# Part 1 — Observe Natural Root Bridge Election

**Objective:** Allow STP to elect a root bridge without any manual configuration. Identify and document the result before making any changes.

---

## Task 1.1 — Verify Trunk Links

Confirm all six inter-switch links are active on each switch:

```cisco
show interfaces trunk
```

All trunk ports should appear in the `trunking` state and show VLANs 10 and 11 in the allowed and active columns. If any port is missing, check cabling in GNS3 and verify `switchport mode trunk` is applied.

---

## Task 1.2 — Verify VLAN Database

Confirm VLANs 10 and 11 are present and active on all switches:

```cisco
show vlan brief
```

!!! warning "VLANs Not Showing?"
    On the 3725, VLANs created in `vlan database` mode are stored in `vlan.dat` — not in the running config. If VLANs are missing, return to VLAN database mode and re-enter them:

    ```cisco
    vlan database
     vlan 10 name SALES
     vlan 11 name ENGINEERING
    apply
    exit
    ```

---

## Task 1.3 — Identify the Root Bridge

Run the following on **each switch**:

```cisco
show spanning-tree vlan 10
```

The root bridge displays:

```
This bridge is the root
```

On non-root switches, note these fields:

| Field | Meaning |
|-------|---------|
| `Root ID Priority` | Root bridge priority — default 32768 + VLAN ID = 32778 for VLAN 10 |
| `Root ID Address` | Root bridge MAC — lowest MAC wins when priorities tie |
| `Root port` | Local port with the lowest cost path toward the root |
| `Cost` | Cumulative path cost to reach the root |

!!! tip "Why Did That Switch Win?"
    With all switches at default priority, the switch with the **lowest MAC address** wins the election. In GNS3, MAC addresses are assigned at startup — often the first device initialized wins. This is exactly why manual priority configuration matters in production.

---

## Task 1.4 — Map Port Roles Across All Switches

Using `show spanning-tree vlan 10` on each switch, complete the following table:

| Switch | Bridge Role | Root Port | Designated Ports | Blocked (Alternate) Ports |
|--------|-------------|-----------|-----------------|--------------------------|
| SW1 | | | | |
| SW2 | | | | |
| SW3 | | | | |
| SW4 | | | | |

Draw the active loop-free topology on the whiteboard. Mark blocked ports with an **X** and draw arrows on root ports pointing toward the root bridge.

---

## Task 1.5 — Establish a Live Ping Baseline

Configure SW2-PC-A and SW3-PC-A with addresses from the VLAN 10 table. From SW2-PC-A, start a continuous ping to SW3-PC-A:

```
ping 192.168.10.30 repeat 10000 timeout 1
```

Leave this running throughout Parts 2 and 3 to observe reconvergence behavior during topology changes.
