const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var client = std.http.Client{
        .allocator = allocator,
    };

    var body_file = try std.fs.cwd().createFile("http-response", .{});
    defer body_file.close();
    var buffer: [1]u8 = undefined;
    var body_writer = body_file.writerStreaming(&buffer);

    _ = try client.fetch(.{
        .location = .{ .url = "https://echo.free.beeceptor.com" },
        .extra_headers = &.{},
        .method = .GET,
        .response_writer = &body_writer.interface,
    });
}
