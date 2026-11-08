----------------------------------------------------------
-- Factionizer - Utility & Skill Extraction Functions   --
----------------------------------------------------------

local FIZ = _G.FIZ

function FIZ:Print(msg, forceDefault)
	if not msg then return end

	if FIZ_Data == nil or forceDefault then
		if DEFAULT_CHAT_FRAME then
			DEFAULT_CHAT_FRAME:AddMessage(msg)
		end
		return
	end

	local sinkType = self.db and self.db.profile and self.db.profile.sink and self.db.profile.sink.sink20OutputSink or "Chat"
	if sinkType == "None" then
		return
	elseif sinkType ~= "Chat" and self.Pour then
		self:Pour(msg, 1.0, 0.85, 0.25, nil, nil, nil, nil, nil, "Interface\\Icons\\Achievement_Reputation_01")
		return
	end

	local printed = false
	for i = 1, NUM_CHAT_WINDOWS do
		local chatTab = _G["ChatFrame" .. i .. "Tab"]
		local chatFrame = _G["ChatFrame" .. i]
		if chatTab and chatTab:IsShown() and chatFrame and chatFrame.messageTypeList then
			local messageTypes = chatFrame.messageTypeList
			for j = 1, #messageTypes do
				if messageTypes[j] == "COMBAT_FACTION_CHANGE" then
					chatFrame:AddMessage(msg)
					printed = true
				end
			end
		end
	end
	if not printed and DEFAULT_CHAT_FRAME then
		DEFAULT_CHAT_FRAME:AddMessage(msg)
	end
end

function FIZ:Printtest(msg, msg1, msg2)
	FIZ:Print(tostring(msg) .. " " .. tostring(msg1) .. "  " .. tostring(msg2), nil)
end

function FIZ:PrintSlash(msg, msg1)
	FIZ:Print(FIZ_Help_COLOUR .. FIZ_NAME .. ":|r " .. msg .. " [" .. FIZ_Help_COLOUR .. msg1 .. "|r]", true)
	FIZ:Help()
end

function FIZ:Debug(msg)
	if not msg then return end
end

function FIZ:TableSize(info)
	local result = 0
	if info then
		for _ in pairs(info) do
			result = result + 1
		end
	end
	return result
end

function FIZ:GetWords(str)
	local ret = {}
	local pos = 0
	local index = 0
	while true do
		local word
		_, pos, word = string.find(str, "^ *([^%s]+) *", pos + 1)
		if not word then
			return ret
		end
		ret[index] = word
		index = index + 1
	end
end

function FIZ:Concat(list, start, stop)
	local ret = ""
	if start == nil then start = 0 end
	if stop == nil then stop = FIZ:TableSize(list) end

	for i = start, stop do
		if list[i] then
			if ret ~= "" then ret = ret .. " " end
			ret = ret .. list[i]
		end
	end
	return ret
end

function FIZ:BoolToEnabled(b)
	local result = FIZ_TXT.disabled
	if b then result = FIZ_TXT.enabled end
	return result
end

function FIZ:RGBToColour_perc(a, r, g, b)
	return string.format("|c%02X%02X%02X%02X", a * 255, r * 255, g * 255, b * 255)
end

function FIZ:GetTabardFaction()
	for i = 1, 40 do
		local spellId
		if C_UnitAuras and C_UnitAuras.GetBuffDataByIndex then
			local aura = C_UnitAuras.GetBuffDataByIndex("player", i)
			if not aura then break end
			spellId = aura.spellId
		elseif _G.UnitBuff then
			local _, _, _, _, _, _, _, _, _, id10, id11 = _G.UnitBuff("player", i)
			spellId = id10 or id11
			if not spellId and not _G.UnitBuff("player", i) then break end
		else
			break
		end

		if spellId and self.ChampionFactions and self.ChampionFactions[spellId] then
			local data = self.ChampionFactions[spellId]
			return data[2], data[1]
		end
	end
	return nil, nil
end

function FIZ:InitFactor(isHuman, faction)
	local factor = 1.0
	if isHuman then
		factor = factor + 0.1
	end
	if faction then
		local numFactions = self:GetNumFactions()
		for i = 1, numFactions do
			local name, _, _, _, _, _, _, _, _, _, _, _, _, _, hasBonusRepGain = self:GetRawFactionInfo(i)
			if faction == name and hasBonusRepGain then
				factor = factor + 1
			end
		end
	end
	return factor
end

function FIZ:ExtractSkills()
	FIZ_Herb = false
	FIZ_Skin = false
	FIZ_Mine = false
	FIZ_Alche = false
	FIZ_Black = false
	FIZ_Enchan = false
	FIZ_Engin = false
	FIZ_Jewel = false
	FIZ_Incrip = false
	FIZ_Leath = false
	FIZ_Tailor = false
	FIZ_Aid = false
	FIZ_Arch = false
	FIZ_Cook = false
	FIZ_Fish = false

	local professions = {}

	-- Modern / Cataclysm / MoP / Retail GetProfessions API
	if _G.GetProfessions and _G.GetProfessionInfo then
		local prof1, prof2, archaeology, fishing, cooking, firstaid = _G.GetProfessions()
		local indices = { prof1, prof2, archaeology, fishing, cooking, firstaid }
		for _, idx in pairs(indices) do
			if idx then
				local name = _G.GetProfessionInfo(idx)
				if name then
					table.insert(professions, name)
				end
			end
		end
	-- Classic Era / TBC / WotLK GetNumSkillLines & GetSkillLineInfo API
	elseif _G.GetNumSkillLines and _G.GetSkillLineInfo then
		local numSkills = _G.GetNumSkillLines()
		for i = 1, numSkills do
			local skillName, isHeader = _G.GetSkillLineInfo(i)
			if skillName and not isHeader then
				table.insert(professions, skillName)
			end
		end
	end

	for _, skillName in ipairs(professions) do
		if skillName == FIZ_TXT.skillHerb then
			FIZ_Herb = true
		elseif skillName == FIZ_TXT.skillSkin then
			FIZ_Skin = true
		elseif skillName == FIZ_TXT.skillMine then
			FIZ_Mine = true
		elseif skillName == FIZ_TXT.skillAlch then
			FIZ_Alche = true
		elseif skillName == FIZ_TXT.skillBlack then
			FIZ_Black = true
		elseif skillName == FIZ_TXT.skillEnch then
			FIZ_Enchan = true
		elseif skillName == FIZ_TXT.skillEngi then
			FIZ_Engin = true
		elseif skillName == FIZ_TXT.skillIncrip then
			FIZ_Incrip = true
		elseif skillName == FIZ_TXT.skillJewel then
			FIZ_Jewel = true
		elseif skillName == FIZ_TXT.skillLeath then
			FIZ_Leath = true
		elseif skillName == FIZ_TXT.skillTail then
			FIZ_Tailor = true
		elseif skillName == FIZ_TXT.skillAid then
			FIZ_Aid = true
		elseif skillName == FIZ_TXT.skillArch then
			FIZ_Arch = true
		elseif skillName == FIZ_TXT.skillCook then
			FIZ_Cook = true
		elseif skillName == FIZ_TXT.skillFish then
			FIZ_Fish = true
		end
	end
end

