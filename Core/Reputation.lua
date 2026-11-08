----------------------------------------------------------
-- Factionizer - Reputation Calculation & Chat Engine   --
----------------------------------------------------------

local FIZ = _G.FIZ

function FIZ:Update_Tooltip(x, l1, r1)
	x = x + 1
	local ToolTip_ID = { l = l1, r = r1 }
	return ToolTip_ID, x
end

function FIZ:BuildUpdateList()
	FIZ_UpdateList = {}
	FIZ_CurrentRepInBag = 0
	FIZ_CurrentRepInBagBank = 0
	FIZ_CurrentRepInQuest = 0
	local index = 1

	if not FIZ_ReputationDetailFrame or not FIZ_ReputationDetailFrame:IsVisible() then
		return
	end

	local factionIndex = self:GetSelectedFaction()
	local faction, _, standingId, barMin, barMax, barValue, _, _, isHeader, _, hasRep, _, _, factionID = self:GetRawFactionInfo(factionIndex)
	if isHeader and not hasRep then
		return
	end

	if faction then
		local oFaction = string.lower(faction)
		faction = string.lower(faction)
		if FIZ_FactionMapping[faction] then
			faction = FIZ_FactionMapping[faction]
		end

		local normCurrent = barValue - barMin
		local repToNext = barMax - barValue
		local gainTable = (factionID and FIZ_FactionGain["id:" .. tostring(factionID)]) or FIZ_FactionGain[oFaction] or FIZ_FactionGain[faction]
		if gainTable then
			local fg_sid = gainTable[standingId]
			if fg_sid then
				-- Instances
				if fg_sid.instance and FIZ_Data.ShowInstances then
					local fg_sid_x = fg_sid.instance
					for i = 0, fg_sid_x.count do
						local fg_sid_x_d = fg_sid_x.data[i]
						if fg_sid_x_d and (not fg_sid_x_d.limit or (normCurrent < fg_sid_x_d.limit)) then
							local toDo = string.format("%.2f", repToNext / fg_sid_x_d.rep)
							if fg_sid_x_d.limit then
								toDo = string.format("%.2f", (fg_sid_x_d.limit - normCurrent) / fg_sid_x_d.rep)
							end
							local bul_name = self:InitMapName(fg_sid_x_d.name)
							local FUL_I = {
								type = FIZ_TXT.instanceShort,
								times = toDo .. "x",
								rep = string.format("%d", fg_sid_x_d.rep),
								hasList = false,
								listShown = nil,
								index = index,
								belongsTo = nil,
								isShown = true,
								name = bul_name .. " (" .. fg_sid_x_d.level .. ")",
								tooltipHead = FIZ_TXT.instanceHead,
								tooltipTip = FIZ_TXT.instanceTip,
								tooltipDetails = {},
							}
							local FUL_I_TD = FUL_I.tooltipDetails
							local x = 0
							FUL_I_TD[x], x = self:Update_Tooltip(x, FIZ_TXT.instance2, bul_name)
							FUL_I_TD[x], x = self:Update_Tooltip(x, FIZ_TXT.mode, fg_sid_x_d.level)
							FUL_I_TD[x], x = self:Update_Tooltip(x, FIZ_TXT.reputation, FUL_I.rep)
							FUL_I_TD[x], x = self:Update_Tooltip(x, FIZ_TXT.timesToRun, FUL_I.times)
							FUL_I_TD[x], x = self:Update_Tooltip(x, " ", " ")
							FUL_I_TD[x] = self:Update_Tooltip(x, FIZ_TXT.maxStanding, _G["FACTION_STANDING_LABEL" .. fg_sid_x_d.maxStanding])
							FUL_I_TD.count = x
							FIZ_UpdateList[index] = FUL_I
							index = index + 1
						end
					end
				end

				-- Mobs
				if fg_sid.mobs and FIZ_Data.ShowMobs then
					local fg_sid_x = fg_sid.mobs
					for i = 0, fg_sid_x.count do
						local fg_sid_x_d = fg_sid_x.data[i]
						if fg_sid_x_d and (not fg_sid_x_d.limit or (normCurrent < fg_sid_x_d.limit)) then
							local toDo = ceil(repToNext / fg_sid_x_d.rep)
							if fg_sid_x_d.limit then
								toDo = ceil((fg_sid_x_d.limit - normCurrent) / fg_sid_x_d.rep)
							end
							local FUL_I = {
								type = FIZ_TXT.mobShort,
								times = toDo .. "x",
								rep = string.format("%d", fg_sid_x_d.rep),
								hasList = false,
								listShown = nil,
								index = index,
								belongsTo = nil,
								isShown = true,
								tooltipHead = FIZ_TXT.mobHead,
								tooltipTip = FIZ_TXT.mobTip,
								tooltipDetails = {},
							}
							local bul_name = self:InitMobName(fg_sid_x_d.name)
							local FUL_I_TD = FUL_I.tooltipDetails
							local x = 0
							if fg_sid_x_d.zone then
								local bul_zone = self:InitMapName(fg_sid_x_d.zone)
								FUL_I.name = bul_name .. " (" .. bul_zone .. ")"
								FUL_I_TD[x], x = self:Update_Tooltip(x, FIZ_TXT.mob2, bul_name)
								FUL_I_TD[x], x = self:Update_Tooltip(x, FIZ_TXT.location, bul_zone)
								FUL_I_TD[x], x = self:Update_Tooltip(x, FIZ_TXT.reputation, FUL_I.rep)
								FUL_I_TD[x], x = self:Update_Tooltip(x, FIZ_TXT.toDo, FUL_I.times)
								FUL_I_TD[x], x = self:Update_Tooltip(x, " ", " ")
								FUL_I_TD[x] = self:Update_Tooltip(x, FIZ_TXT.maxStanding, _G["FACTION_STANDING_LABEL" .. fg_sid_x_d.maxStanding])
								FUL_I_TD.count = x
							else
								FUL_I.name = bul_name
								FUL_I_TD[x], x = self:Update_Tooltip(x, FIZ_TXT.mob2, bul_name)
								FUL_I_TD[x], x = self:Update_Tooltip(x, FIZ_TXT.reputation, FUL_I.rep)
								FUL_I_TD[x], x = self:Update_Tooltip(x, FIZ_TXT.toDo, FUL_I.times)
								FUL_I_TD[x], x = self:Update_Tooltip(x, " ", " ")
								FUL_I_TD[x] = self:Update_Tooltip(x, FIZ_TXT.maxStanding, _G["FACTION_STANDING_LABEL" .. fg_sid_x_d.maxStanding])
								FUL_I_TD.count = x
							end
							FIZ_UpdateList[index] = FUL_I
							index = index + 1
						end
					end
				end

				-- Quests (may have items)
				local sum = 0
				local count = 0
				if fg_sid.quests and FIZ_Data.ShowQuests then
					local fg_sid_x = fg_sid.quests
					for i = 0, fg_sid_x.count do
						local fg_sid_x_d = fg_sid_x.data[i]
						if fg_sid_x_d then
							local showQuest = true
							if fg_sid_x_d.profession then
								local p = fg_sid_x_d.profession
								if (p == FIZ_LIMIT_TYPE_Herb and not FIZ_Herb) or
								   (p == FIZ_LIMIT_TYPE_Skin and not FIZ_Skin) or
								   (p == FIZ_LIMIT_TYPE_Mine and not FIZ_Mine) or
								   (p == FIZ_LIMIT_TYPE_Gather and not (FIZ_Herb or FIZ_Skin or FIZ_Mine)) or
								   (p == FIZ_LIMIT_TYPE_Jewe and not FIZ_Jewel) or
								   (p == FIZ_LIMIT_TYPE_Cook and not FIZ_Cook) or
								   (p == FIZ_LIMIT_TYPE_Arch and not FIZ_Arch) or
								   (p == FIZ_LIMIT_TYPE_Fish and not FIZ_Fish) or
								   (p == FIZ_LIMIT_TYPE_Aid and not FIZ_Aid) or
								   (p == FIZ_LIMIT_TYPE_Blac and not FIZ_Black) or
								   (p == FIZ_LIMIT_TYPE_Tail and not FIZ_Tailor) or
								   (p == FIZ_LIMIT_TYPE_Leat and not FIZ_Leath) or
								   (p == FIZ_LIMIT_TYPE_Ench and not FIZ_Enchan) or
								   (p == FIZ_LIMIT_TYPE_Engi and not FIZ_Engin) or
								   (p == FIZ_LIMIT_TYPE_Incr and not FIZ_Incrip) or
								   (p == FIZ_LIMIT_TYPE_Alch and not FIZ_Alche) then
									showQuest = false
								end
							end

							if showQuest and (not fg_sid_x_d.limit or (normCurrent < fg_sid_x_d.limit)) then
								local toDo = ceil(repToNext / fg_sid_x_d.rep)
								if fg_sid_x_d.limit then
									toDo = ceil((fg_sid_x_d.limit - normCurrent) / fg_sid_x_d.rep)
								end
								local bul_name = self:Quest_Names(fg_sid_x_d.name)
								local FUL_I = {
									type = FIZ_TXT.questShort,
									times = toDo .. "x",
									rep = string.format("%d", fg_sid_x_d.rep),
									index = index,
									belongsTo = nil,
									isShown = true,
									name = bul_name,
									originalName = bul_name,
									tooltipHead = FIZ_TXT.questHead,
									tooltipTip = FIZ_TXT.questTip,
									faction = faction,
									canSuppress = true,
									suppress = (FIZ_Suppressed and ((FIZ_Suppressed[oFaction] and FIZ_Suppressed[oFaction][bul_name]) or (FIZ_Suppressed[faction] and FIZ_Suppressed[faction][bul_name]))) and true or nil,
									tooltipDetails = {},
								}

								local FUL_I_TD = FUL_I.tooltipDetails
								local x = 0
								FUL_I_TD[x], x = self:Update_Tooltip(x, FIZ_TXT.quest2, FUL_I.name)
								FUL_I_TD[x], x = self:Update_Tooltip(x, FIZ_TXT.reputation, FUL_I.rep)
								FUL_I_TD[x], x = self:Update_Tooltip(x, FIZ_TXT.toDo, FUL_I.times)
								if not FUL_I.suppress then
									sum = sum + fg_sid_x_d.rep
									count = count + 1
								end

								if fg_sid_x_d.items then
									FUL_I.hasList = true
									FUL_I.listShown = false
									FUL_I_TD[x], x = self:Update_Tooltip(x, " ", " ")
									FUL_I_TD[x], x = self:Update_Tooltip(x, FIZ_TXT.itemsRequired, " ")
									FUL_I.lowlight = nil

									local entries = self:GetNumQuestLogEntries()
									for z = 1, entries do
										local title, isHeader = self:GetQuestLogEntryInfo(z)
										if title and not isHeader then
											if string.find(string.lower(bul_name), string.lower(title), 1, true) then
												FUL_I.lowlight = true
												FUL_I.name = FUL_I.name .. FIZ_QUEST_ACTIVE_COLOUR .. " (" .. FIZ_TXT.active .. ")|r"
											end
										end
									end

									local itemIndex = index + 1
									local currentQuestTimesBag = -1
									local currentQuestTimesBagBank = -1

									for item in pairs(fg_sid_x_d.items) do
										local FUL_II = {
											type = "",
											times = (fg_sid_x_d.items[item] * toDo) .. "x",
											rep = nil,
											index = itemIndex,
											belongsTo = index,
											hasList = nil,
											listShown = nil,
											isShown = FUL_I.listShown,
											name = self:InitItemName(item) .. " (" .. fg_sid_x_d.items[item] .. "x)",
										}
										FUL_I_TD[x], x = self:Update_Tooltip(x, fg_sid_x_d.items[item] .. "x", self:InitItemName(item))
										FUL_II, currentQuestTimesBag, currentQuestTimesBagBank = self:Quest_Items(fg_sid_x_d.items[item], currentQuestTimesBag, currentQuestTimesBagBank, FUL_II, item)
										FIZ_UpdateList[itemIndex] = FUL_II
										itemIndex = itemIndex + 1
									end

									if currentQuestTimesBag > 0 then
										FUL_I.highlight = true
										FUL_I.lowlight = nil
										FUL_I.name = FUL_I.name .. FIZ_BAG_COLOUR .. " [" .. currentQuestTimesBag .. "x]|r"
										FUL_I.currentTimesBag = currentQuestTimesBag
										FUL_I.currentRepBag = currentQuestTimesBag * FUL_I.rep
										FIZ_CurrentRepInBag = FIZ_CurrentRepInBag + FUL_I.currentRepBag
										FUL_I.name = FUL_I.originalName
										FUL_I_TD[x], x = self:Update_Tooltip(x, " ", " ")
										FUL_I_TD[x], x = self:Update_Tooltip(x, FIZ_TXT.inBag, " ")
										FUL_I_TD[x], x = self:Update_Tooltip(x, FIZ_TXT.turnIns, string.format("%d", FUL_I.currentTimesBag))
										FUL_I_TD[x], x = self:Update_Tooltip(x, FIZ_TXT.reputation, string.format("%d", FUL_I.currentRepBag))
									else
										FUL_I.currentTimesBag = nil
										FUL_I.currentRepBag = nil
									end

									if currentQuestTimesBagBank > 0 then
										FUL_I.name = FUL_I.name .. FIZ_BAG_BANK_COLOUR .. " [" .. currentQuestTimesBagBank .. "x]|r"
										FUL_I.currentTimesBagBank = currentQuestTimesBagBank
										FUL_I.currentRepBagBank = currentQuestTimesBagBank * FUL_I.rep
										FUL_I.highlight = true
										FUL_I.name = FUL_I.originalName
										FUL_I.lowlight = nil
										FIZ_CurrentRepInBagBank = FIZ_CurrentRepInBagBank + FUL_I.currentRepBagBank
										FUL_I_TD[x], x = self:Update_Tooltip(x, " ", " ")
										FUL_I_TD[x], x = self:Update_Tooltip(x, FIZ_TXT.inBagBank, " ")
										FUL_I_TD[x], x = self:Update_Tooltip(x, FIZ_TXT.turnIns, string.format("%d", FUL_I.currentTimesBagBank))
										FUL_I_TD[x], x = self:Update_Tooltip(x, FIZ_TXT.reputation, string.format("%d", FUL_I.currentRepBagBank))
									else
										FUL_I.currentTimesBagBank = nil
										FUL_I.currentRepBagBank = nil
									end
									if currentQuestTimesBag == 0 and currentQuestTimesBagBank <= 0 then
										FUL_I.highlight = nil
									end
									FIZ_UpdateList[index] = FUL_I
									index = itemIndex
								else
									FUL_I.hasList = false
									FUL_I.listShown = nil
									FUL_I.highlight = nil
									FUL_I.lowlight = nil

									local entries = self:GetNumQuestLogEntries()
									for z = 1, entries do
										local title, isHeader, isComplete = self:GetQuestLogEntryInfo(z)
										if title and not isHeader then
											if string.find(string.lower(bul_name), string.lower(title), 1, true) then
												if isComplete then
													FUL_I.highlight = true
													FUL_I.name = FUL_I.name .. FIZ_QUEST_COLOUR .. " (" .. FIZ_TXT.complete .. ")|r"
													FUL_I.currentTimesQuest = 1
													FUL_I.currentRepQuest = FUL_I.rep
													FIZ_CurrentRepInQuest = FIZ_CurrentRepInQuest + fg_sid_x_d.rep

													FUL_I_TD[x], x = self:Update_Tooltip(x, " ", " ")
													FUL_I_TD[x], x = self:Update_Tooltip(x, FIZ_TXT.questCompleted, " ")
													FUL_I_TD[x], x = self:Update_Tooltip(x, FIZ_TXT.reputation, string.format("%d", FUL_I.currentRepQuest))
												else
													FUL_I.lowlight = true
													FUL_I.name = FUL_I.name .. FIZ_QUEST_ACTIVE_COLOUR .. " (" .. FIZ_TXT.active .. ")|r"
												end
											end
										end
									end
									FIZ_UpdateList[index] = FUL_I
									index = index + 1
								end

								FUL_I_TD[x], x = self:Update_Tooltip(x, " ", " ")
								FUL_I_TD[x] = self:Update_Tooltip(x, FIZ_TXT.maxStanding, _G["FACTION_STANDING_LABEL" .. fg_sid_x_d.maxStanding])
								FUL_I_TD.count = x
							end
						end
					end

					if sum > 0 and count > 1 then
						local toDo = ceil(repToNext / sum)
						local FUL_I = {
							type = FIZ_TXT.questShort,
							times = toDo .. "x",
							rep = string.format("%d", sum),
							index = index,
							belongsTo = nil,
							isShown = true,
							name = string.format(FIZ_TXT.allOfTheAbove, count),
							tooltipHead = string.format(FIZ_TXT.questSummaryHead, count),
							tooltipTip = FIZ_TXT.questSummaryTip,
							tooltipDetails = {},
						}
						local FUL_I_TD = FUL_I.tooltipDetails
						local x = 0
						FUL_I_TD[x], x = self:Update_Tooltip(x, FIZ_TXT.reputation, FUL_I.rep)
						FUL_I_TD[x], x = self:Update_Tooltip(x, FIZ_TXT.timesToDo, FUL_I.times)
						FUL_I_TD.count = x - 1
						FIZ_UpdateList[index] = FUL_I
						index = index + 1
					end
				end

				-- Items
				if fg_sid.items and FIZ_Data.ShowItems then
					local fg_sid_x = fg_sid.items
					for i = 0, fg_sid_x.count do
						local fg_sid_x_d = fg_sid_x.data[i]
						if fg_sid_x_d and (not fg_sid_x_d.limit or (normCurrent < fg_sid_x_d.limit)) then
							local toDo = ceil(repToNext / fg_sid_x_d.rep)
							if fg_sid_x_d.limit then
								toDo = ceil((fg_sid_x_d.limit - normCurrent) / fg_sid_x_d.rep)
							end
							if fg_sid_x_d.items then
								local singleItemName = nil
								local itemCount = 0
								for itemKey in pairs(fg_sid_x_d.items) do
									itemCount = itemCount + 1
									if itemCount == 1 then
										singleItemName = self:InitItemName(itemKey)
									else
										singleItemName = nil
									end
								end
								local FUL_I = {
									type = FIZ_TXT.itemsShort,
									times = toDo .. "x",
									rep = string.format("%d", fg_sid_x_d.rep),
									index = index,
									belongsTo = nil,
									isShown = true,
									name = singleItemName or FIZ_TXT.itemsName,
									hasList = true,
									listShown = false,
									tooltipHead = FIZ_TXT.itemsHead,
									tooltipTip = FIZ_TXT.itemsTip,
									tooltipDetails = {},
								}
								local FUL_I_TD = FUL_I.tooltipDetails
								local x = 0
								FUL_I_TD[x], x = self:Update_Tooltip(x, FUL_I.name, " ")
								FUL_I_TD[x], x = self:Update_Tooltip(x, " ", " ")
								FUL_I_TD[x], x = self:Update_Tooltip(x, FIZ_TXT.itemsRequired, " ")

								local itemIndex = index + 1
								local currentQuestTimesBag = -1
								local currentQuestTimesBagBank = -1
								for item in pairs(fg_sid_x_d.items) do
									local FUL_II = {
										type = "",
										times = (fg_sid_x_d.items[item] * toDo) .. "x",
										rep = nil,
										index = itemIndex,
										belongsTo = index,
										hasList = nil,
										listShown = nil,
										isShown = FUL_I.listShown,
										name = self:InitItemName(item) .. " (" .. fg_sid_x_d.items[item] .. "x)",
									}
									FUL_I_TD[x], x = self:Update_Tooltip(x, fg_sid_x_d.items[item] .. "x", self:InitItemName(item))
									FUL_II, currentQuestTimesBag, currentQuestTimesBagBank = self:Quest_Items(fg_sid_x_d.items[item], currentQuestTimesBag, currentQuestTimesBagBank, FUL_II, item)
									FIZ_UpdateList[itemIndex] = FUL_II
									itemIndex = itemIndex + 1
								end

								if currentQuestTimesBag > 0 then
									FUL_I.highlight = true
									FUL_I.lowlight = nil
									FUL_I.name = FUL_I.name .. FIZ_BAG_COLOUR .. " [" .. currentQuestTimesBag .. "x]|r"
									FUL_I.currentTimesBag = currentQuestTimesBag
									FUL_I.currentRepBag = currentQuestTimesBag * FUL_I.rep
									FIZ_CurrentRepInBag = FIZ_CurrentRepInBag + FUL_I.currentRepBag

									FUL_I_TD[x], x = self:Update_Tooltip(x, " ", " ")
									FUL_I_TD[x], x = self:Update_Tooltip(x, FIZ_TXT.inBag, " ")
									FUL_I_TD[x], x = self:Update_Tooltip(x, FIZ_TXT.turnIns, string.format("%d", FUL_I.currentTimesBag))
									FUL_I_TD[x], x = self:Update_Tooltip(x, FIZ_TXT.reputation, string.format("%d", FUL_I.currentRepBag))
								else
									FUL_I.currentTimesBag = nil
									FUL_I.currentRepBag = nil
									FUL_I.highlight = nil
								end

								if currentQuestTimesBagBank > 0 then
									FUL_I.highlight = true
									FUL_I.lowlight = nil
									FUL_I.name = FUL_I.name .. FIZ_BAG_BANK_COLOUR .. " [" .. currentQuestTimesBagBank .. "]|r"
									FUL_I.currentTimesBagBank = currentQuestTimesBagBank
									FUL_I.currentRepBagBank = currentQuestTimesBagBank * FUL_I.rep
									FIZ_CurrentRepInBagBank = FIZ_CurrentRepInBagBank + FUL_I.currentRepBagBank

									FUL_I_TD[x], x = self:Update_Tooltip(x, " ", " ")
									FUL_I_TD[x], x = self:Update_Tooltip(x, FIZ_TXT.inBagBank, " ")
									FUL_I_TD[x], x = self:Update_Tooltip(x, FIZ_TXT.turnIns, string.format("%d", FUL_I.currentTimesBagBank))
									FUL_I_TD[x], x = self:Update_Tooltip(x, FIZ_TXT.reputation, string.format("%d", FUL_I.currentRepBagBank))
								else
									FUL_I.currentTimesBagBank = nil
									FUL_I.currentRepBagBank = nil
								end

								if currentQuestTimesBag == 0 and currentQuestTimesBagBank <= 0 then
									FUL_I.highlight = nil
								end

								FUL_I_TD[x], x = self:Update_Tooltip(x, " ", " ")
								FUL_I_TD[x] = self:Update_Tooltip(x, FIZ_TXT.maxStanding, _G["FACTION_STANDING_LABEL" .. fg_sid_x_d.maxStanding])
								FUL_I_TD.count = x
								FIZ_UpdateList[index] = FUL_I
								index = itemIndex
							end
						end
					end
				end

				-- General
				if fg_sid.general and FIZ_Data.ShowGeneral then
					local fg_sid_x = fg_sid.general
					for i = 0, fg_sid_x.count do
						local fg_sid_x_d = fg_sid_x.data[i]
						if fg_sid_x_d and (not fg_sid_x_d.limit or (normCurrent < fg_sid_x_d.limit)) then
							local toDo = string.format("%.2f", repToNext / fg_sid_x_d.rep)
							if fg_sid_x_d.limit then
								toDo = string.format("%.2f", (fg_sid_x_d.limit - normCurrent) / fg_sid_x_d.rep)
							end
							local bul_name = fg_sid_x_d.name
							local FUL_I = {
								type = FIZ_TXT.generalShort,
								times = toDo .. "x",
								rep = string.format("%d", fg_sid_x_d.rep),
								index = index,
								belongsTo = nil,
								isShown = true,
								hasList = false,
								listShown = nil,
								name = bul_name,
								tooltipHead = (fg_sid_x_d.head and fg_sid_x_d.head ~= "") and fg_sid_x_d.head or FIZ_TXT.generalHead,
								tooltipTip = (fg_sid_x_d.tip and fg_sid_x_d.tip ~= "") and fg_sid_x_d.tip or FIZ_TXT.generalTip,
								tooltipDetails = {},
							}
							local FUL_I_TD = FUL_I.tooltipDetails
							local x = 0
							FUL_I_TD[x], x = self:Update_Tooltip(x, FIZ_TXT.general2, bul_name)
							FUL_I_TD[x], x = self:Update_Tooltip(x, FIZ_TXT.reputation, FUL_I.rep)
							FUL_I_TD[x], x = self:Update_Tooltip(x, FIZ_TXT.timesToRun, FUL_I.times)
							FUL_I_TD[x], x = self:Update_Tooltip(x, " ", " ")
							if fg_sid_x_d.tipList then
								for tip, tipVal in pairs(fg_sid_x_d.tipList) do
									FUL_I_TD[x], x = self:Update_Tooltip(x, tip, tipVal)
								end
								FUL_I_TD[x], x = self:Update_Tooltip(x, " ", " ")
							end
							FUL_I_TD[x] = self:Update_Tooltip(x, FIZ_TXT.maxStanding, _G["FACTION_STANDING_LABEL" .. fg_sid_x_d.maxStanding])
							FUL_I_TD.count = x
							FIZ_UpdateList[index] = FUL_I
							index = index + 1
						end
					end
				end
			end
		end
	end

	FIZ_UpdateList_Update()
end

function FIZ:Quest_Items(itemsNeed, currentQuestTimesBag, currentQuestTimesBagBank, QuestItem, item)
	if type(QuestItem) ~= "table" or not QuestItem.times then
		QuestItem = { name = "Item" }
	end
	local itemTotal = self:GetItemCount(item, true)
	if itemTotal == 0 then
		currentQuestTimesBag = 0
		currentQuestTimesBagBank = 0
	else
		local itemBag = self:GetItemCount(item, false)
		local itemBank = itemTotal - itemBag
		if itemBag >= itemsNeed and itemsNeed > 0 then
			QuestItem.currentTimesBag = floor(itemBag / itemsNeed)
			QuestItem.name = QuestItem.name .. FIZ_BAG_COLOUR .. " [" .. itemBag .. "x]|r"
			if currentQuestTimesBag == -1 then
				currentQuestTimesBag = QuestItem.currentTimesBag
			elseif QuestItem.currentTimesBag < currentQuestTimesBag then
				currentQuestTimesBag = QuestItem.currentTimesBag
			end
		else
			currentQuestTimesBag = 0
			QuestItem.name = QuestItem.name .. " [" .. itemBag .. "x]"
		end
		if itemBank and itemBank > 0 then
			if itemTotal >= itemsNeed and itemsNeed > 0 then
				QuestItem.name = QuestItem.name .. FIZ_BAG_BANK_COLOUR .. " [" .. itemTotal .. "x]|r"
				QuestItem.currentTimesBagBank = floor(itemTotal / itemsNeed)
				if currentQuestTimesBagBank == -1 then
					currentQuestTimesBagBank = QuestItem.currentTimesBagBank
				elseif QuestItem.currentTimesBagBank < currentQuestTimesBagBank then
					currentQuestTimesBagBank = QuestItem.currentTimesBagBank
				end
			else
				currentQuestTimesBagBank = 0
				QuestItem.name = QuestItem.name .. " [" .. itemBank .. "x]"
			end
		else
			currentQuestTimesBagBank = 0
		end
	end
	return QuestItem, currentQuestTimesBag, currentQuestTimesBagBank
end

function FIZ:GetReadyReputation(factionIndex)
	local result = 0
	if not factionIndex then return result end
	if not ReputationFrame or not ReputationFrame:IsVisible() then return result end

	local maxFactionIndex = self:GetNumFactions()
	if factionIndex > maxFactionIndex then return result end

	local faction, _, standingId, barMin, barMax, barValue, _, _, isHeader, _, hasRep, _, _, factionID = self:GetRawFactionInfo(factionIndex)
	if isHeader and not hasRep then return result end

	if faction then
		local oFaction = string.lower(faction)
		faction = string.lower(faction)
		if FIZ_FactionMapping[faction] then
			faction = FIZ_FactionMapping[faction]
		end

		local normCurrent = barValue - barMin
		local repToNext = barMax - barValue

		local FIZ_FG_f = (factionID and FIZ_FactionGain["id:" .. tostring(factionID)]) or FIZ_FactionGain[oFaction] or FIZ_FactionGain[faction]
		if FIZ_FG_f then
			local FIZ_FG_fs = FIZ_FG_f[standingId]
			if FIZ_FG_fs then
				-- Quests (may have items)
				local FIZ_FG_fs_h = FIZ_FG_fs.quests
				if FIZ_FG_fs_h and FIZ_Data.ShowQuests then
					for i = 0, FIZ_FG_fs_h.count do
						local d = FIZ_FG_fs_h.data[i]
						if d and (not d.limit or (normCurrent < d.limit)) then
							local toDo = ceil(repToNext / d.rep)
							if d.limit then
								toDo = ceil((d.limit - normCurrent) / d.rep)
							end

							if d.items then
								local currentQuestTimesBag = -1
								local currentQuestTimesBagBank = -1
								for item in pairs(d.items) do
									_, currentQuestTimesBag, currentQuestTimesBagBank = self:Quest_Items(d.items[item], currentQuestTimesBag, currentQuestTimesBagBank, {}, item)
								end
								if currentQuestTimesBag > toDo then
									currentQuestTimesBag = toDo
								end
								if currentQuestTimesBagBank > toDo then
									currentQuestTimesBagBank = toDo
								end
								if currentQuestTimesBagBank > 0 then
									result = result + currentQuestTimesBagBank * d.rep
								elseif currentQuestTimesBag > 0 then
									result = result + currentQuestTimesBag * d.rep
								end
							else
								local entries = self:GetNumQuestLogEntries()
								local questNameLower = string.lower(self:Quest_Names(d.name))
								for z = 1, entries do
									local title, isQHeader, isComplete = self:GetQuestLogEntryInfo(z)
									if title and not isQHeader and isComplete then
										if string.find(questNameLower, string.lower(title), 1, true) then
											result = result + d.rep
										end
									end
								end
							end
						end
					end
				end

				-- Items
				local FIZ_FG_fs_items = FIZ_FG_fs.items
				if FIZ_FG_fs_items and FIZ_Data.ShowItems then
					for i = 0, FIZ_FG_fs_items.count do
						local d = FIZ_FG_fs_items.data[i]
						if d and (not d.limit or (normCurrent < d.limit)) then
							local toDo = ceil(repToNext / d.rep)
							if d.limit then
								toDo = ceil((d.limit - normCurrent) / d.rep)
							end
							if d.items then
								local currentQuestTimesBag = -1
								local currentQuestTimesBagBank = -1
								for item in pairs(d.items) do
									_, currentQuestTimesBag, currentQuestTimesBagBank = self:Quest_Items(d.items[item], currentQuestTimesBag, currentQuestTimesBagBank, {}, item)
								end
								if currentQuestTimesBag > toDo then
									currentQuestTimesBag = toDo
								end
								if currentQuestTimesBagBank > toDo then
									currentQuestTimesBagBank = toDo
								end
								if currentQuestTimesBagBank > 0 then
									result = result + currentQuestTimesBagBank * d.rep
								elseif currentQuestTimesBag > 0 then
									result = result + currentQuestTimesBag * d.rep
								end
							end
						end
					end
				end
			end
		end
	end

	return result
end

function FIZ:StandingSort()
	local standings = {}
	local numFactions = self:GetNumFactions()

	for i = 1, numFactions do
		local _, _, standingID, _, barMax, barValue, _, _, isHeader, _, hasRep = self:GetRawFactionInfo(i)
		if standingID and (not isHeader or hasRep) then
			if not standings[standingID] then
				standings[standingID] = {}
			end
			local size = self:TableSize(standings[standingID])
			local entry = {
				missing = barMax - barValue,
				i = i,
			}
			local inserted = false
			if size then
				for j = 1, size do
					if not inserted and standings[standingID][j].missing > entry.missing then
						table.insert(standings[standingID], j, entry)
						inserted = true
					end
				end
				if not inserted then
					table.insert(standings[standingID], entry)
				end
			else
				table.insert(standings[standingID], entry)
			end
		end
	end

	local count = 0
	FIZ_Entries = {}
	if not FIZ_Collapsed then
		FIZ_Collapsed = {}
	end
	for i = 8, 1, -1 do
		if self:TableSize(standings[i]) > 0 and standings[i] then
			count = count + 1
			FIZ_Entries[count] = {
				header = true,
				i = i,
				size = self:TableSize(standings[i]),
			}
			if not FIZ_Collapsed[i] then
				for j in pairs(standings[i]) do
					count = count + 1
					FIZ_Entries[count] = {
						header = false,
						i = standings[i][j].i,
						size = 0,
					}
				end
			end
		end
	end
	FIZ_OBS_numFactions = count
end

function FIZ:DumpReputationChangesToChat(initOnly)
	if not FIZ_StoredRep then FIZ_StoredRep = {} end

	local numFactions = self:GetNumFactions()
	local watchIndex = 0
	local watchedIndex = 0
	local watchName = nil

	for factionIndex = 1, numFactions do
		local name, _, standingID, _, barMax, barValue, _, _, isHeader, _, hasRep, isWatched = self:GetRawFactionInfo(factionIndex)
		if name and (not isHeader or hasRep) then
			if isWatched then
				watchedIndex = factionIndex
			end
			if FIZ_StoredRep[name] and not initOnly then
				if FIZ_Data.WriteChatMessage then
					if not FIZ_Data.NoGuildGain or name ~= FIZ_GuildName then
						local sign = ""
						if (barValue - FIZ_StoredRep[name].origRep) > 0 then
							sign = "+"
						end
						if barValue > FIZ_StoredRep[name].rep then
							FIZ:Print(FIZ_NEW_REP_COLOUR .. string.format(FACTION_STANDING_INCREASED .. FIZ_TXT.stats, name, barValue - FIZ_StoredRep[name].rep, sign, barValue - FIZ_StoredRep[name].origRep, barMax - barValue))
						elseif barValue < FIZ_StoredRep[name].rep then
							FIZ:Print(FIZ_NEW_REP_COLOUR .. string.format(FACTION_STANDING_DECREASED .. FIZ_TXT.stats, name, FIZ_StoredRep[name].rep - barValue, sign, barValue - FIZ_StoredRep[name].origRep, barMax - barValue))
						end
						if FIZ_StoredRep[name].standingID ~= standingID then
							FIZ:Print(FIZ_NEW_STANDING_COLOUR .. string.format(FACTION_STANDING_CHANGED, _G["FACTION_STANDING_LABEL" .. standingID] or tostring(standingID), name))
						end
					end
				end
				if FIZ_Data.SwitchFactionBar then
					if not FIZ_Data.NoGuildSwitch or name ~= FIZ_GuildName then
						if barValue > FIZ_StoredRep[name].rep then
							watchIndex = factionIndex
							watchName = name
						end
					end
				end
			else
				FIZ_StoredRep[name] = { origRep = barValue }
			end
			FIZ_StoredRep[name].standingID = standingID
			FIZ_StoredRep[name].rep = barValue
		end
	end

	if watchIndex > 0 then
		if watchIndex ~= watchedIndex then
			if not FIZ_Data.SilentSwitch then
				FIZ:Print(FIZ_Help_COLOUR .. FIZ_NAME .. ":|r " .. FIZ_TXT.switchBar .. " [" .. tostring(watchName) .. "|r]")
			end
		end
		self:SetWatchedFactionIndex(watchIndex)
		if ReputationWatchBar_Update then
			ReputationWatchBar_Update()
		end
	end

	if self.UpdateLDBText then
		self:UpdateLDBText()
	end
end

function FIZ:ClearSessionGain()
	local factionIndex = self:GetSelectedFaction()
	local name, _, standingID, _, _, barValue = self:GetRawFactionInfo(factionIndex)
	if name then
		FIZ_StoredRep[name] = {
			origRep = barValue,
			standingID = standingID,
			rep = barValue,
		}
	end
	self:RefreshReputationFrame()
end

function FIZ_ChatFilter(_, event, ...)
	local msg, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13 = ...
	local skip = false
	if FIZ_Data and FIZ_Data.SuppressOriginalChat and event then
		if event == "CHAT_MSG_COMBAT_FACTION_CHANGE" then
			skip = true
		elseif event == "COMBAT_TEXT_UPDATE" and msg == "FACTION" then
			skip = true
		end
	end
	return skip, msg, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13
end

function FIZ:ListByStanding(standing)
	local numFactions = self:GetNumFactions()
	local list = {}

	for i = 1, numFactions do
		local name, _, standingID, barMin, barMax, barValue, _, _, isHeader, _, hasRep = self:GetRawFactionInfo(i)
		if name and (not isHeader or hasRep) then
			if standing == nil or standing == standingID then
				if not list[standingID] then
					list[standingID] = {}
				end
				list[standingID][name] = {
					max = barMax - barMin,
					value = barValue - barMin,
				}
			end
		end
	end

	for i = 1, 8 do
		if list[i] then
			local col = FACTION_BAR_COLORS[i] or FACTION_BAR_COLORS[4]
			FIZ:Print(FIZ_Help_COLOUR .. FIZ_NAME .. ":|r " .. FIZ:RGBToColour_perc(1, col.r, col.g, col.b) .. "--- " .. (FIZ_TXT_STAND_LV[i] or tostring(i)) .. " (" .. i .. ") ---|r")
			for p in pairs(list[i]) do
				FIZ:Print("    " .. p .. ": " .. FIZ_TXT.missing2 .. ": " .. (list[i][p].max - list[i][p].value))
			end
			if not standing then
				FIZ:Print(" ")
			end
		end
	end
end

