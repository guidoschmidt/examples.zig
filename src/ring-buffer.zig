const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var ring_buffer = try std.RingBuffer.init(allocator, 10);

    var i: u32 = 0;

    var prng = std.Random.DefaultPrng.init(blk: {
        var seed: u64 = undefined;
        try std.posix.getrandom(std.mem.asBytes(&seed));
        break :blk seed;
    });
    var rng = prng.random();

    while (i < 300) : (i += 1) {
        const r = rng.int(u8);
        ring_buffer.writeAssumeCapacity(r);
        std.debug.print("\n{any}", .{ring_buffer});
    }
    var mean: u32 = 0;
    std.debug.print("\n", .{});
    for (ring_buffer.data) |elem| {
        mean += elem;
        std.debug.print("{d},", .{elem});
    }
    mean /= 10;
    std.debug.print("\nMean: {d}", .{mean});
}
