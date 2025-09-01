const std = @import("std");

pub fn main() !void {
    const x = 0.628;
    std.debug.print("\n{d:.4}", .{x});
    std.debug.print("\n{d:.8}", .{x});
    std.debug.print("\n{d:.16}", .{x});
}
