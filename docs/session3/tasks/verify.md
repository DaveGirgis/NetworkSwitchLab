# Verification

Run these commands on each switch to confirm all objectives are complete before ending the session:

```cisco
! Confirm root bridge roles per VLAN
show spanning-tree vlan 10
show spanning-tree vlan 11

! Confirm all port roles and states in detail
show spanning-tree detail

! Confirm trunk links and allowed VLANs
show interfaces trunk

! Confirm VLAN database
show vlan brief

! Confirm PortFast and BPDU Guard status
show spanning-tree summary

! Check for any err-disabled ports
show interfaces status err-disabled
```

---

## Full Final Configurations

### SW1 — Final Config

```cisco
hostname SW1
no ip domain-lookup
ip routing
!
spanning-tree mode pvst
spanning-tree vlan 10 priority 0
spanning-tree vlan 11 priority 4096
!
interface FastEthernet1/0
 description TRUNK_TO_SW2
 switchport mode trunk
 no shutdown
!
interface FastEthernet1/1
 description TRUNK_TO_SW3
 switchport mode trunk
 no shutdown
!
interface FastEthernet1/2
 description TRUNK_TO_SW4
 switchport mode trunk
 no shutdown
!
interface range FastEthernet1/3 - 15
 shutdown
!
interface vlan 10
 ip address 192.168.10.1 255.255.255.0
 no shutdown
!
interface vlan 11
 ip address 192.168.11.1 255.255.255.0
 no shutdown
!
end
```

!!! note "VLANs in vlan.dat"
    The `vlan database` entries for VLAN 10 (SALES) and VLAN 11 (ENGINEERING) are stored in `vlan.dat` and will not appear in `show running-config`. Verify with `show vlan brief`.

### SW2 — Final Config

```cisco
hostname SW2
no ip domain-lookup
!
spanning-tree mode pvst
spanning-tree vlan 10 priority 4096
spanning-tree vlan 11 priority 0
!
interface FastEthernet1/0
 description TRUNK_TO_SW1
 switchport mode trunk
 no shutdown
!
interface FastEthernet1/1
 description TRUNK_TO_SW3
 switchport mode trunk
 no shutdown
!
interface FastEthernet1/2
 description TRUNK_TO_SW4
 switchport mode trunk
 no shutdown
!
interface range FastEthernet1/3 - 9
 shutdown
!
interface FastEthernet1/10
 description ACCESS_PC-A_VLAN10
 switchport mode access
 switchport access vlan 10
 spanning-tree portfast
 spanning-tree bpduguard enable
 no shutdown
!
interface FastEthernet1/11
 description ACCESS_PC-B_VLAN11
 switchport mode access
 switchport access vlan 11
 spanning-tree portfast
 spanning-tree bpduguard enable
 no shutdown
!
interface range FastEthernet1/12 - 15
 shutdown
!
end
```

### SW3 — Final Config

```cisco
hostname SW3
no ip domain-lookup
!
spanning-tree mode pvst
!
interface FastEthernet1/0
 description TRUNK_TO_SW1
 switchport mode trunk
 no shutdown
!
interface FastEthernet1/1
 description TRUNK_TO_SW4
 switchport mode trunk
 no shutdown
!
interface FastEthernet1/2
 description TRUNK_TO_SW2
 switchport mode trunk
 no shutdown
!
interface range FastEthernet1/3 - 9
 shutdown
!
interface FastEthernet1/10
 description ACCESS_PC-A_VLAN10
 switchport mode access
 switchport access vlan 10
 spanning-tree portfast
 spanning-tree bpduguard enable
 no shutdown
!
interface FastEthernet1/11
 description ACCESS_PC-B_VLAN11
 switchport mode access
 switchport access vlan 11
 spanning-tree portfast
 spanning-tree bpduguard enable
 no shutdown
!
interface range FastEthernet1/12 - 15
 shutdown
!
end
```

### SW4 — Final Config

```cisco
hostname SW4
no ip domain-lookup
!
spanning-tree mode pvst
!
interface FastEthernet1/0
 description TRUNK_TO_SW1
 switchport mode trunk
 no shutdown
!
interface FastEthernet1/1
 description TRUNK_TO_SW2
 switchport mode trunk
 no shutdown
!
interface FastEthernet1/2
 description TRUNK_TO_SW3
 switchport mode trunk
 no shutdown
!
interface range FastEthernet1/3 - 9
 shutdown
!
interface FastEthernet1/10
 description ACCESS_PC-A_VLAN10
 switchport mode access
 switchport access vlan 10
 spanning-tree portfast
 spanning-tree bpduguard enable
 no shutdown
!
interface FastEthernet1/11
 description ACCESS_PC-B_VLAN11
 switchport mode access
 switchport access vlan 11
 spanning-tree portfast
 spanning-tree bpduguard enable
 no shutdown
!
interface range FastEthernet1/12 - 15
 shutdown
!
end
```

---

## Lab Completion Checklist

- [ ] VLANs 10 and 11 created via `vlan database` on all switches
- [ ] All six inter-switch trunk links verified as active
- [ ] VLANs 10 and 11 confirmed active with `show vlan brief` on all switches
- [ ] Natural root bridge election winner identified and explained
- [ ] Port roles (root, designated, alternate/blocked) mapped for all four switches
- [ ] Active loop-free topology drawn on whiteboard with blocked ports marked
- [ ] Live ping baseline established between VLAN 10 PCs
- [ ] SW1 forced to root for VLAN 10 and VLAN 11 with priority 0
- [ ] SW2 configured as secondary root with priority 4096
- [ ] Topology re-mapped after root change and compared to natural election
- [ ] Root failure simulated — reconvergence time recorded
- [ ] SW1 restored and second reconvergence observed
- [ ] PVST+ configured: SW1 root for VLAN 10, SW2 root for VLAN 11
- [ ] Different blocked ports confirmed for VLAN 10 vs. VLAN 11
- [ ] VLAN 10 and VLAN 11 reachability verified from all PC hosts
- [ ] PortFast enabled on all PC-facing access ports (SW2, SW3, SW4)
- [ ] BPDU Guard enabled on all PC-facing access ports (SW2, SW3, SW4)
- [ ] BPDU Guard err-disabled state triggered and observed in syslog
- [ ] err-disabled port recovered with shutdown / no shutdown
- [ ] All final configs saved with `write memory` on all switches

---

*Session 3 of 8 — Next: Session 4: Static Routing & Route Summarization*
