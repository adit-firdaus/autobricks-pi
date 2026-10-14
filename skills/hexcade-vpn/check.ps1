# Read-only Hexcade VPN check. Usage: check.ps1 <profile.conf> [target-ip]
param([Parameter(Mandatory)][string]$Profile, [string]$Target)
if (-not (Test-Path $Profile)) { "FAIL profile not found: $Profile"; exit 1 }
$c = Get-Content $Profile -Raw
function Ok($m){ "PASS $m" }; function Bad($m){ "FAIL $m" }
if ($c -match '(?m)^\[Interface\]') { Ok '[Interface]' } else { Bad 'missing [Interface]' }
if ($c -match '(?m)^\[Peer\]') { Ok '[Peer]' } else { Bad 'missing [Peer]' }
$ep = if ($c -match '(?mi)^Endpoint\s*=\s*(.+)$') { $Matches[1].Trim() } else { '' }
"INFO endpoint: $ep"
if ($ep -like '82.22.63.213:*') { Ok 'endpoint is Hexcade hub' } else { Bad 'unexpected endpoint (expected 82.22.63.213:<port>)' }
if ($c -match '(?mi)^Address\s*=\s*(.+)$') { "INFO address: $($Matches[1].Trim())" }
if ($c -match '(?mi)^AllowedIPs\s*=\s*(.+)$') { "INFO allowedips: $($Matches[1].Trim())"; if ($Matches[1] -match '0\.0\.0\.0/0') { 'WARN full-tunnel profile' } }
if ($c -match '(?mi)^PrivateKey\s*=\s*\S{40,}') { Ok 'private key present (not shown)' } else { Bad 'no private key' }
if ($Target) { if (Test-Connection $Target -Count 3 -Quiet) { Ok "ping $Target" } else { Bad "ping $Target" } }
