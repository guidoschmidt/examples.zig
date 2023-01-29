const std = @import("std");
const zelda = @import("zelda");

const API_URL = "https://thispersondoesnotexist.com/image";

pub fn main() !void {
    // Create arena memory allocator
    var arena = std.heap.ArenaAllocator.init(std.heap.c_allocator);
    defer arena.deinit();

    // Perform a HTTP GET request
    var response = try zelda.get(arena.allocator(), API_URL);
    defer response.deinit();

    // Store the binary body data as file
    const file = std.fs.cwd().createFile("face.png", .{}) catch return;
    try file.writeAll(response.body.?);
    defer file.close();
}
