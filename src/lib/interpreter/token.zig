const std = @import("std");

pub const Token = union(enum) {
    BREAK,
    COMMA,
    EOF,
    EQUAL,
    IDENTIFIER: []const u8,
    STRING: []const u8,

    pub fn format(self: Token, comptime _: []const u8, _: std.fmt.FormatOptions, writer: anytype) !void {
        switch (self) {
            .BREAK => return writer.writeAll("break"),
            .COMMA => return writer.writeAll(","),
            .EOF => return writer.writeAll("<eof>"),
            .EQUAL => return writer.writeAll("="),
            .IDENTIFIER => |name| return writer.writeAll("identifier: '" ++ .{name} ++ "'"),
            .STRING => |str| return writer.writeAll("string: '" ++ .{str} ++ "'"),
        }
    }
};
