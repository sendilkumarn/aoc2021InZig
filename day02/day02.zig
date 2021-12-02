const std = @import("std");

const print = std.debug.print;

const parseInt = std.fmt.parseInt;

const tokenize = std.mem.tokenize;
const eql = std.mem.eql;

const input = @embedFile("2.txt");

pub fn main() !void {
  var lines = tokenize(input, "\n");
  var depth: i64 = 0;
  var forward: i64 = 0;
  var aim: i64 = 0;
  var correctedDepth: i64 = 0;

  while(lines.next()) |line| {
    var words = tokenize(line, " ");
    var cmd = words.next().?;
    var count = parseInt(i64, words.next().?, 10) catch unreachable;

    if (eql(u8, cmd, "forward")) {
      forward += count;
      correctedDepth += (depth * count);
    } else if (eql(u8, cmd, "down")) {
      depth += count;
    } else if (eql(u8, cmd, "up")) {
      depth -= count;
    }
  }

  print("part1: {}\n", .{depth * forward});
  print("part2: {}\n", .{correctedDepth * forward});
}