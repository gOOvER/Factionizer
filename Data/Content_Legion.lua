----------------------------------------------------------
-- Factionizer - Legion (7.x) Reputation Content        --
----------------------------------------------------------

local FIZ = _G.FIZ

FIZ:RegisterContentModule("Legion", function(self, zone, mob, Quest, items, instance)
	-- Court of Farondis 1900
	self:AddItems(1900, 1, 8, 250, { [146937] = 1 })  -- Court of Farondis Insignia
	self:AddItems(1900, 1, 8, 250, { [146943] = 1 })  -- Court of Farondis Insignia (BoA)
	self:AddItems(1900, 1, 8, 1500, { [150927] = 1 }) -- Greater Court of Farondis Insignia
	self:AddItems(1900, 1, 8, 1000, { [153113] = 1 }) -- Demon's Soulstone
	self:AddQuest(1900, 1, 8, 42420, 1500)            -- Court of Farondis (Emissary)
	self:AddQuest(1900, 1, 8, 43179, 1500)            -- The Kirin Tor of Dalaran (Emissary)
	self:AddQuest(1900, 1, 8, Quest.world_quest, 75)
	self:AddQuest(1900, 1, 8, Quest.elite_world_quest, 250)

	-- Dreamweavers 1883
	self:AddItems(1883, 1, 8, 250, { [146936] = 1 })  -- Dreamweaver Insignia
	self:AddItems(1883, 1, 8, 250, { [146942] = 1 })  -- Dreamweaver Insignia (BoA)
	self:AddItems(1883, 1, 8, 1500, { [150926] = 1 }) -- Greater Dreamweaver Insignia
	self:AddItems(1883, 1, 8, 1000, { [153113] = 1 }) -- Demon's Soulstone
	self:AddQuest(1883, 1, 8, 42170, 1500)            -- The Dreamweavers (Emissary)
	self:AddQuest(1883, 1, 8, 43179, 1500)            -- The Kirin Tor of Dalaran (Emissary)
	self:AddQuest(1883, 1, 8, Quest.world_quest, 75)
	self:AddQuest(1883, 1, 8, Quest.elite_world_quest, 250)

	-- Highmountain Tribe 1828
	self:AddItems(1828, 1, 8, 250, { [146938] = 1 })  -- Highmountain Tribe Insignia
	self:AddItems(1828, 1, 8, 250, { [146944] = 1 })  -- Highmountain Tribe Insignia (BoA)
	self:AddItems(1828, 1, 8, 1500, { [150928] = 1 }) -- Greater Highmountain Tribe Insignia
	self:AddItems(1828, 1, 8, 1000, { [153113] = 1 }) -- Demon's Soulstone
	self:AddQuest(1828, 1, 8, 42233, 1500)            -- Highmountain Tribes (Emissary)
	self:AddQuest(1828, 1, 8, 43179, 1500)            -- The Kirin Tor of Dalaran (Emissary)
	self:AddQuest(1828, 1, 8, Quest.world_quest, 75)
	self:AddQuest(1828, 1, 8, Quest.elite_world_quest, 250)
	self:AddMob(1828, 1, 8, "Narrok (Worm-Sommelier)", 250, zone.Highmountain)

	-- The Nightfallen 1859
	self:AddItems(1859, 1, 8, 250, { [146940] = 1 })  -- Nightfallen Insignia
	self:AddItems(1859, 1, 8, 250, { [146946] = 1 })  -- Nightfallen Insignia (BoA)
	self:AddItems(1859, 1, 8, 1500, { [150930] = 1 }) -- Greater Nightfallen Insignia
	self:AddItems(1859, 1, 8, 1000, { [153113] = 1 }) -- Demon's Soulstone
	self:AddQuest(1859, 1, 8, 42421, 1500)            -- The Nightfallen (Emissary)
	self:AddQuest(1859, 1, 8, 43179, 750)             -- The Kirin Tor of Dalaran (Emissary)
	self:AddQuest(1859, 1, 8, 43943, 425)             -- Withered Army Training
	self:AddQuest(1859, 1, 8, Quest.world_quest, 75)
	self:AddQuest(1859, 1, 8, Quest.elite_world_quest, 250)

	-- The Wardens 1894
	self:AddItems(1894, 1, 8, 250, { [146939] = 1 })  -- Wardens Insignia
	self:AddItems(1894, 1, 8, 250, { [146945] = 1 })  -- Wardens Insignia (BoA)
	self:AddItems(1894, 1, 8, 1500, { [150929] = 1 }) -- Greater Wardens Insignia
	self:AddItems(1894, 1, 8, 1000, { [153113] = 1 }) -- Demon's Soulstone
	self:AddQuest(1894, 1, 8, 42422, 1500)            -- The Wardens (Emissary)
	self:AddQuest(1894, 1, 8, 43179, 1500)            -- The Kirin Tor of Dalaran (Emissary)
	self:AddQuest(1894, 1, 8, Quest.world_quest, 150)
	self:AddQuest(1894, 1, 8, Quest.elite_world_quest, 250)

	-- Valarjar 1948
	self:AddItems(1948, 1, 8, 250, { [146935] = 1 })  -- Valarjar Insignia
	self:AddItems(1948, 1, 8, 250, { [146941] = 1 })  -- Valarjar Insignia (BoA)
	self:AddItems(1948, 1, 8, 1500, { [150925] = 1 }) -- Greater Valarjar Insignia
	self:AddItems(1948, 1, 8, 1000, { [153113] = 1 }) -- Demon's Soulstone
	self:AddQuest(1948, 1, 8, 42234, 1500)            -- The Valarjar (Emissary)
	self:AddQuest(1948, 1, 8, 43179, 1500)            -- The Kirin Tor of Dalaran (Emissary)
	self:AddQuest(1948, 1, 8, Quest.world_quest, 75)
	self:AddQuest(1948, 1, 8, Quest.elite_world_quest, 250)

	-- Armies of Legionfall 2045
	self:AddItems(2045, 1, 8, 250, { [146950] = 1 })  -- Legionfall Insignia
	self:AddItems(2045, 1, 8, 250, { [146949] = 1 })  -- Legionfall Insignia (BoA)
	self:AddItems(2045, 1, 8, 1500, { [147727] = 1 }) -- Greater Legionfall Insignia
	self:AddItems(2045, 1, 8, 1000, { [153113] = 1 }) -- Demon's Soulstone
	self:AddQuest(2045, 1, 8, 48641, 1500)            -- Armies of Legionfall (Emissary)
	self:AddQuest(2045, 1, 8, 46247, 150)             -- Defending Broken Isles / Construction Supplies
	self:AddQuest(2045, 1, 8, Quest.world_quest, 75)
	self:AddQuest(2045, 1, 8, Quest.elite_world_quest, 250)

	-- Army of the Light 2165
	self:AddItems(2165, 1, 8, 250, { [152957] = 1 })  -- Army of the Light Insignia
	self:AddItems(2165, 1, 8, 250, { [152958] = 1 })  -- Army of the Light Insignia (BoA)
	self:AddItems(2165, 1, 8, 1500, { [152955] = 1 }) -- Greater Army of the Light Insignia
	self:AddItems(2165, 1, 8, 1000, { [153113] = 1 }) -- Demon's Soulstone
	self:AddQuest(2165, 1, 8, 48639, 1500)            -- Army of the Light (Emissary)
	self:AddQuest(2165, 1, 8, 48830, 1000)            -- Fuel of a Doomed World (Weekly)
	self:AddQuest(2165, 1, 8, 48929, 1000)            -- Invasion Onslaught (Weekly)
	self:AddQuest(2165, 1, 8, Quest.world_quest, 75)
	self:AddQuest(2165, 1, 8, Quest.elite_world_quest, 250)

	-- Argussian Reach 2170
	self:AddItems(2170, 1, 8, 250, { [152960] = 1 })  -- Argussian Reach Insignia
	self:AddItems(2170, 1, 8, 250, { [152959] = 1 })  -- Argussian Reach Insignia (BoA)
	self:AddItems(2170, 1, 8, 1500, { [152961] = 1 }) -- Greater Argussian Reach Insignia
	self:AddItems(2170, 1, 8, 1000, { [153113] = 1 }) -- Demon's Soulstone
	self:AddQuest(2170, 1, 8, 48642, 1500)            -- Argussian Reach (Emissary)
	self:AddQuest(2170, 1, 8, 48830, 1000)            -- Fuel of a Doomed World (Weekly)
	self:AddQuest(2170, 1, 8, 48929, 1000)            -- Invasion Onslaught (Weekly)
	self:AddQuest(2170, 1, 8, Quest.world_quest, 75)
	self:AddQuest(2170, 1, 8, Quest.elite_world_quest, 250)

	-- Conjurer Margoss 1975
	self:AddItems(1975, 1, 8, 50, { [138777] = 1 })   -- Drowned Mana (1x)
	self:AddItems(1975, 1, 8, 500, { [138777] = 10 }) -- Drowned Mana (10x)

	-- Fisherfriends of the Isles (2097..2102)
	self:AddItems(2097, 1, 8, 75, { [146848] = 1 })   -- Ilyssia of the Waters: Fragmented Enchantment
	self:AddItems(2098, 1, 8, 75, { [146959] = 1 })   -- Keeper Raynae: Corrupted Globule
	self:AddItems(2099, 1, 8, 75, { [146960] = 1 })   -- Akule Riverhorn: Ancient Totem Fragment
	self:AddItems(2100, 1, 8, 75, { [146961] = 1 })   -- Corbyn: Shiny Bauble
	self:AddItems(2101, 1, 8, 75, { [146962] = 1 })   -- Sha'leth: Golden Minnow
	self:AddItems(2102, 1, 8, 75, { [146963] = 1 })   -- Impus: Desecrated Seaweed

	-- Talon's Vengeance 2018
	self:AddItems(2018, 1, 8, 100, { [142363] = 1 })  -- Mark of Prey

	-- Chromie 2135
	self:AddGeneral(2135, 1, 8, "The Deaths of Chromie", 500, "The Deaths of Chromie", "Awarded via Sands of Time in The Deaths of Chromie scenario.", nil, 0)
end)

