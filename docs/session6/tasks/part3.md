# Part 3 — OSPF Verification

**Objective:** Confirm OSPF neighbor adjacencies are fully established, inspect the link-state database, verify the routing table, and test end-to-end connectivity before moving to EIGRP.

---

## Task 3.1 — Verify OSPF Neighbors

Run on each router:

```
show ip ospf neighbor
```

Expected output on R2 (the transit router):

```
Neighbor ID     Pri   State           Dead Time   Address         Interface
1.1.1.1           1   FULL/DR         00:00:35    10.0.12.1       FastEthernet0/0
3.3.3.3           1   FULL/DR         00:00:38    10.0.23.3       FastEthernet0/1
```

Confirm:
- Both neighbors show state `FULL` — anything less means the adjacency is not complete
- Neighbor IDs match the manually configured router IDs (`1.1.1.1`, `2.2.2.2`, `3.3.3.3`)

> [!NOTE]
> On a point-to-point `/30` link, OSPF still runs DR/BDR election but it is irrelevant — with only two routers, one becomes DR and the other BDR, and both reach FULL state. On a real broadcast segment (like a switch), the DR/BDR election matters for scalability.

---

## Task 3.2 — Inspect the Link-State Database

```
show ip ospf database
```

The output lists all Link State Advertisements (LSAs) in the area. Each router in Area 0 floods its Router LSA describing its directly connected links. With three routers and five networks, you should see three Router LSA entries — one per router ID.

```
show ip ospf database router
```

Examine one entry and note how it describes each link type (stub network, transit network) and the associated cost.

---

## Task 3.3 — Verify the Routing Table

```
show ip route ospf
```

On R1, you should see OSPF routes (`O`) to:
- `192.168.2.0/24` (R2's loopback LAN) via `10.0.12.2`
- `192.168.3.0/24` (R3's LAN) via `10.0.12.2`
- `10.0.23.0/29` (R2–R3 WAN link) via `10.0.12.2`

The `[110/X]` notation shows OSPF's administrative distance (110) and metric (cost). The cost is calculated from the cumulative bandwidth of outgoing interfaces — lower bandwidth = higher cost.

---

## Task 3.4 — End-to-End Connectivity Test

From R1-PC-A, ping both remote destinations:

```
ping 192.168.2.1
ping 192.168.3.10
```

From R3-PC-A, ping back:

```
ping 192.168.2.1
ping 192.168.1.10
```

All four pings should succeed. OSPF has distributed the routing information needed for full reachability across all three LAN segments.

---

## Task 3.5 — View OSPF Process Detail

```
show ip ospf
```

Note the following fields:
- **Routing Process ID** — the local process number (1)
- **Router ID** — confirm it matches the manually configured value
- **Area** — confirms single area (Area 0) operation
- **SPF algorithm** — shows how many times the shortest path tree has been recalculated

```
show ip ospf interface FastEthernet0/1
```

Shows Hello and Dead intervals (default 10s / 40s on Ethernet), DR/BDR status, and the cost assigned to this interface. Record the cost — you will compare it to EIGRP's metric in Part 4.

---

## Task 3.6 — Simulate a Link Failure (Optional)

On R2, shut down `Fa0/0`:

```
interface FastEthernet0/0
 shutdown
```

Watch the console on R1 for the Dead interval timeout (~40 seconds) and the OSPF adjacency drop message. Then verify R1's routing table — the routes via R2 should disappear. Bring the interface back up and watch OSPF reconverge:

```
interface FastEthernet0/0
 no shutdown
```

OSPF convergence (neighbor re-formation + SPF recalculation) typically completes within 45–60 seconds using default timers. This behavior — automatic recovery without manual intervention — is the core advantage of dynamic routing protocols over the static routes in Session 4.
