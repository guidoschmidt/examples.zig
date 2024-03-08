const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var ring_buffer = try std.RingBuffer.init(allocator, 10);

    var i: u32 = 0;
    while(i < 300) : (i += 1) {
        var r = std.rand.Random.int(u32);
        ring_buffer.writeAssumeCapacity(r);
    }
    var mean: u32 = 0;
    std.debug.print("\n", .{});
    for (ring_buffer.data) |elem| {
        mean += elem;
        std.debug.print("{d},", .{ elem });
    }
    mean /= 10;
    std.debug.print("\nMean: {d}", .{ mean });
}
