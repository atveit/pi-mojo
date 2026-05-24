from std.os import mkdir, remove, rmdir
from std.os.path import exists, isdir
from std.ffi import OwnedDLHandle

struct JSStats:
    var size: Int
    var mtime: Float64
    var _is_dir: Bool
    
    def __init__(out self, size: Int, mtime: Float64, is_dir: Bool):
        self.size = size
        self.mtime = mtime
        self._is_dir = is_dir
        
    def isFile(self) -> Bool:
        return not self._is_dir
        
    def isDirectory(self) -> Bool:
        return self._is_dir

struct FileSync:
    var _lib: OwnedDLHandle
    var posix_creat: def(Int, Int32) thin abi("C") -> Int32
    var posix_open_read: def(Int, Int32) thin abi("C") -> Int32
    var posix_write: def(Int32, Int, Int) thin abi("C") -> Int
    var posix_read: def(Int32, Int, Int) thin abi("C") -> Int
    var posix_close: def(Int32) thin abi("C") -> Int32
    var posix_unlink: def(Int) thin abi("C") -> Int32

    def __init__(out self) raises:
        self._lib = OwnedDLHandle("libSystem.B.dylib")
        self.posix_creat = self._lib.get_function[def(Int, Int32) thin abi("C") -> Int32]("creat")
        self.posix_open_read = self._lib.get_function[def(Int, Int32) thin abi("C") -> Int32]("open")
        self.posix_write = self._lib.get_function[def(Int32, Int, Int) thin abi("C") -> Int]("write")
        self.posix_read = self._lib.get_function[def(Int32, Int, Int) thin abi("C") -> Int]("read")
        self.posix_close = self._lib.get_function[def(Int32) thin abi("C") -> Int32]("close")
        self.posix_unlink = self._lib.get_function[def(Int) thin abi("C") -> Int32]("unlink")

    def writeFileSync(self, path: String, content: String) raises:
        var fd = self.posix_creat(Int(path.unsafe_ptr()), 438) # 0o666
        if fd < 0:
            raise Error("Failed to create file: " + path)
        var written = self.posix_write(fd, Int(content.unsafe_ptr()), content.byte_length())
        _ = self.posix_close(fd)
        if written < 0:
            raise Error("Failed to write to file: " + path)

    def readFileSync(self, path: String) raises -> String:
        var fd = self.posix_open_read(Int(path.unsafe_ptr()), 0) # O_RDONLY = 0
        if fd < 0:
            raise Error("Failed to open file for reading: " + path)
            
        var capacity = 1024
        var buf = List[UInt8]()
        buf.resize(capacity, 0)
        
        var total_bytes = self.posix_read(fd, Int(buf.unsafe_ptr()), capacity)
        _ = self.posix_close(fd)
        
        if total_bytes < 0:
            raise Error("Failed to read from file: " + path)
            
        buf.resize(total_bytes, 0)
        return String(unsafe_from_utf8=buf^)

    def rmSync(self, path: String) raises:
        var status = self.posix_unlink(Int(path.unsafe_ptr()))
        if status != 0:
            if isdir(path):
                rmdir(path)
            else:
                remove(path)

def readFileSync(path: String) raises -> String:
    var fs = FileSync()
    return fs.readFileSync(path)

def writeFileSync(path: String, content: String) raises:
    var fs = FileSync()
    fs.writeFileSync(path, content)

def existsSync(path: String) raises -> Bool:
    return exists(path)

def mkdirSync(path: String) raises:
    mkdir(path)

def rmSync(path: String) raises:
    var fs = FileSync()
    fs.rmSync(path)

def statSync(path: String) raises -> JSStats:
    var is_dir = isdir(path)
    var size = 0
    if not is_dir:
        var content = readFileSync(path)
        size = content.byte_length()
            
    return JSStats(size, 0.0, is_dir)
