# Part 0 — Base Configuration

**Objective:** Apply hostname, disable DNS lookup, and enable IPv6 forwarding on R1, R2, and R3 before any addressing is configured.

---

## Task 0.1 — Hostname and Global Settings

Apply to each device. Substitute the correct hostname.

```
enable
configure terminal
hostname R1
no ip domain-lookup
```

Repeat on R2 (`hostname R2`) and R3 (`hostname R3`).

---

## Task 0.2 — Enable IPv6 Unicast Routing

By default, Cisco IOS does not forward IPv6 packets between interfaces — it must be explicitly enabled. This is the IPv6 equivalent of turning routing on, and it must be done on **all three routers**.

```
ipv6 unicast-routing
```

> [!WARNING]
> If you skip this step, routers will accept IPv6 addresses on their interfaces but will silently drop any packet that needs to be forwarded. All pings between different subnets will fail, and `show ipv6 route` will show connected routes only. This is the single most common mistake in a first IPv6 lab.

---

## Task 0.3 — Save Configuration

```
end
write memory
```

Repeat on all three routers before continuing to Part 1.
