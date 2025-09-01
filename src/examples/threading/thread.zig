const std = @import("std");

pub fn main() !void {
    var arr: [4]i32 = .{ 1, 25, -4, 10 };
    var max_value: i32 = undefined;
    try findMax(&max_value, &arr);
    std.debug.print("\nMax value: {d}", .{ max_value });
}

fn findMax(max_value: *i32, values: []i32) !void {
    const THRESHOLD: usize = 2;
    if(values.len <= THRESHOLD) {
        var res = values[0];
        for(values)|it|{
            res=@max(res, it);
        }
        max_value.* = res;
        return;
    }

    const mid = values.len / 2;
    const left = values[0..mid];
    const right = values[mid..];

    var v1: i32 = undefined;
    const t1 = try std.Thread.spawn(.{}, findMax, .{ &v1, left });
    t1.join();

    var v2: i32 = undefined;
    const t2 = try std.Thread.spawn(.{}, findMax, .{ &v2, right });
    t2.join();

    max_value.* = @max(v1, v2);
}
