# Verification

Use the following checklist to confirm the session is complete. All items must pass before the session is considered done.

---

## Checklist

| # | Phase | Check | Command | Expected Result |
|---|-------|-------|---------|-----------------|
| 1 | Addressing | All interfaces up and addressed | `show ip interface brief` | Fa0/0, Fa0/1 (and Lo0 on R2) all up/up with correct IPs |
| 2 | Addressing | R1–R2 WAN link reachable | `ping 10.0.12.2` from R1 | 5/5 replies |
| 3 | Addressing | R2–R3 WAN link reachable | `ping 10.0.23.3` from R2 | 5/5 replies |
| 4 | BGP | R1 BGP session with R2 established | `show ip bgp summary` on R1 | 10.0.12.2 shows a prefix count, not a state word |
| 5 | BGP | R3 BGP session with R2 established | `show ip bgp summary` on R3 | 10.0.23.2 shows a prefix count, not a state word |
| 6 | BGP | R2 has two BGP neighbors established | `show ip bgp summary` on R2 | 10.0.12.1 and 10.0.23.3 both show prefix counts |
| 7 | BGP | R1 BGP table has all three prefixes | `show ip bgp` on R1 | `*>` entries for 192.168.1.0, 192.168.2.0, 192.168.3.0 |
| 8 | BGP | R1 routing table has BGP routes | `show ip route bgp` on R1 | `B` entries for 192.168.2.0/24 and 192.168.3.0/24 |
| 9 | BGP | AS-PATH is correct on R1 | `show ip bgp 192.168.3.0` on R1 | AS-PATH shows `65002 65003` |
| 10 | Reachability | R1-PC-A pings R2 loopback | `ping 192.168.2.1` from R1-PC-A | All replies received |
| 11 | Reachability | R1-PC-A pings R3-PC-A | `ping 192.168.3.10` from R1-PC-A | All replies received |
| 12 | Reachability | R3-PC-A pings R1-PC-A | `ping 192.168.1.10` from R3-PC-A | All replies received |

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

All six pings should succeed. The complete path for R1-PC-A to R3-PC-A is:

```
R1-PC-A --> R1 Fa0/0 --> R1 Fa0/1 --> R2 Fa0/0 --> R2 Fa0/1 --> R3 Fa0/1 --> R3 Fa0/0 --> R3-PC-A
```

BGP has distributed the routing information needed for full reachability by exchanging Update messages across two separate eBGP sessions — one between AS 65001 and AS 65002, and one between AS 65002 and AS 65003.
