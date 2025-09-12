const std = @import("std");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

const OscArgument = packed struct {
    tag_type: u8 = 'i',
    value: i32 = undefined,

    pub fn format(
        self: OscArgument,
        writer: *std.Io.Writer,
    ) std.Io.Writer.Error!void {
        try writer.print("\nOSC Argument:\n - {c} - {d}", .{
            self.tag_type,
            self.value,
        });
    }
};

pub fn main() !void {
    const buffer: []u8 = try allocator.alloc(u8, 100);
    var stream = std.io.fixedBufferStream(buffer);
    var writer = stream.writer();
    try writer.writeInt(i32, 1337, .big);
    try writer.writeInt(i32, 128, .big);
    try writer.writeStruct(OscArgument{
        .tag_type = 'i',
        .value = 1337,
    });

    const written = stream.getWritten();
    std.debug.print("Buffer Written:\n > {any}", .{written});

    var out_stream = std.io.fixedBufferStream(written);
    var reader = out_stream.reader();

    var out = try reader.readInt(i32, .big);
    std.debug.print("\n\nRead Integer:\n > {any}", .{out_stream.buffer});
    std.debug.print("\n > {d}", .{out});

    out = try reader.readInt(i32, .big);
    std.debug.print("\n\nRead Integer:\n > {any}", .{out_stream.buffer});
    std.debug.print("\n > {d}", .{out});

    const out_struct = try reader.readStruct(OscArgument);
    std.debug.print("\n{f}", .{out_struct});
}
