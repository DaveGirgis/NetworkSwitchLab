# Network Topology

## Diagram

```
  PC1 (VLAN 10) ──── f1/0 ┐                        ┌ f1/0 ──── PC3 (VLAN 10)
                           │   R1 / SW1             │
  PC2 (VLAN 11) ──── f1/1 ┤   (3725+NM-16ESW)      ├ f1/1 ──── PC4 (VLAN 11)
                           │                        │
                      f0/0 │  f1/15 ══ trunk ══ f1/15  SW2
                      (GW) │                        │   (3725+NM-16ESW)
               192.168.10.1│
               192.168.11.1│
```

## Device roles

| Device | Role | Notes |
|---|---|---|
| R1 | Layer 3 gateway + SW1 | SVIs on Vlan10 and Vlan11 provide inter-VLAN routing |
| SW2 | Layer 2 switch | Trunk and access ports only — no routing |
| PC1, PC3 | VLAN 10 hosts | Gateway: 192.168.10.1 |
| PC2, PC4 | VLAN 11 hosts | Gateway: 192.168.11.1 |

## Link summary

| Link | Interface (R1/SW1) | Interface (SW2) | Type |
|---|---|---|---|
| Trunk | f1/15 | f1/15 | 802.1Q trunk — VLANs 10, 11 |
| PC1 access | f1/0 | — | Access — VLAN 10 |
| PC2 access | f1/1 | — | Access — VLAN 11 |
| PC3 access | — | f1/0 | Access — VLAN 10 |
| PC4 access | — | f1/1 | Access — VLAN 11 |
| Gateway | f0/0 | — | Routed subinterfaces |

!!! tip "GNS3 setup"
    Connect the two 3725 nodes using their `f1/15` interfaces before starting the lab. The PCs can be VPCS nodes or any host with a static IP configured.
