const std = @import("std");
const span = std.mem.span;
const expect = std.testing.expect;
const alloc = std.testing.allocator;

const AddressStruct = struct {
    street: []const u8,
    city: []const u8,
};
const UserStruct = struct {
    name: []const u8,
    age: u32,
    is_student: bool,
    courses: [][]const u8,
    address: AddressStruct,
};
test "parse json" {
    const json_input: []const u8 =
        \\{
        \\    "name": "John Doe",
        \\    "age": 30,
        \\    "is_student": false,
        \\    "courses": ["Math", "Science"],
        \\    "address": {
        \\      "street": "123 Main St",
        \\      "city": "Anytown"
        \\    }
        \\}
    ;
    const parsed_json = std.json.parseFromSlice(UserStruct, alloc, json_input, .{}) catch |err| {
        std.debug.print("Error parsing JSON: {}\n", .{err});
        return err;
    };
    defer parsed_json.deinit();
    try std.testing.expectEqualSlices(u8, parsed_json.value.name, "John Doe");
}

test "dump json" {
    const new_user: UserStruct = .{
        .name = "bella",
        .age = 299,
        .is_student = false,
        .courses = &[_][]const u8{},
        .address = .{ .city = "addis", .street = "niger" },
    };

    var buff: [1000]u8 = undefined;
    var buff_writer = std.io.fixedBufferStream(&buff);
    _ = try std.json.stringify(new_user, .{}, buff_writer.writer()); // would be great if it can retur a number of bytes it has written
    std.debug.print("{s}\n", .{buff});

}
