#pragma author gmestanley
#pragma description Sega Master System ROM header

bitfield HeaderBits {
    productCode : 20;
    version : 4;
    regionCode : 4;
    romSize : 4;
};

struct Header {
    char signature[10];
    u16 checksum;
    HeaderBits headerBits;
};

Header header @ 0x7FF0;