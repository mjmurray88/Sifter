--[[
Sifter_Frame.lua
Author: Michael Joseph Murray aka Lyte of Lothar(US)
$Revision: 50 $
$Date: 2012-09-28 13:10:09 -0500 (Fri, 28 Sep 2012) $
@project-version@
contact: codemaster2010 AT gmail DOT com

Copyright (c) 2007-2012 Michael J. Murray aka Lyte of Lothar
All rights reserved unless otherwise explicitly stated.
]]

local _, ns = ...

local itemList = {
	"90407", --Sparkling Shard
	"72103", --White Trillium Ore
	"72094", --Black Trillium Ore
	"72093", --Kyparite
	"72092", --Ghost Iron Ore
	"76131", --Primordial Ruby
	"76142", --Sun's Radiance
	"76141", --Imperial Amethyst
	"76140", --Vermilion Onyx
	"76139", --Wild Jade
	"76138", --River's Heart
	"76130", --Tiger Opal
	"76135", --Roguestone
	"76136", --Pandarian Garnet
	"76133", --Lapis Lazuli
	"76137", --Alexandrite
	"76134", --Sunstone
	"78890", --Crystalline Geode
	"78892", --Perfect Geode
	"78891", --Elementium-Coated Geode
	"71807", --Deepholm Iolite
	"71810", --Elven Peridot
	"71806", --Lightstone
	"71805", --Queen's Garnet
	"71808", --Lava Coral
	"71809", --Shadow Spinel
	"53038", --obsidium ore
	"52185", --elementium ore
	"52183", --pyrite ore
	"52179", --alicite
	"52180", --nightstone
	"52178", --zephyrite
	"52182", --jasper
	"52181", --hessonite
	"52177", --carnelian
	"52191", --ocean sapphire
	"52195", --amberjewel
	"52193", --ember topaz
	"52190", --inferno ruby
	"52192", --dream emerald
	"52194", --demonseye
	"36909", --cobalt
	"36912", --saronite
	"36910", --titanium
	"36922", --king's amber
	"36928", --dreadstone
	"36925", --magestic zircon
	"36919", --cardinal ruby
	"36934", --eye of zul
	"36931", --ametrine
	"36930", --monarch topaz
	"36918", --scarlet ruby
	"36924", --sky sapphire
	"36933", --forest emerald
	"36921", --autumn's glow
	"36927", --twilight opal
	"36932", --dark jade
	"36926", --shadow crystal
	"36929", --huge citrine
	"36923", --sun crystal
	"36920", --chalcedony
	"36917", --bloodstone
	"23424", --fel iron
	"23425", --adamantite
	"23437", --talasite
	"23439", --noble topaz
	"23440", --dawnstone
	"23436", --living ruby
	"23438", --star of elune
	"23441", --nightseye
	"23079", --deep peridot
	"21929", --flame spessarite
	"23112", --golden draenite
	"23077", --blood garnet
	"23107", --shadow draenite
	"23117", --azure moonstone
	"10620", --thorium
	"12799", --large opal
	"12364", --huge emerald
	"12800", --azerothian diamond
	"12361", --blue sapphire
	"7910", --star ruby
	"3858", --mithril
	"3864", --citrine
	"7909", --aquamarine
	"2772", --iron
	"1529", --jade
	"1705", --lesser moonstone
	"2770", --copper
	"2771", --tin
	"774", --malachite
	"818", --tigerseye
	"1210", --shadowgem
	"1206", --moss agate
}

local frame = CreateFrame("FRAME")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
local tt = CreateFrame("GAMETOOLTIP", "SIFTER_TOOLTIP", UIParent, "GameTooltipTemplate")
tt:SetOwner(WorldFrame, 'ANCHOR_NONE')

local function serverQuery()
	for i, itemID in ipairs(itemList) do
		--make sure it's owned and hidden
		if not tt:IsOwned(WorldFrame) then
			tt:SetOwner(WorldFrame, 'ANCHOR_NONE')
		end
		
		--query the server for the item
		tt:SetHyperlink("item:"..itemID)
		
		--only run 6 queries at a time
		if i % 6 == 0 then
			coroutine.yield()
		end
	end
end

frame:SetScript("OnEvent", function(self, event)
	--only run this code once
	self:UnregisterEvent(event)
	
	--create the coroutine that performs the queries
	self.thread = coroutine.create(serverQuery)
	
	--periodically resume the coroutine until it finishes
	local lastUpdate = 0
	local throttle = 10
	self:SetScript("OnUpdate", function(self, elapsed)
		lastUpdate = lastUpdate + elapsed
		if lastUpdate >= throttle then
			lastUpdate = 0
			if coroutine.status(self.thread) ~= "dead" then
				coroutine.resume(self.thread)
			else
				self:Hide()
				tt:Hide()
				ns:ClearCachedTooltips()
			end
		end
	end)
	self:Show()
end)
