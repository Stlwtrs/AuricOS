# Round 4: Copy Fail Mitigation and Bundled Security Tools

| | |
|---|---|
| Hardening index | 78 → **78** |
| Tests run | 247 |
| Suggestions | See [`docs/lynis/round-4/`](../lynis/round-4/) |

## Changes

| Control | Implementation |
|---|---|
| Copy Fail mitigation | `algif_aead` blocked in `/etc/modprobe.d/auricos-blacklist.conf`. [CVE-2026-31431](https://nvd.nist.gov/vuln/detail/CVE-2026-31431) ("Copy Fail") lets an unprivileged process write to the page cache of files it can only read, including setuid binaries, through the kernel's AF_ALG AEAD interface. The CachyOS kernel builds this interface as a module (`CONFIG_CRYPTO_USER_API_AEAD=m`), so blocking the module removes it. This is defense in depth on top of kernel updates. |
| Copy Fail detection | [CopyFix](https://github.com/Stlwtrs/CopyFix) installed, with `copyfix.timer` enabled to scan setuid and setgid binaries for page-cache tampering on a schedule |
| USB device alerts | [USBSnitch](https://github.com/Stlwtrs/USBSnitch) installed, with `usb-snitch.service` enabled to alert on new USB devices and flag BadUSB indicators |
| Socket inspection | [hextcp](https://github.com/Stlwtrs/hextcp) installed, a pure-Bash `/proc/net` socket viewer for systems without `ss` or `netstat` |
| Package supply chain | All three tools are packaged as Arch packages from tagged releases, built in clean chroots, with each tool's test suite run in `check()` during the build. PKGBUILDs are in [`packages/`](../../packages/). |
| AIDE database exclusion | `!/var/lib/aide` added to `/etc/aide.conf`, so AIDE no longer reports changes to its own database |

## Why the Score Didn't Change

Lynis has no test for `algif_aead`, Copy Fail, USB alerting or the bundled tools, so none of these changes could raise the index. The round is measured with the checks below instead. The test count stayed at 247, which shows that nothing in the round broke an existing check.

## Verification

```bash
sudo modprobe algif_aead; echo $?           # non-zero: module blocked
lsmod | grep algif_aead                     # no output
grep aide /etc/aide.conf | grep '^!'        # !/var/lib/aide
pacman -Q copyfix hextcp usbsnitch          # all three installed
systemctl is-enabled copyfix.timer          # enabled
systemctl is-active usb-snitch              # active
sudo copyfix; echo $?                       # 0: no tampering found
hextcp -h                                   # usage text
```

## Status

| Check | Result |
|---|---|
| `algif_aead` blocked | ✅ Verified |
| AIDE database exclusion | ✅ Verified |
| Lynis index and test count | ✅ 78, 247 tests |
| Tools installed and services running | ⏳ Re-testing after the build fix below |

## Problems and Fixes

- **Only CopyFix was installed.** The local repository's database listed only `copyfix`, so hextcp and USBSnitch never reached the ISO. `repo-add` was rerun with all three packages, and the database now lists all of them. Lesson: list the repository database (`tar -tf /opt/auricos-repo/auricos.db.tar.gz`) before building.
