const std = @import("std");
const zelda = @import("zelda");

const API_URL_RANDOMFACE = "https://thispersondoesnotexist.com/image";
const API_URL_CHATSONIC = "https://api.writesonic.com/v2/business/content/chatsonic?engine=premium";

// Create arena memory allocator
var arena = std.heap.ArenaAllocator.init(std.heap.c_allocator);

fn get_random_face() !void {
    // Perform a HTTP GET request
    var response = try zelda.get(arena.allocator(), API_URL_RANDOMFACE);
    defer response.deinit();

    // Store the binary body data as file
    const file = std.fs.cwd().createFile("face.png", .{}) catch return;
    try file.writeAll(response.body.?);
    defer file.close();
}

const ChatSonicResponse = struct {
    message: []const u8,
};

fn get_chatsonic() !void {
    var response = try zelda.getAndParseResponse(ChatSonicResponse,
                                                 .{ .allocator = arena.allocator() },
                                                 arena.allocator(),
                                                 API_URL_CHATSONIC);
   defer std.json.parseFree(ChatSonicResponse, response, .{ .allocator = arena.allocator() });
    var stdout = std.io.getStdOut().writer();
    try stdout.print("My ip is {s}\n", .{response.message});
}

pub fn main() !void {
    defer arena.deinit();
    get_chatsonic() catch return;
}
