# Topology

```mermaid
graph LR
    subgraph R1["R1 — Cisco 3725"]
        R1_LAN["Fa0/0\n2001:db8:0:1::1/64\nLAN gateway"]
        R1_WAN["Fa0/1\n2001:db8:0:12::1/64"]
    end

    subgraph R2["R2 — Cisco 3725 (hub)"]
        R2_FA00["Fa0/0\n2001:db8:0:12::2/64"]
        R2_FA01["Fa0/1\n2001:db8:0:23::2/64"]
    end

    subgraph R3["R3 — Cisco 3725"]
        R3_WAN["Fa0/1\n2001:db8:0:23::3/64"]
        R3_LAN["Fa0/0\n2001:db8:0:3::1/64\nLAN gateway"]
    end

    PCA["R1-PC-A\n2001:db8:0:1::10/64"] --> R1_LAN
    R1_WAN <-->|"2001:db8:0:12::/64"| R2_FA00
    R2_FA01 <-->|"2001:db8:0:23::/64"| R3_WAN
    R3_LAN --> PCB["R3-PC-A\n2001:db8:0:3::10/64"]
```

R1 and R3 each serve a local LAN segment via `Fa0/0`. R2 is the hub router connecting both sites via `Fa0/0` (toward R1) and `Fa0/1` (toward R3). No NM-16ESW module is used — PCs connect directly to the router's built-in FastEthernet port.

---

## Link Table

| Link | Device A | Interface A | Device B | Interface B | Type |
|------|----------|-------------|----------|-------------|------|
| 1 | R1 | Fa0/0 | R1-PC-A | NIC | LAN — R1 site |
| 2 | R1 | Fa0/1 | R2 | Fa0/0 | Point-to-point routed link |
| 3 | R2 | Fa0/1 | R3 | Fa0/1 | Point-to-point routed link |
| 4 | R3 | Fa0/0 | R3-PC-A | NIC | LAN — R3 site |

---

## Device Summary

| Device | Role | Interfaces Used |
|--------|------|-----------------|
| R1 | Left spoke router | Fa0/0 — LAN gateway; Fa0/1 — WAN to R2 |
| R2 | Hub router | Fa0/0 — WAN to R1; Fa0/1 — WAN to R3 |
| R3 | Right spoke router | Fa0/0 — LAN gateway; Fa0/1 — WAN to R2 |
| R1-PC-A | IPv6 host on R1 LAN | Simulated with VPCS or loopback |
| R3-PC-A | IPv6 host on R3 LAN | Simulated with VPCS or loopback |
