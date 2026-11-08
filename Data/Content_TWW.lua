----------------------------------------------------------
-- Factionizer - The War Within (11.x) Content          --
----------------------------------------------------------

local FIZ = _G.FIZ

FIZ:RegisterContentModule("TWW", function(self, zone, mob, Quest, items, instance)
	-- Council of Dornogal 2590 (Isle of Dorn)
	self:AddQuest(2590, 1, 8, 83240, 1000)             -- The Theater Troupe (Weekly)
	self:AddQuest(2590, 1, 8, Quest.weekly_quest, 1500) -- Weekly Dungeon / Worldsoul Quest
	self:AddQuest(2590, 1, 8, Quest.special_assignment, 400)
	self:AddQuest(2590, 1, 8, Quest.bountiful_delve, 1250)
	self:AddQuest(2590, 1, 8, Quest.world_quest, 150)
	self:AddQuest(2590, 1, 8, Quest.contract_wq, 15)
	self:AddMob(2590, 1, 8, "Weekly Rare Elite", 150, zone.Isle_of_Dorn)

	-- The Assembly of the Deeps 2594 (The Ringing Deeps)
	self:AddQuest(2594, 1, 8, 83333, 1000)             -- Gearing Up for Trouble / Awakening the Machine (Weekly)
	self:AddQuest(2594, 1, 8, 82946, 1000)             -- Rollin' Down in the Deeps (Weekly)
	self:AddQuest(2594, 1, 8, Quest.weekly_quest, 1500) -- Weekly Dungeon / Worldsoul Quest
	self:AddQuest(2594, 1, 8, Quest.special_assignment, 400)
	self:AddQuest(2594, 1, 8, Quest.bountiful_delve, 1250)
	self:AddQuest(2594, 1, 8, Quest.world_quest, 150)
	self:AddQuest(2594, 1, 8, Quest.contract_wq, 15)
	self:AddMob(2594, 1, 8, "Weekly Rare Elite", 150, zone.Ringing_Deeps)

	-- Hallowfall Arathi 2570 (Hallowfall)
	self:AddQuest(2570, 1, 8, 76586, 1000)             -- Spreading the Light (Weekly)
	self:AddQuest(2570, 1, 8, Quest.weekly_quest, 1500) -- Weekly Dungeon / Worldsoul Quest
	self:AddQuest(2570, 1, 8, Quest.special_assignment, 400)
	self:AddQuest(2570, 1, 8, Quest.bountiful_delve, 1250)
	self:AddQuest(2570, 1, 8, Quest.world_quest, 150)
	self:AddQuest(2570, 1, 8, Quest.contract_wq, 15)
	self:AddMob(2570, 1, 8, "Weekly Rare Elite", 150, zone.Hallowfall)

	-- The Severed Threads 2600 (Azj-Kahet)
	self:AddQuest(2600, 1, 8, 80592, 2250)             -- Forging a Pact (Weekly)
	self:AddQuest(2600, 1, 8, Quest.weekly_quest, 1500) -- Weekly Dungeon / Worldsoul Quest
	self:AddQuest(2600, 1, 8, Quest.special_assignment, 400)
	self:AddQuest(2600, 1, 8, Quest.bountiful_delve, 1250)
	self:AddQuest(2600, 1, 8, Quest.world_quest, 150)
	self:AddQuest(2600, 1, 8, Quest.contract_wq, 15)
	self:AddMob(2600, 1, 8, "Weekly Rare Elite", 150, zone.Azj_Kahet)

	-- Severed Threads Leaders: The Weaver 2601, The General 2605, The Vizier 2607
	self:AddQuest(2601, 1, 8, 80670, 1500)             -- Eyes of the Weaver (Weekly)
	self:AddQuest(2601, 1, 8, Quest.world_quest, 100)
	self:AddQuest(2605, 1, 8, 80671, 1500)             -- Blade of the General (Weekly)
	self:AddQuest(2605, 1, 8, Quest.world_quest, 100)
	self:AddQuest(2607, 1, 8, 80672, 1500)             -- Hand of the Vizier (Weekly)
	self:AddQuest(2607, 1, 8, Quest.world_quest, 100)

	-- The Cartels of Undermine 2653 (Patch 11.1 Undermine)
	self:AddQuest(2653, 1, 8, Quest.weekly_quest, 1000) -- C.H.E.T.T. List / Urge to Surge / Many Jobs, Handle It!
	self:AddQuest(2653, 1, 8, Quest.special_assignment, 400)
	self:AddQuest(2653, 1, 8, Quest.world_quest, 150)
	self:AddQuest(2653, 1, 8, Quest.contract_wq, 15)
	self:AddMob(2653, 1, 8, "Weekly Rare Elite", 100, zone.Undermine)

	-- Undermine Sub-Cartels: Bilgewater 2673, Blackwater 2675, Steamwheedle 2677, Venture Co 2671, Darkfuse Solutions 2669
	for _, cartelID in ipairs({ 2673, 2675, 2677, 2671 }) do
		self:AddQuest(cartelID, 1, 8, Quest.weekly_quest, 1000)
		self:AddQuest(cartelID, 1, 8, Quest.world_quest, 150)
		self:AddMob(cartelID, 1, 8, "Weekly Rare Elite", 100, zone.Undermine)
	end
	self:AddItems(2669, 1, 8, 500, { [235558] = 100 }) -- Market Research (Darkfuse Solutions)

	-- Flame's Radiance 2688 (Patch 11.1.5 Nightfall)
	self:AddQuest(2688, 1, 8, Quest.weekly_quest, 1000)
	self:AddQuest(2688, 1, 8, Quest.world_quest, 200)

	-- The K'aresh Trust 2658 (Patch 11.2 Ghosts of K'aresh)
	self:AddQuest(2658, 1, 8, Quest.weekly_quest, 1500)
	self:AddQuest(2658, 1, 8, Quest.special_assignment, 400)
	self:AddQuest(2658, 1, 8, Quest.bountiful_delve, 1250)
	self:AddQuest(2658, 1, 8, Quest.world_quest, 150)
	self:AddQuest(2658, 1, 8, Quest.contract_wq, 15)
	self:AddMob(2658, 1, 8, "Weekly Rare Elite", 150, zone.Karesh)
end)

