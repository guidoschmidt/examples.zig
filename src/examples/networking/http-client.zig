const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var client: std.http.Client = .{ .allocator = allocator };
    defer client.deinit();

    var body = std.array_list.Managed(u8).init(allocator);
    defer body.deinit();

    var writer_buffer: [1024]u8 = undefined;
    var writer = std.fs.File.stdout().writer(&writer_buffer);

    const req = try client.fetch(.{
        .location = .{ .url = "https://ziglang.org" },
        .extra_headers = &.{},
        .response_writer = &writer.interface,
    });

    if (req.status == .ok) {
        std.debug.print("\n200 -- Response {s}", .{body.items});
    } else {
        std.debug.print("\nSTATUS {d}", .{req.status});
    }
}
