const std = @import("std");

pub fn main() !void {
    std.debug.print("\nAnonymous structs can bu used as tuples:\n{any}", .{
        .{
            12,
            true,
            "test",
        },
    });
}
