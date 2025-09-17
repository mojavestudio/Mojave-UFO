#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=$(cd "$(dirname "$0")/.." && pwd)
DOCS_DIR="$ROOT_DIR/docs"

mkdir -p "$DOCS_DIR"

APP_PATH="$ROOT_DIR/mojave_ufo_mobile"

echo "\n==> Building unified app: $APP_PATH -> docs/"
pushd "$APP_PATH" >/dev/null
if command -v npm >/dev/null 2>&1; then
  npm i
  npm run build
else
  echo "npm not found. Please install Node.js 18+ and npm."
  exit 1
fi
if [[ -d out ]]; then
  rm -rf "$DOCS_DIR"
  mkdir -p "$DOCS_DIR"
  cp -R out/* "$DOCS_DIR/"
  # Recreate .nojekyll so GitHub Pages serves _next assets
  echo "# Disable Jekyll so GitHub Pages serves the _next/ folder" > "$DOCS_DIR/.nojekyll"
else
  echo "Build output folder 'out' not found in $APP_PATH"
  exit 1
fi
popd >/dev/null

echo "\nAll builds exported to: $DOCS_DIR"

