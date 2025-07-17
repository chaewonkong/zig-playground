// Guessing game in Zig
// This program generates a random number between 1 and 10 and prompts the user to guess
const std = @import("std");

pub fn main() !void {
    const timestamp = std.time.nanoTimestamp();
    const seed: u64 = @intCast(timestamp);
    var prng = std.Random.DefaultPrng.init(seed);
    const target = prng.random().intRangeLessThan(u32, 1, 11);

    const stdout = std.io.getStdOut().writer();
    const stdin = std.io.getStdIn().reader();

    var buf: [64]u8 = undefined;
    while (true) {
        try stdout.print("Guess a number between 1 and 10: ", .{});
        const input = try stdin.readUntilDelimiterOrEof(&buf, '\n');
        const inputInt = try std.fmt.parseInt(u32, input.?, 10);
        if (target == inputInt) {
            try stdout.print("Congratulations! You guessed the number: {d}\n", .{target});
            break;
        } else if (inputInt < target) {
            try stdout.print("Too low! Try again.\n", .{});
        } else {
            try stdout.print("Too high! Try again.\n", .{});
        }
    }
}
