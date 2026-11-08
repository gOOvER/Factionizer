----------------------------------------------------------
-- Factionizer - Modern Dark-Gold Ace3 Options UI       --
----------------------------------------------------------

local FIZ = _G.FIZ
local LibStub = LibStub
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")
local AceGUI = LibStub("AceGUI-3.0")
local AceDBOptions = LibStub("AceDBOptions-3.0")
local LSM = LibStub("LibSharedMedia-3.0", true)
local LDBIcon = LibStub("LibDBIcon-1.0", true)
local LibWindow = LibStub("LibWindow-1.1", true)

local configFrame = nil
local hostGroup = nil
local activeCategory = "general"
local importBuffer = ""
local importStatusText = ""
local refreshCustomConfigFrame = nil

local function notifyAndRefresh()
	AceConfigRegistry:NotifyChange("Factionizer")
	if refreshCustomConfigFrame then
		refreshCustomConfigFrame()
	end
end

function FIZ:InitOptions()
	AceConfig:RegisterOptionsTable("Factionizer", function() return self:GetOptionsTable() end)
	AceConfigDialog:SetDefaultSize("Factionizer", 840, 600)
	pcall(function()
		self.optionsFrame = AceConfigDialog:AddToBlizOptions("Factionizer", FIZ_NAME)
	end)

	local profilesOptions = AceDBOptions:GetOptionsTable(self.db)
	AceConfig:RegisterOptionsTable("Factionizer_Profiles", profilesOptions)
	pcall(function()
		AceConfigDialog:AddToBlizOptions("Factionizer_Profiles", FIZ.L["profiles"] or "Profiles", FIZ_NAME)
	end)
end

function FIZ:GetOptionsTable()
	local statusbarValues
	local hasLSMWidget = (_G.AceGUIWidgetLSMlists and _G.AceGUIWidgetLSMlists.statusbar) ~= nil
	if hasLSMWidget then
		statusbarValues = _G.AceGUIWidgetLSMlists.statusbar
	else
		statusbarValues = { ["Blizzard"] = "Blizzard", ["Flat"] = "Flat" }
		if LSM then
			for _, name in ipairs(LSM:List("statusbar")) do
				statusbarValues[name] = name
			end
		end
	end

	local profilesTab = AceDBOptions:GetOptionsTable(self.db)
	profilesTab.order = 60

	local sinkTab = self.GetSinkAce3OptionsDataTable and self:GetSinkAce3OptionsDataTable() or {
		type = "group",
		name = FIZ_TXT.notifications or "Notifications",
		args = {},
	}
	sinkTab.name = FIZ_TXT.notifications or "Notifications"
	sinkTab.order = 40
	sinkTab.args = sinkTab.args or {}
	sinkTab.args.sinkHeader = {
		type = "header",
		name = FIZ_TXT.sinkHeader or "Notification Output Routing (LibSink-2.0)",
		order = 0,
	}
	sinkTab.args.testBtn = {
		type = "execute",
		name = FIZ_TXT.sendTestAlert or "Send Test Notification",
		desc = FIZ_TXT.sendTestAlertDesc or "Sends a sample reputation alert to the selected output sink.",
		order = 99,
		width = "normal",
		func = function()
			if FIZ.Pour then
				FIZ:Pour(
					FIZ_NAME .. ": +500 " .. (_G.REPUTATION or "Reputation"),
					0.25, 1.0, 0.55,
					nil, nil, nil, nil, nil,
					"Interface\\Icons\\Achievement_Reputation_01"
				)
			else
				FIZ:Print(FIZ_Help_COLOUR .. FIZ_NAME .. ":|r +500 " .. (_G.REPUTATION or "Reputation"))
			end
		end,
	}

	local options = {
		type = "group",
		name = "|TInterface\\Icons\\Achievement_Reputation_01:18:18:0:0|t " .. FIZ_NAME .. " |cff00ccffv7.0.0|r",
		childGroups = "tab",
		get = function(info)
			return FIZ.db.profile[info[#info]]
		end,
		set = function(info, value)
			FIZ:SetOption(info[#info], value)
			FIZ:RefreshReputationFrame()
			if FIZ_ReputationDetailFrame and FIZ_ReputationDetailFrame:IsVisible() then
				FIZ:BuildUpdateList()
				FIZ_UpdateList_Update()
			end
			notifyAndRefresh()
		end,
		args = {
			----------------------------------------------------------------------
			-- 1. General & Reputation Frame
			----------------------------------------------------------------------
			general = {
				type = "group",
				name = FIZ_TXT.options or "General",
				order = 10,
				args = {
					uiGroup = {
						type = "group",
						name = _G.REPUTATION or "Reputation Frame & Details",
						inline = true,
						order = 10,
						args = {
							ExtendDetails = {
								type = "toggle",
								name = FIZ_TXT.extendDetails,
								desc = FIZ_TXT.extendDetailsTip,
								width = "full",
								order = 1,
							},
							ShowMissing = {
								type = "toggle",
								name = FIZ_TXT.showMissing,
								desc = FIZ_TXT.showMissingTip,
								width = "full",
								order = 2,
							},
							SortByStanding = {
								type = "toggle",
								name = FIZ_TXT.orderByStanding,
								desc = FIZ_TXT.orderByStandingTip,
								width = "full",
								order = 3,
							},
						},
					},
					previewGroup = {
						type = "group",
						name = FIZ_TXT.showPreviewRep or "Reputation Preview Bar",
						inline = true,
						order = 20,
						args = {
							ShowPreviewRep = {
								type = "toggle",
								name = FIZ_TXT.showPreviewRep,
								desc = FIZ_TXT.showPreviewRepTip,
								width = "full",
								order = 1,
							},
							StatusBarTexture = {
								type = "select",
								dialogControl = hasLSMWidget and "LSM30_Statusbar" or nil,
								name = FIZ.L["statusbarTexture"] or "StatusBar Texture (LibSharedMedia)",
								desc = FIZ.L["statusbarTextureTip"] or "Texture used for the reputation preview and detail progress bars",
								values = statusbarValues,
								width = "double",
								order = 2,
							},
						},
					},
					windowGroup = {
						type = "group",
						name = FIZ_TXT.windowGroupTitle or "Window Position, Scaling & Minimap",
						inline = true,
						order = 30,
						args = {
							minimap = {
								type = "toggle",
								name = FIZ_TXT.showMinimap or FIZ_TXT.minimapButton or "Show Minimap Button",
								desc = FIZ_TXT.showMinimapTip or FIZ_TXT.minimapButtonTip or "Toggle the Factionizer minimap icon",
								width = "full",
								order = 1,
								get = function()
									return not FIZ.db.profile.minimap.hide
								end,
								set = function(_, val)
									FIZ.db.profile.minimap.hide = not val
									if LDBIcon then
										if val then
											LDBIcon:Show("Factionizer")
										else
											LDBIcon:Hide("Factionizer")
										end
									end
									notifyAndRefresh()
								end,
							},
							detachedWindow = {
								type = "toggle",
								name = FIZ_TXT.detachWindow or "Detach Detail Window from Reputation Frame",
								desc = FIZ_TXT.detachWindowTip or "When enabled, FIZ_ReputationDetailFrame remembers its last dragged screen position via LibWindow-1.1 instead of docking to the Blizzard Reputation Frame.",
								width = "full",
								order = 2,
								get = function()
									return FIZ.db.profile.window and FIZ.db.profile.window.detached or false
								end,
								set = function(_, val)
									FIZ.db.profile.window = FIZ.db.profile.window or {}
									FIZ.db.profile.window.detached = val and true or false
									if FIZ.UpdateDetailWindowDocking then
										FIZ:UpdateDetailWindowDocking()
									end
									notifyAndRefresh()
								end,
							},
							windowScale = {
								type = "range",
								name = FIZ_TXT.windowScale or "Detail Window Scale (or Ctrl + MouseWheel)",
								min = 0.65, max = 1.50, step = 0.05,
								order = 3,
								width = "double",
								get = function()
									return (FIZ.db.profile.window and FIZ.db.profile.window.scale) or 1.0
								end,
								set = function(_, val)
									FIZ.db.profile.window = FIZ.db.profile.window or {}
									FIZ.db.profile.window.scale = val
									if LibWindow and FIZ_ReputationDetailFrame then
										LibWindow.SetScale(FIZ_ReputationDetailFrame, val)
									elseif FIZ_ReputationDetailFrame then
										FIZ_ReputationDetailFrame:SetScale(val)
									end
									notifyAndRefresh()
								end,
							},
							uiFontSize = {
								type = "range",
								name = FIZ_TXT.uiFontSize or "UI Font Size (10 - 18 pt)",
								min = 10, max = 18, step = 1,
								order = 4,
								width = "double",
								get = function()
									return FIZ.UIStyle and FIZ.UIStyle.GetFontSize() or 13
								end,
								set = function(_, val)
									if FIZ.UIStyle then
										FIZ.UIStyle.SetFontSize(val)
									end
								end,
							},
						},
					},
				},
			},

			----------------------------------------------------------------------
			-- 2. Chat & Reputation Bar
			----------------------------------------------------------------------
			chat = {
				type = "group",
				name = FIZ_TXT.chatOptions or "Chat & Rep Bar",
				order = 20,
				args = {
					chatGroup = {
						type = "group",
						name = FIZ_TXT.writeChatMessage or FIZ_TXT.gainToChat or "Chat Combat Messages",
						inline = true,
						order = 10,
						args = {
							WriteChatMessage = {
								type = "toggle",
								name = FIZ_TXT.writeChatMessage or FIZ_TXT.gainToChat,
								desc = FIZ_TXT.writeChatMessageTip,
								width = "full",
								order = 1,
							},
							NoGuildGain = {
								type = "toggle",
								name = FIZ_TXT.noGuildGain,
								desc = FIZ_TXT.noGuildGainTip,
								width = "full",
								order = 2,
								disabled = function() return not FIZ.db.profile.WriteChatMessage end,
							},
							SuppressOriginalChat = {
								type = "toggle",
								name = FIZ_TXT.suppressOriginalChat or FIZ_TXT.suppressOriginalGain,
								desc = FIZ_TXT.suppressOriginalChatTip,
								width = "full",
								order = 3,
							},
						},
					},
					barGroup = {
						type = "group",
						name = FIZ_TXT.switchFactionBar or "Watched Reputation Bar",
						inline = true,
						order = 20,
						args = {
							SwitchFactionBar = {
								type = "toggle",
								name = FIZ_TXT.switchFactionBar,
								desc = FIZ_TXT.switchFactionBarTip,
								width = "full",
								order = 1,
							},
							NoGuildSwitch = {
								type = "toggle",
								name = FIZ_TXT.noGuildSwitch,
								desc = FIZ_TXT.noGuildSwitchTip,
								width = "full",
								order = 2,
								disabled = function() return not FIZ.db.profile.SwitchFactionBar end,
							},
							SilentSwitch = {
								type = "toggle",
								name = FIZ_TXT.silentSwitch,
								desc = FIZ_TXT.silentSwitchTip,
								width = "full",
								order = 3,
								disabled = function() return not FIZ.db.profile.SwitchFactionBar end,
							},
						},
					},
				},
			},

			----------------------------------------------------------------------
			-- 3. Reputation Sources
			----------------------------------------------------------------------
			sources = {
				type = "group",
				name = FIZ_TXT.filterOptions or "Reputation Sources",
				order = 30,
				args = {
					filterGroup = {
						type = "group",
						name = FIZ_TXT.visibleSourcesTitle or "Visible Reputation Sources",
						inline = true,
						order = 10,
						args = {
							ShowQuests = {
								type = "toggle",
								name = FIZ_TXT.showQuests,
								desc = FIZ_TXT.showQuestsTip,
								width = "normal",
								order = 1,
							},
							ShowItems = {
								type = "toggle",
								name = FIZ_TXT.showItems,
								desc = FIZ_TXT.showItemsTip,
								width = "normal",
								order = 2,
							},
							ShowMobs = {
								type = "toggle",
								name = FIZ_TXT.showMobs,
								desc = FIZ_TXT.showMobsTip,
								width = "normal",
								order = 3,
							},
							ShowInstances = {
								type = "toggle",
								name = FIZ_TXT.showInstances,
								desc = FIZ_TXT.showInstancesTip,
								width = "normal",
								order = 4,
							},
							ShowGeneral = {
								type = "toggle",
								name = FIZ_TXT.showGeneral,
								desc = FIZ_TXT.showGeneralTip,
								width = "full",
								order = 5,
							},
						},
					},
					quickToggleGroup = {
						type = "group",
						name = FIZ_TXT.quickSourceActions or "Quick Source Actions",
						inline = true,
						order = 20,
						args = {
							enableAll = {
								type = "execute",
								name = (FIZ_TXT.showAll or "Show All") .. " (+)",
								desc = FIZ_TXT.showAllTip,
								order = 1,
								width = "normal",
								func = function()
									FIZ:ToggleAllTypes(true)
									notifyAndRefresh()
								end,
							},
							disableAll = {
								type = "execute",
								name = (FIZ_TXT.showNone or "Show None") .. " (-)",
								desc = FIZ_TXT.showNoneTip,
								order = 2,
								width = "normal",
								func = function()
									FIZ:ToggleAllTypes(false)
									notifyAndRefresh()
								end,
							},
							clearSuppressed = {
								type = "execute",
								name = FIZ_TXT.suppressNone or FIZ_TXT.supressNoneGlobal or "Reset Suppressed Quests",
								desc = FIZ_TXT.suppressNoneTip,
								order = 3,
								width = "double",
								func = function()
									FIZ:SupressNone(true)
									notifyAndRefresh()
								end,
							},
						},
					},
				},
			},

			----------------------------------------------------------------------
			-- 4. Notifications (LibSink-2.0)
			----------------------------------------------------------------------
			notifications = sinkTab,

			----------------------------------------------------------------------
			-- 5. Sharing & Import/Export (LibDeflate + AceComm-3.0)
			----------------------------------------------------------------------
			sharing = {
				type = "group",
				name = FIZ_TXT.sharingExport or "Sharing & Export",
				order = 50,
				args = {
					commGroup = {
						type = "group",
						name = FIZ_TXT.commSyncGroup or "Guild & Group Exclusion Sync (AceComm-3.0)",
						inline = true,
						order = 10,
						args = {
							enableCommSync = {
								type = "toggle",
								name = FIZ_TXT.enableCommSync or "Receive Quest/Item Exclusions from Party, Raid & Guild",
								desc = FIZ_TXT.enableCommSyncDesc or "Automatically merge quest/item exclusions shared by other Factionizer users in your group or guild.",
								width = "full",
								order = 1,
							},
							shareGuildBtn = {
								type = "execute",
								name = FIZ_TXT.shareGuild or "Share Exclusions (Guild)",
								order = 2,
								width = "normal",
								func = function()
									FIZ:ShareSuppressedWithGroup("GUILD")
								end,
							},
							shareGroupBtn = {
								type = "execute",
								name = FIZ_TXT.shareGroup or "Share Exclusions (Party / Raid)",
								order = 3,
								width = "normal",
								func = function()
									FIZ:ShareSuppressedWithGroup()
								end,
							},
						},
					},
					exportGroup = {
						type = "group",
						name = FIZ_TXT.exportImportGroup or "Profile & Exclusions Export / Import (LibDeflate)",
						inline = true,
						order = 20,
						args = {
							exportBox = {
								type = "input",
								name = FIZ_TXT.exportString or "Export String (Ctrl+C to copy)",
								desc = FIZ_TXT.exportStringDesc or "Compressed string containing your current profile settings and suppressed quests.",
								multiline = 3,
								width = "full",
								order = 1,
								get = function()
									return FIZ:ExportProfileString()
								end,
								set = function() end,
							},
							importBox = {
								type = "input",
								name = FIZ_TXT.importString or "Import String (Paste & Click Import)",
								multiline = 3,
								width = "full",
								order = 2,
								get = function()
									return importBuffer
								end,
								set = function(_, val)
									importBuffer = val or ""
								end,
							},
							importBtn = {
								type = "execute",
								name = FIZ_TXT.importBtn or "Import Profile & Exclusions",
								order = 3,
								width = "normal",
								func = function()
									local ok, err = FIZ:ImportProfileString(importBuffer)
									if ok then
										importStatusText = "|cff00ff96" .. (FIZ_TXT.importSuccess or "Profile imported successfully!") .. "|r"
										importBuffer = ""
									else
										importStatusText = "|cffff5555" .. (FIZ_TXT.importFailed or "Import failed: ") .. tostring(err or "Invalid string") .. "|r"
									end
									notifyAndRefresh()
								end,
							},
							importStatus = {
								type = "description",
								name = function() return importStatusText end,
								order = 4,
								width = "normal",
							},
						},
					},
				},
			},

			----------------------------------------------------------------------
			-- 6. Profiles (AceDBOptions-3.0)
			----------------------------------------------------------------------
			profiles = profilesTab,

			----------------------------------------------------------------------
			-- 7. About
			----------------------------------------------------------------------
			about = {
				type = "group",
				name = FIZ_TXT.about or "About",
				order = 100,
				args = {
					infoGroup = {
						type = "group",
						inline = true,
						name = FIZ_TXT.aboutTitle or "About Factionizer",
						order = 1,
						args = {
							banner = {
								type = "description",
								image = "Interface\\Icons\\Achievement_Reputation_01",
								imageWidth = 36,
								imageHeight = 36,
								imageCoords = { 0.08, 0.92, 0.08, 0.92 },
								fontSize = "medium",
								order = 1,
								name = function()
									return "|cffffd200Factionizer|r  |cff00ff96v7.0.0|r\n"
										.. "|cff8892a4" .. (FIZ_TXT.authorsLabel or "Authors:") .. "|r |cff00ff96gOOvER|r, |cffb0b8c4Urbin, Millán-Aszune|r   |cff555c68||   |cff8892a4" .. (FIZ_TXT.architectureLabel or "Architecture:") .. "|r |cffffffffAce3 + HereBeDragons-2.0|r"
								end,
							},
							desc = {
								type = "description",
								fontSize = "medium",
								order = 2,
								name = FIZ_TXT.aboutDesc or "\nComprehensive reputation assistant across all World of Warcraft expansions.\n",
							},
						},
					},
					statsGroup = {
						type = "group",
						inline = true,
						name = FIZ_TXT.dbSummaryTitle or "Database & Profile Summary",
						order = 2,
						args = {
							summary = {
								type = "description",
								fontSize = "medium",
								order = 1,
								name = function()
									local totalZones = 0
									if FIZ.Zone then
										for _ in pairs(FIZ.Zone) do totalZones = totalZones + 1 end
									end
									local totalModules = FIZ.ContentModules and #FIZ.ContentModules or 0
									local activeProfile = (FIZ.db and FIZ.db.GetCurrentProfile and FIZ.db:GetCurrentProfile()) or "Default"
									local suppressedCount = 0
									if FIZ_Suppressed then
										for _, entries in pairs(FIZ_Suppressed) do
											if type(entries) == "table" then
												for _, v in pairs(entries) do
													if v then suppressedCount = suppressedCount + 1 end
												end
											end
										end
									end
									return string.format(
										"|TInterface\\Icons\\Achievement_Reputation_01:14:14:0:0:64:64:5:59:5:59|t  |cffffd200" .. (FIZ_TXT.expansionModules or "Expansion Modules:") .. "|r |cff00ff96%d|r     "
										.. "|T134269:14:14:0:0:64:64:5:59:5:59|t  |cffffd200" .. (FIZ_TXT.registeredZones or "Registered Zones:") .. "|r |cffffffff%d|r\n\n"
										.. "|T134332:14:14:0:0:64:64:5:59:5:59|t  |cffffd200" .. (FIZ_TXT.profileLabel or "Profile:") .. "|r |cffffd200%s|r     "
										.. "|T136243:14:14:0:0:64:64:5:59:5:59|t  |cffffd200" .. (FIZ_TXT.suppressedQuestsCount or "Suppressed Quests:") .. "|r |cff00ff96%d|r",
										totalModules, totalZones, tostring(activeProfile), suppressedCount
									)
								end,
							},
						},
					},
					linksGroup = {
						type = "group",
						inline = true,
						name = FIZ_TXT.linksTitle or "GitHub, Wago.io & Support (Ctrl+C)",
						order = 3,
						args = {
							githubUrl = {
								type = "input",
								name = FIZ_TXT.githubRepo or "GitHub Repository",
								width = "double",
								order = 1,
								get = function() return "https://github.com/gOOvER/Factionizer" end,
								set = function() end,
							},
							donateUrl = {
								type = "input",
								name = FIZ_TXT.supportDonate or "Support & Donate (gOOvER)",
								width = "double",
								order = 2,
								get = function() return "https://donate.goover.dev" end,
								set = function() end,
							},
						},
					},
				},
			},
		},
	}

	return options
end

--------------------------------------------------------------------------------
-- Modern Dark-Gold Standalone Options Window (FactionizerConfigFrame)
--------------------------------------------------------------------------------
local CONFIG_SECTIONS = {
	{ key = "general",       icon = "Interface\\Icons\\Achievement_Reputation_01", label = function() return FIZ_TXT.generalOptions or FIZ_TXT.options or "General" end },
	{ key = "chat",          icon = 135453, label = function() return FIZ_TXT.chatOptions or "Chat & Rep Bar" end },
	{ key = "sources",       icon = 136781, label = function() return FIZ_TXT.filterOptions or "Reputation Sources" end },
	{ key = "notifications", icon = 134436, label = function() return FIZ_TXT.notifications or "Notifications" end },
	{ key = "sharing",       icon = 133464, label = function() return FIZ_TXT.sharingExport or "Sharing & Export" end },
	{ key = "profiles",      icon = 134332, label = function() return FIZ.L["profiles"] or "Profiles" end },
	{ key = "about",         icon = 133738, label = function() return FIZ_TXT.about or "About" end },
}

local function styleAceWidgetsRecursive(widget)
	if not widget then return end
	local UIStyle = FIZ.UIStyle
	if UIStyle then
		local fontSize = UIStyle.GetFontSize()
		if widget.type == "InlineGroup" and widget.border then
			UIStyle.ApplyBox(widget.border, 0.10, 0.12, 0.16, 0.92, 0.22, 0.26, 0.34, 1)
			if widget.titletext then
				widget.titletext:SetTextColor(0.95, 0.80, 0.28)
				UIStyle.ApplyFont(widget.titletext, 1)
			end
		elseif widget.type == "Heading" and widget.label then
			UIStyle.ApplyFont(widget.label, 1)
		elseif (widget.type == "Label" or widget.type == "InteractiveLabel") and widget.label then
			UIStyle.ApplyFont(widget.label, 0)
		elseif widget.type == "CheckBox" and widget.text then
			UIStyle.ApplyFont(widget.text, 0)
			if widget.SetHeight then
				widget:SetHeight(math.max(24, fontSize + 11))
			end
		elseif widget.type == "Button" and widget.frame then
			local fs = widget.text or (widget.frame.GetFontString and widget.frame:GetFontString())
			if fs then
				UIStyle.ApplyFont(fs, 0)
				local strW = fs:GetStringWidth() or 0
				local curW = widget.frame:GetWidth() or 100
				if strW > 0 and (strW + 28) > curW then
					widget.frame:SetWidth(math.ceil(strW + 28))
				end
			end
		elseif widget.type == "EditBox" then
			if widget.label then UIStyle.ApplyFont(widget.label, -1) end
			if widget.editbox then UIStyle.ApplyFont(widget.editbox, 0) end
		elseif widget.type == "MultiLineEditBox" then
			if widget.label then UIStyle.ApplyFont(widget.label, 0) end
			if widget.editBox then UIStyle.ApplyFont(widget.editBox, 0) end
		elseif widget.type == "Dropdown" then
			if widget.label then UIStyle.ApplyFont(widget.label, -1) end
			if widget.text then UIStyle.ApplyFont(widget.text, 0) end
		elseif widget.type == "Slider" then
			if widget.label then UIStyle.ApplyFont(widget.label, 0) end
			if widget.editbox then UIStyle.ApplyFont(widget.editbox, 0) end
		end
	end
	if type(widget.children) == "table" then
		for _, child in ipairs(widget.children) do
			styleAceWidgetsRecursive(child)
		end
	end
	if widget.PerformLayout then
		pcall(function() widget:PerformLayout() end)
	end
end

local function renderActiveCategory()
	if not configFrame or not configFrame:IsShown() or not hostGroup then return end
	local UIStyle = FIZ.UIStyle

	for _, sec in ipairs(CONFIG_SECTIONS) do
		local btn = configFrame.NavButtons[sec.key]
		if btn then
			if UIStyle then
				UIStyle.ApplyFont(btn.Label, 0)
			end
			local isSelected = (sec.key == activeCategory)
			btn.isSelected = isSelected
			btn:UpdateVisual(false)
			if isSelected then
				configFrame.Content.HeaderIcon:SetTexture(sec.icon)
				configFrame.Content.HeaderTitle:SetText(sec.label())
				if UIStyle then
					UIStyle.ApplyFont(configFrame.Content.HeaderTitle, 1)
				end
			end
		end
	end

	if configFrame.ProfileBadge then
		if UIStyle then UIStyle.ApplyFont(configFrame.ProfileBadge, 0) end
		local curProf = (FIZ.db and FIZ.db.GetCurrentProfile and FIZ.db:GetCurrentProfile()) or "Default"
		configFrame.ProfileBadge:SetText("|cff778292" .. (FIZ_TXT.profileLabel or "Profile:") .. "|r |cffffd200" .. tostring(curProf) .. "|r")
	end

	if configFrame.RepBtn and configFrame.ResetSupBtn and configFrame.ProfileBadge then
		configFrame.RepBtn:UpdateSize()
		configFrame.ResetSupBtn:UpdateSize()
		configFrame.ResetSupBtn:ClearAllPoints()
		configFrame.ResetSupBtn:SetPoint("LEFT", configFrame.RepBtn, "RIGHT", 8, 0)
		configFrame.ProfileBadge:ClearAllPoints()
		configFrame.ProfileBadge:SetPoint("LEFT", configFrame.ResetSupBtn, "RIGHT", 18, 0)
	end
	if configFrame.DoneBtn then
		configFrame.DoneBtn:UpdateSize()
	end

	AceConfigDialog:Open("Factionizer", hostGroup, activeCategory)
	styleAceWidgetsRecursive(hostGroup)
end

refreshCustomConfigFrame = function()
	if configFrame and configFrame:IsShown() then
		renderActiveCategory()
	end
end

local function ensureConfigFrame()
	if configFrame then return configFrame end
	local UIStyle = FIZ.UIStyle
	if not UIStyle then return nil end

	local frame = CreateFrame("Frame", "FactionizerConfigFrame", UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
	frame:Hide()
	frame:SetSize(920, 580)
	frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	frame:SetFrameStrata("DIALOG")
	frame:SetToplevel(true)
	frame:SetMovable(true)
	frame:SetClampedToScreen(true)
	frame:EnableMouse(true)
	UIStyle.ApplyBox(frame, 0.07, 0.08, 0.11, 0.97, 0.26, 0.30, 0.38, 1)
	table.insert(UISpecialFrames, "FactionizerConfigFrame")

	if LibWindow and FIZ.db and FIZ.db.profile then
		FIZ.db.profile.configWindow = FIZ.db.profile.configWindow or { scale = 1.0 }
		LibWindow.RegisterConfig(frame, FIZ.db.profile.configWindow)
		LibWindow.RestorePosition(frame)
		LibWindow.EnableMouseWheelScaling(frame)
		function frame:OnMoved()
			LibWindow.SavePosition(self)
		end
	end

	-- 1. Top Header Bar
	frame.Header = UIStyle.CreateHeader(
		frame,
		FIZ_NAME .. "  |cff667080—|r  |cffffffff" .. (FIZ_TXT.options or "Configuration") .. "|r",
		"Interface\\Icons\\Achievement_Reputation_01",
		function() FIZ:HideConfigWindow() end
	)
	frame.Header.Badge:SetText("|cff00ff96v7.0.0|r")

	-- 2. Bottom Footer Bar
	frame.Footer = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate" or nil)
	frame.Footer:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 10, 10)
	frame.Footer:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -10, 10)
	frame.Footer:SetHeight(36)
	UIStyle.ApplyBox(frame.Footer, 0.10, 0.12, 0.15, 1, 0.20, 0.23, 0.29, 1)

	frame.RepBtn = UIStyle.CreateButton(frame.Footer, 170, 26, _G.REPUTATION or "Reputation Panel", "default", "Interface\\Icons\\Achievement_Reputation_01")
	frame.RepBtn:SetPoint("LEFT", frame.Footer, "LEFT", 8, 0)
	frame.RepBtn:SetScript("OnClick", function()
		FIZ:HideConfigWindow()
		FIZ:ToggleDetailWindow()
	end)

	frame.ResetSupBtn = UIStyle.CreateButton(frame.Footer, 180, 26, FIZ_TXT.suppressNone or "Reset Exclusions", "danger", 136243)
	frame.ResetSupBtn:SetPoint("LEFT", frame.RepBtn, "RIGHT", 8, 0)
	frame.ResetSupBtn:SetScript("OnClick", function()
		FIZ:SupressNone(true)
		notifyAndRefresh()
	end)

	frame.ProfileBadge = frame.Footer:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	frame.ProfileBadge:SetPoint("LEFT", frame.ResetSupBtn, "RIGHT", 18, 0)

	frame.DoneBtn = UIStyle.CreateButton(frame.Footer, 100, 26, CLOSE or "Done", "primary")
	frame.DoneBtn:SetPoint("RIGHT", frame.Footer, "RIGHT", -8, 0)
	frame.DoneBtn:SetScript("OnClick", function() FIZ:HideConfigWindow() end)

	-- 3. Left Vertical Category Sidebar
	frame.Sidebar = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate" or nil)
	frame.Sidebar:SetPoint("TOPLEFT", frame.Header, "BOTTOMLEFT", 10, -8)
	frame.Sidebar:SetPoint("BOTTOMLEFT", frame.Footer, "TOPLEFT", 0, 8)
	frame.Sidebar:SetWidth(220)
	UIStyle.ApplyBox(frame.Sidebar, 0.09, 0.11, 0.14, 1, 0.22, 0.25, 0.32, 1)

	local navTitle = frame.Sidebar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	navTitle:SetPoint("TOPLEFT", frame.Sidebar, "TOPLEFT", 12, -12)
	navTitle:SetText(FIZ_TXT.categories or "CATEGORIES")
	navTitle:SetTextColor(0.92, 0.78, 0.28)

	local navDiv = frame.Sidebar:CreateTexture(nil, "ARTWORK")
	navDiv:SetPoint("TOPLEFT", navTitle, "BOTTOMLEFT", 0, -4)
	navDiv:SetPoint("RIGHT", frame.Sidebar, "RIGHT", -12, 0)
	navDiv:SetHeight(1)
	navDiv:SetColorTexture(0.22, 0.25, 0.32, 1)

	frame.NavButtons = {}
	local prevBtn = nil
	for _, sec in ipairs(CONFIG_SECTIONS) do
		local nBtn = CreateFrame("Button", nil, frame.Sidebar, BackdropTemplateMixin and "BackdropTemplate" or nil)
		nBtn:SetHeight(34)
		if not prevBtn then
			nBtn:SetPoint("TOPLEFT", frame.Sidebar, "TOPLEFT", 8, -38)
			nBtn:SetPoint("TOPRIGHT", frame.Sidebar, "TOPRIGHT", -8, -38)
		else
			nBtn:SetPoint("TOPLEFT", prevBtn, "BOTTOMLEFT", 0, -4)
			nBtn:SetPoint("TOPRIGHT", prevBtn, "BOTTOMRIGHT", 0, -4)
		end
		prevBtn = nBtn

		local markBar = nBtn:CreateTexture(nil, "OVERLAY")
		markBar:SetPoint("TOPLEFT", nBtn, "TOPLEFT", 1, -1)
		markBar:SetPoint("BOTTOMLEFT", nBtn, "BOTTOMLEFT", 1, 1)
		markBar:SetWidth(3)
		markBar:SetColorTexture(0.95, 0.78, 0.20, 1)
		nBtn.MarkBar = markBar

		local ic = nBtn:CreateTexture(nil, "ARTWORK")
		ic:SetSize(18, 18)
		ic:SetPoint("LEFT", nBtn, "LEFT", 12, 0)
		ic:SetTexture(sec.icon)
		ic:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		nBtn.Icon = ic

		local lbl = nBtn:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
		lbl:SetPoint("LEFT", ic, "RIGHT", 9, 0)
		lbl:SetPoint("RIGHT", nBtn, "RIGHT", -6, 0)
		lbl:SetJustifyH("LEFT")
		lbl:SetText(sec.label())
		nBtn.Label = lbl

		function nBtn:UpdateVisual(hovered)
			if self.isSelected then
				UIStyle.ApplyBox(self, 0.24, 0.20, 0.09, 0.98, 0.85, 0.68, 0.18, 1)
				self.Label:SetTextColor(1, 0.88, 0.30)
				self.MarkBar:Show()
			elseif hovered then
				UIStyle.ApplyBox(self, 0.16, 0.20, 0.27, 0.95, 0.38, 0.44, 0.56, 1)
				self.Label:SetTextColor(1, 1, 1)
				self.MarkBar:Hide()
			else
				UIStyle.ApplyBox(self, 0.12, 0.14, 0.18, 0.90, 0.18, 0.21, 0.27, 1)
				self.Label:SetTextColor(0.78, 0.82, 0.88)
				self.MarkBar:Hide()
			end
		end

		nBtn:SetScript("OnEnter", function(self) self:UpdateVisual(true) end)
		nBtn:SetScript("OnLeave", function(self) self:UpdateVisual(false) end)
		nBtn:SetScript("OnClick", function()
			activeCategory = sec.key
			renderActiveCategory()
		end)

		frame.NavButtons[sec.key] = nBtn
	end

	-- 4. Right Content Area
	frame.Content = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate" or nil)
	frame.Content:SetPoint("TOPLEFT", frame.Sidebar, "TOPRIGHT", 10, 0)
	frame.Content:SetPoint("BOTTOMRIGHT", frame.Footer, "TOPRIGHT", 0, 8)
	UIStyle.ApplyBox(frame.Content, 0.08, 0.09, 0.12, 1, 0.22, 0.25, 0.32, 1)

	frame.Content.Header = CreateFrame("Frame", nil, frame.Content, BackdropTemplateMixin and "BackdropTemplate" or nil)
	frame.Content.Header:SetPoint("TOPLEFT", frame.Content, "TOPLEFT", 1, -1)
	frame.Content.Header:SetPoint("TOPRIGHT", frame.Content, "TOPRIGHT", -1, -1)
	frame.Content.Header:SetHeight(32)
	UIStyle.ApplyBox(frame.Content.Header, 0.12, 0.14, 0.19, 1, 0.22, 0.25, 0.32, 1)

	local hIcon = frame.Content.Header:CreateTexture(nil, "ARTWORK")
	hIcon:SetSize(18, 18)
	hIcon:SetPoint("LEFT", frame.Content.Header, "LEFT", 12, 0)
	hIcon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	frame.Content.HeaderIcon = hIcon

	local hTitle = frame.Content.Header:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	hTitle:SetPoint("LEFT", hIcon, "RIGHT", 8, 0)
	hTitle:SetTextColor(1, 0.85, 0.25)
	frame.Content.HeaderTitle = hTitle

	frame.Content.Host = CreateFrame("Frame", nil, frame.Content)
	frame.Content.Host:SetPoint("TOPLEFT", frame.Content.Header, "BOTTOMLEFT", 10, -8)
	frame.Content.Host:SetPoint("BOTTOMRIGHT", frame.Content, "BOTTOMRIGHT", -10, 10)

	hostGroup = AceGUI:Create("SimpleGroup")
	hostGroup.type = "FactionizerOptionsContainer"
	hostGroup:SetLayout("Fill")
	hostGroup.frame:SetParent(frame.Content.Host)
	hostGroup.frame:ClearAllPoints()
	hostGroup.frame:SetAllPoints(frame.Content.Host)
	hostGroup.frame:Show()

	frame:SetScript("OnShow", function()
		renderActiveCategory()
	end)

	UIStyle.RegisterFontListener(function()
		if frame:IsShown() then
			renderActiveCategory()
		end
	end)

	configFrame = frame
	return configFrame
end

function FIZ:ShowConfigWindow(category)
	if category then
		activeCategory = category
	end
	local frame = ensureConfigFrame()
	if frame then
		frame:Show()
		renderActiveCategory()
	else
		AceConfigDialog:Open("Factionizer")
	end
end

function FIZ:HideConfigWindow()
	if configFrame and configFrame:IsShown() then
		configFrame:Hide()
	end
	AceConfigDialog:Close("Factionizer")
end

function FIZ:ToggleConfigWindow()
	local frame = ensureConfigFrame()
	if frame then
		if frame:IsShown() then
			self:HideConfigWindow()
		else
			self:ShowConfigWindow()
		end
	elseif AceConfigDialog.OpenFrames and AceConfigDialog.OpenFrames["Factionizer"] then
		AceConfigDialog:Close("Factionizer")
	else
		AceConfigDialog:Open("Factionizer")
	end
end

function FIZ_ToggleConfigWindow()
	FIZ:ToggleConfigWindow()
end
