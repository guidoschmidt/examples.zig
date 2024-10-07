const std = @import("std");
const meta = std.meta;
const fs = std.fs;
const f = @import("lib/functional.zig");

var gpa = std.heap.GeneralPurposeAllocator(.{}){};
const allocator = gpa.allocator();

pub fn transduce(xform: anytype, xf: anytype, col: anytype) void {
    _ = col;
    _ = xf;
    _ = xform;
}

pub fn map(comptime R: type, arg: anytype, comptime fun: anytype) !R {
    const T = @typeInfo(@TypeOf(arg));
    std.debug.print("\n{any}\n{any}", .{ T, @typeInfo(@TypeOf(fun)) });
    return switch(T) {
        .Array => {
            const element_type = T.Array.child;
            const result = try allocator.alloc(element_type, arg.len);
            std.debug.print("\nElement Type {any}", .{ element_type });
            inline for(0..arg.len) |i| {
                result[i] = fun(element_type, arg[i]);
            }
            return result;
        },
        else => {
            const element_type = @TypeOf(arg);
            const result = try allocator.alloc(element_type, 1);
            result[0] = fun(element_type, arg);
            return result;
        }
    };
}

pub fn mul(comptime T: type, m: T, arg: T) T {
    return arg * m;
}

pub fn wrapNoOpts(comptime _: @TypeOf([]const u8), alloc: std.mem.Allocator, outer: []const u8, inner: []const u8) []const u8 {
    return std.fmt.allocPrint(alloc, "<{s}>{s}</{s}>", .{ outer, inner, outer }) catch return "";
}

pub fn wrap(comptime _: @TypeOf([]const u8), alloc: std.mem.Allocator, outer: []const u8, options: []const u8, inner: []const u8) []const u8 {
    return std.fmt.allocPrint(alloc, "<{s} {s}>{s}</{s}>", .{ outer, options, inner, outer }) catch return "";
}


pub fn main() !void {
    // const inner = "<circle cx=\"50\" cy=\"50\" r=\"40\" stroke=\"green\" stroke-width=\"4\" fill=\"yellow\" />";
    // _ = inner;

    const svg = f.partialGeneric([]const u8, wrap, .{ allocator, "sv", "viewBox=\"0 0 300 100\" xmlns=\"http://www.w3.org/2000/svg\""});
    const g = f.partialGeneric([]const u8, wrapNoOpts, .{ allocator, "g" });
    // const t = f.partial2([]const u8, wrap, "text", "fill=\"black\" x=\"0\" y=\"0\"");
    
    const output1 = svg(g("Test"));
    // const output = svg(output1);
    std.debug.print("\n{s}\n{s}", .{ output1, "" });
}
