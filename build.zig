const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib_interpreter_mod = b.createModule(.{
        .root_source_file = b.path("src/lib/interpreter/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    const exe_mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    exe_mod.addImport("interpreter", lib_interpreter_mod);

    const lib_interpreter = b.addStaticLibrary(.{
        .name = "interpreter",
        .root_module = lib_interpreter_mod,
    });

    b.installArtifact(lib_interpreter);

    const exe = b.addExecutable(.{
        .name = "lang",
        .root_module = exe_mod,
    });

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);

    // By making the run step depend on the install step, it will be run from the
    // installation directory rather than directly from within the cache directory.
    // This is not necessary, however, if the application depends on other installed
    // files, this ensures they will be present and in the expected location.
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const lib_interpreter_unit_tests = b.addTest(.{
        .root_module = lib_interpreter_mod,
    });

    const run_lib_interpreter_unit_tests = b.addRunArtifact(lib_interpreter_unit_tests);

    const exe_unit_tests = b.addTest(.{
        .root_module = exe_mod,
    });

    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_interpreter_unit_tests.step);
    test_step.dependOn(&run_exe_unit_tests.step);
}
