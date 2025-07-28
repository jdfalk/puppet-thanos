<!-- file: .github/instructions/github-actions.instructions.md -->
<!-- version: 1.1.0 -->
<!-- guid: 9f8e7d6c-5b4a-3c2d-1e0f-9a8b7c6d5e4f -->
<!-- DO NOT EDIT: This file is managed centrally in ghcommon repository -->
<!-- To update: Create an issue/PR in jdfalk/ghcommon -->

applyTo: ".github/workflows/\*.{yml,yaml}"
description: |
Coding, documentation, and workflow rules for GitHub Actions workflow files, following Google and project-specific style guides. Reference the general instructions for all Copilot/AI agents and VS Code Copilot customization. For details, see the main documentation in `.github/copilot-instructions.md`.

---

# GitHub Actions Workflow Coding Instructions

- Follow the [general coding instructions](general-coding.instructions.md).
- Follow the
  [Google GitHub Actions/YAML Style Guide](https://github.com/google/styleguide/blob/gh-pages/docguide/style.md)
  for additional best practices.
- All workflow files must begin with the required file header (see general
  instructions for details and YAML example).

## Workflow File Structure

- Use `.github/workflows/` directory for all workflow files
- Use descriptive names for workflow files (e.g., `ci.yml`,
  `deploy-production.yml`)
- Use lowercase, hyphen-separated names for workflow files
- Include file extension `.yml` (preferred) or `.yaml`

## YAML Formatting

- Use 2 spaces for indentation
- Keep line length to a reasonable limit (recommended: 100 characters)
- Use blank lines to separate logical sections within workflows
- Use comments to explain complex steps or configurations
- Use consistent formatting for arrays and objects

## Workflow Configuration

### Naming

```yaml
name: Descriptive Workflow Name
```

- Always include a clear, descriptive name for each workflow
- Use title case for workflow names
- Include the purpose of the workflow in its name

### Triggers

```yaml
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
  workflow_dispatch:
```

- List triggers in order of importance
- Use specific branch filters when appropriate
- Consider using `paths` filters to limit execution
- Document custom trigger configurations with comments

### Job Structure

```yaml
jobs:
  job-id:
    name: Human Readable Job Name
    runs-on: ubuntu-latest
    steps:
      - name: Descriptive step name
        uses: actions/checkout@v4
```

- Use lowercase, hyphen-separated names for job IDs
- Always include a human-readable `name` property for jobs
- Group related steps logically
- Use consistent naming conventions across workflows

## Steps Best Practices

### Step Naming

- Always include a descriptive name for each step
- Use sentence case for step names
- Include an action verb describing what the step does

### Actions References

- Always pin actions to specific versions using SHA hashes for critical
  workflows
- Use major version references (`@v4`) for general usage
- Avoid using `@master` or `@main` references

```yaml
# Good - pinned to specific version
- uses: actions/checkout@v4.1.1

# Better - pinned to SHA for critical workflows
- uses: actions/checkout@a81bbbf8298c0fa03ea29cdc473d45769f953675

# Avoid
- uses: actions/checkout@main
```

### Commands and Scripts

- Use multi-line syntax for complex commands
- Use `|` for multi-line scripts rather than chaining with `&&`
- Consider extracting complex scripts to separate files in the repository

```yaml
# Good
- name: Run complex script
  run: |
    echo "Starting process"
    npm test

# Avoid
- name: Run complex script
  run: echo "Starting process" && npm ci && npm run build && npm test
```

## Variables and Secrets

- Use `env:` section at the appropriate scope (workflow, job, or step)
- Define shared variables at the highest appropriate scope
- Prefer environment files for projects with many environment variables
- Never hardcode sensitive information

```yaml
env:
  NODE_VERSION: "20"

jobs:
  build:
    env:
      CACHE_KEY: ${{ runner.os }}-npm-${{ hashFiles('**/package-lock.json') }}
    steps:
      - name: Use specific variable
        env:
          SPECIFIC_VAR: "value"
        run: echo $SPECIFIC_VAR
```

## Reusability and DRY Principles

- Use composite actions for reusable step sequences
- Use reusable workflows for common workflow patterns
- Create workflow templates for organizational standards
- Standardize common job patterns across workflows

## Conditional Execution

- Use clear, explicit conditions
- Use expressions for dynamic behavior
- Comment complex conditions to explain the logic

```yaml
- name: Step that runs only on main branch
  if: github.ref == 'refs/heads/main'
  run: ./deploy.sh

- name: Step with complex condition
  # Run only on pull requests to main when specific files changed
  if: |
    github.event_name == 'pull_request' &&
    github.base_ref == 'main' &&
    contains(github.event.pull_request.labels.*.name, 'deploy')
  run: ./conditional-task.sh
```

## Error Handling

- Use `continue-on-error` for non-critical steps
- Set appropriate timeout limits for long-running steps
- Implement retry logic for flaky operations

```yaml
- name: Flaky external API call
  uses: some/api-action@v1
  with:
    retries: 3
    timeout-minutes: 5
  continue-on-error: true
```

## Performance Optimization

- Use caching for dependencies and build artifacts
- Set appropriate concurrency limits
- Use matrix builds efficiently
- Use job outputs to pass data between jobs

```yaml
- name: Cache dependencies
  uses: actions/cache@v3
  with:
    path: ~/.npm
    key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
    restore-keys: |
      ${{ runner.os }}-node-
```

## Security Best Practices

- Use GITHUB_TOKEN with minimum required permissions
- Use OpenID Connect for cloud provider authentication when possible
- Avoid printing secrets in logs
- Use organization/repository secrets for sensitive values

```yaml
permissions:
  contents: read
  pull-requests: write
```

## Documentation

- Include comments explaining non-obvious workflow behavior
- Document expected inputs and outputs for reusable workflows
- Keep a changelog for significant workflow changes
- Document any required secrets or environment setup

## Required File Header

All workflow files must begin with a standard header as described in the
[general coding instructions](general-coding.instructions.md). Example for YAML:

```yaml
# file: .github/workflows/ci.yml
# version: 1.0.0
# guid: 123e4567-e89b-12d3-a456-426614174000
```
