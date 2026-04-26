# Part 4 — PortFast and BPDU Guard

**Objective:** Configure safe STP behavior on access ports connected to end devices and verify protection against rogue switches.

---

## Task 4.1 — Enable PortFast on Access Ports

Apply to the PC-facing ports on SW2, SW3, and SW4:

```cisco
! On SW2
configure terminal
interface FastEthernet1/10
 spanning-tree portfast
interface FastEthernet1/11
 spanning-tree portfast
end
write memory
```

```cisco
! On SW3
configure terminal
interface FastEthernet1/10
 spanning-tree portfast
interface FastEthernet1/11
 spanning-tree portfast
end
write memory
```

```cisco
! On SW4
configure terminal
interface FastEthernet1/10
 spanning-tree portfast
interface FastEthernet1/11
 spanning-tree portfast
end
write memory
```

Observe the difference by bouncing an access port and watching the state transition:

```cisco
! On SW2
configure terminal
interface FastEthernet1/10
 shutdown
 no shutdown
end

show spanning-tree vlan 10 interface FastEthernet1/10
```

The port transitions directly to `FWD` without passing through `LIS` or `LRN` states.

!!! danger "PortFast Warning"
    **Never** enable PortFast on a port connected to another switch. PortFast skips STP's loop-detection delay entirely. A switch connected to a PortFast port can form a bridging loop before STP has a chance to detect and block it.

---

## Task 4.2 — Enable BPDU Guard

```cisco
! On SW2
configure terminal
interface FastEthernet1/10
 spanning-tree bpduguard enable
interface FastEthernet1/11
 spanning-tree bpduguard enable
end
write memory
```

```cisco
! On SW3
configure terminal
interface FastEthernet1/10
 spanning-tree bpduguard enable
interface FastEthernet1/11
 spanning-tree bpduguard enable
end
write memory
```

```cisco
! On SW4
configure terminal
interface FastEthernet1/10
 spanning-tree bpduguard enable
interface FastEthernet1/11
 spanning-tree bpduguard enable
end
write memory
```

---

## Task 4.3 — Test BPDU Guard Behavior

In GNS3, connect a fifth switch to SW2 Fa1/10. When the rogue device sends a BPDU the port immediately enters `err-disabled` state.

```cisco
! On SW2
show interfaces FastEthernet1/10 status
show spanning-tree inconsistentports
show log
```

Expected syslog output:

```
%SPANTREE-2-BLOCK_BPDUGUARD: Received BPDU on port FastEthernet1/10
 with BPDU Guard enabled. Disabling port.
%PM-4-ERR_DISABLE: bpduguard error detected on Fa1/10,
 putting Fa1/10 in err-disable state
```

---

## Task 4.4 — Recover an err-disabled Port

Remove the rogue device from GNS3, then manually re-enable the port:

```cisco
! On SW2
configure terminal
interface FastEthernet1/10
 shutdown
 no shutdown
end
write memory

show interfaces FastEthernet1/10 status
```

The port returns to `connected` status.

!!! tip "Automatic Recovery (Production Note)"
    In production, `errdisable recovery cause bpduguard` combined with `errdisable recovery interval 300` can automatically re-enable err-disabled ports after a timer. This is not recommended during initial troubleshooting — always investigate the root cause before re-enabling automatically.
