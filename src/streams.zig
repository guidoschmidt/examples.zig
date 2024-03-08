const std = @import("std");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

const OscArgument = packed struct {
    tag_type: u8 = 'i',
    value: i32 = undefined,
};

pub fn main() !void {
    const buffer: []u8 = try allocator.alloc(u8, 100);
    var stream = std.io.fixedBufferStream(buffer);
    var writer = stream.writer();
    // try writer.writeInt(i32, 1337, .big);
    // try writer.writeInt(i32, 128, .big);
    try writer.writeStruct(OscArgument{
        .tag_type = 'i',
        .value = 1337
    });

    // std.debug.print("\n{s} [{any}]", .{ buffer, @TypeOf(buffer) });
    // std.debug.print("\n{any}", .{ stream });

    const written = stream.getWritten();
    std.debug.print("\n\n{s}", .{ written });


    
    var out_stream = std.io.fixedBufferStream(written);
    var reader = out_stream.reader();
    // var out = reader.readInt(i32, .big);
    // std.debug.print("\n\n{any}", .{ out_stream });
    // std.debug.print("\n{any}", .{ out });

    // out = reader.readInt(i32, .big);
    // std.debug.print("\n\n{any}", .{ out_stream });
    // std.debug.print("\n{any}", .{ out });


    // Structs


    const out_struct = try reader.readStruct(OscArgument);
    std.debug.print("\n{any}", .{ out_struct });
}
