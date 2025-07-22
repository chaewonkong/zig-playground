//! Simplified REPL calculator in Zig
// This program reads expressions from the user and evaluates them
const std = @import("std");

pub fn main() !void {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    try stdout.print("Welcome to the REPL calculator! Type 'exit' to quit.\n", .{});

    var buf: [256]u8 = undefined;
    const input = try stdin.readUntilDelimiterOrEof(&buf, '\n');
    var tokenizer = std.mem.tokenizeAny(u8, input.?, " ");
    var expr: Expr = Expr{};

    while (tokenizer.next()) |token| {
        if (std.mem.eql(u8, token, "exit")) {
            try stdout.print("Exiting the REPL calculator. Goodbye!\n", .{});
            return;
        }

        if (std.fmt.parseInt(u64, token, 10) catch null) |intVal| {
            if (expr.left == null) {
                expr.left = intVal;
            } else {
                expr.right = intVal;
            }
        } else if (token.len == 1) {
            const opr = token[0];
            if (opr == '+' or opr == '-' or opr == '*' or opr == '/') {
                expr.opr = opr;
            } else {
                try stdout.print("Unknown operator: {s}\n", .{token});
            }
        } else {
            try stdout.print("Invalid input: {s}\n", .{token});
        }
    }

    if (expr.isEmpty()) {
        try stdout.print("No valid expression provided.\n", .{});
    } else {
        const result = expr.eval();
        try stdout.print("Result: {}\n", .{result});
    }

    try stdout.print("Exiting the REPL calculator. Goodbye!\n", .{});
}

const Expr = struct {
    left: ?u64 = null,
    right: ?u64 = null,
    opr: ?u8 = null,

    pub fn eval(self: Expr) u64 {
        if (isEmpty(self)) {
            return 0;
        }

        if (self.opr) |opr| {
            const left = self.left orelse @panic("Left operand is not set");
            const right = self.right orelse @panic("Right operand is not set");
            return switch (opr) {
                '+' => left + right,
                '-' => left - right,
                '*' => left * right,
                '/' => left / right,
                else => @panic("Unsupported operation"),
            };
        } else {
            return 0;
        }
    }

    pub fn isEmpty(self: Expr) bool {
        return self.left == null and self.right == null and self.opr == null;
    }
};
