const std = @import("std");

const input = @embedFile("data/06.txt");

const util = @import("util.zig");

const print = std.debug.print;

fn solution(day: i16) !void {
    var fishes = try util.parseToIntSlice(u8, input, ",");
    var list = [9]i128{0, 0, 0, 0, 0, 0, 0, 0, 0};

    for (fishes) |fish| {
        list[fish] += 1;
    }
    var x: i128 = 0;

    while(x <= day) : (x += 1) {
        var first = list[0];
        for(list) |_, index| {
            if (index == 6) {
                list[index] = list[index + 1] + first;
            } else if (index == 8) {
                list[index] = first;
            } else {
                list[index] = list[index + 1];
            }
        }
    }

    var sum: i128 = 0;
    for(list) |item| {
        sum +=  item;
    }
    print("{d}\n", .{sum});
}

pub fn main() !void {
    try solution(79);
    try solution(255);
}