const std = @import("std");

pub fn main() !void {
   var arena = std.heap.ArenaAllocator.init(std.heap.c_allocator);
    defer arena.deinit();
    var allocator = arena.allocator();

    const input = "All your base are belong to us!";

    const size = std.base64.standard.Encoder.calcSize(input.len);
    const b64_encoded: []u8 = try allocator.alloc(u8, size);
    _ = std.base64.standard.Encoder.encode(b64_encoded, input);

    std.debug.print("\n{s}", .{ b64_encoded });
}
