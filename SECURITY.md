# Security Policy

AuricOS is a security-focused distribution, so vulnerability reports are taken seriously and handled privately.

## Supported Versions

AuricOS is in active development. Only the latest state of the `main` branch and the most recent tagged release receive fixes.

| Version | Supported |
|---|:--:|
| `main` (development) | ✅ |
| Latest tagged release | ✅ |
| Older releases | ❌ |

## Scope

**In scope:** issues introduced by AuricOS itself, including:

- The installer configuration and post-install scripts (`airootfs/etc/calamares/`, `airootfs/usr/local/bin/`)
- Hardening configuration (sysctl, auditd, AppArmor enablement, PAM, firewall, file permissions)
- Default accounts, credentials, services, or permissions on installed or live systems
- Build-time artifacts or configuration that leak into the ISO or installed systems
- Weaknesses in how packages are built, sourced, or served

**Out of scope:** vulnerabilities in upstream software (the Linux kernel, Arch Linux or CachyOS packages, Calamares, browsers, etc.). Please report those to the upstream project. If an upstream issue is made worse by an AuricOS default, that part is in scope.

## Reporting a Vulnerability

**Please do not open a public issue for security problems.**

Report privately through GitHub:

1. Go to the repository's **Security** tab.
2. Select **Report a vulnerability**.
3. Include:
   - A description of the issue and its impact
   - Steps to reproduce, including the ISO build or commit used
   - Whether it affects the live session, installed systems, or both
   - Any suggested fix, if you have one

## What to Expect

AuricOS is maintained by one person, so responses are best effort:

- **Acknowledgement** within 7 days
- **Assessment** and a planned fix or mitigation as soon as practical
- **Credit** in the changelog and release notes, unless you prefer to remain anonymous

Please allow a reasonable time for a fix before public disclosure.

## Verifying Project Material

Donation addresses and future release checksums are signed with the project's PGP key, published at [`docs/pgp-key.asc`](docs/pgp-key.asc). Treat any address or checksum that does not verify against this key as untrusted.
