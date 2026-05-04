# Command Reference

| Command | Purpose |
|---------|---------|
| `ipv6 unicast-routing` | Enables IPv6 packet forwarding between interfaces — required on every router |
| `ipv6 address [address/prefix]` | Assigns a global unicast IPv6 address to an interface |
| `show ipv6 interface brief` | Summary of all interfaces — shows IPv6 addresses and line protocol status |
| `show ipv6 interface [interface]` | Detailed IPv6 status for one interface, including link-local address |
| `show ipv6 route` | Displays the full IPv6 routing table — connected (C), local (L), and static (S) entries |
| `show ipv6 route static` | Filters the routing table to show only static routes |
| `ipv6 route ::/0 [next-hop]` | Configures the IPv6 default route (gateway of last resort) |
| `ipv6 route [prefix/len] [next-hop]` | Adds a specific IPv6 static route |
| `no ipv6 route [prefix/len] [next-hop]` | Removes a specific IPv6 static route |
| `ping [ipv6-address]` | Sends an ICMPv6 echo to an IPv6 address |
| `ping [ipv6-address] source [interface]` | Pings from a specific source interface — important for testing return paths |
| `show ipv6 neighbors` | Displays the IPv6 neighbor cache (equivalent of IPv4 ARP table) |

---

## IPv6 vs IPv4 — Key Differences for This Lab

| Concept | IPv4 | IPv6 |
|---------|------|------|
| Routing enable | On by default | Must run `ipv6 unicast-routing` |
| Address command | `ip address` | `ipv6 address` |
| Route command | `ip route` | `ipv6 route` |
| Default route prefix | `0.0.0.0 0.0.0.0` | `::/0` |
| Show routing table | `show ip route` | `show ipv6 route` |
| Address resolution | ARP (`show arp`) | Neighbor Discovery (`show ipv6 neighbors`) |
| Host routes | Not installed automatically | Router installs `/128` local route for each interface address |
| Link-local addresses | Not present | Auto-generated on every IPv6 interface (`fe80::`) |

---

## Discussion & Wrap-Up

**1. Link-local addresses — what they are and why they matter**
Every IPv6 interface automatically generates a link-local address from the `fe80::/10` prefix using the interface MAC address (EUI-64). These addresses exist only on a single link — they cannot be routed and will never appear as a next hop in a routing table unless you specifically use them as a next-hop (which requires also specifying the exit interface). In this lab, all next-hop addresses are global unicast addresses, which is simpler and unambiguous.

**2. Why /64 for everything?**
IPv6 was designed with the assumption that all end-user networks are /64. The lower 64 bits are the interface identifier, and Stateless Address Autoconfiguration (SLAAC) depends on the /64 boundary. Point-to-point links between routers can technically use longer prefixes (/126 or /127), but this lab uses /64 throughout to keep the addressing consistent and easy to learn.

**3. The neighbor discovery protocol**
IPv6 does not use ARP. Instead, routers and hosts use Neighbor Discovery Protocol (NDP), which runs over ICMPv6. When R1 sends a packet to `2001:db8:0:12::2`, it first sends a Neighbor Solicitation multicast to discover R2's MAC address, and R2 replies with a Neighbor Advertisement. The result is stored in the neighbor cache (`show ipv6 neighbors`), which is the IPv6 equivalent of `show arp`.

**4. Stateless address autoconfiguration (SLAAC)**
In a production network, hosts can configure their own IPv6 addresses automatically by listening for Router Advertisement (RA) messages from the local router. The host takes the /64 prefix from the RA and generates its own interface identifier using its MAC address. This lab uses static addressing throughout to keep configuration explicit and traceable, but SLAAC is how most IPv6 networks assign host addresses in practice.
