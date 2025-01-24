const std = @import("std");

pub const Token = struct {
    loc: Loc,
    tag: Tag,

    pub const Loc = struct { beg: usize, end: usize };

    pub const Tag = enum {
        equal,
        identifier,
        invalid,

        keyword_break,

        const keywords = std.StaticStringMap(Tag).initComptime(.{
            .{ "break", .keyword_break },
        });

        fn lexeme(tag: Tag) ?[]const u8 {
            return switch (tag) {
                .identifier, .invalid => null,
                .equal => "=",
            };
        }

        pub fn symbol(tag: Tag) []const u8 {
            return tag.lexeme() orelse switch (tag) {
                .identifier => "an identifier",
                .invalid => "invalid token",
                else => unreachable,
            };
        }

        pub fn getKeyword(bytes: []const u8) ?Tag {
            return keywords.get(bytes);
        }
    };
};
