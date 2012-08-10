local T, C, L, G = unpack(select(2, ...)) 
if not C["actionbar"].enable == true then return end

local _G = _G
local media = C["media"]
local securehandler = CreateFrame("Frame", nil, nil, "SecureHandlerBaseTemplate")
local replace = string.gsub

function T.StyleActionBarButton(self)
	local name = self:GetName()
	
	--> fixing a taint issue while changing totem flyout button in combat.
	if name:match("MultiCast") then return end
	
	--> don't skin the boss encounter extra button to match texture (4.3 patch)
	--> http://www.tukui.org/storage/viewer.php?id=913811extrabar.jpg
	if name:match("ExtraActionButton") then return end
	
	local action = self.action
	local Button = self
	local Icon = _G[name.."Icon"]
	local Count = _G[name.."Count"]
	local Flash	 = _G[name.."Flash"]
	local HotKey = _G[name.."HotKey"]
	local Border  = _G[name.."Border"]
	local Btname = _G[name.."Name"]
	local normal  = _G[name.."NormalTexture"]
	local BtnBG = _G[name..'FloatingBG']
 
	Flash:SetTexture("")
	Button:SetNormalTexture("")
 
	if Border then
		Border:Hide()
		Border = T.dummy
	end
 
	Count:ClearAllPoints()
	Count:Point("BOTTOMRIGHT", 0, 2)
	Count:SetFont(C["media"].font, 12, "OUTLINE")

	if Btname then
		Btname:SetText("")
		Btname:Kill()
	end
 
	if not Button.isSkinned then
		if self:GetHeight() ~= T.buttonsize and not InCombatLockdown() then --Taint fix for Flyout Buttons
			self:SetSize(T.buttonsize, T.buttonsize)
		end
		Button:CreateBackdrop()
		Button.backdrop:SetOutside(button, 0, 0)
		Icon:SetTexCoord(.08, .92, .08, .92)
		Icon:SetInside()
		Button.isSkinned = true
	end

	HotKey:ClearAllPoints()
	HotKey:Point("TOPRIGHT", 0, -3)
	HotKey:SetFont(C["media"].font, 12, "OUTLINE")
	HotKey.ClearAllPoints = T.dummy
	HotKey.SetPoint = T.dummy
 
	if not C["actionbar"].hotkey == true then
		HotKey:SetText("")
		HotKey:Kill()
	end
 
	if normal then
		normal:ClearAllPoints()
		normal:SetPoint("TOPLEFT")
		normal:SetPoint("BOTTOMRIGHT")
	end
	
	if BtnBG then
		BtnBG:Kill()
	end 
end

function T.StyleActionBarPetAndShiftButton(normal, button, icon, name, pet)
	button:SetNormalTexture("")
	
	-- bug fix when moving spell from bar
	button.SetNormalTexture = T.dummy
	
	local Flash	 = _G[name.."Flash"]
	Flash:SetTexture("")
	
	if not button.isSkinned then
		button:SetWidth(T.petbuttonsize)
		button:SetHeight(T.petbuttonsize)
		button:CreateBackdrop()
		button.backdrop:SetOutside(button, 0, 0)
		icon:SetTexCoord(.08, .92, .08, .92)
		icon:ClearAllPoints()
		icon:SetInside()
		if pet then			
			if T.petbuttonsize < 30 then
				local autocast = _G[name.."AutoCastable"]
				autocast:SetAlpha(0)
			end
			local shine = _G[name.."Shine"]
			shine:Size(T.petbuttonsize, T.petbuttonsize)
			shine:ClearAllPoints()
			shine:SetPoint("CENTER", button, 0, 0)
			icon:Point("TOPLEFT", button, 2, -2)
			icon:Point("BOTTOMRIGHT", button, -2, 2)
		end
		button.isSkinned = true
	end
	
	if normal then
		normal:ClearAllPoints()
		normal:SetPoint("TOPLEFT")
		normal:SetPoint("BOTTOMRIGHT")
	end
end

function T.StyleShift()
	for i=1, NUM_STANCE_SLOTS do
		local name = "StanceButton"..i
		local button  = _G[name]
		local icon  = _G[name.."Icon"]
		local normal  = _G[name.."NormalTexture"]
		T.StyleActionBarPetAndShiftButton(normal, button, icon, name)
	end
end

function T.StylePet()
	for i=1, NUM_PET_ACTION_SLOTS do
		local name = "PetActionButton"..i
		local button  = _G[name]
		local icon  = _G[name.."Icon"]
		local normal  = _G[name.."NormalTexture2"]
		T.StyleActionBarPetAndShiftButton(normal, button, icon, name, true)
	end
end

function T.UpdateActionBarHotKey(self, actionButtonType)
	local hotkey = _G[self:GetName() .. 'HotKey']
	local text = hotkey:GetText()
	
	text = replace(text, '(s%-)', 'S')
	text = replace(text, '(a%-)', 'A')
	text = replace(text, '(c%-)', 'C')
	text = replace(text, '(Mouse Button )', 'M')
	text = replace(text, '(Middle Mouse)', 'M3')
	text = replace(text, '(Mouse Wheel Up)', 'MU')
	text = replace(text, '(Mouse Wheel Down)', 'MD')
	text = replace(text, '(Num Pad )', 'N')
	text = replace(text, '(Page Up)', 'PU')
	text = replace(text, '(Page Down)', 'PD')
	text = replace(text, '(Spacebar)', 'SpB')
	text = replace(text, '(Insert)', 'Ins')
	text = replace(text, '(Home)', 'Hm')
	text = replace(text, '(Delete)', 'Del')
	
	if hotkey:GetText() == _G['RANGE_INDICATOR'] then
		hotkey:SetText('')
	else
		hotkey:SetText(text)
	end
end

local buttons = 0
local function SetupFlyoutButton()
	for i=1, buttons do
		--prevent error if you don't have max ammount of buttons
		if _G["SpellFlyoutButton"..i] then
			T.StyleActionBarButton(_G["SpellFlyoutButton"..i])
					
			if _G["SpellFlyoutButton"..i]:GetChecked() then
				_G["SpellFlyoutButton"..i]:SetChecked(nil)
			end
		end
	end
end
SpellFlyout:HookScript("OnShow", SetupFlyoutButton)

 
--Hide the Mouseover texture and attempt to find the ammount of buttons to be skinned
function T.StyleActionBarFlyout(self)
	if not self.FlyoutArrow then return end
	
	self.FlyoutBorder:SetAlpha(0)
	self.FlyoutBorderShadow:SetAlpha(0)
	
	SpellFlyoutHorizontalBackground:SetAlpha(0)
	SpellFlyoutVerticalBackground:SetAlpha(0)
	SpellFlyoutBackgroundEnd:SetAlpha(0)
	
	for i=1, GetNumFlyouts() do
		local x = GetFlyoutID(i)
		local _, _, numSlots, isKnown = GetFlyoutInfo(x)
		if isKnown then
			buttons = numSlots
			break
		end
	end
	
	--Change arrow direction depending on what bar the button is on
	local arrowDistance
	if ((SpellFlyout and SpellFlyout:IsShown() and SpellFlyout:GetParent() == self) or GetMouseFocus() == self) then
		arrowDistance = 5
	else
		arrowDistance = 2
	end
	
	if self:GetParent():GetParent():GetName() == "SpellBookSpellIconsFrame" then return end
	
	if self:GetAttribute("flyoutDirection") ~= nil then
		local point, _, _, _, _ = self:GetParent():GetParent():GetPoint()
		
		if strfind(point, "BOTTOM") then
			self.FlyoutArrow:ClearAllPoints()
			self.FlyoutArrow:SetPoint("TOP", self, "TOP", 0, arrowDistance)
			SetClampedTextureRotation(self.FlyoutArrow, 0)
			if not InCombatLockdown() then self:SetAttribute("flyoutDirection", "UP") end
		else
			self.FlyoutArrow:ClearAllPoints()
			self.FlyoutArrow:SetPoint("LEFT", self, "LEFT", -arrowDistance, 0)
			SetClampedTextureRotation(self.FlyoutArrow, 270)
			if not InCombatLockdown() then self:SetAttribute("flyoutDirection", "LEFT") end
		end
	end
end

-- rework the mouseover, pushed, checked texture to match Tukui theme.
for i = 1, 12 do
	_G["ActionButton"..i]:StyleButton()
	_G["MultiBarBottomLeftButton"..i]:StyleButton()
	_G["MultiBarBottomRightButton"..i]:StyleButton()
	_G["MultiBarLeftButton"..i]:StyleButton()
	_G["MultiBarRightButton"..i]:StyleButton()
end
	 
for i=1, 10 do
	_G["StanceButton"..i]:StyleButton()
	_G["PetActionButton"..i]:StyleButton()
end

T.ShowHighlightActionButton = function(self)
	-- hide ugly blizzard proc highlight
	if self.overlay then
		self.overlay:Hide()
		ActionButton_HideOverlayGlow(self)
	end
	
	-- create our own highlight
	-- note: Im still thinking for a better visual display than this, this proc highlight is WIP
	if self.backdrop then
		self.backdrop:SetBackdropBorderColor(0, 1, 0)
	end
end

T.HideHighlightActionButton = function(self)
	if self.backdrop then
		self.backdrop:SetBackdropBorderColor(unpack(C.media.bordercolor))
	end
end

hooksecurefunc("ActionButton_ShowOverlayGlow", T.ShowHighlightActionButton)
hooksecurefunc("ActionButton_HideOverlayGlow", T.HideHighlightActionButton)
hooksecurefunc("ActionButton_Update", T.StyleActionBarButton)
hooksecurefunc("ActionButton_UpdateHotkeys", T.UpdateActionBarHotKey)
hooksecurefunc("ActionButton_UpdateFlyout", T.StyleActionBarFlyout)