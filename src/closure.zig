const std = @import("std");

fn closure(comptime func: anytype) *anyopaque {
    const internal_struct = struct {
        pub fn call(params: i32, b: f32) void {
            std.debug.print("\nParams {any}", .{ params });
            std.debug.print("\n...Run the closure", .{});
            func(params, b);
        }
    };
    return &internal_struct.call;
}

pub fn internal_fn(a: i32, b: f32) void {
    std.debug.print("\nInternal {any}", .{ @as(f32, @floatFromInt(a + 2)) + b });
}

pub fn main() !void {
    const c = closure(internal_fn);
    c(2, 3.1415);

    // const std_in = std.io.getStdIn();
    // var in_buffer = std.io.bufferedReader(std_in.reader());
    // var reader = in_buffer.reader();

    // var msg_buf: [512]u8 = undefined;
    // std.debug.print("\n", .{});
    // while(true) {
    //     var input = try reader.readUntilDelimiter(&msg_buf, '\n');
    //     std.debug.print("\n{s}", .{ input });
    // }
}
