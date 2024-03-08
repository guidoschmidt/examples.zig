const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    //const firstArray = [3]i32{ 1, 2, 3 };
    
    // comptime var array_size = 10;
    // var secondArray : [array_size]i32 = [_]i32{ 0 } ** array_size;
    // //const thirdArray: [3]i32 = .{ 10, 11, 12 };

    // print("\nThe array contains the following:\n", .{});
    // for (secondArray) | el | {
    //     print("Element: {}\n", .{el});
    // }


    const small_array = [_]u32{1,2,3};
    var large_array = [_]u32{0, 0, 0, 0, 0, 0, 0};
    const ptr = &large_array[0];
    ptr.* = small_array[2];

    std.debug.print("\n{any}", .{ large_array });
}
