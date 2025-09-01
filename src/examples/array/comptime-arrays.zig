const std = @import("std");

const max_capacity = 10;

const TableSchema = struct {
    binding: u32 = 0,
    offset: u32 = 0,
};

const User = struct {
    binding: u32 = 0,
    offset: u32 = 0,
};
const Company = struct {
    binding: u32 = 0,
    offset: u32 = 0,
};

fn calcTableSchema(comptime T: type) TableSchema {
    return switch (T) {
        User => .{
            .binding = 0,
            .offset = 0,
        },
        Company => .{
            .binding = 2,
            .offset = 2,
        },
        else => @compileError("WTF?"),
    };
}

pub fn genSchema(comptime ent_type_tuple: anytype) []const TableSchema {
    const table_schemas_const = blk: {
        var table_schemas: [max_capacity]TableSchema = undefined;

        comptime var table_schema_gen_count: usize = 0;
        inline for (0..ent_type_tuple.len) |i| {
            table_schemas[i] = calcTableSchema(ent_type_tuple[i]);
            table_schema_gen_count += 1;
        } // mark 3

        var table_schemas_final: [table_schema_gen_count]TableSchema = undefined; // mark 2
        for (0..table_schema_gen_count) |i| {
            table_schemas_final[i] = table_schemas[i];
        }

        break :blk table_schemas_final;
    };

    return &table_schemas_const;
}

pub fn main() !void {
    const schemas = genSchema(.{ User, Company });
    std.debug.print("{any}\n", .{schemas});
}
