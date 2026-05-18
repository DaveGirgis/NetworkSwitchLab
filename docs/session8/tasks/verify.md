# Verification

Use the following checklist to confirm all three faults have been resolved and the network has reached its intended final state.

---

## Checklist

| # | Check | Command | Expected Result |
|---|-------|---------|-----------------|
| 1 | All VLANs active on R1 | `show vlan-switch brief` on R1 | VLANs 10 and 20 active; correct ports assigned |
| 2 | All VLANs active on R3 | `show vlan-switch brief` on R3 | VLANs 30 and 40 active; correct ports assigned |
| 3 | R1 SVIs and WAN interface up | `show ip interface brief` on R1 | Vlan10, Vlan20, and Fa0/1 all up/up with correct IPs |
| 4 | R3 SVIs and WAN interface up | `show ip interface brief` on R3 | Vlan30, Vlan40, and Fa0/0 all up/up with correct IPs |
| 5 | OSPF neighbors formed on R2 | `show ip ospf neighbor` on R2 | Two neighbors — R1 and R3 — both in FULL state |
| 6 | All subnets in R1 routing table | `show ip route ospf` on R1 | Routes to 172.16.30.0/24, 172.16.40.0/24, 10.1.23.0/30 via OSPF |
| 7 | All subnets in R3 routing table | `show ip route ospf` on R3 | Routes to 172.16.10.0/24, 172.16.20.0/24, 10.1.12.0/30 via OSPF |
| 8 | ACL permits all site traffic | `show ip access-lists CROSS-SITE` on R2 | Permit statements cover all left-site and right-site subnets |
| 9 | PC-A reaches PC-D | `ping 172.16.30.10` from PC-A | 5/5 success |
| 10 | PC-A reaches PC-E | `ping 172.16.40.10` from PC-A | 5/5 success |
| 11 | PC-C reaches PC-D | `ping 172.16.30.10` from PC-C | 5/5 success |
| 12 | PC-C reaches PC-E | `ping 172.16.40.10` from PC-C | 5/5 success |
| 13 | PC-D reaches PC-A | `ping 172.16.10.10` from PC-D | 5/5 success |
| 14 | PC-E reaches PC-C | `ping 172.16.20.10` from PC-E | 5/5 success |

---

## Final Connectivity Summary

When all faults are resolved, every host at the left site can reach every host at the right site and vice versa. The full cross-site ping matrix:

```
! From PC-A (172.16.10.10)
ping 172.16.20.10    ! PC-C  - success (same site, different VLAN)
ping 172.16.30.10    ! PC-D  - success (cross-site)
ping 172.16.40.10    ! PC-E  - success (cross-site)

! From PC-D (172.16.30.10)
ping 172.16.40.10    ! PC-E  - success (same site, different VLAN)
ping 172.16.10.10    ! PC-A  - success (cross-site)
ping 172.16.20.10    ! PC-C  - success (cross-site)
```
