# Verifying a Release

Every AuricOS release on the [Releases page](https://github.com/Stlwtrs/AuricOS/releases) includes a checksum and a PGP signature. Check both before writing the ISO to a USB drive:

- The **checksum** shows the download isn't corrupted.
- The **signature** shows the ISO was released by the AuricOS maintainer and wasn't altered afterward. A checksum alone can't prove this, because anyone who can replace the ISO can replace its checksum too.

## Files

Download all four files into the same folder:

| File | Purpose |
|---|---|
| `auricos-<version>-x86_64.iso` | The ISO |
| `auricos-<version>-x86_64.iso.sig` | Signature of the ISO |
| `SHA256SUMS` | Checksum of the ISO |
| `SHA256SUMS.sig` | Signature of the checksum file |

## 1. Check the Checksum

**Linux:**
```bash
sha256sum -c SHA256SUMS
```
The output should end in `OK`.

**macOS:**
```bash
shasum -a 256 -c SHA256SUMS
```

**Windows (PowerShell):**
```powershell
Get-FileHash .\auricos-<version>-x86_64.iso -Algorithm SHA256
```
Compare the result with the value in `SHA256SUMS`. Letter case doesn't matter.

## 2. Check the Signature

This needs GnuPG (`gpg`). It's preinstalled on most Linux systems; on Windows use [Gpg4win](https://www.gpg4win.org/), and on macOS [GPG Suite](https://gpgtools.org/) or `brew install gnupg`.

**Import the AuricOS signing key** from this repository:
```bash
curl -sL https://github.com/Stlwtrs/AuricOS/raw/main/docs/pgp-key.asc | gpg --import
```

**Check the key's fingerprint:**
```bash
gpg --fingerprint 04544553060CE6C62DA54EE1E013161D5438F94A
```
It must be exactly:
```text
0454 4553 060C E6C6 2DA5  4EE1 E013 161D 5438 F94A
```
The same fingerprint is published in [SECURITY.md](../SECURITY.md) and in each release's notes. If they don't all match, don't use the ISO, and report it as described in [SECURITY.md](../SECURITY.md).

**Verify the ISO:**
```bash
gpg --verify auricos-<version>-x86_64.iso.sig auricos-<version>-x86_64.iso
```

A valid result includes:
```text
gpg: Good signature from "Stlwtrs (Zach White) <sskrypt0@proton.me>"
```

gpg may also print `WARNING: This key is not certified with a trusted signature!`. This is normal: it means you haven't personally certified the key, not that the signature is bad. The fingerprint check above is what establishes that it's the right key.

**`BAD signature`** means the file was modified or damaged. Delete it and download it again. If it fails again, don't use it, and report it.
