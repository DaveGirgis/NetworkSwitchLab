# Session 7 — ACLs and NAT

**Objective:** Configure and verify Access Control Lists (ACLs) as traffic filters and Network Address Translation (NAT) as a connectivity mechanism, using a simulated customer-edge router with a public WAN address.

---

## What You Will Learn

- The three types of Cisco ACLs — standard, extended, and named — and when to use each
- How ACL rules are processed and why the implicit `deny any` matters
- How to apply a standard ACL to VTY lines to restrict management access
- How NAT overload (PAT) translates multiple private addresses to a single public IP
- Why private (RFC1918) source addresses fail without NAT translation in place
- How to use an extended ACL to selectively filter traffic by protocol and destination

---

## Prerequisites

- Session 4 — Static routing (routing table, next-hop, default route)
- Session 2 — NM-16ESW switching basics (VLAN creation, access ports, SVIs)
- Familiarity with subnetting and the difference between RFC1918 and public address space

---

## Session Structure

| Part | Title | Description |
|------|-------|-------------|
| Part 0 | Base Config | Hostname and global settings on R1 and R2 |
| Part 1 | LAN & Interface Addressing | VLAN 10, access ports, SVI gateway, WAN interfaces, PC configuration, and default route |
| Part 2 | ACL Fundamentals | ACL type overview; standard ACL restricting VTY access; standard ACL permit list for NAT |
| Part 3 | NAT Overload | Configure PAT on R1; demonstrate PC-A success and PC-B failure; expand permit list to include PC-B |
| Part 4 | Extended ACLs | Named extended ACL blocking ICMP echo-replies to PC-B; observe selective filtering |
| Verification | Final Check | Confirm NAT translations, ACL hit counts, and per-host ICMP behavior |
