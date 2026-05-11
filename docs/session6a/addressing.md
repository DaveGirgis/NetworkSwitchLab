# Addressing

## Network Summary

| Network | Subnet | Purpose |
|---------|--------|---------|
| `192.168.1.0/24` | R1 LAN | PC-A on R1 site — advertised by R1 into BGP |
| `192.168.2.0/24` | R2 LAN (Loopback) | Simulated R2 site network — advertised by R2 into BGP |
| `192.168.3.0/24` | R3 LAN | PC-A on R3 site — advertised by R3 into BGP |
| `10.0.12.0/30` | R1–R2 WAN link | Point-to-point; used for eBGP peering session |
| `10.0.23.0/29` | R2–R3 WAN link | Point-to-point; used for eBGP peering session |

### Addressing Convention

- `192.168.X.0/24` — LAN subnet where X is the router number
- `10.0.XY.0/3X` — WAN subnet where XY identifies the router pair (12 = R1–R2 uses /30; 23 = R2–R3 uses /29 so that host `.3` is valid)
- Host portion matches router number: R1 = `.1`, R2 = `.2`, R3 = `.3`
- PCs use `.10` as the host address

---

## Interface Address Table

| Device | Interface | IP Address | Subnet Mask | Role |
|--------|-----------|------------|-------------|------|
| R1 | Fa0/0 | 192.168.1.1 | 255.255.255.0 | R1 LAN gateway |
| R1 | Fa0/1 | 10.0.12.1 | 255.255.255.252 | R1–R2 WAN (eBGP peer link) |
| R2 | Fa0/0 | 10.0.12.2 | 255.255.255.252 | R2 side of R1–R2 WAN |
| R2 | Fa0/1 | 10.0.23.2 | 255.255.255.248 | R2 side of R2–R3 WAN |
| R2 | Loopback0 | 192.168.2.1 | 255.255.255.0 | R2 simulated LAN |
| R3 | Fa0/1 | 10.0.23.3 | 255.255.255.248 | R3 side of R2–R3 WAN (eBGP peer link) |
| R3 | Fa0/0 | 192.168.3.1 | 255.255.255.0 | R3 LAN gateway |

## Host Address Table

| Host | IP Address | Subnet Mask | Default Gateway |
|------|------------|-------------|-----------------|
| R1-PC-A | 192.168.1.10 | 255.255.255.0 | 192.168.1.1 |
| R3-PC-A | 192.168.3.10 | 255.255.255.0 | 192.168.3.1 |

---

## BGP Autonomous System Table

| Router | AS Number | BGP Router ID | Neighbors |
|--------|-----------|---------------|-----------|
| R1 | 65001 | 1.1.1.1 | 10.0.12.2 (R2, AS 65002) |
| R2 | 65002 | 2.2.2.2 | 10.0.12.1 (R1, AS 65001); 10.0.23.3 (R3, AS 65003) |
| R3 | 65003 | 3.3.3.3 | 10.0.23.2 (R2, AS 65002) |

AS numbers in the range `64512–65535` are private (similar to RFC 1918 private IP addresses). They are used for internal labs and non-internet-connected networks. In production, internet-facing BGP sessions use globally unique AS numbers assigned by IANA.

---

## BGP Network Advertisements

Unlike OSPF and EIGRP, BGP does not automatically discover and advertise connected interfaces. Each router explicitly declares which prefixes it will inject into BGP using the `network` command. The prefix must already exist in the routing table — typically as a connected route.

| Router | Prefix Advertised | Mask | Source |
|--------|-------------------|------|--------|
| R1 | 192.168.1.0 | 255.255.255.0 | Connected — Fa0/0 |
| R2 | 192.168.2.0 | 255.255.255.0 | Connected — Loopback0 |
| R3 | 192.168.3.0 | 255.255.255.0 | Connected — Fa0/0 |

> [!NOTE]
> The WAN subnets (10.0.12.0/30 and 10.0.23.0/29) are **not** advertised into BGP. They serve only as transport for the BGP TCP sessions. This is normal practice — BGP is used to advertise networks you own, not the transit infrastructure links themselves.
