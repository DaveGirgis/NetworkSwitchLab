# mkdocs.yml — nav entry for Session 4

Append the following block to the `nav:` section in `mkdocs.yml`, after the Session 3 entry:

```yaml
  - Session 4 — Static Routing & Route Summarization:
    - Overview: session4/index.md
    - Topology: session4/topology.md
    - Addressing: session4/addressing.md
    - Tasks:
      - Part 0 — Base Config: session4/tasks/part0.md
      - Part 1 — LAN Configuration: session4/tasks/part1.md
      - Part 2 — Static Routes: session4/tasks/part2.md
      - Part 3 — Default Route & Summarization: session4/tasks/part3.md
      - Verification: session4/tasks/verify.md
    - Reference:
      - Command Reference: session4/reference/commands.md
      - Troubleshooting: session4/reference/troubleshooting.md
```

Also update the Session 4 row in `docs/index.md` status table from `🔜 Coming Soon` to `✅ Available` when published.
