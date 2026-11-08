----------------------------------------------------------
-- Factionizer - The Burning Crusade (2.x) Content      --
----------------------------------------------------------

local FIZ = _G.FIZ

FIZ:RegisterContentModule("TBC", function(self, zone, mob, Quest, items, instance)
	if FIZ_IsAlliance then
		-- Exodar 930
		self:AddQuest(930, 4, 8, Quest.oc_cook_dq, 65, "nil", FIZ_LIMIT_TYPE_Cook)
		self:AddQuest(930, 4, 8, Quest.oc_fish_dq, 65, "nil", FIZ_LIMIT_TYPE_Fish)
		self:AddQuest(930, 4, 8, 10354, 250, { [14047] = 20 }) -- Additional Runecloth (TBC/Classic)
		self:AddQuest(930, 4, 8, 7386, 18.75, { [17423] = 5 })
		self:AddQuest(930, 4, 8, 6881, 2.5, { [17423] = 1 })
		self:AddQuest(930, 4, 8, 6943, 10, { [17504] = 1 })
		self:AddQuest(930, 4, 8, 6942, 10, { [17502] = 1 })
		self:AddQuest(930, 4, 8, 6941, 10, { [17503] = 1 })
		self:AddQuest(930, 4, 8, 7027, 2.5)
		self:AddQuest(930, 4, 8, 7026, 2.5, { [17643] = 1 })
		self:AddQuest(930, 4, 8, 6781, 2.5, { [17422] = 20 })
		self:AddItems(930, 4, 8, 250, { [45715] = 1 })
		self:AddItems(930, 4, 8, 62.5, { [items.oc_comm_bad] = 1 })
		self:AddSpell(930, 1, 8, "Quest.no_dq", 1000)

		-- Honor Hold 946
		self:AddInstance(946, 4, 5, zone.Hellfire_Ramparts, 600, false)
		self:AddInstance(946, 6, 8, zone.Hellfire_Ramparts, 2000, true)
		self:AddInstance(946, 4, 5, zone.The_Blood_Furnace, 750, false)
		self:AddInstance(946, 6, 8, zone.The_Blood_Furnace, 2700, true)
		self:AddInstance(946, 4, 8, zone.The_Shattered_Halls, 1600, false)
		self:AddInstance(946, 4, 8, zone.The_Shattered_Halls, 2900, true)
		self:AddMob(946, 4, 7, "MoshOgg Spellcrafter", 5, zone.The_Shattered_Halls)
		self:AddMob(946, 4, 8, "MoshOgg Spellcrafter", 15, zone.The_Shattered_Halls)
		self:AddQuest(946, 4, 7, 13410, 150)
		self:AddItems(946, 4, 8, 250, { [24579] = 1 })  -- Mark of Honor Hold
		self:AddItems(946, 4, 8, 500, { [129947] = 1 }) -- Commendation of Honor Hold (Timewalking)

		-- Kurenai 978
		self:AddQuest(978, 4, 8, 10476, 500, { [25433] = 10 })
		self:AddQuest(978, 4, 8, 11502, 500)
		self:AddMob(978, 3, 8, "Boulderfist ogres", 10, zone.Nagrand)
		self:AddMob(978, 3, 8, "Kil'sorrow Deathsworn, Cultist & Spellbinder", 10, zone.Nagrand)
		self:AddMob(978, 3, 8, "Murkblood Scavenger", 2, zone.Nagrand)
		self:AddMob(978, 3, 8, "Murkblood", 10, zone.Nagrand)
		self:AddMob(978, 3, 8, "Warmaul non-elite", 10, zone.Nagrand)
	end

	if FIZ_IsHorde then
		-- Silvermoon City 911
		self:AddQuest(911, 4, 8, Quest.oc_cook_dq, 65, "nil", FIZ_LIMIT_TYPE_Cook)
		self:AddQuest(911, 4, 8, Quest.oc_fish_dq, 65, "nil", FIZ_LIMIT_TYPE_Fish)
		self:AddQuest(911, 4, 8, 10363, 250, { [14047] = 20 }) -- Additional Runecloth (TBC/Classic)
		self:AddQuest(911, 4, 8, 7385, 18.75, { [17306] = 5 })
		self:AddQuest(911, 4, 8, 6801, 2.5, { [17306] = 1 })
		self:AddQuest(911, 4, 8, 6825, 10, { [17326] = 1 })
		self:AddQuest(911, 4, 8, 6826, 10, { [17327] = 1 })
		self:AddQuest(911, 4, 8, 6827, 10, { [17328] = 1 })
		self:AddQuest(911, 4, 8, 7027, 2.5)
		self:AddQuest(911, 4, 8, 7002, 2.5, { [17642] = 1 })
		self:AddQuest(911, 4, 8, 6741, 2.5, { [17422] = 20 })
		self:AddItems(911, 4, 8, 250, { [45721] = 1 })
		self:AddItems(911, 4, 8, 62.5, { [items.oc_comm_bad] = 1 })
		self:AddSpell(911, 1, 8, "Quest.no_dq", 1000)

		-- Thrallmar 947
		self:AddInstance(947, 4, 5, zone.Hellfire_Ramparts, 600, false)
		self:AddInstance(947, 6, 8, zone.Hellfire_Ramparts, 2000, true)
		self:AddInstance(947, 4, 5, zone.The_Blood_Furnace, 750, false)
		self:AddInstance(947, 6, 8, zone.The_Blood_Furnace, 2700, true)
		self:AddMob(947, 4, 7, mob.t_mobs, 5, zone.The_Blood_Furnace)
		self:AddMob(947, 4, 8, mob.t_mobs, 15, zone.The_Blood_Furnace)
		self:AddInstance(947, 4, 8, zone.The_Shattered_Halls, 1600, false)
		self:AddInstance(947, 4, 8, zone.The_Shattered_Halls, 2900, true)
		self:AddMob(947, 4, 7, "MoshOgg Spellcrafter", 5, zone.The_Shattered_Halls)
		self:AddMob(947, 4, 8, "MoshOgg Spellcrafter", 15, zone.The_Shattered_Halls)
		self:AddQuest(947, 4, 7, 13410, 150)
		self:AddItems(947, 4, 8, 250, { [24581] = 1 })  -- Mark of Thrallmar
		self:AddItems(947, 4, 8, 500, { [129945] = 1 }) -- Commendation of Thrallmar (Timewalking)

		-- The Mag'har 941
		self:AddQuest(941, 4, 8, 10479, 500, { [25433] = 10 })
		self:AddQuest(941, 4, 8, 11503, 500)
		self:AddMob(941, 3, 8, "Boulderfist ogres", 10, zone.Nagrand)
		self:AddMob(941, 3, 8, "Kil'sorrow Deathsworn, Cultist & Spellbinder", 10, zone.Nagrand)
		self:AddMob(941, 3, 8, "Murkblood Scavenger", 2, zone.Nagrand)
		self:AddMob(941, 3, 8, "Murkblood", 10, zone.Nagrand)
		self:AddMob(941, 3, 8, "Warmaul non-elite", 10, zone.Nagrand)

		-- Tranquillien 922
		self:AddQuest(922, 4, 8, 9217, 500, { [22641] = 10 })
		self:AddQuest(922, 4, 8, 9219, 500, { [22642] = 10 })
	end

	-- Neutral Outland Factions
	-- Cenarion Expedition 942
	self:AddInstance(942, 4, 5, zone.The_Slave_Pens, 650, false)
	self:AddInstance(942, 6, 8, zone.The_Slave_Pens, 650, true)
	self:AddInstance(942, 4, 5, zone.The_Underbog, 1000, false)
	self:AddInstance(942, 6, 8, zone.The_Underbog, 1000, true)
	self:AddInstance(942, 4, 8, zone.The_Steamvault, 1662, false)
	self:AddInstance(942, 4, 8, zone.The_Steamvault, 2319, true)
	self:AddQuest(942, 4, 5, 9802, 250, { [24401] = 10 }) -- Unidentified Plant Parts
	self:AddQuest(942, 4, 8, 9785, 500, { [24368] = 1 })  -- Coilfang Armaments
	self:AddQuest(942, 4, 6, 9875, 500)
	self:AddQuest(942, 4, 8, 11867, 150)
	self:AddItems(942, 4, 8, 500, { [129949] = 1 }) -- Commendation of Cenarion Expedition (Timewalking)
	self:AddMob(942, 4, 4, "Steam Pump Overseer", 1, zone.Zangarmarsh)
	self:AddMob(942, 4, 4, "Wrekt Slave", 2.5, zone.Zangarmarsh)
	self:AddMob(942, 4, 4, "Dreghood Drudge", 2.5, zone.Zangarmarsh)
	self:AddMob(942, 4, 4, "Bloodscale Overseer", 5, zone.Zangarmarsh)
	self:AddMob(942, 4, 4, "Bloodscale Wavecaller", 5, zone.Zangarmarsh)
	self:AddMob(942, 4, 4, "Darkcrest Sorceress", 5, zone.Zangarmarsh)
	self:AddMob(942, 4, 4, "Darkcrest Slaver", 5, zone.Zangarmarsh)
	self:AddMob(942, 4, 4, "Terrorclaw", 7, zone.Zangarmarsh)

	-- Keepers of Time 989
	self:AddInstance(989, 4, 8, zone.O_Hills_Foothills, 1133, false)
	self:AddInstance(989, 4, 8, zone.O_Hills_Foothills, 2445, true)
	self:AddInstance(989, 4, 8, zone.The_Black_Morass, 1110, false)
	self:AddInstance(989, 4, 8, zone.The_Black_Morass, 1725, true)
	self:AddItems(989, 4, 8, 500, { [129950] = 1 }) -- Commendation of the Keepers of Time (Timewalking)

	-- Netherwing 1015
	self:AddQuest(1015, 4, 8, 11050, 250, { [32506] = 1 }) -- Netherwing Egg
	self:AddQuest(1015, 4, 8, 11017, 250, "nil", FIZ_LIMIT_TYPE_Herb)
	self:AddQuest(1015, 4, 8, 11018, 250, "nil", FIZ_LIMIT_TYPE_Mine)
	self:AddQuest(1015, 4, 8, 11016, 250, "nil", FIZ_LIMIT_TYPE_Skin)
	self:AddQuest(1015, 4, 8, 11020, 250)
	self:AddQuest(1015, 4, 8, 11035, 250)
	self:AddQuest(1015, 4, 8, 11015, 250)
	self:AddQuest(1015, 5, 8, 11077, 350)
	self:AddQuest(1015, 5, 8, 11076, 350)
	self:AddQuest(1015, 5, 8, 11055, 350)
	self:AddQuest(1015, 6, 8, 11086, 500)
	self:AddQuest(1015, 7, 8, 11101, 500)

	-- Ogri'la 1038
	self:AddQuest(1038, 4, 8, 11080, 350)
	self:AddQuest(1038, 4, 8, 11066, 350)
	self:AddQuest(1038, 4, 8, 11023, 500)
	self:AddQuest(1038, 6, 8, 11051, 350)

	-- Sha'tari Skyguard 1031
	self:AddQuest(1031, 4, 8, 11004, 150, { [32388] = 6 }) -- Shadow Dust
	self:AddQuest(1031, 4, 8, 11008, 350)
	self:AddQuest(1031, 4, 8, 11085, 150)
	self:AddQuest(1031, 4, 8, 11066, 350)
	self:AddQuest(1031, 4, 8, 11023, 500)
	self:AddMob(1031, 4, 6, "Skettis Kaliri", 2.5, zone.Terokkar_Forest)
	self:AddMob(1031, 4, 8, "Skettis, Talonpriests, Time-Lost Skettis, Monstrous Kaliri", 10, zone.Terokkar_Forest)
	self:AddMob(1031, 4, 8, "Talonsworn Forest-Rager", 30, zone.Terokkar_Forest)
	self:AddMob(1031, 4, 8, "Akkarai, Karrog, Gezzarak, Vakkiz", 100, zone.Terokkar_Forest)
	self:AddMob(1031, 4, 8, "Terokk", 500, zone.Terokkar_Forest)

	-- Sporeggar 970
	self:AddMob(970, 3, 6, "Bog Lords, Bog Giants", 15, zone.Zangarmarsh)
	self:AddInstance(970, 3, 7, zone.The_Underbog, 15, false)
	self:AddInstance(970, 3, 7, zone.The_Underbog, 45, true)
	self:AddQuest(970, 3, 4, 9739, 750)
	self:AddQuest(970, 3, 5, 9743, 750)
	self:AddQuest(970, 3, 5, 9744, 750, { [24291] = 6 })
	self:AddQuest(970, 3, 4, 9808, 750, { [24245] = 10 })
	self:AddQuest(970, 5, 8, 9727, 750)
	self:AddQuest(970, 4, 8, 9807, 750, { [24449] = 6 })
	self:AddQuest(970, 5, 8, 29692, 750, { [24246] = 5 })

	-- The Consortium 933
	self:AddInstance(933, 4, 5, zone.Mana_Tombs, 1200, false)
	self:AddInstance(933, 6, 8, zone.Mana_Tombs, 2400, true)
	self:AddQuest(933, 4, 4, 9882, 250, { [25463] = 3 }) -- Pair of Ivory Tusks
	self:AddQuest(933, 4, 4, 9915, 250, { [25416] = 10 }) -- Oshu'gun Crystal Fragment
	self:AddQuest(933, 5, 8, 9892, 250, { [25433] = 10 }) -- Obsidian Warbeads
	self:AddQuest(933, 5, 8, 10308, 250, { [29209] = 10 }) -- Zaxxis Insignia
	self:AddQuest(933, 6, 8, 10971, 250, { [29460] = 1 }) -- Ethereum Prisoner I.D. Tag
	self:AddQuest(933, 7, 8, 10973, 500)
	self:AddItems(933, 4, 8, 500, { [129946] = 1 }) -- Commendation of the Consortium (Timewalking)

	-- Shattrath City Factions
	-- Lower City 1011
	self:AddInstance(1011, 4, 5, zone.Auchenai_Crypts, 750, false)
	self:AddInstance(1011, 6, 8, zone.Auchenai_Crypts, 750, true)
	self:AddInstance(1011, 4, 8, zone.Sethekk_Halls, 1080, false)
	self:AddInstance(1011, 4, 8, zone.Sethekk_Halls, 1250, true)
	self:AddInstance(1011, 4, 8, zone.Shadow_Labyrinth, 2000, false)
	self:AddInstance(1011, 4, 8, zone.Shadow_Labyrinth, 2700, true)
	self:AddItems(1011, 4, 5, 250, { [25719] = 30 }) -- Arakkoa Feather
	self:AddItems(1011, 4, 8, 500, { [129951] = 1 }) -- Commendation of Lower City (Timewalking)

	-- Shattered Sun Offensive 1077
	self:AddQuest(1077, 4, 8, 11875, 250, "nil", FIZ_LIMIT_TYPE_Gather)
	self:AddQuest(1077, 4, 8, 11877, 250)
	self:AddQuest(1077, 4, 8, 11880, 150)
	self:AddQuest(1077, 4, 8, 11515, 250)
	self:AddQuest(1077, 4, 8, 11516, 250)
	self:AddQuest(1077, 4, 8, 11523, 150)
	self:AddQuest(1077, 4, 8, 11525, 150)
	self:AddQuest(1077, 4, 8, 11514, 250)
	self:AddQuest(1077, 4, 8, 11547, 250)
	self:AddQuest(1077, 4, 8, 11537, 250)
	self:AddQuest(1077, 4, 8, 11533, 150)
	self:AddQuest(1077, 4, 8, 11544, 350)
	self:AddQuest(1077, 4, 8, 11536, 250)
	self:AddQuest(1077, 4, 8, 11541, 250)
	self:AddQuest(1077, 4, 8, 11543, 250)
	self:AddQuest(1077, 4, 8, 11540, 250)
	self:AddQuest(1077, 8, 8, 11549, 500)
	self:AddQuest(1077, 4, 8, 11548, 150)
	self:AddQuest(1077, 4, 8, 11521, 350)
	self:AddQuest(1077, 4, 8, 11546, 250)
	self:AddInstance(1077, 4, 7, zone.Magisters_Terrace, 1640, false)
	self:AddInstance(1077, 4, 8, zone.Magisters_Terrace, 2503, true)

	-- The Aldor 932
	self:AddQuest(932, 1, 3, 10017, 250, { [25802] = 8 })
	self:AddQuest(932, 4, 5, 10326, 250, { [29425] = 10 })
	self:AddQuest(932, 4, 5, 10327, 25, { [29425] = 1 })
	self:AddQuest(932, 5, 8, 10654, 250, { [30809] = 10 })
	self:AddQuest(932, 5, 8, 10655, 25, { [30809] = 1 })
	self:AddQuest(932, 5, 8, 10420, 350, { [29740] = 1 })

	-- The Scryers 934
	self:AddQuest(934, 1, 3, 10024, 250, { [25744] = 8 })
	self:AddQuest(934, 4, 5, 10415, 250, { [29426] = 10 })
	self:AddQuest(934, 4, 5, 10414, 25, { [29426] = 1 })
	self:AddQuest(934, 5, 8, 10658, 250, { [30810] = 10 })
	self:AddQuest(934, 5, 8, 10659, 25, { [30810] = 1 })
	self:AddQuest(934, 5, 8, 10416, 350, { [29739] = 1 })

	-- The Sha'tar 935
	self:AddQuest(935, 4, 5, 10326, 125, { [29425] = 10 })
	self:AddQuest(935, 4, 5, 10327, 12.5, { [29425] = 1 })
	self:AddQuest(935, 4, 5, 10654, 125, { [30809] = 10 })
	self:AddQuest(935, 4, 5, 10655, 12.5, { [30809] = 1 })
	self:AddQuest(935, 4, 5, 10415, 125, { [29426] = 10 })
	self:AddQuest(935, 4, 5, 10414, 12.5, { [29426] = 1 })
	self:AddQuest(935, 4, 5, 10658, 125, { [30810] = 10 })
	self:AddQuest(935, 4, 5, 10659, 12.5, { [30810] = 1 })
	self:AddQuest(935, 4, 5, 10017, 125, { [25802] = 8 })
	self:AddQuest(935, 4, 5, 10024, 125, { [25744] = 8 })
	self:AddQuest(935, 4, 5, 10420, 175, { [29740] = 1 })
	self:AddQuest(935, 4, 5, 10416, 175, { [29739] = 1 })
	self:AddInstance(935, 4, 8, zone.The_Mechanar, 1620, false)
	self:AddInstance(935, 4, 8, zone.The_Mechanar, 3000, true)
	self:AddInstance(935, 4, 8, zone.The_Botanica, 2000, false)
	self:AddInstance(935, 4, 8, zone.The_Botanica, 3000, true)
	self:AddInstance(935, 4, 8, zone.The_Arcatraz, 1800, false)
	self:AddInstance(935, 4, 8, zone.The_Arcatraz, 3000, true)
	self:AddItems(935, 4, 8, 500, { [129948] = 1 }) -- Commendation of the Sha'tar (Timewalking)

	-- TBC Raid Factions
	-- Ashtongue Deathsworn 1012
	self:AddInstance(1012, 4, 8, zone.Black_Temple, 8000)

	-- The Scale of the Sands 990
	self:AddInstance(990, 5, 8, zone.Hyjal_Summit, 7900)
	self:AddMob(990, 4, 8, "Trash Mobs", 12, zone.Hyjal_Summit)
	self:AddMob(990, 4, 8, "Frost Wyrm", 60, zone.Hyjal_Summit)
	self:AddMob(990, 4, 8, "Bosses", 375, zone.Hyjal_Summit)
	self:AddMob(990, 4, 8, "Archimonde", 1500, zone.Hyjal_Summit)

	-- The Violet Eye 967
	self:AddInstance(967, 4, 8, zone.Karazhan, 6000, false)
	self:AddMob(967, 4, 8, "Bosses", 250, zone.Karazhan)
	self:AddMob(967, 4, 8, "Trash Mobs", 15, zone.Karazhan)
end)

