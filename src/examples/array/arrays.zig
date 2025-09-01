const std = @import("std");
const print = std.debug.print;

fn printArray(comptime T: type, arr: *const T) void {
    print("Array: [ ", .{});
    for (0..arr.*.len) |i| {
        if (i == arr.len - 1) {
            print("{}", .{arr[i]});
            continue;
        }
        print("{}, ", .{arr[i]});
    }
    print(" ]\n", .{});
}

pub fn main() !void {
    // Defiining an arry of 3 elements
    var first_array = [3]i32{ 1, 2, 3 };
    printArray(@TypeOf(first_array), &first_array);

    // Filling an entire array with the * operator
    first_array = .{3} ** 3;
    printArray(@TypeOf(first_array), &first_array);

    // Array size has to be compile time known
    const array_size = comptime 10;
    const second_array: [array_size]i32 = [_]i32{0} ** array_size;
    printArray(@TypeOf(second_array), &second_array);

    // Modify arrays using element pointers
    const small_array = [_]u32{ 1, 2, 3 };
    var large_array = [_]u32{ 0, 0, 0, 0, 0, 0, 0 };
    printArray(@TypeOf(large_array), &large_array);
    const ptr = &large_array[0];
    ptr.* = small_array[2];
    printArray(@TypeOf(large_array), &large_array);
}
