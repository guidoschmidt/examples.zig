const std = @import("std");

pub fn build(b: *std.build.Builder) !void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const source = "./src/main.cpp";
    const exe = b.addExecutable("main", source);
    exe.setBuildMode(mode);
    exe.setTarget(target);
    exe.linkLibCpp();
    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Start the program");
    run_step.dependOn(&run_cmd.step);
}
