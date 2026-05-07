# Verification

Use the following checklist to confirm the session is complete. All items must pass. The final state of the lab has the BLOCK-ICMP-REPLY extended ACL in place — PC-B's ICMP echo-replies are intentionally blocked.

---

## Checklist

| # | Phase | Check | Command | Expected Result |
|---|-------|-------|---------|-----------------|
| 1 | Setup | VLAN 10 active with correct ports | `show vlan-switch brief` on R1 | VLAN 10 active; Fa1/0 and Fa1/1 assigned |
| 2 | Setup | SVI and WAN interfaces up | `show ip interface brief` on R1 | Vlan10 and Fa0/1 both up/up with correct IPs |
| 3 | Setup | WAN link reachable | `ping 203.0.113.2` from R1 | 5/5 success |
| 4 | Setup | Default route to R2 loopback works | `ping 198.51.100.1` from R1 | 5/5 success |
| 5 | ACL | VTY ACL present | `show ip access-lists 10` on R1 | ACL 10 with permit for 203.0.113.2 |
| 6 | ACL | NAT permit ACL present | `show ip access-lists 1` on R1 | ACL 1 with permits for both 192.168.10.10 and 192.168.10.20 |
| 7 | NAT | Interfaces marked inside/outside | `show ip nat statistics` on R1 | Inside interface: Vlan10; outside interface: Fa0/1 |
| 8 | NAT | PC-A can reach internet | `ping 198.51.100.1` from PC-A | 5/5 success |
| 9 | NAT | PC-B can reach internet | `ping 198.51.100.1` from PC-B | Times out — expected (ICMP reply blocked by ACL) |
| 10 | NAT | NAT translations exist for both hosts | `show ip nat translations` on R1 | Entries for 192.168.10.10 and 192.168.10.20 |
| 11 | ACL | BLOCK-ICMP-REPLY deny counter active | `show ip access-lists BLOCK-ICMP-REPLY` on R1 | Deny line shows match count > 0 |
| 12 | ACL | PC-A unaffected by extended ACL | `ping 198.51.100.1` from PC-A (repeat) | 5/5 success — no regression |

---

## Final Connectivity Summary

From R1-PC-A (`192.168.10.10`):

```
ping 198.51.100.1    ! R2 loopback — success (NAT + no ICMP block)
```

From R1-PC-B (`192.168.10.20`):

```
ping 198.51.100.1    ! Times out — NAT translation exists but echo-reply is dropped by BLOCK-ICMP-REPLY
```

From R2 (for VTY verification):

```
telnet 203.0.113.1   ! R1 VTY — success (203.0.113.2 permitted by ACL 10)
```

---

## Understanding the Final State

The lab ends with two simultaneous ACL policies active on R1:

1. **ACL 10 on VTY** — Only R2 can manage R1 via Telnet. Any other source is blocked by the implicit deny.

2. **BLOCK-ICMP-REPLY on Vlan10 outbound** — PC-B can initiate ping sessions (echo requests leave R1 and reach R2), but echo-replies are dropped before they arrive at PC-B. PC-A is unaffected.

This demonstrates a key real-world use case: ACLs can enforce asymmetric traffic policies — permitting a host to send traffic while selectively blocking the return.
