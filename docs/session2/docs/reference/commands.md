# Command Reference

Quick reference for NM-16ESW and IOS router commands used in this lab.

---

## VLAN commands

| Command | Purpose |
|---|---|
| `vlan database` | Enter VLAN database mode (required on NM-16ESW) |
| `vlan 10 name VLAN10` | Create VLAN with a name |
| `no vlan 10` | Delete a VLAN |
| `show vlan-switch brief` | Display VLAN table (NM-16ESW specific) |

## Switchport commands

| Command | Purpose |
|---|---|
| `switchport mode access` | Set port to access mode |
| `switchport access vlan 10` | Assign access port to VLAN |
| `switchport mode trunk` | Set port to trunk mode |
| `switchport trunk encapsulation dot1q` | Set 802.1Q encapsulation (required before trunk mode) |
| `switchport trunk allowed vlan 10,11` | Restrict VLANs carried on the trunk |
| `show interfaces f1/0 switchport` | Verify access/trunk mode and VLAN assignment |
| `show interfaces f1/15 trunk` | Verify trunk status and allowed VLANs |

## Router / SVI commands

| Command | Purpose |
|---|---|
| `interface Vlan10` | Create or enter SVI for VLAN 10 |
| `ip address 192.168.10.1 255.255.255.0` | Assign gateway IP to SVI |
| `ip routing` | Enable Layer 3 routing |
| `show ip route` | Verify routing table |
| `show interfaces Vlan10` | Verify SVI status |

## General

| Command | Purpose |
|---|---|
| `no ip domain-lookup` | Prevent DNS lookup on typos |
| `copy running-config startup-config` | Save configuration |
| `show running-config` | View full running configuration |
| `show version` | Confirm IOS version and hardware |
