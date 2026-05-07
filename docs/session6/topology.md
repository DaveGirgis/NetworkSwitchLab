# Topology

```mermaid
graph LR
    subgraph R1["R1 — Cisco 3725\nRouter ID: 1.1.1.1"]
        R1_LAN["Fa0/0\n192.168.1.1/24\nLAN gateway"]
        R1_WAN["Fa0/1\n10.0.12.1/30"]
    end

    subgraph R2["R2 — Cisco 3725\nRouter ID: 2.2.2.2"]
        R2_WAN1["Fa0/0\n10.0.12.2/30"]
        R2_LO["Lo0\n192.168.2.1/24\nSimulated LAN"]
        R2_WAN2["Fa0/1\n10.0.23.2/29"]
    end

    subgraph R3["R3 — Cisco 3725\nRouter ID: 3.3.3.3"]
        R3_WAN["Fa0/1\n10.0.23.3/29"]
        R3_LAN["Fa0/0\n192.168.3.1/24\nLAN gateway"]
    end

    PCA["R1-PC-A\n192.168.1.10/24"] --> R1_LAN
    R1_WAN <-->|"10.0.12.0/30"| R2_WAN1
    R2_WAN2 <-->|"10.0.23.0/29"| R3_WAN
    R3_LAN --> PCB["R3-PC-A\n192.168.3.10/24"]
```

R1 and R3 each serve a local LAN segment via `Fa0/0`, with PCs connecting directly to the router interface. R2 is the transit router — it has no physical LAN; instead, a `Loopback0` interface simulates a connected network that OSPF and EIGRP will advertise. The R1–R2 WAN link uses a `/30` subnet; the R2–R3 WAN link uses a `/29` subnet so that `.2` (R2) and `.3` (R3) are both valid host addresses.

---

## Link Table

| Link | Device A | Interface A | Device B | Interface B | Subnet |
|------|----------|-------------|----------|-------------|--------|
| 1 | R1 | Fa0/0 | R1-PC-A | NIC | 192.168.1.0/24 |
| 2 | R1 | Fa0/1 | R2 | Fa0/0 | 10.0.12.0/30 |
| 3 | R2 | Fa0/1 | R3 | Fa0/1 | 10.0.23.0/29 |
| 4 | R3 | Fa0/0 | R3-PC-A | NIC | 192.168.3.0/24 |

---

## Device Summary

| Device | Role | Interfaces Used |
|--------|------|-----------------|
| R1 | Left router | Fa0/0 — LAN gateway; Fa0/1 — WAN to R2 |
| R2 | Transit router | Fa0/0 — WAN to R1; Fa0/1 — WAN to R3; Lo0 — simulated LAN |
| R3 | Right router | Fa0/0 — LAN gateway; Fa0/1 — WAN to R2 |
| R1-PC-A | End host on R1 LAN | Simulated with VPCS or loopback |
| R3-PC-A | End host on R3 LAN | Simulated with VPCS or loopback |
