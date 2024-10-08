const std = @import("std");

const AudioFormat = enum(u2) {
    PCM = 1
};

const Wav = @This();

duration: u32 = 1, // in seconds
sample_rate: u32 = 44100,
channels: u16 = 1,

const header_size = 36;
const subchunk1_size = 16;
const audio_format = AudioFormat.PCM;
const bit_depth = 8;
const byte_size = 8;
const pi = std.math.pi;

fn write_header(self: *const Wav, writer: std.fs.File.Writer) !void {
    const num_samples: u32 = self.sample_rate * self.duration;
    try writer.writeAll("RIFF");
    try writer.writeInt(u32, @intCast(header_size + num_samples), .little);
    try writer.writeAll("WAVEfmt ");
    try writer.writeInt(u32, subchunk1_size, .little);
    try writer.writeInt(u16, @intFromEnum(audio_format), .little);
    try writer.writeInt(u16, self.channels, .little);
    try writer.writeInt(u32, self.sample_rate, .little);
    try writer.writeInt(u32, self.sample_rate * self.channels * (bit_depth / byte_size), .little);
    try writer.writeInt(u16, self.channels * (bit_depth / byte_size), .little);
    try writer.writeInt(u16, bit_depth, .little);
    try writer.writeAll("data");
    try writer.writeInt(u32, num_samples * self.channels * (bit_depth / byte_size), .little);
}

fn sine_wave(self: *const Wav, file: std.fs.File.Writer, base_freq: f64) !void {
    var idx: u32 = 0;
    var freq: f64 = base_freq;
    while (idx < self.duration * self.sample_rate) : (idx += 1) {
        const sine: f64 = @sin(((@as(f64, @floatFromInt(idx)) * 2.0 * pi) / @as(f64, @floatFromInt(self.sample_rate))) * freq);
        const sample = ((sine + 1.0) / 2.0) * 255.0;
        const arr = [_]u8{ @intFromFloat(sample) };
        try file.writeAll(arr[0..]);
        freq += 0.001;
    }
}

pub fn save(self: *const Wav, file_path: []const u8) !void {
    var file = try std.fs.cwd().createFile(file_path, .{});
    defer file.close();
    try self.write_header(file.writer());
    try self.sine_wave(file.writer(), 440.0);
}

pub fn read(self: *const Wav, file_path: []const u8) !void {
    const file = try std.fs.cwd().openFile(file_path, .{});
    const reader = file.reader();
    _ = reader;
    _ = self;
}
