pub const LengthAdjust = enum {
    spacing,
    spacingAndGlyphs
};

pub const TextAttributes = struct {
    x: ?u32,
    y: ?u32,
    dx: ?u32,
    dy: ?u32,
    rotate: ?[]u32,
    length_adjust: ?[]LengthAdjust,
    text_length: ?u32
};

pub fn text(attr: TextAttributes, inner: []const u8) []const u8 {
    _ = attr;
    return "<text " ++ ">"  ++ inner ++ "</text>";
}

pub const SvgAttributes = struct {
    base_profile: ?[]const u8,
    height: ?u32,
    width: ?u32,
    x: ?u32,
    y: ?u32,
};

pub fn svg(attr: SvgAttributes, inner: []const u8) []const u8 {
    _ = attr;
    const ns = "xmlns='http://www.w3.org/2000/svg'";
    return "<svg " ++ ns ++ ">" ++ inner ++ "</svg>";
}
