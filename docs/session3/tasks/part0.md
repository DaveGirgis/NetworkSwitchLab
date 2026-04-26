# Part 0 — Base Configuration

Apply these configs to each switch before beginning lab tasks.

!!! note "3725 VLAN Configuration"
    The Cisco 3725 uses the legacy `vlan database` method to create VLANs rather than the `vlan <id>` global config command used on newer platforms. VLANs must be created in VLAN database mode **before** they can be assigned to ports. Exit VLAN database mode with `apply` and `exit` — not `end`.

---

## Step 1 — Create VLANs (All Switches)

Run this on **SW1, SW2, SW3, and SW4** before applying any other configuration:

```cisco
vlan database
 vlan 10 name SALES
 vlan 11 name ENGINEERING
apply
exit
```

Verify VLANs exist before proceeding:

```cisco
show vlan brief
```

Both VLANs should appear as `active`. If they do not appear, the port assignments in the base configs below will silently fail.

---

## Step 2 — Apply Base Configurations

### SW1 — Base Config

```cisco
enable
configure terminal

hostname SW1
no ip domain-lookup
ip routing
spanning-tree mode pvst

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

### SW2 — Base Config

```cisco
enable
configure terminal

hostname SW2
no ip domain-lookup
spanning-tree mode pvst

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

### SW3 — Base Config

```cisco
enable
configure terminal

hostname SW3
no ip domain-lookup
spanning-tree mode pvst

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

### SW4 — Base Config

```cisco
enable
configure terminal

hostname SW4
no ip domain-lookup
spanning-tree mode pvst

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
