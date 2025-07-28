<!-- file: .github/instructions/markdown.instructions.md -->
<!-- version: 1.1.0 -->
<!-- guid: e2f8a5b1-9c4d-4e2f-8a5b-4d9c8a5b1e2f -->
<!-- DO NOT EDIT: This file is managed centrally in ghcommon repository -->
<!-- To update: Create an issue/PR in jdfalk/ghcommon -->

applyTo: "\*_/_.md"
description: |
Markdown formatting, documentation, and style rules for Copilot/AI agents and VS Code Copilot customization. These rules extend the general instructions in `general-coding.instructions.md` and merge all unique content from the Google Markdown Style Guide.

---

# Markdown Coding Instructions

- Follow the [general coding instructions](general-coding.instructions.md).
- Follow the
  [Google Markdown Style Guide](https://github.com/google/styleguide/blob/gh-pages/docguide/style.md)
  for additional best practices.
- All Markdown files must begin with the required file header (see general
  instructions for details and Markdown example).

## File Structure and Organization

- Use lowercase letters and hyphens for file names
- Start with a single H1 heading (document title)
- Use hierarchical heading structure (H1 → H2 → H3)
- Include table of contents for long documents
- End with references/links section if applicable

## Heading Guidelines

- Use descriptive, specific headings
- Maintain consistent capitalization
- Avoid punctuation in headings except question marks
- Keep headings concise but informative

## Text Formatting

- Use bold for UI elements, commands, strong emphasis
- Use italics for definitions, foreign words, light emphasis
- Use inline code for variables, functions, file names
- Use code blocks with language specification

## Links and References

- Use descriptive link text, avoid "click here" or "read more"

## Lists and Structure

- Use hyphens (`-`) for unordered lists
- Use numbers with periods for ordered lists
- Use task lists for actionable items

## Tables

- Use proper alignment with pipes (`|`)
- Include header row with separator
- Align columns consistently

## Code Documentation

- Always specify language for syntax highlighting
- Use descriptive comments in code examples
- Keep examples concise but complete

## Images and Media

- Use descriptive alt text
- Use relative paths for local images
- Optimize images for web

## Line Length and Whitespace

- Aim for 80-100 characters per line
- One blank line between major sections
- No trailing whitespace at line ends

## Special Elements

- Use blockquotes for quotes, callouts, or emphasized content
- Use horizontal rules for major document sections
- Use footnotes for additional information or citations

## Accessibility Guidelines

- Provide meaningful alt text for images
- Use proper heading hierarchy for screen readers
- Use lists for grouped information

## Validation and Quality

- Write clear, concise sentences
- Use active voice when possible
- Maintain consistent tone and style
- Proofread for grammar and spelling
- Validate Markdown syntax with linters
- Test links to ensure they work
- Check code examples for accuracy

## Required File Header

All Markdown files must begin with a standard header as described in the
[general coding instructions](general-coding.instructions.md). Example for
Markdown:

```markdown
<!-- file: path/to/file.md -->
<!-- version: 1.0.0 -->
<!-- guid: 123e4567-e89b-12d3-a456-426614174000 -->
<!-- DO NOT EDIT: This file is managed centrally in ghcommon repository -->
<!-- To update: Create an issue/PR in jdfalk/ghcommon -->
```
