const std = @import("std");

fn tick() void {
    std.debug.print("\nTick…", .{});
}

pub fn main() !void {
    var timer = try std.time.Timer.start();
    while (true) {
        std.time.sleep(std.time.ns_per_ms * 13);
        const dur = timer.lap();
        std.debug.print("\n{any}", .{ dur / std.time.ns_per_ms });
    }
}
