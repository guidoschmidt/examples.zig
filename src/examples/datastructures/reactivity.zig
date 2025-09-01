const std = @import("std");

const Subscriber = struct {
    id: []const u8,
    onNextFn: ?*const fn (*Subscriber, i32) void = undefined,

    pub fn onNext(self: *Subscriber, value: i32) void {
        self.onNextFn.?(self, value);
    }
};

const Subscription = struct {
    subscribers: std.StringHashMap(Subscriber) = undefined,

    pub fn init(self: *Subscription, allocator: std.mem.Allocator) void {
        self.subscribers = std.StringHashMap(Subscriber).init(allocator);
    }

    pub fn subscribe(self: *Subscription, subscriber: Subscriber) !void {
        try self.subscribers.put(subscriber.id, subscriber);
    }

    pub fn unsubscribe(self: *Subscription, id: []const u8) void {
        self.subscribers.remove(id);
    }

    pub fn next(self: *Subscription, value: i32) void {
        var val_it = self.subscribers.valueIterator();
        while (val_it.next()) |sub| {
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
        return ReactiveRenderer{ .sub = Subscriber{
            .id = "renderer",
            .onNextFn = impl.onNext,
        } };
    }

    pub fn subscribe(self: *ReactiveRenderer, publisher: *Subscription) !void {
        try publisher.subscribe(self.sub);
    }

    pub fn render(self: *ReactiveRenderer) void {
        std.debug.print("\nRENDER / next frame: {s}", .{self.sub.id});
    }
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var publisher = Subscription{};
    publisher.init(allocator);

    try publisher.subscribe(.{ .id = "echo", .onNextFn = struct {
        pub fn onNext(self: *Subscriber, v: i32) void {
            std.debug.print("\n{s} ---> {d}", .{ self.*.id, v });
        }
    }.onNext });

    try publisher.subscribe(.{ .id = "multiply", .onNextFn = struct {
        pub fn onNext(self: *Subscriber, v: i32) void {
            std.debug.print("\n{s} ---> {d}", .{ self.*.id, v * 10 });
        }
    }.onNext });

    stream: {
        publisher.next(10);
        publisher.next(20);
        publisher.next(30);
        publisher.next(40);
        break :stream;
    }

    // Reactive renderer
    var renderer = ReactiveRenderer.init();
    try renderer.subscribe(&publisher);

    // Input loop
    var in_buf: [1024]u8 = undefined;
    var in = std.fs.File.stdin().readerStreaming(&in_buf);

    input_loop: while (true) {
        std.debug.print("\n>>> Please give new input number: \n", .{});
        var writer_buf: [12]u8 = undefined;
        var writer = std.fs.File.stdout().writerStreaming(&writer_buf);
        const len = try in.interface.streamDelimiter(&writer.interface, '\n');
        _ = try in.interface.takeByte();

        const number = std.fmt.parseInt(i32, writer_buf[0..len], 10) catch {
            continue :input_loop;
        };
        std.debug.print("\n→ got {d}", .{number});
        publisher.next(number);
    }
}
