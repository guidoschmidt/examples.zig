const std = @import("std");
const fs = std.fs;
const print = std.debug.print;

pub fn main() !void {
var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const file_path = "data/dailyActivity_merged.csv";
    const file = try fs.cwd().openFile(file_path, .{ .mode = .read_only });
    defer file.close();

    const stats = try file.stat();
    std.log.info("\nReading {s}\nCSV file size: {d}", .{ file_path, stats.size });
    const reader = file.reader();

    var column_labels = std.ArrayList(u8).init(allocator);
    defer column_labels.deinit();
    try reader.streamUntilDelimiter(column_labels.writer(), '\n', null);
    var column_labels_it = std.mem.tokenize(u8, column_labels.items, ",");

    var array = std.ArrayList(u8).init(allocator);
    defer array.deinit();
    const writer = array.writer();
    var i: u32 = 0;
    while(true) {
        array.clearAndFree();
        reader.streamUntilDelimiter(writer, '\n', null) catch {
            break;
        };
        var iter = std.mem.tokenize(u8, array.items, ",");
        print("\n{d} ", .{ i });
        inline for(0..64) |_| {
            print("{s}", .{ "_" });
        }
        print("\n", .{});
        column_labels_it.reset();
        for (0..3) |_| {
            const col = column_labels_it.next();
            print("{s:<20} | ", .{ col.? });
        }
        print("\n", .{});
        for (0..3) |_| {
            const elem = iter.next();
            print("{s:<20} | ", .{ elem.? });
        }
        i += 1;
    }
}
