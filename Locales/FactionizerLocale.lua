--[[
	Factionizer - AceLocale-3.0 Bridge
	Author: gOOvER
	License: GNU General Public License v2.0 (GPL-2.0)
]]

local addonName, vars = ...
local AceLocale = LibStub("AceLocale-3.0")
local L = AceLocale:GetLocale("Factionizer", true)

vars.L = L

-- Expose keybindings to Blizzard Keybindings UI
BINDING_HEADER_FACTIONIZER = L["BINDING_HEADER_FACTIONIZER"]
BINDING_NAME_SHOWCONFIG = L["BINDING_NAME_SHOWCONFIG"]
BINDING_NAME_SHOWDETAILS = L["BINDING_NAME_SHOWDETAILS"]

-- Build standing levels lookup table
FIZ_TXT_STAND_LV = {
	[0] = L["STAND_LV_0"],
	[1] = L["STAND_LV_1"],
	[2] = L["STAND_LV_2"],
	[3] = L["STAND_LV_3"],
	[4] = L["STAND_LV_4"],
	[5] = L["STAND_LV_5"],
	[6] = L["STAND_LV_6"],
	[7] = L["STAND_LV_7"],
	[8] = L["STAND_LV_8"],
}

-- Build FIZ_TXT table backed by AceLocale-3.0 with nested elements.name / elements.tip support
local elementsName = setmetatable({}, {
	__index = function(_, k)
		return rawget(L, "ELEM_NAME_" .. tostring(k))
	end,
})

local elementsTip = setmetatable({}, {
	__index = function(_, k)
		return rawget(L, "ELEM_TIP_" .. tostring(k))
	end,
})

local elementsTable = {
	name = elementsName,
	tip = elementsTip,
}

FIZ_TXT = setmetatable({
	elements = elementsTable,
	StandLv = FIZ_TXT_STAND_LV,
}, {
	__index = function(_, k)
		return rawget(L, k)
	end,
})

