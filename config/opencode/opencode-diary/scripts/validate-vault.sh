#!/bin/bash
set -eu

# Obsidian Vault検証スクリプト
# Vaultの構造が正しいか確認する

if [ -z "${OBSIDIAN_VAULT:-}" ]; then
  echo "ERROR: OBSIDIAN_VAULT environment variable is not set."
  exit 1
fi

if [ ! -d "$OBSIDIAN_VAULT" ]; then
  echo "ERROR: Obsidian vault not found at: $OBSIDIAN_VAULT"
  exit 1
fi

echo "Validating Obsidian vault at: $OBSIDIAN_VAULT"
echo ""

REQUIRED_DIRS=("Knowledge" "Decisions" "Mistakes" "Projects" "Preferences")
VALID=true

for dir in "${REQUIRED_DIRS[@]}"; do
  if [ -d "$OBSIDIAN_VAULT/$dir" ]; then
    echo "✓ $dir/ exists"
  else
    echo "✗ $dir/ missing"
    VALID=false
  fi
done

echo ""

if [ "$VALID" = true ]; then
  echo "Vault validation passed!"
  exit 0
else
  echo "Vault validation failed. Run init-vault.sh to create missing directories."
  exit 1
fi
