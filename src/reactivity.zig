const std = @import("std");

const Subscriber = struct {
    id: []const u8,
    onNextFn: ?*const fn(*Subscriber, i32) void = undefined,

    pub fn onNext(self: *Subscriber, value: i32) void {
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
        while(val_it.next()) |sub| {
            if (sub.*.onNextFn) |onNextFn| onNextFn(sub, value);
        }
    }
};

const ReactiveRenderer = struct {
    sub: Subscriber = undefined,

    pub fn init() ReactiveRenderer {
        const impl = struct {
            pub fn onNext(ptr: *Subscriber, _: i32) void {
                const self: *ReactiveRenderer = @fieldParentPtr("sub", ptr);
                return self.render();
            }
        };
        return ReactiveRenderer {
            .sub = Subscriber {
                .id = "renderer",
                .onNextFn = impl.onNext,
            }
        };
    }

    pub fn subscribe(self: *ReactiveRenderer, publisher: *Subscription) !void {
        try publisher.subscribe(self.sub);
    }

    pub fn render(self: *ReactiveRenderer) void {
        std.debug.print("\nRENDER / next frame: {s}", .{ self.sub.id });
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
                pub fn onNext(self: *Subscriber, v: i32) void {
                    std.debug.print("\n{s} ---> {d}", .{ self.*.id, v });
                }
            }.onNext
    });

    try publisher.subscribe(.{
        .id = "multiply",
        .onNextFn = struct{
            pub fn onNext(self: *Subscriber, v: i32) void {
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

    // Reactive renderer
    var renderer = ReactiveRenderer.init();
    try renderer.subscribe(&publisher);

    // Input loop
    const in = std.io.getStdIn();
    var buf = std.io.bufferedReader(in.reader());
    var r = buf.reader();

    // const fps = 10;
    // const ms_per_frame = @divTrunc(1, fps) * 1000;
    // std.debug.print("\nms / frame {d}", .{ ms_per_frame });
    // var now = @divTrunc(std.time.nanoTimestamp(), std.time.ns_per_ms);
    // while (true) {
    //     const then = @divTrunc(std.time.nanoTimestamp(), std.time.ns_per_ms);
    //     const elapsed = then - now;
    //     if (elapsed >= ms_per_frame) {
    //         publisher.next(0);
    //         now = then; 
    //     }
    // }

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
