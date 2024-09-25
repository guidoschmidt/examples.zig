const std = @import("std");

const GameActor = struct {
    pub fn jump() void {}

    pub fn fire() void {}
};

const CommandType = enum {
    JUMP,
    FIRE,
};

const Command = struct {
    commandType: CommandType.FIRE = undefined,

    pub fn execute(self: *Command, actor: *GameActor) void {
        switch (self.commandType) {
            .FIRE => actor.fire(),
            .JUMP => actor.jump(),
            else => {},
        }
    }
};

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.c_allocator);
    defer arena.deinit();

    // Open tty
    const flags = std.posix.system.O{
        .ACCMODE = std.posix.ACCMODE.RDWR,
        .NONBLOCK = true
    };
    const tty = try std.posix.open("/dev/tty", flags, 0);

    var term_attr = try std.posix.tcgetattr(tty);
    term_attr.lflag = std.posix.tc_lflag_t{
        .ISIG = true,
    };
    term_attr.iflag = std.posix.tc_iflag_t{
        .ICRNL = false,
    };
    try std.posix.tcsetattr(tty, .FLUSH, term_attr);

    var fds: [1]std.posix.pollfd = undefined;
    fds[0] = .{
        .fd = 0,
        .events = std.posix.POLL.IN,
        .revents = undefined,
    };

    var buffer: [32]u8 = undefined;
    var pos = [2]usize{ 3, 9 };

    var i: usize = 0;
    while (true) : (i += 1) {
        pos[1] = @min(9, pos[1] + 1);

        const size = try std.posix.poll(&fds, 0);
        if (size != 0) {
            _ = std.posix.read(tty, &buffer) catch 0;
            switch(buffer[1]) {
                '[' => switch(buffer[2]) {
                    'A' => {
                        // std.debug.print("\nUP", .{});
                        pos[1] -= 5;
                    },
                    'B' => {
                        // std.debug.print("\nDOWN", .{});
                    },
                    'C' => {
                        // std.debug.print("\nRIGHT", .{});
                        pos[0] = @mod(pos[0] + 1, 99);
                    },
                    'D' => {
                        pos[0] = if(pos[0] == 0) 100 else pos[0] - 1;
                        // std.debug.print("\nLEFT", .{});
                    },
                    else => {}
                },
                else => {}
            }
        }


        for (0..10) |y| {
            for (0..100) |x| {
                std.debug.print("\x1B[{d};{d}H", .{ y, x });
                if (x == pos[0] and y == pos[1]) {
                    std.debug.print("x", .{});
                    continue;
                }
                if (y == 9) {
                    std.debug.print("_", .{});
                }
                else {
                    std.debug.print(" ", .{});
                }
            }
        }

        std.time.sleep(std.time.ns_per_ms * 60);
    }
}
