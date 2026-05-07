# Troubleshooting

---

### `show ip nat translations` is empty after configuring PAT

**Symptom:** After completing Tasks 3.1 and 3.2, pings from PC-A succeed but no entries appear in the NAT translation table.

**Causes:**
- One or both interfaces are not marked with `ip nat inside` / `ip nat outside`
- The ACL referenced in `ip nat inside source list` does not match the PC's address
- The ACL is applied to an interface with `ip access-group` instead of being referenced by NAT — an ACL used only for NAT should not be applied to an interface

**Fix:**
```
show ip nat statistics
show running-config | section ip nat
show ip access-lists 1
```

Confirm that `ip nat inside` is on Vlan10, `ip nat outside` is on Fa0/1, and that ACL 1 has a permit entry matching `192.168.10.10`.

---

### PC-B can reach R2 loopback even before it is added to ACL 1

**Symptom:** Pings from PC-B to `198.51.100.1` succeed before Task 3.5 adds PC-B to the NAT permit list.

**Cause:** A `permit any` or `permit 192.168.10.0 0.0.0.255` entry exists in ACL 1, matching PC-B's address unintentionally. Alternatively, a static route from R2 to `192.168.10.0/24` was accidentally added.

**Fix:**
```
show ip access-lists 1
show ip route
```

Remove any unintended ACL permit entries with `no access-list 1 permit ...` and remove any static route from R2 to the inside network.

---

### BLOCK-ICMP-REPLY is not blocking PC-B's ICMP replies

**Symptom:** After Task 4.3, PC-B's pings to `198.51.100.1` still succeed and `show ip access-lists BLOCK-ICMP-REPLY` shows zero matches on the deny line.

**Causes:**
- The ACL is applied inbound (`in`) instead of outbound (`out`) on Vlan10
- The ACL is applied to Fa0/1 instead of Vlan10
- The deny rule uses `echo` (type 8, the request) instead of `echo-reply` (type 0, the reply)

**Fix:**
```
show running-config | section interface Vlan10
show running-config | section ip access-list
```

Confirm the ACL is applied as `ip access-group BLOCK-ICMP-REPLY out` on Vlan10, and that the deny line reads `deny icmp any host 192.168.10.20 echo-reply`.

---

### Telnet from R2 to R1 is refused after Task 2.1

**Symptom:** `telnet 203.0.113.1` from R2 immediately closes or gives "Connection refused."

**Causes:**
- `transport input` is not set (default on many IOS versions is `transport input none`)
- The VTY password is missing — IOS rejects Telnet without authentication configured
- `access-class 10 in` is blocking R2 because ACL 10 was configured incorrectly

**Fix:**
```
show running-config | section line vty
show ip access-lists 10
```

Ensure `transport input telnet`, `password cisco`, and `login` are all present on `line vty 0 4`. Confirm ACL 10 has `permit host 203.0.113.2`.

---

### PC pings gateway (192.168.10.1) fail

**Symptom:** PC-A or PC-B cannot ping R1's SVI at `192.168.10.1`.

**Causes:**
- VLAN 10 does not exist or the SVI is down
- The PC's port is not assigned to VLAN 10
- The BLOCK-ICMP-REPLY ACL is applied and inadvertently blocking the gateway ping

**Fix:**
```
show vlan-switch brief
show ip interface brief
show ip access-lists BLOCK-ICMP-REPLY
```

Confirm VLAN 10 is active, Vlan10 SVI is up/up, and the correct ports (Fa1/0, Fa1/1) are in VLAN 10. If BLOCK-ICMP-REPLY is applied, note that it only blocks echo-replies destined for `host 192.168.10.20` — it should not affect pings to the gateway unless a permit line is missing.

---

### NAT translations disappear between tests

**Symptom:** Entries that appeared in `show ip nat translations` are gone when checked again.

**Cause:** This is expected behavior. ICMP NAT translations have a short idle timeout (default 60 seconds for ICMP). Once the session is inactive, IOS removes the translation entry. This is not an error.

If you need to clear translations manually (for example, when changing ACL 1 membership), use:

```
clear ip nat translation *
```

This removes all dynamic entries immediately and allows the new ACL rules to take effect on the next ping.
