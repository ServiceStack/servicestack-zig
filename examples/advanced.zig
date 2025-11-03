const std = @import("std");
const servicestack = @import("servicestack");

/// Example showing advanced usage with error handling and JSON parsing
pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Create a ServiceStack client pointing to a test API
    var client = servicestack.Client.init(allocator, "https://httpbin.org");
    defer client.deinit();

    std.debug.print("ServiceStack Advanced Example\n", .{});
    std.debug.print("==============================\n\n", .{});

    // Example 1: GET request with error handling
    std.debug.print("1. GET request with error handling:\n", .{});
    const get_result = client.get("/get") catch |err| {
        std.debug.print("   Error: {}\n\n", .{err});
        return;
    };
    defer allocator.free(get_result);
    std.debug.print("   Success! Response length: {} bytes\n\n", .{get_result.len});

    // Example 2: POST request with custom JSON
    std.debug.print("2. POST request with custom data:\n", .{});
    const user_data =
        \\{
        \\  "name": "Alice",
        \\  "email": "alice@example.com",
        \\  "age": 30
        \\}
    ;
    const post_result = client.post("/post", user_data) catch |err| {
        std.debug.print("   Error: {}\n\n", .{err});
        return;
    };
    defer allocator.free(post_result);
    std.debug.print("   Posted user data successfully\n", .{});
    std.debug.print("   Response length: {} bytes\n\n", .{post_result.len});

    // Example 3: PUT request
    std.debug.print("3. PUT request to update resource:\n", .{});
    const update_data =
        \\{
        \\  "name": "Alice Smith",
        \\  "email": "alice.smith@example.com"
        \\}
    ;
    const put_result = client.put("/put", update_data) catch |err| {
        std.debug.print("   Error: {}\n\n", .{err});
        return;
    };
    defer allocator.free(put_result);
    std.debug.print("   Updated resource successfully\n\n", .{});

    // Example 4: DELETE request
    std.debug.print("4. DELETE request:\n", .{});
    const delete_result = client.delete("/delete") catch |err| {
        std.debug.print("   Error: {}\n\n", .{err});
        return;
    };
    defer allocator.free(delete_result);
    std.debug.print("   Deleted resource successfully\n\n", .{});

    std.debug.print("All operations completed!\n", .{});
}
