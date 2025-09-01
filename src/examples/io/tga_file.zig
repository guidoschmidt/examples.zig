const std = @import("std");
const fs = std.fs;


pub fn main() !void {
var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

    const file_path = "test.tga";
    const file = try fs.cwd().createFile(file_path, .{ .read = true });

    const width = 100;
    const height = 100;
    const header: []const u8 = &[_]u8{ 0, 2, 0, 0, 0, 0, width, height, 24};
    _ = try file.write(header);
    const buffer = try allocator.alloc(u8, width * height * 3);
    for (0..width) |x| {
        for (0..height) |y| {
            buffer[y * width + x + 0] = @intCast(x);
            buffer[y * width + x + 1] = @intCast(y);
            buffer[y * width + x + 2] = 0;
        }
    }
    _ = try file.write(buffer);
    file.close();
}
