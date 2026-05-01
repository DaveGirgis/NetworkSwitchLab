# Part 2 — Static Routes

**Objective:** Configure the point-to-point link between R1 and R2, then add static routes so that hosts on VLAN 10 and VLAN 11 can reach each other across the routed link.

---

## Task 2.1 — Configure the Point-to-Point Link

Using the `/30` subnet you selected from the addressing table, assign IP addresses to `Fa0/1` on R1 and R2. The examples below use subnet 1 (`172.16.31.0/30`) — substitute your assigned subnet.

**On R1:**

```
interface FastEthernet0/1
 ip address 172.16.31.1 255.255.255.252
 no shutdown
```

**On R2:**

```
interface FastEthernet0/1
 ip address 172.16.31.2 255.255.255.252
 no shutdown
```

Verify the link is up and both routers can reach each other across it:

```
show interfaces FastEthernet0/1
```

Then ping from R1 to R2's `Fa0/1` address (and vice versa) before adding routes.

---

## Task 2.2 — Examine the Routing Table

Before adding any static routes, look at what each router already knows.

```
show ip route
```

Each router will show:

- A `C` (connected) entry for its own `/30` link subnet
- A `C` entry for each SVI network (192.168.10.0/24 on R1, 192.168.11.0/24 on R2)

Neither router knows about the other's LAN. That is what static routes will fix.

---

## Task 2.3 — Add a Static Route on R1

R1 needs to know how to reach the VLAN 11 network (192.168.11.0/24) on the other side of R2. The next hop is R2's `Fa0/1` address.

The syntax for a static route is:

```
ip route [destination-network] [subnet-mask] [next-hop-ip]
```

On R1:

```
ip route 192.168.11.0 255.255.255.0 172.16.31.2
```

Substitute `172.16.31.2` with the actual Host 2 address from your selected /30 subnet if different.

---

## Task 2.4 — Add a Static Route on R2

R2 needs to know how to reach the VLAN 10 network (192.168.10.0/24) on the other side of R1.

On R2:

```
ip route 192.168.10.0 255.255.255.0 172.16.31.1
```

Substitute `172.16.31.1` with the actual Host 1 address from your selected /30 subnet if different.

---

## Task 2.5 — Verify the Routing Tables

After adding routes, check the routing table on each router.

```
show ip route
```

You should now see an `S` (static) entry on each router pointing to the remote LAN. The administrative distance for a static route is 1 — it will appear as `[1/0]` in the routing table.

---

## Task 2.6 — End-to-End Connectivity Test

From R1-PC-A, ping R2-PC-A:

```
ping 192.168.11.10
```

From R2-PC-A, ping R1-PC-A:

```
ping 192.168.10.10
```

Both pings should succeed. If either fails, work through the troubleshooting guide before continuing.

> [!NOTE]
> A successful ping from a router itself does not confirm that hosts can reach each other — the source address matters. Ping from the PC (or from the router using the `source` keyword to specify the SVI address, e.g. `source Vlan10`) to validate the full path.
