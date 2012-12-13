--[[
Sifter.lua
Author: Michael Joseph Murray aka Lyte of Lothar(US)
Please see license.txt for details.
$Revision: 52 $
$Date: 2012-10-04 09:03:06 -0500 (Thu, 04 Oct 2012) $
@project-version@
contact: codemaster2010 AT gmail DOT com

Copyright (c) 2007-2012 Michael J. Murray aka Lyte of Lothar(US)
All rights reserved unless otherwise explicitly stated.
]]

--upvalue some often used stuff
local strformat = string.format
local strfind = string.find
local strsplit = strsplit
local tconcat = table.concat

--localization
local L = {}
local LOCALE = GetLocale()

if LOCALE == "esES" then
--@localization(locale="esES", format="lua_additive_table", handle-unlocalized="english", table-name="\tL")@
elseif LOCALE == "esMX" then
--@localization(locale="esMX", format="lua_additive_table", handle-unlocalized="english", table-name="\tL")@
elseif LOCALE == "deDE" then
--@localization(locale="deDE", format="lua_additive_table", handle-unlocalized="english", table-name="\tL")@
elseif LOCALE == "ruRU" then
--@localization(locale="ruRU", format="lua_additive_table", handle-unlocalized="english", table-name="\tL")@
elseif LOCALE == "frFR" then
--@localization(locale="frFR", format="lua_additive_table", handle-unlocalized="english", table-name="\tL")@
elseif LOCALE == "koKR" then
--@localization(locale="koKR", format="lua_additive_table", handle-unlocalized="english", table-name="\tL")@
elseif LOCALE == "zhCN" then
--@localization(locale="zhCN", format="lua_additive_table", handle-unlocalized="english", table-name="\tL")@
elseif LOCALE == "zhTW" then
--@localization(locale="zhTW", format="lua_additive_table", handle-unlocalized="english", table-name="\tL")@
elseif LOCALE == "ptBR" then
--@localization(locale="ptBR", format="lua_additive_table", handle-unlocalized="english", table-name="\tL")@
elseif LOCALE == "itIT" then
--@localization(locale="itIT", format="lua_additive_table", handle-unlocalized="english", table-name="\tL")@
else
--@localization(locale="enUS", format="lua_additive_table", handle-unlocalized="english", table-name="\tL")@
end

--tables relating products to sources and vice-versa
--ore to gems listing
--gems are listed in drop rate order and comma deliminated
local products = {
	--copper ore = malachite, tigerseye, shadowgem
	["2770"] = "774,818,1210",
	--tin ore = moss agate, lesser moonstone, shadowgem, citrine,  jade, aquamarine
	["2771"] = "1206,1705,1210,3864,1529,7909",
	--iron ore = jade, lesser moonstone, citrine, aquamarine, star ruby
	["2772"] = "1529,1705,3864,7909,7910",
	-- mithril ore = star ruby, aquamarine, citrine, blue sapphire, large opal, azerothian diamond, huge emerald
	["3858"] = "7910,7909,3864,12361,12799,12800,12364",
	--thorium ore = star ruby, large opal, huge emerald, azerothian diamond, blue sapphire
	["10620"] = "7910,12799,12364,12800,12361",
	--fel iron ore = flame spessarite, deep peridot, golden draenite, blood garnet, shadow draenite, azure moonstone, noble topaz, living ruby, talasite, star of elune, dawnstone, nightseye
	["23424"] = "21929,23079,23112,23077,23107,23117,23439,23436,23437,23438,23440,23441",
	--adamantite ore = deep peridot, flame spessarite, golden draenite, blood garnet, shadow draenite, azure moonstone, talasite, noble topaz, dawnstone, living ruby, star of elune, nightseye
	["23425"] = "23079,21929,23112,23077,23107,23117,23437,23439,23440,23436,23438,23441",
	--cobalt ore = dark jade, shadow crystal, huge citrine, chalcedony, sun crystal, bloodstone, scarlet ruby, forest emerald, twilight opal, monarch topaz, sky sapphire, autumn's glow
	["36909"] = "36932,36926,36929,36920,36923,36917,36918,36933,36927,36930,36924,36921",
	--saronite ore = dark jade, shadow crystal, huge citrine, sun crystal, chalcedony, bloodstone, monarch topaz, scarlet ruby, sky sapphire, forest emerald, autumn's glow, twilight opal
	["36912"] = "36932,36926,36929,36923,36920,36917,36930,36918,36924,36933,36921,36927",
	--Patch 3.2.0
	--titanium ore = dark jade, shadow crystal, huge citrine, sun crystal, chalcedony, bloodstone, king's amber, dreadstone, magestic zircon, cardinal ruby, eye of zul, ametrine, monarch topaz, scarlet ruby, sky sapphire, forest emerald, autumn's glow, twilight opal
	["36910"] = "36932,36926,36929,36923,36920,36917,36922,36928,36925,36919,36934,36931,36930,36918,36924,36933,36921,36927",
	--Obsidium Ore = Alicite, Nightstone, Zephyrite, Jasper, Hessonite, Carnelian, Ocean Sapphire, Amberjewel, Ember Topaz, Inferno Ruby, Dream Emerald, Demonseye
	["53038"] = "52179,52180,52178,52182,52181,52177,52191,52195,52193,52190,52192,52194",
	--Elementium Ore = Alicite, Nightstone, Zephyrite, Jasper, Hessonite, Carnelian, Ocean Sapphire, Amberjewel, Ember Topaz, Inferno Ruby, Dream Emerald, Demonseye
	["52185"] = "52179,52180,52178,52182,52181,52177,52191,52195,52193,52190,52192,52194",
	--Pyrite Ore = Alicite, Nightstone, Zephyrite, Jasper, Hessonite, Carnelian, Ocean Sapphire, Amberjewel, Ember Topaz, Inferno Ruby, Dream Emerald, Demonseye
	["52183"] = "52179,52180,52178,52182,52181,52177,52191,52195,52193,52190,52192,52194",
	--White Trillium Ore
	["72103"] = "90407,76130,76135,76136,76133,76137,76134,76131,76142,76141,76140,76139,76138",
	--Black Trillium Ore
	["72094"] = "90407,76130,76135,76136,76133,76137,76134,76131,76142,76141,76140,76139,76138",
	--Kyparite
	["72093"] = "90407,76130,76135,76136,76133,76137,76134,76131,76142,76141,76140,76139,76138",
	--Ghost Iron Ore
	["72092"] = "90407,76130,76135,76136,76133,76137,76134,76131,76142,76141,76140,76139,76138",
}

--gem to ore listing
--ores are listed in drop chance order and comma deliminated when needed
local sources = {
	["774"] = "2770", --malachite from copper ore
	["818"] = "2770", --tigerseye from copper ore
	["1210"] = "2770,2771", --shadowgem from copper, tin ore
	["1206"] = "2771", --moss agate from tin ore
	["1529"] = "2772,2771", --jade from iron, tin ore
	["1705"] = "2771,2772", -- lesser moonstone from tin, iron ore
	["3864"] = "2772,3858,2771", --citrine from iron, mithril, tin ore
	["7909"] = "3858,2771,2772", --aquamarine from mithril, tin, iron ore
	["7910"] = "3858,10620,2772", --star ruby from mithril, thorium, iron ore
	["12799"] = "10620,3858", --large opal from thorium, mithril ore
	["12364"] = "10620,3858", --huge emerald from thorium, mithril ore
	["12800"] = "10620,3858", --azerothian diamond from thorium, mithril ore
	["12361"] = "10620,3858", --blue sapphrie from thorium, mithril ore
	["23079"] = "23424,23425", --deep peridot from fel iron, adamantite ore
	["21929"] = "23424,23425", --flame spessarite from fel iron, adamantite ore
	["23112"] = "23424,23425", --golden draenite from fel iron, adamantite ore
	["23077"] = "23424,23425", --blood garnet from fel iron, adamantite ore
	["23107"] = "23424,23425", --shadow draenite from fel iron, adamantite ore
	["23117"] = "23424,23425", --azure moonstone from fel iron, adamantite ore
	["23437"] = "23425,23424", --talasite from adamantite, fel iron ore
	["23439"] = "23425,23424", --noble topaz from adamantite, fel iron ore
	["23440"] = "23425,23424", --dawnstone from adamantite, fel iron ore
	["23436"] = "23425,23424", --living ruby from adamantite, fel iron ore
	["23438"] = "23425,23424", --star of elune from adamantite, fel iron ore
	["23441"] = "23425,23424", --nightseye from adamantite, fel iron ore
	["36932"] = "36909,36912,36910", --dark jade from titanium, cobalt, saronite ore
	["36926"] = "36909,36912,36910", --shadow crystal from titanium, cobalt, saronite ore
	["36929"] = "36909,36912,36910", --huge citrine from titanium, cobalt, saronite ore
	["36923"] = "36909,36912,36910", --sun crystal from titanium, cobalt, saronite ore
	["36920"] = "36909,36912,36910", --chalcedony from titanium, saronite, cobalt ore
	["36917"] = "36909,36912,36910", -- bloodstone from titanium, saronite, cobalt ore
	["36930"] = "36912,36909,36910", --monarch topaz from titanium, saronite, cobalt ore
	["36918"] = "36912,36909,36910", --scarlet ruby from titanium, saronite, cobalt ore
	["36924"] = "36912,36909,36910", --sky sapphire from titanium, saronite, cobalt ore
	["36933"] = "36912,36909,36910", --forest emerald from titanium, saronite, cobalt ore
	["36921"] = "36912,36909,36910", --autumn's glow from titanium, saronite, cobalt ore
	["36927"] = "36912,36909,36910", --twilight opal from titanium, saronite, cobalt ore
	--Patch 3.2.0
	["36922"] = "36910", --king's amber from titanium ore
	["36928"] = "36910", --dreadstone from titanium ore
	["36925"] = "36910", --magestic zircon from titanium ore
	["36919"] = "36910", --cardinal ruby from titanium ore
	["36934"] = "36910", --eye of zul from titanium ore
	["36931"] = "36910", --ametrine from titanium ore
	--Cataclysm
	["52179"] = "53038,52185,52183", --alicite from obsidium, elementium ore, pyrite ore
	["52180"] = "53038,52185,52183", --nightstone from obsidium, elementium ore, pyrite ore
	["52178"] = "53038,52185,52183", --zephyrite from obsidium, elementium ore, pyrite ore
	["52182"] = "53038,52185,52183", --jasper from obsidium, elementium ore, pyrite ore
	["52181"] = "53038,52185,52183", --hessonite from obsidium, elementium ore, pyrite ore
	["52177"] = "53038,52185,52183", --carnelian from obsidium, elementium, ore, pyrite ore
	["52191"] = "53038,52185,52183", --ocean sapphire from obsidium, elementium ore, pyrite ore
	["52195"] = "53038,52185,52183", --amber jewel from obsidium, elementium ore, pyrite ore
	["52193"] = "53038,52185,52183", --ember topaz from obsidium, elementium ore, pyrite ore
	["52190"] = "53038,52185,52183", --inferno ruby from obsidium, elementium ore, pyrite ore
	["52192"] = "53038,52185,52183", --dream emerald from obsidium, elementium ore, pyrite ore
	["52194"] = "53038,52185,52183", --demonseye from obsidium, elementium ore, pyrite ore
	--Cata Epic Gems (Patch 4.3)
	["71807"] = "78892,78890", --Deepholm Iolite from Perfect Geode, Crystalline Geode
	["71810"] = "78892,78890", --Elven Peridot from Perfect Geode, Crystalline Geode
	["71806"] = "78892,78890", --Lightstone from Perfect Geode, Crystalline Geode
	["71805"] = "78891,78892,78890", --Queen's Garnet from Elementium-Coated Geode, Perfect Geode, Crystalline Geode
	["71808"] = "78891,78892,78890", --Lava Coral from Elementium-Coated Geode, Perfect Geode, Crystalline Geode
	["71809"] = "78891,78892,78890", --Shadow Spinel from Elementium-Coated Geode, Perfect Geode, Crystalline Geode
	--MoP Gems
	["76130"] = "72092,72093,72094,72103",
	["76135"] = "72092,72093,72094,72103",
	["76136"] = "72092,72093,72094,72103",
	["76133"] = "72092,72093,72094,72103",
	["76137"] = "72092,72093,72094,72103",
	["76134"] = "72092,72093,72094,72103",
	["76131"] = "72094,72103,72092",
	["76142"] = "72094,72103,72092",
	["76141"] = "72094,72103,72092",
	["76140"] = "72094,72103,72092",
	["76139"] = "72094,72103,72092",
	["76138"] = "72094,72103,72092",
	["90407"] = "72092,72103,72094,72093", --Sparkling Shard (combine 10 to produce JC only gem)
}

local strtable = {}
local function srcHelper(...)
	local name, link, rarity, color
	for i = 1, select("#", ...) do
		local current = select(i, ...)
		if GetItemInfo(current) then --make sure we get a return, otherwise warn out of date cache
			--get the name and rarity for color
			name, link, rarity = GetItemInfo(current)
			color = ITEM_QUALITY_COLORS[rarity].hex
			
			--save the colored name in the table
			strtable[i] = color .. name .. "|r"
		else
			wipe(strtable)
			return L["Updating Item Cache"]
		end
	end
	
	return tconcat(strtable, ", ")
end

local function prdctHelper(...)
	local name, link, rarity, color
	for i = 1, select("#", ...) do
		local current = select(i, ...)
		if GetItemInfo(current) then
			--get the name and rarity for color
			name, link, rarity = GetItemInfo(current)
			color = ITEM_QUALITY_COLORS[rarity].hex
			
			--if the last item then nothing trailing
			--if divisible by 3 then appent a newline char
			--otherwise append a comma and space
			if i == select("#", ...) then
				strtable[i] = color .. name .. "|r"
			elseif i % 3 == 0 then
				strtable[i] = color .. name .. "|r\n"
			else
				strtable[i] = color .. name .. "|r, "
			end
		else
			wipe(strtable)
			return L["Updating Item Cache"]
		end
	end
	
	return tconcat(strtable, "")
end

local getProspectingInfo = setmetatable({}, {
	__index = function(t, k)
		local src = sources[k]
		local prdct = products[k]
		
		if src then
			t[k] = srcHelper(strsplit(",", src))
		else
			--some product lists are 12 items long, far too long for a single line
			--split it up with some \n tokens to make a nicer tooltip
			t[k] = prdctHelper(strsplit(",", prdct))
		end
		
		wipe(strtable)
		return t[k]
	end
})

local _, ns = ...
function ns:ClearCachedTooltips()
	for k in pairs(getProspectingInfo) do
		getProspectingInfo[k] = nil
	end
end

local function AddProspectingInfo(frame, itemLink)
	local _, _, itemString = strfind(itemLink, "^|c%x+|H(.+)|h%[.+%]")
	if itemString then
		local _, itemID = strsplit(":", itemString)
		if itemID then
			if products[itemID] or sources[itemID] then
				frame:AddLine(getProspectingInfo[itemID])
			end
		end
	end
	
	frame:Show()
end

local function HookIt(tt)
	tt:HookScript("OnTooltipSetItem", function(self, ...)
		local itemLink = select(2, self:GetItem())
		if itemLink and GetItemInfo(itemLink) then
			AddProspectingInfo(self, itemLink)
		end
	end)
end

HookIt(GameTooltip)
HookIt(ItemRefTooltip)
