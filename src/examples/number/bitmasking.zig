const std = @import("std");

pub fn main() !void {
    const input: u16 = 0b100001001001;
    const one: u16 = 1;

    for (0..12) |p| {
        const port: u4 = @intCast(p);
        const matches: bool = (input & (one << port)) >= 1;
        const str = if (matches) "●" else "○";
        std.debug.print("\nPort {d: >2} [{d: >8}]:    {s: >2}    {any: >4}", .{
            port,
            (input << port),
            str,
            matches,
        });
    }
}
