# Part 3 — Static Routes

**Objective:** Configure default routes on R1 and R3 pointing toward R2, then add specific static routes on R2 for each LAN segment, achieving full end-to-end IPv6 reachability.

---

## Task 3.1 — Add a Default Route on R1

R1 has a single exit point — its `Fa0/1` link to R2. A default route sends all traffic for unknown destinations toward R2.

The IPv6 default route prefix is `::/0` — all zeros, prefix length zero, matching everything.

```
ipv6 route ::/0 2001:db8:0:12::2
```

Verify it appears in the routing table:

```
show ipv6 route
```

The default route appears as `S ::/0` with the next hop shown. The `S` indicates a static route.

---

## Task 3.2 — Add a Default Route on R3

R3's only exit is toward R2 via `Fa0/1`.

```
ipv6 route ::/0 2001:db8:0:23::2
```

Verify:

```
show ipv6 route
```

---

## Task 3.3 — Add Static Routes on R2

R2 is the hub. It needs an explicit route to each spoke's LAN — it cannot use a default route because it has two possible destinations and must choose the correct one for each.

**Route to R1's LAN:**

```
ipv6 route 2001:db8:0:1::/64 2001:db8:0:12::1
```

**Route to R3's LAN:**

```
ipv6 route 2001:db8:0:3::/64 2001:db8:0:23::3
```

> [!NOTE]
> R2 does not need a default route in this lab — it has directly connected routes to both WAN links and specific static routes to both LANs. Adding a default route to R2 would cause a routing loop: if R2 received a packet for an unknown destination, it would forward it to R1 or R3, which would then forward it back to R2.

---

## Task 3.4 — Verify All Routing Tables

**On R1** — should show: connected LAN (`0:1::/64`), connected WAN (`0:12::/64`), and default (`S ::/0`):

```
show ipv6 route
```

**On R2** — should show: both WAN links connected and two static `S` entries:

```
show ipv6 route static
```

**On R3** — should show: connected LAN (`0:3::/64`), connected WAN (`0:23::/64`), and default (`S ::/0`):

```
show ipv6 route
```

---

## Task 3.5 — End-to-End Connectivity Test

From R1-PC-A, ping R3-PC-A:

```
ping 2001:db8:0:3::10
```

From R3-PC-A, ping R1-PC-A:

```
ping 2001:db8:0:1::10
```

Both pings must succeed. The traffic path for R1-PC-A → R3-PC-A is:

```
R1-PC-A → R1 Fa0/0 → R1 Fa0/1 → R2 Fa0/0 → R2 Fa0/1 → R3 Fa0/1 → R3 Fa0/0 → R3-PC-A
```

Return traffic follows the reverse path using the same static routes.

---

## Discussion Questions

**1. Why does R2 use specific routes while R1 and R3 use defaults?**
R1 and R3 are stub routers — they each have one exit point (toward R2), so a default route is the correct and most efficient choice. R2 has two possible destinations (R1's LAN and R3's LAN) and must make a deliberate routing decision for each. A default on R2 would mean forwarding all unknown traffic in one direction, which would cause routing loops or black holes.

**2. What happens if you accidentally configure a default route on R2?**
Test it: add `ipv6 route ::/0 2001:db8:0:12::1` on R2 and then ping from R3-PC-A to R1-PC-A. Watch what happens to TTL. Remove the incorrect route when done: `no ipv6 route ::/0 2001:db8:0:12::1`.

**3. How would this design change if a fourth router (R4) was added as another spoke off R2?**
R2 would need a third specific static route to R4's LAN. R4 would need a default route pointing to R2. R1 and R3 would not need any changes — their default routes already forward all unknown traffic toward R2, which would handle the new path.
