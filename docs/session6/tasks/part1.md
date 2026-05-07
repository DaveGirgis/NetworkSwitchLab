# Part 1 — Interface Addressing

**Objective:** Assign IPv4 addresses to all LAN interfaces, WAN interfaces, and R2's loopback. Configure PCs and verify local reachability before any routing protocol is started.

---

## Task 1.1 — Configure R1 Interfaces

```
interface FastEthernet0/0
 ip address 192.168.1.1 255.255.255.0
 no shutdown
interface FastEthernet0/1
 ip address 10.0.12.1 255.255.255.252
 no shutdown
```

---

## Task 1.2 — Configure R2 Interfaces

R2 uses a loopback interface to simulate a LAN network. Loopback interfaces are always up and never go down, making them ideal for representing a stable, reachable network in routing protocol labs.

```
interface FastEthernet0/0
 ip address 10.0.12.2 255.255.255.252
 no shutdown
interface FastEthernet0/1
 ip address 10.0.23.2 255.255.255.248
 no shutdown
interface Loopback0
 ip address 192.168.2.1 255.255.255.0
```

> [!NOTE]
> `192.168.2.0/24` will be advertised by OSPF and EIGRP as a directly connected network on R2. End-to-end pings to `192.168.2.1` from either PC confirm that the routing protocol is working correctly.

---

## Task 1.3 — Configure R3 Interfaces

```
interface FastEthernet0/1
 ip address 10.0.23.3 255.255.255.248
 no shutdown
interface FastEthernet0/0
 ip address 192.168.3.1 255.255.255.0
 no shutdown
```

---

## Task 1.4 — Configure R1-PC-A

**VPCS:**

```
ip 192.168.1.10 255.255.255.0 192.168.1.1
```

**Router loopback (if simulating with a router):**

```
interface Loopback0
 ip address 192.168.1.10 255.255.255.0
ip route 0.0.0.0 0.0.0.0 192.168.1.1
```

---

## Task 1.5 — Configure R3-PC-A

**VPCS:**

```
ip 192.168.3.10 255.255.255.0 192.168.3.1
```

**Router loopback (if simulating with a router):**

```
interface Loopback0
 ip address 192.168.3.10 255.255.255.0
ip route 0.0.0.0 0.0.0.0 192.168.3.1
```

---

## Task 1.6 — Verify Interface Addressing

Confirm all interfaces are up and correctly addressed before starting any routing protocol.

```
show ip interface brief
```

Expected output on R2:

```
FastEthernet0/0    10.0.12.2    YES manual up                  up
FastEthernet0/1    10.0.23.2    YES manual up                  up
Loopback0          192.168.2.1  YES manual up                  up
```

Then verify the WAN links at Layer 3:

**From R1:**
```
ping 10.0.12.2
```

**From R3:**
```
ping 10.0.23.2
```

Both should succeed. If either fails, check that both ends of the link share the same subnet and have `no shutdown`.

> [!WARNING]
> Do not proceed to Part 2 until all interface pings succeed. OSPF will not form neighbors if there is a Layer 3 reachability problem on the WAN link.

```
end
write memory
```

Repeat on all three routers before continuing to Part 2.
