----------------------------------------------------------
-- Factionizer - Shared Modern Dark-Gold UI Style       --
----------------------------------------------------------

local FIZ = _G.FIZ
FIZ.UIStyle = FIZ.UIStyle or {}
local UIStyle = FIZ.UIStyle

local WHITE_TEX = "Interface\\Buttons\\WHITE8X8"

UIStyle._fontListeners = UIStyle._fontListeners or {}

function UIStyle.GetFontSize()
	local sz = (FIZ and FIZ.db and FIZ.db.profile and tonumber(FIZ.db.profile.uiFontSize)) or 13
	return math.min(math.max(math.floor(sz), 10), 18)
end

function UIStyle.SetFontSize(size)
	size = math.min(math.max(math.floor(tonumber(size) or 13), 10), 18)
	if FIZ and FIZ.db and FIZ.db.profile then
		FIZ.db.profile.uiFontSize = size
	end
	for _, fn in ipairs(UIStyle._fontListeners) do
		pcall(fn, size)
	end
	return size
end

function UIStyle.RegisterFontListener(fn)
	if type(fn) == "function" then
		table.insert(UIStyle._fontListeners, fn)
	end
end

function UIStyle.ApplyFont(fontString, delta, overrideFlags)
	if not fontString or not fontString.GetFont or not fontString.SetFont then return end
	local fontPath, _, fontFlags = fontString:GetFont()
	if not fontPath then
		fontPath, _, fontFlags = GameFontNormal:GetFont()
	end
	if fontPath then
		local targetSize = math.max(9, UIStyle.GetFontSize() + (delta or 0))
		fontString:SetFont(fontPath, targetSize, overrideFlags ~= nil and overrideFlags or (fontFlags or ""))
	end
end

function UIStyle.ApplyBox(f, bgR, bgG, bgB, bgA, brR, brG, brB, brA)
	if not f or not f.SetBackdrop then return end
	f:SetBackdrop({
		bgFile = WHITE_TEX,
		edgeFile = WHITE_TEX,
		tile = false,
		edgeSize = 1,
		insets = { left = 1, right = 1, top = 1, bottom = 1 },
	})
	f:SetBackdropColor(bgR or 0.08, bgG or 0.09, bgB or 0.12, bgA or 0.96)
	f:SetBackdropBorderColor(brR or 0.24, brG or 0.27, brB or 0.34, brA or 1)
end

function UIStyle.CreateHeader(parent, titleText, iconTexture, onClose)
	local header = CreateFrame("Frame", nil, parent, BackdropTemplateMixin and "BackdropTemplate" or nil)
	header:SetPoint("TOPLEFT", parent, "TOPLEFT", 1, -1)
	header:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -1, -1)
	header:SetHeight(42)
	UIStyle.ApplyBox(header, 0.11, 0.13, 0.17, 1, 0.22, 0.25, 0.32, 1)

	-- Subtle gold bottom accent line
	local accent = header:CreateTexture(nil, "OVERLAY")
	accent:SetColorTexture(0.79, 0.64, 0.15, 0.85)
	accent:SetPoint("BOTTOMLEFT", header, "BOTTOMLEFT", 0, 0)
	accent:SetPoint("BOTTOMRIGHT", header, "BOTTOMRIGHT", 0, 0)
	accent:SetHeight(1)
	header.Accent = accent

	local icon = header:CreateTexture(nil, "ARTWORK")
	icon:SetSize(24, 24)
	icon:SetPoint("LEFT", header, "LEFT", 12, 0)
	icon:SetTexture(iconTexture or "Interface\\Icons\\Achievement_Reputation_01")
	icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	header.Icon = icon

	local title = header:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	title:SetPoint("LEFT", icon, "RIGHT", 10, 0)
	title:SetText(titleText or "")
	title:SetTextColor(1, 0.85, 0.25)
	header.Title = title

	local badge = header:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	badge:SetPoint("RIGHT", header, "RIGHT", -48, 0)
	badge:SetTextColor(0.65, 0.72, 0.82)
	header.Badge = badge

	local closeBtn = CreateFrame("Button", nil, header, BackdropTemplateMixin and "BackdropTemplate" or nil)
	closeBtn:SetSize(28, 28)
	closeBtn:SetPoint("RIGHT", header, "RIGHT", -8, 0)
	UIStyle.ApplyBox(closeBtn, 0.16, 0.18, 0.23, 1, 0.28, 0.31, 0.38, 1)
	local closeTxt = closeBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	closeTxt:SetPoint("CENTER", 0, 0)
	closeTxt:SetText("×")
	closeTxt:SetTextColor(0.82, 0.86, 0.92)
	closeBtn:SetScript("OnEnter", function(self)
		self:SetBackdropColor(0.65, 0.18, 0.22, 1)
		self:SetBackdropBorderColor(0.90, 0.30, 0.35, 1)
		closeTxt:SetTextColor(1, 1, 1)
	end)
	closeBtn:SetScript("OnLeave", function(self)
		self:SetBackdropColor(0.16, 0.18, 0.23, 1)
		self:SetBackdropBorderColor(0.28, 0.31, 0.38, 1)
		closeTxt:SetTextColor(0.82, 0.86, 0.92)
	end)
	closeBtn:SetScript("OnClick", function()
		if PlaySound and SOUNDKIT then
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
		end
		if onClose then onClose() end
	end)
	header.CloseButton = closeBtn

	-- Font Size Controls (A- | 13pt | A+)
	local fontPlusBtn = UIStyle.CreateButton(header, 28, 24, "A+", "default")
	fontPlusBtn:SetPoint("RIGHT", closeBtn, "LEFT", -8, 0)
	header.FontPlusBtn = fontPlusBtn

	local fontIndicator = CreateFrame("Frame", nil, header, BackdropTemplateMixin and "BackdropTemplate" or nil)
	fontIndicator:SetSize(38, 24)
	fontIndicator:SetPoint("RIGHT", fontPlusBtn, "LEFT", -3, 0)
	UIStyle.ApplyBox(fontIndicator, 0.08, 0.10, 0.13, 1, 0.22, 0.25, 0.32, 1)
	local fontLabel = fontIndicator:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	fontLabel:SetPoint("CENTER", 0, 0)
	fontLabel:SetTextColor(0.95, 0.80, 0.28)
	fontLabel:SetText(UIStyle.GetFontSize() .. "pt")
	header.FontLabel = fontLabel

	local fontMinusBtn = UIStyle.CreateButton(header, 28, 24, "A-", "default")
	fontMinusBtn:SetPoint("RIGHT", fontIndicator, "LEFT", -3, 0)
	header.FontMinusBtn = fontMinusBtn

	badge:ClearAllPoints()
	badge:SetPoint("RIGHT", fontMinusBtn, "LEFT", -10, 0)

	fontMinusBtn:SetScript("OnClick", function()
		UIStyle.SetFontSize(UIStyle.GetFontSize() - 1)
	end)
	fontPlusBtn:SetScript("OnClick", function()
		UIStyle.SetFontSize(UIStyle.GetFontSize() + 1)
	end)

	UIStyle.RegisterFontListener(function(newSize)
		if header.FontLabel then
			header.FontLabel:SetText(newSize .. "pt")
		end
		UIStyle.ApplyFont(title, 2)
		UIStyle.ApplyFont(badge, 0)
	end)
	UIStyle.ApplyFont(title, 2)
	UIStyle.ApplyFont(badge, 0)

	header:EnableMouse(true)
	header:SetScript("OnMouseDown", function(_, button)
		if button == "LeftButton" and parent:IsMovable() then
			parent:StartMoving()
		end
	end)
	header:SetScript("OnMouseUp", function()
		if parent:IsMovable() then
			parent:StopMovingOrSizing()
			if parent.OnMoved then parent:OnMoved() end
		end
	end)

	return header
end

function UIStyle.FormatIconText(iconTexture, text)
	if not iconTexture then return text or "" end
	if type(iconTexture) == "number" or not tostring(iconTexture):find("UI%-GroupLoot") then
		return string.format("|T%s:15:15:0:0:64:64:5:59:5:59|t  %s", tostring(iconTexture), text or "")
	else
		return string.format("|T%s:15:15:0:0|t  %s", tostring(iconTexture), text or "")
	end
end

function UIStyle.CreateButton(parent, width, height, text, variant, iconTexture, name)
	local btn = CreateFrame("Button", name, parent, BackdropTemplateMixin and "BackdropTemplate" or nil)
	if width then btn:SetWidth(width) end
	btn:SetHeight(height or 26)
	btn._iconTexture = iconTexture

	local schemes = {
		default = {
			bg = { 0.15, 0.18, 0.23, 1 },
			br = { 0.27, 0.31, 0.39, 1 },
			hoverBg = { 0.21, 0.25, 0.33, 1 },
			hoverBr = { 0.83, 0.68, 0.21, 1 },
			txt = { 0.92, 0.94, 0.98 },
		},
		primary = {
			bg = { 0.24, 0.20, 0.09, 1 },
			br = { 0.78, 0.63, 0.16, 1 },
			hoverBg = { 0.33, 0.27, 0.12, 1 },
			hoverBr = { 0.98, 0.82, 0.28, 1 },
			txt = { 1.00, 0.88, 0.35 },
		},
		danger = {
			bg = { 0.24, 0.11, 0.13, 1 },
			br = { 0.62, 0.22, 0.26, 1 },
			hoverBg = { 0.36, 0.15, 0.18, 1 },
			hoverBr = { 0.90, 0.32, 0.36, 1 },
			txt = { 1.00, 0.65, 0.68 },
		},
	}
	local s = schemes[variant or "default"] or schemes.default
	btn._scheme = s

	UIStyle.ApplyBox(btn, s.bg[1], s.bg[2], s.bg[3], s.bg[4], s.br[1], s.br[2], s.br[3], s.br[4])

	btn._minWidth = width or 60
	btn._baseHeight = height or 26

	local label = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	label:SetPoint("CENTER", btn, "CENTER", 0, 0)
	UIStyle.ApplyFont(label, 0)
	label:SetText(UIStyle.FormatIconText(iconTexture, text))
	label:SetTextColor(s.txt[1], s.txt[2], s.txt[3])
	btn.Label = label

	function btn:UpdateSize()
		UIStyle.ApplyFont(label, 0)
		local textW = label:GetStringWidth() or 0
		if textW > 0 then
			self:SetWidth(math.max(self._minWidth or 60, math.ceil(textW + 24)))
		elseif self._minWidth then
			self:SetWidth(self._minWidth)
		end
		self:SetHeight(math.max(self._baseHeight or 26, UIStyle.GetFontSize() + 13))
	end

	function btn:SetText(t)
		label:SetText(UIStyle.FormatIconText(self._iconTexture, t))
		self:UpdateSize()
	end
	function btn:GetFontString()
		return label
	end
	btn:UpdateSize()
	UIStyle.RegisterFontListener(function()
		if btn and btn.UpdateSize then
			btn:UpdateSize()
		end
	end)

	local function refreshState(self, hovered)
		if not self:IsEnabled() then
			self:SetBackdropColor(0.10, 0.11, 0.14, 0.85)
			self:SetBackdropBorderColor(0.18, 0.20, 0.25, 0.85)
			label:SetTextColor(0.42, 0.45, 0.50)
		elseif hovered then
			self:SetBackdropColor(s.hoverBg[1], s.hoverBg[2], s.hoverBg[3], s.hoverBg[4])
			self:SetBackdropBorderColor(s.hoverBr[1], s.hoverBr[2], s.hoverBr[3], s.hoverBr[4])
			label:SetTextColor(1, 1, 1)
		else
			self:SetBackdropColor(s.bg[1], s.bg[2], s.bg[3], s.bg[4])
			self:SetBackdropBorderColor(s.br[1], s.br[2], s.br[3], s.br[4])
			label:SetTextColor(s.txt[1], s.txt[2], s.txt[3])
		end
	end

	btn:SetScript("OnEnter", function(self) refreshState(self, true) end)
	btn:SetScript("OnLeave", function(self) refreshState(self, false) end)
	hooksecurefunc(btn, "Enable", function(self) refreshState(self, false) end)
	hooksecurefunc(btn, "Disable", function(self) refreshState(self, false) end)

	return btn
end

function UIStyle.CreateFilterPill(parent, text, defaultActive, onToggle, name)
	local pill = CreateFrame("Button", name, parent, BackdropTemplateMixin and "BackdropTemplate" or nil)
	pill:SetHeight(26)
	pill.active = (defaultActive ~= false)

	local dotBorder = pill:CreateTexture(nil, "BORDER")
	dotBorder:SetSize(9, 9)
	dotBorder:SetPoint("LEFT", pill, "LEFT", 9, 0)
	dotBorder:SetColorTexture(0.05, 0.06, 0.08, 1)

	local dot = pill:CreateTexture(nil, "ARTWORK")
	dot:SetSize(7, 7)
	dot:SetPoint("CENTER", dotBorder, "CENTER", 0, 0)
	pill.Dot = dot

	local label = pill:CreateFontString(name and (name .. "Text") or nil, "OVERLAY", "GameFontHighlight")
	label:SetPoint("LEFT", dotBorder, "RIGHT", 7, 0)
	label:SetText(text or "")
	pill.Label = label

	local function updateVisual()
		if pill.active then
			UIStyle.ApplyBox(pill, 0.13, 0.23, 0.19, 1, 0.18, 0.68, 0.46, 1)
			dot:SetColorTexture(0.0, 1.0, 0.59, 1)
			label:SetTextColor(0.92, 0.98, 0.95)
		else
			UIStyle.ApplyBox(pill, 0.12, 0.14, 0.18, 1, 0.24, 0.27, 0.34, 1)
			dot:SetColorTexture(0.32, 0.36, 0.44, 1)
			label:SetTextColor(0.56, 0.60, 0.68)
		end
		if not pill._fixedWidth then
			local w = math.max((label:GetStringWidth() or 54) + 30, 68)
			pill:SetWidth(w)
		end
	end

	function pill:SetFixedWidth(w)
		self._fixedWidth = w
		self:SetWidth(w)
	end

	function pill:SetChecked(val)
		self.active = (val and val ~= 0) and true or false
		updateVisual()
	end

	function pill:GetChecked()
		return self.active
	end

	function pill:SetText(t)
		label:SetText(t or "")
		updateVisual()
	end

	pill:SetScript("OnClick", function(self)
		self.active = not self.active
		updateVisual()
		if PlaySound and SOUNDKIT then
			PlaySound(self.active and SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_OFF)
		end
		if onToggle then onToggle(self, self.active) end
	end)
	pill:SetScript("OnEnter", function(self)
		if self.active then
			self:SetBackdropBorderColor(0.30, 0.88, 0.62, 1)
		else
			self:SetBackdropBorderColor(0.45, 0.50, 0.62, 1)
		end
		if self.tooltipText then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, true)
			GameTooltip:Show()
		end
	end)
	pill:SetScript("OnLeave", function()
		updateVisual()
		GameTooltip:Hide()
	end)

	updateVisual()
	return pill
end

function UIStyle.CreateEditBox(parent, width, height, placeholderText, name)
	local box = CreateFrame("EditBox", name, parent, BackdropTemplateMixin and "BackdropTemplate" or nil)
	if width then box:SetWidth(width) end
	box:SetHeight(height or 26)
	box:SetAutoFocus(false)
	box:ClearFocus()
	box:SetMultiLine(false)
	box:SetTextInsets(8, 24, 4, 4)
	box:SetFontObject("GameFontHighlight")
	UIStyle.ApplyBox(box, 0.06, 0.07, 0.09, 1, 0.24, 0.27, 0.35, 1)

	local placeholder = box:CreateFontString(nil, "OVERLAY", "GameFontDisable")
	placeholder:SetPoint("LEFT", box, "LEFT", 8, 0)
	placeholder:SetText(placeholderText or "")
	placeholder:SetTextColor(0.48, 0.53, 0.62)
	box.Placeholder = placeholder

	local clearBtn = CreateFrame("Button", nil, box)
	clearBtn:SetSize(18, 18)
	clearBtn:SetPoint("RIGHT", box, "RIGHT", -4, 0)
	local clearTxt = clearBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	clearTxt:SetPoint("CENTER", 0, 0)
	clearTxt:SetText("×")
	clearTxt:SetTextColor(0.60, 0.65, 0.72)
	clearBtn:Hide()
	clearBtn:SetScript("OnEnter", function() clearTxt:SetTextColor(1, 0.35, 0.35) end)
	clearBtn:SetScript("OnLeave", function() clearTxt:SetTextColor(0.60, 0.65, 0.72) end)
	clearBtn:SetScript("OnClick", function()
		box:SetText("")
		box:ClearFocus()
		if box.OnValueChanged then box:OnValueChanged("") end
	end)
	box.ClearButton = clearBtn

	local function syncPlaceholder()
		local txt = box:GetText() or ""
		if txt == "" and not box:HasFocus() then
			placeholder:Show()
		else
			placeholder:Hide()
		end
		if txt ~= "" then
			clearBtn:Show()
		else
			clearBtn:Hide()
		end
	end

	box:SetScript("OnEditFocusGained", function(self)
		self:SetBackdropBorderColor(0.83, 0.68, 0.21, 1)
		placeholder:Hide()
	end)
	box:SetScript("OnEditFocusLost", function(self)
		self:SetBackdropBorderColor(0.24, 0.27, 0.35, 1)
		syncPlaceholder()
	end)
	box:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
	box:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)
	box:SetScript("OnTextChanged", function(self, userInput)
		syncPlaceholder()
		if self.OnValueChanged then self:OnValueChanged(self:GetText() or "", userInput) end
	end)

	syncPlaceholder()
	return box
end
