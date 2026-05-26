# Troubleshooting

This page is the post-lab answer key. Read it after you have attempted to find and fix all three faults on your own, or use it to check your reasoning after completing verification.

---

### Fault 1 — One right-site host cannot reach the gateway

**Symptom:** PC-E (172.16.40.10) cannot ping 172.16.40.1 or any other address. All other hosts at the right site work normally. `show ip interface brief` on R3 shows Vlan40 as down/down.

**Cause:** The NM-16ESW access port connected to PC-E (Fa1/4) is assigned to VLAN 1 instead of VLAN 40. Because no active port is a member of VLAN 40, the SVI (`interface Vlan40`) has no reason to come up. PC-E's traffic reaches the switch fabric but is placed into VLAN 1, where there is no SVI and no gateway.

**Diagnosis:**
```
show vlan-switch brief
```

Fa1/4 will appear under VLAN 1 instead of VLAN 40.

**Fix:**
```
enable
configure terminal
interface Fa1/4
switchport access vlan 40
```

After applying this, Vlan40 will come up within a few seconds and PC-E will be able to reach 172.16.40.1.

---

### Fault 2 — Left-site cannot reach right-site at all

**Symptom:** Pings from PC-A, PC-B, or PC-C to any right-site address fail. Pings from left-site hosts to R2 (10.1.12.2) succeed. `show ip route ospf` on R1 shows no routes to 172.16.30.0/24 or 172.16.40.0/24.

**Cause:** The OSPF `network` statement for R2's Fa0/1 interface (10.1.23.0/30) is missing from R2's OSPF configuration. Because this interface is not included in OSPF, R2 does not form an OSPF adjacency with R3. Without a neighbor, R2 learns no routes from R3 and cannot advertise R3's networks to R1.

**Diagnosis:**
```
show ip ospf neighbor
```

Run on R2 — only one neighbor appears (R1). R3 is absent.

```
show running-config | section ospf
```

Run on R2 — the `network 10.1.23.0 0.0.0.3 area 0` line is missing.

**Fix:**
```
enable
configure terminal
router ospf 1
network 10.1.23.0 0.0.0.3 area 0
```

After applying this, R2 will form an OSPF adjacency with R3. Allow 30–60 seconds for the neighbor to reach FULL state and for routes to propagate. Confirm with `show ip ospf neighbor` on R2 and `show ip route ospf` on R1.

---

### Fault 3 — Some right-site destinations reachable, others not

**Symptom:** Pings from left-site hosts (PC-A, PC-B, PC-C) to PC-D (172.16.30.10) succeed. Pings from the same hosts to PC-E (172.16.40.10) fail — consistently. The routing table on all routers is correct.

**Cause:** The ACL `CROSS-SITE` on R2, applied outbound on Fa0/1, contains a permit statement for destination 172.16.30.0/24 (VLAN 30) but is missing the permit for destination 172.16.40.0/24 (VLAN 40). Traffic toward VLAN 40 hits the implicit deny at the end of the ACL and is dropped.

The routing table being correct is a key diagnostic signal — when routes exist but connectivity is still broken in a consistent, destination-specific pattern, the fault is almost always an ACL.

**Diagnosis:**
```
show ip access-lists CROSS-SITE
```

Run on R2 — a permit statement for 172.16.40.0 is absent. The implicit deny has match counts for traffic toward 172.16.40.0/24.

```
show ip interface Fa0/1
```

Run on R2 — confirms `CROSS-SITE` is applied outbound on Fa0/1.

**Fix:**
```
enable
configure terminal
ip access-list extended CROSS-SITE
permit ip 172.16.0.0 0.0.255.255 172.16.40.0 0.0.0.255
```

This adds a permit covering all left-site traffic destined for the VLAN 40 subnet. Alternatively, if the intent is to permit all inter-site traffic broadly, the existing permit for VLAN 30 can be replaced with a single entry covering the full 172.16.0.0/16 range. Confirm the fix with `ping 172.16.40.10` from PC-A.
