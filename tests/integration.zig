//! Integration tests against the live https://test.servicestack.net Services:
//!
//!     zig build test-integration
//!
//! Use SERVICESTACK_TEST_URL to run them against a different ServiceStack instance.

const std = @import("std");
const servicestack = @import("servicestack");

const JsonServiceClient = servicestack.JsonServiceClient;

fn testUrl(allocator: std.mem.Allocator) ![]const u8 {
    return std.process.getEnvVarOwned(allocator, "SERVICESTACK_TEST_URL") catch
        allocator.dupe(u8, "https://test.servicestack.net");
}

// Hand-written DTOs matching the remote Services, generated DTOs have the same shape.

const HelloResponse = struct {
    result: ?[]const u8 = null,
};

const Hello = struct {
    pub const ss_name = "Hello";
    pub const ss_verb = "GET";
    pub const Response = HelloResponse;

    name: ?[]const u8 = null,
};

const ThrowValidationResponse = struct {
    age: i32 = 0,
    email: ?[]const u8 = null,
    responseStatus: ?servicestack.ResponseStatus = null,
};

const ThrowValidation = struct {
    pub const ss_name = "ThrowValidation";
    pub const ss_verb = "POST";
    pub const Response = ThrowValidationResponse;

    age: ?i32 = null,
    email: ?[]const u8 = null,
};

const ThrowTypeResponse = struct {
    responseStatus: ?servicestack.ResponseStatus = null,
};

const ThrowType = struct {
    pub const ss_name = "ThrowType";
    pub const ss_verb = "GET";
    pub const Response = ThrowTypeResponse;

    type: ?[]const u8 = null,
    message: ?[]const u8 = null,
};

const HelloSecure = struct {
    pub const ss_name = "HelloSecure";
    pub const ss_verb = "GET";
    pub const Response = HelloResponse;

    name: ?[]const u8 = null,
};

test "sends typed request" {
    const allocator = std.testing.allocator;
    const base_url = try testUrl(allocator);
    defer allocator.free(base_url);

    var client = try JsonServiceClient.init(allocator, base_url);
    defer client.deinit();

    var res = try client.send(Hello{ .name = "World" });
    defer res.deinit();

    try std.testing.expectEqualStrings("Hello, World!", res.value.result.?);
}

test "returns validation errors" {
    const allocator = std.testing.allocator;
    const base_url = try testUrl(allocator);
    defer allocator.free(base_url);

    var client = try JsonServiceClient.init(allocator, base_url);
    defer client.deinit();

    const res = client.send(ThrowValidation{});
    try std.testing.expectError(servicestack.ClientError.WebServiceException, res);

    const web_ex = client.getError().?;
    try std.testing.expectEqual(@as(u16, 400), web_ex.status_code);
    try std.testing.expect(web_ex.isValidationError());
    try std.testing.expect(std.mem.indexOf(u8, web_ex.fieldError("Age").?, "must be between 1 and 120") != null);
    try std.testing.expect(web_ex.fieldError("Email") != null);
}

test "returns error status codes" {
    const allocator = std.testing.allocator;
    const base_url = try testUrl(allocator);
    defer allocator.free(base_url);

    var client = try JsonServiceClient.init(allocator, base_url);
    defer client.deinit();

    const res = client.send(ThrowType{ .type = "NotFound", .message = "Not Here" });
    try std.testing.expectError(servicestack.ClientError.WebServiceException, res);

    const web_ex = client.getError().?;
    try std.testing.expect(web_ex.isNotFound());
    try std.testing.expectEqualStrings("NotFound", web_ex.errorCode());
    try std.testing.expectEqualStrings("Not Here", web_ex.errorMessage());
}

test "api returns error status instead of error" {
    const allocator = std.testing.allocator;
    const base_url = try testUrl(allocator);
    defer allocator.free(base_url);

    var client = try JsonServiceClient.init(allocator, base_url);
    defer client.deinit();

    const api = try client.api(HelloSecure{ .name = "World" });
    defer api.deinit();

    try std.testing.expect(api.failed());
    try std.testing.expectEqualStrings("Unauthorized", api.errorCode());
}

test "api returns typed response" {
    const allocator = std.testing.allocator;
    const base_url = try testUrl(allocator);
    defer allocator.free(base_url);

    var client = try JsonServiceClient.init(allocator, base_url);
    defer client.deinit();

    const api = try client.api(Hello{ .name = "World" });
    defer api.deinit();

    try std.testing.expect(api.succeeded());
    try std.testing.expectEqualStrings("Hello, World!", api.response.?.result.?);
}

test "authenticates then calls secure service" {
    const allocator = std.testing.allocator;
    const base_url = try testUrl(allocator);
    defer allocator.free(base_url);

    var client = try JsonServiceClient.init(allocator, base_url);
    defer client.deinit();

    var auth = try client.authenticate("test", "test");
    defer auth.deinit();
    try std.testing.expectEqualStrings("test", auth.value.userName.?);

    var res = try client.send(HelloSecure{ .name = "World" });
    defer res.deinit();
    try std.testing.expectEqualStrings("Hello, World!", res.value.result.?);
}

test "sends batched requests" {
    const allocator = std.testing.allocator;
    const base_url = try testUrl(allocator);
    defer allocator.free(base_url);

    var client = try JsonServiceClient.init(allocator, base_url);
    defer client.deinit();

    const requests = [_]Hello{ .{ .name = "A" }, .{ .name = "B" } };
    var res = try client.sendAll(HelloResponse, requests[0..]);
    defer res.deinit();

    try std.testing.expectEqual(@as(usize, 2), res.value.len);
    try std.testing.expectEqualStrings("Hello, A!", res.value[0].result.?);
    try std.testing.expectEqualStrings("Hello, B!", res.value[1].result.?);
}

test "sends request to custom route" {
    const allocator = std.testing.allocator;
    const base_url = try testUrl(allocator);
    defer allocator.free(base_url);

    var client = try JsonServiceClient.init(allocator, base_url);
    defer client.deinit();

    var res = try client.getUrl(HelloResponse, "/hello/World");
    defer res.deinit();

    try std.testing.expectEqualStrings("Hello, World!", res.value.result.?);
}
