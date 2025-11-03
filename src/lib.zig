const std = @import("std");

/// ServiceStack HTTP Client for Zig
/// 
/// This library provides a simple HTTP client for interacting with ServiceStack services.
/// It supports JSON serialization/deserialization and common HTTP methods.

/// Maximum size for HTTP response bodies (10 MB)
const max_response_size = 10 * 1024 * 1024;

/// HTTP Client for ServiceStack services
pub const Client = struct {
    allocator: std.mem.Allocator,
    base_url: []const u8,
    http_client: std.http.Client,

    /// Initialize a new ServiceStack client
    pub fn init(allocator: std.mem.Allocator, base_url: []const u8) Client {
        return Client{
            .allocator = allocator,
            .base_url = base_url,
            .http_client = .{ .allocator = allocator },
        };
    }

    /// Cleanup resources
    pub fn deinit(self: *Client) void {
        self.http_client.deinit();
    }

    /// Send a GET request to the specified path
    pub fn get(self: *Client, path: []const u8) ![]const u8 {
        const url = try std.fmt.allocPrint(self.allocator, "{s}{s}", .{ self.base_url, path });
        defer self.allocator.free(url);

        const uri = try std.Uri.parse(url);
        
        var headers = std.http.Headers{ .allocator = self.allocator };
        defer headers.deinit();

        try headers.append("Accept", "application/json");

        var request = try self.http_client.open(.GET, uri, headers, .{});
        defer request.deinit();

        try request.send();
        try request.finish();
        try request.wait();

        if (request.response.status != .ok) {
            return error.HttpRequestFailed;
        }

        var response_body = std.ArrayList(u8).init(self.allocator);
        defer response_body.deinit();

        try request.reader().readAllArrayList(&response_body, max_response_size);

        return try response_body.toOwnedSlice();
    }

    /// Send a POST request with JSON body to the specified path
    pub fn post(self: *Client, path: []const u8, body: []const u8) ![]const u8 {
        const url = try std.fmt.allocPrint(self.allocator, "{s}{s}", .{ self.base_url, path });
        defer self.allocator.free(url);

        const uri = try std.Uri.parse(url);
        
        var headers = std.http.Headers{ .allocator = self.allocator };
        defer headers.deinit();

        try headers.append("Accept", "application/json");
        try headers.append("Content-Type", "application/json");

        var request = try self.http_client.open(.POST, uri, headers, .{});
        defer request.deinit();

        request.transfer_encoding = .{ .content_length = body.len };
        
        try request.send();
        try request.writeAll(body);
        try request.finish();
        try request.wait();

        if (request.response.status != .ok and request.response.status != .created) {
            return error.HttpRequestFailed;
        }

        var response_body = std.ArrayList(u8).init(self.allocator);
        defer response_body.deinit();

        try request.reader().readAllArrayList(&response_body, max_response_size);

        return try response_body.toOwnedSlice();
    }

    /// Send a PUT request with JSON body to the specified path
    pub fn put(self: *Client, path: []const u8, body: []const u8) ![]const u8 {
        const url = try std.fmt.allocPrint(self.allocator, "{s}{s}", .{ self.base_url, path });
        defer self.allocator.free(url);

        const uri = try std.Uri.parse(url);
        
        var headers = std.http.Headers{ .allocator = self.allocator };
        defer headers.deinit();

        try headers.append("Accept", "application/json");
        try headers.append("Content-Type", "application/json");

        var request = try self.http_client.open(.PUT, uri, headers, .{});
        defer request.deinit();

        request.transfer_encoding = .{ .content_length = body.len };
        
        try request.send();
        try request.writeAll(body);
        try request.finish();
        try request.wait();

        if (request.response.status != .ok) {
            return error.HttpRequestFailed;
        }

        var response_body = std.ArrayList(u8).init(self.allocator);
        defer response_body.deinit();

        try request.reader().readAllArrayList(&response_body, max_response_size);

        return try response_body.toOwnedSlice();
    }

    /// Send a DELETE request to the specified path
    pub fn delete(self: *Client, path: []const u8) ![]const u8 {
        const url = try std.fmt.allocPrint(self.allocator, "{s}{s}", .{ self.base_url, path });
        defer self.allocator.free(url);

        const uri = try std.Uri.parse(url);
        
        var headers = std.http.Headers{ .allocator = self.allocator };
        defer headers.deinit();

        try headers.append("Accept", "application/json");

        var request = try self.http_client.open(.DELETE, uri, headers, .{});
        defer request.deinit();

        try request.send();
        try request.finish();
        try request.wait();

        if (request.response.status != .ok and request.response.status != .no_content) {
            return error.HttpRequestFailed;
        }

        var response_body = std.ArrayList(u8).init(self.allocator);
        defer response_body.deinit();

        try request.reader().readAllArrayList(&response_body, max_response_size);

        return try response_body.toOwnedSlice();
    }
};

// Tests
test "Client initialization" {
    const allocator = std.testing.allocator;
    var client = Client.init(allocator, "https://example.com");
    defer client.deinit();
    
    try std.testing.expectEqualStrings("https://example.com", client.base_url);
}

test "URL construction" {
    const allocator = std.testing.allocator;
    const base_url = "https://api.example.com";
    const path = "/users/123";
    
    const url = try std.fmt.allocPrint(allocator, "{s}{s}", .{ base_url, path });
    defer allocator.free(url);
    
    try std.testing.expectEqualStrings("https://api.example.com/users/123", url);
}
