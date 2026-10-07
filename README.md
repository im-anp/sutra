# Sutra

A personal second brain that runs on your own Mac.

Sutra remembers what you tell it, reads your documents, searches and reads the
web, creates PDFs, Word docs and pitch decks, works in your tools (Jira, Notion,
GitHub, and any local MCP server), helps you learn things properly, and hands
builds to Claude Code or Codex. It recalls the notes that matter before every
reply, and learns how you like things done — drafting short procedures from
your corrections that take effect only once you approve them. Its everyday apps track spending, nutrition
and workouts (with a short video for every exercise, and a nudge when it's
time to level up). Use it from your phone in any browser with Sutra Remote, or
over Telegram, and let it use your own Chrome (via the Sutra extension) for
sites that block automation. Its memory is a folder of plain markdown you own — open it in
Obsidian.

**Website:** https://im-anp.github.io/sutra

## Install

Needs macOS on Apple Silicon, [Node 24+](https://nodejs.org), and an
[OpenRouter key](https://openrouter.ai/keys).

```bash
curl -fsSL https://raw.githubusercontent.com/im-anp/sutra/main/install.sh | bash
```

Then run `sutra`. It opens at http://localhost:3000.

| command | |
|---|---|
| `sutra` | start it and open the browser |
| `sutra update` | move to the latest version |
| `sutra key` | set or replace the OpenRouter key |
| `sutra doctor` | check the install |
| `sutra vault` | print the vault path (`--open` to reveal it) |
| `sutra remote setup` | use Sutra from your phone — then open https://sutra-remote.vercel.app and type the code |
| `sutra remote code` | a new pairing code (`list` / `revoke <id\|all>` / `on` / `off`) |
| `sutra version` | what's installed |

## Privacy and safety

- Runs entirely on your machine and only listens on `localhost`.
- No account, no sign-in: whoever uses this computer is treated as you.
- Anything that sends, posts, buys or changes something asks you first.
- Model calls go to OpenRouter with your own key; everything else stays local.
- Sutra Remote is off until you set it up. Your Mac connects out to the relay
  (nothing listens on your network); messages pass through it over HTTPS and
  are held at most 10 minutes. `sutra remote revoke all` unpairs every browser.

This repository holds the installer, the website and the release builds.
Sutra itself is distributed as a compiled build under the MIT license
(see [LICENSE](LICENSE)).
