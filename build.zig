const std = @import("std");
const io = std.io;
const log = std.log;
const fs = std.fs;
const print = std.debug.print;
const heap = std.heap;
const process = std.process;

fn createExecutable(b: *std.Build,
                    target: std.Build.ResolvedTarget,
                    optimize: std.builtin.OptimizeMode,
                    source: []const u8) !void {
    const source_filename = std.fs.path.basename(source);
    const index = std.mem.lastIndexOfScalar(u8, source_filename, '.') orelse source_filename.len;
    const exe_name = source_filename[0..index];
    const exe = b.addExecutable(.{
        .root_source_file = b.path(source),
        .name = exe_name,
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |buildArgs| {
        run_cmd.addArgs(buildArgs);
    }

    const run_step_name = try std.fmt.allocPrint(b.allocator, "{s}", .{ exe_name });
    defer b.allocator.free(run_step_name);
    const run_step = b.step(run_step_name, "Run the program");
    run_step.dependOn(&run_cmd.step);
}

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const args = try process.argsAlloc(b.allocator);
    defer process.argsFree(b.allocator, args);

    var examples = std.ArrayList([]const u8).init(b.allocator);
    defer examples.deinit();
    
    print("\n\n--- Examples ---\n", .{});
    const src_dir = try fs.cwd().openDir("./src", .{ .iterate = true });
    var it = src_dir.iterate();
    var i: u32 = 0;
    while (try it.next()) |path| : (i += 1) {
        if (!std.mem.containsAtLeast(u8, path.name, 1, ".zig")) continue;
        const source = try std.fmt.allocPrint(b.allocator, "./src/{s}", .{ path.name });
        print("- {d} {s}\n", .{ i, source });
        try examples.append(source);
    }
    print("----------------\n", .{});


    const single_example_name = args[args.len - 1];
    var index: ?usize = null;
    for (0..examples.items.len) |j| {
        if (std.mem.containsAtLeast(u8, examples.items[j], 1, single_example_name)) {
            index = j;
            break;
        }
    }

    if (index) |j| {
        const example = examples.items[j];
        print("\nBuilding single example: {s}...\n\n", .{ example });
        try createExecutable(b, target, optimize, example);
        return;
    }
    
    for (examples.items) |source_file| {
        try createExecutable(b, target, optimize, source_file);
    }
    // return;

    // defer b.allocator.free(source);
    // print("\n...Building {s} {s}\n\n", .{ example_name, source });

    // try createExecutable(b, source);
}
