const std = @import("std");
const span = std.mem.span;
const expect = std.testing.expect;
const c = @cImport({
    @cDefine("MY_C_CODE", "()\nconst char* give_str() { return \"Hello C\"; }");
});

test "c_interloop to zig string" {
    const c_str = c.give_str();
    const hc: [*:0]const u8 = "Hello C";
    const hz: [*:0]const u8 = "Hello Zig";
    std.debug.print("{s}\n", .{hz});
    std.debug.print(
        "{any}\n{s}\n{d}\n",
        .{
            @TypeOf(c_str),
            c_str,
            std.mem.len(c_str),
        },
    );

    try expect(!std.mem.eql(u8, span(c_str), span(hz)));
    try expect(std.mem.eql(u8, span(c_str), span(hc)));
}
