# NetworkSwitchLab — Project Context for Claude Code

## What This Project Is

A CCNA-style lab guide series for adult professionals learning enterprise networking using **Cisco 3725 routers with NM-16ESW modules in GNS3**. The guides are built with **MkDocs Material** and published to GitHub Pages at `https://DaveGirgis.github.io/NetworkSwitchLab/`.

Repository: `https://github.com/DaveGirgis/NetworkSwitchLab`  
Working directory: `C:\Users\DaveG\Downloads\Github\NetworkSwitchLab`  
Branch: `main` (commits go directly to main — no PR workflow currently in use)

---

## Dev Server

```
mkdocs serve        # http://localhost:8000
```

Config saved in `.claude/launch.json`.

---

## Session Status

| Session | Topic | Status |
|---------|-------|--------|
| Session 1 | Simulation Platform Introduction | ✅ Complete |
| Session 2 | Switching Fundamentals — VLANs & Inter-VLAN Routing | ✅ Complete |
| Session 3 | Spanning Tree Protocol — Root Election & PVST+ | ✅ Complete |
| Session 4 | Static Routing & Route Summarization | ✅ Complete |
| Session 5 | IPv6 Addressing & Static Routing | ✅ Complete |
| Session 6 | OSPF Single Area & EIGRP | ✅ Complete |
| Session 7 | ACLs and NAT | ✅ Complete |
| Session 8 | Capstone Troubleshooting Lab | 🔜 Not started |

---

## File Structure Convention (Sessions 3–5)

```
docs/session{N}/
├── index.md              # Objectives, learning outcomes, prerequisites, session table
├── topology.md           # Mermaid diagram ONLY (no ASCII art), link table, device summary
├── addressing.md         # Address tables, subnet references
├── tasks/
│   ├── part0.md          # Base config
│   ├── part1.md          # ...
│   ├── part2.md
│   ├── part3.md
│   └── verify.md         # Checklist table + connectivity test
└── reference/
    ├── commands.md        # Command reference table + discussion wrap-up
    └── troubleshooting.md # Symptom/cause/fix sections
```

New sessions must also be added to:
- `mkdocs.yml` — nav block (follow the Session 4/5 pattern)
- `docs/index.md` — session table row (change 🔜 Coming Soon to ✅ Available with link)

---

## Critical Hardware Rules

These apply to ALL sessions and must be consistent throughout:

### Cisco 3725 + NM-16ESW
- **`show vlan-switch brief`** — NOT `show vlan brief` (3725-specific command)
- **`show vlan-switch`** — NOT `show vlan`
- NM-16ESW ports: `Fa1/0` through `Fa1/15` (16 ports, zero-indexed)
- Port naming convention: access port number matches VLAN where possible (e.g. VLAN 10 → `Fa1/10`, VLAN 11 → `Fa1/11`)
- VLANs created in `vlan database` mode (not `configure terminal`)
- SVIs used for Layer 3 gateway — NOT router-on-a-stick subinterfaces (`Fa0/0.10`)
- No trunk link needed between NM-16ESW and router when using SVIs

### Topology Diagrams
- Mermaid `graph LR` only — no ASCII art diagrams
- Use `subgraph` blocks for each router
- Show interface names and IPv4/IPv6 addresses inside nodes

### Code Blocks
- Use plain ASCII hyphens `-` in IOS comments, never Unicode em dashes `—` (causes paste errors in terminal)
- No hidden Unicode characters — use `python3` to scan for non-ASCII bytes if paste errors are reported

---

## Session 4 Key Details

**Topic:** IPv4 static routing between R1 and R2 (two routers)  
**Design:** SVIs (not subinterfaces), NM-16ESW on both routers  
**VLAN 10** → access port `Fa1/10`, SVI `interface Vlan10`, gateway `192.168.10.1/24`  
**VLAN 11** → access port `Fa1/11`, SVI `interface Vlan11`, gateway `192.168.11.1/24`  
**WAN link:** `Fa0/1` on both routers, `/30` subnet from `172.16.31.0/24`  
**PC addresses:** R1-PC-A `192.168.10.10`, R2-PC-A `192.168.11.10`

---

## Session 5 Key Details

**Topic:** IPv6 addressing and static routing across three routers  
**Design:** Pure Layer 3 (no NM-16ESW), PCs connect directly to router `Fa0/0`  
**Routers:** R1 (left spoke), R2 (hub), R3 (right spoke)

**Addressing convention:** third hextet encodes network identity; last hextet = router number

| Network | Prefix | Meaning |
|---------|--------|---------|
| R1 LAN | `2001:db8:0:1::/64` | `1` = R1 |
| R3 LAN | `2001:db8:0:3::/64` | `3` = R3 |
| R1–R2 link | `2001:db8:0:12::/64` | `12` = R1↔R2 |
| R2–R3 link | `2001:db8:0:23::/64` | `23` = R2↔R3 |

**Key IPv6 commands:** `ipv6 unicast-routing` (required on all routers), `ipv6 address`, `ipv6 route`, `show ipv6 route`, `show ipv6 interface brief`

---

## Common Tasks

### Scan a file for hidden Unicode characters
```bash
python3 -c "
with open('docs/sessionX/tasks/partY.md', 'rb') as f:
    content = f.read()
for i, byte in enumerate(content):
    if byte > 127 or (byte < 32 and byte not in (9, 10, 13)):
        line = content[:i].count(10) + 1
        print(f'Line ~{line}: byte=0x{byte:02X} at offset {i}')
"
```

### Start the MkDocs dev server
```bash
mkdocs serve
```

### Push changes
```bash
git add <files>
git commit -m "descriptive message"
git push origin main
```

### gh CLI (authenticated as DaveGirgis)
```bash
"/c/Program Files/GitHub CLI/gh.exe" <command>
```
Note: `gh` is not in PATH for the Claude Code shell — use the full path above.
