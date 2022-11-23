const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    const firstArray = [3]i32{ 1, 2, 3 };
    //const secondArray = [_]i32{ 7, 8, 9 };
    //const thirdArray: [3]i32 = .{ 10, 11, 12 };

    print("\nThe array contains the following:\n", .{});
    for (firstArray) | el | {
        print("Element: {}\n", .{el});
    }
}
