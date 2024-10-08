const std = @import("std");
const meta = std.meta;
const fs = std.fs;
const f = @import("lib/functional.zig");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

pub fn wrapNoOpts(comptime _: @TypeOf([]const u8), alloc: std.mem.Allocator, outer: []const u8, inner: []const u8) []const u8 {
    return std.fmt.allocPrint(alloc, "<{s}>{s}</{s}>", .{ outer, inner, outer }) catch return "";
}

pub fn wrap(comptime _: @TypeOf([]const u8), alloc: std.mem.Allocator, outer: []const u8, options: []const u8, inner: []const u8) []const u8 {
    return std.fmt.allocPrint(alloc, "<{s} {s}>{s}</{s}>", .{ outer, options, inner, outer }) catch return "";
}

pub fn main() !void {
    const svg = f.partialGeneric([]const u8, wrap, .{ allocator, "svg", "viewBox=\"0 0 800 300\" xmlns=\"http://www.w3.org/2000/svg\"" });
    const g = f.partialGeneric([]const u8, wrapNoOpts, .{ allocator, "g" });
    const t = f.partialGeneric([]const u8, wrap, .{ allocator, "text", "fill=\"black\" x=\"0\" y=\"0\"" });

    const svg_output = svg(g(t("Test")));
    std.debug.print("\nSVG:\n{s}", .{svg_output});

    const file_path = "out/test.svg";
    const file = try fs.cwd().createFile(file_path, .{});
    try file.writeAll(svg_output);
    file.close();

    std.debug.print("\nSaved as {s}\n", .{file_path});
}
