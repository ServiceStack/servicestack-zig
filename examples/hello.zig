//! Calls the live https://test.servicestack.net Services:
//!
//!     zig build example

const std = @import("std");
const servicestack = @import("servicestack");

// DTOs of the remote API, normally generated with:
//   npx get-dtos zig https://test.servicestack.net

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
    responseStatus: ?servicestack.ResponseStatus = null,
};

const ThrowValidation = struct {
    pub const ss_name = "ThrowValidation";
    pub const ss_verb = "POST";
    pub const Response = ThrowValidationResponse;

    age: ?i32 = null,
};

const HelloSecure = struct {
    pub const ss_name = "HelloSecure";
    pub const ss_verb = "GET";
    pub const Response = HelloResponse;

    name: ?[]const u8 = null,
};

pub fn main() !void {
    var gpa: std.heap.GeneralPurposeAllocator(.{}) = .{};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var client = try servicestack.JsonServiceClient.init(allocator, "https://test.servicestack.net");
    defer client.deinit();

    // Typed API Request, res.value is a HelloResponse
    var res = try client.send(Hello{ .name = "World" });
    defer res.deinit();
    std.debug.print("send: {s}\n", .{res.value.result.?});

    // Batched Requests
    const requests = [_]Hello{ .{ .name = "A" }, .{ .name = "B" } };
    var all = try client.sendAll(HelloResponse, requests[0..]);
    defer all.deinit();
    for (all.value) |response| {
        std.debug.print("sendAll: {s}\n", .{response.result.?});
    }

    // Structured validation errors
    if (client.send(ThrowValidation{})) |ok| {
        ok.deinit();
    } else |_| {
        const web_ex = client.getError().?;
        std.debug.print("ThrowValidation: {d} {s}\n", .{ web_ex.status_code, web_ex.errorMessage() });
        if (web_ex.response_status) |status| {
            if (status.errors) |errors| {
                for (errors) |err| {
                    std.debug.print("  {s}: {s}\n", .{ err.fieldName orelse "", err.message orelse "" });
                }
            }
        }
    }

    // Authenticated Requests
    var auth = try client.authenticate("test", "test");
    defer auth.deinit();

    var secure = try client.send(HelloSecure{ .name = "World" });
    defer secure.deinit();
    std.debug.print("HelloSecure: {s}\n", .{secure.value.result.?});
}
