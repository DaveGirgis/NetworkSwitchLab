# Part 2 — Connecting Devices

## Objectives

- Draw a link between R1 and PC-A
- Assign interfaces on both ends
- Show interface labels on the canvas
- Save the project

---

## Step 1 — Activate the Link Tool

In the GNS3 toolbar, click the **Add a link** button — it looks like a cable connector or a diagonal line. The mouse cursor changes to a crosshair when the link tool is active.

Alternatively, use the keyboard shortcut **Ctrl+L** to toggle the link tool.

!!! tip "Exiting link mode"
    Press **Escape** or click the **Add a link** button again to return to the selection cursor. If you accidentally start a link, pressing Escape cancels it.

---

## Step 2 — Draw the Link

1. With the link tool active, click **R1** on the canvas.
2. A popup appears listing all available interfaces on R1. Select **FastEthernet0/0** (`Fa0/0`).
3. Move the mouse to **PC-A** and click it.
4. A second popup appears listing PC-A's interfaces. Select **eth0**.
5. GNS3 draws a line between R1 and PC-A. A red dot on each end indicates the link is down (devices are not started yet).

---

## Step 3 — Link Types

GNS3 offers different cable types. The correct choice for all labs in this series is **Ethernet**.

| Cable Type | Use Case |
|------------|----------|
| **Ethernet** | All LAN connections — use for every lab in this series |
| **Serial** | WAN emulation (DTE/DCE); not used here |
| **Null modem** | Back-to-back serial; not used here |

GNS3 automatically selects Ethernet when you connect two Ethernet interfaces. You do not need to manually change the cable type.

---

## Step 4 — Show Interface Labels

Interface labels on the canvas make it easy to verify which physical port each link uses.

To show labels:

- **View → Show/Hide interface labels** (or press **Shift+I**)

After enabling, you will see small text annotations on each end of every link, such as `Fa0/0` on the R1 side and `eth0` on the PC-A side.

!!! info "Always enable interface labels"
    Leaving interface labels visible prevents errors when wiring complex topologies. Starting from Session 2, all topology diagrams assume labels are shown.

---

## Step 5 — Save the Project

Save frequently to avoid losing your topology.

- **File → Save** or **Ctrl+S**

GNS3 writes the current canvas state to the `.gns3` project file. Device configurations are saved separately to the project folder when you run `copy running-config startup-config` inside IOS.

---

## What the Canvas Should Look Like

After completing this part:

- R1 and PC-A are visible on the canvas
- A single link connects them, labeled `Fa0/0` on the R1 end and `eth0` on the PC-A end
- Both link endpoints show **red dots** (link is down — devices not started)
- Interface labels are visible

---

## Summary

| Completed | Task |
|-----------|------|
| ☐ | Link drawn between R1 Fa0/0 and PC-A eth0 |
| ☐ | Interface labels enabled |
| ☐ | Project saved |

Proceed to [Part 3 — Starting Devices & Console Access](part3.md).
