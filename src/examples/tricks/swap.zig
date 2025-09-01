const std = @import("std");

fn swap(comptime T: type, x: *T, y: *T) void {
    const t, y.* = .{ y.*, x.* };
    x.* = t;
    std.debug.print("\n{d}, {d}", .{ x.*, y.* });
}

pub fn main() !void {
    var x: u8 = 250;
    var y: u8 = 1;

    var i: usize = 0;
    while (i < 1000) : (i += 1) {
        swap(u8, &x, &y);
    }
}
