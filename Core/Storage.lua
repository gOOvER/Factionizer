----------------------------------------------------------
-- Factionizer - Storage, AceDB-3.0, LibSink & Sharing  --
----------------------------------------------------------

local FIZ = _G.FIZ
local LibStub = LibStub
local AceDB = LibStub("AceDB-3.0")
local LSM = LibStub("LibSharedMedia-3.0", true)
local LDBIcon = LibStub("LibDBIcon-1.0", true)
local LibDeflate = LibStub("LibDeflate", true)
local LibWindow = LibStub("LibWindow-1.1", true)

local COMM_PREFIX = "FIZSync7"

function FIZ:InitStorage()
	self.db = AceDB:New("FactionizerDB", self.DB_DEFAULTS or { profile = self.DEFAULT_PROFILE, char = { Collapsed = {}, StoredRep = {} } }, true)
	self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
	self.db.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")

	if LSM then
		LSM:Register("statusbar", "Blizzard", "Interface\\PaperDollInfoFrame\\UI-Character-Skills-Bar")
		LSM:Register("statusbar", "Flat", "Interface\\Buttons\\WHITE8X8")
		LSM.RegisterCallback(self, "LibSharedMedia_Registered", "UpdatePreviewBarTextures")
	end

	self:SyncProfileToLegacy()

	if self.SetSinkStorage and self.db and self.db.profile then
		self.db.profile.sink = self.db.profile.sink or { sink20OutputSink = "Chat", sink20Sticky = false }
		self:SetSinkStorage(self.db.profile.sink)
	end

	if self.RegisterComm then
		self:RegisterComm(COMM_PREFIX, "OnCommReceived")
	end
end

function FIZ:GetStatusBarTexturePath()
	local texName = self.db and self.db.profile and self.db.profile.StatusBarTexture or "Blizzard"
	if LSM then
		local path = LSM:Fetch("statusbar", texName, true)
		if path then return path end
	end
	return "Interface\\PaperDollInfoFrame\\UI-Character-Skills-Bar"
end

function FIZ:UpdatePreviewBarTextures()
	local texPath = self:GetStatusBarTexturePath()
	for i = 1, 15 do
		local bar = _G["FIZ_StatusBar" .. i]
		if bar and bar.SetStatusBarTexture then
			bar:SetStatusBarTexture(texPath)
		end
	end
	if self.DetailProgressBar and self.DetailProgressBar.SetStatusBarTexture then
		self.DetailProgressBar:SetStatusBarTexture(texPath)
	end
	if self.DetailPreviewBar and self.DetailPreviewBar.SetStatusBarTexture then
		self.DetailPreviewBar:SetStatusBarTexture(texPath)
	end
end

function FIZ:SetOption(key, value)
	local val = value
	if type(self.DEFAULT_PROFILE[key]) == "boolean" then
		val = value and true or false
	end
	if self.db and self.db.profile then
		self.db.profile[key] = val
	end
	FIZ_Data[key] = val
	if key == "SortByStanding" and FIZ_OrderByStandingCheckBox then
		FIZ_OrderByStandingCheckBox:SetChecked(val)
	elseif key == "StatusBarTexture" then
		self:UpdatePreviewBarTextures()
	end
end

function FIZ:SyncProfileToLegacy()
	if not self.db or not self.db.profile then return end
	local p = self.db.profile
	local c = self.db.char

	-- Migrate existing legacy FIZ_Data if profile has not been migrated yet
	if type(_G.FIZ_Data) == "table" and _G.FIZ_Data ~= p and next(_G.FIZ_Data) and not p._migratedFromLegacy then
		for k, v in pairs(_G.FIZ_Data) do
			if self.DEFAULT_PROFILE[k] ~= nil then
				p[k] = v
			end
		end
		p._migratedFromLegacy = true
	end
	if type(_G.FIZ_Suppressed) == "table" and _G.FIZ_Suppressed ~= p.Suppressed and next(_G.FIZ_Suppressed) and not p._migratedSuppressed then
		p.Suppressed = _G.FIZ_Suppressed
		p._migratedSuppressed = true
	end

	p.Suppressed = p.Suppressed or {}
	p.window = p.window or { detached = false, scale = 1.0 }
	p.configWindow = p.configWindow or { scale = 1.0 }
	p.sink = p.sink or { sink20OutputSink = "Chat", sink20Sticky = false }
	c.Collapsed = c.Collapsed or {}
	c.StoredRep = c.StoredRep or {}

	FIZ_Data = p
	_G.FIZ_Data = p
	FIZ_Suppressed = p.Suppressed
	_G.FIZ_Suppressed = p.Suppressed
	FIZ_Collapsed = c.Collapsed
	_G.FIZ_Collapsed = c.Collapsed
	FIZ_StoredRep = c.StoredRep
	_G.FIZ_StoredRep = c.StoredRep
end

function FIZ:OnProfileChanged()
	self:SyncProfileToLegacy()
	if self.SetSinkStorage and self.db and self.db.profile then
		self:SetSinkStorage(self.db.profile.sink)
	end
	if LDBIcon then
		LDBIcon:Refresh("Factionizer", self.db.profile.minimap)
	end
	if FIZ_OrderByStandingCheckBox then
		FIZ_OrderByStandingCheckBox:SetChecked(FIZ_Data.SortByStanding)
	end
	if LibWindow and FIZ_ReputationDetailFrame and self.db.profile.window then
		LibWindow.RegisterConfig(FIZ_ReputationDetailFrame, self.db.profile.window)
		if self.db.profile.window.detached then
			LibWindow.RestorePosition(FIZ_ReputationDetailFrame)
		end
	end
	self:UpdatePreviewBarTextures()
	self:RefreshReputationFrame()
	if FIZ_ReputationDetailFrame and FIZ_ReputationDetailFrame:IsVisible() then
		self:BuildUpdateList()
		FIZ_UpdateList_Update()
	end
end

----------------------------------------------------------
-- Profile & Exclusions Export / Import (LibDeflate)    --
----------------------------------------------------------

local EXPORT_KEYS = {
	"ShowMobs", "ShowQuests", "ShowInstances", "ShowItems", "ShowGeneral",
	"ShowMissing", "ExtendDetails", "WriteChatMessage", "NoGuildGain",
	"SuppressOriginalChat", "ShowPreviewRep", "SwitchFactionBar",
	"SilentSwitch", "NoGuildSwitch", "SortByStanding", "StatusBarTexture",
}

function FIZ:ExportProfileString()
	if not self.Serialize or not self.db or not self.db.profile then return "" end
	local p = self.db.profile
	local payload = {
		v = FIZ_VNMBR,
		settings = {},
		suppressed = p.Suppressed or {},
		sink = p.sink or {},
	}
	for _, k in ipairs(EXPORT_KEYS) do
		payload.settings[k] = p[k]
	end
	local serialized = self:Serialize(payload)
	if LibDeflate then
		local compressed = LibDeflate:CompressDeflate(serialized)
		local encoded = compressed and LibDeflate:EncodeForPrint(compressed)
		if encoded then
			return "!FIZ1!" .. encoded
		end
	end
	return serialized
end

function FIZ:ImportProfileString(str)
	if not self.Deserialize or type(str) ~= "string" then return false, "Invalid string" end
	str = str:gsub("^%s+", ""):gsub("%s+$", "")
	if str == "" then return false, "Empty string" end

	local raw = str
	if str:sub(1, 6) == "!FIZ1!" and LibDeflate then
		local decoded = LibDeflate:DecodeForPrint(str:sub(7))
		if not decoded then return false, "Decode error" end
		raw = LibDeflate:DecompressDeflate(decoded)
		if not raw then return false, "Checksum/Decompress error" end
	end

	local ok, data = self:Deserialize(raw)
	if not ok or type(data) ~= "table" then
		return false, "Deserialize error"
	end

	local p = self.db.profile
	if type(data.settings) == "table" then
		for _, k in ipairs(EXPORT_KEYS) do
			if data.settings[k] ~= nil then
				p[k] = data.settings[k]
			end
		end
	end
	if type(data.suppressed) == "table" then
		p.Suppressed = data.suppressed
	end
	if type(data.sink) == "table" then
		p.sink = data.sink
	end

	self:OnProfileChanged()
	return true
end

----------------------------------------------------------
-- Guild / Group Exclusions Sharing (AceComm-3.0)       --
----------------------------------------------------------

function FIZ:ShareSuppressedWithGroup(channel)
	if not self.SendCommMessage or not self.Serialize or not self.db or not self.db.profile then return end
	local targetChannel = channel
	if not targetChannel then
		if IsInRaid and IsInRaid() then
			targetChannel = "RAID"
		elseif IsInGroup and IsInGroup() then
			targetChannel = "PARTY"
		elseif IsInGuild and IsInGuild() then
			targetChannel = "GUILD"
		end
	end
	if not targetChannel then
		self:Print(FIZ_Help_COLOUR .. FIZ_NAME .. ":|r " .. (FIZ_TXT.commNotInGroup or "Cannot share (not in a group or guild)."), true)
		return
	end

	local payload = {
		cmd = "SUPPRESSED_SYNC",
		suppressed = self.db.profile.Suppressed or {},
	}
	local serialized = self:Serialize(payload)
	if LibDeflate then
		local comp = LibDeflate:CompressDeflate(serialized)
		serialized = (comp and LibDeflate:EncodeForWoWAddonChannel(comp)) or serialized
	end
	self:SendCommMessage(COMM_PREFIX, serialized, targetChannel)
	self:Print(FIZ_Help_COLOUR .. FIZ_NAME .. ":|r " .. string.format(FIZ_TXT.commSharedVia or "Shared quest/item exclusions via %s.", targetChannel), true)
end

function FIZ:OnCommReceived(prefix, message, _, sender)
	if prefix ~= COMM_PREFIX or not self.db or not self.db.profile then return end
	if not self.db.profile.enableCommSync then return end
	if sender and FIZ_Player and sender:match("^([^%-]+)") == FIZ_Player then return end

	local raw = message
	if LibDeflate then
		local dec = LibDeflate:DecodeForWoWAddonChannel(message)
		if dec then
			local decomp = LibDeflate:DecompressDeflate(dec)
			if decomp then raw = decomp end
		end
	end

	local ok, data = self:Deserialize(raw)
	if not ok or type(data) ~= "table" or data.cmd ~= "SUPPRESSED_SYNC" or type(data.suppressed) ~= "table" then
		return
	end

	local added = 0
	local sup = self.db.profile.Suppressed
	for faction, entries in pairs(data.suppressed) do
		if type(entries) == "table" then
			sup[faction] = sup[faction] or {}
			for entryKey, flag in pairs(entries) do
				if flag and not sup[faction][entryKey] then
					sup[faction][entryKey] = true
					added = added + 1
				end
			end
		end
	end

	if added > 0 then
		self:Print(FIZ_Help_COLOUR .. FIZ_NAME .. ":|r " .. string.format(FIZ_TXT.commReceivedFrom or "Received %d exclusion(s) from %s.", added, tostring(sender or "?")), true)
		if FIZ_ReputationDetailFrame and FIZ_ReputationDetailFrame:IsVisible() then
			self:BuildUpdateList()
			FIZ_UpdateList_Update()
		end
	end
end
