# Changelog

All notable changes to this project will be documented in this file.

## [0.1.1]

### Added

- `postFileWithRequest` / `postFilesWithRequest` for uploading files with a
  Request DTO as a `multipart/form-data` Request, incl. an `UploadFile` Type
- `on_authentication_required` callback and Refresh Token support for
  re-authenticating before automatically retrying a Request that returned
  401 Unauthorized

### Fixed

- Bearer Tokens are now owned by the client instead of the error arena, which
  is reset whenever a Request fails

## [0.1.0]

### Added

- `JsonServiceClient` for consuming ServiceStack APIs with generated typed DTOs
- Response Type, Request Name and HTTP Method resolved from a Request DTO's
  `Response`, `ss_name` and `ss_verb` declarations at comptime
- Structured `ResponseStatus` errors in `WebServiceException`, incl. field errors
- `api()` results that return errors instead of an error union
- Auth with Basic Auth, API Keys, Bearer Tokens and Session Cookies, incl. a
  `CookieJar` that `std.http.Client` doesn't provide
- Batched (`sendAll`), one-way (`publish`) and custom URL Requests
- Built-in ServiceStack DTOs referenced by generated DTOs (`ResponseStatus`,
  `QueryResponse(T)`, `Authenticate`, ...)

[0.1.1]: https://github.com/ServiceStack/servicestack-zig/releases/tag/v0.1.1
[0.1.0]: https://github.com/ServiceStack/servicestack-zig/releases/tag/v0.1.0
