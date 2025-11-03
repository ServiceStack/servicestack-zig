const std = @import("std");
const servicestack = @import("servicestack");

// Example DTOs for a more complex ServiceStack API
// These would typically be generated via "Add ServiceStack Reference"

// User-related DTOs
const User = struct {
    id: i32,
    username: []const u8,
    email: []const u8,
    created_at: []const u8,
};

const AuthenticateRequest = struct {
    username: []const u8,
    password: []const u8,
    provider: []const u8 = "credentials",
};

const AuthenticateResponse = struct {
    user_id: i32,
    session_id: []const u8,
    username: []const u8,
    bearer_token: []const u8,
};

// Todo-related DTOs
const Todo = struct {
    id: i32,
    user_id: i32,
    title: []const u8,
    description: ?[]const u8,
    completed: bool,
    priority: i32,
};

const CreateTodoRequest = struct {
    title: []const u8,
    description: ?[]const u8,
    priority: i32 = 1,
};

const CreateTodoResponse = struct {
    todo: Todo,
    success: bool,
    error_message: ?[]const u8,
};

const GetTodosRequest = struct {
    user_id: i32,
    completed: ?bool,
    limit: i32 = 10,
    offset: i32 = 0,
};

const GetTodosResponse = struct {
    todos: []Todo,
    total: i32,
    has_more: bool,
};

const UpdateTodoRequest = struct {
    id: i32,
    title: ?[]const u8,
    description: ?[]const u8,
    completed: ?bool,
    priority: ?i32,
};

const UpdateTodoResponse = struct {
    todo: Todo,
    success: bool,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    std.debug.print("=== ServiceStack Zig Client - Advanced Example ===\n\n", .{});

    // Initialize the client
    var client = try servicestack.JsonServiceClient.init(
        allocator,
        "https://api.example.com",
    );
    defer client.deinit();

    // Configure timeout
    client.setTimeout(30000); // 30 seconds

    std.debug.print("Client initialized successfully!\n", .{});
    std.debug.print("Base URL: {s}\n", .{client.base_url});
    std.debug.print("Timeout: {}ms\n\n", .{client.timeout_ms});

    // Example 1: Authentication
    std.debug.print("Example 1: Authentication\n", .{});
    std.debug.print("-------------------------\n", .{});
    const auth_request = AuthenticateRequest{
        .username = "user@example.com",
        .password = "password123",
    };
    std.debug.print("Request: POST /auth/login\n", .{});
    std.debug.print("  Username: {s}\n", .{auth_request.username});
    std.debug.print("  Provider: {s}\n\n", .{auth_request.provider});
    // In real usage:
    // const parsed_auth = try client.post(AuthenticateResponse, "/auth/login", auth_request);
    // defer parsed_auth.deinit();
    // std.debug.print("Authenticated! Session: {s}\n\n", .{parsed_auth.value.session_id});

    // Example 2: Create a Todo
    std.debug.print("Example 2: Create a Todo\n", .{});
    std.debug.print("------------------------\n", .{});
    const create_request = CreateTodoRequest{
        .title = "Learn Zig programming",
        .description = "Complete the ServiceStack Zig client integration",
        .priority = 1,
    };
    std.debug.print("Request: POST /todos\n", .{});
    std.debug.print("  Title: {s}\n", .{create_request.title});
    if (create_request.description) |desc| {
        std.debug.print("  Description: {s}\n", .{desc});
    }
    std.debug.print("  Priority: {}\n\n", .{create_request.priority});
    // In real usage:
    // const parsed_create = try client.post(CreateTodoResponse, "/todos", create_request);
    // defer parsed_create.deinit();

    // Example 3: Get Todos with filters
    std.debug.print("Example 3: Get Todos with Filters\n", .{});
    std.debug.print("---------------------------------\n", .{});
    const get_request = GetTodosRequest{
        .user_id = 1,
        .completed = false,
        .limit = 20,
        .offset = 0,
    };
    std.debug.print("Request: POST /todos/query\n", .{});
    std.debug.print("  User ID: {}\n", .{get_request.user_id});
    if (get_request.completed) |comp| {
        std.debug.print("  Completed: {}\n", .{comp});
    }
    std.debug.print("  Limit: {}\n", .{get_request.limit});
    std.debug.print("  Offset: {}\n\n", .{get_request.offset});
    // In real usage:
    // const parsed_todos = try client.post(GetTodosResponse, "/todos/query", get_request);
    // defer parsed_todos.deinit();

    // Example 4: Update a Todo
    std.debug.print("Example 4: Update a Todo\n", .{});
    std.debug.print("------------------------\n", .{});
    const update_request = UpdateTodoRequest{
        .id = 1,
        .title = null,
        .description = null,
        .completed = true,
        .priority = null,
    };
    std.debug.print("Request: PUT /todos/1\n", .{});
    std.debug.print("  ID: {}\n", .{update_request.id});
    if (update_request.completed) |comp| {
        std.debug.print("  Completed: {}\n", .{comp});
    }
    std.debug.print("\n", .{});
    // In real usage:
    // const parsed_update = try client.put(UpdateTodoResponse, "/todos/1", update_request);
    // defer parsed_update.deinit();

    // Example 5: Delete a Todo
    std.debug.print("Example 5: Delete a Todo\n", .{});
    std.debug.print("------------------------\n", .{});
    std.debug.print("Request: DELETE /todos/1\n", .{});
    // In real usage:
    // const parsed_delete = try client.delete(DeleteResponse, "/todos/1");
    // defer parsed_delete.deinit();

    std.debug.print("\n=== All examples completed successfully! ===\n", .{});
    std.debug.print("\nTo use with a real ServiceStack API:\n", .{});
    std.debug.print("1. Replace the base URL with your API endpoint\n", .{});
    std.debug.print("2. Define DTOs matching your service contracts\n", .{});
    std.debug.print("3. Uncomment the actual API calls\n", .{});
    std.debug.print("4. Handle responses appropriately\n", .{});
}
