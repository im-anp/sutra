# Sunday

A personal second brain that runs on your own Mac.

Sunday remembers what you tell it, reads your documents, searches and reads the
web, creates PDFs, Word docs and pitch decks, works in your tools (Jira, Notion,
GitHub, and any local MCP server), helps you learn things properly, and hands
builds to Claude Code or Codex. It recalls the notes that matter before every
reply, and learns how you like things done — drafting short procedures from
your corrections that take effect only once you approve them. Its everyday apps track spending, nutrition
and workouts (with a short video for every exercise, and a nudge when it's
time to level up). Use it from your phone in any browser with Sunday Remote, or
over Telegram, and let it use your own Chrome (via the Sunday extension) for
sites that block automation. Its memory is a folder of plain markdown you own — open it in
Obsidian.

**Website:** https://sundaybot.me

> **Beta:** Sunday is in public beta — features change and things can break.
> Keep backups of anything important. Using it means you agree to the
> [Terms](https://platform.sundaybot.me/terms) and
> [Privacy Policy](https://platform.sundaybot.me/privacy).

## Install

Download **[Sunday.dmg](https://github.com/im-anp/sutra/releases/latest/download/Sunday.dmg)**
(macOS on Apple Silicon), open it and drag Sunday into Applications. It's
signed and notarized by Apple, brings everything it needs, lives in the menu
bar and updates itself.

The app is free and open source. For the AI, log in with a
[Sunday plan](https://sundaybot.me/#pricing) (from ₹799/month, nothing to set
up) or use your own [OpenRouter key](https://openrouter.ai/keys).

To use Sunday from your phone, open Settings › Remote in the app, then go to
https://app.sundaybot.me and type the code.

## Privacy and safety

- Runs entirely on your machine and only listens on `localhost`.
- No sign-in to the app: whoever uses this computer is treated as you. A Sunday
  account (optional) only holds your plan — no chats or files.
- Anything that sends, posts, buys or changes something asks you first.
- Model calls go to OpenRouter — through your Sunday plan or your own key;
  everything else stays local.
- Sunday Remote is off until you set it up. Your Mac connects out to the relay
  (nothing listens on your network); messages pass through it over HTTPS and
  are held at most 10 minutes. Settings › Remote unpairs any phone or browser.

This repository holds the website and the release builds.
Sunday itself is distributed as a compiled build under the MIT license
(see [LICENSE](LICENSE)).
