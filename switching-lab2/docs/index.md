# GNS3 Switching Lab

**VLAN Trunking and Inter-VLAN Routing**

---

Welcome to this hands-on switching lab. You will configure VLANs, access ports, a trunk link, and inter-VLAN routing across two Cisco 3725 routers running NM-16ESW switch modules.

## Quick start

1. Open your GNS3 project with the two 3725 nodes linked on `f1/15`
2. Start both devices and open console connections
3. Work through Tasks 1–4 in order
4. Complete the Verification checklist before finishing

## Lab at a glance

| Item | Detail |
|---|---|
| Platform | GNS3 |
| Device | Cisco 3725 + NM-16ESW (slot 1) |
| VLANs | 10, 11 |
| Gateway | R1 — 192.168.10.1 / 192.168.11.1 |
| Trunk port | f1/15 (both switches) |
| Estimated time | 45–60 minutes |

## Objectives

- [x] Create VLANs 10 and 11 on both switches
- [x] Assign access ports — f1/0 (VLAN 10), f1/1 (VLAN 11)
- [x] Configure f1/15 as an 802.1Q trunk between SW1 and SW2
- [x] Configure inter-VLAN routing on R1 using subinterfaces
- [x] Verify end-to-end connectivity across VLANs

!!! tip "Save your work"
    Run `copy running-config startup-config` after completing each task.
