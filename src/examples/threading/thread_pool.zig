const std = @import("std");

const rng_gen = std.Random.Xoshiro256;
var rng = rng_gen.init(0);

fn heavyTask(i: usize) void {
    std.debug.print(">>> Thread: {d}\n", .{i});
    std.Thread.sleep(std.time.ns_per_s * rng.random().intRangeAtMost(u64, 2, 5));
}

pub fn main() !void {
    var thread_pool: std.Thread.Pool = undefined;
    try thread_pool.init(.{
        .allocator = std.heap.smp_allocator,
    });

    var wait_group: std.Thread.WaitGroup = .{};

    const thread_count = 40;
    for (0..thread_count) |i| {
        thread_pool.spawnWg(&wait_group, heavyTask, .{i});
    }
    wait_group.wait();
}
