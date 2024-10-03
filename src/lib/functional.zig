// pub fn comp(comptime fns: anytype) *const @TypeOf(fns[0]) {
//     return struct {
//         pub fn f(args: T) T {
//             var tmp: T = args;
//             inline for (fns) |func| {
//                 tmp = @call(.auto, func, .{ T, tmp });
//             }
//             return tmp;
//         }
//     }.f;
// }

pub fn partial(comptime fun: anytype, comptime arg0: anytype) *const fn (comptime arg: @TypeOf(arg0)) @TypeOf(arg0) {
    return struct {
        pub fn f(comptime arg: @TypeOf(arg0)) @TypeOf(arg) {
            return fun(arg0, arg);
        }
    }.f;
}

pub fn partialTyped(comptime T: type, comptime fun: anytype, comptime arg0: T) *const fn (comptime arg: @TypeOf(arg0)) T {
    return struct {
        pub fn f(comptime arg: @TypeOf(arg0)) @TypeOf(arg) {
            return fun(arg0, arg);
        }
    }.f;
}


pub fn partial2Typed(comptime T: type, comptime fun: anytype, comptime arg0: T, comptime arg1: T) *const fn (comptime r0: @TypeOf(arg0)) @TypeOf(arg0) {
    return struct {
        pub fn f(comptime arg: @TypeOf(arg0)) @TypeOf(arg) {
            return fun(arg0, arg1, arg);
        }
    }.f;
}
