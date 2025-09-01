const std = @import("std");

fn printMap(map: *const [][]u8) void {
    std.debug.print("\n", .{});
    for (0..map.len) |x| {
        const row = map.*[x];
        std.debug.print("{d: >3}    ", .{x});
        for (0..row.len) |y| {
            std.debug.print("{c}", .{map.*[x][y]});
        }
        std.debug.print("\n", .{});
    }
}

fn fillMap(map: *const [][]u8) void {
    for (0..map.len) |x| {
        const row = map.*[x];
        for (0..row.len) |y| {
            map.*[x][y] = '#';
        }
    }
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    var map = try allocator.alloc([]u8, 10);
    for (0..map.len) |x| {
        map[x] = try allocator.alloc(u8, 12);
        for (0..map[x].len) |y| {
            map[x][y] = '.';
        }
    }
    printMap(&map);

    const map_copy: [][]u8 = try allocator.alloc([]u8, map.len);
    for (0..map.len) |x| {
        map_copy[x] = try allocator.alloc(u8, map[x].len);
        for (0..map[x].len) |y| map_copy[x][y] = map[x][y];
    }

    std.debug.print("\nMap:", .{});
    printMap(&map);
    std.debug.print("\nCopy:", .{});
    printMap(&map_copy);
    std.debug.print("\nAfter Fill:", .{});
    fillMap(&map);
    printMap(&map);
    printMap(&map_copy);
}
