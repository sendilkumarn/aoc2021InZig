const std = @import("std");

const ArrayList = std.ArrayList;

const allocator = std.testing.allocator;

const parseInt = std.fmt.parseInt;

var gpalloc = std.heap.GeneralPurposeAllocator(.{}){};
pub const gpa = &gpalloc.allocator;

pub fn parseToIntSlice(comptime T: type, string: []const u8, delim: []const u8) ![]T {
    var list = ArrayList(T).init(gpa);
    var words = std.mem.split(string, delim);

    while(words.next()) |word| {
        if(word.len == 0) continue;
        try list.append(try parseInt(T, word, 10));
    }

    return list.toOwnedSlice();
}

pub fn parseInputToSlice(comptime T: type, string: []const u8, delim: []const u8) ![]T {
    var list = ArrayList(T).init(gpa);

    var lines = std.mem.split(string, delim);
    while(lines.next()) |line| {
        if (line.len == 0) continue;
        try list.append(line);
    }
    return list.toOwnedSlice();
}
