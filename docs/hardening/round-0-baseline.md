# Baseline: Stock Install

| | |
|---|---|
| Hardening index | **64** |
| Tests run | 239 |
| Suggestions | 30 |

## What Was Measured

The first working AuricOS install, before any hardening: the archiso profile, the Calamares installer, the XFCE desktop and the post-install cleanup that removes live-only components. No firewall, no mandatory access control and no audit logging.

## Main Gaps Found

- No firewall; nothing restricted incoming connections
- AppArmor not enabled
- No audit logging (`auditd`)
- Default kernel and network settings (no `sysctl` hardening)
- Core dumps enabled
- No login banner, default `umask`, default password hashing cost
- Unused network protocols (dccp, sctp, rds, tipc) loadable
- Compilers available to every account
- No file integrity monitoring

These gaps set the plan for rounds 1 to 3.
