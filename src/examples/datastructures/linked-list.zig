/// source: https://www.openmymind.net/Zigs-New-LinkedList-API/
const std = @import("std");
const SinglyLinkedList = std.SinglyLinkedList;

const User = struct {
    id: i64,
    power: u32,
    node: SinglyLinkedList.Node,
};

pub fn main() !void {
    // Create users
    var user1 = User{ .id = 1, .power = 9000, .node = .{} };

    var user2 = User{
        .id = 2,
        .power = 1,
        .node = .{},
    };

    std.debug.print("Address of user1: {*}\n", .{&user1});

    const address_of_user1_power = &user1.power;
    std.debug.print("Address of user1.power: {*}\n", .{address_of_user1_power});

    // const power_offset = 8; // 8 byte
    const power_offset = @offsetOf(User, "power"); // 8 byte
    const also_user: *User = @ptrFromInt(@intFromPtr(address_of_user1_power) - power_offset);
    std.debug.print("Address of user1 (via bit offset): {*}\n", .{also_user});

    std.debug.print("User memory addresses equal: {any}\n", .{also_user == &user1});
    std.debug.print("Also user: {}", .{also_user});

    // Create linked list
    var list: SinglyLinkedList = .{};
    list.prepend(&user2.node);
    list.prepend(&user1.node);

    std.debug.print("\nLinked List:\n", .{});
    var node = list.first;
    while (node) |n| {
        const user: *User = @fieldParentPtr("node", n);
        std.debug.print("\n{any}\n   → {any}", .{ n, user });
        node = n.next;
    }
}
