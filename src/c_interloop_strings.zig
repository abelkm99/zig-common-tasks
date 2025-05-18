const std = @import("std");
const span = std.mem.span;
const expect = std.testing.expect;
const c = @cImport({
    @cDefine("MY_C_CODE", "()\nconst char* give_str() { return \"Hello C\"; }");
});

test "c_interloop to zig string" {
    const c_str = c.give_str();
    const hc: [*:0]const u8 = "Hello C"; // i didn't know we can create strings like this
    const hc2: []const u8 = "Hello C";
    const hz: [*:0]const u8 = "Hello Zig";
    try expect(!std.mem.eql(u8, span(c_str), span(hz)));
    try expect(std.mem.eql(u8, span(c_str), span(hc)));
    try expect(std.mem.eql(u8, span(c_str), hc2));
}

test "zig string types" {
    const str_1: *const [7]u8 = "string1";
    const str_2: *const [7:0]u8 = "string2";
    // var str_3: *const [7]const u8 = "string3"; // not allowed
    // var str_3: *const [7:0]const u8 = "string3"; // not allowed
    // const str_4: [*:0]u8 = "string4"; // now allowed since it expect *const [7:0]u8
    const str_5: [*:0]const u8 = "string5";
    const str_6: [*]const u8 = "string6"; // definetly the worst way to creating a string

    _ = &str_1;
    _ = &str_2;
    _ = &str_5;
    _ = &str_6;


    std.debug.print(
        "{s}\n{s}\n",
        .{
            str_1,
            str_6[0..30000],
        },
    );
}
