// Simplified REPL calculator in Zig
// This program reads expressions from the user and evaluates them
const std = @import("std");

pub fn main() !void {
    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    try stdout.print("Welcome to the REPL calculator! Type 'exit' to quit.\n", .{});

    var buf: [256]u8 = undefined;
    const input = try stdin.readUntilDelimiterOrEof(&buf, '\n');
    var tokenizer = std.mem.tokenizeAny(u8, input.?, " ");
    var expr: Expr = undefined;

    while (tokenizer.next()) |token| {
        if (std.mem.eql(u8, token, "exit")) {
            break;
        }

        if (std.fmt.parseInt(u64, token, 10) catch null) |intVal| {
            if (expr.isEmpty()) {
                expr.left = .{ .Int = intVal };
            } else {
                expr.right = .{ .Int = intVal };
            }
        } else if (std.fmt.parseFloat(f64, token) catch null) |_| {
            // not implemented error
            try stdout.print("Float values are not supported yet.\n", .{});
            break;
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

    try stdout.print("Evaluation result: ", .{});
    if (expr.isEmpty()) {
        try stdout.print("No valid expression provided.\n", .{});
    } else {
        const result = expr.eval();
        try stdout.print("{}\n", .{result.Int});
    }

    try stdout.print("Exiting the REPL calculator. Goodbye!\n", .{});
}

const Value = union(enum) {
    none,
    Int: u64,
    Float: f64,
};

const Expr = struct {
    left: Value,
    right: Value,
    opr: ?u8 = null,

    pub fn eval(self: Expr) Value {
        if (self.opr) |opr| {
            if (self.left == .Int and self.right == .Int) {
                return switch (opr) {
                    '+' => .{ .Int = self.left.Int + self.right.Int },
                    '-' => .{ .Int = self.left.Int - self.right.Int },
                    '*' => .{ .Int = self.left.Int * self.right.Int },
                    '/' => .{ .Int = self.left.Int / self.right.Int },
                    else => @panic("Unsupported operation"),
                };
            } else {
                return .none;
            }
        } else {
            return .none;
        }
    }

    pub fn isEmpty(self: Expr) bool {
        return self.left == .none and self.right == .none and self.opr == null;
    }
};
