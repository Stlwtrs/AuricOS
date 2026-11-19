# Changelog

All notable changes to AuricOS are documented here.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [1.0-beta] - In development

### Added
- archiso-based live ISO with an XFCE desktop, custom panel layout, wallpaper, and LightDM theme
- Alacritty as the default terminal with a gold palette and transparency; zsh and fastfetch
- Calamares 3.4.2 graphical installer with AuricOS branding and an installation slideshow
- Post-install pipeline that removes live-only components, the installer, and build-time repositories
- CachyOS `linux-cachyos-bore` kernel, with `[cachyos]` prioritized below Arch repositories
- Installer password policy (minimum 8 characters, no empty passwords) and `auricos` default hostname

### Security
- **Hardening round 1 (Lynis 64 → 72):** ufw default-deny firewall; AppArmor enabled via kernel parameter; auditd; 25 kernel and network sysctl controls; core dumps disabled; `arch-audit` and Lynis included
- **Hardening round 2 (Lynis 72 → 75):** login banner; `umask 027`; yescrypt cost factor 7; `pam_pwquality`; dccp, sctp, rds, tipc and FireWire modules blocked; compilers restricted to `wheel` with a pacman hook; sysstat
- **Hardening round 3 (Lynis 75 → 78):** auditd ruleset (16 rules); AIDE file integrity monitoring built from a PGP-verified source; ufw `log_martians` override fixed; `sshd_config` restricted to `600`
- Root account locked on all installations; SSH disabled by default

### Fixed
- Root password re-enabled by the installer's users step after cleanup had locked it
- Installed systems using bash instead of zsh
- Package database warnings caused by a build-host pacman field (`%INSTALLED_DB%`)
- Installer launcher and Calamares remaining on installed systems
