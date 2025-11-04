# Contributing to ServiceStack Zig

Thank you for your interest in contributing to the ServiceStack Zig client library!

## Development Setup

1. Install Zig 0.13.0 or later from [ziglang.org](https://ziglang.org/download/)
2. Clone the repository
3. Run tests: `zig build test`
4. Run examples: `zig build example`

## Building

```bash
# Build the library
zig build

# Run tests
zig build test

# Run the basic example
zig build example
```

## Code Style

- Follow the Zig standard library conventions
- Use `zig fmt` to format your code
- Add tests for new functionality
- Document public APIs with doc comments

## Testing

All new features should include appropriate tests. Run the test suite before submitting:

```bash
zig build test
```

## Submitting Changes

1. Fork the repository
2. Create a feature branch
3. Make your changes with tests
4. Ensure all tests pass
5. Submit a pull request

## Questions?

Feel free to open an issue if you have questions or need help with your contribution.
