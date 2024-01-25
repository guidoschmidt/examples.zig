//! Source: https://stackoverflow.blog/2022/01/31/the-complete-beginners-guide-to-dynamic-programming
//!
//! In a technical interview, you've been given an array of numbers and you need to
//! find a pair of numbers that are equal to the given target value. Numbers can be
//! either positive, negative, or both. Can you design an algorithm that works in
//! O(n)—linear time or greater?
//!
//! const sequence = [_]u32{ 8, 10, 2, 9, 7, 5 }
//! let results = pairValues(sum: 11) = //returns (9, 2)
const std = @import("std");

// Memoized version
// O(n + d)
fn pairValuesMemoized(alloc: std.mem.Allocator, sum: u32, sequence: []const u32) ![2]u32 {
    var addends = std.AutoHashMap(u32, u32).init(alloc);
    for (sequence) |a| {
        const diff = sum -| a;
        if (addends.contains(diff)) return [2]u32{ a, diff };
        try addends.put(a, a);
    }
    return [2]u32{0, 0};
}

// Non memoized version
// O(n^2)
fn pairValues(sum: u32, sequence: []const u32) [2]u32 {
    for (sequence) |a| {
        const diff = sum -| a;
        for (sequence)|b| {
            if (b != a and b == diff) {
                return [2]u32{ a, b };
            }
        }
    }
    return [2]u32{ 0, 0 };
}

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const rng_gen = std.rand.DefaultPrng;
    var rng: std.rand.Xoshiro256 = rng_gen.init(0);

    const how_many = 250000000;
    var sequence: []u32 = try allocator.alloc(u32, how_many);
    std.debug.print("\nSequence: [first 100 values]\n", .{});
    for (0..100) |i| {
        sequence[i] = rng.random().intRangeAtMost(u32, 1, 100);
        std.debug.print("{d}, ", .{ sequence[i] });
    }
    std.debug.print("...\n", .{});

    var timer = try std.time.Timer.start();

    var t0 = timer.lap();
    const result_from_memo = try pairValuesMemoized(allocator, 11, sequence);
    var t1 = timer.lap();
    std.debug.print("\x1B[34m", .{});
    std.debug.print("\n\nMemoized [O(n + d)]:   {any}", .{ result_from_memo });
    std.debug.print("\n  ⏱ {d} s", .{ (t1 - t0) / std.time.ns_per_s });

    t0 = timer.lap();
    const result = pairValues(11, sequence);
    t1 = timer.lap();
    std.debug.print("\x1B[33m", .{});
    std.debug.print("\n\nNon-Memoized [O(n^2)]: {any}", .{ result });
    std.debug.print("\n  ⏱ {d} s", .{ (t1 - t0) / std.time.ns_per_s });

    std.debug.print("\x1B[0m", .{});
}
