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
}
