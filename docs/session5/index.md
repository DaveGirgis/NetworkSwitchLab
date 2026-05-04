# Session 5 — IPv6 Addressing & Static Routing

**Objective:** Configure global unicast IPv6 addresses on three routers, establish LAN reachability on R1 and R3, then build a fully connected network using IPv6 static routes and a default route.

---

## What You Will Learn

- How IPv6 addresses are structured and written in compressed notation
- The difference between global unicast and link-local addresses
- Why `ipv6 unicast-routing` must be enabled before a Cisco router will forward IPv6 packets
- How to assign IPv6 addresses to router interfaces
- How to configure IPv6 static routes and a default route using `ipv6 route`
- How to verify IPv6 connectivity using `show ipv6 interface`, `show ipv6 route`, and `ping`

---

## Prerequisites

- Session 1 — VLANs and trunking on NM-16ESW
- Session 2 — Inter-VLAN routing
- Session 4 — Static routing concepts (IPv4 version of this session's routing tasks)
- Familiarity with binary and hexadecimal notation

---

## Session Structure

| Part | Title | Description |
|------|-------|-------------|
| Part 0 | Base Config | Hostname, global settings, enable IPv6 forwarding, and interface bringup on all three routers |
| Part 1 | LAN Interfaces | Assign IPv6 addresses to R1 and R3 LAN interfaces and configure PCs |
| Part 2 | WAN Links | Configure point-to-point IPv6 addresses on the R1-R2 and R2-R3 links |
| Part 3 | Static Routes | Add default routes on R1 and R3, and specific static routes on R2 |
| Verification | Final Check | Confirm full end-to-end IPv6 reachability across all three routers |
