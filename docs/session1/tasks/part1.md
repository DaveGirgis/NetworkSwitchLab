# Part 1 — Adding Devices to a Project

## Objectives

- Create a new GNS3 project
- Add a Cisco 3725 router to the canvas
- Add a VPCS node to the canvas
- Understand the role of each device type

---

## Step 1 — Create a New Project

1. From the GNS3 menu, select **File → New blank project**.
2. Enter a project name such as **Session1-Lab**.
3. Click **OK**. GNS3 creates a project folder and opens a blank canvas.

!!! tip "Project files"
    GNS3 stores each project in its own folder under `Documents\GNS3\projects\` by default. The project contains a `.gns3` topology file plus folders for device configurations and disk images.

---

## Step 2 — Explore the Device Panel

The **Device Toolbar** on the left side of the GNS3 window contains all available node types. Click each icon to reveal the category:

| Icon | Category | Contains |
|------|----------|----------|
| Router icon | **Routers** | Cisco 3725, 3640, 7200, and any custom templates |
| Switch icon | **Switches** | Built-in Ethernet switch, ATM switch |
| End Device icon | **End Devices** | VPCS, built-in PC |
| Security icon | **Security** | Cisco ASA appliances (if installed) |
| All Devices icon | **All Devices** | Combined view |

---

## Step 3 — Add a Cisco 3725 Router

1. In the Device Toolbar, click the **Routers** category.
2. Locate your **3725** template.
3. **Drag** the template icon onto the canvas and release it to place the node.
4. GNS3 names the node **R1** automatically (subsequent routers are R2, R3, etc.).

To rename a node:

- Right-click the node → **Change hostname**
- Type the new name and press **Enter**

---

## Step 4 — Add a VPCS Node

VPCS (Virtual PC Simulator) is a lightweight built-in emulator that provides a minimal IP host. It runs locally on Windows with no IOS image required.

**What VPCS supports:**

| Feature | Supported |
|---------|-----------|
| Static IP address + subnet mask | Yes |
| Default gateway | Yes |
| `ping` | Yes |
| `traceroute` | Yes |
| Save/restore configuration | Yes |
| DNS resolution | Yes |
| DHCP client | Yes |
| Routing protocols | No |
| Full TCP/UDP stack | No |

VPCS is ideal for verifying Layer 3 reachability in lab topologies — it is faster to start than a full OS and uses almost no CPU.

**To add a VPCS node:**

1. In the Device Toolbar, click the **End Devices** category.
2. Locate **VPCS**.
3. Drag it onto the canvas.
4. GNS3 names it **PC1** by default. Rename it to **PC-A** using right-click → **Change hostname**.

---

## Step 5 — Review the Canvas

Your canvas should now show:

- One node labeled **R1** (Cisco 3725 icon)
- One node labeled **PC-A** (VPCS icon)
- Both nodes are gray/stopped — no link between them yet

---

## Summary

| Completed | Task |
|-----------|------|
| ☐ | New project created |
| ☐ | Cisco 3725 node added and named R1 |
| ☐ | VPCS node added and named PC-A |

Proceed to [Part 2 — Connecting Devices](part2.md).
