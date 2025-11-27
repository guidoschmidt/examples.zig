/// References:
/// https://github.com/thi-ng/umbrella/tree/develop/deprecated/packages/iterators
/// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Iterators_and_generators
/// https://github.com/ghostty-org/ghostty/blob/main/src/synthetic/Generator.zig
const std = @import("std");
const assert = std.debug.assert;

pub const GeneratorError = error{
    NoSpaceLeft,
};

fn Generator(comptime T: type, next_fn: fn () T) type {
    return struct {
        done: bool = false,

        pub fn next() T {
            return next_fn();
        }
    };
}

const UrlGenerator = struct {
    const list_of_urls = [_][]const u8{
        "https://ziglang.org",
        "https://zig.news",
        "https://github.com",
    };

    pub fn init() type {
        return Generator(
            @TypeOf(list_of_urls[0]),
            struct {
                var i: usize = 0;
                const rng_gen = std.Random.DefaultPrng;
                var rng: std.Random.Xoshiro256 = rng_gen.init(0);
                const random = rng.random();

                pub fn next_fn() []const u8 {
                    while (true) {
                        // if (i >= list_of_urls.len - 1) {
                        //     i = @mod(i + 1, list_of_urls.len);
                        // } else {
                        //     i += 1;
                        // }
                        i = random.intRangeAtMost(usize, 0, list_of_urls.len - 1);
                        return list_of_urls[i];
                    }
                }
            }.next_fn,
        );
    }
};

const FibonacciGenerator = struct {
    pub fn init(start: usize) type {
        return Generator(usize, struct {
            var num_a: usize = start;
            var num_b: usize = start + 1;

            pub fn next_fn() usize {
                std.debug.assert(num_a + num_b < std.math.maxInt(usize));
                const result = num_a + num_b;
                num_b = num_a;
                num_a = result;
                return result;
            }
        }.next_fn);
    }
};

pub fn main() !void {
    const url_it = UrlGenerator.init();
    const fib_it = FibonacciGenerator.init(0);

    var reader_buffer: [10]u8 = undefined;
    var reader = std.fs.File.stdin().readerStreaming(&reader_buffer);

    while (true) {
        std.debug.print("Next URL:\n    → {s}\n", .{url_it.next()});
        std.debug.print("Fibonnacci:\n    → {d}\n", .{fib_it.next()});

        var writter_buffer: [10]u8 = undefined;
        var writer = std.fs.File.stdout().writerStreaming(&writter_buffer);
        _ = try reader.interface.streamDelimiter(&writer.interface, '\n');
        _ = try reader.interface.takeByte();
        std.debug.print("Press [Enter] to continue.\n", .{});
    }
}
