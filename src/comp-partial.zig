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

fn addX(comptime T: type, v: T, a: T) T {
    return v + a;
}

fn divX(comptime T: type, d: T, v: T) T {
    return @divFloor(v, d);
}

fn multX(v: anytype, m: anytype) @TypeOf(m) {
    return v * m;
}

pub fn main() !void {
    const mult5 = f.partial(multX, 5);
    std.debug.print("\n{d}", .{ mult5(3) });

    // const c_f32 = f.comp(f32, &.{
    //     f.partial(f32, multX, 5),
    //     f.partial(f32, addX, 10),
    // });
    // std.debug.print("\n\n(x * 5) + 10", .{});
    // for (1..10) |x| {
    //     const result = c_f32(@floatCast(@as(f32, @floatFromInt(x))));
    //     std.debug.print("\n{x:.2}  →  {d:>5.2}, {any}", .{ x, result, @TypeOf(result) });
    // }

    // const c_i32 = f.comp(i32, &.{
    //     f.partial(i32, multX, 10),
    //     f.partial(i32, divX, 2),
    // });
    // std.debug.print("\n\n(x * 10) / 2", .{});
    // for (1..10) |x| {
    //     const result = c_i32(@intCast(x));
    //     std.debug.print("\n{d}  →  {d}, {any}", .{ x, result, @TypeOf(result) });
    // }
}
