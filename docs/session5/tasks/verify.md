# Verification

Use the following checklist to confirm the session is complete. Every item must pass before the session is considered done.

---

## Checklist

| # | Check | Command | Expected Result |
|---|-------|---------|-----------------|
| 1 | R1 LAN interface up with correct IPv6 | `show ipv6 interface Fa0/0` | `2001:DB8:0:1::1` assigned, line protocol up |
| 2 | R3 LAN interface up with correct IPv6 | `show ipv6 interface Fa0/0` | `2001:DB8:0:3::1` assigned, line protocol up |
| 3 | R1 WAN interface up | `show ipv6 interface Fa0/1` | `2001:DB8:0:12::1` assigned, line protocol up |
| 4 | R2 Fa0/0 up | `show ipv6 interface Fa0/0` | `2001:DB8:0:12::2` assigned, line protocol up |
| 5 | R2 Fa0/1 up | `show ipv6 interface Fa0/1` | `2001:DB8:0:23::2` assigned, line protocol up |
| 6 | R3 WAN interface up | `show ipv6 interface Fa0/1` | `2001:DB8:0:23::3` assigned, line protocol up |
| 7 | R1-PC-A reaches R1 gateway | `ping 2001:db8:0:1::1` from PC | All replies received |
| 8 | R3-PC-A reaches R3 gateway | `ping 2001:db8:0:3::1` from PC | All replies received |
| 9 | R1 default route present | `show ipv6 route` on R1 | `S ::/0` entry via `2001:DB8:0:12::2` |
| 10 | R3 default route present | `show ipv6 route` on R3 | `S ::/0` entry via `2001:DB8:0:23::2` |
| 11 | R2 has two specific static routes | `show ipv6 route static` on R2 | `S 2001:DB8:0:1::/64` and `S 2001:DB8:0:3::/64` |
| 12 | End-to-end — R1-PC-A pings R3-PC-A | `ping 2001:db8:0:3::10` from R1-PC-A | All replies received |

---

## Connectivity Test

From R1-PC-A (`2001:db8:0:1::10`), ping R3-PC-A (`2001:db8:0:3::10`). This tests the complete path: R1 LAN → R1 WAN interface → R2 → R3 WAN interface → R3 LAN. Both directions must succeed.

Also ping from R1 itself using the source interface to verify the return path uses R2's static route correctly:

```
ping 2001:db8:0:3::10 source FastEthernet0/0
```

A successful ping using `source Fa0/0` confirms that R2's static route to `2001:db8:0:1::/64` is working — R3 sends the reply to that prefix and R2 forwards it back to R1.
