# Topology

```mermaid
graph LR
    subgraph R1["R1 — Cisco 3725 (Left Site)"]
        R1_NM["NM-16ESW\nFa1/10 - PC-A, VLAN 10\nFa1/11 - PC-B, VLAN 10\nFa1/12 - PC-C, VLAN 20"]
        R1_V10["SVI Vlan10\n172.16.10.1/24"]
        R1_V20["SVI Vlan20\n172.16.20.1/24"]
        R1_WAN["Fa0/1\n10.1.12.1/30"]
        R1_NM --> R1_V10
        R1_NM --> R1_V20
    end

    subgraph R2["R2 — Cisco 3725 (Hub)"]
        R2_L["Fa0/0\n10.1.12.2/30"]
        R2_R["Fa0/1\n10.1.23.1/30"]
    end

    subgraph R3["R3 — Cisco 3725 (Right Site)"]
        R3_NM["NM-16ESW\nFa1/3 - PC-D, VLAN 30\nFa1/4 - PC-E, VLAN 40"]
        R3_V30["SVI Vlan30\n172.16.30.1/24"]
        R3_V40["SVI Vlan40\n172.16.40.1/24"]
        R3_WAN["Fa0/0\n10.1.23.2/30"]
        R3_NM --> R3_V30
        R3_NM --> R3_V40
    end

    PCA["PC-A\n172.16.10.10/24"] --> R1_NM
    PCB["PC-B\n172.16.10.20/24"] --> R1_NM
    PCC["PC-C\n172.16.20.10/24"] --> R1_NM
    R1_WAN <-->|"10.1.12.0/30"| R2_L
    R2_R <-->|"10.1.23.0/30"| R3_WAN
    PCD["PC-D\n172.16.30.10/24"] --> R3_NM
    PCE["PC-E\n172.16.40.10/24"] --> R3_NM
```

R1 serves the left site with two VLANs — VLAN 10 (Sales, two hosts) and VLAN 20 (Management, one host). R3 mirrors this structure on the right site with VLAN 30 (Sales) and VLAN 40 (Management). R2 is a pure Layer 3 hub with no switching module; it connects the two sites over /30 WAN links and runs OSPF with both neighbors. All three routers participate in OSPF area 0.

---

## Link Table

| Link | Device A | Interface A | Device B | Interface B | Subnet |
|------|----------|-------------|----------|-------------|--------|
| 1 | R1 | Fa1/10 | PC-A | NIC | 172.16.10.0/24 (VLAN 10) |
| 2 | R1 | Fa1/11 | PC-B | NIC | 172.16.10.0/24 (VLAN 10) |
| 3 | R1 | Fa1/12 | PC-C | NIC | 172.16.20.0/24 (VLAN 20) |
| 4 | R1 | Fa0/1 | R2 | Fa0/0 | 10.1.12.0/30 |
| 5 | R2 | Fa0/1 | R3 | Fa0/0 | 10.1.23.0/30 |
| 6 | R3 | Fa1/3 | PC-D | NIC | 172.16.30.0/24 (VLAN 30) |
| 7 | R3 | Fa1/4 | PC-E | NIC | 172.16.40.0/24 (VLAN 40) |

> [!NOTE]
> R1 and R3 use SVIs for inter-VLAN routing — there is no trunk link between the NM-16ESW and the router chassis. The SVI (`interface Vlan10`, etc.) binds directly to the VLAN on the switching module. No subinterfaces or router-on-a-stick configuration is used.

---

## Device Summary

| Device | Role | Interfaces Used |
|--------|------|-----------------|
| R1 | Left-site router — VLAN 10 and VLAN 20 | Fa1/10, Fa1/11 (VLAN 10 access); Fa1/12 (VLAN 20 access); Fa0/1 (WAN to R2) |
| R2 | Hub router — OSPF, ACL enforcement | Fa0/0 (WAN to R1); Fa0/1 (WAN to R3) |
| R3 | Right-site router — VLAN 30 and VLAN 40 | Fa1/3 (VLAN 30 access); Fa1/4 (VLAN 40 access); Fa0/0 (WAN to R2) |
| PC-A | Left-site Sales host | VPCS on R1 Fa1/10 |
| PC-B | Left-site Sales host | VPCS on R1 Fa1/11 |
| PC-C | Left-site Management host | VPCS on R1 Fa1/12 |
| PC-D | Right-site Sales host | VPCS on R3 Fa1/3 |
| PC-E | Right-site Management host | VPCS on R3 Fa1/4 |
