#pragma author gmestanley
#pragma description Format of Microsoft .obj files

#pragma MIME application/x-coff

import std.core;
import std.string;
import type.time;
import type.guid;

enum MachineType : u16 {
	Unknown = 0x00,
	ALPHAAXPOld = 0x183,
	ALPHAAXP = 0x184,
	ALPHAAXP64Bit = 0x284,
	AM33 = 0x1D3,
	AMD64 = 0x8664,
	ARM = 0x1C0,
	ARM64 = 0xAA64,
	ARMNT = 0x1C4,
	CLRPureMSIL = 0xC0EE,
	EBC = 0xEBC,
	I386 = 0x14C,
	I860 = 0x14D,
	IA64 = 0x200,
	LOONGARCH32 = 0x6232,
	LOONGARCH64 = 0x6264,
	M32R = 0x9041,
	MIPS16 = 0x266,
	MIPSFPU = 0x366,
	MIPSFPU16 = 0x466,
	MOTOROLA68000 = 0x268,
	POWERPC = 0x1F0,
	POWERPCFP = 0x1F1,
	POWERPC64 = 0x1F2,
	R3000 = 0x162,
	R4000 = 0x166,
	R10000 = 0x168,
	RISCV32 = 0x5032,
	RISCV64 = 0x5064,
	RISCV128 = 0x5128,
	SH3 = 0x1A2,
	SH3DSP = 0x1A3,
	SH4 = 0x1A6,
	SH5 = 0x1A8,
	THUMB = 0x1C2,
	WCEMIPSV2 = 0x169
};

struct MSOBJHeader {
	padding[4];
	u16 unknown;
	MachineType machine;
	type::time32_t timeDateStamp;
	type::GUID guid;
	u32 coffSize;
};

MSOBJHeader msobjHeader @ 0x00;

enum PEFormat : u16 {
	ROM = 0x107,
	PE32 = 0x10B,
	PE32Plus = 0x20B
};

enum SubsystemType : u16 {
	Unknown = 0x00,
	Native = 0x01,
	WindowsGUI = 0x02,
	WindowsCUI = 0x03,
	OS2CUI = 0x05,
	POSIXCUI = 0x07,
	Windows9xNative = 0x08,
	WindowsCEGUI = 0x09,
	EFIApplication = 0x0A,
	EFIBootServiceDriver = 0x0B,
	EFIRuntimeDriver = 0x0C,
	EFIROM = 0x0D,
	Xbox = 0x0E,
	WindowsBootApplication = 0x10
};

bitfield Characteristics {
	baseRelocationsStripped : 1 [[hex::spec_name("IMAGE_FILE_RELOCS_STRIPPED")]];
	executableImage : 1 [[hex::spec_name("IMAGE_FILE_EXECUTABLE_IMAGE")]];
	lineNumbersStripped : 1 [[hex::spec_name("IMAGE_FILE_LINE_NUMS_STRIPPED")]];
	symbolsStripped : 1 [[hex::spec_name("IMAGE_FILE_LOCAL_SYMS_STRIPPED")]];
	aggressivelyTrimWorkingSet : 1 [[hex::spec_name("IMAGE_FILE_AGGRESSIVE_WS_TRIM")]];
	largeAddressAware : 1 [[hex::spec_name("IMAGE_FILE_LARGE_ADDRESS_AWARE")]];
	padding : 1;
	bytesReversedLo : 1 [[hex::spec_name("IMAGE_FILE_BYTES_REVERSED_LO")]];
	machine32Bit : 1 [[hex::spec_name("IMAGE_FILE_32BIT_MACHINE")]];
	debugInfoStripped : 1 [[hex::spec_name("IMAGE_FILE_DEBUG_STRIPPED")]];
	removableRunFromSwap : 1 [[hex::spec_name("IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP")]];
	netRunFromSwap : 1 [[hex::spec_name("IMAGE_FILE_NET_RUN_FROM_SWAP")]];
	systemFile : 1 [[hex::spec_name("IMAGE_FILE_SYSTEM")]];
	dll : 1 [[hex::spec_name("IMAGE_FILE_DLL")]];
	uniprocessorMachineOnly : 1 [[hex::spec_name("IMAGE_FILE_UP_SYSTEM_ONLY")]];
	bytesReversedHi : 1 [[hex::spec_name("IMAGE_FILE_BYTES_REVERSED_HI")]];
};

bitfield DLLCharacteristics {
	callWhenLoaded : 1;
	callWhenThreadTerminates : 1;
	callWhenThreadStarts : 1;
	callWhenExiting : 1;
	padding : 1;
	highEntropyVA : 1 [[hex::spec_name("IMAGE_DLLCHARACTERISTICS_HIGH_ENTROPY_VA")]];
	dynamicBase : 1 [[hex::spec_name("IMAGE_DLLCHARACTERISTICS_DYNAMIC_BASE")]];
	forceIntegrity : 1 [[hex::spec_name("IMAGE_DLLCHARACTERISTICS_FORCE_INTEGRITY")]];
	nxCompatible : 1 [[hex::spec_name("IMAGE_DLLCHARACTERISTICS_NX_COMPAT")]];
	noIsolation : 1 [[hex::spec_name("IMAGE_DLLCHARACTERISTICS_NO_ISOLATION")]];
	noSEH : 1 [[hex::spec_name("IMAGE_DLLCHARACTERISTICS_NO_SEH")]];
	doNotBind : 1 [[hex::spec_name("IMAGE_DLLCHARACTERISTICS_NO_BIND")]];
	appContainer : 1 [[hex::spec_name("IMAGE_DLLCHARACTERISTICS_APPCONTAINER")]];
	isWDMDriver : 1 [[hex::spec_name("IMAGE_DLLCHARACTERISTICS_WDM_DRIVER")]];
	supportsControlFlowGuard : 1 [[hex::spec_name("IMAGE_DLLCHARACTERISTICS_GUARD_CF")]];
	terminalServerAware : 1 [[hex::spec_name("IMAGE_DLLCHARACTERISTICS_TERMINAL_SERVER_AWARE ")]];
};

bitfield LoaderFlags {
	prestartBreakpoint : 1 [[comment("Invoke a breakpoint instruction before starting the process")]];
	postloadingDebugger : 1 [[comment("Invoke a debugger on the process after it's been loaded")]];
	padding : 30;
};

struct DataDirectory {
	u32 rva;
	u32 size;
};

struct OptionalHeader {
	PEFormat magic;
	u8 majorLinkerVersion;
	u8 minorLinkerVersion;
	u32 sizeOfCode;
	u32 sizeOfInitializedData;
	u32 sizeOfUninitializedData;
	u32 addressOfEntryPoint;
	u32 baseOfCode;
	if (magic == PEFormat::PE32Plus) {
		u64 imageBase;
	}
	else {
		u32 baseOfData;
		u32 imageBase;
	}
	u32 virtualSectionAlignment [[hex::spec_name("sectionAlignment")]];
	u32 rawSectionAlignment [[hex::spec_name("fileAlignment")]];
	u16 majorOperatingSystemVersion;
	u16 minorOperatingSystemVersion;
	u16 majorImageVersion;
	u16 minorImageVersion;
	u16 majorSubsystemVersion;
	u16 minorSubsystemVersion;
	u32 win32VersionValue;
	u32 sizeOfImage;
	u32 sizeOfHeaders;
	u32 checksum;
	SubsystemType subsystem;
	DLLCharacteristics dllCharacteristics;
	if (magic == PEFormat::PE32Plus) {
		u64 sizeOfStackReserve;
		u64 sizeOfStackCommit;
		u64 sizeOfHeapReserve;
		u64 sizeOfHeapCommit;
	}
	else {
		u32 sizeOfStackReserve;
		u32 sizeOfStackCommit;
		u32 sizeOfHeapReserve;
		u32 sizeOfHeapCommit;
	}
	LoaderFlags loaderFlags;
	u32 numberOfRVAsAndSizes [[hex::spec_name("numberOfRvaAndSizes")]];
	DataDirectory directories[numberOfRVAsAndSizes];
};

struct COFFHeader {
	MachineType machine;
	u16 numberOfSections;
	type::time32_t timeDateStamp;
	u32 pointerToSymbolTable;
	u32 numberOfSymbols;
	u16 sizeOfOptionalHeader;
	Characteristics characteristics;
	if (sizeOfOptionalHeader)
	   OptionalHeader optionalHeader;
};

COFFHeader coffHeader @ 0x20;

enum AlignmentType : u8 {    
	BoundaryOf1Byte = 1,
	BoundaryOf2Bytes,
	BoundaryOf4Bytes,
	BoundaryOf8Bytes,
	BoundaryOf16Bytes,
	BoundaryOf32Bytes,
	BoundaryOf64Bytes,
	BoundaryOf128Bytes,
	BoundaryOf256Bytes,
	BoundaryOf512Bytes,
	BoundaryOf1024Bytes,
	BoundaryOf2048Bytes,
	BoundaryOf4096Bytes,
	BoundaryOf8192Bytes,
};

fn formatAlignmentBits(u8 value) {
	if (value) {
		AlignmentType enumValue = value;
		return enumValue;
	}
	return value;
};

bitfield SectionFlags {
	padding : 3;
	doNotPad : 1 [[hex::spec_name("IMAGE_SCN_TYPE_NO_PAD")]];
	padding : 1;
	containsCode : 1 [[hex::spec_name("IMAGE_SCN_CNT_CODE")]];
	containsInitializedData : 1 [[hex::spec_name("IMAGE_SCN_CNT_INITIALIZED_DATA")]];
	containsUninitializedData : 1 [[hex::spec_name("IMAGE_SCN_CNT_UNINITIALIZED_DATA")]];
	linkOther : 1 [[hex::spec_name("IMAGE_SCN_LNK_OTHER")]];
	linkHasInformation : 1 [[hex::spec_name("IMAGE_SCN_LNK_INFO")]];
	padding : 1;
	linkRemove : 1 [[hex::spec_name("IMAGE_SCN_LNK_REMOVE")]];
	linkHasCOMDAT : 1 [[hex::spec_name("IMAGE_SCN_LNK_COMDAT")]];
	padding : 1;
	resetSpeculativeExceptions : 1 [[hex::spec_name("")]];
	globalPointerRelocations : 1 [[hex::spec_name("IMAGE_SCN_GPREL")]];
	purgeable : 1 [[hex::spec_name("IMAGE_SCN_MEM_PURGEABLE")]];
	is16Bit : 1 [[hex::spec_name("IMAGE_SCN_MEM_16BIT")]];
	locked : 1 [[hex::spec_name("IMAGE_SCN_MEM_LOCKED")]];
	preloaded : 1 [[hex::spec_name("IMAGE_SCN_MEM_PRELOAD")]];
	dataAlignment : 4 [[format("formatAlignmentBits")]];
	linkExtendedRelocations : 1 [[hex::spec_name("IMAGE_SCN_LNK_NRELOC_OVFL")]];
	discardable : 1 [[hex::spec_name("IMAGE_SCN_MEM_DISCARDABLE")]];
	notCached : 1 [[hex::spec_name("IMAGE_SCN_MEM_NOT_CACHED")]];
	notPageable : 1 [[hex::spec_name("IMAGE_SCN_MEM_NOT_PAGED")]];
	shared : 1 [[hex::spec_name("IMAGE_SCN_MEM_SHARED")]];
	executed : 1 [[hex::spec_name("IMAGE_SCN_MEM_EXECUTE")]];
	read : 1 [[hex::spec_name("IMAGE_SCN_MEM_READ")]];
	writtenOn : 1 [[hex::spec_name("IMAGE_SCN_MEM_WRITE")]];
};

fn formatNullTerminatedString(str string) {
	u8 currentNameSize;
	for (u8 i = 0, i < 8, i += 1) {
		if (std::mem::read_unsigned($+i, 1) == 0) {
			break;
		}
		currentNameSize += 1;
	}
	return "\"" + std::string::substr(string, 0, currentNameSize) + "\"";
};

struct SectionHeader {
	char name[8] [[name("sectionName"), hex::spec_name("name"), format("formatNullTerminatedString")]];
	u32 virtualSize;
	u32 virtualAddress;
	u32 sizeOfRawData;
	u32 ptrRawData;
	u32 ptrRelocations;
	u32 ptrLineNumbers;
	u16 numberOfRelocations;
	u16 numberOfLineNumbers;
	SectionFlags characteristics;
};

SectionHeader sectionsTable[coffHeader.numberOfSections] @ 0x20 + sizeof(coffHeader);

enum I386Relocations : u16 {
	Absolute = 0x00,
	Dir16 = 0x01,
	RelativeDisplacement16Bit = 0x02,
	VA32Bit = 0x06,
	RVA32Bit = 0x07,
	Seg12 = 0x09,
	SectionIndex = 0x0A,
	Offset = 0x0B,
	CLRToken = 0x0C,
	TargetSectionOffset = 0x0D,
	RelativeDisplacement32Bit = 0x14,
};

enum IA64Relocations : u16 {
	Absolute = 0x00,
	IMM14 = 0x01,
	IMM22 = 0x02,
	IMM64 = 0x03,
	VA32Bit = 0x04,
	VA64Bit = 0x05,
	PCREL21B = 0x06,
	PCREL21M = 0x07,
	PCREL21F = 0x08,
	GPREL22 = 0x09,
	LTOFF22 = 0x0A,
	Section = 0x0B,
	SECREL22 = 0x0C,
	SECREL64I = 0x0D,
	SECREL32 = 0x0E,
	RVA32Bit = 0x10,
	SREL14 = 0x11,
	SREL22 = 0x12,
	SREL32 = 0x13,
	UREL32 = 0x14,
	PCREL60X = 0x15,
	PCREL60B = 0x16,
	PCREL60F = 0x17,
	PCREL60I = 0x18,
	PCREL60M = 0x19,
	IMMGPREL64 = 0x1A,
	CLRToken = 0x1B,
	GPREL32 = 0x1C,
	ADDEND = 0x1F
};

enum MIPSRelocations : u16 {
	Absolute = 0x00,
	RefHalf = 0x01,
	RefWord = 0x02,
	JMPAddress = 0x03,
	RefHi = 0x04,
	RefLo = 0x05,
	GPREL = 0x06,
	Literal = 0x07,
	Section = 0x0A,
	SECREL = 0x0B,
	SecRelLo = 0x0C,
	SecRelHi = 0x0D,
	JMPAddr16 = 0x10,
	RefWordRelative = 0x22,
	Pair = 0x25
};

enum M32RRelocations : u16 {
	Absolute = 0x00,
	VA32Bit = 0x01,
	RVA32Bit = 0x02,
	VA24Bit = 0x03,
	GPREL16 = 0x04,
	PCREL24 = 0x05,
	PCREL16 = 0x06,
	PCREL8 = 0x07,
	RefHalf = 0x08,
	RefHi = 0x09,
	RefLo = 0x0A,
	Pair = 0x0B,
	Section = 0x0C,
	SECREL = 0x0D,
	CLRToken = 0x0E
};

struct Relocation {
	u32 virtualAddress;
	u32 symbolTableIndex;
	if (coffHeader.machine == MachineType::I386) {
		I386Relocations type;
	}
	else if (coffHeader.machine == MachineType::IA64) {
		IA64Relocations type;
	}
	else if (coffHeader.machine == MachineType::MIPS16 || MachineType::MIPSFPU || MachineType::MIPSFPU16 || MachineType::R4000 || MachineType::WCEMIPSV2) {
		MIPSRelocations type;
	}
	else if (coffHeader.machine == MachineType::M32R) {
		M32RRelocations type;
	}
	else {
		u16 type;
	}
};

fn formatASCIIZString(str string) {
	return "\"" + std::string::substr(string, 0, std::string::length(string)-1) + "\"";
};

struct DebugStructure {
	u8 unknown[14];
	type::GUID guid;
	u32 age;
	char filename[] [[format("formatASCIIZString")]];
	u8 rest[sectionsTable[std::core::array_index()].sizeOfRawData-(34+sizeof(filename))];
};

struct ASCIIZString {
	char string[] [[format("formatASCIIZString")]];
} [[inline]];

struct StringTable {
	u32 size;
	ASCIIZString strings[while($ < addressof(this) + size)];
} [[inline]];

struct Section {
    std::print(sectionsTable[std::core::array_index()].name);
    match (sectionsTable[std::core::array_index()].name) {
	(".drectve"): char command[sectionsTable[std::core::array_index()].sizeOfRawData] [[name(".drectve")]];
	(".cil$fg"): StringTable stringTable [[name(".cil$fg")]];
	(".cil$db"): DebugStructure debugStructure [[name(".cil$db")]];
    (_): u8 freeformSection[sectionsTable[std::core::array_index()].sizeOfRawData] [[name(sectionsTable[std::core::array_index()].name)]];
    }
};

Section sections[coffHeader.numberOfSections] @ sectionsTable[0].ptrRawData+0x20;

// Symbol & String Tables
enum SectionNumberType : s16 {
	Undefined = 0,
	Absolute = -1,
	Debug = -2
};

enum SymbolTypeMSB : u8 {
	Null = 0x00,
	Pointer = 0x10,
	Function = 0x20,
	Array = 0x30
};

enum SymbolTypeLSB : u8 {
	Null = 0x00,
	Void = 0x01,
	Char = 0x02,
	Short = 0x03,
	Integer = 0x04,
	Long = 0x05,
	Float = 0x06,
	Double = 0x07,
	Struct = 0x08,
	Union = 0x09,
	Enum = 0x0A,
	MemberOfEnum = 0x0B,
	Byte = 0x0C,
	Word = 0x0D,
	UInt = 0x0E,
	DWord = 0x0F
};

enum StorageClassType : s8 {
	EndOfFunction = -1,
	Null = 0,
	Automatic = 1,
	External = 2,
	Static = 3,
	Register = 4,
	DefinedExternally = 5,
	Label = 6,
	UndefinedLabel = 7,
	MemberOfStruct = 8,
	Argument = 9,
	StructTag = 10,
	MemberOfUnion = 11,
	UnionTag = 12,
	TypeDefinition = 13,
	UndefinedStatic = 14,
	EnumTag = 15,
	MemberOfEnum = 16,
	RegisterParameter = 17,
	Bitfield = 18,
	Block = 100,
	BlockFunction = 101,
	EndOfStruct = 102,
	File = 103,
	Section = 104,
	WeakExternal = 105,
	CLRToken = 107
};

struct SymbolNameOffset {
	padding[4];
	u32 offset [[name("nameOffset")]];
} [[inline]];

struct SymbolType {
	SymbolTypeMSB msb;
	SymbolTypeLSB lsb;
};

fn formatSymbolType(SymbolType value) {
	return "{ " + std::string::to_string(value.msb) + " | " + std::string::to_string(value.lsb) + " }";
};

struct Symbol {
	if (std::mem::read_unsigned($, 4) == 0) {
		SymbolNameOffset nameOffset;
	}
	else {
		char shortName[8] [[format("formatNullTerminatedString")]];
	}
	u32 value;
	SectionNumberType sectionNumber;
	SymbolType type [[format("formatSymbolType")]];
	StorageClassType storageClass;
	u8 numberOfAuxSymbols;
};

bool checkForSymbols in;

Symbol symbolTable[checkForSymbols * coffHeader.numberOfSymbols] @ coffHeader.pointerToSymbolTable+0x20;

StringTable stringTable[checkForSymbols] @ addressof(symbolTable) + sizeof(symbolTable);