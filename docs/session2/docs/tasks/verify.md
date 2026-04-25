# Verification

Complete all checks below before marking the lab finished.

---

## Switch verification (both SW1 and SW2)

### VLAN table

```ios
show vlan-switch brief
```

- [ ] VLANs 10 and 11 appear as `active`
- [ ] `f1/0` is listed under VLAN 10
- [ ] `f1/1` is listed under VLAN 11

### Trunk status

```ios
show interfaces FastEthernet 1/15 trunk
```

- [ ] Status shows `trunking`
- [ ] Encapsulation shows `802.1q`
- [ ] VLANs 10 and 11 appear in the allowed and forwarding columns

### Access port mode

```ios
show interfaces FastEthernet 1/0 switchport
show interfaces FastEthernet 1/1 switchport
```

- [ ] Both ports show `Administrative Mode: static access`
- [ ] Correct VLAN assigned to each

---

## Routing verification (R1 only)

### Routing table

```ios
show ip route
```

- [ ] Connected route for `192.168.10.0/24` via `Vlan10`
- [ ] Connected route for `192.168.11.0/24` via `Vlan11`

### SVI status

```ios
show interfaces Vlan10
show interfaces Vlan11
```

- [ ] Both SVIs show `line protocol is up`

---

## End-to-end connectivity (from PC nodes)

Configure static IPs on each PC before running pings.

| Test | Command | Expected |
|---|---|---|
| PC1 → gateway | `ping 192.168.10.1` | Success |
| PC2 → gateway | `ping 192.168.11.1` | Success |
| PC1 → PC3 (same VLAN, across trunk) | `ping 192.168.10.20` | Success |
| PC1 → PC2 (inter-VLAN via R1) | `ping 192.168.11.10` | Success |
| PC3 → PC4 (inter-VLAN via R1) | `ping 192.168.11.20` | Success |

- [ ] All five ping tests succeed

---

!!! warning "Inter-VLAN pings failing?"
    1. Confirm `ip routing` is enabled on R1 — `show running-config | include ip routing`
    2. Check that both SVIs (`interface Vlan10`, `interface Vlan11`) are up — `show interfaces Vlan10`
    3. An SVI only comes up if at least one active port exists in that VLAN — confirm access port assignments
    4. Confirm the trunk is active on both switches before testing

!!! success "Lab complete"
    All verification checks passed — well done!
