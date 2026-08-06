# servicestack-zig

Typed Zig Client Library for consuming [ServiceStack](https://servicestack.net) APIs.

- Typed Request/Response DTOs, generated from any ServiceStack API
- Response Types inferred from the Request DTO at comptime
- Structured `ResponseStatus` errors with field validation errors
- Auth with Basic Auth, API Keys, JWT Bearer Tokens and Session Cookies
- Batched Requests, one-way Requests and custom URLs
- Zero dependencies, only the Zig standard library

Requires Zig 0.15+.

## Install

```bash
zig fetch --save https://github.com/ServiceStack/servicestack-zig/archive/refs/tags/v0.1.0.tar.gz
```

Then add the module to your `build.zig`:

```zig
const servicestack = b.dependency("servicestack", .{ .target = target, .optimize = optimize });

const exe = b.addExecutable(.{
    .name = "myapp",
    .root_module = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{.{ .name = "servicestack", .module = servicestack.module("servicestack") }},
    }),
});
```

## Generate Typed DTOs

Generate the Zig DTOs of any ServiceStack API with the [get-dtos](https://www.npmjs.com/package/get-dtos) tool:

```bash
npx get-dtos zig https://blazor-vue.web-templates.io
```

Which downloads a `dtos.zig` containing the typed DTOs of the remote API:

```zig
const ss = @import("servicestack");

// @Route("/hello/{Name}")
pub const Hello = struct {
    pub const ss_name = "Hello";
    pub const ss_verb = "GET";
    pub const Response = HelloResponse;

    name: ?[]const u8 = null,
};

pub const HelloResponse = struct {
    result: ?[]const u8 = null,
    responseStatus: ?ss.ResponseStatus = null,
};
```

The generated `ss_name`, `ss_verb` and `Response` declarations are what let the
client resolve each API's route, HTTP Method and Response Type at comptime.

## Usage

```zig
const std = @import("std");
const ss = @import("servicestack");
const dtos = @import("dtos.zig");

pub fn main() !void {
    var gpa: std.heap.GeneralPurposeAllocator(.{}) = .{};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var client = try ss.JsonServiceClient.init(allocator, "https://blazor-vue.web-templates.io");
    defer client.deinit();

    var res = try client.send(dtos.Hello{ .name = "World" }); // res.value is a HelloResponse
    defer res.deinit();

    std.debug.print("{s}\n", .{res.value.result.?});
}
```

Responses are returned as a `std.json.Parsed(T)` that owns its memory — call
`deinit()` when you're done with it.

`send` uses the HTTP Method the API is annotated with, use `get`, `post`, `put`,
`patch` or `delete` to send a Request DTO with a specific HTTP Method:

```zig
var res = try client.post(dtos.Hello{ .name = "World" });
```

APIs that don't return a Response Body are sent with `sendVoid`:

```zig
try client.sendVoid(dtos.DeleteBooking{ .id = 1 });
```

### AutoQuery

AutoQuery APIs return a typed `ss.QueryResponse(T)`, with the query params of
their base type flattened into the Request DTO:

```zig
var res = try client.send(dtos.QueryBookings{ .take = 5, .orderByDesc = "id" });
defer res.deinit();

for (res.value.results.?) |booking| {
    std.debug.print("{d} {s}\n", .{ booking.id, booking.name.? });
}
```

### Error Handling

Failed API Requests return `error.WebServiceException`, with the HTTP Status Code
and structured error available from `client.getError()`:

```zig
if (client.send(dtos.CreateBooking{})) |res| {
    defer res.deinit();
} else |_| {
    const web_ex = client.getError().?;
    std.debug.print("{d} {s}: {s}\n", .{
        web_ex.status_code,        // 400
        web_ex.errorCode(),        // "NotEmpty"
        web_ex.errorMessage(),     // "'Name' must not be empty."
    });
    std.debug.print("{?s}\n", .{web_ex.fieldError("Name")});
    std.debug.print("{}\n", .{web_ex.isUnauthorized()}); // false
}
```

Alternatively `api` returns errors in its result instead of an error union:

```zig
const api = try client.api(dtos.CreateBooking{});
defer api.deinit();

if (api.failed()) {
    std.debug.print("{s} {?s}\n", .{ api.errorCode(), api.fieldError("Name") });
} else {
    std.debug.print("{s}\n", .{api.response.?.id.?});
}
```

### Authentication

API Keys and JWTs are sent in the Bearer Token Authorization header:

```zig
client.setBearerToken("ak-87949de37e894627a9f6173154e7cafa");
```

HTTP Basic Auth credentials:

```zig
client.setCredentials("username", "password");
```

Sign in with ServiceStack's Authenticate API. The client retains the Session
Cookies the Server returns (`std.http.Client` has no cookie jar of its own), so
subsequent Requests stay authenticated:

```zig
var auth = try client.authenticate("username", "password");
defer auth.deinit();
```

### Batched Requests

```zig
const requests = [_]dtos.Hello{ .{ .name = "A" }, .{ .name = "B" } };
var res = try client.sendAll(dtos.HelloResponse, requests[0..]);
defer res.deinit();
```

Or send a Request to a one-way endpoint that ignores its Response:

```zig
try client.publish(dtos.Hello{ .name = "World" });
```

### Uploading Files

Use `postFileWithRequest` to upload a file with an API Request:

```zig
var res = try client.postFileWithRequest(dtos.UploadPhoto{ .album = "Holiday" }, .{
    .field_name = "file",
    .file_name = "photo.png",
    .content_type = "image/png",
    .contents = bytes,
});
defer res.deinit();
```

The Request DTO's populated properties are sent as form fields alongside the
file. To upload multiple files use `postFilesWithRequest`.

### Transparently handle 401 Unauthorized Responses

If the Server returns a 401 Unauthorized Response either because the client was
unauthenticated or its Bearer Token or API Key had expired, use the
`on_authentication_required` callback to re-authenticate before the original
Request is automatically retried:

```zig
fn signIn(client: *ss.JsonServiceClient) anyerror!void {
    var auth = try client.authenticate("username", "password");
    auth.deinit();
}

client.on_authentication_required = signIn;

// Automatically retries Requests returning 401 Responses
var res = try client.send(dtos.Secured{});
defer res.deinit();
```

A configured Refresh Token takes precedence over the callback:

```zig
client.setRefreshToken(refresh_token);
```

### Custom URLs

```zig
var res = try client.getUrl(dtos.HelloResponse, "/hello/World");
defer res.deinit();

const csv = try client.sendUrlString(.GET, "/api/QueryBookings.csv", null);
defer allocator.free(csv);
```

### Client Configuration

```zig
try client.setHeader("X-Custom", "Value");
try client.setBasePath("");      // use the /json/reply pre-defined routes
client.cookies.clear();          // clear the Session Cookies
```

`JsonServiceClient.init` sends Requests to ServiceStack's pre-defined `/api`
route. Use `setBasePath("")` for older ServiceStack instances that only have the
`/json/reply` routes enabled.

## Examples

- [examples/hello.zig](examples/hello.zig) — typed APIs, batched Requests,
  validation errors and authentication

```bash
zig build example
```

## Tests

```bash
zig build test              # unit tests
zig build test-integration  # integration tests against test.servicestack.net
```

## License

MIT. See [LICENSE](LICENSE).
