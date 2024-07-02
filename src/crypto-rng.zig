const std = @import("std");

pub fn main() !void {
    const rng = std.crypto.random;

    for (0..100) |i| {
        const mod = @mod(i, 4);
        switch (mod) {
            0 => {
                std.debug.print("\n{d}", .{ rng.float(f32) });
            },
            1 => {
                std.debug.print("\n{any}", .{ rng.boolean() });
            },
            2 => {
                std.debug.print("\n{d}", .{ rng.int(i16) });
            },
            else => {
                std.debug.print("\n{d}", .{ rng.intRangeAtMost(i16, -10, 200) });
            }
        }
    }

} 
