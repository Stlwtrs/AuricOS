# Round 2: Accounts, Authentication and Toolchain

| | |
|---|---|
| Hardening index | 72 → **75** |
| Tests run | 244 |
| Suggestions | 16 |

## Changes

| Control | Implementation |
|---|---|
| Login banner | Authorized-use warning in `/etc/issue` |
| Default permissions | `umask 027` in `login.defs` and `/etc/profile` |
| Password hashing | yescrypt cost factor raised to 7 |
| Password quality | `pam_pwquality` in `system-auth`: dictionary check, username check, repeated-character limit |
| Unused protocols | `dccp`, `sctp`, `rds`, `tipc` and FireWire storage modules blocked in `/etc/modprobe.d/auricos-blacklist.conf` |
| Compiler restriction | `gcc`, `cc`, `as`, `ld`, `clang` and related tools set to `root:wheel`, mode `750`, with a pacman hook that re-applies this after compiler updates |
| System statistics | `sysstat` collection and summary timers enabled |

## Verification

```bash
cat /etc/issue                                # banner text
umask                                         # 0027
grep YESCRYPT_COST_FACTOR /etc/login.defs     # 7
grep pwquality /etc/pam.d/system-auth         # pam_pwquality line present
sudo modprobe dccp; echo $?                   # non-zero: module blocked
stat -c '%U:%G %a' "$(readlink -f /usr/bin/gcc)"  # root:wheel 750
systemctl is-active sysstat                   # active
```

## Problems and Fixes

- **The first build was missing the round's files and cleanup steps.** They had not been saved into the profile, so the rebuild changed nothing. They were rewritten with `printf` and checked in the profile before rebuilding.
- **Typing quotes failed in the VM.** An "international" keyboard layout made `'` and `"` dead keys. This was a test-environment problem, not an AuricOS bug, but it is now in the troubleshooting guide.
