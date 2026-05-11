# Part 2 — BGP Configuration

**Objective:** Enable eBGP on all three routers, declare neighbor relationships, and advertise each router's LAN prefix into BGP.

---

## Task 2.1 — Configure BGP on R1

```
router bgp 65001
 bgp router-id 1.1.1.1
 neighbor 10.0.12.2 remote-as 65002
 network 192.168.1.0 mask 255.255.255.0
```

---

## Task 2.2 — Configure BGP on R2

R2 is the transit router. It peers with both R1 and R3 and re-advertises routes between the two edge ASes.

```
router bgp 65002
 bgp router-id 2.2.2.2
 neighbor 10.0.12.1 remote-as 65001
 neighbor 10.0.23.3 remote-as 65003
 network 192.168.2.0 mask 255.255.255.0
```

---

## Task 2.3 — Configure BGP on R3

```
router bgp 65003
 bgp router-id 3.3.3.3
 neighbor 10.0.23.2 remote-as 65002
 network 192.168.3.0 mask 255.255.255.0
```

---

## Understanding the Configuration

### Autonomous System Number

`router bgp 65001` starts the BGP process for this router and declares its AS number. Every router in an AS shares the same AS number — in this lab, each router is its own AS. Unlike OSPF (`router ospf 1`), the BGP AS number is globally significant: it identifies your organization on the internet. The range 64512–65535 is reserved for private use.

### Why neighbor statements are required

OSPF and EIGRP discover neighbors automatically using multicast Hello packets. BGP does not. You must explicitly tell each router who its peers are using `neighbor <ip> remote-as <AS>`. The IP address is the neighbor's directly connected interface address — in this lab, always the WAN link IP on the shared subnet.

The `remote-as` value must match the AS number configured on the neighbor. If the values do not match, BGP will reject the connection attempt and the neighbor will stay in the `Idle` or `Active` state.

### BGP uses TCP, not multicast

When you configure a neighbor statement, IOS attempts to open a TCP connection to that IP address on port 179. This means:

- Both routers must have Layer 3 reachability to each other (the WAN link must be up and addressed)
- The neighbor IP must be directly reachable — eBGP peers cannot be multiple hops away by default
- No multicast or broadcast is used; BGP sessions are unicast point-to-point

### The network command — what it actually does

The `network` command in BGP does **not** mean "run BGP on this interface" (unlike OSPF). It means "inject this prefix into the BGP table and advertise it to neighbors."

For the injection to succeed, the exact prefix must already exist in the IP routing table — typically as a connected route. If the prefix is missing or has a different mask, BGP silently ignores the network statement.

```
! This works because 192.168.1.0/24 is in the routing table as a connected route on Fa0/0
network 192.168.1.0 mask 255.255.255.0
```

> [!WARNING]
> The `mask` keyword is required in BGP. Without it, IOS assumes a classful mask, which may not match your prefix. A `/24` without `mask 255.255.255.0` will still work here, but develop the habit of always specifying the mask to avoid subtle mismatches.

### What to expect after configuration

After configuring BGP on all three routers, you should see console messages similar to:

```
%BGP-5-ADJCHANGE: neighbor 10.0.12.2 Up
```

This confirms the TCP session was established and the BGP Open message exchange completed. BGP will then exchange Update messages containing the route advertisements. Allow 30–60 seconds for the session to come up and routes to propagate before running verification commands.

> [!NOTE]
> BGP convergence is intentionally slower than OSPF or EIGRP. BGP is designed for stability and policy control, not speed. On the internet, rapid convergence would cause route flapping to propagate globally, destabilizing routing for millions of networks. The default BGP timers (Keepalive: 60s, Hold: 180s) reflect this design.

```
end
write memory
```

Repeat `write memory` on all three routers.
