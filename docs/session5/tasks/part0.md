# Part 0 — Base Configuration

**Objective:** Apply hostname and global settings, enable IPv6 forwarding, and bring up physical interfaces on R1, R2, and R3 before any addressing is configured.

---

## Task 0.1 — Hostname and Global Settings

Apply to each device. Substitute the correct hostname.

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

## Task 0.2 — Enable IPv6 Unicast Routing

By default, Cisco IOS does not forward IPv6 packets between interfaces — it must be explicitly enabled. This is the IPv6 equivalent of turning routing on, and it must be done on **all three routers**.

```
ipv6 unicast-routing
```

> [!WARNING]
> If you skip this step, routers will accept IPv6 addresses on their interfaces but will silently drop any packet that needs to be forwarded. All pings between different subnets will fail, and `show ipv6 route` will show connected routes only. This is the single most common mistake in a first IPv6 lab.

---

## Task 0.3 — Bring Up Physical Interfaces

The 3725's built-in FastEthernet interfaces are administratively shut down by default. Bring up both interfaces on each router.

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
> Interfaces must be up before IPv6 addresses can come online. Bring them up now so the addresses configured in Parts 1 and 2 activate immediately.

---

## Task 0.4 — Save Configuration

```
end
write memory
```

Repeat on all three routers before continuing to Part 1.
