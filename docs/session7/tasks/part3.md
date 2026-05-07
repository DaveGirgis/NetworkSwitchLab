# Part 3 — NAT Overload

**Objective:** Configure PAT (NAT overload) on R1 to translate inside RFC1918 addresses to R1's public WAN IP. Observe that PC-A (in the permit list) can reach the internet while PC-B (not yet in the permit list) cannot, then expand the ACL to include PC-B and verify both hosts succeed.

---

## Understanding NAT Overload

NAT overload (also called PAT — Port Address Translation) allows many inside hosts to share a single outside IP address. Each translation uses a unique source port number to distinguish sessions, so multiple hosts can communicate with the same destination simultaneously. The inside host's private address is hidden from the outside network.

**Key terms:**

| Term | Meaning | Example |
|------|---------|---------|
| Inside local | Private address of the inside host | 192.168.10.10 |
| Inside global | Public address the host appears as | 203.0.113.1:12345 |
| Outside global | Address of the remote server | 198.51.100.1 |

---

## Task 3.1 — Mark Interfaces Inside and Outside

NAT requires IOS to know which interface boundary separates the inside (private) network from the outside (public) network. Mark both interfaces on R1:

```
interface Vlan10
 ip nat inside
interface FastEthernet0/1
 ip nat outside
```

---

## Task 3.2 — Configure PAT Using ACL 1

Reference ACL 1 (built in Part 2) as the source selector. The `overload` keyword enables PAT.

```
ip nat inside source list 1 interface FastEthernet0/1 overload
```

This statement means: for any packet arriving on a NAT inside interface whose source IP is permitted by ACL 1, translate the source to the address of `FastEthernet0/1` (`203.0.113.1`), multiplexed by port number.

---

## Task 3.3 — Test PC-A (Expect: Success)

From PC-A:

```
ping 198.51.100.1
```

PC-A's source address (`192.168.10.10`) matches `access-list 1 permit host 192.168.10.10`. R1 translates it to `203.0.113.1` before forwarding to R2. R2 sees the packet sourced from `203.0.113.1`, which it knows how to reach (connected route), so the echo-reply returns successfully.

Inspect the NAT translation table on R1:

```
show ip nat translations
```

Expected output (port numbers will vary):

```
Pro Inside global      Inside local       Outside local      Outside global
icmp 203.0.113.1:1     192.168.10.10:1    198.51.100.1:1     198.51.100.1:1
```

---

## Task 3.4 — Test PC-B (Expect: Failure)

From PC-B:

```
ping 198.51.100.1
```

The ping should time out. Inspect the NAT translation table again:

```
show ip nat translations
```

There will be no entry for `192.168.10.20`. PC-B's source address does not match ACL 1, so R1 forwards the packet without translation. R2 receives a packet sourced from `192.168.10.20` — a private address for which it has no return route. The echo-reply is never sent, and PC-B receives only timeouts.

> [!NOTE]
> This is the correct behavior for an ISP router. RFC1918 addresses are unroutable on the public internet — any packet arriving at an upstream router with a private source is either dropped silently or rejected. NAT is the standard mechanism that hides these addresses behind a routable public IP.

---

## Task 3.5 — Expand ACL 1 to Include PC-B

Add PC-B's address to the NAT permit list:

```
access-list 1 permit host 192.168.10.20
```

Clear existing NAT translations so the table starts fresh:

```
clear ip nat translation *
```

From PC-B:

```
ping 198.51.100.1
```

The ping should now succeed. Verify both hosts are visible in the translation table:

```
show ip nat translations
```

Expected output:

```
Pro Inside global      Inside local       Outside local      Outside global
icmp 203.0.113.1:1     192.168.10.10:1    198.51.100.1:1     198.51.100.1:1
icmp 203.0.113.1:2     192.168.10.20:1    198.51.100.1:1     198.51.100.1:1
```

Both hosts now have translations and can reach the simulated internet server.

---

## Task 3.6 — View NAT Statistics

```
show ip nat statistics
```

Note the total active translations and the hit/miss counts. A "miss" indicates a packet that did not match any inside source entry (such as PC-B's initial pings before it was added to ACL 1).
