# Part 4 — EIGRP

**Objective:** Remove OSPF from all three routers, configure EIGRP Autonomous System 100 in its place, verify neighbor relationships and routing tables, and compare EIGRP behavior against what you observed with OSPF.

---

## Task 4.1 — Remove OSPF

Remove the OSPF process from all three routers. This immediately withdraws all OSPF-learned routes from the routing table.

**On R1, R2, and R3:**

```
no router ospf 1
```

Confirm OSPF routes are gone:

```
show ip route
```

Only `C` (connected) and `L` (local) entries should remain. End-to-end pings between PCs will now fail — this is expected.

---

## Task 4.2 — Configure EIGRP on R1

```
router eigrp 100
 eigrp router-id 1.1.1.1
 no auto-summary
 passive-interface FastEthernet0/0
 network 192.168.1.0 0.0.0.255
 network 10.0.12.0 0.0.0.3
```

---

## Task 4.3 — Configure EIGRP on R2

```
router eigrp 100
 eigrp router-id 2.2.2.2
 no auto-summary
 passive-interface Loopback0
 network 192.168.2.0 0.0.0.255
 network 10.0.12.0 0.0.0.3
 network 10.0.23.0 0.0.0.3
```

---

## Task 4.4 — Configure EIGRP on R3

```
router eigrp 100
 eigrp router-id 3.3.3.3
 no auto-summary
 passive-interface FastEthernet0/0
 network 192.168.3.0 0.0.0.255
 network 10.0.23.0 0.0.0.3
```

---

## Understanding the Configuration

### Autonomous System Number

All routers in an EIGRP domain must use the **same AS number** (100 in this lab). Routers with different AS numbers will not form EIGRP neighbor relationships — they will not exchange routes, and no error message is displayed. This is a common misconfiguration that is difficult to spot without checking both routers.

### `no auto-summary`

By default, EIGRP performs classful route summarization at major network boundaries. This means `192.168.1.0/24` would be summarized to `192.168.0.0/16` when crossing a classful boundary — potentially hiding individual subnets. `no auto-summary` disables this behavior and advertises exact prefixes. This is always the correct setting in modern networks.

### Passive Interface

Same purpose as in OSPF — suppress EIGRP Hello packets on interfaces where no EIGRP neighbor will exist. The LAN-facing interfaces (`Fa0/0` on R1 and R3, `Loopback0` on R2) should all be passive.

---

## Task 4.5 — Verify EIGRP Neighbors

```
show ip eigrp neighbors
```

Expected output on R2:

```
EIGRP-IPv4 Neighbors for AS(100)
H   Address         Interface       Hold Uptime   SRTT   RTO  Q  Seq
                                    (sec)         (ms)       Cnt Num
1   10.0.23.3       Fa0/1             13 00:01:12   10   200  0  5
0   10.0.12.1       Fa0/0             11 00:01:15   10   200  0  4
```

Confirm both neighbors appear. Unlike OSPF which shows a `FULL` state, EIGRP neighbors are either present (listed) or absent. If a neighbor is missing, check AS number and `no auto-summary` on both sides.

---

## Task 4.6 — Verify the EIGRP Routing Table

```
show ip route eigrp
```

EIGRP routes appear with the `D` prefix (from DUAL — the Diffusing Update ALgorithm). On R1 you should see:

```
D    192.168.2.0/24 [90/2297856] via 10.0.12.2, FastEthernet0/1
D    192.168.3.0/24 [90/2809856] via 10.0.12.2, FastEthernet0/1
D    10.0.23.0/30   [90/2681856] via 10.0.12.2, FastEthernet0/1
```

The `[90/X]` notation shows EIGRP's administrative distance (90 — lower than OSPF's 110, meaning EIGRP is preferred if both run simultaneously) and the composite metric. EIGRP's metric is calculated from bandwidth and delay by default and produces large numbers compared to OSPF costs.

---

## Task 4.7 — Inspect the EIGRP Topology Table

```
show ip eigrp topology
```

The topology table shows every known path to each destination, not just the best one. For each prefix:

- **Successor** — the best path (installed in the routing table)
- **Feasible Successor** — a backup path that is guaranteed loop-free (if one exists)

In a linear three-router chain, R2's loopback has only one path from R1's perspective so there is no feasible successor. If you had a triangle topology with three WAN links, you would see feasible successors — backup paths that EIGRP can switch to instantly without recalculating.

---

## Task 4.8 — End-to-End Connectivity Test

```
ping 192.168.3.10
ping 192.168.2.1
```

Run from R1-PC-A. Both should succeed. Then repeat from R3-PC-A.

---

## OSPF vs EIGRP Comparison

| Feature | OSPF | EIGRP |
|---------|------|-------|
| Protocol type | Link-state | Advanced distance vector (DUAL) |
| Administrative distance | 110 | 90 |
| Metric | Cost (based on bandwidth) | Composite (bandwidth + delay) |
| Neighbor state | FULL | Present / absent |
| Route code in table | `O` | `D` |
| Convergence mechanism | SPF recalculation | Feasible successor (instant) or DUAL query |
| Topology database | Link-state database (LSDB) | Topology table |
| Vendor support | Open standard (all vendors) | Cisco proprietary (classic); open since 2013 |
| Scales to large networks | Yes (via areas) | Yes (via AS boundaries and stub routing) |

**Discussion:** Given that EIGRP has a lower administrative distance, what would happen if you configured both protocols simultaneously on the same routers? Which routes would appear in the routing table, and why?
