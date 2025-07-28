<!-- file: .github/instructions/typescript.instructions.md -->
<!-- version: 1.1.0 -->
<!-- guid: 8f4a3c5d-6e7b-5d9f-0a1b-2c3d4e5f6a7b -->
<!-- DO NOT EDIT: This file is managed centrally in ghcommon repository -->
<!-- To update: Create an issue/PR in jdfalk/ghcommon -->

applyTo: "\*_/_.ts"
description: |
TypeScript language-specific coding, documentation, and testing rules for Copilot/AI agents and VS Code Copilot customization. These rules extend the general instructions in `general-coding.instructions.md` and merge all unique content from the Google TypeScript Style Guide.

---

# TypeScript Coding Instructions

- Follow the [general coding instructions](general-coding.instructions.md).
- Follow the
  [Google TypeScript Style Guide](https://google.github.io/styleguide/tsguide.html)
  for additional best practices.
- All TypeScript files must begin with the required file header (see general
  instructions for details and TypeScript example).

## Core Principles

- Readability: Code should be clear and understandable
- Consistency: Follow established patterns and conventions
- Type Safety: Use TypeScript features to catch errors at compile time
- Simplicity: Prefer simple, straightforward solutions

## File Organization

- Use `.ts` for TypeScript files, `.tsx` for TypeScript with JSX
- Use ES6 import/export style
- License header (if required), then imports, then main export, then
  implementation

## Naming Conventions

- camelCase for variables and functions
- PascalCase for classes and interfaces
- SCREAMING_SNAKE_CASE for module-level constants
- Use descriptive names, avoid abbreviations
- Use PascalCase for enum names and members

## Type Annotations

- Always annotate function parameters and return types
- Use arrow functions for short functions
- Use explicit types for complex objects
- Use interfaces for object shapes that might be extended
- Use type aliases for unions, primitives, or computed types
- Use extends for generic constraints
- Use built-in utility types

## Code Formatting

- Maximum 80 characters per line
- Use 2 spaces for indentation, no tabs
- Always use semicolons
- Use single quotes for strings, template literals for interpolation
- Use trailing commas in multiline structures

## Best Practices

- Use strict null checks
- Use array methods instead of loops
- Use object spread for copying
- Use destructuring for extraction
- Prefer async/await over promises
- Keep functions small and focused
- Use pure functions when possible
- Use function overloads for different signatures

## Testing

- Use descriptive test names
- Follow AAA pattern (Arrange, Act, Assert)
- Use table-driven tests for multiple scenarios

## Required File Header

All TypeScript files must begin with a standard header as described in the
[general coding instructions](general-coding.instructions.md). Example for
TypeScript:

```typescript
// file: path/to/file.ts
// version: 1.0.0
// guid: 123e4567-e89b-12d3-a456-426614174000
```
