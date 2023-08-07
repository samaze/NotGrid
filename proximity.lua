local L = AceLibrary("AceLocale-2.2"):new("NotGrid")

local spells40yd = { -- Macros are forced to have text associated with them so we can safely just check the textures as well as check against the presence of text. No need for Gratuity or Babble overhead. Though if they have an item in their bar that matches the texture then GG haha
	["PALADIN"] = {"Interface\\Icons\\Spell_Holy_FlashHeal", "Interface\\Icons\\Spell_Holy_HolyBolt"},
	["PRIEST"] = {"Interface\\Icons\\Spell_Holy_FlashHeal", "Interface\\Icons\\Spell_Holy_LesserHeal", "Interface\\Icons\\Spell_Holy_Heal", "Interface\\Icons\\Spell_Holy_GreaterHeal", "Interface\\Icons\\Spell_Holy_Renew"},
	["DRUID"] = {"Interface\\Icons\\Spell_Nature_HealingTouch", "Interface\\Icons\\Spell_Nature_ResistNature", "Interface\\Icons\\Spell_Nature_Rejuvenation"},
	["SHAMAN"] = {"Interface\\Icons\\Spell_Nature_MagicImmunity", "Interface\\Icons\\Spell_Nature_HealingWaveLesser", "Interface\\Icons\\Spell_Nature_HealingWaveGreater"},
}

-- extracted from WorldMapArea dbc table  --  x is left/right, y is top/bottom  --  areaname correlates to GetMapInfo() api call
local MapSizes = {
	["Alterac"] = {x = 2800.0003, y = 1866.6667},
	["AlteracValley"] = {x = 4237.5, y = 2825},
	["Arathi"] = {x = 3600.0004, y = 2399.9997},
	["ArathiBasin"] = {x = 1756.2497, y = 1170.833},
	["Ashenvale"] = {x = 5766.667, y = 3843.7504},
	["Aszhara"] = {x = 5070.833, y = 3381.25},
	["Azeroth"] = {x = 35199.9, y = 23466.6},
	["Badlands"] = {x = 2487.5, y = 1658.334},
	["Barrens"] = {x = 10133.334, y = 6756.25},
	["BlastedLands"] = {x = 3350, y = 2233.33},
	["BurningSteppes"] = {x = 2929.1663, y = 1952.083},
	["Darkshore"] = {x = 6550, y = 4366.666},
	["Darnassis"] = {x = 1058.333, y = 705.733},
	["DeadwindPass"] = {x = 2499.9997, y = 1666.664},
	["Desolace"] = {x = 4495.833, y = 2997.9163},
	["DunMorogh"] = {x = 4925, y = 3283.334},
	["Durotar"] = {x = 5287.5, y = 3525},
	["Duskwood"] = {x = 2700.0003, y = 1800.004},
	["Dustwallow"] = {x = 5250.0001, y = 3500},
	["EasternPlaguelands"] = {x = 3870.833, y = 2581.25},
	["Elwynn"] = {x = 3470.834, y = 2314.587},
	["Felwood"] = {x = 5750, y = 3833.333},
	["Feralas"] = {x = 6950, y = 4633.333},
	["Hilsbrad"] = {x = 3200, y = 2133.333},
	["Hinterlands"] = {x = 3850, y = 2566.667},
	["Ironforge"] = {x = 790.6246, y = 527.605},
	["Kalimdor"] = {x = 36799.81, y = 24533.2},
	["LochModan"] = {x = 2758.333, y = 1839.583},
	["Moonglade"] = {x = 2308.333, y = 1539.583},
	["Mulgore"] = {x = 5137.5, y = 3425.0003},
	["Ogrimmar"] = {x = 1402.605, y = 935.416},
	["Redridge"] = {x = 2170.834, y = 1447.92},
	["SearingGorge"] = {x = 2231.2503, y = 1487.5},
	["Silithus"] = {x = 3483.334, y = 2322.916},
	["Silverpine"] = {x = 4200, y = 2800},
	["StonetalonMountains"] = {x = 4883.333, y = 3256.2503},
	["Stormwind"] = {x = 1344.27037, y = 896.354},
	["Stranglethorn"] = {x = 6381.25, y = 4254.17},
	["SwampOfSorrows"] = {x = 2293.75, y = 1529.167},
	["Tanaris"] = {x = 6900, y = 4600},
	["Teldrassil"] = {x = 5091.666, y = 3393.75},
	["ThousandNeedles"] = {x = 4399.9997, y = 2933.333},
	["ThunderBluff"] = {x = 1043.7499, y = 695.8331},
	["Tirisfal"] = {x = 4518.75, y = 3012.5001},
	["Undercity"] = {x = 959.375, y = 640.104},
	["UngoroCrater"] = {x = 3700.0003, y = 2466.666},
	["WarsongGulch"] = {x = 1145.8337, y = 764.5831},
	["WesternPlaguelands"] = {x = 4299.9997, y = 2866.667},
	["Westfall"] = {x = 3500.0003, y = 2333.33},
	["Wetlands"] = {x = 4135.4167, y = 2756.25},
	["Winterspring"] = {x = 7100.0003, y = 4733.333}
}



--------------------
-- UNIT_PROXIMITY --
--------------------
function NotGrid:UNIT_PROXIMITY()
	for key,f in self.UnitFrames do
		local unitid = f.unit
		if UnitExists(unitid) and f:IsVisible() then
			local response = self:CheckProximity(unitid)
			if response == 1 then
				self:RangeToggle(f, 1)
			elseif response == 2 then
				self:RangeToggle(f, 2)
			else
				self:RangeToggle(f, 3)
			end
		end
	end
end


function NotGrid:RangeToggle(f, condition)
	if condition == 1 then
		f.lastseen = GetTime() -- this of course makes it sort of wrong when players are switching up Unitids on rapid join/leave of group
		f:SetAlpha(1)
	elseif condition == 2 then
		f:SetAlpha(self.o.ooralpha)
	elseif (f.lastseen and (GetTime() - f.lastseen) > self.o.proximityleeway) then -- if not confirmed to be out of range, toggle him as out of range only after the proximity leeway time
		f:SetAlpha(self.o.ooralpha)
	end
end

----------------
-- Main Check --
----------------

function NotGrid:CheckProximity(unitid) -- return 1=confirmed_true, 2=confirmed_false, and no_response/false/nil means we can't confirm either way
	if UnitExists(unitid) and UnitIsVisible(unitid) then
		--check these scenarios first even if the player has check with map toggled
		if UnitIsUnit(unitid, "player") then --unitisplayer, 0 yards
			return 1
		elseif CheckInteractDistance(unitid, 3) then -- duel range, 10 yards
			return 1
		elseif CheckInteractDistance(unitid, 2) then -- trade and inspect range (1 is the same as 2 with patch 1.12), 11.11 yards
			return 1
		elseif CheckInteractDistance(unitid, 4) then -- follow range, 28 yards
			return 1
		elseif SpellIsTargeting() then
			if SpellCanTargetUnit(unitid) then
				return 1
			else
				return 2
			end
		elseif UnitIsUnit(unitid, "target") and self.ProximityVars.spell40slot then
			if IsActionInRange(self.ProximityVars.spell40slot) == 1 then -- IsActionInRange returns the string "0" if not in range which is a boolean true, so I check for 1 instead
				return 1
			else
				return 2
			end
		end
		--if checking with map is toggled, AND the player is outside, AND we haven't returned an INRANGE confirmation yet, then start looking at the map for range
		if self.o.usemapdistances and (self.ProximityVars.instance == "none" or self.ProximityVars.instance == "pvp") and not WorldMapFrame:IsVisible() then
			local distance = self:GetWorldDistance(unitid)
			if distance and distance <= 40 then
				return 1
			else
				return 2
			end
		end
	end
end

-------------------------
-- Map Proximity Stuff --
-------------------------

function NotGrid:GetWorldDistance(unitid) -- Thanks to Rhena/Renew/Astrolabe
	local px, py, ux, uy, distance
	local v = self.ProximityVars
	SetMapToCurrentZone()
	px, py = GetPlayerMapPosition("player") -- gets position data in units of percentage of map size
	ux, uy = GetPlayerMapPosition(unitid)
	if v.mapFileName and MapSizes[v.mapFileName] then
		local xdelta = (px - ux)*MapSizes[v.mapFileName].x -- (px-ux) gives distance in percentage units, multiply by mapsize to convert to wow units.
		local ydelta = (py - uy)*MapSizes[v.mapFileName].y
		distance = sqrt(xdelta^2 + ydelta^2)*(40/42.9) -- Then use maths distance formula for two points on a grid. include a modifiier of (40/42.9) because there seems to be 40 spell yards per 42.9 wow gps units.
	end
	return distance
end

function NotGrid:UpdateProximityMapVars()
	local v = self.ProximityVars
	SetMapToCurrentZone()
	v.mapFileName, _, _ = GetMapInfo()
	_, v.instance = IsInInstance()
	--[[ -- these become moot with the change to using mapFileName
	v.Continent = GetCurrentMapContinent()
	v.Zone = GetCurrentMapZone()
	v.ZoneName = GetZoneText()
	if v.ZoneName == "Warsong Gulch" or v.ZoneName == "Arathi Basin" or v.ZoneName == "Alterac Valley" then
		v.Zone = v.ZoneName
	end
	]]
end

-------------------------
-- Combat Event Handle -- TODO: This doesn't recognize events such as "player suffers X damage from creatures spell" is that because I found it to be erronous previously? Or an oversight?
-------------------------

function NotGrid:CombatEventHandle()
	local combatlogrange = tonumber(GetCVar("CombatLogRangeFriendlyPlayers")) -- I'm going to inappropriately assume that if he's set this as non-default then he's also set all the others as the same(we can correct this easily in future versions)
	if combatlogrange <= 40 then
		local v = self.ProximityVars
		local capturestring = L.CombatEvents[event] -- "event" is the name of the event sent by the wow api
		local _, _, name = string.find(arg1, capturestring) -- arg1 gets sent by any combat event as the string you see in combat log, this will grab the name out of it using defined capture strings in localization.lua
		
		for _,f in self.UnitFrames do --look through unitframes for f.name?
			if (name and f.name) and (name == f.name) then
				self:RangeToggle(f, 1)
			end
		end
	end
end

-------------------------
-- 40 Yard Spell Stuff --
-------------------------

function NotGrid:GetFortyYardSpell()
	local v = self.ProximityVars
	local _, class = UnitClass("player")
	if spells40yd[class] then -- if player is of a class that has data in the table
		local textures = spells40yd[class]
		local indices = getn(spells40yd[class])
		for i = 1, 120 do -- for all possible action bar slots
			local ActionTexture = GetActionTexture(i)
			for j=1,indices do -- for as many textures are in the class table
				if ActionTexture == textures[j] and not GetActionText(i) then -- if we match a texture and there is no text with it(macros are forced to have text)
					v.spell40slot = i -- set it as our variable and return out of the function
					return
				end
			end
		end
	end
	v.spell40slot = nil -- set it as nil if it never found anything
end


---------------------
--  Clique Helper  --
---------------------

function NotGrid:SpellCanTarget()
	for _,f in self.UnitFrames do
		local unitid = f.unit
		if UnitExists(unitid) and UnitIsVisible(unitid) and SpellIsTargeting() then -- mimick the checks of the main checker and then pass results directly to RangeToggle
			if SpellCanTargetUnit(unitid) then
				self:RangeToggle(f, 1)
			else
				self:RangeToggle(f, 2)
			end
		end
	end
end

--[[ Although I've done away with NotProximityLib I still want these notes to be around.
------------------------------------------------
-- Notes About Combat Log Messages
------------------------------------------------
None of the below can be used for accurate proximity assumptions. 
Here's why: Combat events are limited to the likes of "(%a+) hits". There's no "(%a+) gets hit". What does this mean? Lets look at a Ragnaros encounter for an example.

Player -- 0 yards
Ragnaros -- 40 yards
RaidMember -- 80 yards

When Ragnaros hits RaidMember, Player will get the combat message "Ragnaros hits RaidMember". That's great, our assumption is now that because we see "Ragnaros hits RaidMember" that we can capture the first name of such a string and determine that Ragnaros is in range. However, when RaidMember hits Ragnaros, Player will get the event "RaidMember hits Ragnaros". Because RaidMember hit a unit that was within 40 yards of Player, Player still gets the message "RaidMember hits Ragnaros", even though the RaidMember is 80 yards away.

And we're not getting any special arguments(in 1.12) sent along with these events telling us who is responsible for triggering said combat message. All we know is we got a CREATURE_HITS_PARTY_MEMBER and PARTY_MEMBER_HITS_CREATURE. There's no way to parse out whether one is further away than the other. Almost all combat messages are made useless by this fact.

These are all deprecated:
CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS = ".+ c?[rh]its (%a+) for .+",
CHAT_MSG_COMBAT_CREATURE_VS_PARTY_HITS = ".+ c?[rh]its (%a+) for .+",
CHAT_MSG_COMBAT_CREATURE_VS_CREATURE_HITS = ".+ c?[rh]its (%a+) for .+",
CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE = {".+'s .+ c?[rh]its (%a+) for .+", ".+'s .+ was resisted by (%a+)%."},
CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE = {".+'s .+ c?[rh]its (%a+) for .+", ".+'s .+ was resisted by (%a+)%."},
CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE = {".+'s .+ c?[rh]its (%a+) for .+", ".+'s .+ was resisted by (%a+)%."},

CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE = ".+'s .+ c?[rh]its (%a+) for .+",
CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE = "(%a+) is afflicted by .+"

CHAT_MSG_COMBAT_PARTY_HITS = "(%a+) c?[rh]its .+",
CHAT_MSG_COMBAT_FRIENDLYPLAYER_HITS = "(%a+) c?[rh]its .+",

CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE = "%a+ suffers %d+ %a+ damage from (%a+)'s .+" -- For this I could still read it for "(%a+) is Afflicted by" but creatures aren't in the RosterLib so its pointless.

------------------------------------------------
-- Notes About IsActionInRange()
------------------------------------------------
So the premise was we'd recognize that any healing class will have a 40yd healing spell right from the start. We could then use this spell as a default check for 40 yards for the targetted unit (its how the action bar determines whether to color them red or not) but IsActionInRange only accepts the literal button as value, not the spellname. So there's a possibility we could itterate through a player's actionbars and stop at the first 40 yard range spell we see and use that as the default, and listen for action bar changes(if thats a thing) and modify if needed. But that seems excessive, and I think we'd need to make a full table listing every 40 yard range spell to check against.

Level 1 Spells:
pala: Holy Light (40 yd)
prie: Lesser Heal(40 yd)
drui: Healing Touch(40 yd)
sham: Healing Wave(40 yd)

IsSpellInRange() -- TBC
IsItemInRange() -- TBC
IsCurrentAction() -- Useless. If you're casting and a unit runs out of range it won't fail unit it reaches the end of cast.

------------------------------------------------
-- ISSUES/BUGS
------------------------------------------------
unitischarmed -- need to handle this and not set him out of range with certain conditions
]]
