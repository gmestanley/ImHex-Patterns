#pragma author gmestanley
#pragma description Sega Saturn disc format

struct GameNameString {
    char string[16] [[]];
};

struct GameName {
	GameNameString gameName[while(std::mem::read_unsigned($,16)!=32)];
	char rest[while($<224)];
};

struct Header {
	char console[16] [[format("fstsOne")]];
	char copyright[16];
	char id[10] [[format("fstsOne")]];
	char consoleVersion[6];
	char pressDate[16] [[format("fstsOne")]];
	char area[16] [[format("fstsOne")]];
	char region[16] [[format("fstsOne")]];
	GameName
};

Header header @ 16;