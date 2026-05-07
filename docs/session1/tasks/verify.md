# Session 1 Verification

## Environment Checklist

Work through this checklist top to bottom. Every item must pass before moving on to Session 2. If any item fails, refer to the [Troubleshooting](../reference/troubleshooting.md) page.

---

### GNS3 Installation

| # | Test | Expected Result | Pass? |
|---|------|-----------------|-------|
| 1 | GNS3 launches without error dialogs | Application opens to blank canvas | ☐ |
| 2 | Bottom status bar shows green dot | "GNS3 server" label is green | ☐ |
| 3 | GNS3 version matches installer version | Version numbers match in status bar | ☐ |

---

### IOS Template

| # | Test | Expected Result | Pass? |
|---|------|-----------------|-------|
| 4 | Open Edit → Preferences → IOS Routers | 3725 template listed | ☐ |
| 5 | Template shows NM-16ESW in slot 1 | Visible in Edit → Network adapters tab | ☐ |
| 6 | RAM is set to 256 MB | Visible in Edit → Memory tab | ☐ |
| 7 | Idle-PC field is non-empty | A hex value such as `0x60c09aa0` is set | ☐ |

---

### Project Topology

| # | Test | Expected Result | Pass? |
|---|------|-----------------|-------|
| 8 | Project "Session1-Lab" exists | Visible in File → Recent projects | ☐ |
| 9 | Canvas shows R1 and PC-A nodes | Both icons visible | ☐ |
| 10 | Link connects R1 Fa0/0 to PC-A eth0 | One link with correct interface labels | ☐ |

---

### Device Operation

| # | Test | Expected Result | Pass? |
|---|------|-----------------|-------|
| 11 | Start all nodes — R1 boots | IOS banner appears in console, prompt reaches `R1>` | ☐ |
| 12 | Start all nodes — PC-A starts | VPCS prompt `PC-A>` appears immediately | ☐ |
| 13 | Link dots turn green after boot | Both ends of the R1 — PC-A link are green | ☐ |

---

### Configuration & Connectivity

| # | Test | Expected Result | Pass? |
|---|------|-----------------|-------|
| 14 | `R1# show interfaces Fa0/0` | `FastEthernet0/0 is up, line protocol is up` | ☐ |
| 15 | `R1# show interfaces Fa1/0` | NM-16ESW interface visible (may show administratively down) | ☐ |
| 16 | `PC-A> show ip` | IP `192.168.1.10/24`, gateway `192.168.1.1` | ☐ |
| 17 | `PC-A> ping 192.168.1.1` | 5 of 5 replies received | ☐ |

---

### Persistence

| # | Test | Expected Result | Pass? |
|---|------|-----------------|-------|
| 18 | `R1# copy running-config startup-config` | "OK" confirmation | ☐ |
| 19 | `PC-A> save` | "Saving..." confirmation | ☐ |
| 20 | Stop all nodes, reopen project, restart — configs persist | R1 interface still configured; PC-A IP retained | ☐ |

---

## Connectivity Test Output

Record your ping output here for reference:

```
PC-A> ping 192.168.1.1

84 bytes from 192.168.1.1 icmp_seq=1 ttl=255 time=___ ms
84 bytes from 192.168.1.1 icmp_seq=2 ttl=255 time=___ ms
84 bytes from 192.168.1.1 icmp_seq=3 ttl=255 time=___ ms
84 bytes from 192.168.1.1 icmp_seq=4 ttl=255 time=___ ms
84 bytes from 192.168.1.1 icmp_seq=5 ttl=255 time=___ ms
```

All 5 replies received = GNS3 environment is working correctly.

---

*Session 1 complete — proceed to [Session 2: Switching Fundamentals](../../session2/index.md)*
