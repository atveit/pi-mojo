# Performance Smoke Test: Flat Memory Tape vs Traditional Eager DOM Tree Allocations
# Benchmarks allocation, memory representation, and traversal of flat Tape vs deep nested pointer objects.

import std.time

# Tape Type Tags
comptime TAPE_ROOT: UInt8 = 114        # 'r'
comptime TAPE_START_ARRAY: UInt8 = 91  # '['
comptime TAPE_END_ARRAY: UInt8 = 93    # ']'
comptime TAPE_STRING: UInt8 = 34       # '"'
comptime TAPE_INT64: UInt8 = 108       # 'l'

# 56-bit Payload Mask
comptime PAYLOAD_MASK: UInt64 = 0x00FFFFFFFFFFFFFF

struct TapeEntry(Copyable, Movable):
    var data: UInt64

    def __init__(out self, data: UInt64 = 0):
        self.data = data

    def __copyinit__(mut self, other: Self):
        self.data = other.data

    def __moveinit__(mut self, deinit other: Self):
        self.data = other.data

    @staticmethod
    def create(type_tag: UInt8, payload: Int = 0) -> Self:
        var tag_shifted = UInt64(type_tag) << 56
        var payload_masked = UInt64(payload) & PAYLOAD_MASK
        return Self(tag_shifted | payload_masked)

    @always_inline
    def type_tag(self) -> UInt8:
        return UInt8(self.data >> 56)

    @always_inline
    def payload(self) -> Int:
        return Int(self.data & PAYLOAD_MASK)

struct Tape(Movable, Sized):
    var entries: List[TapeEntry]
    var string_buffer: List[UInt8]

    def __init__(out self, capacity: Int = 128):
        self.entries = List[TapeEntry](capacity=capacity)
        self.string_buffer = List[UInt8](capacity=capacity * 8)

    def __moveinit__(mut self, deinit other: Self):
        self.entries = other.entries^
        self.string_buffer = other.string_buffer^

    def __len__(self) -> Int:
        return len(self.entries)

    def append_root(mut self):
        self.entries.append(TapeEntry.create(TAPE_ROOT, 0))

    def append_int64(mut self, value: Int64):
        self.entries.append(TapeEntry.create(TAPE_INT64, 0))
        self.entries.append(TapeEntry(UInt64(value)))

    def append_string(mut self, s: String) -> Int:
        var offset = len(self.string_buffer)
        var s_bytes = s.as_bytes()
        var s_len = s.byte_length()
        for i in range(s_len):
            self.string_buffer.append(s_bytes[i])
        self.string_buffer.append(0) # Null terminator
        self.entries.append(TapeEntry.create(TAPE_STRING, offset))
        return offset

    def start_array(mut self) -> Int:
        var idx = len(self.entries)
        self.entries.append(TapeEntry.create(TAPE_START_ARRAY, 0))
        return idx

    def end_array(mut self, start_idx: Int):
        var end_idx = len(self.entries)
        self.entries.append(TapeEntry.create(TAPE_END_ARRAY, start_idx))
        self.entries[start_idx] = TapeEntry.create(TAPE_START_ARRAY, end_idx)

    def finalize(mut self):
        if len(self.entries) > 0:
            self.entries[0] = TapeEntry.create(TAPE_ROOT, len(self.entries))

    def get_string(self, offset: Int) -> String:
        var end = offset
        while end < len(self.string_buffer) and self.string_buffer[end] != 0:
            end += 1
        var size = end - offset
        if size <= 0:
            return String()
        var ptr = self.string_buffer.unsafe_ptr()
        var bytes = List[UInt8](capacity=size)
        for i in range(size):
            bytes.append(ptr[offset + i])
        return String(unsafe_from_utf8=bytes^)


# Traditional Eager Object/DOM Tree Representation
struct DOMValue(Copyable, Movable):
    var type_tag: Int # 0 = root/object, 1 = array, 2 = string, 3 = int64
    var int_val: Int64
    var str_val: String
    var array_val: List[DOMValue]

    def __init__(out self, type_tag: Int = 0):
        self.type_tag = type_tag
        self.int_val = 0
        self.str_val = String()
        self.array_val = List[DOMValue]()

    def __copyinit__(mut self, other: Self):
        self.type_tag = other.type_tag
        self.int_val = other.int_val
        self.str_val = other.str_val
        self.array_val = List[DOMValue]()
        for i in range(len(other.array_val)):
            self.array_val.append(other.array_val[i].copy())

    def __moveinit__(mut self, deinit other: Self):
        self.type_tag = other.type_tag
        self.int_val = other.int_val
        self.str_val = other.str_val^
        self.array_val = other.array_val^

    @staticmethod
    def create_int(value: Int64) -> Self:
        var v = Self(3)
        v.int_val = value
        return v^

    @staticmethod
    def create_string(s: String) -> Self:
        var v = Self(2)
        v.str_val = s
        return v^


def run_benchmark() raises:
    print("---------------------------------------------------------")
    print("🔥 Smoke Test: Flat Memory Tape vs Traditional eager DOM")
    print("---------------------------------------------------------")

    var iterations = 100_000

    # Warmup
    # 1. Warmup Eager DOM
    var dom_warm = DOMValue(1) # Array
    dom_warm.array_val.append(DOMValue.create_string("warmup"))
    dom_warm.array_val.append(DOMValue.create_int(123))

    # 2. Warmup Tape
    var tape_warm = Tape()
    tape_warm.append_root()
    var start_arr_warm = tape_warm.start_array()
    _ = tape_warm.append_string("warmup")
    tape_warm.append_int64(123)
    tape_warm.end_array(start_arr_warm)
    tape_warm.finalize()

    # -----------------------------------------------------------------
    # Test 1: Benchmark Eager DOM Allocations
    # We allocate a JSON array containing: ["item", 100, "item", 200, "item", 300]
    # -----------------------------------------------------------------
    var start = std.time.monotonic()
    var dom_count = 0
    for _ in range(iterations):
        var root = DOMValue(1) # Array
        root.array_val.append(DOMValue.create_string("item"))
        root.array_val.append(DOMValue.create_int(100))
        root.array_val.append(DOMValue.create_string("item"))
        root.array_val.append(DOMValue.create_int(200))
        root.array_val.append(DOMValue.create_string("item"))
        root.array_val.append(DOMValue.create_int(300))
        dom_count += len(root.array_val)
    var end = std.time.monotonic()
    var time_dom = Float64(end - start) / 1_000_000_000.0

    # -----------------------------------------------------------------
    # Test 2: Benchmark Flat Tape Building (No deep objects / tree nesting)
    # -----------------------------------------------------------------
    start = std.time.monotonic()
    var tape_count = 0
    for _ in range(iterations):
        var tape = Tape()
        tape.append_root()
        var arr_start = tape.start_array()
        _ = tape.append_string("item")
        tape.append_int64(100)
        _ = tape.append_string("item")
        tape.append_int64(200)
        _ = tape.append_string("item")
        tape.append_int64(300)
        tape.end_array(arr_start)
        tape.finalize()
        tape_count += len(tape)
    end = std.time.monotonic()
    var time_tape = Float64(end - start) / 1_000_000_000.0

    print("Iterations:      ", iterations)
    print("Eager DOM Time:  ", time_dom, "s")
    print("Flat Tape Time:  ", time_tape, "s")

    var speedup = time_dom / time_tape
    print("Speedup factor:  ", speedup, "x")
    
    if dom_count == 0 or tape_count == 0:
        raise Error("Verification failed!")
    else:
        print("Verification:    PASS (allocated items count verified)")
    print("---------------------------------------------------------\n")

def main() raises:
    run_benchmark()
