# Addressing

## Network Summary

| Network | Subnet | Purpose |
|---------|--------|---------|
| `192.168.1.0/24` | R1 LAN | PC-A on R1 site |
| `192.168.2.0/24` | R2 LAN (Loopback) | Simulated R2 site network |
| `192.168.3.0/24` | R3 LAN | PC-A on R3 site |
| `10.0.12.0/30` | R1–R2 WAN link | Point-to-point between R1 and R2 |
| `10.0.23.0/29` | R2–R3 WAN link | Point-to-point between R2 and R3 |

### Addressing Convention

- `192.168.X.0/24` — LAN subnet where X is the router number
- `10.0.XY.0/3X` — WAN subnet where XY identifies the router pair (12 = R1↔R2 uses /30; 23 = R2↔R3 uses /29 so that host `.3` is valid)
- Host portion matches router number: R1 = `.1`, R2 = `.2`, R3 = `.3`
- PCs use `.10` as the host address

---

## Interface Address Table

| Device | Interface | IP Address | Subnet Mask | Role |
|--------|-----------|------------|-------------|------|
| R1 | Fa0/0 | 192.168.1.1 | 255.255.255.0 | R1 LAN gateway |
| R1 | Fa0/1 | 10.0.12.1 | 255.255.255.252 | R1–R2 WAN |
| R2 | Fa0/0 | 10.0.12.2 | 255.255.255.252 | R2 side of R1–R2 WAN |
| R2 | Fa0/1 | 10.0.23.2 | 255.255.255.248 | R2 side of R2–R3 WAN |
| R2 | Loopback0 | 192.168.2.1 | 255.255.255.0 | R2 simulated LAN |
| R3 | Fa0/1 | 10.0.23.3 | 255.255.255.248 | R3 side of R2–R3 WAN |
| R3 | Fa0/0 | 192.168.3.1 | 255.255.255.0 | R3 LAN gateway |

## Host Address Table

| Host | IP Address | Subnet Mask | Default Gateway |
|------|------------|-------------|-----------------|
| R1-PC-A | 192.168.1.10 | 255.255.255.0 | 192.168.1.1 |
| R3-PC-A | 192.168.3.10 | 255.255.255.0 | 192.168.3.1 |

---

## Router ID Table

Router IDs uniquely identify each router in OSPF and EIGRP. Manually setting them prevents the router from choosing a different ID if an interface goes up or down.

| Router | Router ID |
|--------|-----------|
| R1 | 1.1.1.1 |
| R2 | 2.2.2.2 |
| R3 | 3.3.3.3 |

---

## OSPF Network Statements

OSPF uses wildcard masks (the inverse of the subnet mask). A `/24` uses wildcard `0.0.0.255`; a `/30` uses `0.0.0.3`; a `/29` uses `0.0.0.7`.

| Router | Network | Wildcard | Area |
|--------|---------|----------|------|
| R1 | 192.168.1.0 | 0.0.0.255 | 0 |
| R1 | 10.0.12.0 | 0.0.0.3 | 0 |
| R2 | 192.168.2.0 | 0.0.0.255 | 0 |
| R2 | 10.0.12.0 | 0.0.0.3 | 0 |
| R2 | 10.0.23.0 | 0.0.0.7 | 0 |
| R3 | 192.168.3.0 | 0.0.0.255 | 0 |
| R3 | 10.0.23.0 | 0.0.0.7 | 0 |

## EIGRP Network Statements

EIGRP network statements use either a classful network address (no wildcard) or a wildcard mask for precision. Using wildcards is the safer and more explicit approach.

| Router | Network | Wildcard |
|--------|---------|----------|
| R1 | 192.168.1.0 | 0.0.0.255 |
| R1 | 10.0.12.0 | 0.0.0.3 |
| R2 | 192.168.2.0 | 0.0.0.255 |
| R2 | 10.0.12.0 | 0.0.0.3 |
| R2 | 10.0.23.0 | 0.0.0.7 |
| R3 | 192.168.3.0 | 0.0.0.255 |
| R3 | 10.0.23.0 | 0.0.0.7 |
