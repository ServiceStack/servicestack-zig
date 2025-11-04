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

    // Initialize the JsonServiceClient with your ServiceStack API base URL
    var client = try servicestack.JsonServiceClient.init(
        allocator,
        "https://test.servicestack.net",
    );
    defer client.deinit();

    // Create a request DTO
    const request = Hello{ .name = "Zig" };

    std.debug.print("Making request to ServiceStack API...\n", .{});
    std.debug.print("Request: Hello {{ name: \"{s}\" }}\n", .{request.name});

    // Make a POST request
    // Note: This is an example and will fail without a real endpoint
    // In a real scenario, you would use:
    // const parsed = try client.post(HelloResponse, "/hello", request);
    // defer parsed.deinit();
    // std.debug.print("Response: {s}\n", .{parsed.value.result});

    std.debug.print("\nJsonServiceClient initialized successfully!\n", .{});
    std.debug.print("Base URL: {s}\n", .{client.base_url});
    std.debug.print("Timeout: {}ms\n", .{client.timeout_ms});

    std.debug.print("\nExample of how to use the client:\n", .{});
    std.debug.print("  const parsed = try client.post(HelloResponse, \"/hello\", request);\n", .{});
    std.debug.print("  defer parsed.deinit();\n", .{});
    std.debug.print("  std.debug.print(\"Result: {{s}}\\n\", .{{parsed.value.result}});\n", .{});
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
