----------------------------------------------------------
-- Factionizer - LDB, Minimap & Interactive LibQTip     --
----------------------------------------------------------

local FIZ = _G.FIZ
local LibStub = LibStub
local LDB = LibStub("LibDataBroker-1.1", true)
local LDBIcon = LibStub("LibDBIcon-1.0", true)
local LibQTip = LibStub("LibQTip-1.0", true)

local STANDING_HEX = {
	[1] = "cc2222",
	[2] = "ff3333",
	[3] = "ee6622",
	[4] = "e5cc33",
	[5] = "33cc33",
	[6] = "33dd88",
	[7] = "33aaff",
	[8] = "00ffcc",
}

local STANDING_RGB = {
	[1] = { 0.80, 0.13, 0.13 },
	[2] = { 1.00, 0.20, 0.20 },
	[3] = { 0.93, 0.40, 0.13 },
	[4] = { 0.85, 0.72, 0.15 },
	[5] = { 0.18, 0.72, 0.22 },
	[6] = { 0.18, 0.78, 0.48 },
	[7] = { 0.20, 0.62, 0.95 },
	[8] = { 0.00, 0.82, 0.72 },
}

local BarCellProvider
if LibQTip and LibQTip.CreateCellProvider then
	local ok, provider, prototype = pcall(LibQTip.CreateCellProvider, LibQTip)
	if ok and provider and prototype then
		BarCellProvider = provider
		function prototype:InitializeCell()
			self.bar = CreateFrame("StatusBar", nil, self)
			self.bar:SetPoint("TOPLEFT", self, "TOPLEFT", 1, -2)
			self.bar:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -1, 2)
			local bg = self.bar:CreateTexture(nil, "BACKGROUND")
			bg:SetAllPoints()
			bg:SetColorTexture(0.06, 0.07, 0.09, 0.90)
			self.label = self.bar:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
			self.label:SetPoint("CENTER", self.bar, "CENTER", 0, 0)
		end
		function prototype:SetupCell(tooltip, data)
			if type(data) ~= "table" then return 160, 18 end
			local w = data.width or 160
			self.bar:SetStatusBarTexture(data.tex or "Interface\\TargetingFrame\\UI-StatusBar")
			self.bar:SetMinMaxValues(0, math.max(1, data.max or 1))
			self.bar:SetValue(math.max(0, math.min(data.val or 0, data.max or 1)))
			self.bar:SetStatusBarColor(data.r or 0.2, data.g or 0.7, data.b or 0.3, 0.82)
			self.label:SetText(data.text or "")
			self.bar:Show()
			return w, 18
		end
		function prototype:ReleaseCell()
			if self.bar then self.bar:Hide() end
		end
		function prototype:getContentHeight()
			return 18
		end
	end
end

local function onFactionRowClick(_, info, button)
	if not info or not info.index then return end
	if button == "RightButton" then
		FIZ:SetWatchedFactionIndex(info.index)
		FIZ:UpdateLDBText()
		if FIZ.qtip and FIZ.qtipAnchor then
			FIZ:ShowQTip(FIZ.qtipAnchor)
		end
	else
		if FIZ.qtip and LibQTip then
			LibQTip:Release(FIZ.qtip)
			FIZ.qtip = nil
		end
		if ReputationFrame and not ReputationFrame:IsVisible() and ToggleCharacter then
			ToggleCharacter("ReputationFrame")
		end
		FIZ:SetSelectedFaction(info.index)
		if FIZ_ReputationDetailFrame then
			FIZ_ReputationDetailFrame:Show()
		end
		FIZ:BuildUpdateList()
		if FIZ_UpdateList_Update then
			FIZ_UpdateList_Update()
		end
		FIZ:RefreshReputationFrame()
	end
end

function FIZ:ShowQTip(anchorFrame)
	if not LibQTip or not anchorFrame then return end
	if GameTooltip and GameTooltip:IsShown() then
		GameTooltip:Hide()
	end

	local tip = LibQTip:Acquire("FactionizerQTip", 5, "LEFT", "LEFT", "RIGHT", "RIGHT", "RIGHT")
	self.qtip = tip
	self.qtipAnchor = anchorFrame
	tip:Clear()

	-- Title Banner
	local titleLine = tip:AddHeader()
	tip:SetCell(
		titleLine,
		1,
		"|TInterface\\Icons\\Achievement_Reputation_01:15:15:0:0:64:64:5:59:5:59|t  |cffffd200" .. FIZ_NAME .. "|r  |cff00ff96v7.0.0|r",
		"GameFontNormal",
		"LEFT",
		5
	)
	tip:AddSeparator(1, 0.79, 0.64, 0.15, 0.85)

	-- Column Headers
	local hdr = tip:AddHeader(
		"|cffffd200" .. (FIZ_TXT.faction or _G.FACTION or "Faction") .. "|r",
		"|cffffd200" .. (FIZ_TXT.standing or _G.STANDING or "Standing") .. "|r",
		"|cffffd200" .. (FIZ_TXT.currentRep or "Current") .. "|r",
		"|cffffd200" .. (FIZ_TXT.missingRep or "Missing") .. "|r",
		"|cffffd200" .. (FIZ_TXT.session or "Session") .. "|r"
	)
	tip:SetLineColor(hdr, 0.14, 0.16, 0.22, 0.90)
	tip:AddSeparator(1, 0.24, 0.27, 0.35, 0.85)

	-- Collect Watched + Session Gain + Top Active Factions
	local rows = {}
	local numFactions = self:GetNumFactions()
	for i = 1, numFactions do
		local name, _, standingID, barMin, barMax, barValue, _, _, isHeader, _, hasRep, isWatched, _, factionID = self:GetRawFactionInfo(i)
		if name and (not isHeader or hasRep) then
			local normMax = math.max(1, (barMax or 0) - (barMin or 0))
			local normVal = (barValue or 0) - (barMin or 0)
			local origRep = FIZ_StoredRep and FIZ_StoredRep[name] and FIZ_StoredRep[name].origRep
			local sessionGain = origRep and ((barValue or 0) - origRep) or 0
			if isWatched or sessionGain ~= 0 or #rows < 10 then
				table.insert(rows, {
					index = i,
					name = name,
					standingID = standingID or 4,
					normVal = normVal,
					normMax = normMax,
					missing = math.max(0, normMax - normVal),
					sessionGain = sessionGain,
					isWatched = isWatched,
					factionID = factionID,
				})
			end
		end
	end

	table.sort(rows, function(a, b)
		if a.isWatched ~= b.isWatched then
			return a.isWatched and true or false
		end
		if (a.sessionGain ~= 0) ~= (b.sessionGain ~= 0) then
			return a.sessionGain > b.sessionGain
		end
		return a.standingID > b.standingID
	end)

	local maxRows = math.min(#rows, 14)
	if maxRows == 0 then
		local emptyLine = tip:AddLine()
		tip:SetCell(emptyLine, 1, "|cff8892a4" .. (FIZ_TXT.noActiveFactions or "No active factions found.") .. "|r", "GameFontDisableSmall", "LEFT", 5)
	else
		local barTex = self:GetStatusBarTexturePath()
		for r = 1, maxRows do
			local item = rows[r]
			local hex = STANDING_HEX[item.standingID] or "e5cc33"
			local rgb = STANDING_RGB[item.standingID] or STANDING_RGB[4]
			local barR, barG, barB = rgb[1], rgb[2], rgb[3]
			local standingText = _G["FACTION_STANDING_LABEL" .. item.standingID] or ""
			if item.factionID and self.IsMajorFaction and self:IsMajorFaction(item.factionID) and C_MajorFactions and C_MajorFactions.GetMajorFactionData then
				local mfData = C_MajorFactions.GetMajorFactionData(item.factionID)
				if mfData and mfData.renownLevel then
					standingText = string.format(RENOWN_LEVEL_LABEL or "Renown %d", mfData.renownLevel)
					hex = "00ccff"
					barR, barG, barB = 0.00, 0.72, 0.95
				end
			end

			local pct = math.min(100, math.max(0, (item.normVal / item.normMax) * 100))
			local namePrefix = item.isWatched and "|TInterface\\Buttons\\UI-CheckBox-Check:14:14:0:0|t " or "    "
			local sessionStr = item.sessionGain > 0 and string.format("|cff44ff66+%d|r", item.sessionGain)
				or (item.sessionGain < 0 and string.format("|cffff5555%d|r", item.sessionGain) or "|cff6670800|r")
			local barText = string.format("%d / %d (%.0f%%)", item.normVal, item.normMax, pct)

			local line = tip:AddLine(
				namePrefix .. "|cffffffff" .. item.name .. "|r",
				"|cff" .. hex .. standingText .. "|r",
				barText,
				item.missing > 0 and string.format("|cffff6b6b-%d|r", item.missing) or "|cff00ffccMax|r",
				sessionStr
			)
			if tip.SetCellProgressBar then
				tip:SetCellProgressBar(line, 3, item.normVal, item.normMax, barText, barR, barG, barB, 160, barTex)
			elseif BarCellProvider then
				tip:SetCell(line, 3, {
					val = item.normVal,
					max = item.normMax,
					text = barText,
					r = barR,
					g = barG,
					b = barB,
					width = 160,
					tex = barTex,
				}, nil, "CENTER", 1, BarCellProvider)
			end
			if item.isWatched then
				tip:SetLineColor(line, 0.13, 0.23, 0.19, 0.75)
			elseif r % 2 == 0 then
				tip:SetLineColor(line, 0.11, 0.13, 0.17, 0.55)
			end
			tip:SetLineScript(line, "OnMouseUp", onFactionRowClick, item)
		end
	end

	tip:AddSeparator(1, 0.24, 0.27, 0.35, 0.85)
	local hint1 = tip:AddLine()
	tip:SetCell(
		hint1,
		1,
		"|cffffd200" .. (FIZ_TXT.qtipRowLeft or "Row Left-Click:") .. "|r " .. (FIZ_TXT.qtipRowLeftDesc or "Open Faction Details")
		.. "   |cff555c68||r   |cffffd200" .. (FIZ_TXT.qtipRowRight or "Row Right-Click:") .. "|r " .. (FIZ_TXT.qtipRowRightDesc or "Watch Faction"),
		"GameFontHighlightSmall",
		"LEFT",
		5
	)
	local hint2 = tip:AddLine()
	tip:SetCell(
		hint2,
		1,
		"|cffffd200" .. (FIZ_TXT.qtipIconLeft or "Icon Left-Click:") .. "|r " .. (FIZ_TXT.qtipIconLeftDesc or "Toggle Reputation Panel")
		.. "   |cff555c68||r   |cffffd200" .. (FIZ_TXT.qtipIconRight or "Icon Right-Click:") .. "|r " .. (FIZ_TXT.qtipIconRightDesc or "Open Options"),
		"GameFontDisableSmall",
		"LEFT",
		5
	)

	tip:SmartAnchorTo(anchorFrame)
	tip:SetAutoHideDelay(0.25, anchorFrame, function(t)
		LibQTip:Release(t)
		if self.qtip == t then
			self.qtip = nil
		end
	end)
	tip:Show()
end

function FIZ:SetupLDB()
	if not LDB then return end
	self.ldb = LDB:NewDataObject("Factionizer", {
		type = "data source",
		text = FIZ_NAME,
		label = FIZ_NAME,
		icon = "Interface\\Icons\\Achievement_Reputation_01",
		OnClick = function(_, button)
			if FIZ.qtip and LibQTip then
				LibQTip:Release(FIZ.qtip)
				FIZ.qtip = nil
			end
			if button == "RightButton" then
				FIZ:ToggleConfigWindow()
			else
				FIZ:ToggleDetailWindow()
			end
		end,
		OnEnter = function(frame)
			if LibQTip then
				FIZ:ShowQTip(frame)
			end
		end,
		OnTooltipShow = function(tooltip)
			if LibQTip then
				local owner = tooltip and tooltip:GetOwner()
				if owner then
					tooltip:Hide()
					FIZ:ShowQTip(owner)
					return
				end
			end
			if not tooltip or not tooltip.AddLine then return end
			tooltip:AddLine(FIZ_NAME)
			local watchedLine = FIZ:GetWatchedFactionSummary()
			if watchedLine then
				tooltip:AddLine(" ")
				tooltip:AddLine(watchedLine, 0.8, 1, 0.8)
			end
			tooltip:AddLine(" ")
			tooltip:AddLine(FIZ_TXT.minimapTooltipLeft or "|cFFFFFFFFLeft-Click:|r Toggle Reputation Window", 1, 1, 1)
			tooltip:AddLine(FIZ_TXT.minimapTooltipRight or "|cFFFFFFFFRight-Click:|r Open Factionizer Options", 1, 1, 1)
		end,
	})
	if LDBIcon and not LDBIcon:IsRegistered("Factionizer") then
		LDBIcon:Register("Factionizer", self.ldb, self.db.profile.minimap)
	end
end

function FIZ:GetWatchedFactionSummary()
	local numFactions = self:GetNumFactions()
	for i = 1, numFactions do
		local name, _, standingID, barMin, barMax, barValue, _, _, isHeader, _, hasRep, isWatched = self:GetRawFactionInfo(i)
		if name and (not isHeader or hasRep) and isWatched then
			local normMax = (barMax or 0) - (barMin or 0)
			local normVal = (barValue or 0) - (barMin or 0)
			local standingText = _G["FACTION_STANDING_LABEL" .. (standingID or 4)] or ""
			return string.format("%s (%s): %d / %d (-%d)", name, standingText, normVal, normMax, math.max(0, normMax - normVal))
		end
	end
	return nil
end

function FIZ:UpdateLDBText()
	if not self.ldb then return end
	local summary = self:GetWatchedFactionSummary()
	self.ldb.text = summary or FIZ_NAME
end

function Factionizer_OnAddonCompartmentClick(_, buttonName)
	if buttonName == "RightButton" then
		FIZ:ToggleConfigWindow()
	else
		FIZ:ToggleDetailWindow()
	end
end

function Factionizer_OnAddonCompartmentEnter(_, menuButtonFrame)
	if LibQTip and menuButtonFrame then
		FIZ:ShowQTip(menuButtonFrame)
		return
	end
	if not GameTooltip then return end
	GameTooltip:SetOwner(menuButtonFrame, "ANCHOR_LEFT")
	GameTooltip:SetText(FIZ_NAME)
	local watchedLine = FIZ:GetWatchedFactionSummary()
	if watchedLine then
		GameTooltip:AddLine(watchedLine, 0.8, 1, 0.8)
	end
	GameTooltip:AddLine(FIZ_TXT.minimapTooltipLeft or "|cFFFFFFFFLeft-Click:|r Toggle Reputation Window", 1, 1, 1)
	GameTooltip:AddLine(FIZ_TXT.minimapTooltipRight or "|cFFFFFFFFRight-Click:|r Open Factionizer Options", 1, 1, 1)
	GameTooltip:Show()
end

function Factionizer_OnAddonCompartmentLeave()
	if GameTooltip then
		GameTooltip:Hide()
	end
end
