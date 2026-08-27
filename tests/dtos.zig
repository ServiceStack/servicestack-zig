/// Options:
/// Date: 2026-08-07 02:41:43
/// Version: 10.09
/// Tip: To override a DTO option, remove "/" prefix before updating
/// BaseUrl: https://test.servicestack.net
/// GlobalNamespace:
/// MakePropertiesOptional: False
/// AddServiceStackTypes: True
/// AddResponseStatus: False
/// AddImplicitVersion:
/// AddDescriptionAsComments: True
/// IncludeTypes:
/// ExcludeTypes:
/// DefaultImports: const std = @import("std");
///
const std = @import("std");
const ss = @import("servicestack");

pub const Item = struct {
    name: ?[]const u8 = null,
    description: ?[]const u8 = null,
};

pub const Poco = struct {
    name: ?[]const u8 = null,
};

pub const CustomType = struct {
    id: i32 = 0,
    name: ?[]const u8 = null,
};

pub const SetterType = struct {
    id: i32 = 0,
    name: ?[]const u8 = null,
};

pub const DeclarativeChildValidation = struct {
    name: ?[]const u8 = null,
    // @Validate(Validator="MaximumLength(20)")
    value: ?[]const u8 = null,
};

pub const FluentChildValidation = struct {
    name: ?[]const u8 = null,
    value: ?[]const u8 = null,
};

pub const DeclarativeSingleValidation = struct {
    name: ?[]const u8 = null,
    // @Validate(Validator="MaximumLength(20)")
    value: ?[]const u8 = null,
};

pub const FluentSingleValidation = struct {
    name: ?[]const u8 = null,
    value: ?[]const u8 = null,
};

// @DataContract
pub const CancelRequest = struct {
    // @DataMember(Order=1)
    tag: ?[]const u8 = null,

    // @DataMember(Order=2)
    meta: ?std.json.Value = null,
};

// @DataContract
pub const CancelRequestResponse = struct {
    // @DataMember(Order=1)
    tag: ?[]const u8 = null,

    // @DataMember(Order=2)
    elapsed: ?[]const u8 = null,

    // @DataMember(Order=3)
    meta: ?std.json.Value = null,

    // @DataMember(Order=4)
    responseStatus: ?ss.ResponseStatus = null,
};

// @DataContract
pub const UpdateEventSubscriber = struct {
    // @DataMember(Order=1)
    id: ?[]const u8 = null,

    // @DataMember(Order=2)
    subscribeChannels: ?[][]const u8 = null,

    // @DataMember(Order=3)
    unsubscribeChannels: ?[][]const u8 = null,
};

// @DataContract
pub const UpdateEventSubscriberResponse = struct {
    // @DataMember(Order=1)
    responseStatus: ?ss.ResponseStatus = null,
};

pub const NavItem = struct {
    label: ?[]const u8 = null,
    href: ?[]const u8 = null,
    exact: ?bool = null,
    id: ?[]const u8 = null,
    className: ?[]const u8 = null,
    iconClass: ?[]const u8 = null,
    iconSrc: ?[]const u8 = null,
    show: ?[]const u8 = null,
    hide: ?[]const u8 = null,
    children: ?[]NavItem = null,
    meta: ?std.json.Value = null,
};

// @DataContract
pub const GetNavItems = struct {
    // @DataMember(Order=1)
    name: ?[]const u8 = null,
};

// @DataContract
pub const GetNavItemsResponse = struct {
    // @DataMember(Order=1)
    baseUrl: ?[]const u8 = null,

    // @DataMember(Order=2)
    results: ?[]NavItem = null,

    // @DataMember(Order=3)
    navItemsMap: ?std.json.Value = null,

    // @DataMember(Order=4)
    meta: ?std.json.Value = null,

    // @DataMember(Order=5)
    responseStatus: ?ss.ResponseStatus = null,
};

// @DataContract
pub const AuditBase = struct {
    // @DataMember(Order=1)
    createdDate: ?[]const u8 = null,

    // @DataMember(Order=2)
    // @Required()
    createdBy: ?[]const u8 = null,

    // @DataMember(Order=3)
    modifiedDate: ?[]const u8 = null,

    // @DataMember(Order=4)
    // @Required()
    modifiedBy: ?[]const u8 = null,

    // @DataMember(Order=5)
    deletedDate: ?[]const u8 = null,

    // @DataMember(Order=6)
    deletedBy: ?[]const u8 = null,
};

// @DataContract
pub const AuthUserSession = struct {
    // @DataMember(Order=1)
    referrerUrl: ?[]const u8 = null,

    // @DataMember(Order=2)
    id: ?[]const u8 = null,

    // @DataMember(Order=3)
    userAuthId: ?[]const u8 = null,

    // @DataMember(Order=4)
    userAuthName: ?[]const u8 = null,

    // @DataMember(Order=5)
    userName: ?[]const u8 = null,

    // @DataMember(Order=6)
    twitterUserId: ?[]const u8 = null,

    // @DataMember(Order=7)
    twitterScreenName: ?[]const u8 = null,

    // @DataMember(Order=8)
    facebookUserId: ?[]const u8 = null,

    // @DataMember(Order=9)
    facebookUserName: ?[]const u8 = null,

    // @DataMember(Order=10)
    firstName: ?[]const u8 = null,

    // @DataMember(Order=11)
    lastName: ?[]const u8 = null,

    // @DataMember(Order=12)
    displayName: ?[]const u8 = null,

    // @DataMember(Order=13)
    company: ?[]const u8 = null,

    // @DataMember(Order=14)
    email: ?[]const u8 = null,

    // @DataMember(Order=15)
    primaryEmail: ?[]const u8 = null,

    // @DataMember(Order=16)
    phoneNumber: ?[]const u8 = null,

    // @DataMember(Order=17)
    birthDate: ?[]const u8 = null,

    // @DataMember(Order=18)
    birthDateRaw: ?[]const u8 = null,

    // @DataMember(Order=19)
    address: ?[]const u8 = null,

    // @DataMember(Order=20)
    address2: ?[]const u8 = null,

    // @DataMember(Order=21)
    city: ?[]const u8 = null,

    // @DataMember(Order=22)
    state: ?[]const u8 = null,

    // @DataMember(Order=23)
    country: ?[]const u8 = null,

    // @DataMember(Order=24)
    culture: ?[]const u8 = null,

    // @DataMember(Order=25)
    fullName: ?[]const u8 = null,

    // @DataMember(Order=26)
    gender: ?[]const u8 = null,

    // @DataMember(Order=27)
    language: ?[]const u8 = null,

    // @DataMember(Order=28)
    mailAddress: ?[]const u8 = null,

    // @DataMember(Order=29)
    nickname: ?[]const u8 = null,

    // @DataMember(Order=30)
    postalCode: ?[]const u8 = null,

    // @DataMember(Order=31)
    timeZone: ?[]const u8 = null,

    // @DataMember(Order=32)
    requestTokenSecret: ?[]const u8 = null,

    // @DataMember(Order=33)
    createdAt: ?[]const u8 = null,

    // @DataMember(Order=34)
    lastModified: ?[]const u8 = null,

    // @DataMember(Order=35)
    roles: ?[][]const u8 = null,

    // @DataMember(Order=36)
    permissions: ?[][]const u8 = null,

    // @DataMember(Order=37)
    isAuthenticated: bool = false,

    // @DataMember(Order=38)
    fromToken: bool = false,

    // @DataMember(Order=39)
    profileUrl: ?[]const u8 = null,

    // @DataMember(Order=40)
    sequence: ?[]const u8 = null,

    // @DataMember(Order=41)
    tag: i64 = 0,

    // @DataMember(Order=42)
    authProvider: ?[]const u8 = null,

    // @DataMember(Order=43)
    providerOAuthAccess: ?[]std.json.Value = null,

    // @DataMember(Order=44)
    meta: ?std.json.Value = null,

    // @DataMember(Order=45)
    audiences: ?[][]const u8 = null,

    // @DataMember(Order=46)
    scopes: ?[][]const u8 = null,

    // @DataMember(Order=47)
    dns: ?[]const u8 = null,

    // @DataMember(Order=48)
    rsa: ?[]const u8 = null,

    // @DataMember(Order=49)
    sid: ?[]const u8 = null,

    // @DataMember(Order=50)
    hash: ?[]const u8 = null,

    // @DataMember(Order=51)
    homePhone: ?[]const u8 = null,

    // @DataMember(Order=52)
    mobilePhone: ?[]const u8 = null,

    // @DataMember(Order=53)
    webpage: ?[]const u8 = null,

    // @DataMember(Order=54)
    emailConfirmed: ?bool = null,

    // @DataMember(Order=55)
    phoneNumberConfirmed: ?bool = null,

    // @DataMember(Order=56)
    twoFactorEnabled: ?bool = null,

    // @DataMember(Order=57)
    securityStamp: ?[]const u8 = null,

    // @DataMember(Order=58)
    type: ?[]const u8 = null,

    // @DataMember(Order=59)
    recoveryToken: ?[]const u8 = null,

    // @DataMember(Order=60)
    refId: ?i32 = null,

    // @DataMember(Order=61)
    refIdStr: ?[]const u8 = null,
};

pub const NestedClass = struct {
    value: ?[]const u8 = null,
};

pub const EnumType = enum {
    Value1,
    Value2,
    Value3,
};

// @Flags()
pub const EnumTypeFlags = enum(i32) {
    Value1 = 0,
    Value2 = 1,
    Value3 = 2,
};

pub const EnumWithValues = enum {
    None,
    @"Member 1",
    Value2,
};

// @Flags()
pub const EnumFlags = enum(i32) {
    Value0 = 0,
    Value1 = 1,
    Value2 = 2,
    Value3 = 4,
    Value123 = 7,
};

pub const EnumAsInt = enum {
    Value1,
    Value2,
    Value3,
};

pub const EnumStyle = enum {
    lower,
    UPPER,
    PascalCase,
    camelCase,
    camelUPPER,
    PascalUPPER,
};

pub const EnumStyleMembers = enum {
    lower,
    UPPER,
    PascalCase,
    camelCase,
    camelUPPER,
    PascalUPPER,
};

pub fn KeyValuePair(comptime TKey: type, comptime TValue: type) type {
    return struct {
        key: ?TKey = null,
        value: ?TValue = null,
    };
}

pub const SubType = struct {
    id: i32 = 0,
    name: ?[]const u8 = null,
};

pub const AllTypesBase = struct {
    id: i32 = 0,
    nullableId: ?i32 = null,
    byte: u8 = 0,
    short: i16 = 0,
    int: i32 = 0,
    long: i64 = 0,
    uShort: u16 = 0,
    uInt: u32 = 0,
    uLong: u64 = 0,
    float: f32 = 0,
    double: f64 = 0,
    decimal: f64 = 0,
    string: ?[]const u8 = null,
    dateTime: ?[]const u8 = null,
    timeSpan: ?[]const u8 = null,
    dateTimeOffset: ?[]const u8 = null,
    guid: ?[]const u8 = null,
    char: u8 = 0,
    keyValuePair: ?KeyValuePair = null,
    nullableDateTime: ?[]const u8 = null,
    nullableTimeSpan: ?[]const u8 = null,
    stringList: [][]const u8 = &.{},
    stringArray: [][]const u8 = &.{},
    stringMap: ?std.json.Value = null,
    intStringMap: ?std.json.Value = null,
    subType: ?SubType = null,
};

pub const HelloBase = struct {
    id: i32 = 0,
};

pub fn HelloBase_1(comptime T: type) type {
    return struct {
        items: []T = &.{},
        counts: []i32 = &.{},
    };
}

pub const EmptyClass = struct {};

pub const DayOfWeek = enum {
    Sunday,
    Monday,
    Tuesday,
    Wednesday,
    Thursday,
    Friday,
    Saturday,
};

// @DataContract
pub const ScopeType = enum {
    Global,
    Sale,
};

pub const Channel = struct {
    name: ?[]const u8 = null,
    value: ?[]const u8 = null,
};

pub const Device = struct {
    id: i64 = 0,
    type: ?[]const u8 = null,
    timeStamp: i64 = 0,
    channels: []Channel = &.{},
};

pub const Logger = struct {
    id: i64 = 0,
    devices: []Device = &.{},
};

pub const Rockstar = struct {
    id: i32 = 0,
    firstName: ?[]const u8 = null,
    lastName: ?[]const u8 = null,
    age: ?i32 = null,
};

// @DataContract
pub const AiContent = struct {
    /// The type of the content part.
    // @DataMember(Name="type")
    type: ?[]const u8 = null,
};

/// The function that the model called.
// @DataContract
pub const ToolFunction = struct {
    /// The name of the function to call.
    // @DataMember(Name="name")
    name: ?[]const u8 = null,

    /// The arguments to call the function with, as generated by the model in JSON format. Note that the model does not always generate valid JSON, and may hallucinate parameters not defined by your function schema. Validate the arguments in your code before calling your function.
    // @DataMember(Name="arguments")
    arguments: ?[]const u8 = null,
};

/// The tool calls generated by the model, such as function calls.
// @DataContract
pub const ToolCall = struct {
    /// The ID of the tool call.
    // @DataMember(Name="id")
    id: ?[]const u8 = null,

    /// The type of the tool. Currently, only `function` is supported.
    // @DataMember(Name="type")
    type: ?[]const u8 = null,

    /// The function that the model called.
    // @DataMember(Name="function")
    function: ?ToolFunction = null,
};

/// A list of messages comprising the conversation so far.
// @DataContract
pub const AiMessage = struct {
    /// The contents of the message.
    // @DataMember(Name="content")
    content: ?[]std.json.Value = null,

    /// The role of the author of this message. Valid values are `system`, `user`, `assistant` and `tool`.
    // @DataMember(Name="role")
    role: ?[]const u8 = null,

    /// An optional name for the participant. Provides the model information to differentiate between participants of the same role.
    // @DataMember(Name="name")
    name: ?[]const u8 = null,

    /// The tool calls generated by the model, such as function calls.
    // @DataMember(Name="tool_calls")
    tool_calls: ?[]ToolCall = null,

    /// Tool call that this message is responding to.
    // @DataMember(Name="tool_call_id")
    tool_call_id: ?[]const u8 = null,

    /// The reasoning an assistant message was generated with, normalized per provider when replayed as history.
    // @DataMember(Name="reasoning")
    reasoning: ?[]const u8 = null,

    /// The reasoning an assistant message was generated with, as emitted by Gemini and most OpenAI-compatible providers.
    // @DataMember(Name="reasoning_content")
    reasoning_content: ?[]const u8 = null,

    /// Unix timestamp (in milliseconds) the message was generated.
    // @DataMember(Name="timestamp")
    timestamp: ?i64 = null,

    /// Images attached to the message. Folded into `content` parts before sending to a provider.
    // @DataMember(Name="images")
    images: ?[]std.json.Value = null,
};

/// Parameters for audio output. Required when audio output is requested with modalities: [audio]
// @DataContract
pub const AiChatAudio = struct {
    /// Specifies the output audio format. Must be one of wav, mp3, flac, opus, or pcm16.
    // @DataMember(Name="format")
    format: ?[]const u8 = null,

    /// The voice the model uses to respond. Supported voices are alloy, ash, ballad, coral, echo, fable, nova, onyx, sage, and shimmer.
    // @DataMember(Name="voice")
    voice: ?[]const u8 = null,
};

pub const ResponseFormat = enum {
    text,
    json_object,
};

// @DataContract
pub const AiResponseFormat = struct {
    /// An object specifying the format that the model must output. Compatible with GPT-4 Turbo and all GPT-3.5 Turbo models newer than gpt-3.5-turbo-1106.
    // @DataMember(Name="type")
    type: ?ResponseFormat = null,
};

pub const ToolType = enum {
    function,
};

// @DataContract
pub const AiToolFunction = struct {
    /// The name of the function to be called. Must be a-z, A-Z, 0-9, or contain underscores and dashes, with a maximum length of 64.
    // @DataMember(Name="name")
    name: ?[]const u8 = null,

    /// A description of what the function does, used by the model to choose when and how to call the function.
    // @DataMember(Name="description")
    description: ?[]const u8 = null,

    /// The parameters the functions accepts, described as a JSON Schema object. See the guide for examples, and the JSON Schema reference for documentation about the format.
    // @DataMember(Name="parameters")
    parameters: ?std.json.Value = null,
};

// @DataContract
pub const Tool = struct {
    /// The type of the tool. Currently, only function is supported.
    // @DataMember(Name="type")
    type: ?ToolType = null,

    /// The function definition the model may call.
    // @DataMember(Name="function")
    function: ?AiToolFunction = null,
};

pub const RoomType = enum {
    Single,
    Double,
    Queen,
    Twin,
    Suite,
};

/// Discount Coupons
pub const Coupon = struct {
    id: ?[]const u8 = null,
    description: ?[]const u8 = null,
    discount: i32 = 0,
    expiryDate: ?[]const u8 = null,
};

pub const Address = struct {
    id: i64 = 0,
    addressText: ?[]const u8 = null,
};

/// Booking Details
pub const Booking = struct {
    // @DataMember(Order=1)
    createdDate: ?[]const u8 = null,

    // @DataMember(Order=2)
    // @Required()
    createdBy: ?[]const u8 = null,

    // @DataMember(Order=3)
    modifiedDate: ?[]const u8 = null,

    // @DataMember(Order=4)
    // @Required()
    modifiedBy: ?[]const u8 = null,

    // @DataMember(Order=5)
    deletedDate: ?[]const u8 = null,

    // @DataMember(Order=6)
    deletedBy: ?[]const u8 = null,
    id: i32 = 0,
    name: ?[]const u8 = null,
    roomType: ?RoomType = null,
    roomNumber: i32 = 0,
    bookingStartDate: ?[]const u8 = null,
    bookingEndDate: ?[]const u8 = null,
    cost: f64 = 0,
    // @References(typeof(Coupon))
    couponId: ?[]const u8 = null,

    discount: ?Coupon = null,
    notes: ?[]const u8 = null,
    cancelled: ?bool = null,
    // @References(typeof(Address))
    permanentAddressId: ?i64 = null,

    permanentAddress: ?Address = null,
    // @References(typeof(Address))
    postalAddressId: ?i64 = null,

    postalAddress: ?Address = null,
};

pub fn QueryDbTenant(comptime From: type, comptime Into: type) type {
    _ = From;
    _ = Into;
    return struct {
        // @DataMember(Order=1)
        skip: ?i32 = null,

        // @DataMember(Order=2)
        take: ?i32 = null,

        // @DataMember(Order=3)
        orderBy: ?[]const u8 = null,

        // @DataMember(Order=4)
        orderByDesc: ?[]const u8 = null,

        // @DataMember(Order=5)
        include: ?[]const u8 = null,

        // @DataMember(Order=6)
        fields: ?[]const u8 = null,

        // @DataMember(Order=7)
        meta: ?std.json.Value = null,
    };
}

pub const LivingStatus = enum {
    Alive,
    Dead,
};

pub const RockstarAuditTenant = struct {
    // @DataMember(Order=1)
    createdDate: ?[]const u8 = null,

    // @DataMember(Order=2)
    // @Required()
    createdBy: ?[]const u8 = null,

    // @DataMember(Order=3)
    modifiedDate: ?[]const u8 = null,

    // @DataMember(Order=4)
    // @Required()
    modifiedBy: ?[]const u8 = null,

    // @DataMember(Order=5)
    deletedDate: ?[]const u8 = null,

    // @DataMember(Order=6)
    deletedBy: ?[]const u8 = null,
    tenantId: i32 = 0,
    id: i32 = 0,
    firstName: ?[]const u8 = null,
    lastName: ?[]const u8 = null,
    age: ?i32 = null,
    dateOfBirth: ?[]const u8 = null,
    dateDied: ?[]const u8 = null,
    livingStatus: ?LivingStatus = null,
};

pub const RockstarBase = struct {
    firstName: ?[]const u8 = null,
    lastName: ?[]const u8 = null,
    age: ?i32 = null,
    dateOfBirth: ?[]const u8 = null,
    dateDied: ?[]const u8 = null,
    livingStatus: ?LivingStatus = null,
};

pub const RockstarAuto = struct {
    firstName: ?[]const u8 = null,
    lastName: ?[]const u8 = null,
    age: ?i32 = null,
    dateOfBirth: ?[]const u8 = null,
    dateDied: ?[]const u8 = null,
    livingStatus: ?LivingStatus = null,
    id: i32 = 0,
};

pub const OnlyDefinedInGenericType = struct {
    id: i32 = 0,
    name: ?[]const u8 = null,
};

pub const OnlyDefinedInGenericTypeFrom = struct {
    id: i32 = 0,
    name: ?[]const u8 = null,
};

pub const OnlyDefinedInGenericTypeInto = struct {
    id: i32 = 0,
    name: ?[]const u8 = null,
};

pub const RockstarAudit = struct {
    firstName: ?[]const u8 = null,
    lastName: ?[]const u8 = null,
    age: ?i32 = null,
    dateOfBirth: ?[]const u8 = null,
    dateDied: ?[]const u8 = null,
    livingStatus: ?LivingStatus = null,
    id: i32 = 0,
    createdDate: ?[]const u8 = null,
    createdBy: ?[]const u8 = null,
    createdInfo: ?[]const u8 = null,
    modifiedDate: ?[]const u8 = null,
    modifiedBy: ?[]const u8 = null,
    modifiedInfo: ?[]const u8 = null,
};

pub fn CreateAuditBase(comptime Table: type, comptime TResponse: type) type {
    _ = Table;
    _ = TResponse;
    return struct {};
}

pub fn CreateAuditTenantBase(comptime Table: type, comptime TResponse: type) type {
    _ = Table;
    _ = TResponse;
    return struct {};
}

pub fn UpdateAuditBase(comptime Table: type, comptime TResponse: type) type {
    _ = Table;
    _ = TResponse;
    return struct {};
}

pub fn UpdateAuditTenantBase(comptime Table: type, comptime TResponse: type) type {
    _ = Table;
    _ = TResponse;
    return struct {};
}

pub fn PatchAuditBase(comptime Table: type, comptime TResponse: type) type {
    _ = Table;
    _ = TResponse;
    return struct {};
}

pub fn PatchAuditTenantBase(comptime Table: type, comptime TResponse: type) type {
    _ = Table;
    _ = TResponse;
    return struct {};
}

pub fn SoftDeleteAuditBase(comptime Table: type, comptime TResponse: type) type {
    _ = Table;
    _ = TResponse;
    return struct {};
}

pub fn SoftDeleteAuditTenantBase(comptime Table: type, comptime TResponse: type) type {
    _ = Table;
    _ = TResponse;
    return struct {};
}

pub const RockstarVersion = struct {
    firstName: ?[]const u8 = null,
    lastName: ?[]const u8 = null,
    age: ?i32 = null,
    dateOfBirth: ?[]const u8 = null,
    dateDied: ?[]const u8 = null,
    livingStatus: ?LivingStatus = null,
    id: i32 = 0,
    rowVersion: u64 = 0,
};

// @Route("/messages/crud/{Id}", "PUT")
pub const MessageCrud = struct {
    pub const ss_name = "MessageCrud";
    pub const ss_verb = "PUT";

    id: i32 = 0,
    name: ?[]const u8 = null,
};

pub fn QueryResponseAlt(comptime T: type) type {
    return struct {
        offset: i32 = 0,
        total: i32 = 0,
        results: []T = &.{},
        meta: ?std.json.Value = null,
        responseStatus: ?ss.ResponseStatus = null,
    };
}

/// Output object for generated text
pub const TextOutput = struct {
    /// The generated text
    // @ApiMember(Description="The generated text")
    text: ?[]const u8 = null,
};

pub const UploadInfo = struct {
    name: ?[]const u8 = null,
    fileName: ?[]const u8 = null,
    contentLength: i64 = 0,
    contentType: ?[]const u8 = null,
};

pub const MetadataTestNestedChild = struct {
    name: ?[]const u8 = null,
};

pub const MetadataTestChild = struct {
    name: ?[]const u8 = null,
    results: []MetadataTestNestedChild = &.{},
};

pub const MenuItemExampleItem = struct {
    // @DataMember(Order=1)
    // @ApiMember()
    name1: ?[]const u8 = null,
};

pub const MenuItemExample = struct {
    // @DataMember(Order=1)
    // @ApiMember()
    name1: ?[]const u8 = null,

    menuItemExampleItem: ?MenuItemExampleItem = null,
};

// @DataContract
pub const MenuExample = struct {
    // @DataMember(Order=1)
    // @ApiMember()
    menuItemExample1: ?MenuItemExample = null,
};

pub const ListResult = struct {
    result: ?[]const u8 = null,
};

pub const ArrayResult = struct {
    result: ?[]const u8 = null,
};

pub const HelloResponseBase = struct {
    refId: i32 = 0,
};

pub const HelloWithReturnResponse = struct {
    result: ?[]const u8 = null,
};

pub const HelloType = struct {
    result: ?[]const u8 = null,
};

pub const InnerType = struct {
    id: i64 = 0,
    name: ?[]const u8 = null,
};

pub const InnerEnum = enum {
    Foo,
    Bar,
    Baz,
};

pub const ReturnedDto = struct {
    id: i32 = 0,
};

pub const CustomUserSession = struct {
    // @DataMember(Order=1)
    referrerUrl: ?[]const u8 = null,

    // @DataMember(Order=2)
    id: ?[]const u8 = null,

    // @DataMember(Order=3)
    userAuthId: ?[]const u8 = null,

    // @DataMember(Order=4)
    userAuthName: ?[]const u8 = null,

    // @DataMember(Order=5)
    userName: ?[]const u8 = null,

    // @DataMember(Order=6)
    twitterUserId: ?[]const u8 = null,

    // @DataMember(Order=7)
    twitterScreenName: ?[]const u8 = null,

    // @DataMember(Order=8)
    facebookUserId: ?[]const u8 = null,

    // @DataMember(Order=9)
    facebookUserName: ?[]const u8 = null,

    // @DataMember(Order=10)
    firstName: ?[]const u8 = null,

    // @DataMember(Order=11)
    lastName: ?[]const u8 = null,

    // @DataMember(Order=12)
    displayName: ?[]const u8 = null,

    // @DataMember(Order=13)
    company: ?[]const u8 = null,

    // @DataMember(Order=14)
    email: ?[]const u8 = null,

    // @DataMember(Order=15)
    primaryEmail: ?[]const u8 = null,

    // @DataMember(Order=16)
    phoneNumber: ?[]const u8 = null,

    // @DataMember(Order=17)
    birthDate: ?[]const u8 = null,

    // @DataMember(Order=18)
    birthDateRaw: ?[]const u8 = null,

    // @DataMember(Order=19)
    address: ?[]const u8 = null,

    // @DataMember(Order=20)
    address2: ?[]const u8 = null,

    // @DataMember(Order=21)
    city: ?[]const u8 = null,

    // @DataMember(Order=22)
    state: ?[]const u8 = null,

    // @DataMember(Order=23)
    country: ?[]const u8 = null,

    // @DataMember(Order=24)
    culture: ?[]const u8 = null,

    // @DataMember(Order=25)
    fullName: ?[]const u8 = null,

    // @DataMember(Order=26)
    gender: ?[]const u8 = null,

    // @DataMember(Order=27)
    language: ?[]const u8 = null,

    // @DataMember(Order=28)
    mailAddress: ?[]const u8 = null,

    // @DataMember(Order=29)
    nickname: ?[]const u8 = null,

    // @DataMember(Order=30)
    postalCode: ?[]const u8 = null,

    // @DataMember(Order=31)
    timeZone: ?[]const u8 = null,

    // @DataMember(Order=32)
    requestTokenSecret: ?[]const u8 = null,

    // @DataMember(Order=33)
    createdAt: ?[]const u8 = null,

    // @DataMember(Order=34)
    lastModified: ?[]const u8 = null,

    // @DataMember(Order=35)
    roles: ?[][]const u8 = null,

    // @DataMember(Order=36)
    permissions: ?[][]const u8 = null,

    // @DataMember(Order=37)
    isAuthenticated: bool = false,

    // @DataMember(Order=38)
    fromToken: bool = false,

    // @DataMember(Order=39)
    profileUrl: ?[]const u8 = null,

    // @DataMember(Order=40)
    sequence: ?[]const u8 = null,

    // @DataMember(Order=41)
    tag: i64 = 0,

    // @DataMember(Order=42)
    authProvider: ?[]const u8 = null,

    // @DataMember(Order=43)
    providerOAuthAccess: ?[]std.json.Value = null,

    // @DataMember(Order=44)
    meta: ?std.json.Value = null,

    // @DataMember(Order=45)
    audiences: ?[][]const u8 = null,

    // @DataMember(Order=46)
    scopes: ?[][]const u8 = null,

    // @DataMember(Order=47)
    dns: ?[]const u8 = null,

    // @DataMember(Order=48)
    rsa: ?[]const u8 = null,

    // @DataMember(Order=49)
    sid: ?[]const u8 = null,

    // @DataMember(Order=50)
    hash: ?[]const u8 = null,

    // @DataMember(Order=51)
    homePhone: ?[]const u8 = null,

    // @DataMember(Order=52)
    mobilePhone: ?[]const u8 = null,

    // @DataMember(Order=53)
    webpage: ?[]const u8 = null,

    // @DataMember(Order=54)
    emailConfirmed: ?bool = null,

    // @DataMember(Order=55)
    phoneNumberConfirmed: ?bool = null,

    // @DataMember(Order=56)
    twoFactorEnabled: ?bool = null,

    // @DataMember(Order=57)
    securityStamp: ?[]const u8 = null,

    // @DataMember(Order=58)
    type: ?[]const u8 = null,

    // @DataMember(Order=59)
    recoveryToken: ?[]const u8 = null,

    // @DataMember(Order=60)
    refId: ?i32 = null,

    // @DataMember(Order=61)
    refIdStr: ?[]const u8 = null,
    // @DataMember
    customName: ?[]const u8 = null,

    // @DataMember
    customInfo: ?[]const u8 = null,
};

pub const UnAuthInfo = struct {
    customInfo: ?[]const u8 = null,
};

/// Annotations for the message, when applicable, as when using the web search tool.
// @DataContract
pub const UrlCitation = struct {
    /// The index of the last character of the URL citation in the message.
    // @DataMember(Name="end_index")
    end_index: i32 = 0,

    /// The index of the first character of the URL citation in the message.
    // @DataMember(Name="start_index")
    start_index: i32 = 0,

    /// The title of the web resource.
    // @DataMember(Name="title")
    title: ?[]const u8 = null,

    /// The URL of the web resource.
    // @DataMember(Name="url")
    url: ?[]const u8 = null,
};

/// Annotations for the message, when applicable, as when using the web search tool.
// @DataContract
pub const ChoiceAnnotation = struct {
    /// The type of the URL citation. Always url_citation.
    // @DataMember(Name="type")
    type: ?[]const u8 = null,

    /// A URL citation when using web search.
    // @DataMember(Name="url_citation")
    url_citation: ?UrlCitation = null,
};

/// If the audio output modality is requested, this object contains data about the audio response from the model.
// @DataContract
pub const ChoiceAudio = struct {
    /// Base64 encoded audio bytes generated by the model, in the format specified in the request.
    // @DataMember(Name="data")
    data: ?[]const u8 = null,

    /// The Unix timestamp (in seconds) for when this audio response will no longer be accessible on the server for use in multi-turn conversations.
    // @DataMember(Name="expires_at")
    expires_at: i64 = 0,

    /// Unique identifier for this audio response.
    // @DataMember(Name="id")
    id: ?[]const u8 = null,

    /// Transcript of the audio generated by the model.
    // @DataMember(Name="transcript")
    transcript: ?[]const u8 = null,
};

// @DataContract
pub const ChoiceMessage = struct {
    /// The contents of the message.
    // @DataMember(Name="content")
    content: ?[]const u8 = null,

    /// The refusal message generated by the model.
    // @DataMember(Name="refusal")
    refusal: ?[]const u8 = null,

    /// The reasoning process used by the model.
    // @DataMember(Name="reasoning")
    reasoning: ?[]const u8 = null,

    /// The reasoning process used by the model, as emitted by Gemini and most OpenAI-compatible providers.
    // @DataMember(Name="reasoning_content")
    reasoning_content: ?[]const u8 = null,

    /// The reasoning process used by the model, as emitted by Anthropic.
    // @DataMember(Name="thinking")
    thinking: ?[]const u8 = null,

    /// The role of the author of this message.
    // @DataMember(Name="role")
    role: ?[]const u8 = null,

    /// Unix timestamp (in milliseconds) the message was generated.
    // @DataMember(Name="timestamp")
    timestamp: ?i64 = null,

    /// The tool call this message is responding to, set on `tool` role messages in tool_history.
    // @DataMember(Name="tool_call_id")
    tool_call_id: ?[]const u8 = null,

    /// Images generated by the model or produced by a tool call.
    // @DataMember(Name="images")
    images: ?[]std.json.Value = null,

    /// Audio generated by the model or produced by a tool call.
    // @DataMember(Name="audios")
    audios: ?[]std.json.Value = null,

    /// Files produced by a tool call.
    // @DataMember(Name="files")
    files: ?[]std.json.Value = null,

    /// Annotations for the message, when applicable, as when using the web search tool.
    // @DataMember(Name="annotations")
    annotations: ?[]ChoiceAnnotation = null,

    /// If the audio output modality is requested, this object contains data about the audio response from the model.
    // @DataMember(Name="audio")
    audio: ?ChoiceAudio = null,

    /// The tool calls generated by the model, such as function calls.
    // @DataMember(Name="tool_calls")
    tool_calls: ?[]ToolCall = null,
};

/// A list of message content tokens with log probability information.
// @DataContract
pub const LogprobItem = struct {
    /// The token.
    // @DataMember(Name="token")
    token: ?[]const u8 = null,

    /// The log probability of this token, if it is within the top 20 most likely tokens. Otherwise, the value `-9999`.0 is used to signify that the token is very unlikely.
    // @DataMember(Name="logprob")
    logprob: f64 = 0,

    /// A list of integers representing the UTF-8 bytes representation of the token. Useful in instances where characters are represented by multiple tokens and their byte representations must be combined to generate the correct text representation. Can be `null` if there is no bytes representation for the token.
    // @DataMember(Name="bytes")
    bytes: ?[]const u8 = null,

    /// List of the most likely tokens and their log probability, at this token position. In rare cases, there may be fewer than the number of requested `top_logprobs` returned.
    // @DataMember(Name="top_logprobs")
    top_logprobs: []LogprobItem = &.{},
};

/// Log probability information for the choice.
// @DataContract
pub const Logprobs = struct {
    /// A list of message content tokens with log probability information.
    // @DataMember(Name="content")
    content: []LogprobItem = &.{},
};

// @DataContract
pub const Choice = struct {
    /// The reason the model stopped generating tokens. This will be stop if the model hit a natural stop point or a provided stop sequence, length if the maximum number of tokens specified in the request was reached, content_filter if content was omitted due to a flag from our content filters, tool_calls if the model called a tool
    // @DataMember(Name="finish_reason")
    finish_reason: ?[]const u8 = null,

    /// The index of the choice in the list of choices.
    // @DataMember(Name="index")
    index: i32 = 0,

    /// A chat completion message generated by the model.
    // @DataMember(Name="message")
    message: ?ChoiceMessage = null,

    /// Log probability information for the choice.
    // @DataMember(Name="logprobs")
    logprobs: ?Logprobs = null,
};

/// Usage statistics for the completion request.
// @DataContract
pub const AiCompletionUsage = struct {
    /// When using Predicted Outputs, the number of tokens in the prediction that appeared in the completion.
    // @DataMember(Name="accepted_prediction_tokens")
    accepted_prediction_tokens: i64 = 0,

    /// Audio input tokens generated by the model.
    // @DataMember(Name="audio_tokens")
    audio_tokens: i64 = 0,

    /// Tokens generated by the model for reasoning.
    // @DataMember(Name="reasoning_tokens")
    reasoning_tokens: i64 = 0,

    /// When using Predicted Outputs, the number of tokens in the prediction that did not appear in the completion.
    // @DataMember(Name="rejected_prediction_tokens")
    rejected_prediction_tokens: i64 = 0,
};

/// Breakdown of tokens used in the prompt.
// @DataContract
pub const AiPromptUsage = struct {
    /// When using Predicted Outputs, the number of tokens in the prediction that appeared in the completion.
    // @DataMember(Name="accepted_prediction_tokens")
    accepted_prediction_tokens: i64 = 0,

    /// Audio input tokens present in the prompt.
    // @DataMember(Name="audio_tokens")
    audio_tokens: i64 = 0,

    /// Cached tokens present in the prompt.
    // @DataMember(Name="cached_tokens")
    cached_tokens: i64 = 0,
};

/// Usage statistics for the completion request.
// @DataContract
pub const AiUsage = struct {
    /// Number of tokens in the generated completion.
    // @DataMember(Name="completion_tokens")
    completion_tokens: i64 = 0,

    /// Number of tokens in the prompt.
    // @DataMember(Name="prompt_tokens")
    prompt_tokens: i64 = 0,

    /// Total number of tokens used in the request (prompt + completion).
    // @DataMember(Name="total_tokens")
    total_tokens: i64 = 0,

    /// Breakdown of tokens used in a completion.
    // @DataMember(Name="completion_tokens_details")
    completion_tokens_details: ?AiCompletionUsage = null,

    /// Breakdown of tokens used in the prompt.
    // @DataMember(Name="prompt_tokens_details")
    prompt_tokens_details: ?AiPromptUsage = null,

    /// Seconds spent servicing the completion, including every request in the tool loop.
    // @DataMember(Name="duration")
    duration: ?i64 = null,
};

pub const TypesGroup = struct {};

/// Text content part
// @DataContract
pub const AiTextContent = struct {
    /// The type of the content part.
    // @DataMember(Name="type")
    type: ?[]const u8 = null,
    /// The text content.
    // @DataMember(Name="text")
    text: ?[]const u8 = null,
};

// @DataContract
pub const AiImageUrl = struct {
    /// Either a URL of the image or the base64 encoded image data.
    // @DataMember(Name="url")
    url: ?[]const u8 = null,
};

/// Image content part
// @DataContract
pub const AiImageContent = struct {
    /// The type of the content part.
    // @DataMember(Name="type")
    type: ?[]const u8 = null,
    /// The image for this content.
    // @DataMember(Name="image_url")
    image_url: ?AiImageUrl = null,
};

/// Audio content part
// @DataContract
pub const AiInputAudio = struct {
    /// URL or Base64 encoded audio data.
    // @DataMember(Name="data")
    data: ?[]const u8 = null,

    /// The format of the encoded audio data. Currently supports 'wav' and 'mp3'.
    // @DataMember(Name="format")
    format: ?[]const u8 = null,
};

/// Audio content part
// @DataContract
pub const AiAudioContent = struct {
    /// The type of the content part.
    // @DataMember(Name="type")
    type: ?[]const u8 = null,
    /// The audio input for this content.
    // @DataMember(Name="input_audio")
    input_audio: ?AiInputAudio = null,
};

/// File content part
// @DataContract
pub const AiFile = struct {
    /// The URL or base64 encoded file data, used when passing the file to the model as a string.
    // @DataMember(Name="file_data")
    file_data: ?[]const u8 = null,

    /// The name of the file, used when passing the file to the model as a string.
    // @DataMember(Name="filename")
    filename: ?[]const u8 = null,

    /// The ID of an uploaded file to use as input.
    // @DataMember(Name="file_id")
    file_id: ?[]const u8 = null,
};

/// File content part
// @DataContract
pub const AiFileContent = struct {
    /// The type of the content part.
    // @DataMember(Name="type")
    type: ?[]const u8 = null,
    /// The file input for this content.
    // @DataMember(Name="file")
    file: ?AiFile = null,
};

// @DataContract
pub const AiAudioUrl = struct {
    /// Either a URL of the audio or the base64 encoded audio data.
    // @DataMember(Name="url")
    url: ?[]const u8 = null,
};

/// Generated audio content part, referenced by URL (emitted by tool calls and audio models)
// @DataContract
pub const AiAudioUrlContent = struct {
    /// The type of the content part.
    // @DataMember(Name="type")
    type: ?[]const u8 = null,
    /// The audio for this content.
    // @DataMember(Name="audio_url")
    audio_url: ?AiAudioUrl = null,
};

pub const ChatMessage = struct {
    id: i64 = 0,
    channel: ?[]const u8 = null,
    fromUserId: ?[]const u8 = null,
    fromName: ?[]const u8 = null,
    displayName: ?[]const u8 = null,
    message: ?[]const u8 = null,
    userAuthId: ?[]const u8 = null,
    private: bool = false,
};

pub const GetChatHistoryResponse = struct {
    results: ?[]ChatMessage = null,
    responseStatus: ?ss.ResponseStatus = null,
};

pub const GetUserDetailsResponse = struct {
    provider: ?[]const u8 = null,
    userId: ?[]const u8 = null,
    userName: ?[]const u8 = null,
    fullName: ?[]const u8 = null,
    displayName: ?[]const u8 = null,
    firstName: ?[]const u8 = null,
    lastName: ?[]const u8 = null,
    company: ?[]const u8 = null,
    email: ?[]const u8 = null,
    phoneNumber: ?[]const u8 = null,
    birthDate: ?[]const u8 = null,
    birthDateRaw: ?[]const u8 = null,
    address: ?[]const u8 = null,
    address2: ?[]const u8 = null,
    city: ?[]const u8 = null,
    state: ?[]const u8 = null,
    country: ?[]const u8 = null,
    culture: ?[]const u8 = null,
    gender: ?[]const u8 = null,
    language: ?[]const u8 = null,
    mailAddress: ?[]const u8 = null,
    nickname: ?[]const u8 = null,
    postalCode: ?[]const u8 = null,
    timeZone: ?[]const u8 = null,
};

pub const CustomHttpErrorResponse = struct {
    custom: ?[]const u8 = null,
    responseStatus: ?ss.ResponseStatus = null,
};

pub const Items = struct {
    results: []Item = &.{},
};

pub const ReturnCustom400Response = struct {
    responseStatus: ?ss.ResponseStatus = null,
};

pub const ThrowTypeResponse = struct {
    responseStatus: ?ss.ResponseStatus = null,
};

pub const ThrowValidationResponse = struct {
    age: i32 = 0,
    required: ?[]const u8 = null,
    email: ?[]const u8 = null,
    responseStatus: ?ss.ResponseStatus = null,
};

pub const ThrowBusinessErrorResponse = struct {
    responseStatus: ?ss.ResponseStatus = null,
};

/// Response object for text generation requests
// @Api(Description="Response object for text generation requests")
pub const TextGenerationResponse = struct {
    /// List of generated text outputs
    // @ApiMember(Description="List of generated text outputs")
    results: ?[]TextOutput = null,

    /// Detailed response status information
    // @ApiMember(Description="Detailed response status information")
    responseStatus: ?ss.ResponseStatus = null,
};

pub const TestFileUploadsResponse = struct {
    id: ?i32 = null,
    refId: ?[]const u8 = null,
    files: []UploadInfo = &.{},
    responseStatus: ?ss.ResponseStatus = null,
};

pub const TestUploadWithDto = struct {
    pub const ss_name = "TestUploadWithDto";
    pub const ss_verb = "POST";

    int: i32 = 0,
    nullableId: ?i32 = null,
    long: i64 = 0,
    double: f64 = 0,
    string: ?[]const u8 = null,
    dateTime: ?[]const u8 = null,
    intArray: ?[]i32 = null,
    intList: ?[]i32 = null,
    stringArray: ?[][]const u8 = null,
    stringList: ?[][]const u8 = null,
    pocoArray: ?[]Poco = null,
    pocoList: ?[]Poco = null,
    nullableByteArray: ?[]?u8 = null,
    nullableByteList: ?[]?u8 = null,
    nullableDateTimeArray: ?[]?[]const u8 = null,
    nullableDateTimeList: ?[]?[]const u8 = null,
    pocoLookup: ?std.json.Value = null,
    pocoLookupMap: ?std.json.Value = null,
    mapList: ?std.json.Value = null,
};

pub const Account = struct {
    name: ?[]const u8 = null,
};

pub const Project = struct {
    account: ?[]const u8 = null,
    name: ?[]const u8 = null,
};

pub const SecuredResponse = struct {
    result: ?[]const u8 = null,
    responseStatus: ?ss.ResponseStatus = null,
};

pub const CreateJwtResponse = struct {
    token: ?[]const u8 = null,
    responseStatus: ?ss.ResponseStatus = null,
};

pub const CreateRefreshJwtResponse = struct {
    token: ?[]const u8 = null,
    responseStatus: ?ss.ResponseStatus = null,
};

pub const MetadataTestResponse = struct {
    id: i32 = 0,
    results: []MetadataTestChild = &.{},
};

// @DataContract
pub const GetExampleResponse = struct {
    // @DataMember(Order=1)
    responseStatus: ?ss.ResponseStatus = null,

    // @DataMember(Order=2)
    // @ApiMember()
    menuExample1: ?MenuExample = null,
};

// @Route("/messages/{Id}", "PUT")
pub const Message = struct {
    pub const ss_name = "Message";
    pub const ss_verb = "PUT";

    id: i32 = 0,
    name: ?[]const u8 = null,
};

pub const GetRandomIdsResponse = struct {
    results: [][]const u8 = &.{},
};

pub const HelloResponse = struct {
    result: ?[]const u8 = null,
};

pub const AllTypes = struct {
    pub const ss_name = "AllTypes";
    pub const ss_verb = "POST";

    id: i32 = 0,
    nullableId: ?i32 = null,
    byte: u8 = 0,
    short: i16 = 0,
    int: i32 = 0,
    long: i64 = 0,
    uShort: u16 = 0,
    uInt: u32 = 0,
    uLong: u64 = 0,
    float: f32 = 0,
    double: f64 = 0,
    decimal: f64 = 0,
    string: ?[]const u8 = null,
    dateTime: ?[]const u8 = null,
    timeSpan: ?[]const u8 = null,
    dateTimeOffset: ?[]const u8 = null,
    guid: ?[]const u8 = null,
    char: u8 = 0,
    keyValuePair: ?KeyValuePair = null,
    nullableDateTime: ?[]const u8 = null,
    nullableTimeSpan: ?[]const u8 = null,
    stringList: [][]const u8 = &.{},
    stringArray: [][]const u8 = &.{},
    stringMap: ?std.json.Value = null,
    intStringMap: ?std.json.Value = null,
    subType: ?SubType = null,
};

pub const AllCollectionTypes = struct {
    pub const ss_name = "AllCollectionTypes";
    pub const ss_verb = "POST";

    intArray: []i32 = &.{},
    intList: []i32 = &.{},
    stringArray: [][]const u8 = &.{},
    stringList: [][]const u8 = &.{},
    floatArray: []f32 = &.{},
    doubleList: []f64 = &.{},
    byteArray: ?[]const u8 = null,
    charArray: []u8 = &.{},
    decimalList: []f64 = &.{},
    pocoArray: []Poco = &.{},
    pocoList: []Poco = &.{},
    pocoLookup: ?std.json.Value = null,
    pocoLookupMap: ?std.json.Value = null,
};

pub const HelloAllTypesResponse = struct {
    result: ?[]const u8 = null,
    allTypes: ?AllTypes = null,
    allCollectionTypes: ?AllCollectionTypes = null,
};

pub const SubAllTypes = struct {
    id: i32 = 0,
    nullableId: ?i32 = null,
    byte: u8 = 0,
    short: i16 = 0,
    int: i32 = 0,
    long: i64 = 0,
    uShort: u16 = 0,
    uInt: u32 = 0,
    uLong: u64 = 0,
    float: f32 = 0,
    double: f64 = 0,
    decimal: f64 = 0,
    string: ?[]const u8 = null,
    dateTime: ?[]const u8 = null,
    timeSpan: ?[]const u8 = null,
    dateTimeOffset: ?[]const u8 = null,
    guid: ?[]const u8 = null,
    char: u8 = 0,
    keyValuePair: ?KeyValuePair = null,
    nullableDateTime: ?[]const u8 = null,
    nullableTimeSpan: ?[]const u8 = null,
    stringList: [][]const u8 = &.{},
    stringArray: [][]const u8 = &.{},
    stringMap: ?std.json.Value = null,
    intStringMap: ?std.json.Value = null,
    subType: ?SubType = null,
    hierarchy: i32 = 0,
};

pub const HelloDateTime = struct {
    pub const ss_name = "HelloDateTime";
    pub const ss_verb = "POST";

    dateTime: ?[]const u8 = null,
};

// @DataContract
pub const HelloWithDataContractResponse = struct {
    // @DataMember(Name="result", Order=1, IsRequired=true, EmitDefaultValue=false)
    result: ?[]const u8 = null,
};

/// Description on HelloWithDescriptionResponse type
pub const HelloWithDescriptionResponse = struct {
    result: ?[]const u8 = null,
};

pub const HelloWithInheritanceResponse = struct {
    refId: i32 = 0,
    result: ?[]const u8 = null,
};

pub const HelloWithAlternateReturnResponse = struct {
    result: ?[]const u8 = null,
    altResult: ?[]const u8 = null,
};

pub const HelloWithRouteResponse = struct {
    result: ?[]const u8 = null,
};

pub const HelloWithTypeResponse = struct {
    result: ?HelloType = null,
};

pub const HelloInnerTypesResponse = struct {
    innerType: ?InnerType = null,
    innerEnum: ?InnerEnum = null,
};

pub const HelloVerbResponse = struct {
    result: ?[]const u8 = null,
};

pub const EnumResponse = struct {
    operator: ?ScopeType = null,
};

// @Route("/hellotypes/{Name}")
pub const HelloTypes = struct {
    pub const ss_name = "HelloTypes";
    pub const ss_verb = "POST";

    string: ?[]const u8 = null,
    bool: bool = false,
    int: i32 = 0,
};

// @DataContract
pub const HelloZipResponse = struct {
    // @DataMember
    result: ?[]const u8 = null,
};

pub const PingResponse = struct {
    responses: ?std.json.Value = null,
    responseStatus: ?ss.ResponseStatus = null,
};

pub const RequiresRoleResponse = struct {
    result: ?[]const u8 = null,
    responseStatus: ?ss.ResponseStatus = null,
};

pub const SendVerbResponse = struct {
    id: i32 = 0,
    pathInfo: ?[]const u8 = null,
    requestMethod: ?[]const u8 = null,
};

pub const GetSessionResponse = struct {
    result: ?CustomUserSession = null,
    unAuthInfo: ?UnAuthInfo = null,
    responseStatus: ?ss.ResponseStatus = null,
};

// @DataContract(Namespace="http://schemas.servicestack.net/types")
pub const GetStuffResponse = struct {
    // @DataMember
    summaryDate: ?[]const u8 = null,

    // @DataMember
    summaryEndDate: ?[]const u8 = null,

    // @DataMember
    symbol: ?[]const u8 = null,

    // @DataMember
    email: ?[]const u8 = null,

    // @DataMember
    isEnabled: ?bool = null,
};

pub const StoreLogsResponse = struct {
    existingLogs: []Logger = &.{},
    responseStatus: ?ss.ResponseStatus = null,
};

pub const TestAuthResponse = struct {
    userId: ?[]const u8 = null,
    sessionId: ?[]const u8 = null,
    userName: ?[]const u8 = null,
    displayName: ?[]const u8 = null,
    responseStatus: ?ss.ResponseStatus = null,
};

pub const RequiresAdmin = struct {
    pub const ss_name = "RequiresAdmin";
    pub const ss_verb = "POST";

    id: i32 = 0,
};

// @Route("/custom")
// @Route("/custom/{Data}")
pub const CustomRoute = struct {
    pub const ss_name = "CustomRoute";
    pub const ss_verb = "POST";

    data: ?[]const u8 = null,
};

// @Route("/wait/{ForMs}")
pub const Wait = struct {
    pub const ss_name = "Wait";
    pub const ss_verb = "POST";

    forMs: i32 = 0,
};

// @Route("/echo/types")
pub const EchoTypes = struct {
    pub const ss_name = "EchoTypes";
    pub const ss_verb = "POST";

    byte: u8 = 0,
    short: i16 = 0,
    int: i32 = 0,
    long: i64 = 0,
    uShort: u16 = 0,
    uInt: u32 = 0,
    uLong: u64 = 0,
    float: f32 = 0,
    double: f64 = 0,
    decimal: f64 = 0,
    string: ?[]const u8 = null,
    dateTime: ?[]const u8 = null,
    timeSpan: ?[]const u8 = null,
    dateTimeOffset: ?[]const u8 = null,
    guid: ?[]const u8 = null,
    char: u8 = 0,
};

// @Route("/echo/collections")
pub const EchoCollections = struct {
    pub const ss_name = "EchoCollections";
    pub const ss_verb = "POST";

    stringList: ?[][]const u8 = null,
    stringArray: ?[][]const u8 = null,
    stringMap: ?std.json.Value = null,
    intStringMap: ?std.json.Value = null,
};

// @Route("/echo/complex")
pub const EchoComplexTypes = struct {
    pub const ss_name = "EchoComplexTypes";
    pub const ss_verb = "POST";

    subType: ?SubType = null,
    subTypes: ?[]SubType = null,
    subTypeMap: ?std.json.Value = null,
    stringMap: ?std.json.Value = null,
    intStringMap: ?std.json.Value = null,
};

// @Route("/rockstars", "POST")
pub const StoreRockstars = struct {
    pub const ss_name = "StoreRockstars";
    pub const ss_verb = "POST";
    pub const ss_collection = "items";

    items: []Rockstar = &.{},
};

// @DataContract
pub const ChatResponse = struct {
    /// A unique identifier for the chat completion.
    // @DataMember(Name="id")
    id: ?[]const u8 = null,

    /// A list of chat completion choices. Can be more than one if n is greater than 1.
    // @DataMember(Name="choices")
    choices: []Choice = &.{},

    /// The Unix timestamp (in seconds) of when the chat completion was created.
    // @DataMember(Name="created")
    created: i64 = 0,

    /// The model used for the chat completion.
    // @DataMember(Name="model")
    model: ?[]const u8 = null,

    /// This fingerprint represents the backend configuration that the model runs with.
    // @DataMember(Name="system_fingerprint")
    system_fingerprint: ?[]const u8 = null,

    /// The object type, which is always chat.completion.
    // @DataMember(Name="object")
    object: ?[]const u8 = null,

    /// Specifies the processing type used for serving the request.
    // @DataMember(Name="service_tier")
    service_tier: ?[]const u8 = null,

    /// Usage statistics for the completion request.
    // @DataMember(Name="usage")
    usage: ?AiUsage = null,

    /// The provider used for the chat completion.
    // @DataMember(Name="provider")
    provider: ?[]const u8 = null,

    /// Total cost of the completion in USD, accumulated across every request in the tool loop.
    // @DataMember(Name="cost")
    cost: ?f64 = null,

    /// The assistant and tool messages exchanged during the tool-execution loop, in order.
    // @DataMember(Name="tool_history")
    tool_history: ?[]ChoiceMessage = null,

    /// Set of 16 key-value pairs that can be attached to an object. This can be useful for storing additional information about the object in a structured format.
    // @DataMember(Name="metadata")
    metadata: ?std.json.Value = null,

    // @DataMember(Name="responseStatus")
    responseStatus: ?ss.ResponseStatus = null,
};

pub const RockstarWithIdResponse = struct {
    id: i32 = 0,
    responseStatus: ?ss.ResponseStatus = null,
};

pub const RockstarWithIdAndResultResponse = struct {
    id: i32 = 0,
    result: ?RockstarAuto = null,
    responseStatus: ?ss.ResponseStatus = null,
};

pub const RockstarWithIdAndCountResponse = struct {
    id: i32 = 0,
    count: i32 = 0,
    responseStatus: ?ss.ResponseStatus = null,
};

pub const RockstarWithIdAndRowVersionResponse = struct {
    id: i32 = 0,
    rowVersion: u32 = 0,
    responseStatus: ?ss.ResponseStatus = null,
};

pub const QueryItems = struct {
    pub const ss_name = "QueryItems";
    pub const ss_verb = "GET";
    pub const Response = ss.QueryResponse(Poco);

    // @DataMember(Order=1)
    skip: ?i32 = null,

    // @DataMember(Order=2)
    take: ?i32 = null,

    // @DataMember(Order=3)
    orderBy: ?[]const u8 = null,

    // @DataMember(Order=4)
    orderByDesc: ?[]const u8 = null,

    // @DataMember(Order=5)
    include: ?[]const u8 = null,

    // @DataMember(Order=6)
    fields: ?[]const u8 = null,

    // @DataMember(Order=7)
    meta: ?std.json.Value = null,
};

// @Route("/channels/{Channel}/raw")
pub const PostRawToChannel = struct {
    pub const ss_name = "PostRawToChannel";
    pub const ss_verb = "POST";

    from: ?[]const u8 = null,
    toUserId: ?[]const u8 = null,
    channel: ?[]const u8 = null,
    message: ?[]const u8 = null,
    selector: ?[]const u8 = null,
};

// @Route("/channels/{Channel}/chat")
pub const PostChatToChannel = struct {
    pub const ss_name = "PostChatToChannel";
    pub const ss_verb = "POST";
    pub const Response = ChatMessage;

    from: ?[]const u8 = null,
    toUserId: ?[]const u8 = null,
    channel: ?[]const u8 = null,
    message: ?[]const u8 = null,
    selector: ?[]const u8 = null,
};

// @Route("/chathistory")
pub const GetChatHistory = struct {
    pub const ss_name = "GetChatHistory";
    pub const ss_verb = "POST";
    pub const Response = GetChatHistoryResponse;

    channels: ?[][]const u8 = null,
    afterId: ?i64 = null,
    take: ?i32 = null,
};

// @Route("/reset")
pub const ClearChatHistory = struct {
    pub const ss_name = "ClearChatHistory";
    pub const ss_verb = "POST";
};

// @Route("/reset-serverevents")
pub const ResetServerEvents = struct {
    pub const ss_name = "ResetServerEvents";
    pub const ss_verb = "POST";
};

// @Route("/channels/{Channel}/object")
pub const PostObjectToChannel = struct {
    pub const ss_name = "PostObjectToChannel";
    pub const ss_verb = "POST";

    toUserId: ?[]const u8 = null,
    channel: ?[]const u8 = null,
    selector: ?[]const u8 = null,
    customType: ?CustomType = null,
    setterType: ?SetterType = null,
};

// @Route("/account")
pub const GetUserDetails = struct {
    pub const ss_name = "GetUserDetails";
    pub const ss_verb = "GET";
    pub const Response = GetUserDetailsResponse;
};

pub const CustomHttpError = struct {
    pub const ss_name = "CustomHttpError";
    pub const ss_verb = "POST";
    pub const Response = CustomHttpErrorResponse;

    statusCode: i32 = 0,
    statusDescription: ?[]const u8 = null,
};

pub const AltQueryItems = struct {
    pub const ss_name = "AltQueryItems";
    pub const ss_verb = "POST";
    pub const Response = QueryResponseAlt;

    name: ?[]const u8 = null,
};

pub const GetItems = struct {
    pub const ss_name = "GetItems";
    pub const ss_verb = "GET";
    pub const Response = Items;
};

pub const GetNakedItems = struct {
    pub const ss_name = "GetNakedItems";
    pub const ss_verb = "GET";
    pub const Response = []Item;
};

// @ValidateRequest(Validator="IsAuthenticated")
pub const DeclarativeValidationAuth = struct {
    pub const ss_name = "DeclarativeValidationAuth";
    pub const ss_verb = "POST";

    name: ?[]const u8 = null,
};

pub const DeclarativeCollectiveValidationTest = struct {
    pub const ss_name = "DeclarativeCollectiveValidationTest";
    pub const ss_verb = "POST";
    pub const Response = ss.EmptyResponse;

    // @Validate(Validator="NotEmpty")
    // @Validate(Validator="MaximumLength(20)")
    site: ?[]const u8 = null,

    declarativeValidations: []DeclarativeChildValidation = &.{},
    fluentValidations: []FluentChildValidation = &.{},
};

pub const DeclarativeSingleValidationTest = struct {
    pub const ss_name = "DeclarativeSingleValidationTest";
    pub const ss_verb = "POST";
    pub const Response = ss.EmptyResponse;

    // @Validate(Validator="NotEmpty")
    // @Validate(Validator="MaximumLength(20)")
    site: ?[]const u8 = null,

    declarativeSingleValidation: ?DeclarativeSingleValidation = null,
    fluentSingleValidation: ?FluentSingleValidation = null,
};

pub const DummyTypes = struct {
    pub const ss_name = "DummyTypes";
    pub const ss_verb = "POST";

    helloResponses: ?[]HelloResponse = null,
    listResult: ?[]ListResult = null,
    arrayResult: ?[]ArrayResult = null,
    cancelRequest: ?CancelRequest = null,
    cancelRequestResponse: ?CancelRequestResponse = null,
    updateEventSubscriber: ?UpdateEventSubscriber = null,
    updateEventSubscriberResponse: ?UpdateEventSubscriberResponse = null,
    getApiKeys: ?ss.GetApiKeys = null,
    getApiKeysResponse: ?ss.GetApiKeysResponse = null,
    regenerateApiKeys: ?ss.RegenerateApiKeys = null,
    regenerateApiKeysResponse: ?ss.RegenerateApiKeysResponse = null,
    userApiKey: ?ss.UserApiKey = null,
    convertSessionToToken: ?ss.ConvertSessionToToken = null,
    convertSessionToTokenResponse: ?ss.ConvertSessionToTokenResponse = null,
    getAccessToken: ?ss.GetAccessToken = null,
    getAccessTokenResponse: ?ss.GetAccessTokenResponse = null,
    navItem: ?NavItem = null,
    getNavItems: ?GetNavItems = null,
    getNavItemsResponse: ?GetNavItemsResponse = null,
    emptyResponse: ?ss.EmptyResponse = null,
    idResponse: ?ss.IdResponse = null,
    stringResponse: ?ss.StringResponse = null,
    stringsResponse: ?ss.StringsResponse = null,
    auditBase: ?std.json.Value = null,
};

// @Route("/throwhttperror/{Status}")
pub const ThrowHttpError = struct {
    pub const ss_name = "ThrowHttpError";
    pub const ss_verb = "POST";

    status: ?i32 = null,
    message: ?[]const u8 = null,
};

// @Route("/throw404")
// @Route("/throw404/{Message}")
pub const Throw404 = struct {
    pub const ss_name = "Throw404";
    pub const ss_verb = "POST";

    message: ?[]const u8 = null,
};

// @Route("/throwcustom400")
// @Route("/throwcustom400/{Message}")
pub const ThrowCustom400 = struct {
    pub const ss_name = "ThrowCustom400";
    pub const ss_verb = "POST";

    message: ?[]const u8 = null,
};

// @Route("/returncustom400")
// @Route("/returncustom400/{Message}")
pub const ReturnCustom400 = struct {
    pub const ss_name = "ReturnCustom400";
    pub const ss_verb = "POST";
    pub const Response = ReturnCustom400Response;

    message: ?[]const u8 = null,
};

// @Route("/throw/{Type}")
pub const ThrowType = struct {
    pub const ss_name = "ThrowType";
    pub const ss_verb = "POST";
    pub const Response = ThrowTypeResponse;

    type: ?[]const u8 = null,
    message: ?[]const u8 = null,
};

// @Route("/throwvalidation")
pub const ThrowValidation = struct {
    pub const ss_name = "ThrowValidation";
    pub const ss_verb = "POST";
    pub const Response = ThrowValidationResponse;

    age: i32 = 0,
    required: ?[]const u8 = null,
    email: ?[]const u8 = null,
};

// @Route("/throwbusinesserror")
pub const ThrowBusinessError = struct {
    pub const ss_name = "ThrowBusinessError";
    pub const ss_verb = "POST";
    pub const Response = ThrowBusinessErrorResponse;
};

/// Convert speech to text
// @Api(Description="Convert speech to text")
pub const SpeechToText = struct {
    pub const ss_name = "SpeechToText";
    pub const ss_verb = "POST";
    pub const Response = TextGenerationResponse;

    /// The audio stream containing the speech to be transcribed
    // @ApiMember(Description="The audio stream containing the speech to be transcribed")
    // @Required()
    audio: ?[]const u8 = null,

    /// Optional client-provided identifier for the request
    // @ApiMember(Description="Optional client-provided identifier for the request")
    refId: ?[]const u8 = null,

    /// Tag to identify the request
    // @ApiMember(Description="Tag to identify the request")
    tag: ?[]const u8 = null,
};

pub const TestFileUploads = struct {
    pub const ss_name = "TestFileUploads";
    pub const ss_verb = "POST";
    pub const Response = TestFileUploadsResponse;

    id: ?i32 = null,
    refId: ?[]const u8 = null,
};

pub const RootPathRoutes = struct {
    pub const ss_name = "RootPathRoutes";
    pub const ss_verb = "POST";

    path: ?[]const u8 = null,
};

pub const GetAccount = struct {
    pub const ss_name = "GetAccount";
    pub const ss_verb = "POST";
    pub const Response = Account;

    account: ?[]const u8 = null,
};

pub const GetProject = struct {
    pub const ss_name = "GetProject";
    pub const ss_verb = "POST";
    pub const Response = Project;

    account: ?[]const u8 = null,
    project: ?[]const u8 = null,
};

// @Route("/image-stream")
pub const ImageAsStream = struct {
    pub const ss_name = "ImageAsStream";
    pub const ss_verb = "POST";
    pub const Response = []const u8;

    format: ?[]const u8 = null,
};

// @Route("/image-bytes")
pub const ImageAsBytes = struct {
    pub const ss_name = "ImageAsBytes";
    pub const ss_verb = "POST";
    pub const Response = []const u8;

    format: ?[]const u8 = null,
};

// @Route("/image-custom")
pub const ImageAsCustomResult = struct {
    pub const ss_name = "ImageAsCustomResult";
    pub const ss_verb = "POST";
    pub const Response = []const u8;

    format: ?[]const u8 = null,
};

// @Route("/image-response")
pub const ImageWriteToResponse = struct {
    pub const ss_name = "ImageWriteToResponse";
    pub const ss_verb = "POST";
    pub const Response = []const u8;

    format: ?[]const u8 = null,
};

// @Route("/image-file")
pub const ImageAsFile = struct {
    pub const ss_name = "ImageAsFile";
    pub const ss_verb = "POST";
    pub const Response = []const u8;

    format: ?[]const u8 = null,
};

// @Route("/image-redirect")
pub const ImageAsRedirect = struct {
    pub const ss_name = "ImageAsRedirect";
    pub const ss_verb = "POST";

    format: ?[]const u8 = null,
};

// @Route("/hello-image/{Name}")
pub const HelloImage = struct {
    pub const ss_name = "HelloImage";
    pub const ss_verb = "GET";
    pub const Response = []const u8;

    name: ?[]const u8 = null,
    format: ?[]const u8 = null,
    width: ?i32 = null,
    height: ?i32 = null,
    fontSize: ?i32 = null,
    fontFamily: ?[]const u8 = null,
    foreground: ?[]const u8 = null,
    background: ?[]const u8 = null,
};

// @Route("/secured")
// @ValidateRequest(Validator="IsAuthenticated")
pub const Secured = struct {
    pub const ss_name = "Secured";
    pub const ss_verb = "POST";
    pub const Response = SecuredResponse;

    name: ?[]const u8 = null,
};

// @Route("/jwt")
pub const CreateJwt = struct {
    pub const ss_name = "CreateJwt";
    pub const ss_verb = "POST";
    pub const Response = CreateJwtResponse;

    // @DataMember(Order=1)
    referrerUrl: ?[]const u8 = null,

    // @DataMember(Order=2)
    id: ?[]const u8 = null,

    // @DataMember(Order=3)
    userAuthId: ?[]const u8 = null,

    // @DataMember(Order=4)
    userAuthName: ?[]const u8 = null,

    // @DataMember(Order=5)
    userName: ?[]const u8 = null,

    // @DataMember(Order=6)
    twitterUserId: ?[]const u8 = null,

    // @DataMember(Order=7)
    twitterScreenName: ?[]const u8 = null,

    // @DataMember(Order=8)
    facebookUserId: ?[]const u8 = null,

    // @DataMember(Order=9)
    facebookUserName: ?[]const u8 = null,

    // @DataMember(Order=10)
    firstName: ?[]const u8 = null,

    // @DataMember(Order=11)
    lastName: ?[]const u8 = null,

    // @DataMember(Order=12)
    displayName: ?[]const u8 = null,

    // @DataMember(Order=13)
    company: ?[]const u8 = null,

    // @DataMember(Order=14)
    email: ?[]const u8 = null,

    // @DataMember(Order=15)
    primaryEmail: ?[]const u8 = null,

    // @DataMember(Order=16)
    phoneNumber: ?[]const u8 = null,

    // @DataMember(Order=17)
    birthDate: ?[]const u8 = null,

    // @DataMember(Order=18)
    birthDateRaw: ?[]const u8 = null,

    // @DataMember(Order=19)
    address: ?[]const u8 = null,

    // @DataMember(Order=20)
    address2: ?[]const u8 = null,

    // @DataMember(Order=21)
    city: ?[]const u8 = null,

    // @DataMember(Order=22)
    state: ?[]const u8 = null,

    // @DataMember(Order=23)
    country: ?[]const u8 = null,

    // @DataMember(Order=24)
    culture: ?[]const u8 = null,

    // @DataMember(Order=25)
    fullName: ?[]const u8 = null,

    // @DataMember(Order=26)
    gender: ?[]const u8 = null,

    // @DataMember(Order=27)
    language: ?[]const u8 = null,

    // @DataMember(Order=28)
    mailAddress: ?[]const u8 = null,

    // @DataMember(Order=29)
    nickname: ?[]const u8 = null,

    // @DataMember(Order=30)
    postalCode: ?[]const u8 = null,

    // @DataMember(Order=31)
    timeZone: ?[]const u8 = null,

    // @DataMember(Order=32)
    requestTokenSecret: ?[]const u8 = null,

    // @DataMember(Order=33)
    createdAt: ?[]const u8 = null,

    // @DataMember(Order=34)
    lastModified: ?[]const u8 = null,

    // @DataMember(Order=35)
    roles: ?[][]const u8 = null,

    // @DataMember(Order=36)
    permissions: ?[][]const u8 = null,

    // @DataMember(Order=37)
    isAuthenticated: bool = false,

    // @DataMember(Order=38)
    fromToken: bool = false,

    // @DataMember(Order=39)
    profileUrl: ?[]const u8 = null,

    // @DataMember(Order=40)
    sequence: ?[]const u8 = null,

    // @DataMember(Order=41)
    tag: i64 = 0,

    // @DataMember(Order=42)
    authProvider: ?[]const u8 = null,

    // @DataMember(Order=43)
    providerOAuthAccess: ?[]std.json.Value = null,

    // @DataMember(Order=44)
    meta: ?std.json.Value = null,

    // @DataMember(Order=45)
    audiences: ?[][]const u8 = null,

    // @DataMember(Order=46)
    scopes: ?[][]const u8 = null,

    // @DataMember(Order=47)
    dns: ?[]const u8 = null,

    // @DataMember(Order=48)
    rsa: ?[]const u8 = null,

    // @DataMember(Order=49)
    sid: ?[]const u8 = null,

    // @DataMember(Order=50)
    hash: ?[]const u8 = null,

    // @DataMember(Order=51)
    homePhone: ?[]const u8 = null,

    // @DataMember(Order=52)
    mobilePhone: ?[]const u8 = null,

    // @DataMember(Order=53)
    webpage: ?[]const u8 = null,

    // @DataMember(Order=54)
    emailConfirmed: ?bool = null,

    // @DataMember(Order=55)
    phoneNumberConfirmed: ?bool = null,

    // @DataMember(Order=56)
    twoFactorEnabled: ?bool = null,

    // @DataMember(Order=57)
    securityStamp: ?[]const u8 = null,

    // @DataMember(Order=58)
    type: ?[]const u8 = null,

    // @DataMember(Order=59)
    recoveryToken: ?[]const u8 = null,

    // @DataMember(Order=60)
    refId: ?i32 = null,

    // @DataMember(Order=61)
    refIdStr: ?[]const u8 = null,
    jwtExpiry: ?[]const u8 = null,
};

// @Route("/jwt-refresh")
pub const CreateRefreshJwt = struct {
    pub const ss_name = "CreateRefreshJwt";
    pub const ss_verb = "POST";
    pub const Response = CreateRefreshJwtResponse;

    userAuthId: ?[]const u8 = null,
    jwtExpiry: ?[]const u8 = null,
};

// @Route("/jwt-invalidate")
pub const InvalidateLastAccessToken = struct {
    pub const ss_name = "InvalidateLastAccessToken";
    pub const ss_verb = "POST";
    pub const Response = ss.EmptyResponse;
};

// @Route("/logs")
pub const ViewLogs = struct {
    pub const ss_name = "ViewLogs";
    pub const ss_verb = "POST";
    pub const Response = []const u8;

    clear: bool = false,
};

// @Route("/metadatatest")
pub const MetadataTest = struct {
    pub const ss_name = "MetadataTest";
    pub const ss_verb = "POST";
    pub const Response = MetadataTestResponse;

    id: i32 = 0,
};

// @Route("/metadatatest-array")
pub const MetadataTestArray = struct {
    pub const ss_name = "MetadataTestArray";
    pub const ss_verb = "POST";
    pub const Response = []MetadataTestChild;

    id: i32 = 0,
};

// @Route("/example", "GET")
// @DataContract
pub const GetExample = struct {
    pub const ss_name = "GetExample";
    pub const ss_verb = "GET";
    pub const Response = GetExampleResponse;
};

// @Route("/messages/{Id}", "GET")
pub const RequestMessage = struct {
    pub const ss_name = "RequestMessage";
    pub const ss_verb = "GET";
    pub const Response = Message;

    id: i32 = 0,
};

// @Route("/randomids")
pub const GetRandomIds = struct {
    pub const ss_name = "GetRandomIds";
    pub const ss_verb = "POST";
    pub const Response = GetRandomIdsResponse;

    take: ?i32 = null,
};

// @Route("/textfile-test")
pub const TextFileTest = struct {
    pub const ss_name = "TextFileTest";
    pub const ss_verb = "POST";

    asAttachment: bool = false,
};

// @Route("/return/text")
pub const ReturnText = struct {
    pub const ss_name = "ReturnText";
    pub const ss_verb = "POST";

    text: ?[]const u8 = null,
};

// @Route("/return/html")
pub const ReturnHtml = struct {
    pub const ss_name = "ReturnHtml";
    pub const ss_verb = "POST";

    text: ?[]const u8 = null,
};

// @Route("/hello")
// @Route("/hello/{Name}")
pub const Hello = struct {
    pub const ss_name = "Hello";
    pub const ss_verb = "POST";
    pub const Response = HelloResponse;

    // @Required()
    name: ?[]const u8 = null,

    title: ?[]const u8 = null,
};

// @Route("/hello-secure/{Name}")
// @ValidateRequest(Validator="IsAuthenticated")
pub const HelloSecure = struct {
    pub const ss_name = "HelloSecure";
    pub const ss_verb = "POST";
    pub const Response = HelloResponse;

    name: ?[]const u8 = null,
};

pub const HelloWithNestedClass = struct {
    pub const ss_name = "HelloWithNestedClass";
    pub const ss_verb = "GET";
    pub const Response = HelloResponse;

    name: ?[]const u8 = null,
    nestedClassProp: ?NestedClass = null,
};

pub const HelloList = struct {
    pub const ss_name = "HelloList";
    pub const ss_verb = "POST";
    pub const Response = []ListResult;

    names: [][]const u8 = &.{},
};

pub const HelloArray = struct {
    pub const ss_name = "HelloArray";
    pub const ss_verb = "POST";
    pub const Response = []ArrayResult;

    names: [][]const u8 = &.{},
};

pub const HelloMap = struct {
    pub const ss_name = "HelloMap";
    pub const ss_verb = "POST";
    pub const Response = std.json.Value;

    names: [][]const u8 = &.{},
};

pub const HelloQueryResponse = struct {
    pub const ss_name = "HelloQueryResponse";
    pub const ss_verb = "POST";
    pub const Response = ss.QueryResponse([]const u8);

    names: [][]const u8 = &.{},
};

pub const HelloWithEnum = struct {
    pub const ss_name = "HelloWithEnum";
    pub const ss_verb = "POST";

    enumProp: ?EnumType = null,
    enumTypeFlags: ?EnumTypeFlags = null,
    enumWithValues: ?EnumWithValues = null,
    nullableEnumProp: ?EnumType = null,
    enumFlags: ?EnumFlags = null,
    enumAsInt: ?EnumAsInt = null,
    enumStyle: ?EnumStyle = null,
    enumStyleMembers: ?EnumStyleMembers = null,
};

pub const HelloWithEnumList = struct {
    pub const ss_name = "HelloWithEnumList";
    pub const ss_verb = "POST";

    enumProp: []EnumType = &.{},
    enumWithValues: []EnumWithValues = &.{},
    nullableEnumProp: []?EnumType = &.{},
    enumFlags: []EnumFlags = &.{},
    enumStyle: []EnumStyle = &.{},
};

pub const HelloWithEnumMap = struct {
    pub const ss_name = "HelloWithEnumMap";
    pub const ss_verb = "POST";

    enumProp: ?std.json.Value = null,
    enumWithValues: ?std.json.Value = null,
    nullableEnumProp: ?std.json.Value = null,
    enumFlags: ?std.json.Value = null,
    enumStyle: ?std.json.Value = null,
};

pub const HelloExternal = struct {
    pub const ss_name = "HelloExternal";
    pub const ss_verb = "POST";

    name: ?[]const u8 = null,
};

/// AllowedAttributes Description
// @Route("/allowed-attributes", "GET")
// @Api(Description="AllowedAttributes Description")
// @ApiResponse(Description="Your request was not understood", StatusCode=400)
// @DataContract
pub const AllowedAttributes = struct {
    pub const ss_name = "AllowedAttributes";
    pub const ss_verb = "GET";

    /// Range Description
    // @DataMember(Name="Aliased")
    // @ApiMember(DataType="double", Description="Range Description", IsRequired=true, ParameterType="path")
    Aliased: f64 = 0,
};

// @Route("/all-types")
pub const HelloAllTypes = struct {
    pub const ss_name = "HelloAllTypes";
    pub const ss_verb = "POST";
    pub const Response = HelloAllTypesResponse;

    name: ?[]const u8 = null,
    allTypes: ?AllTypes = null,
    allCollectionTypes: ?AllCollectionTypes = null,
};

pub const HelloSubAllTypes = struct {
    pub const ss_name = "HelloSubAllTypes";
    pub const ss_verb = "POST";
    pub const Response = SubAllTypes;

    id: i32 = 0,
    nullableId: ?i32 = null,
    byte: u8 = 0,
    short: i16 = 0,
    int: i32 = 0,
    long: i64 = 0,
    uShort: u16 = 0,
    uInt: u32 = 0,
    uLong: u64 = 0,
    float: f32 = 0,
    double: f64 = 0,
    decimal: f64 = 0,
    string: ?[]const u8 = null,
    dateTime: ?[]const u8 = null,
    timeSpan: ?[]const u8 = null,
    dateTimeOffset: ?[]const u8 = null,
    guid: ?[]const u8 = null,
    char: u8 = 0,
    keyValuePair: ?KeyValuePair = null,
    nullableDateTime: ?[]const u8 = null,
    nullableTimeSpan: ?[]const u8 = null,
    stringList: [][]const u8 = &.{},
    stringArray: [][]const u8 = &.{},
    stringMap: ?std.json.Value = null,
    intStringMap: ?std.json.Value = null,
    subType: ?SubType = null,
    hierarchy: i32 = 0,
};

pub const HelloString = struct {
    pub const ss_name = "HelloString";
    pub const ss_verb = "POST";
    pub const Response = []const u8;

    name: ?[]const u8 = null,
};

pub const HelloVoid = struct {
    pub const ss_name = "HelloVoid";
    pub const ss_verb = "POST";

    name: ?[]const u8 = null,
};

// @DataContract
pub const HelloWithDataContract = struct {
    pub const ss_name = "HelloWithDataContract";
    pub const ss_verb = "POST";
    pub const Response = HelloWithDataContractResponse;

    // @DataMember(Name="name", Order=1, IsRequired=true, EmitDefaultValue=false)
    name: ?[]const u8 = null,

    // @DataMember(Name="id", Order=2, EmitDefaultValue=false)
    id: i32 = 0,
};

/// Description on HelloWithDescription type
pub const HelloWithDescription = struct {
    pub const ss_name = "HelloWithDescription";
    pub const ss_verb = "POST";
    pub const Response = HelloWithDescriptionResponse;

    name: ?[]const u8 = null,
};

pub const HelloWithInheritance = struct {
    pub const ss_name = "HelloWithInheritance";
    pub const ss_verb = "POST";
    pub const Response = HelloWithInheritanceResponse;

    id: i32 = 0,
    name: ?[]const u8 = null,
};

pub const HelloWithGenericInheritance = struct {
    pub const ss_name = "HelloWithGenericInheritance";
    pub const ss_verb = "POST";

    items: []Poco = &.{},
    counts: []i32 = &.{},
    result: ?[]const u8 = null,
};

pub const HelloWithGenericInheritance2 = struct {
    pub const ss_name = "HelloWithGenericInheritance2";
    pub const ss_verb = "POST";

    items: []Hello = &.{},
    counts: []i32 = &.{},
    result: ?[]const u8 = null,
};

pub const HelloWithReturn = struct {
    pub const ss_name = "HelloWithReturn";
    pub const ss_verb = "POST";
    pub const Response = HelloWithAlternateReturnResponse;

    name: ?[]const u8 = null,
};

// @Route("/helloroute")
pub const HelloWithRoute = struct {
    pub const ss_name = "HelloWithRoute";
    pub const ss_verb = "POST";
    pub const Response = HelloWithRouteResponse;

    name: ?[]const u8 = null,
};

pub const HelloWithType = struct {
    pub const ss_name = "HelloWithType";
    pub const ss_verb = "POST";
    pub const Response = HelloWithTypeResponse;

    name: ?[]const u8 = null,
};

pub const HelloInterface = struct {
    pub const ss_name = "HelloInterface";
    pub const ss_verb = "POST";

    poco: ?std.json.Value = null,
    emptyInterface: ?std.json.Value = null,
    emptyClass: ?EmptyClass = null,
};

pub const HelloInnerTypes = struct {
    pub const ss_name = "HelloInnerTypes";
    pub const ss_verb = "POST";
    pub const Response = HelloInnerTypesResponse;
};

pub const HelloBuiltin = struct {
    pub const ss_name = "HelloBuiltin";
    pub const ss_verb = "POST";

    dayOfWeek: ?DayOfWeek = null,
};

pub const HelloGet = struct {
    pub const ss_name = "HelloGet";
    pub const ss_verb = "GET";
    pub const Response = HelloVerbResponse;

    id: i32 = 0,
};

pub const HelloPost = struct {
    pub const ss_name = "HelloPost";
    pub const ss_verb = "POST";
    pub const Response = HelloVerbResponse;

    id: i32 = 0,
};

pub const HelloPut = struct {
    pub const ss_name = "HelloPut";
    pub const ss_verb = "PUT";
    pub const Response = HelloVerbResponse;

    id: i32 = 0,
};

pub const HelloDelete = struct {
    pub const ss_name = "HelloDelete";
    pub const ss_verb = "DELETE";
    pub const Response = HelloVerbResponse;

    id: i32 = 0,
};

pub const HelloPatch = struct {
    pub const ss_name = "HelloPatch";
    pub const ss_verb = "PATCH";
    pub const Response = HelloVerbResponse;

    id: i32 = 0,
};

pub const HelloReturnVoid = struct {
    pub const ss_name = "HelloReturnVoid";
    pub const ss_verb = "POST";

    id: i32 = 0,
};

pub const EnumRequest = struct {
    pub const ss_name = "EnumRequest";
    pub const ss_verb = "PUT";
    pub const Response = EnumResponse;

    operator: ?ScopeType = null,
};

// @Route("/hellozip")
// @DataContract
pub const HelloZip = struct {
    pub const ss_name = "HelloZip";
    pub const ss_verb = "POST";
    pub const Response = HelloZipResponse;

    // @DataMember
    name: ?[]const u8 = null,

    // @DataMember
    @"test": [][]const u8 = &.{},
};

// @Route("/ping")
pub const Ping = struct {
    pub const ss_name = "Ping";
    pub const ss_verb = "POST";
    pub const Response = PingResponse;
};

// @Route("/reset-connections")
pub const ResetConnections = struct {
    pub const ss_name = "ResetConnections";
    pub const ss_verb = "POST";
};

// @Route("/requires-role")
pub const RequiresRole = struct {
    pub const ss_name = "RequiresRole";
    pub const ss_verb = "POST";
    pub const Response = RequiresRoleResponse;
};

// @Route("/return/string")
pub const ReturnString = struct {
    pub const ss_name = "ReturnString";
    pub const ss_verb = "POST";
    pub const Response = []const u8;

    data: ?[]const u8 = null,
};

// @Route("/return/bytes")
pub const ReturnBytes = struct {
    pub const ss_name = "ReturnBytes";
    pub const ss_verb = "POST";
    pub const Response = []const u8;

    data: ?[]const u8 = null,
};

// @Route("/return/stream")
pub const ReturnStream = struct {
    pub const ss_name = "ReturnStream";
    pub const ss_verb = "POST";
    pub const Response = []const u8;

    data: ?[]const u8 = null,
};

// @Route("/return/json")
pub const ReturnJson = struct {
    pub const ss_name = "ReturnJson";
    pub const ss_verb = "POST";
};

// @Route("/return/json/header")
pub const ReturnJsonHeader = struct {
    pub const ss_name = "ReturnJsonHeader";
    pub const ss_verb = "POST";
};

// @Route("/write/json")
pub const WriteJson = struct {
    pub const ss_name = "WriteJson";
    pub const ss_verb = "POST";
};

// @Route("/Request1", "GET")
pub const GetRequest1 = struct {
    pub const ss_name = "GetRequest1";
    pub const ss_verb = "GET";
    pub const Response = []ReturnedDto;
};

// @Route("/Request2", "GET")
pub const GetRequest2 = struct {
    pub const ss_name = "GetRequest2";
    pub const ss_verb = "GET";
    pub const Response = []ReturnedDto;
};

// @Route("/sendjson")
pub const SendJson = struct {
    pub const ss_name = "SendJson";
    pub const ss_verb = "POST";
    pub const Response = []const u8;

    id: i32 = 0,
    name: ?[]const u8 = null,
    requestStream: ?[]const u8 = null,
};

// @Route("/sendtext")
pub const SendText = struct {
    pub const ss_name = "SendText";
    pub const ss_verb = "POST";
    pub const Response = []const u8;

    id: i32 = 0,
    name: ?[]const u8 = null,
    contentType: ?[]const u8 = null,
    requestStream: ?[]const u8 = null,
};

// @Route("/sendraw")
pub const SendRaw = struct {
    pub const ss_name = "SendRaw";
    pub const ss_verb = "POST";
    pub const Response = []const u8;

    id: i32 = 0,
    name: ?[]const u8 = null,
    contentType: ?[]const u8 = null,
    requestStream: ?[]const u8 = null,
};

pub const SendDefault = struct {
    pub const ss_name = "SendDefault";
    pub const ss_verb = "POST";
    pub const Response = SendVerbResponse;

    id: i32 = 0,
};

// @Route("/sendrestget/{Id}", "GET")
pub const SendRestGet = struct {
    pub const ss_name = "SendRestGet";
    pub const ss_verb = "GET";
    pub const Response = SendVerbResponse;

    id: i32 = 0,
};

pub const SendGet = struct {
    pub const ss_name = "SendGet";
    pub const ss_verb = "GET";
    pub const Response = SendVerbResponse;

    id: i32 = 0,
};

pub const SendPost = struct {
    pub const ss_name = "SendPost";
    pub const ss_verb = "POST";
    pub const Response = SendVerbResponse;

    id: i32 = 0,
};

pub const SendPut = struct {
    pub const ss_name = "SendPut";
    pub const ss_verb = "PUT";
    pub const Response = SendVerbResponse;

    id: i32 = 0,
};

pub const SendReturnVoid = struct {
    pub const ss_name = "SendReturnVoid";
    pub const ss_verb = "POST";

    id: i32 = 0,
};

// @Route("/session")
pub const GetSession = struct {
    pub const ss_name = "GetSession";
    pub const ss_verb = "POST";
    pub const Response = GetSessionResponse;
};

// @Route("/session/edit/{CustomName}")
pub const UpdateSession = struct {
    pub const ss_name = "UpdateSession";
    pub const ss_verb = "POST";
    pub const Response = GetSessionResponse;

    customName: ?[]const u8 = null,
};

// @Route("/Stuff")
// @DataContract(Namespace="http://schemas.servicestack.net/types")
pub const GetStuff = struct {
    pub const ss_name = "GetStuff";
    pub const ss_verb = "POST";
    pub const Response = GetStuffResponse;

    // @DataMember
    // @ApiMember(DataType="DateTime", Name="Summary Date")
    summaryDate: ?[]const u8 = null,

    // @DataMember
    // @ApiMember(DataType="DateTime", Name="Summary End Date")
    summaryEndDate: ?[]const u8 = null,

    // @DataMember
    // @ApiMember(DataType="string", Name="Symbol")
    symbol: ?[]const u8 = null,

    // @DataMember
    // @ApiMember(DataType="string", Name="Email")
    email: ?[]const u8 = null,

    // @DataMember
    // @ApiMember(DataType="bool", Name="Is Enabled")
    isEnabled: ?bool = null,
};

pub const StoreLogs = struct {
    pub const ss_name = "StoreLogs";
    pub const ss_verb = "POST";
    pub const Response = StoreLogsResponse;

    loggers: []Logger = &.{},
};

pub const HelloAuth = struct {
    pub const ss_name = "HelloAuth";
    pub const ss_verb = "POST";
    pub const Response = HelloResponse;

    name: ?[]const u8 = null,
};

// @Route("/testauth")
pub const TestAuth = struct {
    pub const ss_name = "TestAuth";
    pub const ss_verb = "POST";
    pub const Response = TestAuthResponse;
};

// @Route("/testdata/AllTypes")
pub const TestDataAllTypes = struct {
    pub const ss_name = "TestDataAllTypes";
    pub const ss_verb = "POST";
    pub const Response = AllTypes;
};

// @Route("/testdata/AllCollectionTypes")
pub const TestDataAllCollectionTypes = struct {
    pub const ss_name = "TestDataAllCollectionTypes";
    pub const ss_verb = "POST";
    pub const Response = AllCollectionTypes;
};

// @Route("/void-response")
pub const TestVoidResponse = struct {
    pub const ss_name = "TestVoidResponse";
    pub const ss_verb = "POST";
};

// @Route("/null-response")
pub const TestNullResponse = struct {
    pub const ss_name = "TestNullResponse";
    pub const ss_verb = "POST";
};

/// Chat Completions API (OpenAI-Compatible)
// @Route("/v1/chat/completions", "POST")
// @DataContract
pub const ChatCompletion = struct {
    pub const ss_name = "ChatCompletion";
    pub const ss_verb = "POST";
    pub const Response = ChatResponse;

    /// The messages to generate chat completions for.
    // @DataMember(Name="messages")
    messages: []AiMessage = &.{},

    /// ID of the model to use. See the model endpoint compatibility table for details on which models work with the Chat API
    // @DataMember(Name="model")
    model: ?[]const u8 = null,

    /// Parameters for audio output. Required when audio output is requested with modalities: [audio]
    // @DataMember(Name="audio")
    audio: ?AiChatAudio = null,

    /// Modify the likelihood of specified tokens appearing in the completion.
    // @DataMember(Name="logit_bias")
    logit_bias: ?std.json.Value = null,

    /// Set of 16 key-value pairs that can be attached to an object. This can be useful for storing additional information about the object in a structured format.
    // @DataMember(Name="metadata")
    metadata: ?std.json.Value = null,

    /// Constrains effort on reasoning for reasoning models. Currently supported values are minimal, low, medium, and high (none, default). Reducing reasoning effort can result in faster responses and fewer tokens used on reasoning in a response.
    // @DataMember(Name="reasoning_effort")
    reasoning_effort: ?[]const u8 = null,

    /// An object specifying the format that the model must output. Compatible with GPT-4 Turbo and all GPT-3.5 Turbo models newer than `gpt-3.5-turbo-1106`. Setting Type to ResponseFormat.JsonObject enables JSON mode, which guarantees the message the model generates is valid JSON.
    // @DataMember(Name="response_format")
    response_format: ?AiResponseFormat = null,

    /// Specifies the processing type used for serving the request.
    // @DataMember(Name="service_tier")
    service_tier: ?[]const u8 = null,

    /// A stable identifier used to help detect users of your application that may be violating OpenAI's usage policies. The IDs should be a string that uniquely identifies each user.
    // @DataMember(Name="safety_identifier")
    safety_identifier: ?[]const u8 = null,

    /// Up to 4 sequences where the API will stop generating further tokens.
    // @DataMember(Name="stop")
    stop: ?[][]const u8 = null,

    /// Output types that you would like the model to generate. Most models are capable of generating text, which is the default:
    // @DataMember(Name="modalities")
    modalities: ?[][]const u8 = null,

    /// Used by OpenAI to cache responses for similar requests to optimize your cache hit rates.
    // @DataMember(Name="prompt_cache_key")
    prompt_cache_key: ?[]const u8 = null,

    /// A list of tools the model may call. Currently, only functions are supported as a tool. Use this to provide a list of functions the model may generate JSON inputs for. A max of 128 functions are supported.
    // @DataMember(Name="tools")
    tools: ?[]Tool = null,

    /// Constrains the verbosity of the model's response. Lower values will result in more concise responses, while higher values will result in more verbose responses. Currently supported values are low, medium, and high.
    // @DataMember(Name="verbosity")
    verbosity: ?[]const u8 = null,

    /// What sampling temperature to use, between 0 and 2. Higher values like 0.8 will make the output more random, while lower values like 0.2 will make it more focused and deterministic.
    // @DataMember(Name="temperature")
    temperature: ?f64 = null,

    /// An upper bound for the number of tokens that can be generated for a completion, including visible output tokens and reasoning tokens.
    // @DataMember(Name="max_completion_tokens")
    max_completion_tokens: ?i32 = null,

    /// An integer between 0 and 20 specifying the number of most likely tokens to return at each token position, each with an associated log probability. logprobs must be set to true if this parameter is used.
    // @DataMember(Name="top_logprobs")
    top_logprobs: ?i32 = null,

    /// An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of the tokens with top_p probability mass. So 0.1 means only the tokens comprising the top 10% probability mass are considered.
    // @DataMember(Name="top_p")
    top_p: ?f64 = null,

    /// Number between `-2.0` and `2.0`. Positive values penalize new tokens based on their existing frequency in the text so far, decreasing the model's likelihood to repeat the same line verbatim.
    // @DataMember(Name="frequency_penalty")
    frequency_penalty: ?f64 = null,

    /// Number between -2.0 and 2.0. Positive values penalize new tokens based on whether they appear in the text so far, increasing the model's likelihood to talk about new topics.
    // @DataMember(Name="presence_penalty")
    presence_penalty: ?f64 = null,

    /// This feature is in Beta. If specified, our system will make a best effort to sample deterministically, such that repeated requests with the same seed and parameters should return the same result. Determinism is not guaranteed, and you should refer to the system_fingerprint response parameter to monitor changes in the backend.
    // @DataMember(Name="seed")
    seed: ?i32 = null,

    /// How many chat completion choices to generate for each input message. Note that you will be charged based on the number of generated tokens across all of the choices. Keep `n` as `1` to minimize costs.
    // @DataMember(Name="n")
    n: ?i32 = null,

    /// Whether or not to store the output of this chat completion request for use in our model distillation or evals products.
    // @DataMember(Name="store")
    store: ?bool = null,

    /// Whether to return log probabilities of the output tokens or not. If true, returns the log probabilities of each output token returned in the content of message.
    // @DataMember(Name="logprobs")
    logprobs: ?bool = null,

    /// Whether to enable parallel function calling during tool use.
    // @DataMember(Name="parallel_tool_calls")
    parallel_tool_calls: ?bool = null,

    /// Whether to enable thinking mode for some Qwen models and providers.
    // @DataMember(Name="enable_thinking")
    enable_thinking: ?bool = null,

    /// If set, partial message deltas will be sent, like in ChatGPT. Tokens will be sent as data-only server-sent events as they become available, with the stream terminated by a `data: [DONE]` message.
    // @DataMember(Name="stream")
    stream: ?bool = null,
};

/// Find Bookings
// @Route("/bookings", "GET")
// @Route("/bookings/{Id}", "GET")
pub const QueryBookings = struct {
    pub const ss_name = "QueryBookings";
    pub const ss_verb = "GET";
    pub const Response = ss.QueryResponse(Booking);

    // @DataMember(Order=1)
    skip: ?i32 = null,

    // @DataMember(Order=2)
    take: ?i32 = null,

    // @DataMember(Order=3)
    orderBy: ?[]const u8 = null,

    // @DataMember(Order=4)
    orderByDesc: ?[]const u8 = null,

    // @DataMember(Order=5)
    include: ?[]const u8 = null,

    // @DataMember(Order=6)
    fields: ?[]const u8 = null,

    // @DataMember(Order=7)
    meta: ?std.json.Value = null,
    id: ?i32 = null,
};

/// Find Coupons
// @Route("/coupons", "GET")
pub const QueryCoupons = struct {
    pub const ss_name = "QueryCoupons";
    pub const ss_verb = "GET";
    pub const Response = ss.QueryResponse(Coupon);

    // @DataMember(Order=1)
    skip: ?i32 = null,

    // @DataMember(Order=2)
    take: ?i32 = null,

    // @DataMember(Order=3)
    orderBy: ?[]const u8 = null,

    // @DataMember(Order=4)
    orderByDesc: ?[]const u8 = null,

    // @DataMember(Order=5)
    include: ?[]const u8 = null,

    // @DataMember(Order=6)
    fields: ?[]const u8 = null,

    // @DataMember(Order=7)
    meta: ?std.json.Value = null,
    id: ?[]const u8 = null,
};

pub const QueryAddresses = struct {
    pub const ss_name = "QueryAddresses";
    pub const ss_verb = "GET";
    pub const Response = ss.QueryResponse(Address);

    // @DataMember(Order=1)
    skip: ?i32 = null,

    // @DataMember(Order=2)
    take: ?i32 = null,

    // @DataMember(Order=3)
    orderBy: ?[]const u8 = null,

    // @DataMember(Order=4)
    orderByDesc: ?[]const u8 = null,

    // @DataMember(Order=5)
    include: ?[]const u8 = null,

    // @DataMember(Order=6)
    fields: ?[]const u8 = null,

    // @DataMember(Order=7)
    meta: ?std.json.Value = null,
    ids: []i64 = &.{},
};

pub const QueryRockstarAudit = struct {
    pub const ss_name = "QueryRockstarAudit";
    pub const ss_verb = "GET";
    pub const Response = ss.QueryResponse(RockstarAuto);

    // @DataMember(Order=1)
    skip: ?i32 = null,

    // @DataMember(Order=2)
    take: ?i32 = null,

    // @DataMember(Order=3)
    orderBy: ?[]const u8 = null,

    // @DataMember(Order=4)
    orderByDesc: ?[]const u8 = null,

    // @DataMember(Order=5)
    include: ?[]const u8 = null,

    // @DataMember(Order=6)
    fields: ?[]const u8 = null,

    // @DataMember(Order=7)
    meta: ?std.json.Value = null,
    id: ?i32 = null,
};

pub const QueryRockstarAuditSubOr = struct {
    pub const ss_name = "QueryRockstarAuditSubOr";
    pub const ss_verb = "GET";
    pub const Response = ss.QueryResponse(RockstarAuto);

    // @DataMember(Order=1)
    skip: ?i32 = null,

    // @DataMember(Order=2)
    take: ?i32 = null,

    // @DataMember(Order=3)
    orderBy: ?[]const u8 = null,

    // @DataMember(Order=4)
    orderByDesc: ?[]const u8 = null,

    // @DataMember(Order=5)
    include: ?[]const u8 = null,

    // @DataMember(Order=6)
    fields: ?[]const u8 = null,

    // @DataMember(Order=7)
    meta: ?std.json.Value = null,
    firstNameStartsWith: ?[]const u8 = null,
    ageOlderThan: ?i32 = null,
};

pub const QueryPocoBase = struct {
    pub const ss_name = "QueryPocoBase";
    pub const ss_verb = "GET";
    pub const Response = ss.QueryResponse(OnlyDefinedInGenericType);

    // @DataMember(Order=1)
    skip: ?i32 = null,

    // @DataMember(Order=2)
    take: ?i32 = null,

    // @DataMember(Order=3)
    orderBy: ?[]const u8 = null,

    // @DataMember(Order=4)
    orderByDesc: ?[]const u8 = null,

    // @DataMember(Order=5)
    include: ?[]const u8 = null,

    // @DataMember(Order=6)
    fields: ?[]const u8 = null,

    // @DataMember(Order=7)
    meta: ?std.json.Value = null,
    id: i32 = 0,
};

pub const QueryPocoIntoBase = struct {
    pub const ss_name = "QueryPocoIntoBase";
    pub const ss_verb = "GET";
    pub const Response = ss.QueryResponse(OnlyDefinedInGenericTypeInto);

    // @DataMember(Order=1)
    skip: ?i32 = null,

    // @DataMember(Order=2)
    take: ?i32 = null,

    // @DataMember(Order=3)
    orderBy: ?[]const u8 = null,

    // @DataMember(Order=4)
    orderByDesc: ?[]const u8 = null,

    // @DataMember(Order=5)
    include: ?[]const u8 = null,

    // @DataMember(Order=6)
    fields: ?[]const u8 = null,

    // @DataMember(Order=7)
    meta: ?std.json.Value = null,
    id: i32 = 0,
};

// @Route("/message/query/{Id}", "GET")
pub const MessageQuery = struct {
    pub const ss_name = "MessageQuery";
    pub const ss_verb = "GET";
    pub const Response = ss.QueryResponse(MessageQuery);

    // @DataMember(Order=1)
    skip: ?i32 = null,

    // @DataMember(Order=2)
    take: ?i32 = null,

    // @DataMember(Order=3)
    orderBy: ?[]const u8 = null,

    // @DataMember(Order=4)
    orderByDesc: ?[]const u8 = null,

    // @DataMember(Order=5)
    include: ?[]const u8 = null,

    // @DataMember(Order=6)
    fields: ?[]const u8 = null,

    // @DataMember(Order=7)
    meta: ?std.json.Value = null,
    id: i32 = 0,
};

// @Route("/rockstars", "GET")
pub const QueryRockstars = struct {
    pub const ss_name = "QueryRockstars";
    pub const ss_verb = "GET";
    pub const Response = ss.QueryResponse(Rockstar);

    // @DataMember(Order=1)
    skip: ?i32 = null,

    // @DataMember(Order=2)
    take: ?i32 = null,

    // @DataMember(Order=3)
    orderBy: ?[]const u8 = null,

    // @DataMember(Order=4)
    orderByDesc: ?[]const u8 = null,

    // @DataMember(Order=5)
    include: ?[]const u8 = null,

    // @DataMember(Order=6)
    fields: ?[]const u8 = null,

    // @DataMember(Order=7)
    meta: ?std.json.Value = null,
};

/// Create a new Booking
// @Route("/bookings", "POST")
// @ValidateRequest(Validator="HasRole(`Employee`)")
pub const CreateBooking = struct {
    pub const ss_name = "CreateBooking";
    pub const ss_verb = "POST";
    pub const Response = ss.IdResponse;

    /// Name this Booking is for
    // @Validate(Validator="NotEmpty")
    name: ?[]const u8 = null,

    roomType: ?RoomType = null,
    // @Validate(Validator="GreaterThan(0)")
    roomNumber: i32 = 0,

    // @Validate(Validator="GreaterThan(0)")
    cost: f64 = 0,

    // @Required()
    bookingStartDate: ?[]const u8 = null,

    bookingEndDate: ?[]const u8 = null,
    notes: ?[]const u8 = null,
    couponId: ?[]const u8 = null,
    permanentAddressId: ?i64 = null,
    postalAddressId: ?i64 = null,
};

/// Update an existing Booking
// @Route("/booking/{Id}", "PATCH")
// @ValidateRequest(Validator="HasRole(`Employee`)")
// @ValidateRequest(Validator="HasRole(`Manager`)")
pub const UpdateBooking = struct {
    pub const ss_name = "UpdateBooking";
    pub const ss_verb = "PATCH";
    pub const Response = ss.IdResponse;

    id: i32 = 0,
    name: ?[]const u8 = null,
    roomType: ?RoomType = null,
    // @Validate(Validator="GreaterThan(0)")
    roomNumber: ?i32 = null,

    // @Validate(Validator="GreaterThan(0)")
    cost: ?f64 = null,

    bookingStartDate: ?[]const u8 = null,
    bookingEndDate: ?[]const u8 = null,
    notes: ?[]const u8 = null,
    couponId: ?[]const u8 = null,
    cancelled: ?bool = null,
    permanentAddressId: ?i64 = null,
    postalAddressId: ?i64 = null,
};

/// Delete a Booking
// @Route("/booking/{Id}", "DELETE")
pub const DeleteBooking = struct {
    pub const ss_name = "DeleteBooking";
    pub const ss_verb = "DELETE";

    id: i32 = 0,
};

// @Route("/coupons", "POST")
// @ValidateRequest(Validator="HasRole(`Employee`)")
pub const CreateCoupon = struct {
    pub const ss_name = "CreateCoupon";
    pub const ss_verb = "POST";
    pub const Response = ss.IdResponse;

    // @Validate(Validator="NotEmpty")
    id: ?[]const u8 = null,

    // @Validate(Validator="NotEmpty")
    description: ?[]const u8 = null,

    // @Validate(Validator="GreaterThan(0)")
    discount: i32 = 0,

    // @Validate(Validator="NotNull")
    expiryDate: ?[]const u8 = null,
};

// @Route("/coupons/{Id}", "PATCH")
// @ValidateRequest(Validator="HasRole(`Employee`)")
pub const UpdateCoupon = struct {
    pub const ss_name = "UpdateCoupon";
    pub const ss_verb = "PATCH";
    pub const Response = ss.IdResponse;

    id: ?[]const u8 = null,
    // @Validate(Validator="NotEmpty")
    description: ?[]const u8 = null,

    // @Validate(Validator="NotNull")
    // @Validate(Validator="GreaterThan(0)")
    discount: ?i32 = null,

    // @Validate(Validator="NotNull")
    expiryDate: ?[]const u8 = null,
};

/// Delete a Coupon
// @Route("/coupons/{Id}", "DELETE")
// @ValidateRequest(Validator="HasRole(`Manager`)")
pub const DeleteCoupon = struct {
    pub const ss_name = "DeleteCoupon";
    pub const ss_verb = "DELETE";

    id: ?[]const u8 = null,
};

pub const CreateAddress = struct {
    pub const ss_name = "CreateAddress";
    pub const ss_verb = "POST";
    pub const Response = ss.IdResponse;

    addressText: ?[]const u8 = null,
};

pub const UpdateAddress = struct {
    pub const ss_name = "UpdateAddress";
    pub const ss_verb = "PATCH";
    pub const Response = ss.IdResponse;

    id: i32 = 0,
    addressText: ?[]const u8 = null,
};

pub const CreateRockstarAudit = struct {
    pub const ss_name = "CreateRockstarAudit";
    pub const ss_verb = "POST";
    pub const Response = RockstarWithIdResponse;

    firstName: ?[]const u8 = null,
    lastName: ?[]const u8 = null,
    age: ?i32 = null,
    dateOfBirth: ?[]const u8 = null,
    dateDied: ?[]const u8 = null,
    livingStatus: ?LivingStatus = null,
};

pub const CreateRockstarAuditTenant = struct {
    pub const ss_name = "CreateRockstarAuditTenant";
    pub const ss_verb = "POST";
    pub const Response = RockstarWithIdAndResultResponse;

    sessionId: ?[]const u8 = null,
    firstName: ?[]const u8 = null,
    lastName: ?[]const u8 = null,
    age: ?i32 = null,
    dateOfBirth: ?[]const u8 = null,
    dateDied: ?[]const u8 = null,
    livingStatus: ?LivingStatus = null,
};

pub const UpdateRockstarAuditTenant = struct {
    pub const ss_name = "UpdateRockstarAuditTenant";
    pub const ss_verb = "PUT";
    pub const Response = RockstarWithIdAndResultResponse;

    sessionId: ?[]const u8 = null,
    id: i32 = 0,
    firstName: ?[]const u8 = null,
    livingStatus: ?LivingStatus = null,
};

pub const PatchRockstarAuditTenant = struct {
    pub const ss_name = "PatchRockstarAuditTenant";
    pub const ss_verb = "PATCH";
    pub const Response = RockstarWithIdAndResultResponse;

    sessionId: ?[]const u8 = null,
    id: i32 = 0,
    firstName: ?[]const u8 = null,
    livingStatus: ?LivingStatus = null,
};

pub const SoftDeleteAuditTenant = struct {
    pub const ss_name = "SoftDeleteAuditTenant";
    pub const ss_verb = "PUT";
    pub const Response = RockstarWithIdAndResultResponse;

    id: i32 = 0,
};

pub const CreateRockstarAuditMqToken = struct {
    pub const ss_name = "CreateRockstarAuditMqToken";
    pub const ss_verb = "POST";
    pub const Response = RockstarWithIdResponse;

    firstName: ?[]const u8 = null,
    lastName: ?[]const u8 = null,
    age: ?i32 = null,
    dateOfBirth: ?[]const u8 = null,
    dateDied: ?[]const u8 = null,
    livingStatus: ?LivingStatus = null,
    bearerToken: ?[]const u8 = null,
};

pub const RealDeleteAuditTenant = struct {
    pub const ss_name = "RealDeleteAuditTenant";
    pub const ss_verb = "DELETE";
    pub const Response = RockstarWithIdAndCountResponse;

    sessionId: ?[]const u8 = null,
    id: i32 = 0,
    age: ?i32 = null,
};

pub const CreateRockstarVersion = struct {
    pub const ss_name = "CreateRockstarVersion";
    pub const ss_verb = "POST";
    pub const Response = RockstarWithIdAndRowVersionResponse;

    firstName: ?[]const u8 = null,
    lastName: ?[]const u8 = null,
    age: ?i32 = null,
    dateOfBirth: ?[]const u8 = null,
    dateDied: ?[]const u8 = null,
    livingStatus: ?LivingStatus = null,
};
