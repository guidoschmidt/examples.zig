const std = @import("std");
const fs = std.fs;
const panic = std.debug.panic;
const print = std.debug.print;

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

pub fn main() !void {
    const file_path = "assets/infile.txt";
    const file = try (fs.cwd().openFile(file_path, .{ .mode = .read_only }));
    const contents = try file.readToEndAlloc(allocator, std.math.maxInt(u8));
    print("\nContent of file {s}:\n{s}Type: {?}", .{ file_path, contents, @TypeOf(contents) });
}
