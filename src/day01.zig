const std = @import("std");

const print = std.debug.print;

const parseInt = std.fmt.parseInt;

const tokenize = std.mem.tokenize;

const input = @embedFile("data/01.txt");

pub fn main() !void {
  var count: i64 = 0;
  var window:[3]i64 = .{0, 0, 0};
  var part1: i64 = 0;
  var part2: i64 = 0;

  var lines = tokenize(input, "\n");
  while(lines.next()) |line| {
    const num = parseInt(i64, line, 10) catch unreachable;

    if (count > 0 and num > window[2]) {
      part1 += 1;
    }

    if (count > 2 and (num + window[1] + window[2]) > (window[0] + window[1] + window[2])) {
      part2 += 1;
    }

    window[0] = window[1];
    window[1] = window[2];
    window[2] = num;
    count += 1;
  }

  print("{}\n", .{part1});
  print("{}\n", .{part2});
}