----------------------------------------------------------
-- Factionizer - ReputationFrame Hooks & Bar Rendering  --
----------------------------------------------------------

local FIZ = _G.FIZ

function FIZ:PositionReputationFrameControls()
	if not ReputationFrame then return end
	local optBtn = _G.FIZ_OptionsButton
	local pill = _G.FIZ_OrderByStandingCheckBox
	local baseLevel = (ReputationListScrollFrame and ReputationListScrollFrame:GetFrameLevel())
		or ReputationFrame:GetFrameLevel()
		or 1
	local targetLevel = baseLevel + 15

	if ReputationFrameFactionLabel then
		ReputationFrameFactionLabel:Hide()
	end
	if ReputationFrameStandingLabel then
		ReputationFrameStandingLabel:Hide()
	end

	if optBtn then
		optBtn:SetFrameLevel(targetLevel)
		optBtn._lockHeight = true
		optBtn:SetHeight(20)
		optBtn:ClearAllPoints()
		if ReputationListScrollFrame then
			optBtn:SetPoint("BOTTOMRIGHT", ReputationListScrollFrame, "TOPRIGHT", -2, 6)
		elseif ReputationFrame.ReputationDetailFrame then
			optBtn:SetPoint("TOPRIGHT", ReputationFrame, "TOPRIGHT", -28, -28)
		else
			optBtn:SetPoint("TOPLEFT", ReputationFrame, "TOPLEFT", 210, -42)
		end
	end

	if pill then
		pill:SetFrameLevel(targetLevel)
		pill:SetHeight(20)
		pill:ClearAllPoints()
		if ReputationListScrollFrame and optBtn then
			pill:SetPoint("BOTTOMLEFT", ReputationListScrollFrame, "TOPLEFT", 46, 6)
			pill:SetPoint("RIGHT", optBtn, "LEFT", -6, 0)
			pill._fixedWidth = true
		else
			pill:SetPoint("TOPLEFT", ReputationFrame, "TOPLEFT", 68, -42)
		end
	end
end

function FIZ:CreateReputationFrameControls()
	if not ReputationFrame then return end
	local UIStyle = self.UIStyle

	-- 1. Options Button on ReputationFrame
	if not _G.FIZ_OptionsButton then
		local optBtn
		if UIStyle then
			optBtn = UIStyle.CreateButton(ReputationFrame, 88, 20, FIZ_TXT.options or "Options", "primary", "Interface\\Icons\\Achievement_Reputation_01", "FIZ_OptionsButton")
			optBtn._lockHeight = true
			optBtn:SetHeight(20)
		else
			optBtn = CreateFrame("Button", "FIZ_OptionsButton", ReputationFrame, "UIPanelButtonTemplate")
			optBtn:SetSize(84, 20)
			optBtn:SetText(FIZ_TXT.options or "Options")
		end
		optBtn:SetScript("OnClick", function()
			FIZ:ToggleConfigWindow()
		end)
		optBtn:HookScript("OnEnter", function(btn)
			FIZ_ShowHelpToolTip(btn, "FIZ_OptionsButton")
		end)
		optBtn:HookScript("OnLeave", function()
			if GameTooltip then GameTooltip:Hide() end
		end)
	else
		_G.FIZ_OptionsButton:SetText(FIZ_TXT.options or "Options")
	end

	-- 2. Order By Standing Filter Pill / CheckBox on ReputationFrame
	if not _G.FIZ_OrderByStandingCheckBox then
		if UIStyle then
			local pill = UIStyle.CreateFilterPill(
				ReputationFrame,
				FIZ_TXT.orderByStanding or "Order by Standing",
				FIZ_Data and FIZ_Data.SortByStanding or false,
				function(_, active)
					FIZ:SetOption("SortByStanding", active)
					FIZ:RefreshReputationFrame()
				end,
				"FIZ_OrderByStandingCheckBox"
			)
			pill:SetHeight(20)
			pill:HookScript("OnEnter", function(selfBtn)
				FIZ_ShowHelpToolTip(selfBtn, "FIZ_OrderByStandingCheckBox")
			end)
		else
			local cb = CreateFrame("CheckButton", "FIZ_OrderByStandingCheckBox", ReputationFrame, "UICheckButtonTemplate")
			cb:SetSize(22, 22)
			cb:SetHitRectInsets(0, -140, 0, 0)
			local cbText = _G["FIZ_OrderByStandingCheckBoxText"] or cb.Text or cb.text
			if cbText then
				cbText:SetText(FIZ_TXT.orderByStanding or "Order by Standing")
			end
			cb:SetChecked(FIZ_Data and FIZ_Data.SortByStanding or false)
			cb:SetScript("OnClick", function(selfBtn)
				FIZ:SetOption("SortByStanding", selfBtn:GetChecked())
				FIZ:PlayCheckBoxSound(FIZ_Data.SortByStanding)
				FIZ:RefreshReputationFrame()
			end)
			cb:SetScript("OnEnter", function(selfBtn)
				FIZ_ShowHelpToolTip(selfBtn, "FIZ_OrderByStandingCheckBox")
			end)
			cb:SetScript("OnLeave", function()
				if GameTooltip then GameTooltip:Hide() end
			end)
		end
	else
		if _G.FIZ_OrderByStandingCheckBox.SetText then
			_G.FIZ_OrderByStandingCheckBox:SetText(FIZ_TXT.orderByStanding or "Order by Standing")
		else
			local cbText = _G["FIZ_OrderByStandingCheckBoxText"] or _G.FIZ_OrderByStandingCheckBox.Text
			if cbText then
				cbText:SetText(FIZ_TXT.orderByStanding or "Order by Standing")
			end
		end
		_G.FIZ_OrderByStandingCheckBox:SetChecked(FIZ_Data and FIZ_Data.SortByStanding or false)
	end

	self:PositionReputationFrameControls()
	if not ReputationFrame._fizShowHooked then
		ReputationFrame._fizShowHooked = true
		ReputationFrame:HookScript("OnShow", function()
			FIZ:PositionReputationFrameControls()
		end)
	end

	-- 3. Create preview bars dynamically on Classic clients where ReputationBar1..15 exist
	self:CreateClassicPreviewBars()
end

function FIZ:CreateClassicPreviewBars()
	local texPath = self:GetStatusBarTexturePath()
	for i = 1, 15 do
		local repBar = _G["ReputationBar" .. i]
		local repStatusBar = _G["ReputationBar" .. i .. "ReputationBar"]
		if repBar and repStatusBar and not _G["FIZ_StatusBar" .. i] then
			local previewBar = CreateFrame("StatusBar", "FIZ_StatusBar" .. i, repBar)
			previewBar:SetSize(101, 5)
			previewBar:SetPoint("TOPLEFT", repStatusBar, "TOPLEFT", 0, 0)
			previewBar:SetMinMaxValues(0, 1)
			previewBar:SetValue(0)
			previewBar:SetStatusBarTexture(texPath)
			previewBar:SetStatusBarColor(0.25, 0.9, 0.55, 0.65)
			previewBar:Hide()
		end
	end
end

function FIZ:SetupHooks()
	if ReputationFrameStandingLabel and not FIZ_Orig_StandingText then
		FIZ_Orig_StandingText = ReputationFrameStandingLabel:GetText() or ""
	end

	self:CreateReputationFrameControls()
	self:CreateModernDetailFrame()

	if _G.GetFactionInfo and not FIZ_Orig_GetFactionInfo then
		FIZ_Orig_GetFactionInfo = _G.GetFactionInfo
	end
	if _G.GetNumFactions and not FIZ_Orig_GetNumFactions then
		FIZ_Orig_GetNumFactions = _G.GetNumFactions
	end

	-- Use AceHook-3.0 for all ReputationFrame hooks
	if _G.ReputationFrame_Update and not self:IsHooked("ReputationFrame_Update") then
		self:RawHook("ReputationFrame_Update", "ReputationFrame_Update", true)
	end
	if _G.ReputationBar_OnClick and not self:IsHooked("ReputationBar_OnClick") then
		self:RawHook("ReputationBar_OnClick", "ReputationBar_OnClick", true)
	end
	if _G.ExpandFactionHeader and not self:IsHooked("ExpandFactionHeader") then
		self:RawHook("ExpandFactionHeader", "Hook_ExpandFactionHeader", true)
	end
	if _G.CollapseFactionHeader and not self:IsHooked("CollapseFactionHeader") then
		self:RawHook("CollapseFactionHeader", "Hook_CollapseFactionHeader", true)
	end

	-- Retail 11.x / 12.x ReputationFrame ScrollBox / ReputationDetailFrame support
	if ReputationFrame and not _G.ReputationFrame_Update and ReputationFrame.Update then
		if not self:IsHooked(ReputationFrame, "Update") then
			self:SecureHook(ReputationFrame, "Update", "OnRetailReputationFrameUpdate")
		end
		if _G.FIZ_OrderByStandingCheckBox then
			_G.FIZ_OrderByStandingCheckBox:Hide()
		end
		if _G.FIZ_OptionsButton then
			_G.FIZ_OptionsButton:ClearAllPoints()
			_G.FIZ_OptionsButton:SetPoint("TOPRIGHT", ReputationFrame, "TOPRIGHT", -25, -28)
		end
	end
end

function FIZ:OnRetailReputationFrameUpdate()
	local selectedIndex = self:GetSelectedFaction()
	if selectedIndex == 0 then
		if FIZ_ReputationDetailFrame then
			FIZ_ReputationDetailFrame:Hide()
		end
		return
	end

	if FIZ_Data.ExtendDetails then
		if ReputationFrame and ReputationFrame.ReputationDetailFrame and ReputationFrame.ReputationDetailFrame:IsShown() then
			ReputationFrame.ReputationDetailFrame:Hide()
			if FIZ_ReputationDetailFrame then
				FIZ_ReputationDetailFrame:Show()
			end
		end
	end

	if FIZ_ReputationDetailFrame and FIZ_ReputationDetailFrame:IsVisible() then
		local name, _, standingID, barMin, barMax, barValue, _, _, isHeader, _, hasRep, _, _, factionID = self:GetFactionInfo(selectedIndex)
		if name and (not isHeader or hasRep) then
			self.selectedFactionName = name
			local gender = UnitSex("player")
			local colorIndex, _, factionStandingtext = FIZ_Friend_Detail(factionID, standingID, {})
			local origBarValue = barValue
			barMax = barMax - barMin
			barValue = barValue - barMin
			local toExalted = 0
			if standingID < 8 then
				toExalted = (FIZ_ToExalted[standingID] or 0) + barMax - barValue
			end
			self:Rep_Detail_Frame(selectedIndex, colorIndex or standingID, barValue, barMax, origBarValue, standingID, toExalted, factionStandingtext or GetText("FACTION_STANDING_LABEL" .. standingID, gender))
			FIZ_UpdateList_Update()
		else
			FIZ_ReputationDetailFrame:Hide()
		end
	end
end

function FIZ_GetFactionInfo(factionIndex)
	return FIZ:GetFactionInfo(factionIndex)
end

function FIZ:ReputationFrame_Update()
	self:PositionReputationFrameControls()
	local numFactions
	if FIZ_Data.SortByStanding then
		self:StandingSort()
		numFactions = FIZ_OBS_numFactions
	else
		numFactions = self:GetNumFactions()
		-- Keep selected faction synced by name when headers are expanded/collapsed
		local selIndex = self:GetSelectedFaction()
		if selIndex and selIndex > 0 then
			local selName, _, _, _, _, _, _, _, selHeader, _, selHasRep = self:GetRawFactionInfo(selIndex)
			if (self.selectedFactionName and selName ~= self.selectedFactionName) or (selHeader and not selHasRep) then
				local foundIndex = 0
				if self.selectedFactionName then
					for idx = 1, numFactions do
						local fName, _, _, _, _, _, _, _, fHeader, _, fHasRep = self:GetRawFactionInfo(idx)
						if fName == self.selectedFactionName and (not fHeader or fHasRep) then
							foundIndex = idx
							break
						end
					end
				end
				self:SetSelectedFaction(foundIndex)
			elseif selName and (not selHeader or selHasRep) then
				self.selectedFactionName = selName
			end
		end
	end

	local numDisplayed = NUM_FACTIONS_DISPLAYED or 15
	local factionHeight = REPUTATIONFRAME_FACTIONHEIGHT or 26
	if ReputationListScrollFrame then
		if not FauxScrollFrame_Update(ReputationListScrollFrame, numFactions, numDisplayed, factionHeight) then
			if ReputationListScrollFrameScrollBar then
				ReputationListScrollFrameScrollBar:SetValue(0)
			end
		end
	end
	local factionOffset = ReputationListScrollFrame and FauxScrollFrame_GetOffset(ReputationListScrollFrame) or 0

	for i = 1, numDisplayed do
		local factionIndex = factionOffset + i
		local factionRow = _G["ReputationBar" .. i]
		local factionBar = _G["ReputationBar" .. i .. "ReputationBar"]
		local factionTitle = _G["ReputationBar" .. i .. "FactionName"]
		local factionButton = _G["ReputationBar" .. i .. "ExpandOrCollapseButton"]
		local factionStanding = _G["ReputationBar" .. i .. "ReputationBarFactionStanding"]
		local factionBackground = _G["ReputationBar" .. i .. "Background"]
		local factionBarPreview = _G["FIZ_StatusBar" .. i]

		if factionRow then
			if factionIndex <= numFactions then
				if FIZ_Data.SortByStanding then
					self:SortByStanding(i, factionIndex, factionRow, factionBar, factionBarPreview, factionTitle, factionButton, factionStanding, factionBackground)
				else
					self:OriginalRepOrder(i, factionIndex, factionRow, factionBar, factionBarPreview, factionTitle, factionButton, factionStanding, factionBackground)
				end
			else
				factionRow:Hide()
			end
		end
	end

	if self:GetSelectedFaction() == 0 then
		if ReputationDetailFrame then
			ReputationDetailFrame:Hide()
		end
		if FIZ_ReputationDetailFrame then
			FIZ_ReputationDetailFrame:Hide()
		end
	end
end

function FIZ_ReputationFrame_Update()
	FIZ:ReputationFrame_Update()
end

function FIZ:Hook_ExpandFactionHeader(index)
	if not FIZ_Entries then return end
	if FIZ_Data.SortByStanding then
		if not FIZ_Entries[index] then return end
		FIZ_Collapsed[FIZ_Entries[index].i] = nil
		self:ReputationFrame_Update()
	else
		if self.hooks and self.hooks.ExpandFactionHeader then
			self.hooks.ExpandFactionHeader(index)
		else
			self:ExpandFactionHeader(index)
		end
	end
end

function FIZ:Hook_CollapseFactionHeader(index)
	if not FIZ_Entries then return end
	if FIZ_Data.SortByStanding then
		if not FIZ_Entries[index] then return end
		FIZ_Collapsed[FIZ_Entries[index].i] = true
		self:ReputationFrame_Update()
	else
		if self.hooks and self.hooks.CollapseFactionHeader then
			self.hooks.CollapseFactionHeader(index)
		else
			self:CollapseFactionHeader(index)
		end
	end
end

function FIZ_ReputationFrame_SetRowType(factionRow, isChild, isHeader, hasRep)
	if not factionRow then return end
	local factionRowName = factionRow:GetName()
	local factionBar = _G[factionRowName .. "ReputationBar"]
	local factionTitle = _G[factionRowName .. "FactionName"]
	local factionButton = _G[factionRowName .. "ExpandOrCollapseButton"]
	local factionStanding = _G[factionRowName .. "ReputationBarFactionStanding"]
	local factionBackground = _G[factionRowName .. "Background"]
	local factionLeftTexture = _G[factionRowName .. "ReputationBarLeftTexture"]
	local factionRightTexture = _G[factionRowName .. "ReputationBarRightTexture"]

	if factionLeftTexture then factionLeftTexture:SetWidth(62) end
	if factionRightTexture then factionRightTexture:SetWidth(42) end
	if factionBar then factionBar:SetPoint("RIGHT", factionRow, "RIGHT", 0, 0) end

	if isHeader then
		factionRow:SetPoint("LEFT", ReputationFrame, "LEFT", 10, 0)
		if factionTitle then factionTitle:SetWidth(145) end
		if factionButton then
			factionButton:SetPoint("LEFT", factionRow, "LEFT", 3, 0)
			factionButton:Show()
		end
		if factionTitle and factionButton then
			factionTitle:SetPoint("LEFT", factionButton, "RIGHT", 10, 0)
			factionTitle:SetFontObject(GameFontNormalLeft)
		end
		if factionBackground then factionBackground:Hide() end
		if factionLeftTexture then
			factionLeftTexture:SetHeight(15)
			factionLeftTexture:SetWidth(60)
			factionLeftTexture:SetTexCoord(0.765625, 1.0, 0.046875, 0.28125)
		end
		if factionRightTexture then
			factionRightTexture:SetHeight(15)
			factionRightTexture:SetWidth(39)
			factionRightTexture:SetTexCoord(0.0, 0.15234375, 0.390625, 0.625)
		end
		if factionBar then factionBar:SetWidth(99) end
		if factionRow.LFGBonusRepButton and factionButton then
			factionRow.LFGBonusRepButton:SetPoint("RIGHT", factionButton, "LEFT", 0, 1)
		end
	else
		factionRow:SetPoint("LEFT", ReputationFrame, "LEFT", 29, 0)
		if factionTitle then
			factionTitle:SetWidth(160)
			factionTitle:SetPoint("LEFT", factionRow, "LEFT", 10, 0)
			factionTitle:SetFontObject(GameFontHighlightSmall)
		end
		if factionButton then factionButton:Hide() end
		if factionBackground then factionBackground:Show() end
		if factionLeftTexture then
			factionLeftTexture:SetHeight(21)
			factionLeftTexture:SetTexCoord(0.7578125, 1.0, 0.0, 0.328125)
		end
		if factionRightTexture then
			factionRightTexture:SetHeight(21)
			factionRightTexture:SetTexCoord(0.0, 0.1640625, 0.34375, 0.671875)
		end
		if factionBar then factionBar:SetWidth(101) end
		if factionRow.LFGBonusRepButton and factionBackground then
			factionRow.LFGBonusRepButton:SetPoint("RIGHT", factionBackground, "LEFT", -2, 0)
		end
	end

	if hasRep or not isHeader then
		if factionStanding then factionStanding:Show() end
		if factionBar then
			factionBar:Show()
			factionBar:GetParent().hasRep = true
		end
		factionRow.hasRep = true
	else
		if factionStanding then factionStanding:Hide() end
		if factionBar then
			factionBar:Hide()
			factionBar:GetParent().hasRep = false
		end
		factionRow.hasRep = false
	end
	factionRow.isHeader = isHeader and true or false
end

function FIZ:ReputationBar_OnClick(frame)
	if not frame or not frame.index then return end

	-- Handle clicks on category headers by toggling collapse/expand instead of opening details
	if FIZ_Data and FIZ_Data.SortByStanding then
		local entry = FIZ_Entries and FIZ_Entries[frame.index]
		if entry and entry.header then
			if FIZ_Collapsed[entry.i] then
				self:Hook_ExpandFactionHeader(frame.index)
			else
				self:Hook_CollapseFactionHeader(frame.index)
			end
			return
		end
	else
		local name, _, _, _, _, _, _, _, isHeader, isCollapsed, hasRep = self:GetRawFactionInfo(frame.index)
		if isHeader and not hasRep then
			if isCollapsed then
				self:Hook_ExpandFactionHeader(frame.index)
			else
				self:Hook_CollapseFactionHeader(frame.index)
			end
			return
		end
		if name then
			self.selectedFactionName = name
		end
	end

	if ((ReputationDetailFrame and ReputationDetailFrame:IsVisible()) or (FIZ_ReputationDetailFrame and FIZ_ReputationDetailFrame:IsVisible())) and (self:GetSelectedFaction() == frame.index) then
		self:PlayCheckBoxSound(false)
		self:SetSelectedFaction(0)
		self.selectedFactionName = nil
		if ReputationDetailFrame then ReputationDetailFrame:Hide() end
		if FIZ_ReputationDetailFrame then FIZ_ReputationDetailFrame:Hide() end
	else
		if frame.hasRep then
			local rawName = self:GetRawFactionInfo(frame.index)
			if rawName then
				self.selectedFactionName = rawName
			end
			self:PlayCheckBoxSound(true)
			self:SetSelectedFaction(frame.index)
			if FIZ_Data.ExtendDetails then
				if FIZ_ReputationDetailFrame then FIZ_ReputationDetailFrame:Show() end
				if ReputationDetailFrame then ReputationDetailFrame:Hide() end
				self:BuildUpdateList()
				FIZ_UpdateList_Update()
			else
				if ReputationDetailFrame then ReputationDetailFrame:Show() end
				if FIZ_ReputationDetailFrame then FIZ_ReputationDetailFrame:Hide() end
			end
			self:RefreshReputationFrame()
		end
	end
end

function FIZ_ReputationBar_OnClick(self)
	FIZ:ReputationBar_OnClick(self)
end

function FIZ:SortByStanding(i, factionIndex, factionRow, factionBar, factionBarPreview, factionTitle, factionButton, factionStanding, factionBackground)
	local OBS_fi = FIZ_Entries[factionIndex]
	if not OBS_fi then return end
	local OBS_fi_i = OBS_fi.i
	local gender = UnitSex("player")
	local lfgBonusFactionID = _G.GetLFGBonusFactionID and _G.GetLFGBonusFactionID() or nil

	if OBS_fi.header then
		FIZ_ReputationFrame_SetRowType(factionRow, false, OBS_fi.header, false)
		if factionRow.LFGBonusRepButton then
			factionRow.LFGBonusRepButton:SetShown(false)
		end
		if OBS_fi_i == 8 then
			factionTitle:SetText(GetText("FACTION_STANDING_LABEL" .. OBS_fi_i, gender) .. " (" .. tostring(OBS_fi.size) .. ")")
		else
			factionTitle:SetText(GetText("FACTION_STANDING_LABEL" .. OBS_fi_i, gender) .. " -> " .. GetText("FACTION_STANDING_LABEL" .. (OBS_fi_i + 1), gender) .. " (" .. tostring(OBS_fi.size) .. ")")
		end
		if factionButton then
			if FIZ_Collapsed[OBS_fi_i] then
				factionButton:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up")
			else
				factionButton:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up")
			end
		end
		factionRow.index = factionIndex
		factionRow.isCollapsed = FIZ_Collapsed[OBS_fi_i]
		if factionBarPreview then factionBarPreview:Hide() end
		factionRow:Show()
	else
		local name, _, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, _, _, hasRep, _, isChild, factionID, hasBonusRepGain, canBeLFGBonus = self:GetFactionInfo(OBS_fi_i)
		if not name then return end
		factionTitle:SetText(name)

		local colorIndex, isCappedFriendship, factionStandingtext, friendID, friendRep, friendThreshold, nextFriendThreshold = FIZ_Friend_Detail(factionID, standingID, factionRow)
		if friendID then
			if nextFriendThreshold then
				barMin, barMax, barValue = friendThreshold, nextFriendThreshold, friendRep
			else
				barMin, barMax, barValue = 0, 1, 1
			end
		end

		local origBarValue = barValue
		barMax = barMax - barMin
		barValue = barValue - barMin
		barMin = 0

		local toExalted = 0
		if standingID < 8 then
			toExalted = (FIZ_ToExalted[standingID] or 0) + barMax - barValue
		end

		factionRow.index = OBS_fi_i
		if FIZ_Data.ShowMissing then
			factionRow.standingText = factionStandingtext .. " (" .. (barMax - barValue) .. ")"
		else
			factionRow.standingText = factionStandingtext
		end
		factionStanding:SetText(factionRow.standingText)

		if isCappedFriendship then
			factionRow.tooltip = nil
		else
			factionRow.tooltip = HIGHLIGHT_FONT_COLOR_CODE .. " " .. barValue .. " / " .. barMax .. FONT_COLOR_CODE_CLOSE
		end

		factionBar:SetMinMaxValues(0, barMax)
		factionBar:SetValue(barValue)
		local color = FACTION_BAR_COLORS[colorIndex or standingID] or FACTION_BAR_COLORS[4]
		factionBar:SetStatusBarColor(color.r, color.g, color.b)
		if factionBar.BonusIcon then
			factionBar.BonusIcon:SetShown(hasBonusRepGain and true or false)
		end
		if factionRow.LFGBonusRepButton then
			factionRow.LFGBonusRepButton.factionID = factionID
			factionRow.LFGBonusRepButton:SetShown(canBeLFGBonus and true or false)
			factionRow.LFGBonusRepButton:SetChecked(lfgBonusFactionID == factionID)
			factionRow.LFGBonusRepButton:SetEnabled(lfgBonusFactionID ~= factionID)
		end

		if factionBarPreview then
			local previewValue = 0
			if FIZ_Data.ShowPreviewRep then
				previewValue = self:GetReadyReputation(OBS_fi_i)
			end
			if (previewValue > 0) and not ((standingID == 8) and (barMax - barValue == 1)) then
				factionBarPreview:Show()
				factionBarPreview:SetMinMaxValues(0, barMax)
				previewValue = previewValue + barValue
				if previewValue > barMax then previewValue = barMax end
				factionBarPreview:SetValue(previewValue)
				factionBarPreview:SetID(factionIndex)
				factionBarPreview:SetStatusBarColor(0.25, 0.9, 0.55, 0.65)
			else
				factionBarPreview:Hide()
			end
		end

		FIZ_ReputationFrame_SetRowType(factionRow, isChild, OBS_fi.header, hasRep)
		factionRow:Show()

		local atWar1 = _G["ReputationBar" .. i .. "ReputationBarAtWarHighlight1"]
		local atWar2 = _G["ReputationBar" .. i .. "ReputationBarAtWarHighlight2"]
		if atWarWith then
			if atWar1 then atWar1:Show() end
			if atWar2 then atWar2:Show() end
		else
			if atWar1 then atWar1:Hide() end
			if atWar2 then atWar2:Hide() end
		end

		local hl1 = _G["ReputationBar" .. i .. "ReputationBarHighlight1"]
		local hl2 = _G["ReputationBar" .. i .. "ReputationBarHighlight2"]
		if OBS_fi_i == self:GetSelectedFaction() then
			if ReputationDetailFrame and ReputationDetailFrame:IsShown() then
				local flag = canToggleAtWar and 1 or nil
				FIZ_ReputationDetailFrame_IsShown(OBS_fi_i, flag, 1, i)
			end
			if FIZ_ReputationDetailFrame and FIZ_ReputationDetailFrame:IsVisible() then
				self:Rep_Detail_Frame(OBS_fi_i, colorIndex or standingID, barValue, barMax, origBarValue, standingID, toExalted, factionStandingtext)
			end
			if hl1 then hl1:Show() end
			if hl2 then hl2:Show() end
		else
			if hl1 then hl1:Hide() end
			if hl2 then hl2:Hide() end
		end
	end
end

function FIZ:OriginalRepOrder(i, factionIndex, factionRow, factionBar, factionBarPreview, factionTitle, factionButton, factionStanding, factionBackground)
	local name, _, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, _, isChild, factionID, hasBonusRepGain, canBeLFGBonus = self:GetFactionInfo(factionIndex)
	if not name then return end
	local lfgBonusFactionID = _G.GetLFGBonusFactionID and _G.GetLFGBonusFactionID() or nil

	factionTitle:SetText(name)
	if factionButton then
		if isCollapsed then
			factionButton:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up")
		else
			factionButton:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up")
		end
	end
	factionRow.index = factionIndex
	factionRow.isCollapsed = isCollapsed

	local colorIndex, isCappedFriendship, factionStandingtext, friendID, friendRep, friendThreshold, nextFriendThreshold = FIZ_Friend_Detail(factionID, standingID, factionRow)
	if friendID then
		if nextFriendThreshold then
			barMin, barMax, barValue = friendThreshold, nextFriendThreshold, friendRep
		else
			barMin, barMax, barValue = 0, 1, 1
		end
	end

	local origBarValue = barValue
	barMax = barMax - barMin
	barValue = barValue - barMin
	barMin = 0

	local toExalted = 0
	if standingID < 8 then
		toExalted = (FIZ_ToExalted[standingID] or 0) + barMax - barValue
	end

	if FIZ_Data.ShowMissing then
		factionRow.standingText = factionStandingtext .. " (" .. (barMax - barValue) .. ")"
	else
		factionRow.standingText = factionStandingtext
	end
	factionStanding:SetText(factionRow.standingText)

	if isCappedFriendship then
		factionRow.tooltip = nil
	else
		factionRow.tooltip = HIGHLIGHT_FONT_COLOR_CODE .. " " .. barValue .. " / " .. barMax .. FONT_COLOR_CODE_CLOSE
	end

	factionBar:SetMinMaxValues(0, barMax)
	factionBar:SetValue(barValue)
	local color = FACTION_BAR_COLORS[colorIndex or standingID] or FACTION_BAR_COLORS[4]
	factionBar:SetStatusBarColor(color.r, color.g, color.b)
	if factionBar.BonusIcon then
		factionBar.BonusIcon:SetShown(hasBonusRepGain and true or false)
	end
	if factionRow.LFGBonusRepButton then
		factionRow.LFGBonusRepButton.factionID = factionID
		factionRow.LFGBonusRepButton:SetShown(canBeLFGBonus and true or false)
		factionRow.LFGBonusRepButton:SetChecked(lfgBonusFactionID == factionID)
		factionRow.LFGBonusRepButton:SetEnabled(lfgBonusFactionID ~= factionID)
	end

	if factionBarPreview then
		local previewValue = 0
		if FIZ_Data.ShowPreviewRep then
			previewValue = self:GetReadyReputation(factionIndex)
		end
		if (previewValue > 0) and not ((standingID == 8) and (barMax - barValue == 1)) then
			factionBarPreview:Show()
			factionBarPreview:SetMinMaxValues(0, barMax)
			previewValue = previewValue + barValue
			if previewValue > barMax then previewValue = barMax end
			factionBarPreview:SetValue(previewValue)
			factionBarPreview:SetID(factionIndex)
			factionBarPreview:SetStatusBarColor(0.25, 0.9, 0.55, 0.65)
		else
			factionBarPreview:Hide()
		end
	end

	-- Always use our unified 4-arg FIZ_ReputationFrame_SetRowType so Classic Era / Forever / TBC
	-- 3-arg ReputationFrame_SetRowType(factionRow, rowType, hasRep) never receives booleans as rowType!
	FIZ_ReputationFrame_SetRowType(factionRow, isChild, isHeader, hasRep)

	factionRow:Show()

	local atWar1 = _G["ReputationBar" .. i .. "ReputationBarAtWarHighlight1"]
	local atWar2 = _G["ReputationBar" .. i .. "ReputationBarAtWarHighlight2"]
	if atWarWith then
		if atWar1 then atWar1:Show() end
		if atWar2 then atWar2:Show() end
	else
		if atWar1 then atWar1:Hide() end
		if atWar2 then atWar2:Hide() end
	end

	local hl1 = _G["ReputationBar" .. i .. "ReputationBarHighlight1"]
	local hl2 = _G["ReputationBar" .. i .. "ReputationBarHighlight2"]
	if (not isHeader or hasRep) and factionIndex == self:GetSelectedFaction() then
		if ReputationDetailFrame and ReputationDetailFrame:IsShown() then
			local flag = (canToggleAtWar and not isHeader) and 1 or nil
			FIZ_ReputationDetailFrame_IsShown(factionIndex, flag, 2, i)
		end
		if FIZ_ReputationDetailFrame and FIZ_ReputationDetailFrame:IsVisible() then
			self:Rep_Detail_Frame(factionIndex, colorIndex or standingID, barValue, barMax, origBarValue, standingID, toExalted, factionStandingtext)
			if hl1 then hl1:Show() end
			if hl2 then hl2:Show() end
		end
	else
		if hl1 then hl1:Hide() end
		if hl2 then hl2:Hide() end
	end
end
