---
allowed-tools: TodoWrite, TodoRead, Read, Write, MultiEdit, Bash(mkdir:*)
description: Implement the given task with Specification-Driven Development workflow
---

## Context

- Task Name: $ARGUMENTS

## Your task

- Check if the `.claude-code/kiro/(Task Name)` (when Task Name is specified) or `.claude-code/kiro` directory exists and these documents are present:
  - `requirements.md`
  - `design.md`
  - `tasks.md`
- If any of the required documents are missing, notify the user to complete the previous stages first.
- Read the requirements.md, design.md, and tasks.md files to understand the task.
- Implement the task according to the specifications provided in these documents.
  - For each task:
    - Update task to in_progress using TodoWrite
    - Execute implementation and testing
    - Run lint and typecheck
    - Update task to completed using TodoWrite
    - Then, check the task in tasks.md as completed
