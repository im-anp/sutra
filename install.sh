#!/usr/bin/env bash
#
# Sutra installer.
#
#   curl -fsSL https://raw.githubusercontent.com/im-anp/sutra/main/install.sh | bash
#
# Downloads the latest Sutra build to ~/sutra (SUTRA_DIR overrides), installs
# its dependencies, asks for your OpenRouter key and vault folder, and puts
# `sutra` on your PATH. Re-running it updates an existing install.

# Everything is inside main(), called on the last line, so a download cut off
# halfway through runs nothing instead of half a script.
main() {
set -euo pipefail

RELEASES_REPO="im-anp/sutra"
APP="${SUTRA_DIR:-$HOME/sutra}"

BOLD=$'\033[1m'; GREEN=$'\033[32m'; DIM=$'\033[2m'; RED=$'\033[31m'; OFF=$'\033[0m'
say()  { printf '%s\n' "  $*"; }
ok()   { printf '  %s✓%s %s\n' "$GREEN" "$OFF" "$*"; }
warn() { printf '  %s✗%s %s\n' "$RED" "$OFF" "$*"; }
step() { printf '\n%s  %s%s\n' "$BOLD" "$*" "$OFF"; }

# Piped from curl, stdin is this script, so questions read from the terminal.
if [ -r /dev/tty ]; then TTY=/dev/tty; else TTY=/dev/stdin; fi

printf '\n  %s%ssutra%s %s— your second brain%s\n\n' "$GREEN" "$BOLD" "$OFF" "$DIM" "$OFF"

# ── Platform and Node ───────────────────────────────────────────────────────
step "Checking this machine"
if [ "$(uname -s)" != "Darwin" ] || [ "$(uname -m)" != "arm64" ]; then
  warn "Sutra currently ships for macOS on Apple Silicon (M1 or newer)."
  say "This machine is $(uname -s) $(uname -m)."
  exit 1
fi
if ! command -v node >/dev/null 2>&1; then
  warn "Node is not installed. Sutra needs Node 24 or newer."
  say "  brew install node      — or download it from https://nodejs.org"
  exit 1
fi
NODE_MAJOR="$(node -p 'process.versions.node.split(".")[0]')"
if [ "$NODE_MAJOR" -lt 24 ]; then
  warn "Node $(node -v) found; Sutra needs 24 or newer."
  say "  brew upgrade node      — or nvm install 24"
  exit 1
fi
ok "macOS on Apple Silicon, Node $(node -v)"

# ── Existing install ────────────────────────────────────────────────────────
if [ -d "$APP/.git" ]; then
  warn "$APP is a source checkout, not a release install. Leaving it alone."
  say "Set SUTRA_DIR to install somewhere else."
  exit 1
fi
if [ -f "$APP/VERSION" ] && [ -f "$APP/cli/sutra.mjs" ]; then
  step "Sutra is already installed — updating"
  node "$APP/cli/sutra.mjs" update
  exit 0
fi
if [ -e "$APP" ] && [ -n "$(ls -A "$APP" 2>/dev/null)" ]; then
  warn "$APP already exists and isn't a Sutra install. Move it, or set SUTRA_DIR."
  exit 1
fi

# ── Download ────────────────────────────────────────────────────────────────
step "Downloading Sutra"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
URL="$(node -e '
  fetch("https://api.github.com/repos/" + process.argv[1] + "/releases/latest", { headers: { "user-agent": "sutra-installer" } })
    .then((r) => { if (!r.ok) throw new Error("GitHub answered " + r.status); return r.json(); })
    .then((rel) => {
      const a = (rel.assets || []).find((x) => x.name.endsWith("-darwin-arm64.tar.gz"));
      if (!a) throw new Error("no macOS build in the latest release");
      console.log(a.browser_download_url);
    })
    .catch((e) => { console.error(e.message); process.exit(1); });
' "$RELEASES_REPO")" || { warn "Couldn't find a Sutra release to download."; exit 1; }
curl -fsSL "$URL" -o "$TMP/sutra.tar.gz"
tar -xzf "$TMP/sutra.tar.gz" -C "$TMP"
mkdir -p "$(dirname "$APP")"
rm -rf "$APP"
mv "$TMP/sutra" "$APP"
cd "$APP"
ok "Sutra $(cat VERSION) → $APP"

# ── Dependencies ────────────────────────────────────────────────────────────
step "Installing dependencies"
say "${DIM}A minute or two — it includes a local embedding model runtime.${OFF}"
npm ci --omit=dev --no-audit --no-fund --loglevel=error
ok "Dependencies installed"

# ── Key and vault ───────────────────────────────────────────────────────────
touch .env.local
chmod 600 .env.local

step "Model access"
say "Sutra runs on OpenRouter — one key, every model."
say "${DIM}Get one at https://openrouter.ai/keys${OFF}"
printf '\n  Paste your OpenRouter key: '
read -r -s OPENROUTER_KEY < "$TTY" || OPENROUTER_KEY=""   # -s: the key never lands in scrollback
printf '\n'
if [ -z "$OPENROUTER_KEY" ]; then
  warn "No key given — set it later with: sutra key"
else
  printf 'OPENROUTER_API_KEY=%s\n' "$OPENROUTER_KEY" >> .env.local
  ok "Key saved to $APP/.env.local (readable only by you)"
fi

step "Your vault"
DEFAULT_VAULT="$HOME/Documents/Sutra"
say "Your memory is plain markdown in a folder you own — point Obsidian at it."
printf '  Vault folder [%s]: ' "$DEFAULT_VAULT"
read -r VAULT_INPUT < "$TTY" || VAULT_INPUT=""
VAULT="${VAULT_INPUT:-$DEFAULT_VAULT}"
VAULT="${VAULT/#\~/$HOME}"
mkdir -p "$VAULT"
printf 'SUTRA_VAULT=%s\n' "$VAULT" >> .env.local
ok "Vault ready at $VAULT"

# ── The `sutra` command ─────────────────────────────────────────────────────
step "Installing the sutra command"
chmod +x "$APP/cli/sutra.mjs"
BIN_DIR=""
for candidate in "$HOME/.local/bin" "/usr/local/bin" "$HOME/bin"; do
  if [ -d "$candidate" ] && [ -w "$candidate" ]; then BIN_DIR="$candidate"; break; fi
done
if [ -z "$BIN_DIR" ]; then
  BIN_DIR="$HOME/.local/bin"
  mkdir -p "$BIN_DIR"
fi
ln -sf "$APP/cli/sutra.mjs" "$BIN_DIR/sutra"
ok "sutra → $BIN_DIR/sutra"

printf '\n  %s%sSutra is ready.%s\n\n' "$GREEN" "$BOLD" "$OFF"
case ":$PATH:" in
  *":$BIN_DIR:"*) say "Start it:    ${BOLD}sutra${OFF}" ;;
  *)
    warn "$BIN_DIR is not on your PATH yet. Add this to ~/.zshrc:"
    say ""
    say "    ${BOLD}export PATH=\"$BIN_DIR:\$PATH\"${OFF}"
    say ""
    say "Then: ${BOLD}sutra${OFF}   (or run it now as ${BOLD}$BIN_DIR/sutra${OFF})"
    ;;
esac
say ""
say "  ${BOLD}sutra${OFF}          start, and open the browser"
say "  ${BOLD}sutra update${OFF}   move to the latest version"
say "  ${BOLD}sutra doctor${OFF}   check the install"
say ""
say "${DIM}Runs entirely on this machine and only answers this machine."
say "No account, no sign-in: whoever uses this computer is treated as you.${OFF}"
say ""
}

main "$@"
