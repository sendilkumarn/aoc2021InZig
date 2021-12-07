const std = @import("std");

const input = @embedFile("data/07.txt");

const util = @import("utils.zig");

const print = std.debug.print;

fn part1() !void {
    var positions = try util.parseToIntSlice(i64, input, ",");
    var pLen = positions.len;
    var x: i64 = 0;
    var out: i64 = std.math.maxInt(i64);

    while(x < pLen) : (x += 1) {
        var count: i64 = 0;
        for(positions) |position| {
          count += std.math.absInt(x - position) catch unreachable;
        }

        if(count < out) {
            out = count;
        }
    }

    print("{d}\n", .{out});
}

fn sumFactorial(n: i64) i64 {
  return @divExact(n * (n + 1), 2);
}

fn part2() !void {
    var positions = try util.parseToIntSlice(i64, input, ",");
    var pLen = positions.len;
    var x: i64 = 0;
    var out: i64 = std.math.maxInt(i64);

    var map = std.AutoHashMap(i64, i64).init(std.testing.allocator);
    defer map.deinit();

    while(x < pLen) : (x += 1) {
      var count: i64 = 0;
      for (positions) |otherPosition| {
        var diff = std.math.absInt(@intCast(i64, x) - otherPosition) catch unreachable;
        if (!map.contains(diff)) {
          try map.put(diff, sumFactorial(diff));
        }
        count += map.get(diff).?;
      }

       if(count < out) {
            out = count;
        }
    }
    print("{d}\n", .{out});
}

pub fn main() !void {
    try part1();
    try part2();
}