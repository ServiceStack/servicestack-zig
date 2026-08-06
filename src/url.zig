//! URL and QueryString helpers.

const std = @import("std");

/// HTTP Methods used by ServiceStack APIs.
pub const HttpMethods = struct {
    pub const GET = "GET";
    pub const POST = "POST";
    pub const PUT = "PUT";
    pub const PATCH = "PATCH";
    pub const DELETE = "DELETE";
    pub const OPTIONS = "OPTIONS";
    pub const HEAD = "HEAD";
};

/// Whether the HTTP Method sends the Request DTO in the Request Body,
/// otherwise it's sent in the QueryString.
pub fn hasRequestBody(method: std.http.Method) bool {
    return switch (method) {
        .GET, .DELETE, .HEAD, .OPTIONS => false,
        else => true,
    };
}

/// Parses a HTTP Method name, defaulting to POST.
pub fn parseMethod(verb: []const u8) std.http.Method {
    if (std.ascii.eqlIgnoreCase(verb, "GET")) return .GET;
    if (std.ascii.eqlIgnoreCase(verb, "POST")) return .POST;
    if (std.ascii.eqlIgnoreCase(verb, "PUT")) return .PUT;
    if (std.ascii.eqlIgnoreCase(verb, "PATCH")) return .PATCH;
    if (std.ascii.eqlIgnoreCase(verb, "DELETE")) return .DELETE;
    if (std.ascii.eqlIgnoreCase(verb, "OPTIONS")) return .OPTIONS;
    if (std.ascii.eqlIgnoreCase(verb, "HEAD")) return .HEAD;
    return .POST;
}

/// Joins URL path segments with a single "/" separator, caller owns the result.
pub fn combineWith(allocator: std.mem.Allocator, base_path: []const u8, path: []const u8) ![]u8 {
    const base = std.mem.trimRight(u8, base_path, "/");
    const rel = std.mem.trim(u8, path, "/");
    if (rel.len == 0) return allocator.dupe(u8, base);
    if (base.len == 0) return allocator.dupe(u8, rel);
    return std.fmt.allocPrint(allocator, "{s}/{s}", .{ base, rel });
}

/// Converts a relative path into an absolute URL of base_url, caller owns the result.
pub fn toAbsoluteUrl(allocator: std.mem.Allocator, base_url: []const u8, path_or_url: []const u8) ![]u8 {
    if (std.mem.startsWith(u8, path_or_url, "http://") or std.mem.startsWith(u8, path_or_url, "https://")) {
        return allocator.dupe(u8, path_or_url);
    }
    return combineWith(allocator, base_url, path_or_url);
}

/// Percent-encodes a QueryString name or value.
pub fn encodeUriComponent(writer: *std.Io.Writer, value: []const u8) !void {
    for (value) |byte| {
        switch (byte) {
            'A'...'Z', 'a'...'z', '0'...'9', '-', '_', '.', '~' => try writer.writeByte(byte),
            ' ' => try writer.writeByte('+'),
            else => try writer.print("%{X:0>2}", .{byte}),
        }
    }
}

/// Writes a JSON value in its ServiceStack QueryString representation.
pub fn writeQsValue(writer: *std.Io.Writer, value: std.json.Value) !void {
    switch (value) {
        .null => {},
        .bool => |b| try encodeUriComponent(writer, if (b) "true" else "false"),
        .integer => |i| {
            var buf: [32]u8 = undefined;
            try encodeUriComponent(writer, std.fmt.bufPrint(&buf, "{d}", .{i}) catch "");
        },
        .float => |f| {
            var buf: [64]u8 = undefined;
            try encodeUriComponent(writer, std.fmt.bufPrint(&buf, "{d}", .{f}) catch "");
        },
        .number_string, .string => |s| try encodeUriComponent(writer, s),
        .array => |items| {
            try encodeUriComponent(writer, "[");
            for (items.items, 0..) |item, i| {
                if (i > 0) try encodeUriComponent(writer, ",");
                try writeQsValue(writer, item);
            }
            try encodeUriComponent(writer, "]");
        },
        .object => |map| {
            try encodeUriComponent(writer, "{");
            var it = map.iterator();
            var i: usize = 0;
            while (it.next()) |entry| : (i += 1) {
                if (i > 0) try encodeUriComponent(writer, ",");
                try encodeUriComponent(writer, entry.key_ptr.*);
                try encodeUriComponent(writer, ":");
                try writeQsValue(writer, entry.value_ptr.*);
            }
            try encodeUriComponent(writer, "}");
        },
    }
}

/// Appends the populated properties of a Request DTO to the URL's QueryString,
/// caller owns the result.
pub fn appendDtoQueryString(allocator: std.mem.Allocator, url: []const u8, request: anytype) ![]u8 {
    const json = try std.fmt.allocPrint(allocator, "{f}", .{std.json.fmt(request, .{ .emit_null_optional_fields = false })});
    defer allocator.free(json);

    var parsed = std.json.parseFromSlice(std.json.Value, allocator, json, .{}) catch {
        return allocator.dupe(u8, url);
    };
    defer parsed.deinit();

    var out: std.Io.Writer.Allocating = .init(allocator);
    errdefer out.deinit();
    const writer = &out.writer;

    try writer.writeAll(url);
    var sep: u8 = if (std.mem.indexOfScalar(u8, url, '?') != null) '&' else '?';

    if (parsed.value == .object) {
        var it = parsed.value.object.iterator();
        while (it.next()) |entry| {
            if (entry.value_ptr.* == .null) continue;
            try writer.writeByte(sep);
            sep = '&';
            try encodeUriComponent(writer, entry.key_ptr.*);
            try writer.writeByte('=');
            try writeQsValue(writer, entry.value_ptr.*);
        }
    }

    return out.toOwnedSlice();
}

test "combineWith joins url paths" {
    const allocator = std.testing.allocator;

    const a = try combineWith(allocator, "https://x.org", "api");
    defer allocator.free(a);
    try std.testing.expectEqualStrings("https://x.org/api", a);

    const b = try combineWith(allocator, "https://x.org/", "/api/");
    defer allocator.free(b);
    try std.testing.expectEqualStrings("https://x.org/api", b);

    const c = try combineWith(allocator, "https://x.org", "");
    defer allocator.free(c);
    try std.testing.expectEqualStrings("https://x.org", c);
}

test "toAbsoluteUrl keeps absolute urls" {
    const allocator = std.testing.allocator;

    const a = try toAbsoluteUrl(allocator, "https://x.org", "/api/Hello");
    defer allocator.free(a);
    try std.testing.expectEqualStrings("https://x.org/api/Hello", a);

    const b = try toAbsoluteUrl(allocator, "https://x.org", "https://y.org/api");
    defer allocator.free(b);
    try std.testing.expectEqualStrings("https://y.org/api", b);
}

test "appendDtoQueryString appends populated properties" {
    const allocator = std.testing.allocator;
    const Dto = struct {
        name: ?[]const u8 = null,
        take: ?i32 = null,
    };

    const a = try appendDtoQueryString(allocator, "/api/Hello", Dto{ .name = "A B&C" });
    defer allocator.free(a);
    try std.testing.expectEqualStrings("/api/Hello?name=A+B%26C", a);

    const b = try appendDtoQueryString(allocator, "/api/Hello", Dto{});
    defer allocator.free(b);
    try std.testing.expectEqualStrings("/api/Hello", b);

    const c = try appendDtoQueryString(allocator, "/api/Hello?a=1", Dto{ .take = 10 });
    defer allocator.free(c);
    try std.testing.expectEqualStrings("/api/Hello?a=1&take=10", c);
}

test "hasRequestBody" {
    try std.testing.expect(hasRequestBody(.POST));
    try std.testing.expect(hasRequestBody(.PUT));
    try std.testing.expect(!hasRequestBody(.GET));
    try std.testing.expect(!hasRequestBody(.DELETE));
}

test "parseMethod" {
    try std.testing.expectEqual(std.http.Method.GET, parseMethod("GET"));
    try std.testing.expectEqual(std.http.Method.PATCH, parseMethod("patch"));
    try std.testing.expectEqual(std.http.Method.POST, parseMethod("UNKNOWN"));
}
