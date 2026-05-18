# Session 8 — GNS3 Project Build Notes

## Startup Configs

| File | Router | Faults |
|------|--------|--------|
| r1-startup.cfg | R1 — Left Site | None |
| r2-startup.cfg | R2 — Hub | Fault 2 (OSPF), Fault 3 (ACL) |
| r3-startup.cfg | R3 — Right Site | Fault 1 (VLAN) |

## Steps to Build the Project

### 1. Create the GNS3 project

- New project: `session8-capstone`
- Add three Cisco 3725 routers: R1, R2, R3
- Add NM-16ESW module to R1 and R3 (slot 1)
- Add five VPCS nodes: PC-A, PC-B, PC-C, PC-D, PC-E

### 2. Connect the devices

Wire exactly as the link table in topology.md specifies:

| From | Port | To | Port |
|------|------|----|------|
| PC-A | NIC | R1 | Fa1/10 |
| PC-B | NIC | R1 | Fa1/20 |
| PC-C | NIC | R1 | Fa1/30 |
| R1 | Fa0/1 | R2 | Fa0/0 |
| R2 | Fa0/1 | R3 | Fa0/0 |
| PC-D | NIC | R3 | Fa1/30 |
| PC-E | NIC | R3 | Fa1/40 |

### 3. Load the startup configs

For each router, right-click > Edit config > paste the contents of the corresponding .cfg file, or use:

```
File > Import configs
```

if your GNS3 version supports bulk import.

### 4. Create the VLAN databases

The startup-config does not include VLAN database entries (those live in nvram:vlan.dat). After booting each router, console in and run:

**On R1:**
```
vlan database
vlan 10 name SALES
vlan 20 name MGMT
apply
exit
```

**On R3:**
```
vlan database
vlan 30 name SALES
vlan 40 name MGMT
apply
exit
```

Then save state so the vlan.dat is captured in the project snapshot:
```
copy running-config startup-config
```

### 5. Configure VPCS hosts

```
! PC-A
ip 172.16.10.10 255.255.255.0 172.16.10.1

! PC-B
ip 172.16.10.20 255.255.255.0 172.16.10.1

! PC-C
ip 172.16.20.10 255.255.255.0 172.16.20.1

! PC-D
ip 172.16.30.10 255.255.255.0 172.16.30.1

! PC-E
ip 172.16.40.10 255.255.255.0 172.16.40.1
```

Save each VPCS config with `save`.

### 6. Verify faults are active before saving

Before zipping the project for distribution, confirm the three faults are visible:

```
! On R3 -- Fault 1 should show Fa1/40 in VLAN 1
show vlan-switch brief

! On R2 -- Fault 2: only R1 neighbor, no R3
show ip ospf neighbor

! On R2 -- Fault 3: only one permit line in CROSS-SITE
show ip access-lists CROSS-SITE
```

### 7. Save and zip

- GNS3: File > Save project
- Zip the entire project folder: `session8-capstone.zip`
- Distribute the zip to students
