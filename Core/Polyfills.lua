----------------------------------------------------------
-- Factionizer - Cross-Version WoW API Polyfills        --
----------------------------------------------------------

local FIZ = _G.FIZ

function FIZ:GetAddOnMetadata(addon, field)
	if C_AddOns and C_AddOns.GetAddOnMetadata then
		return C_AddOns.GetAddOnMetadata(addon, field)
	elseif _G.GetAddOnMetadata then
		return _G.GetAddOnMetadata(addon, field)
	end
	return nil
end

function FIZ:PlayCheckBoxSound(checked)
	if not PlaySound then return end
	if SOUNDKIT then
		PlaySound(checked and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
	else
		PlaySound(checked and 856 or 857)
	end
end

function FIZ:SetupDetailFrameBackdrop(frame)
	if not frame or not frame.SetBackdrop then return end
	frame:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
		tile = true,
		tileSize = 32,
		edgeSize = 32,
		insets = { left = 11, right = 12, top = 12, bottom = 11 },
	})
end

function FIZ:GetNumFactions()
	if C_Reputation and C_Reputation.GetNumFactions then
		return C_Reputation.GetNumFactions() or 0
	elseif FIZ_Orig_GetNumFactions then
		return FIZ_Orig_GetNumFactions() or 0
	elseif _G.GetNumFactions then
		return _G.GetNumFactions() or 0
	end
	return 0
end

local function UnpackFactionData(data)
	if not data then return nil end
	local name = data.name
	local description = data.description or ""
	local standingID = data.reaction or 4
	local barMin = data.currentReactionThreshold or 0
	local barMax = data.nextReactionThreshold or 0
	local barValue = data.currentStanding or 0
	local atWarWith = data.atWarWith or false
	local canToggleAtWar = data.canToggleAtWar or false
	local isHeader = data.isHeader or false
	local isCollapsed = data.isCollapsed or false
	local hasRep = data.isHeaderWithRep or false
	local isWatched = data.isWatched or false
	local isChild = data.isChild or false
	local factionID = data.factionID
	local hasBonusRepGain = data.hasBonusRepGain or false
	local canBeLFGBonus = false

	-- Major Faction (Renown) handling on Retail 10.0+ / 11.x / 12.x
	if factionID and C_Reputation and C_Reputation.IsMajorFaction and C_Reputation.IsMajorFaction(factionID) and C_MajorFactions and C_MajorFactions.GetMajorFactionData then
		local majorData = C_MajorFactions.GetMajorFactionData(factionID)
		if majorData then
			barMin = 0
			barMax = majorData.renownLevelThreshold or 2500
			local isCapped = C_MajorFactions.HasMaximumRenown and C_MajorFactions.HasMaximumRenown(factionID)
			barValue = isCapped and barMax or (majorData.renownReputationEarned or 0)
			standingID = 8
		end
	elseif factionID and C_GossipInfo and C_GossipInfo.GetFriendshipReputation then
		local friendInfo = C_GossipInfo.GetFriendshipReputation(factionID)
		if friendInfo and friendInfo.friendshipFactionID and friendInfo.friendshipFactionID > 0 then
			barMin = friendInfo.reactionThreshold or 0
			if friendInfo.nextThreshold then
				barMax = friendInfo.nextThreshold
				barValue = friendInfo.standing or barMin
				standingID = 5
			else
				barMax = friendInfo.maxRep or (barMin + 1)
				barValue = barMax
				standingID = 8
			end
		end
	end

	-- Paragon reputation handling on Retail 7.2+ / 11.x / 12.x
	if factionID and C_Reputation and C_Reputation.IsFactionParagon and C_Reputation.IsFactionParagon(factionID) and C_Reputation.GetFactionParagonInfo then
		local currentValue, threshold, _, hasRewardPending = C_Reputation.GetFactionParagonInfo(factionID)
		if currentValue and threshold and threshold > 0 then
			barMin = 0
			barMax = threshold
			barValue = currentValue % threshold
			if hasRewardPending then
				barValue = barValue + threshold
			end
		end
	end

	return name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild, factionID, hasBonusRepGain, canBeLFGBonus
end

function FIZ:GetRawFactionInfo(factionIndex)
	if not factionIndex or factionIndex <= 0 then return nil end
	if C_Reputation and C_Reputation.GetFactionDataByIndex then
		return UnpackFactionData(C_Reputation.GetFactionDataByIndex(factionIndex))
	elseif FIZ_Orig_GetFactionInfo then
		return FIZ_Orig_GetFactionInfo(factionIndex)
	elseif _G.GetFactionInfo then
		return _G.GetFactionInfo(factionIndex)
	end
	return nil
end

local FIZ_CityFactionNames_DE = {
	["Stormwind"] = "Sturmwind",
	["Stormwind City"] = "Sturmwind",
	["Ironforge"] = "Eisenschmiede",
	["Undercity"] = "Unterstadt",
	["Thunder Bluff"] = "Donnerfels",
	["Silvermoon City"] = "Silbermond",
	["Silvermoon"] = "Silbermond",
	["The Exodar"] = "Die Exodar",
	["Exodar"] = "Exodar",
	["Gnomeregan Exiles"] = "Gnomeregangnome",
	["Darkspear Trolls"] = "Dunkelspeertrolle",
	["Bilgewater Cartel"] = "Bilgewasserkartell",
	["Gilneas"] = "Gilneas",
	["Shattrath City"] = "Shattrath",
}

local function TranslateFactionDisplayName(name)
	if not name or not _G.GetLocale or _G.GetLocale() ~= "deDE" then
		return name
	end
	return FIZ_CityFactionNames_DE[name] or name
end

function FIZ:GetFactionInfo(factionIndex)
	local name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild, factionID, hasBonusRepGain, canBeLFGBonus = FIZ:GetRawFactionInfo(factionIndex)
	if not name then return nil end
	name = TranslateFactionDisplayName(name)
	local normMax = (barMax or 0) - (barMin or 0)
	local normCurrent = (barValue or 0) - (barMin or 0)
	if FIZ_Data and FIZ_Data.ShowMissing and isHeader and not hasRep and ((normMax - normCurrent) > 0) then
		name = name .. " (" .. (normMax - normCurrent) .. ")"
	end
	return name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild, factionID, hasBonusRepGain, canBeLFGBonus
end

function FIZ:GetFactionNameByID(factionID)
	if not factionID then return nil end
	if C_Reputation and C_Reputation.GetFactionDataByID then
		local data = C_Reputation.GetFactionDataByID(factionID)
		return data and TranslateFactionDisplayName(data.name) or nil
	elseif _G.GetFactionInfoByID then
		local name = _G.GetFactionInfoByID(factionID)
		return TranslateFactionDisplayName(name)
	end
	return nil
end

function FIZ:GetSelectedFaction()
	if C_Reputation and C_Reputation.GetSelectedFaction then
		return C_Reputation.GetSelectedFaction() or 0
	elseif _G.GetSelectedFaction then
		return _G.GetSelectedFaction() or 0
	end
	return 0
end

function FIZ:SetSelectedFaction(index)
	if C_Reputation and C_Reputation.SetSelectedFaction then
		C_Reputation.SetSelectedFaction(index or 0)
	elseif _G.SetSelectedFaction then
		_G.SetSelectedFaction(index or 0)
	end
end

function FIZ:ToggleAtWar(index)
	if not index or index <= 0 then return end
	if C_Reputation and C_Reputation.ToggleFactionAtWar then
		C_Reputation.ToggleFactionAtWar(index)
	elseif _G.FactionToggleAtWar then
		_G.FactionToggleAtWar(index)
	end
end

function FIZ:SetFactionInactive(index, inactive)
	if not index or index <= 0 then return end
	if C_Reputation and C_Reputation.SetFactionActive then
		C_Reputation.SetFactionActive(index, not inactive)
	elseif inactive and _G.SetFactionInactive then
		_G.SetFactionInactive(index)
	elseif (not inactive) and _G.SetFactionActive then
		_G.SetFactionActive(index)
	end
end

function FIZ:IsFactionInactive(index)
	if not index or index <= 0 then return false end
	if C_Reputation and C_Reputation.IsFactionActive then
		return not C_Reputation.IsFactionActive(index)
	elseif _G.IsFactionInactive then
		return _G.IsFactionInactive(index) and true or false
	end
	return false
end

function FIZ:SetWatchedFactionIndex(index)
	if C_Reputation and C_Reputation.SetWatchedFactionByIndex then
		C_Reputation.SetWatchedFactionByIndex(index or 0)
	elseif _G.SetWatchedFactionIndex then
		_G.SetWatchedFactionIndex(index or 0)
	end
end

function FIZ:ExpandFactionHeader(index)
	if C_Reputation and C_Reputation.ExpandFactionHeader then
		C_Reputation.ExpandFactionHeader(index)
	elseif FIZ_Orig_ExpandFactionHeader then
		FIZ_Orig_ExpandFactionHeader(index)
	elseif _G.ExpandFactionHeader then
		_G.ExpandFactionHeader(index)
	end
end

function FIZ:CollapseFactionHeader(index)
	if C_Reputation and C_Reputation.CollapseFactionHeader then
		C_Reputation.CollapseFactionHeader(index)
	elseif FIZ_Orig_CollapseFactionHeader then
		FIZ_Orig_CollapseFactionHeader(index)
	elseif _G.CollapseFactionHeader then
		_G.CollapseFactionHeader(index)
	end
end

function FIZ:GetFriendshipInfo(factionID)
	if not factionID then return nil end
	if C_GossipInfo and C_GossipInfo.GetFriendshipReputation then
		local info = C_GossipInfo.GetFriendshipReputation(factionID)
		if info and info.friendshipFactionID and info.friendshipFactionID > 0 then
			return info.friendshipFactionID, info.standing, info.maxRep, info.name, info.text, info.texture, info.reaction, info.reactionThreshold, info.nextThreshold
		end
		return nil
	elseif _G.GetFriendshipReputation then
		return _G.GetFriendshipReputation(factionID)
	end
	return nil
end

function FIZ:IsMajorFaction(factionID)
	if not factionID then return false end
	if C_Reputation and C_Reputation.IsMajorFaction then
		return C_Reputation.IsMajorFaction(factionID) and true or false
	end
	return false
end

local CLASSIC_QUEST_FALLBACK_DE = {
	[7801] = "Zusätzlicher Runenstoff",
	[7805] = "Zusätzlicher Runenstoff",
	[7806] = "Zusätzlicher Runenstoff",
	[7796] = "Zusätzlicher Runenstoff",
	[7831] = "Zusätzlicher Runenstoff",
	[7824] = "Zusätzlicher Runenstoff",
	[7822] = "Zusätzlicher Runenstoff",
	[7819] = "Zusätzlicher Runenstoff",
	[7818] = "Eine Spende Runenstoff",
	[7823] = "Eine Spende Runenstoff",
	[7386] = "Haufenweise Kristalle",
	[6881] = "Ivus der Waldfürst",
	[6943] = "Luftunterstützung von Ichman",
	[6942] = "Luftunterstützung von Vipore",
	[6941] = "Luftunterstützung von Slidore",
	[7027] = "Widderzaumzeug",
	[7026] = "Widderledernes Zaumzeug",
	[6781] = "Mehr Rüstungsfetzen",
	[7385] = "Eine Gallone Blut",
	[6801] = "Lokholar der Eislord",
	[6825] = "Luftunterstützung von Guse",
	[6826] = "Luftunterstützung von Jeztor",
	[6827] = "Luftunterstützung von Mulverick",
	[7002] = "Widderledernes Zaumzeug",
	[7001] = "Leere Ställe",
	[6741] = "Mehr Beute!",
	[4970] = "Frostsäblerverpflegung",
	[5201] = "Eindringlinge der Winterfelle",
	[5981] = "Tobende Riesen",
	[5402] = "Geißelsteine des Dieners",
	[5403] = "Geißelsteine des Eindringlings",
	[5404] = "Geißelsteine des Verderbers",
	[7070] = "Teile der Knochenwand",
	[7483] = "Buchband der Schnelligkeit",
	[7484] = "Buchband des Fokus",
	[7485] = "Buchband des Schutzes",
	[6641] = "Vorsha die Peitscherin",
	[6642] = "Gunst der Bruderschaft, Dunkeleisenerz",
	[6643] = "Gunst der Bruderschaft, Feuerkern",
	[6644] = "Gunst der Bruderschaft, Lavakern",
	[6645] = "Gunst der Bruderschaft, Kernleder",
	[6646] = "Gunst der Bruderschaft, Blut des Berges",
	[6701] = "Syndikatsemblem",
	[7737] = "Erlangte Anerkennung",
	[8195] = "Münzen der Zulian, Razzashi und Hakkari",
	[8238] = "Münzen der Gurubashi, Bleichborken und Blutfransen",
	[8239] = "Münzen der Sandwüter, Schädelspalter und Blutskalpe",
	[8249] = "Schrottkisten benötigt",
	[8319] = "Verschlüsselte Schattenhammertexte",
	[8466] = "Federn für Grazle",
	[8467] = "Federn für Nafien",
	[8469] = "Perlen für Salfa",
	[8554] = "Die Geißel der Westlichen Pestländer",
	[9259] = "Schattenhammertexte",
	[9266] = "Aus einer feindlichen Welt",
	[9267] = "Heilende Kräuter",
	[9268] = "Knochenspenden",
	[7905] = "Der Dunkelmond-Jahrmarkt",
	[7926] = "Der Dunkelmond-Jahrmarkt",
	[13662] = "Ein Geschenk eines Champions",
	[28395] = "Gefieder der Totenwaldfelle",
	[28396] = "Perlen der Geistwandler",
	[28523] = "Noch mehr Beute!",
	[28755] = "Knochen für die Knochenwand",
	[28756] = "Kampf um das Alteractal",
	[29035] = "Mehr Geißelsteine des Dieners",
	[29037] = "Mehr Geißelsteine des Eindringlings",
	[29038] = "Mehr Geißelsteine des Verderbers",
	[29040] = "Knochenspenden",
	[29433] = "Testet Eure Stärke",
	[29434] = "Behaltet den Ball im Auge",
	[29436] = "Schuss und Treffer!",
	[29438] = "Er schießt, er trifft!",
	[29443] = "Ein merkwürdiger Kristall",
	[29444] = "Ein exotisches Ei",
	[29445] = "Eine faszinierende Grimoire",
	[29446] = "Eine wundersame Waffe",
	[29451] = "Der Meisterstratege",
	[29455] = "Eine interessante Trophäe",
	[29456] = "Ein erbeutetes Banner",
	[29457] = "Das Abzeichen des Feindes",
	[29458] = "Das Tagebuch des Gefallenen",
	[29463] = "Der menschliche Kanonenkugel",
	[29464] = "Werkzeuge der Zunft",
	[29506] = "Eine sprudelnde Mischung",
	[29507] = "Spaß für die Kleinen",
	[29508] = "Babys brauchen Schuhe",
	[29509] = "Kräftige Kost",
	[29510] = "Weggeworfene Glücksbringer",
	[29511] = "Sprechende Tätowierungen",
	[29513] = "Augen auf das Ziel",
	[29514] = "Kräuter für die Heilung",
	[29515] = "Schreibt die Zukunft",
	[29516] = "Behaltet den glänzenden Schmuck",
	[29517] = "Augen auf den Preis",
	[29518] = "Reparatur der Geschütze",
	[29519] = "Gerben für den Jahrmarkt",
	[29520] = "Banner, überall Banner!",
	[29760] = "Grubenbauer",
	[29761] = "Replikate der Rüstungen",
}

local CLASSIC_QUEST_FALLBACK_EN = {
	[7801] = "Additional Runecloth",
	[7805] = "Additional Runecloth",
	[7806] = "Additional Runecloth",
	[7796] = "Additional Runecloth",
	[7831] = "Additional Runecloth",
	[7824] = "Additional Runecloth",
	[7822] = "Additional Runecloth",
	[7819] = "Additional Runecloth",
	[7818] = "A Donation of Runecloth",
	[7823] = "A Donation of Runecloth",
	[7386] = "Crystal Cluster",
	[6881] = "Ivus the Forest Lord",
	[6943] = "Ichman's Beacon",
	[6942] = "Vipore's Beacon",
	[6941] = "Slidore's Beacon",
	[7027] = "Ram Riding Harnesses",
	[7026] = "Ram Hide Harnesses",
	[6781] = "More Armor Scraps",
	[7385] = "A Gallon of Blood",
	[6801] = "Lokholar the Ice Lord",
	[6825] = "Guse's Beacon",
	[6826] = "Jeztor's Beacon",
	[6827] = "Mulverick's Beacon",
	[7002] = "Ram Hide Harnesses",
	[7001] = "Empty Stables",
	[6741] = "More Booty!",
	[4970] = "Frostsaber Provisions",
	[5201] = "Winterfall Intrusion",
	[5981] = "Rampaging Giants",
	[5402] = "Minion's Scourgestones",
	[5403] = "Invader's Scourgestones",
	[5404] = "Corruptor's Scourgestones",
	[7070] = "Fragments of the Bone Wall",
	[7483] = "Libram of Rapidity",
	[7484] = "Libram of Focus",
	[7485] = "Libram of Protection",
	[6641] = "Vorsha the Lasher",
	[6642] = "Favor Amongst the Brotherhood, Dark Iron Ore",
	[6643] = "Favor Amongst the Brotherhood, Fiery Core",
	[6644] = "Favor Amongst the Brotherhood, Lava Core",
	[6645] = "Favor Amongst the Brotherhood, Core Leather",
	[6646] = "Favor Amongst the Brotherhood, Blood of the Mountain",
	[6701] = "Syndicate Emblems",
	[7737] = "Gaining Acceptance",
	[8195] = "Zulian, Razzashi, and Hakkari Coins",
	[8238] = "Gurubashi, Vilebranch, and Witherbark Coins",
	[8239] = "Sandfury, Skullsplitter, and Bloodscalp Coins",
	[8249] = "Junkboxes Needed",
	[8319] = "Encrypted Twilight Texts",
	[8466] = "Feathers for Grazle",
	[8467] = "Feathers for Nafien",
	[8469] = "Beads for Salfa",
	[8554] = "The Scourge of the Western Plaguelands",
	[9259] = "Twilight Texts",
	[9266] = "Making Amends",
	[9267] = "Mending Old Wounds",
	[9268] = "War at Sea",
	[7905] = "The Darkmoon Faire",
	[7926] = "The Darkmoon Faire",
	[13662] = "A Worthy Weapon",
}

local ITEM_FALLBACK_DE = {
	[2589]  = "Leinenstoff",
	[2604]  = "Rote Farbstoffe",
	[3371]  = "Leere Phiole",
	[3466]  = "Starker Fluxus",
	[3857]  = "Kohle",
	[4306]  = "Seidenstoff",
	[4338]  = "Magiestoff",
	[11370] = "Dunkeleisenerz",
	[11382] = "Blut des Berges",
	[12840] = "Geißelstein des Dieners",
	[12841] = "Geißelstein des Eindringlings",
	[12843] = "Geißelstein des Verderbers",
	[12844] = "Ehrenabzeichen der Argentumdämmerung",
	[14047] = "Runenstoff",
	[16885] = "Schwere Plünderkiste",
	[17010] = "Feuerkern",
	[17011] = "Lavakern",
	[17012] = "Kernleder",
	[17124] = "Syndikatsemblem",
	[17306] = "Blut eines Sturmlanzensoldaten",
	[17326] = "Fleisch eines Sturmlanzensoldaten",
	[17327] = "Fleisch eines Sturmlanzenlieutenants",
	[17328] = "Fleisch eines Sturmlanzenkommandanten",
	[17422] = "Rüstungsfetzen",
	[17423] = "Sturmkristall",
	[17502] = "Frostwolfbalg",
	[17503] = "Alteracwidderbalg",
	[17504] = "Frostwolfmaulkorb",
	[17642] = "Alteracwidderzaumzeug",
	[17643] = "Frostwolfzaumzeug",
	[18332] = "Buchband der Schnelligkeit",
	[18333] = "Buchband des Fokus",
	[18334] = "Buchband des Schutzes",
	[18945] = "Dunkeleisenrückstände",
	[19698] = "Münze der Zulian",
	[19699] = "Münze der Razzashi",
	[19700] = "Münze der Hakkari",
	[19701] = "Münze der Gurubashi",
	[19702] = "Münze der Bleichborken",
	[19703] = "Münze der Blutfransen",
	[19704] = "Münze der Sandwüter",
	[19705] = "Münze der Schädelspalter",
	[19706] = "Münze der Blutskalpe",
	[19858] = "Ehrenmünze der Zandalari",
	[20404] = "Verschlüsselter Schattenhammertext",
	[21229] = "Insignien des Qirajilords",
	[21230] = "Uraltes Qirajiartefakt",
	[21377] = "Kopfputzfeder der Totenwaldfelle",
	[21383] = "Geisterperlen der Winterfelle",
	[24245] = "Glühkappe",
	[24246] = "bluthibiskus",
	[24291] = "Sumpflordranke",
	[24368] = "Unidentifizierte Pflanzenteile",
	[24401] = "Unkatalogisierte Spezies",
	[24449] = "Fruchtbare Sporen",
	[24579] = "Ehrenmal der Feste Ehrenfeste",
	[24581] = "Ehrenmal von Thrallmar",
	[25416] = "Kriegsperlen der Oshu'gun",
	[25433] = "Kriegsperlen aus Obsidian",
	[25463] = "Kristallpulverprobe von Oshu'gun",
	[25719] = "Arakkoafeder",
	[29209] = "Insignien der Zerschmetterten Sonne",
	[29425] = "Mal des Sargeras",
	[29426] = " Teufelswaffen",
	[29739] = "Arkaner Foliant",
	[29740] = "Teufelsrüstung",
	[30809] = "Mal von Kil'jaeden",
	[30810] = "Siegel der Sonnenzorn",
	[32506] = "Netherschwingenei",
	[42780] = "Relikt von Ulduar",
	[44710] = "Immerfrostsplitter",
	[44711] = "Belobigungsabzeichen der Kirin Tor",
	[44713] = "Belobigungsabzeichen des Wyrmruhpakts",
	[45714] = "Belobigungsabzeichen von Darnassus",
	[45715] = "Belobigungsabzeichen der Exodar",
	[45716] = "Belobigungsabzeichen von Gnomeregan",
	[45717] = "Belobigungsabzeichen von Eisenschmiede",
	[45718] = "Belobigungsabzeichen von Sturmwind",
	[45719] = "Belobigungsabzeichen von Orgrimmar",
	[45720] = "Belobigungsabzeichen der Dunkelspeere",
	[45721] = "Belobigungsabzeichen von Silbermond",
	[45722] = "Belobigungsabzeichen von Donnerfels",
	[45723] = "Belobigungsabzeichen von Unterstadt",
	[49702] = "Belobigungsabzeichen der Ritter der Schwarzen Klinge",
}

local ITEM_FALLBACK_EN = {
	[2589]  = "Linen Cloth",
	[2604]  = "Red Dye",
	[3371]  = "Empty Vial",
	[3466]  = "Strong Flux",
	[3857]  = "Coal",
	[4306]  = "Silk Cloth",
	[4338]  = "Mageweave Cloth",
	[11370] = "Dark Iron Ore",
	[11382] = "Blood of the Mountain",
	[12840] = "Minion's Scourgestone",
	[12841] = "Invader's Scourgestone",
	[12843] = "Corruptor's Scourgestone",
	[12844] = "Argent Dawn Valor Token",
	[14047] = "Runecloth",
	[16885] = "Heavy Junkbox",
	[17010] = "Fiery Core",
	[17011] = "Lava Core",
	[17012] = "Core Leather",
	[17124] = "Syndicate Emblem",
	[17306] = "Stormpike Soldier's Blood",
	[17326] = "Stormpike Soldier's Flesh",
	[17327] = "Stormpike Lieutenant's Flesh",
	[17328] = "Stormpike Commander's Flesh",
	[17422] = "Armor Scraps",
	[17423] = "Storm Crystal",
	[17502] = "Frostwolf Hide",
	[17503] = "Alterac Ram Hide",
	[17504] = "Frostwolf Muzzle",
	[17642] = "Alterac Ram Hide",
	[17643] = "Frostwolf Hide",
	[18332] = "Libram of Rapidity",
	[18333] = "Libram of Focus",
	[18334] = "Libram of Protection",
	[18945] = "Dark Iron Residue",
	[19698] = "Zulian Coin",
	[19699] = "Razzashi Coin",
	[19700] = "Hakkari Coin",
	[19701] = "Gurubashi Coin",
	[19702] = "Vilebranch Coin",
	[19703] = "Witherbark Coin",
	[19704] = "Sandfury Coin",
	[19705] = "Skullsplitter Coin",
	[19706] = "Bloodscalp Coin",
	[19858] = "Zandalar Honor Token",
	[20404] = "Encrypted Twilight Text",
	[21229] = "Qiraji Lord's Insignia",
	[21230] = "Ancient Qiraji Artifact",
	[21377] = "Deadwood Headdress Feather",
	[21383] = "Winterfall Spirit Beads",
	[24245] = "Glowcap",
	[24246] = "Sanguine Hibiscus",
	[24291] = "Bog Lord Tendril",
	[24368] = "Unidentified Plant Parts",
	[24401] = "Uncatalogued Species",
	[24449] = "Fertile Spores",
	[24579] = "Mark of Honor Hold",
	[24581] = "Mark of Thrallmar",
	[25416] = "Oshu'gun Crystal Powder Sample",
	[25433] = "Obsidian Warbeads",
	[25463] = "Pair of Ivory Tusks",
	[25719] = "Arakkoa Feather",
	[29425] = "Mark of Sargeras",
	[29426] = "Fel Armament",
	[29739] = "Arcane Tome",
	[29740] = "Fel Armament",
	[30809] = "Mark of Kil'jaeden",
	[30810] = "Sunfury Signet",
	[32506] = "Netherwing Egg",
	[42780] = "Relic of Ulduar",
	[44710] = "Everfrost Chip",
	[44711] = "Kirin Tor Commendation Badge",
	[44713] = "Wyrmrest Commendation Badge",
	[45714] = "Darnassus Commendation Badge",
	[45715] = "Exodar Commendation Badge",
	[45716] = "Gnomeregan Commendation Badge",
	[45717] = "Ironforge Commendation Badge",
	[45718] = "Stormwind Commendation Badge",
	[45719] = "Orgrimmar Commendation Badge",
	[45720] = "Sen'jin Commendation Badge",
	[45721] = "Silvermoon Commendation Badge",
	[45722] = "Thunder Bluff Commendation Badge",
	[45723] = "Undercity Commendation Badge",
	[49702] = "Ebon Blade Commendation Badge",
}

function FIZ:GetItemInfoName(itemID)
	if not itemID then return nil end
	if C_Item and C_Item.GetItemNameByID then
		local name = C_Item.GetItemNameByID(itemID)
		if name and name ~= "" then return name end
	end
	if C_Item and C_Item.GetItemInfo then
		local name = C_Item.GetItemInfo(itemID)
		if name and name ~= "" then return name end
	end
	if _G.GetItemInfo then
		local name = _G.GetItemInfo(itemID)
		if name and name ~= "" then return name end
	end
	if C_Item and C_Item.RequestLoadItemDataByID and type(itemID) == "number" then
		pcall(C_Item.RequestLoadItemDataByID, itemID)
	end
	if type(itemID) == "number" then
		if GetLocale and GetLocale() == "deDE" and ITEM_FALLBACK_DE[itemID] then
			return ITEM_FALLBACK_DE[itemID]
		end
		if ITEM_FALLBACK_EN[itemID] then
			return ITEM_FALLBACK_EN[itemID]
		end
	end
	return nil
end

function FIZ:GetItemCount(itemID, includeBank)
	if not itemID then return 0 end
	if C_Item and C_Item.GetItemCount then
		return C_Item.GetItemCount(itemID, includeBank) or 0
	elseif _G.GetItemCount then
		return _G.GetItemCount(itemID, includeBank) or 0
	end
	return 0
end

function FIZ:GetNumQuestLogEntries()
	if C_QuestLog and C_QuestLog.GetNumQuestLogEntries then
		return C_QuestLog.GetNumQuestLogEntries() or 0
	elseif _G.GetNumQuestLogEntries then
		local entries = _G.GetNumQuestLogEntries()
		return entries or 0
	end
	return 0
end

function FIZ:GetQuestLogEntryInfo(questLogIndex)
	if C_QuestLog and C_QuestLog.GetInfo then
		local info = C_QuestLog.GetInfo(questLogIndex)
		if info then
			local isComplete = false
			if info.questID and C_QuestLog.IsComplete then
				isComplete = C_QuestLog.IsComplete(info.questID)
			end
			return info.title, info.isHeader, isComplete
		end
		return nil
	elseif _G.GetQuestLogTitle then
		local title, _, _, isHeader, _, isComplete = _G.GetQuestLogTitle(questLogIndex)
		return title, isHeader, isComplete
	end
	return nil
end

function FIZ:GetQuestTitleByID(questID)
	if not questID or type(questID) ~= "number" then return nil end
	if C_QuestLog and C_QuestLog.GetTitleForQuestID then
		local title = C_QuestLog.GetTitleForQuestID(questID)
		if title and title ~= "" then
			return title
		end
	end
	if C_QuestLog and C_QuestLog.GetQuestInfo then
		local title = C_QuestLog.GetQuestInfo(questID)
		if title and title ~= "" then
			return title
		end
	end
	if C_TooltipInfo and C_TooltipInfo.GetHyperlink then
		local tooltipData = C_TooltipInfo.GetHyperlink(string.format("quest:%d", questID))
		if tooltipData and tooltipData.lines and tooltipData.lines[1] and tooltipData.lines[1].leftText then
			return tooltipData.lines[1].leftText
		end
	end
	if GameTooltip and GameTooltip.SetHyperlink and GameTooltipTextLeft1 then
		GameTooltip:SetOwner(UIParent, "ANCHOR_NONE")
		GameTooltip:SetHyperlink(string.format("quest:%d", questID))
		local quest = GameTooltipTextLeft1:GetText()
		GameTooltip:Hide()
		if quest and quest ~= "" then
			return quest
		end
	end
	if C_QuestLog and C_QuestLog.RequestLoadQuestByID then
		pcall(C_QuestLog.RequestLoadQuestByID, questID)
	end
	if GetLocale and GetLocale() == "deDE" and CLASSIC_QUEST_FALLBACK_DE[questID] then
		return CLASSIC_QUEST_FALLBACK_DE[questID]
	end
	if CLASSIC_QUEST_FALLBACK_EN[questID] then
		return CLASSIC_QUEST_FALLBACK_EN[questID]
	end
	return nil
end

function FIZ:RefreshReputationFrame()
	if not ReputationFrame or not ReputationFrame:IsVisible() then return end
	if _G.ReputationFrame_Update then
		_G.ReputationFrame_Update()
	elseif ReputationFrame.Update then
		ReputationFrame:Update()
	end
end

