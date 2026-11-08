----------------------------------------------------------
-- Factionizer - Classic (1.x) Reputation Content       --
----------------------------------------------------------

local FIZ = _G.FIZ

FIZ:RegisterContentModule("Classic", function(self, zone, mob, Quest, items, instance)
	if FIZ_IsAlliance then
		-- Alliance Capital Cities
		-- Darnassus 69
		self:AddQuest(69, 4, 8, Quest.mc_cook_dq, 250, "nil", FIZ_LIMIT_TYPE_Cook)
		self:AddQuest(69, 4, 8, Quest.oc_cook_dq, 65, "nil", FIZ_LIMIT_TYPE_Cook)
		self:AddQuest(69, 4, 8, Quest.mc_fish_dq, 250, "nil", FIZ_LIMIT_TYPE_Fish)
		self:AddQuest(69, 4, 8, Quest.oc_fish_dq, 65, "nil", FIZ_LIMIT_TYPE_Fish)
		self:AddQuest(69, 4, 8, 7801, 250, { [14047] = 20 }) -- Additional Runecloth (Classic)
		self:AddGeneral(69, 4, 8, FIZ_TXT.mnd, 1500, FIZ_TXT.mnd, FIZ_TXT.mnd, nil, 0)
		self:AddQuest(69, 4, 8, 7386, 18.75, { [17423] = 5 })
		self:AddQuest(69, 4, 8, 6881, 2.5, { [17423] = 1 })
		self:AddQuest(69, 4, 8, 6943, 10, { [17504] = 1 })
		self:AddQuest(69, 4, 8, 6942, 10, { [17502] = 1 })
		self:AddQuest(69, 4, 8, 6941, 10, { [17503] = 1 })
		self:AddQuest(69, 4, 8, 7027, 2.5)
		self:AddQuest(69, 4, 8, 7026, 2.5, { [17643] = 1 })
		self:AddQuest(69, 4, 8, 6781, 2.5, { [17422] = 20 })
		self:AddItems(69, 4, 8, 250, { [45714] = 1 })
		self:AddItems(69, 4, 8, 62.5, { [items.oc_comm_bad] = 1 })
		self:AddSpell(69, 1, 8, "Quest.no_dq", 1000)

		-- Gnomeregan 54
		self:AddQuest(54, 4, 8, Quest.oc_cook_dq, 65, "nil", FIZ_LIMIT_TYPE_Cook)
		self:AddQuest(54, 4, 8, Quest.oc_fish_dq, 65, "nil", FIZ_LIMIT_TYPE_Fish)
		self:AddQuest(54, 4, 8, 7806, 250, { [14047] = 20 }) -- Additional Runecloth (Classic)
		self:AddQuest(54, 4, 8, 7386, 18.75, { [17423] = 5 })
		self:AddQuest(54, 4, 8, 6881, 2.5, { [17423] = 1 })
		self:AddQuest(54, 4, 8, 6943, 10, { [17504] = 1 })
		self:AddQuest(54, 4, 8, 6942, 10, { [17502] = 1 })
		self:AddQuest(54, 4, 8, 6941, 10, { [17503] = 1 })
		self:AddQuest(54, 4, 8, 7027, 2.5)
		self:AddQuest(54, 4, 8, 7026, 2.5, { [17643] = 1 })
		self:AddQuest(54, 4, 8, 6781, 2.5, { [17422] = 20 })
		self:AddItems(54, 4, 8, 250, { [45716] = 1 })
		self:AddItems(54, 4, 8, 62.5, { [items.oc_comm_bad] = 1 })
		self:AddSpell(54, 1, 8, "Quest.no_dq", 1000)

		-- Ironforge 47
		self:AddQuest(47, 4, 8, Quest.mc_cook_dq, 250, "nil", FIZ_LIMIT_TYPE_Cook)
		self:AddQuest(47, 4, 8, Quest.oc_cook_dq, 65, "nil", FIZ_LIMIT_TYPE_Cook)
		self:AddQuest(47, 4, 8, Quest.mc_fish_dq, 250, "nil", FIZ_LIMIT_TYPE_Fish)
		self:AddQuest(47, 4, 8, Quest.oc_fish_dq, 65, "nil", FIZ_LIMIT_TYPE_Fish)
		self:AddQuest(47, 4, 8, 7805, 250, { [14047] = 20 }) -- Additional Runecloth (Classic)
		self:AddQuest(47, 4, 8, 7386, 18.75, { [17423] = 5 })
		self:AddQuest(47, 4, 8, 6881, 2.5, { [17423] = 1 })
		self:AddQuest(47, 4, 8, 6943, 10, { [17504] = 1 })
		self:AddQuest(47, 4, 8, 6942, 10, { [17502] = 1 })
		self:AddQuest(47, 4, 8, 6941, 10, { [17503] = 1 })
		self:AddQuest(47, 4, 8, 7027, 2.5)
		self:AddQuest(47, 4, 8, 7026, 2.5, { [17643] = 1 })
		self:AddQuest(47, 4, 8, 6781, 2.5, { [17422] = 20 })
		self:AddItems(47, 4, 8, 250, { [45717] = 1 })
		self:AddItems(47, 4, 8, 62.5, { [items.oc_comm_bad] = 1 })
		self:AddSpell(47, 1, 8, "Quest.no_dq", 1000)

		-- Stormwind 72
		self:AddQuest(72, 4, 8, Quest.mc_cook_dq, 250, "nil", FIZ_LIMIT_TYPE_Cook)
		self:AddQuest(72, 4, 8, Quest.oc_cook_dq, 65, "nil", FIZ_LIMIT_TYPE_Cook)
		self:AddQuest(72, 4, 8, Quest.mc_fish_dq, 250, "nil", FIZ_LIMIT_TYPE_Fish)
		self:AddQuest(72, 4, 8, Quest.oc_fish_dq, 65, "nil", FIZ_LIMIT_TYPE_Fish)
		self:AddQuest(72, 4, 8, 7796, 250, { [14047] = 20 }) -- Additional Runecloth (Classic)
		self:AddQuest(72, 4, 8, 7386, 18.75, { [17423] = 5 })
		self:AddQuest(72, 4, 8, 6881, 2.5, { [17423] = 1 })
		self:AddQuest(72, 4, 8, 6943, 10, { [17504] = 1 })
		self:AddQuest(72, 4, 8, 6942, 10, { [17502] = 1 })
		self:AddQuest(72, 4, 8, 6941, 10, { [17503] = 1 })
		self:AddQuest(72, 4, 8, 7027, 2.5)
		self:AddQuest(72, 4, 8, 7026, 2.5, { [17643] = 1 })
		self:AddQuest(72, 4, 8, 6781, 2.5, { [17422] = 20 })
		self:AddItems(72, 4, 8, 250, { [45718] = 1 })
		self:AddItems(72, 4, 8, 62.5, { [items.oc_comm_bad] = 1 })
		self:AddSpell(72, 1, 8, "Quest.no_dq", 1000)

		-- Alliance Battleground Factions
		-- Silverwing Sentinels 890
		self:AddInstance(890, 4, 8, zone.Warsong_Gulch, 35)
		self:AddInstance(890, 4, 8, zone.Warsong_Gulch, 105)
		-- Stormpike Guard 730
		self:AddQuest(730, 4, 8, 7386, 18.75, { [17423] = 5 })
		self:AddQuest(730, 4, 8, 6881, 2.5, { [17423] = 1 })
		self:AddQuest(730, 4, 8, 6941, 10, { [17503] = 1 })
		self:AddQuest(730, 4, 8, 6942, 10, { [17502] = 1 })
		self:AddQuest(730, 4, 8, 6943, 10, { [17504] = 1 })
		self:AddQuest(730, 4, 8, 7027, 2.5)
		self:AddQuest(730, 4, 8, 7026, 2.5, { [17643] = 1 })
		self:AddQuest(730, 4, 8, 6781, 2.5, { [17422] = 20 })
		-- The League of Arathor 509
		self:AddInstance(509, 4, 8, zone.Arathi_Basin, 10)
		self:AddInstance(509, 4, 8, zone.Arathi_Basin, 100)

		-- Wintersaber Trainers 589
		self:AddQuest(589, 4, 8, 29037, 1500)
		self:AddQuest(589, 4, 8, 29035, 1500)
		self:AddQuest(589, 4, 8, 29038, 1500)
		self:AddQuest(589, 4, 8, 29040, 1500)
		self:AddQuest(589, 4, 8, 4970, 250)  -- Frostsaber Provisions (Classic)
		self:AddQuest(589, 4, 8, 5201, 250)  -- Winterfall Intrusion (Classic)
		self:AddQuest(589, 5, 8, 5981, 350)  -- Rampaging Giants (Classic)
	end

	if FIZ_IsHorde then
		-- Horde Capital Cities
		-- Darkspear Trolls 530
		self:AddQuest(530, 4, 8, Quest.oc_cook_dq, 65, "nil", FIZ_LIMIT_TYPE_Cook)
		self:AddQuest(530, 4, 8, Quest.oc_fish_dq, 65, "nil", FIZ_LIMIT_TYPE_Fish)
		self:AddQuest(530, 4, 8, 7831, 250, { [14047] = 20 }) -- Additional Runecloth (Classic)
		self:AddQuest(530, 4, 8, 7385, 18.75, { [17306] = 5 })
		self:AddQuest(530, 4, 8, 6801, 2.5, { [17306] = 1 })
		self:AddQuest(530, 4, 8, 6825, 10, { [17326] = 1 })
		self:AddQuest(530, 4, 8, 6826, 10, { [17327] = 1 })
		self:AddQuest(530, 4, 8, 6827, 10, { [17328] = 1 })
		self:AddQuest(530, 4, 8, 7027, 2.5)
		self:AddQuest(530, 4, 8, 7002, 2.5, { [17642] = 1 })
		self:AddQuest(530, 4, 8, 6741, 2.5, { [17422] = 20 })
		self:AddItems(530, 4, 8, 250, { [45720] = 1 })
		self:AddItems(530, 4, 8, 62.5, { [items.oc_comm_bad] = 1 })
		self:AddSpell(530, 1, 8, "Quest.no_dq", 1000)

		-- Orgrimmar 76
		self:AddQuest(76, 4, 8, Quest.mc_cook_dq, 250, "nil", FIZ_LIMIT_TYPE_Cook)
		self:AddQuest(76, 4, 8, Quest.oc_cook_dq, 65, "nil", FIZ_LIMIT_TYPE_Cook)
		self:AddQuest(76, 4, 8, Quest.mc_fish_dq, 250, "nil", FIZ_LIMIT_TYPE_Fish)
		self:AddQuest(76, 4, 8, Quest.oc_fish_dq, 65, "nil", FIZ_LIMIT_TYPE_Fish)
		self:AddQuest(76, 4, 8, 7824, 250, { [14047] = 20 }) -- Additional Runecloth (Classic)
		self:AddQuest(76, 4, 8, 7385, 18.75, { [17306] = 5 })
		self:AddQuest(76, 4, 8, 6801, 2.5, { [17306] = 1 })
		self:AddQuest(76, 4, 8, 6825, 10, { [17326] = 1 })
		self:AddQuest(76, 4, 8, 6826, 10, { [17327] = 1 })
		self:AddQuest(76, 4, 8, 6827, 10, { [17328] = 1 })
		self:AddQuest(76, 4, 8, 7027, 2.5)
		self:AddQuest(76, 4, 8, 7002, 2.5, { [17642] = 1 })
		self:AddQuest(76, 4, 8, 6741, 2.5, { [17422] = 20 })
		self:AddItems(76, 4, 8, 250, { [45719] = 1 })
		self:AddItems(76, 4, 8, 62.5, { [items.oc_comm_bad] = 1 })
		self:AddSpell(76, 1, 8, "Quest.no_dq", 1000)

		-- Thunder Bluff 81
		self:AddQuest(81, 4, 8, Quest.mc_cook_dq, 250, "nil", FIZ_LIMIT_TYPE_Cook)
		self:AddQuest(81, 4, 8, Quest.oc_cook_dq, 65, "nil", FIZ_LIMIT_TYPE_Cook)
		self:AddQuest(81, 4, 8, Quest.mc_fish_dq, 250, "nil", FIZ_LIMIT_TYPE_Fish)
		self:AddQuest(81, 4, 8, Quest.oc_fish_dq, 65, "nil", FIZ_LIMIT_TYPE_Fish)
		self:AddQuest(81, 4, 8, 7823, 250, { [14047] = 20 }) -- Additional Runecloth (Classic)
		self:AddQuest(81, 4, 8, 7385, 18.75, { [17306] = 5 })
		self:AddQuest(81, 4, 8, 6801, 2.5, { [17306] = 1 })
		self:AddQuest(81, 4, 8, 6825, 10, { [17326] = 1 })
		self:AddQuest(81, 4, 8, 6826, 10, { [17327] = 1 })
		self:AddQuest(81, 4, 8, 6827, 10, { [17328] = 1 })
		self:AddQuest(81, 4, 8, 7027, 2.5)
		self:AddQuest(81, 4, 8, 7002, 2.5, { [17642] = 1 })
		self:AddQuest(81, 4, 8, 6741, 2.5, { [17422] = 20 })
		self:AddItems(81, 4, 8, 250, { [45722] = 1 })
		self:AddItems(81, 4, 8, 62.5, { [items.oc_comm_bad] = 1 })
		self:AddSpell(81, 1, 8, "Quest.no_dq", 1000)

		-- Undercity 68
		self:AddQuest(68, 4, 8, Quest.mc_cook_dq, 250, "nil", FIZ_LIMIT_TYPE_Cook)
		self:AddQuest(68, 4, 8, Quest.oc_cook_dq, 65, "nil", FIZ_LIMIT_TYPE_Cook)
		self:AddQuest(68, 4, 8, Quest.mc_fish_dq, 250, "nil", FIZ_LIMIT_TYPE_Fish)
		self:AddQuest(68, 4, 8, Quest.oc_fish_dq, 65, "nil", FIZ_LIMIT_TYPE_Fish)
		self:AddQuest(68, 4, 8, 7818, 250, { [14047] = 20 }) -- Additional Runecloth (Classic)
		self:AddQuest(68, 4, 8, 7385, 18.75, { [17306] = 5 })
		self:AddQuest(68, 4, 8, 6801, 2.5, { [17306] = 1 })
		self:AddQuest(68, 4, 8, 6825, 10, { [17326] = 1 })
		self:AddQuest(68, 4, 8, 6826, 10, { [17327] = 1 })
		self:AddQuest(68, 4, 8, 6827, 10, { [17328] = 1 })
		self:AddQuest(68, 4, 8, 7027, 2.5)
		self:AddQuest(68, 4, 8, 7002, 2.5, { [17642] = 1 })
		self:AddQuest(68, 4, 8, 6741, 2.5, { [17422] = 20 })
		self:AddItems(68, 4, 8, 250, { [45723] = 1 })
		self:AddItems(68, 4, 8, 62.5, { [items.oc_comm_bad] = 1 })
		self:AddSpell(68, 1, 8, "Quest.no_dq", 1000)

		-- Horde Battleground Factions
		-- The Defilers 510
		self:AddInstance(510, 4, 8, zone.Warsong_Gulch, 35)
		self:AddInstance(510, 4, 8, zone.Warsong_Gulch, 105)
		-- Frostwolf Clan 729
		self:AddQuest(729, 4, 8, 7385, 18.75, { [17306] = 5 })
		self:AddQuest(729, 4, 8, 6801, 2.5, { [17306] = 1 })
		self:AddQuest(729, 4, 8, 6825, 10, { [17326] = 1 })
		self:AddQuest(729, 4, 8, 6826, 10, { [17327] = 1 })
		self:AddQuest(729, 4, 8, 6827, 10, { [17328] = 1 })
		self:AddQuest(729, 4, 8, 7027, 2.5)
		self:AddQuest(729, 4, 8, 7002, 2.5, { [17642] = 1 })
		self:AddQuest(729, 4, 8, 6741, 2.5, { [17422] = 20 })
		-- Warsong Outriders 889
		self:AddInstance(889, 4, 8, zone.Arathi_Basin, 10)
		self:AddInstance(889, 4, 8, zone.Arathi_Basin, 100)
	end

	-- Steamwheedle Cartel
	-- Booty Bay 21
	self:AddMob(21, 1, 7, 11, 5, zone.C_o_Stranglethorn)
	self:AddMob(21, 1, 8, 12, 2.5, zone.C_o_Stranglethorn)
	self:AddMob(21, 1, 8, 13, 2.5, zone.C_o_Stranglethorn)
	self:AddMob(21, 1, 7, 14, 5, zone.C_o_Stranglethorn)
	self:AddMob(21, 1, 7, 15, 12.5, zone.C_o_Stranglethorn)
	self:AddMob(21, 1, 8, 15, 7.5, zone.C_o_Stranglethorn)
	self:AddMob(21, 1, 8, 17, 7.5, zone.C_o_Stranglethorn)
	self:AddMob(21, 1, 7, "Cap'n Garvey & Alicia Cuthbert", 5, zone.Badlands)
	self:AddQuest(21, 1, 3, 9259, 500, { [4306] = 40, [2604] = 4 })

	-- Everlook 577
	self:AddQuest(577, 1, 3, 9266, 500, { [14047] = 40, [3857] = 4 })
	self:AddMob(577, 1, 7, 11, 5, zone.C_o_Stranglethorn)
	self:AddMob(577, 1, 8, 12, 2.5, zone.C_o_Stranglethorn)
	self:AddMob(577, 1, 8, 13, 2.5, zone.C_o_Stranglethorn)
	self:AddMob(577, 1, 7, 14, 5, zone.C_o_Stranglethorn)
	self:AddMob(577, 1, 7, 15, 12.5, zone.C_o_Stranglethorn)
	self:AddMob(577, 1, 8, 15, 7.5, zone.C_o_Stranglethorn)
	self:AddMob(577, 1, 8, 17, 7.5, zone.C_o_Stranglethorn)
	self:AddMob(577, 1, 7, "Cap'n Garvey & Alicia Cuthbert", 5, zone.Badlands)

	-- Gadgetzan 369
	self:AddMob(369, 1, 8, 11, 2.5, zone.C_o_Stranglethorn)
	self:AddMob(369, 1, 8, 12, 2.5, zone.C_o_Stranglethorn)
	self:AddMob(369, 1, 7, 13, 5, zone.C_o_Stranglethorn)
	self:AddMob(369, 1, 7, 14, 2.5, zone.C_o_Stranglethorn)
	self:AddMob(369, 1, 8, 15, 7.5, zone.C_o_Stranglethorn)
	self:AddMob(369, 1, 7, 15, 12.5, zone.C_o_Stranglethorn)
	self:AddMob(369, 1, 8, 17, 12.5, zone.C_o_Stranglethorn)
	self:AddMob(369, 1, 7, "Cap'n Garvey & Alicia Cuthbert", 25, zone.Badlands)
	self:AddQuest(369, 1, 3, 9268, 500, { [4338] = 40, [3466] = 4 })

	-- Ratchet 470
	self:AddMob(470, 1, 8, 11, 2.5, zone.C_o_Stranglethorn)
	self:AddMob(470, 1, 8, 12, 2.5, zone.C_o_Stranglethorn)
	self:AddMob(470, 1, 8, 13, 2.5, zone.C_o_Stranglethorn)
	self:AddMob(470, 1, 7, 14, 2.5, zone.C_o_Stranglethorn)
	self:AddMob(470, 1, 7, 15, 7.5, zone.C_o_Stranglethorn)
	self:AddMob(470, 1, 8, 15, 7.5, zone.C_o_Stranglethorn)
	self:AddMob(470, 1, 7, 17, 12.5, zone.C_o_Stranglethorn)
	self:AddMob(470, 1, 8, "Cap'n Garvey & Alicia Cuthbert", 12.5, zone.Badlands)
	self:AddQuest(470, 1, 3, 9267, 500, { [2589] = 40, [3371] = 4 })

	-- Bloodsail Buccaneers 87
	self:AddMob(87, 1, 7, "Booty Bay Bruiser & Elite", 25, zone.C_o_Stranglethorn)
	self:AddMob(87, 1, 7, "Some Booty Bay Named", 5, zone.C_o_Stranglethorn)
	self:AddMob(87, 1, 7, "Most Booty Bay Named", 1, zone.C_o_Stranglethorn)
	self:AddMob(87, 1, 7, "Most Faldir's Cove Named", 5, zone.Arathi_Highlands)
	self:AddMob(87, 1, 7, "Baron Revilgaz, Grizzlowe & Wharfmaster Lozgil", 25, zone.C_o_Stranglethorn)
	self:AddMob(87, 1, 7, "Viznik & Rickle Goldgrubber (bankers)", 25, zone.C_o_Stranglethorn)

	-- Classic World Factions
	-- Argent Dawn 529
	self:AddGeneral(529, 3, 3, "Fiona's Caravan Quests", 24000, "Fiona's Caravan Quests", "Fiona's Caravan Quests until '[42] Argent Call: The Trial of the Crypt' will give enough reputation to reach Revered.", nil, 0)
	self:AddGeneral(529, 4, 4, "Fiona's Caravan Quests", 21000, "Fiona's Caravan Quests", "Fiona's Caravan Quests until '[42] Argent Call: The Trial of the Crypt' will give enough reputation to reach Revered.", nil, 0)
	self:AddGeneral(529, 5, 5, "Fiona's Caravan Quests", 18000, "Fiona's Caravan Quests", "Fiona's Caravan Quests until '[42] Argent Call: The Trial of the Crypt' will give enough reputation to reach Revered.", nil, 0)
	self:AddGeneral(529, 6, 6, "Fiona's Caravan Quests", 12000, "Fiona's Caravan Quests", "Fiona's Caravan Quests until '[42] Argent Call: The Trial of the Crypt' will give enough reputation to reach Revered.", nil, 0)
	self:AddQuest(529, 7, 8, 28756, 1000)
	self:AddQuest(529, 7, 8, 28755, 1000)
	self:AddQuest(529, 4, 8, 5402, 25, { [12840] = 20 }) -- Minion's Scourgestones (Classic)
	self:AddQuest(529, 4, 8, 5403, 25, { [12841] = 10 }) -- Invader's Scourgestones (Classic)
	self:AddQuest(529, 4, 8, 5404, 25, { [12843] = 1 })  -- Corruptor's Scourgestones (Classic)
	self:AddItems(529, 4, 8, 25, { [12844] = 1 })        -- Argent Dawn Valor Token (Classic)

	-- Darkmoon Faire 909
	self:AddQuest(909, 1, 8, 29761, 250)
	self:AddQuest(909, 1, 8, 29433, 250)
	self:AddQuest(909, 1, 8, 29443, 250, { [71635] = 1 })
	self:AddQuest(909, 1, 8, 29446, 250, { [71638] = 1 })
	self:AddQuest(909, 1, 8, 29456, 250, { [71951] = 1 })
	self:AddQuest(909, 1, 8, 29444, 250, { [71636] = 1 })
	self:AddQuest(909, 1, 8, 29445, 250, { [71637] = 1 })
	self:AddQuest(909, 1, 8, 29458, 250, { [71953] = 1 })
	self:AddQuest(909, 1, 8, 29457, 250, { [71952] = 1 })
	self:AddQuest(909, 1, 8, 29451, 250, { [71715] = 1 })
	self:AddQuest(909, 1, 8, 29464, 250, { [71716] = 1 })
	self:AddQuest(909, 1, 8, 29463, 250)
	self:AddQuest(909, 1, 8, 29438, 250)
	self:AddQuest(909, 1, 8, 29455, 250)
	self:AddQuest(909, 1, 8, 29436, 250)
	self:AddQuest(909, 1, 8, 29434, 250)
	self:AddQuest(909, 1, 8, 29514, 250, "nil", FIZ_LIMIT_TYPE_Herb)
	self:AddQuest(909, 1, 8, 29519, 250, "nil", FIZ_LIMIT_TYPE_Skin)
	self:AddQuest(909, 1, 8, 29518, 250, "nil", FIZ_LIMIT_TYPE_Mine)
	self:AddQuest(909, 1, 8, 29511, 250, "nil", FIZ_LIMIT_TYPE_Engi)
	self:AddQuest(909, 1, 8, 29506, 250, "nil", FIZ_LIMIT_TYPE_Alch)
	self:AddQuest(909, 1, 8, 29508, 250, "nil", FIZ_LIMIT_TYPE_Blac)
	self:AddQuest(909, 1, 8, 29520, 250, "nil", FIZ_LIMIT_TYPE_Tail)
	self:AddQuest(909, 1, 8, 29517, 250, "nil", FIZ_LIMIT_TYPE_Leat)
	self:AddQuest(909, 1, 8, 29510, 250, "nil", FIZ_LIMIT_TYPE_Ench)
	self:AddQuest(909, 1, 8, 29516, 250, "nil", FIZ_LIMIT_TYPE_Jewe)
	self:AddQuest(909, 1, 8, 29515, 250, "nil", FIZ_LIMIT_TYPE_Incr)
	self:AddQuest(909, 1, 8, 29512, 250, "nil", FIZ_LIMIT_TYPE_Aid)
	self:AddQuest(909, 1, 8, 29507, 250, "nil", FIZ_LIMIT_TYPE_Arch)
	self:AddQuest(909, 1, 8, 29509, 250, "nil", FIZ_LIMIT_TYPE_Cook)
	self:AddQuest(909, 1, 8, 29513, 250, "nil", FIZ_LIMIT_TYPE_Fish)
	self:AddItems(909, 1, 8, 25, { [43039] = 1 })
	self:AddItems(909, 1, 8, 25, { [42922] = 1 })
	self:AddItems(909, 1, 8, 25, { [44184] = 1 })
	self:AddItems(909, 1, 8, 25, { [44185] = 1 })
	self:AddItems(909, 1, 8, 350, { [19228] = 1 })
	self:AddItems(909, 1, 8, 350, { [62046] = 1 })
	self:AddItems(909, 1, 8, 350, { [19267] = 1 })
	self:AddItems(909, 1, 8, 350, { [31907] = 1 })
	self:AddItems(909, 1, 8, 350, { [62045] = 1 })
	self:AddItems(909, 1, 8, 350, { [31914] = 1 })
	self:AddItems(909, 1, 8, 350, { [31891] = 1 })
	self:AddItems(909, 1, 8, 350, { [62044] = 1 })
	self:AddItems(909, 1, 8, 350, { [62021] = 1 })
	self:AddItems(909, 1, 8, 350, { [19257] = 1 })
	self:AddItems(909, 1, 8, 350, { [19277] = 1 })
	self:AddItems(909, 1, 8, 350, { [31890] = 1 })
	self:AddItems(909, 1, 8, 350, { [44276] = 1 })
	self:AddItems(909, 1, 8, 350, { [44326] = 1 })
	self:AddItems(909, 1, 8, 350, { [44259] = 1 })
	self:AddItems(909, 1, 8, 350, { [44294] = 1 })

	-- Ravenholdt 349
	self:AddQuest(349, 4, 4, 6701, 250, { [17124] = 1 })
	self:AddQuest(349, 4, 8, 8249, 75, { [16885] = 5 })
	self:AddMob(349, 4, 6, "All Syndicate members", 5, zone.Hillsbrad_Foothills)

	-- Syndicate 70
	self:AddMob(70, 1, 4, "Myrokos Silentform", 25, zone.Hillsbrad_Foothills)
	self:AddMob(70, 1, 4, "Winstone Wolfe", 5, zone.Hillsbrad_Foothills)
	self:AddMob(70, 1, 4, "Lord Jorach Ravenholdt", 5, zone.Hillsbrad_Foothills)
	self:AddMob(70, 1, 4, "Fahrad", 5, zone.Hillsbrad_Foothills)
	self:AddMob(70, 1, 4, "Zan Shivsproket", 5, zone.Hillsbrad_Foothills)
	self:AddMob(70, 1, 4, "Smudge Thunderwood", 5, zone.Hillsbrad_Foothills)
	self:AddMob(70, 1, 4, "Simone Cantrell", 5, zone.Hillsbrad_Foothills)
	self:AddMob(70, 1, 4, "Master Kang", 5, zone.Hillsbrad_Foothills)
	self:AddMob(70, 1, 4, "Carlo Aurelius", 5, zone.Hillsbrad_Foothills)
	self:AddMob(70, 1, 4, "Ravenholdt Assassin", 5, zone.Hillsbrad_Foothills)
	self:AddMob(70, 1, 4, "Ravenholdt Guard", 5, zone.Hillsbrad_Foothills)

	-- Thorium Brotherhood 59
	self:AddQuest(59, 4, 6, 13662, 25, { [18945] = 4 })
	self:AddQuest(59, 4, 6, 7737, 625, { [18945] = 100 })
	self:AddQuest(59, 4, 8, 6642, 300, { [11370] = 10 })
	self:AddQuest(59, 4, 8, 6645, 1400, { [17012] = 2 })
	self:AddQuest(59, 4, 8, 6646, 2000, { [11382] = 1 })
	self:AddQuest(59, 4, 8, 6643, 2000, { [17010] = 1 })
	self:AddQuest(59, 4, 8, 6644, 2000, { [17011] = 1 })

	-- Timbermaw Hold 576
	self:AddQuest(576, 2, 8, 28395, 2000, { [21377] = 5 })
	self:AddQuest(576, 2, 8, 28396, 2000, { [21377] = 5 })
	self:AddQuest(576, 2, 8, 28523, 2000, { [21383] = 5 })
	self:AddQuest(576, 2, 8, 8466, 300, { [21377] = 5 })  -- Feathers for Grazle (Classic)
	self:AddQuest(576, 2, 8, 8467, 300, { [21377] = 5 })  -- Feathers for Nafien (Classic)
	self:AddQuest(576, 2, 8, 8469, 300, { [21383] = 5 })  -- Beads for Salfa (Classic)
	self:AddMob(576, 2, 6, "Deadwood Avenger, Den Watcher, Shaman, Gardener, Pathfinder & Warrior", 20, zone.Felwood)
	self:AddMob(576, 2, 6, "Winterfall Runner, Den Watcher, Shaman, Pathfinder, Totemic & Ursa", 20, zone.Winterspring)
	self:AddMob(576, 2, 8, "Chieftain Bloodmaw", 60, zone.Felwood)
	self:AddMob(576, 2, 8, "Overlord Ror", 60, zone.Felwood)
	self:AddMob(576, 2, 8, "Ragepaw (Rare)", 50, zone.Felwood)
	self:AddMob(576, 2, 8, "Grizzle Snowpaw (Rare)", 50, zone.Winterspring)
	self:AddMob(576, 2, 8, "High Chief Winterfall", 50, zone.Winterspring)

	-- Classic Raid Factions
	-- Brood of Nozdormu 910
	self:AddMob(910, 1, 4, "Anubisath Defender", 100, zone.Temple_of_AhnQiraj)
	self:AddMob(910, 1, 4, "Anubisath Sentinel", 100, zone.Temple_of_AhnQiraj)
	self:AddMob(910, 1, 4, "Obsidian Eradicator", 100, zone.Temple_of_AhnQiraj)
	self:AddMob(910, 1, 4, "Qiraji Lasher", 100, zone.Temple_of_AhnQiraj)
	self:AddMob(910, 1, 4, "Vekniss Hive Crawler", 100, zone.Temple_of_AhnQiraj)
	self:AddMob(910, 1, 4, "Vekniss Soldier", 100, zone.Temple_of_AhnQiraj)
	self:AddMob(910, 1, 4, "Vekniss Stinger", 100, zone.Temple_of_AhnQiraj)
	self:AddMob(910, 1, 4, "Vekniss Warrior", 100, zone.Temple_of_AhnQiraj)
	self:AddMob(910, 1, 4, "Vekniss Wasp", 100, zone.Temple_of_AhnQiraj)
	self:AddMob(910, 1, 8, "Most Bosses", 50)
	self:AddMob(910, 1, 8, "Ossirian", 100, zone.Ruins_of_AhnQiraj)
	self:AddMob(910, 1, 8, "Twin Emperors", 200, zone.Temple_of_AhnQiraj)
	self:AddMob(910, 1, 8, "C'Thun", 2500, zone.Temple_of_AhnQiraj)
	self:AddItems(910, 1, 8, 500, { [21229] = 1 })
	self:AddItems(910, 1, 8, 1000, { [21230] = 1 })

	-- Cenarion Circle 609
	self:AddQuest(609, 4, 8, 8319, 500, { [20404] = 10 })
	self:AddInstance(609, 4, 8, zone.Ruins_of_AhnQiraj, 1200)
	self:AddMob(609, 4, 5, "Any Twilight's Hammer mobs", 10, zone.Silithus)
	self:AddItems(609, 1, 8, 500, { [21229] = 1 })

	-- Hydraxian Waterlords 749
	self:AddMob(749, 4, 5, "Desert Rumbler, Dust Stormer", 5, zone.Silithus)
	self:AddMob(749, 4, 5, "Greater Obsidian Elemental", 5, zone.Burning_Steppes)
	self:AddMob(749, 4, 6, "Lord Incendius", 15, zone.Blackrock_Depths)
	self:AddMob(749, 4, 6, "Huricanian (Rare)", 25, zone.Silithus)
	self:AddMob(749, 4, 6, "Pyroguard Emberseer", 50, zone.Blackrock_Spire)
	self:AddMob(749, 4, 6, "Molten Core Trash", 20, zone.Molten_Core)
	self:AddMob(749, 4, 6, "Molten Destroyer & Lava Pack", 40, zone.Molten_Core)
	self:AddInstance(749, 4, 7, zone.Molten_Core, 1050)
	self:AddInstance(749, 8, 8, zone.Molten_Core, 350)

	-- Zandalar Tribe 270 (Classic Era / Legacy)
	self:AddItems(270, 4, 8, 50, { [19858] = 1 }) -- Zandalar Honor Token
	self:AddQuest(270, 4, 8, 8195, 25, { [19698] = 1, [19699] = 1, [19700] = 1 }) -- Zulian, Razzashi, and Hakkari Coins
	self:AddQuest(270, 4, 8, 8238, 25, { [19701] = 1, [19702] = 1, [19703] = 1 }) -- Gurubashi, Vilebranch, and Witherbark Coins
	self:AddQuest(270, 4, 8, 8239, 25, { [19704] = 1, [19705] = 1, [19706] = 1 }) -- Sandfury, Skullsplitter, and Bloodscalp Coins
	self:AddQuest(270, 1, 8, Quest.outd, 1)

	-- Shen'dralar 809 (Dire Maul Librams & Class Books)
	self:AddQuest(809, 4, 8, 7483, 500, { [18332] = 1 }) -- Libram of Rapidity
	self:AddQuest(809, 4, 8, 7484, 500, { [18333] = 1 }) -- Libram of Focus
	self:AddQuest(809, 4, 8, 7485, 500, { [18334] = 1 }) -- Libram of Protection
	self:AddGeneral(809, 4, 8, "Dire Maul Class Book Turn-ins & Lorekeeper Quests", 500,
		"Shen'dralar (Dire Maul)",
		"Turn in Libram of Rapidity, Libram of Focus, Libram of Protection, and Royal Seal of Eldre'Thalas class books to Lorekeeper Lydros in Dire Maul.")

	-- Gelkis Clan Centaur 92 (Desolace)
	self:AddMob(92, 1, 6, "Magram Clan Centaurs", 20, zone.Desolace)
	self:AddGeneral(92, 1, 7, "Gelkis Alliance Quests (Uthek the Wise)", 250,
		"Gelkis Clan Centaur",
		"Slay rival Magram Clan Centaurs in southern Desolace (20 rep per kill up to Revered) and complete Uthek the Wise's quest chain.")

	-- Magram Clan Centaur 93 (Desolace)
	self:AddMob(93, 1, 6, "Gelkis Clan Centaurs", 20, zone.Desolace)
	self:AddGeneral(93, 1, 7, "Magram Alliance Quests (Warug)", 250,
		"Magram Clan Centaur",
		"Slay rival Gelkis Clan Centaurs in southwestern Desolace (20 rep per kill up to Revered) and complete Warug's quest chain.")
end)

