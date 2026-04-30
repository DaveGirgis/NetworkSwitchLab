# Addressing

## VLAN Assignments

| VLAN | Name | Subnet | Gateway |
|------|------|--------|---------|
| 10 | SALES | 192.168.10.0/24 | 192.168.10.1 |
| 11 | ENGINEERING | 192.168.11.0/24 | 192.168.11.1 |

---

## Host Address Table

| Host | VLAN | IP Address | Subnet Mask | Default Gateway |
|------|------|------------|-------------|-----------------|
| R1-PC-A | 10 | 192.168.10.10 | 255.255.255.0 | 192.168.10.1 |
| R2-PC-A | 11 | 192.168.11.10 | 255.255.255.0 | 192.168.11.1 |

---

## Point-to-Point Link Addressing

The link between R1 `Fa0/1` and R2 `Fa0/1` uses a `/30` subnet selected from the table below. Your instructor will assign a subnet, or you may be asked to select one. Record your selection and fill in the interface addresses before beginning Part 2.

| Device | Interface | IP Address | Subnet Mask |
|--------|-----------|------------|-------------|
| R1 | Fa0/1 | | |
| R2 | Fa0/1 | | |

---

## /30 Subnet Reference — 172.16.31.0/24 (First 16 Subnets)

A `/30` mask (`255.255.255.252`) provides exactly 4 addresses per subnet — 1 network address, 2 usable host addresses, and 1 broadcast address. This makes it the standard choice for point-to-point routed links where only two devices need addresses.

| Subnet # | Network Address | Host 1 | Host 2 | Broadcast |
|----------|----------------|--------|--------|-----------|
| 1 | 172.16.31.0 | 172.16.31.1 | 172.16.31.2 | 172.16.31.3 |
| 2 | 172.16.31.4 | 172.16.31.5 | 172.16.31.6 | 172.16.31.7 |
| 3 | 172.16.31.8 | 172.16.31.9 | 172.16.31.10 | 172.16.31.11 |
| 4 | 172.16.31.12 | 172.16.31.13 | 172.16.31.14 | 172.16.31.15 |
| 5 | 172.16.31.16 | 172.16.31.17 | 172.16.31.18 | 172.16.31.19 |
| 6 | 172.16.31.20 | 172.16.31.21 | 172.16.31.22 | 172.16.31.23 |
| 7 | 172.16.31.24 | 172.16.31.25 | 172.16.31.26 | 172.16.31.27 |
| 8 | 172.16.31.28 | 172.16.31.29 | 172.16.31.30 | 172.16.31.31 |
| 9 | 172.16.31.32 | 172.16.31.33 | 172.16.31.34 | 172.16.31.35 |
| 10 | 172.16.31.36 | 172.16.31.37 | 172.16.31.38 | 172.16.31.39 |
| 11 | 172.16.31.40 | 172.16.31.41 | 172.16.31.42 | 172.16.31.43 |
| 12 | 172.16.31.44 | 172.16.31.45 | 172.16.31.46 | 172.16.31.47 |
| 13 | 172.16.31.48 | 172.16.31.49 | 172.16.31.50 | 172.16.31.51 |
| 14 | 172.16.31.52 | 172.16.31.53 | 172.16.31.54 | 172.16.31.55 |
| 15 | 172.16.31.56 | 172.16.31.57 | 172.16.31.58 | 172.16.31.59 |
| 16 | 172.16.31.60 | 172.16.31.61 | 172.16.31.62 | 172.16.31.63 |

> [!NOTE]
> The pattern increments by 4 for each subnet. Every network address is divisible by 4, and every broadcast address ends in `.3`, `.7`, `.11`, `.15`, and so on — the last address before the next multiple of 4. Recognizing this pattern is faster than recalculating from scratch on the exam.
