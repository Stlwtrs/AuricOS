# Lynis Reports

Raw Lynis output for each hardening round, one folder per round. Each folder holds:

| File | Contents |
|---|---|
| `summary.md` | Hardening index, tests run, and every warning and suggestion |
| `lynis-output.txt` | Console output of `lynis audit system --quick` |
| `lynis-report.dat` | Lynis's machine-readable report |

Reports are captured on a fresh installation with [`scripts/lynis-capture.sh`](../../scripts/lynis-capture.sh), which replaces the hostname, username, and IP and MAC addresses with placeholders.

Rounds 0–3 were recorded as scores only; see [`docs/hardening/`](../hardening/) for what each round changed. Raw reports start with round 4.
