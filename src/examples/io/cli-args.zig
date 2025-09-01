const std = @import("std");

pub fn main() !void {
    const args = try std.process.argsAlloc(std.heap.page_allocator);
    defer std.process.argsFree(std.heap.page_allocator, args);

    for (0..args.len) |i| {
        std.debug.print("\n{d}: {s}", .{ i, args[i] });
    }
}
