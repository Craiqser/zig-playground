const std = @import("std");
const Token = @import("token.zig").Token;

const expectTokens = @import("testutil.zig").expectTokens;

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
            // std.debug.print("byte: '{any}'\n", .{byte});
            pos += 1;

            switch (byte) {
                '{' => return .LEFT_BRACE,
                '}' => return .RIGHT_BRACE,
                '[' => return .LEFT_BRACKET,
                ']' => return .RIGHT_BRACKET,
                '(' => return .LEFT_PARENT,
                ')' => return .RIGHT_PARENT,
                ',' => return .COMMA,
                '.' => return .DOT,

                ' ', '\t', '\r', '\n' => {},
                else => return Error.UnexpectedCharacter,
            }
        }

        return .EOF;
    }
};

test "tokens: empty" {
    try expectTokens("", &.{});
    try expectTokens("  ", &.{});
}

test "tokens: single" {
    try expectTokens(" , { }\t[ ]\r( ).\n", &.{
        .COMMA,
        .LEFT_BRACE,
        .RIGHT_BRACE,
        .LEFT_BRACKET,
        .RIGHT_BRACKET,
        .LEFT_PARENT,
        .RIGHT_PARENT,
        .DOT,
    });
}
