# Platform Setup

## GNS3 Server Endpoints

GNS3 uses a client-server model internally. The GUI connects to a GNS3 server process to launch and manage device instances. Depending on your setup, that server runs either on your local machine or inside the GNS3 VM.

| Mode | Server Address | Port | When Used |
|------|---------------|------|-----------|
| Local (Windows) | `127.0.0.1` | `3080` | Default — all labs in this series |
| GNS3 VM (VMware) | `192.168.56.x` | `3080` | Only needed for QEMU/Docker devices |
| GNS3 VM (VirtualBox) | `192.168.56.x` | `3080` | Only needed for QEMU/Docker devices |

You can verify the active server in GNS3 by checking the bottom status bar: a **green dot** labeled "GNS3 server" indicates the local server is running and connected.

---

## IOS Image Requirements

All router labs in this series use a single IOS image. Obtain this image independently — it is not distributed with GNS3.

| Parameter | Value |
|-----------|-------|
| **Platform** | Cisco 3725 |
| **Recommended image** | `c3725-adventerprisek9-mz.124-15.T14.bin` |
| **Minimum IOS** | 12.4(x) Mainline or T-train |
| **RAM allocated** | 256 MB (128 MB minimum) |
| **NVRAM** | 256 KB (default) |
| **Idle-PC** | Must be calculated after template creation |

!!! warning "Idle-PC is required"
    Without an Idle-PC value, Dynamips will consume 100% of a CPU core on your host. Always calculate or set an Idle-PC value before running labs. GNS3 will prompt you to do this automatically the first time you start a router.

---

## Module Configuration

The Cisco 3725 base chassis has two WAN slots (`slot 0`) occupied by the built-in `Fa0/0` and `Fa0/1` interfaces. Switching capability comes from the NM-16ESW network module installed in **slot 1**.

| Slot | Module | Interfaces Provided |
|------|--------|---------------------|
| 0 | Built-in | `Fa0/0`, `Fa0/1` (WAN/uplink) |
| 1 | NM-16ESW | `Fa1/0` through `Fa1/15` (16 switch ports) |

!!! info "Sessions 2 and beyond"
    Sessions 2-4 use the NM-16ESW switch ports for VLANs and trunking. Session 1 uses only the built-in `Fa0/0` interface. Configure the NM-16ESW in the template now so it is ready for later labs.

---

## Console Application

GNS3 opens a terminal window when you right-click a device and select **Console**. The application used depends on your GNS3 preferences.

| Application | Notes |
|-------------|-------|
| **Built-in console** (GNS3 2.2+) | No extra install; recommended for beginners |
| **SecureCRT** | Professional SSH/Telnet client; full-featured |
| **PuTTY** | Lightweight, free; widely used |
| **Windows Terminal** | Works with GNS3 telnet via custom command |

Configure your preferred terminal at: **Edit → Preferences → General → Console applications**
