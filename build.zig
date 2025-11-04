const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // ServiceStack HTTP Client library module
    const servicestack_module = b.addModule("servicestack", .{
        .root_source_file = b.path("src/lib.zig"),
        .target = target,
        .optimize = optimize,
    });

    // Library tests
    const lib_unit_tests = b.addTest(.{
        .root_module = servicestack_module,
    });

    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);
    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&run_lib_unit_tests.step);

    // Example executable
    const example_module = b.createModule(.{
        .root_source_file = b.path("examples/basic.zig"),
        .target = target,
        .optimize = optimize,
    });
    example_module.addImport("servicestack", servicestack_module);

    const example = b.addExecutable(.{
        .name = "example",
        .root_module = example_module,
    });

    b.installArtifact(example);

    const run_example = b.addRunArtifact(example);
    const example_step = b.step("example", "Run basic example");
    example_step.dependOn(&run_example.step);

    // Advanced example executable
    const advanced_module = b.createModule(.{
        .root_source_file = b.path("examples/advanced.zig"),
        .target = target,
        .optimize = optimize,
    });
    advanced_module.addImport("servicestack", servicestack_module);

    const advanced = b.addExecutable(.{
        .name = "advanced",
        .root_module = advanced_module,
    });

    b.installArtifact(advanced);

    const run_advanced = b.addRunArtifact(advanced);
    const advanced_step = b.step("advanced", "Run advanced example");
    advanced_step.dependOn(&run_advanced.step);
}
