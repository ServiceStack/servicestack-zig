// Example DTOs that would typically be generated via "Add ServiceStack Reference"
// This file demonstrates how to structure DTOs for use with the JsonServiceClient

const std = @import("std");

// ============================================================================
// Common Response Types
// ============================================================================

/// Standard ServiceStack ResponseStatus for error handling
pub const ResponseStatus = struct {
    error_code: ?[]const u8 = null,
    message: ?[]const u8 = null,
    stack_trace: ?[]const u8 = null,
    errors: ?[]ResponseError = null,
};

pub const ResponseError = struct {
    error_code: []const u8,
    field_name: []const u8,
    message: []const u8,
};

// ============================================================================
// Authentication DTOs
// ============================================================================

/// Request DTO for authenticating with ServiceStack
pub const Authenticate = struct {
    provider: []const u8 = "credentials",
    username: ?[]const u8 = null,
    password: ?[]const u8 = null,
    remember_me: ?bool = null,
    access_token: ?[]const u8 = null,
    access_token_secret: ?[]const u8 = null,
};

/// Response DTO from authentication
pub const AuthenticateResponse = struct {
    user_id: []const u8,
    session_id: []const u8,
    username: []const u8,
    display_name: ?[]const u8 = null,
    bearer_token: []const u8,
    refresh_token: ?[]const u8 = null,
    profile_url: ?[]const u8 = null,
    roles: ?[][]const u8 = null,
    permissions: ?[][]const u8 = null,
    response_status: ?ResponseStatus = null,
};

// ============================================================================
// User Management DTOs
// ============================================================================

pub const User = struct {
    id: i32,
    username: []const u8,
    email: []const u8,
    first_name: ?[]const u8 = null,
    last_name: ?[]const u8 = null,
    display_name: ?[]const u8 = null,
    created_date: []const u8,
    modified_date: ?[]const u8 = null,
};

pub const GetUser = struct {
    id: i32,
};

pub const GetUserResponse = struct {
    user: User,
    response_status: ?ResponseStatus = null,
};

pub const CreateUser = struct {
    username: []const u8,
    email: []const u8,
    password: []const u8,
    first_name: ?[]const u8 = null,
    last_name: ?[]const u8 = null,
};

pub const CreateUserResponse = struct {
    user: User,
    response_status: ?ResponseStatus = null,
};

pub const UpdateUser = struct {
    id: i32,
    email: ?[]const u8 = null,
    first_name: ?[]const u8 = null,
    last_name: ?[]const u8 = null,
    display_name: ?[]const u8 = null,
};

pub const UpdateUserResponse = struct {
    user: User,
    response_status: ?ResponseStatus = null,
};

pub const DeleteUser = struct {
    id: i32,
};

pub const DeleteUserResponse = struct {
    success: bool,
    response_status: ?ResponseStatus = null,
};

// ============================================================================
// Todo Management DTOs
// ============================================================================

pub const Priority = enum(i32) {
    Low = 0,
    Medium = 1,
    High = 2,
    Critical = 3,
};

pub const Todo = struct {
    id: i32,
    user_id: i32,
    title: []const u8,
    description: ?[]const u8 = null,
    completed: bool = false,
    priority: Priority = .Medium,
    due_date: ?[]const u8 = null,
    created_date: []const u8,
    modified_date: ?[]const u8 = null,
};

pub const GetTodos = struct {
    user_id: ?i32 = null,
    completed: ?bool = null,
    priority: ?Priority = null,
    limit: i32 = 100,
    offset: i32 = 0,
    order_by: ?[]const u8 = null,
};

pub const GetTodosResponse = struct {
    todos: []Todo,
    total: i32,
    offset: i32,
    limit: i32,
    response_status: ?ResponseStatus = null,
};

pub const GetTodo = struct {
    id: i32,
};

pub const GetTodoResponse = struct {
    todo: Todo,
    response_status: ?ResponseStatus = null,
};

pub const CreateTodo = struct {
    title: []const u8,
    description: ?[]const u8 = null,
    priority: Priority = .Medium,
    due_date: ?[]const u8 = null,
};

pub const CreateTodoResponse = struct {
    todo: Todo,
    response_status: ?ResponseStatus = null,
};

pub const UpdateTodo = struct {
    id: i32,
    title: ?[]const u8 = null,
    description: ?[]const u8 = null,
    completed: ?bool = null,
    priority: ?Priority = null,
    due_date: ?[]const u8 = null,
};

pub const UpdateTodoResponse = struct {
    todo: Todo,
    response_status: ?ResponseStatus = null,
};

pub const DeleteTodo = struct {
    id: i32,
};

pub const DeleteTodoResponse = struct {
    success: bool,
    response_status: ?ResponseStatus = null,
};

// ============================================================================
// Query DTOs with Filtering
// ============================================================================

pub const QueryResponse = struct {
    offset: i32,
    total: i32,
    results: []Todo, // Generic, would be specific type in real usage
    response_status: ?ResponseStatus = null,
};

// ============================================================================
// Example Usage
// ============================================================================

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    std.debug.print("=== ServiceStack Zig DTOs Example ===\n\n", .{});

    // Example 1: Authentication DTO
    const auth_request = Authenticate{
        .provider = "credentials",
        .username = "user@example.com",
        .password = "password123",
        .remember_me = true,
    };
    std.debug.print("Authentication Request:\n", .{});
    std.debug.print("  Provider: {s}\n", .{auth_request.provider});
    if (auth_request.username) |username| {
        std.debug.print("  Username: {s}\n", .{username});
    }
    if (auth_request.remember_me) |remember| {
        std.debug.print("  Remember Me: {}\n\n", .{remember});
    }

    // Example 2: Create Todo DTO
    const create_todo = CreateTodo{
        .title = "Learn Zig programming",
        .description = "Complete the ServiceStack integration",
        .priority = .High,
        .due_date = "2024-12-31T23:59:59Z",
    };
    std.debug.print("Create Todo Request:\n", .{});
    std.debug.print("  Title: {s}\n", .{create_todo.title});
    if (create_todo.description) |desc| {
        std.debug.print("  Description: {s}\n", .{desc});
    }
    std.debug.print("  Priority: {}\n", .{create_todo.priority});
    if (create_todo.due_date) |due| {
        std.debug.print("  Due Date: {s}\n\n", .{due});
    }

    // Example 3: Query Todos DTO
    const query_todos = GetTodos{
        .user_id = 1,
        .completed = false,
        .priority = .High,
        .limit = 20,
        .offset = 0,
        .order_by = "created_date DESC",
    };
    std.debug.print("Query Todos Request:\n", .{});
    if (query_todos.user_id) |user_id| {
        std.debug.print("  User ID: {}\n", .{user_id});
    }
    if (query_todos.completed) |completed| {
        std.debug.print("  Completed: {}\n", .{completed});
    }
    if (query_todos.priority) |priority| {
        std.debug.print("  Priority: {}\n", .{priority});
    }
    std.debug.print("  Limit: {}\n", .{query_todos.limit});
    std.debug.print("  Offset: {}\n", .{query_todos.offset});
    if (query_todos.order_by) |order_by| {
        std.debug.print("  Order By: {s}\n\n", .{order_by});
    }

    // Example 4: JSON serialization
    var json_buffer = std.ArrayList(u8).init(allocator);
    defer json_buffer.deinit();

    try std.json.stringify(create_todo, .{}, json_buffer.writer());
    std.debug.print("Serialized CreateTodo to JSON:\n{s}\n\n", .{json_buffer.items});

    std.debug.print("These DTOs would be used with JsonServiceClient like:\n", .{});
    std.debug.print("  const response = try client.post(AuthenticateResponse, \"/auth\", auth_request);\n", .{});
    std.debug.print("  const todo = try client.post(CreateTodoResponse, \"/todos\", create_todo);\n", .{});
    std.debug.print("  const todos = try client.post(GetTodosResponse, \"/todos/query\", query_todos);\n", .{});
}
