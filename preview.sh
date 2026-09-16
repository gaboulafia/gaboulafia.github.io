#!/usr/bin/env bash
# Preview the site locally before publishing.
# Opens http://localhost:4321 and reloads as you save. Ctrl-C to stop.
set -euo pipefail
cd "$(dirname "$0")"

if command -v quarto >/dev/null 2>&1; then
  QUARTO=quarto
elif [ -x /Applications/RStudio.app/Contents/Resources/app/quarto/bin/quarto ]; then
  QUARTO=/Applications/RStudio.app/Contents/Resources/app/quarto/bin/quarto
else
  echo "Can't find quarto. Is RStudio still installed?" >&2
  exit 1
fi

# Clear out any preview left running from last time.
pkill -f "quarto preview" 2>/dev/null || true
sleep 1

echo "Preview at http://localhost:4321 — Ctrl-C to stop."
echo "Stop this before running ./publish.sh"
echo
exec "$QUARTO" preview --port 4321
