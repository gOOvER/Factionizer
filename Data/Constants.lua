----------------------------------------------------------
-- Factionizer - Constants & Addon Namespace            --
----------------------------------------------------------

local addonName, vars = ...
vars = vars or {}

local LibStub = LibStub
local AceAddon = LibStub("AceAddon-3.0")

local FIZ = AceAddon:NewAddon(
	vars,
	"Factionizer",
	"AceConsole-3.0",
	"AceEvent-3.0",
	"AceHook-3.0",
	"AceTimer-3.0",
	"AceBucket-3.0",
	"AceComm-3.0",
	"AceSerializer-3.0",
	"LibSink-2.0"
)
_G.FIZ = FIZ
_G.Factionizer = FIZ

FIZ.L = vars.L or LibStub("AceLocale-3.0"):GetLocale("Factionizer", true) or {}

---------------------------
-- Addon Constants       --
---------------------------

FIZ_NAME = addonName or "Factionizer"
FIZ_VNMBR = 7000000

FIZ_ToExalted = {
	[0] = 84000,
	[1] = 48000, -- Hated -> Hostile
	[2] = 45000, -- Hostile -> Unfriendly
	[3] = 42000, -- Unfriendly -> Neutral
	[4] = 39000, -- Neutral -> Friendly
	[5] = 33000, -- Friendly -> Honored
	[6] = 21000, -- Honored -> Revered
	[7] = 0,     -- Revered -> Exalted
	[8] = 0,     -- Exalted
}

FIZ_ToBFF = {
	[0] = 42999, -- 1 - Stranger: 0-8400
	[1] = 42000, -- 2 - Acquaintance: 8400-16800
	[2] = 33600, -- 3 - Buddy: 16800-25200
	[3] = 25200, -- 4 - Friend: 25200-33600
	[4] = 16800, -- 5 - Good Friend: 33600-42000
	[5] = 8400,  -- 6 - Best Friend: 42000-42999
}

-- Colours
FIZ_Help_COLOUR = "|cFFFFFF7F"
FIZ_NEW_REP_COLOUR = "|cFF7F7FFF"
FIZ_NEW_STANDING_COLOUR = "|cFF6060C0"
FIZ_BAG_COLOUR = "|cFFC0FFC0"
FIZ_BAG_BANK_COLOUR = "|cFFFFFF7F"
FIZ_QUEST_COLOUR = "|cFFC0FFC0"
FIZ_HIGHLIGHT_COLOUR = "|cFF00FF00"
FIZ_QUEST_ACTIVE_COLOUR = "|cFFFF7F7F"
FIZ_LOWLIGHT_COLOUR = "|cFFFF3F3F"
FIZ_SUPPRESS_COLOUR = "|cFF7F7F7F"

-- Profession limit types
FIZ_LIMIT_TYPE_Herb = 1
FIZ_LIMIT_TYPE_Skin = 2
FIZ_LIMIT_TYPE_Mine = 3
FIZ_LIMIT_TYPE_Gather = 4
FIZ_LIMIT_TYPE_Engi = 5
FIZ_LIMIT_TYPE_Alch = 6
FIZ_LIMIT_TYPE_Blac = 7
FIZ_LIMIT_TYPE_Tail = 8
FIZ_LIMIT_TYPE_Leat = 9
FIZ_LIMIT_TYPE_Ench = 10
FIZ_LIMIT_TYPE_Jewe = 11
FIZ_LIMIT_TYPE_Incr = 12
FIZ_LIMIT_TYPE_Aid = 13
FIZ_LIMIT_TYPE_Arch = 14
FIZ_LIMIT_TYPE_Cook = 15
FIZ_LIMIT_TYPE_Fish = 16

-- Championing Tabard Buff Spell IDs -> { maxLevel, factionID }
FIZ.ChampionFactions = {
	-- WotLK Championing Tabards
	[57819] = { 80, 1037 }, -- Alliance Vanguard
	[57820] = { 80, 1052 }, -- Horde Expedition
	[57821] = { 80, 1090 }, -- Kirin Tor
	[57822] = { 80, 1098 }, -- Knights of the Ebon Blade
	[57823] = { 80, 1091 }, -- The Wyrmrest Accord
	[57824] = { 80, 1106 }, -- Argent Crusade
	-- City Tabards (Cataclysm+)
	[93795] = { 85, 72 },   -- Stormwind
	[93805] = { 85, 47 },   -- Ironforge
	[93806] = { 85, 54 },   -- Gnomeregan
	[93811] = { 85, 69 },   -- Darnassus
	[93816] = { 85, 930 },  -- Exodar
	[93821] = { 85, 1134 }, -- Gilneas
	[93825] = { 85, 76 },   -- Orgrimmar
	[93827] = { 85, 530 },  -- Darkspear Trolls
	[93828] = { 85, 81 },   -- Thunder Bluff
	[93830] = { 85, 68 },   -- Undercity
	[94462] = { 85, 911 },  -- Silvermoon City
	[94463] = { 85, 1133 }, -- Bilgewater Cartel
	[126434] = { 90, 1353 }, -- Tushui Pandaren
	[126436] = { 90, 1352 }, -- Huojin Pandaren
	-- Cataclysm Faction Tabards
	[93832] = { 85, 1158 }, -- Guardians of Hyjal
	[93833] = { 85, 1135 }, -- The Earthen Ring
	[93838] = { 85, 1171 }, -- Therazane
	[93840] = { 85, 1173 }, -- Ramkahen
	[93841] = { 85, 1174 }, -- Wildhammer Clan
	[93846] = { 85, 1172 }, -- Dragonmaw Clan
}

--------------------------
-- Addon State Globals  --
--------------------------

FIZ_Data = FIZ_Data or {}
FIZ_Suppressed = FIZ_Suppressed or {}
FIZ_Collapsed = FIZ_Collapsed or {}
FIZ_StoredRep = FIZ_StoredRep or {}
FIZ_FactionMapping = {}
FIZ_FactionGain = {}
FIZ_Entries = {}
FIZ_UpdateList = {}
FIZ_OBS_numFactions = 0
FIZ_UPDATE_LIST_HEIGHT = 13

FIZ_CurrentRepInBag = 0
FIZ_CurrentRepInBagBank = 0
FIZ_CurrentRepInQuest = 0

-- Skill Tracking
FIZ_Herb = false
FIZ_Skin = false
FIZ_Mine = false
FIZ_Jewel = false
FIZ_Cook = false
FIZ_Arch = false
FIZ_Fish = false
FIZ_Aid = false
FIZ_Black = false
FIZ_Tailor = false
FIZ_Leath = false
FIZ_Enchan = false
FIZ_Engin = false
FIZ_Incrip = false
FIZ_Alche = false

-- Race/Side/Difficulty
FIZ_IsHuman = false
FIZ_IsDeathKnight = false
FIZ_IsAlliance = false
FIZ_IsHorde = false
FIZ_IsHeroic = false
FIZ_GuildName = nil
FIZ_Player = nil
FIZ_Realm = nil
FIZ_InitComplete = false
FIZ_InitCount = 0

FIZ.DEFAULT_PROFILE = {
	ShowMobs = true,
	ShowQuests = true,
	ShowInstances = true,
	ShowItems = true,
	ShowGeneral = true,
	ShowMissing = true,
	ExtendDetails = true,
	WriteChatMessage = true,
	NoGuildGain = true,
	SuppressOriginalChat = true,
	ShowPreviewRep = true,
	SwitchFactionBar = true,
	SilentSwitch = true,
	NoGuildSwitch = true,
	SortByStanding = false,
	StatusBarTexture = "Blizzard",
	ChatFrame = 0,
	Version = FIZ_VNMBR,
	OriginalCollapsed = {},
	Suppressed = {},
	minimap = {
		hide = false,
	},
	window = {
		detached = false,
		scale = 1.0,
	},
	configWindow = {
		scale = 1.0,
	},
	sink = {
		sink20OutputSink = "Chat",
		sink20Sticky = false,
	},
	enableCommSync = true,
}

FIZ.DB_DEFAULTS = {
	profile = FIZ.DEFAULT_PROFILE,
	char = {
		Collapsed = {},
		StoredRep = {},
	},
}

