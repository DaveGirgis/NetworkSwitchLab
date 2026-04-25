# Task 3 — Trunk Port (f1/15)

**Apply on both R1 (SW1) and SW2.**

---

## Objective

Configure `f1/15` as an 802.1Q trunk on both switches, allowing only VLANs 10 and 11.

## Steps

### 1. Configure the trunk port

```ios
configure terminal
!
interface FastEthernet 1/15
 switchport trunk encapsulation dot1q
 switchport mode trunk
 switchport trunk allowed vlan 10,11
 no shutdown
!
end
```

!!! warning "Encapsulation before mode"
    On the NM-16ESW you must set `switchport trunk encapsulation dot1q` **before** `switchport mode trunk`. Reversing the order will produce an error.

### 2. Save

```ios
copy running-config startup-config
```

## Verification

```ios
show interfaces FastEthernet 1/15 trunk
```

Expected output:

```
Port      Mode         Encapsulation  Status        Native vlan
Fa1/15    on           802.1q         trunking      1

Port      Vlans allowed on trunk
Fa1/15    10-11

Port      Vlans allowed and active in management domain
Fa1/15    10-11

Port      Vlans in spanning tree forwarding state and not pruned
Fa1/15    10-11
```

!!! tip
    The trunk must show `trunking` in the Status column on **both** switches before moving to Task 4. If one side shows `not-trunking`, check that the trunk port is configured identically on the other device.

!!! success "Task complete"
    `f1/15` is an active 802.1Q trunk carrying VLANs 10 and 11 on both switches.
