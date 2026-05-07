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

---

## Commonly Used IPv6 Prefixes

IPv6 reserves distinct address ranges for specific purposes, similar to how IPv4 sets aside 10.0.0.0/8 for private use and 127.0.0.0/8 for loopback. The table at the end of this section is a quick reference; the subsections below explain what you will actually encounter.

### Link-Local — `fe80::/10`

Every IPv6-enabled interface **automatically generates** a link-local address the moment you enable IPv6 — no configuration required. The address always starts with `fe80` and the host portion is derived from the interface's MAC address using the EUI-64 algorithm: the MAC is split in half, the two-byte sequence `ff:fe` is inserted in the middle, and the 7th bit of the first byte is flipped. Modern operating systems often substitute a random host ID instead to improve privacy.

Link-local addresses are **never forwarded by a router**. They exist purely for on-link communication:

- **Neighbor Discovery Protocol (NDP)** — IPv6's replacement for ARP; resolves addresses and detects duplicate IPs
- **Router Advertisement / Router Solicitation** — how hosts learn their default gateway without DHCP
- **Routing protocol hellos** — OSPFv3 and EIGRPv6 source their hello packets from `fe80::` addresses

You will always see a `fe80::` address alongside any global unicast address in `show ipv6 interface brief`. This is expected and correct — every interface has at least one link-local address.

The IPv4 analogue is `169.254.0.0/16` (APIPA), though link-local is far more important in IPv6 because it is used intentionally, not just as a fallback.

### Unique Local Addresses — `fd00::/8`

Unique Local Addresses (ULAs) are IPv6's equivalent of IPv4 private space. RFC 4193 defines the full range as `fc00::/7`, but the `fd` half (`fd00::/8`) is what you actually configure — the `fc` half is reserved for future use.

| IPv4 Private Range | IPv6 ULA Equivalent |
|--------------------|---------------------|
| 10.0.0.0/8 | fd00::/8 |
| 172.16.0.0/12 | (same range, different prefix) |
| 192.168.0.0/16 | (same range, different prefix) |

ULAs are routable within an organization or site but are not announced to the public internet. The specification recommends generating a random 40-bit Global ID (bits 80-41 of the address) to ensure your internal prefixes are unique if two sites ever merge. In lab work a fixed prefix like `fd00:1::/48` or `fd12:3456::/48` is fine.

Common uses: internal lab topologies, home networks, VPN tunnel endpoints, and any scenario where you want private IPv6 addressing without requesting a public allocation.

### Global Unicast — `2000::/3`

Global Unicast Addresses are the publicly routable IPv6 space, spanning `2000::` through `3fff:ffff:...`. Your ISP delegates a block (typically a `/48` or `/56`) and you subnet it into `/64`s for each LAN segment.

The documentation prefix `2001:db8::/32` lives inside this range. It is permanently reserved by IANA (RFC 3849) and will never appear on the live internet, making it the correct choice for lab guides, textbooks, and RFCs. All addresses in this session use `2001:db8:0:x::/64`.

### Loopback — `::1/128`

`::1` is the IPv6 loopback address — the equivalent of `127.0.0.1`. It always refers to the local device and is never sent on the wire. You will see it in `show ipv6 route` as a local route. Cisco IOS loopback *interfaces* use global unicast or link-local addresses, not `::1`.

### Multicast — `ff00::/8`

IPv6 eliminates broadcast entirely. Everything that IPv4 would broadcast is instead sent to a specific multicast group. The `ff00::/8` range covers all multicast; the `ff02::` subset is link-local multicast (not forwarded by routers).

Addresses you will see on a Cisco router:

| Address | Used By |
|---------|---------|
| `ff02::1` | All IPv6 nodes on the link |
| `ff02::2` | All IPv6 routers on the link |
| `ff02::5` / `ff02::6` | OSPFv3 hello packets |
| `ff02::a` | EIGRPv6 hello packets |
| `ff02::1:2` | DHCPv6 relay agents |
| `ff02::1:ffxx:xxxx` | Solicited-node multicast (NDP — replaces ARP) |

The solicited-node address is constructed from the last 24 bits of a unicast address. NDP uses it to resolve a known IPv6 address to a MAC address without flooding the entire link.

---

### Quick Reference Table

| Prefix | Scope | IPv4 Analogue | Common Use |
|--------|-------|---------------|------------|
| `fe80::/10` | Link-local | 169.254.0.0/16 | NDP, routing protocol hellos, default gateway discovery |
| `fd00::/8` | Unique Local | 10.0.0.0/8, 192.168.0.0/16 | Private / lab / VPN networks |
| `2000::/3` | Global Unicast | Public IP space | Internet-routable addresses |
| `2001:db8::/32` | Documentation | N/A | Lab guides and RFC examples |
| `::1/128` | Loopback | 127.0.0.1 | Local software testing |
| `ff00::/8` | Multicast | 224.0.0.0/4 | NDP, routing protocols, DHCPv6 |
