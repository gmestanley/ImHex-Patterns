#pragma author gmestanley
#pragma description XM file format

#pragma MIME audio/module-xm
#pragma MIME audio/xm
#pragma MIME audio/x-xm

bitfield HeaderFlags {
	amigaFrequencyTable : 1;
	linearFrequencyTable : 1;
	padding : 14;
};

struct Header {
	char signature[17];
	char moduleName[21];
	char trackerName[20];
	u8 majorVersion;
	u8 minorVersion;
	u32 headerSize;
	u16 songLength;
	u16 restartPosition;
	u16 numberOfChannels;
	u16 numberOfPatterns;
	u16 numberOfInstruments;
	HeaderFlags flags;
	u16 defaultTempo;
	u16 defaultBPM;
	u8 patternOrderTable[256];
};

Header header @ 0x00;