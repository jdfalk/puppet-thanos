<!-- file: .github/instructions/go.instructions.md -->
<!-- version: 1.1.0 -->
<!-- guid: 8f4a3c5d-6e7b-5d9f-0a1b-2c3d4e5f6a7b -->
<!-- DO NOT EDIT: This file is managed centrally in ghcommon repository -->
<!-- To update: Create an issue/PR in jdfalk/ghcommon -->

applyTo: "\*_/_.go"
description: |
Go language-specific coding, documentation, and testing rules for Copilot/AI agents and VS Code Copilot customization. These rules extend the general instructions in `general-coding.instructions.md` and merge all unique content from the Google Go Style Guide.

---

# Go Coding Instructions

- Follow the [general coding instructions](general-coding.instructions.md).
- Follow the
  [Google Go Style Guide](https://google.github.io/styleguide/go/index.html) for
  additional best practices.
- All Go files must begin with the required file header (see general
  instructions for details and Go example).

## Core Principles

- Clarity over cleverness: Code should be clear and readable
- Simplicity: Prefer simple solutions over complex ones
- Consistency: Follow established patterns within the codebase
- Readability: Code is written for humans to read

## Naming Conventions

- Use short, concise, evocative package names (lowercase, no underscores)
- Use camelCase for unexported names, PascalCase for exported names
- Use short names for short-lived variables, descriptive names for longer-lived
  variables
- Use PascalCase for exported constants, camelCase for unexported constants
- Single-method interfaces should end in "-er" (e.g., Reader, Writer)

## Code Organization

- Use `goimports` to format imports automatically
- Group imports: standard library, third-party, local
- No blank lines within groups, one blank line between groups
- Keep functions short and focused
- Use blank lines to separate logical sections
- Order: receiver, name, parameters, return values

## Formatting

- Use tabs for indentation, spaces for alignment
- Opening brace on same line as declaration, closing brace on its own line
- No strict line length limit, but aim for readability

## Comments

- Every package should have a package comment
- Public functions must have comments starting with the function name
- Comment exported variables, explain purpose and constraints

## Error Handling

- Use lowercase for error messages, no punctuation at end
- Be specific about what failed
- Create custom error types for specific error conditions
- Use `errors.Is` and `errors.As` for error checking

## Best Practices

- Use short variable declarations (`:=`) when possible
- Use `var` for zero values or when type is important
- Use `make()` for slices and maps with known capacity
- Accept interfaces, return concrete types
- Keep interfaces small and focused
- Use channels for communication between goroutines
- Use sync primitives for protecting shared state
- Test file names end with `_test.go`, test function names start with `Test`
- Use table-driven tests for multiple scenarios

## Required File Header

All Go files must begin with a standard header as described in the
[general coding instructions](general-coding.instructions.md). Example for Go:

```go
// file: path/to/file.go
// version: 1.0.0
// guid: 123e4567-e89b-12d3-a456-426614174000
```
