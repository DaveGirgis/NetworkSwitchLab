# Part 2 — Control Root Bridge Placement

**Objective:** Override the natural election and force SW1 to become the primary root for both VLANs, with SW2 as the designated secondary.

---

## Task 2.1 — Set SW1 as Primary Root

```cisco
! On SW1
configure terminal
spanning-tree vlan 10 priority 0
spanning-tree vlan 11 priority 0
end
write memory
```

!!! info "Priority Values"
    STP bridge priority must be a multiple of 4096. Valid values range from `0` to `61440`. The default is `32768`. Setting `0` guarantees SW1 wins the election for a given VLAN regardless of MAC address.

Wait 30–50 seconds for STP to reconverge, then verify on SW1:

```cisco
show spanning-tree vlan 10
show spanning-tree vlan 11
```

Both should show:

```
This bridge is the root
Bridge ID  Priority    10  (priority 0 sys-id-ext 10)
```

---

## Task 2.2 — Set SW2 as Secondary Root

```cisco
! On SW2
configure terminal
spanning-tree vlan 10 priority 4096
spanning-tree vlan 11 priority 4096
end
write memory
```

Verify:

```cisco
! On SW2
show spanning-tree vlan 10
```

Bridge ID Priority should show `4106  (priority 4096 sys-id-ext 10)`.

---

## Task 2.3 — Re-map the Active Topology

Repeat Task 1.4 with the new root placement and update your whiteboard diagram.

**Discussion questions:**

- Which ports changed state after forcing SW1 to root?
- How does placing the root bridge at a central uplink switch affect path efficiency for downstream switches?
- What would happen in a real network if the root bridge were placed on an access layer switch by accident?

---

## Task 2.4 — Simulate Root Bridge Failure

With the continuous ping still running, shut all trunk ports on SW1:

```cisco
! On SW1
configure terminal
interface range FastEthernet1/0 - 2
 shutdown
end
```

Observe the ping output and record:

- How many replies were lost?
- How many seconds until recovery?
- Which switch became the new root?

```cisco
! On SW2 — confirm it is now root
show spanning-tree vlan 10
```

Restore SW1 and observe the second reconvergence:

```cisco
! On SW1
configure terminal
interface range FastEthernet1/0 - 2
 no shutdown
end
write memory
```

!!! note "Classic STP Convergence Time"
    Classic 802.1D STP takes 30–50 seconds to converge: 15 seconds Listening + 15 seconds Learning before a port transitions to Forwarding. This is a primary motivation for Rapid STP (802.1w), which converges in 1–2 seconds using a proposal/agreement mechanism between neighbors rather than fixed timers.
