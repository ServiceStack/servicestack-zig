# Add ServiceStack Reference for Zig

This document describes how to use ServiceStack DTOs with the Zig JsonServiceClient.

## Overview

[Add ServiceStack Reference](https://docs.servicestack.net/add-servicestack-reference) is ServiceStack's feature for generating strongly-typed client DTOs from your service contracts. While native Zig DTO generation support may be added to ServiceStack in the future, you can currently create Zig DTOs manually based on your service contracts.

## Creating Zig DTOs

### Manual DTO Creation

Based on your ServiceStack service's metadata, create corresponding Zig structs:

#### Example ServiceStack C# DTOs:

```csharp
[Route("/hello")]
public class Hello : IReturn<HelloResponse>
{
    public string Name { get; set; }
}

public class HelloResponse
{
    public string Result { get; set; }
}
```

#### Corresponding Zig DTOs:

```zig
const Hello = struct {
    name: []const u8,
};

const HelloResponse = struct {
    result: []const u8,
};
```

### Type Mappings

Map ServiceStack/C# types to Zig types:

| ServiceStack/C# | Zig Type |
|-----------------|----------|
| `string` | `[]const u8` |
| `int` | `i32` |
| `long` | `i64` |
| `bool` | `bool` |
| `double` | `f64` |
| `float` | `f32` |
| `DateTime` | `[]const u8` (ISO 8601 string) |
| `List<T>` | `[]T` |
| `T?` (nullable) | `?T` |

### Field Naming Conventions

ServiceStack typically uses PascalCase for property names, but JSON serialization often uses camelCase. The Zig client uses the field names as-is, so match your API's JSON format:

```zig
// If your API returns: { "firstName": "John", "lastName": "Doe" }
const User = struct {
    firstName: []const u8,
    lastName: []const u8,
};

// If your API returns: { "first_name": "John", "last_name": "Doe" }
const User = struct {
    first_name: []const u8,
    last_name: []const u8,
};
```

## Complete Example

### 1. ServiceStack Service (C#)

```csharp
[Route("/todos", "GET")]
public class GetTodos : IReturn<GetTodosResponse>
{
    public int UserId { get; set; }
    public bool? Completed { get; set; }
}

public class GetTodosResponse
{
    public List<Todo> Todos { get; set; }
    public int Total { get; set; }
}

public class Todo
{
    public int Id { get; set; }
    public string Title { get; set; }
    public bool Completed { get; set; }
}
```

### 2. Zig DTOs

```zig
const GetTodos = struct {
    userId: i32,
    completed: ?bool,
};

const GetTodosResponse = struct {
    todos: []Todo,
    total: i32,
};

const Todo = struct {
    id: i32,
    title: []const u8,
    completed: bool,
};
```

### 3. Usage

```zig
const std = @import("std");
const servicestack = @import("servicestack");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var client = try servicestack.JsonServiceClient.init(
        allocator,
        "https://your-api.com"
    );
    defer client.deinit();

    const request = GetTodos{
        .userId = 1,
        .completed = null,
    };

    const response = try client.post(GetTodosResponse, "/todos", request);
    
    std.debug.print("Found {} todos\n", .{response.total});
    for (response.todos) |todo| {
        std.debug.print("- {s} (completed: {})\n", .{todo.title, todo.completed});
    }
}
```

## Working with Complex Types

### Nested Objects

```zig
const User = struct {
    id: i32,
    name: []const u8,
    profile: Profile,
};

const Profile = struct {
    bio: []const u8,
    avatar_url: []const u8,
};
```

### Optional Fields

Use Zig's optional type `?T` for nullable fields:

```zig
const Todo = struct {
    id: i32,
    title: []const u8,
    description: ?[]const u8,  // Can be null
    due_date: ?[]const u8,     // Can be null
};
```

### Arrays/Lists

```zig
const User = struct {
    id: i32,
    name: []const u8,
    roles: [][]const u8,  // Array of strings
    permissions: []Permission,  // Array of objects
};
```

### Enums

Map ServiceStack enums to Zig enums:

```csharp
public enum Priority
{
    Low = 0,
    Medium = 1,
    High = 2
}
```

```zig
const Priority = enum(i32) {
    Low = 0,
    Medium = 1,
    High = 2,
};

const Todo = struct {
    id: i32,
    title: []const u8,
    priority: Priority,
};
```

## Best Practices

1. **Organize DTOs by Service**: Group related DTOs in separate Zig files
2. **Use Consistent Naming**: Match field names to your API's JSON format exactly
3. **Document Special Cases**: Add comments for fields with special handling
4. **Version DTOs**: Keep DTOs in sync with your ServiceStack service version
5. **Share Common Types**: Extract shared types (like `ResponseStatus`) to a common file

## Example Project Structure

```
your-project/
├── build.zig
├── src/
│   ├── main.zig
│   └── dtos/
│       ├── common.zig       # Shared types
│       ├── auth.zig         # Authentication DTOs
│       ├── todos.zig        # Todo service DTOs
│       └── users.zig        # User service DTOs
└── examples/
    └── api_usage.zig
```

### Common DTOs (common.zig):

```zig
pub const ResponseStatus = struct {
    error_code: ?[]const u8,
    message: ?[]const u8,
    stack_trace: ?[]const u8,
    errors: ?[]ResponseError,
};

pub const ResponseError = struct {
    error_code: []const u8,
    field_name: []const u8,
    message: []const u8,
};
```

## Future Integration

ServiceStack may add native Zig support to "Add ServiceStack Reference" in the future, which would allow automatic generation of Zig DTOs from your service metadata. Until then, manually creating DTOs as shown in this guide is the recommended approach.

## Tips

1. Use your ServiceStack service's `/types/zig` endpoint (once supported) or `/types/typescript` as a reference
2. Test your DTOs with sample JSON responses to ensure correct structure
3. Use `std.json.stringify` to validate request DTO serialization
4. Use `std.json.parseFromSlice` to test response parsing manually if needed

## Resources

- [ServiceStack Add Reference](https://docs.servicestack.net/add-servicestack-reference)
- [Zig JSON Documentation](https://ziglang.org/documentation/master/std/#std;json)
- [ServiceStack Client Architecture](https://docs.servicestack.net/clients-overview)
