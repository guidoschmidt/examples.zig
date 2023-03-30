const std = @import("std");
const io = std.io;
const fs = std.fs;
const cwd = fs.cwd();
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

    var input_buffer: []u8 = try allocator.alloc(u8, 10);
    defer allocator.free(input_buffer);

    print("\n\n>>> Found the following example sourc files:\n", .{});
    const src_dir = try cwd.openIterableDir("./src", .{});
    var it = src_dir.iterate();
    while (try it.next()) |path| {
        print("× {s}\n", .{ path.name });
    }

    print("\n→ Which example should be built?\n", .{});
    if (try std.io.getStdIn()
            .reader()
            .readUntilDelimiterOrEof(input_buffer[0..], '\n')) |user_input| {
        const source = try std.fmt.allocPrint(allocator, "./src/{s}", .{ user_input });
        defer allocator.free(source);
        print("→ Building {s}\n\n", .{ source });

        const target = b.standardTargetOptions(.{});
        const exe = b.addExecutable(.{
            .root_source_file = .{ .path = source },
            .name = source[6..source.len - 4],
            .target = target
        });
        exe.install();

        const run_cmd = exe.run();
        run_cmd.step.dependOn(b.getInstallStep());
        if (b.args) |buildArgs| {
            run_cmd.addArgs(buildArgs);
        }

        const run_step = b.step("run", "Run the program");
        run_step.dependOn(&run_cmd.step);
    }
}
