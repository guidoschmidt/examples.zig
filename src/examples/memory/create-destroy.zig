// Source: https://www.openmymind.net/learning_zig/heap_memory/
const std = @import("std");

const Player = struct {
    name: []const u8,
    id: u32,

    pub fn format(self: Player, writer: *std.Io.Writer) std.Io.Writer.Error!void {
        try writer.print("{s} {d}", .{ self.name, self.id });
    }
};

// allocator.create allocates a single instance
fn createPlayer(allocator: std.mem.Allocator, id: u32) !*Player {
    const player = try allocator.create(Player);
    player.*.name = "Player";
    player.*.id = id;
    return player;
}

pub fn main() !void {
    var gpa = std.heap.DebugAllocator(.{}){};
    const allocator = gpa.allocator();

    for (0..10) |i| {
        const player = try createPlayer(allocator, @intCast(i));
        std.debug.print("{f}\n", .{player});
        // allocator.destroy frees a single instance
        defer allocator.destroy(player);
    }
}
