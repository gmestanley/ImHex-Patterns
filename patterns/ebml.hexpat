#pragma author gmestanley
#pragma description EBML file format

#pragma endian big

bitfield Length {
	lengthFieldSize : $[$]>=0x80+ 1*$[$]>=0x40 + $[$]>=0x40;
	length : 7*lengthFieldSize;
};

enum ByteIDType : u8 { };
enum DByteIDType : u16 {
	CreationVersion = 0x4286 /*[[hex::spec_name("Version")]]*/,
	ReadVersion = 0x42F7,
	MaxIDLength = 0x42F2,
	MaxSizeLength = 0x42F3,
	
};
enum TByteIDType : u24 { };
enum QByteIDType : u32 { Signature = 0x1A45DFA3, Segment = 0x18538067, SeekHead = 0x114D9B74 };

struct Chunk {
	if ($[$] >= 0x80) ByteIDType ID;
	else if ($[$] >= 0x40) DByteIDType ID;
	else if ($[$] >= 0x20) TByteIDType ID;
	else QByteIDType ID;
	Length length;
	if (ID == 0x4282) char name[length.length];
	else u8 value[length.length];
};

Chunk headerChunk @ 0x00;
Chunk chunks[4] @ 0x05;