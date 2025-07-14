const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    var nl: usize = 0;
    var nw: usize = 0;
    var nc: usize = 0;

    const IN = true;
    const OUT = false;

    var state = OUT;

    while (true) {
        const c = stdin.readByte() catch |err| switch (err) {
            error.EndOfStream => break,
            else => return err,
        };

        nc += 1;
        if (c == '\n') {
            nl += 1;
        }
        if (c == ' ' or c == '\n' or c == '\n') {
            state = OUT;
        } else if (state == OUT) {
            nw += 1;
            state = IN;
        }
    }

    try stdout.print("{d} {d} {d}\n", .{ nl, nw, nc });
}
