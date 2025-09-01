const std = @import("std");

fn tick() void {
    std.debug.print("\nTick…", .{});
}

pub fn main() !void {
    var timer = try std.time.Timer.start();
    while (true) {
        std.Thread.sleep(std.time.ns_per_s);
        const dur = timer.lap();
        tick();
        std.debug.print("\n{any}", .{dur / std.time.ns_per_s});
    }
}
