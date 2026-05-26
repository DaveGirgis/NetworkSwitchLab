# Addressing

## Network Summary

| Network | Subnet | Purpose |
|---------|--------|---------|
| `172.16.10.0/24` | R1 VLAN 10 — Sales | Left-site Sales hosts (PC-A, PC-B) |
| `172.16.20.0/24` | R1 VLAN 20 — Management | Left-site Management host (PC-C) |
| `10.1.12.0/30` | R1–R2 WAN link | Point-to-point between left site and hub |
| `10.1.23.0/30` | R2–R3 WAN link | Point-to-point between hub and right site |
| `172.16.30.0/24` | R3 VLAN 30 — Sales | Right-site Sales host (PC-D) |
| `172.16.40.0/24` | R3 VLAN 40 — Management | Right-site Management host (PC-E) |

---

## VLAN Assignment

| VLAN | Name | Subnet | Gateway SVI | Router |
|------|------|--------|-------------|--------|
| 10 | SALES | 172.16.10.0/24 | 172.16.10.1 (Vlan10 on R1) | R1 |
| 20 | MGMT | 172.16.20.0/24 | 172.16.20.1 (Vlan20 on R1) | R1 |
| 30 | SALES | 172.16.30.0/24 | 172.16.30.1 (Vlan30 on R3) | R3 |
| 40 | MGMT | 172.16.40.0/24 | 172.16.40.1 (Vlan40 on R3) | R3 |

---

## Interface Address Table

| Device | Interface | IP Address | Subnet Mask | Role |
|--------|-----------|------------|-------------|------|
| R1 | Vlan10 (SVI) | 172.16.10.1 | 255.255.255.0 | Left-site VLAN 10 gateway |
| R1 | Vlan20 (SVI) | 172.16.20.1 | 255.255.255.0 | Left-site VLAN 20 gateway |
| R1 | Fa0/1 | 10.1.12.1 | 255.255.255.252 | WAN — R1 to R2 |
| R2 | Fa0/0 | 10.1.12.2 | 255.255.255.252 | WAN — R2 to R1 |
| R2 | Fa0/1 | 10.1.23.1 | 255.255.255.252 | WAN — R2 to R3 |
| R3 | Fa0/0 | 10.1.23.2 | 255.255.255.252 | WAN — R3 to R2 |
| R3 | Vlan30 (SVI) | 172.16.30.1 | 255.255.255.0 | Right-site VLAN 30 gateway |
| R3 | Vlan40 (SVI) | 172.16.40.1 | 255.255.255.0 | Right-site VLAN 40 gateway |

---

## Host Address Table

| Host | IP Address | Subnet Mask | Default Gateway | VLAN | Port on Router |
|------|------------|-------------|-----------------|------|----------------|
| PC-A | 172.16.10.10 | 255.255.255.0 | 172.16.10.1 | 10 | R1 Fa1/10 |
| PC-B | 172.16.10.20 | 255.255.255.0 | 172.16.10.1 | 10 | R1 Fa1/11 |
| PC-C | 172.16.20.10 | 255.255.255.0 | 172.16.20.1 | 20 | R1 Fa1/12 |
| PC-D | 172.16.30.10 | 255.255.255.0 | 172.16.30.1 | 30 | R3 Fa1/3 |
| PC-E | 172.16.40.10 | 255.255.255.0 | 172.16.40.1 | 40 | R3 Fa1/4 |

---

## Routing

All three routers run OSPF process 1, area 0. All connected networks are advertised — there are no static routes or default routes in the baseline design.

| Router | OSPF Networks Advertised |
|--------|--------------------------|
| R1 | 172.16.10.0/24, 172.16.20.0/24, 10.1.12.0/30 |
| R2 | 10.1.12.0/30, 10.1.23.0/30 |
| R3 | 172.16.30.0/24, 172.16.40.0/24, 10.1.23.0/30 |

---

## ACL Reference

One ACL is present in the baseline configuration. It exists on R2 and controls cross-site traffic.

| ACL | Type | Purpose | Applied to |
|-----|------|---------|------------|
| CROSS-SITE | Named extended | Controls traffic from left-site subnets destined for right-site subnets | `interface Fa0/1` — `ip access-group CROSS-SITE out` |
