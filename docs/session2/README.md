# Switching Lab — MkDocs Setup

## Prerequisites

Python 3.8+ required.

## Install MkDocs

```bash
pip install mkdocs mkdocs-material
```

## Serve locally (students on same network)

```bash
cd switching-lab
mkdocs serve --dev-addr 0.0.0.0:8000
```

Students browse to `http://<your-ip>:8000` from any device on the same network — no internet needed.

## Build static site (host anywhere)

```bash
mkdocs build
```

Output goes to the `site/` folder. Drop it on any web server, USB drive, or share via Python:

```bash
cd site
python3 -m http.server 8000
```

## Delivery options

| Method | Best for |
|---|---|
| `mkdocs serve` on instructor machine | Classroom / lab LAN |
| Static site on USB | Offline, no network |
| GitHub Pages (free) | Remote / homework labs |
| Any web host or NAS | Persistent access |

## Project structure

```
switching-lab/
├── mkdocs.yml          # Site config and navigation
└── docs/
    ├── index.md
    ├── overview/
    │   ├── introduction.md
    │   ├── topology.md
    │   └── addressing.md
    ├── tasks/
    │   ├── task1.md
    │   ├── task2.md
    │   ├── task3.md
    │   ├── task4.md
    │   └── verify.md
    └── reference/
        ├── commands.md
        └── troubleshooting.md
```
