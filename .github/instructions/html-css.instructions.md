<!-- file: .github/instructions/html-css.instructions.md -->
<!-- version: 1.1.0 -->
<!-- guid: 2d1e0f9a-8b7c-6d5e-4f3a-2b1c0d9e8f7a -->
<!-- DO NOT EDIT: This file is managed centrally in ghcommon repository -->
<!-- To update: Create an issue/PR in jdfalk/ghcommon -->

applyTo: "\*_/_.{html,css}"
description: |
Coding, documentation, and workflow rules for HTML and CSS files, following Google HTML/CSS style guide and general project rules. Reference this for all HTML and CSS code, documentation, and formatting in this repository. All unique content from the Google HTML/CSS Style Guide is merged here.

---

# HTML/CSS Coding Instructions

- Follow the [general coding instructions](general-coding.instructions.md).
- Follow the [Google HTML/CSS Style Guide](https://google.github.io/styleguide/htmlcssguide.html) for additional best practices.
- All HTML and CSS files must begin with the required file header (see general instructions for details and HTML/CSS example).

## Core Principles

- Consistency: Follow the same conventions throughout the project
- Readability: Write code that is easy to read and understand
- Maintainability: Code should be easy to modify and extend
- Performance: Consider the impact on page load times and rendering
- Accessibility: Ensure content is accessible to all users

## HTML Guidelines

- Use HTML5 doctype: `<!DOCTYPE html>`
- Use valid HTML, validate with W3C tools
- Use UTF-8 encoding: `<meta charset="utf-8" />`
- Use semantic HTML and accessible markup
- Use 2 spaces for indentation, lowercase for tags/attributes, double quotes for
  attribute values
- Provide alternative content for multimedia
- Use appropriate input types and labels in forms

## CSS Guidelines

- Use valid CSS, validate with W3C tools
- Use meaningful, lowercase, hyphen-separated class and ID names
- Avoid presentational names
- Use shorthand properties when possible
- Avoid qualifying class names with type selectors unless necessary

## Required File Header

All HTML and CSS files must begin with a standard header as described in the
[general coding instructions](general-coding.instructions.md). Example for CSS:

```css
/* file: path/to/file.css */
/* version: 1.0.0 */
/* guid: 123e4567-e89b-12d3-a456-426614174000 */
```
