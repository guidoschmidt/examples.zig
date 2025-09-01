const std = @import("std");
const json = std.json;
const print = std.debug.print;

pub fn main() !void {
    const ImagePayload = struct {
        image_data: []const u8,
        folder_name: []const u8,
        file_name: []const u8,
        ext: []const u8,
    };

    const payload = ImagePayload{
        .ext = "png",
        .file_name = "test",
        .folder_name = "test_zig",
        .image_data = "",
    };

    var buffer: [1024]u8 = undefined;
    var writer: std.io.Writer = .fixed(&buffer);
    try std.json.Stringify.value(payload, .{
        .whitespace = .indent_2,
    }, &writer);
    print("\nJSON:\n{s}\n", .{writer.buffered()});
}
