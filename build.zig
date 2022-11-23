const std = @import("std");
const print = std.debug.print;
const heap = std.heap;
const process = std.process;

pub fn build(b: *std.build.Builder) !void {
    var gpa = heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const args = try process.argsAlloc(allocator);
    defer process.argsFree(allocator, args);

    for (args) |a| {
        print("\n{s}", .{a});
    }
    const source = if (args.len > 2) args[args.len - 1] else "./hello.zig";
    print("Building {s}", .{source});

    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();
    const exe = b.addExecutable("hello", "./hello.zig");
    exe.setTarget(target);
    exe.setBuildMode(mode);
    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |buildArgs| {
        run_cmd.addArgs(buildArgs);
    }

    const run_step = b.step("run", "Run the program");
    run_step.dependOn(&run_cmd.step);
}
