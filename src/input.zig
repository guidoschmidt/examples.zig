const std = @import("std");
const log = std.log;

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

pub fn main() !void {
    var buf: []u8 = try allocator.alloc(u8, 100);
    log.info("\nWhat's your name?", .{});
    if (try std.io.getStdIn().reader().readUntilDelimiterOrEof(buf[0..], '\n')) |user_input| {
        log.info("Hello {s}!", .{ user_input });
    } else {
        log.info("ERROR!", .{ });
    }
}
