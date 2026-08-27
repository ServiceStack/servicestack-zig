//! Integration tests against the live https://test.servicestack.net Services:
//!
//!     zig build test-integration
//!
//! Use SERVICESTACK_TEST_URL to run them against a different ServiceStack instance.

const std = @import("std");
const servicestack = @import("servicestack");

// Typed DTOs generated from https://test.servicestack.net with:
//     npx get-dtos zig https://test.servicestack.net
const dtos = @import("dtos.zig");

const JsonServiceClient = servicestack.JsonServiceClient;

/// Model the ChatCompletion integration test uses, available on test.servicestack.net
const chat_model = "openai/gpt-oss-120b";

fn testUrl(allocator: std.mem.Allocator) ![]const u8 {
    return std.process.getEnvVarOwned(allocator, "SERVICESTACK_TEST_URL") catch
        allocator.dupe(u8, "https://test.servicestack.net");
}

/// Converts a typed DTO into the JSON Value that polymorphic properties hold
fn jsonValueOf(allocator: std.mem.Allocator, dto: anytype) !std.json.Parsed(std.json.Value) {
    const json = try std.fmt.allocPrint(allocator, "{f}", .{
        std.json.fmt(dto, .{ .emit_null_optional_fields = false }),
    });
    defer allocator.free(json);
    return std.json.parseFromSlice(std.json.Value, allocator, json, .{});
}

test "sends typed request" {
    const allocator = std.testing.allocator;
    const base_url = try testUrl(allocator);
    defer allocator.free(base_url);

    var client = try JsonServiceClient.init(allocator, base_url);
    defer client.deinit();

    var res = try client.send(dtos.Hello{ .name = "World", .title = "Mr" });
    defer res.deinit();

    try std.testing.expectEqualStrings("Hello, Mr. World!", res.value.result.?);
}

test "returns validation errors" {
    const allocator = std.testing.allocator;
    const base_url = try testUrl(allocator);
    defer allocator.free(base_url);

    var client = try JsonServiceClient.init(allocator, base_url);
    defer client.deinit();

    const res = client.send(dtos.ThrowValidation{});
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

    const res = client.send(dtos.ThrowType{ .type = "NotFound", .message = "Not Here" });
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

    const api = try client.api(dtos.HelloSecure{ .name = "World" });
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

    const api = try client.api(dtos.Hello{ .name = "World" });
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

    var res = try client.send(dtos.HelloSecure{ .name = "World" });
    defer res.deinit();
    try std.testing.expectEqualStrings("Hello, World!", res.value.result.?);
}

test "sends batched requests" {
    const allocator = std.testing.allocator;
    const base_url = try testUrl(allocator);
    defer allocator.free(base_url);

    var client = try JsonServiceClient.init(allocator, base_url);
    defer client.deinit();

    const requests = [_]dtos.Hello{ .{ .name = "A" }, .{ .name = "B" } };
    var res = try client.sendAll(dtos.HelloResponse, requests[0..]);
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

    var res = try client.getUrl(dtos.HelloResponse, "/hello/World");
    defer res.deinit();

    try std.testing.expectEqualStrings("Hello, World!", res.value.result.?);
}

// Sends a Request to ServiceStack AI Chat's OpenAI-compatible ChatCompletion API
test "sends chat completion" {
    const allocator = std.testing.allocator;
    const base_url = try testUrl(allocator);
    defer allocator.free(base_url);

    var client = try JsonServiceClient.init(allocator, base_url);
    defer client.deinit();

    // The ChatCompletion API requires an authenticated User
    var auth = try client.authenticate("test", "test");
    auth.deinit();

    // Content parts are polymorphic, e.g. text, image_url or input_audio, so they're
    // held as the JSON Value of the typed content part being sent
    var text_part = try jsonValueOf(allocator, dtos.AiTextContent{
        .type = "text",
        .text = "Capital of France? Answer in 3 words",
    });
    defer text_part.deinit();

    var content = [_]std.json.Value{text_part.value};
    var messages = [_]dtos.AiMessage{.{ .role = "user", .content = content[0..] }};

    var res = client.send(dtos.ChatCompletion{
        .model = chat_model,
        .messages = messages[0..],
    }) catch |err| {
        // A shared LLM can be rate limited or temporarily unavailable
        const web_ex = client.getError() orelse return err;
        switch (web_ex.status_code) {
            429, 502, 503, 504 => {
                std.debug.print("skipping, ChatCompletion unavailable: {d}\n", .{web_ex.status_code});
                return error.SkipZigTest;
            },
            else => return err,
        }
    };
    defer res.deinit();

    try std.testing.expect(res.value.choices.len > 0);

    const message = res.value.choices[0].message orelse return error.TestUnexpectedResult;
    try std.testing.expect(message.content != null);
    try std.testing.expect(message.content.?.len > 0);
    try std.testing.expectEqualStrings(chat_model, res.value.model.?);
}
