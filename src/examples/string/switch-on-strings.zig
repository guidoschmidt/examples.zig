/// reference: https://www.openmymind.net/Switching-On-Strings-In-Zig/
const std = @import("std");

pub fn main() !void {
    // You can't switch on string out of the box:
    // switch (color) {
    //     "red" => {},
    //     "green" => {},
    //     "blue" => {},
    //     else => {},
    // }

    // Reasons:
    // 1. ambiguity around string identity, e.g.
    //   - when are two strings considered to be the same?
    //   - is a null terminated string the same as a non-null-terminated?
    // 2. optimization in the switch statement, which are not possible with strings
    //    https://en.wikipedia.org/wiki/Branch_table

    // You can either user
    // A.) std.mem.eql
    const colours = [_][]const u8{ "red", "green", "blue", "yellow", "pink" };

    const rng_gen = std.Random.DefaultPrng;
    var rng: std.Random.Xoshiro256 = rng_gen.init(@intCast(std.time.nanoTimestamp()));
    const random_index = rng.random().intRangeAtMost(usize, 0, colours.len - 1);

    const colour = colours[random_index];
    if (std.mem.eql(u8, colour, "red")) {
        std.debug.print("Selected: red\n", .{});
    } else if (std.mem.eql(u8, colour, "blue")) {
        std.debug.print("Selected: blue\n", .{});
    } else if (std.mem.eql(u8, colour, "green")) {
        std.debug.print("Selected: green\n", .{});
    } else {
        std.debug.print("Other color: {s}\n", .{colour});
    }

    // B.) represent string options as enum
    const Color = enum {
        red,
        blue,
        green,
        yellow,
    };

    const selected_enum_colour = std.meta.stringToEnum(Color, colour) orelse {
        return error.InvalidChoice;
    };

    switch (selected_enum_colour) {
        .red => {
            std.debug.print("Selected: {s}\n", .{colour});
        },
        .green => {
            std.debug.print("Selected: {s}\n", .{colour});
        },
        .blue => {
            std.debug.print("Selected: {s}\n", .{colour});
        },
        else => {
            std.debug.print("Selected: {s}\n", .{colour});
        },
    }

    // you can even skip defininig an enum type by leveraging zigs anonymous types:
    const selected_enum_colour_anonymous = std.meta.stringToEnum(enum { red, blue, green, yellow }, colour) orelse return error.InvalidChoice;

    switch (selected_enum_colour_anonymous) {
        .red => std.debug.print("Selected: red\n", .{}),
        else => std.debug.print("Selected another colour than red: {s}", .{colour}),
    }
}
