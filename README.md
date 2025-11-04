# servicestack-zig

ServiceStack Client Zig Library - A JsonServiceClient for making API requests to ServiceStack services.

## Overview

This library provides a `JsonServiceClient` for the Zig programming language that enables you to easily consume ServiceStack APIs using strongly-typed DTOs (Data Transfer Objects).

## Features

- ✅ HTTP GET, POST, PUT, DELETE, and PATCH support
- ✅ JSON serialization/deserialization
- ✅ Strongly-typed request/response DTOs
- ✅ Configurable timeouts
- ✅ Simple and intuitive API

## Installation

Add this package to your `build.zig.zon` dependencies:

```zig
.dependencies = .{
    .servicestack = .{
        .url = "https://github.com/ServiceStack/servicestack-zig/archive/refs/heads/main.tar.gz",
    },
},
# ServiceStack Zig

ServiceStack HTTP Client Library for Zig

## Overview

This library provides a simple and efficient HTTP client for interacting with ServiceStack services from Zig applications. It supports common HTTP methods (GET, POST, PUT, DELETE) with JSON serialization.

## Installation

### Using Zig Package Manager

Add this to your `build.zig.zon`:

```zig
.{
    .name = "my-project",
    .version = "0.1.0",
    .dependencies = .{
        .servicestack = .{
            .url = "https://github.com/ServiceStack/servicestack-zig/archive/<commit-hash>.tar.gz",
            .hash = "<hash>",
        },
    },
}
```

Then in your `build.zig`, add the module:

```zig
const servicestack_dep = b.dependency("servicestack", .{
    .target = target,
    .optimize = optimize,
});

exe.root_module.addImport("servicestack", servicestack_dep.module("servicestack"));
```

## Usage

### Basic Example

```zig
const std = @import("std");
const servicestack = @import("servicestack");

// Define your ServiceStack DTOs
const Hello = struct {
    name: []const u8,
};

const HelloResponse = struct {
    result: []const u8,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Initialize the JsonServiceClient
    var client = try servicestack.JsonServiceClient.init(
        allocator,
        "https://test.servicestack.net"
    );
    defer client.deinit();

    // Create a request DTO
    const request = Hello{ .name = "World" };

    // Make a POST request
    const parsed = try client.post(HelloResponse, "/hello", request);
    defer parsed.deinit();
    std.debug.print("Result: {s}\n", .{parsed.value.result});
}
```

### HTTP Methods

The `JsonServiceClient` supports all common HTTP methods:

```zig
// GET request
const parsed = try client.get(MyResponse, "/api/resource");
defer parsed.deinit();
const response = parsed.value;

// POST request
const parsed = try client.post(MyResponse, "/api/resource", request);
defer parsed.deinit();
const response = parsed.value;

// PUT request
const parsed = try client.put(MyResponse, "/api/resource", request);
defer parsed.deinit();
const response = parsed.value;

// DELETE request
const parsed = try client.delete(MyResponse, "/api/resource");
defer parsed.deinit();
const response = parsed.value;

// PATCH request
const parsed = try client.patch(MyResponse, "/api/resource", request);
defer parsed.deinit();
const response = parsed.value;
```

### Configuration

```zig
// Set custom timeout (in milliseconds)
client.setTimeout(60000); // 60 seconds
```
    // Create a ServiceStack client
    var client = servicestack.Client.init(allocator, "https://api.example.com");
    defer client.deinit();

    // GET request
    const response = try client.get("/users/123");
    defer allocator.free(response);
    std.debug.print("Response: {s}\n", .{response});

    // POST request with JSON body
    const json_body = "{\"name\": \"John Doe\"}";
    const post_response = try client.post("/users", json_body);
    defer allocator.free(post_response);
    
    // PUT request
    const put_response = try client.put("/users/123", json_body);
    defer allocator.free(put_response);
    
    // DELETE request
    const delete_response = try client.delete("/users/123");
    defer allocator.free(delete_response);
}
```

## API Reference

### Client

#### `init(allocator: std.mem.Allocator, base_url: []const u8) Client`

Creates a new ServiceStack client with the specified base URL.

#### `deinit(self: *Client) void`

Cleans up resources used by the client.

#### `get(self: *Client, path: []const u8) ![]const u8`

Sends a GET request to the specified path and returns the response body.

#### `post(self: *Client, path: []const u8, body: []const u8) ![]const u8`

Sends a POST request with a JSON body to the specified path and returns the response body.

#### `put(self: *Client, path: []const u8, body: []const u8) ![]const u8`

Sends a PUT request with a JSON body to the specified path and returns the response body.

#### `delete(self: *Client, path: []const u8) ![]const u8`

Sends a DELETE request to the specified path and returns the response body.

## Building

```bash
# Build the library
zig build

# Run tests
zig build test

# Run the example
zig build example
```

## Adding ServiceStack Reference

To use this client with your ServiceStack services, generate Zig DTOs using [Add ServiceStack Reference](https://docs.servicestack.net/add-servicestack-reference):

1. Use the ServiceStack `x` tool or your ServiceStack instance to generate DTOs
2. Add the generated Zig DTO files to your project
3. Import and use them with the `JsonServiceClient`

## Requirements

- Zig 0.11.0 or later

## License

See LICENSE file for details.
# Run tests
zig build test

# Run basic example
zig build example

# Run advanced example
zig build advanced
```

## Examples

The repository includes two examples:

- `examples/basic.zig` - Simple GET and POST requests
- `examples/advanced.zig` - Comprehensive example with error handling and all HTTP methods

Run them with:
```bash
zig build example
zig build advanced
```

## Publishing to Zigistry

This package is ready to be published to Zigistry (the Zig package registry). The `build.zig.zon` file contains all necessary metadata:

- Package name: `servicestack`
- Version: `0.1.0`
- Minimum Zig version: `0.13.0`
- License: MIT

To publish updates:

1. Update the version in `build.zig.zon`
2. Create a git tag: `git tag v0.1.0`
3. Push the tag: `git push origin v0.1.0`
4. Submit to Zigistry following their submission process

## Requirements

- Zig 0.13.0 or later

## License

MIT License - see LICENSE file for details

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.
