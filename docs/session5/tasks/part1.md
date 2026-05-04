# Part 1 — LAN Interfaces

**Objective:** Assign IPv6 addresses to the LAN interfaces on R1 and R3, configure the host PCs, and verify that each PC can reach its local gateway before inter-site routing is configured.

---

## Task 1.1 — Configure the R1 LAN Interface

R1's `Fa0/0` connects to R1-PC-A. Assign the gateway address for the R1 LAN segment.

```
interface FastEthernet0/0
 ipv6 address 2001:db8:0:1::1/64
 no shutdown
```

Verify the interface came up with the correct address:

```
show ipv6 interface FastEthernet0/0
```

You will see two addresses listed — the global unicast address you just configured (`2001:db8:0:1::1`) and an automatically generated link-local address beginning with `fe80::`. Both are normal. Only the global unicast address is used for routing.

---

## Task 1.2 — Configure the R3 LAN Interface

R3's `Fa0/0` connects to R3-PC-A.

```
interface FastEthernet0/0
 ipv6 address 2001:db8:0:3::1/64
 no shutdown
```

Verify:

```
show ipv6 interface FastEthernet0/0
```

---

## Task 1.3 — Configure R1-PC-A

Assign a static IPv6 address and default gateway to the PC on R1's LAN. Use VPCS syntax if running VPCS, or configure a router loopback if simulating a host with a router.

**VPCS:**

```
ip 2001:db8:0:1::10/64 2001:db8:0:1::1
```

**Router loopback (if simulating PC with a router):**

```
interface Loopback0
 ipv6 address 2001:db8:0:1::10/64
```

> [!NOTE]
> VPCS supports IPv6 with the `ip` command followed by the address/prefix and gateway. The gateway must be the router's global unicast address, not its link-local address.

---

## Task 1.4 — Configure R3-PC-A

```
ip 2001:db8:0:3::10/64 2001:db8:0:3::1
```

---

## Task 1.5 — Verify Local Gateway Reachability

From R1-PC-A, ping the R1 gateway:

```
ping 2001:db8:0:1::1
```

From R3-PC-A, ping the R3 gateway:

```
ping 2001:db8:0:3::1
```

Both pings should succeed. If either fails, check that:
- The router interface has `no shutdown` and the IPv6 address is correct (`show ipv6 interface Fa0/0`)
- The PC address and prefix length are correct
- `ipv6 unicast-routing` is configured on the router (Part 0, Task 0.2)

> [!WARNING]
> Do not proceed to Part 2 until both local pings succeed. If a PC cannot reach its own gateway, the WAN configuration in Part 2 and routes in Part 3 will appear broken even when configured correctly.
