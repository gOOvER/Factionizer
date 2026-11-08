----------------------------------------------------------
-- Factionizer - Warlords of Draenor (6.x) Content      --
----------------------------------------------------------

local FIZ = _G.FIZ

FIZ:RegisterContentModule("WoD", function(self, zone, mob, Quest, items, instance)
	if FIZ_IsAlliance then
		-- Council of Exarchs 1731
		self:AddItems(1731, 1, 8, 1000, { [128315] = 1 }) -- Medallion of the Legion
		self:AddItems(1731, 1, 8, 300, { [167929] = 1 })  -- Commendation of the Council of Exarchs (Timewalking)
		self:AddMob(1731, 1, 7, "Invasive Shambler", 500, zone.Talador)
		self:AddMob(1731, 1, 7, "Phantom Pearltusk", 500, zone.Shadowmoon_Valley)
		self:AddMob(1731, 1, 7, "Searing Ravager", 500, zone.Talador)
		self:AddMob(1731, 1, 8, "Malgosh Shadowkeeper", 50, zone.Shadowmoon_Valley)
		self:AddMob(1731, 1, 8, "Sargerei Demonlord", 16, zone.Shadowmoon_Valley)
		self:AddMob(1731, 1, 8, "Void Beast", 16, zone.Spires_of_Arak)
		self:AddMob(1731, 1, 8, "Void Spawn", 16, zone.Spires_of_Arak)
		self:AddMob(1731, 1, 8, "Darkwing Rider", 8, zone.Shadowmoon_Valley)
		self:AddMob(1731, 1, 8, "Eldermoss", 8, zone.Shadowmoon_Valley)
		self:AddMob(1731, 1, 8, "Invokaz", 8, zone.Shadowmoon_Valley)
		self:AddMob(1731, 1, 8, "Nightshade Consort", 8, zone.Shadowmoon_Valley)
		self:AddMob(1731, 1, 8, "Ra'ka Bloodspear", 8, zone.Shadowmoon_Valley)
		self:AddMob(1731, 1, 8, "Razz Ricketroz", 8, zone.Shadowmoon_Valley)
		self:AddMob(1731, 1, 8, "Sargerei Darkblade", 8, zone.Shadowmoon_Valley)
		self:AddMob(1731, 1, 8, "Shadowmoon Deathcaller", 8, zone.Spires_of_Arak)
		self:AddMob(1731, 1, 8, "Soulbinder Zamaya", 8, zone.Shadowmoon_Valley)
		self:AddMob(1731, 1, 8, "Sargerei Acolyte, Binder, Demonspeaker & Worker", 5, zone.Shadowmoon_Valley)
		self:AddMob(1731, 1, 8, "Shadowmoon Defiler, Enslaver, Void Augur & Warrior", 5, zone.Spires_of_Arak)

		-- Sha'tari Defense 1710
		self:AddItems(1710, 1, 8, 1000, { [128315] = 1 }) -- Medallion of the Legion
		self:AddItems(1710, 1, 8, 300, { [167930] = 1 })  -- Commendation of the Sha'tari Defense (Timewalking)
		self:AddMob(1710, 1, 8, "Archmagus Tekar", 50, zone.Talador)
		self:AddMob(1710, 1, 8, "Grom'kar Warbeast", 22, zone.Talador)
		self:AddMob(1710, 1, 8, "Grom'kar Sharpshooter", 19, zone.Talador)
		self:AddMob(1710, 1, 8, "Grom'kar Siegebreaker", 19, zone.Talador)
		self:AddMob(1710, 1, 8, "Rune Ritualist", 16, zone.Talador)
		self:AddMob(1710, 1, 8, "Sargerei Fiendmaster", 16, zone.Talador)
		self:AddMob(1710, 1, 8, "Sargerei Destructor, Discordant, Fiendspeaker, Ritualist & Soulspewer", 8, zone.Talador)
		self:AddMob(1710, 1, 8, "Grom'kar Blademaster, Bulwark, Deadeye & Punisher", 5, zone.Talador)

		-- Wrynn's Vanguard 1682
		self:AddItems(1682, 1, 8, 1000, { [128315] = 1 }) -- Medallion of the Legion
		self:AddItems(1682, 1, 8, 300, { [168017] = 1 })  -- Commendation of Wrynn's Vanguard (Timewalking)
		self:AddQuest(1682, 1, 8, 35689, 25)
		self:AddQuest(1682, 1, 8, 35264, 125)
		self:AddQuest(1682, 1, 8, 35639, 500)

		-- Hand of the Prophet 1847
		self:AddItems(1847, 1, 8, 1000, { [128315] = 1 }) -- Medallion of the Legion
		self:AddItems(1847, 1, 8, 300, { [167926] = 1 })  -- Commendation of the Hand of the Prophet (Timewalking)
		self:AddQuest(1847, 1, 8, 39568, 250)
		self:AddQuest(1847, 1, 8, 37891, 250)
		self:AddQuest(1847, 1, 8, 38440, 250)
		self:AddQuest(1847, 1, 8, 38250, 250)
		self:AddQuest(1847, 1, 8, 37968, 250)
		self:AddQuest(1847, 1, 8, 38585, 250)
		self:AddQuest(1847, 1, 8, 38046, 250)
		self:AddQuest(1847, 1, 8, 38045, 250)
		self:AddQuest(1847, 1, 8, 39567, 250)
		self:AddQuest(1847, 1, 8, 39569, 250)
		self:AddQuest(1847, 1, 8, 39586, 250)
		self:AddQuest(1847, 1, 8, 39581, 250)
		self:AddQuest(1847, 1, 8, 39573, 250)
		self:AddQuest(1847, 1, 8, 39574, 250)
		self:AddQuest(1847, 1, 8, 39570, 250)
	end

	if FIZ_IsHorde then
		-- Frostwolf Orcs 1445
		self:AddItems(1445, 1, 8, 1000, { [128315] = 1 }) -- Medallion of the Legion
		self:AddItems(1445, 1, 8, 300, { [167928] = 1 })  -- Commendation of the Frostwolf Orcs (Timewalking)
		self:AddMob(1445, 1, 7, "Grimfrost Drudge", 500, zone.Frostfire_Ridge)
		self:AddMob(1445, 1, 7, "Malevolent Breath", 500, zone.Frostfire_Ridge)
		self:AddMob(1445, 1, 8, "Gorg'ak the Lava Guzzler", 50, zone.Frostfire_Ridge)
		self:AddMob(1445, 1, 8, "Jabberjaw", 50, zone.Frostfire_Ridge)
		self:AddMob(1445, 1, 8, "Moltnoma", 50, zone.Frostfire_Ridge)
		self:AddMob(1445, 1, 8, "Slogtusk the Corpse-Eater", 50, zone.Frostfire_Ridge)
		self:AddMob(1445, 1, 8, "Son of Goramal", 50, zone.Frostfire_Ridge)
		self:AddMob(1445, 1, 8, "Grom'kar Pulverizer", 16, zone.Frostfire_Ridge)
		self:AddMob(1445, 1, 8, "Bloodmaul Bonecrusher", 16, zone.Frostfire_Ridge)
		self:AddMob(1445, 1, 8, "Icecrag Mountainbreaker", 16, zone.Frostfire_Ridge)
		self:AddMob(1445, 1, 8, "Ak'ox the Slaughterer", 16, zone.Frostfire_Ridge)
		self:AddMob(1445, 1, 8, "Bloodmaul Geomancer, Magma Shaper & Taskmaster", 8, zone.Frostfire_Ridge)
		self:AddMob(1445, 1, 8, "Grom'kar Deadeye, Enforcer, Footsoldier, Shocktrooper & Warforger", 5, zone.Frostfire_Ridge)

		-- Laughing Skull Orcs 1708
		self:AddItems(1708, 1, 8, 1000, { [128315] = 1 }) -- Medallion of the Legion
		self:AddItems(1708, 1, 8, 300, { [167924] = 1 })  -- Commendation of the Laughing Skull Orcs (Timewalking)
		self:AddMob(1708, 1, 8, "Firestarter Grash", 60, zone.Gorgrond)
		self:AddMob(1708, 1, 8, "Basten", 19, zone.Gorgrond)
		self:AddMob(1708, 1, 8, "Gruesome Torturer", 19, zone.Gorgrond)
		self:AddMob(1708, 1, 8, "Hulking Brute", 19, zone.Gorgrond)
		self:AddMob(1708, 1, 8, "Iron Bloodburner, Cauterizer, Deadshot & Warden", 19, zone.Gorgrond)
		self:AddMob(1708, 1, 8, "Irontusk Trampler", 19, zone.Gorgrond)
		self:AddMob(1708, 1, 8, "Nultra", 19, zone.Gorgrond)
		self:AddMob(1708, 1, 8, "Iron Bulwark & Enforcer", 16, zone.Gorgrond)
		self:AddMob(1708, 1, 8, "Everbloom Shaper, Wasp & Waterspeaker", 5, zone.Gorgrond)

		-- Vol'jin's Spear 1681
		self:AddItems(1681, 1, 8, 1000, { [128315] = 1 }) -- Medallion of the Legion
		self:AddItems(1681, 1, 8, 300, { [168018] = 1 })  -- Commendation of Vol'jin's Spear (Timewalking)
		self:AddQuest(1681, 1, 8, 36024, 25)
		self:AddQuest(1681, 1, 8, 36026, 125)
		self:AddQuest(1681, 1, 8, 36032, 500)

		-- Vol'jin's Headhunters 1848
		self:AddItems(1848, 1, 8, 1000, { [128315] = 1 }) -- Medallion of the Legion
		self:AddItems(1848, 1, 8, 300, { [167927] = 1 })  -- Commendation of Vol'jin's Headhunters (Timewalking)
		self:AddQuest(1848, 1, 8, 37940, 250)
		self:AddQuest(1848, 1, 8, 38441, 250)
		self:AddQuest(1848, 1, 8, 38252, 250)
		self:AddQuest(1848, 1, 8, 38449, 250)
		self:AddQuest(1848, 1, 8, 38586, 250)
		self:AddQuest(1848, 1, 8, 38047, 250)
		self:AddQuest(1848, 1, 8, 38044, 250)
		self:AddQuest(1848, 1, 8, 39511, 250)
		self:AddQuest(1848, 1, 8, 39532, 250)
		self:AddQuest(1848, 1, 8, 39519, 250)
		self:AddQuest(1848, 1, 8, 39514, 250)
		self:AddQuest(1848, 1, 8, 39526, 250)
		self:AddQuest(1848, 1, 8, 39512, 250)
	end

	-- Neutral Draenor Factions
	-- Arakkoa Outcasts 1515
	self:AddItems(1515, 1, 8, 2500, { [117492] = 1 }) -- Relic of Rukhmar
	self:AddItems(1515, 1, 8, 1000, { [128315] = 1 }) -- Medallion of the Legion
	self:AddItems(1515, 1, 8, 300, { [167925] = 1 })  -- Commendation of the Arakkoa Outcasts (Timewalking)
	self:AddMob(1515, 1, 8, "Solar Magnifier", 50, zone.Spires_of_Arak)
	self:AddMob(1515, 1, 8, "Dread Raven", 16, zone.Spires_of_Arak)
	self:AddMob(1515, 1, 8, "Skyreach Dawnbreaker & Dreadtalon", 16, zone.Spires_of_Arak)
	self:AddMob(1515, 1, 8, "Deranged Plunderer & Amorphic Cognitor", 6, zone.Spires_of_Arak)
	self:AddMob(1515, 1, 8, "Apexis Sol-Mender, Highmaul Relic-Seeker & Skyreach Mobs", 5, zone.Spires_of_Arak)

	-- Steamwheedle Preservation Society 1711
	self:AddItems(1711, 1, 8, 1000, { [128315] = 1 }) -- Medallion of the Legion
	self:AddItems(1711, 1, 8, 350, { [118100] = 1 })  -- Highmaul Relic
	self:AddItems(1711, 1, 8, 12.5, { [118099] = 1 }) -- Gorian Artifact Fragment (250 rep per 20)
	self:AddItems(1711, 1, 8, 300, { [167932] = 1 })  -- Commendation of the Steamwheedle Preservation Society (Timewalking)
	self:AddQuest(1711, 1, 8, 37210, 500)
	self:AddQuest(1711, 1, 8, 37211, 500)
	self:AddQuest(1711, 1, 8, 37221, 500)
	self:AddQuest(1711, 1, 8, 37222, 500)
	self:AddQuest(1711, 1, 8, 37223, 500)
	self:AddQuest(1711, 1, 8, 37224, 500)
	self:AddQuest(1711, 1, 8, 37225, 500)
	self:AddQuest(1711, 1, 8, 37226, 500)
	self:AddQuest(1711, 1, 8, 37520, 500)

	-- Order of the Awakened 1849
	self:AddItems(1849, 1, 8, 1000, { [128315] = 1 }) -- Medallion of the Legion
	self:AddItems(1849, 1, 8, 300, { [167931] = 1 })  -- Commendation of the Order of the Awakened (Timewalking)
	self:AddQuest(1849, 1, 8, 39433, 1500)            -- Unseen Influence (Daily)

	-- The Saberstalkers 1850
	self:AddItems(1850, 1, 8, 1000, { [128315] = 1 }) -- Medallion of the Legion
	self:AddQuest(1850, 1, 8, 39565, 1500)            -- Rumble in the Jungle (Weekly)
	self:AddQuest(1850, 1, 8, 39529, 250)             -- Tooth and Claw (Daily)
	self:AddMob(1850, 1, 8, "Blackfang Saberon (Normal)", 25, zone.Tanaan_Jungle)
	self:AddMob(1850, 1, 8, "Blackfang Saberon (Rare)", 500, zone.Tanaan_Jungle)
end)

