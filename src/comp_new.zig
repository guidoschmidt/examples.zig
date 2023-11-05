const std = @import("std");

fn comp(comptime T: type, comptime fns: anytype) *const fn(args: T) T {
    const internal_struct = struct {
        pub fn f(args: T) T {
            var tmp: T = args;
            inline for(fns) |func| {
                tmp =  func(T, tmp);
            }
            return tmp;
        }
    };
    return internal_struct.f;
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

pub fn main() !void {
    const c_f32 = comp(f32, &.{ add2, mult3, div10 });
    for(50..55) |x| {
        const result =  c_f32(@floatCast(@as(f32, @floatFromInt(x)))) ;
        std.debug.print("\n{d:>5.2}, {any}", .{ result, @TypeOf(result) });
    }

    const c_i32 = comp(i32, &.{ div10, mult3 });
    for(100..110) |x| {
        const result =  c_i32(@intCast(x)) ;
        std.debug.print("\n{d:>5.0}, {any}", .{ result, @TypeOf(result) });
    }
}
