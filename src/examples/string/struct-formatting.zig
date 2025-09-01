const std = @import("std");

const MyStruct = struct {
    name: []const u8,
    value: u32,

    pub fn format(self: MyStruct, writer: *std.Io.Writer) std.Io.Writer.Error!void {
        try writer.print("{s}", .{self.name});
    }
};

pub fn main() !void {
    const test_str = "Test String";
    std.debug.print("\n{s}", .{test_str});
    const example_struct = MyStruct{ .name = "Test", .value = 8 };

    std.debug.print("\n{f}", .{example_struct});
}
