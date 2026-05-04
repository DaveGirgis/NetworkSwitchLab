# Session 6 — OSPF Single Area & EIGRP

**Objective:** Configure and verify two dynamic routing protocols on a three-router network — first OSPF in a single area, then EIGRP — observing how each protocol discovers routes, elects neighbors, and reacts to topology information.

---

## What You Will Learn

- How OSPF forms neighbor adjacencies using Hello packets and the router ID
- How to configure OSPF single area (Area 0) using network statements and wildcard masks
- Why `passive-interface` is used on LAN-facing interfaces
- How to read and interpret the OSPF link-state database and routing table
- How EIGRP differs from OSPF — neighbor relationships, metric calculation, and the DUAL algorithm
- How to configure EIGRP and why `no auto-summary` is required
- How to compare routing table entries (`O` vs `D`) and understand what each protocol advertises

---

## Prerequisites

- Session 4 — Static routing (understanding of routing table, next-hop, administrative distance)
- Session 5 — IPv6 static routing (optional but reinforces routing concepts)
- Familiarity with subnetting and wildcard masks

---

## Session Structure

| Part | Title | Description |
|------|-------|-------------|
| Part 0 | Base Config | Hostname, global settings, and interface bringup on all three routers |
| Part 1 | Interface Addressing | Assign IPv4 addresses to all LAN and WAN interfaces; configure PCs |
| Part 2 | OSPF — Configuration | Enable OSPF Area 0, set router IDs, advertise all networks |
| Part 3 | OSPF — Verification | Verify neighbor adjacencies, link-state database, and routing table |
| Part 4 | EIGRP | Remove OSPF, configure EIGRP AS 100, and compare protocol behavior |
| Verification | Final Check | Confirm full end-to-end reachability under EIGRP |
