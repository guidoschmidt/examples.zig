const std = @import("std");
const l = std.log.scoped(.@"Bit-Operations");

pub fn main() !void {
    l.info("----- 1. Complement -----", .{});
    const a = 0b1011;
    l.info("{b} → Complement: {b}", .{ a, ~@as(u8, a) });
}
