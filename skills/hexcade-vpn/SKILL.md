---
name: hexcade-vpn
description: Validate a Hexcade WireGuard profile, bring the tunnel up and check handshake and reachability of a challenge machine. Use when a student has trouble connecting the Hexcade VPN or reaching a challenge.
---

# Hexcade VPN checks

Run from this skill's folder. Keys are never printed.

- macOS/Linux: `bash check.sh <profile.conf> [target-ip]`
- Windows: `powershell -File check.ps1 <profile.conf> [target-ip]`

The script validates the profile (sections, endpoint, AllowedIPs, suspicious 0.0.0.0/0), shows the redacted endpoint/address, and, if the tunnel is up, the handshake age and a ping to `target-ip`. It changes nothing. Bring the tunnel up/down yourself with `wg-quick up|down <profile>` (Windows: WireGuard app or `wireguard /installtunnelservice`).

See the system prompt for the failure ladder.
