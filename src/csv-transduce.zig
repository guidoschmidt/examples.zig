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

pub fn wrapNoOpts(comptime outer: []const u8, comptime inner: []const u8) []const u8 {
    return "<" ++ outer ++ ">" ++ inner ++ "</" ++ outer ++ ">";
}

pub fn wrap(comptime outer: []const u8, comptime options: []const u8, comptime inner: []const u8) []const u8 {
    return "<" ++ outer ++ " " ++ options ++ ">" ++ inner ++ "</" ++ outer ++ ">";
}


pub fn main() !void {

    const inner = "<circle cx=\"50\" cy=\"50\" r=\"40\" stroke=\"green\" stroke-width=\"4\" fill=\"yellow\" />";
    _ = inner;

    const svg = f.partial2([]const u8, wrap, "svg", "viewBox=\"0 0 300 100\" xmlns=\"http://www.w3.org/2000/svg\"");
    const g = f.partial([]const u8, wrapNoOpts, "g");
    const t = f.partial2([]const u8, wrap, "text", "fill=\"black\" x=\"0\" y=\"0\"");
    
    const output = svg(g(t("Test")));
    std.debug.print("\n{s}", .{ output });

    
    // const file_path = "out/test.svg";
    // const file = try fs.cwd().createFile(file_path, .{});
    // defer file.close();
    // _ = try file.write(output);


    
    // const input = [_]f32{9, 18, 27};
    // _ = input;
    // const result = try map([]f32, @as(f32, 10.0), f.partial(f32, mul, 9));
    // for (result) |r| {
    //     std.debug.print("\n{d}", .{ r });
    // }

    // const file_path = "data/dailyActivity_merged.csv";
    // const file = try fs.cwd().openFile(file_path, .{ .mode = .read_only });
    // defer file.close();
    // const reader = file.reader();
    // var contents = std.ArrayList(u8).init(allocator);
    // try reader.streamUntilDelimiter(contents.writer(), '\n', null);
    // std.debug.print("\n{s}\nCount: {d}", .{ contents.items, contents.items.len });

    // const line : []const u8 = try allocator.dupe(u8, contents.items);

    // var splitIt = std.mem.tokenize(u8, line, ",");
    // while (splitIt.next()) |entry| {
    //     std.debug.print("\n{s}", .{ entry });
    // }

    // const cols = [_][]const u8 { "TotalSteps", "TotalDistance" };
    // comptime var fields: [cols.len]std.builtin.Type.StructField = undefined;
    // comptime var i: usize = 0;
    // inline for (cols) |col| {
    //     std.debug.print("\n\n{s}", .{ col });
    //     fields[i] = .{
    //             .name = col,
    //             .type = u8,
    //             .default_value = "",
    //             .is_comptime = false,
    //             .alignment = @alignOf(u8),
    //     };
    //     i += 1;
    // }

    // std.debug.print("\n{d}", .{ fields.len });
    // inline for (fields) |field| {
    //     std.debug.print("\n{s}, {any}", .{ field.name, field.type });
    // }
    // const decls: [0]std.builtin.Type.Declaration = [_]std.builtin.Type.Declaration{};
    // const TestType = @Type(.{
    //     .Struct = .{
    //         .layout = .Auto,
    //         .is_tuple = false,
    //         .fields = &fields,
    //         .decls = &decls,
    //     },
    // });
    // const inst: TestType = TestType{ .TotalSteps = 3 };
    // std.debug.print("\n\n{any}\n{any}", .{ TestType, inst });
}
