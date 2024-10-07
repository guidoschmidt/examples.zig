const std = @import("std");
const f = @import("lib/functional.zig");

fn add2(comptime T: type, v: T) T {
    return v + 2;
}

fn mult3(comptime T: type, v: T) T {
    return v * 3;
}

fn div10(comptime T: type, v: T) T {
    return @divTrunc(v, 10);
}

fn addX(comptime T: type, comptime v: T, x: T) T {
    return v + x;
}

fn multX(comptime T: type, comptime v: T, x: T) T {
    return v * x;
}

fn multXX(comptime T: type, comptime v: T, comptime u: T, x: T) T {
    return v * u * x;
}

pub fn main() !void {
    const mult5 = f.partial(u8, multX, 5);
    const mult2and5 = f.partial2(u8, multXX, 2, 5);
    std.debug.print("\n{d}, {d}", .{mult5(3), mult2and5(3)});

    const comp_fn = f.comp(u8, &.{
        f.partial(u8, multX, 5),
        f.partial(u8, addX, 10),
    });
    std.debug.print("\n\n(x * 5) + 10: {d}", .{ comp_fn(3) });
}
