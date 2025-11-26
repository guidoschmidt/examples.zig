const std = @import("std");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    var out: std.io.Writer.Allocating = .init(arena.allocator());

    const address: []const u8 = "/oscillator/4/frequency";
    try out.writer.writeAll(address);
    const len = out.written().len;
    try out.writer.splatByteAll(0, 4 - @mod(len, 4));
    try out.writer.writeByte(',');

    try out.writer.writeByte('f');
    try out.writer.splatByteAll(0, 4 - @mod(len, 4));

    const float_value: f32 = 440.0;
    try out.writer.splatByteAll(0, 4 - @mod(len, 4));
    try out.writer.writeInt(i32, @bitCast(float_value), .big);

    for (out.written()) |v| {
        std.debug.print("{x}\n", .{v});
    }
}
