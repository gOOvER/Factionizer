----------------------------------------------------------
-- Factionizer - Slash Commands & AceTab-3.0            --
----------------------------------------------------------

local FIZ = _G.FIZ
local LibStub = LibStub
local AceTab = LibStub("AceTab-3.0", true)

function FIZ:InitCommands()
	self:RegisterChatCommand("factionizer", "SlashHandler")
	self:RegisterChatCommand("fz", "SlashHandler")

	if AceTab and not AceTab:IsTabCompletionRegistered("Factionizer") then
		AceTab:RegisterTabCompletion(
			"Factionizer",
			"^/[fF][zZ]%s+",
			function(t)
				for _, cmd in ipairs({
					"options", "config", "status", "list", "help", "about",
					"enable", "disable", "toggle",
				}) do
					table.insert(t, cmd)
				end
			end
		)
	end
end

function FIZ:SlashHandler(msg)
	FIZ_SlashHandler(msg)
end

function FIZ_SlashHandler(msg)
	if not msg or msg == "" then
		FIZ:ToggleConfigWindow()
		return
	end

	local msgLower = string.lower(msg)
	local wordsLower = FIZ:GetWords(msgLower)
	local size = FIZ:TableSize(wordsLower)
	local FD_SH = FIZ_Data

	if size > 0 then
		if wordsLower[0] == "enable" then
			if size > 1 then
				if wordsLower[1] == "mobs" then
					FD_SH.ShowMobs = true
				elseif wordsLower[1] == "quests" then
					FD_SH.ShowQuests = true
				elseif wordsLower[1] == "dungeons" or wordsLower[1] == "instances" then
					FD_SH.ShowInstances = true
				elseif wordsLower[1] == "items" then
					FD_SH.ShowItems = true
				elseif wordsLower[1] == "general" then
					FD_SH.ShowGeneral = true
				elseif wordsLower[1] == "missing" then
					FD_SH.ShowMissing = true
				elseif wordsLower[1] == "details" then
					FD_SH.ExtendDetails = true
				elseif wordsLower[1] == "chat" then
					FD_SH.WriteChatMessage = true
					FD_SH.NoGuildGain = false
				elseif wordsLower[1] == "suppress" then
					FD_SH.SuppressOriginalChat = true
				elseif wordsLower[1] == "preview" then
					FD_SH.ShowPreviewRep = true
				elseif wordsLower[1] == "bar" then
					FD_SH.SwitchFactionBar = true
					FD_SH.NoGuildSwitch = false
					FD_SH.SilentSwitch = false
				elseif wordsLower[1] == "all" then
					FD_SH.ShowMobs = true
					FD_SH.ShowQuests = true
					FD_SH.ShowInstances = true
					FD_SH.ShowItems = true
					FD_SH.ShowGeneral = true
					FD_SH.ShowMissing = true
					FD_SH.ExtendDetails = true
					FD_SH.WriteChatMessage = true
					FD_SH.NoGuildGain = false
					FD_SH.SuppressOriginalChat = true
					FD_SH.ShowPreviewRep = true
					FD_SH.SwitchFactionBar = true
					FD_SH.NoGuildSwitch = false
					FD_SH.SilentSwitch = false
				else
					FIZ:PrintSlash(FIZ_TXT.command, msgLower)
				end

				FIZ:RefreshReputationFrame()
				if FIZ_ReputationDetailFrame and FIZ_ReputationDetailFrame:IsVisible() then
					FIZ:BuildUpdateList()
					FIZ_UpdateList_Update()
				end
			else
				FIZ:PrintSlash(FIZ_TXT.command, msgLower)
			end
		elseif wordsLower[0] == "disable" then
			if size > 1 then
				if wordsLower[1] == "mobs" then
					FD_SH.ShowMobs = false
				elseif wordsLower[1] == "quests" then
					FD_SH.ShowQuests = false
				elseif wordsLower[1] == "dungeons" or wordsLower[1] == "instances" then
					FD_SH.ShowInstances = false
				elseif wordsLower[1] == "items" then
					FD_SH.ShowItems = false
				elseif wordsLower[1] == "general" then
					FD_SH.ShowGeneral = false
				elseif wordsLower[1] == "missing" then
					FD_SH.ShowMissing = false
				elseif wordsLower[1] == "details" then
					FD_SH.ExtendDetails = false
				elseif wordsLower[1] == "chat" then
					FD_SH.WriteChatMessage = false
					FD_SH.NoGuildGain = false
				elseif wordsLower[1] == "suppress" then
					FD_SH.SuppressOriginalChat = false
				elseif wordsLower[1] == "preview" then
					FD_SH.ShowPreviewRep = false
				elseif wordsLower[1] == "bar" then
					FD_SH.SwitchFactionBar = false
					FD_SH.NoGuildSwitch = false
					FD_SH.SilentSwitch = false
				elseif wordsLower[1] == "all" then
					FD_SH.ShowMobs = false
					FD_SH.ShowQuests = false
					FD_SH.ShowInstances = false
					FD_SH.ShowItems = false
					FD_SH.ShowGeneral = false
					FD_SH.ShowMissing = false
					FD_SH.ExtendDetails = false
					FD_SH.WriteChatMessage = false
					FD_SH.NoGuildGain = false
					FD_SH.SuppressOriginalChat = false
					FD_SH.ShowPreviewRep = false
					FD_SH.SwitchFactionBar = false
					FD_SH.NoGuildSwitch = false
					FD_SH.SilentSwitch = false
				else
					FIZ:PrintSlash(FIZ_TXT.command, msgLower)
				end

				FIZ:RefreshReputationFrame()
				if FIZ_ReputationDetailFrame and FIZ_ReputationDetailFrame:IsVisible() then
					FIZ:BuildUpdateList()
					FIZ_UpdateList_Update()
				end
			else
				FIZ:PrintSlash(FIZ_TXT.command, msgLower)
			end
		elseif wordsLower[0] == "toggle" then
			if size > 1 then
				if wordsLower[1] == "mobs" then
					FD_SH.ShowMobs = not FD_SH.ShowMobs
				elseif wordsLower[1] == "quests" then
					FD_SH.ShowQuests = not FD_SH.ShowQuests
				elseif wordsLower[1] == "dungeons" or wordsLower[1] == "instances" then
					FD_SH.ShowInstances = not FD_SH.ShowInstances
				elseif wordsLower[1] == "items" then
					FD_SH.ShowItems = not FD_SH.ShowItems
				elseif wordsLower[1] == "general" then
					FD_SH.ShowGeneral = not FD_SH.ShowGeneral
				elseif wordsLower[1] == "missing" then
					FD_SH.ShowMissing = not FD_SH.ShowMissing
				elseif wordsLower[1] == "details" then
					FD_SH.ExtendDetails = not FD_SH.ExtendDetails
				elseif wordsLower[1] == "chat" then
					FD_SH.WriteChatMessage = not FD_SH.WriteChatMessage
					FD_SH.NoGuildGain = false
				elseif wordsLower[1] == "suppress" then
					FD_SH.SuppressOriginalChat = not FD_SH.SuppressOriginalChat
				elseif wordsLower[1] == "preview" then
					FD_SH.ShowPreviewRep = not FD_SH.ShowPreviewRep
				elseif wordsLower[1] == "bar" then
					FD_SH.SwitchFactionBar = not FD_SH.SwitchFactionBar
					FD_SH.NoGuildSwitch = false
					FD_SH.SilentSwitch = false
				elseif wordsLower[1] == "all" then
					FD_SH.ShowMobs = not FD_SH.ShowMobs
					FD_SH.ShowQuests = not FD_SH.ShowQuests
					FD_SH.ShowInstances = not FD_SH.ShowInstances
					FD_SH.ShowItems = not FD_SH.ShowItems
					FD_SH.ShowGeneral = not FD_SH.ShowGeneral
					FD_SH.ShowMissing = not FD_SH.ShowMissing
					FD_SH.ExtendDetails = not FD_SH.ExtendDetails
					FD_SH.WriteChatMessage = not FD_SH.WriteChatMessage
					FD_SH.NoGuildGain = false
					FD_SH.SuppressOriginalChat = not FD_SH.SuppressOriginalChat
					FD_SH.ShowPreviewRep = not FD_SH.ShowPreviewRep
					FD_SH.SwitchFactionBar = not FD_SH.SwitchFactionBar
					FD_SH.NoGuildSwitch = false
					FD_SH.SilentSwitch = false
				else
					FIZ:PrintSlash(FIZ_TXT.command, msgLower)
				end

				FIZ:RefreshReputationFrame()
				if FIZ_ReputationDetailFrame and FIZ_ReputationDetailFrame:IsVisible() then
					FIZ:BuildUpdateList()
					FIZ_UpdateList_Update()
				end
			else
				FIZ:PrintSlash(FIZ_TXT.command, msgLower)
			end
		elseif wordsLower[0] == "list" or wordsLower[0] == "loc" then
			if size > 1 then
				for s = 1, 8 do
					local label = _G["FACTION_STANDING_LABEL" .. s]
					if wordsLower[1] == tostring(s) or (label and wordsLower[1] == string.lower(label)) then
						FIZ:ListByStanding(s)
						return
					end
				end
				FIZ:PrintSlash(FIZ_TXT.command, msgLower)
			else
				FIZ:ListByStanding()
			end
		elseif wordsLower[0] == "options" or wordsLower[0] == "config" then
			FIZ:ToggleConfigWindow()
		elseif wordsLower[0] == "status" then
			FIZ:Status()
		elseif wordsLower[0] == "help" then
			FIZ:Help()
		elseif wordsLower[0] == "about" then
			FIZ:About()
		else
			FIZ:PrintSlash(FIZ_TXT.command, msgLower)
		end
	end
end

function FIZ:Help()
	FIZ:Print(" ", true)
	FIZ:Print(FIZ_Help_COLOUR .. FIZ_NAME .. ":|r " .. FIZ_TXT.help, true)
	FIZ:Print(FIZ_Help_COLOUR .. FIZ_TXT.usage .. ":|r /fz help " .. FIZ_Help_COLOUR .. FIZ_TXT.helphelp, true)
	FIZ:Print(FIZ_Help_COLOUR .. FIZ_TXT.usage .. ":|r /fz about " .. FIZ_Help_COLOUR .. FIZ_TXT.helpabout, true)
	FIZ:Print(FIZ_Help_COLOUR .. FIZ_TXT.usage .. ":|r /fz status " .. FIZ_Help_COLOUR .. FIZ_TXT.helpstatus, true)
	FIZ:Print(FIZ_Help_COLOUR .. FIZ_TXT.usage .. ":|r /fz options", true)
	FIZ:Print(FIZ_Help_COLOUR .. FIZ_TXT.usage .. ":|r /fz enable { mobs | quests | instances | items | all }", true)
	FIZ:Print(FIZ_Help_COLOUR .. FIZ_TXT.usage .. ":|r /fz disable { mobs | quests | instances | items | all }", true)
	FIZ:Print(FIZ_Help_COLOUR .. FIZ_TXT.usage .. ":|r /fz toggle { mobs | quests | instances | items | all }", true)
	FIZ:Print(FIZ_Help_COLOUR .. FIZ_TXT.usage .. ":|r /fz enable { missing | details | chat | suppress }", true)
	FIZ:Print(FIZ_Help_COLOUR .. FIZ_TXT.usage .. ":|r /fz disable { missing | details | chat | suppress }", true)
	FIZ:Print(FIZ_Help_COLOUR .. FIZ_TXT.usage .. ":|r /fz toggle { missing | details | chat | suppress }", true)
end

function FIZ:About()
	local ver = self:GetAddOnMetadata("Factionizer", "Version")
	local date = self:GetAddOnMetadata("Factionizer", "X-Date")
	local author = self:GetAddOnMetadata("Factionizer", "Author")
	local web = self:GetAddOnMetadata("Factionizer", "X-Website")

	if author ~= nil then
		FIZ:Print(FIZ_NAME .. " " .. FIZ_TXT.by .. " " .. FIZ_Help_COLOUR .. author .. "|r", true)
	end
	if ver ~= nil then
		FIZ:Print("  " .. FIZ_TXT.version .. ": " .. FIZ_Help_COLOUR .. ver .. "|r", true)
	end
	if date ~= nil then
		FIZ:Print("  " .. FIZ_TXT.date .. ": " .. FIZ_Help_COLOUR .. date .. "|r", true)
	end
	if web ~= nil then
		FIZ:Print("  " .. FIZ_TXT.web .. ": " .. FIZ_Help_COLOUR .. web .. "|r", true)
	end
end

function FIZ:Status()
	FIZ:Print(" ", true)
	FIZ:Print(FIZ_Help_COLOUR .. FIZ_NAME .. ":|r " .. FIZ_TXT.status, true)
	FIZ:Print("   " .. FIZ_TXT.statMobs .. ": " .. FIZ_Help_COLOUR .. FIZ:BoolToEnabled(FIZ_Data.ShowMobs) .. "|r", true)
	FIZ:Print("   " .. FIZ_TXT.statQuests .. ": " .. FIZ_Help_COLOUR .. FIZ:BoolToEnabled(FIZ_Data.ShowQuests) .. "|r", true)
	FIZ:Print("   " .. FIZ_TXT.statInstances .. ": " .. FIZ_Help_COLOUR .. FIZ:BoolToEnabled(FIZ_Data.ShowInstances) .. "|r", true)
	FIZ:Print("   " .. FIZ_TXT.statItems .. ": " .. FIZ_Help_COLOUR .. FIZ:BoolToEnabled(FIZ_Data.ShowItems) .. "|r", true)
	FIZ:Print("   " .. FIZ_TXT.statGeneral .. ": " .. FIZ_Help_COLOUR .. FIZ:BoolToEnabled(FIZ_Data.ShowGeneral) .. "|r", true)
	FIZ:Print("   " .. FIZ_TXT.statMissing .. ": " .. FIZ_Help_COLOUR .. FIZ:BoolToEnabled(FIZ_Data.ShowMissing) .. "|r", true)
	FIZ:Print("   " .. FIZ_TXT.statDetails .. ": " .. FIZ_Help_COLOUR .. FIZ:BoolToEnabled(FIZ_Data.ExtendDetails) .. "|r", true)
	FIZ:Print("   " .. FIZ_TXT.statChat .. ": " .. FIZ_Help_COLOUR .. FIZ:BoolToEnabled(FIZ_Data.WriteChatMessage) .. "|r", true)
	FIZ:Print("   " .. FIZ_TXT.statNoGuildChat .. ": " .. FIZ_Help_COLOUR .. FIZ:BoolToEnabled(FIZ_Data.NoGuildGain) .. "|r", true)
	FIZ:Print("   " .. FIZ_TXT.statSuppress .. ": " .. FIZ_Help_COLOUR .. FIZ:BoolToEnabled(FIZ_Data.SuppressOriginalChat) .. "|r", true)
	FIZ:Print("   " .. FIZ_TXT.statPreview .. ": " .. FIZ_Help_COLOUR .. FIZ:BoolToEnabled(FIZ_Data.ShowPreviewRep) .. "|r", true)
	FIZ:Print("   " .. FIZ_TXT.statSwitch .. ": " .. FIZ_Help_COLOUR .. FIZ:BoolToEnabled(FIZ_Data.SwitchFactionBar) .. "|r", true)
	FIZ:Print("   " .. FIZ_TXT.statNoGuildSwitch .. ": " .. FIZ_Help_COLOUR .. FIZ:BoolToEnabled(FIZ_Data.NoGuildSwitch) .. "|r", true)
	FIZ:Print("   " .. FIZ_TXT.statSilentSwitch .. ": " .. FIZ_Help_COLOUR .. FIZ:BoolToEnabled(FIZ_Data.SilentSwitch) .. "|r", true)
end

