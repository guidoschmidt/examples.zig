const std = @import("std");

const Vertex = struct {
    position: [4]f32 = undefined,
};

pub fn main() !void {
    const positions = [3][4]f32{
        [4]f32{ 0, 0.5, 0, 1 },
        [4]f32{ -0.5, -0.5, 0, 1 },
        [4]f32{ 0.5, -0.5, 0, 1 },
    };

    const vertices = [3]Vertex{
        .{ .position = .{ 0, 0, 0, 0 } },
        .{ .position = .{ 0, 0, 0, 0 } },
        .{ .position = .{ 0, 0, 0, 0 } },
    };

    std.debug.print("\n@sizeof #1: {d}", .{@sizeOf(@TypeOf(positions))});
    std.debug.print("\n@sizeof #1: {d}", .{positions.len * @sizeOf([4]f32)});
    std.debug.print("\n@sizeof #1: {d}", .{@sizeOf(@TypeOf(vertices))});
}
