# Command Reference

| Command | Purpose |
|---------|---------|
| `show spanning-tree vlan <id>` | STP topology for a specific VLAN |
| `show spanning-tree detail` | Full port roles, path costs, and timer detail |
| `show spanning-tree summary` | Feature status and per-VLAN instance overview |
| `show interfaces trunk` | Verify trunk links and allowed VLANs |
| `show vlan brief` | Confirm VLAN database on the switch |
| `show interfaces status err-disabled` | Find ports shut down by BPDU Guard |
| `show log` | View BPDU Guard and STP syslog events |
| `spanning-tree vlan <id> priority <value>` | Set bridge priority for a specific VLAN |
| `spanning-tree portfast` | Skip Listening/Learning on an access port |
| `spanning-tree bpduguard enable` | Err-disable port if a BPDU is received |
| `errdisable recovery cause bpduguard` | Enable automatic err-disable recovery (optional) |

---

## Discussion & Wrap-Up

**1. Why STP exists**
Ethernet frames have no TTL field. Without STP, a broadcast frame caught in a switching loop circulates at wire speed indefinitely, consuming all available bandwidth within seconds and crashing the network. STP solves this by computing a loop-free tree and blocking redundant paths.

**2. The cost of blocked ports**
Every blocked port represents unused physical bandwidth. PVST+ partially recovers this by running independent spanning trees per VLAN, but each individual VLAN's topology still has blocked links. This tradeoff motivates technologies like EtherChannel and layer 3 routed access designs in modern networks.

**3. Classic STP vs. Rapid STP**
802.1D classic STP takes 30–50 seconds to converge using fixed timers. 802.1w Rapid STP converges in 1–2 seconds using a proposal/agreement handshake between neighboring switches. Modern switches run RSTP or MSTP by default. Understanding classic STP first makes RSTP much easier to grasp — and both are CCNA exam objectives.

**4. The accidental root bridge**
Any unmanaged switch plugged into a production network with default priority can win the root election if its MAC address is lower than the infrastructure switches. This silently reroutes traffic through an unintended device, causing asymmetric paths and performance degradation. BPDU Guard on all access ports is the mitigation.
