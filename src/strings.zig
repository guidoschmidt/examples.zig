const std = @import("std");

pub fn main() !void {
    // 1. Initialize a string that con't be changed
    const non_editable_string = "I will always be the same";
    // Try commenting in this line
    //non_editable_string = "Test";
    std.debug.print("\n{s}", .{ non_editable_string });
    std.debug.print("\n{any}", .{ @TypeOf(non_editable_string) });


    
    // 2. Initialize an editable string
    //    as long as the length of the strings stays the same
    //    you can edit and overwrite it
    var editable_string = "You can change me?".*;
    editable_string[4] = 'm';
    editable_string[5] = 'a';
    editable_string[6] = 'y';
    std.debug.print("\n{s}", .{ editable_string });
    editable_string = "You can change me!".*;
    std.debug.print("\n{s}", .{ editable_string });
    std.debug.print("\n{any}", .{ @TypeOf(editable_string) });

    // 3. Get a substring
    const substring = editable_string[0..3];
    std.debug.print("\nSubstring: {s}", .{ substring });

    // 4. Chop a string into an array
    std.debug.print("\nstd.mem.split let's you split a string:", .{});
    var split_it = std.mem.split(u8, editable_string[0..], " ");
    while (split_it.next()) |part| {
        std.debug.print("\n    - {s}", .{ part });
    }

    // 5. Split a string every X chars:
    //    see: https://zig.news/pyrolistical/new-way-to-split-and-iterate-over-strings-2akh
    std.debug.print("\nstd.mem.window uses a 'rolling winodw' to split a string (u8 buffer) every x elements:", .{});
    const string_buffer = "Nature's first green is gold";
    var window_it = std.mem.window(u8, string_buffer, 3, 3);
    while (window_it.next()) |part| {
        std.debug.print("\n    - {s}", .{ part });
    }

    std.debug.print("\nstd.mem.window can even be a 'sliding winodw':", .{});
    window_it = std.mem.window(u8, string_buffer, 10, 1);
    while (window_it.next()) |part| {
        std.debug.print("\n    - {s}", .{ part });
    }
}
