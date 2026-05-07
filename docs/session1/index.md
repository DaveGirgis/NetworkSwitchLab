# Session 1: Simulation Platform Introduction

## Overview

| | |
|---|---|
| **Session** | 1 of 8 |
| **Duration** | ~1 hour |
| **Platform** | GNS3 2.2+ on Windows |
| **Difficulty** | Beginner |

GNS3 (Graphical Network Simulator-3) is a free, open-source network simulation platform that lets you design, build, and test network topologies on your desktop without any physical hardware. This series uses GNS3 to emulate Cisco 3725 routers — the same IOS image runs in GNS3's Dynamips engine, producing real Cisco command-line behavior.

This session walks through installing GNS3, understanding its architecture, importing a Cisco IOS image, building a minimal topology, and verifying that your environment is ready for the labs that follow.

---

## Learning Objectives

By the end of this session, students will be able to:

- Explain the relationship between the GNS3 GUI, the local compute engine, and the optional GNS3 VM
- Identify which device types can run locally on Windows and which require the GNS3 VM
- Import a Cisco 3725 IOS image and configure a reusable router template with NM-16ESW
- Add Cisco 3725 and VPCS nodes to a GNS3 project
- Connect devices using Ethernet links and label interfaces on the canvas
- Start all devices, open console sessions, and confirm end-to-end reachability with VPCS ping

---

## Session Structure

| Part | Topic |
|------|-------|
| [Part 0](tasks/part0.md) | Installation & Architecture |
| [Part 1](tasks/part1.md) | Adding Devices to a Project |
| [Part 2](tasks/part2.md) | Connecting Devices |
| [Part 3](tasks/part3.md) | Starting Devices & Console Access |
| [Verification](tasks/verify.md) | Final Verification & Checklist |

---

*Session 1 of 8 — Next: [Session 2: Switching Fundamentals](../session2/index.md)*
