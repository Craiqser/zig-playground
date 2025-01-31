const std = @import("std");
const ipr = @import("interpreter");

pub fn main() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("Run `zig build test` to run the tests.\n", .{});
    try bw.flush();
}

test "use other module" {
    try std.testing.expectEqual(@as(i32, 150), ipr.add(100, 50));
}
