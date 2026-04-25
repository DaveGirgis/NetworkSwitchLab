# Introduction

## Overview

In this lab you will configure VLANs, access ports, a trunk link, and inter-VLAN routing across two Cisco 3725 routers running NM-16ESW switch modules in slot 1. R1 acts as the Layer 3 gateway for both VLANs using subinterfaces on `f0/0`.

## Prerequisites

- Basic IOS CLI familiarity (navigation, interface config, show commands)
- GNS3 project loaded with two 3725 nodes linked on `f1/15`
- NM-16ESW module installed in slot 1 on both devices

!!! info "NM-16ESW port naming"
    The NM-16ESW switch module presents ports as `f1/0` through `f1/15`. The router's own routed interface is `f0/0`. Keep this distinction in mind throughout the lab.

## Key differences from Catalyst switches

The NM-16ESW behaves differently from a standalone Catalyst in a few important ways:

| Behavior | Catalyst | NM-16ESW (3725) |
|---|---|---|
| VLAN creation | `conf t → vlan 10` | `vlan database → vlan 10` |
| Show VLANs | `show vlan brief` | `show vlan-switch brief` |
| Trunk encapsulation | Often auto | Must set `dot1q` explicitly |

!!! warning "Common GNS3 gotcha"
    `show vlan brief` will not work on the NM-16ESW. Always use `show vlan-switch brief`.
