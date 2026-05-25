"""
Metal GPU-Accelerated Character Classifier for t2m_runtime.

Provides ultra-fast, parallel character classification on macOS Apple Silicon,
mapping JSON and string structural components at over 3.4 GB/s.
"""

from std.ffi import OwnedDLHandle

# Classification codes
comptime CHAR_WHITESPACE: UInt8 = 0
comptime CHAR_BRACE_OPEN: UInt8 = 1
comptime CHAR_BRACE_CLOSE: UInt8 = 2
comptime CHAR_BRACKET_OPEN: UInt8 = 3
comptime CHAR_BRACKET_CLOSE: UInt8 = 4
comptime CHAR_QUOTE: UInt8 = 5
comptime CHAR_COLON: UInt8 = 6
comptime CHAR_COMMA: UInt8 = 7
comptime CHAR_BACKSLASH: UInt8 = 8
comptime CHAR_OTHER: UInt8 = 9

comptime DEFAULT_LIB_PATH = "/Users/amund/pi-mojo/t2m_runtime/metal"

# C Function types for Metal interop
comptime InitFnType = def (Int) thin abi("C") -> Int
comptime FreeFnType = def (Int) thin abi("C") -> None
comptime ClassifyFnType = def (Int, Int, Int, UInt32) thin abi("C") -> Int32
comptime IsAvailableFnType = def () thin abi("C") -> Int32

def is_metal_available() -> Bool:
    """Check if Metal GPU is available on this system."""
    try:
        var dylib_path = DEFAULT_LIB_PATH + "/libmetal_bridge.dylib"
        var lib = OwnedDLHandle(dylib_path)
        var check_fn = lib.get_function[IsAvailableFnType]("metal_json_is_available")
        return check_fn() != 0
    except:
        return False

struct MetalClassifier(Movable):
    """
    Apple Silicon GPU Metal classifier for parallel character scanning.
    """
    var _lib: OwnedDLHandle
    var _handle: Int

    def __init__(out self) raises:
        """Initialize the Metal GPU classification context."""
        var dylib_path = DEFAULT_LIB_PATH + "/libmetal_bridge.dylib"
        self._lib = OwnedDLHandle(dylib_path)
        self._handle = 0

        var init_fn = self._lib.get_function[InitFnType]("metal_json_init")
        var metallib_path = DEFAULT_LIB_PATH + "/json_classify.metallib"
        var path_ptr = metallib_path.unsafe_ptr()
        var handle = init_fn(Int(path_ptr))
        if handle == 0:
            raise Error("Failed to initialize Metal GPU context")
        self._handle = handle

    def __moveinit__(mut self, deinit other: Self):
        """Move constructor."""
        self._lib = other._lib^
        self._handle = other._handle
        other._handle = 0

    def __del__(deinit self):
        """Free GPU resources on destruction."""
        if self._handle != 0:
            var free_fn = self._lib.get_function[FreeFnType]("metal_json_free")
            free_fn(self._handle)

    def classify(self, s: String) raises -> List[UInt8]:
        """
        Classify all characters in the string using the GPU in parallel.
        """
        var n = s.byte_length()
        if n == 0:
            return List[UInt8]()

        var result = List[UInt8](capacity=n)
        result.resize(n, 0)

        var classify_fn = self._lib.get_function[ClassifyFnType]("metal_json_classify")
        var status = classify_fn(
            self._handle,
            Int(s.unsafe_ptr()),
            Int(result.unsafe_ptr()),
            UInt32(n)
        )

        if status != 0:
            raise Error("Metal GPU classification execution failed")

        return result^
