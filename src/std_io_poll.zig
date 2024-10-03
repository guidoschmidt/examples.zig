const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    defer {
        const deinit_status = gpa.deinit();
        if (deinit_status == .leak) @panic("TEST FAIL");
    }

    var arena = std.heap.ArenaAllocator.init(allocator);
    defer arena.deinit();

    const arena_allocator = arena.allocator();

    const args = try std.process.argsAlloc(arena_allocator);

    if (args.len >= 2) {
        return childMain();
    } else {
        return parent(allocator, arena_allocator);
    }
}

fn parent(gpa: std.mem.Allocator, arena: std.mem.Allocator) !void {
    const self_exe_path = try std.fs.selfExePathAlloc(arena);
    var child = std.process.Child.init(&.{ self_exe_path, "child" }, gpa);

    child.stdin_behavior = .Pipe;
    child.stdout_behavior = .Pipe;
    child.stderr_behavior = .Pipe;

    try child.spawn();

    var poller = std.io.poll(gpa, enum { stdout, stderr }, .{
        .stdout = child.stdout.?,
        .stderr = child.stderr.?,
    });
    defer poller.deinit();

    try child.stdin.?.writeAll("the input");
    child.stdin.?.close(); // send EOF
    child.stdin = null;

    while (try poller.poll()) {}

    const term = try child.wait();
    switch (term) {
        .Exited => |code| {
            if (code != 0) @panic("bad child exit code");
        },
        else => @panic("child crash"),
    }

    const stdout = poller.fifo(.stdout).readableSlice(0);
    const stderr = poller.fifo(.stderr).readableSlice(0);

    for (0..10000) |i| {
        if (!std.mem.eql(u8, stderr[i * "Garbage".len ..][0.."Garbage".len], "Garbage")) {
            @panic("Garbage failure");
        }
        if (!std.mem.eql(u8, stdout[i * "Trash".len ..][0.."Trash".len], "Trash")) {
            @panic("Trash failure");
        }
    }
}

fn childMain() !void {
    const stdout = std.io.getStdOut();
    const stderr = std.io.getStdErr();
    const stdin = std.io.getStdIn();

    for (0..10000) |_| {
        try stderr.writeAll("Garbage");
        try stdout.writeAll("Trash");
    }

    var buf: [1000]u8 = undefined;
    const amt = try stdin.readAll(&buf);
    if (!std.mem.eql(u8, buf[0..amt], "the input")) {
        @panic("test failure");
    }
}
