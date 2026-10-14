#!/usr/bin/env bash
# Read-only Hexcade VPN check. Usage: check.sh <profile.conf> [target-ip]
f="${1:?profile.conf}"; t="${2:-}"
[ -f "$f" ] || { echo "FAIL profile not found: $f"; exit 1; }
ok(){ echo "PASS $*"; }; bad(){ echo "FAIL $*"; }
grep -q '^\[Interface\]' "$f" && ok "[Interface]" || bad "missing [Interface]"
grep -q '^\[Peer\]' "$f" && ok "[Peer]" || bad "missing [Peer]"
ep=$(grep -i '^Endpoint' "$f" | head -1 | sed 's/.*= *//'); echo "INFO endpoint: ${ep:-none}"
case "$ep" in 82.22.63.213:*) ok "endpoint is Hexcade hub";; *) bad "unexpected endpoint (expected 82.22.63.213:<port>)";; esac
addr=$(grep -i '^Address' "$f" | head -1 | sed 's/.*= *//'); echo "INFO address: ${addr:-none}"
ai=$(grep -i '^AllowedIPs' "$f" | head -1 | sed 's/.*= *//'); echo "INFO allowedips: ${ai:-none}"
case "$ai" in *0.0.0.0/0*) echo "WARN full-tunnel profile: all traffic goes through VPN";; esac
grep -qi '^PrivateKey *= *.\{40,\}' "$f" && ok "private key present (not shown)" || bad "no private key"
iface=$(basename "$f" .conf)
if command -v wg >/dev/null 2>&1; then
  hs=$(wg show "$iface" latest-handshakes 2>/dev/null | awk '{print $2}' | head -1)
  if [ -n "$hs" ] && [ "$hs" != 0 ]; then age=$(( $(date +%s) - hs )); [ "$age" -lt 180 ] && ok "handshake ${age}s ago" || bad "handshake stale (${age}s)"
  else echo "INFO tunnel '$iface' not up or no handshake yet (may need sudo to read)"; fi
else echo "INFO wg not installed"; fi
if [ -n "$t" ]; then ping -c 3 -W 3 "$t" >/dev/null 2>&1 && ok "ping $t" || bad "ping $t"; fi
