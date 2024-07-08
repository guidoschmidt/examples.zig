const std = @import("std");

const Subscriber = struct {
    id: []const u8,
    onNextFn: ?*const fn(*const *Subscriber, i32) void = undefined,

    pub fn onNext(self: *const *Subscriber, value: i32) void {
        self.onNextFn.?(self, value);
    }
};

const Subscription = struct {
    subscribers: std.StringHashMap(Subscriber) = undefined,

    pub fn init(self: *Subscription, allocator: std.mem.Allocator) void {
        self.subscribers = std.StringHashMap(Subscriber).init(allocator);
    }

    pub fn subscribe(self: *Subscription,
                     subscriber: Subscriber) !void {
        try self.subscribers.put(subscriber.id, subscriber);
    }

    pub fn unsubscribe(self: *Subscription, id: []const u8) void {
        self.subscribers.remove(id);
    }

    pub fn next(self: *Subscription, value: i32) void {
        var val_it = self.subscribers.valueIterator();
        while(val_it.next()) |*sub| {
            sub.*.onNextFn.?(sub, value);
        }
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var publisher = Subscription {};
    publisher.init(allocator);

    try publisher.subscribe(.{
        .id = "echo",
        .onNextFn = struct{
                pub fn onNext(self: *const *Subscriber, v: i32) void {
                    std.debug.print("\n{s} ---> {d}", .{ self.*.id, v });
                }
            }.onNext
    });

    try publisher.subscribe(.{
        .id = "multiply",
        .onNextFn = struct{
            pub fn onNext(self: *const *Subscriber, v: i32) void {
                std.debug.print("\n{s} ---> {d}", .{ self.*.id, v * 10 });
            }
        }.onNext
    });

    stream: {
        publisher.next(10);
        publisher.next(20);
        publisher.next(30);
        publisher.next(40);
        break: stream;
    }

    // Input loop
    const in = std.io.getStdIn();
    var buf = std.io.bufferedReader(in.reader());
    var r = buf.reader();

    input_loop: while (true) {
        var msg_buf: [4096]u8 = undefined;
        std.debug.print("\nPlease enter a number: ", .{});
        const input = try r.readUntilDelimiterOrEof(&msg_buf, '\n');

        if (input) |input_txt| {
            const number = std.fmt.parseInt(i32, input_txt, 10) catch {
                break :input_loop;
            };
            std.debug.print("\n", .{});
            publisher.next(number);
        }
    }
}
