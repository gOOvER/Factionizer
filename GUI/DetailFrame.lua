----------------------------------------------------------
-- Factionizer - Modern Dark-Gold Detail Frame GUI      --
----------------------------------------------------------

local FIZ = _G.FIZ
local LibStub = LibStub
local LibWindow = LibStub("LibWindow-1.1", true)

local ROW_HEIGHT = 20

local TYPE_BADGE_COLORS = {
	["[Q]"] = "|cFFFFD100", -- Gold for Quests
	["[D]"] = "|cFFB080FF", -- Purple for Dungeons/Instances
	["[M]"] = "|cFFFF6060", -- Coral Red for Mobs
	["[I]"] = "|cFF55FF88", -- Mint Green for Items
	["[G]"] = "|cFF55CCFF", -- Sky Blue for General (or German Gegenstände)
	["[A]"] = "|cFF55CCFF", -- Sky Blue for German Allgemein
}

local function GetBadgeColor(badgeText)
	if not badgeText then return "|cFFFFFFFF" end
	if FIZ_TXT then
		if badgeText == FIZ_TXT.questShort then return "|cFFFFD100" end
		if badgeText == FIZ_TXT.instanceShort then return "|cFFB080FF" end
		if badgeText == FIZ_TXT.mobShort then return "|cFFFF6060" end
		if badgeText == FIZ_TXT.itemsShort then return "|cFF55FF88" end
		if badgeText == FIZ_TXT.generalShort then return "|cFF55CCFF" end
	end
	return TYPE_BADGE_COLORS[badgeText] or "|cFFFFFFFF"
end

function FIZ:UpdateDetailWindowDocking()
	local frame = _G.FIZ_ReputationDetailFrame
	if not frame then return end
	local winCfg = self.db and self.db.profile and self.db.profile.window
	local isDetached = winCfg and winCfg.detached
	if frame.DockButton then
		frame.DockButton:SetText(isDetached and (FIZ_TXT.dock or "Dock") or (FIZ_TXT.detach or "Detach"))
	end
	if isDetached and LibWindow and winCfg and winCfg.x and winCfg.y then
		LibWindow.RestorePosition(frame)
	else
		local parentFrame = ReputationFrame or UIParent
		frame:ClearAllPoints()
		frame:SetPoint("TOPLEFT", parentFrame, "TOPRIGHT", 4, 0)
	end
end

function FIZ:CreateModernDetailFrame()
	if _G.FIZ_ReputationDetailFrame then return _G.FIZ_ReputationDetailFrame end

	local UIStyle = self.UIStyle
	local parentFrame = ReputationFrame or UIParent
	local frame = CreateFrame("Frame", "FIZ_ReputationDetailFrame", parentFrame, BackdropTemplateMixin and "BackdropTemplate" or nil)
	frame:SetSize(540, 656)
	frame:SetPoint("TOPLEFT", parentFrame, "TOPRIGHT", 4, 0)
	frame:SetFrameStrata("HIGH")
	frame:SetToplevel(true)
	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:SetClampedToScreen(true)
	frame:Hide()

	UIStyle.ApplyBox(frame, 0.07, 0.08, 0.11, 0.97, 0.26, 0.30, 0.38, 1)

	-- LibWindow-1.1 Position & Ctrl+MouseWheel Scale Persistence
	if LibWindow and self.db and self.db.profile then
		self.db.profile.window = self.db.profile.window or { detached = false, scale = 1.0 }
		LibWindow.RegisterConfig(frame, self.db.profile.window)
		LibWindow.EnableMouseWheelScaling(frame)
		if self.db.profile.window.scale then
			frame:SetScale(self.db.profile.window.scale)
		end
		function frame:OnMoved()
			if FIZ.db and FIZ.db.profile and FIZ.db.profile.window then
				FIZ.db.profile.window.detached = true
			end
			LibWindow.SavePosition(self)
			if self.DockButton then
				self.DockButton:SetText(FIZ_TXT.dock or "Dock")
			end
		end
	end

	-- 1. Top Dark-Gold Header Bar (Gatherer Style)
	frame.Header = UIStyle.CreateHeader(
		frame,
		FIZ_NAME .. "  |cff667080—|r  |cffffffff" .. (_G.REPUTATION or FIZ_TXT.reputation or "Reputation") .. "|r",
		"Interface\\Icons\\Achievement_Reputation_01",
		function() frame:Hide() end
	)
	_G.FIZ_ReputationDetailCloseButton = frame.Header.CloseButton

	-- Quick Options Button in Header
	local gearBtn = UIStyle.CreateButton(frame.Header, 88, 26, FIZ_TXT.options or "Options", "primary", nil, "FIZ_DetailOptionsShortcutButton")
	gearBtn:SetPoint("RIGHT", frame.Header.CloseButton, "LEFT", -6, 0)
	gearBtn:SetScript("OnClick", function()
		FIZ:ToggleConfigWindow()
	end)

	-- Dock / Detach Toggle Button in Header
	local isDetached = self.db and self.db.profile and self.db.profile.window and self.db.profile.window.detached
	local dockBtn = UIStyle.CreateButton(frame.Header, 76, 26, isDetached and (FIZ_TXT.dock or "Dock") or (FIZ_TXT.detach or "Detach"), "default", nil, "FIZ_DetailDockButton")
	dockBtn:SetPoint("RIGHT", gearBtn, "LEFT", -4, 0)
	dockBtn:SetScript("OnClick", function()
		if FIZ.db and FIZ.db.profile then
			FIZ.db.profile.window = FIZ.db.profile.window or {}
			FIZ.db.profile.window.detached = not FIZ.db.profile.window.detached
			if not FIZ.db.profile.window.detached then
				FIZ.db.profile.window.x = nil
				FIZ.db.profile.window.y = nil
			end
			FIZ:UpdateDetailWindowDocking()
		end
	end)
	frame.DockButton = dockBtn

	-------------------------------------------------------------------
	-- 2. Hero Header Card (Faction Name, Standing, Progress Bar, Lore)
	-------------------------------------------------------------------
	local headerCard = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate" or nil)
	headerCard:SetPoint("TOPLEFT", frame.Header, "BOTTOMLEFT", 8, -6)
	headerCard:SetPoint("TOPRIGHT", frame.Header, "BOTTOMRIGHT", -8, -6)
	headerCard:SetHeight(112)
	UIStyle.ApplyBox(headerCard, 0.10, 0.12, 0.16, 0.96, 0.22, 0.25, 0.32, 1)

	local facName = headerCard:CreateFontString("FIZ_ReputationDetailFactionName", "OVERLAY", "GameFontNormalLarge")
	facName:SetPoint("TOPLEFT", headerCard, "TOPLEFT", 12, -9)
	facName:SetPoint("RIGHT", headerCard, "RIGHT", -200, 0)
	facName:SetJustifyH("LEFT")
	facName:SetWordWrap(false)
	facName:SetTextColor(1, 0.85, 0.25)

	local standingNext = headerCard:CreateFontString("FIZ_ReputationDetailStandingNextValue", "OVERLAY", "GameFontHighlight")
	standingNext:SetPoint("TOPRIGHT", headerCard, "TOPRIGHT", -12, -10)
	standingNext:SetJustifyH("RIGHT")

	local standingName = headerCard:CreateFontString("FIZ_ReputationDetailStandingName", "OVERLAY", "GameFontNormalLarge")
	standingName:SetPoint("RIGHT", standingNext, "LEFT", -5, 0)
	standingName:SetJustifyH("RIGHT")

	-- Live StatusBar + Preview Bar
	local barBg = CreateFrame("Frame", nil, headerCard, BackdropTemplateMixin and "BackdropTemplate" or nil)
	barBg:SetPoint("TOPLEFT", headerCard, "TOPLEFT", 12, -32)
	barBg:SetPoint("TOPRIGHT", headerCard, "TOPRIGHT", -12, -32)
	barBg:SetHeight(20)
	UIStyle.ApplyBox(barBg, 0.04, 0.05, 0.07, 0.98, 0.24, 0.27, 0.35, 1)

	local texPath = self:GetStatusBarTexturePath()

	local previewBar = CreateFrame("StatusBar", nil, barBg)
	previewBar:SetPoint("TOPLEFT", barBg, "TOPLEFT", 1, -1)
	previewBar:SetPoint("BOTTOMRIGHT", barBg, "BOTTOMRIGHT", -1, 1)
	previewBar:SetStatusBarTexture(texPath)
	previewBar:SetStatusBarColor(0.25, 0.95, 0.55, 0.55)
	previewBar:SetMinMaxValues(0, 1)
	previewBar:SetValue(0)
	previewBar:SetFrameLevel(barBg:GetFrameLevel() + 1)
	self.DetailPreviewBar = previewBar

	local progBar = CreateFrame("StatusBar", nil, barBg)
	progBar:SetPoint("TOPLEFT", barBg, "TOPLEFT", 1, -1)
	progBar:SetPoint("BOTTOMRIGHT", barBg, "BOTTOMRIGHT", -1, 1)
	progBar:SetStatusBarTexture(texPath)
	progBar:SetMinMaxValues(0, 1)
	progBar:SetValue(0)
	progBar:SetFrameLevel(barBg:GetFrameLevel() + 2)
	self.DetailProgressBar = progBar

	local progText = progBar:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	progText:SetPoint("CENTER", barBg, "CENTER", 0, 0)
	self.DetailProgressText = progText

	-- Faction Lore Description
	local facDesc = headerCard:CreateFontString("FIZ_ReputationDetailFactionDescription", "OVERLAY", "GameFontHighlight")
	facDesc:SetPoint("TOPLEFT", barBg, "BOTTOMLEFT", 0, -7)
	facDesc:SetPoint("BOTTOMRIGHT", headerCard, "BOTTOMRIGHT", -12, 7)
	facDesc:SetJustifyH("LEFT")
	facDesc:SetJustifyV("TOP")
	facDesc:SetTextColor(0.80, 0.84, 0.90)

	-------------------------------------------------------------------
	-- 3. Two-Column Statistics Card
	-------------------------------------------------------------------
	local statsCard = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate" or nil)
	statsCard:SetPoint("TOPLEFT", headerCard, "BOTTOMLEFT", 0, -5)
	statsCard:SetPoint("TOPRIGHT", headerCard, "BOTTOMRIGHT", 0, -5)
	statsCard:SetHeight(80)
	UIStyle.ApplyBox(statsCard, 0.09, 0.11, 0.14, 0.96, 0.22, 0.25, 0.32, 1)

	local function CreateStatPair(labelGlobal, valGlobal, col, row)
		local xLeft = (col == 1) and 12 or 268
		local xRight = (col == 1) and -274 or -12
		local yOffset = -8 - (row - 1) * 17

		local lbl = statsCard:CreateFontString(labelGlobal, "OVERLAY", "GameFontNormal")
		lbl:SetPoint("TOPLEFT", statsCard, "TOPLEFT", xLeft, yOffset)
		lbl:SetJustifyH("LEFT")
		lbl:SetTextColor(0.82, 0.86, 0.92)

		local val = statsCard:CreateFontString(valGlobal, "OVERLAY", "GameFontHighlight")
		val:SetPoint("TOPRIGHT", statsCard, "TOPRIGHT", xRight, yOffset)
		val:SetJustifyH("RIGHT")
		return lbl, val
	end

	-- Left Column: Needed, Current, Missing, To Exalted
	CreateStatPair("FIZ_ReputationDetailStandingNeeded", "FIZ_ReputationDetailStandingNeededValue", 1, 1)
	CreateStatPair("FIZ_ReputationDetailStandingCurrent", "FIZ_ReputationDetailStandingCurrentValue", 1, 2)
	CreateStatPair("FIZ_ReputationDetailStandingMissing", "FIZ_ReputationDetailStandingMissingValue", 1, 3)
	CreateStatPair("FIZ_ReputationDetailStandingToExaltedHeader", "FIZ_ReputationDetailStandingToExaltedValue", 1, 4)

	-- Right Column: In Bags, In Bags & Bank, In Quests, Session Gain
	CreateStatPair("FIZ_ReputationDetailStandingBag", "FIZ_ReputationDetailStandingBagValue", 2, 1)
	CreateStatPair("FIZ_ReputationDetailStandingBagBank", "FIZ_ReputationDetailStandingBagBankValue", 2, 2)
	CreateStatPair("FIZ_ReputationDetailStandingQuests", "FIZ_ReputationDetailStandingQuestsValue", 2, 3)
	CreateStatPair("FIZ_ReputationDetailStandingGained", "FIZ_ReputationDetailStandingGainedValue", 2, 4)

	-------------------------------------------------------------------
	-- 4. Blizzard Faction Controls Bar (At War, Inactive, Watch Bar)
	-------------------------------------------------------------------
	local ctrlBar = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate" or nil)
	ctrlBar:SetPoint("TOPLEFT", statsCard, "BOTTOMLEFT", 0, -4)
	ctrlBar:SetPoint("TOPRIGHT", statsCard, "BOTTOMRIGHT", 0, -4)
	ctrlBar:SetHeight(28)
	UIStyle.ApplyBox(ctrlBar, 0.10, 0.12, 0.15, 0.96, 0.20, 0.23, 0.29, 1)

	local atWarCB = CreateFrame("CheckButton", "FIZ_ReputationDetailAtWarCheckBox", ctrlBar)
	atWarCB:SetSize(22, 22)
	atWarCB:SetPoint("LEFT", ctrlBar, "LEFT", 10, 0)
	atWarCB:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up")
	atWarCB:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down")
	atWarCB:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight", "ADD")
	atWarCB:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-SwordCheck")
	atWarCB:SetDisabledCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled")
	local atWarText = atWarCB:CreateFontString("FIZ_ReputationDetailAtWarCheckBoxText", "ARTWORK", "GameFontNormal")
	atWarText:SetPoint("LEFT", atWarCB, "RIGHT", 4, 0)
	atWarText:SetText(_G.AT_WAR or "At War")
	atWarText:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	atWarCB:SetScript("OnClick", function(selfBtn)
		FIZ:ToggleAtWar(FIZ:GetSelectedFaction())
		FIZ:PlayCheckBoxSound(selfBtn:GetChecked())
		FIZ:RefreshReputationFrame()
	end)
	atWarCB:SetScript("OnEnter", function(selfBtn)
		if GameTooltip and _G.REPUTATION_AT_WAR_DESCRIPTION then
			GameTooltip:SetOwner(selfBtn, "ANCHOR_RIGHT")
			GameTooltip:SetText(_G.REPUTATION_AT_WAR_DESCRIPTION, nil, nil, nil, nil, true)
			GameTooltip:Show()
		end
	end)
	atWarCB:SetScript("OnLeave", function() if GameTooltip then GameTooltip:Hide() end end)

	local inactiveCB = CreateFrame("CheckButton", "FIZ_ReputationDetailInactiveCheckBox", ctrlBar, "UICheckButtonTemplate")
	inactiveCB:SetSize(22, 22)
	inactiveCB:SetPoint("LEFT", ctrlBar, "LEFT", 140, 0)
	local inactiveText = _G["FIZ_ReputationDetailInactiveCheckBoxText"] or inactiveCB.Text
	if inactiveText then
		inactiveText:SetFontObject(GameFontNormal)
		inactiveText:SetText(_G.MOVE_TO_INACTIVE or "Move to Inactive")
	end
	inactiveCB:SetScript("OnClick", function(selfBtn)
		FIZ:PlayCheckBoxSound(selfBtn:GetChecked())
		FIZ:SetFactionInactive(FIZ:GetSelectedFaction(), selfBtn:GetChecked())
	end)
	inactiveCB:SetScript("OnEnter", function(selfBtn)
		if GameTooltip and _G.REPUTATION_MOVE_TO_INACTIVE then
			GameTooltip:SetOwner(selfBtn, "ANCHOR_RIGHT")
			GameTooltip:SetText(_G.REPUTATION_MOVE_TO_INACTIVE, nil, nil, nil, nil, true)
			GameTooltip:Show()
		end
	end)
	inactiveCB:SetScript("OnLeave", function() if GameTooltip then GameTooltip:Hide() end end)

	local watchCB = CreateFrame("CheckButton", "FIZ_ReputationDetailMainScreenCheckBox", ctrlBar, "UICheckButtonTemplate")
	watchCB:SetSize(22, 22)
	watchCB:SetPoint("LEFT", ctrlBar, "LEFT", 285, 0)
	local watchText = _G["FIZ_ReputationDetailMainScreenCheckBoxText"] or watchCB.Text
	if watchText then
		watchText:SetFontObject(GameFontNormal)
		watchText:SetText(_G.SHOW_FACTION_ON_MAINSCREEN or "Show as Experience Bar")
	end
	watchCB:SetScript("OnClick", function(selfBtn)
		FIZ:PlayCheckBoxSound(selfBtn:GetChecked())
		if selfBtn:GetChecked() then
			FIZ:SetWatchedFactionIndex(FIZ:GetSelectedFaction())
		else
			FIZ:SetWatchedFactionIndex(0)
		end
		if _G.ReputationWatchBar_Update then
			_G.ReputationWatchBar_Update()
		end
	end)
	watchCB:SetScript("OnEnter", function(selfBtn)
		if GameTooltip and _G.REPUTATION_SHOW_AS_XP then
			GameTooltip:SetOwner(selfBtn, "ANCHOR_RIGHT")
			GameTooltip:SetText(_G.REPUTATION_SHOW_AS_XP, nil, nil, nil, nil, true)
			GameTooltip:Show()
		end
	end)
	watchCB:SetScript("OnLeave", function() if GameTooltip then GameTooltip:Hide() end end)

	-------------------------------------------------------------------
	-- 5. Filter Pills + Search Box Toolbar (Gatherer Style)
	-------------------------------------------------------------------
	local filterCard = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate" or nil)
	filterCard:SetPoint("TOPLEFT", ctrlBar, "BOTTOMLEFT", 0, -4)
	filterCard:SetPoint("TOPRIGHT", ctrlBar, "BOTTOMRIGHT", 0, -4)
	filterCard:SetHeight(66)
	UIStyle.ApplyBox(filterCard, 0.10, 0.12, 0.15, 0.96, 0.20, 0.23, 0.29, 1)

	local prevPill = nil
	local function CreateSourcePill(globalName, optionKey, defaultLabel, width)
		local pill = UIStyle.CreateFilterPill(
			filterCard,
			defaultLabel,
			FIZ_Data and FIZ_Data[optionKey] ~= false,
			function(_, active)
				FIZ:SetOption(optionKey, active)
				FIZ:BuildUpdateList()
				FIZ_UpdateList_Update()
			end,
			globalName
		)
		pill:SetFixedWidth(width)
		if not prevPill then
			pill:SetPoint("TOPLEFT", filterCard, "TOPLEFT", 6, -6)
		else
			pill:SetPoint("LEFT", prevPill, "RIGHT", 5, 0)
		end
		prevPill = pill
		pill:HookScript("OnEnter", function(selfBtn)
			FIZ_ShowHelpToolTip(selfBtn, globalName)
		end)
		return pill
	end

	CreateSourcePill("FIZ_ShowQuestButton", "ShowQuests", FIZ_TXT.showQuests or "Quests", 90)
	CreateSourcePill("FIZ_ShowInstancesButton", "ShowInstances", FIZ_TXT.showInstances or "Instances", 102)
	CreateSourcePill("FIZ_ShowMobsButton", "ShowMobs", FIZ_TXT.showMobs or "Mobs", 86)
	CreateSourcePill("FIZ_ShowItemsButton", "ShowItems", FIZ_TXT.showItems or "Items", 118)
	CreateSourcePill("FIZ_ShowGeneralButton", "ShowGeneral", FIZ_TXT.showGeneral or "General", 96)

	-- Row 2 of Filter Card: Modern Search Box + All / None / Expand / Collapse Buttons
	local searchBox = UIStyle.CreateEditBox(filterCard, 214, 26, (_G.SEARCH or "Search") .. "...", "FIZ_SearchEditBox")
	searchBox:SetPoint("BOTTOMLEFT", filterCard, "BOTTOMLEFT", 6, 6)
	searchBox.OnValueChanged = function(_, text)
		FIZ.searchFilter = string.lower(strtrim(text or ""))
		FIZ_UpdateList_Update()
	end
	self.SearchBox = searchBox

	local showAllBtn = UIStyle.CreateButton(filterCard, 58, 26, FIZ_TXT.showAll or "All", "default", nil, "FIZ_ShowAllButton")
	showAllBtn:SetPoint("LEFT", searchBox, "RIGHT", 5, 0)
	showAllBtn:SetScript("OnClick", function()
		FIZ:SetOption("ShowQuests", true)
		FIZ:SetOption("ShowMobs", true)
		FIZ:SetOption("ShowInstances", true)
		FIZ:SetOption("ShowItems", true)
		FIZ:SetOption("ShowGeneral", true)
		FIZ:PlayCheckBoxSound(true)
		FIZ:BuildUpdateList()
		FIZ_UpdateList_Update()
	end)
	showAllBtn:HookScript("OnEnter", function(btn) FIZ_ShowHelpToolTip(btn, "FIZ_ShowAllButton") end)
	showAllBtn:HookScript("OnLeave", function() if GameTooltip then GameTooltip:Hide() end end)

	local showNoneBtn = UIStyle.CreateButton(filterCard, 58, 26, FIZ_TXT.showNone or "None", "default", nil, "FIZ_ShowNoneButton")
	showNoneBtn:SetPoint("LEFT", showAllBtn, "RIGHT", 4, 0)
	showNoneBtn:SetScript("OnClick", function()
		FIZ:SetOption("ShowQuests", false)
		FIZ:SetOption("ShowMobs", false)
		FIZ:SetOption("ShowInstances", false)
		FIZ:SetOption("ShowItems", false)
		FIZ:SetOption("ShowGeneral", false)
		FIZ:PlayCheckBoxSound(false)
		FIZ:BuildUpdateList()
		FIZ_UpdateList_Update()
	end)
	showNoneBtn:HookScript("OnEnter", function(btn) FIZ_ShowHelpToolTip(btn, "FIZ_ShowNoneButton") end)
	showNoneBtn:HookScript("OnLeave", function() if GameTooltip then GameTooltip:Hide() end end)

	local expandBtn = UIStyle.CreateButton(filterCard, 84, 26, FIZ_TXT.expand or "Expand", "default", nil, "FIZ_ExpandButton")
	expandBtn:SetPoint("LEFT", showNoneBtn, "RIGHT", 4, 0)
	expandBtn:SetScript("OnClick", function()
		FIZ:PlayCheckBoxSound(true)
		FIZ_ShowUpdateEntries(true)
	end)
	expandBtn:HookScript("OnEnter", function(btn) FIZ_ShowHelpToolTip(btn, "FIZ_ExpandButton") end)
	expandBtn:HookScript("OnLeave", function() if GameTooltip then GameTooltip:Hide() end end)

	local collapseBtn = UIStyle.CreateButton(filterCard, 84, 26, FIZ_TXT.collapse or "Collapse", "default", nil, "FIZ_CollapseButton")
	collapseBtn:SetPoint("LEFT", expandBtn, "RIGHT", 4, 0)
	collapseBtn:SetScript("OnClick", function()
		FIZ:PlayCheckBoxSound(false)
		FIZ_ShowUpdateEntries(false)
	end)
	collapseBtn:HookScript("OnEnter", function(btn) FIZ_ShowHelpToolTip(btn, "FIZ_CollapseButton") end)
	collapseBtn:HookScript("OnLeave", function() if GameTooltip then GameTooltip:Hide() end end)

	-------------------------------------------------------------------
	-- 6. Scrollable Reputation Sources List Card
	-------------------------------------------------------------------
	local listCard = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate" or nil)
	listCard:SetPoint("TOPLEFT", filterCard, "BOTTOMLEFT", 0, -4)
	listCard:SetPoint("TOPRIGHT", filterCard, "BOTTOMRIGHT", 0, -4)
	listCard:SetHeight(268)
	UIStyle.ApplyBox(listCard, 0.08, 0.09, 0.12, 0.98, 0.22, 0.25, 0.32, 1)

	local scrollFrame = CreateFrame("ScrollFrame", "FIZ_UpdateListScrollFrame", listCard, "FauxScrollFrameTemplate")
	scrollFrame:SetPoint("TOPLEFT", listCard, "TOPLEFT", 4, -4)
	scrollFrame:SetPoint("BOTTOMRIGHT", listCard, "BOTTOMRIGHT", -24, 4)
	scrollFrame:SetScript("OnVerticalScroll", function(selfScroll, offset)
		FauxScrollFrame_OnVerticalScroll(selfScroll, offset, ROW_HEIGHT, FIZ_UpdateList_Update)
	end)

	local noInfoText = listCard:CreateFontString("FIZ_NoInformationText", "OVERLAY", "GameFontDisableLarge")
	noInfoText:SetPoint("CENTER", listCard, "CENTER", 0, 0)
	noInfoText:SetWidth(460)
	noInfoText:SetJustifyH("CENTER")
	noInfoText:Hide()

	for row = 1, FIZ_UPDATE_LIST_HEIGHT do
		local entryName = "FIZ_UpdateEntry" .. row
		local btn = CreateFrame("Button", entryName, listCard)
		btn:SetSize(492, ROW_HEIGHT)
		if row == 1 then
			btn:SetPoint("TOPLEFT", scrollFrame, "TOPLEFT", 0, 0)
		else
			btn:SetPoint("TOPLEFT", _G["FIZ_UpdateEntry" .. (row - 1)], "BOTTOMLEFT", 0, 0)
		end
		btn:RegisterForClicks("LeftButtonUp", "RightButtonUp")

		-- Alternating zebra stripe background
		local rowBg = btn:CreateTexture(nil, "BACKGROUND")
		rowBg:SetAllPoints()
		rowBg:SetTexture("Interface\\Buttons\\WHITE8X8")
		if row % 2 == 0 then
			rowBg:SetVertexColor(0.14, 0.16, 0.22, 0.45)
		else
			rowBg:SetVertexColor(0.08, 0.09, 0.13, 0.25)
		end

		-- Hover highlight texture
		local hlTex = btn:CreateTexture(nil, "HIGHLIGHT")
		hlTex:SetAllPoints()
		hlTex:SetTexture("Interface\\Buttons\\WHITE8X8")
		hlTex:SetVertexColor(0.95, 0.80, 0.25, 0.18)

		local tex = btn:CreateTexture(entryName .. "Texture", "OVERLAY")
		tex:SetSize(16, 16)
		tex:SetPoint("LEFT", btn, "LEFT", 4, 0)
		tex:SetTexture("Interface\\Buttons\\UI-MinusButton-Up")

		local lbl = btn:CreateFontString(entryName .. "Label", "OVERLAY", "GameFontNormal")
		lbl:SetSize(30, ROW_HEIGHT)
		lbl:SetPoint("LEFT", btn, "LEFT", 22, 0)
		lbl:SetJustifyH("LEFT")

		local times = btn:CreateFontString(entryName .. "Times", "OVERLAY", "GameFontHighlight")
		times:SetSize(52, ROW_HEIGHT)
		times:SetPoint("LEFT", btn, "LEFT", 52, 0)
		times:SetJustifyH("RIGHT")

		local nameFS = btn:CreateFontString(entryName .. "Name", "OVERLAY", "GameFontHighlight")
		nameFS:SetSize(326, ROW_HEIGHT)
		nameFS:SetPoint("LEFT", btn, "LEFT", 110, 0)
		nameFS:SetJustifyH("LEFT")
		nameFS:SetWordWrap(false)

		local repFS = btn:CreateFontString(entryName .. "Rep", "OVERLAY", "GameFontHighlight")
		repFS:SetSize(52, ROW_HEIGHT)
		repFS:SetPoint("RIGHT", btn, "RIGHT", -4, 0)
		repFS:SetJustifyH("RIGHT")

		local itemTimes = btn:CreateFontString(entryName .. "ItemTimes", "OVERLAY", "GameFontDisable")
		itemTimes:SetSize(52, ROW_HEIGHT)
		itemTimes:SetPoint("LEFT", btn, "LEFT", 52, 0)
		itemTimes:SetJustifyH("RIGHT")

		local itemName = btn:CreateFontString(entryName .. "ItemName", "OVERLAY", "GameFontDisable")
		itemName:SetSize(300, ROW_HEIGHT)
		itemName:SetPoint("LEFT", btn, "LEFT", 110, 0)
		itemName:SetJustifyH("LEFT")
		itemName:SetWordWrap(false)

		local totalTimes = btn:CreateFontString(entryName .. "TotalTimes", "OVERLAY", "GameFontDisable")
		totalTimes:SetSize(90, ROW_HEIGHT)
		totalTimes:SetPoint("RIGHT", btn, "RIGHT", -4, 0)
		totalTimes:SetJustifyH("RIGHT")

		btn:SetScript("OnEnter", function(selfBtn) FIZ_ShowLineToolTip(selfBtn) end)
		btn:SetScript("OnLeave", function() if GameTooltip then GameTooltip:Hide() end end)
		btn:SetScript("OnMouseUp", function(selfBtn, button) FIZ_MouseButtonUp(selfBtn, button) end)
		btn:Hide()
	end

	-------------------------------------------------------------------
	-- 7. Footer Action Bar & Hint
	-------------------------------------------------------------------
	local footerCard = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate" or nil)
	footerCard:SetPoint("TOPLEFT", listCard, "BOTTOMLEFT", 0, -4)
	footerCard:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -8, 8)
	UIStyle.ApplyBox(footerCard, 0.10, 0.12, 0.15, 0.96, 0.20, 0.23, 0.29, 1)

	local clearFacBtn = UIStyle.CreateButton(footerCard, 166, 26, FIZ_TXT.supressNoneFaction or "Clear Faction", "default", nil, "FIZ_SupressNoneFactionButton")
	clearFacBtn:SetPoint("TOPLEFT", footerCard, "TOPLEFT", 6, -6)
	clearFacBtn:SetScript("OnClick", function()
		FIZ:PlayCheckBoxSound(false)
		FIZ:SupressNone(false)
	end)
	clearFacBtn:HookScript("OnEnter", function(btn) FIZ_ShowHelpToolTip(btn, "FIZ_SupressNoneFactionButton") end)
	clearFacBtn:HookScript("OnLeave", function() if GameTooltip then GameTooltip:Hide() end end)

	local clearAllBtn = UIStyle.CreateButton(footerCard, 166, 26, FIZ_TXT.supressNoneGlobal or "Clear All", "danger", nil, "FIZ_SupressNoneGlobalButton")
	clearAllBtn:SetPoint("LEFT", clearFacBtn, "RIGHT", 6, 0)
	clearAllBtn:SetScript("OnClick", function()
		FIZ:PlayCheckBoxSound(false)
		FIZ:SupressNone(true)
	end)
	clearAllBtn:HookScript("OnEnter", function(btn) FIZ_ShowHelpToolTip(btn, "FIZ_SupressNoneGlobalButton") end)
	clearAllBtn:HookScript("OnLeave", function() if GameTooltip then GameTooltip:Hide() end end)

	local resetGainBtn = UIStyle.CreateButton(footerCard, 168, 26, FIZ_TXT.clearSessionGain or "Reset Session", "primary", nil, "FIZ_ClearSessionGainButton")
	resetGainBtn:SetPoint("LEFT", clearAllBtn, "RIGHT", 6, 0)
	resetGainBtn:SetScript("OnClick", function()
		FIZ:PlayCheckBoxSound(false)
		FIZ:ClearSessionGain()
	end)
	resetGainBtn:HookScript("OnEnter", function(btn) FIZ_ShowHelpToolTip(btn, "FIZ_ClearSessionGainButton") end)
	resetGainBtn:HookScript("OnLeave", function() if GameTooltip then GameTooltip:Hide() end end)

	local hintText = footerCard:CreateFontString("FIZ_ReputationDetailSuppressHint", "OVERLAY", "GameFontDisableSmall")
	hintText:SetPoint("BOTTOMLEFT", footerCard, "BOTTOMLEFT", 8, 5)
	hintText:SetPoint("BOTTOMRIGHT", footerCard, "BOTTOMRIGHT", -8, 5)
	hintText:SetJustifyH("CENTER")
	hintText:SetText(FIZ_TXT.suppressHint or "")

	self:UpdateDetailWindowDocking()
	return frame
end

local function MatchesSearchFilter(entry, filter)
	if not filter or filter == "" then return true end
	if not entry then return false end
	if entry.name and string.find(string.lower(entry.name), filter, 1, true) then
		return true
	end
	if entry.belongsTo and FIZ_UpdateList[entry.belongsTo] and FIZ_UpdateList[entry.belongsTo].name then
		if string.find(string.lower(FIZ_UpdateList[entry.belongsTo].name), filter, 1, true) then
			return true
		end
	end
	return false
end

function FIZ_UpdateList_Update()
	if not FIZ_ReputationDetailFrame or not FIZ_ReputationDetailFrame:IsVisible() then return end

	FIZ_UpdateListScrollFrame:Show()
	FIZ_ShowQuestButton:SetChecked(FIZ_Data.ShowQuests)
	FIZ_ShowItemsButton:SetChecked(FIZ_Data.ShowItems)
	FIZ_ShowMobsButton:SetChecked(FIZ_Data.ShowMobs)
	FIZ_ShowInstancesButton:SetChecked(FIZ_Data.ShowInstances)
	FIZ_ShowGeneralButton:SetChecked(FIZ_Data.ShowGeneral)

	if FIZ_ShowQuestButtonText then FIZ_ShowQuestButtonText:SetText(FIZ_TXT.showQuests) end
	if FIZ_ShowItemsButtonText then FIZ_ShowItemsButtonText:SetText(FIZ_TXT.showItems) end
	if FIZ_ShowMobsButtonText then FIZ_ShowMobsButtonText:SetText(FIZ_TXT.showMobs) end
	if FIZ_ShowInstancesButtonText then FIZ_ShowInstancesButtonText:SetText(FIZ_TXT.showInstances) end
	if FIZ_ShowGeneralButtonText then FIZ_ShowGeneralButtonText:SetText(FIZ_TXT.showGeneral) end

	FIZ_ShowAllButton:SetText(FIZ_TXT.showAll)
	FIZ_ShowNoneButton:SetText(FIZ_TXT.showNone)
	FIZ_ExpandButton:SetText(FIZ_TXT.expand)
	FIZ_CollapseButton:SetText(FIZ_TXT.collapse)

	FIZ_SupressNoneFactionButton:SetText(FIZ_TXT.supressNoneFaction)
	FIZ_SupressNoneGlobalButton:SetText(FIZ_TXT.supressNoneGlobal)
	FIZ_ReputationDetailSuppressHint:SetText(FIZ_TXT.suppressHint)
	FIZ_ClearSessionGainButton:SetText(FIZ_TXT.clearSessionGain)

	local filter = FIZ.searchFilter or ""
	local visibleIndices = {}
	local max = FIZ:TableSize(FIZ_UpdateList)
	for idx = 1, max do
		local entry = FIZ_UpdateList[idx]
		if entry and entry.isShown and MatchesSearchFilter(entry, filter) then
			table.insert(visibleIndices, idx)
		end
	end

	local numEntries = #visibleIndices
	if not FauxScrollFrame_Update(FIZ_UpdateListScrollFrame, numEntries, FIZ_UPDATE_LIST_HEIGHT, ROW_HEIGHT) then
		if FIZ_UpdateListScrollFrameScrollBar then
			FIZ_UpdateListScrollFrameScrollBar:SetValue(0)
		end
	end
	local entryOffset = FauxScrollFrame_GetOffset(FIZ_UpdateListScrollFrame) or 0

	local haveInfo = numEntries > 0

	for row = 1, FIZ_UPDATE_LIST_HEIGHT do
		local listPos = entryOffset + row
		local entryIndex = visibleIndices[listPos]
		if entryIndex and FIZ_UpdateList[entryIndex] then
			local entryFrameName = "FIZ_UpdateEntry" .. row
			local entryFrame = _G[entryFrameName]
			local entryTexture = _G[entryFrameName .. "Texture"]

			local entryLabel = _G[entryFrameName .. "Label"]
			local entryName = _G[entryFrameName .. "Name"]
			local entryRep = _G[entryFrameName .. "Rep"]
			local entryTimes = _G[entryFrameName .. "Times"]

			local entryItemTimes = _G[entryFrameName .. "ItemTimes"]
			local entryItemName = _G[entryFrameName .. "ItemName"]
			local entryItemTotal = _G[entryFrameName .. "TotalTimes"]
			local F_UL_ei = FIZ_UpdateList[entryIndex]

			if entryFrame then
				entryFrame:Show()
				entryFrame.id = F_UL_ei.index
				entryFrame.tooltipHead = F_UL_ei.tooltipHead
				entryFrame.tooltipTip = F_UL_ei.tooltipTip
				entryFrame.tooltipDetails = F_UL_ei.tooltipDetails
			end

			local color = ""
			if F_UL_ei.highlight then
				color = FIZ_HIGHLIGHT_COLOUR
			elseif F_UL_ei.suppress then
				color = FIZ_SUPPRESS_COLOUR
			elseif F_UL_ei.lowlight then
				color = FIZ_LOWLIGHT_COLOUR
			end

			if F_UL_ei.type ~= "" then
				if entryTexture then
					if F_UL_ei.hasList then
						if F_UL_ei.listShown then
							entryTexture:SetTexture("Interface\\Buttons\\UI-MinusButton-Up")
						else
							entryTexture:SetTexture("Interface\\Buttons\\UI-PlusButton-Up")
						end
					else
						entryTexture:SetTexture("Interface\\Buttons\\UI-CheckBox-Up")
					end
					if F_UL_ei.suppress then
						entryTexture:SetVertexColor(0.5, 0.5, 0.5, 0.8)
					else
						entryTexture:SetVertexColor(0.3, 1.0, 0.4, 1.0)
					end
					if F_UL_ei.canSuppress or F_UL_ei.hasList then
						entryTexture:Show()
					else
						entryTexture:Hide()
					end
				end

				entryLabel:Show()
				entryName:Show()
				entryRep:Show()
				entryTimes:Show()

				local badgeColor = (color ~= "" and color) or GetBadgeColor(F_UL_ei.type)
				entryLabel:SetText(badgeColor .. F_UL_ei.type .. "|r")
				entryName:SetText(color .. F_UL_ei.name)
				entryRep:SetText((color ~= "" and color or "|cFF88DDFF") .. F_UL_ei.rep .. "|r")
				entryTimes:SetText(color .. F_UL_ei.times)

				entryItemTimes:Hide()
				entryItemName:Hide()
				entryItemTotal:Hide()
			else
				entryTexture:Hide()
				entryLabel:Hide()
				entryName:Hide()
				entryRep:Hide()
				entryTimes:Hide()

				entryItemTimes:Show()
				entryItemName:Show()

				entryItemTimes:SetText(color .. F_UL_ei.times)
				entryItemName:SetText(color .. F_UL_ei.name)
			end
		else
			local entryFrame = _G["FIZ_UpdateEntry" .. row]
			if entryFrame then entryFrame:Hide() end
		end
	end

	if haveInfo then
		FIZ_NoInformationText:Hide()
	else
		FIZ_NoInformationText:SetText(FIZ_TXT.noInfo)
		FIZ_NoInformationText:Show()
	end
end

function FIZ_MouseButtonUp(self, button)
	if button == "LeftButton" then
		FIZ_UpdateEntryClick(self)
	elseif button == "RightButton" then
		FIZ:UpdateEntrySuppress(self)
	end
end

function FIZ_UpdateEntryClick(self)
	if FIZ_UpdateList[self.id] and FIZ_UpdateList[self.id].hasList then
		if FIZ_UpdateList[self.id].listShown then
			FIZ:ShowUpdateEntry(self.id, false)
		else
			FIZ:ShowUpdateEntry(self.id, true)
		end
	end
end

function FIZ:UpdateEntrySuppress(self)
	if FIZ_UpdateList[self.id] and FIZ_UpdateList[self.id].type ~= "" then
		local entry = FIZ_UpdateList[self.id]
		if entry.faction and entry.originalName then
			if not FIZ_Suppressed then
				FIZ_Suppressed = {}
			end
			if not FIZ_Suppressed[entry.faction] then
				FIZ_Suppressed[entry.faction] = {}
			end
			if FIZ_Suppressed[entry.faction][entry.originalName] then
				FIZ_Suppressed[entry.faction][entry.originalName] = nil
			else
				FIZ_Suppressed[entry.faction][entry.originalName] = true
			end
			if self.db and self.db.profile then
				self.db.profile.Suppressed = FIZ_Suppressed
			end
			self:BuildUpdateList()
		end
	end
end

function FIZ:SupressNone(allFactions)
	if allFactions == true then
		FIZ_Suppressed = {}
		if self.db and self.db.profile then
			self.db.profile.Suppressed = FIZ_Suppressed
		end
		self:BuildUpdateList()
	else
		local factionIndex = self:GetSelectedFaction()
		local faction = self:GetRawFactionInfo(factionIndex)
		if faction then
			faction = string.lower(faction)
			if FIZ_FactionMapping[faction] then
				faction = FIZ_FactionMapping[faction]
			end
			if not FIZ_Suppressed then
				FIZ_Suppressed = {}
			end
			FIZ_Suppressed[faction] = {}
			if self.db and self.db.profile then
				self.db.profile.Suppressed = FIZ_Suppressed
			end
		end
		self:BuildUpdateList()
	end
end

function FIZ:GetUpdateListSize()
	local count = 0
	local highest = 0
	for i in pairs(FIZ_UpdateList) do
		if FIZ_UpdateList[i].isShown then
			count = count + 1
			if i > highest then
				highest = i
			end
		end
	end
	return count, highest
end

function FIZ:ShowUpdateEntry(index, show)
	if not FIZ_UpdateList[index] then return end
	if not FIZ_UpdateList[index].hasList then return end
	if type(show) ~= "boolean" then return end

	FIZ_UpdateList[index].listShown = show
	for i in pairs(FIZ_UpdateList) do
		if FIZ_UpdateList[i].belongsTo == index then
			FIZ_UpdateList[i].isShown = show
		end
	end

	FIZ_UpdateList_Update()
end

function FIZ_ShowUpdateEntries(show)
	if type(show) ~= "boolean" then return end

	for i in pairs(FIZ_UpdateList) do
		if FIZ_UpdateList[i].belongsTo == nil then
			FIZ_UpdateList[i].isShown = true
			FIZ_UpdateList[i].listShown = show
		else
			FIZ_UpdateList[i].isShown = show
		end
	end

	FIZ_UpdateList_Update()
end

function FIZ_ShowLineToolTip(self)
	if not self then return end

	if self.tooltipHead then
		GameTooltip_SetDefaultAnchor(GameTooltip, self)
		GameTooltip:SetText(self.tooltipHead, 1, 1, 0.5, 1)
		if self.tooltipTip then
			GameTooltip:AddLine(self.tooltipTip, 1, 1, 1, 1)
		end
		if self.tooltipDetails and type(self.tooltipDetails) == "table" and self.tooltipDetails.count then
			GameTooltip:AddLine(" ", 1, 1, 1, 1)
			for i = 0, self.tooltipDetails.count do
				if self.tooltipDetails[i] and self.tooltipDetails[i].l and self.tooltipDetails[i].r then
					if self.tooltipDetails[i].r == " " or self.tooltipDetails[i].r == "" then
						GameTooltip:AddDoubleLine(self.tooltipDetails[i].l, self.tooltipDetails[i].r, 1, 1, 0, 1, 1, 1)
					else
						GameTooltip:AddDoubleLine(self.tooltipDetails[i].l, self.tooltipDetails[i].r, 1, 1, 0.5, 1, 1, 1)
					end
				end
			end
		end
		GameTooltip:Show()
	end
end

function FIZ_ShowHelpToolTip(self, element)
	if not element then return end
	local name = element
	local tip = ""
	local head = ""
	if FIZ_TXT.elements and FIZ_TXT.elements.name and FIZ_TXT.elements.tip and FIZ_TXT.elements.name[name] and FIZ_TXT.elements.tip[name] then
		tip = FIZ_TXT.elements.tip[name]
		head = FIZ_TXT.elements.name[name]
	end

	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	if head ~= "" then
		GameTooltip:SetText(head, 1, 1, 0.5, 1.0, true)
		GameTooltip:AddLine(tip, 1, 1, 1, 1.0, true)
	end
	GameTooltip:Show()
end

function FIZ:EnsureValidSelectedFaction()
	local sel = self:GetSelectedFaction()
	if sel and sel > 0 then
		local name, _, _, _, _, _, _, _, isHeader, _, hasRep = self:GetRawFactionInfo(sel)
		if name and (not isHeader or hasRep) then
			self.selectedFactionName = name
			return sel
		end
	end
	local numFactions = self:GetNumFactions()
	local firstValid = 0
	for i = 1, numFactions do
		local name, _, _, _, _, _, _, _, isHeader, _, hasRep, isWatched = self:GetRawFactionInfo(i)
		if name and (not isHeader or hasRep) then
			if firstValid == 0 then
				firstValid = i
			end
			if isWatched then
				self.selectedFactionName = name
				self:SetSelectedFaction(i)
				return i
			end
		end
	end
	if firstValid > 0 then
		local name = self:GetRawFactionInfo(firstValid)
		self.selectedFactionName = name
		self:SetSelectedFaction(firstValid)
	end
	return firstValid
end

function FIZ:ToggleDetailWindow()
	self:CreateModernDetailFrame()
	if ReputationFrame and ReputationFrame:IsVisible() then
		if FIZ_Data.ExtendDetails then
			if FIZ_ReputationDetailFrame and FIZ_ReputationDetailFrame:IsVisible() then
				FIZ_ReputationDetailFrame:Hide()
				HideUIPanel(CharacterFrame)
			else
				self:EnsureValidSelectedFaction()
				if FIZ_ReputationDetailFrame then FIZ_ReputationDetailFrame:Show() end
				if ReputationDetailFrame then ReputationDetailFrame:Hide() end
				self:RefreshReputationFrame()
			end
		else
			if ReputationDetailFrame and ReputationDetailFrame:IsVisible() then
				ReputationDetailFrame:Hide()
				HideUIPanel(CharacterFrame)
			else
				self:EnsureValidSelectedFaction()
				if FIZ_ReputationDetailFrame then FIZ_ReputationDetailFrame:Hide() end
				if ReputationDetailFrame then ReputationDetailFrame:Show() end
				self:RefreshReputationFrame()
			end
		end
	else
		ToggleCharacter("ReputationFrame")
		self:EnsureValidSelectedFaction()
		if FIZ_Data.ExtendDetails then
			if FIZ_ReputationDetailFrame then FIZ_ReputationDetailFrame:Show() end
		else
			if ReputationDetailFrame then ReputationDetailFrame:Show() end
		end
		self:RefreshReputationFrame()
	end
end

function FIZ_ToggleDetailWindow()
	FIZ:ToggleDetailWindow()
end

function FIZ_ReputationDetailFrame_IsShown(faction, flag, flag2, i)
	if not ReputationDetailFrame then return end
	local name, description, _, _, _, _, atWarWith, _, isHeader, _, _, isWatched = FIZ:GetFactionInfo(faction)
	if ReputationDetailFactionName then ReputationDetailFactionName:SetText(name or "") end
	if ReputationDetailFactionDescription then ReputationDetailFactionDescription:SetText(description or "") end
	if ReputationDetailAtWarCheckBox then
		ReputationDetailAtWarCheckBox:SetChecked(atWarWith and true or false)
		if flag then
			ReputationDetailAtWarCheckBox:Enable()
			if ReputationDetailAtWarCheckBoxText then
				ReputationDetailAtWarCheckBoxText:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
			end
		else
			ReputationDetailAtWarCheckBox:Disable()
			if ReputationDetailAtWarCheckBoxText then
				ReputationDetailAtWarCheckBoxText:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)
			end
		end
	end

	if flag2 == 2 then
		if ReputationDetailInactiveCheckBox then
			if not isHeader then
				ReputationDetailInactiveCheckBox:Enable()
				if ReputationDetailInactiveCheckBoxText then
					ReputationDetailInactiveCheckBoxText:SetTextColor(ReputationDetailInactiveCheckBoxText:GetFontObject():GetTextColor())
				end
			else
				ReputationDetailInactiveCheckBox:Disable()
				if ReputationDetailInactiveCheckBoxText then
					ReputationDetailInactiveCheckBoxText:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)
				end
			end
		end
		if i then
			if _G["ReputationBar" .. i .. "ReputationBarHighlight1"] then _G["ReputationBar" .. i .. "ReputationBarHighlight1"]:Show() end
			if _G["ReputationBar" .. i .. "ReputationBarHighlight2"] then _G["ReputationBar" .. i .. "ReputationBarHighlight2"]:Show() end
		end
	end

	if ReputationDetailInactiveCheckBox then
		ReputationDetailInactiveCheckBox:SetChecked(FIZ:IsFactionInactive(faction))
	end
	if ReputationDetailMainScreenCheckBox then
		ReputationDetailMainScreenCheckBox:SetChecked(isWatched and true or false)
	end
end

function FIZ:Rep_Detail_Frame(faction, colorID, barValue, barMax, origBarValue, standingID, toExalted, factionStandingtext)
	self:CreateModernDetailFrame()
	local name, description, _, _, _, _, atWarWith, canToggleAtWar, _, _, _, isWatched = self:GetFactionInfo(faction)
	local gender = UnitSex("player")
	self:BuildUpdateList()

	FIZ_ReputationDetailFactionName:SetText(name or "")
	FIZ_ReputationDetailFactionDescription:SetText(description or "")

	FIZ_ReputationDetailStandingName:SetText(factionStandingtext or "")
	local color = FACTION_BAR_COLORS[colorID] or FACTION_BAR_COLORS[5]
	if color then
		FIZ_ReputationDetailStandingName:SetTextColor(color.r, color.g, color.b)
	end

	-- Update Live Progress Bar & Preview Bar inside Detail Frame
	local safeMax = math.max(1, barMax or 1)
	local safeVal = math.max(0, math.min(barValue or 0, safeMax))
	if self.DetailProgressBar then
		self.DetailProgressBar:SetMinMaxValues(0, safeMax)
		self.DetailProgressBar:SetValue(safeVal)
		if color then
			self.DetailProgressBar:SetStatusBarColor(color.r, color.g, color.b, 0.9)
		end
	end
	local previewGain = (FIZ_CurrentRepInBag or 0) + (FIZ_CurrentRepInQuest or 0)
	if self.DetailPreviewBar then
		self.DetailPreviewBar:SetMinMaxValues(0, safeMax)
		if previewGain > 0 then
			self.DetailPreviewBar:SetValue(math.min(safeMax, safeVal + previewGain))
			self.DetailPreviewBar:Show()
		else
			self.DetailPreviewBar:SetValue(0)
			self.DetailPreviewBar:Hide()
		end
	end
	if self.DetailProgressText then
		local pct = (safeVal / safeMax) * 100
		if previewGain > 0 then
			self.DetailProgressText:SetText(string.format("%d / %d (%.1f%%) |cff55ff88+%d|r", safeVal, safeMax, pct, previewGain))
		else
			self.DetailProgressText:SetText(string.format("%d / %d (%.1f%%)", safeVal, safeMax, pct))
		end
	end

	FIZ_ReputationDetailStandingCurrent:SetText(FIZ_TXT.currentRep)
	FIZ_ReputationDetailStandingNeeded:SetText(FIZ_TXT.neededRep)
	FIZ_ReputationDetailStandingMissing:SetText(FIZ_TXT.missingRep)
	FIZ_ReputationDetailStandingBag:SetText(FIZ_TXT.repInBag)
	FIZ_ReputationDetailStandingBagBank:SetText(FIZ_TXT.repInBagBank)
	FIZ_ReputationDetailStandingQuests:SetText(FIZ_TXT.repInQuest)
	FIZ_ReputationDetailStandingGained:SetText(FIZ_TXT.factionGained)

	FIZ_ReputationDetailStandingCurrentValue:SetText(barValue)
	FIZ_ReputationDetailStandingNeededValue:SetText(barMax)
	FIZ_ReputationDetailStandingMissingValue:SetText("|cFFFF7755" .. tostring(barMax - barValue) .. "|r")
	FIZ_ReputationDetailStandingBagValue:SetText((FIZ_CurrentRepInBag > 0 and "|cFF55FF88+" or "") .. tostring(FIZ_CurrentRepInBag) .. (FIZ_CurrentRepInBag > 0 and "|r" or ""))
	FIZ_ReputationDetailStandingBagBankValue:SetText((FIZ_CurrentRepInBagBank > 0 and "|cFFFFFF66+" or "") .. tostring(FIZ_CurrentRepInBagBank) .. (FIZ_CurrentRepInBagBank > 0 and "|r" or ""))
	FIZ_ReputationDetailStandingQuestsValue:SetText((FIZ_CurrentRepInQuest > 0 and "|cFF55CCFF+" or "") .. tostring(FIZ_CurrentRepInQuest) .. (FIZ_CurrentRepInQuest > 0 and "|r" or ""))

	if FIZ_StoredRep and name and FIZ_StoredRep[name] and FIZ_StoredRep[name].origRep then
		local diff = origBarValue - FIZ_StoredRep[name].origRep
		FIZ_ReputationDetailStandingGainedValue:SetText((diff > 0 and "|cFFFFD100+" or "") .. string.format("%d", diff) .. (diff > 0 and "|r" or ""))
	else
		FIZ_ReputationDetailStandingGainedValue:SetText("0")
	end

	if standingID < 8 then
		local nextColor = FACTION_BAR_COLORS[standingID + 1] or FACTION_BAR_COLORS[5]
		FIZ_ReputationDetailStandingNextValue:SetText("--> " .. GetText("FACTION_STANDING_LABEL" .. (standingID + 1), gender))
		if nextColor then
			FIZ_ReputationDetailStandingNextValue:SetTextColor(nextColor.r, nextColor.g, nextColor.b)
		end
	else
		FIZ_ReputationDetailStandingNextValue:SetText("")
	end

	if standingID < 7 then
		FIZ_ReputationDetailStandingToExaltedHeader:SetText(FIZ_TXT.toExalted)
		FIZ_ReputationDetailStandingToExaltedValue:SetText("|cFF99BBFF" .. tostring(toExalted) .. "|r")
	else
		FIZ_ReputationDetailStandingToExaltedHeader:SetText("")
		FIZ_ReputationDetailStandingToExaltedValue:SetText("")
	end

	FIZ_ReputationDetailAtWarCheckBox:SetChecked(atWarWith and true or false)
	if canToggleAtWar then
		FIZ_ReputationDetailAtWarCheckBox:Enable()
		FIZ_ReputationDetailAtWarCheckBoxText:SetTextColor(RED_FONT_COLOR.r, RED_FONT_COLOR.g, RED_FONT_COLOR.b)
	else
		FIZ_ReputationDetailAtWarCheckBox:Disable()
		FIZ_ReputationDetailAtWarCheckBoxText:SetTextColor(GRAY_FONT_COLOR.r, GRAY_FONT_COLOR.g, GRAY_FONT_COLOR.b)
	end

	FIZ_ReputationDetailInactiveCheckBox:SetChecked(self:IsFactionInactive(faction))
	FIZ_ReputationDetailMainScreenCheckBox:SetChecked(isWatched and true or false)
end

function FIZ_Friend_Detail(factionID, standingID, factionRow)
	local colorIndex, factionStandingtext, isCappedFriendship
	local gender = UnitSex("player")
	local friendID, friendRep, _, _, _, _, friendTextLevel, friendThreshold, nextFriendThreshold = FIZ:GetFriendshipInfo(factionID)
	if friendID ~= nil then
		if not nextFriendThreshold then
			isCappedFriendship = true
		end
		colorIndex = 5
		factionStandingtext = friendTextLevel
		if factionRow then factionRow.friendshipID = friendID end
	else
		factionStandingtext = GetText("FACTION_STANDING_LABEL" .. (standingID or 4), gender)
		if factionRow then factionRow.friendshipID = nil end
		colorIndex = standingID or 4
	end
	return colorIndex, isCappedFriendship, factionStandingtext, friendID, friendRep, friendThreshold, nextFriendThreshold
end
