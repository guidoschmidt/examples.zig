const std = @import("std");
const fun = @import("shared").functional;

fn add(comptime arg0: anytype) @TypeOf(arg0) {
    return arg0 + 1;
}

fn generic(comptime func: anytype, comptime args: anytype) void {
    const FuncType = @TypeOf(func);
    const args_info = @typeInfo(FuncType).@"fn".params;
    inline for (0..args_info.len) |i| {
        std.debug.print("\n{any}", .{args_info[i]});
    }

    const ArgsType = @TypeOf(args);
    const fields_info = @typeInfo(ArgsType).@"struct".fields;
    inline for (0..fields_info.len) |i| {
        std.debug.print("\n{any}: {any}", .{ fields_info[i], args[i] });
    }
}

const DataStruct = struct {
    seed: u16 = undefined,
    state_count: u8 = undefined,
    palette: [10]u32 = undefined,
    // Try adding a new property and set it to undefined.
    // e.g. shape_count: u16 = undefined
    // shape_count: u16 = undefined,

    pub fn initRandom() DataStruct {
        const fill_random_fn = struct {
            pub fn f() DataStruct {
                const rng_gen = std.Random.DefaultPrng;
                var rng = rng_gen.init(0);
                var random = rng.random();

                var ds = DataStruct{};

                const type_info = @typeInfo(DataStruct);
                inline for (type_info.@"struct".fields) |field| {
                    switch (field.type) {
                        u8, u16, u32, u64 => {
                            @field(ds, field.name) = random.int(field.type);
                        },
                        []u8, []u16, [10]u32 => {
                            inline for (0..@field(ds, field.name).len) |i| {
                                @field(ds, field.name)[i] = random.int(@TypeOf(@field(ds, field.name)[0]));
                            }
                        },
                        else => {},
                    }
                }
                return ds;
            }
        }.f;
        return fill_random_fn();
    }

    pub fn format(
        self: @This(),
        writer: *std.Io.Writer,
    ) std.Io.Writer.Error!void {
        try writer.print("Palette: [", .{});
        for (0..self.palette.len) |i| {
            try writer.print("{d}{s}", .{
                self.palette[i],
                if (i < self.palette.len - 1) ", " else "",
            });
        }
        try writer.print("]\n", .{});
        try writer.print("Seed:    {d:>}\n", .{self.seed});
        try writer.print("Palette: {d:>}\n", .{self.state_count});
    }
};

pub fn main() !void {
    const ds = DataStruct.initRandom();
    std.debug.print("\n{f}", .{ds});

    generic(add, .{ 2, 4 });
}
