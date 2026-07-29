#pragma author gmestanley
#pragma description Sega Saturn disc format

import std.string;

fn formatSpaceTerminatedString(str string) {
    return "\"" + std::string::substr(string, 0, std::string::length(string)-1) + "\"";
};

fn formatSpacePaddedString(str string) {
    for (u8 i = 0, i < 16, i += 1) {
        if (std::mem::read_string($+i, 1) == " ") {
            return "\"" + std::string::substr(string, 0, i) + "\"";
        }
    }
};

struct GameNameString {
    char string[16] [[format("formatSpacePaddedString")]];
};

struct GameName {
    GameNameString gameName[while(std::mem::read_string($, 1) != " ")];
    char rest[while($<224)];
};

struct Header {
    char console[16] [[format("formatSpaceTerminatedString")]];
    char copyright[16];
    char id[10] [[format("formatSpacePaddedString")]];
    char consoleVersion[6];
    char pressDate[16] [[format("formatSpacePaddedString")]];
    char area[16] [[format("formatSpacePaddedString")]];
    char region[16] [[format("formatSpacePaddedString")]];
    GameName gameName;
};

Header header @ 16;
