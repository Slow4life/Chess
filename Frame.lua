-- CONST


-- VARS

function Chess:ClickTile(b)
    local parent = b:GetParent():GetName()
    print(parent)
    if currentButton == nil then
        currentButton = b:GetName()
    elseif currentButton == b:GetName() then
        currentButton = nil
    elseif currentButton and currentButton ~= b:GetName() then
        b:Hide()
        --b:SetFrameStrata("BACKGROUND")
        --b.tex:SetAlpha(0.5)
        getglobal(currentButton):SetParent(parent)
        getglobal(currentButton):SetPoint("CENTER")
        currentButton = nil
        currentColor = nil
    end
end


-- MainFrame


-- EDITBOX
local eb = CreateFrame("EditBox", "Opponent", MainFrame, "InputBoxTemplate")
	eb:SetAutoFocus(false)
	eb:SetWidth(142)
	eb:SetHeight(32)
	eb:SetPoint("TOPLEFT", MainFrame, 12, -16)

-- Buttons
local b = CreateFrame("Button", "Okay", Opponent, "UIPanelButtonTemplate")
    b:SetWidth(buttonWidth)
    b:SetHeight(buttonHeight)
	b:SetText("Okay")
	b:SetPoint("RIGHT", Opponent, 47, 0)
	b:SetScript("OnClick", function()
		--ResetInstances()
	end)

local b = CreateFrame("Button", "Reset", MainFrame, "UIPanelButtonTemplate")
    b:SetWidth(buttonWidth)
    b:SetHeight(buttonHeight)
	b:SetText("Reset")
	b:SetPoint("BOTTOMLEFT", MainFrame, 5, 6)
	b:SetScript("OnClick", function()
		--ResetInstances()
	end)

local b = CreateFrame("Button", "Flip", MainFrame, "UIPanelButtonTemplate")
    b:SetWidth(buttonWidth)
    b:SetHeight(buttonHeight)
	b:SetText("Flip")
	b:SetPoint("BOTTOMRIGHT", MainFrame, -5, 6)
	b:SetScript("OnClick", function()
		--ResetInstances()
	end)

-- TILES
local f = CreateFrame("Button", "A1", MainFrame, "BackdropTemplate")
    f:SetWidth(tileSize)
    f:SetHeight(tileSize)
    f:SetFrameStrata("MEDIUM")
    f:SetPoint("BOTTOMLEFT", 7, 28)
    f.tex = f:CreateTexture()
    f.tex:SetAllPoints(f)
    f.tex:SetTexture("Interface\\Addons\\Chess\\Icons\\blacktile.blp")
    f:SetScript("OnClick", function()
        print("test")
	end)

local f = CreateFrame("Frame", "B1", A1, "BackdropTemplate")
    f:SetWidth(tileSize)
    f:SetHeight(tileSize)
    f:SetFrameStrata("MEDIUM")
    f:SetPoint("RIGHT", tileSize, 0)
    f:SetBackdrop({    
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    })
    f:SetBackdropColor(1, 1, 1, 1)

local f = CreateFrame("Frame", "C1", B1, "BackdropTemplate")
    f:SetWidth(tileSize)
    f:SetHeight(tileSize)
    f:SetFrameStrata("MEDIUM")
    f:SetPoint("RIGHT", tileSize, 0)
    f:SetBackdrop({    
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    })
    f:SetBackdropColor(0, 0, 0, 1)

local f = CreateFrame("Frame", "D1", C1, "BackdropTemplate")
    f:SetWidth(tileSize)
    f:SetHeight(tileSize)
    f:SetFrameStrata("MEDIUM")
    f:SetPoint("RIGHT", tileSize, 0)
    f:SetBackdrop({    
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    })
    f:SetBackdropColor(1, 1, 1, 1)

local f = CreateFrame("Frame", "E1", D1, "BackdropTemplate")
    f:SetWidth(tileSize)
    f:SetHeight(tileSize)
    f:SetFrameStrata("MEDIUM")
    f:SetPoint("RIGHT", tileSize, 0)
    f:SetBackdrop({    
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    })
    f:SetBackdropColor(0, 0, 0, 1)

local f = CreateFrame("Frame", "F1", E1, "BackdropTemplate")
    f:SetWidth(tileSize)
    f:SetHeight(tileSize)
    f:SetFrameStrata("MEDIUM")
    f:SetPoint("RIGHT", tileSize, 0)
    f:SetBackdrop({    
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    })
    f:SetBackdropColor(1, 1, 1, 1)

local f = CreateFrame("Frame", "G1", F1, "BackdropTemplate")
    f:SetWidth(tileSize)
    f:SetHeight(tileSize)
    f:SetFrameStrata("MEDIUM")
    f:SetPoint("RIGHT", tileSize, 0)
    f:SetBackdrop({    
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
    })
    f:SetBackdropColor(0, 0, 0, 1)

local f = CreateFrame("Frame", "F1", G1, "BackdropTemplate")


-- BUTTONS (TEXTURES)
local b = CreateFrame("Button", "T_A1", A1)
    b:SetWidth(pieceSize)
    b:SetHeight(pieceSize)
    b:SetPoint("CENTER")
    b.visible = true
    b:SetFrameStrata("HIGH")
    b.tex = f:CreateTexture()
    b.tex:SetAllPoints(b)
    b.tex:SetTexture("Interface\\Icons\\classicon_mage")
    b:SetScript("OnClick", function()
        ClickTile(b)
	end)

local b = CreateFrame("Button", "T_B1", B1)
    b:SetWidth(pieceSize)
    b:SetHeight(pieceSize)
    b:SetPoint("CENTER")
    b.visible = true
    b:SetFrameStrata("HIGH")
    b.tex = f:CreateTexture()
    b.tex:SetAllPoints(b)
    b.tex:SetTexture("Interface\\Icons\\classicon_hunter")
    b:SetScript("OnClick", function()
        ClickTile(b)
	end)

local b = CreateFrame("Button", "T_C1", C1)
    b:SetWidth(pieceSize)
    b:SetHeight(pieceSize)
    b:SetPoint("CENTER")
    b.visible = true
    b:SetFrameStrata("HIGH")
    b.tex = f:CreateTexture()
    b.tex:SetAllPoints(b)
    b.tex:SetTexture("Interface\\Icons\\classicon_rogue")
    b:SetScript("OnClick", function()
        print(b.visible)
        ClickTile(b)
	end)