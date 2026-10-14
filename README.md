# autobricks-pi

One-line setup for [Pi](https://pi.dev) with the AutoBricks AI provider. It asks for your API key interactively.

```bash
curl -fsSL https://adit-firdaus.github.io/autobricks-pi/install.sh | bash
```

Installs Pi from npm and writes `~/.pi/agent/{models,settings}.json` and `APPEND_SYSTEM.md` (default model `xiaomi/mimo-v2.6-flash`).

## Hexcade VPN helper
The installer also loads a system prompt (`prompts/hexcade-vpn.md`) and a `hexcade-vpn` skill that walk a student through importing the Hexcade WireGuard profile, bringing the tunnel up and verifying a challenge is reachable. Start `pi` and say: "help me connect the Hexcade VPN, profile is at <path>".
