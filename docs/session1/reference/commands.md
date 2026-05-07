# Command Reference

## GNS3 Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Ctrl+S` | Save project |
| `Ctrl+Z` | Undo |
| `Ctrl+L` | Toggle Add Link tool |
| `Shift+I` | Show/hide interface labels |
| `Ctrl+Shift+E` | Start all nodes |
| `Ctrl+Shift+D` | Stop all nodes |
| `Ctrl+Shift+S` | Suspend all nodes |
| `Escape` | Cancel current action / return to select mode |
| `Delete` | Delete selected node or link |
| `Ctrl+A` | Select all nodes |
| `Ctrl+Shift+Z` | Zoom to fit all nodes |

---

## VPCS Command Reference

| Command | Example | Description |
|---------|---------|-------------|
| `ip <addr> <mask> <gateway>` | `ip 192.168.1.10 255.255.255.0 192.168.1.1` | Set IP address, subnet mask, and default gateway |
| `ip <addr>/<prefix> <gateway>` | `ip 192.168.1.10/24 192.168.1.1` | CIDR notation shorthand |
| `show ip` | `show ip` | Display current IP configuration |
| `ping <target>` | `ping 192.168.1.1` | Send 5 ICMP echo requests |
| `ping <target> -c <n>` | `ping 10.0.0.1 -c 10` | Send n ICMP echo requests |
| `trace <target>` | `trace 10.0.0.1` | Traceroute to target |
| `save` | `save` | Save current configuration to project file |
| `load` | `load` | Reload saved configuration |
| `dhcp` | `dhcp` | Request IP via DHCP |
| `clear ip` | `clear ip` | Remove current IP configuration |
| `clear arp` | `clear arp` | Clear ARP cache |
| `arp` | `arp` | Display ARP table |
| `set pcname <name>` | `set pcname PC-A` | Rename the VPCS node |

---

## IOS First-Boot Commands

Commands to run immediately after a Cisco 3725 boots for the first time in GNS3:

```
! Verify platform and IOS version
show version

! Verify all interfaces including NM-16ESW
show interfaces summary

! Enter privileged mode
enable

! Enter global configuration
configure terminal

! Set hostname
hostname R1

! Disable DNS lookup (prevents typo delays)
no ip domain-lookup

! Configure interface toward VPCS
interface FastEthernet0/0
 ip address 192.168.1.1 255.255.255.0
 no shutdown
 exit

! Return to privileged mode
end

! Save configuration
copy running-config startup-config
```

---

## IOS Verification Commands

| Command | What It Shows |
|---------|---------------|
| `show version` | IOS version, RAM, platform, uptime |
| `show interfaces` | Detailed status of all interfaces |
| `show interfaces summary` | Compact one-line status per interface |
| `show interfaces FastEthernet0/0` | Status and stats for a specific interface |
| `show ip interface brief` | IP address and up/down state for all interfaces |
| `show running-config` | Active configuration in RAM |
| `show startup-config` | Saved configuration in NVRAM |

---

## Discussion: Why Simulate Instead of Build Physical Labs?

Physical Cisco gear for CCNA-level labs costs hundreds to thousands of dollars, requires rack space, and cannot be easily reset. Simulation with GNS3 and Dynamips offers several practical advantages:

- **Zero hardware cost** — one laptop replaces a full rack
- **Snapshot and rollback** — save topology state before a risky change and restore it instantly if something breaks
- **Multiple topologies in parallel** — run three different lab scenarios simultaneously
- **Authentic IOS behavior** — Dynamips runs real Cisco IOS binary images, so the commands are identical to physical hardware
- **Packet capture** — right-click any link and select "Start capture" to open Wireshark and observe frames in real time
- **Scalability** — spin up a 10-router OSPF domain without buying 10 routers

The trade-offs are CPU and RAM consumption. Dynamips emulates Cisco MIPS hardware on your CPU, which is less efficient than running on native silicon. Idle-PC tuning mitigates the CPU cost significantly.
