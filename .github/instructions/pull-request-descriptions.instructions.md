<!-- file: .github/instructions/pull-request-descriptions.instructions.md -->
<!-- version: 1.2.0 -->
<!-- guid: pr2d3567-e89b-12d3-a456-426614174000 -->
<!-- DO NOT EDIT: This file is managed centrally in ghcommon repository -->
<!-- To update: Create an issue/PR in jdfalk/ghcommon -->

---

applyTo: "\*\*"
description: |
Pull request description format rules for all Copilot/AI agents and VS Code Copilot customization. These rules apply to all pull request descriptions and follow the project's documentation standards. For details, see the main documentation in `.github/copilot-instructions.md`.

---

# Pull Request Description Instructions

These instructions are the canonical source for all pull request description
formatting rules in this repository. They are used by GitHub Copilot for pull
request generation and follow our established standards.

- Follow the [general coding instructions](general-coding.instructions.md) for
  basic file formatting rules.
- All PR formatting and workflow rules are found in
  `.github/instructions/*.instructions.md` files.
- Document all changes comprehensively in pull request descriptions.
- For agent/AI-specific instructions, see [AGENTS.md](../AGENTS.md) and related
  files.

For more details and the full system, see
[copilot-instructions.md](../copilot-instructions.md).

## Template Structure

Use this template for your pull request descriptions:

```markdown
## Summary

Brief overview of the entire PR and its purpose

## Issues Addressed

### type(scope): description (#issue-number)

**Description:** Detailed explanation of what was done for this specific issue

**Files Modified:**

- [`path/to/file1.ext`](./path/to/file1.ext) - Description of changes |
  [[diff]](../../pull/PR_NUMBER/files#diff-hash)
  [[repo]](../../blob/main/path/to/file1.ext)
- [`path/to/file2.ext`](./path/to/file2.ext) - Description of changes |
  [[diff]](../../pull/PR_NUMBER/files#diff-hash)
  [[repo]](../../blob/main/path/to/file2.ext)

### type(scope): description (#issue-number)

**Description:** Detailed explanation of what was done for this specific issue

**Files Modified:**

- [`path/to/file3.ext`](./path/to/file3.ext) - Description of changes |
  [[diff]](../../pull/PR_NUMBER/files#diff-hash)
  [[repo]](../../blob/main/path/to/file3.ext)

_Note: Omit issue numbers from section headers if not working on specific
issues. Use `type(scope): description` format instead._

## Testing

How the changes were tested (unit tests, integration tests, manual testing)

## Breaking Changes

(If applicable) List any breaking changes and migration steps

## Additional Notes

Any additional context, screenshots, or important information

## Related Issues

Closes #123, #456, #789
```

## Guidelines

### Summary Section

- Keep it concise but comprehensive (2-4 sentences)
- Explain the overall purpose and impact of the PR
- Use present tense ("add feature" not "added feature")

### Issues Addressed Section

- **Group changes by issue/feature**, not by file
- Use conventional commit format: `type(scope): description (#issue-number)`
  when working on specific issues
- Use `type(scope): description` format when not working on specific issues
- Each issue gets its own subsection with:
  - Conventional commit header
  - Detailed description of what was implemented
  - List of all files modified for that specific issue

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

### File Links Format

Each file entry should include:

- **File path link**: `[path/to/file.ext](./path/to/file.ext)` - Links to the
  file in the PR
- **Description**: What was changed in this file
- **Additional links**:
  - `[[diff]]` - Link to the diff view for this specific file
  - `[[repo]]` - Link to the file in the repository

### Testing Section

- Describe testing approach for each issue/feature
- Include test coverage information
- Note any manual testing performed
- Mention edge cases tested

### Related Issues

- Use GitHub's automatic closing keywords: `Closes #123`, `Fixes #456`,
  `Resolves #789`
- Link related but not closed issues with: `Related to #999`

## Example

```markdown
## Summary

This PR implements user authentication, adds profile management, and updates
documentation to support the new auth system.

## Issues Addressed

### feat(auth): implement JWT token validation (#123)

**Description:** Added JWT middleware to secure API endpoints and protect user
data. Implemented token generation, validation, and refresh functionality.

**Files Modified:**

- [`src/middleware/auth.js`](./src/middleware/auth.js) - JWT validation logic
  and middleware | [[diff]](../../pull/456/files#diff-abc123)
  [[repo]](../../blob/main/src/middleware/auth.js)
- [`src/routes/api.js`](./src/routes/api.js) - Applied auth middleware to
  protected routes | [[diff]](../../pull/456/files#diff-def456)
  [[repo]](../../blob/main/src/routes/api.js)
- [`tests/auth.test.js`](./tests/auth.test.js) - Comprehensive test coverage for
  auth flow | [[diff]](../../pull/456/files#diff-ghi789)
  [[repo]](../../blob/main/tests/auth.test.js)

### feat(ui): add user profile page (#456)

**Description:** Created new user profile interface with edit capabilities,
avatar upload, and preference management.

**Files Modified:**

- [`src/components/UserProfile.jsx`](./src/components/UserProfile.jsx) - Main
  profile component with edit functionality |
  [[diff]](../../pull/456/files#diff-jkl012)
  [[repo]](../../blob/main/src/components/UserProfile.jsx)
- [`src/styles/profile.css`](./src/styles/profile.css) - Responsive styling for
  profile page | [[diff]](../../pull/456/files#diff-mno345)
  [[repo]](../../blob/main/src/styles/profile.css)

### docs(readme): update installation instructions (#789)

**Description:** Updated README with current installation steps and added
troubleshooting section for auth setup.

**Files Modified:**

- [`README.md`](./README.md) - Updated installation and auth setup documentation
  | [[diff]](../../pull/456/files#diff-pqr678)
  [[repo]](../../blob/main/README.md)

## Testing

- **Unit Tests**: Added 15 new tests for auth middleware and profile components
  (95% coverage)
- **Integration Tests**: Tested complete auth flow from login to protected
  resource access
- **Manual Testing**: Verified UI functionality across Chrome, Firefox, and
  Safari
- **Edge Cases**: Tested token expiration, invalid tokens, and network failures

## Breaking Changes

- API endpoints now require authentication headers
- Migration: Users need to log in again after deployment

## Additional Notes

- JWT tokens expire after 24 hours with automatic refresh
- Profile images are stored in AWS S3 with CDN caching
- Added rate limiting to auth endpoints (10 requests/minute)

## Related Issues

Closes #123, #456, #789 Related to #999 (future OAuth implementation)
```

## Best Practices

1. **One issue per section** - Don't mix unrelated changes
2. **Accurate file descriptions** - Explain what changed, not just what the file
   does
3. **Complete file coverage** - List every modified file with its purpose
4. **Proper linking** - Ensure all links work and point to correct locations
5. **Clear testing** - Explain how each feature/fix was verified
6. **Conventional commits** - Follow the established format consistently
