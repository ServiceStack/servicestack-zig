//! JsonServiceClient for consuming ServiceStack APIs.

const std = @import("std");
const types = @import("types.zig");
const url_util = @import("url.zig");

const ResponseStatus = types.ResponseStatus;

/// Errors returned by failed API Requests. Call `client.getError()` for the
/// HTTP Status Code and structured `ResponseStatus` of a `WebServiceException`.
pub const ClientError = error{
    /// The API returned an error Response
    WebServiceException,
    /// The Request DTO doesn't declare its Response Type
    ResponseTypeNotFound,
};

/// The error Response of a failed API Request.
pub const WebServiceException = struct {
    /// HTTP Status Code of the error Response
    status_code: u16 = 0,
    /// HTTP Status Description of the error Response
    status_description: []const u8 = "",
    /// Structured error returned by the API
    response_status: ?ResponseStatus = null,
    /// Raw error Response Body, useful when the Service returned a non JSON error
    response_body: []const u8 = "",

    /// The `ErrorCode` of the error, e.g. "NotFound".
    pub fn errorCode(self: WebServiceException) []const u8 {
        const status = self.response_status orelse return "";
        return status.errorCode orelse "";
    }

    /// The error message.
    pub fn errorMessage(self: WebServiceException) []const u8 {
        const status = self.response_status orelse return "";
        return status.message orelse "";
    }

    /// The validation error message for `field_name`, if it has one.
    pub fn fieldError(self: WebServiceException, field_name: []const u8) ?[]const u8 {
        const status = self.response_status orelse return null;
        return status.fieldError(field_name);
    }

    /// Whether the Request requires Authentication (401).
    pub fn isUnauthorized(self: WebServiceException) bool {
        return self.status_code == 401;
    }

    /// Whether the User was denied access to the Request (403).
    pub fn isForbidden(self: WebServiceException) bool {
        return self.status_code == 403;
    }

    /// Whether the Request returned 404 NotFound.
    pub fn isNotFound(self: WebServiceException) bool {
        return self.status_code == 404;
    }

    /// Whether the Response contains field validation errors.
    pub fn isValidationError(self: WebServiceException) bool {
        const status = self.response_status orelse return false;
        const errors = status.errors orelse return false;
        return errors.len > 0;
    }
};

/// A file uploaded in a `multipart/form-data` Request.
pub const UploadFile = struct {
    /// Field name of the file in the multipart Request, defaults to "file"
    field_name: []const u8 = "file",
    /// File name of the uploaded file
    file_name: []const u8 = "file",
    /// Content-Type of the uploaded file
    content_type: []const u8 = "application/octet-stream",
    /// Contents of the uploaded file
    contents: []const u8,
};

/// The Response Type a Request DTO returns, declared with `pub const Response`.
pub fn ResponseTypeOf(comptime T: type) type {
    if (@hasDecl(T, "Response")) return T.Response;
    @compileError("Request DTO '" ++ @typeName(T) ++ "' doesn't declare its Response Type with `pub const Response`. " ++
        "Use sendAs() to specify the Response Type explicitly.");
}

/// Retains the Session Cookies returned by the Server, e.g. ServiceStack's
/// `ss-id`/`ss-pid` Session Cookies, which `std.http.Client` doesn't do itself.
pub const CookieJar = struct {
    const Self = @This();

    allocator: std.mem.Allocator,
    cookies: std.StringArrayHashMapUnmanaged([]const u8) = .empty,

    pub fn init(allocator: std.mem.Allocator) Self {
        return .{ .allocator = allocator };
    }

    pub fn deinit(self: *Self) void {
        for (self.cookies.keys(), self.cookies.values()) |name, value| {
            self.allocator.free(name);
            self.allocator.free(value);
        }
        self.cookies.deinit(self.allocator);
    }

    /// Records the Cookie in a `Set-Cookie` header, ignoring its attributes.
    pub fn setCookie(self: *Self, set_cookie: []const u8) !void {
        const pair = std.mem.sliceTo(set_cookie, ';');
        const eq = std.mem.indexOfScalar(u8, pair, '=') orelse return;

        const name = std.mem.trim(u8, pair[0..eq], " ");
        const value = std.mem.trim(u8, pair[eq + 1 ..], " ");
        if (name.len == 0) return;

        const owned_value = try self.allocator.dupe(u8, value);
        errdefer self.allocator.free(owned_value);

        if (self.cookies.getEntry(name)) |entry| {
            self.allocator.free(entry.value_ptr.*);
            entry.value_ptr.* = owned_value;
            return;
        }

        const owned_name = try self.allocator.dupe(u8, name);
        errdefer self.allocator.free(owned_name);
        try self.cookies.put(self.allocator, owned_name, owned_value);
    }

    /// The `Cookie` request header to send, or null when no Cookies are stored.
    /// Caller owns the returned memory.
    pub fn cookieHeader(self: *Self, allocator: std.mem.Allocator) !?[]u8 {
        if (self.cookies.count() == 0) return null;

        var out: std.Io.Writer.Allocating = .init(allocator);
        errdefer out.deinit();

        for (self.cookies.keys(), self.cookies.values(), 0..) |name, value, i| {
            if (i > 0) try out.writer.writeAll("; ");
            try out.writer.print("{s}={s}", .{ name, value });
        }
        return try out.toOwnedSlice();
    }

    /// Removes all stored Cookies.
    pub fn clear(self: *Self) void {
        for (self.cookies.keys(), self.cookies.values()) |name, value| {
            self.allocator.free(name);
            self.allocator.free(value);
        }
        self.cookies.clearRetainingCapacity();
    }
};

/// The Request DTO Type of a slice, array or pointer to an array of Request DTOs.
pub fn ElementType(comptime T: type) type {
    return switch (@typeInfo(T)) {
        .array => |info| info.child,
        .pointer => |info| switch (info.size) {
            .one => ElementType(info.child),
            else => info.child,
        },
        else => @compileError("Expected a slice of Request DTOs, found '" ++ @typeName(T) ++ "'"),
    };
}

/// The Request DTO Name used in ServiceStack's pre-defined routes.
pub fn nameOf(comptime T: type) []const u8 {
    if (@hasDecl(T, "ss_name")) return T.ss_name;
    const type_name = @typeName(T);
    if (std.mem.lastIndexOfScalar(u8, type_name, '.')) |i| return type_name[i + 1 ..];
    return type_name;
}

/// The field a DTO inheriting a collection holds its collection in, declared with
/// `pub const ss_collection`. These DTOs are sent and returned as the JSON Array of
/// that field instead of a JSON Object, which is how ServiceStack serializes them.
pub fn collectionFieldOf(comptime T: type) ?[]const u8 {
    if (@typeInfo(T) != .@"struct") return null;
    if (!@hasDecl(T, "ss_collection")) return null;
    return T.ss_collection;
}

/// The HTTP Method a Request DTO should be sent with, POST when not declared.
pub fn methodOf(comptime T: type) std.http.Method {
    if (@hasDecl(T, "ss_verb")) return url_util.parseMethod(T.ss_verb);
    return .POST;
}

/// Either the typed Response of a successful API Request or the structured
/// error of a failed one, returned by `api()`.
pub fn ApiResult(comptime T: type) type {
    return struct {
        const Self = @This();

        /// Owns the memory of `response` and `error`
        arena: *std.heap.ArenaAllocator,
        /// The typed Response of a successful API Request
        response: ?T = null,
        /// The structured error of a failed API Request
        @"error": ?ResponseStatus = null,

        /// Releases the memory of the Response and error.
        pub fn deinit(self: Self) void {
            const allocator = self.arena.child_allocator;
            self.arena.deinit();
            allocator.destroy(self.arena);
        }

        /// Whether the API Request succeeded.
        pub fn succeeded(self: Self) bool {
            return self.@"error" == null;
        }

        /// Whether the API Request failed.
        pub fn failed(self: Self) bool {
            return self.@"error" != null;
        }

        /// The `ErrorCode` of a failed API Request.
        pub fn errorCode(self: Self) []const u8 {
            const err = self.@"error" orelse return "";
            return err.errorCode orelse "";
        }

        /// The error message of a failed API Request.
        pub fn errorMessage(self: Self) []const u8 {
            const err = self.@"error" orelse return "";
            return err.message orelse "";
        }

        /// The validation error message for `field_name`, if it has one.
        pub fn fieldError(self: Self, field_name: []const u8) ?[]const u8 {
            const err = self.@"error" orelse return null;
            return err.fieldError(field_name);
        }
    };
}

/// Client for consuming ServiceStack APIs with generated typed DTOs.
///
/// ```
/// var client = try JsonServiceClient.init(allocator, "https://example.org");
/// defer client.deinit();
///
/// var res = try client.send(dtos.Hello{ .name = "World" });
/// defer res.deinit();
/// std.debug.print("{s}\n", .{res.value.result.?});
/// ```
pub const JsonServiceClient = struct {
    const Self = @This();

    allocator: std.mem.Allocator,
    /// Base URL of the remote ServiceStack instance
    base_url: []const u8,
    /// Base URL Request DTOs are sent to, e.g. https://example.org/api
    reply_base_url: []const u8,
    /// Base URL one-way Requests are sent to
    oneway_base_url: []const u8,
    /// JWT or API Key sent in the Bearer Authorization header
    bearer_token: ?[]const u8 = null,
    /// UserName sent in the HTTP Basic Auth header
    user_name: ?[]const u8 = null,
    /// Password sent in the HTTP Basic Auth header
    password: ?[]const u8 = null,
    /// Additional Headers sent with each Request
    headers: std.ArrayList(std.http.Header),
    /// Refresh Token used to fetch a new Bearer Token when a Request returns 401
    refresh_token: ?[]const u8 = null,
    /// URL used to fetch a new Access Token, defaults to this client's GetAccessToken API
    refresh_token_uri: ?[]const u8 = null,
    /// Invoked when a Request returns 401 Unauthorized, letting the client
    /// re-authenticate before the Request is retried once
    on_authentication_required: ?*const fn (client: *Self) anyerror!void = null,
    /// Details of the last failed Request
    last_error: ?WebServiceException = null,
    /// Session Cookies returned by the Server, sent with each Request
    cookies: CookieJar,

    http_client: std.http.Client,
    error_arena: std.heap.ArenaAllocator,
    /// Bearer Token owned by the client, e.g. one fetched from a Refresh Token
    owned_bearer_token: ?[]u8 = null,

    /// Creates a client that sends Requests to ServiceStack's pre-defined /api route.
    pub fn init(allocator: std.mem.Allocator, base_url: []const u8) !Self {
        var self = Self{
            .allocator = allocator,
            .base_url = try allocator.dupe(u8, std.mem.trimRight(u8, base_url, "/")),
            .reply_base_url = "",
            .oneway_base_url = "",
            .headers = .empty,
            .cookies = CookieJar.init(allocator),
            .http_client = .{ .allocator = allocator },
            .error_arena = std.heap.ArenaAllocator.init(allocator),
        };
        try self.setBasePath("api");
        return self;
    }

    /// Releases the memory owned by the client.
    pub fn deinit(self: *Self) void {
        if (self.owned_bearer_token) |token| self.allocator.free(token);
        self.allocator.free(self.base_url);
        if (self.reply_base_url.len > 0) self.allocator.free(self.reply_base_url);
        if (self.oneway_base_url.len > 0) self.allocator.free(self.oneway_base_url);
        self.headers.deinit(self.allocator);
        self.cookies.deinit();
        self.error_arena.deinit();
        self.http_client.deinit();
    }

    /// Changes the base path Request DTOs are sent to, e.g. "api".
    /// Use an empty `base_path` for the /json/reply pre-defined routes.
    pub fn setBasePath(self: *Self, base_path: []const u8) !void {
        if (self.reply_base_url.len > 0) self.allocator.free(self.reply_base_url);
        if (self.oneway_base_url.len > 0) self.allocator.free(self.oneway_base_url);

        if (base_path.len == 0) {
            self.reply_base_url = try url_util.combineWith(self.allocator, self.base_url, "json/reply");
            self.oneway_base_url = try url_util.combineWith(self.allocator, self.base_url, "json/oneway");
        } else {
            self.reply_base_url = try url_util.combineWith(self.allocator, self.base_url, base_path);
            self.oneway_base_url = try url_util.combineWith(self.allocator, self.base_url, base_path);
        }
    }

    /// Sets the JWT or API Key sent in the Bearer Authorization header.
    pub fn setBearerToken(self: *Self, token: []const u8) void {
        self.bearer_token = token;
    }

    /// Sets a Bearer Token the client copies and owns, used for Tokens with a
    /// shorter lifetime than their source, e.g. one fetched from a Refresh Token.
    pub fn setOwnedBearerToken(self: *Self, token: []const u8) !void {
        const owned = try self.allocator.dupe(u8, token);
        if (self.owned_bearer_token) |previous| self.allocator.free(previous);
        self.owned_bearer_token = owned;
        self.bearer_token = owned;
    }

    /// Sets the Refresh Token used to fetch a new Bearer Token when a Request
    /// returns 401 Unauthorized.
    pub fn setRefreshToken(self: *Self, token: []const u8) void {
        self.refresh_token = token;
    }

    /// Sets the UserName and Password sent in the HTTP Basic Auth header.
    pub fn setCredentials(self: *Self, user_name: []const u8, password: []const u8) void {
        self.user_name = user_name;
        self.password = password;
    }

    /// Adds a HTTP Header sent with each Request.
    pub fn setHeader(self: *Self, name: []const u8, value: []const u8) !void {
        for (self.headers.items) |*header| {
            if (std.ascii.eqlIgnoreCase(header.name, name)) {
                header.value = value;
                return;
            }
        }
        try self.headers.append(self.allocator, .{ .name = name, .value = value });
    }

    /// Details of the last failed Request, valid until the next Request is sent.
    pub fn getError(self: *Self) ?WebServiceException {
        return self.last_error;
    }

    // ── Typed API ──

    /// Sends a Request DTO with the HTTP Method it's annotated with, returning
    /// its typed Response. Caller owns the returned `std.json.Parsed`.
    pub fn send(self: *Self, request: anytype) !std.json.Parsed(ResponseTypeOf(@TypeOf(request))) {
        return self.sendMethod(ResponseTypeOf(@TypeOf(request)), methodOf(@TypeOf(request)), request);
    }

    /// Sends a Request DTO with a GET Request.
    pub fn get(self: *Self, request: anytype) !std.json.Parsed(ResponseTypeOf(@TypeOf(request))) {
        return self.sendMethod(ResponseTypeOf(@TypeOf(request)), .GET, request);
    }

    /// Sends a Request DTO with a POST Request.
    pub fn post(self: *Self, request: anytype) !std.json.Parsed(ResponseTypeOf(@TypeOf(request))) {
        return self.sendMethod(ResponseTypeOf(@TypeOf(request)), .POST, request);
    }

    /// Sends a Request DTO with a PUT Request.
    pub fn put(self: *Self, request: anytype) !std.json.Parsed(ResponseTypeOf(@TypeOf(request))) {
        return self.sendMethod(ResponseTypeOf(@TypeOf(request)), .PUT, request);
    }

    /// Sends a Request DTO with a PATCH Request.
    pub fn patch(self: *Self, request: anytype) !std.json.Parsed(ResponseTypeOf(@TypeOf(request))) {
        return self.sendMethod(ResponseTypeOf(@TypeOf(request)), .PATCH, request);
    }

    /// Sends a Request DTO with a DELETE Request.
    pub fn delete(self: *Self, request: anytype) !std.json.Parsed(ResponseTypeOf(@TypeOf(request))) {
        return self.sendMethod(ResponseTypeOf(@TypeOf(request)), .DELETE, request);
    }

    /// Sends a Request DTO that doesn't return a Response Body.
    pub fn sendVoid(self: *Self, request: anytype) !void {
        const T = @TypeOf(request);
        const body = try self.sendDto(methodOf(T), nameOf(T), request);
        self.allocator.free(body);
    }

    /// Sends a Request DTO that doesn't declare its Response Type, requiring the
    /// Response Type to be specified explicitly.
    pub fn sendAs(self: *Self, comptime ResponseType: type, request: anytype) !std.json.Parsed(ResponseType) {
        return self.sendMethod(ResponseType, methodOf(@TypeOf(request)), request);
    }

    /// Sends a Request DTO with the specified HTTP Method and Response Type.
    pub fn sendMethod(
        self: *Self,
        comptime ResponseType: type,
        method: std.http.Method,
        request: anytype,
    ) !std.json.Parsed(ResponseType) {
        const body = try self.sendDto(method, nameOf(@TypeOf(request)), request);
        defer self.allocator.free(body);
        return self.parseResponse(ResponseType, body);
    }

    /// Sends a Request DTO, returning either its typed Response or the structured
    /// error of a failed Request. Caller owns the returned `ApiResult`.
    pub fn api(self: *Self, request: anytype) !ApiResult(ResponseTypeOf(@TypeOf(request))) {
        const ResponseType = ResponseTypeOf(@TypeOf(request));
        const Result = ApiResult(ResponseType);

        const arena = try self.allocator.create(std.heap.ArenaAllocator);
        arena.* = std.heap.ArenaAllocator.init(self.allocator);
        errdefer {
            arena.deinit();
            self.allocator.destroy(arena);
        }

        const body = self.sendDto(methodOf(@TypeOf(request)), nameOf(@TypeOf(request)), request) catch |err| {
            if (err != ClientError.WebServiceException) return err;
            const web_ex = self.last_error orelse WebServiceException{};
            const status = web_ex.response_status orelse ResponseStatus{
                .errorCode = try arena.allocator().dupe(u8, web_ex.status_description),
                .message = try arena.allocator().dupe(u8, web_ex.status_description),
            };
            return Result{
                .arena = arena,
                .@"error" = try cloneResponseStatus(arena.allocator(), status),
            };
        };
        defer self.allocator.free(body);

        const value = try parseJson(ResponseType, arena.allocator(), body);
        return Result{ .arena = arena, .response = value };
    }

    /// Sends multiple Request DTOs of the same Type in a single Request.
    pub fn sendAll(
        self: *Self,
        comptime ResponseType: type,
        requests: anytype,
    ) !std.json.Parsed([]const ResponseType) {
        const T = ElementType(@TypeOf(requests));
        const batch_name = try std.fmt.allocPrint(self.allocator, "{s}[]", .{nameOf(T)});
        defer self.allocator.free(batch_name);

        const url = try url_util.combineWith(self.allocator, self.reply_base_url, batch_name);
        defer self.allocator.free(url);

        const body = try self.sendUrlRequest(.POST, url, requests, true);
        defer self.allocator.free(body);
        return self.parseResponse([]const ResponseType, body);
    }

    /// Sends a Request DTO to a one-way endpoint, ignoring any Response.
    pub fn publish(self: *Self, request: anytype) !void {
        const url = try url_util.combineWith(self.allocator, self.oneway_base_url, nameOf(@TypeOf(request)));
        defer self.allocator.free(url);

        const body = try self.sendUrlRequest(.POST, url, request, true);
        self.allocator.free(body);
    }

    /// Signs in with UserName and Password credentials, using the Bearer Token
    /// the Server returns for subsequent Requests.
    pub fn authenticate(self: *Self, user_name: []const u8, password: []const u8) !std.json.Parsed(types.AuthenticateResponse) {
        const res = try self.send(types.Authenticate{
            .provider = "credentials",
            .userName = user_name,
            .password = password,
        });
        errdefer res.deinit();

        if (res.value.bearerToken) |token| {
            if (token.len > 0) {
                // The Parsed arena owns the token, copy it into memory the client owns
                try self.setOwnedBearerToken(token);
            }
        }
        return res;
    }

    // ── File Uploads ──

    /// Uploads a file with a Request DTO as a `multipart/form-data` Request,
    /// returning its typed Response, e.g:
    ///
    /// ```
    /// var res = try client.postFileWithRequest(dtos.UploadPhoto{ .album = "Holiday" }, .{
    ///     .field_name = "file",
    ///     .file_name = "photo.png",
    ///     .content_type = "image/png",
    ///     .contents = bytes,
    /// });
    /// defer res.deinit();
    /// ```
    pub fn postFileWithRequest(
        self: *Self,
        request: anytype,
        file: UploadFile,
    ) !std.json.Parsed(ResponseTypeOf(@TypeOf(request))) {
        const files = [_]UploadFile{file};
        return self.postFilesWithRequest(request, files[0..]);
    }

    /// Uploads multiple files with a Request DTO as a `multipart/form-data` Request.
    pub fn postFilesWithRequest(
        self: *Self,
        request: anytype,
        files: []const UploadFile,
    ) !std.json.Parsed(ResponseTypeOf(@TypeOf(request))) {
        const url = try url_util.combineWith(self.allocator, self.reply_base_url, nameOf(@TypeOf(request)));
        defer self.allocator.free(url);

        const body = try self.postFilesWithRequestUrl(url, request, files);
        defer self.allocator.free(body);

        return self.parseResponse(ResponseTypeOf(@TypeOf(request)), body);
    }

    /// Uploads files with a Request DTO to a custom URL, returning the raw
    /// Response Body. Caller owns the returned memory.
    pub fn postFilesWithRequestUrl(
        self: *Self,
        path: []const u8,
        request: anytype,
        files: []const UploadFile,
    ) ![]u8 {
        var boundary_bytes: [16]u8 = undefined;
        std.crypto.random.bytes(&boundary_bytes);

        var hex: [boundary_bytes.len * 2]u8 = undefined;
        const hex_chars = "0123456789abcdef";
        for (boundary_bytes, 0..) |byte, i| {
            hex[i * 2] = hex_chars[byte >> 4];
            hex[i * 2 + 1] = hex_chars[byte & 0x0F];
        }

        const boundary = try std.fmt.allocPrint(self.allocator, "----ServiceStackFormBoundary{s}", .{hex});
        defer self.allocator.free(boundary);

        const body = try self.multipartBody(boundary, request, files);
        defer self.allocator.free(body);

        const content_type = try std.fmt.allocPrint(self.allocator, "multipart/form-data; boundary={s}", .{boundary});
        defer self.allocator.free(content_type);

        return self.sendRequest(.POST, path, body, content_type, true);
    }

    // ── URL API ──

    /// Sends a GET Request to a custom relative path or absolute URL.
    pub fn getUrl(self: *Self, comptime ResponseType: type, path: []const u8) !std.json.Parsed(ResponseType) {
        const body = try self.sendUrlRequest(.GET, path, null, true);
        defer self.allocator.free(body);
        return self.parseResponse(ResponseType, body);
    }

    /// Sends a POST Request to a custom relative path or absolute URL.
    pub fn postUrl(self: *Self, comptime ResponseType: type, path: []const u8, request: anytype) !std.json.Parsed(ResponseType) {
        const body = try self.sendUrlRequest(.POST, path, request, true);
        defer self.allocator.free(body);
        return self.parseResponse(ResponseType, body);
    }

    /// Sends a Request to a custom relative path or absolute URL, returning its
    /// raw Response Body. Caller owns the returned memory.
    pub fn sendUrlString(self: *Self, method: std.http.Method, path: []const u8, request: anytype) ![]u8 {
        return self.sendUrlRequest(method, path, request, true);
    }

    // ── Internals ──

    fn sendDto(self: *Self, method: std.http.Method, dto_name: []const u8, request: anytype) ![]u8 {
        const dto_url = try url_util.combineWith(self.allocator, self.reply_base_url, dto_name);
        defer self.allocator.free(dto_url);

        if (url_util.hasRequestBody(method)) {
            return self.sendUrlRequest(method, dto_url, request, true);
        }

        const url = try url_util.appendDtoQueryString(self.allocator, dto_url, request);
        defer self.allocator.free(url);
        return self.sendUrlRequest(method, url, null, true);
    }

    fn parseResponse(self: *Self, comptime ResponseType: type, body: []const u8) !std.json.Parsed(ResponseType) {
        const arena = try self.allocator.create(std.heap.ArenaAllocator);
        arena.* = std.heap.ArenaAllocator.init(self.allocator);
        errdefer {
            arena.deinit();
            self.allocator.destroy(arena);
        }

        const value = try parseJson(ResponseType, arena.allocator(), body);
        return std.json.Parsed(ResponseType){ .arena = arena, .value = value };
    }

    /// Serializes a Request DTO as JSON and sends it, returning the Response Body.
    /// Caller owns the memory.
    fn sendUrlRequest(
        self: *Self,
        method: std.http.Method,
        path: []const u8,
        request: anytype,
        retry_on_auth_failure: bool,
    ) ![]u8 {
        var payload: ?[]u8 = null;
        defer if (payload) |p| self.allocator.free(p);

        if (@TypeOf(request) != @TypeOf(null) and url_util.hasRequestBody(method)) {
            // DTOs inheriting a collection are sent as their collection's JSON Array
            if (comptime collectionFieldOf(@TypeOf(request))) |field| {
                payload = try std.fmt.allocPrint(self.allocator, "{f}", .{
                    std.json.fmt(@field(request, field), .{ .emit_null_optional_fields = false }),
                });
            } else {
                payload = try std.fmt.allocPrint(self.allocator, "{f}", .{
                    std.json.fmt(request, .{ .emit_null_optional_fields = false }),
                });
            }
        }

        return self.sendRequest(method, path, payload, if (payload != null) "application/json" else null, retry_on_auth_failure);
    }

    /// Sends the HTTP Request, returning the Response Body. Caller owns the memory.
    fn sendRequest(
        self: *Self,
        method: std.http.Method,
        path: []const u8,
        body: ?[]const u8,
        content_type: ?[]const u8,
        retry_on_auth_failure: bool,
    ) ![]u8 {
        const url = try url_util.toAbsoluteUrl(self.allocator, self.base_url, path);
        defer self.allocator.free(url);

        const uri = try std.Uri.parse(url);

        var headers: std.ArrayList(std.http.Header) = .empty;
        defer headers.deinit(self.allocator);

        try headers.append(self.allocator, .{ .name = "Accept", .value = "application/json" });

        var auth_header: ?[]u8 = null;
        defer if (auth_header) |h| self.allocator.free(h);

        if (self.bearer_token) |token| {
            auth_header = try std.fmt.allocPrint(self.allocator, "Bearer {s}", .{token});
            try headers.append(self.allocator, .{ .name = "Authorization", .value = auth_header.? });
        } else if (self.user_name != null or self.password != null) {
            const credentials = try std.fmt.allocPrint(self.allocator, "{s}:{s}", .{
                self.user_name orelse "",
                self.password orelse "",
            });
            defer self.allocator.free(credentials);

            const encoder = std.base64.standard.Encoder;
            const encoded = try self.allocator.alloc(u8, encoder.calcSize(credentials.len));
            defer self.allocator.free(encoded);
            _ = encoder.encode(encoded, credentials);

            auth_header = try std.fmt.allocPrint(self.allocator, "Basic {s}", .{encoded});
            try headers.append(self.allocator, .{ .name = "Authorization", .value = auth_header.? });
        }

        const cookie_header = try self.cookies.cookieHeader(self.allocator);
        defer if (cookie_header) |h| self.allocator.free(h);
        if (cookie_header) |h| {
            try headers.append(self.allocator, .{ .name = "Cookie", .value = h });
        }

        for (self.headers.items) |header| {
            try headers.append(self.allocator, header);
        }

        if (content_type) |ct| {
            try headers.append(self.allocator, .{ .name = "Content-Type", .value = ct });
        }

        var req = try self.http_client.request(method, uri, .{ .extra_headers = headers.items });
        defer req.deinit();

        if (body) |p| {
            req.transfer_encoding = .{ .content_length = p.len };
            var body_writer = try req.sendBodyUnflushed(&.{});
            try body_writer.writer.writeAll(p);
            try body_writer.end();
            try req.connection.?.flush();
        } else {
            try req.sendBodiless();
        }

        var redirect_buf: [8192]u8 = undefined;
        var res = try req.receiveHead(&redirect_buf);

        var header_it = res.head.iterateHeaders();
        while (header_it.next()) |header| {
            if (std.ascii.eqlIgnoreCase(header.name, "set-cookie")) {
                try self.cookies.setCookie(header.value);
            }
        }

        var read_buf: [4096]u8 = undefined;
        var reader = res.reader(&read_buf);
        const response_body = try reader.allocRemaining(self.allocator, .unlimited);
        errdefer self.allocator.free(response_body);

        const status_code = @intFromEnum(res.head.status);

        if (status_code == 401 and retry_on_auth_failure) {
            if (self.onAuthenticationRequired()) |_| {
                self.allocator.free(response_body);
                return self.sendRequest(method, path, body, content_type, false);
            } else |_| {}
        }

        if (status_code >= 400) {
            // response_body is released by the errdefer above
            try self.captureError(status_code, res.head.status.phrase() orelse "", response_body);
            return ClientError.WebServiceException;
        }

        return response_body;
    }

    /// Builds the `multipart/form-data` body of a file upload Request, sending the
    /// populated Request DTO properties as form fields. Caller owns the memory.
    fn multipartBody(self: *Self, boundary: []const u8, request: anytype, files: []const UploadFile) ![]u8 {
        var out: std.Io.Writer.Allocating = .init(self.allocator);
        errdefer out.deinit();
        const writer = &out.writer;

        // Request DTO properties are sent as form fields
        const json = try std.fmt.allocPrint(self.allocator, "{f}", .{
            std.json.fmt(request, .{ .emit_null_optional_fields = false }),
        });
        defer self.allocator.free(json);

        var parsed = try std.json.parseFromSlice(std.json.Value, self.allocator, json, .{});
        defer parsed.deinit();

        if (parsed.value == .object) {
            var it = parsed.value.object.iterator();
            while (it.next()) |entry| {
                if (entry.value_ptr.* == .null) continue;

                try writer.print("--{s}\r\n", .{boundary});
                try writer.print("Content-Disposition: form-data; name=\"{s}\"\r\n\r\n", .{entry.key_ptr.*});
                switch (entry.value_ptr.*) {
                    .string => |str| try writer.writeAll(str),
                    else => try writer.print("{f}", .{std.json.fmt(entry.value_ptr.*, .{})}),
                }
                try writer.writeAll("\r\n");
            }
        }

        for (files) |file| {
            try writer.print("--{s}\r\n", .{boundary});
            try writer.print("Content-Disposition: form-data; name=\"{s}\"; filename=\"{s}\"\r\n", .{
                file.field_name, file.file_name,
            });
            try writer.print("Content-Type: {s}\r\n\r\n", .{file.content_type});
            try writer.writeAll(file.contents);
            try writer.writeAll("\r\n");
        }

        try writer.print("--{s}--\r\n", .{boundary});
        return out.toOwnedSlice();
    }

    /// Re-authenticates the client after a Request returned 401 Unauthorized,
    /// using the Refresh Token when configured, otherwise the
    /// `on_authentication_required` callback.
    fn onAuthenticationRequired(self: *Self) !void {
        if (self.refresh_token != null) {
            return self.refreshAccessToken();
        }

        const callback = self.on_authentication_required orelse return ClientError.WebServiceException;
        return callback(self);
    }

    /// Exchanges the Refresh Token for a new Bearer Token.
    fn refreshAccessToken(self: *Self) !void {
        const refresh_token = self.refresh_token orelse return ClientError.WebServiceException;

        const url = if (self.refresh_token_uri) |uri|
            try self.allocator.dupe(u8, uri)
        else
            try url_util.combineWith(self.allocator, self.reply_base_url, "GetAccessToken");
        defer self.allocator.free(url);

        const body = try self.sendUrlRequest(.POST, url, types.GetAccessToken{
            .refreshToken = refresh_token,
        }, false);
        defer self.allocator.free(body);

        var arena = std.heap.ArenaAllocator.init(self.allocator);
        defer arena.deinit();

        const res = try parseJson(types.GetAccessTokenResponse, arena.allocator(), body);
        const access_token = res.accessToken orelse return ClientError.WebServiceException;
        if (access_token.len == 0) return ClientError.WebServiceException;

        // The parse arena owns the token, copy it into memory the client owns
        try self.setOwnedBearerToken(access_token);
    }

    /// Records the details of a failed Request in `last_error`.
    fn captureError(self: *Self, status_code: u16, status_description: []const u8, body: []const u8) !void {
        _ = self.error_arena.reset(.retain_capacity);

        const allocator = self.error_arena.allocator();
        var web_ex = WebServiceException{
            .status_code = status_code,
            .status_description = try allocator.dupe(u8, status_description),
            .response_body = try allocator.dupe(u8, body),
        };

        const options = std.json.ParseOptions{
            .ignore_unknown_fields = true,
            .allocate = .alloc_always,
        };
        const ErrorResponse = struct { responseStatus: ?ResponseStatus = null };
        if (std.json.parseFromSliceLeaky(ErrorResponse, allocator, body, options)) |error_response| {
            web_ex.response_status = error_response.responseStatus;
        } else |_| {
            // Fallback for Services that return a bare ResponseStatus
            if (std.json.parseFromSliceLeaky(ResponseStatus, allocator, body, options)) |status| {
                if (status.errorCode != null or status.message != null) {
                    web_ex.response_status = status;
                }
            } else |_| {}
        }

        self.last_error = web_ex;
    }
};

/// Parses a Response Body, treating an empty Body as an empty Response.
fn parseJson(comptime T: type, allocator: std.mem.Allocator, body: []const u8) !T {
    // alloc_always copies strings into the arena, the Response Body is freed by the caller
    const options = std.json.ParseOptions{
        .ignore_unknown_fields = true,
        .allocate = .alloc_always,
    };
    const json = std.mem.trim(u8, body, " \t\r\n");

    // DTOs inheriting a collection are returned as their collection's JSON Array
    if (comptime collectionFieldOf(T)) |field| {
        var value: T = .{};
        @field(value, field) = try std.json.parseFromSliceLeaky(
            @FieldType(T, field),
            allocator,
            if (json.len == 0) "[]" else json,
            options,
        );
        return value;
    }

    if (json.len == 0) {
        return std.json.parseFromSliceLeaky(T, allocator, "{}", options);
    }
    return std.json.parseFromSliceLeaky(T, allocator, json, options);
}

fn cloneResponseStatus(allocator: std.mem.Allocator, status: ResponseStatus) !ResponseStatus {
    var to = ResponseStatus{
        .errorCode = if (status.errorCode) |x| try allocator.dupe(u8, x) else null,
        .message = if (status.message) |x| try allocator.dupe(u8, x) else null,
        .stackTrace = if (status.stackTrace) |x| try allocator.dupe(u8, x) else null,
    };
    if (status.errors) |errors| {
        const to_errors = try allocator.alloc(types.ResponseError, errors.len);
        for (errors, 0..) |err, i| {
            to_errors[i] = .{
                .errorCode = if (err.errorCode) |x| try allocator.dupe(u8, x) else null,
                .fieldName = if (err.fieldName) |x| try allocator.dupe(u8, x) else null,
                .message = if (err.message) |x| try allocator.dupe(u8, x) else null,
            };
        }
        to.errors = to_errors;
    }
    return to;
}

test "nameOf uses the declared DTO name" {
    const Hello = struct {
        pub const ss_name = "Hello";
        name: ?[]const u8 = null,
    };
    try std.testing.expectEqualStrings("Hello", nameOf(Hello));
}

test "methodOf uses the declared Verb, defaulting to POST" {
    const Hello = struct {
        pub const ss_verb = "GET";
    };
    const CreateHello = struct {};
    try std.testing.expectEqual(std.http.Method.GET, methodOf(Hello));
    try std.testing.expectEqual(std.http.Method.POST, methodOf(CreateHello));
}

test "collectionFieldOf resolves the field of DTOs inheriting a collection" {
    const Contact = struct { id: i32 = 0 };
    const StoreContacts = struct {
        pub const ss_collection = "items";
        items: []const Contact = &.{},
    };
    const Hello = struct { name: ?[]const u8 = null };

    try std.testing.expectEqualStrings("items", collectionFieldOf(StoreContacts).?);
    try std.testing.expectEqual(@as(?[]const u8, null), collectionFieldOf(Hello));
    try std.testing.expectEqual(@as(?[]const u8, null), collectionFieldOf([]const u8));
}

test "DTOs inheriting a collection are sent and parsed as a JSON Array" {
    const allocator = std.testing.allocator;

    const Contact = struct { id: i32 = 0, firstName: ?[]const u8 = null };
    const StoreContacts = struct {
        pub const ss_name = "StoreContacts";
        pub const ss_verb = "POST";
        pub const ss_collection = "items";
        items: []const Contact = &.{},
    };

    // Sent as the JSON Array of its collection, not a JSON Object
    const request = StoreContacts{ .items = &.{.{ .id = 1, .firstName = "A" }} };
    const json = try std.fmt.allocPrint(allocator, "{f}", .{
        std.json.fmt(@field(request, StoreContacts.ss_collection), .{ .emit_null_optional_fields = false }),
    });
    defer allocator.free(json);
    try std.testing.expectEqualStrings("[{\"id\":1,\"firstName\":\"A\"}]", json);

    // And populated from the JSON Array the API returns
    var arena = std.heap.ArenaAllocator.init(allocator);
    defer arena.deinit();

    const parsed = try parseJson(StoreContacts, arena.allocator(), json);
    try std.testing.expectEqual(@as(usize, 1), parsed.items.len);
    try std.testing.expectEqual(@as(i32, 1), parsed.items[0].id);
    try std.testing.expectEqualStrings("A", parsed.items[0].firstName.?);

    // An empty Body is an empty collection
    const empty = try parseJson(StoreContacts, arena.allocator(), "");
    try std.testing.expectEqual(@as(usize, 0), empty.items.len);
}

test "ResponseTypeOf resolves the declared Response Type" {
    const HelloResponse = struct { result: ?[]const u8 = null };
    const Hello = struct {
        pub const Response = HelloResponse;
    };
    try std.testing.expectEqual(HelloResponse, ResponseTypeOf(Hello));
}

test "CookieJar retains Session Cookies" {
    const allocator = std.testing.allocator;
    var jar = CookieJar.init(allocator);
    defer jar.deinit();

    try std.testing.expect(try jar.cookieHeader(allocator) == null);

    try jar.setCookie("ss-id=SESSION_ID; path=/; samesite=strict; httponly");
    try jar.setCookie("ss-pid=PERM_ID; path=/; httponly");

    const header = (try jar.cookieHeader(allocator)).?;
    defer allocator.free(header);
    try std.testing.expectEqualStrings("ss-id=SESSION_ID; ss-pid=PERM_ID", header);

    // A Cookie of the same name replaces the previous value
    try jar.setCookie("ss-id=NEW_SESSION; path=/");
    const updated = (try jar.cookieHeader(allocator)).?;
    defer allocator.free(updated);
    try std.testing.expectEqualStrings("ss-id=NEW_SESSION; ss-pid=PERM_ID", updated);

    jar.clear();
    try std.testing.expect(try jar.cookieHeader(allocator) == null);
}

test "CookieJar ignores malformed Set-Cookie headers" {
    const allocator = std.testing.allocator;
    var jar = CookieJar.init(allocator);
    defer jar.deinit();

    try jar.setCookie("no-equals-sign");
    try jar.setCookie("=missing-name");
    try std.testing.expect(try jar.cookieHeader(allocator) == null);
}

test "multipartBody sends Request DTO properties as form fields with files" {
    const allocator = std.testing.allocator;
    var client = try JsonServiceClient.init(allocator, "https://example.org");
    defer client.deinit();

    const UploadPhoto = struct {
        album: ?[]const u8 = null,
        notes: ?[]const u8 = null,
    };

    const files = [_]UploadFile{.{
        .field_name = "file",
        .file_name = "photo.png",
        .content_type = "image/png",
        .contents = "PNG-CONTENTS",
    }};

    const body = try client.multipartBody("BOUNDARY", UploadPhoto{ .album = "Holiday" }, files[0..]);
    defer allocator.free(body);

    // Populated properties are sent as form fields, empty ones are omitted
    try std.testing.expect(std.mem.indexOf(u8, body, "Content-Disposition: form-data; name=\"album\"\r\n\r\nHoliday") != null);
    try std.testing.expect(std.mem.indexOf(u8, body, "name=\"notes\"") == null);

    // Files are sent with their filename and Content-Type
    try std.testing.expect(std.mem.indexOf(u8, body, "name=\"file\"; filename=\"photo.png\"") != null);
    try std.testing.expect(std.mem.indexOf(u8, body, "Content-Type: image/png") != null);
    try std.testing.expect(std.mem.indexOf(u8, body, "PNG-CONTENTS") != null);

    try std.testing.expect(std.mem.startsWith(u8, body, "--BOUNDARY\r\n"));
    try std.testing.expect(std.mem.endsWith(u8, body, "--BOUNDARY--\r\n"));
}

test "multipartBody supports multiple files" {
    const allocator = std.testing.allocator;
    var client = try JsonServiceClient.init(allocator, "https://example.org");
    defer client.deinit();

    const files = [_]UploadFile{
        .{ .field_name = "file1", .file_name = "a.txt", .contents = "AAA" },
        .{ .field_name = "file2", .file_name = "b.txt", .contents = "BBB" },
    };

    const body = try client.multipartBody("BOUNDARY", .{}, files[0..]);
    defer allocator.free(body);

    try std.testing.expect(std.mem.indexOf(u8, body, "filename=\"a.txt\"") != null);
    try std.testing.expect(std.mem.indexOf(u8, body, "filename=\"b.txt\"") != null);
    // Files default to application/octet-stream
    try std.testing.expect(std.mem.indexOf(u8, body, "Content-Type: application/octet-stream") != null);
}
