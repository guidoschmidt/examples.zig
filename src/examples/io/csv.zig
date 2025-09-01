const std = @import("std");
const fs = std.fs;
const print = std.debug.print;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const file_path = "./data/dailyActivity_merged.csv";
    const file = try fs.cwd().openFile(file_path, .{ .mode = .read_only });
    defer file.close();

    const stats = try file.stat();
    std.log.info("\nReading {s}\nCSV file size: {d}", .{ file_path, stats.size });
    var buffer_reader: [1024]u8 = undefined;
    var reader = file.readerStreaming(&buffer_reader);

    var column_labels = std.array_list.Managed(u8).init(allocator);
    var column_labels_writer = column_labels.writer().adaptToNewApi(&.{});
    defer column_labels.deinit();
    _ = try reader.interface.streamDelimiter(&column_labels_writer.new_interface, '\n');
    var column_labels_it = std.mem.tokenizeSequence(u8, column_labels.items, ",");

    var array = std.array_list.Managed(u8).init(allocator);
    defer array.deinit();
    var writer = array.writer().adaptToNewApi(&.{});
    var i: u32 = 0;
    while (true) {
        array.clearAndFree();
        _ = reader.interface.streamDelimiter(&writer.new_interface, '\n') catch {
            break;
        };
        _ = try reader.interface.takeByte();
        var iter = std.mem.tokenizeSequence(u8, array.items, ",");
        print("\n{d} ", .{i});
        inline for (0..64) |_| {
            print("{s}", .{"_"});
        }
        print("\n", .{});
        column_labels_it.reset();
        for (0..3) |_| {
            const col = column_labels_it.next();
            print("{s:<20} | ", .{col.?});
        }
        print("\n", .{});
        for (0..3) |_| {
            const elem = iter.next();
            print("{s:<20} | ", .{elem orelse ""});
        }
        i += 1;
    }
}
