using pokechar = u8;

bitfield PlayerBadges {
	badge : 1;
	badge1 : 1;
	badge2 : 1;
	badge3 : 1;
	badge4 : 1;
	badge5 : 1;
	badge6 : 1;
	badge7 : 1;
};

struct InitialTime {
	u8 initialDay;
	u8 initialHour;
	u8 initialMinute;
	u8 initialSecond;
};

struct TimePlayed {
	u8 gameTimeCap;
	u16 hoursPlayed;
	u8 minutesPlayed;
	u8 secondsPlayed;
	u8 framesPlayed;
};

bool crystal in;

struct Savefile {
	u8 options[8];
	padding[1];
	u16 trainerID;
	pokechar playerName[11];
	pokechar momName[11];
	pokechar rivalName[11];
	pokechar redName[11];
	pokechar blueName[11];
	if (crystal) {
	   bool hasSaved;
	   bool spawnAfterChampion;
	   InitialTime initialTime;
	   pokechar rtc[4];
	   pokechar four[4];
	}
	bool daylightSavings;
	TimePlayed timePlayed;
	if (crystal) {
	   pokechar two[2];
	   u8 currentDay;
	   pokechar one;
	   u8 objectFollowsLeader;
	   u8 objectFollowsFollower;
	   u8 centeredObject;
	   u8 followerMovementQueueLength;
	   pokechar followMovementQueue[5];
	}
	else {
	u8 playerPalette;
	u24 money;
	PlayerBadges playerBadges;
	}
};

Savefile primaryCopy @ 0x2000;