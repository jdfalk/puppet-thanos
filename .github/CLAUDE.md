<!-- file: .github/CLAUDE.md -->
<!-- version: 2.0.0 -->
<!-- guid: 3c4d5e6f-7a8b-9c0d-1e2f-3a4b5c6d7e8f -->

# CLAUDE.md

> **NOTE:** This file is a pointer. All Claude/AI agent and workflow
> instructions are now centralized in the `.github/instructions/` and
> `.github/prompts/` directories.

## 🚨 CRITICAL: Documentation Update Protocol

**NEVER edit markdown files directly. ALWAYS use the documentation update
system:**

1. **Create GitHub Issue First** (if none exists):

   ```bash
   ./scripts/create-issue-update.sh "Update [filename] - [description]" "Detailed description of what needs to be updated"
   ```

2. **Create Documentation Update**:

   ```bash
   ./scripts/create-doc-update.sh [filename] "[content]" [mode] --issue [issue-number]
   ```

3. **Link to Issue**: Every documentation change MUST reference a GitHub issue
   for tracking and context.

**Failure to follow this protocol will result in workflow conflicts and lost
changes.**

## Canonical Source for Agent Instructions

- General and language-specific rules: `.github/instructions/` (all code style,
  documentation, and workflow rules are here)
- Prompts: `.github/prompts/`
- System documentation: `.github/copilot-instructions.md`

For all agent, Claude, or workflow tasks, **refer to the above files**. Do not
duplicate or override these rules elsewhere.
