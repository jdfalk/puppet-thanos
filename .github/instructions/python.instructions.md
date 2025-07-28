<!-- file: .github/instructions/python.instructions.md -->
<!-- version: 1.1.0 -->
<!-- guid: 2a5b7c8d-9e1f-4a2b-8c3d-6e9f1a5b7c8d -->
<!-- DO NOT EDIT: This file is managed centrally in ghcommon repository -->
<!-- To update: Create an issue/PR in jdfalk/ghcommon -->

applyTo: "\*_/_.py"
description: |
Python language-specific coding, documentation, and testing rules for Copilot/AI agents and VS Code Copilot customization. These rules extend the general instructions in `general-coding.instructions.md` and merge all unique content from the Google Python Style Guide.

---

# Python Coding Instructions

- Follow the [general coding instructions](general-coding.instructions.md).
- Follow the
  [Google Python Style Guide](https://google.github.io/styleguide/pyguide.html)
  for additional best practices.
- All Python files must begin with the required file header (see general
  instructions for details and Python example).

## Core Principles

- Be consistent: Follow the established patterns in your codebase
- Readability counts: Code is read more often than it is written
- Simple is better than complex: Prefer clarity over cleverness
- Use tools: Leverage formatters like `ruff`, `black`, and `isort` for
  consistency

## Language Rules

- Use `pylint` with Google's pylintrc configuration
- Use absolute imports, never relative
- Avoid mutable global state
- Use nested functions only when closing over a local value
- Use comprehensions for simple cases
- Use default iterators and operators
- Use generators as needed
- Use lambda for one-liners, prefer generator expressions
- Use properties for simple computations
- Use implicit false when possible, `if foo is None:` for None checks
- Do not use mutable objects as default argument values
- Use 4 spaces for indentation, never tabs
- Maximum line length is 80 characters
- Use parentheses for implied line continuation
- Two blank lines between top-level definitions
- One blank line between method definitions
- Use triple-double-quotes for docstrings, Google-style docstring format
- Use f-strings, `%` operator, or `format()` for formatting
- Use `with` statements for resource management
- Use `# TODO:` comments with context
- Imports on separate lines, grouped stdlib/third-party/local
- Use descriptive names, avoid single character names
- Use type annotations where applicable
- Put main functionality in `main()` and check `if __name__ == '__main__':`
- Prefer small and focused functions

## Required File Header

All Python files must begin with a standard header as described in the
[general coding instructions](general-coding.instructions.md). Example for
Python:

```python
#!/usr/bin/env python3
# file: path/to/file.py
# version: 1.0.0
# guid: 123e4567-e89b-12d3-a456-426614174000
```
