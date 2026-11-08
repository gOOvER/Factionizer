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
	if not f then return end
	if not f.SetBackdrop and BackdropTemplateMixin then
		Mixin(f, BackdropTemplateMixin)
	end
	if not f.SetBackdrop then return end
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

function UIStyle.FormatIconText(iconTexture, text)
	if not iconTexture then return text or "" end
	local texStr = tostring(iconTexture)
	if type(iconTexture) == "number" or texStr:find("^Interface\\Icons\\") then
		return string.format("|T%s:14:14:0:0:64:64:5:59:5:59|t %s", texStr, text or "")
	else
		return string.format("|T%s:14:14:0:0|t %s", texStr, text or "")
	end
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
	title:SetJustifyH("LEFT")
	title:SetWordWrap(false)
	title:SetText(titleText or "")
	title:SetTextColor(1, 0.85, 0.25)
	header.Title = title

	local badge = header:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	badge:SetPoint("RIGHT", header, "RIGHT", -48, 0)
	badge:SetTextColor(0.65, 0.72, 0.82)
	header.Badge = badge

	local closeBtn = CreateFrame("Button", nil, header, BackdropTemplateMixin and "BackdropTemplate" or nil)
	closeBtn:SetSize(26, 26)
	closeBtn:SetPoint("RIGHT", header, "RIGHT", -8, 0)
	UIStyle.ApplyBox(closeBtn, 0.18, 0.14, 0.16, 1, 0.38, 0.26, 0.30, 1)

	local closeIcon = closeBtn:CreateTexture(nil, "OVERLAY")
	closeIcon:SetSize(14, 14)
	closeIcon:SetPoint("CENTER", closeBtn, "CENTER", 0, 0)
	closeIcon:SetTexture("Interface\\Buttons\\UI-StopButton")
	closeIcon:SetVertexColor(0.92, 0.75, 0.78, 1)
	closeBtn.Icon = closeIcon

	closeBtn:SetScript("OnEnter", function(self)
		self:SetBackdropColor(0.68, 0.18, 0.22, 1)
		self:SetBackdropBorderColor(0.95, 0.35, 0.40, 1)
		closeIcon:SetVertexColor(1, 1, 1, 1)
	end)
	closeBtn:SetScript("OnLeave", function(self)
		self:SetBackdropColor(0.18, 0.14, 0.16, 1)
		self:SetBackdropBorderColor(0.38, 0.26, 0.30, 1)
		closeIcon:SetVertexColor(0.92, 0.75, 0.78, 1)
	end)
	closeBtn:SetScript("OnClick", function()
		if PlaySound and SOUNDKIT then
			PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
		end
		if onClose then onClose() end
	end)
	header.CloseButton = closeBtn

	-- Font Size Controls (A- | 13pt | A+)
	local fontPlusBtn = UIStyle.CreateButton(header, 30, 24, "A+", "default")
	fontPlusBtn:SetFixedWidth(30)
	fontPlusBtn:SetPoint("RIGHT", closeBtn, "LEFT", -6, 0)
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
	header.FontIndicator = fontIndicator

	local fontMinusBtn = UIStyle.CreateButton(header, 30, 24, "A-", "default")
	fontMinusBtn:SetFixedWidth(30)
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
		UIStyle.ApplyFont(title, 1)
		UIStyle.ApplyFont(badge, 0)
	end)
	UIStyle.ApplyFont(title, 1)
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

function UIStyle.CreateButton(parent, width, height, text, variant, iconTexture, name)
	local btn = CreateFrame("Button", name, parent, BackdropTemplateMixin and "BackdropTemplate" or nil)
	if width then btn:SetWidth(width) end
	btn:SetHeight(height or 26)
	btn._iconTexture = iconTexture
	btn._rawText = text or ""

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
	label:SetWordWrap(false)
	UIStyle.ApplyFont(label, -1)
	label:SetText(UIStyle.FormatIconText(iconTexture, text))
	label:SetTextColor(s.txt[1], s.txt[2], s.txt[3])
	btn.Label = label

	function btn:SetFixedWidth(w)
		self._fixedWidth = w
		if w then
			self:SetWidth(w)
			label:SetWidth(math.max(10, w - 8))
		else
			label:SetWidth(0)
			self:UpdateSize()
		end
	end

	function btn:UpdateSize()
		UIStyle.ApplyFont(label, self._fontDelta or -1)
		if self._fixedWidth then
			self:SetWidth(self._fixedWidth)
			label:SetWidth(math.max(10, self._fixedWidth - 8))
		else
			label:SetWidth(0)
			local textW = label:GetStringWidth() or 0
			if textW > 0 then
				self:SetWidth(math.max(self._minWidth or 60, math.ceil(textW + 18)))
			elseif self._minWidth then
				self:SetWidth(self._minWidth)
			end
		end
		if not self._lockHeight then
			self:SetHeight(math.max(self._baseHeight or 26, UIStyle.GetFontSize() + 11))
		end
	end

	function btn:SetIcon(newIcon)
		self._iconTexture = newIcon
		label:SetText(UIStyle.FormatIconText(self._iconTexture, self._rawText))
		self:UpdateSize()
	end

	function btn:SetText(t)
		self._rawText = t or ""
		label:SetText(UIStyle.FormatIconText(self._iconTexture, self._rawText))
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
	dotBorder:SetSize(10, 10)
	dotBorder:SetPoint("LEFT", pill, "LEFT", 7, 0)
	dotBorder:SetColorTexture(0.05, 0.06, 0.08, 1)

	local dot = pill:CreateTexture(nil, "ARTWORK")
	dot:SetSize(8, 8)
	dot:SetPoint("CENTER", dotBorder, "CENTER", 0, 0)
	pill.Dot = dot

	local checkIcon = pill:CreateTexture(nil, "OVERLAY")
	checkIcon:SetSize(12, 12)
	checkIcon:SetPoint("CENTER", dotBorder, "CENTER", 0, 0)
	checkIcon:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
	pill.CheckIcon = checkIcon

	local label = pill:CreateFontString(name and (name .. "Text") or nil, "OVERLAY", "GameFontHighlight")
	label:SetPoint("LEFT", dotBorder, "RIGHT", 6, 0)
	label:SetPoint("RIGHT", pill, "RIGHT", -4, 0)
	label:SetJustifyH("LEFT")
	label:SetWordWrap(false)
	UIStyle.ApplyFont(label, -1)
	label:SetText(text or "")
	pill.Label = label

	local function updateVisual()
		UIStyle.ApplyFont(label, -1)
		if pill.active then
			UIStyle.ApplyBox(pill, 0.13, 0.23, 0.19, 1, 0.18, 0.68, 0.46, 1)
			dot:SetColorTexture(0.08, 0.35, 0.22, 1)
			checkIcon:Show()
			label:SetTextColor(0.92, 0.98, 0.95)
		else
			UIStyle.ApplyBox(pill, 0.12, 0.14, 0.18, 1, 0.24, 0.27, 0.34, 1)
			dot:SetColorTexture(0.18, 0.20, 0.25, 1)
			checkIcon:Hide()
			label:SetTextColor(0.56, 0.60, 0.68)
		end
		if not pill._fixedWidth then
			label:ClearAllPoints()
			label:SetPoint("LEFT", dotBorder, "RIGHT", 6, 0)
			local w = math.max((label:GetStringWidth() or 54) + 28, 64)
			pill:SetWidth(w)
		else
			label:ClearAllPoints()
			label:SetPoint("LEFT", dotBorder, "RIGHT", 6, 0)
			label:SetPoint("RIGHT", pill, "RIGHT", -4, 0)
		end
	end

	function pill:SetFixedWidth(w)
		self._fixedWidth = w
		if w then
			self:SetWidth(w)
		end
		updateVisual()
	end

	function pill:GetNaturalWidth()
		UIStyle.ApplyFont(label, -1)
		return math.ceil((label:GetStringWidth() or 50) + 26)
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

	UIStyle.RegisterFontListener(function()
		updateVisual()
	end)

	updateVisual()
	return pill
end

function UIStyle.CreateCheckBox(parent, text, globalName, isDanger)
	local cb = CreateFrame("CheckButton", globalName, parent, BackdropTemplateMixin and "BackdropTemplate" or nil)
	cb:SetSize(18, 18)

	local box = CreateFrame("Frame", nil, cb, BackdropTemplateMixin and "BackdropTemplate" or nil)
	box:SetSize(16, 16)
	box:SetPoint("LEFT", cb, "LEFT", 0, 0)
	UIStyle.ApplyBox(box, 0.06, 0.07, 0.10, 1, 0.28, 0.32, 0.42, 1)
	cb.Box = box

	local checkTex = box:CreateTexture(nil, "OVERLAY")
	checkTex:SetSize(14, 14)
	checkTex:SetPoint("CENTER", box, "CENTER", 0, 0)
	if isDanger then
		checkTex:SetTexture("Interface\\Buttons\\UI-CheckBox-SwordCheck")
	else
		checkTex:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
	end
	checkTex:Hide()
	cb.CheckTex = checkTex

	local label = cb:CreateFontString(globalName and (globalName .. "Text") or nil, "OVERLAY", "GameFontNormal")
	label:SetPoint("LEFT", box, "RIGHT", 6, 0)
	label:SetJustifyH("LEFT")
	label:SetWordWrap(false)
	UIStyle.ApplyFont(label, -1)
	label:SetText(text or "")
	if isDanger then
		label:SetTextColor(0.95, 0.35, 0.35)
	else
		label:SetTextColor(0.90, 0.82, 0.35)
	end
	cb.Text = label
	cb.text = label

	local function syncVisual(self)
		local checked = self:GetChecked()
		local enabled = self:IsEnabled()
		if checked then
			checkTex:Show()
			if isDanger then
				UIStyle.ApplyBox(box, 0.26, 0.10, 0.12, 1, 0.80, 0.28, 0.30, 1)
			else
				UIStyle.ApplyBox(box, 0.12, 0.22, 0.18, 1, 0.82, 0.68, 0.20, 1)
			end
		else
			checkTex:Hide()
			UIStyle.ApplyBox(box, 0.06, 0.07, 0.10, 1, 0.28, 0.32, 0.42, 1)
		end
		if not enabled then
			checkTex:SetDesaturated(true)
			box:SetAlpha(0.5)
		else
			checkTex:SetDesaturated(false)
			box:SetAlpha(1.0)
		end
		local w = 22 + math.ceil(label:GetStringWidth() or 40)
		cb:SetHitRectInsets(0, -math.max(10, w - 18), -2, -2)
	end

	hooksecurefunc(cb, "SetChecked", syncVisual)
	hooksecurefunc(cb, "Enable", syncVisual)
	hooksecurefunc(cb, "Disable", syncVisual)
	cb:HookScript("OnClick", syncVisual)
	cb:HookScript("OnEnter", function(self)
		if self:IsEnabled() then
			box:SetBackdropBorderColor(0.95, 0.80, 0.28, 1)
		end
	end)
	cb:HookScript("OnLeave", function(self)
		syncVisual(self)
	end)

	UIStyle.RegisterFontListener(function()
		UIStyle.ApplyFont(label, -1)
		syncVisual(cb)
	end)

	syncVisual(cb)
	return cb
end

function UIStyle.StyleScrollBar(scrollFrame)
	if not scrollFrame then return end
	local name = scrollFrame:GetName()
	local scrollBar = scrollFrame.ScrollBar or (name and _G[name .. "ScrollBar"])
	if not scrollBar then return end

	local upBtn = scrollBar.ScrollUpButton or (name and _G[name .. "ScrollBarScrollUpButton"])
	local downBtn = scrollBar.ScrollDownButton or (name and _G[name .. "ScrollBarScrollDownButton"])
	local thumb = scrollBar.ThumbTexture or (scrollBar.GetThumbTexture and scrollBar:GetThumbTexture()) or (name and _G[name .. "ScrollBarThumbTexture"])

	-- Hide legacy ornate scroll bar artwork
	for _, region in ipairs({ scrollBar:GetRegions() }) do
		if region and region:GetObjectType() == "Texture" and region ~= thumb then
			region:SetAlpha(0)
		end
	end
	if name then
		for _, suffix in ipairs({ "Track", "Top", "Middle", "Bottom", "BG" }) do
			local tex = _G[name .. "ScrollBar" .. suffix] or _G[name .. suffix]
			if tex and tex.SetAlpha then tex:SetAlpha(0) end
		end
	end

	if not scrollBar._fizTrack then
		local track = CreateFrame("Frame", nil, scrollBar, BackdropTemplateMixin and "BackdropTemplate" or nil)
		track:SetPoint("TOPLEFT", scrollBar, "TOPLEFT", 2, 0)
		track:SetPoint("BOTTOMRIGHT", scrollBar, "BOTTOMRIGHT", -2, 0)
		track:SetFrameLevel(math.max(1, scrollBar:GetFrameLevel() - 1))
		UIStyle.ApplyBox(track, 0.05, 0.06, 0.08, 0.90, 0.18, 0.21, 0.27, 1)
		scrollBar._fizTrack = track
	end

	if upBtn then
		upBtn:SetSize(14, 14)
		UIStyle.ApplyBox(upBtn, 0.14, 0.16, 0.22, 1, 0.26, 0.30, 0.38, 1)
	end
	if downBtn then
		downBtn:SetSize(14, 14)
		UIStyle.ApplyBox(downBtn, 0.14, 0.16, 0.22, 1, 0.26, 0.30, 0.38, 1)
	end

	if thumb then
		thumb:SetTexture(WHITE_TEX)
		thumb:SetVertexColor(0.78, 0.63, 0.16, 0.85)
		thumb:SetSize(10, 28)
	end
end

function UIStyle.CreateEditBox(parent, width, height, placeholderText, name)
	local box = CreateFrame("EditBox", name, parent, BackdropTemplateMixin and "BackdropTemplate" or nil)
	if width then box:SetWidth(width) end
	box:SetHeight(height or 26)
	box:SetAutoFocus(false)
	box:ClearFocus()
	box:SetMultiLine(false)
	box:SetTextInsets(8, 22, 4, 4)
	box:SetFontObject("GameFontHighlight")
	UIStyle.ApplyFont(box, -1)
	UIStyle.ApplyBox(box, 0.06, 0.07, 0.09, 1, 0.24, 0.27, 0.35, 1)

	local placeholder = box:CreateFontString(nil, "OVERLAY", "GameFontDisable")
	placeholder:SetPoint("LEFT", box, "LEFT", 8, 0)
	placeholder:SetPoint("RIGHT", box, "RIGHT", -22, 0)
	placeholder:SetJustifyH("LEFT")
	placeholder:SetWordWrap(false)
	UIStyle.ApplyFont(placeholder, -1)
	placeholder:SetText(placeholderText or "")
	placeholder:SetTextColor(0.48, 0.53, 0.62)
	box.Placeholder = placeholder

	local clearBtn = CreateFrame("Button", nil, box)
	clearBtn:SetSize(16, 16)
	clearBtn:SetPoint("RIGHT", box, "RIGHT", -4, 0)
	local clearIcon = clearBtn:CreateTexture(nil, "OVERLAY")
	clearIcon:SetSize(12, 12)
	clearIcon:SetPoint("CENTER", 0, 0)
	clearIcon:SetTexture("Interface\\Buttons\\UI-StopButton")
	clearIcon:SetVertexColor(0.60, 0.65, 0.72, 1)
	clearBtn:Hide()
	clearBtn:SetScript("OnEnter", function() clearIcon:SetVertexColor(1, 0.35, 0.35, 1) end)
	clearBtn:SetScript("OnLeave", function() clearIcon:SetVertexColor(0.60, 0.65, 0.72, 1) end)
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

	UIStyle.RegisterFontListener(function()
		UIStyle.ApplyFont(box, -1)
		UIStyle.ApplyFont(placeholder, -1)
	end)

	syncPlaceholder()
	return box
end
