# Round 1: Network and Kernel

| | |
|---|---|
| Hardening index | 64 → **72** |
| Tests run | 244 |
| Suggestions | Not recorded |

## Changes

| Control | Implementation |
|---|---|
| Default-deny firewall | `ufw` enabled during installation: deny incoming, allow outgoing |
| Mandatory access control | AppArmor enabled with the `lsm=` kernel parameter, which the installer adds to GRUB |
| Audit logging | `auditd` enabled |
| Kernel and network settings | 25 settings in `/etc/sysctl.d/99-auricos-hardening.conf`: reverse-path filtering, ICMP redirect and source-route rejection, SYN cookies, `kptr_restrict=2`, `dmesg_restrict=1`, `yama.ptrace_scope=1`, BPF hardening, protected FIFOs and regular files, `sysrq=0` |
| Core dumps | Disabled with systemd-coredump and `limits.d` |
| Vulnerability checks | `arch-audit` and Lynis included |

## Verification

```bash
sudo ufw status verbose           # Status: active, deny (incoming)
sudo aa-status | head -3          # AppArmor loaded, profiles in enforce mode
systemctl is-active auditd        # active
sysctl kernel.kptr_restrict       # 2
ulimit -c                         # 0
```

## Problems and Fixes

- **The sysctl file was missing from the installed system.** It had been saved in the profile root instead of `airootfs/etc/sysctl.d/`, so it never entered the ISO. Lynis showed no change until the file was moved. Lesson: confirm each file on the installed system, not only in the profile.
