const std = @import("std");
const io = std.io;
const log = std.log;
const fs = std.fs;
const print = std.debug.print;
const heap = std.heap;
const process = std.process;

fn find(arr: *std.array_list.Managed([]const u8), elem: []const u8) bool {
    for (arr.items) |item| if (std.mem.eql(u8, item, elem)) return true;
    return false;
}

fn createExecutable(
    b: *std.Build,
    module_shadred: *std.Build.Module,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
    source: []const u8,
) !void {
    const source_filename = std.fs.path.basename(source);
    const index = std.mem.lastIndexOfScalar(u8, source_filename, '.') orelse source_filename.len;
    const exe_name = source_filename[0..index];
    const exe = b.addExecutable(.{
        .name = exe_name,
        .root_module = b.createModule(.{
            .optimize = optimize,
            .target = target,
            .root_source_file = b.path(source),
        }),
    });
    exe.root_module.addImport("shared", module_shadred);

    const path = fs.path.dirname(source) orelse "";
    const clean_path = try std.mem.replaceOwned(u8, b.allocator, path, "./src/examples", "");
    const out_path = try fs.path.join(b.allocator, &.{ "bin", clean_path });
    const full_exe_path = try std.fs.path.join(b.allocator, &.{ out_path, exe_name });
    print("\n→ {s}\n", .{full_exe_path});
    const install_artifact = b.addInstallArtifact(exe, .{
        .dest_dir = .{
            .override = .{
                .custom = out_path,
            },
        },
    });
    b.getInstallStep().dependOn(&install_artifact.step);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |buildArgs| {
        run_cmd.addArgs(buildArgs);
    }

    const run_step_name = try std.fmt.allocPrint(b.allocator, "run-{s}", .{exe_name});
    defer b.allocator.free(run_step_name);
    const run_step = b.step(run_step_name, "Run the program");
    run_step.dependOn(&run_cmd.step);
}

fn parseDir(
    b: *std.Build,
    depth: usize,
    path: []const u8,
    results: *std.array_list.Managed([]const u8),
) !void {
    const extension = fs.path.extension(path);
    if (!std.mem.eql(u8, extension, "zig") and extension.len > 0) return;
    const src_dir = fs.cwd().openDir(path, .{ .iterate = true }) catch |err| {
        print("\n{any}: {s}", .{ err, path });
        return;
    };
    var it = src_dir.iterate();
    var i: u32 = 0;
    while (try it.next()) |subpath| : (i += 1) {
        const child_path = try std.fs.path.join(b.allocator, &.{ path, subpath.name });
        if (!std.mem.containsAtLeast(u8, subpath.name, 1, ".zig")) {
            try parseDir(b, depth + 1, child_path, results);
            continue;
        }
        try results.append(child_path);
    }
}

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const args = try process.argsAlloc(b.allocator);
    defer process.argsFree(b.allocator, args);

    var examples = std.array_list.Managed([]const u8).init(b.allocator);
    defer examples.deinit();

    const module_shared = b.addModule("shared", .{
        .root_source_file = b.path("src/shared/root.zig"),
        .optimize = optimize,
        .target = target,
    });

    const root_dir = try std.fs.path.join(b.allocator, &.{ "src", "examples" });
    try parseDir(b, 0, root_dir, &examples);

    // Print a list of every example found
    // print("\n\n--- Examples ---\n", .{});
    // for (examples.items) |example_src| {
    //     print("- {s}\n", .{example_src});
    // }
    // print("----------------\n", .{});

    const arg = if (args.len < 10) "all" else args[args.len - 1];
    const single_example_path = try std.fs.path.resolve(b.allocator, &.{arg});
    if (find(&examples, single_example_path)) {
        print("Found example: {s}", .{single_example_path});
        try createExecutable(b, module_shared, target, optimize, single_example_path);
    } else {
        print("Couldn't find example: {s}", .{single_example_path});
    }

    if (std.mem.eql(u8, single_example_path, "all")) {
        for (examples.items) |example_src| {
            print("\nBuilding example: {s}", .{example_src});
            try createExecutable(b, module_shared, target, optimize, example_src);
        }
    }
}
