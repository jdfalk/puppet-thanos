<!-- file: .github/copilot-instructions.md -->
<!-- version: 2.0.0 -->
<!-- guid: 4d5e6f7a-8b9c-0d1e-2f3a-4b5c6d7e8f9a -->

# Copilot/AI Agent Coding Instructions System

This repository uses a centralized, modular system for Copilot/AI agent coding, documentation, and workflow instructions, following the latest VS Code Copilot customization best practices.

## 🚨 CRITICAL: Documentation Update Protocol

**NEVER edit markdown files directly. ALWAYS use the documentation update system:**

1. **Create GitHub Issue First** (if none exists):

   ```bash
   ./scripts/create-issue-update.sh "Update [filename] - [description]" "Detailed description of what needs to be updated"
   ```

2. **Create Documentation Update**:

   ```bash
   ./scripts/create-doc-update.sh [filename] "[content]" [mode] --issue [issue-number]
   ```

3. **Link to Issue**: Every documentation change MUST reference a GitHub issue for tracking and context.

**Failure to follow this protocol will result in workflow conflicts and lost changes.**

## System Overview

- **General rules**: `.github/instructions/general-coding.instructions.md` (applies to all files)
- **Language/task-specific rules**: `.github/instructions/*.instructions.md` (with `applyTo` frontmatter)
- **Prompt files**: `.github/prompts/` (for Copilot/AI prompt customization)
- **Agent-specific docs**: `.github/AGENTS.md`, `.github/CLAUDE.md`, etc. (pointers to this system)
- **VS Code integration**: `.vscode/copilot/` contains symlinks to canonical `.github/instructions/` files for VS Code Copilot features

## How It Works

- **General instructions** are always included for all files and languages.
- **Language/task-specific instructions** extend the general rules and use the `applyTo` field to target file globs (e.g., `**/*.go`).
- **All code style, documentation, and workflow rules are now found exclusively in `.github/instructions/*.instructions.md` files.**
- **Prompt files** are stored in `.github/prompts/` and can reference instructions as needed.
- **Agent docs** (e.g., AGENTS.md) point to `.github/` as the canonical source for all rules.
- **VS Code** uses symlinks in `.vscode/copilot/` to include these instructions for Copilot customization.

## For Contributors

- **Edit or add rules** in `.github/instructions/` only. Do not use or reference any `code-style-*.md` files; these are obsolete.
- **Add new prompts** in `.github/prompts/`.
- **Update agent docs** to reference this system.
- **Do not duplicate rules**; always reference the general instructions from specific ones.
- **See `.github/README.md`** for a human-friendly summary and contributor guide.

For full details, see the [general coding instructions](instructions/general-coding.instructions.md) and language-specific files in `.github/instructions/`.
