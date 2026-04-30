# Part 0 — Base Configuration

**Objective:** Apply hostname, disable DNS lookup, set enable secret, and configure console logging on R1 and R2 before any routing or switching configuration begins.

---

## Task 0.1 — Hostname and Global Settings

Apply to each device. Substitute the correct hostname for each.

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

Repeat on R2 with `hostname R2`.

---

## Task 0.2 — Bring Up Physical Interfaces

The 3725's built-in FastEthernet interfaces are administratively shut down by default. Bring up `Fa0/0` and `Fa0/1` on both routers.

```
interface FastEthernet0/0
 no shutdown
interface FastEthernet0/1
 no shutdown
```

> [!NOTE]
> NM-16ESW interfaces (`Fa1/x`) do not require `no shutdown` — they come up automatically when GNS3 links are connected. The built-in router interfaces (`Fa0/0`, `Fa0/1`) must be explicitly enabled.

---

## Task 0.3 — Save Configuration

```
end
write memory
```

Repeat on both R1 and R2 before proceeding to Part 1.
