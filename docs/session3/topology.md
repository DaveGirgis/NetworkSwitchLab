# Topology

## Diagram

``` mermaid
graph TD
    %% Define Nodes
    SW1["🔀 SW1<br/>(Root Bridge)"]
    SW2["🔀 SW2<br/>(Secondary Root)"]

    subgraph Access_Layer [" "]
    direction LR
        SW3["🔀 SW3"]
        SW4["🔀 SW4"]
    end

    PC_A2["💻 SW2-PC-A<br/>VLAN 10 — .20"]
    PC_B2["💻 SW2-PC-B<br/>VLAN 11 — .20"]
    PC_A3["💻 SW3-PC-A<br/>VLAN 10 — .30"]
    PC_B3["💻 SW3-PC-B<br/>VLAN 11 — .30"]
    PC_A4["💻 SW4-PC-A<br/>VLAN 10 — .40"]
    PC_B4["💻 SW4-PC-B<br/>VLAN 11 — .40"]

    %% Switch to Switch Connections
    SW1 -- "Fa1/0 — Fa1/0" --- SW2
    SW1 -- "Fa1/1 — Fa1/0" --- SW3
    SW1 -- "Fa1/2 — Fa1/0" --- SW4
    SW2 -- "Fa1/1 — Fa1/2" --- SW3
    SW2 -- "Fa1/2 — Fa1/1" --- SW4
    SW3 -- "Fa1/1 — Fa1/2" --- SW4

    %% PC Connections
    SW2 -- "Fa1/10" --- PC_A2
    SW2 -- "Fa1/11" --- PC_B2
    SW3 -- "Fa1/10" --- PC_A3
    SW3 -- "Fa1/11" --- PC_B3
    SW4 -- "Fa1/10" --- PC_A4
    SW4 -- "Fa1/11" --- PC_B4

    %% Ranking logic
    SW1 ~~~ SW2
    SW3 ~~~ SW4
```

!!! note "GNS3 Setup"
    Each 3725 requires an **NM-16ESW** module in slot 1. Interfaces appear as `FastEthernet1/0` through `FastEthernet1/15`. Connect all six inter-switch links **before** powering on devices so STP observes the full topology during initial convergence.

---

## Inter-Switch Links

| Link | Switch A | Port | Switch B | Port |
|------|----------|------|----------|------|
| SW1 — SW2 | SW1 | Fa1/0 | SW2 | Fa1/0 |
| SW1 — SW3 | SW1 | Fa1/1 | SW3 | Fa1/0 |
| SW1 — SW4 | SW1 | Fa1/2 | SW4 | Fa1/0 |
| SW2 — SW3 | SW2 | Fa1/1 | SW3 | Fa1/2 |
| SW2 — SW4 | SW2 | Fa1/2 | SW4 | Fa1/1 |
| SW3 — SW4 | SW3 | Fa1/1 | SW4 | Fa1/2 |

---

## Access Port Assignments

| Switch | Port | VLAN | Device | IP Address |
|--------|------|------|--------|------------|
| SW2 | Fa1/10 | 10 | SW2-PC-A | 192.168.10.20 |
| SW2 | Fa1/11 | 11 | SW2-PC-B | 192.168.11.20 |
| SW3 | Fa1/10 | 10 | SW3-PC-A | 192.168.10.30 |
| SW3 | Fa1/11 | 11 | SW3-PC-B | 192.168.11.30 |
| SW4 | Fa1/10 | 10 | SW4-PC-A | 192.168.10.40 |
| SW4 | Fa1/11 | 11 | SW4-PC-B | 192.168.11.40 |
