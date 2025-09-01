// source: https://www.ryanliptak.com/blog/zig-fieldparentptr-for-dumbos/
const std = @import("std");

const MyStruct = struct {
    a: u64 = undefined,
    b: bool = true,
    list: std.array_list.Managed(i64) = undefined,

    pub fn testFun(self: *MyStruct) void {
        std.debug.print("\n{any}", .{self});
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var instance = MyStruct{};

    const from_builtin: *MyStruct = @fieldParentPtr("a", &instance.a);
    std.debug.assert(&instance == from_builtin);
    from_builtin.list = std.array_list.Managed(i64).init(allocator);

    instance.testFun();
    from_builtin.testFun();
}
