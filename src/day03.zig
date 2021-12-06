const std = @import("std");

const ArrayList = std.ArrayList;
const allocator = std.testing.allocator;

const print = std.debug.print;

const parseInt = std.fmt.parseInt;

const tokenize = std.mem.tokenize;
const eql = std.mem.eql;

const input = @embedFile("data/3.txt");

fn formatInput() !ArrayList([]const u8) {
  var list = ArrayList([]const u8).init(allocator);
  var lines = tokenize(input, "\n");
  while(lines.next()) |line| {
    try list.append(line);
  }
  return list;
}

fn pow2(number: usize) i64 {
  var i: i64 = 0;
  var out: i64 = 1;
  while(i < number) : (i += 1) {
    out *= 2;
  }
  return out;
}

pub fn main() !void {
  var lines = try formatInput();

  part1(lines) catch unreachable;
  part2(lines) catch unreachable;
}

fn part1(lines: ArrayList([]const u8)) !void {
  const lineSize = lines.items[0].len;
  const inpSize = lines.items.len;
  var i: usize = 0;
  var gamma: i64 = 0;
  var epsilon: i64 = 0;

  while (i < lineSize) : (i += 1) {
    var counter: usize = 0;
    for(lines.items) |item| {
      if (item[i] == '1') {
        counter += 1;
      }
    }
    const val = pow2(lineSize - i - 1);
    if (counter < (inpSize - counter)) {
      gamma += 0;
      epsilon += val;
    } else {
      gamma += val;
      epsilon += 0;
    }
  }
  
  print("g: {d} \t e: {d} \t part1: {d}\n", .{gamma, epsilon, gamma * epsilon});
}

fn getList(lines: ArrayList([]const u8), zero: bool) ![]const u8 {
  var i: usize = 0;
  var gen = lines;
  
  const lineSize = gen.items[0].len;
  while (i < lineSize) : (i += 1) {
    const inpSize = gen.items.len;
    var zIndexList = ArrayList([]const u8).init(allocator);
    var oIndexList = ArrayList([]const u8).init(allocator);
    if (gen.items.len != 1) {
      var counter: usize = 0;
      for(gen.items) |item, index| {
        if (item[i] == '1') {
          counter += 1;
          try oIndexList.append(item);
        } else {
          try zIndexList.append(item);
        }
      }
      var identifier: u8 = 0;
      if (counter < (inpSize - counter)) {
        if (zero) {
          identifier = 0;
        } else {
          identifier = 1;
        }
        
      } else {
        if (!zero) {
          identifier = 0;
        } else {
          identifier = 1;
        }
      }

      if (identifier == 1) {
        gen = oIndexList;
      } else {
        gen = zIndexList;
      }
    }
  }
  return gen.items[0];
}

fn part2(lines: ArrayList([]const u8)) !void {
  const o2 =  getList(lines, true) catch unreachable;
  const co2 = getList(lines, false) catch unreachable;

  const size = o2.len;

  var i: usize = size;

  var gamma: i64 = 0;
  var epsilon: i64 = 0;

  while (i > 0) : (i -= 1) {
    if (o2[i - 1] == '0') {
      gamma += 0;
    } else {
      gamma += pow2(size - i);
    }

    if (co2[i - 1] == '0') {
      epsilon += 0;
    } else {
      epsilon += pow2(size - i);
    }
  }
  print("g: {d} \t e: {d} \t part1: {d}\n", .{gamma, epsilon, gamma * epsilon});
}
