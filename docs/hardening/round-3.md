# Round 3: Auditing and File Integrity

| | |
|---|---|
| Hardening index | 75 → **78** |
| Tests run | 247 |
| Suggestions | 13 |

## Changes

| Control | Implementation |
|---|---|
| Audit ruleset | 16 `auditd` rules watching identity files, sudoers, PAM, SSH, sysctl, modprobe, firewall, AppArmor and systemd unit changes, plus `sudo` execution and kernel module load and unload |
| File integrity | AIDE, built from the AUR with its PGP-signed source verified against the upstream key; `aidecheck.timer` runs scheduled checks |
| Martian packet logging | Fixed `ufw`'s own sysctl file, which reset `log_martians` to 0 when ufw started |
| SSH configuration | `sshd_config` restricted to mode `600` |

## Verification

```bash
sudo auditctl -l | wc -l                      # 16
sudo touch /etc/sudoers.d/test && sudo rm /etc/sudoers.d/test
sudo ausearch -k sudoers -i | tail -5         # event shows your auid
sudo aide --init                              # create the baseline (see First-Login Steps)
sysctl net.ipv4.conf.all.log_martians         # 1
stat -c '%a' /etc/ssh/sshd_config             # 600
```

## Problems and Fixes

- **`log_martians` stayed at 0** even though the AuricOS sysctl file set it to 1. `ufw` applies its own `/etc/ufw/sysctl.conf` when it starts, which overrode the setting. The installer now edits that file too.
- **The AIDE source signature couldn't be checked** because the signing key failed to download from the Ubuntu keyserver. It was imported from keys.openpgp.org and its fingerprint checked against upstream. `--skippgpcheck` was never used.

## Remaining Suggestions

All 13 are reviewed in the README's [Accepted Findings](../../README.md#accepted-findings-and-risk-decisions): 10 accepted as deliberate trade-offs, 2 false positives and 1 planned (systemd service sandboxing).
