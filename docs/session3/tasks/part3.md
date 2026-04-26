# Part 3 — PVST+ Load Balancing

**Objective:** Use Per-VLAN Spanning Tree to assign different root bridges to VLAN 10 and VLAN 11, activating links that would otherwise remain blocked under a single spanning tree instance.

---

## Task 3.1 — Configure PVST+ Root Bridges

```cisco
! On SW1 — Primary root for VLAN 10, secondary for VLAN 11
configure terminal
spanning-tree vlan 10 priority 0
spanning-tree vlan 11 priority 4096
end
write memory
```

```cisco
! On SW2 — Primary root for VLAN 11, secondary for VLAN 10
configure terminal
spanning-tree vlan 10 priority 4096
spanning-tree vlan 11 priority 0
end
write memory
```

SW3 and SW4 remain at default priority 32768 for both VLANs — no changes needed.

---

## Task 3.2 — Verify Per-VLAN Topologies

Run on each switch:

```cisco
show spanning-tree vlan 10
show spanning-tree vlan 11
```

Confirm:

- SW1 shows `This bridge is the root` for VLAN 10
- SW2 shows `This bridge is the root` for VLAN 11
- The blocked ports **differ** between VLAN 10 and VLAN 11

Draw two topology diagrams side by side — one per VLAN — and compare which links are active in each.

---

## Task 3.3 — Test Reachability Across Both VLANs

Configure all PC-A devices with VLAN 10 addresses and all PC-B devices with VLAN 11 addresses per the addressing table.

```cisco
! From SW2-PC-A (192.168.10.20) — VLAN 10 path through SW1 as root
ping 192.168.10.30   ! to SW3-PC-A
ping 192.168.10.40   ! to SW4-PC-A
ping 192.168.10.1    ! to SW1 SVI

! From SW2-PC-B (192.168.11.20) — VLAN 11 path through SW2 as root
ping 192.168.11.30   ! to SW3-PC-B
ping 192.168.11.40   ! to SW4-PC-B
ping 192.168.11.1    ! to SW1 SVI
```

All pings should succeed. VLAN 10 and VLAN 11 traffic follow different physical paths through the mesh.

---

## Task 3.4 — View the Full PVST+ Summary

```cisco
show spanning-tree summary
```

Confirm VLAN 10 and VLAN 11 are both listed with their respective root bridge assignments and port counts.

**Discussion questions:**

- A link blocked in VLAN 10 may be forwarding in VLAN 11. What does this mean for physical link utilization?
- How would you extend this design if you had 10 VLANs and wanted to spread load across 4 uplinks?
- What is the operational cost of running many independent PVST+ instances on a large campus network?
