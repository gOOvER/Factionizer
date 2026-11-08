----------------------------------------------------------
-- Factionizer - Dragonflight (10.x) Reputation Content --
----------------------------------------------------------

local FIZ = _G.FIZ

FIZ:RegisterContentModule("Dragonflight", function(self, zone, mob, Quest, items, instance)
	-- Dragonscale Expedition 2507
	self:AddItems(2507, 1, 8, 15, { [192055] = 1 })   -- Dragon Isles Artifact
	self:AddItems(2507, 1, 8, 30, { [198048] = 1 })   -- Ancient Vault Artifact
	self:AddItems(2507, 1, 8, 250, { [200452] = 1 })  -- Dragonscale Expedition Insignia
	self:AddItems(2507, 1, 8, 500, { [201921] = 1 })  -- Dragonscale Expedition Insignia (Epic)
	self:AddItems(2507, 1, 8, 2500, { [202091] = 1 }) -- Dragonscale Expedition Insignia (Legendary)
	self:AddQuest(2507, 1, 8, 70750, 500)             -- Aiding the Accord (Weekly)
	self:AddQuest(2507, 1, 8, Quest.weekly_quest, 250)
	self:AddQuest(2507, 1, 8, Quest.world_quest, 100)
	self:AddQuest(2507, 1, 8, Quest.contract_wq, 15)

	-- Maruuk Centaur 2503
	self:AddItems(2503, 1, 8, 25, { [200093] = 1 })   -- Centaur Hunting Trophy
	self:AddItems(2503, 1, 8, 250, { [200453] = 1 })  -- Maruuk Centaur Insignia
	self:AddItems(2503, 1, 8, 500, { [201922] = 1 })  -- Maruuk Centaur Insignia (Epic)
	self:AddItems(2503, 1, 8, 2500, { [202092] = 1 }) -- Maruuk Centaur Insignia (Legendary)
	self:AddQuest(2503, 1, 8, 70750, 500)             -- Aiding the Accord (Weekly)
	self:AddQuest(2503, 1, 8, Quest.weekly_quest, 500) -- Grand Hunt
	self:AddQuest(2503, 1, 8, Quest.world_quest, 100)
	self:AddQuest(2503, 1, 8, Quest.contract_wq, 15)

	-- Iskaara Tuskarr 2511
	self:AddItems(2511, 1, 8, 15, { [200071] = 1 })   -- Sacred Tuskarr Totem
	self:AddItems(2511, 1, 8, 250, { [200454] = 1 })  -- Iskaara Tuskarr Insignia
	self:AddItems(2511, 1, 8, 500, { [201923] = 1 })  -- Iskaara Tuskarr Insignia (Epic)
	self:AddItems(2511, 1, 8, 2500, { [202094] = 1 }) -- Iskaara Tuskarr Insignia (Legendary)
	self:AddQuest(2511, 1, 8, 70893, 500)             -- Community Feast (Weekly)
	self:AddQuest(2511, 1, 8, 70750, 500)             -- Aiding the Accord (Weekly)
	self:AddQuest(2511, 1, 8, Quest.world_quest, 100)
	self:AddQuest(2511, 1, 8, Quest.contract_wq, 15)

	-- Valdrakken Accord 2510
	self:AddItems(2510, 1, 8, 15, { [199906] = 1 })   -- Titan Relic
	self:AddItems(2510, 1, 8, 250, { [200455] = 1 })  -- Valdrakken Accord Insignia
	self:AddItems(2510, 1, 8, 500, { [201924] = 1 })  -- Valdrakken Accord Insignia (Epic)
	self:AddItems(2510, 1, 8, 2500, { [202093] = 1 }) -- Valdrakken Accord Insignia (Legendary)
	self:AddQuest(2510, 1, 8, 70750, 500)             -- Aiding the Accord (Weekly)
	self:AddQuest(2510, 1, 8, 70866, 250)             -- Siege on Dragonbane Keep
	self:AddQuest(2510, 1, 8, Quest.world_quest, 100)
	self:AddQuest(2510, 1, 8, Quest.contract_wq, 15)

	-- Loamm Niffen 2564 (Zaralek Cavern)
	self:AddItems(2564, 1, 8, 250, { [205342] = 1 })  -- Loamm Niffen Insignia
	self:AddItems(2564, 1, 8, 500, { [205985] = 1 })  -- Loamm Niffen Insignia (Epic)
	self:AddItems(2564, 1, 8, 2500, { [205988] = 1 }) -- Loamm Niffen Insignia (Legendary)
	self:AddQuest(2564, 1, 8, 75665, 1500)            -- A Worthy Ally: Loamm Niffen (Weekly)
	self:AddQuest(2564, 1, 8, 75629, 500)             -- Researchers Under Fire (Weekly)
	self:AddQuest(2564, 1, 8, Quest.world_quest, 125)
	self:AddQuest(2564, 1, 8, Quest.contract_wq, 15)

	-- Dream Wardens 2574 (Emerald Dream)
	self:AddItems(2574, 1, 8, 250, { [210420] = 1 })  -- Dream Wardens Insignia
	self:AddItems(2574, 1, 8, 500, { [210421] = 1 })  -- Dream Wardens Insignia (Epic)
	self:AddItems(2574, 1, 8, 2500, { [210423] = 1 }) -- Dream Wardens Insignia (Legendary)
	self:AddQuest(2574, 1, 8, 78444, 1500)            -- A Worthy Ally: Dream Wardens (Weekly)
	self:AddQuest(2574, 1, 8, 78319, 1000)            -- The Superbloom (Weekly)
	self:AddQuest(2574, 1, 8, 78821, 500)             -- Blooming Dreamseeds (Weekly)
	self:AddQuest(2574, 1, 8, Quest.world_quest, 125)
	self:AddQuest(2574, 1, 8, Quest.contract_wq, 15)

	-- Artisan's Consortium - Dragon Isles Branch 2544
	self:AddQuest(2544, 1, 8, Quest.weekly_quest, 250)
	self:AddQuest(2544, 1, 8, Quest.contract_wq, 15)

	-- Cobalt Assembly 2550
	self:AddMob(2550, 1, 8, "Sundered Flame (Arcane Sustenance)", 30, zone.Azure_Span)

	-- Wrathion 2517 & Sabellian 2518
	self:AddItems(2517, 1, 8, 50, { [200285] = 1 })   -- Mark of Sargha
	self:AddItems(2517, 1, 8, 250, { [191264] = 1 })  -- Restored Obsidian Key
	self:AddQuest(2517, 1, 8, 66805, 500)             -- Allegiance to One (Weekly)
	self:AddQuest(2517, 1, 8, Quest.weekly_quest, 250)

	self:AddItems(2518, 1, 8, 50, { [200285] = 1 })   -- Mark of Sargha
	self:AddItems(2518, 1, 8, 250, { [191264] = 1 })  -- Restored Obsidian Key
	self:AddQuest(2518, 1, 8, 66805, 500)             -- Allegiance to One (Weekly)
	self:AddQuest(2518, 1, 8, Quest.weekly_quest, 250)

	-- Winterpelt Furbolg 2526
	self:AddItems(2526, 1, 8, 15, { [202254] = 1 })   -- Liberated Furbolg Artifacts
	self:AddItems(2526, 1, 8, 75, { [202253] = 1 })   -- Intact Coil Capacitor

	-- Glimmerogg Racer 2568
	self:AddQuest(2568, 1, 8, Quest.world_quest, 100)

	-- Soridormi 2553
	self:AddItems(2553, 1, 8, 1000, { [207002] = 1 }) -- Greater Encapsulated Destiny
	self:AddQuest(2553, 1, 8, Quest.weekly_quest, 1000)

	-- Azerothian Archives 2615
	self:AddQuest(2615, 1, 8, 78642, 1000)            -- The Big Dig: Traitor's Rest (Weekly)
	self:AddQuest(2615, 1, 8, Quest.world_quest, 250)
end)

