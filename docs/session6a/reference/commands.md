# Command Reference

## BGP Configuration Commands

| Command | Purpose |
|---------|---------|
| `router bgp <AS>` | Enters BGP configuration mode and declares this router's AS number |
| `bgp router-id A.B.C.D` | Manually sets the BGP router ID — use the same convention as OSPF (1.1.1.1, 2.2.2.2, 3.3.3.3) |
| `neighbor <ip> remote-as <AS>` | Declares an eBGP peer by IP address and remote AS number |
| `network <prefix> mask <mask>` | Injects a prefix into the BGP table for advertisement — the prefix must exist in the routing table |
| `no router bgp <AS>` | Removes the BGP process and all BGP-learned routes |

## BGP Verification Commands

| Command | Purpose |
|---------|---------|
| `show ip bgp summary` | Overview of all BGP neighbors — session state, prefixes received, up/down time |
| `show ip bgp` | Full BGP table — all prefixes with status codes, next-hop, and AS-PATH |
| `show ip bgp <prefix>` | Detailed attributes for one specific prefix — origin, AS-PATH, next-hop, weight |
| `show ip route bgp` | Filters the routing table to BGP-learned routes only (`B` entries) |
| `show ip bgp neighbors` | Detailed BGP neighbor information — timers, capabilities, message counts |
| `show ip bgp neighbors <ip> advertised-routes` | Prefixes this router is sending to the specified neighbor |
| `show ip bgp neighbors <ip> received-routes` | Prefixes received from the specified neighbor (requires `soft-reconfiguration inbound`) |

## BGP Maintenance Commands

| Command | Purpose |
|---------|---------|
| `clear ip bgp * soft` | Soft-reset all BGP sessions — re-exchanges routes without dropping TCP connections |
| `clear ip bgp <ip> soft` | Soft-reset one specific neighbor session |
| `clear ip bgp *` | Hard-reset all BGP sessions — drops and re-establishes TCP connections (use sparingly) |
| `debug ip bgp` | Real-time BGP event output — Open, Update, Keepalive, Notification messages |
| `no debug all` | Stops all active debug output |

## General Routing Commands

| Command | Purpose |
|---------|---------|
| `show ip route` | Full routing table — all sources including BGP (`B`), connected (`C`), static (`S`) |
| `show ip interface brief` | Summary of all interfaces — IP address and line/protocol status |
| `show running-config \| section router bgp` | Shows the full BGP process configuration |

---

## Discussion & Wrap-Up

**1. BGP versus IGPs — fundamentally different purposes**

OSPF and EIGRP are Interior Gateway Protocols (IGPs): they discover topology inside a single organization and find the shortest path. BGP is an Exterior Gateway Protocol (EGP): it connects organizations (autonomous systems) together and carries policy — which paths are allowed, which are preferred, and which routes you will re-advertise.

The internet routes between 900,000+ prefixes entirely through BGP. Every ISP, cloud provider, and large enterprise uses BGP to interconnect. OSPF and EIGRP are never used between organizations — they are used internally to distribute routes within an AS.

**2. Administrative distance — where BGP fits**

| Source | Administrative Distance |
|--------|------------------------|
| Connected | 0 |
| Static | 1 |
| eBGP | 20 |
| EIGRP | 90 |
| OSPF | 110 |
| iBGP | 200 |

eBGP has AD 20 — lower than any IGP. If both BGP and OSPF advertise the same prefix, the BGP route wins. This is intentional: BGP carries inter-domain policy, and that policy should override intra-domain metrics.

**3. AS-PATH as loop prevention**

BGP has no concept of a hop count or metric in the traditional sense. Its primary loop prevention tool is the AS-PATH attribute. When a route passes through an AS, that AS prepends its number to the path. If a router receives a route that already contains its own AS in the path, it discards it — the route has come back around and would cause a loop.

This is why the AS-PATH for `192.168.3.0` on R1 reads `65002 65003`: the route was born in AS 65003, passed through AS 65002, and arrived at AS 65001. If R1 somehow tried to send this route back toward R2, R2 would see `65001` in the path and reject it.

**4. Why BGP convergence is slow — and why that is correct**

OSPF converges in seconds. EIGRP in milliseconds. BGP's default Hold timer is 180 seconds — three minutes before a dead neighbor is detected. This is not a limitation; it is a deliberate design choice.

On the internet, a BGP session connects two organizations. A router reset or flapping link at one ISP should not immediately cascade change messages to every other router on the internet. BGP's slow convergence (and route dampening features) absorbs transient failures before propagating them globally. Speed would be destabilizing at internet scale.

**5. When you would use BGP in a real network**

- Connecting your organization to an ISP (single or multi-homed)
- Running a cloud infrastructure that needs to exchange routes with customer networks
- Large enterprise networks where traffic engineering across multiple WAN providers is required
- Data center fabrics using eBGP as a routing protocol between spine and leaf (BGP in the data center)

For most enterprise networks that use a single ISP, a default route from the ISP plus an IGP internally is sufficient — BGP is not needed. BGP becomes necessary when you have multiple ISPs, when you need policy control over inbound/outbound traffic paths, or when you are an ISP yourself.
