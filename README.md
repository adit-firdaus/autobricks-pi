# autobricks-pi

One-line setup for [Pi](https://pi.dev) with the AutoBricks AI provider. Only your API key is needed.

```bash
AUTOBRICKS_API_KEY=your-key bash -c "$(curl -fsSL https://adit-firdaus.github.io/autobricks-pi/install.sh)"
```

Installs Pi from npm and writes `~/.pi/agent/{models,settings}.json` and `APPEND_SYSTEM.md` (default model `xiaomi/mimo-v2.6-flash`).
