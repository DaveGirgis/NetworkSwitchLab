# Troubleshooting

| Symptom | Likely Cause | Resolution |
|---------|-------------|------------|
| Port stuck in BLK permanently | Expected — non-designated alternate port | Verify with `show spanning-tree` — this may be correct |
| Unexpected root bridge after reboot | Priority not saved to NVRAM | Run `write memory` after every priority change |
| Port in err-disabled state | BPDU Guard triggered | Remove rogue device, then `shutdown` / `no shutdown` the port |
| Slow convergence after link failure | Normal for classic 802.1D | ~30–50 sec expected; preview RSTP as the modern solution |
| VLAN missing from spanning tree | VLAN not in database | `show vlan brief` — create with `vlan <id>` in global config |
| Trunk not passing VLAN 10 or 11 | VLAN pruned from trunk | `switchport trunk allowed vlan all` or add specific VLANs |
| PC cannot ping across switches | PC in wrong VLAN or wrong IP | Verify access port VLAN assignment and PC address |
| STP topology changing repeatedly | Flapping link or rogue BPDU source | `show spanning-tree detail` — check topology change counters |
