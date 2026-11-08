----------------------------------------------------------
-- Factionizer - Reputation Content & Builders          --
----------------------------------------------------------

local FIZ = _G.FIZ

FIZ.ContentModules = FIZ.ContentModules or {}

function FIZ:RegisterContentModule(name, initFunc)
	if type(initFunc) == "function" then
		table.insert(self.ContentModules, { name = name, init = initFunc })
	end
end

function FIZ:Content(faction, from, to, name, rep)
	if not faction then return 0 end
	if not from then return 0 end
	if not to then return 0 end
	if not name then return 0 end
	if not rep then return 0 end
	if type(rep) ~= "number" then return 0 end
	if from < 1 or from > 8 then return 0 end
	if to < 1 or to > 8 then return 0 end
	if from > to then return 0 end
	return 1
end

function FIZ:AddSpell(faction, from, to, name, rep, zone, limit)
	if self:Content(faction, from, to, name, rep) ~= 1 then return end
end

function FIZ:AddMob(faction, from, to, name, rep, zone, limit)
	if self:Content(faction, from, to, name, rep) ~= 1 then return end
	local idKey = (type(faction) == "number") and ("id:" .. tostring(faction)) or nil
	local resolvedFaction = self:InitFaction(FIZ_GuildName, faction)
	if not resolvedFaction then return end

	rep = rep * self:InitFactor(FIZ_IsHuman, FIZ_faction)
	faction = string.lower(resolvedFaction)

	for standing = from, to do
		local faction_info = FIZ_FactionGain[faction] or (idKey and FIZ_FactionGain[idKey])
		if not faction_info then
			faction_info = {}
		end
		FIZ_FactionGain[faction] = faction_info
		if idKey then FIZ_FactionGain[idKey] = faction_info end
		local standing_info = faction_info[standing]
		if not standing_info then
			standing_info = {}
			faction_info[standing] = standing_info
		end
		local add_info = standing_info.mobs
		if add_info then
			add_info.count = add_info.count + 1
		else
			add_info = { data = {}, count = 0 }
			standing_info.mobs = add_info
		end
		local count = add_info.count
		add_info.data[count] = {
			name = name,
			rep = rep,
			maxStanding = to,
			zone = zone,
			limit = (standing == to and limit) and limit or nil,
		}
	end
end

function FIZ:AddQuest(faction, from, to, name, rep, itemList, limitType)
	if self:Content(faction, from, to, name, rep) ~= 1 then return end
	local idKey = (type(faction) == "number") and ("id:" .. tostring(faction)) or nil
	local resolvedFaction = self:InitFaction(FIZ_GuildName, faction)
	if not resolvedFaction then return end

	rep = rep * self:InitFactor(FIZ_IsHuman, FIZ_faction)
	faction = string.lower(resolvedFaction)

	for standing = from, to do
		local faction_info = FIZ_FactionGain[faction] or (idKey and FIZ_FactionGain[idKey])
		if not faction_info then
			faction_info = {}
		end
		FIZ_FactionGain[faction] = faction_info
		if idKey then FIZ_FactionGain[idKey] = faction_info end
		local standing_info = faction_info[standing]
		if not standing_info then
			standing_info = {}
			faction_info[standing] = standing_info
		end
		local add_info = standing_info.quests
		if add_info then
			add_info.count = add_info.count + 1
		else
			add_info = { data = {}, count = 0 }
			standing_info.quests = add_info
		end
		local count = add_info.count
		local add_count = {
			name = name,
			rep = rep,
			maxStanding = to,
		}
		if itemList then
			if itemList == "nil" then
				add_count.profession = limitType
			elseif type(itemList) == "table" then
				add_count.items = {}
				for item, amt in pairs(itemList) do
					add_count.items[item] = amt
				end
			end
		end
		add_info.data[count] = add_count
	end
end

function FIZ:AddInstance(faction, from, to, name, rep, heroic)
	if self:Content(faction, from, to, name, rep) ~= 1 then return end
	local idKey = (type(faction) == "number") and ("id:" .. tostring(faction)) or nil
	local resolvedFaction = self:InitFaction(FIZ_GuildName, faction)
	if not resolvedFaction then return end

	rep = rep * self:InitFactor(FIZ_IsHuman, FIZ_faction)
	faction = string.lower(resolvedFaction)

	for standing = from, to do
		local faction_info = FIZ_FactionGain[faction] or (idKey and FIZ_FactionGain[idKey])
		if not faction_info then
			faction_info = {}
		end
		FIZ_FactionGain[faction] = faction_info
		if idKey then FIZ_FactionGain[idKey] = faction_info end
		local standing_info = faction_info[standing]
		if not standing_info then
			standing_info = {}
			faction_info[standing] = standing_info
		end
		local add_info = standing_info.instance
		if add_info then
			add_info.count = add_info.count + 1
		else
			add_info = { data = {}, count = 0 }
			standing_info.instance = add_info
		end
		local count = add_info.count
		add_info.data[count] = {
			name = name,
			rep = rep,
			maxStanding = to,
			level = heroic and FIZ_TXT.heroic or FIZ_TXT.normal,
		}
	end
end

function FIZ:AddItems(faction, from, to, rep, itemList)
	if self:Content(faction, from, to, itemList, rep) ~= 1 then return end
	local idKey = (type(faction) == "number") and ("id:" .. tostring(faction)) or nil
	local resolvedFaction = self:InitFaction(FIZ_GuildName, faction)
	if not resolvedFaction then return end

	rep = rep * self:InitFactor(FIZ_IsHuman, FIZ_faction)
	faction = string.lower(resolvedFaction)

	for standing = from, to do
		local faction_info = FIZ_FactionGain[faction] or (idKey and FIZ_FactionGain[idKey])
		if not faction_info then
			faction_info = {}
		end
		FIZ_FactionGain[faction] = faction_info
		if idKey then FIZ_FactionGain[idKey] = faction_info end
		local standing_info = faction_info[standing]
		if not standing_info then
			standing_info = {}
			faction_info[standing] = standing_info
		end
		local add_info = standing_info.items
		if add_info then
			add_info.count = add_info.count + 1
		else
			add_info = { data = {}, count = 0 }
			standing_info.items = add_info
		end
		local count = add_info.count
		local add_count = {
			rep = rep,
			maxStanding = to,
		}
		if type(itemList) == "table" then
			add_count.items = {}
			for item, amt in pairs(itemList) do
				add_count.items[item] = amt
			end
		end
		add_info.data[count] = add_count
	end
end

function FIZ:AddGeneral(faction, from, to, name, rep, head, tip, tipList, flag)
	if self:Content(faction, from, to, name, rep) ~= 1 then return end
	local idKey = (type(faction) == "number") and ("id:" .. tostring(faction)) or nil
	local resolvedFaction = self:InitFaction(FIZ_GuildName, faction)
	if not resolvedFaction then return end

	rep = rep * self:InitFactor(FIZ_IsHuman, FIZ_faction)
	faction = string.lower(resolvedFaction)

	for standing = from, to do
		local faction_info = FIZ_FactionGain[faction] or (idKey and FIZ_FactionGain[idKey])
		if not faction_info then
			faction_info = {}
		end
		FIZ_FactionGain[faction] = faction_info
		if idKey then FIZ_FactionGain[idKey] = faction_info end
		local standing_info = faction_info[standing]
		if not standing_info then
			standing_info = {}
			faction_info[standing] = standing_info
		end
		local add_info = standing_info.general
		if add_info then
			add_info.count = add_info.count + 1
		else
			add_info = { data = {}, count = 0 }
			standing_info.general = add_info
		end
		local count = add_info.count

		local entryName = name
		local entryHead = head
		local entryTip = tip
		if entryName == "1" then
			entryName = FIZ_TXT.tfr
			entryHead = FIZ_TXT.tfr
			entryTip = FIZ_TXT.nswts
		else
			if self.TranslateContentText then
				entryName = self:TranslateContentText(entryName)
				entryHead = self:TranslateContentText(entryHead)
				entryTip = self:TranslateContentText(entryTip)
			end
		end

		local add_count = {
			name = entryName,
			rep = rep,
			maxStanding = to,
			flag = flag,
			head = entryHead,
			tip = entryTip,
		}
		if type(tipList) == "table" then
			add_count.tipList = {}
			for k, v in pairs(tipList) do
				add_count.tipList[k] = v
			end
		end
		add_info.data[count] = add_count
	end
end

----------------------------------------------------------
-- Shared Lookup Registries for Expansion Content Files --
----------------------------------------------------------

FIZ.Zone = {
	-- Kalimdor
	Kalimdor = 13,
	AhnQiraj_F_King = 772,
	Ammen_Vale = 894,
	Ashenvale = 43,
	Azshara = 181,
	Azuremyst_Isle = 464,
	Bloodmyst_Isle = 476,
	Camp_Narache = 890,
	Darkshore = 42,
	Darnassus = 381,
	Desolace = 101,
	Durotar = 1004,
	Dustwallow_Marsh = 141,
	Echo_Isles = 891,
	Felwood = 182,
	Feralas = 121,
	Molten_Front = 795,
	Moonglade = 241,
	Mount_Hyjal = 606,
	Mulgore = 9,
	Northern_Barrens = 11,
	Orgrimmar = 321,
	Shadowglen = 888,
	Silithus = 261,
	Southern_Barrens = 607,
	Stonetalon_Mountains = 81,
	Tanaris = 161,
	Teldrassil = 41,
	The_Exodar = 471,
	Thousand_Needles = 61,
	Thunder_Bluff = 362,
	Uldum = 720,
	UnGoro_Crater = 201,
	Valley_of_Trials = 889,
	Winterspring = 281,

	-- Eastern Kingdoms
	Eastern_Kingdoms = 14,
	Abyssal_Depths = 614,
	Arathi_Highlands = 16,
	Badlands = 17,
	Blasted_Lands = 19,
	Burning_Steppes = 29,
	Coldridge_Valley = 866,
	Deadwind_Pass = 32,
	Deathknell = 892,
	Dun_Morogh = 27,
	Duskwood = 34,
	E_Plaguelands = 23,
	Elwynn_Forest = 30,
	Evrsong_Woods = 462,
	Ghostlands = 463,
	Gilneas = 545,
	Gilneas_City = 611,
	Hillsbrad_Foothills = 24,
	Ironforge = 341,
	Isle_of_QuelDanas = 499,
	Kelpthar_Forest = 610,
	Loch_Modan = 35,
	New_Tinkertown = 895,
	N_Stranglethorn = 37,
	Northshire = 864,
	Redridge_Mountains = 36,
	R_Gilneas = 684,
	R_Gilneas_C = 685,
	Searing_Gorge = 28,
	Shimmering_Expanse = 615,
	Silvermoon_City = 480,
	Silverpine_Forest = 21,
	Stormwind_City = 301,
	Stranglethorn_Vale = 689,
	Sunstrider_Isle = 893,
	Swamp_of_Sorrows = 38,
	C_o_Stranglethorn = 673,
	The_Hinterlands = 26,
	The_Scarlet_Enclave = 502,
	Tirisfal_Glades = 20,
	Tol_Barad = 708,
	Tol_Barad_Peninsula = 709,
	Twilight_Highlands = 700,
	Undercity = 382,
	Vashjir = 613,
	W_Plaguelands = 22,
	Westfall = 39,
	Wetlands = 40,

	-- Outland
	Outland = 466,
	Blades_Edge = 475,
	Hellfire_Peninsula = 465,
	Nagrand = 477,
	Netherstorm = 479,
	Shadowmoon_Valley_TBC = 473,
	Shattrath_City = 481,
	Terokkar_Forest = 478,
	Zangarmarsh = 467,

	-- Northrend
	Northrend = 485,
	Borean_Tundra = 486,
	Crystalsong_Forest = 510,
	Dalaran = 504,
	Dragonblight = 488,
	Grizzly_Hills = 490,
	Howling_Fjord = 491,
	Hrothgars_Landing = 541,
	Icecrown = 492,
	Sholazar_Basin = 493,
	The_Storm_Peaks = 495,
	Wintergrasp = 501,
	ZulDrak = 496,

	-- The Maelstrom
	The_Maelstrom = 751,
	Deepholm = 640,
	Kezan = 605,
	The_Lost_Isles = 544,
	The_Maelstrom2 = 737,
	The_Wandering_Isle = 808,

	-- Pandaria
	Pandaria = 862,
	Dread_Wastes = 858,
	Isle_of_Giants = 929,
	Isle_of_Thunder = 928,
	Krasarang_Wilds = 857,
	Kun_Lai_Summit = 809,
	Shrine_of_7_Stars = 905,
	Shrine_of_2_Moons = 903,
	The_Jade_Forest = 806,
	The_Veiled_Stair = 873,
	Timeless_Isle = 951,
	Townlong_Steppes = 810,
	Vale_of_Eternal_Blossoms = 811,
	Valley_ot_FourvWind = 807,

	-- Draenor
	Draenor = 962,
	Ashran = 978,
	Frostfire_Ridge = 941,
	Frostwall = 976,
	Gorgrond = 949,
	Lunarfall = 971,
	Nagrand_WoD = 950,
	Shadowmoon_Valley = 947,
	Spires_of_Arak = 948,
	Stormshield = 1009,
	Talador = 946,
	Tanaan_Jungle = 945,
	TaJuAs_ot_Dark_Portal = 970,
	Warspear = 1011,

	-- Broken Isles & Argus (Legion 7.x - offset by 10000 to avoid legacy ID collisions)
	Broken_Isles = 10619,
	Azsuna = 10630,
	Valsharah = 10641,
	Highmountain = 10650,
	Stormheim = 10634,
	Suramar = 10680,
	Broken_Shore = 10646,
	Dalaran_Legion = 10627,
	Krokuun = 10830,
	Eredath = 10882,
	Antoran_Wastes = 10885,
	Argus = 10905,

	-- Kul Tiras & Zandalar (Battle for Azeroth 8.x)
	Kul_Tiras = 10876,
	Tiragarde_Sound = 10895,
	Boralus = 11161,
	Drustvar = 10896,
	Stormsong_Valley = 10942,
	Zandalar = 10875,
	Zuldazar = 10862,
	Dazaralor = 11165,
	Nazmir = 10863,
	Voldun = 10864,
	Nazjatar = 11355,
	Mechagon = 11462,
	Uldum_BfA = 11527,
	Vale_BfA = 11530,

	-- Shadowlands (9.x)
	Shadowlands = 11550,
	Oribos = 11670,
	Bastion = 11533,
	Maldraxxus = 11536,
	Ardenweald = 11565,
	Revendreth = 11525,
	The_Maw = 11543,
	Korthia = 11961,
	Zereth_Mortis = 11970,

	-- Dragon Isles (Dragonflight 10.x)
	Dragon_Isles = 11978,
	Waking_Shores = 12022,
	Ohnahran_Plains = 12023,
	Azure_Span = 12024,
	Thaldraszus = 12025,
	Valdrakken = 12112,
	Forbidden_Reach = 12151,
	Zaralek_Cavern = 12133,
	Emerald_Dream = 12200,
	Amirdrassil = 12239,

	-- Khaz Algar (The War Within 11.x)
	Khaz_Algar = 12274,
	Isle_of_Dorn = 12248,
	Dornogal = 12339,
	Ringing_Deeps = 12214,
	Hallowfall = 12215,
	Azj_Kahet = 12255,
	City_of_Threads_Zone = 12256,
	Siren_Isle = 12369,
	Undermine = 12346,
	Karesh = 12371,

	-- Quel'Thalas (Midnight 12.x)
	QuelThalas = 12400,
	Eversong_Midnight = 12401,
	ZulAman_Midnight = 12402,
	Harandar = 12403,
	Voidstorm = 12404,

	-- Classic Forever (1.16 / 16001)
	Zephras_Isle = 9901,
	Shadowgale_Forest = 9902,
	Riverglades = 9903,
	Darkspear_Islands = 9904,
	Farhold_Keep = 9905,
	Skywall_Forever = 9906,

	-- Battlegrounds
	Alterac_Valley = 401,
	Arathi_Basin = 461,
	Deepwind_Gorge = 935,
	Eye_of_the_Storm = 482,
	Isle_of_Conquest = 540,
	Seething_Shore = 10907,
	Silvershard_Mines = 860,
	Strand_ot_Ancients = 512,
	Temple_of_Kotmogu = 856,
	Battle_for_Gilneas = 736,
	Twin_Peaks = 626,
	Warsong_Gulch = 443,

	-- Classic Dungeons & Raids
	Blackfathom_Deeps = 688,
	Blackrock_Depths = 704,
	Blackrock_Spire = 721,
	Dire_Maul = 699,
	Gnomeregan = 691,
	Maraudon = 750,
	Ragefire_Chasm = 680,
	Razorfen_Downs = 760,
	Razorfen_Kraul = 761,
	Shadowfang_Keep = 764,
	Stratholme = 765,
	The_Deadmines = 756,
	The_Stockade = 690,
	Temple_of_AtalHakkar = 687,
	Uldaman = 692,
	Wailing_Caverns = 749,
	ZulFarrak = 686,
	Blackwing_Lair = 755,
	Molten_Core = 696,
	Ruins_of_AhnQiraj = 717,
	Temple_of_AhnQiraj = 766,

	-- Burning Crusade Dungeons & Raids
	Auchenai_Crypts = 722,
	Hellfire_Ramparts = 797,
	Magisters_Terrace = 798,
	Mana_Tombs = 732,
	O_Hills_Foothills = 734,
	Sethekk_Halls = 723,
	Shadow_Labyrinth = 724,
	The_Arcatraz = 731,
	The_Black_Morass = 733,
	The_Blood_Furnace = 725,
	The_Botanica = 729,
	The_Mechanar = 730,
	The_Shattered_Halls = 710,
	The_Slave_Pens = 728,
	The_Steamvault = 727,
	The_Underbog = 726,
	Black_Temple = 796,
	Gruuls_Lair = 776,
	Hyjal_Summit = 775,
	Karazhan = 799,
	Magtheridons_Lair = 779,
	Serpentshrine_Cavern = 780,
	Sunwell_Plateau = 789,
	The_Eye = 782,

	-- Wrath Dungeons & Raids
	Ahnkahet_T_O_Kingdom = 522,
	Azjol_Nerub = 533,
	DrakTharon_Keep = 534,
	Gundrak = 530,
	Halls_o_Lightning = 525,
	Halls_of_Reflection = 603,
	Halls_of_Stone = 526,
	Pit_of_Saron = 602,
	Culling_of_Stratholme = 521,
	The_Forge_of_Souls = 601,
	The_Nexus = 520,
	The_Oculus = 528,
	The_Violet_Hold = 536,
	Trial_ot_Champion = 542,
	Utgarde_Keep = 523,
	Utgarde_Pinnacle = 524,
	Icecrown_Citadel = 604,
	Naxxramas = 535,
	Onyxias_Lair = 718,
	The_Eye_of_Eternity = 527,
	The_Obsidian_Sanctum = 531,
	The_Ruby_Sanctum = 609,
	Trial_of_the_Crusader = 543,
	Ulduar = 529,
	Vault_of_Archavon = 532,

	-- Cataclysm Dungeons & Raids
	Blackrock_Caverns = 753,
	End_Time = 820,
	Grim_Batol = 757,
	Halls_of_Origination = 759,
	Hour_of_Twilight = 819,
	Lost_City_of_thevTolvir = 747,
	The_Stonecore = 768,
	The_Vortex_Pinnacle = 769,
	Throne_of_the_Tides = 767,
	Well_of_Eternity = 816,
	ZulAman = 781,
	ZulGurub = 793,
	Baradin_Hold = 752,
	Blackwing_Descent = 754,
	Dragon_Soul = 824,
	Firelands = 800,
	Bastion_of_Twilight = 758,
	Throne_ot_Four_Winds = 773,

	-- Pandaria Dungeons & Raids
	Gate_of_the_Setting_Sun = 875,
	MoguShan_Palace = 885,
	Scarlet_Halls = 871,
	Scarlet_Monastery = 874,
	Scholomance = 898,
	Shado_pan_Monastery = 877,
	Siege_of_Niuzao_Temple = 887,
	Stormstout_Brewery = 876,
	Temple_ot_Jade_Serpen = 867,
	Heart_of_Fear = 897,
	Mogushan_Vaults = 896,
	Siege_of_Orgrimmar = 953,
	Terrace_of_Endless_Spring = 886,
	Throne_of_Thunder = 930,

	-- Draenor Dungeons & Raids
	Auchindoun = 984,
	Bloodmaul_Slag_Mines = 964,
	Grimrail_Depot = 993,
	Iron_Docks = 987,
	Shadowmoon_Burial_Grounds = 969,
	Skyreach = 989,
	The_Everbloom = 1008,
	Up_Blackrock_Spire = 995,
	Highmaul = 994,
	Blackrock_Foundry = 988,
	Hellfire_Citadel = 7545,

	-- Legion Dungeons & Raids (7.x)
	Eye_of_Azshara = 10713,
	Darkheart_Thicket = 10733,
	Neltharions_Lair = 10731,
	Halls_of_Valor = 10703,
	Maw_of_Souls = 10706,
	Vault_of_the_Wardens = 10710,
	Black_Rook_Hold = 10751,
	Court_of_Stars = 10761,
	The_Arcway = 10749,
	Return_to_Karazhan = 10809,
	Cathedral_of_Eternal_Night = 10845,
	Seat_of_the_Triumvirate = 10903,
	The_Emerald_Nightmare = 10777,
	Trial_of_Valor = 10806,
	The_Nighthold = 10764,
	Tomb_of_Sargeras = 10850,
	Antorus = 10909,

	-- Battle for Azeroth Dungeons & Raids (8.x)
	AtalDazar = 10934,
	Freehold = 10936,
	Tol_Dagor = 10974,
	The_MOTHERLODE = 11010,
	Waycrest_Manor = 11015,
	Kings_Rest = 11004,
	Temple_of_Sethraliss = 11038,
	The_Underrot = 11041,
	Shrine_of_the_Storm = 11039,
	Siege_of_Boralus = 11162,
	Operation_Mechagon = 11490,
	Uldir = 11148,
	Battle_of_Dazaralor = 11352,
	Crucible_of_Storms = 11363,
	The_Eternal_Palace = 11512,
	Nyalotha = 11580,

	-- Shadowlands Dungeons & Raids (9.x)
	The_Necrotic_Wake = 11666,
	Plaguefall = 11674,
	Mists_of_Tirna_Scithe = 11669,
	Halls_of_Atonement = 11663,
	Spires_of_Ascension = 11693,
	Theater_of_Pain = 11683,
	De_Other_Side = 11677,
	Sanguine_Depths = 11675,
	Tazavesh = 11989,
	Castle_Nathria = 11735,
	Sanctum_of_Domination = 11998,
	Sepulcher_of_the_First_Ones = 12047,

	-- Dragonflight Dungeons & Raids (10.x)
	Ruby_Life_Pools = 12095,
	The_Nokhud_Offensive = 12093,
	The_Azure_Vault = 12073,
	Algethar_Academy = 12097,
	Neltharus = 12080,
	Brackenhide_Hollow = 12096,
	Halls_of_Infusion = 12082,
	Uldaman_Legacy_of_Tyr = 12071,
	Dawn_of_the_Infinite = 12190,
	Vault_of_the_Incarnates = 12119,
	Aberrus = 12166,
	Amirdrassil_Raid = 12232,

	-- The War Within Dungeons & Raids (11.x)
	The_Rookery = 12315,
	The_Stonevault = 12341,
	Priory_of_the_Sacred_Flame = 12308,
	Ara_Kara = 12357,
	Cinderbrew_Meadery = 12335,
	Darkflame_Cleft = 12303,
	The_Dawnbreaker = 12359,
	City_of_Threads = 12343,
	Operation_Floodgate = 12387,
	Eco_Dome_Aldani = 12392,
	Nerubar_Palace = 12291,
	Liberation_of_Undermine = 12406,
	Manaforge_Omega = 12412,

	-- Midnight Dungeons & Raids (12.x)
	Windrunner_Spire = 12420,
	Murder_Row = 12421,
	Den_of_Nalorakk = 12422,
	Maisara_Caverns = 12423,
	Blinding_Vale = 12424,
	Nexus_Point_Xenas = 12425,
	Voidscar_Arena = 12426,
	The_Voidspire = 12430,
	The_Dreamrift = 12431,
	March_on_QuelDanas = 12432,
}

FIZ.Mob = {
	t_mobs = 1,
	o_bosses = 2,
	a_bosses = 3,
	p_boss = 4,
	f_clear = 5,
	a_unamed = 11,
	a_named = 12,
	bs_bucc = 13,
	s_pirate = 14,
	wastewander = 15,
	a_vent_co = 16,
}

FIZ.QuestType = {
	mc_cook_dq = 1,
	oc_cook_dq = 2,
	mc_fish_dq = 3,
	oc_fish_dq = 4,
	no_dq = 5,
	outd = 6,
	champ_tabard = 7,
	bp_quest_fac = 8,
	da_jewel_dq = 9,
	world_quest = 10,
	elite_world_quest = 11,
	emissary_quest = 12,
	weekly_quest = 13,
	contract_wq = 14,
	calling_quest = 15,
	bountiful_delve = 16,
	special_assignment = 17,
}

FIZ.ItemType = {
	oc_comm_bad = 4,
}

FIZ.InstanceType = {
	spill_rep_dun = 1,
	TBD = 2,
	n_cat_inst = 3,
	h_cat_inst = 4,
}

function FIZ_InitEnFactionGains(guildName)
	for _, mod in ipairs(FIZ.ContentModules) do
		if mod.init then
			mod.init(FIZ, FIZ.Zone, FIZ.Mob, FIZ.QuestType, FIZ.ItemType, FIZ.InstanceType)
		end
	end

	if IsInGuild and IsInGuild() then
		FIZ:AddQuest("guildName", 4, 8, FIZ.QuestType.bp_quest_fac, 125)
	end
end
