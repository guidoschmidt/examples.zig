const std = @import("std");
const io = std.io;
const fs = std.fs;
const print = std.debug.print;
const heap = std.heap;
const process = std.process;

pub fn build(b: *std.Build) !void {
    var gpa = heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const args = try process.argsAlloc(allocator);
    defer process.argsFree(allocator, args);


    print("\n\n>>> Found the following example sourc files:\n", .{});
    const src_dir = try fs.cwd().openIterableDir("./src", .{});
    var it = src_dir.iterate();
    var i: u32 = 0;
    while (try it.next()) |path| : (i += 1) {
        if (!std.mem.containsAtLeast(u8, path.name, 1, ".zig")) continue;
        print("- {d} {s}\n", .{ i, path.name });
    }

    const in = std.io.getStdIn();
    var buf = std.io.bufferedReader(in.reader());

    // Get the Reader interface from BufferedReader
    var r = buf.reader();

    std.debug.print("Write something: ", .{});
    // Ideally we would want to issue more than one read
    // otherwise there is no point in buffering.
    var msg_buf: [4096]u8 = undefined;
    var input = try r.readUntilDelimiterOrEof(&msg_buf, '\n');

    if (input) | input_txt | {
        const selection_idx = std.fmt.parseInt(usize, input_txt[0..input_txt.len - 1], 10) catch 0;
        it.reset();
        var j: u32 = 0;
        while (j < selection_idx) : (j += 1) {
            _ = try it.next();
        }
        if (try it.next()) |entry| {
            const source = try std.fmt.allocPrint(allocator, "src/{s}", .{ entry.name });
            defer allocator.free(source);
            print("\n...Building {s}", .{ source });

            const target = b.standardTargetOptions(.{});
            const exe_name = fs.path.basename(source);
            const exe = b.addExecutable(.{
                .root_source_file = .{ .path = source },
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
    }
}
