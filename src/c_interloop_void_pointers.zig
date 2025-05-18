const std = @import("std");
const span = std.mem.span;
const expect = std.testing.expect;

const c_code =
    \\
    \\static const void* _value;
    \\void store_void(const void* v) { _value = v; }
    \\const void* get_void() { return _value; }
;

const c = @cImport({
    @cDefine("MY_C_CODE", c_code);
});

test "void pointer" {
    const num: [3]u8 = [3]u8{ 1, 2, 3 };
    c.store_void(&num);
    const v: *const [3]u8 = @ptrCast(@alignCast(c.get_void().?)); // add *const if your not using @constCast
    std.debug.print("{any}\n", .{v.*});
    try expect(std.mem.eql(u8,&num, v));
}
