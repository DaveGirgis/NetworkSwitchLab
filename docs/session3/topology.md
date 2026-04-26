# Topology

## Diagram

```
        SW1 (Fa1/0)----------(Fa1/0) SW2
         |    \                /    |
      Fa1/1   Fa1/2        Fa1/1   Fa1/2
         |       \          /       |
        SW3    (Fa1/2)  (Fa1/2)   SW4
      (Fa1/0)                   (Fa1/0)
         |    SW3(Fa1/1)--SW4(Fa1/1)   |
      Fa1/10                        Fa1/10
      Fa1/11                        Fa1/11
     [PC-A]                        [PC-A]
     [PC-B]                        [PC-B]
```

---

## Inter-Switch Links

| Link | Switch A | Port | Switch B | Port |
|------|----------|------|----------|------|
| SW1 — SW2 | SW1 | Fa1/0 | SW2 | Fa1/0 |
| SW1 — SW3 | SW1 | Fa1/1 | SW3 | Fa1/0 |
| SW1 — SW4 | SW1 | Fa1/2 | SW4 | Fa1/0 |
| SW2 — SW3 | SW2 | Fa1/1 | SW3 | Fa1/2 |
| SW2 — SW4 | SW2 | Fa1/2 | SW4 | Fa1/1 |
| SW3 — SW4 | SW3 | Fa1/1 | SW4 | Fa1/2 |

---

## Access Port Assignments

| Switch | Port | VLAN | Device |
|--------|------|------|--------|
| SW2 | Fa1/10 | 10 | SW2-PC-A |
| SW2 | Fa1/11 | 11 | SW2-PC-B |
| SW3 | Fa1/10 | 10 | SW3-PC-A |
| SW3 | Fa1/11 | 11 | SW3-PC-B |
| SW4 | Fa1/10 | 10 | SW4-PC-A |
| SW4 | Fa1/11 | 11 | SW4-PC-B |

!!! note "GNS3 Setup"
    Each 3725 requires an **NM-16ESW** module in slot 1. Interfaces appear as `FastEthernet1/0` through `FastEthernet1/15`. Connect all six inter-switch links **before** powering on devices so STP observes the full topology during initial convergence.
