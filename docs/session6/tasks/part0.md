# Part 0 — Base Configuration

**Objective:** Apply hostname and global settings to R1, R2, and R3 before any IP addressing is configured.

---

## Task 0.1 — Hostname and Global Settings

Apply to each device, substituting the correct hostname.

```
enable
configure terminal
hostname R1
no ip domain-lookup

exit
```

Repeat on R2 (`hostname R2`) and R3 (`hostname R3`).
