const std = @import("std");

const Rectangle = struct { w: f32, h: f32, color: u16 };

const Elipsis = struct { r1: f32, r2: f32, color: u16 };

pub fn main() !void {
    // var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    // const allocator = gpa.allocator();

    const circle = Elipsis{
        .r1 = 3,
        .r2 = 3,
        .color = 25500,
    };
    const rect: Rectangle = .{
        .w = 3,
        .h = 3,
        .color = 25500,
    };
    std.log.debug("\nCircle:    {any} [{?}]", .{ circle, @TypeOf(circle) });
    std.log.debug("\nRectangle: {any} [{?}]", .{ rect, @TypeOf(rect) });

    const colour = 0xff0000;
    std.log.debug("\n{any} [{?}]", .{ colour, @TypeOf(colour) });
}
