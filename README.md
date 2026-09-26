# Sutra

A personal second brain that runs on your own Mac.

Sutra remembers what you tell it, reads your documents and email, searches and
reads the web, works in your tools (Gmail, Calendar, Jira, Notion, Slack,
GitHub), helps you learn things properly, and hands builds to Claude Code or
Codex. Its memory is a folder of plain markdown you own — open it in Obsidian.

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
| `sutra version` | what's installed |

## Privacy and safety

- Runs entirely on your machine and only listens on `localhost`.
- No account, no sign-in: whoever uses this computer is treated as you.
- Anything that sends, posts, buys or changes something asks you first.
- Model calls go to OpenRouter with your own key; everything else stays local.

This repository holds the installer, the website and the release builds.
Sutra itself is distributed as a compiled build under the MIT license
(see [LICENSE](LICENSE)).
