# Troubleshooting

Common problems and fixes for this lab.

---

## VLANs not appearing in `show vlan-switch brief`

**Symptom:** VLAN 10 or 11 missing from the VLAN table after creation.

**Fix:** Ensure you created VLANs in `vlan database` mode, not in `configure terminal`. The NM-16ESW does not support the Catalyst-style `conf t → vlan 10` method.

```ios
vlan database
 vlan 10 name VLAN10
 vlan 11 name VLAN11
exit
```

---

## Trunk port shows `not-trunking`

**Symptom:** `show interfaces f1/15 trunk` shows status `not-trunking` on one or both switches.

**Fix 1:** Confirm `switchport trunk encapsulation dot1q` was set **before** `switchport mode trunk` on the affected device.

**Fix 2:** Check the port is not shut down — `no shutdown` on `f1/15`.

**Fix 3:** Verify the other side is also configured as a trunk. A trunk will not form if one side is still in access mode.

---

## Access port assigned to wrong VLAN

**Symptom:** Host cannot reach gateway; `show vlan-switch brief` shows port in wrong VLAN.

**Fix:** Re-enter the access VLAN command:

```ios
interface FastEthernet 1/0
 switchport access vlan 10
```

---

## Inter-VLAN pings fail — same switch works, cross-switch fails

**Symptom:** PC1 → PC3 pings fail but PC1 → gateway succeeds.

**Fix:** The trunk is likely not carrying the correct VLANs. Verify on both switches:

```ios
show interfaces FastEthernet 1/15 trunk
```

Confirm VLANs 10 and 11 appear in the `Vlans in spanning tree forwarding state` section. If missing, check the `allowed vlan` configuration.

---

## Inter-VLAN pings fail — all cross-VLAN traffic

**Symptom:** PC1 cannot ping PC2 even though both can reach the gateway.

**Fix 1:** Confirm `ip routing` is enabled on R1:

```ios
show running-config | include ip routing
```

If not present, run `ip routing` in config mode.

**Fix 2:** Check both SVIs are up:

```ios
show interfaces Vlan10
show interfaces Vlan11
```

An SVI only comes up if at least one active access port exists in that VLAN. If the SVI is down, verify the access port assignment and that the port is not shut down.

---

## SVI shows `line protocol is down`

**Symptom:** `show interfaces Vlan10` shows line protocol down.

**Fix:** The SVI requires at least one physical port in that VLAN to be active. Check:

```ios
show vlan-switch brief
```

Confirm `f1/0` appears under VLAN 10 and `f1/1` under VLAN 11. If a port is missing, re-assign it:

```ios
interface FastEthernet 1/0
 switchport access vlan 10
 no shutdown
```
