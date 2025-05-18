const std = @import("std");
const span = std.mem.span;
const expect = std.testing.expect;

test "get the path" {
    const alloc = std.testing.allocator;
    const path = std.process.getEnvVarOwned(alloc, "TERM") catch return;
    defer alloc.free(path);

    std.debug.print("{s}\n", .{path});
}

test "get all the environment variables" {
    const alloc = std.testing.allocator;
    var path = try std.process.getEnvMap(alloc);
    defer path.deinit();

    var iter = path.hash_map.keyIterator();
    while (iter.next()) |v| {
        std.debug.print("{s}\n", .{v.*});
    }
}
