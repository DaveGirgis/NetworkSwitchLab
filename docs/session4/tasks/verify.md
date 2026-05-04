# Verification

Use the following checklist to confirm the session is complete. Every item must pass before the session is considered done.

---

## Checklist

| # | Check | Command | Expected Result |
|---|-------|---------|-----------------|
| 1 | VLAN 10 exists on R1 | `show vlan-switch brief` | VLAN 10 (SALES) shown as active |
| 2 | VLAN 11 exists on R2 | `show vlan-switch brief` | VLAN 11 (ENGINEERING) shown as active |
| 3 | SVI Vlan10 is up on R1 | `show interfaces Vlan10` | Line protocol is up, IP address 192.168.10.1 assigned |
| 4 | SVI Vlan11 is up on R2 | `show interfaces Vlan11` | Line protocol is up, IP address 192.168.11.1 assigned |
| 5 | VLAN 10 access port active on R1 | `show vlan-switch brief` | Fa1/10 listed under VLAN 10 as active |
| 6 | VLAN 11 access port active on R2 | `show vlan-switch brief` | Fa1/11 listed under VLAN 11 as active |
| 7 | Point-to-point link is up | `show interfaces Fa0/1` | Line protocol is up on both R1 and R2 |
| 8 | R1 routing table has static route to VLAN 11 | `show ip route` | S entry for 192.168.11.0/24 via /30 next-hop |
| 9 | R2 routing table has static route to VLAN 10 | `show ip route` | S entry for 192.168.10.0/24 via /30 next-hop |
| 10 | Default route present on R1 | `show ip route` | S* 0.0.0.0/0 shown; gateway of last resort set |
| 11 | Summary route present on R1 | `show ip route` | Single S entry for 10.0.0.0/22 — no individual /24 entries |
| 12 | Loopbacks reachable from R1 | `ping 10.0.x.1` (x = 0–3) | All four pings succeed |

---

## Connectivity Test

From R1-PC-A (`192.168.10.10`), ping R2-PC-A (`192.168.11.10`). This tests the complete path: VLAN 10 host → R1 SVI (Vlan10) → static route → /30 link → R2 SVI (Vlan11) → VLAN 11 host. Both directions must succeed.

From R1-PC-A, also ping `10.0.3.1` (the highest loopback on R2). A successful ping confirms the summary route is functioning correctly and that the default route on R1 is not masking a misconfiguration in the specific route entries.
