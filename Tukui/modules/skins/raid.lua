local T, C, L, G = unpack(select(2, ...))

local function LoadSkin()
	local groups = {
		"RaidGroup1",
		"RaidGroup2",
		"RaidGroup3",
		"RaidGroup4",
		"RaidGroup5",
		"RaidGroup6",
		"RaidGroup7",
		"RaidGroup8",
	}

	for _, object in pairs(groups) do
		_G[object]:StripTextures()
	end
	
	for i=1,8 do
		for j=1,5 do
			_G["RaidGroup"..i.."Slot"..j]:StripTextures()
		end
	end
	
	for i=1,40 do
		_G["RaidGroupButton"..i]:StripTextures()
		_G["RaidGroupButton"..i]:SetTemplate("Default")
		_G["RaidGroupButton"..i]:SetBackdropBorderColor(0, 0, 0, 0)
	end
end

T.SkinFuncs["Blizzard_RaidUI"] = LoadSkin