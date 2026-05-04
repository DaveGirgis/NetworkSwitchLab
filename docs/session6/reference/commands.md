# Command Reference

## OSPF Commands

| Command | Purpose |
|---------|---------|
| `router ospf 1` | Enters OSPF configuration mode with process ID 1 |
| `router-id A.B.C.D` | Manually sets the OSPF router ID — must be unique per router |
| `network [address] [wildcard] area [N]` | Matches interfaces and places them into an OSPF area |
| `passive-interface [interface]` | Suppresses OSPF Hellos on an interface while still advertising its network |
| `show ip ospf neighbor` | Displays OSPF neighbor adjacencies and their state |
| `show ip ospf` | Shows OSPF process details — router ID, area, SPF run count |
| `show ip ospf database` | Displays all LSAs in the link-state database |
| `show ip ospf database router` | Shows Router LSAs — each router's description of its own links |
| `show ip ospf interface [interface]` | Shows Hello/Dead intervals, cost, DR/BDR status for one interface |
| `show ip route ospf` | Filters routing table to OSPF-learned routes only |
| `no router ospf 1` | Removes the OSPF process and all OSPF-learned routes |

## EIGRP Commands

| Command | Purpose |
|---------|---------|
| `router eigrp [AS]` | Enters EIGRP configuration mode with the specified AS number |
| `eigrp router-id A.B.C.D` | Manually sets the EIGRP router ID |
| `no auto-summary` | Disables classful summarization — always use this in modern networks |
| `network [address] [wildcard]` | Matches interfaces and enables EIGRP on them |
| `passive-interface [interface]` | Suppresses EIGRP Hellos on an interface |
| `show ip eigrp neighbors` | Lists active EIGRP neighbors |
| `show ip eigrp topology` | Displays all paths known to EIGRP — successors and feasible successors |
| `show ip eigrp topology all-links` | Shows all paths including those that are not feasible successors |
| `show ip eigrp interfaces` | Shows which interfaces are running EIGRP and Hello/Hold intervals |
| `show ip route eigrp` | Filters routing table to EIGRP-learned routes only |
| `no router eigrp [AS]` | Removes the EIGRP process and all EIGRP-learned routes |

## General Routing Commands

| Command | Purpose |
|---------|---------|
| `show ip route` | Full routing table — all sources (connected, static, OSPF, EIGRP) |
| `show ip interface brief` | Summary of all interfaces — IP address and line/protocol status |
| `show running-config \| section router` | Shows all routing protocol configurations |
| `debug ip ospf adj` | Real-time OSPF adjacency events (use carefully — verbose output) |
| `no debug all` | Stops all active debug output |

---

## Discussion & Wrap-Up

**1. Administrative distance — how IOS chooses between protocols**
When multiple routing sources know a route to the same destination, IOS uses administrative distance (AD) to pick the winner. Lower AD wins. Connected routes have AD 0 (always preferred). Static routes have AD 1. EIGRP has AD 90. OSPF has AD 110. RIP has AD 120. If you ran OSPF and EIGRP simultaneously, EIGRP routes would be installed in the routing table because 90 < 110 — unless the OSPF route has a more specific prefix.

**2. OSPF convergence — what actually happens when a link fails**
When a WAN link goes down, the neighboring router stops receiving Hello packets. After the Dead interval (default 40 seconds), it marks the neighbor as down, removes the associated routes, floods a new LSA describing the topology change, and all routers in the area run the SPF algorithm to recalculate shortest paths. Total convergence time with default timers is typically 40–50 seconds. OSPF timers can be tuned down to sub-second using BFD (Bidirectional Forwarding Detection).

**3. EIGRP convergence — the DUAL advantage**
EIGRP does not wait for a timer to expire. When a neighbor becomes unreachable, EIGRP immediately checks its topology table for a feasible successor. If one exists, traffic switches to the backup path in milliseconds with no recalculation needed. If no feasible successor exists, EIGRP sends Query messages to its neighbors asking if they have a path — this is the DUAL query process, and it completes much faster than OSPF's SPF recalculation in most topologies.

**4. When to use each protocol**
OSPF is the standard for enterprise and service provider networks because it is open, scales with multi-area design, and is supported by every vendor. EIGRP has historically been Cisco-only (though it became an open standard in 2013) and excels in Cisco-only environments where its faster convergence and simpler configuration are advantages. For the CCNA exam, you need to configure and verify both — but in production, most new deployments choose OSPF.
