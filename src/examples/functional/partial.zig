const std = @import("std");
const f = @import("shared").functional;

fn addX(comptime T: type, comptime x: T, v: T) T {
    return v + x;
}

fn multX(comptime T: type, comptime x: T, v: T) T {
    return v * x;
}

fn multXAddY(comptime T: type, comptime x: T, comptime y: T, v: T) T {
    return (x * v) + y;
}

pub fn main() !void {
    std.debug.print("Partial Function Application", .{});

    std.debug.print("\nCreate an add8 function:", .{});
    const add8 = f.partial(u8, addX, 8);
    for (0..3) |i| {
        std.debug.print("\n {d} + 8 = {d}", .{ i, add8(@intCast(i)) });
    }

    std.debug.print("\nCreate a multiply with 5 function:", .{});
    const mult5 = f.partial(u8, multX, 5);
    for (1..6) |i| {
        std.debug.print("\n {d} x 5 = {d}", .{ i, mult5(@intCast(i)) });
    }

    std.debug.print("\nCreate a function which calculates 5 * x + 2:", .{});
    const mult2add5 = f.partial2(u8, multXAddY, 2, 5);
    for (0..10) |i| {
        std.debug.print("\n 2 * {d} + 5 = {d}", .{ i, mult2add5(@intCast(i)) });
    }
}
