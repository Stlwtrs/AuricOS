# Contributing to AuricOS

Thanks for your interest in AuricOS. Bug reports, testing results, and hardening suggestions are all welcome.

## Ways to Contribute

- **Report bugs** using the bug report template in the Issues tab.
- **Share test results**, especially from physical hardware or UEFI systems, which are not yet fully tested.
- **Suggest hardening improvements.** Please include the reasoning and any trade-offs, since AuricOS aims to stay usable as a desktop.
- **Submit pull requests** for fixes or improvements.

For security vulnerabilities, follow [SECURITY.md](SECURITY.md) instead of opening a public issue.

## Development Setup

1. Use an Arch-based host with `archiso` and `devtools` installed.
2. Build any AUR packages listed in `packages.x86_64` into a local repository (see the [README](README.md#building-auricos)).
3. Build the ISO:

   ```bash
   sudo mkarchiso -v -w work -o out .
   ```

## Testing Changes

Every change should be tested on a **fresh installation**, not only in the live session:

1. Create a blank disk: `qemu-img create -f qcow2 auric-test.qcow2 20G`
2. Boot the ISO in QEMU/KVM and install with Calamares.
3. Boot the installed disk without the ISO attached.
4. Run the [post-install verification checklist](README.md#post-install-verification-checklist).
5. For hardening changes, run `sudo lynis audit system --quick` and include the hardening index before and after.

## Guidelines

- **One change per pull request.** It keeps reviews and rollbacks simple.
- **Avoid shipping files that packages own** (for example `/etc/issue` or `/etc/skel/.zshrc`). Stage them under `/usr/share/auricos/` and copy them into place during installation instead.
- **New executable files** need an entry in `profiledef.sh` under `file_permissions`.
- **Never commit** build output (`work/`, `out/`, ISOs, disk images, packages) or personal paths and credentials.
- **Explain security trade-offs.** If a change weakens a default for usability, say why.

## Commit Messages

Use short, descriptive messages in the imperative mood:

```text
Add auditd rule for kernel module loading
Fix ufw overriding log_martians
```
