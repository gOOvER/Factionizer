----------------------------------------------------------
-- Factionizer - Classic Forever & Season of Discovery  --
-- (Interface 11508 / 11509 / 16001)                    --
----------------------------------------------------------

local FIZ = _G.FIZ

FIZ:RegisterContentModule("Forever", function(self, zone, mob, quest, items, instance)
	local isDE = (GetLocale and GetLocale() == "deDE") or false
	local function T(en, de)
		return isDE and de or en
	end

	-- Helper to register localized aliases -> canonical faction key
	local function MapAliases(canonical, aliases)
		if not FIZ_FactionMapping then
			FIZ_FactionMapping = {}
		end
		local target = string.lower(canonical)
		FIZ_FactionMapping[target] = target
		if type(aliases) == "table" then
			for _, alias in ipairs(aliases) do
				if alias and alias ~= "" then
					FIZ_FactionMapping[string.lower(alias)] = target
				end
			end
		end
	end

	-- Helper to register faction gains under both numeric ID (if available in DBC) and string name
	local function ResolveTargets(factionID, englishName, aliases)
		MapAliases(englishName, aliases)
		local targets = { englishName }
		if factionID then
			table.insert(targets, factionID)
			local byID = self:GetFactionNameByID(factionID)
			if byID and byID ~= "" and string.lower(byID) ~= string.lower(englishName) then
				table.insert(targets, byID)
			end
		end
		return targets
	end

	-- Classic Forever Capital City Alias Mappings (e.g. Gnomeregangnome / Stormwind / Ironforge on deDE client)
	MapAliases("Gnomeregan", { "Gnomeregangnome", "Gnomeregan Exiles", "Gnomeregan-Exilanten" })
	MapAliases("Stormwind", { "Sturmwind", "Stormwind City" })
	MapAliases("Ironforge", { "Eisenschmiede" })
	MapAliases("Undercity", { "Unterstadt" })
	MapAliases("Thunder Bluff", { "Donnerfels" })
	MapAliases("Silvermoon City", { "Silbermond", "Silvermoon" })
	MapAliases("Exodar", { "Die Exodar", "The Exodar" })

	----------------------------------------------------------
	-- Season of Discovery / Classic Era (1.15.x) Factions  --
	----------------------------------------------------------

	-- Azeroth Commerce Authority (Alliance - Faction ID 2586)
	for _, fac in ipairs(ResolveTargets(2586, "Azeroth Commerce Authority", {
		"Handelsbehörde von Azeroth",
		"Autorité commerciale d'Azeroth",
		"Autoridad de Comercio de Azeroth",
	})) do
		self:AddQuest(fac, 4, 5, T("Waylaid Supplies: Tier 1 (Level 1-25)", "Abgefangene Vorräte: Stufe 1 (Stufe 1-25)"), 300)
		self:AddQuest(fac, 4, 6, T("Waylaid Supplies: Tier 2 (Level 25-40)", "Abgefangene Vorräte: Stufe 2 (Stufe 25-40)"), 500)
		self:AddQuest(fac, 4, 7, T("Waylaid Supplies: Tier 3 (Level 40-50)", "Abgefangene Vorräte: Stufe 3 (Stufe 40-50)"), 700)
		self:AddQuest(fac, 4, 8, T("Waylaid Supplies: Tier 4 (Level 50-60)", "Abgefangene Vorräte: Stufe 4 (Stufe 50-60)"), 1000)
		self:AddQuest(fac, 6, 8, T("Craftsman's Writ Turn-in", "Handwerkererlass abgeben"), 500)
		self:AddGeneral(fac, 4, 8, T("Waylaid Supplies & Craftsman's Writs", "Abgefangene Vorräte & Handwerkererlasse"), 500,
			T("Azeroth Commerce Authority", "Handelsbehörde von Azeroth"),
			T("Turn in filled Waylaid Supply Crates and Craftsman's Writs to Azeroth Commerce Authority quartermasters in Stormwind, Ironforge, and Darnassus.",
			  "Gib gefüllte Kisten mit abgefangenen Vorräten und Handwerkererlasse bei den Rüstmeistern der Handelsbehörde in Sturmwind, Eisenschmiede und Darnassus ab."))
	end

	-- Durotar Supply and Logistics (Horde - Faction ID 2587)
	for _, fac in ipairs(ResolveTargets(2587, "Durotar Supply and Logistics", {
		"Versorgung und Logistik von Durotar",
		"Logistique et ravitaillement de Durotar",
		"Suministros y Logística de Durotar",
	})) do
		self:AddQuest(fac, 4, 5, T("Waylaid Supplies: Tier 1 (Level 1-25)", "Abgefangene Vorräte: Stufe 1 (Stufe 1-25)"), 300)
		self:AddQuest(fac, 4, 6, T("Waylaid Supplies: Tier 2 (Level 25-40)", "Abgefangene Vorräte: Stufe 2 (Stufe 25-40)"), 500)
		self:AddQuest(fac, 4, 7, T("Waylaid Supplies: Tier 3 (Level 40-50)", "Abgefangene Vorräte: Stufe 3 (Stufe 40-50)"), 700)
		self:AddQuest(fac, 4, 8, T("Waylaid Supplies: Tier 4 (Level 50-60)", "Abgefangene Vorräte: Stufe 4 (Stufe 50-60)"), 1000)
		self:AddQuest(fac, 6, 8, T("Craftsman's Writ Turn-in", "Handwerkererlass abgeben"), 500)
		self:AddGeneral(fac, 4, 8, T("Waylaid Supplies & Craftsman's Writs", "Abgefangene Vorräte & Handwerkererlasse"), 500,
			T("Durotar Supply and Logistics", "Versorgung und Logistik von Durotar"),
			T("Turn in filled Waylaid Supply Crates and Craftsman's Writs to Durotar Supply and Logistics quartermasters in Orgrimmar, Thunder Bluff, and Undercity.",
			  "Gib gefüllte Kisten mit abgefangenen Vorräten und Handwerkererlasse bei den Rüstmeistern in Orgrimmar, Donnerfels und Unterstadt ab."))
	end

	-- Emerald Wardens (Neutral - Faction ID 2641)
	for _, fac in ipairs(ResolveTargets(2641, "Emerald Wardens", {
		"Smaragdwächter",
		"Gardiens d'émeraude",
		"Celadores Esmeralda",
	})) do
		self:AddQuest(fac, 4, 8, T("Nightmare Incursion Daily Quest", "Tägliche Quest der Alptraum-Inkursionen"), 1000)
		self:AddQuest(fac, 4, 7, T("Nightmare Incursion Mission (Duskwood / Ashenvale)", "Alptraum-Inkursion (Dämmerwald / Eschental)"), 100)
		self:AddQuest(fac, 4, 8, T("Nightmare Incursion Mission (Feralas / The Hinterlands)", "Alptraum-Inkursion (Feralas / Hinterland)"), 150)
		self:AddGeneral(fac, 4, 8, T("Nightmare Incursions", "Alptraum-Inkursionen"), 150,
			T("Emerald Wardens", "Smaragdwächter"),
			T("Complete Nightmare Incursion envelopes and daily quests at the Emerald Dream portals in Duskwood, Ashenvale, Feralas, and The Hinterlands.",
			  "Schließe Aufträge und tägliche Quests der Alptraum-Inkursionen an den Portalen des Smaragdgrünen Traums im Dämmerwald, Eschental, Feralas und Hinterland ab."))
	end

	----------------------------------------------------------
	-- Classic Forever (1.16 / 16001) New Factions          --
	----------------------------------------------------------

	-- Nightclaw Druids / Druiden der Nachtklaue (Zephras Isle - Shadowgale Forest)
	for _, fac in ipairs(ResolveTargets(nil, "Nightclaw Druids", {
		"Druiden der Nachtklaue",
		"Nachtklauendruiden",
		"Druides de la Griffe-de-nuit",
	})) do
		self:AddQuest(fac, 4, 8, T("Shadowgale Forest Storyline Quest", "Story-Quest im Schattensturmwald (Insel Zephras)"), 250)
		self:AddQuest(fac, 4, 8, T("Shadowgale Forest Elite Quest", "Elite-Quest im Schattensturmwald"), 500)
		self:AddQuest(fac, 4, 8, T("Repeatable Trophy / Pelt Turn-in (Shadowgale Forest)", "Wiederholbare Trophäen-/Pelzabgabe (Schattensturmwald)"), 250)
		self:AddMob(fac, 4, 7, T("Corrupted Wildlife & Invaders", "Verderbte Wildtiere & Eindringlinge"), 10, zone.Shadowgale_Forest)
		self:AddGeneral(fac, 4, 8, T("Shadowgale Forest Quests & Turn-ins", "Quests & Abgaben im Schattensturmwald"), 250,
			T("Nightclaw Druids (Zephras Isle)", "Druiden der Nachtklaue (Insel Zephras)"),
			T("Gain reputation through the ~13 storyline quests in Shadowgale Forest on Zephras Isle and repeatable creature trophy/pelt turn-ins up to Exalted.",
			  "Erhalte Ruf durch die ca. 13 Story-Quests im Schattensturmwald auf der Insel Zephras sowie durch wiederholbare Trophäen- und Pelzabgaben bis Ehrfürchtig."))
	end

	-- Windshapers (Zephras Isle - Skyborne / Skywall)
	for _, fac in ipairs(ResolveTargets(nil, "Windshapers", {
		"Windformer",
		"Die Windformer",
		"Façonneurs du vent",
	})) do
		self:AddQuest(fac, 4, 8, T("Skyborne & Zephras Isle Storyline Quest", "Story-Quest auf der Insel Zephras"), 250)
		self:AddQuest(fac, 4, 8, T("Elemental & Totem Mastery Quest", "Elementar- & Totem-Prüfungsquest"), 350)
		self:AddQuest(fac, 4, 8, T("Repeatable Air Elemental Core Turn-in", "Wiederholbare Luftelementarkern-Abgabe"), 250)
		self:AddMob(fac, 4, 7, T("Rogue Air Elementals", "Abtrünnige Luftelementare"), 10, zone.Zephras_Isle)
		self:AddGeneral(fac, 4, 8, T("Zephras Isle & Skywall Activities", "Aktivitäten auf der Insel Zephras"), 250,
			T("Windshapers (Zephras Isle)", "Windformer (Insel Zephras)"),
			T("Reclusive Skyborne wind-masters on Zephras Isle. Gain reputation by completing Zephras Isle quests, shamanistic totem trials, and elemental turn-ins.",
			  "Zurückgezogene Windmeister auf der Insel Zephras. Erhalte Ruf durch Quests auf der Insel Zephras, schamanistische Totemprüfungen und Elementarabgaben."))
	end

	-- Barkskin Burrow (Mount Hyjal Furbolg Tribe - Starts Hostile / At War)
	for _, fac in ipairs(ResolveTargets(nil, "Barkskin Burrow", {
		"Borkenhautbau",
		"Borkenhautfeste",
		"Stamm der Borkenhäute",
		"Terrier des Écorce-peau",
	})) do
		self:AddQuest(fac, 1, 4, T("Furbolg Diplomacy & Peace Offering Quest", "Furbolg-Diplomatie & Friedensangebot-Quest"), 500)
		self:AddQuest(fac, 4, 8, T("Barkskin Burrow Storyline Quest", "Story-Quest im Borkenhautbau (Hyjal)"), 250)
		self:AddQuest(fac, 1, 8, T("Ceremonial Mastic / Corruption Cleansing Turn-in", "Zeremonienharz / Läuterungsabgabe"), 250)
		self:AddMob(fac, 1, 6, T("Corrupted Satyrs & Demon Invaders", "Verderbte Satyrn & Dämonische Eindringlinge"), 10, zone.Mount_Hyjal)
		self:AddGeneral(fac, 1, 8, T("Mount Hyjal Diplomacy & Turn-ins", "Diplomatie & Abgaben am Berg Hyjal"), 250,
			T("Barkskin Burrow (Mount Hyjal)", "Borkenhautbau (Berg Hyjal)"),
			T("Unbribable furbolgs of Mount Hyjal. Players begin At War/Hostile and earn their trust up to Exalted through diplomacy quests and Ceremonial Mastic turn-ins.",
			  "Unbestechliche Furbolgs vom Berg Hyjal. Spieler beginnen Feindselig/Im Krieg und erlangen ihr Vertrauen bis Ehrfürchtig durch Diplomatie-Quests und Abgaben."))
	end

	-- Bolder'ok Clan (Riverglades - Ogre Exiles)
	for _, fac in ipairs(ResolveTargets(nil, "Bolder'ok Clan", {
		"Klan der Bolder'ok",
		"Bolder'ok-Klan",
		"Bolder'okklan",
		"Clan Bolder'ok",
	})) do
		self:AddQuest(fac, 4, 8, T("Riverglades Bolder'ok Storyline Quest", "Bolder'ok-Story-Quest in den Flussauen"), 250)
		self:AddQuest(fac, 4, 8, T("Bolder'ok Boulder & War-Supply Turn-in", "Vorrats- & Felsbrockenabgabe der Bolder'ok"), 250)
		self:AddMob(fac, 4, 7, T("Twilight's Hammer Pursuers", "Verfolger des Schattenhammers"), 10, zone.Riverglades)
		self:AddGeneral(fac, 4, 8, T("Riverglades Quests & Bounties", "Quests & Kopfgelder in den Flussauen"), 250,
			T("Bolder'ok Clan (Riverglades)", "Klan der Bolder'ok (Flussauen)"),
			T("Former Twilight's Hammer ogres seeking a peaceful home in the Riverglades (Level 42+). Aid their settlement through storyline and repeatable supply quests.",
			  "Ehemalige Oger des Schattenhammers in den Flussauen (Stufe 42+). Unterstütze ihre Siedlung durch Story- und wiederholbare Vorratsquests."))
	end

	-- Brotherhood of the Horse (Riverglades - Farhold Keep)
	for _, fac in ipairs(ResolveTargets(nil, "Brotherhood of the Horse", {
		"Bruderschaft des Pferdes",
		"Bruderschaft der Reiter",
		"Confrérie du Cheval",
	})) do
		self:AddQuest(fac, 4, 8, T("Farhold Keep Storyline Quest", "Story-Quest der Fernwacht (Flussauen)"), 250)
		self:AddQuest(fac, 4, 8, T("Riverglades Cavalry Patrol & Escort", "Kavallerie-Patrouille & Eskorte in den Flussauen"), 250)
		self:AddQuest(fac, 4, 8, T("Farhold Steed & Forage Supply Turn-in", "Futter- & Reittier-Vorratsabgabe"), 250)
		self:AddGeneral(fac, 4, 8, T("Farhold Keep Quests & Cavalry Supplies", "Quests der Fernwacht & Kavallerievorräte"), 250,
			T("Brotherhood of the Horse (Riverglades)", "Bruderschaft des Pferdes (Flussauen)"),
			T("Renowned horsemen and traders stationed at Farhold Keep in the Riverglades. Complete regional quests and cavalry supply turn-ins to unlock mounts and gear.",
			  "Berühmte Reiter und Händler der Fernwacht in den Flussauen. Schließe regionale Quests und Vorratsabgaben ab, um Reittiere und Ausrüstung freizuschalten."))
	end

	-- Powderfuse / Powderfuse Cartel (Riverglades)
	for _, fac in ipairs(ResolveTargets(nil, "Powderfuse", {
		"Powderfuse Cartel",
		"Pulverlunte",
		"Kartell Pulverlunte",
	})) do
		self:AddQuest(fac, 4, 8, T("Riverglades Trade & Salvage Quest", "Handels- & Bergungsquest in den Flussauen"), 250)
		self:AddQuest(fac, 4, 8, T("Repeatable Explosives & Salvage Turn-in", "Wiederholbare Sprengstoff- & Bergungsabgabe"), 250)
		self:AddGeneral(fac, 4, 8, T("Riverglades Engineering & Trade Quests", "Ingenieurs- & Handelsquests in den Flussauen"), 250,
			T("Powderfuse (Riverglades)", "Pulverlunte (Flussauen)"),
			T("Goblin and dwarven salvagers operating in the Riverglades. Complete regional trade quests and engineering salvage turn-ins.",
			  "Goblinische und zwergische Bergungsspezialisten in den Flussauen. Schließe Handelsquests und Ingenieurs-Bergungsabgaben ab."))
	end

	-- Cenarion Scouts (Azeroth-wide Outdoor Events)
	for _, fac in ipairs(ResolveTargets(nil, "Cenarion Scouts", {
		"Späher des Cenarius",
		"Cenarische Späher",
		"Éclaireurs cénariens",
	})) do
		self:AddQuest(fac, 4, 8, T("Cenarion Scout Regional Outpost Quest", "Außenposten-Quest der Späher des Cenarius"), 250)
		self:AddQuest(fac, 4, 8, T("Outdoor Nature-Defense Event", "Dynamisches Naturverteidigungs-Ereignis"), 250)
		self:AddQuest(fac, 4, 8, T("Poacher & Defiler Bounty Turn-in", "Kopfgeldabgabe gegen Wilderer & Schänder"), 150)
		self:AddGeneral(fac, 4, 8, T("Dynamic Outdoor Events Across Azeroth", "Dynamische Außenwelt-Ereignisse in Azeroth"), 250,
			T("Cenarion Scouts", "Späher des Cenarius"),
			T("Proactive nature advocates operating across multiple zones in Azeroth. Participate in dynamic outdoor nature-defense events and outpost quests.",
			  "Aktive Naturschützer in ganz Azeroth. Nimm an dynamischen Naturverteidigungs-Ereignissen und Außenposten-Quests teil."))
	end

	-- The Watchers (Night Elf Marshals & Underground Prison Network)
	for _, fac in ipairs(ResolveTargets(nil, "The Watchers", {
		"Watchers",
		"Die Wächter",
		"Die Behüter",
		"Les Gardiens",
	})) do
		self:AddQuest(fac, 4, 8, T("Warden Marshal Bounty & Investigation Quest", "Kopfgeld- & Ermittlungsquest der Wächter"), 250)
		self:AddQuest(fac, 4, 8, T("Underground Barrow Prison Dungeon Quest", "Dungeon-Quest im unterirdischen Grabhügel-Gefängnis"), 500)
		self:AddQuest(fac, 4, 8, T("Escaped Prisoner Signet Turn-in", "Siegelabgabe entflohener Gefangener"), 250)
		self:AddGeneral(fac, 4, 8, T("Prison Network Quests & Bounties", "Gefängnisnetzwerk-Quests & Kopfgelder"), 250,
			T("The Watchers", "Die Wächter"),
			T("Night Elf jailers and marshals guarding the underground prison network across Kalimdor. Complete fugitive bounties and prison dungeon quests.",
			  "Nachtelfische Kerkermeister und Marschälle in Kalimdor. Schließe Kopfgeldjagden auf Flüchtige und Gefängnis-Dungeonquests ab."))
	end

	-- Theramore Expeditionary Force (Alliance Battleground Faction - Darkspear Islands)
	for _, fac in ipairs(ResolveTargets(nil, "Theramore Expeditionary Force", {
		"Expeditionskorps von Theramore",
		"Streitkräfte von Theramore",
		"Corps expéditionnaire de Theramore",
	})) do
		self:AddQuest(fac, 4, 8, T("Darkspear Islands Battleground Victory / Mark Turn-in", "Sieg / Ehrenzeichen-Abgabe der Dunkelspeerinseln"), 150)
		self:AddGeneral(fac, 4, 8, T("Darkspear Islands Battleground (15v15)", "Schlachtfeld: Dunkelspeerinseln (15v15)"), 200,
			T("Theramore Expeditionary Force (Alliance PvP)", "Expeditionskorps von Theramore (Allianz-PvP)"),
			T("Gain reputation in the 15v15 Darkspear Islands Battleground (Levels 30-60) by capturing flags, holding control points, and turning in battleground marks.",
			  "Erhalte Ruf im 15v15-Schlachtfeld Dunkelspeerinseln (Stufe 30-60) durch das Erobern von Flaggen, Halten von Kontrollpunkten und Abgeben von Ehrenzeichen."))
	end

	-- Darkspear Raiders (Horde Battleground Faction - Darkspear Islands)
	for _, fac in ipairs(ResolveTargets(nil, "Darkspear Raiders", {
		"Räuber der Dunkelspeere",
		"Dunkelspeerräuber",
		"Écumeurs Sombrelance",
	})) do
		self:AddQuest(fac, 4, 8, T("Darkspear Islands Battleground Victory / Mark Turn-in", "Sieg / Ehrenzeichen-Abgabe der Dunkelspeerinseln"), 150)
		self:AddGeneral(fac, 4, 8, T("Darkspear Islands Battleground (15v15)", "Schlachtfeld: Dunkelspeerinseln (15v15)"), 200,
			T("Darkspear Raiders (Horde PvP)", "Räuber der Dunkelspeere (Horde-PvP)"),
			T("Gain reputation in the 15v15 Darkspear Islands Battleground (Levels 30-60) by capturing flags, holding control points, and turning in battleground marks.",
			  "Erhalte Ruf im 15v15-Schlachtfeld Dunkelspeerinseln (Stufe 30-60) durch das Erobern von Flaggen, Halten von Kontrollpunkten und Abgeben von Ehrenzeichen."))
	end

	----------------------------------------------------------
	-- Classic Forever Adaptations of Classic+ Factions     --
	-- (Loaded on Classic clients < 20000 so they don't     --
	--  collide with Wrath/Cataclysm versions on Retail)    --
	----------------------------------------------------------
	local tocVersion = select(4, GetBuildInfo()) or 0
	if tocVersion < 20000 then
		-- Guardians of Hyjal (Forever Mount Hyjal Zone & Level 60 Endgame)
		for _, fac in ipairs(ResolveTargets(1158, "Guardians of Hyjal", {
			"Wächter des Hyjal",
			"Gardiens d'Hyjal",
		})) do
			self:AddQuest(fac, 4, 8, T("Mount Hyjal Storyline Quest", "Story-Quest am Berg Hyjal"), 250)
			self:AddQuest(fac, 5, 8, T("Artisan's Tier Crafting Commission", "Handwerksauftrag am Berg Hyjal"), 350)
			self:AddQuest(fac, 4, 8, T("World Tree Defense Daily / Repeatable", "Wiederholbare Verteidigung des Weltenbaums"), 250)
			self:AddMob(fac, 4, 8, T("Burning Legion & Twilight Invaders (Mount Hyjal)", "Eindringlinge der Brennenden Legion & des Schattenhammers"), 15, zone.Mount_Hyjal)
			self:AddGeneral(fac, 4, 8, T("Mount Hyjal Quests & Level 60 Dungeon Runs", "Quests am Berg Hyjal & Stufe-60-Dungeons"), 250,
				T("Guardians of Hyjal (Classic Forever)", "Wächter des Hyjal (Classic Forever)"),
				T("Complete quests across Mount Hyjal, Artisan's Tier crafting commissions, and level 60 dungeon runs.",
				  "Schließe Quests am Berg Hyjal, Handwerksaufträge und Stufe-60-Dungeons ab."))
		end

		-- Kirin Tor (Forever Dalaran Regional Hub)
		for _, fac in ipairs(ResolveTargets(1090, "Kirin Tor", {
			"Kirin Tor",
		})) do
			self:AddQuest(fac, 4, 8, T("Dalaran & Ambermill Storyline Quest", "Story-Quest um Dalaran &Mühlenbern"), 250)
			self:AddQuest(fac, 4, 8, T("Arcane Research & Tome Turn-in", "Arkane Forschung & Foliantenabgabe"), 250)
			self:AddGeneral(fac, 4, 8, T("Dalaran Regional Quests & Arcane Turn-ins", "Regionale Quests um Dalaran & Arkane Abgaben"), 250,
				T("Kirin Tor (Classic Forever)", "Kirin Tor (Classic Forever)"),
				T("Aid the mages of the Kirin Tor around Dalaran and Hillsbrad/Silverpine through regional storyline quests and arcane research turn-ins.",
				  "Unterstütze die Magier der Kirin Tor rund um Dalaran, das Vorgebirge des Hügellands und den Silberwald durch Story-Quests und arkane Forschungsabgaben."))
		end

		-- The Earthen Ring / Earthen Ring (Forever Zephras Isle & Kalimdor/EK)
		for _, fac in ipairs(ResolveTargets(1135, "The Earthen Ring", {
			"Earthen Ring",
			"Der Irdene Ring",
			"Irdener Ring",
			"Le Cercle terrestre",
		})) do
			self:AddQuest(fac, 4, 8, T("Zephras Isle & Elemental Harmony Quest", "Quest zur Elementarharmonie (Insel Zephras)"), 250)
			self:AddQuest(fac, 4, 8, T("Elemental Essence Turn-in", "Abgabe von Elementaressenzen"), 250)
			self:AddGeneral(fac, 4, 8, T("Zephras Isle & Azeroth Elemental Quests", "Elementar-Quests auf der Insel Zephras & in Azeroth"), 250,
				T("The Earthen Ring (Classic Forever)", "Der Irdene Ring (Classic Forever)"),
				T("Restore elemental balance on Zephras Isle and across Azeroth through Earthen Ring quests and elemental essence turn-ins.",
				  "Stelle das elementare Gleichgewicht auf der Insel Zephras und in Azeroth durch Quests des Irdenen Rings und Elementaressenz-Abgaben wieder her."))
		end
	end

	-- The High Order / Der Hohe Orden (Faction ID 2779 - Classic Forever)
	for _, fac in ipairs(ResolveTargets(2779, "The High Order", {
		"Der Hohe Orden",
		"Hoher Orden",
		"Le Haut Ordre",
		"La Alta Orden",
	})) do
		self:AddQuest(fac, 4, 8, T("High Order Campaign & Sanctum Quest", "Kampagnen- & Sanktumsquest des Hohen Ordens"), 250)
		self:AddQuest(fac, 4, 8, T("High Order Daily / Repeatable Commendation", "Tägliche / Wiederholbare Belobigung des Hohen Ordens"), 150)
		self:AddQuest(fac, 4, 8, T("Insignia / Relic of the High Order Turn-in", "Insignien- / Reliktabgabe des Hohen Ordens"), 250)
		self:AddInstance(fac, 4, 8, T("Classic Forever Level 60 Dungeons", "Classic Forever Stufe-60-Dungeons"), 300, false)
		self:AddGeneral(fac, 4, 8, T("High Order Quests, Bounties & Turn-ins", "Quests, Kopfgelder & Abgaben des Hohen Ordens"), 250,
			T("The High Order / Der Hohe Orden", "Der Hohe Orden"),
			T("Earn reputation with The High Order (Der Hohe Orden) by completing order campaign quests, regional bounties, dungeon objectives, and turning in High Order insignias.",
			  "Erhalte Ruf beim Hohen Orden durch das Abschließen von Ordenskampagnen-Quests, regionalen Kopfgeldern, Dungeon-Aufträgen und das Abgeben von Insignien."))
	end
end)

