const std = @import("std");

const json = std.json;
const print = std.debug.print;

pub fn main() !void {
    const Cat = struct { 
        age: i32, 
        male: bool
    };
    const json_str_cat =
        \\ {
        \\   "age": 3, "male": true
        \\ }
    ;
    var stream = json.TokenStream.init(json_str_cat);
    const parsed_cat = try json.parse(Cat, &stream, .{});
    print("\nParsed cat:\n{?} y, male: {?}\n", .{ parsed_cat.age, parsed_cat.male });

    // Working with string in JSON, the parser will need an allocator
    var arena = std.heap.ArenaAllocator.init(std.heap.c_allocator);
    defer arena.deinit();
    const Person = struct {
        name: []u8,
        age: u32
    };
    const json_str_person =
        \\ {
        \\   "name": "Matt", "age": 30
        \\ }
    ;
    stream = json.TokenStream.init(json_str_person);
    const parsed_person = try std.json.parse(Person, &stream, .{ .allocator = arena.allocator() });
    print("\nParsed Person:\n{s}: {?}", .{ parsed_person.name, parsed_person.age });
}
