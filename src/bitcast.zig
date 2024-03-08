const std = @import("std");

pub fn main() !void {
    const input: f32 = -3.14159;
    const input_big = std.mem.nativeToBig(i32, @bitCast(input));

    const as_bytes = std.mem.asBytes(&input_big);
    std.debug.print("\nAs bytes: {s}, {any}", .{ as_bytes, @TypeOf(as_bytes) });


    const from_bytes = std.mem.bytesAsValue(i32, as_bytes[0..]);
    const from_bytes_native = std.mem.bigToNative(i32, from_bytes.*);
    const from_bytes_native_f: f32 = @bitCast(from_bytes_native);
    std.debug.print("\n{d}", .{ from_bytes_native_f });

}
