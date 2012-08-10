local T, C, L, G = unpack(select(2, ...))
-- MOVE ME TO SKIN


-- Skin all DropDownList[i]
local function SkinDropDownList(level, index)
	for i = 1, UIDROPDOWNMENU_MAXLEVELS do
		local menubackdrop = _G["DropDownList"..i.."MenuBackdrop"]
		local backdrop = _G["DropDownList"..i.."Backdrop"]
		if not backdrop.isSkinned then
			menubackdrop:SetTemplate("Default")
			backdrop:SetTemplate("Default")
			backdrop.isSkinned = true
		end
	end
end
hooksecurefunc("UIDropDownMenu_CreateFrames", SkinDropDownList)