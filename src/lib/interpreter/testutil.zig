const std = @import("std");
const t = std.testing;

const Token = @import("token.zig").Token;
const Tokenizer = @import("tokenizer.zig").Tokenizer;

const allocator = std.testing.allocator;
var arena = std.heap.ArenaAllocator.init(allocator);

fn reset() void {
    _ = arena.reset(.free_all);
}

pub fn expectTokens(src: []const u8, expected: []const Token) !void {
    defer reset();

    var tokenizer = Tokenizer.init(arena.allocator(), src);

    for (expected) |expected_token| {
        const actual_token = try tokenizer.next();

        try t.expectEqualStrings(@tagName(expected_token), @tagName(actual_token));

        switch (expected_token) {
            .IDENTIFIER => |name| try t.expectEqualStrings(name, actual_token.IDENTIFIER),
            .STRING => |str| try t.expectEqualStrings(str, actual_token.STRING),
            else => try t.expectEqual(expected_token, actual_token),
        }
    }

    const eof_token = try tokenizer.next();
    try t.expectEqual(.EOF, eof_token);
}
