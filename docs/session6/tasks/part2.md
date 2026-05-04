# Part 2 — OSPF Configuration

**Objective:** Enable OSPF single area (Area 0) on all three routers, set router IDs, advertise all connected networks, and suppress OSPF Hello packets on LAN-facing interfaces.

---

## Task 2.1 — Configure OSPF on R1

```
router ospf 1
 router-id 1.1.1.1
 passive-interface FastEthernet0/0
 network 192.168.1.0 0.0.0.255 area 0
 network 10.0.12.0 0.0.0.3 area 0
```

---

## Task 2.2 — Configure OSPF on R2

```
router ospf 1
 router-id 2.2.2.2
 passive-interface Loopback0
 network 192.168.2.0 0.0.0.255 area 0
 network 10.0.12.0 0.0.0.3 area 0
 network 10.0.23.0 0.0.0.3 area 0
```

---

## Task 2.3 — Configure OSPF on R3

```
router ospf 1
 router-id 3.3.3.3
 passive-interface FastEthernet0/0
 network 192.168.3.0 0.0.0.255 area 0
 network 10.0.23.0 0.0.0.3 area 0
```

---

## Understanding the Configuration

### Router ID

The router ID uniquely identifies each OSPF router in the area. If not set manually, IOS selects the highest IP address on any loopback interface, or failing that, the highest IP address on any active interface at the time OSPF starts. Setting it manually with `router-id` avoids surprises if interfaces change state.

### Wildcard Mask

A wildcard mask is the bitwise inverse of a subnet mask. Bits set to `0` must match; bits set to `1` are ignored.

| Prefix | Subnet Mask | Wildcard Mask |
|--------|-------------|---------------|
| /24 | 255.255.255.0 | 0.0.0.255 |
| /30 | 255.255.255.252 | 0.0.0.3 |

The `network` statement matches any interface whose IP address falls within the specified range and places it into the stated OSPF area.

### Passive Interface

`passive-interface` tells OSPF to advertise the connected network for that interface but suppress Hello packets on it. This prevents OSPF from wasting time searching for neighbors on interfaces where no OSPF router will ever exist — like a LAN connected to a PC.

> [!NOTE]
> After configuring OSPF, you should see console messages similar to:
> `%OSPF-5-ADJCHG: Process 1, Nbr 2.2.2.2 on FastEthernet0/1 from LOADING to FULL`
>
> This confirms a neighbor adjacency has reached the FULL state, meaning the link-state databases are synchronized and routing can begin. Proceed to Part 3 to verify the full state of OSPF.
