const std = @import("std");
const print = std.debug.print;

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

fn comp(comptime fun_a: anytype, comptime fun_b: anytype) type {
    // const fn_type_a = @TypeOf(fun_a);
    // const fn_type_b = @TypeOf(fun_b);
    // const params_a = @typeInfo(fn_type_a).Fn.params.len;
    // const params_b = @typeInfo(fn_type_b).Fn.params.len;

    return struct {
        pub fn invoke(arg: i32) i32 {
            var tmp = fun_a(arg);
            return fun_b(tmp);
        }
    };
}

fn negate(v: i32) i32 {
    return -v;
}

fn plusB(v: i32, b: i32) i32 {
    return v + b;
}

fn powB(v: i32, b: i32) i32 {
    var result = v;
    const until: usize = @intCast(b);
    for(1..until) |_| {
        result *= v;
    }
    return result;
}

fn partial(comptime fun: anytype, comptime arg0: i32) type {
    return struct {
        pub fn invoke(arg: i32) i32 {
            return fun(arg0, arg);
        }
    };
}

pub fn main() !void {
    const part = partial(powB, 3);
    for(1..5) |e| {
        print("\n{d} → {any}", .{ e, part.invoke(@intCast(e)) });
    }
}
