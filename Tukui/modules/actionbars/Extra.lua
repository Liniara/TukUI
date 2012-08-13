local T, C, L, G = unpack(select(2, ...))
if not C.actionbar.enable then return end

-- create the holder to allow moving extra button
local holder = CreateFrame("Frame", "TukuiExtraActionBarFrameHolder", UIParent)
holder:Size(160, 80)
holder:SetPoint("BOTTOM", 0, 250)
holder:SetMovable(true)
holder:SetTemplate("Default")
holder:SetBackdropBorderColor(1,0,0)
holder:SetAlpha(0)
	
holder.text = T.SetFontString(holder, C.media.uffont, 12)
holder.text:SetPoint("CENTER")
holder.text:SetText(L.move_extrabutton)
holder.text:Hide()

ExtraActionBarFrame:SetParent(UIParent)
ExtraActionBarFrame:ClearAllPoints()
ExtraActionBarFrame:SetPoint("CENTER", holder, "CENTER", 0, 0)
ExtraActionBarFrame.ignoreFramePositionManager  = true

G.ActionBars.BarExtra = ExtraActionBarFrame
G.ActionBars.BarExtra.Holder = holder

-- hook the texture, idea by roth via WoWInterface forums
local button = ExtraActionButton1
G.ActionBars.BarExtra.Button1 = ExtraActionButton1

-- always hide the background texture of extra
local disableTexture = function(self)
	self.button.style:SetTexture("")
end
hooksecurefunc("ExtraActionBar_OnShow", disableTexture)

-- spell icon
local icon = button.icon
icon:SetTexCoord(.08, .92, .08, .92)
icon:Point("TOPLEFT", button, 2, -2)
icon:Point("BOTTOMRIGHT", button, -2, 2)
icon:SetDrawLayer("ARTWORK")

-- pushed/hover
button:StyleButton()

-- backdrop
button:SetTemplate("Default")
button:SetNormalTexture("")