# Part 2 — WAN Links

**Objective:** Configure IPv6 addresses on the point-to-point links between R1-R2 and R2-R3, verify both links are up, and examine the routing table before adding static routes.

---

## Task 2.1 — Configure the R1 WAN Interface

R1's `Fa0/1` connects to R2's `Fa0/0`. This link uses the `2001:db8:0:12::/64` subnet — the third hextet `12` identifies this as the R1-to-R2 link.

```
interface FastEthernet0/1
 ipv6 address 2001:db8:0:12::1/64
 no shutdown
```

---

## Task 2.2 — Configure R2's Interfaces

R2 is the hub router. Its `Fa0/0` faces R1 and its `Fa0/1` faces R3.

```
interface FastEthernet0/0
 ipv6 address 2001:db8:0:12::2/64
 no shutdown
interface FastEthernet0/1
 ipv6 address 2001:db8:0:23::2/64
 no shutdown
```

Note how R2 holds address `::2` on both WAN subnets — the last hextet always matches the router number.

---

## Task 2.3 — Configure the R3 WAN Interface

R3's `Fa0/1` connects to R2's `Fa0/1`. This link uses the `2001:db8:0:23::/64` subnet.

```
interface FastEthernet0/1
 ipv6 address 2001:db8:0:23::3/64
 no shutdown
```

---

## Task 2.4 — Verify WAN Links

Check all interfaces are up on each router:

```
show ipv6 interface brief
```

Expected output on R2:

```
FastEthernet0/0            [up/up]
    FE80::...
    2001:DB8:0:12::2
FastEthernet0/1            [up/up]
    FE80::...
    2001:DB8:0:23::2
```

Then ping across each WAN link to confirm layer 3 reachability:

**From R1:**

```
ping 2001:db8:0:12::2
```

**From R3:**

```
ping 2001:db8:0:23::2
```

Both pings should succeed. If a ping fails, verify the GNS3 cable connects the correct interfaces and that both sides have `no shutdown` and matching subnet addresses.

---

## Task 2.5 — Examine the Routing Table Before Adding Routes

Before configuring static routes, look at what each router knows automatically.

```
show ipv6 route
```

Each router will show only `C` (connected) and `L` (local) entries — one for each configured interface. R1 knows about `2001:db8:0:1::/64` and `2001:db8:0:12::/64` but has no knowledge of R3's LAN (`2001:db8:0:3::/64`). R3 is in the same position. R2 knows both WAN subnets but neither LAN. Static routes in Part 3 will fix this.

> [!NOTE]
> The `L` (local) entries represent the router's own interface addresses as /128 host routes. This is an IPv6 feature with no direct IPv4 equivalent — the router installs a host route for each of its own addresses so it can receive packets destined directly to itself.
