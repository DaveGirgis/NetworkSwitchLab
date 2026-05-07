# Part 0 — Base Configuration

**Objective:** Apply hostname and disable DNS lookup on R1 and R2 before any interface or ACL configuration begins.

---

## Task 0.1 — Hostname and Global Settings

Apply to each device, substituting the correct hostname.

```
enable
configure terminal
hostname R1
no ip domain-lookup
```

Repeat on R2 with `hostname R2`.
