<!-- file: .github/prompts/ai-rebase-context.md -->
<!-- version: 1.0.1 -->
<!-- guid: 5f8e7d6c-9b8a-7c6d-5e4f-3a2b1c0d9e8f -->

# Repository Context for AI Rebase

## Project Overview

This is the **ghcommon** repository, which contains shared GitHub workflows,
automation scripts, and common utilities for managing multiple repositories in
the organization. It focuses on:

- Reusable GitHub Actions workflows
- Documentation management automation
- Issue and project management tools
- Code quality and standardization tools

## Coding Standards

- Follow conventional commit message format: `type(scope): description`
- Use proper file headers with path, version, and GUID
- Maintain documentation with every code change
- Use semantic versioning for all files
- Follow the centralized coding instructions system in `.github/instructions/`

## Key Files to Reference

### README.md

The main project documentation explaining the repository's purpose and
structure.

### .github/instructions/general-coding.instructions.md

Contains the canonical coding standards and file header requirements that apply
to all files.

### .github/commit-messages.md

Defines the conventional commit message format used across all repositories.

### .github/workflows/

Contains reusable GitHub Actions workflows that can be used by other
repositories.

## Common Conflict Patterns

### File Headers

When resolving conflicts in file headers, always:

- Keep the correct file path relative to repository root
- Increment the version number appropriately (patch/minor/major)
- Preserve the GUID (never change it)
- Use the correct comment format for the file type

### Workflow Files

For GitHub Actions workflow conflicts:

- Preserve both workflow logic when possible
- Maintain proper YAML indentation
- Keep input/output definitions consistent
- Ensure environment variables are properly quoted

### Documentation Updates

When resolving documentation conflicts:

- Combine content additions rather than choosing one side
- Maintain consistent formatting and structure
- Preserve both sets of new information when relevant
- Keep version history in changelogs

## Dependencies and Imports

- Python scripts use standard library when possible
- Shell scripts should be POSIX-compatible
- GitHub Actions use official actions with pinned versions
- Templates and prompts should be self-contained

## Project Structure

- `.github/workflows/` - Reusable GitHub Actions workflows
- `.github/instructions/` - Coding standards and guidelines
- `.github/prompts/` - AI prompt templates
- `scripts/` - Automation and utility scripts
- `templates/` - File and project templates
- `docs/` - Additional documentation
