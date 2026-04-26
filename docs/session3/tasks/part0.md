# Part 0 — Base Configuration

Apply these configs to each switch before beginning lab tasks.

---

## SW1 — Base Config

```cisco
enable
configure terminal

hostname SW1
no ip domain-lookup
ip routing
spanning-tree mode pvst

! VLAN definitions
vlan 10
 name SALES
vlan 11
 name ENGINEERING

! Management SVIs — SW1 only
interface vlan 10
 ip address 192.168.10.1 255.255.255.0
 no shutdown

interface vlan 11
 ip address 192.168.11.1 255.255.255.0
 no shutdown

! Inter-switch trunk ports
interface FastEthernet1/0
 description TRUNK_TO_SW2
 switchport mode trunk
 no shutdown

interface FastEthernet1/1
 description TRUNK_TO_SW3
 switchport mode trunk
 no shutdown

interface FastEthernet1/2
 description TRUNK_TO_SW4
 switchport mode trunk
 no shutdown

! Unused ports — administratively down
interface range FastEthernet1/3 - 15
 shutdown

end
write memory
```

---

## SW2 — Base Config

```cisco
enable
configure terminal

hostname SW2
no ip domain-lookup
spanning-tree mode pvst

! VLAN definitions
vlan 10
 name SALES
vlan 11
 name ENGINEERING

! Inter-switch trunk ports
interface FastEthernet1/0
 description TRUNK_TO_SW1
 switchport mode trunk
 no shutdown

interface FastEthernet1/1
 description TRUNK_TO_SW3
 switchport mode trunk
 no shutdown

interface FastEthernet1/2
 description TRUNK_TO_SW4
 switchport mode trunk
 no shutdown

! Access ports for end devices
interface FastEthernet1/10
 description ACCESS_PC-A_VLAN10
 switchport mode access
 switchport access vlan 10
 no shutdown

interface FastEthernet1/11
 description ACCESS_PC-B_VLAN11
 switchport mode access
 switchport access vlan 11
 no shutdown

! Unused ports — administratively down
interface range FastEthernet1/3 - 9
 shutdown
interface range FastEthernet1/12 - 15
 shutdown

end
write memory
```

---

## SW3 — Base Config

```cisco
enable
configure terminal

hostname SW3
no ip domain-lookup
spanning-tree mode pvst

! VLAN definitions
vlan 10
 name SALES
vlan 11
 name ENGINEERING

! Inter-switch trunk ports
interface FastEthernet1/0
 description TRUNK_TO_SW1
 switchport mode trunk
 no shutdown

interface FastEthernet1/1
 description TRUNK_TO_SW4
 switchport mode trunk
 no shutdown

interface FastEthernet1/2
 description TRUNK_TO_SW2
 switchport mode trunk
 no shutdown

! Access ports for end devices
interface FastEthernet1/10
 description ACCESS_PC-A_VLAN10
 switchport mode access
 switchport access vlan 10
 no shutdown

interface FastEthernet1/11
 description ACCESS_PC-B_VLAN11
 switchport mode access
 switchport access vlan 11
 no shutdown

! Unused ports — administratively down
interface range FastEthernet1/3 - 9
 shutdown
interface range FastEthernet1/12 - 15
 shutdown

end
write memory
```

---

## SW4 — Base Config

```cisco
enable
configure terminal

hostname SW4
no ip domain-lookup
spanning-tree mode pvst

! VLAN definitions
vlan 10
 name SALES
vlan 11
 name ENGINEERING

! Inter-switch trunk ports
interface FastEthernet1/0
 description TRUNK_TO_SW1
 switchport mode trunk
 no shutdown

interface FastEthernet1/1
 description TRUNK_TO_SW2
 switchport mode trunk
 no shutdown

interface FastEthernet1/2
 description TRUNK_TO_SW3
 switchport mode trunk
 no shutdown

! Access ports for end devices
interface FastEthernet1/10
 description ACCESS_PC-A_VLAN10
 switchport mode access
 switchport access vlan 10
 no shutdown

interface FastEthernet1/11
 description ACCESS_PC-B_VLAN11
 switchport mode access
 switchport access vlan 11
 no shutdown

! Unused ports — administratively down
interface range FastEthernet1/3 - 9
 shutdown
interface range FastEthernet1/12 - 15
 shutdown

end
write memory
```
