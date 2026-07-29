#pragma author gmestanley
#pragma description Quick Disk format

import hex.provider;
import type.bcd;
import std.mem;
import std.string;

struct FwNESHeader {
    if (std::mem::read_string(0x00, 3) == "FDS" && $[3] == 0x1A) {
        char signature[4];
        u8 numberOfDiskSides;
    }
};

FwNESHeader fwNESHeader @ 0x00;

enum CountryType : u8 {
    Japan = 0x49
};

fn DisplayYear(u8 value) {
    str fullYearDisplay = "";
    str calendar = "";
    u16 year = 1989;
    if (value >= 0x85) {
        calendar += "Gregorian calendar";
        fullYearDisplay += "19" + std::string::to_string(value-48);
    }
    else {
        calendar += "Japanese calendar (";
        if (value >= 0x61) {
            calendar += "Showa";
            year = 1986;
        }
        else {
            calendar += "Heisei";
        }
        fullYearDisplay += std::string::to_string(year+((value^0x60)-1));
        calendar += " era)";
    }
    return std::string::to_string(fullYearDisplay + ", " + calendar);
};

struct Date {
    u8 year [[format("DisplayYear")]];
    u8 month;
    u8 day;
};

struct Header {
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
    Date manufacturingDate;
    CountryType country;
    padding[9];
    Date rewrittenDiskDate;
    padding[2];
    u16 diskWriterSerialNumber;
    padding[1];
    type::BCD<1> diskRewriteCount;
    u8 actualDiskSide;
    u8 diskType;
    u8 diskVersion;
};

fn displayFileType(u8 type) {
    match (type) {
        (0): return "Program, PRG-RAM";
        (1): return "Character, CHR-RAM";
        (2): return "Nametable, VRAM";
    }
};

struct FileHeaderBlock {
    u8 fileNumber;
    u8 fileID;
    char fileName[8];
    u16 fileAddress;
    u16 fileSize;
    u8 fileType [[format("displayFileType")]];
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

u24 paddingLimit = 0xFFDB + 37 * (hex::prv::get_information("file_extension") == ".qd");

struct DiskSide {
    Block header;
    Block fileAmount;
    File files[fileAmount.fileAmount];
    padding[while($<paddingLimit)];
    paddingLimit+=0x10000;
};

DiskSide diskSides[while($<std::mem::size())] @ sizeof(fwNESHeader);
