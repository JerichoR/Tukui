local T, C, L = unpack((select(2, ...)))

local ActionBars = T["ActionBars"]
local Movers = T["Movers"]
local Button = ExtraActionButton1
local Icon = ExtraActionButton1Icon
local Container = ExtraAbilityContainer
local ZoneAbilities = ZoneAbilityFrame

function ActionBars:DisableExtraButtonTexture()
	local Bar = ExtraActionBarFrame

	if (HasExtraActionBar()) then
		Button.style:SetTexture("")

		Icon:SetInside()
	end
end

function ActionBars:SkinZoneAbilities()
	for SpellButton in ZoneAbilities.SpellButtonContainer:EnumerateActive() do
		if not SpellButton.IsSkinned then
			SpellButton:CreateBackdrop()
			SpellButton:StyleButton()
			SpellButton:CreateShadow()

			SpellButton.Backdrop:SetFrameLevel(SpellButton:GetFrameLevel() - 1)

			SpellButton.Icon:SetTexCoord(unpack(T.IconCoord))
			SpellButton.Icon:ClearAllPoints()
			SpellButton.Icon:SetInside(SpellButton.Backdrop)

			SpellButton.NormalTexture:SetAlpha(0)

			SpellButton.IsSkinned = true
		end
	end
end

function ActionBars:SetupExtraButton()
	local Holder = CreateFrame("Frame", "TukuiExtraActionButton", UIParent)
	local Bar = ExtraActionBarFrame
	local Icon = ExtraActionButton1Icon
	local Button = ExtraActionButton1
	
	if Button.SpellActivationAlert then
		Button.SpellActivationAlert:SetAlpha(0)
	end
	
	if Button.SpellCastAnimFrame then
		Button.SpellCastAnimFrame:SetAlpha(0)
	end
	
	if Button.InterruptDisplay then
		Button.InterruptDisplay:SetAlpha(0)
	end

	Bar:EnableMouse(false)
	Bar:SetParent(UIParent)

	Holder:SetSize(160, 80)
	Holder:SetPoint("BOTTOM", 0, 250)

	Container:SetParent(Holder)
	Container:ClearAllPoints()
	Container:SetPoint("CENTER", Holder, "CENTER", 0, 0)
	Container:EnableMouse(false)
	Container.ignoreFramePositionManager = true

	Button:StripTextures()
	Button:CreateBackdrop()
	Button:StyleButton()
	Button:SetNormalTexture("")
	Button:CreateShadow()

	Button.HotKey:Kill()

	Button.QuickKeybindHighlightTexture:SetTexture("")

	Icon:SetDrawLayer("ARTWORK")
	Icon:SetTexCoord(unpack(T.IconCoord))

	ZoneAbilities.Style:SetAlpha(0)

	Movers:RegisterFrame(Holder, "Extra Buttons")

	hooksecurefunc("ExtraActionBar_Update", self.DisableExtraButtonTexture)
	hooksecurefunc(ZoneAbilities, "UpdateDisplayedZoneAbilities", ActionBars.SkinZoneAbilities)
end
