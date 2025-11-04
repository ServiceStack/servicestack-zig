const std = @import("std");
const servicestack = @import("servicestack");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Create a ServiceStack client
    var client = servicestack.Client.init(allocator, "https://httpbin.org");
    defer client.deinit();

    std.debug.print("ServiceStack HTTP Client Example\n", .{});
    std.debug.print("==================================\n\n", .{});

    // Example GET request
    std.debug.print("Sending GET request to /get...\n", .{});
    const get_response = client.get("/get") catch |err| {
        std.debug.print("GET request failed: {}\n", .{err});
        return;
    };
    defer allocator.free(get_response);
    std.debug.print("GET Response: {s}\n\n", .{get_response});

    // Example POST request
    std.debug.print("Sending POST request to /post...\n", .{});
    const post_body = "{\"message\": \"Hello from ServiceStack Zig!\"}";
    const post_response = client.post("/post", post_body) catch |err| {
        std.debug.print("POST request failed: {}\n", .{err});
        return;
    };
    defer allocator.free(post_response);
    std.debug.print("POST Response: {s}\n\n", .{post_response});

    std.debug.print("Example completed successfully!\n", .{});
}
