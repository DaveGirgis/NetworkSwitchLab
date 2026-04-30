# Part 3 — Default Route & Route Summarization

**Objective:** Configure a default route on R1 to simulate an upstream gateway, then add loopback interfaces representing additional networks and summarize them into a single route advertisement.

---

## Task 3.1 — Add Loopback Interfaces on R2

Loopback interfaces are logical, always-up interfaces used to simulate stub networks. Add four loopbacks on R2 to represent additional networks reachable beyond R2.

```
interface Loopback0
 ip address 10.0.0.1 255.255.255.0
interface Loopback1
 ip address 10.0.1.1 255.255.255.0
interface Loopback2
 ip address 10.0.2.1 255.255.255.0
interface Loopback3
 ip address 10.0.3.1 255.255.255.0
```

These networks (10.0.0.0/24 through 10.0.3.0/24) are now directly connected on R2. R1 does not yet know about them.

---

## Task 3.2 — Configure a Default Route on R1

A default route matches any destination not covered by a more specific entry in the routing table. It is the gateway of last resort — used when the router has no better information.

The network `0.0.0.0` with mask `0.0.0.0` matches everything:

```
ip route 0.0.0.0 0.0.0.0 172.16.31.2
```

Verify it appears in the routing table:

```
show ip route
```

The default route appears as `S*` — static, and flagged as the gateway of last resort. The line at the top of the routing table output will show:

```
Gateway of last resort is 172.16.31.2 to network 0.0.0.0
```

---

## Task 3.3 — Add Static Routes for the Loopback Networks on R1

With a default route in place, R1 will forward unknown traffic toward R2. But for R2 to send return traffic back, R2 still needs explicit routes to R1's networks — and R1 needs routes to the loopbacks if you want to test reachability specifically.

Add individual static routes on R1 for each loopback network:

```
ip route 10.0.0.0 255.255.255.0 172.16.31.2
ip route 10.0.1.0 255.255.255.0 172.16.31.2
ip route 10.0.2.0 255.255.255.0 172.16.31.2
ip route 10.0.3.0 255.255.255.0 172.16.31.2
```

Verify you can ping each loopback from R1:

```
ping 10.0.0.1
ping 10.0.1.1
ping 10.0.2.1
ping 10.0.3.1
```

---

## Task 3.4 — Calculate the Summary Route

Before replacing the four specific routes with a single summary, you need to calculate the correct summary prefix. Complete the table below.

Write each network address in binary, identify the common bit boundary, and determine the summary network and prefix length.

| Network | Binary (Third Octet) |
|---------|----------------------|
| 10.0.**0**.0 | |
| 10.0.**1**.0 | |
| 10.0.**2**.0 | |
| 10.0.**3**.0 | |

| Field | Value |
|-------|-------|
| Common bits in third octet | |
| Summary network address | |
| Summary prefix length | |
| Summary subnet mask | |

> [!TIP]
> The first two octets (10.0) are identical across all four networks. The variation is in the third octet. Find the highest bit position where all four values agree — that is your summary boundary.

---

## Task 3.5 — Replace Specific Routes with the Summary

Remove the four individual routes and replace them with a single summary route. The `no` form of `ip route` removes an existing entry.

```
no ip route 10.0.0.0 255.255.255.0 172.16.31.2
no ip route 10.0.1.0 255.255.255.0 172.16.31.2
no ip route 10.0.2.0 255.255.255.0 172.16.31.2
no ip route 10.0.3.0 255.255.255.0 172.16.31.2
```

Add the summary route using the values you calculated in Task 3.4:

```
ip route 10.0.0.0 255.255.252.0 172.16.31.2
```

Verify the routing table:

```
show ip route
```

The four specific `S` entries should be gone. A single `S` entry for `10.0.0.0/22` should replace them.

---

## Task 3.6 — Confirm Reachability is Preserved

Summarization should not break reachability — it should only change how the routing table represents the path. Verify the loopback networks are still reachable from R1.

```
ping 10.0.0.1
ping 10.0.1.1
ping 10.0.2.1
ping 10.0.3.1
```

All four pings should still succeed.

> [!WARNING]
> A summary route covers all addresses in its range — including subnets that do not exist. If you summarize 10.0.0.0/22, your router will also forward traffic for 10.0.0.0 through 10.0.3.255 toward R2, even if some of those subnets are not configured. This is expected behavior in this lab but is a real design consideration in production networks.
