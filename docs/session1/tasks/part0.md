# Part 0 — Installation & Architecture

## Objectives

- Install GNS3 on Windows
- Understand the difference between local compute and the GNS3 VM
- Import a Cisco 3725 IOS image and build a reusable router template
- Configure the NM-16ESW module in slot 1

---

## Step 1 — Download and Install GNS3

1. Navigate to [https://www.gns3.com/software/download](https://www.gns3.com/software/download) and download the **GNS3 All-in-One** Windows installer (latest stable release, 2.2.x or newer).

2. Run the installer with default options. The installer includes:
    - GNS3 GUI
    - GNS3 server (local)
    - Dynamips (Cisco IOS emulator)
    - VPCS
    - Wireshark (packet capture)
    - WinPCAP or Npcap (required for Wireshark)

3. When prompted about the **GNS3 VM**, select **"I will use the GNS3 VM later"** or skip. The GNS3 VM is not required for any lab in this series.

!!! tip "GNS3 VM — when you need it"
    The GNS3 VM is a Linux virtual machine that runs inside VMware or VirtualBox. It is only required for devices that use **QEMU** (IOS-XE, IOS-XR, ASAv, Arista vEOS) or **Docker** containers. All labs in this series use Cisco 3725 via **Dynamips**, which runs directly on Windows — no VM needed.

---

## Step 2 — First Launch

1. Open GNS3. The Setup Wizard may appear on first run — choose **"Run appliances on my computer"** (local server).

2. Verify the server connection in the **bottom status bar**. You should see:
    - **GNS3 server** with a green dot — local server is running
    - **Version** shows a matching GNS3 version number

3. If the status bar shows a red dot, open **Edit → Preferences → Server** and confirm:
    - Host: `127.0.0.1`
    - Port: `3080`
    - Auth: disabled

---

## Step 3 — Import the Cisco 3725 IOS Image

You will need a Cisco 3725 IOS image (`.bin` file). This image must be obtained independently — Cisco IOS images are proprietary and are not bundled with GNS3.

1. Open **Edit → Preferences → IOS Routers** (on macOS: **GNS3 → Preferences**).

2. Click **New** to launch the IOS router wizard.

3. On the **Server** screen, choose **Run this IOS router on my local computer**.

4. Click **Browse** and navigate to your `c3725-adventerprisek9-mz.124-15.T14.bin` file (or equivalent 3725 image).

5. GNS3 will auto-detect the platform as **3725**. Confirm and click **Next**.

6. Set the template name to **3725** (or any name you prefer).

7. Set **RAM** to **256 MB**. Click **Next**.

8. On the **Network adapters** screen:
    - **Slot 0**: `GT96100-FE` (pre-filled — provides `Fa0/0` and `Fa0/1`)
    - **Slot 1**: Select **`NM-16ESW`** from the dropdown

9. Click **Next**, then **Finish**.

---

## Step 4 — Calculate the Idle-PC Value

Without an Idle-PC value, Dynamips will pin a CPU core at 100% whenever the router is running.

1. Back in **Edit → Preferences → IOS Routers**, select your new **3725** template.

2. Click **Edit**, then navigate to the **Idle-PC** field.

3. Click **Idle-PC finder**. GNS3 will temporarily start a router instance and run a measurement — this takes about 30 seconds.

4. A list of candidate values appears. Select one marked with an asterisk (`*`) — these are the highest-priority candidates.

5. Click **OK** and save the template.

!!! warning "Do this before your first lab"
    Every student machine needs its own Idle-PC value — it is specific to your CPU. If you clone a GNS3 project from someone else, recalculate Idle-PC on your machine.

---

## Summary

| Completed | Task |
|-----------|------|
| ☐ | GNS3 installed without errors |
| ☐ | Local server shows green in status bar |
| ☐ | 3725 template created with correct IOS image |
| ☐ | RAM set to 256 MB |
| ☐ | NM-16ESW in slot 1 |
| ☐ | Idle-PC value calculated and saved |

Proceed to [Part 1 — Adding Devices](part1.md).
