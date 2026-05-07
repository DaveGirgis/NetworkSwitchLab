# Addressing

## Network Summary

| Network | Subnet | Purpose |
|---------|--------|---------|
| `192.168.10.0/24` | R1 LAN — VLAN 10 | RFC1918 inside network for PC-A and PC-B |
| `203.0.113.0/30` | R1–R2 WAN link | Non-RFC1918 simulated public WAN (TEST-NET-3) |
| `198.51.100.1/32` | R2 Loopback | Simulated internet server destination (TEST-NET-2) |

---

## VLAN Assignment

| VLAN | Name | Subnet | Gateway SVI |
|------|------|--------|-------------|
| 10 | CLIENTS | 192.168.10.0/24 | 192.168.10.1 (Vlan10 on R1) |

---

## Interface Address Table

| Device | Interface | IP Address | Subnet Mask | Role |
|--------|-----------|------------|-------------|------|
| R1 | Vlan10 (SVI) | 192.168.10.1 | 255.255.255.0 | LAN gateway — NAT inside |
| R1 | Fa0/1 | 203.0.113.1 | 255.255.255.252 | WAN — NAT outside |
| R2 | Fa0/0 | 203.0.113.2 | 255.255.255.252 | ISP-facing WAN |
| R2 | Loopback0 | 198.51.100.1 | 255.255.255.255 | Simulated internet server |

---

## Host Address Table

| Host | IP Address | Subnet Mask | Default Gateway | Port on R1 |
|------|------------|-------------|-----------------|------------|
| PC-A | 192.168.10.10 | 255.255.255.0 | 192.168.10.1 | Fa1/0 |
| PC-B | 192.168.10.20 | 255.255.255.0 | 192.168.10.1 | Fa1/1 |

---

## Routing

| Router | Route | Next-hop | Purpose |
|--------|-------|----------|---------|
| R1 | 0.0.0.0/0 | 203.0.113.2 | Default route — all non-local traffic forwarded to R2 |
| R2 | — | — | No route to 192.168.10.0/24 (intentional — simulates real ISP behavior) |

---

## ACL Summary

| ACL | Type | Purpose | Applied to |
|-----|------|---------|------------|
| 10 | Standard numbered | Permit VTY access from R2 only | `line vty 0 4` — `access-class 10 in` |
| 1 | Standard numbered | NAT permit list — controls which inside hosts are translated | Referenced by `ip nat inside source list 1` |
| BLOCK-ICMP-REPLY | Named extended | Block ICMP echo-replies destined for PC-B | `interface Vlan10` — `ip access-group BLOCK-ICMP-REPLY out` |

---

## NAT Overload Configuration Reference

| Parameter | Value |
|-----------|-------|
| Inside interface | Vlan10 |
| Outside interface | Fa0/1 |
| Translation type | Overload (PAT) |
| Inside global address | 203.0.113.1 (Fa0/1 address) |
| NAT permit ACL | access-list 1 |
