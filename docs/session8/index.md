# Session 8 — Capstone Troubleshooting Lab

**Objective:** Import a pre-configured GNS3 project with three injected faults and restore full network connectivity by identifying and correcting each fault independently.

---

## What You Will Learn

- How to approach a broken network methodically without being told which layer failed
- How to use Cisco IOS `show` commands to isolate a fault to a specific device and configuration line
- Why faults at different layers produce similar symptoms and how to distinguish them
- How to confirm a fix is correct before moving on to the next fault

---

## Prerequisites

- Session 2 — VLANs, NM-16ESW, access ports, SVIs
- Session 3 — Spanning Tree fundamentals (port states, VLAN membership)
- Session 4 — Static routing concepts and SVI operation
- Session 6 — OSPF neighbor formation and route advertisement
- Session 7 — ACL structure, permit/deny logic, interface application

---

## Lab Format

This session does not follow a build-from-scratch format. The GNS3 project is provided as a zip file with all devices pre-configured — including three deliberate faults. Your job is to find and fix each one.

No hints are given about which layer, which device, or which command is relevant. Use the topology and addressing tables in this session as your reference for what the network *should* look like.

---

## Session Structure

| Part | Title | Description |
|------|-------|-------------|
| Part 0 | Project Import | Download and import the GNS3 project; confirm lab loads |
| Part 1 | Fault 1 | Isolate and fix the first reported issue |
| Part 2 | Fault 2 | Isolate and fix the second reported issue |
| Part 3 | Fault 3 | Isolate and fix the third reported issue |
| Verification | Final Check | Confirm full mesh connectivity across all sites |
