const std = @import("std");
const span = std.mem.span;
const expect = std.testing.expect;
test "Write bytes to a file (create if necessary, append or replace contents)" {
    // current working directory
    const cwd = std.fs.cwd();

    const file_path = "hello.txt";

    const handle = try cwd.createFile(file_path, .{
        // set to true to fully replace the contents of the file
        .truncate = false,
    });
    defer handle.close();
    defer cwd.deleteFile(file_path) catch unreachable;

    // go to the end of the file if you want to append to the file
    // and `truncate` was set to `false` (otherwise this is not needed)
    try handle.seekFromEnd(0);

    // write bytes to the file
    var buffer_writer = std.io.bufferedWriter(handle.writer());
    const bytes_written = try buffer_writer.write("hello Zig\n");

    try std.testing.expectEqual(@as(usize, 10), bytes_written);
}
