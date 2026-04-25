# Task 4 — Inter-VLAN Routing on R1

**R1 only.**

---

## Objective

Configure R1 as the Layer 3 gateway for both VLANs using Switched Virtual Interfaces (SVIs). An SVI is a virtual Layer 3 interface tied directly to a VLAN — no subinterfaces or trunk dependency on a routed port required.

## Steps

### 1. Enable IP routing

```ios
configure terminal
ip routing
end
```

### 2. Create SVI for VLAN 10

```ios
configure terminal
!
interface Vlan10
 ip address 192.168.10.1 255.255.255.0
 no shutdown
!
end
```

### 3. Create SVI for VLAN 11

```ios
configure terminal
!
interface Vlan11
 ip address 192.168.11.1 255.255.255.0
 no shutdown
!
end
```

### 4. Save

```ios
copy running-config startup-config
```

## Verification

```ios
show ip route
```

Expected output (connected routes):

```
C    192.168.10.0/24 is directly connected, Vlan10
C    192.168.11.0/24 is directly connected, Vlan11
```

```ios
show interfaces Vlan10
show interfaces Vlan11
```

Both SVIs should show `line protocol is up`.

!!! info "How SVIs work"
    The SVI (`interface Vlan10`) acts as the Layer 3 presence for that VLAN on the switch fabric. Any port assigned to VLAN 10 can reach the gateway directly — no dedicated routed uplink needed. R1 routes between SVIs the same way it would route between any two directly connected networks.

!!! warning "SVI line protocol stays down?"
    An SVI only comes up if at least one physical port in that VLAN is active. If `interface Vlan10` shows `line protocol is down`, confirm that `f1/0` is assigned to VLAN 10 and is not shut down.

!!! success "Task complete"
    R1 has connected routes for both VLANs via SVIs and both interfaces are up/up.
