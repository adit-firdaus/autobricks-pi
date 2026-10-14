#!/usr/bin/env bash
# Usage: AUTOBRICKS_API_KEY=xxx bash autobricks-pi-setup.sh
# Installs Pi and preconfigures the AutoBricks AI provider, default model and system prompt.
set -euo pipefail
: "${AUTOBRICKS_API_KEY:?set AUTOBRICKS_API_KEY}"

code=$(curl -s -o /dev/null -w '%{http_code}' -H "Authorization: Bearer $AUTOBRICKS_API_KEY" https://api.autobricksai.com/v1/models)
[ "$code" = 200 ] || { echo "AutoBricks key rejected (HTTP $code)"; exit 1; }

npm i -g @earendil-works/pi-coding-agent --ignore-scripts

D="${PI_CODING_AGENT_DIR:-$HOME/.pi/agent}"
mkdir -p "$D"; umask 077

cat > "$D/models.json" <<EOF
{"providers":{"autobricks":{"baseUrl":"https://api.autobricksai.com/v1","api":"openai-completions","apiKey":"$AUTOBRICKS_API_KEY","models":[
{"id":"xiaomi/mimo-v2.6-flash"},{"id":"autobricksai/mimo-2.5"},{"id":"autobricksai/claude-haiku-4.5"},{"id":"autobricksai/claude-sonnet-4.6"},
{"id":"autobricksai/claude-opus-4.7"},{"id":"autobricksai/gemini-2.5-flash"},{"id":"autobricksai/gemini-2.5-pro"},
{"id":"autobricksai/gpt-5.4"},{"id":"autobricksai/gpt-4.1"},{"id":"autobricksai/deepseek-v4"},{"id":"autobricksai/qwen3-235b"}]}}}
EOF

cat > "$D/settings.json" <<'EOF'
{"defaultProvider":"autobricks","defaultModel":"xiaomi/mimo-v2.6-flash"}
EOF

cat > "$D/APPEND_SYSTEM.md" <<'EOF'
You are an AutoBricks AI coding assistant. Be concise, act directly, and show what you changed.
EOF

echo "Done. Run: pi"
