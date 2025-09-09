const std = @import("std");

const Client = std.http.Client;

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    var response: std.Io.Writer.Allocating = .init(allocator);
    defer response.deinit();

    var client: Client = .{
        .allocator = allocator,
    };
    defer client.deinit();

    _ = try client.fetch(.{
        .method = .POST,
        .location = .{
            .url = "https://echo.free.beeceptor.com",
        },
        .payload = "Hello World",
        .response_writer = &response.writer,
    });

    const response_data = try response.toOwnedSlice();
    std.debug.print("{s}\n", .{response_data});
}
