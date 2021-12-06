const std = @import("std");
const util = @import("util.zig");

const ArrayList = std.ArrayList;
const allocator = std.testing.allocator;

const print = std.debug.print;

const parseInt = std.fmt.parseInt;

const tokenize = std.mem.tokenize;
const eql = std.mem.eql;

const input = @embedFile("data/4.txt");

fn buildBoard(comptime T: type, list: [][]const u8, delim: []const u8) !ArrayList(?T) {
    var boards = ArrayList(?[5][5]?u8).init(allocator);
    var board: [5][5]?u8 = undefined;
    for(list) |item, i| {
        var row = try util.parseInputToSlice([]const u8, item, " ");
        var j: usize = 0;
        for (row) |num| {
            if (num.len == 0) continue;
            board[i % 5][j] = try parseInt(u8, num, 10);
            j += 1;
        }

        if (i % 5 == 4) {
            try boards.append(board);
        }
    }

    return boards;
}

fn mark(board: *[5][5]?u8, num: u8) !void {
    for (board) |*row| {
        for (row) |*item| {
            if(item.* == num) item.* = null;
        }
    }
}

fn isGameWon(board: [5][5]?u8) bool {
    var x: u8 = 0;
    
    while(x < 5) : (x += 1) {
        var columnCount: i8 = 0;
        for (board) |row| {
            var rowCount: i8 = 0;
            for (row) |col, index| {
                if (col == null) rowCount += 1;
                if (index == x and col == null) columnCount += 1; 
            }

            if(rowCount == 5 or columnCount == 5) {
                return true;
            }
        }
    }
    
    return false;
}

fn getSum(board: [5][5]?u8) i64 {
    var sum: i64 = 0;
    for (board) |row| {
        for (row) |col| {
            if (col != null) sum += @intCast(i64, col.?);
        }
    }
    return sum;
}

fn notInList(list: ArrayList(usize), i: usize) bool {
    for (list.items) |item| {
        if (item == i) {
            return false;
        }
    }
    return true;
}

fn part1(turns: []u8, game: ArrayList(?[5][5]?u8)) !void{
    for (turns) |turn| {
        for (game.items) |*board, index| {
            try mark(&board.*.?, turn);
            var isWon = isGameWon(board.*.?);
            if(isWon) {
                var sum = getSum(board.*.?);
                print("Part1 : {d}\n", .{sum * turn});
                return;
            }
        }
    }
}

fn part2(turns: []u8, game: ArrayList(?[5][5]?u8)) !void{
    var winningBoardCount: i64 = 0;
    var wonBoards = ArrayList(usize).init(allocator);

    for (turns) |turn| {
        for (game.items) |*board, index| {
            try mark(&board.*.?, turn);
            var isWon = isGameWon(board.*.?);
            if(isWon and notInList(wonBoards, index)) {
                try wonBoards.append(index);
                winningBoardCount += 1;
                if (winningBoardCount == game.items.len) {
                    var sum = getSum(board.*.?);
                    print("Part2 : {d}\n", .{sum * turn});
                }
            }
        }
    }
}

pub fn main() !void {
    var lines = try util.parseInputToSlice([]const u8, input, "\n");
    var turns = try util.parseToIntSlice(u8, lines[0], ",");
    var game = try buildBoard([5][5]?u8, lines[1..], " ");

    try part1(turns, game);
    try part2(turns, game);
}