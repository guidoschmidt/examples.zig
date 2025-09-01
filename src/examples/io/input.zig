const std = @import("std");
const log = std.log;

pub fn main() !void {
    var buffer_reader: [256]u8 = undefined;
    var std_reader = std.fs.File.stdin().readerStreaming(&buffer_reader);
    var buffer_writer: [256]u8 = undefined;
    var std_writer = std.fs.File.stdout().writer(&buffer_writer);

    log.info("\nWhat's your name?", .{});
    const len = try std_reader.interface.streamDelimiter(&std_writer.interface, '\n');
    const user_input = buffer_writer[0..len];
    log.info("\nHello {s}", .{user_input});
}
