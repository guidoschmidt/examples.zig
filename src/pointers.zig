const std = @import("std");



const Node = struct {
    name: []const u8,

    pub fn format(self: Node,
                  comptime fmt: []const u8,
                  options: std.fmt.FormatOptions,
                  writer: anytype) !void {
        _ = fmt;
        _ = options;
        try writer.print("Node '{s}'", .{ self.name });
    }
};


pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var list = std.ArrayList(*Node).init(allocator);
    var node = Node {
        .name = "abc"
    };
    try list.append(&node);

    // Swap the item by assigning to the pointer
    list.items[0].* = Node {
        .name = "xyz",
    };

    std.debug.print("\n{any}", .{ list.items[0] });
}
