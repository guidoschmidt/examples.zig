const std = @import("std");

const User = struct {
    id: u32,
    age: u8,
};

pub fn main() !void {
    const age_offset = @offsetOf(User, "age");
    std.debug.print("\nByte offset of 'age' in User struct: {d}", .{age_offset});
}
