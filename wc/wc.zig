const std = @import("std");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    var nl: usize = 0;
    var nw: usize = 0;
    var nc: usize = 0;

    const State = enum {
        In,
        Out,
    };

    var state = State.Out;

    while (stdin.readByte()) |c| {
        nc += 1;
        if (c == '\n') {
            nl += 1;
        }
        if (c == ' ' or c == '\n' or c == '\t') {
            state = State.Out;
        } else if (state == State.Out) {
            nw += 1;
            state = State.In;
        }
    } else |err| switch (err) {
        error.EndOfStream => {}, // EOF
        else => return err,
    }

    try stdout.print("{d} {d} {d}\n", .{ nl, nw, nc });
}
