----------------------------------------------------------
-- Factionizer - Midnight (12.x) Reputation Content     --
----------------------------------------------------------

local FIZ = _G.FIZ

FIZ:RegisterContentModule("Midnight", function(self, zone, mob, Quest, items, instance)
	-- Silvermoon Court 2710 (Eversong Woods / Silvermoon)
	self:AddQuest(2710, 1, 8, Quest.weekly_quest, 1500)
	self:AddQuest(2710, 1, 8, Quest.special_assignment, 400)
	self:AddQuest(2710, 1, 8, Quest.bountiful_delve, 1250)
	self:AddQuest(2710, 1, 8, Quest.world_quest, 150)
	self:AddQuest(2710, 1, 8, Quest.contract_wq, 15)
	self:AddMob(2710, 1, 8, "Weekly Rare Elite", 150, zone.Eversong_Midnight)

	-- Amani Tribe 2696 (Zul'Aman)
	self:AddQuest(2696, 1, 8, Quest.weekly_quest, 1500)
	self:AddQuest(2696, 1, 8, Quest.special_assignment, 400)
	self:AddQuest(2696, 1, 8, Quest.bountiful_delve, 1250)
	self:AddQuest(2696, 1, 8, Quest.world_quest, 150)
	self:AddQuest(2696, 1, 8, Quest.contract_wq, 15)
	self:AddMob(2696, 1, 8, "Weekly Rare Elite", 150, zone.ZulAman_Midnight)

	-- Haranir 2704 (Harandar)
	self:AddQuest(2704, 1, 8, Quest.weekly_quest, 1500)
	self:AddQuest(2704, 1, 8, Quest.special_assignment, 400)
	self:AddQuest(2704, 1, 8, Quest.bountiful_delve, 1250)
	self:AddQuest(2704, 1, 8, Quest.world_quest, 150)
	self:AddQuest(2704, 1, 8, Quest.contract_wq, 15)
	self:AddMob(2704, 1, 8, "Weekly Rare Elite", 150, zone.Harandar)

	-- The Singularity 2699 (Voidstorm)
	self:AddQuest(2699, 1, 8, Quest.weekly_quest, 1500)
	self:AddQuest(2699, 1, 8, Quest.special_assignment, 400)
	self:AddQuest(2699, 1, 8, Quest.bountiful_delve, 1250)
	self:AddQuest(2699, 1, 8, Quest.world_quest, 150)
	self:AddQuest(2699, 1, 8, Quest.contract_wq, 15)
	self:AddMob(2699, 1, 8, "Weekly Rare Elite", 150, zone.Voidstorm)
end)

