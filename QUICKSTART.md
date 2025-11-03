# Quick Start Guide

Get started with ServiceStack Zig in 5 minutes!

## 1. Install Zig

Download and install Zig 0.11.0 or later from [ziglang.org](https://ziglang.org/download/)

## 2. Create a New Project

```bash
mkdir my-servicestack-app
cd my-servicestack-app
zig init-exe
```

## 3. Add ServiceStack Zig Dependency

Edit `build.zig.zon` and add:

```zig
.{
    .name = "my-servicestack-app",
    .version = "0.1.0",
    .dependencies = .{
        .servicestack = .{
            .url = "https://github.com/ServiceStack/servicestack-zig/archive/refs/heads/main.tar.gz",
        },
    },
}
```

## 4. Update build.zig

Edit `build.zig` to include the servicestack module:

```zig
const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Get servicestack dependency
    const servicestack = b.dependency("servicestack", .{
        .target = target,
        .optimize = optimize,
    });

    const exe = b.addExecutable(.{
        .name = "my-servicestack-app",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    // Add servicestack module to your executable
    exe.addModule("servicestack", servicestack.module("servicestack"));
    
    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
```

## 5. Write Your First ServiceStack Client

Edit `src/main.zig`:

```zig
const std = @import("std");
const servicestack = @import("servicestack");

// Define your DTOs
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

    // Create the client
    var client = try servicestack.JsonServiceClient.init(
        allocator,
        "https://test.servicestack.net"
    );
    defer client.deinit();

    // Make a request
    const request = Hello{ .name = "World" };
    const response = try client.post(HelloResponse, "/hello", request);

    std.debug.print("Result: {s}\n", .{response.result});
}
```

## 6. Build and Run

```bash
zig build run
```

## What's Next?

### Explore Examples

Check out the examples directory:
- `examples/basic.zig` - Simple usage
- `examples/advanced.zig` - Complex DTOs and multiple requests
- `examples/dtos.zig` - DTO patterns and best practices

### Read Documentation

- [USAGE.md](USAGE.md) - Detailed usage guide
- [ADD_SERVICESTACK_REFERENCE.md](ADD_SERVICESTACK_REFERENCE.md) - Creating DTOs
- [README.md](README.md) - Full documentation

### Common Tasks

#### Define DTOs for Your API

Match your ServiceStack service contracts:

```zig
const User = struct {
    id: i32,
    name: []const u8,
    email: []const u8,
};

const GetUser = struct {
    id: i32,
};

const GetUserResponse = struct {
    user: User,
};
```

#### Make Different HTTP Requests

```zig
// GET request
const user = try client.get(GetUserResponse, "/users/1");

// POST request
const created = try client.post(CreateUserResponse, "/users", create_request);

// PUT request
const updated = try client.put(UpdateUserResponse, "/users/1", update_request);

// DELETE request
_ = try client.delete(DeleteResponse, "/users/1");
```

#### Configure Timeout

```zig
client.setTimeout(60000); // 60 seconds
```

#### Handle Errors

```zig
const response = client.get(MyResponse, "/endpoint") catch |err| {
    std.debug.print("Error: {}\n", .{err});
    return err;
};
```

## Troubleshooting

### Build Errors

If you get build errors:
1. Ensure you're using Zig 0.11.0 or later: `zig version`
2. Try cleaning the build cache: `rm -rf zig-cache zig-out`
3. Rebuild: `zig build`

### Runtime Errors

If requests fail:
1. Check that your base URL is correct
2. Verify your DTOs match the API response structure
3. Check network connectivity
4. Try increasing timeout: `client.setTimeout(60000)`

### Need Help?

- Open an issue on [GitHub](https://github.com/ServiceStack/servicestack-zig/issues)
- Check the [ServiceStack Community](https://forums.servicestack.net/)
- Read the detailed [documentation](README.md)

## Example: Real-World Todo App

Here's a complete example with CRUD operations:

```zig
const std = @import("std");
const servicestack = @import("servicestack");

const Todo = struct {
    id: i32,
    title: []const u8,
    completed: bool,
};

const CreateTodo = struct {
    title: []const u8,
};

const CreateTodoResponse = struct {
    todo: Todo,
};

const GetTodosResponse = struct {
    todos: []Todo,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var client = try servicestack.JsonServiceClient.init(
        allocator,
        "https://your-api.com"
    );
    defer client.deinit();

    // Create a todo
    const create = CreateTodo{ .title = "Learn Zig" };
    const created = try client.post(CreateTodoResponse, "/todos", create);
    std.debug.print("Created todo #{}: {s}\n", .{ created.todo.id, created.todo.title });

    // Get all todos
    const todos = try client.get(GetTodosResponse, "/todos");
    std.debug.print("Found {} todos\n", .{todos.todos.len});

    for (todos.todos) |todo| {
        const status = if (todo.completed) "✓" else " ";
        std.debug.print("[{s}] {}: {s}\n", .{ status, todo.id, todo.title });
    }
}
```

Happy coding with ServiceStack and Zig! 🚀
