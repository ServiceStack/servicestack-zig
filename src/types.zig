//! Built-in ServiceStack DTOs referenced by generated DTOs.

const std = @import("std");

/// A field validation error within a `ResponseStatus`.
pub const ResponseError = struct {
    errorCode: ?[]const u8 = null,
    fieldName: ?[]const u8 = null,
    message: ?[]const u8 = null,
};

/// ServiceStack's structured error, returned in the `responseStatus` property
/// of failed API Responses.
pub const ResponseStatus = struct {
    errorCode: ?[]const u8 = null,
    message: ?[]const u8 = null,
    stackTrace: ?[]const u8 = null,
    errors: ?[]const ResponseError = null,

    /// The validation error message for `name`, matched case-insensitively.
    pub fn fieldError(self: ResponseStatus, name: []const u8) ?[]const u8 {
        const err = self.getFieldError(name) orelse return null;
        return err.message;
    }

    /// The `ResponseError` for `name`, matched case-insensitively.
    pub fn getFieldError(self: ResponseStatus, name: []const u8) ?ResponseError {
        const errors = self.errors orelse return null;
        for (errors) |err| {
            const field_name = err.fieldName orelse continue;
            if (std.ascii.eqlIgnoreCase(field_name, name)) return err;
        }
        return null;
    }
};

/// Returned by APIs with no Response Body.
pub const EmptyResponse = struct {
    responseStatus: ?ResponseStatus = null,
};

/// Returned by APIs that return the Id of the created or updated entity.
pub const IdResponse = struct {
    id: ?[]const u8 = null,
    responseStatus: ?ResponseStatus = null,
};

/// Returned by APIs that return a single string result.
pub const StringResponse = struct {
    result: ?[]const u8 = null,
    responseStatus: ?ResponseStatus = null,
};

/// Returned by APIs that return a list of string results.
pub const StringsResponse = struct {
    results: ?[]const []const u8 = null,
    responseStatus: ?ResponseStatus = null,
};

/// The typed Response of AutoQuery Requests.
pub fn QueryResponse(comptime T: type) type {
    return struct {
        offset: i32 = 0,
        total: i32 = 0,
        results: ?[]const T = null,
        responseStatus: ?ResponseStatus = null,
    };
}

/// Authenticate with a ServiceStack Service.
pub const Authenticate = struct {
    pub const ss_name = "Authenticate";
    pub const ss_verb = "POST";
    pub const Response = AuthenticateResponse;

    provider: ?[]const u8 = null,
    userName: ?[]const u8 = null,
    password: ?[]const u8 = null,
    rememberMe: ?bool = null,
    accessToken: ?[]const u8 = null,
    accessTokenSecret: ?[]const u8 = null,
    returnUrl: ?[]const u8 = null,
    errorView: ?[]const u8 = null,
};

/// The Response of a successful `Authenticate` Request.
pub const AuthenticateResponse = struct {
    userId: ?[]const u8 = null,
    sessionId: ?[]const u8 = null,
    userName: ?[]const u8 = null,
    displayName: ?[]const u8 = null,
    referrerUrl: ?[]const u8 = null,
    bearerToken: ?[]const u8 = null,
    refreshToken: ?[]const u8 = null,
    refreshTokenExpiry: ?[]const u8 = null,
    profileUrl: ?[]const u8 = null,
    roles: ?[]const []const u8 = null,
    permissions: ?[]const []const u8 = null,
    authProvider: ?[]const u8 = null,
    responseStatus: ?ResponseStatus = null,
};

/// Register a new User.
pub const Register = struct {
    pub const ss_name = "Register";
    pub const ss_verb = "POST";
    pub const Response = RegisterResponse;

    userName: ?[]const u8 = null,
    firstName: ?[]const u8 = null,
    lastName: ?[]const u8 = null,
    displayName: ?[]const u8 = null,
    email: ?[]const u8 = null,
    password: ?[]const u8 = null,
    confirmPassword: ?[]const u8 = null,
    autoLogin: ?bool = null,
    errorView: ?[]const u8 = null,
};

/// The Response of a successful `Register` Request.
pub const RegisterResponse = struct {
    userId: ?[]const u8 = null,
    sessionId: ?[]const u8 = null,
    userName: ?[]const u8 = null,
    referrerUrl: ?[]const u8 = null,
    bearerToken: ?[]const u8 = null,
    refreshToken: ?[]const u8 = null,
    refreshTokenExpiry: ?[]const u8 = null,
    roles: ?[]const []const u8 = null,
    permissions: ?[]const []const u8 = null,
    redirectUrl: ?[]const u8 = null,
    responseStatus: ?ResponseStatus = null,
};

/// Assign Roles and Permissions to a User.
pub const AssignRoles = struct {
    pub const ss_name = "AssignRoles";
    pub const ss_verb = "POST";
    pub const Response = AssignRolesResponse;

    userName: ?[]const u8 = null,
    permissions: ?[]const []const u8 = null,
    roles: ?[]const []const u8 = null,
};

/// The Response of a successful `AssignRoles` Request.
pub const AssignRolesResponse = struct {
    allRoles: ?[]const []const u8 = null,
    allPermissions: ?[]const []const u8 = null,
    responseStatus: ?ResponseStatus = null,
};

/// Remove Roles and Permissions from a User.
pub const UnAssignRoles = struct {
    pub const ss_name = "UnAssignRoles";
    pub const ss_verb = "POST";
    pub const Response = UnAssignRolesResponse;

    userName: ?[]const u8 = null,
    permissions: ?[]const []const u8 = null,
    roles: ?[]const []const u8 = null,
};

/// The Response of a successful `UnAssignRoles` Request.
pub const UnAssignRolesResponse = struct {
    allRoles: ?[]const []const u8 = null,
    allPermissions: ?[]const []const u8 = null,
    responseStatus: ?ResponseStatus = null,
};

/// Convert an authenticated Session into a JWT Bearer Token.
pub const ConvertSessionToToken = struct {
    pub const ss_name = "ConvertSessionToToken";
    pub const ss_verb = "POST";
    pub const Response = ConvertSessionToTokenResponse;

    preserveSession: ?bool = null,
};

/// The Response of `ConvertSessionToToken`.
pub const ConvertSessionToTokenResponse = struct {
    accessToken: ?[]const u8 = null,
    refreshToken: ?[]const u8 = null,
    responseStatus: ?ResponseStatus = null,
};

/// Exchange a Refresh Token for a new JWT Bearer Token.
pub const GetAccessToken = struct {
    pub const ss_name = "GetAccessToken";
    pub const ss_verb = "POST";
    pub const Response = GetAccessTokenResponse;

    refreshToken: ?[]const u8 = null,
};

/// The Response of `GetAccessToken`.
pub const GetAccessTokenResponse = struct {
    accessToken: ?[]const u8 = null,
    responseStatus: ?ResponseStatus = null,
};

/// An API Key assigned to a User.
pub const UserApiKey = struct {
    key: ?[]const u8 = null,
    keyType: ?[]const u8 = null,
    expiryDate: ?[]const u8 = null,
};

/// Return the API Keys assigned to the authenticated User.
pub const GetApiKeys = struct {
    pub const ss_name = "GetApiKeys";
    pub const ss_verb = "GET";
    pub const Response = GetApiKeysResponse;

    environment: ?[]const u8 = null,
};

/// The Response of `GetApiKeys`.
pub const GetApiKeysResponse = struct {
    results: ?[]const UserApiKey = null,
    responseStatus: ?ResponseStatus = null,
};

/// Regenerate the API Keys of the authenticated User.
pub const RegenerateApiKeys = struct {
    pub const ss_name = "RegenerateApiKeys";
    pub const ss_verb = "POST";
    pub const Response = RegenerateApiKeysResponse;

    environment: ?[]const u8 = null,
};

/// The Response of `RegenerateApiKeys`.
pub const RegenerateApiKeysResponse = struct {
    results: ?[]const UserApiKey = null,
    responseStatus: ?ResponseStatus = null,
};

test "ResponseStatus field errors" {
    const status = ResponseStatus{
        .errorCode = "NotEmpty",
        .message = "'Name' must not be empty.",
        .errors = &.{
            .{ .errorCode = "NotEmpty", .fieldName = "Name", .message = "'Name' must not be empty." },
        },
    };

    try std.testing.expectEqualStrings("'Name' must not be empty.", status.fieldError("name").?);
    try std.testing.expectEqualStrings("NotEmpty", status.errorCode.?);
    try std.testing.expect(status.fieldError("Missing") == null);
}
