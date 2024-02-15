const std = @import("std");

const stderr = std.io.getStdErr().writer();
const stdout = std.io.getStdOut().writer();

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len < 2) {
        try stderr.print("color [hex_code [hex_code]]\n", .{});
        return;
    }

    if (std.mem.eql(u8, args[1], "help")) {
        try stderr.print("color [hex_code [hex_code]]\n", .{});
        return;
    }

    _ = try stdout.write("\n");

    for (args[1..]) |arg| {
        try stdout.print("{s}: ", .{arg});

        var color: [3:0]u8 = .{};
        _ = std.fmt.hexToBytes(&color, arg) catch |err| {
            try stderr.print("{s}\n", .{@errorName(err)});
            return;
        };

        stdout.print("\x1b[48;2;{d};{d};{d}m", .{ color[0], color[1], color[2] }) catch |err| {
            try stderr.print("{s}\n", .{@errorName(err)});
            return;
        };

        _ = try stdout.write(" " ** 7);
        _ = try stdout.write("\x1b[0m\n");
    }
    _ = try stdout.write("\n");
}
