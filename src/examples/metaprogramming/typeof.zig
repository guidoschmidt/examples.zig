const std = @import("std");

const Vertex = struct {
    position: @Vector(4, f32),
};

pub fn main() !void {
    const arr = [_]f32{ 0, 1, 3 };
    const arr_type = @TypeOf(arr);
    const single_type = @typeInfo(arr_type).array.child;

    std.debug.print("\n@TypeOf Array: {any}", .{arr_type});
    std.debug.print("\n@sizeOf Array: {d}", .{@sizeOf(@TypeOf(arr))});
    std.debug.print("\n@TypeOf Element: {any}", .{single_type});
    std.debug.print("\n@sizeOf Vertex: {any}", .{@sizeOf(Vertex)});
}
