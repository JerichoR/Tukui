local T, C, L = select(2, ...):unpack()

local DataText = T["DataTexts"]
local MyName = UnitName("player")
local format = format
local int = 2
local BGFrame = CreateFrame("Frame", nil, UIParent)
local Color = {}

function BGFrame:OnEnter()
	local NumScores = GetNumBattlefieldScores()
	local NumExtraStats = GetNumBattlefieldStats()

	for i = 1, NumScores do
		local Name, KillingBlows, HonorableKills, Deaths, HonorGained = GetBattlefieldScore(i)

		if (Name and Name == MyName) then
			local CurrentMapID = C_Map.GetBestMapForUnit("player")
			local ClassColor = format("|cff%.2x%.2x%.2x", Color.r * 255, Color.g * 255, Color.b * 255)

			GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 4)
			GameTooltip:ClearLines()
			GameTooltip:SetPoint("BOTTOM", self, "TOP", 0, 1)
			GameTooltip:ClearLines()
			GameTooltip:AddDoubleLine(L.DataText.StatsFor, ClassColor..Name.."|r")
			GameTooltip:AddLine(" ")
			GameTooltip:AddDoubleLine(KILLING_BLOWS, KillingBlows, 1, 1, 1)
			GameTooltip:AddDoubleLine(HONORABLE_KILLS, HonorableKills, 1, 1, 1)
			GameTooltip:AddDoubleLine(DEATHS, Deaths, 1, 1, 1)
			GameTooltip:AddDoubleLine(HONOR, format("%d", HonorGained), 1, 1, 1)

			for j = 1, NumExtraStats do
				GameTooltip:AddDoubleLine(GetBattlefieldStatInfo(j), GetBattlefieldStatData(i, j), 1,1,1)
			end

			break
		end
	end

	GameTooltip:Show()
end

function BGFrame:OnUpdate(t)
	int = int - t

	if (int < 0) then
		local NumScores = GetNumBattlefieldScores()

		RequestBattlefieldScoreData()

		for i = 1, NumScores do
			local Name, KillingBlows, HonorableKills, Deaths, HonorGained = GetBattlefieldScore(i)

			if (Name and Name == MyName) then
				self.Text1:SetText(DataText.NameColor..HONORABLE_KILLS..": |r"..DataText.ValueColor..HonorableKills.."|r")
				self.Text2:SetText(DataText.NameColor..HONOR..": |r"..DataText.ValueColor..format("%d", HonorGained).."|r")
				self.Text3:SetText(DataText.NameColor..KILLING_BLOWS..": |r"..DataText.ValueColor..KillingBlows.."|r")
			end
		end

		int = 2
	end
end

function BGFrame:OnEvent()
	local InInstance, InstanceType = IsInInstance()

	if (InInstance and (InstanceType == "pvp")) then
		self:Show()
	else
		self:Hide()
		self.Text1:SetText("")
		self.Text2:SetText("")
		self.Text3:SetText("")
	end
end

function BGFrame:Enable()
	if not (C.DataTexts.Battleground) then
		return
	end

	Color.r, Color.g, Color.b = unpack(T.Colors.class[T.MyClass])

	local DataTextLeft = T.DataTexts.Panels.Left

	BGFrame:SetAllPoints(DataTextLeft)
	BGFrame:CreateBackdrop()
	BGFrame:SetFrameLevel(4)
	BGFrame:SetFrameStrata("BACKGROUND")

	local Text1 = BGFrame:CreateFontString(nil, "OVERLAY")
	Text1:SetFontObject(DataText.Font)
	Text1:SetPoint("LEFT", 30, -1)
	Text1:SetHeight(BGFrame:GetHeight())
	BGFrame.Text1 = Text1

	local Text2 = BGFrame:CreateFontString(nil, "OVERLAY")
	Text2:SetFontObject(DataText.Font)
	Text2:SetPoint("CENTER", 0, -1)
	Text2:SetHeight(BGFrame:GetHeight())
	BGFrame.Text2 = Text2

	local Text3 = BGFrame:CreateFontString(nil, "OVERLAY")
	Text3:SetFontObject(DataText.Font)
	Text3:SetPoint("RIGHT", -30, -1)
	Text3:SetHeight(BGFrame:GetHeight())
	BGFrame.Text3 = Text3

	BGFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	BGFrame:SetScript("OnUpdate", BGFrame.OnUpdate)
	BGFrame:SetScript("OnEvent", BGFrame.OnEvent)
	BGFrame:SetScript("OnEnter", BGFrame.OnEnter)
	BGFrame:SetScript("OnLeave", GameTooltip_Hide)
end

DataText.BGFrame = BGFrame
