const std = @import("std");

pub fn main() !void {
    var text = "all your base are belong to us!".*;
    for (0..text.len) |i| {
        if (text[i] != ' ') {
            // ASCII magic: subtract -32 and you get the uppercase letter
            text[i] = text[i] - 32;
        }
    }
    std.debug.print("\n{s}", .{ text });
}
