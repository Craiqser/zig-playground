const std = @import("std");
const Token = @import("token.zig").Token;

const Allocator = std.mem.Allocator;

pub const Error = error{
    UnexpectedCharacter,
};

pub const Tokenizer = struct {
    arena: Allocator,
    pos: usize = 0,
    src: []const u8,

    pub fn init(arena: Allocator, src: []const u8) Tokenizer {
        return .{
            .arena = arena,
            .pos = if (std.mem.startsWith(u8, src, "\xEF\xBB\xBF")) 3 else 0, // Skip the UTF-8 BOM if present.
            .src = src,
        };
    }

    pub fn next(self: *Tokenizer) Error!Token {
        var pos = self.pos;
        defer self.pos = pos;
        const src = self.src;

        while (pos < src.len) {
            const byte = src[pos];
            pos += 1;

            switch (byte) {
                ',' => return .COMMA,
                ' ', '\t', '\r', '\n' => {},
                else => return Error.UnexpectedCharacter,
            }
        }

        return .EOF;
    }
};
