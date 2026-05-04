# Part 0 — Base Configuration

**Objective:** Apply hostname and global settings, then bring up all physical interfaces on R1, R2, and R3 before any IP addressing is configured.

---

## Task 0.1 — Hostname and Global Settings

Apply to each device, substituting the correct hostname.

```
enable
configure terminal
hostname R1
no ip domain-lookup
enable secret cisco
line console 0
 logging synchronous
 exec-timeout 0 0
exit
```

Repeat on R2 (`hostname R2`) and R3 (`hostname R3`).

---

## Task 0.2 — Bring Up Physical Interfaces

The 3725's built-in FastEthernet interfaces are administratively shut down by default. Bring up both on each router.

**On R1 and R3:**

```
interface FastEthernet0/0
 no shutdown
interface FastEthernet0/1
 no shutdown
```

**On R2:**

```
interface FastEthernet0/0
 no shutdown
interface FastEthernet0/1
 no shutdown
```

> [!NOTE]
> Loopback interfaces (`Loopback0`) come up automatically when created — they do not require `no shutdown`. R2's loopback will be configured in Part 1.

---

## Task 0.3 — Save Configuration

```
end
write memory
```

Repeat on all three routers before continuing to Part 1.
