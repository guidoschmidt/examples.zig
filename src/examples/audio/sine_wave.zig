const std = @import("std");

const SAMPLE_RATE = 44100;
const CHANNELS = 1;
const HEADER_SIZE = 36;
const SUBCHUNK1_SIZE = 16;
const AUDIO_FORMAT = 1;
const BIT_DEPTH = 8;
const BYTE_SIZE = 8;
const PI = std.math.pi;

fn write_header(seconds: u32, file: *std.fs.File.Writer) !void {
    const num_samples: u32 = SAMPLE_RATE * seconds;
    try file.interface.writeAll("RIFF");
    try file.interface.writeInt(u32, @intCast(HEADER_SIZE + num_samples), .little);
    try file.interface.writeAll("WAVEfmt ");
    try file.interface.writeInt(u32, SUBCHUNK1_SIZE, .little);
    try file.interface.writeInt(u16, AUDIO_FORMAT, .little);
    try file.interface.writeInt(u16, CHANNELS, .little);
    try file.interface.writeInt(u32, SAMPLE_RATE, .little);
    try file.interface.writeInt(u32, SAMPLE_RATE * CHANNELS * (BIT_DEPTH / BYTE_SIZE), .little);
    try file.interface.writeInt(u16, CHANNELS * (BIT_DEPTH / BYTE_SIZE), .little);
    try file.interface.writeInt(u16, BIT_DEPTH, .little);
    try file.interface.writeAll("data");
    try file.interface.writeInt(u32, num_samples * CHANNELS * (BIT_DEPTH / BYTE_SIZE), .little);
}

fn sine_wave(comptime seconds: u32, file: *std.fs.File.Writer, base_freq: f64) !void {
    var idx: u32 = 0;
    var freq: f64 = base_freq;
    while (idx < seconds * SAMPLE_RATE) : (idx += 1) {
        const sine: f64 = @sin(((@as(f64, @floatFromInt(idx)) * 2.0 * PI) / SAMPLE_RATE) * freq);
        const sample = ((sine + 1.0) / 2.0) * 255.0;
        const arr = [_]u8{@intFromFloat(sample)};
        try file.interface.writeAll(arr[0..]);
        freq += 0.001;
    }
}

pub fn main() !void {
    var file = try std.fs.cwd().createFile("sine.wav", .{});
    var file_writer_buffer: [1024]u8 = undefined;
    var file_writer = file.writer(&file_writer_buffer);
    defer file.close();
    try write_header(3, &file_writer);
    try sine_wave(3, &file_writer, 440.0);
}
