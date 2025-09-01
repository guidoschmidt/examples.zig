const std = @import("std");

fn giveMeASlice(slice: []const i64) void {
    for(slice) |s| {
        std.debug.print("\n{d}", .{ s });
    }
}

pub fn main() !void {
    const simple_array = [_]i64 { 1, 1, 2, 3, 5 };
    std.debug.print("\n{any}: ({any})", .{ simple_array, @TypeOf(simple_array) });
    giveMeASlice(simple_array[0..]);
}
