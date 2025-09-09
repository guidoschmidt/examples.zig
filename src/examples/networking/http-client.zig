const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var client = std.http.Client{
        .allocator = allocator,
    };

    var body: std.Io.Writer.Allocating = .init(allocator);
    defer body.deinit();
    try body.ensureUnusedCapacity(1024);

    _ = try client.fetch(.{
        .location = .{ .url = "https://echo.free.beeceptor.com" },
        .extra_headers = &.{},
        .method = .GET,
        .response_writer = &body.writer,
    });

    const response = try body.toOwnedSlice();
    std.debug.print("\nResult:\n{s}\n", .{response});
}
