const std = @import("std");

const random = std.rand.DefaultPrng;
var rng: std.rand.Xoshiro256 = random.init(0);

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();


    // Create a fixed size array with 10 elements
    var fixed_array = [_]u8{ 0 } ** 10;
    std.debug.print("{}", .{ @TypeOf(fixed_array) });
    for (fixed_array[5..10]) |i| {
        fixed_array[i] = 10;
    }
    for (fixed_array) |e| {
        std.debug.print("{d}\n", .{ e });
    }

    // Now how can we create an array with X elements, where X
    // is a variable we define earlier
    const dynamic_size = rng.random().intRangeAtMost(u16, 1, 99);
    var dynamic_array = try allocator.alloc(u8, dynamic_size);
    std.debug.print("dynamic array type {}\n", .{ @TypeOf(dynamic_array) });
    std.debug.print("dynamic array length {}\n", .{ dynamic_array.len });
    dynamic_array[0] = 99;
    for (0..dynamic_array.len) |i| {
        dynamic_array[i] = 5;
        std.debug.print("→ {d}: {}\n", .{ i, dynamic_array[i] });
    }
}
