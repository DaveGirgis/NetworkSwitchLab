# Part 0 — Base Configuration

**Objective:** Apply hostname and disable DNS lookup on R1 and R2 before any routing or switching configuration begins.

---

## Task 0.1 — Hostname and Global Settings

Apply to each device. Substitute the correct hostname for each.

```
enable
configure terminal
hostname R1
no ip domain-lookup
```

Repeat on R2 with `hostname R2`.

---

## Task 0.2 — Bring Up the WAN Interface

The 3725's built-in FastEthernet interfaces are administratively shut down by default. Bring up `Fa0/1` on both routers — this is the WAN link configured in Part 2.

```
interface FastEthernet0/1
 no shutdown
```

> [!NOTE]
> NM-16ESW interfaces (`Fa1/x`) do not require `no shutdown` — they come up automatically when GNS3 links are connected. The built-in router interfaces (`Fa0/x`) must be explicitly enabled.

---

## Task 0.3 — Save Configuration

```
end
write memory
```

Repeat on both R1 and R2 before proceeding to Part 1.
