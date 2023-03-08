const std = @import("std");
    
const uri = std.Uri.parse("https://ziglang.org") catch unreachable;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var c: std.http.Client = .{ .allocator = allocator };
    defer c.deinit();

    var req = try c.request(uri, .{}, .{});
    var buffer: []u8 = allocator.alloc(u8, 1024) catch unreachable;
    _ = req.readAll(buffer) catch unreachable;
    defer req.deinit();

    std.debug.print("\n→ {?}", .{ req.response.state });
    std.debug.print("\n  {s}", .{ buffer });
}
