# Address Table

## IP addressing

| Device | Interface | IP Address | Subnet Mask | VLAN | Role |
|---|---|---|---|---|---|
| R1 | Vlan10 (SVI) | 192.168.10.1 | 255.255.255.0 | 10 | VLAN 10 gateway |
| R1 | Vlan11 (SVI) | 192.168.11.1 | 255.255.255.0 | 11 | VLAN 11 gateway |
| PC1 | eth0 | 192.168.10.10 | 255.255.255.0 | 10 | Host |
| PC2 | eth0 | 192.168.11.10 | 255.255.255.0 | 11 | Host |
| PC3 | eth0 | 192.168.10.20 | 255.255.255.0 | 10 | Host |
| PC4 | eth0 | 192.168.11.20 | 255.255.255.0 | 11 | Host |

## Port assignments

| Device | Port | Mode | VLAN |
|---|---|---|---|
| R1 / SW1 | f1/0 | Access | 10 |
| R1 / SW1 | f1/1 | Access | 11 |
| R1 / SW1 | f1/15 | Trunk | 10, 11 |
| SW2 | f1/0 | Access | 10 |
| SW2 | f1/1 | Access | 11 |
| SW2 | f1/15 | Trunk | 10, 11 |

!!! note
    PC IP addresses above are suggestions. You may use any addresses in the 192.168.10.0/24 and 192.168.11.0/24 ranges as long as the gateway is set to the R1 subinterface address for that VLAN.
