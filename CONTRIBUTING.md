# Contributing to swift-music

Thank you for your interest in contributing to swift-music! This document provides guidelines and standards for contributing to the project.

## Code of Conduct

- Be respectful and constructive in all interactions
- Focus on what is best for the community and the project
- Show empathy towards other community members

## Getting Started

1. Fork the repository
2. Clone your fork locally
3. Create a feature branch from `main`
4. Make your changes
5. Run tests to ensure nothing breaks
6. Submit a pull request

## Development Setup

### Prerequisites

- Swift 6.0 or later
- Xcode 16.0 or later (for macOS development)
- Git

### Building the Project

```bash
swift build
```

### Running Tests

```bash
swift test
```

### Generating Documentation

```bash
swift package generate-documentation --target Music
```

## Coding Standards

This project follows modern Swift best practices and 0xLeif's development standards:

### Swift Style Guidelines

1. **Protocol-Oriented Design**
   - Favor protocols and protocol extensions over class inheritance
   - Use protocol composition to build flexible, reusable components

2. **Value Types First**
   - Use structs and enums by default
   - Only use classes when reference semantics are required

3. **Type Safety**
   - Leverage Swift's type system to prevent errors at compile time
   - Use enums with associated values for representing state
   - Avoid force unwrapping (`!`) in production code

4. **Naming Conventions**
   - Follow Swift API Design Guidelines
   - Use clear, descriptive names
   - Prefer full words over abbreviations
   - Use camelCase for properties and methods
   - Use PascalCase for types

5. **Access Control**
   - Be intentional with access modifiers
   - Default to the most restrictive access level
   - Make public APIs clear and well-documented

6. **Error Handling**
   - Use `Result` types and `async throws` appropriately
   - Make error cases explicit and recoverable
   - Provide meaningful error messages

7. **Documentation**
   - Document all public APIs with triple-slash comments (`///`)
   - Include parameter descriptions and return values
   - Add usage examples for complex APIs
   - Focus on "why" rather than "what"

8. **Functional Patterns**
   - Embrace `map`, `flatMap`, `compactMap`, `filter`, `reduce`
   - Minimize mutable state
   - Prefer `let` over `var`

9. **Concurrency**
   - All types must be `Sendable` for Swift 6 compatibility
   - Use structured concurrency patterns when needed
   - Avoid data races and thread-unsafe code

### Code Formatting

- Use 4 spaces for indentation (no tabs)
- Maximum line length: 120 characters (flexible for readability)
- Use trailing closure syntax when appropriate
- Be explicit about capture lists in closures
- Use `guard` statements for early returns and input validation

### Example Code Style

```swift
/// Represents a musical interval between two pitches
///
/// An interval is defined by its numeric distance and quality.
public struct Interval: Sendable {
    /// The numeric distance (1 = unison, 2 = second, etc.)
    public let number: Int

    /// The quality of the interval
    public let quality: IntervalQuality

    /// Creates an interval with the specified properties
    /// - Parameters:
    ///   - number: The interval number (1-based)
    ///   - quality: The interval quality
    public init(number: Int, quality: IntervalQuality) {
        self.number = number
        self.quality = quality
    }

    /// Returns the inversion of this interval
    ///
    /// For example, a major third (M3) inverts to a minor sixth (m6).
    public var inverted: Interval {
        let invertedNumber = 9 - number
        let invertedQuality = quality.inverted
        return Interval(number: invertedNumber, quality: invertedQuality)
    }
}
```

## Testing

### Test Requirements

- All new features must include tests
- Maintain or improve code coverage
- Tests should be clear and focused
- Use descriptive test names that explain the behavior being tested
- Use Swift Testing framework (not XCTest)

### Test Organization

```swift
import Testing
@testable import Music

@Suite("Interval Tests")
struct IntervalTests {
    @Test("Major third inverts to minor sixth")
    func majorThirdInversion() {
        let majorThird = Interval.majorThird
        let inverted = majorThird.inverted

        #expect(inverted.number == 6)
        #expect(inverted.quality == .minor)
    }
}
```

## Pull Request Process

1. **Update Documentation**
   - Update README.md if adding new features
   - Add or update code documentation
   - Update CHANGELOG.md following Keep a Changelog format

2. **Write Tests**
   - Add tests for new functionality
   - Ensure all tests pass locally

3. **Code Review**
   - Ensure your code follows the style guidelines
   - Address any CI/CD failures
   - Respond to review comments promptly

4. **PR Description**
   - Clearly describe what the PR does
   - Reference any related issues
   - Include examples if adding new features

### PR Title Format

Use conventional commit style:
- `feat: Add new scale pattern for Hungarian minor`
- `fix: Correct MIDI file encoding for edge case`
- `docs: Update chord progression examples`
- `test: Add tests for frequency conversion`
- `refactor: Simplify interval inversion logic`

## Commit Guidelines

- Write clear, concise commit messages
- Use present tense ("Add feature" not "Added feature")
- Use imperative mood ("Move cursor to..." not "Moves cursor to...")
- Reference issues and PRs where appropriate
- Keep commits focused and atomic

## Areas for Contribution

We welcome contributions in these areas:

### High Priority
- Additional scale patterns
- More chord voicing algorithms
- Extended MIDI features
- Performance optimizations
- Documentation improvements
- Bug fixes

### Medium Priority
- Additional chord progressions
- Musical analysis tools
- More comprehensive examples
- Tutorial documentation

### Nice to Have
- Additional rhythm patterns
- Tuning system support
- Harmonic analysis
- Integration examples

## Questions or Problems?

- Open an issue for bugs or feature requests
- Use discussions for questions and ideas
- Tag issues appropriately (bug, enhancement, documentation, etc.)

## License

By contributing to swift-music, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to swift-music and helping make Swift music theory development better!
