# Troubleshooting

## OSPF neighbors do not appear in `show ip ospf neighbor`

**Symptom:** After configuring OSPF on both routers, `show ip ospf neighbor` returns no output.  
**Cause 1:** The `network` statement does not match the WAN interface address. Check the address and wildcard.  
**Cause 2:** The OSPF area numbers do not match on both ends of the link (e.g., one says `area 0`, the other says `area 1`).  
**Cause 3:** The interface is administratively down — OSPF cannot form a neighbor on a down interface.  
**Cause 4:** Hello/Dead timer mismatch — if one side has been manually tuned and the other has defaults, adjacency will not form.  
**Fix:** Verify both sides:

```
show ip ospf interface FastEthernet0/1
show running-config | section router ospf
```

Confirm the area matches on both routers and the interface is up/up.

---

## OSPF neighbor shows `INIT` or `2WAY` but never reaches `FULL`

**Symptom:** `show ip ospf neighbor` shows a neighbor stuck in `INIT` or `2WAY` state.  
**Cause:** `INIT` means Hello packets are being received but the router's own ID is not in them — usually a misconfigured network statement. `2WAY` is normal on broadcast segments between non-DR/BDR routers but should not persist on a `/30` point-to-point link.  
**Fix:** Verify the `network` statement covers both ends of the WAN link:

```
show ip ospf interface FastEthernet0/1
show running-config | section router ospf
```

---

## OSPF neighbors are FULL but routing table has no `O` entries

**Symptom:** `show ip ospf neighbor` shows FULL adjacencies, but `show ip route ospf` is empty.  
**Cause:** The remote network is not being advertised. The `network` statement on the remote router may be missing or have the wrong wildcard.  
**Fix:** On each remote router, verify what networks OSPF is advertising:

```
show ip ospf database
show running-config | section router ospf
```

Confirm `network` statements exist for all LAN and WAN interfaces on every router.

---

## EIGRP neighbors do not appear after configuration

**Symptom:** `show ip eigrp neighbors` is empty after configuring EIGRP on both routers.  
**Cause 1:** AS number mismatch — if R1 uses `router eigrp 100` and R2 uses `router eigrp 200`, no neighbor relationship will form. No error is displayed.  
**Cause 2:** `network` statement does not include the WAN interface.  
**Cause 3:** The interface is passive — EIGRP Hellos are suppressed on passive interfaces.  
**Fix:** Check the AS number and network statement on both routers:

```
show running-config | section router eigrp
show ip eigrp interfaces
```

Confirm AS numbers match and the WAN interface is not listed as passive.

---

## Routes are missing from EIGRP routing table after neighbors form

**Symptom:** EIGRP neighbors are present but `show ip route eigrp` is missing some routes.  
**Cause:** `auto-summary` is enabled (missing `no auto-summary`). EIGRP is summarizing `192.168.1.0/24`, `192.168.2.0/24`, and `192.168.3.0/24` into `192.168.0.0/8` and discarding the individual subnets.  
**Fix:** Add `no auto-summary` to the EIGRP process on all routers:

```
router eigrp 100
 no auto-summary
```

---

## End-to-end ping fails after switching from OSPF to EIGRP

**Symptom:** Pings worked under OSPF but fail after removing OSPF and enabling EIGRP.  
**Cause 1:** OSPF was removed but EIGRP neighbors have not yet formed. Wait 15–30 seconds for Hello exchange and route propagation.  
**Cause 2:** EIGRP `network` statement is missing on one router, so that router's LAN is not advertised.  
**Fix:** Step through the path systematically:

```
! On R1
show ip eigrp neighbors        ! Both neighbors present?
show ip route eigrp             ! All remote networks visible?
ping 10.0.12.2                  ! WAN link to R2 reachable?
ping 192.168.2.1                ! R2 loopback reachable?
ping 192.168.3.1                ! R3 gateway reachable?
ping 192.168.3.10               ! R3-PC-A reachable?
```

The first ping that fails identifies the broken hop.

---

## PC cannot ping its local gateway after routing is configured

**Symptom:** Dynamic routing is working between routers, but a PC cannot ping its directly connected gateway.  
**Cause:** The gateway interface (`Fa0/0`) is configured as `passive-interface` for OSPF or EIGRP but the interface itself is down or the PC's default gateway is wrong. The passive-interface setting does not affect whether the router forwards packets — it only suppresses routing protocol Hellos.  
**Fix:**

```
show ip interface brief              ! Is Fa0/0 up/up?
show running-config | section Fa0/0  ! Is IP address correct?
```

Verify the PC's gateway address exactly matches the router's Fa0/0 IP.
