<!-- file: .github/instructions/javascript.instructions.md -->
<!-- version: 1.1.0 -->
<!-- guid: 8e7d6c5b-4a3c-2d1e-0f9a-8b7c6d5e4f3a -->
<!-- DO NOT EDIT: This file is managed centrally in ghcommon repository -->
<!-- To update: Create an issue/PR in jdfalk/ghcommon -->

applyTo: "\*_/_.{js,jsx}"
description: |
JavaScript language-specific coding, documentation, and testing rules for Copilot/AI agents and VS Code Copilot customization. These rules extend the general instructions in `general-coding.instructions.md` and merge all unique content from the Google JavaScript Style Guide.

---

# JavaScript Coding Instructions

- Follow the [general coding instructions](general-coding.instructions.md).
- Follow the
  [Google JavaScript Style Guide](https://google.github.io/styleguide/jsguide.html)
  for additional best practices.
- All JavaScript files must begin with the required file header (see general
  instructions for details and JavaScript example).

## File Structure

- Use `camelCase` for file names
- Each file should contain exactly one ES module
- Prefer ES6 modules (`import`/`export`) over other module systems

## Formatting

- Use 2 spaces for indentation
- Line length maximum of 80 characters
- Use semicolons to terminate statements
- Use single quotes for string literals
- Add trailing commas for multi-line object/array literals
- Use parentheses only where required for clarity or priority

## Naming Conventions

- `functionNamesLikeThis`, `variableNamesLikeThis`, `ClassNamesLikeThis`,
  `EnumNamesLikeThis`, `methodNamesLikeThis`, `CONSTANT_VALUES_LIKE_THIS`,
  `private_values_with_underscore`, `package-names-like-this`

## Comments

- Use JSDoc for documentation
- Comment all non-obvious code sections

## Language Features

- Use `const` and `let` instead of `var`
- Use arrow functions for anonymous functions, especially callbacks
- Use template literals instead of string concatenation
- Use object/array destructuring where it improves readability
- Use default parameters instead of conditional statements
- Use spread operator and rest parameters where appropriate

## Best Practices

- Avoid using the global scope
- Avoid deeply nested code blocks
- Use early returns to reduce nesting
- Limit line length to improve readability
- Separate logic and display concerns

## Error Handling

- Always handle Promise rejections
- Use try/catch blocks appropriately
- Provide useful error messages

## Testing

- Write unit tests for all code
- Use descriptive test names
- Follow AAA pattern (Arrange, Act, Assert)

## Required File Header

All JavaScript files must begin with a standard header as described in the
[general coding instructions](general-coding.instructions.md). Example for
JavaScript:

```js
// file: path/to/file.js
// version: 1.0.0
// guid: 123e4567-e89b-12d3-a456-426614174000
```
