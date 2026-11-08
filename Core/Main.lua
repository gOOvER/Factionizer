----------------------------------------------------------
-- Factionizer - Core Lifecycle & Event Management      --
----------------------------------------------------------

local FIZ = _G.FIZ

function FIZ:OnInitialize()
	self:InitStorage()
	self:InitOptions()
	self:InitCommands()
	self:SetupLDB()
end

function FIZ:OnEnable()
	self:SetupHooks()

	if FIZ_OptionsButtonText then
		FIZ_OptionsButtonText:SetText(FIZ_TXT.options)
	end
	if FIZ_OrderByStandingCheckBoxText then
		FIZ_OrderByStandingCheckBoxText:SetText(FIZ_TXT.orderByStanding)
	end
	if FIZ_OrderByStandingCheckBox then
		FIZ_OrderByStandingCheckBox:SetChecked(FIZ_Data.SortByStanding)
	end

	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("UPDATE_FACTION", "OnReputationChanged")
	self:RegisterEvent("QUEST_COMPLETE", "OnReputationChanged")
	self:RegisterEvent("QUEST_WATCH_UPDATE", "OnReputationChanged")
	self:RegisterBucketEvent("BAG_UPDATE", 0.2, "OnBagUpdate")
	self:RegisterEvent("BANKFRAME_OPENED", "OnBankOpened")
	self:RegisterEvent("BANKFRAME_CLOSED", "OnBankClosed")
	self:RegisterEvent("CHAT_MSG_SKILL", "OnSkillsChanged")
	self:RegisterEvent("SKILL_LINES_CHANGED", "OnSkillsChanged")
	self:RegisterEvent("TRADE_SKILL_SHOW", "OnSkillsChanged")

	if ChatFrame_AddMessageEventFilter then
		ChatFrame_AddMessageEventFilter("CHAT_MSG_COMBAT_FACTION_CHANGE", FIZ_ChatFilter)
		ChatFrame_AddMessageEventFilter("COMBAT_TEXT_UPDATE", FIZ_ChatFilter)
	end

	self:Init()
end

function FIZ:PLAYER_ENTERING_WORLD()
	self:Init()
	if FIZ_InitCount <= 5 then
		self:ScheduleTimer("DelayedInitCheck", 5)
	end
end

function FIZ:DelayedInitCheck()
	FIZ_InitCount = FIZ_InitCount + 1
	if IsInGuild and IsInGuild() and (not FIZ_GuildName or FIZ_GuildName == "") then
		FIZ_GuildName = GetGuildInfo("player")
		if FIZ_GuildName and FIZ_GuildName ~= "" then
			self:InitFactionMap(GetLocale(), FIZ_GuildName)
			FIZ_FactionGain = {}
			FIZ_InitEnFactionGains(FIZ_GuildName)
		end
	end
	if FIZ_InitCount <= 5 and (not FIZ_GuildName or FIZ_GuildName == "") then
		self:ScheduleTimer("DelayedInitCheck", 5)
	end
end

function FIZ:OnReputationChanged()
	self:RefreshReputationFrame()
	if FIZ_ReputationDetailFrame and FIZ_ReputationDetailFrame:IsVisible() then
		self:BuildUpdateList()
		FIZ_UpdateList_Update()
	end
	self:DumpReputationChangesToChat()
end

function FIZ:OnBagUpdate()
	if FIZ_ReputationDetailFrame and FIZ_ReputationDetailFrame:IsVisible() then
		self:RefreshReputationFrame()
	end
end

function FIZ:OnBankOpened()
	FIZ_BankOpen = true
end

function FIZ:OnBankClosed()
	if FIZ_BankOpen then
		FIZ_BankOpen = nil
		if FIZ_ReputationDetailFrame and FIZ_ReputationDetailFrame:IsVisible() then
			self:RefreshReputationFrame()
		end
	end
end

function FIZ:OnSkillsChanged()
	self:ExtractSkills()
	self:RefreshReputationFrame()
	if FIZ_ReputationDetailFrame and FIZ_ReputationDetailFrame:IsVisible() then
		self:BuildUpdateList()
		FIZ_UpdateList_Update()
	end
end

function FIZ:Init()
	if FIZ_InitComplete then return end

	self:SyncProfileToLegacy()
	FIZ_Data.Version = FIZ_VNMBR

	self:ExtractSkills()

	local _, race = UnitRace("player")
	local faction, locFaction = UnitFactionGroup("player")
	local _, enClass = UnitClass("player")
	FIZ_Player = UnitName("player")
	FIZ_Realm = GetRealmName and GetRealmName() or "Realm"

	if IsInGuild and IsInGuild() then
		if FIZ_GuildName == nil or FIZ_GuildName == "" then
			FIZ_GuildName = GetGuildInfo("player")
		end
	end

	if race and faction and FIZ_Player then
		FIZ_IsHuman = (race == "Human")
		FIZ_IsDeathKnight = (enClass == "DEATHKNIGHT")
		FIZ_IsAlliance = (faction == "Alliance" or faction == FACTION_ALLIANCE or locFaction == FACTION_ALLIANCE)
		FIZ_IsHorde = (faction == "Horde" or faction == FACTION_HORDE or locFaction == FACTION_HORDE)

		self:InitFactor(FIZ_IsHuman)

		local locale = GetLocale()
		self:InitFactionMap(locale, FIZ_GuildName)
		FIZ_FactionGain = {}
		if FIZ_InitEnFactionGains then
			FIZ_InitEnFactionGains(FIZ_GuildName)
		end
		self:DumpReputationChangesToChat(true)

		FIZ_InitComplete = true
	end
end

