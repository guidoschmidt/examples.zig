// https://zig.news/kristoff/easy-interfaces-with-zig-0100-2hc5
const std = @import("std");

const Shape = struct {
    calcAreaFn: *const fn (ptr: *Shape) f32,

    pub fn calcArea(self: *Shape) f32 {
        return self.calcAreaFn(self);
    }
};

const Circle = struct {
    shape: Shape,
    points: std.array_list.Managed(i64) = undefined,

    radius: f32 = 1,

    pub fn init(radius: f32) Circle {
        const impl = struct {
            pub fn calcArea(ptr: *Shape) f32 {
                const self: *Circle = @fieldParentPtr("shape", ptr);
                return self.calcArea();
            }
        };
        var gpa = std.heap.GeneralPurposeAllocator(.{}){};
        const allocator = gpa.allocator();

        return Circle{ .points = std.array_list.Managed(i64).init(allocator), .radius = radius, .shape = Shape{
            .calcAreaFn = impl.calcArea,
        } };
    }

    pub fn calcArea(self: *Circle) f32 {
        return self.radius * std.math.pi * 2.0;
    }

    pub fn shapePtr(self: *const Circle) *Shape {
        return &self.shape;
    }
};

const Rectangle = struct {
    shape: Shape,

    width: f32 = 1,
    height: f32 = 1,

    pub fn init(width: f32, height: f32) Rectangle {
        const impl = struct {
            pub fn calcArea(ptr: *Shape) f32 {
                const self: *Rectangle = @fieldParentPtr("shape", ptr);
                return self.calcArea();
            }
        };
        return Rectangle{ .width = width, .height = height, .shape = Shape{
            .calcAreaFn = impl.calcArea,
        } };
    }

    pub fn calcArea(self: *Rectangle) f32 {
        return self.width * self.height;
    }

    pub fn shapePtr(self: *const Rectangle) *Shape {
        return &self.shape;
    }
};

pub fn main() !void {
    const shapes = [_]*Shape{
        @constCast(&Circle.init(2).shape),
        @constCast(&Rectangle.init(3, 4).shape),
        @constCast(&Circle.init(9.2).shape),
    };

    for (shapes) |shape| {
        std.debug.print("\nArea: {d:.2}", .{shape.calcArea()});
    }
}
