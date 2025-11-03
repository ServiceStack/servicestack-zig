# ServiceStack Zig Client Usage Guide

## Introduction

The ServiceStack Zig client library provides a `JsonServiceClient` class for making HTTP requests to ServiceStack services. This guide demonstrates how to use the client with ServiceStack DTOs.

## Quick Start

### 1. Import the Library

```zig
const std = @import("std");
const servicestack = @import("servicestack");
```

### 2. Define Your DTOs

ServiceStack DTOs are simple Zig structs that match your service's request/response contracts:

```zig
// Request DTO
const Hello = struct {
    name: []const u8,
};

// Response DTO
const HelloResponse = struct {
    result: []const u8,
};
```

### 3. Initialize the Client

```zig
pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var client = try servicestack.JsonServiceClient.init(
        allocator,
        "https://your-api.com"
    );
    defer client.deinit();
}
```

### 4. Make API Requests

```zig
// POST request with DTO
const request = Hello{ .name = "World" };
const response = try client.post(HelloResponse, "/hello", request);

// GET request
const users = try client.get(UsersResponse, "/users");

// PUT request
const updated = try client.put(UpdateResponse, "/users/1", updateRequest);

// DELETE request
const deleted = try client.delete(DeleteResponse, "/users/1");
```

## Advanced Usage

### Custom Timeout

Set a custom timeout for requests (in milliseconds):

```zig
client.setTimeout(60000); // 60 seconds
```

### Complex DTOs

ServiceStack DTOs can include nested structures, arrays, and optional fields:

```zig
const User = struct {
    id: i32,
    name: []const u8,
    email: []const u8,
    roles: [][]const u8,
    metadata: ?Metadata,
};

const Metadata = struct {
    created_at: []const u8,
    updated_at: []const u8,
};

const CreateUserRequest = struct {
    user: User,
};

const CreateUserResponse = struct {
    id: i32,
    success: bool,
    message: []const u8,
};
```

### Error Handling

The client returns Zig errors for various failure conditions:

```zig
const response = client.post(HelloResponse, "/hello", request) catch |err| {
    switch (err) {
        error.HttpError => {
            std.debug.print("HTTP request failed\n", .{});
        },
        error.OutOfMemory => {
            std.debug.print("Out of memory\n", .{});
        },
        else => {
            std.debug.print("Unknown error: {}\n", .{err});
        },
    }
    return err;
};
```

## ServiceStack DTO Generation

### Using Add ServiceStack Reference

ServiceStack supports "Add ServiceStack Reference" for generating strongly-typed DTOs in various languages. While Zig support may need to be added to the ServiceStack ecosystem, you can:

1. **Manually create DTOs**: Define Zig structs that match your service's contracts
2. **Convert from other languages**: If you have DTOs in other languages, convert them to Zig structs
3. **Use JSON examples**: Create structs based on actual JSON responses from your API

### DTO Naming Conventions

Follow Zig naming conventions when creating DTOs:

```zig
// PascalCase for struct names
const HelloRequest = struct {
    // snake_case for field names (or match your API's convention)
    name: []const u8,
    greeting_type: []const u8,
};
```

## Complete Example

```zig
const std = @import("std");
const servicestack = @import("servicestack");

// DTOs for a todo service
const Todo = struct {
    id: i32,
    title: []const u8,
    completed: bool,
};

const GetTodosResponse = struct {
    todos: []Todo,
    total: i32,
};

const CreateTodoRequest = struct {
    title: []const u8,
};

const CreateTodoResponse = struct {
    todo: Todo,
    success: bool,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Initialize client
    var client = try servicestack.JsonServiceClient.init(
        allocator,
        "https://api.example.com"
    );
    defer client.deinit();

    // Set timeout
    client.setTimeout(30000);

    // Get all todos
    const todos_response = try client.get(GetTodosResponse, "/todos");
    std.debug.print("Found {} todos\n", .{todos_response.total});

    // Create a new todo
    const create_request = CreateTodoRequest{ 
        .title = "Learn Zig with ServiceStack" 
    };
    const create_response = try client.post(
        CreateTodoResponse, 
        "/todos", 
        create_request
    );
    
    if (create_response.success) {
        std.debug.print("Created todo #{}: {s}\n", .{
            create_response.todo.id,
            create_response.todo.title,
        });
    }
}
```

## Best Practices

1. **Always defer deinit**: Call `defer client.deinit()` right after initialization
2. **Use allocators properly**: Pass the same allocator to the client that you use for your application
3. **Handle errors**: Always handle potential errors from API calls
4. **Define clear DTOs**: Keep your DTO structures simple and match your API contracts exactly
5. **Set appropriate timeouts**: Configure timeouts based on your API's expected response times

## Tips

- Use `std.testing.allocator` in tests for memory leak detection
- DTOs with `[]const u8` fields for strings will reference the JSON response buffer
- For long-lived response data, make copies with `allocator.dupe()`
- The client automatically sets `Content-Type` and `Accept` headers to `application/json`

## Troubleshooting

### Memory Issues

If you encounter memory issues:
- Ensure you're calling `client.deinit()`
- Check that response data doesn't outlive the client
- Use `std.testing.allocator` to detect leaks in tests

### JSON Parsing Errors

If JSON parsing fails:
- Verify your DTO structure matches the API response
- Use `ignore_unknown_fields = true` (already set by default)
- Check that field types match (i32 vs i64, etc.)

### Network Errors

If requests fail:
- Verify the base URL is correct
- Check that the endpoint path is valid
- Ensure the server is accessible
- Increase timeout for slow connections
