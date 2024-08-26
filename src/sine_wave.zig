/// Sources:
/// https://blog.jfo.click/makin-wavs-with-zig/
/// https://zig.news/xq/re-makin-wavs-with-zig-1jjd
const std = @import("std");

const SAMPLE_RATE = 44100;
const CHANNELS = 2;
const HEADER_SIZE = 36;
const SUBCHUNK1_SIZE = 16;
const AUDIO_FORMAT = 1;
const BIT_DEPTH = 8;
const BYTE_SIZE = 8;
const PI = std.math.pi;

fn write_header(seconds: u32, file: std.fs.File.Writer) !void {
    const num_samples: u32 = SAMPLE_RATE * seconds;
    try file.writeAll("RIFF");
    try file.writeInt(u32, @intCast(HEADER_SIZE + num_samples), .little);
    try file.writeAll("WAVEfmt ");
    try file.writeInt(u32, SUBCHUNK1_SIZE, .little);
    try file.writeInt(u16, AUDIO_FORMAT, .little);
    try file.writeInt(u16, CHANNELS, .little);
    try file.writeInt(u32, SAMPLE_RATE, .little);
    try file.writeInt(u32, SAMPLE_RATE * CHANNELS * (BIT_DEPTH / BYTE_SIZE), .little);
    try file.writeInt(u16, CHANNELS * (BIT_DEPTH / BYTE_SIZE), .little);
    try file.writeInt(u16, BIT_DEPTH, .little);
    try file.writeAll("data");
    try file.writeInt(u32, num_samples * CHANNELS * (BIT_DEPTH / BYTE_SIZE), .little);
}

fn sine_wave(comptime seconds: u32, file: std.fs.File.Writer, base_freq: f64) !void {
    var idx: u32 = 0;
    var freq: f64 = base_freq;
    while (idx < seconds * SAMPLE_RATE) : (idx += 1) {
        const sine: f64 = @sin(((@as(f64, @floatFromInt(idx)) * 2.0 * PI) / SAMPLE_RATE) * freq);
        const sample = ((sine + 1.0) / 2.0) * 255.0;
        const arr = [_]u8{ @intFromFloat(sample) };
        try file.writeAll(arr[0..]);
        freq += 0.001;
    }
}

pub fn main() !void {
    var file = try std.fs.cwd().createFile("sine.wav", .{});
    defer file.close();
    try write_header(3, file.writer());
    try sine_wave(3, file.writer(), 440.0);
}
