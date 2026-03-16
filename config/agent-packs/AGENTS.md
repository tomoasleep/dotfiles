# dotfiles/config/agent-packs

This directory contains agent-packs, which are collections of related agent skills and tools for coding agents.
Prefer to put agent skills in ./PACK_NAME/skills/SKILL_NAME. They will be automatically registered as agent-packs, and you can make symlinks to each coding agent directories.

## Create Symbolic Links to Agent Packs

```console
# In root of this repository
bin/agent-pack-sync
```
