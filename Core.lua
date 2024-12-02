Chess = LibStub("AceAddon-3.0"):NewAddon("Chess", "AceComm-3.0")

local tileSize = 32
local pieceSize = 28
local buttonWidth = 48
local factionButtonWidth = 65
local buttonHeight = 22
local tileYOffset = 5
local flipOffset = 89
local black = "Interface\\Addons\\Chess\\Icons\\blacktile.blp"
local white = "Interface\\Addons\\Chess\\Icons\\whitetile.blp"
local grey = "Interface\\Addons\\Chess\\Icons\\greytile.blp"
local blue = "Interface\\Addons\\Chess\\Icons\\bluetile.blp"
local red = "Interface\\Addons\\Chess\\Icons\\redtile.blp"

local flipText = "Flip"
local allianceText = "Alliance"
local hordeText = "Horde"
local enterText = "or press 'Enter'"

local currentButton, challenger, lastOppFrom, lastOppTo = nil
local flipped = false
local currentPlayerColor = blue

local availMoves = {}

function Chess:OnInitialize()
    Chess:RegisterComm("CHESS") -- ARGS: prefix
    Chess:CreateMainFrame("MainFrame", 266, 350) -- ARGS: name, width, height
    Chess:PopulateBoard()
    Chess:PopulateTiles()
    Chess:CreateEditBox()
    Chess:CreateButtons()
end

function Chess:CreateMainFrame(name, width, height)
    local f = CreateFrame("Frame", name, UIParent, "BackdropTemplate")
    f:SetPoint("CENTER",0,-140)
    f:SetWidth(width)
    f:SetHeight(height)
    f:SetBackdrop({
        bgFile = "Interface/TutorialFrame/TutorialFrameBackground",
        edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 },
    })
    f:SetBackdropColor(0, 0, 0, 0.5)
    f:SetFrameStrata("LOW")
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)
    f:Show()
end

function Chess:CreateTile(name, anchor, point, xoffset, yoffset, color)
    local f = CreateFrame("Button", name, anchor)
    f:SetWidth(tileSize)
    f:SetHeight(tileSize)
    f:SetFrameStrata("LOW")
    f:SetPoint(point, xoffset, yoffset)
    f.tex = f:CreateTexture()
    f.tex:SetAllPoints(f)
    f.tex:SetTexture(color)
    f.color = color
    f.highlight = false
    f.contains = nil
    f:SetScript("OnClick", function()
        Chess:ClickTile(f)
	end)

    return f
end

function Chess:CreatePiece(name, anchor, tex, color, type)
    local b = CreateFrame("Button", name, anchor)
    b:SetWidth(pieceSize)
    b:SetHeight(pieceSize)
    b:SetPoint("CENTER")
    b:SetFrameStrata("MEDIUM")
    b.tex = b:CreateTexture()
    b.tex:SetAllPoints(b)
    b.tex:SetTexture(tex)
    b.color = color
    b.hasMoved = false
    b.type = type
    b:SetScript("OnClick", function()
        Chess:ClickPiece(b)
	end)
    anchor.contains = b:GetName()
end

function Chess:CreateButton(name, anchor, text, width, height, point, xoffset, yoffset)
    local b = CreateFrame("Button", name, MainFrame, "UIPanelButtonTemplate")
    b:SetText(text)
    b:SetWidth(width)
    b:SetHeight(height)
	b:SetPoint(point, anchor, xoffset, yoffset)
end

function Chess:CreateEditBox()
    local eb = CreateFrame("EditBox", "Opponent", MainFrame, "InputBoxTemplate")
	eb:SetAutoFocus(false)
	eb:SetWidth(142)
	eb:SetHeight(32)
	eb:SetPoint("TOPLEFT", MainFrame, 12, -16)
    eb:SetScript("OnEnterPressed", function()
		challenger = eb:GetText()
        eb:ClearFocus()
	end)
end

function Chess:CreateButtons()
    Chess:CreateButton("Flip", MainFrame, flipText, buttonWidth, buttonHeight, "TOPLEFT", 6, -64)
    Flip:SetScript("OnClick", function()
        Chess:FlipBoard()
	end)
    Chess:CreateButton("Horde", MainFrame, hordeText, factionButtonWidth, buttonHeight, "TOPRIGHT", -6, -64)
    Horde:SetScript("OnClick", function()
        if currentPlayerColor == blue then
            Chess:ResetColors()
        end
		currentPlayerColor = red
	end)
    Chess:CreateButton("Alliance", Horde, allianceText, factionButtonWidth, buttonHeight, "LEFT", -factionButtonWidth + 2, 0)
    Alliance:SetScript("OnClick", function()
        if currentPlayerColor == red then
            Chess:ResetColors()
        end
		currentPlayerColor = blue
	end)
    Chess:CreateButton("Enter", Opponent, enterText, 106, buttonHeight, "RIGHT", 106, 0)
    Enter:SetScript("OnClick", function()
        challenger = Opponent:GetText()
        Opponent:ClearFocus()
    end)
end

function Chess:PopulateBoard()
    local f = Chess:CreateTile("A1", MainFrame, "BOTTOMLEFT", 5, tileYOffset, black)
    local temp = white
    for i = 2, 8 do
        f = Chess:CreateTile("A" .. tostring(i), f, "TOP", 0, tileSize, temp)
        local ttemp = Chess:TileAlter(temp)
        temp = ttemp
    end
    local f = Chess:CreateTile("B1", A1, "RIGHT", tileSize, 0, white)
    local temp = black
    for i = 2, 8 do
        f = Chess:CreateTile("B" .. tostring(i), f, "TOP", 0, tileSize, temp)
        local ttemp = Chess:TileAlter(temp)
        temp = ttemp
    end
    local f = Chess:CreateTile("C1", B1, "RIGHT", tileSize, 0, black)
    local temp = white
    for i = 2, 8 do
        f = Chess:CreateTile("C" .. tostring(i), f, "TOP", 0, tileSize, temp)
        local ttemp = Chess:TileAlter(temp)
        temp = ttemp
    end
    local f = Chess:CreateTile("D1", C1, "RIGHT", tileSize, 0, white)
    local temp = black
    for i = 2, 8 do
        f = Chess:CreateTile("D" .. tostring(i), f, "TOP", 0, tileSize, temp)
        local ttemp = Chess:TileAlter(temp)
        temp = ttemp
    end
    local f = Chess:CreateTile("E1", D1, "RIGHT", tileSize, 0, black)
    local temp = white
    for i = 2, 8 do
        f = Chess:CreateTile("E" .. tostring(i), f, "TOP", 0, tileSize, temp)
        local ttemp = Chess:TileAlter(temp)
        temp = ttemp
    end
    local f = Chess:CreateTile("F1", E1, "RIGHT", tileSize, 0, white)
    local temp = black
    for i = 2, 8 do
        f = Chess:CreateTile("F" .. tostring(i), f, "TOP", 0, tileSize, temp)
        local ttemp = Chess:TileAlter(temp)
        temp = ttemp
    end
    local f = Chess:CreateTile("G1", F1, "RIGHT", tileSize, 0, black)
    local temp = white
    for i = 2, 8 do
        f = Chess:CreateTile("G" .. tostring(i), f, "TOP", 0, tileSize, temp)
        local ttemp = Chess:TileAlter(temp)
        temp = ttemp
    end
    local f = Chess:CreateTile("H1", G1, "RIGHT", tileSize, 0, white)
    local temp = black
    for i = 2, 8 do
        f = Chess:CreateTile("H" .. tostring(i), f, "TOP", 0, tileSize, temp)
        local ttemp = Chess:TileAlter(temp)
        temp = ttemp
    end
end

function Chess:FlipBoard()
    if not flipped then
        A1:ClearAllPoints()
        A1:SetPoint("TOPRIGHT", -5, -flipOffset)
        for i = 2, 8 do
            local name = getglobal("A" .. tostring(i))
            name:ClearAllPoints()
            name:SetPoint("BOTTOM", 0, -tileSize)
        end
        B1:ClearAllPoints()
        B1:SetPoint("RIGHT", -tileSize, 0)
        for i = 2, 8 do
            local name = getglobal("B" .. tostring(i))
            name:ClearAllPoints()
            name:SetPoint("BOTTOM", 0, -tileSize)
        end
        C1:ClearAllPoints()
        C1:SetPoint("RIGHT", -tileSize, 0)
        for i = 2, 8 do
            local name = getglobal("C" .. tostring(i))
            name:ClearAllPoints()
            name:SetPoint("BOTTOM", 0, -tileSize)
        end
        D1:ClearAllPoints()
        D1:SetPoint("RIGHT", -tileSize, 0)
        for i = 2, 8 do
            local name = getglobal("D" .. tostring(i))
            name:ClearAllPoints()
            name:SetPoint("BOTTOM", 0, -tileSize)
        end
        E1:ClearAllPoints()
        E1:SetPoint("RIGHT", -tileSize, 0)
        for i = 2, 8 do
            local name = getglobal("E" .. tostring(i))
            name:ClearAllPoints()
            name:SetPoint("BOTTOM", 0, -tileSize)
        end
        F1:ClearAllPoints()
        F1:SetPoint("RIGHT", -tileSize, 0)
        for i = 2, 8 do
            local name = getglobal("F" .. tostring(i))
            name:ClearAllPoints()
            name:SetPoint("BOTTOM", 0, -tileSize)
        end
        G1:ClearAllPoints()
        G1:SetPoint("RIGHT", -tileSize, 0)
        for i = 2, 8 do
            local name = getglobal("G" .. tostring(i))
            name:ClearAllPoints()
            name:SetPoint("BOTTOM", 0, -tileSize)
        end
        H1:ClearAllPoints()
        H1:SetPoint("RIGHT", -tileSize, 0)
        for i = 2, 8 do
            local name = getglobal("H" .. tostring(i))
            name:ClearAllPoints()
            name:SetPoint("BOTTOM", 0, -tileSize)
        end
        flipped = true
    elseif flipped then -----------------------------------------------------------------
        A1:ClearAllPoints()
        A1:SetPoint("BOTTOMLEFT", 5, tileYOffset)
        for i = 2, 8 do
            local name = getglobal("A" .. tostring(i))
            name:ClearAllPoints()
            name:SetPoint("TOP", 0, tileSize)
        end
        B1:ClearAllPoints()
        B1:SetPoint("RIGHT", tileSize, 0)
        for i = 2, 8 do
            local name = getglobal("B" .. tostring(i))
            name:ClearAllPoints()
            name:SetPoint("TOP", 0, tileSize)
        end
        C1:ClearAllPoints()
        C1:SetPoint("RIGHT", tileSize, 0)
        for i = 2, 8 do
            local name = getglobal("C" .. tostring(i))
            name:ClearAllPoints()
            name:SetPoint("TOP", 0, tileSize)
        end
        D1:ClearAllPoints()
        D1:SetPoint("RIGHT", tileSize, 0)
        for i = 2, 8 do
            local name = getglobal("D" .. tostring(i))
            name:ClearAllPoints()
            name:SetPoint("TOP", 0, tileSize)
        end
        E1:ClearAllPoints()
        E1:SetPoint("RIGHT", tileSize, 0)
        for i = 2, 8 do
            local name = getglobal("E" .. tostring(i))
            name:ClearAllPoints()
            name:SetPoint("TOP", 0, tileSize)
        end
        F1:ClearAllPoints()
        F1:SetPoint("RIGHT", tileSize, 0)
        for i = 2, 8 do
            local name = getglobal("F" .. tostring(i))
            name:ClearAllPoints()
            name:SetPoint("TOP", 0, tileSize)
        end
        G1:ClearAllPoints()
        G1:SetPoint("RIGHT", tileSize, 0)
        for i = 2, 8 do
            local name = getglobal("G" .. tostring(i))
            name:ClearAllPoints()
            name:SetPoint("TOP", 0, tileSize)
        end
        H1:ClearAllPoints()
        H1:SetPoint("RIGHT", tileSize, 0)
        for i = 2, 8 do
            local name = getglobal("H" .. tostring(i))
            name:ClearAllPoints()
            name:SetPoint("TOP", 0, tileSize)
        end
        flipped = false
    end
end

function Chess:PopulateTiles()
    -- WHITE
    Chess:CreatePiece("A2T", A2, "Interface\\Icons\\classicon_warrior", "white", "pawn")
    Chess:CreatePiece("B2T", B2, "Interface\\Icons\\classicon_warrior", "white", "pawn")
    Chess:CreatePiece("C2T", C2, "Interface\\Icons\\classicon_warrior", "white", "pawn")
    Chess:CreatePiece("D2T", D2, "Interface\\Icons\\classicon_warrior", "white", "pawn")
    Chess:CreatePiece("E2T", E2, "Interface\\Icons\\classicon_warrior", "white", "pawn")
    Chess:CreatePiece("F2T", F2, "Interface\\Icons\\classicon_warrior", "white", "pawn")
    Chess:CreatePiece("G2T", G2, "Interface\\Icons\\classicon_warrior", "white", "pawn")
    Chess:CreatePiece("H2T", H2, "Interface\\Icons\\classicon_warrior", "white", "pawn")
    Chess:CreatePiece("A1T", A1, "Interface\\Icons\\inv_bannerpvp_02", "white", "rook")
    Chess:CreatePiece("H1T", H1, "Interface\\Icons\\inv_bannerpvp_02", "white", "rook")
    Chess:CreatePiece("B1T", B1, "Interface\\Icons\\spell_frost_summonwaterelemental", "white", "knight")
    Chess:CreatePiece("G1T", G1, "Interface\\Icons\\spell_frost_summonwaterelemental", "white", "knight")
    Chess:CreatePiece("C1T", C1, "Interface\\Icons\\classicon_mage", "white", "bishop")
    Chess:CreatePiece("F1T", F1, "Interface\\Icons\\classicon_mage", "white", "bishop")
    Chess:CreatePiece("D1T", D1, "Interface\\Icons\\inv_misc_head_human_02", "white", "queen")
    Chess:CreatePiece("E1T", E1, "Interface\\Icons\\classicon_paladin", "white", "king")
    -- BLACK
    Chess:CreatePiece("A7T", A7, "Interface\\Icons\\inv_axe_06", "black", "pawn")
    Chess:CreatePiece("B7T", B7, "Interface\\Icons\\inv_axe_06", "black", "pawn")
    Chess:CreatePiece("C7T", C7, "Interface\\Icons\\inv_axe_06", "black", "pawn")
    Chess:CreatePiece("D7T", D7, "Interface\\Icons\\inv_axe_06", "black", "pawn")
    Chess:CreatePiece("E7T", E7, "Interface\\Icons\\inv_axe_06", "black", "pawn")
    Chess:CreatePiece("F7T", F7, "Interface\\Icons\\inv_axe_06", "black", "pawn")
    Chess:CreatePiece("G7T", G7, "Interface\\Icons\\inv_axe_06", "black", "pawn")
    Chess:CreatePiece("H7T", H7, "Interface\\Icons\\inv_axe_06", "black", "pawn")
    Chess:CreatePiece("A8T", A8, "Interface\\Icons\\inv_bannerpvp_01", "black", "rook")
    Chess:CreatePiece("H8T", H8, "Interface\\Icons\\inv_bannerpvp_01", "black", "rook")
    Chess:CreatePiece("B8T", B8, "Interface\\Icons\\spell_shadow_summonfelhunter", "black", "knight")
    Chess:CreatePiece("G8T", G8, "Interface\\Icons\\spell_shadow_summonfelhunter", "black", "knight")
    Chess:CreatePiece("C8T", C8, "Interface\\Icons\\classicon_warlock", "black", "bishop")
    Chess:CreatePiece("F8T", F8, "Interface\\Icons\\classicon_warlock", "black", "bishop")
    Chess:CreatePiece("D8T", D8, "Interface\\Icons\\inv_misc_head_orc_02", "black", "queen")
    Chess:CreatePiece("E8T", E8, "Interface\\Icons\\classicon_shaman", "black", "king")
end

function Chess:ClickPiece(b)
    local parent = b:GetParent()
    if currentButton == nil then
        currentButton = b
        Chess:Highlight(parent)
    elseif currentButton == b then
        Chess:ResetColors()
    elseif currentButton and currentButton ~= b then
        if Chess:PiecesAreNotSameColor(getglobal(currentButton:GetName()), b) and parent.highlight then
            b:Hide()
            Chess:Move(parent)
            if challenger then
                Chess:SendCommMessage("CHESS", currentButton:GetName() .. ":" .. b:GetName(), "WHISPER", challenger)
            end
            Chess:ResetColors()
        end
        Chess:ResetColors()
    end
end

function Chess:ClickTile(f) -- f = second button
    if currentButton and f.contains == nil and f.highlight then
        Chess:Move(f)
        if challenger then
            Chess:SendCommMessage("CHESS", currentButton:GetName() .. ":" .. f:GetName(), "WHISPER", challenger)
        end
        Chess:ResetColors()
    end
    Chess:ResetColors()
end

function Chess:Highlight(parent)
    local col = string.sub(parent:GetName(), 1, 1)
    local row = tonumber(string.sub(parent:GetName(), 2, 2))
    local first, second, colNumLeft, colLetterLeft, left, cLeft, tLeft, nLeft, colNumRight, colLetterRight, right, cRight, tRight, nRight
    if currentButton.color == "white" and currentPlayerColor == blue then
        parent.tex:SetTexture(blue)
        table.insert(availMoves, parent:GetName())
        if currentButton.type == "pawn" then
            first = row + 1
            second = row + 2
            nLeft = Chess:Convert(col) - 1
            nRight = Chess:Convert(col) + 1
            colNumLeft = Chess:Convert(col)
            if colNumLeft - 1 > 0 then
                colLetterLeft = Chess:Convert(colNumLeft - 1)
                left = colLetterLeft .. first
                if getglobal(left) then
                    cLeft = getglobal(left)
                    tLeft = getglobal(cLeft.contains)
                end
                if tLeft and currentButton.color ~= tLeft.color then
                    cLeft.tex:SetTexture(blue)
                    cLeft.highlight = true
                    table.insert(availMoves, left)
                end
            end
            colNumRight = Chess:Convert(col)
            if colNumRight + 1 < 9 then
                colLetterRight = Chess:Convert(colNumRight + 1)
                right = colLetterRight .. first
                if getglobal(right) ~= nil then
                    cRight = getglobal(right)
                    tRight = getglobal(cRight.contains)
                end
                if tRight and currentButton.color ~= tRight.color then
                    cRight.tex:SetTexture(blue)
                    cRight.highlight = true
                    table.insert(availMoves, right)
                end
            end
            if getglobal(col .. tostring(first)) then
                if not getglobal(col .. tostring(first)).contains then
                    getglobal(col .. tostring(first)).tex:SetTexture(blue)
                    getglobal(col .. tostring(first)).highlight = true
                    table.insert(availMoves, col .. tostring(first))
                else
                    return
                end
            end
            if getglobal(col .. tostring(second)) and getglobal(currentButton:GetName()).hasMoved == false then
                local tempOne = getglobal(col .. tostring(second)).contains
                if not getglobal(col .. tostring(second)).contains then
                    getglobal(col .. tostring(second)).tex:SetTexture(blue)
                    getglobal(col .. tostring(second)).highlight = true
                    table.insert(availMoves, col .. tostring(second))
                end
            end
            -- EN PASSANT
            --if colNumLeft - 1 > 0 then
            --    local rowNumber = string.sub(currentButton:GetParent():GetName(), 2, 2)
            --    local cLetterLeft = Chess:Convert(colNumLeft - 1)
            --    local leftNP = getglobal(colLetterLeft .. rowNumber):GetName()
            --    local leftN = getglobal(colLetterLeft .. rowNumber).contains
            --    if leftN and getglobal(leftN).type == "pawn" then
            --        if leftNP == lastOppTo and lastOppFrom and lastOppTo and (tonumber(string.sub(lastOppTo, 2, 2)) - tonumber(string.sub(lastOppFrom, 2, 2)) == -2) then
            --            local tempLetter = string.sub(lastOppFrom, 1, 1)
            --            local tempNum = tonumber(rowNumber + 1)
            --            getglobal(tempLetter .. tempNum).tex:SetTexture(blue)
            --            getglobal(tempLetter .. tempNum).highlight = true
            --            table.insert(availMoves, tostring(tempLetter .. tempNum))
            --        end
            --    end
            --end
            --if colNumRight + 1 < 9 then
            --    local rowNumber = string.sub(currentButton:GetParent():GetName(), 2, 2)
            --    local cLetterRight = Chess:Convert(colNumLeft + 1)
            --    local rightN = colLetterRight .. rowNumber
            --end
        end

        if currentButton.type == "bishop" then
            local colNum = Chess:Convert(col)
            -- TOPRIGHT
            for i = 1, 7, 1 do
                local colNumBack = Chess:Convert(colNum + i)
                if colNumBack and row + i < 9 then
                    local iter = Chess:BishopMove(colNumBack, tostring(row + i), blue)
                    if iter == 0 then
                        break
                    end
                end
            end
            -- BOTTOMRIGHT
            for i = 1, 7, 1 do
                local colNumBack = Chess:Convert(colNum + i)
                if colNumBack and row - i > 0 then
                    local iter = Chess:BishopMove(colNumBack, tostring(row - i), blue)
                    if iter == 0 then
                        break
                    end
                end
            end
            -- TOPLEFT
            for i = 1, 7, 1 do
                local colNumBack = Chess:Convert(colNum - i)
                if colNumBack and row + i < 9 then
                    local iter = Chess:BishopMove(colNumBack, tostring(row + i), blue)
                    if iter == 0 then
                        break
                    end
                end
            end
            -- BOTTOMLEFT
            for i = 1, 7, 1 do
                local colNumBack = Chess:Convert(colNum - i)
                if colNumBack and row - i > 0 then
                    local iter = Chess:BishopMove(colNumBack, tostring(row - i), blue)
                    if iter == 0 then
                        break
                    end
                end
            end
        end

        if currentButton.type == "knight" then
            local colNum = Chess:Convert(col)
            -- +x +y
            local colNumBack = Chess:Convert(colNum + 1)
            if colNumBack and row + 2 < 9 then
                Chess:KnightMove(colNumBack, tostring(row + 2), blue)
            end
            colNumBack = Chess:Convert(colNum + 2)
            if colNumBack and row + 1 < 9 then
                Chess:KnightMove(colNumBack, tostring(row + 1), blue)
            end
            -- +x -y
            colNumBack = Chess:Convert(colNum + 1)
            if colNumBack and row - 2 > 0 then
                Chess:KnightMove(colNumBack, tostring(row - 2), blue)
            end
            colNumBack = Chess:Convert(colNum + 2)
            if colNumBack and row - 1 > 0 then
                Chess:KnightMove(colNumBack, tostring(row - 1), blue)
            end
            -- -x -y
            colNumBack = Chess:Convert(colNum - 1)
            if colNumBack and row - 2 > 0 then
                Chess:KnightMove(colNumBack, tostring(row - 2), blue)
            end
            colNumBack = Chess:Convert(colNum - 2)
            if colNumBack and row - 1 > 0 then
                Chess:KnightMove(colNumBack, tostring(row - 1), blue)
            end
            -- -x +y
            colNumBack = Chess:Convert(colNum - 1)
            if colNumBack and row + 2 < 9 then
                Chess:KnightMove(colNumBack, tostring(row + 2), blue)
            end
            colNumBack = Chess:Convert(colNum - 2)
            if colNumBack and row + 1 < 9 then
                Chess:KnightMove(colNumBack, tostring(row + 1), blue)
            end
        end

        if currentButton.type == "rook" then
            local colNum = Chess:Convert(col)
            -- UP
            for i = 1, 7, 1 do
                local iter = Chess:RookMoveHorizontal(col, tostring(row + i), blue)
                if iter == 0 then
                    break
                end
            end
            -- DOWN
            for i = 1, 7, 1 do
                local iter = Chess:RookMoveHorizontal(col, tostring(row - i), blue)
                if iter == 0 then
                    break
                end
            end
            -- LEFT
            for i = 1, 7, 1 do
                local backNum = Chess:Convert(colNum - i)
                local iter = Chess:RookMoveVertical(backNum, tostring(row), blue)
                if iter == 0 then
                    break
                end
            end
            -- RIGHT
            for i = 1, 7, 1 do
                local backNum = Chess:Convert(colNum + i)
                local iter = Chess:RookMoveVertical(backNum, tostring(row), blue)
                if iter == 0 then
                    break
                end
            end
        end

        if currentButton.type == "queen" then
            local colNum = Chess:Convert(col)
            -- TOPRIGHT
            for i = 1, 7, 1 do
                local colNumBack = Chess:Convert(colNum + i)
                if colNumBack and row + i < 9 then
                    local iter = Chess:BishopMove(colNumBack, tostring(row + i), blue)
                    if iter == 0 then
                        break
                    end
                end
            end
            -- BOTTOMRIGHT
            for i = 1, 7, 1 do
                local colNumBack = Chess:Convert(colNum + i)
                if colNumBack and row - i > 0 then
                    local iter = Chess:BishopMove(colNumBack, tostring(row - i), blue)
                    if iter == 0 then
                        break
                    end
                end
            end
            -- TOPLEFT
            for i = 1, 7, 1 do
                local colNumBack = Chess:Convert(colNum - i)
                if colNumBack and row + i < 9 then
                    local iter = Chess:BishopMove(colNumBack, tostring(row + i), blue)
                    if iter == 0 then
                        break
                    end
                end
            end
            -- BOTTOMLEFT
            for i = 1, 7, 1 do
                local colNumBack = Chess:Convert(colNum - i)
                if colNumBack and row - i > 0 then
                    local iter = Chess:BishopMove(colNumBack, tostring(row - i), blue)
                    if iter == 0 then
                        break
                    end
                end
            end
            -- UP
            for i = 1, 7, 1 do
                local iter = Chess:RookMoveHorizontal(col, tostring(row + i), blue)
                if iter == 0 then
                    break
                end
            end
            -- DOWN
            for i = 1, 7, 1 do
                local iter = Chess:RookMoveHorizontal(col, tostring(row - i), blue)
                if iter == 0 then
                    break
                end
            end
            -- LEFT
            for i = 1, 7, 1 do
                local backNum = Chess:Convert(colNum - i)
                local iter = Chess:RookMoveVertical(backNum, tostring(row), blue)
                if iter == 0 then
                    break
                end
            end
            -- RIGHT
            for i = 1, 7, 1 do
                local backNum = Chess:Convert(colNum + i)
                local iter = Chess:RookMoveVertical(backNum, tostring(row), blue)
                if iter == 0 then
                    break
                end
            end
        end
        if currentButton.type == "king" then
            -- BISHOP
            local colNum = Chess:Convert(col)
            local colNumBack = Chess:Convert(colNum + 1)
            if colNumBack and row + 1 < 9 then
                Chess:BishopMove(colNumBack, tostring(row + 1), blue)
            end
            if colNumBack and row - 1 > 0 then
                Chess:BishopMove(colNumBack, tostring(row - 1), blue)
            end
            colNumBack = Chess:Convert(colNum - 1)
            if colNumBack and row + 1 < 9 then
                Chess:BishopMove(colNumBack, tostring(row + 1), blue)
            end
            if colNumBack and row - 1 > 0 then
                Chess:BishopMove(colNumBack, tostring(row - 1), blue)
            end
            -- ROOK
            Chess:RookMoveHorizontal(col, tostring(row + 1), blue)
            Chess:RookMoveHorizontal(col, tostring(row - 1), blue)
            local backNum = Chess:Convert(colNum - 1)
            Chess:RookMoveVertical(backNum, tostring(row), blue)
            backNum = Chess:Convert(colNum + 1)
            Chess:RookMoveVertical(backNum, tostring(row), blue)
        end

    elseif currentButton.color == "black" and currentPlayerColor == red then
        parent.tex:SetTexture(red)
        table.insert(availMoves, parent:GetName())
        if currentButton.type == "pawn" then
            first = row - 1
            second = row - 2
            nLeft = Chess:Convert(col) - 1
            nRight = Chess:Convert(col) + 1
            parent.tex:SetTexture(red)
            table.insert(availMoves, parent:GetName())
            colNumLeft = Chess:Convert(col)
            if colNumLeft - 1 > 0 then
                colLetterLeft = Chess:Convert(colNumLeft - 1)
                left = colLetterLeft .. first
                if getglobal(left) then
                    cLeft = getglobal(left)
                    tLeft = getglobal(cLeft.contains)
                end
                if tLeft and currentButton.color ~= tLeft.color then
                    cLeft.tex:SetTexture(red)
                    cLeft.highlight = true
                    table.insert(availMoves, left)
                end
            end
            colNumRight = Chess:Convert(col)
            if colNumRight + 1 < 9 then
                colLetterRight = Chess:Convert(colNumRight + 1)
                right = colLetterRight .. first
                if getglobal(right) ~= nil then
                    cRight = getglobal(right)
                    tRight = getglobal(cRight.contains)
                end
                if tRight and currentButton.color ~= tRight.color then
                    cRight.tex:SetTexture(red)
                    cRight.highlight = true
                    table.insert(availMoves, right)
                end
            end
            if getglobal(col .. tostring(first)) then
                if not getglobal(col .. tostring(first)).contains then
                    getglobal(col .. tostring(first)).tex:SetTexture(red)
                    getglobal(col .. tostring(first)).highlight = true
                    table.insert(availMoves, col .. tostring(first))
                else
                    return
                end
            end
            if getglobal(col .. tostring(second)) and getglobal(currentButton:GetName()).hasMoved == false then
                local tempOne = getglobal(col .. tostring(second)).contains
                if not getglobal(col .. tostring(second)).contains then
                    getglobal(col .. tostring(second)).tex:SetTexture(red)
                    getglobal(col .. tostring(second)).highlight = true
                    table.insert(availMoves, col .. tostring(second))
                end
            end
        end

        if currentButton.type == "bishop" then
            local colNum = Chess:Convert(col)
            -- TOPRIGHT
            for i = 1, 7, 1 do
                local colNumBack = Chess:Convert(colNum + i)
                if colNumBack and row + i < 9 then
                    local iter = Chess:BishopMove(colNumBack, tostring(row + i), red)
                    if iter == 0 then
                        break
                    end
                end
            end
            -- BOTTOMRIGHT
            for i = 1, 7, 1 do
                local colNumBack = Chess:Convert(colNum + i)
                if colNumBack and row - i > 0 then
                    local iter = Chess:BishopMove(colNumBack, tostring(row - i), red)
                    if iter == 0 then
                        break
                    end
                end
            end
            -- TOPLEFT
            for i = 1, 7, 1 do
                local colNumBack = Chess:Convert(colNum - i)
                if colNumBack and row + i < 9 then
                    local iter = Chess:BishopMove(colNumBack, tostring(row + i), red)
                    if iter == 0 then
                        break
                    end
                end
            end
            -- BOTTOMLEFT
            for i = 1, 7, 1 do
                local colNumBack = Chess:Convert(colNum - i)
                if colNumBack and row - i > 0 then
                    local iter = Chess:BishopMove(colNumBack, tostring(row - i), red)
                    if iter == 0 then
                        break
                    end
                end
            end
        end

        if currentButton.type == "knight" then
            local colNum = Chess:Convert(col)
            -- +x +y
            local colNumBack = Chess:Convert(colNum + 1)
            if colNumBack and row + 2 < 9 then
                Chess:KnightMove(colNumBack, tostring(row + 2), red)
            end
            colNumBack = Chess:Convert(colNum + 2)
            if colNumBack and row + 1 < 9 then
                Chess:KnightMove(colNumBack, tostring(row + 1), red)
            end
            -- +x -y
            colNumBack = Chess:Convert(colNum + 1)
            if colNumBack and row - 2 > 0 then
                Chess:KnightMove(colNumBack, tostring(row - 2), red)
            end
            colNumBack = Chess:Convert(colNum + 2)
            if colNumBack and row - 1 > 0 then
                Chess:KnightMove(colNumBack, tostring(row - 1), red)
            end
            -- -x -y
            colNumBack = Chess:Convert(colNum - 1)
            if colNumBack and row - 2 > 0 then
                Chess:KnightMove(colNumBack, tostring(row - 2), red)
            end
            colNumBack = Chess:Convert(colNum - 2)
            if colNumBack and row - 1 > 0 then
                Chess:KnightMove(colNumBack, tostring(row - 1), red)
            end
            -- -x +y
            colNumBack = Chess:Convert(colNum - 1)
            if colNumBack and row + 2 < 9 then
                Chess:KnightMove(colNumBack, tostring(row + 2), red)
            end
            colNumBack = Chess:Convert(colNum - 2)
            if colNumBack and row + 1 < 9 then
                Chess:KnightMove(colNumBack, tostring(row + 1), red)
            end
        end

        if currentButton.type == "rook" then
            local colNum = Chess:Convert(col)
            -- UP
            for i = 1, 7, 1 do
                local iter = Chess:RookMoveHorizontal(col, tostring(row + i), red)
                if iter == 0 then
                    break
                end
            end
            -- DOWN
            for i = 1, 7, 1 do
                local iter = Chess:RookMoveHorizontal(col, tostring(row - i), red)
                if iter == 0 then
                    break
                end
            end
            -- LEFT
            for i = 1, 7, 1 do
                local backNum = Chess:Convert(colNum - i)
                local iter = Chess:RookMoveVertical(backNum, tostring(row), red)
                if iter == 0 then
                    break
                end
            end
            -- RIGHT
            for i = 1, 7, 1 do
                local backNum = Chess:Convert(colNum + i)
                local iter = Chess:RookMoveVertical(backNum, tostring(row), red)
                if iter == 0 then
                    break
                end
            end
        end

        if currentButton.type == "queen" then
            local colNum = Chess:Convert(col)
            -- TOPRIGHT
            for i = 1, 7, 1 do
                local colNumBack = Chess:Convert(colNum + i)
                if colNumBack and row + i < 9 then
                    local iter = Chess:BishopMove(colNumBack, tostring(row + i), red)
                    if iter == 0 then
                        break
                    end
                end
            end
            -- BOTTOMRIGHT
            for i = 1, 7, 1 do
                local colNumBack = Chess:Convert(colNum + i)
                if colNumBack and row - i > 0 then
                    local iter = Chess:BishopMove(colNumBack, tostring(row - i), red)
                    if iter == 0 then
                        break
                    end
                end
            end
            -- TOPLEFT
            for i = 1, 7, 1 do
                local colNumBack = Chess:Convert(colNum - i)
                if colNumBack and row + i < 9 then
                    local iter = Chess:BishopMove(colNumBack, tostring(row + i), red)
                    if iter == 0 then
                        break
                    end
                end
            end
            -- BOTTOMLEFT
            for i = 1, 7, 1 do
                local colNumBack = Chess:Convert(colNum - i)
                if colNumBack and row - i > 0 then
                    local iter = Chess:BishopMove(colNumBack, tostring(row - i), red)
                    if iter == 0 then
                        break
                    end
                end
            end
            -- UP
            for i = 1, 7, 1 do
                local iter = Chess:RookMoveHorizontal(col, tostring(row + i), red)
                if iter == 0 then
                    break
                end
            end
            -- DOWN
            for i = 1, 7, 1 do
                local iter = Chess:RookMoveHorizontal(col, tostring(row - i), red)
                if iter == 0 then
                    break
                end
            end
            -- LEFT
            for i = 1, 7, 1 do
                local backNum = Chess:Convert(colNum - i)
                local iter = Chess:RookMoveVertical(backNum, tostring(row), red)
                if iter == 0 then
                    break
                end
            end
            -- RIGHT
            for i = 1, 7, 1 do
                local backNum = Chess:Convert(colNum + i)
                local iter = Chess:RookMoveVertical(backNum, tostring(row), red)
                if iter == 0 then
                    break
                end
            end
        end
        if currentButton.type == "king" then
            -- BISHOP
            local colNum = Chess:Convert(col)
            local colNumBack = Chess:Convert(colNum + 1)
            if colNumBack and row + 1 < 9 then
                Chess:BishopMove(colNumBack, tostring(row + 1), red)
            end
            if colNumBack and row - 1 > 0 then
                Chess:BishopMove(colNumBack, tostring(row - 1), red)
            end
            colNumBack = Chess:Convert(colNum - 1)
            if colNumBack and row + 1 < 9 then
                Chess:BishopMove(colNumBack, tostring(row + 1), red)
            end
            if colNumBack and row - 1 > 0 then
                Chess:BishopMove(colNumBack, tostring(row - 1), red)
            end
            -- ROOK
            Chess:RookMoveHorizontal(col, tostring(row + 1), red)
            Chess:RookMoveHorizontal(col, tostring(row - 1), red)
            local backNum = Chess:Convert(colNum - 1)
            Chess:RookMoveVertical(backNum, tostring(row), red)
            backNum = Chess:Convert(colNum + 1)
            Chess:RookMoveVertical(backNum, tostring(row), red)
        end
    end
end

function Chess:BishopMove(colArg, rowArg, color)
    if getglobal(colArg .. rowArg).contains then
        local tempOne = getglobal(colArg .. rowArg).contains
        if getglobal(tempOne).color == currentButton.color then
            return 0
        else
            getglobal(colArg .. rowArg).tex:SetTexture(color)
            getglobal(colArg .. rowArg).highlight = true
            table.insert(availMoves, colArg .. rowArg)
            return 0
        end
    else
        getglobal(colArg .. rowArg).tex:SetTexture(color)
        getglobal(colArg .. rowArg).highlight = true
        table.insert(availMoves, colArg .. rowArg)
    end
end

function Chess:KnightMove(colArg, rowArg, color)
    if getglobal(colArg .. rowArg).contains then
        local tempOne = getglobal(colArg .. rowArg).contains
        if getglobal(tempOne).color == currentButton.color then
        else
            getglobal(colArg .. rowArg).tex:SetTexture(color)
            getglobal(colArg .. rowArg).highlight = true
            table.insert(availMoves, colArg .. rowArg)
        end
    else
        getglobal(colArg .. rowArg).tex:SetTexture(color)
        getglobal(colArg .. rowArg).highlight = true
        table.insert(availMoves, colArg .. rowArg)
    end
end

function Chess:RookMoveHorizontal(colArg, rowArg, color)
    if getglobal(colArg .. rowArg) then
        if getglobal(colArg .. rowArg).contains then
            local tempOne = getglobal(colArg .. rowArg).contains
            if getglobal(tempOne).color == currentButton.color then
                return 0
            else
                getglobal(colArg .. rowArg).tex:SetTexture(color)
                getglobal(colArg .. rowArg).highlight = true
                table.insert(availMoves, colArg .. rowArg)
                return 0
            end
        else
            getglobal(colArg .. rowArg).tex:SetTexture(color)
            getglobal(colArg .. rowArg).highlight = true
            table.insert(availMoves, colArg .. rowArg)
        end
    end
end

function Chess:RookMoveVertical(colArg, rowArg, color)
    if colArg then
        if getglobal(colArg .. rowArg).contains then
            local tempOne = getglobal(colArg .. rowArg).contains
            if getglobal(tempOne).color == currentButton.color then
                return 0
            else
                getglobal(colArg .. rowArg).tex:SetTexture(color)
                getglobal(colArg .. rowArg).highlight = true
                table.insert(availMoves, colArg .. rowArg)
                return 0
            end
        else
            getglobal(colArg .. rowArg).tex:SetTexture(color)
            getglobal(colArg .. rowArg).highlight = true
            table.insert(availMoves, colArg .. rowArg)
        end
    end
end

function Chess:Move(sButton)
    local cParent = getglobal(currentButton:GetName()):GetParent():GetName()
    sButton.contains = getglobal(currentButton:GetName()):GetName()
    getglobal(cParent).contains = nil
    getglobal(currentButton:GetName()).hasMoved = true
    getglobal(currentButton:GetName()):SetParent(sButton)
    getglobal(currentButton:GetName()):SetPoint("CENTER")
end

function Chess:OnCommReceived(prefix, message, dist, sender)
    local start = nil
    print(message)
    local find = string.find(message, ".")
    print(find)
    local one, two = strsplit(":", message)
    lastOppFrom = getglobal(one):GetParent():GetName()
    lastOppTo = two
    if two:len() == 3 then
        local oneParent = getglobal(one):GetParent():GetName()
        local twoParent = getglobal(two):GetParent():GetName()
        getglobal(oneParent).contains = nil
        getglobal(twoParent).contains = getglobal(one):GetName()
        getglobal(one).hasMoved = true
        getglobal(one):SetParent(getglobal(two):GetParent())
        getglobal(one):SetPoint("CENTER")
        getglobal(two):Hide()
    else
        local oneParent = getglobal(one):GetParent():GetName()
        local twoParent = getglobal(two):GetName()
        getglobal(oneParent).contains = nil
        getglobal(twoParent).contains = getglobal(one):GetName()
        getglobal(one).hasMoved = true
        getglobal(one):SetParent(getglobal(two))
        getglobal(one):SetPoint("CENTER")
    end
end

function Chess:Convert(col)
    if col == "A" then
        return 1
    elseif col == "B" then
        return 2
    elseif col == "C" then
        return 3
    elseif col == "D" then
        return 4
    elseif col == "E" then
        return 5
    elseif col == "F" then
        return 6
    elseif col == "G" then
        return 7
    elseif col == "H" then
        return 8
    elseif col == 1 then
        return "A"
    elseif col == 2 then
        return "B"
    elseif col == 3 then
        return "C"
    elseif col == 4 then
        return "D"
    elseif col == 5 then
        return "E"
    elseif col == 6 then
        return "F"
    elseif col == 7 then
        return "G"
    elseif col == 8 then
        return "H"
    else
        return nil
    end
end

function Chess:TileAlter(temp)
    if temp == white then
        temp = black
    else
        temp = white
    end
    return temp
end

function Chess:PiecesAreNotSameColor(one, two)
    if one.color == two.color then
        return false
    else
        return true
    end
end

function Chess:ResetColors()
    for i, t in ipairs(availMoves) do
        getglobal(t).tex:SetTexture(getglobal(t).color)
        getglobal(t).highlight = false
    end
    availMoves = {}
    currentButton = nil
end
