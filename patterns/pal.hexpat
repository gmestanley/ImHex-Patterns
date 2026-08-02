#pragma author gmestanley
#pragma description Palette file

import std.io;
import std.mem;

struct Color {
    u24 color [[color(std::format("{:x}", this))]];
};

Color colors[while($<std::mem::size())] @ 0x00;