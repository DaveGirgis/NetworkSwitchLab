# Addressing

## VLAN 10 — 192.168.10.0/24

| Device | IP Address | Default Gateway |
|--------|------------|-----------------|
| SW1 SVI (VLAN 10) | 192.168.10.1 | — |
| SW2-PC-A | 192.168.10.20 | 192.168.10.1 |
| SW3-PC-A | 192.168.10.30 | 192.168.10.1 |
| SW4-PC-A | 192.168.10.40 | 192.168.10.1 |

## VLAN 11 — 192.168.11.0/24

| Device | IP Address | Default Gateway |
|--------|------------|-----------------|
| SW1 SVI (VLAN 11) | 192.168.11.1 | — |
| SW2-PC-B | 192.168.11.20 | 192.168.11.1 |
| SW3-PC-B | 192.168.11.30 | 192.168.11.1 |
| SW4-PC-B | 192.168.11.40 | 192.168.11.1 |

!!! info "Management Access"
    Only SW1 has SVIs configured. SW2, SW3, and SW4 have no Layer 3 addressing — they are pure Layer 2 switches for this lab. All pings and reachability tests originate from the attached PCs or from SW1.
