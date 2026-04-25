# Task 1 — Base Configuration

**Apply on both R1 and SW2 unless noted.**

---

## Objective

Set hostnames and disable DNS lookup on both devices. This prevents the CLI from stalling when you mistype a command, which GNS3 students commonly encounter.

## Steps

### 1. Configure R1

```ios
enable
configure terminal
hostname R1
no ip domain-lookup
line con 0
 logging synchronous
end
```

### 2. Configure SW2

```ios
enable
configure terminal
hostname SW2
no ip domain-lookup
line con 0
 logging synchronous
end
```

### 3. Save on both devices

```ios
copy running-config startup-config
```

## Verification

```ios
show running-config | include hostname
```

Expected output on each device:

```
hostname R1
```

```
hostname SW2
```

!!! success "Task complete"
    Both devices should now display their correct hostname in the CLI prompt — `R1#` and `SW2#`.
