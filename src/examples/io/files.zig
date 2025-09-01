const std = @import("std");
const fs = std.fs;
const panic = std.debug.panic;
const print = std.debug.print;

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

pub fn main() !void {
    // Reading files
    const file_path = try std.fs.path.join(allocator, &.{ "data", "infile.txt" });
    var read_file = try (fs.cwd().openFile(file_path, .{ .mode = .read_only }));
    const contents = try read_file.readToEndAlloc(allocator, std.math.maxInt(u8));
    print("\nTest of file {s}:\n{s}Type: {any}", .{ file_path, contents, @TypeOf(contents) });

    // Writing files
    const write_file = try std.fs.cwd().createFile("save.txt", .{});
    defer write_file.close();
    var writer_buffer: [1024]u8 = undefined;
    var write_file_writer = write_file.writer(&writer_buffer);
    var buf: [32]u8 = undefined;
    for (0..12) |i| {
        const result = try std.fmt.bufPrint(&buf, "Number {d}\n", .{i});
        try write_file_writer.interface.writeAll(result);
    }

    // Get extension of file path
    const basepath = std.fs.path.basename(file_path);
    const extension = std.fs.path.extension(basepath);
    const filename = std.fs.path.stem(file_path);
    print("\nbasepath: {s}\nextension: {s}\nfilename: {s}", .{ basepath, extension, filename });
}
