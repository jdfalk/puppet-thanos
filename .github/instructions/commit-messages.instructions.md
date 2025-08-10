<!-- file: .github/instructions/commit-messages.instructions.md -->
<!-- version: 1.3.0 -->
<!-- guid: msg12345-e89b-12d3-a456-426614174000 -->
<!-- DO NOT EDIT: This file is managed centrally in ghcommon repository -->
<!-- To update: Create an issue/PR in jdfalk/ghcommon -->

---

applyTo: "\*\*"
description: |
Conventional commit message format rules for all Copilot/AI agents and VS Code Copilot customization. These rules apply to all git commits and follow the project's commit message standards. For details, see the main documentation in `.github/copilot-instructions.md`.

---

# Conventional Commit Message Instructions

These instructions are the canonical source for all conventional commit message
formatting rules in this repository. They are used by GitHub Copilot for commit
message generation and follow our established standards.

- Follow the [general coding instructions](general-coding.instructions.md) for
  basic file formatting rules.
- All commit formatting and workflow rules are found in
  `.github/instructions/*.instructions.md` files.
- Document all changes comprehensively in commit messages.
- For agent/AI-specific instructions, see [AGENTS.md](../AGENTS.md) and related
  files.

For more details and the full system, see
[copilot-instructions.md](../copilot-instructions.md).

## Template Structure

**CRITICAL REQUIREMENT**: Every commit MUST have a conventional commit header in the format `type(scope): description`. This is mandatory and non-negotiable. If you don't use this format, the commit has failed validation.

**IMPORTANT**: Only include issue numbers if you are working on a specific
GitHub issue. Do not use placeholder numbers like #123.

### Multi-Area Changes Format

When committing files from different functional areas (e.g., frontend, backend, docs), group them by area and provide a conventional commit header for each area:

```text
type(scope): primary description of the overall change

Brief description of the overall changes and their purpose.

Areas Modified:

feat(frontend): description of frontend changes
- path/to/frontend1.ext - Description of changes
- path/to/frontend2.ext - Description of changes

fix(backend): description of backend changes
- path/to/backend1.ext - Description of changes
- path/to/backend2.ext - Description of changes

docs(readme): description of documentation changes
- path/to/docs1.ext - Description of changes
```

### Multi-Issue Format

For commits that address multiple GitHub issues, use this format:

```text
type(scope): primary description

Brief description of the overall changes and their purpose.

Issues Addressed:

type(scope): description
- path/to/file1.ext - Description of changes
- path/to/file2.ext - Description of changes
- path/to/file3.ext - Description of changes

type(scope): description
- path/to/file4.ext - Description of changes
- path/to/file5.ext - Description of changes

type(scope): description
- path/to/file6.ext - Description of changes
```

For single commits, use the standard format:

```text
type(scope): description

Brief description of what was changed and why.

Files changed:
- [path/to/file1.ext](path/to/file1.ext) - Description of changes
- [path/to/file2.ext](path/to/file2.ext) - Description of changes
```

Only if working on a specific issue, include the issue number:

```text
type(scope): description (#actual-issue-number)

Brief description of what was changed and why.

Files changed:
- [path/to/file1.ext](path/to/file1.ext) - Description of changes
- [path/to/file2.ext](path/to/file2.ext) - Description of changes

Closes #actual-issue-number
```

For commits without a specific issue, omit the issue number entirely:

```text
type(scope): description

Brief description of what was changed and why.

Files changed:
- path/to/file1.ext - Description of changes
- path/to/file2.ext - Description of changes
```

## Guidelines

### Commit Header (MANDATORY)

- **CRITICAL**: Every commit MUST use conventional commit format: `type(scope): description`
- **FAILURE TO COMPLY**: Any commit without a proper conventional commit header is considered failed and invalid
- Include issue number only if working on a specific issue:
  `type(scope): description (#issue-number)`
- Keep the header under 72 characters
- Use present tense ("add feature" not "added feature")
- Be specific and descriptive

### Body Structure

- **Single Area Changes**: Use "Files changed:" section
- **Multi-Area Changes**: Use "Areas Modified:" with subsections grouped by functional area
- **Multiple Issues**: Use "Issues Addressed:" with subsections
- Group files logically by area or issue they address
- Include brief context about the overall changes

### Conventional Commit Types

- `feat`: New features
- `fix`: Bug fixes
- `docs`: Documentation changes
- `style`: Code style changes (formatting, no logic changes)
- `refactor`: Code refactoring (no functional changes)
- `test`: Adding or updating tests
- `chore`: Maintenance tasks, build changes, etc.
- `perf`: Performance improvements
- `ci`: CI/CD changes
- `build`: Build system changes
- `revert`: Reverting previous commits

### File Documentation

- **Always list every modified file**
- Explain what changed in each file, not just what the file does
- Use relative paths from repository root as markdown links:
  `[path/to/file.ext](path/to/file.ext)`
- Be specific about the nature of changes
- Group files by functional area when dealing with multi-area changes
- Link to relevant documentation where helpful (e.g., [general coding instructions](general-coding.instructions.md))

### Issue References

- Include issue numbers in the header: `(#123)`
- Use closing keywords in footer: `Closes #123, #456`
- For related issues: `Related to #999`
- Omit issue references if not working on a specific issue
- Link to specific issue examples when referencing patterns

## Examples

### Multi-Area Commit Example

```text
feat(system): implement user dashboard with backend API

Added complete user dashboard functionality including frontend components,
backend API endpoints, and updated documentation.

Areas Modified:

feat(frontend): add user dashboard components
- [src/components/Dashboard.jsx](src/components/Dashboard.jsx) - Main dashboard component with data visualization
- [src/components/UserStats.jsx](src/components/UserStats.jsx) - User statistics display component
- [src/styles/dashboard.css](src/styles/dashboard.css) - Responsive dashboard styling

feat(backend): add dashboard API endpoints
- [src/routes/dashboard.js](src/routes/dashboard.js) - New dashboard data API endpoints
- [src/controllers/userController.js](src/controllers/userController.js) - User data aggregation logic

test(integration): add dashboard test coverage
- [tests/dashboard.test.js](tests/dashboard.test.js) - Frontend component tests
- [tests/api/dashboard.test.js](tests/api/dashboard.test.js) - Backend API endpoint tests

docs(api): update API documentation
- [docs/api.md](docs/api.md) - Added dashboard endpoint documentation
```

### Multi-Issue Commit Example

```text
feat(auth): implement user authentication system (#123)

Added comprehensive authentication system with JWT tokens, profile management,
and updated documentation to support the new auth workflow.

Issues Addressed:

feat(auth): implement JWT token validation (#123)
- [src/middleware/auth.js](src/middleware/auth.js) - JWT validation logic and middleware
- [src/routes/api.js](src/routes/api.js) - Applied auth middleware to protected routes
- [tests/auth.test.js](tests/auth.test.js) - Comprehensive test coverage for auth flow

feat(ui): add user profile page (#456)
- [src/components/UserProfile.jsx](src/components/UserProfile.jsx) - Main profile component with edit functionality
- [src/styles/profile.css](src/styles/profile.css) - Responsive styling for profile page

docs(readme): update installation instructions (#789)
- [README.md](README.md) - Updated installation and auth setup documentation

Closes #123, #456, #789
```

### Single-Issue Commit Example

```text
fix(search): resolve pagination bug in results (#542)

Fixed issue where search results pagination was not properly handling
empty result sets, causing infinite loading states.

Files changed:
- [src/components/SearchResults.jsx](src/components/SearchResults.jsx) - Added null check for empty results
- [src/hooks/useSearchPagination.js](src/hooks/useSearchPagination.js) - Fixed pagination logic for edge cases
- [tests/search.test.js](tests/search.test.js) - Added test coverage for empty result pagination

Closes #542
```

### Simple Commit Example

```text
style(ui): format search component files

Applied prettier formatting to search-related components.

Files changed:
- [src/components/SearchBar.jsx](src/components/SearchBar.jsx) - Code formatting only
- [src/components/SearchResults.jsx](src/components/SearchResults.jsx) - Code formatting only
```

### Breaking Change Example

```text
feat(api)!: restructure user authentication endpoints (#345)

BREAKING CHANGE: Authentication endpoints have been restructured.
The /auth/login endpoint now returns different response format.

Issues Addressed:

feat(api): restructure authentication endpoints (#345)
- [src/routes/auth.js](src/routes/auth.js) - New endpoint structure and response format
- [src/middleware/auth.js](src/middleware/auth.js) - Updated to handle new token format
- [docs/api.md](docs/api.md) - Updated API documentation

Closes #345
```

## Best Practices

### Do

1. **ALWAYS use conventional commit headers** - This is mandatory, no exceptions
2. **Be specific** - Explain what changed and why
3. **Group by area/issue** - Keep related changes together with proper headers
4. **List all files** - Don't leave any modified files undocumented
5. **Use present tense** - "add" not "added"
6. **Reference issues only when working on specific issues** - Don't use
   placeholder numbers
7. **Use helpful markdown links** - Link to relevant docs like [general coding instructions](general-coding.instructions.md)
8. **Be consistent** - Follow the format every time

### Don't

1. **NEVER skip the conventional commit header** - This will cause commit failure
2. **Mix unrelated changes** - One commit per logical change set
3. **Use vague descriptions** - "fix stuff" or "update files"
4. **Forget file listings** - Every file should be documented
5. **Use placeholder issue numbers** - Only reference real issues you're working
   on
6. **Use past tense** - Avoid "fixed" or "added"
7. **Ignore functional grouping** - Group files by area when they serve different purposes

## Integration with VS Code

Your VS Code settings are configured to use these commit message guidelines.
When generating commit messages with GitHub Copilot, it will follow this format
automatically.

## Atomic Commits

- **One logical change per commit** - Don't mix features, fixes, and docs
- **Complete changes** - Don't split related files across commits
- **Buildable commits** - Each commit should leave the code in a working state
- **Issue-focused** - Group files by the issue they address, not by file type
