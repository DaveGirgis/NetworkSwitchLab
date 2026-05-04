# Addressing

## The Addressing Convention

This session uses a single design rule to make every IPv6 address self-documenting:

> **The third hextet describes the network. The last hextet identifies the device.**

| Third hextet value | Meaning |
|--------------------|---------|
| `1` | R1's LAN segment |
| `3` | R3's LAN segment |
| `12` | The link between R1 and R2 |
| `23` | The link between R2 and R3 |

| Last hextet value | Meaning |
|-------------------|---------|
| `::1` | Router 1 (or the gateway on any LAN) |
| `::2` | Router 2 |
| `::3` | Router 3 |
| `::10` | PC / host |

Once you know the convention, you can reconstruct any address in this lab from memory.

---

## Full Address Table

| Device | Interface | IPv6 Address | Role |
|--------|-----------|--------------|------|
| R1 | Fa0/0 | `2001:db8:0:1::1/64` | R1 LAN gateway |
| R1-PC-A | NIC | `2001:db8:0:1::10/64` | Host on R1 LAN |
| R1 | Fa0/1 | `2001:db8:0:12::1/64` | R1 end of R1-R2 link |
| R2 | Fa0/0 | `2001:db8:0:12::2/64` | R2 end of R1-R2 link |
| R2 | Fa0/1 | `2001:db8:0:23::2/64` | R2 end of R2-R3 link |
| R3 | Fa0/1 | `2001:db8:0:23::3/64` | R3 end of R2-R3 link |
| R3 | Fa0/0 | `2001:db8:0:3::1/64` | R3 LAN gateway |
| R3-PC-A | NIC | `2001:db8:0:3::10/64` | Host on R3 LAN |

Default gateways:
- R1-PC-A uses `2001:db8:0:1::1` (R1 Fa0/0)
- R3-PC-A uses `2001:db8:0:3::1` (R3 Fa0/0)

---

## Static Route Summary

| Router | Route | Next Hop | Purpose |
|--------|-------|----------|---------|
| R1 | `::/0` | `2001:db8:0:12::2` | Default — all unknown traffic toward R2 |
| R3 | `::/0` | `2001:db8:0:23::2` | Default — all unknown traffic toward R2 |
| R2 | `2001:db8:0:1::/64` | `2001:db8:0:12::1` | Reach R1's LAN via R1 |
| R2 | `2001:db8:0:3::/64` | `2001:db8:0:23::3` | Reach R3's LAN via R3 |

---

## IPv6 Primer for IPv4 Students

### Address Format

An IPv6 address is 128 bits written as eight groups of four hexadecimal digits, separated by colons:

```
2001:0db8:0000:0001:0000:0000:0000:0001
```

Two shortening rules apply:

1. **Leading zeros** in any group can be dropped: `0001` becomes `1`, `0000` becomes `0`
2. **One consecutive run** of all-zero groups can be collapsed to `::` (used only once per address)

The address above becomes:

```
2001:db8:0:1::1
```

### Prefix Length

IPv6 uses the same CIDR slash notation as IPv4. A `/64` prefix means the first 64 bits identify the network and the last 64 bits are the host portion — exactly like a `/24` in IPv4, but with far more host space.

### Link-Local Addresses

Every IPv6-enabled interface automatically generates a **link-local address** starting with `fe80::`. These are used for neighbor discovery and routing protocol traffic. They are not routable beyond a single link and will appear in `show ipv6 interface` output alongside the global unicast address you configure. This is normal and expected.

### The Documentation Prefix

`2001:db8::/32` is reserved by IANA for documentation and examples (RFC 3849). It will never appear on the public internet, making it the correct choice for lab guides.
