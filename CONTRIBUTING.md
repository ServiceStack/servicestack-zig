# Contributing to ServiceStack Zig

Thank you for your interest in contributing to the ServiceStack Zig client library!

## Development Setup

### Prerequisites

- Zig 0.11.0 or later
- Git

### Getting Started

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/YOUR_USERNAME/servicestack-zig.git
   cd servicestack-zig
   ```

3. Build the project:
   ```bash
   zig build
   ```

4. Run tests:
   ```bash
   zig build test
   ```

## Project Structure

```
servicestack-zig/
├── src/
│   └── client.zig          # Main JsonServiceClient implementation
├── examples/
│   ├── basic.zig           # Basic usage example
│   └── advanced.zig        # Advanced usage with multiple DTOs
├── build.zig               # Build configuration
├── build.zig.zon           # Package metadata
├── README.md               # Main documentation
├── USAGE.md                # Detailed usage guide
├── ADD_SERVICESTACK_REFERENCE.md  # DTO creation guide
└── .github/
    └── workflows/
        └── ci.yml          # CI configuration
```

## Making Changes

### Code Style

Follow the Zig standard library conventions:
- 4 spaces for indentation
- Snake_case for function names
- PascalCase for type names
- Descriptive variable names
- Clear documentation comments

### Testing

All new features and bug fixes should include tests:

```zig
test "descriptive test name" {
    const allocator = std.testing.allocator;
    
    // Your test code here
    
    try std.testing.expectEqual(expected, actual);
}
```

Run tests with:
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

### Documentation

- Add doc comments to all public APIs
- Update README.md if adding new features
- Add examples for new functionality
- Keep USAGE.md up to date

### Commit Messages

Use clear, descriptive commit messages:
- Use present tense ("Add feature" not "Added feature")
- First line should be 50 chars or less
- Reference issues and pull requests when relevant

Example:
```
Add support for custom headers

- Add setHeader method to JsonServiceClient
- Update documentation with header examples
- Add tests for header functionality

Fixes #123
```

## Submitting Changes

1. Create a feature branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes and commit:
   ```bash
   git add .
   git commit -m "Your descriptive commit message"
   ```

3. Push to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```

4. Open a Pull Request

### Pull Request Guidelines

- Provide a clear description of the changes
- Reference any related issues
- Ensure all tests pass
- Update documentation as needed
- Keep changes focused and minimal

## Areas for Contribution

### High Priority

- [ ] Custom header support
- [ ] Authentication integration (Bearer tokens, API keys)
- [ ] Better error handling and custom error types
- [ ] Response status handling
- [ ] Request/response interceptors
- [ ] Streaming support for large responses

### Medium Priority

- [ ] Connection pooling
- [ ] Retry logic with exponential backoff
- [ ] Request caching
- [ ] Multipart form data support
- [ ] File upload/download helpers
- [ ] WebSocket support

### Documentation

- [ ] More comprehensive examples
- [ ] Integration guides for popular ServiceStack services
- [ ] Tutorial videos or blog posts
- [ ] API reference documentation

### Infrastructure

- [ ] Benchmark suite
- [ ] Integration tests with real ServiceStack service
- [ ] Performance profiling
- [ ] Memory usage optimization

## Testing with Real ServiceStack Services

When testing with real ServiceStack services:

1. Use the public test instance at `https://test.servicestack.net`
2. Or set up a local ServiceStack service for testing
3. Add integration tests in a separate directory
4. Document any setup required

## Code Review Process

1. All submissions require review from maintainers
2. Address review feedback promptly
3. Keep discussions focused and professional
4. Be open to suggestions and improvements

## Bug Reports

When reporting bugs, please include:

- Zig version
- Operating system
- Minimal reproduction code
- Expected vs actual behavior
- Error messages or stack traces

Use the GitHub issue template when available.

## Feature Requests

For feature requests:

- Describe the use case clearly
- Explain why the feature would be useful
- Provide examples if possible
- Discuss potential implementation approaches

## Questions and Support

- GitHub Issues: For bug reports and feature requests
- GitHub Discussions: For questions and community discussion
- ServiceStack Forums: For ServiceStack-specific questions

## License

By contributing, you agree that your contributions will be licensed under the same license as the project (BSD 3-Clause).

## Recognition

Contributors will be recognized in the README and release notes.

Thank you for contributing to ServiceStack Zig!
## Submitting Changes

1. Fork the repository
2. Create a feature branch
3. Make your changes with tests
4. Ensure all tests pass
5. Submit a pull request

## Questions?

Feel free to open an issue if you have questions or need help with your contribution.
