# Part 4 — Extended ACLs

**Objective:** Create a named extended ACL that blocks ICMP echo-replies destined for PC-B, apply it in the correct direction on the correct interface, and verify that PC-A is unaffected while PC-B's pings time out.

---

## Understanding Extended ACLs

Standard ACLs match only the source IP address. Extended ACLs match on any combination of:

- Source IP address (and optional wildcard)
- Destination IP address (and optional wildcard)
- Protocol (`ip`, `tcp`, `udp`, `icmp`, and others)
- Port numbers (for TCP and UDP)
- ICMP message type (for ICMP — such as `echo`, `echo-reply`, `unreachable`)

This precision makes extended ACLs the right tool whenever you need to filter on what kind of traffic is going where, not just where it came from.

---

## Task 4.1 — ACL Placement Decision

Before writing the ACL, determine where to apply it.

**Why not inbound on `Fa0/1` (outside interface)?**

When a packet arrives inbound on `Fa0/1`, NAT has not yet un-translated the destination. The packet's destination address is still `203.0.113.1` — R1's public IP. There is no way for an ACL at this point to distinguish between a reply going to PC-A and a reply going to PC-B; both appear destined for the same address.

**Why outbound on `Vlan10` (inside SVI)?**

After inbound processing on `Fa0/1`, NAT restores the original destination: `192.168.10.20` for PC-B and `192.168.10.10` for PC-A. An outbound ACL on `Vlan10` is evaluated at this point, where the distinction between the two hosts is visible. The ACL can then precisely deny traffic destined only for PC-B.

> [!NOTE]
> This is a common exam topic: ACL evaluation order relative to NAT. On an inside-to-outside flow, the outbound ACL on the outside interface fires **after** NAT translation. On an outside-to-inside flow, the inbound ACL on the inside interface fires **after** NAT un-translation. The general rule: ACLs on inside interfaces see inside (private) addresses; ACLs on outside interfaces see outside (public) addresses.

---

## Task 4.2 — Create the Named Extended ACL

```
ip access-list extended BLOCK-ICMP-REPLY
 deny icmp any host 192.168.10.20 echo-reply
 permit ip any any
```

**Line breakdown:**

- `deny icmp` — match ICMP protocol
- `any` — match any source address (the reply could come from anywhere)
- `host 192.168.10.20` — match this specific destination (PC-B)
- `echo-reply` — match only ICMP type 0 (echo-reply); echo requests from PC-B are still allowed out
- `permit ip any any` — explicitly permit all other traffic (replaces the implicit deny for everything else)

---

## Task 4.3 — Apply the ACL Outbound on Vlan10

```
interface Vlan10
 ip access-group BLOCK-ICMP-REPLY out
```

---

## Task 4.4 — Verify Selective Behavior

**PC-A ping — expect success:**

From PC-A:
```
ping 198.51.100.1
```

PC-A's echo-replies are destined for `192.168.10.10`. The deny rule targets `host 192.168.10.20`, so PC-A's traffic matches only the `permit ip any any` line and passes through.

**PC-B ping — expect timeout:**

From PC-B:
```
ping 198.51.100.1
```

PC-B's echo-reply packets are destined for `192.168.10.20` and match the deny rule. They are dropped before reaching PC-B. PC-B's pings time out, though PC-B's echo requests do leave R1 successfully (the ACL only blocks the replies coming back).

**Check the ACL hit counts:**

```
show ip access-lists BLOCK-ICMP-REPLY
```

Expected output after pinging from both hosts:

```
Extended IP access list BLOCK-ICMP-REPLY
    10 deny icmp any host 192.168.10.20 echo-reply (5 matches)
    20 permit ip any any (10 matches)
```

The deny counter increments with each echo-reply that was dropped for PC-B. The permit counter shows all other traffic that passed — including PC-A's replies and PC-B's outbound echo requests.
