const std = @import("std");

pub fn main() !void {
    const comptime_file = @embedFile("./comptime-file.zig");
    std.log.info("\n{s}", .{comptime_file});
}
