const std = @import("std");

pub const Token = union(enum) {
    BREAK,
    COMMA,
    DOT,
    EOF,
    EQUAL,
    IDENTIFIER: []const u8,
    LEFT_BRACE,
    LEFT_BRACKET,
    LEFT_PARENT,
    RIGHT_BRACE,
    RIGHT_BRACKET,
    RIGHT_PARENT,
    STRING: []const u8,

    pub fn format(self: Token, comptime _: []const u8, _: std.fmt.FormatOptions, writer: anytype) !void {
        switch (self) {
            .BREAK => return writer.writeAll("break"),
            .COMMA => return writer.writeAll(","),
            .DOT => return writer.writeAll("."),
            .EOF => return writer.writeAll("<eof>"),
            .EQUAL => return writer.writeAll("="),
            .IDENTIFIER => |name| return writer.writeAll("identifier: '" ++ .{name} ++ "'"),
            .LEFT_BRACE => return writer.writeAll("{"),
            .LEFT_BRACKET => return writer.writeAll("["),
            .LEFT_PARENT => return writer.writeAll("("),
            .RIGHT_BRACE => return writer.writeAll("}"),
            .RIGHT_BRACKET => return writer.writeAll("]"),
            .RIGHT_PARENT => return writer.writeAll(")"),
            .STRING => |str| return writer.writeAll("string: '" ++ .{str} ++ "'"),
        }
    }
};
