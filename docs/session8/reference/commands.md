# Command Reference

This session is investigative — there is no build sequence. The commands below are organized by the diagnostic question they answer. Use them to narrow down where a fault lives before attempting a fix.

---

## Layer 2 — VLAN and Switching

| Command | Run on | What it tells you |
|---------|--------|-------------------|
| `show vlan-switch brief` | R1 or R3 | Which VLANs exist and which ports are assigned to each |
| `show vlan-switch` | R1 or R3 | Full VLAN detail including port membership |
| `show interfaces Fa1/X` | R1 or R3 | Physical state of a specific NM-16ESW port |
| `show interfaces Fa1/X switchport` | R1 or R3 | Access VLAN and mode for a specific port |

**Interpreting `show vlan-switch brief`:**
- If a port appears under VLAN 1 instead of its expected VLAN, the `switchport access vlan` command was not applied or was applied incorrectly.
- If a VLAN row does not appear at all, the VLAN was never created (`vlan database` → `vlan X`).
- If a VLAN appears but its SVI is down, the VLAN exists but no ports are active in it.

---

## Layer 3 — OSPF and Routing

| Command | Run on | What it tells you |
|---------|--------|-------------------|
| `show ip ospf neighbor` | Any router | Whether OSPF adjacencies have formed and reached FULL state |
| `show ip route ospf` | Any router | Which routes were learned via OSPF |
| `show ip route` | Any router | Full routing table — all protocols |
| `show running-config \| section ospf` | Any router | The OSPF process configuration including `network` statements |
| `show ip ospf interface brief` | Any router | Which interfaces are participating in OSPF |

**Interpreting `show ip ospf neighbor`:**
- A missing neighbor means the two routers never formed an adjacency — check `network` statements on both sides, ensure the interface is included in OSPF, and confirm area numbers match.
- A neighbor stuck in INIT or 2WAY (not FULL) suggests a hello timer or area mismatch.

---

## Policy — ACL Inspection

| Command | Run on | What it tells you |
|---------|--------|-------------------|
| `show ip access-lists` | Any router | All ACLs and their match counters |
| `show ip access-lists CROSS-SITE` | R2 | The specific ACL controlling cross-site traffic |
| `show ip interface Fa0/1` | R2 | Whether an ACL is applied to the interface and in which direction |
| `show running-config \| section ip access-list` | Any router | Full ACL configuration |

**Interpreting ACL hit counters:**
- A deny line with matches (`X matches`) confirms traffic is hitting that rule.
- A permit line with zero matches on traffic you expect to succeed suggests the traffic is not reaching that rule — either it was dropped earlier or it matches a different rule first.

---

## Connectivity Testing

| Command | Run on | What it tests |
|---------|--------|---------------|
| `ping 172.16.X.1` | PC | Reachability to the local gateway |
| `ping 172.16.X.Y` | PC or router | End-to-end reachability across sites |
| `ping 10.1.12.2` | R1 | R1-to-R2 WAN link |
| `ping 10.1.23.2` | R2 | R2-to-R3 WAN link |

**Diagnostic strategy:** Start with the nearest hop. If a PC cannot reach its gateway, the fault is Layer 2. If the gateway is reachable but a remote site is not, the fault is Layer 3 or policy. If some remote destinations succeed while others fail on the same router, the fault is policy.

---

## Fix Commands

Once a fault is identified, these are the typical corrective commands.

**Wrong VLAN assignment:**
```
enable
configure terminal
interface Fa1/X
switchport access vlan Y
```

**Missing OSPF network statement:**
```
enable
configure terminal
router ospf 1
network A.B.C.D W.X.Y.Z area 0
```

**ACL permit entry missing:**
```
enable
configure terminal
ip access-list extended CROSS-SITE
permit ip A.B.C.D W.X.Y.Z any
```

> [!NOTE]
> On the Cisco 3725 with NM-16ESW, VLANs must be created in `vlan database` mode before an SVI will come up. If a VLAN SVI is missing from `show ip interface brief`, confirm the VLAN exists with `show vlan-switch brief` first.

---

## Discussion

### Why does OSPF still fail if the link is up?

OSPF forms neighbors over connected interfaces, but only on interfaces explicitly included in a `network` statement. A link can be physically up and have a valid IP address while still being invisible to OSPF. The neighbor table (`show ip ospf neighbor`) is the definitive check — if a neighbor is absent, the routing table will have no routes learned from that direction.

### Why would some destinations succeed and others fail when routing is working?

When the routing table is correct but reachability is still inconsistent, the fault is almost always policy. An ACL that permits traffic to one subnet but not another produces exactly this pattern — pings to one destination succeed, pings to a different destination on the same router fail. The ACL hit counters (`show ip access-lists`) will show a deny match for the affected traffic.

### Why is `show vlan brief` the wrong command here?

The Cisco 3725 with NM-16ESW uses `show vlan-switch brief` — the standard `show vlan brief` command applies to dedicated switch platforms and is not available in the same form on this hardware. Using the wrong command returns an error or incomplete output and does not reflect NM-16ESW VLAN state.
