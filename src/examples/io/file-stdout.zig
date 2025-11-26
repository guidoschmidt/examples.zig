// references:
// - https://ziggit.dev/t/new-zigger-exploring-performance/13006
const std = @import("std");

pub fn main() !void {
    const stdout = std.fs.File.stdout();
    // Can make buffer as big or as small as needed.
    var stdout_buf: [256]u8 = undefined;
    var writer = stdout.writer(&stdout_buf);
    // Later on
    try writer.interface.print("Something that needs {d} formatting", .{10});
    // Don't forget
    try writer.interface.flush();
}
