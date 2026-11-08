----------------------------------------------------------
-- Factionizer - Shadowlands (9.x) Reputation Content   --
----------------------------------------------------------

local FIZ = _G.FIZ

FIZ:RegisterContentModule("Shadowlands", function(self, zone, mob, Quest, items, instance)
	-- The Ascended 2407 (Bastion)
	self:AddQuest(2407, 1, 8, Quest.calling_quest, 1500)
	self:AddQuest(2407, 1, 8, Quest.weekly_quest, 500)
	self:AddQuest(2407, 1, 8, Quest.world_quest, 125)
	self:AddQuest(2407, 1, 8, Quest.contract_wq, 10)

	-- The Undying Army 2410 (Maldraxxus)
	self:AddQuest(2410, 1, 8, Quest.calling_quest, 1500)
	self:AddQuest(2410, 1, 8, Quest.weekly_quest, 500)
	self:AddQuest(2410, 1, 8, Quest.world_quest, 125)
	self:AddQuest(2410, 1, 8, Quest.contract_wq, 10)

	-- The Wild Hunt 2465 (Ardenweald)
	self:AddQuest(2465, 1, 8, Quest.calling_quest, 1500)
	self:AddQuest(2465, 1, 8, Quest.weekly_quest, 500)
	self:AddQuest(2465, 1, 8, Quest.world_quest, 125)
	self:AddQuest(2465, 1, 8, Quest.contract_wq, 10)

	-- Court of Harvesters 2413 (Revendreth)
	self:AddQuest(2413, 1, 8, Quest.calling_quest, 1500)
	self:AddQuest(2413, 1, 8, Quest.weekly_quest, 500)
	self:AddQuest(2413, 1, 8, Quest.world_quest, 125)
	self:AddQuest(2413, 1, 8, Quest.contract_wq, 10)

	-- The Avowed 2439 (Halls of Atonement / Revendreth)
	self:AddItems(2439, 1, 8, 5, { [173061] = 1 })    -- Sinstone Fragment
	self:AddMob(2439, 1, 8, "Inquisitor (Sinstone)", 100, zone.Revendreth)
	self:AddMob(2439, 1, 8, "High Inquisitor (Sinstone)", 200, zone.Revendreth)
	self:AddMob(2439, 1, 8, "Grand Inquisitor (Sinstone)", 250, zone.Revendreth)

	-- Ve'nari 2432 (The Maw)
	self:AddQuest(2432, 1, 8, Quest.weekly_quest, 850)
	self:AddQuest(2432, 1, 8, Quest.world_quest, 300)
	self:AddMob(2432, 1, 8, "Maw Rare / Wrath of the Jailer", 100, zone.The_Maw)

	-- Death's Advance 2470 (Korthia)
	self:AddItems(2470, 1, 8, 250, { [186655] = 1 })  -- Death's Advance War Chest / Insignia
	self:AddQuest(2470, 1, 8, 63949, 1000)            -- Shaping Fate (Weekly)
	self:AddQuest(2470, 1, 8, Quest.world_quest, 125)
	self:AddQuest(2470, 1, 8, Quest.contract_wq, 10)

	-- The Archivists' Codex 2472 (Korthia)
	self:AddItems(2472, 1, 8, 0.5, { [185636] = 1 })  -- Relic Fragment

	-- The Enlightened 2478 (Zereth Mortis)
	self:AddItems(2478, 1, 8, 100, { [190941] = 1 })  -- Teachings of the Elders
	self:AddQuest(2478, 1, 8, 65324, 1250)            -- Patterns Within Patterns (Weekly)
	self:AddQuest(2478, 1, 8, Quest.world_quest, 125)
	self:AddQuest(2478, 1, 8, Quest.contract_wq, 10)
	self:AddMob(2478, 1, 8, "Antros (World Boss)", 500, zone.Zereth_Mortis)
	self:AddMob(2478, 1, 8, "Zereth Mortis Rare Mob", 15, zone.Zereth_Mortis)

	-- Court of Night 2464, Stitchmasters 2462, The Ember Court 2445
	self:AddQuest(2464, 1, 8, Quest.world_quest, 300)
	self:AddQuest(2462, 1, 8, Quest.weekly_quest, 750)
	self:AddQuest(2445, 1, 8, Quest.weekly_quest, 1000)
end)

