const std = @import("std");
    
pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var client: std.http.Client = .{ .allocator = allocator };
    defer client.deinit();

    var body = std.ArrayList(u8).init(allocator);
    defer body.deinit();

    const req = try client.fetch(.{
        .location = .{ .url = "https://ziglang.org" },
        .extra_headers = &.{},
        .response_storage = .{
            .dynamic = &body,
        }
    });

    if (req.status == .ok) {
        std.debug.print("\n200 -- Response {s}", .{ body.items });
    } else {
        std.debug.print("\nSTATUS {d}", .{ req.status });
    }
}
