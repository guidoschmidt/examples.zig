const std = @import("std");
const io = std.io;
const log = std.log;
const fs = std.fs;
const print = std.debug.print;
const heap = std.heap;
const process = std.process;

fn createExecutable(b: *std.Build, source: []u8) !void {
    _ = source;
    _ = b;
    
}

pub fn build(b: *std.Build) !void {
    var gpa = heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const args = try process.argsAlloc(allocator);
    defer process.argsFree(allocator, args);

    print("\n\n>>> Found the following example sourc files:\n", .{});
    const src_dir = try fs.cwd().openDir("./src", .{ .iterate = true });
    var it = src_dir.iterate();
    var i: u32 = 0;
    while (try it.next()) |path| : (i += 1) {
        if (!std.mem.containsAtLeast(u8, path.name, 1, ".zig")) continue;
        print("- {d} {s}\n", .{ i, path.name });
    }

    const example_name = args[args.len - 1];
    const source = try std.fmt.allocPrint(allocator, "./src/{s}.zig", .{ example_name });
    defer allocator.free(source);
    print("\n...Building {s} {s}\n\n", .{ example_name, source });

    const target = b.standardTargetOptions(.{});
    const exe_name = fs.path.basename(source);
    const exe = b.addExecutable(.{
        .root_source_file = b.path(source),
        .name = exe_name,
        .target = target
    });
    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |buildArgs| {
        run_cmd.addArgs(buildArgs);
    }
    const run_step = b.step("run", "Run the program");
    run_step.dependOn(&run_cmd.step);
}
