# Part 3 — Starting Devices & Console Access

## Objectives

- Start all devices in the project
- Open console sessions on R1 and PC-A
- Configure a basic IP address on R1 Fa0/0
- Configure PC-A with an IP address and default gateway
- Verify connectivity using VPCS ping

---

## Step 1 — Start All Devices

To start every device in the project at once:

- Click the **Start all nodes** button in the toolbar (green play triangle), or
- Use **Edit → Start all nodes**, or
- Right-click an individual device → **Start**

!!! note "Boot time"
    The Cisco 3725 takes **30-60 seconds** to fully boot. VPCS starts almost instantly. Do not attempt to open a console before the IOS banner appears — wait for the boot sequence to complete.

After starting:

- Link endpoints change from **red** to **green** when both devices are up and the interface is active
- A small green arrow icon appears on each running device

---

## Step 2 — Open Console Sessions

Right-click **R1** → **Console**. Your configured terminal application opens a Telnet session to the router's console port.

Right-click **PC-A** → **Console**. A second terminal window opens for the VPCS session.

!!! tip "Console port numbers"
    Each device gets a unique TCP port for its console (usually starting at 5000). GNS3 manages these automatically — you never need to remember the port number.

---

## Step 3 — Navigate the IOS Boot Sequence

When the R1 console opens, you will see the IOS startup banner:

```
System Bootstrap, Version 12.4...

...

Press RETURN to get started!
```

Press **Enter**. You will arrive at the user EXEC prompt:

```
R1>
```

Enter privileged EXEC mode:

```
R1> enable
R1#
```

Verify the template loaded correctly:

```
R1# show version
```

Look for: `Cisco 3725`, `256K bytes of non-volatile configuration memory`, and the IOS version string.

Verify the NM-16ESW module is detected:

```
R1# show interfaces summary
```

You should see `Fa1/0` through `Fa1/15` listed.

---

## Step 4 — Configure R1 Fa0/0

Enter global configuration mode and assign an IP address to the interface connected to PC-A:

```
R1# configure terminal
R1(config)# interface FastEthernet0/0
R1(config-if)# ip address 192.168.1.1 255.255.255.0
R1(config-if)# no shutdown
R1(config-if)# end
R1# copy running-config startup-config
```

Verify the interface came up:

```
R1# show interfaces FastEthernet0/0
```

Look for: `FastEthernet0/0 is up, line protocol is up`

---

## Step 5 — Configure PC-A in VPCS

Switch to the **PC-A** console window. The VPCS prompt looks like:

```
PC-A>
```

Assign an IP address, subnet mask, and default gateway in a single command:

```
PC-A> ip 192.168.1.10 255.255.255.0 192.168.1.1
```

This sets:

| Parameter | Value |
|-----------|-------|
| IP address | `192.168.1.10` |
| Subnet mask | `255.255.255.0` |
| Default gateway | `192.168.1.1` (R1 Fa0/0) |

Verify the configuration was applied:

```
PC-A> show ip
```

Expected output:
```
NAME        : PC-A[1]
IP/MASK     : 192.168.1.10/24
GATEWAY     : 192.168.1.1
```

---

## Step 6 — Verify Connectivity

From PC-A, ping R1:

```
PC-A> ping 192.168.1.1
```

Expected output:
```
84 bytes from 192.168.1.1 icmp_seq=1 ttl=255 time=x.xxx ms
84 bytes from 192.168.1.1 icmp_seq=2 ttl=255 time=x.xxx ms
84 bytes from 192.168.1.1 icmp_seq=3 ttl=255 time=x.xxx ms
84 bytes from 192.168.1.1 icmp_seq=4 ttl=255 time=x.xxx ms
84 bytes from 192.168.1.1 icmp_seq=5 ttl=255 time=x.xxx ms
```

Five successful replies confirm that GNS3 is working correctly and end-to-end Layer 3 connectivity is functional.

!!! warning "If ping fails"
    Check the [Troubleshooting](../reference/troubleshooting.md) page. The most common causes are: interface not up on R1, wrong IP address on PC-A, or link not properly drawn between the two devices.

---

## Step 7 — Save Configurations

Save the VPCS configuration so it persists when you reopen the project:

```
PC-A> save
```

Save the router running configuration:

```
R1# copy running-config startup-config
```

---

## Summary

| Completed | Task |
|-----------|------|
| ☐ | All devices started successfully |
| ☐ | Console sessions opened on R1 and PC-A |
| ☐ | R1 Fa0/0 configured with 192.168.1.1/24 and brought up |
| ☐ | PC-A configured with 192.168.1.10/24 and gateway 192.168.1.1 |
| ☐ | Ping from PC-A to R1 returns 5 successful replies |
| ☐ | Configurations saved on both devices |

Proceed to the [Verification Checklist](verify.md).
