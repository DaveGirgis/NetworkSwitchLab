# Task 2 — VLAN Creation and Access Ports

**Apply on both R1 (SW1) and SW2 unless noted.**

---

## Objective

Create VLANs 10 and 11 on both switches and assign the correct access ports.

## Steps

### 1. Create VLANs

!!! warning "NM-16ESW syntax"
    VLANs must be created in `vlan database` mode on the NM-16ESW — the standard `conf t → vlan 10` Catalyst syntax will **not** work here.

```ios
vlan database
 vlan 10 name VLAN10
 vlan 11 name VLAN11
exit
```

### 2. Assign access ports

```ios
configure terminal
!
interface FastEthernet 1/0
 switchport mode access
 switchport access vlan 10
 no shutdown
!
interface FastEthernet 1/1
 switchport mode access
 switchport access vlan 11
 no shutdown
!
end
```

### 3. Save

```ios
copy running-config startup-config
```

## Verification

```ios
show vlan-switch brief
```

Expected output (abbreviated):

```
VLAN Name                             Status    Ports
---- -------------------------------- --------- -------------------------------
1    default                          active    ...
10   VLAN10                           active    Fa1/0
11   VLAN11                           active    Fa1/1
```

```ios
show interfaces FastEthernet 1/0 switchport
show interfaces FastEthernet 1/1 switchport
```

Confirm `Administrative Mode: static access` and the correct VLAN assignment for each port.

!!! success "Task complete"
    VLANs 10 and 11 exist on both switches and their access ports are correctly assigned.
