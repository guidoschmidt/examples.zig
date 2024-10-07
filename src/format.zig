const std = @import("std");

pub fn main() !void {
    var x: usize = 0;
    for (0..32) |i| {
        std.debug.print("\n{d}", .{ i });
        std.debug.print("\n{d:0>6}", .{ x });
        x += 1;
    }
}
