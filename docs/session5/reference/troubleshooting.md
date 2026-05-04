# Troubleshooting

## Ping between routers on a WAN link fails

**Symptom:** R1 cannot ping `2001:db8:0:12::2` even though both interfaces have IPv6 addresses assigned and show line protocol up.  
**Cause:** `ipv6 unicast-routing` was not configured on one or both routers. Without it, the router accepts IPv6 packets addressed to itself but will not forward or respond to packets that require routing.  
**Fix:** Confirm on each router:

```
show running-config | include ipv6 unicast-routing
```

If the output is empty, the command is missing. Add it:

```
configure terminal
ipv6 unicast-routing
```

---

## PC cannot ping its local gateway

**Symptom:** R1-PC-A cannot ping `2001:db8:0:1::1`. The router interface shows line protocol up.  
**Cause 1:** The PC's prefix length is wrong. If R1-PC-A is configured as `2001:db8:0:1::10/128`, it treats itself as an isolated host with no local subnet and cannot reach the gateway.  
**Cause 2:** The PC's gateway address is incorrect or not set.  
**Cause 3:** The router interface was not brought up with `no shutdown`.  
**Fix:** Verify the router interface:

```
show ipv6 interface FastEthernet0/0
```

Confirm the global unicast address shows `2001:DB8:0:1::1` and the line protocol is up. On the PC, verify the address (`2001:db8:0:1::10/64`) and gateway (`2001:db8:0:1::1`) are correct.

---

## R2 can reach R1's LAN but not R3's LAN

**Symptom:** Pings from R2 to `2001:db8:0:1::10` succeed but pings to `2001:db8:0:3::10` fail.  
**Cause:** The static route for R3's LAN is missing or uses the wrong next-hop on R2.  
**Fix:** Check R2's routing table:

```
show ipv6 route static
```

You should see two entries: one for `2001:DB8:0:1::/64` and one for `2001:DB8:0:3::/64`. If the second is missing, add it:

```
ipv6 route 2001:db8:0:3::/64 2001:db8:0:23::3
```

---

## `show ipv6 interface` shows address as Tentative

**Symptom:** After assigning an IPv6 address, `show ipv6 interface` shows the address state as `tentative` rather than valid.  
**Cause:** The router is running Duplicate Address Detection (DAD) — a standard IPv6 process that verifies no other device on the link is using the same address. It completes within a few seconds.  
**Fix:** Wait 3–5 seconds and re-run the command. The address will move from `tentative` to its normal valid state. If it remains tentative indefinitely, another device on the same link has the same address.

---

## End-to-end ping fails even though all routing tables look correct

**Symptom:** R1-PC-A cannot ping R3-PC-A but all `show ipv6 route` outputs appear correct.  
**Cause 1:** The return path is broken. Routing requires both directions — R3 must know how to reach R1-PC-A's address, not just its own gateway.  
**Cause 2:** The PC's default gateway is missing, so traffic from the PC never leaves the local subnet.  
**Fix:** Test each hop individually:

```
! From R1-PC-A
ping 2001:db8:0:1::1      ! gateway — should succeed
ping 2001:db8:0:12::2     ! R2 Fa0/0 — tests R1 default route
ping 2001:db8:0:23::3     ! R3 Fa0/1 — tests R2 static route to R3 LAN side
ping 2001:db8:0:3::1      ! R3 LAN gateway — tests full outbound path
ping 2001:db8:0:3::10     ! R3-PC-A — tests end-to-end
```

The first ping that fails identifies which hop is broken.

---

## Link-local address appears as next-hop in routing table

**Symptom:** `show ipv6 route` shows a static route with a next-hop of `FE80::...` instead of a global unicast address.  
**Cause:** The `ipv6 route` command was configured using the neighbor's link-local address as the next hop. This is technically valid but requires the exit interface to also be specified.  
**Fix:** Remove the route and re-add it using the global unicast next-hop address:

```
no ipv6 route ::/0 FE80::...
ipv6 route ::/0 2001:db8:0:12::2
```

Using global unicast next-hops is simpler, unambiguous, and does not require specifying the exit interface.
