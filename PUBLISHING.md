# Publishing to Zigistry

This document describes the setup for publishing the ServiceStack Zig library to Zigistry.

## Package Structure

The package is structured according to Zigistry requirements:

### Required Files

1. **build.zig.zon** - Package metadata file
   - Package name: `servicestack`
   - Version: `0.1.0`
   - Description: ServiceStack HTTP Client Library for Zig
   - Minimum Zig version: `0.13.0`
   - License: MIT
   - Paths: Specifies which files are included in the package

2. **build.zig** - Build configuration
   - Defines the `servicestack` module
   - Sets up tests with `zig build test`
   - Provides example builds with `zig build example` and `zig build advanced`
   - Uses standard Zig build system conventions

3. **src/lib.zig** - Main library file
   - Exports the public API
   - Includes documentation comments
   - Contains unit tests

4. **LICENSE** - MIT License file

5. **README.md** - Package documentation
   - Installation instructions
   - Usage examples
   - API reference

### Additional Files

- **CONTRIBUTING.md** - Contributor guidelines
- **examples/** - Example code demonstrating usage
  - `basic.zig` - Simple examples
  - `advanced.zig` - Comprehensive usage
- **.github/workflows/ci.yml** - GitHub Actions CI/CD

## How to Publish

### Step 1: Prepare Release

1. Update version in `build.zig.zon`
2. Update README.md with any changes
3. Ensure all tests pass: `zig build test`
4. Commit all changes

### Step 2: Create Git Tag

```bash
git tag v0.1.0
git push origin v0.1.0
```

### Step 3: Submit to Zigistry

Follow the Zigistry submission process:

1. Visit [zigistry.dev](https://zigistry.dev) (when available)
2. Submit the package with the GitHub repository URL
3. The package manager will use the git tag to fetch the code
4. Zigistry will calculate the hash for the tarball

### Step 4: Using the Package

Once published, users can add it to their projects:

```zig
// build.zig.zon
.{
    .name = "my-project",
    .version = "0.1.0",
    .dependencies = .{
        .servicestack = .{
            .url = "https://github.com/ServiceStack/servicestack-zig/archive/v0.1.0.tar.gz",
            .hash = "1220...", // Hash provided by Zigistry
        },
    },
}
```

## Package Features

### HTTP Client

The package provides a complete HTTP client for ServiceStack services:

- **GET** requests
- **POST** requests with JSON body
- **PUT** requests with JSON body
- **DELETE** requests
- Automatic JSON content-type headers
- Error handling
- Memory management with allocators

### Testing

Run tests with:
```bash
zig build test
```

Tests include:
- Client initialization
- URL construction
- Basic functionality tests

### Examples

Two examples are provided:

1. **Basic Example** (`zig build example`)
   - Simple GET and POST requests
   - Basic error handling
   
2. **Advanced Example** (`zig build advanced`)
   - All HTTP methods
   - Comprehensive error handling
   - JSON data examples

## Continuous Integration

GitHub Actions CI is configured to:
- Test on multiple Zig versions (0.13.0, 0.14.0)
- Run all tests
- Build all examples
- Check code formatting

## Versioning

The package follows Semantic Versioning:
- MAJOR version for incompatible API changes
- MINOR version for backwards-compatible functionality
- PATCH version for backwards-compatible bug fixes

Current version: **0.1.0** (Initial release)

## Support

For issues or questions:
- Open an issue on GitHub
- See CONTRIBUTING.md for contribution guidelines

## License

This package is released under the MIT License. See LICENSE file for details.
