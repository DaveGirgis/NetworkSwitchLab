# Session 6a — BGP (eBGP)

**Objective:** Configure and verify External BGP (eBGP) across a three-router network, observing how BGP establishes TCP-based sessions, exchanges reachability information, and propagates routes across autonomous system boundaries.

---

## What You Will Learn

- How BGP differs from OSPF and EIGRP — TCP-based sessions, manual neighbor declaration, and policy-driven route selection
- What an Autonomous System (AS) is and why BGP uses AS numbers
- How to configure eBGP neighbor relationships using `neighbor` statements
- How BGP advertises networks using the `network` command and why the prefix must already exist in the routing table
- How to read the BGP table (`show ip bgp`) and interpret AS-PATH, Next Hop, and the best-path marker
- Why BGP convergence is slower than IGPs and why that is intentional
- How to verify end-to-end reachability across multiple autonomous systems

---

## Prerequisites

- Session 4 — Static routing (routing table, next-hop, administrative distance)
- Session 6 — OSPF and EIGRP (neighbor concepts, protocol comparison)
- Basic understanding of subnetting and TCP/IP

---

## Session Structure

| Part | Title | Description |
|------|-------|-------------|
| Part 0 | Base Config | Hostname and global settings on all three routers |
| Part 1 | Interface Addressing | Assign IPv4 addresses to all interfaces; configure PCs |
| Part 2 | BGP Configuration | Enable eBGP, declare neighbors, advertise networks |
| Part 3 | BGP Verification | Verify neighbor sessions, BGP table, routing table, and end-to-end reachability |
| Verification | Final Check | Master checklist confirming full BGP operation |
