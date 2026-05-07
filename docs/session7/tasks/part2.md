# Part 2 — ACL Fundamentals

**Objective:** Understand the three ACL types and their placement rules, then apply a standard ACL to restrict VTY management access, and build a second standard ACL that will serve as the NAT permit list in Part 3.

---

## Understanding ACLs

An Access Control List (ACL) is an ordered list of permit and deny rules. IOS evaluates each packet against the rules from top to bottom and acts on the first match. If no rule matches, an implicit `deny any` at the end of every ACL drops the packet.

### ACL Types

| Type | Number Range | What It Matches | Placement Rule |
|------|-------------|-----------------|----------------|
| Standard numbered | 1–99 | Source IP address only | Place close to the destination — standard ACLs cannot distinguish by destination, so placing them near the source would over-block traffic |
| Extended numbered | 100–199 | Source IP, destination IP, protocol, and port | Place close to the source — the precise match means traffic can be dropped before it consumes bandwidth traversing the network |
| Named (standard or extended) | A text name | Same as the type above | Same placement rules; named ACLs are easier to read, document, and edit than numbered ACLs |

### How ACLs Are Applied

- **Physical interfaces and SVIs:** `ip access-group [name-or-number] in|out`
  - `in` — evaluated as packets arrive on the interface
  - `out` — evaluated as packets leave the interface
- **VTY lines:** `access-class [number] in|out`
  - `in` — restricts who can connect *to* this router via Telnet or SSH
  - `out` — restricts where *from* this router Telnet or SSH sessions can be initiated

---

## Task 2.1 — Standard ACL for VTY Access

**Scenario:** Only R2 (at `203.0.113.2`) should be permitted to Telnet into R1 for management. All other sources are denied by the implicit `deny any`.

On R1, create the ACL and apply it to the VTY lines:

```
access-list 10 permit host 203.0.113.2
line vty 0 4
 access-class 10 in
 password cisco
 login
 transport input telnet
```

**Test from R2:**

```
telnet 203.0.113.1
```

Enter password `cisco` when prompted. The session should open successfully.

**Verify the ACL:**

```
show ip access-lists 10
```

Expected output on R1 (after one successful Telnet attempt):

```
Standard IP access list 10
    10 permit host 203.0.113.2 (2 matches)
```

> [!NOTE]
> Notice that `access-class` (not `ip access-group`) is used on VTY lines. The `ip access-group` command is for interfaces — applying it to a VTY line will produce an error. The two commands serve similar filtering purposes but operate in different contexts.

---

## Task 2.2 — Standard ACL as a NAT Permit List

The NAT configuration in Part 3 requires an ACL that identifies which inside source addresses should be translated. Only `access-list 1` entries with `permit` will have their source addresses translated; all others pass through R1 untranslated (and will fail to reach R2 for the reasons observed in Task 1.8).

Create ACL 1 permitting only PC-A:

```
access-list 1 permit host 192.168.10.10
```

**Do not apply this ACL to any interface.** When referenced by `ip nat inside source list`, it acts as a selector for NAT — not as a forwarding filter. Packets from addresses not matched by ACL 1 are still forwarded by R1; they simply will not receive a NAT translation.

Verify the ACL exists:

```
show ip access-lists 1
```

Expected output:

```
Standard IP access list 1
    10 permit 192.168.10.10
```

The ACL will show zero matches at this point — it has no effect until NAT is configured in Part 3.
