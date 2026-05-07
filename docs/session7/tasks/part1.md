# Part 1 — LAN & Interface Addressing

**Objective:** Build the VLAN 10 LAN on R1's NM-16ESW, assign IP addresses to all interfaces, configure PCs, add a default route on R1, and verify that the WAN link is reachable — including confirming that the PCs cannot reach the ISP server without NAT.

---

## Task 1.1 — Create VLAN 10 on R1

VLANs on the NM-16ESW are created in `vlan database` mode, not under `configure terminal`.

```
vlan database
 vlan 10 name CLIENTS
apply
exit
```

Verify VLAN 10 is active:

```
show vlan-switch brief
```

VLAN 10 should appear as active with no ports assigned yet.

---

## Task 1.2 — Configure Access Ports

Assign `Fa1/0` (PC-A) and `Fa1/1` (PC-B) to VLAN 10. Both hosts share the same VLAN and subnet.

```
interface FastEthernet1/0
 switchport mode access
 switchport access vlan 10
interface FastEthernet1/1
 switchport mode access
 switchport access vlan 10
```

> [!NOTE]
> NM-16ESW interfaces do not require `no shutdown` — they come up automatically when a GNS3 link is connected. Only the built-in router interfaces (`Fa0/x`) need explicit `no shutdown`.

---

## Task 1.3 — Configure the SVI (Inside NAT Interface)

The SVI `interface Vlan10` is R1's Layer 3 gateway for the LAN. This interface will later be marked as the NAT inside boundary.

```
interface Vlan10
 ip address 192.168.10.1 255.255.255.0
 no shutdown
```

---

## Task 1.4 — Configure R1 WAN Interface (Outside NAT Interface)

`Fa0/1` connects R1 to R2 over the simulated public WAN link. This interface will later be marked as the NAT outside boundary.

```
interface FastEthernet0/1
 ip address 203.0.113.1 255.255.255.252
 no shutdown
```

---

## Task 1.5 — Configure R2 Interfaces

R2 simulates an ISP router. Its loopback represents a reachable internet destination.

```
interface FastEthernet0/0
 ip address 203.0.113.2 255.255.255.252
 no shutdown
interface Loopback0
 ip address 198.51.100.1 255.255.255.255
```

> [!NOTE]
> Do **not** add a static route from R2 to `192.168.10.0/24`. A real ISP router would never have a route to your private address space. Leaving this route absent is what causes PC-B to fail in Part 3 when it is not included in the NAT permit list.

---

## Task 1.6 — Configure PCs

**PC-A:**

```
ip 192.168.10.10 255.255.255.0 192.168.10.1
```

**PC-B:**

```
ip 192.168.10.20 255.255.255.0 192.168.10.1
```

---

## Task 1.7 — Default Route on R1

R1 needs a default route to forward all non-local traffic toward R2.

```
ip route 0.0.0.0 0.0.0.0 203.0.113.2
```

---

## Task 1.8 — Verify and Save

Confirm R1's interfaces and routing before moving to ACL configuration.

```
show ip interface brief
```

Expected output on R1:

```
Vlan10            192.168.10.1    YES manual up                  up
FastEthernet0/1   203.0.113.1     YES manual up                  up
```

Verify WAN link reachability from R1:

```
ping 203.0.113.2
```

Verify the default route reaches R2's loopback:

```
ping 198.51.100.1
```

Both pings should succeed. R1 sources these pings from `203.0.113.1` (its outside address), so they work without NAT.

**Now test from the PCs:**

From PC-A:
```
ping 198.51.100.1
```

From PC-B:
```
ping 198.51.100.1
```

Both should time out. The PCs source their packets from `192.168.10.x` — RFC1918 addresses that R2 cannot route back to. This is the problem NAT solves in Part 3.

Save configuration on both routers:

```
end
write memory
```
