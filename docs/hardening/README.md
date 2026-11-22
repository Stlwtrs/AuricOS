# Hardening Records

AuricOS was hardened in rounds. Each round made one set of changes, rebuilt the ISO, installed it on a fresh virtual disk, and measured the result with Lynis. These records document what each round changed, how it was verified, and what went wrong along the way.

| Round | Focus | Hardening index | Record |
|---|---|:--:|---|
| Baseline | Stock install, no hardening | **64** | [round-0-baseline.md](round-0-baseline.md) |
| 1 | Network and kernel | **72** | [round-1.md](round-1.md) |
| 2 | Accounts, authentication and toolchain | **75** | [round-2.md](round-2.md) |
| 3 | Auditing and file integrity | **78** | [round-3.md](round-3.md) |
| 4 | Copy Fail mitigation and bundled security tools | **78** | [round-4.md](round-4.md) |

## Method

1. Make the round's changes in the archiso profile and commit them.
2. Build the ISO with `mkarchiso`.
3. Install it on a **new** QEMU/KVM disk (never a reused one, and never the live session).
4. Boot the installed system and confirm each change (the checks are listed in each record).
5. Run `sudo lynis audit system --quick` (Lynis 3.1.7) and record the hardening index, tests run and suggestions.

The hardening index is a guide, not a goal. Lynis rewards some server-oriented settings that don't suit a desktop, and it has no tests for some controls AuricOS adds (round 4 is an example). Each remaining suggestion is reviewed in the README's [Accepted Findings](../../README.md#accepted-findings-and-risk-decisions).

## Raw Reports

Raw Lynis output goes in [`docs/lynis/`](../lynis/), captured with [`scripts/lynis-capture.sh`](../../scripts/lynis-capture.sh), which removes the hostname, username, and IP and MAC addresses. Rounds 0–3 were recorded as scores only, so their raw output is not available; reports are kept from round 4 onward.
