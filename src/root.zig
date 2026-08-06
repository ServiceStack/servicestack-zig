//! Typed Zig Client Library for consuming [ServiceStack](https://servicestack.net) APIs.
//!
//! Generate typed DTOs for a remote ServiceStack API with
//! [get-dtos](https://www.npmjs.com/package/get-dtos):
//!
//! ```sh
//! npx get-dtos zig https://blazor-vue.web-templates.io
//! ```
//!
//! Then send them with the client, which infers each API's Response Type from
//! its Request DTO:
//!
//! ```zig
//! const servicestack = @import("servicestack");
//! const dtos = @import("dtos.zig");
//!
//! var client = try servicestack.JsonServiceClient.init(allocator, "https://blazor-vue.web-templates.io");
//! defer client.deinit();
//!
//! var res = try client.send(dtos.Hello{ .name = "World" });
//! defer res.deinit();
//! std.debug.print("{s}\n", .{res.value.result.?});
//! ```

const std = @import("std");

pub const client = @import("client.zig");
pub const types = @import("types.zig");
pub const url = @import("url.zig");

pub const JsonServiceClient = client.JsonServiceClient;
pub const ClientError = client.ClientError;
pub const WebServiceException = client.WebServiceException;
pub const ApiResult = client.ApiResult;
pub const UploadFile = client.UploadFile;
pub const CookieJar = client.CookieJar;
pub const ResponseTypeOf = client.ResponseTypeOf;
pub const nameOf = client.nameOf;
pub const methodOf = client.methodOf;
pub const collectionFieldOf = client.collectionFieldOf;

pub const ResponseStatus = types.ResponseStatus;
pub const ResponseError = types.ResponseError;
pub const EmptyResponse = types.EmptyResponse;
pub const IdResponse = types.IdResponse;
pub const StringResponse = types.StringResponse;
pub const StringsResponse = types.StringsResponse;
pub const QueryResponse = types.QueryResponse;
pub const Authenticate = types.Authenticate;
pub const AuthenticateResponse = types.AuthenticateResponse;
pub const Register = types.Register;
pub const RegisterResponse = types.RegisterResponse;
pub const AssignRoles = types.AssignRoles;
pub const AssignRolesResponse = types.AssignRolesResponse;
pub const UnAssignRoles = types.UnAssignRoles;
pub const UnAssignRolesResponse = types.UnAssignRolesResponse;
pub const ConvertSessionToToken = types.ConvertSessionToToken;
pub const ConvertSessionToTokenResponse = types.ConvertSessionToTokenResponse;
pub const GetAccessToken = types.GetAccessToken;
pub const GetAccessTokenResponse = types.GetAccessTokenResponse;
pub const UserApiKey = types.UserApiKey;
pub const GetApiKeys = types.GetApiKeys;
pub const GetApiKeysResponse = types.GetApiKeysResponse;
pub const RegenerateApiKeys = types.RegenerateApiKeys;
pub const RegenerateApiKeysResponse = types.RegenerateApiKeysResponse;

test {
    std.testing.refAllDecls(@This());
    _ = client;
    _ = types;
    _ = url;
}

test "exports the public API surface" {
    // Types consumers reference by name must be re-exported from the root module
    _ = JsonServiceClient;
    _ = UploadFile;
    _ = CookieJar;
    _ = ClientError;
    _ = WebServiceException;
    _ = ResponseStatus;
    _ = QueryResponse(ResponseStatus);
    _ = Authenticate;
    _ = collectionFieldOf;
}
