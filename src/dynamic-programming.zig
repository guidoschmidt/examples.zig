// Source: https://qsantos.fr/2024/01/04/dynamic-programming-is-not-black-magic/
const std = @import("std");
const time = std.time;

const Timer = time.Timer;

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
    const input: u32 = 42; // !Choose wisely

    var timer = Timer.start() catch {
        unreachable;
    };
    const result_dp = fibonacciDynamicProgramming(u128, input);
    var elapsed: f64 = @floatFromInt(timer.read()) ;
    var dur: u64 = @intFromFloat(elapsed / time.ns_per_ms);
    std.debug.print("\nDP:        {d: >30} [{d} ms]", .{ result_dp, dur });

    timer = Timer.start() catch {
        unreachable;
    };
    const result_recur = fibonacciRecursive(u128, input);
    elapsed = @floatFromInt(timer.read()) ;
    dur = @intFromFloat(elapsed / time.ns_per_ms);
    std.debug.print("\nRecursive: {d: >30} [{d} ms]", .{ result_recur, dur });

}
