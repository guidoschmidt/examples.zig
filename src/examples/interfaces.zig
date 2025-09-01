/// Sources:
/// https://zig.news/kristoff/easy-interfaces-with-zig-0100-2hc5
/// https://www.youtube.com/watch?v=AHc4x1uXBQE
/// https://ziggit.dev/t/polymorphism-with-zig-0-10-0/463/10

const std = @import("std");

const Shape = union(enum) {
    circle: Circle,
    rectangle: Rectangle,

    pub fn area(self: *Shape) f32 {
        switch(self.*) {
            inline else => |*kind| kind.area(),
        }
    }
};

const Circle = struct {
    radius: f32 = 1,

    pub fn area(self: Circle) f32 {
        return 2.0 * std.math.pi * self.radius;
    } 
};

const Rectangle = struct {
    width: f32 = 1,
    height: f32 = 1,

    pub fn area(self: Rectangle) f32 {
        return self.width * self.height;
    }
};

pub fn main() !void {
    const circ = Circle{ .radius = 12 };
    std.debug.print("\nCircle area: {d:.3}", .{ circ.area() });

    const rect = Rectangle{ .width = 4, .height = 3 };
    std.debug.print("\nRectangle area: {d:.3}", .{ rect.area() });
}
