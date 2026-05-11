# Troubleshooting

## BGP neighbor shows `Active` and never becomes Established

**Symptom:** `show ip bgp summary` shows the neighbor in `Active` state indefinitely.  
**Cause 1:** Layer 3 reachability problem — BGP cannot open the TCP session because the neighbor IP is not reachable.  
**Cause 2:** AS number mismatch — the `remote-as` value does not match the AS number configured on the neighbor router.  
**Cause 3:** BGP is not configured on the neighbor at all, or the neighbor statement on the far end has the wrong IP.  
**Fix:** Start with a ping:

```
ping 10.0.12.2
```

If the ping fails, the WAN link is the problem — verify interface addressing and `no shutdown`. If the ping succeeds, verify the AS numbers match on both sides:

```
show running-config | section router bgp
```

Confirm that R1's `neighbor 10.0.12.2 remote-as 65002` matches R2's `router bgp 65002`, and that R2's `neighbor 10.0.12.1 remote-as 65001` matches R1's `router bgp 65001`.

---

## BGP session is Established but `show ip bgp` shows no remote routes

**Symptom:** `show ip bgp summary` shows Established with a prefix count of `0` for a neighbor, or `show ip bgp` only shows locally originated routes.  
**Cause:** The neighbor's `network` statement is missing, incorrect, or the prefix does not exist in the neighbor's routing table.  
**Fix:** On the neighbor router, verify the network statement and check whether the prefix is in the routing table:

```
show running-config | section router bgp
show ip route 192.168.X.0
```

The prefix listed in the `network` command must appear in the routing table with an **exact prefix length match**. If `192.168.1.0/24` is in the routing table but the network statement says `network 192.168.1.0` without `mask 255.255.255.0`, IOS assumes a classful /24 in this case — but if the mask is wrong (e.g., you accidentally typed a /25), the prefix will not be injected.

---

## BGP table shows routes but routing table has no `B` entries

**Symptom:** `show ip bgp` shows prefixes marked `*>` (valid and best), but `show ip route bgp` is empty.  
**Cause:** The next-hop IP in the BGP table is unreachable. BGP installs a route in the routing table only if the next-hop is reachable. If the next-hop becomes unreachable (e.g., the WAN interface goes down after the session was established), BGP keeps the route in the BGP table but marks it invalid and does not install it.  
**Fix:** Check the next-hop reachability:

```
show ip bgp
```

Look at the `Next Hop` column. A `*` without `>` means the route is invalid — often because the next-hop is not reachable. Verify the WAN interface is up:

```
show ip interface brief
ping <next-hop-ip>
```

---

## End-to-end ping fails even though BGP routes are installed

**Symptom:** `show ip route bgp` shows the correct BGP routes, but pings from PC-A to a remote PC fail.  
**Cause 1:** Return path missing — the remote router does not have a route back. Check `show ip route bgp` on the far-end router.  
**Cause 2:** PC default gateway is wrong — the PC is sending traffic to the correct destination, but its gateway address is misconfigured.  
**Cause 3:** An intermediate interface is down.  
**Fix:** Step through the path from the source:

```
! On R1
show ip route bgp                  ! Is 192.168.3.0/24 present?
ping 192.168.3.1                   ! Can R1 reach R3's gateway?
ping 192.168.3.10                  ! Can R1 reach R3-PC-A?
```

Then check from the far end:

```
! On R3
show ip route bgp                  ! Is 192.168.1.0/24 present?
ping 192.168.1.1                   ! Can R3 reach R1's gateway?
```

The first ping that fails identifies the broken hop. Trace back to find the missing route or unreachable interface.

---

## `network` command accepted but prefix does not appear in BGP table

**Symptom:** `show running-config | section router bgp` shows the network statement, but `show ip bgp` does not include the prefix.  
**Cause:** The prefix does not exist in the routing table with an exact match. BGP checks the routing table when the `network` command is entered. If the prefix is absent or the mask differs, BGP silently skips the advertisement with no error message.  
**Fix:** Verify the prefix is in the routing table:

```
show ip route 192.168.1.0
```

If it is missing (e.g., the interface is down), bring the interface up. If the mask does not match, correct the `network` statement:

```
router bgp 65001
 no network 192.168.1.0
 network 192.168.1.0 mask 255.255.255.0
```

---

## BGP session drops and does not recover after a link flap

**Symptom:** After a WAN link went down and came back up, `show ip bgp summary` shows the neighbor in `Idle` or `Active` state and the session does not re-establish on its own.  
**Cause:** BGP's ConnectRetry timer may be delaying reconnection. This is normal behavior — BGP backs off exponentially after failed connection attempts.  
**Fix:** A soft or hard clear will restart the connection attempt immediately:

```
clear ip bgp 10.0.12.2 soft
```

If that does not work, use a hard reset:

```
clear ip bgp 10.0.12.2
```

Wait 30–60 seconds and check `show ip bgp summary` again. If the session still does not come up, verify the WAN interface is fully operational:

```
show ip interface brief
ping 10.0.12.2
```
