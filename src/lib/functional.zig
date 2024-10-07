const std = @import("std");

pub fn comp(comptime T: type, comptime fns: anytype) fn(arg: T) T {
    return struct {
        pub fn f(arg: T) T {
            var tmp: T = arg;
            inline for (fns) |func| {
                tmp = @call(.auto, func, .{ tmp });
            }
            return tmp;
        }
    }.f;
}

pub fn partial(comptime T: type, func: anytype, comptime arg0: T) *const fn (arg: T) T {
    return struct {
        pub fn f(arg: T) T {
            return @call(.auto, func, .{ T, arg0, arg });
        }
    }.f;
}

pub fn partial2(comptime T: type, func: anytype, comptime arg0: anytype, comptime arg1: anytype) *const fn (arg: T) T {
    return struct {
        pub fn f(arg: T) T {
            return @call(.auto, func, .{ T, arg0, arg1, arg });
        }
    }.f;
}

pub fn partialGeneric(comptime T: type, func: anytype, comptime args: anytype) *const fn (arg: T) T {
    const field_info = @typeInfo(@TypeOf(args)).Struct.fields;
    return struct {
        pub fn f(arg: T) T {
            // @compileLog(());
            switch(field_info.len) {
                1 => return @call(.auto, func, .{ T, args[0], arg }),
                2 => return @call(.auto, func, .{ T, args[0], args[1], arg }),
                3 => return @call(.auto, func, .{ T, args[0], args[1], args[2], arg }),
                else => return @call(.auto, func, .{ T }),
            }
        }
    }.f;
}

// pub fn partial2Typed(comptime T: type, comptime fun: anytype, comptime arg0: T, comptime arg1: T) *const fn (comptime r0: @TypeOf(arg0)) @TypeOf(arg0) {
//     return struct {
//         pub fn f(comptime arg: @TypeOf(arg0)) @TypeOf(arg) {
//             return fun(arg0, arg1, arg);
//         }
//     }.f;
// }
