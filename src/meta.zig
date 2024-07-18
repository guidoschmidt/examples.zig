const std = @import("std");

const DataStruct = struct {
    seed: u16 = undefined,
    state_count: u8 = undefined,
    palette: [10]u32 = undefined,
    // Try adding a new property and set it to undefined.
    // e.g. shape_count: u16 = undefined

    pub fn initRandom() DataStruct {
        const fill_random_fn = struct {
            pub fn f() DataStruct {
                const rng_gen = std.rand.DefaultPrng;
                var rng = rng_gen.init(0);
                var random = rng.random();

                var ds = DataStruct{};

                const type_info = @typeInfo(DataStruct);
                inline for (type_info.Struct.fields) |field| {
                    switch (field.type) {
                        u8, u16, u32, u64 => {
                            @field(ds, field.name) = random.int(field.type);
                        },
                        []u8, []u16, [10]u32 => {
                            inline for(0..@field(ds, field.name).len) |i| {
                                @field(ds, field.name)[i] = random.int(@TypeOf(@field(ds, field.name)[0]));
                            }
                        },
                        else => {}
                    }
                }
                return ds;
            }
        }.f;
        return fill_random_fn();
    }
};

pub fn main() !void {
    const ds = DataStruct.initRandom();
    std.debug.print("\n{any}", .{ ds });
}
