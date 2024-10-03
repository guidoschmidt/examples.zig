const std = @import("std");

const math = std.math;
const print = std.debug.print;
const bits = std.bit_set;

pub fn main() !void {
    for (0..32) |i| {
        const init_value: u8 = @intCast(i);
        const bit_count: u8 = 8;
        var bit_set = bits.IntegerBitSet(bit_count){ .mask = init_value };
        print("\nValue {} in bits:", .{init_value});
        print("\nBitSet size: {}", .{bit_set.capacity()});
        print("\nBitSet count: {}", .{bit_set.capacity()});
        var idx: u16 = 0;
        while (idx < bit_set.capacity()) {
            const reverse_idx = ((bit_set.capacity() - 1) - idx);
            const val: bool = bit_set.isSet(reverse_idx);
            const bin_pow: u16 = math.pow(u16, 2, @intCast(reverse_idx));
            const ten_div: u8 = @intFromFloat(math.floor(math.log10(@as(f32, @floatFromInt(bin_pow)) + 1)));
            const whitespace: [3]u8 = .{' '} ** 3;
            print("\n{} [{s}{}]: {}", .{ idx, whitespace[0..(3 - ten_div)], bin_pow, @intFromBool(val) });
            idx += 1;
        }
        idx = 0;
        print("\n----------\nBinary: \n", .{});
        while (idx < bit_set.capacity()) {
            const val: bool = bit_set.isSet((bit_set.capacity() - 1) - idx);
            print("{}", .{ @intFromBool(val) });
            idx += 1;
        }
        print("\n----------\n", .{});
    }
}
