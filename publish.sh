#!/usr/bin/env bash
# Render the site and push it live to gaboulafia.com
#
#   ./publish.sh                 -> commits as "Update site"
#   ./publish.sh "new paper"     -> commits with your message
#
set -euo pipefail
cd "$(dirname "$0")"

# Quarto: prefer one on PATH, otherwise the copy bundled inside RStudio.
if command -v quarto >/dev/null 2>&1; then
  QUARTO=quarto
elif [ -x /Applications/RStudio.app/Contents/Resources/app/quarto/bin/quarto ]; then
  QUARTO=/Applications/RStudio.app/Contents/Resources/app/quarto/bin/quarto
else
  echo "Can't find quarto. Is RStudio still installed?" >&2
  exit 1
fi

# A running preview server writes to docs/ too, and the two renders clobber
# each other. Stop it first.
if pgrep -f "quarto preview" >/dev/null 2>&1; then
  echo "Stopping the preview server first..."
  pkill -f "quarto preview" || true
  sleep 1
fi

echo "Rendering..."
"$QUARTO" render

if [ -z "$(git status --porcelain)" ]; then
  echo "Nothing changed. Site is already up to date."
  exit 0
fi

MSG="${1:-Update site}"
git add -A
git commit -q -m "$MSG"

echo "Pushing..."
git push -q origin main

echo
echo "Done. Live in ~1 minute at https://gaboulafia.com"
echo "  (GitHub has to rebuild; a hard refresh is Cmd-Shift-R)"
