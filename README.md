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
