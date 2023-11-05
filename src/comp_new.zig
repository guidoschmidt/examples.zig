const std = @import("std");

fn comp(comptime T: type, comptime fns: anytype) *const fn(args: T) T {
    return struct {
        pub fn f(args: T) T {
            var tmp: T = args;
            inline for(fns) |func| {
                tmp = @call(.auto, func, .{T, tmp});
            }
            return tmp;
        }
    }.f;
}

fn partial(comptime T: type, comptime fun: anytype, comptime arg0: T) *const fn(t: @TypeOf(T), args: T) T {
    return struct {
        pub fn f(comptime t: @TypeOf(T), arg: T) T {
            return fun(t, arg0, arg);
        }
    }.f;
}


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

fn multX(comptime T: type, v: T, m: T) T {
    return v * m;
}

pub fn main() !void {
    const c_f32 = comp(f32, &.{
        partial(f32, multX, 5),
        partial(f32, addX, 10),
    });
    std.debug.print("\n\n(x * 5) + 10", .{});
    for(1..10) |x| {
        const result =  c_f32(@floatCast(@as(f32, @floatFromInt(x)))) ;
        std.debug.print("\n{x:.2}  →  {d:>5.2}, {any}", .{ x, result, @TypeOf(result) });
    }

    const c_i32 = comp(i32, &.{
        partial(i32, multX, 10),
        partial(i32, divX, 2),
    });
    std.debug.print("\n\n(x * 10) / 2", .{});
    for(1..10) |x| {
        const result =  c_i32(@intCast(x)) ;
        std.debug.print("\n{d}  →  {d}, {any}", .{ x, result, @TypeOf(result) });
    }
}
