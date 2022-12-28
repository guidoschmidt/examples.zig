const std = @import("std");

const math = std.math;
const print = std.debug.print;
const bits = std.bit_set;

pub fn range(len: usize) []const void {
    return @as([*]void, undefined)[0..len];
}

pub fn main() !void {
    for (range(32)) |_, i| {
        const init_value: u8 = @intCast(u8, i);
        comptime var bit_count: u8 = 8;
        var bit_set = bits.IntegerBitSet(bit_count){ .mask = init_value };
        print("\nValue {} in bits:", .{init_value});
        print("\nBitSet size: {}", .{bit_set.capacity()});
        print("\nBitSet count: {}", .{bit_set.capacity()});
        var idx: u16 = 0;
        while (idx < bit_set.capacity()) {
            const reverse_idx = ((bit_set.capacity() - 1) - idx);
            const val: bool = bit_set.isSet(reverse_idx);
            const bin_pow: u16 = math.pow(u16, 2, @intCast(u16, reverse_idx));
            const ten_div = @floatToInt(u8, (math.floor(math.log10((@intToFloat(f32, bin_pow)) + 1))));
            const whitespace: [3]u8 = .{' '} ** 3;
            print("\n{} [{s}{}]: {}", .{ idx, whitespace[0..(3 - ten_div)], bin_pow, @boolToInt(val) });
            idx += 1;
        }
        idx = 0;
        print("\n----------\nBinary: \n", .{});
        while (idx < bit_set.capacity()) {
            var val: bool = bit_set.isSet((bit_set.capacity() - 1) - idx);
            print("{}", .{@boolToInt(val)});
            idx += 1;
        }
        print("\n----------\n", .{});
    }
}
