# Session 4 — Static Routing & Route Summarization

**Objective:** Configure static routes and a default route to establish end-to-end reachability between two LAN segments, then summarize multiple routes into a single prefix.

---

## What You Will Learn

- How to read and interpret the IP routing table
- How to configure static routes using next-hop and exit-interface syntax
- How to configure a default route as a gateway of last resort
- How to calculate and apply a summary route to reduce routing table size

---

## Prerequisites

- Session 1 — VLANs and trunking on NM-16ESW
- Session 2 — Router-on-a-stick inter-VLAN routing
- Familiarity with binary subnetting and CIDR notation

---

## Session Structure

| Part | Title | Description |
|------|-------|-------------|
| Part 0 | Base Config | Hostname, global settings, and interface bringup on R1 and R2 |
| Part 1 | LAN Configuration | VLAN creation, trunk port, and router-on-a-stick subinterfaces on each router |
| Part 2 | Static Routes | Configure static routes so VLAN 10 and VLAN 11 hosts can reach each other |
| Part 3 | Default Route & Summarization | Add a gateway of last resort and consolidate loopback networks into a summary route |
| Verification | Final Check | Confirm full end-to-end reachability and a clean routing table |
