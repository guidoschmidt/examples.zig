const std = @import("std");
const Wav = @import("Wav.zig");

pub fn main() !void {
    const wav = Wav {
        .duration = 10
    };
    try wav.save("test.wav");
}
