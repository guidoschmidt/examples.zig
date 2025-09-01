// Source: https://qsantos.fr/2024/01/04/dynamic-programming-is-not-black-magic/
const std = @import("std");
const time = std.time;

const Timer = time.Timer;

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

var cache = std.AutoHashMap(u128, u128).init(allocator);


fn fibonacciRecursiveMemoized(comptime T: type, n: T) T {
    if (n == 0) {
        cache.put(0, 0) catch unreachable;
        return 0;
    }
    if (n == 1) {
        cache.put(1, 1) catch unreachable;
        return 1;
    }
    const n_2 = cache.get(n - 2) orelse fibonacciRecursiveMemoized(T, n - 2);
    const n_1 = cache.get(n - 1) orelse fibonacciRecursiveMemoized(T, n - 1);
    if (!cache.contains(n - 2)) cache.put(n - 2, n_2) catch unreachable;
    if (!cache.contains(n - 1)) cache.put(n - 1, n_1) catch unreachable;
    return n_2 + n_1;
}

fn fibonacciRecursive(comptime T: type, n: T) T {
    if (n == 0) return 0;
    if (n == 1) return 1;
    return fibonacciRecursive(T, n - 2) + fibonacciRecursive(T, n - 1);
}

fn fibonacciDynamicProgramming(comptime T: type, n: T) T {
    if (n == 0) return 0;
    var previous_previous: T = 0;
    var previous: T = 1;
    for (0..@intCast(n - 1)) |_| {
        const current = previous_previous + previous;
        previous_previous = previous;
        previous = current;
    }
    return previous;
}

pub fn main() !void {
    const input_values = [_]u32{ 1, 2, 3, 8, 12, 30, 40, 42, 43, 44 };

    for (input_values) |input| {
        std.debug.print("\n\n>>> Input \x1B[33m{d}\x1B[0m → fibonacci", .{ input });

        var timer = Timer.start() catch {
            unreachable;
        };
        const result_dp = fibonacciDynamicProgramming(u128, input);
        var elapsed: f64 = @floatFromInt(timer.read()) ;
        var dur: u64 = @intFromFloat(elapsed / time.ns_per_ms);
        std.debug.print("\n\x1B[31mDynamic Programming:\n{d: >4} [{d} ms]", .{ result_dp, dur });

        
        timer = Timer.start() catch {
            unreachable;
        };
        const result_recur_memo = fibonacciRecursiveMemoized(u128, input);
        elapsed = @floatFromInt(timer.read()) ;
        dur = @intFromFloat(elapsed / time.ns_per_ms);
        std.debug.print("\n\x1B[32mRecursive (Memoized):\n{d: >4} [{d} ms]", .{ result_recur_memo, dur });

        
        timer = Timer.start() catch {
            unreachable;
        };
        const result_recur = fibonacciRecursive(u128, input);
        elapsed = @floatFromInt(timer.read()) ;
        dur = @intFromFloat(elapsed / time.ns_per_ms);
        std.debug.print("\n\x1B[34mRecursive:\n{d: >4} [{d} ms]", .{ result_recur, dur });

        std.debug.print("\x1B[0m", .{});
    }
}
