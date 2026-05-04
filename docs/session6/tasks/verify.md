# Verification

Use the following checklist to confirm the session is complete. Items 1–7 cover the OSPF phase; items 8–12 cover the EIGRP phase. All items must pass before the session is considered done.

---

## Checklist

| # | Phase | Check | Command | Expected Result |
|---|-------|-------|---------|-----------------|
| 1 | Both | All interfaces up and addressed | `show ip interface brief` | Fa0/0, Fa0/1 (and Lo0 on R2) all up/up with correct IPs |
| 2 | OSPF | R1 has OSPF neighbor with R2 | `show ip ospf neighbor` on R1 | R2 (2.2.2.2) shown in FULL state |
| 3 | OSPF | R3 has OSPF neighbor with R2 | `show ip ospf neighbor` on R3 | R2 (2.2.2.2) shown in FULL state |
| 4 | OSPF | R2 has two OSPF neighbors | `show ip ospf neighbor` on R2 | R1 (1.1.1.1) and R3 (3.3.3.3) both FULL |
| 5 | OSPF | R1 routing table has OSPF routes | `show ip route ospf` on R1 | O entries for 192.168.2.0/24, 192.168.3.0/24, 10.0.23.0/30 |
| 6 | OSPF | R1-PC-A pings R3-PC-A | `ping 192.168.3.10` from R1-PC-A | All replies received |
| 7 | OSPF | R1-PC-A pings R2 loopback | `ping 192.168.2.1` from R1-PC-A | All replies received |
| 8 | EIGRP | OSPF removed from all routers | `show ip route` | No `O` entries on any router |
| 9 | EIGRP | R1 has EIGRP neighbor with R2 | `show ip eigrp neighbors` on R1 | 10.0.12.2 listed |
| 10 | EIGRP | R3 has EIGRP neighbor with R2 | `show ip eigrp neighbors` on R3 | 10.0.23.2 listed |
| 11 | EIGRP | R1 routing table has EIGRP routes | `show ip route eigrp` on R1 | D entries for 192.168.2.0/24, 192.168.3.0/24, 10.0.23.0/30 |
| 12 | EIGRP | R1-PC-A pings R3-PC-A | `ping 192.168.3.10` from R1-PC-A | All replies received |

---

## Final Connectivity Test

From R1-PC-A (`192.168.1.10`), ping all remote addresses:

```
ping 192.168.2.1    ! R2 loopback
ping 192.168.3.1    ! R3 LAN gateway
ping 192.168.3.10   ! R3-PC-A
```

From R3-PC-A (`192.168.3.10`), repeat in the other direction:

```
ping 192.168.2.1
ping 192.168.1.1
ping 192.168.1.10
```

All six pings should succeed under EIGRP. The complete path for R1-PC-A to R3-PC-A is:

```
R1-PC-A → R1 Fa0/0 → R1 Fa0/1 → R2 Fa0/0 → R2 Fa0/1 → R3 Fa0/1 → R3 Fa0/0 → R3-PC-A
```
