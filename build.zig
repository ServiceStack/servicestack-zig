const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Create the module
    const servicestack_module = b.addModule("servicestack", .{
        .source_file = .{ .path = "src/client.zig" },
    });

    // Create a library
    const lib = b.addStaticLibrary(.{
        .name = "servicestack-zig",
        .root_source_file = .{ .path = "src/client.zig" },
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(lib);

    // Create tests
    const tests = b.addTest(.{
        .root_source_file = .{ .path = "src/client.zig" },
        .target = target,
        .optimize = optimize,
    });

    const run_tests = b.addRunArtifact(tests);
    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&run_tests.step);

    // Create example
    const example = b.addExecutable(.{
        .name = "example",
        .root_source_file = .{ .path = "examples/basic.zig" },
        .target = target,
        .optimize = optimize,
    });
    example.addModule("servicestack", servicestack_module);
    b.installArtifact(example);

    const run_example = b.addRunArtifact(example);
    const example_step = b.step("example", "Run example");
    example_step.dependOn(&run_example.step);
}
