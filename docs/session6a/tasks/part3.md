# Part 3 — BGP Verification

**Objective:** Confirm BGP neighbor sessions are established, inspect the BGP table and its attributes, verify that BGP routes are installed in the routing table, and test end-to-end reachability.

---

## Task 3.1 — Verify BGP Neighbor Sessions

Run on each router:

```
show ip bgp summary
```

Expected output on R2:

```
BGP router identifier 2.2.2.2, local AS number 65002
BGP table version is 4, main routing table version 4
3 network entries using 351 bytes of memory
3 path entries using 156 bytes of memory

Neighbor        V    AS MsgRcvd MsgSent   TblVer  InQ OutQ Up/Down  State/PfxRcd
10.0.12.1       4 65001       8       8        4    0    0 00:03:15        1
10.0.23.3       4 65003       7       7        4    0    0 00:02:48        1
```

Confirm:

- Both neighbors show a number in the `State/PfxRcd` column, not a state name like `Active` or `Idle` — a numeric value means the session is **Established** and that many prefixes were received
- `Up/Down` shows elapsed time, not a timestamp — this confirms the session has been stable
- `V` column shows BGP version 4 (the only version in use today)

> [!NOTE]
> If the `State/PfxRcd` column shows `Active` instead of a number, the TCP session has not established. Check Layer 3 reachability between the neighbor IPs (`ping 10.0.12.1` from R2) and verify the `remote-as` value matches the neighbor's actual AS number.

---

## Task 3.2 — Inspect the BGP Table

```
show ip bgp
```

Expected output on R1:

```
BGP table version is 4, local router ID is 1.1.1.1
Status codes: s suppressed, d damped, h history, * valid, > best, i - internal,
              r RIB-failure, S Stale
Origin codes: i - IGP, e - EGP, ? - incomplete

   Network          Next Hop            Metric LocPrf Weight Path
*> 192.168.1.0      0.0.0.0                  0         32768 i
*> 192.168.2.0      10.0.12.2                0             0 65002 i
*> 192.168.3.0      10.0.12.2                              0 65002 65003 i
```

Key fields to note:

| Column | Meaning |
|--------|---------|
| `*` | Route is valid (reachable next-hop) |
| `>` | Route is the best path — will be installed in the routing table |
| `Network` | The prefix being advertised |
| `Next Hop` | `0.0.0.0` means locally originated; otherwise the eBGP peer address |
| `Path` | The AS-PATH — the sequence of ASes this route has traversed |

### Reading the AS-PATH

The `Path` column for `192.168.3.0` shows `65002 65003`:

- The route originated in **AS 65003** (R3's network)
- It was received by R2 (**AS 65002**), which prepended its own AS number before sending it to R1
- R1 reads the path right-to-left to find the origin: `65003` originated it, passed through `65002`, and arrived at `65001` (R1)

This AS-PATH serves as BGP's loop prevention mechanism. If R1 ever received a route with `65001` already in the path, it would discard it — that route has already passed through its own AS.

---

## Task 3.3 — Verify Routing Table

```
show ip route bgp
```

Expected output on R1:

```
B    192.168.2.0/24 [20/0] via 10.0.12.2, 00:03:15
B    192.168.3.0/24 [20/0] via 10.0.12.2, 00:02:48
```

- `B` — route learned via BGP
- `[20/0]` — administrative distance 20 (eBGP), metric 0
- `via 10.0.12.2` — next hop is R2's WAN interface (directly connected, so reachable)

> [!NOTE]
> eBGP has an administrative distance of **20**, which is lower than OSPF (110) and EIGRP (90). If a network ran both BGP and an IGP advertising the same prefix, BGP would win. This is intentional — BGP is the authoritative routing protocol for inter-AS routing.

---

## Task 3.4 — End-to-End Connectivity Test

From R1-PC-A, ping both remote destinations:

```
ping 192.168.2.1    ! R2 loopback
ping 192.168.3.10   ! R3-PC-A
```

From R3-PC-A, ping in the other direction:

```
ping 192.168.2.1
ping 192.168.1.10   ! R1-PC-A
```

All four pings should succeed. The complete path for R1-PC-A to R3-PC-A is:

```
R1-PC-A --> R1 Fa0/0 --> R1 Fa0/1 --> R2 Fa0/0 --> R2 Fa0/1 --> R3 Fa0/1 --> R3 Fa0/0 --> R3-PC-A
```

---

## Task 3.5 — View BGP Attributes for a Specific Prefix

```
show ip bgp 192.168.3.0
```

This shows the full BGP attribute set for one prefix. Note the following:

- **Origin**: `i` (IGP) — the prefix was injected using a `network` command on R3
- **AS_PATH**: `65002 65003` — the two ASes the route traversed before reaching R1
- **Next Hop**: `10.0.12.2` — R2's address; R1 must reach this to forward packets
- **Local Preference**: not set (only used in iBGP within a single AS)
- **Weight**: 0 — Cisco-proprietary attribute, only significant locally

---

## Task 3.6 — Simulate a BGP Session Drop (Optional)

On R2, shut down `Fa0/0` to simulate a link failure toward R1:

```
interface FastEthernet0/0
 shutdown
```

Watch the console on R1. After the BGP Hold timer expires (default 180 seconds), you will see:

```
%BGP-5-ADJCHANGE: neighbor 10.0.12.2 Down BGP Notification sent
```

Run `show ip route` on R1 — the BGP routes (`B`) should disappear. This leaves R1 with no path to 192.168.2.0/24 or 192.168.3.0/24.

Restore the link:

```
interface FastEthernet0/0
 no shutdown
```

BGP will re-establish the TCP session and re-exchange routes. Compare the reconvergence time to the OSPF failover you observed in Session 6 — BGP is noticeably slower because it waits for the Hold timer to expire before detecting the failure. In production networks, BFD (Bidirectional Forwarding Detection) is used to shorten this detection time without changing BGP timers.
