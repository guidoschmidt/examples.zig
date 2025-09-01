const std = @import("std");
const meta = std.meta;
const fs = std.fs;
const f = @import("shared").functional;

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

pub fn transduce(xform: anytype, xf: anytype, col: anytype) void {
    _ = col;
    _ = xf;
    _ = xform;
}

pub fn map(comptime R: type, arg: anytype, comptime fun: anytype) !R {
    const T = @typeInfo(@TypeOf(arg));
    std.debug.print("\n{any}\n{any}", .{ T, @typeInfo(@TypeOf(fun)) });
    return switch (T) {
        .Array => {
            const element_type = T.Array.child;
            const result = try allocator.alloc(element_type, arg.len);
            std.debug.print("\nElement Type {any}", .{element_type});
            inline for (0..arg.len) |i| {
                result[i] = fun(element_type, arg[i]);
            }
            return result;
        },
        else => {
            const element_type = @TypeOf(arg);
            const result = try allocator.alloc(element_type, 1);
            result[0] = fun(element_type, arg);
            return result;
        },
    };
}

pub fn mul(comptime T: type, m: T, arg: T) T {
    return arg * m;
}

pub fn main() !void {}
