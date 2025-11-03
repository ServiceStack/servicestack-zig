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

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

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
# Run tests
zig build test

# Run example
zig build example
```

## Requirements

- Zig 0.13.0 or later

## License

MIT License - see LICENSE file for details

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
