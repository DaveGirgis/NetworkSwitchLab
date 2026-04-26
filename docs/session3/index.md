# Session 3: Spanning Tree Protocol — Root Election & PVST+

## Overview

| | |
|---|---|
| **Session** | 3 of 8 |
| **Duration** | ~2.5 hours |
| **Platform** | GNS3 with Cisco 3725 + NM-16ESW |
| **Difficulty** | Intermediate |

This lab expands the two-switch topology from Session 1 into a four-switch partial mesh. Students will observe STP elect a root bridge naturally, then take control of root bridge placement using bridge priority manipulation. The session concludes with Per-VLAN Spanning Tree (PVST+) load balancing using the VLAN 10 and VLAN 11 networks established in the previous session.

---

## Learning Objectives

By the end of this session, students will be able to:

- Explain the STP root bridge election process (bridge ID, priority, MAC address)
- Identify root ports, designated ports, and blocked ports on a live topology
- Manipulate root bridge placement using `spanning-tree priority`
- Configure a secondary root bridge for redundancy
- Implement PVST+ to load-balance traffic across redundant links per VLAN
- Enable PortFast and BPDU Guard on access ports

---

## Session Structure

| Part | Topic |
|------|-------|
| [Part 0](tasks/part0.md) | Base Configuration |
| [Part 1](tasks/part1.md) | Observe Natural Root Bridge Election |
| [Part 2](tasks/part2.md) | Control Root Bridge Placement |
| [Part 3](tasks/part3.md) | PVST+ Load Balancing |
| [Part 4](tasks/part4.md) | PortFast and BPDU Guard |
| [Verification](tasks/verify.md) | Final Verification & Checklist |

---

*Session 3 of 8 — Next: Session 4: Static Routing & Route Summarization*
