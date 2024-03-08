pub fn comp(comptime T: type, comptime fns: anytype) *const fn (args: T) T {
    return struct {
        pub fn f(args: T) T {
            var tmp: T = args;
            inline for (fns) |func| {
                tmp = @call(.auto, func, .{ T, tmp });
            }
            return tmp;
        }
    }.f;
}

pub fn partial(comptime T: type, comptime fun: anytype, comptime arg0: T) *const fn (comptime args: T) T {
    return struct {
        pub fn f(comptime arg: T) T {
            return fun(arg0, arg);
        }
    }.f;
}


pub fn partial2(comptime T: type, comptime fun: anytype, comptime arg0: T, comptime arg1: T) *const fn (comptime args: T) T {
    return struct {
        pub fn f(comptime arg: T) T {
            return fun(arg0, arg1, arg);
        }
    }.f;
}
