# Release Checklist

The steps for publishing an AuricOS release. Every release ISO is built from a committed, tagged state and tested before it's signed.

## 1. Prepare the Source

- [ ] All changes are committed and pushed, and `git status` is clean
- [ ] The `[Unreleased]` or in-development section of [CHANGELOG.md](../CHANGELOG.md) is renamed to the release version and date
- [ ] README's Project Status table and the wiki are up to date
- [ ] `bash scripts/prepublic-check.sh` passes

## 2. Build

```bash
sudo rm -rf work
sudo mkarchiso -v -w work -o out .
```

Remove older ISOs from `out/` so the release script picks the right one.

## 3. Test the Exact ISO Being Released

Install it on a fresh virtual disk in **both** BIOS and UEFI mode (commands in the wiki's [Installation](https://github.com/Stlwtrs/AuricOS/wiki/Installation) page), and on physical hardware if available.

- [ ] Live session boots straight to the desktop; the installer opens without a password prompt
- [ ] Installation completes in BIOS mode
- [ ] Installation completes in UEFI mode, and the system still boots after resetting the firmware settings (fallback path)
- [ ] Post-install checklist in the README passes: firewall active, AppArmor and auditd running, root locked, no live user (`id auric` fails), no autologin in `/etc/lightdm/`
- [ ] Bundled tools installed and running: `pacman -Q copyfix hextcp usbsnitch`, `systemctl is-active usb-snitch`, `systemctl is-enabled copyfix.timer`
- [ ] Lynis index is at least 78. Inside the installed VM, download the capture script with `curl -LO https://github.com/Stlwtrs/AuricOS/raw/main/scripts/lynis-capture.sh` and run `sudo bash lynis-capture.sh <version>`. Keep the folder and commit it to `docs/lynis/<version>/` after publishing (committing it before would make the tested ISO older than the latest commit)

## 4. Sign and Publish

```bash
git tag -u 04544553060CE6C62DA54EE1E013161D5438F94A v1.0.0 -m "AuricOS v1.0.0"
git push origin v1.0.0
bash scripts/release.sh v1.0.0
```

Run these as your normal user, not with `sudo`. The script checks the ISO size, the source state, the tag and the signing key, then writes the checksum, both signatures and draft release notes to `release/v1.0.0/`.

- [ ] Edit `release/v1.0.0/release-notes.md`: fill in Highlights and Known Limitations
- [ ] Publish with the `gh release create` command the script prints, or upload the same four files at the repository's **Releases → Draft a new release** page
- [ ] Download the published files on another machine and follow [Verifying a Release](verifying-releases.md)

## 5. After Publishing

- [ ] README: link the release, and change "Pre-built ISOs are not yet published" in Project Status
- [ ] Wiki: update the Installation page to download a release instead of building from source
- [ ] Close the milestone on GitHub

## Signing Key

| | |
|---|---|
| Fingerprint | `0454 4553 060C E6C6 2DA5  4EE1 E013 161D 5438 F94A` |
| Expires | 2028-11-19 |

Before it expires, extend the key and its subkey:

```bash
gpg --quick-set-expire 04544553060CE6C62DA54EE1E013161D5438F94A 2y
gpg --quick-set-expire 04544553060CE6C62DA54EE1E013161D5438F94A 2y '*'
```

Then publish the updated public key to `docs/pgp-key.asc`. The private key never goes in the repository.
