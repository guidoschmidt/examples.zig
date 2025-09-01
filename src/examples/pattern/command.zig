/// source: https://gameprogrammingpatterns.com/
const std = @import("std");

const GameActor = struct {
    x: i8,
    y: i8,

    pub fn jump(self: *GameActor, dir: i8) void {
        self.y = self.y -| dir;
    }

    pub fn move(self: *GameActor, dir: i8) void {
        self.x += dir;
    }

    pub fn update(self: *GameActor, ground: i8) void {
        self.y = @min(ground, self.y + 1);
        self.x = @mod(self.x, 99);
    }
};

const CommandType = enum {
    JUMP,
    MOVE,

    pub fn format(
        self: CommandType,
        comptime fmt: []const u8,
        options: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        _ = fmt;
        _ = options;
        switch (self) {
            CommandType.JUMP => try writer.print("{s} ", .{"JUMP"}),
            CommandType.MOVE => try writer.print("{s} ", .{"MOVE"}),
        }
    }
};

const Command = struct {
    commandType: CommandType = undefined,
    arg: i8 = undefined,

    pub fn execute(self: *const Command, actor: *GameActor) void {
        switch (self.commandType) {
            .MOVE => actor.move(self.arg),
            .JUMP => actor.jump(self.arg),
        }
    }

    pub fn format(self: Command, writer: *std.Io.Writer) !void {
        try writer.print("{any}({d}) ", .{ self.commandType, self.arg });
    }
};

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    // Open tty
    const flags = std.posix.system.O{ .ACCMODE = std.posix.ACCMODE.RDWR, .NONBLOCK = true };
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
    const ground = 30;
    var player = GameActor{
        .x = 50,
        .y = ground,
    };

    var i: usize = 0;
    var command: ?Command = undefined;
    while (true) : (i += 1) {
        const size = try std.posix.poll(&fds, 0);
        if (size != 0) {
            _ = std.posix.read(tty, &buffer) catch 0;
            switch (buffer[1]) {
                '[' => switch (buffer[2]) {
                    'A' => {
                        command = Command{ .commandType = CommandType.JUMP, .arg = 20 };
                        command.?.execute(&player);
                    },
                    'C' => {
                        command = Command{
                            .commandType = CommandType.MOVE,
                            .arg = 1,
                        };
                        command.?.execute(&player);
                    },
                    'D' => {
                        command = Command{
                            .commandType = CommandType.MOVE,
                            .arg = -1,
                        };
                        command.?.execute(&player);
                    },
                    else => {},
                },
                else => {},
            }
        }

        player.update(ground);

        std.debug.print("\x1B[?25l", .{});
        for (0..100) |y| {
            std.debug.print("\x1B[{d};{d}H", .{ 0, 0 });
            if (command) |c|
                std.debug.print("{any}", .{c});
            for (1..100) |x| {
                std.debug.print("\x1B[{d};{d}H", .{ y, x });
                if (x == player.x and y == player.y) {
                    std.debug.print("⚈", .{});
                    continue;
                }
                if (y == ground) {
                    std.debug.print("_", .{});
                } else {
                    std.debug.print(" ", .{});
                }
            }
        }
    }
}
