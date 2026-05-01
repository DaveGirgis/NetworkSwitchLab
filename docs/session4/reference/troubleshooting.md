# Troubleshooting

## Ping from R1-PC-A to R2-PC-A fails — no route to host

**Symptom:** Ping from 192.168.10.10 to 192.168.11.10 fails. R1's routing table shows the static route for 192.168.11.0/24.  
**Cause:** The static route on R2 pointing back to 192.168.10.0/24 is missing or incorrect. Routing requires a path in both directions — traffic reaches R2 but the return path does not exist.  
**Fix:** Verify `show ip route` on R2. Add the missing route:

```
ip route 192.168.10.0 255.255.255.0 172.16.31.1
```

---

## Ping from R1 to R2's Fa0/1 fails — point-to-point link appears down

**Symptom:** `show interfaces FastEthernet0/1` shows line protocol is down on one or both routers.  
**Cause:** Either the GNS3 link is not connected, the interface was not brought up with `no shutdown`, or the IP addresses are on different subnets.  
**Fix:** Confirm the GNS3 cable connects `Fa0/1` on R1 to `Fa0/1` on R2 (not to an NM-16ESW port). Confirm both interfaces have `no shutdown`. Verify both IP addresses belong to the same `/30` subnet from the addressing table.

```
show interfaces FastEthernet0/1
show running-config | section FastEthernet0/1
```

---

## Local gateway ping fails — PC cannot reach its default gateway

**Symptom:** R1-PC-A cannot ping 192.168.10.1. The SVI appears to be configured correctly.  
**Cause 1:** The access port `Fa1/1` is not assigned to VLAN 10, so no active port exists in the VLAN and the SVI line protocol stays down.  
**Cause 2:** VLAN 10 was not created in `vlan database` mode — the SVI exists but the VLAN does not, so the interface stays down.  
**Cause 3:** The SVI was not brought up with `no shutdown`.  
**Fix:** Verify the full LAN configuration:

```
show vlan-switch brief
show interfaces Vlan10
show running-config | section Vlan10
```

Confirm VLAN 10 is active in `show vlan-switch brief`, that `Fa1/1` is assigned to it, and that the SVI shows line protocol up.

---

## `show ip route` shows the static route but ping still fails

**Symptom:** The correct `S` entry appears in the routing table on both routers, but end-to-end pings fail.  
**Cause:** The next-hop IP address in the static route is unreachable — either the /30 link is down, or the wrong next-hop address was entered (e.g., the network address or broadcast instead of the host address).  
**Fix:** Ping the next-hop address directly from the router. If that fails, the /30 link itself is the problem. If it succeeds, verify the next-hop in the static route matches the far-end interface address — not the network address or broadcast.

```
show ip route static
ping 172.16.31.2
```

---

## Summary route is in the table but loopbacks are unreachable

**Symptom:** `show ip route` on R1 shows `10.0.0.0/22` as a static route, but pings to R2's loopbacks fail.  
**Cause 1:** The summary prefix or mask was calculated incorrectly and does not cover the loopback addresses.  
**Cause 2:** The specific routes were removed before the summary was added, leaving a gap during which traffic was black-holed and the session state was not cleared.  
**Fix:** Verify the summary covers the target range. `10.0.0.0/22` covers `10.0.0.0–10.0.3.255`. If your loopbacks are in that range and pings still fail, confirm R2 has routes back to R1's networks:

```
show ip route
ping 10.0.0.1 source Vlan10
```

Using `source` on the ping ensures the test uses a return-path that R2 knows about — R2 has a static route to 192.168.10.0/24 via the SVI network, not to R1's `Fa0/1` address.

---

## GNS3 link shows green but interface line protocol stays down

**Symptom:** The GNS3 canvas shows a green link between R1 and R2 on `Fa0/1`, but `show interfaces` reports line protocol is down.  
**Cause:** GNS3 links sometimes take several seconds to fully negotiate after the topology starts. The interface may also need a manual reset if it was previously connected to a different device.  
**Fix:** Wait 10–15 seconds after starting the topology. If the link remains down, toggle the interface:

```
interface FastEthernet0/1
 shutdown
 no shutdown
```
