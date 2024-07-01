const std = @import("std");

const json = std.json;
const print = std.debug.print;

pub fn main() !void {
    // ------ Before 0.12.0 ------ 
    // const Cat = struct { 
    //     age: i32, 
    //     male: bool
    // };
    // const json_str_cat =
    //     \\ {
    //     \\   "age": 3, "male": true
    //     \\ }
    // ;
    // var stream = json.TokenStream.init(json_str_cat);
    // const parsed_cat = try json.parse(Cat, &stream, .{});
    // print("\nParsed cat:\n{?} y, male: {?}\n", .{ parsed_cat.age, parsed_cat.male });

    
    // Working with string in JSON, the parser will need an allocator
    // const Person = struct {
    //     name: []u8,
    //     age: u32
    // };
    // const json_str_person =
    //     \\ {
    //     \\   "name": "Matt", "age": 30
    //     \\ }
    // ;
    // stream = json.TokenStream.init(json_str_person);
    // const parsed_person = try std.json.parse(Person, &stream, .{ .allocator = arena.allocator() });
    // print("\nParsed Person:\n{s}: {?}", .{ parsed_person.name, parsed_person.age });

    // ------ 0.12.0 ------
    var arena = std.heap.ArenaAllocator.init(std.heap.c_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();
    

    const ImagePayload = struct {
        image_data: []const u8,
        folder_name: []const u8,
        file_name: []const u8,
        ext: []const u8,
    };
    const payload = ImagePayload{
        .ext = "png",
        .file_name = "test",
        .folder_name = "test_zig",
        .image_data = "",
    };
    var string_stream = std.ArrayList(u8).init(allocator);
    try std.json.stringify(payload, .{}, string_stream.writer());

    print("\n{s}", .{ string_stream.items });
}
