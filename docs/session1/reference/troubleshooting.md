# Troubleshooting

## GNS3 Installation & Server

| Symptom | Likely Cause | Fix |
|---------|-------------|-----|
| GNS3 opens but status bar shows red dot | Local GNS3 server failed to start | Check **Edit → Preferences → Server** — confirm host is `127.0.0.1` and port is `3080`. Restart GNS3. |
| "Could not connect to server" on launch | Another process is using port 3080 | Open Task Manager and end any existing `gns3server.exe` process, then relaunch GNS3. |
| Wireshark missing after install | Wireshark option was unchecked in installer | Reinstall GNS3 and ensure Wireshark is selected, or install Wireshark separately from wireshark.org. |
| GNS3 VM option greyed out in preferences | VMware or VirtualBox not installed | The GNS3 VM is not needed for this series. Ignore this option. |

---

## IOS Image & Template

| Symptom | Likely Cause | Fix |
|---------|-------------|-----|
| IOS image not found when creating template | File path changed or incorrect | Remove and re-add the template. Browse to the correct `.bin` file location. |
| "Incorrect platform" warning | Wrong IOS image selected for 3725 | Verify your image file is a `c3725-*.bin` image, not a 3640, 7200, or other platform image. |
| Template created but NM-16ESW not in slot 1 | Module was not set during wizard | Edit the template → Network adapters tab → set slot 1 to `NM-16ESW`. |
| Idle-PC finder fails or produces no candidates | Router did not fully boot during measurement | Run the Idle-PC finder again. If it fails repeatedly, start a router manually, wait 60 seconds, then right-click → Idle-PC. |

---

## High CPU Usage

| Symptom | Likely Cause | Fix |
|---------|-------------|-----|
| CPU at 100% when router is running | Idle-PC value not set | Right-click the running router → **Idle-PC** → **Auto**. Select a value marked with `*`. |
| CPU drops briefly then spikes again | Idle-PC value is wrong for your CPU | Try a different Idle-PC candidate from the list. Values vary by CPU model. |
| Multiple routers all pegging CPU | Each router needs its own Idle-PC value set | Set Idle-PC on the template so all routers created from it inherit the value. |

---

## Device Startup

| Symptom | Likely Cause | Fix |
|---------|-------------|-----|
| Router console shows nothing after start | Router is still booting | Wait 60 seconds. If nothing appears, press **Enter** in the console window. |
| Console window closes immediately | Terminal application not configured | Open **Edit → Preferences → General → Console applications** and set a valid terminal. |
| VPCS console shows "Connection refused" | VPCS failed to start | Stop and restart PC-A. If the problem persists, delete and re-add the VPCS node. |
| Router stuck at "Rommon" prompt | IOS image file is corrupt or incomplete | Verify MD5 checksum of your `.bin` file. Re-download the image if needed. |
| "Not enough memory" error on start | Template RAM too high for your system | Lower template RAM to 128 MB in **Edit → Preferences → IOS Routers → Edit → Memory**. |

---

## Connectivity

| Symptom | Likely Cause | Fix |
|---------|-------------|-----|
| Link dots stay red after both devices start | Interface on router is administratively down | Run `no shutdown` on the router interface. Fa0/0 defaults to down on Cisco IOS. |
| Ping from VPCS returns "host unreachable" | IP address not set on router interface | Verify `show ip interface brief` on R1 shows Fa0/0 with the correct IP and status "up/up". |
| Ping returns timeout (no reply) | Wrong IP or gateway on VPCS | Run `show ip` in VPCS. Verify IP is `192.168.1.10`, gateway is `192.168.1.1`. |
| Ping works in one direction only | ARP or routing issue | Run `arp` in VPCS and check the ARP table. Verify no access-lists are blocking ICMP on R1. |
| Console can connect but no ping | Link not drawn between correct interfaces | Delete the link and redraw it. Confirm you selected `Fa0/0` on R1 and `eth0` on PC-A. |

---

## Saving & Reopening Projects

| Symptom | Likely Cause | Fix |
|---------|-------------|-----|
| Router config lost after reopen | `copy running-config startup-config` was not run | Always save configs before stopping devices. Use `copy run start` as the last step of every lab. |
| VPCS IP address missing after reopen | `save` not run in VPCS console | Run `save` in the VPCS console window before stopping the node. |
| Project shows "topology.gns3 not found" | Project folder moved or renamed | Open GNS3 and use **File → Open** to navigate to the `.gns3` file in its current location. |
