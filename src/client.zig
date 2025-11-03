const std = @import("std");
const http = std.http;
const json = std.json;
const mem = std.mem;

/// JsonServiceClient is a client for making HTTP requests to ServiceStack services
/// It handles JSON serialization/deserialization and provides a simple API
pub const JsonServiceClient = struct {
    allocator: mem.Allocator,
    base_url: []const u8,
    timeout_ms: u32,
    max_response_size: usize,

    const Self = @This();

    /// Initialize a new JsonServiceClient
    pub fn init(allocator: mem.Allocator, base_url: []const u8) !Self {
        return Self{
            .allocator = allocator,
            .base_url = try allocator.dupe(u8, base_url),
            .timeout_ms = 30000, // 30 second default timeout (note: not enforced by std.http yet)
            .max_response_size = 10 * 1024 * 1024, // 10MB default max response size
        };
    }

    /// Deinitialize and cleanup resources
    pub fn deinit(self: *Self) void {
        self.allocator.free(self.base_url);
    }

    /// Set the timeout for requests in milliseconds
    /// Note: Currently not enforced by std.http.Client, reserved for future use
    pub fn setTimeout(self: *Self, timeout_ms: u32) void {
        self.timeout_ms = timeout_ms;
    }

    /// Set the maximum response size in bytes
    pub fn setMaxResponseSize(self: *Self, max_size: usize) void {
        self.max_response_size = max_size;
    }

    /// Send a GET request and parse the response
    /// Caller owns the returned Parsed(TResponse) and must call deinit() on it
    pub fn get(self: *Self, comptime TResponse: type, path: []const u8) !json.Parsed(TResponse) {
        return self.send(TResponse, .GET, path, null);
    }

    /// Send a POST request with a request DTO and parse the response
    /// Caller owns the returned Parsed(TResponse) and must call deinit() on it
    pub fn post(self: *Self, comptime TResponse: type, path: []const u8, request: anytype) !json.Parsed(TResponse) {
        return self.send(TResponse, .POST, path, request);
    }

    /// Send a PUT request with a request DTO and parse the response
    /// Caller owns the returned Parsed(TResponse) and must call deinit() on it
    pub fn put(self: *Self, comptime TResponse: type, path: []const u8, request: anytype) !json.Parsed(TResponse) {
        return self.send(TResponse, .PUT, path, request);
    }

    /// Send a DELETE request and parse the response
    /// Caller owns the returned Parsed(TResponse) and must call deinit() on it
    pub fn delete(self: *Self, comptime TResponse: type, path: []const u8) !json.Parsed(TResponse) {
        return self.send(TResponse, .DELETE, path, null);
    }

    /// Send a PATCH request with a request DTO and parse the response
    /// Caller owns the returned Parsed(TResponse) and must call deinit() on it
    pub fn patch(self: *Self, comptime TResponse: type, path: []const u8, request: anytype) !json.Parsed(TResponse) {
        return self.send(TResponse, .PATCH, path, request);
    }

    /// Internal method to send HTTP requests
    fn send(
        self: *Self,
        comptime TResponse: type,
        method: http.Method,
        path: []const u8,
        request: anytype,
    ) !json.Parsed(TResponse) {
        var client = http.Client{ .allocator = self.allocator };
        defer client.deinit();

        // Build full URL
        const url = try std.fmt.allocPrint(self.allocator, "{s}{s}", .{ self.base_url, path });
        defer self.allocator.free(url);

        const uri = try std.Uri.parse(url);

        // Prepare request body if provided
        var body_buffer: ?[]const u8 = null;
        defer if (body_buffer) |buf| self.allocator.free(buf);

        if (request != null) {
            var body_list = std.ArrayList(u8).init(self.allocator);
            defer body_list.deinit();

            try json.stringify(request, .{}, body_list.writer());
            body_buffer = try body_list.toOwnedSlice();
        }

        // Create headers
        var headers = http.Headers{ .allocator = self.allocator };
        defer headers.deinit();

        try headers.append("accept", "application/json");
        try headers.append("content-type", "application/json");

        // Make the request
        const server_header_buffer = try self.allocator.alloc(u8, 8192);
        defer self.allocator.free(server_header_buffer);
        
        var req = try client.open(method, uri, .{
            .server_header_buffer = server_header_buffer,
            .headers = headers,
        });
        defer req.deinit();

        // Set content length for non-empty requests
        if (body_buffer) |body| {
            req.transfer_encoding = .{ .content_length = body.len };
        } else {
            req.transfer_encoding = .{ .content_length = 0 };
        }

        try req.send();

        if (body_buffer) |body| {
            try req.writeAll(body);
        }

        try req.finish();
        try req.wait();

        // Check status code
        if (req.response.status != .ok) {
            // TODO: Improve error handling to include status code and response body
            return error.HttpError;
        }

        // Read response
        var response_buffer = std.ArrayList(u8).init(self.allocator);
        defer response_buffer.deinit();

        try req.reader().readAllArrayList(&response_buffer, self.max_response_size);

        // Parse JSON response
        // Note: Caller owns the returned Parsed(TResponse) and must call deinit() on it
        return try json.parseFromSlice(
            TResponse,
            self.allocator,
            response_buffer.items,
            .{ .ignore_unknown_fields = true },
        );
    }
};

/// Example DTO structure for demonstration
pub const HelloResponse = struct {
    result: []const u8,
};

pub const Hello = struct {
    name: []const u8,
};

// Tests
test "JsonServiceClient init and deinit" {
    const allocator = std.testing.allocator;
    var client = try JsonServiceClient.init(allocator, "https://example.org");
    defer client.deinit();

    try std.testing.expectEqualStrings("https://example.org", client.base_url);
    try std.testing.expectEqual(@as(u32, 30000), client.timeout_ms);
}

test "JsonServiceClient setTimeout" {
    const allocator = std.testing.allocator;
    var client = try JsonServiceClient.init(allocator, "https://example.org");
    defer client.deinit();

    client.setTimeout(5000);
    try std.testing.expectEqual(@as(u32, 5000), client.timeout_ms);
}

test "Hello DTO structure" {
    const allocator = std.testing.allocator;
    const hello = Hello{ .name = "World" };

    var list = std.ArrayList(u8).init(allocator);
    defer list.deinit();

    try json.stringify(hello, .{}, list.writer());
    const result = list.items;

    try std.testing.expect(mem.indexOf(u8, result, "World") != null);
}
