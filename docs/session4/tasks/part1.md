# Part 1 — LAN Configuration

**Objective:** Create VLANs on each router's NM-16ESW module, configure access ports, and bring up SVI interfaces so each LAN segment has a functioning default gateway.

---

## Task 1.1 — Create VLANs on R1

VLANs on the NM-16ESW are created in `vlan database` mode, not under `configure terminal`. R1 hosts VLAN 10.

```
vlan database
 vlan 10 name SALES
apply
exit
```

Verify with:

```
show vlan-switch brief
```

VLAN 10 should appear as active with no ports assigned yet.

> [!NOTE]
> VLANs are stored in `vlan.dat` on the NM-16ESW, not in `running-config`. If `show running-config` does not show the VLAN, that is expected — `show vlan-switch brief` is the correct verification command.

---

## Task 1.2 — Create VLANs on R2

R2 hosts VLAN 11.

```
vlan database
 vlan 11 name ENGINEERING
apply
exit
```

Verify with:

```
show vlan-switch brief
```

---

## Task 1.3 — Configure the Access Port on R1

Assign `Fa1/10` to VLAN 10. This is where R1-PC-A connects.

```
interface FastEthernet1/10
 switchport mode access
 switchport access vlan 10
```

---

## Task 1.4 — Configure the Access Port on R2

Assign `Fa1/11` to VLAN 11.

```
interface FastEthernet1/11
 switchport mode access
 switchport access vlan 11
```

---

## Task 1.5 — Configure the SVI on R1

A Switched Virtual Interface (SVI) is a logical Layer 3 interface bound to a VLAN. It serves as the default gateway for hosts in that VLAN. Configure the VLAN 10 SVI on R1.

```
interface Vlan10
 ip address 192.168.10.1 255.255.255.0
 no shutdown
```

Verify the SVI is up:

```
show interfaces Vlan10
```

The line protocol will only come up if at least one physical port assigned to VLAN 10 is active.

---

## Task 1.6 — Configure the SVI on R2

Configure the VLAN 11 SVI on R2.

```
interface Vlan11
 ip address 192.168.11.1 255.255.255.0
 no shutdown
```

Verify:

```
show interfaces Vlan11
```

---

## Task 1.7 — Configure R1-PC-A and R2-PC-A

Assign IP addresses to the host devices using VPCS or router loopbacks as appropriate.

**R1-PC-A:**

```
ip 192.168.10.10 255.255.255.0 192.168.10.1
```

**R2-PC-A:**

```
ip 192.168.11.10 255.255.255.0 192.168.11.1
```

Verify local gateway reachability before moving to Part 2. Each PC should be able to ping its default gateway.

**From R1-PC-A:**

```
ping 192.168.10.1
```

**From R2-PC-A:**

```
ping 192.168.11.1
```

> [!WARNING]
> Do not proceed to Part 2 until local pings succeed. If a host cannot reach its gateway, the static routes in Part 2 will appear to fail even when configured correctly.
