const std = @import("std");

pub fn main() !void {
    const comptime_file = @embedFile("./data/infile.txt");
    std.log.info("\n{s}", .{ comptime_file });
}
