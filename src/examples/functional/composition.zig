const std = @import("std");
const f = @import("shared").functional;

fn addX(comptime T: type, comptime x: T, v: T) T {
    return v + x;
}

fn subX(comptime T: type, comptime x: T, v: T) T {
    return v - x;
}

fn mulX(comptime T: type, comptime x: T, v: T) T {
    return v * x;
}

pub fn main() !void {
    const combined = f.comp(u32, .{
        f.partial(u32, addX, 5),
        f.partial(u32, mulX, 10),
        f.partial(u32, subX, 3),
        f.partial(u32, mulX, 2),
    });
    std.debug.print("\nFunction Composition", .{});
    for (1..10) |i| {
        std.debug.print("\n((({d} + 5) * 10) - 3) * 2: {d}", .{ i, combined(@intCast(i)) });
    }
}
