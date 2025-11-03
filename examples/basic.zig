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
    // const response = try client.post(HelloResponse, "/hello", request);
    // std.debug.print("Response: {s}\n", .{response.result});

    std.debug.print("\nJsonServiceClient initialized successfully!\n", .{});
    std.debug.print("Base URL: {s}\n", .{client.base_url});
    std.debug.print("Timeout: {}ms\n", .{client.timeout_ms});

    std.debug.print("\nExample of how to use the client:\n", .{});
    std.debug.print("  const response = try client.post(HelloResponse, \"/hello\", request);\n", .{});
    std.debug.print("  std.debug.print(\"Result: {{s}}\\n\", .{{response.result}});\n", .{});
}
