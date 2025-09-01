// source: https://matklad.github.io/2025/03/19/comptime-zig-orm.html
// const std = @import("std");

// const Account = struct {
//     // id = 0 means a new object which has not yet any
//     // assigned id!
//     id: ID = .unassigned,
//     balance: u128,

//     // idiom for creating a newtype over an integer
//     // ID = enumeration backed by a u64 integer
//     // adding '_' allows the enum to have any value from the u64 range
//     pub const ID = enum(u64) { unassigned = 0, _ };
// };

// const Transfer = struct {
//     id: ID = @enumFromInt(0),
//     amount: u128,
//     debit_account: Account.ID,
//     credit_account: Account.ID,

//     // !!! same definition as Account.ID
//     // but actually the tyes are distinct!
//     pub const ID = enum(u64) { _ };
// };

// pub fn main() !void {
//     var gpa_instance = std.heap.DebugAllocator(.{});
//     const gpa = gpa_instance.allocator();

//     var random_instance = std.Random.DefaultPrng.init(0);
//     const random = random_instance.random();

//     var db: DB = .{};

//     const alice: Account.ID = try db.account.create(gpa, .{
//         .balance = 200,
//     });
//     const bob: Account.ID = try db.account.create(gpa, .{
//         .balance = 200,
//     });

//     const transfer: ?Transfer.ID = try create_transfer(&db, gpa, alice, bob, 100);

//     std.debug.assert(transfer != null);
// }

pub fn main() !void {}
