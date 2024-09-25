const std = @import("std");

pub fn main() !void {
    var bound_array = try std.BoundedArray(i64, 100).init(0);
    try bound_array.append(1337);

    for (0..bound_array.len) |i| {
        std.debug.print("\n{d}", .{ bound_array.buffer[i] });
    }
}
