import hex.provider;
import type.bcd;
import std.mem;
import std.string;

u8 actualDiskPosition;

struct FwNESHeader {
    if (std::mem::read_string(0x00, 3) == "FDS" && $[3] == 0x1A) {
        actualDiskPosition = 0x10;
        char signature[4];
        u8 numberOfDiskSides;
    }
};

FwNESHeader fwNESHeader @ 0x00;

enum CountryType : u8 {
    Japan = 0x49
};

u8 headerPosition;
bool debug in;

struct Header {
    if (debug) {
        std::print("Position of header before setting, by variable: "+std::string::to_string(headerPosition));
        std::print("Position of header before setting: "+std::string::to_string($));
        headerPosition = $;
        std::print("Position of header after setting, by variable: "+std::string::to_string(headerPosition));
        std::print("Position of header after setting: "+std::string::to_string($));
    }

    char signature[14];
    u8 licenseeCode;
    char gameID[3];
    char gameType;
    u8 gameVersion;
    u8 sideNumber;
    u8 diskNumber;
    u8 fmcDiskType;
    padding[1];
    u8 numberOfFileReadOnBoot;
    padding[5];
    type::BCD<1> manufacturingDate[3];
    CountryType country;
    padding[9];
    type::BCD<1> rewrittenDiskDate[3];
    padding[2];
    u16 diskWriterSerialNumber;
    padding[1];
    type::BCD<1> diskRewriteCount;
    u8 actualDiskSide;
    u8 diskType;
    u8 diskVersion;
};

struct FileHeaderBlock {
    u8 fileNumber;
    u8 fileID;
    char fileName[8];
    u16 fileAddress;
    u16 fileSize;
    u8 fileType;
} [[inline]];

struct Block {
    u8 blockID;
    match (blockID) {
        (1): Header header [[inline]];
        (2): u8 fileAmount;
        (3): FileHeaderBlock fileHeaderBlock;
        (4): u8 data[std::mem::read_unsigned($-4-2*(hex::prv::get_information("file_extension") == ".qd"), 2)];
    }
    if (hex::prv::get_information(
    "file_extension") == ".qd")
        u16 crc;
};

struct File {
    Block fileHeader;
    Block fileData;
};

struct DiskSide {
    Block header;
    Block fileAmount;
    File files[fileAmount.fileAmount];
    if (hex::prv::get_information(
    "file_extension") == ".fds")
        padding[while($-headerPosition<0xFFDB)];
        
    if (debug) {
        std::print("Current position of header minus old position of header: "+std::string::to_string($-headerPosition));
        std::print("Position of header by variable: "+std::string::to_string(headerPosition));
        std::print("Position of header: "+std::string::to_string($));
    }
};

DiskSide diskSides[while($<std::mem::size())] @ actualDiskPosition;