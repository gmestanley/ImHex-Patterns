#pragma author gmestanley
#pragma description PC98 Disk Format

import chs;

chsAddress = 0x20;

enum FDDType : u32 {
	HardDisk = 5,
	FloppyDisk640Or720K = 16,
	FloppyDisk1Point44M = 0x30,
	FloppyDisk1Point2M = 0x90
};

struct Header {
	FDDType fddType;
	u32 headerSize;
	u32 dataSize;
	u32 bytesPerSector;
	u32 sectorCount;
	u32 headCount;
	u32 cylinderCount;
};

Header header @ 0x04;