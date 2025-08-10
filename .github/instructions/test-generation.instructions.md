<!-- file: .github/instructions/test-generation.instructions.md -->
<!-- version: 1.2.0 -->
<!-- guid: test1234-e89b-12d3-a456-426614174000 -->
<!-- DO NOT EDIT: This file is managed centrally in ghcommon repository -->
<!-- To update: Create an issue/PR in jdfalk/ghcommon -->

---

applyTo: "**/\*\_test.{go,js,ts,py} **/_test_.{go,js,ts,py} **/tests/**"
description: |
Test generation and structure rules for all Copilot/AI agents and VS Code Copilot customization. These rules apply to all test files and follow the project's testing standards. For details, see the main documentation in `.github/copilot-instructions.md`.

---

# Test Generation Instructions

These instructions are the canonical source for all test generation, structure,
and best practice rules in this repository. They are used by GitHub Copilot for
test file creation and follow our established testing standards.

- Follow the [general coding instructions](general-coding.instructions.md) for
  basic file formatting rules.
- All testing and workflow rules are found in
  `.github/instructions/*.instructions.md` files.
- Document all test cases comprehensively using appropriate style for the
  language.
- For agent/AI-specific instructions, see [AGENTS.md](../AGENTS.md) and related
  files.

For more details and the full system, see
[copilot-instructions.md](../copilot-instructions.md).

## Test Structure

Follow this structure when creating tests:

```markdown
[Setup] - Prepare the test environment and inputs [Exercise] - Execute the
functionality being tested [Verify] - Check that the results match expectations
[Teardown] - Clean up any resources (if needed)
```

## Test Naming Conventions

- Use descriptive names that indicate what's being tested
- Follow the pattern: `test[UnitOfWork_StateUnderTest_ExpectedBehavior]`
- Examples:
  - `testLoginService_InvalidCredentials_ReturnsError`
  - `testUserRepository_SaveDuplicateEmail_ThrowsException`
  - `testCalculator_DivideByZero_ThrowsException`

## Test Types

- **Unit Tests**: Focus on a single function, method, or class in isolation
- **Integration Tests**: Verify interactions between components
- **Functional Tests**: Test complete features from a user perspective
- **Performance Tests**: Measure response times and resource usage
- **Security Tests**: Identify vulnerabilities and validate safeguards
- **Accessibility Tests**: Ensure compliance with accessibility standards

## Unit Test Best Practices

- Test one specific behavior per test case
- Mock external dependencies
- Use setup/teardown to avoid code duplication
- Write deterministic tests (consistent results)
- Cover both happy paths and edge cases
- Test public interfaces, not internal implementation
- Keep tests independent of each other
- Use clear assertions with meaningful messages

## Test Coverage Guidelines

- Aim for high coverage of business-critical code
- Prioritize coverage of complex logic and edge cases
- Don't obsess over 100% coverage at the expense of meaningful tests
- Focus on code paths rather than simple line coverage
- Consider risk and complexity when prioritizing what to test

## Mocking Guidelines

- Mock external services and dependencies
- Use stubs for predetermined responses
- Use spies to verify interactions
- Avoid excessive mocking that reduces test value
- Mock at the appropriate abstraction level
- Document mock behavior clearly

## Assertion Best Practices

- Use specific assertions (e.g., `assertEquals` instead of `assertTrue`)
- Check only one logical assertion per test
- Write clear assertion messages explaining expected vs actual
- Verify the right things: state changes, interactions, or exceptions
- For collections, verify content regardless of order when appropriate

## Data Management

- Use test data factories or builders for complex objects
- Create minimal test data sets that focus on the test requirements
- Avoid shared mutable test data between tests
- Consider using test database fixtures for integration tests
- Clean up test data reliably after tests complete

## Test Organization

- Group tests by feature or component
- Separate slow tests from fast tests
- Use test suites to organize related tests
- Maintain parallel structure between code and tests
- Place tests in a location that mirrors the code structure

## Testing Anti-Patterns to Avoid

- Flaky tests with inconsistent results
- Tests that depend on external services without mocks
- Overly complex test setups
- Testing implementation details instead of behavior
- Excessive use of sleep/delay in asynchronous tests
- Ignoring test failures
- Testing trivial code with no logic
- Writing tests after code is already in production

## Special Testing Considerations

- **Asynchronous Code**: Use async/await patterns and avoid arbitrary delays
- **APIs**: Test request validation, response formats, and error cases
- **UIs**: Test component rendering, user interactions, and state management
- **Data Access**: Test query correctness and error handling
- **Security**: Test authorization, input validation, and error handling
