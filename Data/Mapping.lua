----------------------------------------------------------
-- Factionizer - Faction, Zone, Mob, Item & Quest Map   --
----------------------------------------------------------

local FIZ = _G.FIZ
local LibStub = _G.LibStub
local HBD = LibStub and LibStub("HereBeDragons-2.0", true)
local HBDMigrate = LibStub and LibStub("HereBeDragons-Migrate", true)

-- Zone ID (from FIZ.Zone) -> { uiMapID, englishFallback, areaTableID, instanceID }
FIZ_LegacyZoneMap = {
	-- Kalimdor
	[13]    = { 12,  "Kalimdor", 12, 1 },
	[772]   = { 327, "Ahn'Qiraj: The Fallen Kingdom", 5095 },
	[894]   = { 468, "Ammen Vale", 3526 },
	[43]    = { 63,  "Ashenvale", 331 },
	[181]   = { 76,  "Azshara", 16 },
	[464]   = { 97,  "Azuremyst Isle", 3524 },
	[476]   = { 106, "Bloodmyst Isle", 3525 },
	[890]   = { 462, "Camp Narache", 221 },
	[42]    = { 62,  "Darkshore", 148 },
	[381]   = { 89,  "Darnassus", 1657 },
	[101]   = { 66,  "Desolace", 405 },
	[1004]  = { 1,   "Durotar", 14 },
	[141]   = { 70,  "Dustwallow Marsh", 15 },
	[891]   = { 463, "Echo Isles", 368 },
	[182]   = { 77,  "Felwood", 361 },
	[121]   = { 69,  "Feralas", 357 },
	[795]   = { 338, "Molten Front", 5733 },
	[241]   = { 80,  "Moonglade", 493 },
	[606]   = { 198, "Mount Hyjal", 616 },
	[9]     = { 7,   "Mulgore", 215 },
	[11]    = { 10,  "Northern Barrens", 17 },
	[321]   = { 85,  "Orgrimmar", 1637 },
	[888]   = { 460, "Shadowglen", 188 },
	[261]   = { 81,  "Silithus", 1377 },
	[607]   = { 199, "Southern Barrens", 4709 },
	[81]    = { 65,  "Stonetalon Mountains", 406 },
	[161]   = { 71,  "Tanaris", 440 },
	[41]    = { 57,  "Teldrassil", 141 },
	[471]   = { 103, "The Exodar", 3557 },
	[61]    = { 64,  "Thousand Needles", 400 },
	[362]   = { 88,  "Thunder Bluff", 1638 },
	[720]   = { 249, "Uldum", 5034 },
	[201]   = { 78,  "Un'Goro Crater", 490 },
	[889]   = { 461, "Valley of Trials", 363 },
	[281]   = { 83,  "Winterspring", 618 },

	-- Eastern Kingdoms
	[14]    = { 13,  "Eastern Kingdoms", 13, 0 },
	[614]   = { 204, "Abyssal Depths", 5145 },
	[16]    = { 14,  "Arathi Highlands", 45 },
	[17]    = { 15,  "Badlands", 3 },
	[19]    = { 17,  "Blasted Lands", 4 },
	[29]    = { 36,  "Burning Steppes", 46 },
	[866]   = { 427, "Coldridge Valley", 132 },
	[32]    = { 42,  "Deadwind Pass", 41 },
	[892]   = { 465, "Deathknell", 154 },
	[27]    = { 27,  "Dun Morogh", 1 },
	[34]    = { 47,  "Duskwood", 10 },
	[23]    = { 23,  "Eastern Plaguelands", 139 },
	[30]    = { 37,  "Elwynn Forest", 12 },
	[462]   = { 94,  "Eversong Woods", 3430 },
	[463]   = { 95,  "Ghostlands", 3433 },
	[545]   = { 179, "Gilneas", 4714 },
	[611]   = { 202, "Gilneas City", 4755 },
	[24]    = { 25,  "Hillsbrad Foothills", 267 },
	[341]   = { 87,  "Ironforge", 1537 },
	[499]   = { 122, "Isle of Quel'Danas", 4080 },
	[610]   = { 201, "Kelp'thar Forest", 4815 },
	[35]    = { 48,  "Loch Modan", 38 },
	[895]   = { 469, "New Tinkertown", 5000 },
	[37]    = { 50,  "Northern Stranglethorn", 33 },
	[864]   = { 425, "Northshire", 9 },
	[36]    = { 49,  "Redridge Mountains", 44 },
	[684]   = { 217, "Ruins of Gilneas", 4706 },
	[685]   = { 218, "Ruins of Gilneas City", 4755 },
	[28]    = { 32,  "Searing Gorge", 51 },
	[615]   = { 205, "Shimmering Expanse", 5144 },
	[480]   = { 110, "Silvermoon City", 3487 },
	[21]    = { 21,  "Silverpine Forest", 130 },
	[301]   = { 84,  "Stormwind City", 1519 },
	[689]   = { 224, "Stranglethorn Vale", 33 },
	[893]   = { 467, "Sunstrider Isle", 3431 },
	[38]    = { 51,  "Swamp of Sorrows", 8 },
	[673]   = { 210, "The Cape of Stranglethorn", 5287 },
	[26]    = { 26,  "The Hinterlands", 47 },
	[502]   = { 124, "Plaguelands: The Scarlet Enclave", 4298, 609 },
	[20]    = { 18,  "Tirisfal Glades", 85 },
	[708]   = { 244, "Tol Barad", 5095, 732 },
	[709]   = { 245, "Tol Barad Peninsula", 5389, 732 },
	[700]   = { 241, "Twilight Highlands", 4922 },
	[382]   = { 90,  "Undercity", 1497 },
	[613]   = { 203, "Vashj'ir", 5146 },
	[22]    = { 22,  "Western Plaguelands", 28 },
	[39]    = { 52,  "Westfall", 40 },
	[40]    = { 56,  "Wetlands", 11 },

	-- Outland
	[466]   = { 101, "Outland", 3483, 530 },
	[475]   = { 105, "Blade's Edge Mountains", 3522 },
	[465]   = { 100, "Hellfire Peninsula", 3483 },
	[477]   = { 107, "Nagrand", 3518 },
	[479]   = { 109, "Netherstorm", 3523 },
	[473]   = { 104, "Shadowmoon Valley", 3520 },
	[481]   = { 111, "Shattrath City", 3703 },
	[478]   = { 108, "Terokkar Forest", 3519 },
	[467]   = { 102, "Zangarmarsh", 3521 },

	-- Northrend
	[485]   = { 113, "Northrend", 4076, 571 },
	[486]   = { 114, "Borean Tundra", 3537 },
	[510]   = { 127, "Crystalsong Forest", 2817 },
	[504]   = { 125, "Dalaran", 4395 },
	[488]   = { 115, "Dragonblight", 65 },
	[490]   = { 116, "Grizzly Hills", 394 },
	[491]   = { 117, "Howling Fjord", 495 },
	[541]   = { 170, "Hrothgar's Landing", 4742 },
	[492]   = { 118, "Icecrown", 210 },
	[493]   = { 119, "Sholazar Basin", 3711 },
	[495]   = { 120, "The Storm Peaks", 67 },
	[501]   = { 123, "Wintergrasp", 4197 },
	[496]   = { 121, "Zul'Drak", 66 },

	-- The Maelstrom
	[751]   = { 948, "The Maelstrom", 5416, 646 },
	[640]   = { 207, "Deepholm", 5042, 646 },
	[605]   = { 194, "Kezan", 4737, 648 },
	[544]   = { 174, "The Lost Isles", 4720, 648 },
	[737]   = { 276, "The Maelstrom", 5416, 730 },
	[808]   = { 378, "The Wandering Isle", 5736, 860 },

	-- Pandaria
	[862]   = { 424, "Pandaria", 5845, 870 },
	[858]   = { 422, "Dread Wastes", 6138 },
	[929]   = { 507, "Isle of Giants", 6661 },
	[928]   = { 504, "Isle of Thunder", 6507, 1064 },
	[857]   = { 418, "Krasarang Wilds", 6134 },
	[809]   = { 379, "Kun-Lai Summit", 5841 },
	[905]   = { 393, "Shrine of Seven Stars", 6553 },
	[903]   = { 391, "Shrine of Two Moons", 6142 },
	[806]   = { 371, "The Jade Forest", 5785 },
	[873]   = { 433, "The Veiled Stair", 6375 },
	[951]   = { 554, "Timeless Isle", 6757 },
	[810]   = { 388, "Townlong Steppes", 5842 },
	[811]   = { 390, "Vale of Eternal Blossoms", 5840 },
	[807]   = { 376, "Valley of the Four Winds", 5805 },

	-- Draenor
	[962]   = { 572, "Draenor", 6719, 1116 },
	[978]   = { 588, "Ashran", 6941, 1191 },
	[941]   = { 525, "Frostfire Ridge", 6720 },
	[976]   = { 590, "Frostwall", 7004 },
	[949]   = { 543, "Gorgrond", 6721 },
	[971]   = { 582, "Lunarfall", 7078 },
	[950]   = { 550, "Nagrand", 6755 },
	[947]   = { 539, "Shadowmoon Valley", 6719 },
	[948]   = { 542, "Spires of Arak", 6722 },
	[1009]  = { 622, "Stormshield", 7332 },
	[946]   = { 535, "Talador", 6662 },
	[945]   = { 534, "Tanaan Jungle", 6723 },
	[970]   = { 577, "Tanaan Jungle", 6723 },
	[1011]  = { 624, "Warspear", 7333 },

	-- Legion (7.x - offset keys by 10000)
	[10619] = { 619, "Broken Isles", 7502, 1220 },
	[10630] = { 630, "Azsuna", 7334 },
	[10641] = { 641, "Val'sharah", 7558 },
	[10650] = { 650, "Highmountain", 7503 },
	[10634] = { 634, "Stormheim", 7541 },
	[10680] = { 680, "Suramar", 7637 },
	[10646] = { 646, "Broken Shore", 7543 },
	[10627] = { 627, "Dalaran", 7502 },
	[10830] = { 830, "Krokuun", 8574, 1669 },
	[10882] = { 882, "Eredath", 8701, 1669 },
	[10885] = { 885, "Antoran Wastes", 8899, 1669 },
	[10905] = { 905, "Argus", 8574, 1669 },

	-- Battle for Azeroth (8.x)
	[10876] = { 876,  "Kul Tiras", 8721, 1643 },
	[10895] = { 895,  "Tiragarde Sound", 8567 },
	[11161] = { 1161, "Boralus", 8568 },
	[10896] = { 896,  "Drustvar", 8956 },
	[10942] = { 942,  "Stormsong Valley", 9042 },
	[10875] = { 875,  "Zandalar", 8717, 1642 },
	[10862] = { 862,  "Zuldazar", 8670 },
	[11165] = { 1165, "Dazar'alor", 8670 },
	[10863] = { 863,  "Nazmir", 8650 },
	[10864] = { 864,  "Vol'dun", 8501 },
	[11355] = { 1355, "Nazjatar", 10052, 1718 },
	[11462] = { 1462, "Mechagon Island", 10290 },
	[11527] = { 1527, "Uldum", 5034 },
	[11530] = { 1530, "Vale of Eternal Blossoms", 5840 },

	-- Shadowlands (9.x)
	[11550] = { 1550, "The Shadowlands", 10413, 2222 },
	[11670] = { 1670, "Oribos", 10565 },
	[11533] = { 1533, "Bastion", 10534 },
	[11536] = { 1536, "Maldraxxus", 10413 },
	[11565] = { 1565, "Ardenweald", 11510 },
	[11525] = { 1525, "Revendreth", 10414 },
	[11543] = { 1543, "The Maw", 11400 },
	[11961] = { 1961, "Korthia", 13570 },
	[11970] = { 1970, "Zereth Mortis", 13536, 2374 },

	-- Dragonflight (10.x)
	[11978] = { 1978, "Dragon Isles", 13642, 2444 },
	[12022] = { 2022, "The Waking Shores", 13644 },
	[12023] = { 2023, "Ohn'ahran Plains", 13645 },
	[12024] = { 2024, "The Azure Span", 13646 },
	[12025] = { 2025, "Thaldraszus", 13647 },
	[12112] = { 2112, "Valdrakken", 13862 },
	[12151] = { 2151, "The Forbidden Reach", 14433 },
	[12133] = { 2133, "Zaralek Cavern", 14022, 2481 },
	[12200] = { 2200, "Emerald Dream", 14529, 2548 },
	[12239] = { 2239, "Amirdrassil", 14529 },

	-- The War Within (11.x)
	[12274] = { 2274, "Khaz Algar", 14717, 2601 },
	[12248] = { 2248, "Isle of Dorn", 14717 },
	[12339] = { 2339, "Dornogal", 14771 },
	[12214] = { 2214, "The Ringing Deeps", 14795 },
	[12215] = { 2215, "Hallowfall", 14838 },
	[12255] = { 2255, "Azj-Kahet", 14752 },
	[12256] = { 2256, "City of Threads", 14753 },
	[12369] = { 2369, "Siren Isle", 15328 },
	[12346] = { 2346, "Undermine", 15347, 2706 },
	[12371] = { 2371, "K'aresh", 15458, 2738 },

	-- Midnight (12.x)
	[12400] = { 2400, "Quel'Thalas" },
	[12401] = { 2401, "Eversong Woods" },
	[12402] = { 2402, "Zul'Aman" },
	[12403] = { 2403, "Harandar" },
	[12404] = { 2404, "Voidstorm" },

	-- Classic Forever (1.16 / 16001)
	[9901]  = { 9901, "Zephras Isle" },
	[9902]  = { 9902, "Shadowgale Forest" },
	[9903]  = { 9903, "Riverglades" },
	[9904]  = { 9904, "Darkspear Islands" },
	[9905]  = { 9905, "Farhold Keep" },
	[9906]  = { 9906, "Skywall" },

	-- Battlegrounds
	[401]   = { 91,  "Alterac Valley", 2597, 30 },
	[461]   = { 93,  "Arathi Basin", 3358, 529 },
	[935]   = { 519, "Deepwind Gorge", 6665, 1105 },
	[482]   = { 112, "Eye of the Storm", 3820, 566 },
	[540]   = { 169, "Isle of Conquest", 4710, 628 },
	[10907] = { 907, "Seething Shore", 8935, 1803 },
	[860]   = { 423, "Silvershard Mines", 6126, 727 },
	[512]   = { 128, "Strand of the Ancients", 4384, 607 },
	[856]   = { 417, "Temple of Kotmogu", 6051, 998 },
	[736]   = { 275, "The Battle for Gilneas", 5449, 761 },
	[626]   = { 206, "Twin Peaks", 5031, 726 },
	[443]   = { 92,  "Warsong Gulch", 3277, 489 },

	-- Classic Dungeons & Raids
	[688]   = { 221, "Blackfathom Deeps", 719, 48 },
	[704]   = { 242, "Blackrock Depths", 1584, 230 },
	[721]   = { 250, "Blackrock Spire", 1583, 229 },
	[699]   = { 234, "Dire Maul", 2557, 429 },
	[691]   = { 226, "Gnomeregan", 721, 90 },
	[750]   = { 280, "Maraudon", 2100, 349 },
	[680]   = { 213, "Ragefire Chasm", 2437, 389 },
	[760]   = { 300, "Razorfen Downs", 722, 129 },
	[761]   = { 301, "Razorfen Kraul", 491, 47 },
	[764]   = { 310, "Shadowfang Keep", 209, 33 },
	[765]   = { 317, "Stratholme", 2017, 329 },
	[756]   = { 291, "The Deadmines", 1581, 36 },
	[690]   = { 225, "The Stockade", 717, 34 },
	[687]   = { 220, "The Temple of Atal'Hakkar", 1477, 109 },
	[692]   = { 230, "Uldaman", 1337, 70 },
	[749]   = { 279, "Wailing Caverns", 718, 43 },
	[686]   = { 219, "Zul'Farrak", 1176, 209 },
	[755]   = { 287, "Blackwing Lair", 2677, 469 },
	[696]   = { 232, "Molten Core", 2717, 409 },
	[717]   = { 247, "Ruins of Ahn'Qiraj", 3429, 509 },
	[766]   = { 319, "Temple of Ahn'Qiraj", 3428, 531 },

	-- TBC Dungeons & Raids
	[722]   = { 256, "Auchenai Crypts", 3790, 558 },
	[797]   = { 347, "Hellfire Ramparts", 3562, 543 },
	[798]   = { 348, "Magisters' Terrace", 4131, 585 },
	[732]   = { 272, "Mana-Tombs", 3792, 557 },
	[734]   = { 274, "Old Hillsbrad Foothills", 2367, 560 },
	[723]   = { 258, "Sethekk Halls", 3791, 556 },
	[724]   = { 260, "Shadow Labyrinth", 3789, 555 },
	[731]   = { 269, "The Arcatraz", 3848, 552 },
	[733]   = { 273, "The Black Morass", 2366, 269 },
	[725]   = { 261, "The Blood Furnace", 3713, 542 },
	[729]   = { 266, "The Botanica", 3847, 553 },
	[730]   = { 267, "The Mechanar", 3849, 554 },
	[710]   = { 246, "The Shattered Halls", 3714, 540 },
	[728]   = { 265, "The Slave Pens", 3717, 547 },
	[727]   = { 263, "The Steamvault", 3715, 545 },
	[726]   = { 262, "The Underbog", 3716, 546 },
	[796]   = { 339, "Black Temple", 3959, 564 },
	[776]   = { 330, "Gruul's Lair", 3923, 565 },
	[775]   = { 329, "Hyjal Summit", 3606, 534 },
	[799]   = { 350, "Karazhan", 3457, 532 },
	[779]   = { 331, "Magtheridon's Lair", 3836, 544 },
	[780]   = { 332, "Serpentshrine Cavern", 3607, 548 },
	[789]   = { 335, "Sunwell Plateau", 4075, 580 },
	[782]   = { 334, "Tempest Keep", 3845, 550 },

	-- Wrath Dungeons & Raids
	[522]   = { 132, "Ahn'kahet: The Old Kingdom", 4494, 619 },
	[533]   = { 157, "Azjol-Nerub", 4277, 601 },
	[534]   = { 160, "Drak'Tharon Keep", 4196, 600 },
	[530]   = { 153, "Gundrak", 4416, 604 },
	[525]   = { 138, "Halls of Lightning", 4272, 602 },
	[603]   = { 185, "Halls of Reflection", 4820, 668 },
	[526]   = { 140, "Halls of Stone", 4264, 599 },
	[602]   = { 184, "Pit of Saron", 4813, 658 },
	[521]   = { 130, "The Culling of Stratholme", 4100, 595 },
	[601]   = { 183, "The Forge of Souls", 4809, 632 },
	[520]   = { 129, "The Nexus", 4265, 576 },
	[528]   = { 142, "The Oculus", 4228, 578 },
	[536]   = { 168, "The Violet Hold", 4415, 608 },
	[542]   = { 171, "Trial of the Champion", 4723, 650 },
	[523]   = { 133, "Utgarde Keep", 206, 574 },
	[524]   = { 136, "Utgarde Pinnacle", 1196, 575 },
	[604]   = { 186, "Icecrown Citadel", 4812, 631 },
	[535]   = { 162, "Naxxramas", 3456, 533 },
	[718]   = { 248, "Onyxia's Lair", 2159, 249 },
	[527]   = { 141, "The Eye of Eternity", 4500, 616 },
	[531]   = { 155, "The Obsidian Sanctum", 4493, 615 },
	[609]   = { 200, "The Ruby Sanctum", 4987, 724 },
	[543]   = { 172, "Trial of the Crusader", 4722, 649 },
	[529]   = { 147, "Ulduar", 4273, 603 },
	[532]   = { 156, "Vault of Archavon", 4603, 624 },

	-- Cataclysm Dungeons & Raids
	[753]   = { 283, "Blackrock Caverns", 4926, 645 },
	[820]   = { 401, "End Time", 5789, 938 },
	[757]   = { 293, "Grim Batol", 4950, 670 },
	[759]   = { 297, "Halls of Origination", 4945, 644 },
	[819]   = { 399, "Hour of Twilight", 5844, 940 },
	[747]   = { 277, "Lost City of the Tol'vir", 5396, 755 },
	[768]   = { 324, "The Stonecore", 5088, 725 },
	[769]   = { 325, "The Vortex Pinnacle", 5035, 657 },
	[767]   = { 322, "Throne of the Tides", 5004, 643 },
	[816]   = { 398, "Well of Eternity", 5788, 939 },
	[781]   = { 333, "Zul'Aman", 3805, 568 },
	[793]   = { 337, "Zul'Gurub", 1977, 309 },
	[752]   = { 282, "Baradin Hold", 5600, 757 },
	[754]   = { 285, "Blackwing Descent", 5094, 669 },
	[824]   = { 409, "Dragon Soul", 5892, 967 },
	[800]   = { 367, "Firelands", 5723, 720 },
	[758]   = { 294, "The Bastion of Twilight", 5334, 671 },
	[773]   = { 328, "Throne of the Four Winds", 5638, 754 },

	-- Mists of Pandaria Dungeons & Raids
	[875]   = { 437, "Gate of the Setting Sun", 5976, 962 },
	[885]   = { 453, "Mogu'shan Palace", 6182, 994 },
	[871]   = { 431, "Scarlet Halls", 6052, 1001 },
	[874]   = { 435, "Scarlet Monastery", 796, 1004 },
	[898]   = { 476, "Scholomance", 2057, 1007 },
	[877]   = { 443, "Shado-Pan Monastery", 5918, 959 },
	[887]   = { 457, "Siege of Niuzao Temple", 6214, 1011 },
	[876]   = { 439, "Stormstout Brewery", 5963, 961 },
	[867]   = { 429, "Temple of the Jade Serpent", 5956, 960 },
	[897]   = { 474, "Heart of Fear", 6297, 1009 },
	[896]   = { 471, "Mogu'shan Vaults", 6125, 1008 },
	[953]   = { 556, "Siege of Orgrimmar", 6738, 1136 },
	[886]   = { 456, "Terrace of Endless Spring", 6067, 996 },
	[930]   = { 508, "Throne of Thunder", 6622, 1098 },

	-- Warlords of Draenor Dungeons & Raids
	[984]   = { 593, "Auchindoun", 6912, 1182 },
	[964]   = { 573, "Bloodmaul Slag Mines", 6874, 1175 },
	[993]   = { 606, "Grimrail Depot", 6984, 1208 },
	[987]   = { 595, "Iron Docks", 6951, 1195 },
	[969]   = { 574, "Shadowmoon Burial Grounds", 6932, 1176 },
	[989]   = { 601, "Skyreach", 6988, 1209 },
	[1008]  = { 620, "The Everbloom", 7109, 1279 },
	[995]   = { 616, "Upper Blackrock Spire", 7307, 1358 },
	[994]   = { 610, "Highmaul", 6996, 1228 },
	[988]   = { 596, "Blackrock Foundry", 6967, 1205 },
	[7545]  = { 661, "Hellfire Citadel", 7545, 1448 },

	-- Legion Dungeons & Raids (7.x)
	[10713] = { 713, "Eye of Azshara", 8040, 1456 },
	[10733] = { 733, "Darkheart Thicket", 7673, 1466 },
	[10731] = { 731, "Neltharion's Lair", 7546, 1458 },
	[10703] = { 703, "Halls of Valor", 7672, 1477 },
	[10706] = { 706, "Maw of Souls", 7812, 1492 },
	[10710] = { 710, "Vault of the Wardens", 7787, 1493 },
	[10751] = { 751, "Black Rook Hold", 7805, 1501 },
	[10761] = { 761, "Court of Stars", 8079, 1571 },
	[10749] = { 749, "The Arcway", 7855, 1516 },
	[10809] = { 809, "Return to Karazhan", 8443, 1651 },
	[10845] = { 845, "Cathedral of Eternal Night", 8527, 1677 },
	[10903] = { 903, "Seat of the Triumvirate", 8910, 1753 },
	[10777] = { 777, "The Emerald Nightmare", 8026, 1520 },
	[10806] = { 806, "Trial of Valor", 8440, 1648 },
	[10764] = { 764, "The Nighthold", 8025, 1530 },
	[10850] = { 850, "Tomb of Sargeras", 8524, 1676 },
	[10909] = { 909, "Antorus, the Burning Throne", 8638, 1712 },

	-- Battle for Azeroth Dungeons & Raids (8.x)
	[10934] = { 934,  "Atal'Dazar", 9028, 1763 },
	[10936] = { 936,  "Freehold", 9164, 1754 },
	[10974] = { 974,  "Tol Dagor", 9327, 1771 },
	[11010] = { 1010, "The MOTHERLODE!!", 8064, 1594 },
	[11015] = { 1015, "Waycrest Manor", 9424, 1862 },
	[11004] = { 1004, "Kings' Rest", 9526, 1762 },
	[11038] = { 1038, "Temple of Sethraliss", 9391, 1877 },
	[11041] = { 1041, "The Underrot", 9389, 1841 },
	[11039] = { 1039, "Shrine of the Storm", 9525, 1864 },
	[11162] = { 1162, "Siege of Boralus", 9354, 1822 },
	[11490] = { 1490, "Operation: Mechagon", 10522, 2097 },
	[11148] = { 1148, "Uldir", 9389, 1861 },
	[11352] = { 1352, "Battle of Dazar'alor", 10076, 2070 },
	[11363] = { 1363, "Crucible of Storms", 10057, 2096 },
	[11512] = { 1512, "The Eternal Palace", 10425, 2164 },
	[11580] = { 1580, "Ny'alotha, the Waking City", 12872, 2217 },

	-- Shadowlands Dungeons & Raids (9.x)
	[11666] = { 1666, "The Necrotic Wake", 11402, 2286 },
	[11674] = { 1674, "Plaguefall", 13228, 2289 },
	[11669] = { 1669, "Mists of Tirna Scithe", 13334, 2290 },
	[11663] = { 1663, "Halls of Atonement", 12831, 2287 },
	[11693] = { 1693, "Spires of Ascension", 12837, 2285 },
	[11683] = { 1683, "Theater of Pain", 12841, 2293 },
	[11677] = { 1677, "De Other Side", 13309, 2291 },
	[11675] = { 1675, "Sanguine Depths", 12842, 2284 },
	[11989] = { 1989, "Tazavesh, the Veiled Market", 13577, 2441 },
	[11735] = { 1735, "Castle Nathria", 13224, 2296 },
	[11998] = { 1998, "Sanctum of Domination", 13561, 2450 },
	[12047] = { 2047, "Sepulcher of the First Ones", 13742, 2481 },

	-- Dragonflight Dungeons & Raids (10.x)
	[12095] = { 2095, "Ruby Life Pools", 14063, 2521 },
	[12093] = { 2093, "The Nokhud Offensive", 13982, 2516 },
	[12073] = { 2073, "The Azure Vault", 13954, 2515 },
	[12097] = { 2097, "Algeth'ar Academy", 14032, 2526 },
	[12080] = { 2080, "Neltharus", 14011, 2519 },
	[12096] = { 2096, "Brackenhide Hollow", 13991, 2520 },
	[12082] = { 2082, "Halls of Infusion", 14082, 2527 },
	[12071] = { 2071, "Uldaman: Legacy of Tyr", 13968, 2451 },
	[12190] = { 2190, "Dawn of the Infinite", 14514, 2579 },
	[12119] = { 2119, "Vault of the Incarnates", 14030, 2522 },
	[12166] = { 2166, "Aberrus, the Shadowed Crucible", 14663, 2569 },
	[12232] = { 2232, "Amirdrassil, the Dream's Hope", 14643, 2549 },

	-- The War Within Dungeons & Raids (11.x)
	[12315] = { 2315, "The Rookery", 14938, 2648 },
	[12341] = { 2341, "The Stonevault", 14883, 2652 },
	[12308] = { 2308, "Priory of the Sacred Flame", 14954, 2649 },
	[12357] = { 2357, "Ara-Kara, City of Echoes", 15093, 2660 },
	[12335] = { 2335, "Cinderbrew Meadery", 15103, 2661 },
	[12303] = { 2303, "Darkflame Cleft", 14882, 2651 },
	[12359] = { 2359, "The Dawnbreaker", 14971, 2662 },
	[12343] = { 2343, "City of Threads", 14979, 2669 },
	[12387] = { 2387, "Operation: Floodgate", 15452, 2773 },
	[12392] = { 2392, "Eco-Dome Al'dani" },
	[12291] = { 2291, "Nerub-ar Palace", 14980, 2657 },
	[12406] = { 2406, "Liberation of Undermine", 15522, 2769 },
	[12412] = { 2412, "Manaforge Omega" },

	-- Midnight Dungeons & Raids (12.x)
	[12420] = { 2420, "Windrunner Spire" },
	[12421] = { 2421, "Murder Row" },
	[12422] = { 2422, "Den of Nalorakk" },
	[12423] = { 2423, "Maisara Caverns" },
	[12424] = { 2424, "Blinding Vale" },
	[12425] = { 2425, "Nexus-Point Xenas" },
	[12426] = { 2426, "Voidscar Arena" },
	[12430] = { 2430, "The Voidspire" },
	[12431] = { 2431, "The Dreamrift" },
	[12432] = { 2432, "March on Quel'Danas" },
}

-- Fallback translations for custom Classic Forever zones and cross-expansion lookups
local FIZ_ZoneFallbackTranslations = {
	deDE = {
		-- Custom Classic Forever Zones
		["Zephras Isle"] = "Insel Zephras",
		["Shadowgale Forest"] = "Schattensturmwald",
		["Riverglades"] = "Flussauen",
		["Darkspear Islands"] = "Dunkelspeerinseln",
		["Farhold Keep"] = "Feste Fernwacht",
		["Skywall"] = "Himmelswall",
		-- Kalimdor & Eastern Kingdoms
		["Kalimdor"] = "Kalimdor",
		["Ahn'Qiraj: The Fallen Kingdom"] = "Ahn'Qiraj: Das Gefallene Königreich",
		["Ammen Vale"] = "Ammental",
		["Ashenvale"] = "Eschental",
		["Azshara"] = "Azshara",
		["Azuremyst Isle"] = "Azurmythosinsel",
		["Bloodmyst Isle"] = "Blutmythosinsel",
		["Camp Narache"] = "Camp Narache",
		["Darkshore"] = "Dunkelküste",
		["Darnassus"] = "Darnassus",
		["Desolace"] = "Desolace",
		["Durotar"] = "Durotar",
		["Dustwallow Marsh"] = "Düstermarschen",
		["Echo Isles"] = "Echoinseln",
		["Felwood"] = "Teufelswald",
		["Feralas"] = "Feralas",
		["Molten Front"] = "Geschmolzene Front",
		["Moonglade"] = "Mondlichtung",
		["Mount Hyjal"] = "Berg Hyjal",
		["Mulgore"] = "Mulgore",
		["Northern Barrens"] = "Nördliches Brachland",
		["Orgrimmar"] = "Orgrimmar",
		["Shadowglen"] = "Laubschattental",
		["Silithus"] = "Silithus",
		["Southern Barrens"] = "Südliches Brachland",
		["Stonetalon Mountains"] = "Steinkrallengebirge",
		["Tanaris"] = "Tanaris",
		["Teldrassil"] = "Teldrassil",
		["The Exodar"] = "Die Exodar",
		["Thousand Needles"] = "Tausend Nadeln",
		["Thunder Bluff"] = "Donnerfels",
		["Uldum"] = "Uldum",
		["Un'Goro Crater"] = "Krater von Un'Goro",
		["Valley of Trials"] = "Tal der Prüfungen",
		["Winterspring"] = "Winterquell",
		["Eastern Kingdoms"] = "Östliche Königreiche",
		["Abyssal Depths"] = "Abyssische Tiefen",
		["Arathi Highlands"] = "Arathihochland",
		["Badlands"] = "Ödland",
		["Blasted Lands"] = "Verwüstete Lande",
		["Burning Steppes"] = "Brennende Steppe",
		["Coldridge Valley"] = "Eisklammtal",
		["Deadwind Pass"] = "Gebirgspass der Totenwinde",
		["Deathknell"] = "Todesend",
		["Dun Morogh"] = "Dun Morogh",
		["Duskwood"] = "Dämmerwald",
		["Eastern Plaguelands"] = "Östliche Pestländer",
		["Elwynn Forest"] = "Wald von Elwynn",
		["Eversong Woods"] = "Immersangwald",
		["Ghostlands"] = "Geisterlande",
		["Gilneas"] = "Gilneas",
		["Gilneas City"] = "Gilneas (Stadt)",
		["Hillsbrad Foothills"] = "Vorgebirge des Hügellands",
		["Ironforge"] = "Eisenschmiede",
		["Isle of Quel'Danas"] = "Insel von Quel'Danas",
		["Kelp'thar Forest"] = "Tang'tharwald",
		["Loch Modan"] = "Loch Modan",
		["New Tinkertown"] = "Neu-Tüftlerstadt",
		["Northern Stranglethorn"] = "Nördliches Schlingendorntal",
		["Northshire"] = "Nordhain",
		["Redridge Mountains"] = "Rotkammgebirge",
		["Ruins of Gilneas"] = "Ruinen von Gilneas",
		["Ruins of Gilneas City"] = "Ruinen der Stadt Gilneas",
		["Searing Gorge"] = "Sengende Schlucht",
		["Shimmering Expanse"] = "Schimmernde Weiten",
		["Silvermoon City"] = "Silbermond",
		["Silverpine Forest"] = "Silberwald",
		["Stormwind City"] = "Sturmwind",
		["Stranglethorn Vale"] = "Schlingendorntal",
		["Sunstrider Isle"] = "Insel der Sonnenwanderer",
		["Swamp of Sorrows"] = "Sümpfe des Elends",
		["The Cape of Stranglethorn"] = "Das Schlingendornkap",
		["The Hinterlands"] = "Hinterland",
		["Plaguelands: The Scarlet Enclave"] = "Pestländer: Die Scharlachrote Enklave",
		["Tirisfal Glades"] = "Tirisfal",
		["Tol Barad"] = "Tol Barad",
		["Tol Barad Peninsula"] = "Halbinsel von Tol Barad",
		["Twilight Highlands"] = "Schattenhochland",
		["Undercity"] = "Unterstadt",
		["Vashj'ir"] = "Vashj'ir",
		["Western Plaguelands"] = "Westliche Pestländer",
		["Westfall"] = "Westfall",
		["Wetlands"] = "Sumpfland",
		-- Outland & Northrend
		["Outland"] = "Scherbenwelt",
		["Blade's Edge Mountains"] = "Schergrat",
		["Hellfire Peninsula"] = "Höllenfeuerhalbinsel",
		["Nagrand"] = "Nagrand",
		["Netherstorm"] = "Nethersturm",
		["Shadowmoon Valley"] = "Schattenmondtal",
		["Shattrath City"] = "Shattrath",
		["Terokkar Forest"] = "Wälder von Terokkar",
		["Zangarmarsh"] = "Zangarmarschen",
		["Northrend"] = "Nordend",
		["Borean Tundra"] = "Boreanische Tundra",
		["Crystalsong Forest"] = "Kristallsangwald",
		["Dalaran"] = "Dalaran",
		["Dragonblight"] = "Drachenöde",
		["Grizzly Hills"] = "Grizzlyhügel",
		["Howling Fjord"] = "Heulender Fjord",
		["Hrothgar's Landing"] = "Hrothgars Landestelle",
		["Icecrown"] = "Eiskrone",
		["Sholazar Basin"] = "Sholazarbecken",
		["The Storm Peaks"] = "Die Sturmgipfel",
		["Wintergrasp"] = "Tausendwinter",
		["Zul'Drak"] = "Zul'Drak",
		-- Battlegrounds
		["Alterac Valley"] = "Alteractal",
		["Arathi Basin"] = "Arathibecken",
		["Deepwind Gorge"] = "Tiefenwindschlucht",
		["Eye of the Storm"] = "Auge des Sturms",
		["Isle of Conquest"] = "Insel der Eroberung",
		["Seething Shore"] = "Brodelnde Küste",
		["Silvershard Mines"] = "Silberbruchminen",
		["Strand of the Ancients"] = "Strand der Uralten",
		["Temple of Kotmogu"] = "Tempel von Katmogu",
		["The Battle for Gilneas"] = "Die Schlacht um Gilneas",
		["Twin Peaks"] = "Zwillingsgipfel",
		["Warsong Gulch"] = "Kriegshymnenschlucht",
		-- Modern Zones & Instances
		["Quel'Thalas"] = "Quel'Thalas",
		["Zul'Aman"] = "Zul'Aman",
		["Harandar"] = "Harandar",
		["Voidstorm"] = "Leerensturm",
		["Windrunner Spire"] = "Windläuferspitze",
		["Murder Row"] = "Mördergasse",
		["Den of Nalorakk"] = "Nalorakks Bau",
		["Maisara Caverns"] = "Maisarahöhlen",
		["Blinding Vale"] = "Blendendes Tal",
		["Nexus-Point Xenas"] = "Nexuspunkt Xenas",
		["Voidscar Arena"] = "Leerennarbenarena",
		["The Voidspire"] = "Die Leerenspitze",
		["The Dreamrift"] = "Der Traumriss",
		["March on Quel'Danas"] = "Marsch auf Quel'Danas",
		["Eco-Dome Al'dani"] = "Biokuppel Al'dani",
		["Manaforge Omega"] = "Manaschmiede Omega",
	},
	frFR = {
		["Zephras Isle"] = "Île de Zephras",
		["Shadowgale Forest"] = "Forêt d'Ombrevent",
		["Riverglades"] = "Clairières-des-Rivières",
		["Darkspear Islands"] = "Îles Sombrelance",
		["Farhold Keep"] = "Donjon de Lointain-Fort",
		["Skywall"] = "Mur-Céleste",
		["Voidstorm"] = "Tempête du Vide",
	},
	esES = {
		["Zephras Isle"] = "Isla de Zephras",
		["Shadowgale Forest"] = "Bosque Vendaval Sombrío",
		["Riverglades"] = "Claros del Río",
		["Darkspear Islands"] = "Islas Lanza Negra",
		["Farhold Keep"] = "Fortaleza Lejana",
		["Skywall"] = "Muro Celeste",
		["Voidstorm"] = "Tormenta del Vacío",
	},
}
FIZ_ZoneFallbackTranslations.esMX = FIZ_ZoneFallbackTranslations.esES

local FIZ_ContentTextTranslations_DE = {
	-- Mob & Boss Generic Labels
	["Trash Mobs"] = "Trash-Gegner",
	["All Normal Mobs"] = "Alle normalen Gegner",
	["All Rare Mobs"] = "Alle seltenen Gegner",
	["Rare Mobs"] = "Seltene Gegner",
	["Bosses"] = "Bosse",
	["Most Bosses"] = "Die meisten Bosse",
	["Weekly Rare Elite"] = "Wöchentlicher seltener Elitegegner",
	-- Classic Mobs & Activities
	["Molten Core Trash"] = "Geschmolzener Kern Trash-Gegner",
	["Molten Destroyer & Lava Pack"] = "Geschmolzener Zerstörer & Lavameute",
	["Ancient Core Hound"] = "Uralter Kernhund",
	["Lava Surger"] = "Lavawoger",
	["Firelord"] = "Feuerlord",
	["Flameguard"] = "Flammenwächter",
	["Firewalker"] = "Feuergänger",
	["Lucifron"] = "Lucifron",
	["Magmadar"] = "Magmadar",
	["Gehennas"] = "Gehennas",
	["Garr"] = "Garr",
	["Shazzrah"] = "Shazzrah",
	["Baron Geddon"] = "Baron Geddon",
	["Sulfuron Harbinger"] = "Sulfuronherold",
	["Golemagg the Incinerator"] = "Golemagg der Verbrenner",
	["Majordomo Executus"] = "Majordomus Executus",
	["Ragnaros"] = "Ragnaros",
	["Lord Incendius"] = "Lord Incendius",
	["Pyroguard Emberseer"] = "Feuerwache Glutseher",
	["High Chief Winterfall"] = "Oberhäuptling der Winterfelle",
	["Winterfall Runner, Den Watcher, Shaman, Pathfinder, Totemic & Ursa"] = "Läufer, Höhlenwächter, Schamane, Pfadfinder, Totemiker & Ursa der Winterfelle",
	["Deadwood Avenger, Den Watcher, Shaman, Gardener, Pathfinder & Warrior"] = "Rächer, Höhlenwächter, Schamane, Gärtner, Pfadfinder & Krieger der Totenwaldfelle",
	["Grizzle Snowpaw (Rare)"] = "Grizzle Schneepfote (Selten)",
	["Ragepaw (Rare)"] = "Wutpranke (Selten)",
	["Desert Rumbler, Dust Stormer"] = "Wüstenrumpler, Staubstürmer",
	["Huricanian (Rare)"] = "Huricanian (Selten)",
	["Twilight Avenger, Geolord, Elementalist & Stonecaller"] = "Zwielichträcher, Geolord, Elementarist & Steinrufer",
	["Any Twilight's Hammer mobs"] = "Alle Gegner des Schattenhammers",
	["Vyral the Vile"] = "Vyral der Üble",
	["Prince Skaldrenox"] = "Prinz Skaldrenox",
	["High Marshal Whirlaxis"] = "Hochmarschall Whirlaxis",
	["Baron Kazum"] = "Baron Kazum",
	["Lord Skwol"] = "Lord Skwol",
	["The Duke of Cynders"] = "Der Fürst der Asche",
	["The Duke of Fathoms"] = "Der Fürst der Tiefen",
	["The Duke of Shards"] = "Der Fürst der Splitter",
	["The Duke of Zephyrs"] = "Der Fürst der Stürme",
	["Anubisath Defender"] = "Verteidiger der Anubisath",
	["Anubisath Sentinel"] = "Wächter der Anubisath",
	["Obsidian Eradicator"] = "Obsidianvernichter",
	["Greater Obsidian Elemental"] = "Großer Obsidianelementar",
	["Qiraji Lasher"] = "Peitscher der Qiraji",
	["Vekniss Hive Crawler"] = "Schwarmkrabbler der Vekniss",
	["Vekniss Soldier"] = "Soldat der Vekniss",
	["Vekniss Stinger"] = "Stecher der Vekniss",
	["Vekniss Warrior"] = "Krieger der Vekniss",
	["Vekniss Wasp"] = "Wespe der Vekniss",
	["Twin Emperors"] = "Zwillingsimperatoren",
	["C'Thun"] = "C'Thun",
	["Ossirian"] = "Ossirian der Narbenlose",
	["All Syndicate members"] = "Alle Mitglieder des Syndikats",
	["Ravenholdt Guard"] = "Wache von Rabenholdt",
	["Ravenholdt Assassin"] = "Assassine von Rabenholdt",
	["Lord Jorach Ravenholdt"] = "Lord Jorach Rabenholdt",
	["Fahrad"] = "Fahrad",
	["Zan Shivsproket"] = "Zan Messerritzel",
	["Smudge Thunderwood"] = "Smudge Donnerholz",
	["Winstone Wolfe"] = "Winstone Wolf",
	["Myrokos Silentform"] = "Myrokos Stillform",
	["Carlo Aurelius"] = "Carlo Aurelius",
	["Simone Cantrell"] = "Simone Cantrell",
	["Razz Ricketroz"] = "Razz Klapperroz",
	["Booty Bay Bruiser & Elite"] = "Schläger & Elite von Beutebucht",
	["Some Booty Bay Named"] = "Einige benannte NPCs in Beutebucht",
	["Most Booty Bay Named"] = "Die meisten benannten NPCs in Beutebucht",
	["Most Faldir's Cove Named"] = "Die meisten benannten NPCs in Faldirs Bucht",
	["Baron Revilgaz, Grizzlowe & Wharfmaster Lozgil"] = "Baron Revilgaz, Grizzlowe & Hafenmeister Lozgil",
	["Viznik & Rickle Goldgrubber (bankers)"] = "Viznik & Rickle Goldgräber (Bankiers)",
	["Cap'n Garvey & Alicia Cuthbert"] = "Kapitän Garvey & Alicia Cuthbert",
	["MoshOgg Spellcrafter"] = "Zauberkundiger der Mosh'Ogg",
	["Gelkis Clan Centaur"] = "Zentaur des Gelkisklans",
	["Gelkis Clan Centaurs"] = "Zentauren des Gelkisklans",
	["Gelkis Alliance Quests (Uthek the Wise)"] = "Quests des Gelkisbündnisses (Uthek die Weise)",
	["Slay rival Magram Clan Centaurs in southern Desolace (20 rep per kill up to Revered) and complete Uthek the Wise's quest chain."] = "Tötet rivalisierende Zentauren des Magramklans im südlichen Desolace (20 Ruf pro Kill bis Respektvoll) und schließt die Questreihe von Uthek der Weisen ab.",
	["Magram Clan Centaur"] = "Zentaur des Magramklans",
	["Magram Clan Centaurs"] = "Zentauren des Magramklans",
	["Magram Alliance Quests (Warug)"] = "Quests des Magrambündnisses (Warug)",
	["Slay rival Gelkis Clan Centaurs in southwestern Desolace (20 rep per kill up to Revered) and complete Warug's quest chain."] = "Tötet rivalisierende Zentauren des Gelkisklans im südwestlichen Desolace (20 Ruf pro Kill bis Respektvoll) und schließt Warugs Questreihe ab.",
	["Shen'dralar (Dire Maul)"] = "Shen'dralar (Düsterbruch)",
	["Dire Maul Class Book Turn-ins & Lorekeeper Quests"] = "Düsterbruch Klassenbuch-Abgaben & Hüter-des-Wissens-Quests",
	["Turn in Libram of Rapidity, Libram of Focus, Libram of Protection, and Royal Seal of Eldre'Thalas class books to Lorekeeper Lydros in Dire Maul."] = "Gebt Buchband der Schnelligkeit, Buchband des Fokus, Buchband des Schutzes sowie die Klassenbücher (Königliches Siegel von Eldre'Thalas) bei Hüter des Wissens Lydros im Düsterbruch ab.",
	["Fiona's Caravan Quests"] = "Fionas Karawanenquests",
	["Fiona's Caravan Quests until '[42] Argent Call: The Trial of the Crypt' will give enough reputation to reach Revered."] = "Fionas Karawanenquests bis '[42] Ruf des Argentumkreuzzugs: Die Prüfung der Krypta' gewähren genügend Ruf bis Respektvoll.",
	-- TBC / Wrath / Cata / MoP / WoD / Modern
	["Boulderfist ogres"] = "Oger der Felsfäuste",
	["Warmaul non-elite"] = "Nicht-Elite der Totschläger",
	["Murkblood"] = "Finsterblut",
	["Murkblood Scavenger"] = "Plünderer der Finsterblut",
	["Dreghood Drudge"] = "Schufter der Abschaumkappen",
	["Wrekt Slave"] = "Sklave der Wrekt",
	["Bog Lords, Bog Giants"] = "Sumpflords, Sumpfriesen",
	["Steam Pump Overseer"] = "Dampfpumpenaufseher",
	["Bloodscale Overseer"] = "Aufseher der Blutschuppen",
	["Bloodscale Wavecaller"] = "Wellenruferin der Blutschuppen",
	["Darkcrest Slaver"] = "Sklavenjäger der Finsterkämme",
	["Darkcrest Sorceress"] = "Zauberin der Finsterkämme",
	["Skettis Kaliri"] = "Kaliri von Skettis",
	["Skettis, Talonpriests, Time-Lost Skettis, Monstrous Kaliri"] = "Skettis, Krallenpriester, Zeitverlorene Skettis, Monströser Kaliri",
	["Terokk"] = "Terokk",
	["Akkarai, Karrog, Gezzarak, Vakkiz"] = "Akkarai, Karrog, Gezzarak, Vakkiz",
	["Void Spawn"] = "Leerbrut",
	["Void Beast"] = "Leerenbestie",
	["Frost Wyrm"] = "Frostwyrm",
	["Grimfrost Drudge"] = "Grimmfrostschufter",
	["Icecrag Mountainbreaker"] = "Eisklippenbergbrecher",
	["The Deaths of Chromie"] = "Die Tode von Chromie",
	["Awarded via Sands of Time in The Deaths of Chromie scenario."] = "Wird durch Sande der Zeit im Szenario 'Die Tode von Chromie' gewährt.",
	["Inquisitor (Sinstone)"] = "Inquisitor (Sündenstein)",
	["High Inquisitor (Sinstone)"] = "Hochinquisitor (Sündenstein)",
	["Grand Inquisitor (Sinstone)"] = "Großinquisitor (Sündenstein)",
	["Maw Rare / Wrath of the Jailer"] = "Schlund-Rar / Zorn des Kerkermeisters",
	["Zereth Mortis Rare Mob"] = "Seltener Gegner in Zereth Mortis",
	["Antros (World Boss)"] = "Antros (Weltboss)",
	["Narrok (Worm-Sommelier)"] = "Narrok (Wurm-Sommelier)",
	["Sundered Flame (Arcane Sustenance)"] = "Zerschmetterte Flamme (Arkane Nahrung)",
}

function FIZ:TranslateContentText(text)
	if type(text) ~= "string" then return text end
	if GetLocale and GetLocale() == "deDE" then
		return FIZ_ContentTextTranslations_DE[text] or text
	end
	return text
end

local function FIZ_TranslateFallbackZone(englishName)
	if not englishName then return nil end
	local locTable = FIZ_ZoneFallbackTranslations[GetLocale()]
	if locTable and locTable[englishName] then
		return locTable[englishName]
	end
	return englishName
end

function FIZ_ResolveZoneName(areaID)
	if not areaID then return nil end
	local entry = FIZ_LegacyZoneMap[areaID]
	if entry then
		local uiMapID, fallback, areaTableID, instanceID = entry[1], entry[2], entry[3], entry[4]

		-- 1. Try HereBeDragons-2.0 (current actively maintained mapping library)
		if HBD and uiMapID then
			local hbdName = HBD:GetLocalizedMap(uiMapID)
			if hbdName and hbdName ~= "" then
				return hbdName
			end
		end
		if HBD and HBDMigrate and areaID < 10000 then
			local migratedUIMapID = HBDMigrate:GetUIMapIDFromMapAreaId(areaID)
			if migratedUIMapID then
				local hbdName = HBD:GetLocalizedMap(migratedUIMapID)
				if hbdName and hbdName ~= "" then
					return hbdName
				end
			end
		end

		-- 2. Try Blizzard C_Map.GetMapInfo (UiMap.db2)
		if uiMapID and C_Map and C_Map.GetMapInfo then
			local mapInfo = C_Map.GetMapInfo(uiMapID)
			if mapInfo and mapInfo.name and mapInfo.name ~= "" then
				return mapInfo.name
			end
		end

		-- 3. Try Blizzard C_Map.GetAreaInfo (AreaTable.db2 - covers Classic dungeons/subzones without uiMapIDs)
		if areaTableID and C_Map and C_Map.GetAreaInfo then
			local areaName = C_Map.GetAreaInfo(areaTableID)
			if areaName and areaName ~= "" then
				return areaName
			end
		end

		-- 4. Try Blizzard GetRealZoneText (Map.db2 instance IDs)
		if instanceID and _G.GetRealZoneText then
			local instName = _G.GetRealZoneText(instanceID)
			if instName and instName ~= "" then
				return instName
			end
		end

		-- 5. Legacy GetMapNameByID fallback
		if _G.GetMapNameByID then
			local legacyName = _G.GetMapNameByID(areaID)
			if legacyName and legacyName ~= "" then
				return legacyName
			end
		end

		return FIZ_TranslateFallbackZone(fallback)
	end

	-- Direct uiMapID or areaTableID lookup if not in FIZ_LegacyZoneMap
	if HBD then
		local hbdName = HBD:GetLocalizedMap(areaID)
		if hbdName and hbdName ~= "" then
			return hbdName
		end
	end
	if C_Map and C_Map.GetMapInfo then
		local mapInfo = C_Map.GetMapInfo(areaID)
		if mapInfo and mapInfo.name and mapInfo.name ~= "" then
			return mapInfo.name
		end
	end
	if C_Map and C_Map.GetAreaInfo then
		local areaName = C_Map.GetAreaInfo(areaID)
		if areaName and areaName ~= "" then
			return areaName
		end
	end
	if _G.GetMapNameByID then
		local legacyName = _G.GetMapNameByID(areaID)
		if legacyName and legacyName ~= "" then
			return legacyName
		end
	end
	return tostring(areaID)
end

function FIZ_InitEnFactions()
	local numFactions = FIZ:GetNumFactions()
	for i = 1, numFactions do
		local name, _, _, _, _, _, _, _, isHeader, _, hasRep, _, _, factionID = FIZ:GetRawFactionInfo(i)
		if (not isHeader or hasRep) and name and factionID then
			FIZ:AddMapping(name, factionID)
		end
	end
end

function FIZ:InitMapName(fimap)
	local map
	if fimap == 1 then
		map = FIZ_TXT.srfd
	elseif fimap == 2 then
		map = FIZ_TXT.tbd
	elseif fimap == 3 or fimap == 5 then
		map = FIZ_TXT.nci
	elseif fimap == 4 or fimap == 6 then
		map = FIZ_TXT.hci
	elseif not fimap then
		map = " "
	elseif type(fimap) == "number" then
		map = FIZ_ResolveZoneName(fimap)
	elseif type(fimap) == "string" then
		map = FIZ_TranslateFallbackZone(fimap)
	else
		map = tostring(fimap)
	end
	if not map then
		map = tostring(fimap)
	end
	return map
end

function FIZ:InitMobName(fimob)
	local mob
	if fimob == 1 then
		mob = FIZ_TXT.tmob
	elseif fimob == 2 then
		mob = FIZ_TXT.oboss
	elseif fimob == 3 then
		mob = FIZ_TXT.aboss
	elseif fimob == 4 then
		mob = FIZ_TXT.pboss
	elseif fimob == 5 then
		mob = FIZ_TXT.fclear
	elseif fimob == 11 then
		mob = (FIZ_TXT.AU .. " " .. FIZ_TXT.BB)
	elseif fimob == 12 then
		mob = (FIZ_TXT.AU .. " " .. FIZ_TXT.SSP)
	elseif fimob == 13 then
		mob = (FIZ_TXT.AU .. " " .. FIZ_TXT.Wa)
	elseif fimob == 14 then
		mob = FIZ_TXT.VCm
	elseif fimob == 15 then
		mob = (FIZ_TXT.AN .. " " .. FIZ_TXT.BB)
	elseif fimob == 16 then
		mob = (FIZ_TXT.AN .. " " .. FIZ_TXT.SSP)
	elseif fimob == 17 then
		mob = (FIZ_TXT.AN .. " " .. FIZ_TXT.Wa)
	end
	if not mob then
		mob = self:TranslateContentText(tostring(fimob))
	end
	return mob
end

function FIZ:InitItemName(fiitem)
	local item_name
	if fiitem == 1 then
		item_name = FIZ_TXT.cdq
	elseif fiitem == 2 then
		item_name = FIZ_TXT.fdq
	elseif fiitem == 3 then
		item_name = FIZ_TXT.ndq
	elseif fiitem == 4 then
		item_name = FIZ_TXT.cbadge
	elseif fiitem == 5 then
		item_name = FIZ_TXT.deleted
	else
		item_name = self:GetItemInfoName(fiitem)
	end

	if not item_name then
		item_name = tostring(fiitem)
	end
	return item_name
end

function FIZ:Quest_Names(questIndex)
	if questIndex == 1 then
		return FIZ_TXT.cdq
	elseif questIndex == 2 then
		return FIZ_TXT.coq
	elseif questIndex == 3 then
		return FIZ_TXT.fdq
	elseif questIndex == 4 then
		return FIZ_TXT.foq
	elseif questIndex == 5 then
		return FIZ_TXT.ndq
	elseif questIndex == 6 then
		return FIZ_TXT.deleted
	elseif questIndex == 7 then
		return FIZ_TXT.Championing
	elseif questIndex == 8 then
		return FIZ_TXT.bpqfg
	elseif questIndex == 9 then
		return FIZ_TXT.djdq
	elseif questIndex == 10 then
		return _G.TRACKER_HEADER_WORLD_QUESTS or FIZ_TXT.worldQuests
	elseif questIndex == 11 then
		return (_G.TRACKER_HEADER_WORLD_QUESTS or FIZ_TXT.worldQuests) .. " (" .. (_G.ELITE or "Elite") .. ")"
	elseif questIndex == 12 then
		return _G.BOUNTY_BOARD_LOCKED_TITLE or FIZ_TXT.emissaryQuest
	elseif questIndex == 13 then
		return FIZ_TXT.weeklyQuest or ((_G.WEEKLY or "Weekly") .. " " .. (_G.QUESTS_LABEL or "Quest"))
	elseif questIndex == 14 then
		return FIZ_TXT.contractWQ or ("Contract (" .. (_G.TRACKER_HEADER_WORLD_QUESTS or FIZ_TXT.worldQuests) .. ")")
	elseif questIndex == 15 then
		return _G.COVENANT_CALLINGS_HEADER or FIZ_TXT.covenantCalling
	elseif questIndex == 16 then
		return FIZ_TXT.bountifulDelve
	elseif questIndex == 17 then
		return FIZ_TXT.specialAssignment
	elseif questIndex == 99 then
		return FIZ_TXT.tbd
	end

	if type(questIndex) == "string" then
		return self:TranslateContentText(questIndex)
	end

	local quest = self:GetQuestTitleByID(questIndex)
	if not quest or quest == "" then
		quest = tostring(questIndex)
	end
	return quest
end

function FIZ:InitFaction(guildName, faction)
	if faction == "guildName" or faction == FIZ_GuildName then
		FIZ_faction = faction
	elseif type(faction) == "number" then
		FIZ_faction = self:GetFactionNameByID(faction)
		if not FIZ_faction or FIZ_faction == "" then
			FIZ_faction = "id:" .. tostring(faction)
		end
	elseif type(faction) == "string" and faction ~= "" then
		FIZ_faction = faction
	else
		FIZ_faction = nil
	end
	return FIZ_faction
end

function FIZ:InitFactionMap(locale, guildName)
	FIZ_FactionMapping = {}
	if FIZ_InitEnFactions then
		FIZ_InitEnFactions()
	end
	if guildName then
		self:AddMapping(guildName, guildName)
	end
end

function FIZ:AddMapping(english, localised)
	if not FIZ_FactionMapping then
		FIZ_FactionMapping = {}
	end
	if self:InitFaction(FIZ_GuildName, localised) and FIZ_faction then
		FIZ_FactionMapping[string.lower(FIZ_faction)] = string.lower(english)
	end
end
