#!/bin/bash
set -eu

# Obsidian Vault初期化スクリプト
# 環境変数 $OBSIDIAN_VAULT を使用してVaultのフォルダ構造を作成する

if [ -z "${OBSIDIAN_VAULT:-}" ]; then
  echo "ERROR: OBSIDIAN_VAULT environment variable is not set."
  echo "Please set it to your Obsidian vault path."
  echo "Example: export OBSIDIAN_VAULT=~/Documents/ObsidianVault"
  exit 1
fi

if [ ! -d "$OBSIDIAN_VAULT" ]; then
  echo "ERROR: Obsidian vault not found at: $OBSIDIAN_VAULT"
  exit 1
fi

echo "Initializing Obsidian vault structure at: $OBSIDIAN_VAULT"

# Create directories
mkdir -p "$OBSIDIAN_VAULT/Knowledge"
mkdir -p "$OBSIDIAN_VAULT/Decisions"
mkdir -p "$OBSIDIAN_VAULT/Mistakes"
mkdir -p "$OBSIDIAN_VAULT/Projects"
mkdir -p "$OBSIDIAN_VAULT/Preferences"

# Create .gitkeep files to preserve directories
touch "$OBSIDIAN_VAULT/Knowledge/.gitkeep"
touch "$OBSIDIAN_VAULT/Decisions/.gitkeep"
touch "$OBSIDIAN_VAULT/Mistakes/.gitkeep"
touch "$OBSIDIAN_VAULT/Projects/.gitkeep"
touch "$OBSIDIAN_VAULT/Preferences/.gitkeep"

echo "Created directories:"
echo "  - Knowledge/"
echo "  - Decisions/"
echo "  - Mistakes/"
echo "  - Projects/"
echo "  - Preferences/"
echo ""
echo "Vault initialization complete!"
echo ""
echo "Next steps:"
echo "1. Add your profile to Preferences/personal.md"
echo "2. Start using the obsidian-memory skills in your sessions"
