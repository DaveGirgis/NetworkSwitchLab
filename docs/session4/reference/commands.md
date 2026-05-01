# Command Reference

| Command | Purpose |
|---------|---------|
| `show ip route` | Displays the full routing table — connected, static, and dynamic routes |
| `show ip route static` | Filters the routing table to show only static routes |
| `show interfaces FastEthernet0/1` | Confirms line protocol status and IP address on the point-to-point link |
| `show interfaces Vlan10` | Confirms SVI status and IP address for VLAN 10 |
| `show vlan-switch brief` | Confirms VLAN existence and port assignments on NM-16ESW |
| `interface Vlan10` | Enters SVI configuration mode for VLAN 10 — provides the Layer 3 gateway for that VLAN |
| `ip route [network] [mask] [next-hop]` | Adds a static route using next-hop IP address |
| `ip route [network] [mask] [exit-interface]` | Adds a static route using exit interface (use with caution on multi-access links) |
| `ip route 0.0.0.0 0.0.0.0 [next-hop]` | Configures the default route (gateway of last resort) |
| `no ip route [network] [mask] [next-hop]` | Removes a specific static route |
| `ping [ip] source [interface]` | Sends a ping using a specific source interface — useful for testing paths from non-directly-connected addresses |
| `interface Loopback[N]` | Creates a logical loopback interface — always up, used to simulate stub networks |

---

## Discussion & Wrap-Up

**1. Why static routing exists — and when it belongs in production**
Static routes are the simplest form of routing: an administrator manually tells a router where to send traffic. There is no protocol overhead, no neighbor relationships to maintain, and the behavior is completely predictable. In production, static routes are appropriate for stub networks (a site with only one exit point), for default routes pointing toward an ISP, and for specific traffic engineering cases where you need guaranteed path control. They become a maintenance burden as the network grows — which is exactly why dynamic routing protocols exist.

**2. The cost of manual configuration — convergence and scale**
Every static route is a configuration line someone must add, verify, and remove when the topology changes. If R2's `Fa0/1` interface goes down, R1's static route still exists and will continue forwarding traffic into a black hole until an administrator intervenes. Dynamic routing protocols detect failures and recalculate paths automatically — this is called convergence. Static routes do not converge. In a network with dozens of routers and routes, this operational cost becomes unsustainable, which is the direct motivation for OSPF in the next session.

**3. How summarization relates to what OSPF will do automatically**
Manual route summarization does in static routing what OSPF area border routers (ABRs) do automatically in a multi-area design. By advertising a single `10.0.0.0/22` instead of four `/24` entries, R1's routing table stays smaller and any route changes within R2's loopback range are invisible to R1. The tradeoff is that a summary route is imprecise — it covers address space that may not be fully allocated. This is acceptable when you control both sides of the summary, and it is a concept the CCNA exam tests directly under both static routing and OSPF multi-area topics.

**4. The production gotcha — summary routes and black holes**
When you configure `ip route 10.0.0.0 255.255.252.0 172.16.31.2` on R1, R1 will forward all traffic for `10.0.0.0–10.0.3.255` toward R2 — including subnets that R2 does not actually have. If a host sends traffic to `10.0.2.200` and that subnet does not exist anywhere on R2, R2 has no matching route and drops the packet. The traffic never returns an error to the sender — it simply disappears. This is called a routing black hole, and it is one of the most common causes of intermittent connectivity problems in networks that use manual summarization. The fix is either to ensure your summary exactly matches your allocated space, or to add a `null0` discard route on R2 for the summary range so that unroutable traffic is explicitly dropped rather than silently forwarded.
