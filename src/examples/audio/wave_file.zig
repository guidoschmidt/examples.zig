/// Sources:
/// https://blog.jfo.click/makin-wavs-with-zig/
/// https://zig.news/xq/re-makin-wavs-with-zig-1jjd
const std = @import("std");
const Wav = @import("shared").Wav;

pub fn main() !void {
    const wav = Wav{ .duration = 10 };
    try wav.save("test.wav");
}
