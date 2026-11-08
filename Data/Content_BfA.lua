----------------------------------------------------------
-- Factionizer - Battle for Azeroth (8.x) Content       --
----------------------------------------------------------

local FIZ = _G.FIZ

FIZ:RegisterContentModule("BfA", function(self, zone, mob, Quest, items, instance)
	if FIZ_IsAlliance then
		-- Proudmoore Admiralty 2160
		self:AddItems(2160, 1, 8, 250, { [163616] = 1 })  -- Dented Coin (Island Expedition Turn-In)
		self:AddQuest(2160, 1, 8, 50599, 1500)            -- Proudmoore Admiralty (Emissary)
		self:AddQuest(2160, 1, 8, Quest.world_quest, 75)
		self:AddQuest(2160, 1, 8, Quest.contract_wq, 10)

		-- Order of Embers 2161
		self:AddItems(2161, 1, 8, 250, { [163614] = 1 })  -- Exotic Spices (Island Expedition Turn-In)
		self:AddQuest(2161, 1, 8, 50600, 1500)            -- Order of Embers (Emissary)
		self:AddQuest(2161, 1, 8, Quest.world_quest, 75)
		self:AddQuest(2161, 1, 8, Quest.contract_wq, 10)

		-- Storm's Wake 2162
		self:AddItems(2162, 1, 8, 250, { [163615] = 1 })  -- Lost Sea Scroll (Island Expedition Turn-In)
		self:AddQuest(2162, 1, 8, 50601, 1500)            -- Storm's Wake (Emissary)
		self:AddQuest(2162, 1, 8, Quest.world_quest, 75)
		self:AddQuest(2162, 1, 8, Quest.contract_wq, 10)

		-- 7th Legion 2159
		self:AddItems(2159, 1, 8, 250, { [163617] = 1 })  -- Rusted Alliance Insignia (Island Expedition)
		self:AddQuest(2159, 1, 8, 50605, 1500)            -- Alliance War Effort (Emissary)
		self:AddQuest(2159, 1, 8, Quest.world_quest, 75)
		self:AddQuest(2159, 1, 8, Quest.contract_wq, 10)

		-- Waveblade Ankoan 2400
		self:AddItems(2400, 1, 8, 250, { [174522] = 1 })  -- Waveswept Abyssal Conch
		self:AddQuest(2400, 1, 8, 56119, 1500)            -- The Waveblade Ankoan (Emissary)
		self:AddQuest(2400, 1, 8, Quest.world_quest, 75)
		self:AddQuest(2400, 1, 8, Quest.contract_wq, 10)

		-- Honeyback Hive 2395
		self:AddItems(2395, 1, 8, 20, { [168822] = 1 })   -- Thin Jelly
		self:AddItems(2395, 1, 8, 80, { [168825] = 1 })   -- Rich Jelly
		self:AddItems(2395, 1, 8, 160, { [168828] = 1 })  -- Royal Jelly
	end

	if FIZ_IsHorde then
		-- Zandalari Empire 2103
		self:AddItems(2103, 1, 8, 250, { [163621] = 1 })  -- Golden Beetle (Island Expedition Turn-In)
		self:AddQuest(2103, 1, 8, 50598, 1500)            -- Zandalari Empire (Emissary)
		self:AddQuest(2103, 1, 8, Quest.world_quest, 75)
		self:AddQuest(2103, 1, 8, Quest.contract_wq, 10)

		-- Talanji's Expedition 2156
		self:AddItems(2156, 1, 8, 250, { [163619] = 1 })  -- Shimmering Shell (Island Expedition Turn-In)
		self:AddQuest(2156, 1, 8, 50602, 1500)            -- Talanji's Expedition (Emissary)
		self:AddQuest(2156, 1, 8, Quest.world_quest, 75)
		self:AddQuest(2156, 1, 8, Quest.contract_wq, 10)

		-- Voldunai 2158
		self:AddItems(2158, 1, 8, 250, { [163618] = 1 })  -- Island Flotsam (Island Expedition Turn-In)
		self:AddQuest(2158, 1, 8, 50603, 1500)            -- Voldunai (Emissary)
		self:AddQuest(2158, 1, 8, Quest.world_quest, 75)
		self:AddQuest(2158, 1, 8, Quest.contract_wq, 10)

		-- The Honorbound 2157
		self:AddItems(2157, 1, 8, 250, { [163620] = 1 })  -- Rusted Horde Insignia (Island Expedition)
		self:AddQuest(2157, 1, 8, 50606, 1500)            -- Horde War Effort (Emissary)
		self:AddQuest(2157, 1, 8, Quest.world_quest, 75)
		self:AddQuest(2157, 1, 8, Quest.contract_wq, 10)

		-- The Unshackled 2373
		self:AddItems(2373, 1, 8, 250, { [174523] = 1 })  -- Waveswept Abyssal Conch
		self:AddQuest(2373, 1, 8, 56120, 1500)            -- The Unshackled (Emissary)
		self:AddQuest(2373, 1, 8, Quest.world_quest, 75)
		self:AddQuest(2373, 1, 8, Quest.contract_wq, 10)
	end

	-- Neutral Battle for Azeroth Factions
	-- Champions of Azeroth 2164
	self:AddItems(2164, 1, 8, 250, { [163217] = 1 })  -- Azeroth's Tear
	self:AddQuest(2164, 1, 8, 50562, 1500)            -- Champions of Azeroth (Emissary)
	self:AddQuest(2164, 1, 8, Quest.world_quest, 75)
	self:AddQuest(2164, 1, 8, Quest.contract_wq, 10)

	-- Tortollan Seekers 2163
	self:AddItems(2163, 1, 8, 250, { [166501] = 1 })  -- Soggy Page
	self:AddQuest(2163, 1, 8, 50604, 1500)            -- Tortollan Seekers (Emissary)
	self:AddQuest(2163, 1, 8, Quest.world_quest, 175)
	self:AddQuest(2163, 1, 8, Quest.contract_wq, 10)

	-- Rustbolt Resistance 2391
	self:AddItems(2391, 1, 8, 150, { [168497] = 1 })  -- Rustbolt Resistance Insignia
	self:AddQuest(2391, 1, 8, 55350, 850)             -- The Mechagonian Threat (Daily)
	self:AddQuest(2391, 1, 8, Quest.world_quest, 150)
	self:AddQuest(2391, 1, 8, Quest.contract_wq, 10)

	-- Rajani 2415
	self:AddItems(2415, 1, 8, 250, { [173374] = 1 })  -- Rajani Insignia
	self:AddQuest(2415, 1, 8, 56309, 1500)            -- Black Empire Assault (Vale of Eternal Blossoms)
	self:AddQuest(2415, 1, 8, Quest.world_quest, 125)
	self:AddQuest(2415, 1, 8, Quest.contract_wq, 10)

	-- Uldum Accord 2417
	self:AddItems(2417, 1, 8, 250, { [173376] = 1 })  -- Uldum Accord Insignia
	self:AddQuest(2417, 1, 8, 57157, 1500)            -- Black Empire Assault (Uldum)
	self:AddQuest(2417, 1, 8, Quest.world_quest, 125)
	self:AddQuest(2417, 1, 8, Quest.contract_wq, 10)
end)

