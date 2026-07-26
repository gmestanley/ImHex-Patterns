#pragma author gmestanley
#pragma description GameBoy Sound file format

import std.mem;
import std.string;

fn formatString(str string) {
	u8 stringIndex;
	while (stringIndex < 32) {
		if (!std::mem::read_unsigned($+stringIndex, 1)) {
			break;
		}
		stringIndex += 1;
	}
	return "\"" + std::string::substr(string, 0, stringIndex) + "\"";
};

struct Header {
	char signature[3];
	u8 version;
	u8 numberOfTracks;
	u8 flags[11];
	char title[32] [[format("formatString")]];
	char credits[32] [[format("formatString")]];
	char copyright[32] [[format("formatString")]];
};

Header header @ 0x00;

u8 data[std::mem::size()-sizeof(header)] @ sizeof(header);
