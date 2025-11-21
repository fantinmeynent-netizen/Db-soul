--=====================================================
--        SUPER MENU COMPLET + CATEGORIES + MODULES
--=====================================================

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

------------------------------------------------------
--         VARIABLES GLOBALES POUR LES MODULES
------------------------------------------------------
local runningModules = {
    DragonBallFarm = false
}

------------------------------------------------------
--        CREATION DE LA FENETRE PRINCIPALE
------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui", player.PlayerGui)
ScreenGui.Name = "SuperMenu"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 600, 0, 350)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 8)

------------------------------------------------------
--  BARRE DU HAUT + BOUTONS QUITTER / REDUIRE
------------------------------------------------------
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 30, 1, 0)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
CloseBtn.TextColor3 = Color3.new(1,1,1)

local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size = UDim2.new(0, 30, 1, 0)
MinBtn.Position = UDim2.new(1, -60, 0, 0)
MinBtn.Text = "_"
MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinBtn.TextColor3 = Color3.new(1,1,1)

------------------------------------------------------
--       MINI CARRE QUAND ON REDUIT
------------------------------------------------------
local MiniFrame = Instance.new("Frame", ScreenGui)
MiniFrame.Size = UDim2.new(0, 120, 0, 40)
MiniFrame.Position = UDim2.new(1, -140, 0, 20)
MiniFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MiniFrame.Visible = false
MiniFrame.Active = true
MiniFrame.Draggable = true

local MiniText = Instance.new("TextButton", MiniFrame)
MiniText.Size = UDim2.new(1, 0, 1, 0)
MiniText.Text = "MENU"
MiniText.BackgroundTransparency = 1
MiniText.TextColor3 = Color3.new(1,1,1)

------------------------------------------------------
--      CATEGORIES A GAUCHE
------------------------------------------------------
local CategoryFrame = Instance.new("Frame", MainFrame)
CategoryFrame.Size = UDim2.new(0, 140, 1, -30)
CategoryFrame.Position = UDim2.new(0, 0, 0, 30)
CategoryFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local function createCategory(name)
    local btn = Instance.new("TextButton", CategoryFrame)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    btn.TextColor3 = Color3.new(1, 1, 1)
    return btn
end

local CombatBtn = createCategory("Combat")
local FarmBtn = createCategory("Farm")
local MiscBtn = createCategory("Misc")

MiscBtn.Position = UDim2.new(0, 0, 0, 80)
FarmBtn.Position = UDim2.new(0, 0, 0, 40)
CombatBtn.Position = UDim2.new(0, 0, 0, 0)

------------------------------------------------------
--    ZONE CENTRALE + SCROLLFRAME POUR MODULES
------------------------------------------------------
local ScrollFrame = Instance.new("ScrollingFrame", MainFrame)
ScrollFrame.Size = UDim2.new(1, -140, 1, -30)
ScrollFrame.Position = UDim2.new(0, 140, 0, 30)
ScrollFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

local UIList = Instance.new("UIListLayout", ScrollFrame)
UIList.Padding = UDim.new(0, 10)
UIList.SortOrder = Enum.SortOrder.LayoutOrder

------------------------------------------------------
--      FONCTION CREATION D'UN MODULE
------------------------------------------------------
local function createModule(name, description, toggleCallback)
    local frame = Instance.new("Frame", ScrollFrame)
    frame.Size = UDim2.new(1, -20, 0, 80)
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    frame.LayoutOrder = #ScrollFrame:GetChildren()

    local UICorner2 = Instance.new("UICorner", frame)

    local desc = Instance.new("TextLabel", frame)
    desc.Size = UDim2.new(0.7, 0, 1, 0)
    desc.Text = description
    desc.TextWrapped = true
    desc.BackgroundTransparency = 1
    desc.TextColor3 = Color3.new(1,1,1)

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.25, 0, 0.6, 0)
    btn.Position = UDim2.new(0.72, 0, 0.2, 0)
    btn.Text = "OFF"
    btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    btn.TextColor3 = Color3.new(1,1,1)

    btn.MouseButton1Click:Connect(function()
        local newState = not (btn.Text == "ON")
        if newState then
            btn.Text = "ON"
            btn.BackgroundColor3 = Color3.fromRGB(0, 160, 0)
        else
            btn.Text = "OFF"
            btn.BackgroundColor3 = Color3.fromRGB(160, 0, 0)
        end
        toggleCallback(newState)
    end)
end

------------------------------------------------------
--      FONCTION POUR EFFACER LE SCROLL
------------------------------------------------------
local function clearScroll()
    for _, v in ipairs(ScrollFrame:GetChildren()) do
        if v:IsA("Frame") then v:Destroy() end
    end
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ScrollFrame.UIListLayout.AbsoluteContentSize)
end

UIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize)
end)

------------------------------------------------------
--        MODULE : DRAGONBALL FARM
------------------------------------------------------
local function startDragonBallFarm()
    runningModules.DragonBallFarm = true

    while runningModules.DragonBallFarm do
        local folder = workspace:FindFirstChild("DragonBall")
        if folder then
            for _, obj in ipairs(folder:GetChildren()) do
                if not runningModules.DragonBallFarm then return end

                local part = obj:IsA("BasePart") and obj or (obj.PrimaryPart or nil)
                if part and part.Position.Y <= 10000 then
                    
                    local char = player.Character or player.CharacterAdded:Wait()
                    local hrp = char:WaitForChild("HumanoidRootPart")

                    local original = hrp.CFrame

                    hrp.CFrame = part.CFrame + Vector3.new(0, 5, 0)

                    task.wait(8)

                    for _, d in ipairs(part:GetDescendants()) do
                        if d:IsA("ProximityPrompt") then
                            d:InputHoldBegin()
                            task.wait(d.HoldDuration or 0.3)
                            d:InputHoldEnd()
                        end
                    end

                    hrp.CFrame = CFrame.new(original.X, 100000, original.Z)

                    task.wait(10)

                    hrp.CFrame = original
                end
            end
        end

        task.wait(0.3)
    end
end

local function stopAllModules()
    for k in pairs(runningModules) do
        runningModules[k] = false
    end
end

------------------------------------------------------
--     CATEGORIES : AFFICHER MODULES SELON CHOIX
------------------------------------------------------
CombatBtn.MouseButton1Click:Connect(function()
    clearScroll()
    -- vide pour l’instant
end)

FarmBtn.MouseButton1Click:Connect(function()
    clearScroll()

    createModule(
        "DragonBall Farm",
        "Farm automatique des DragonBalls : TP, press E, TP hauteur 100000…",
        function(state)
            if state then
                startDragonBallFarm()
            else
                runningModules.DragonBallFarm = false
            end
        end
    )
end)

MiscBtn.MouseButton1Click:Connect(function()
    clearScroll()
end)

------------------------------------------------------
--       BOUTON FERMER
------------------------------------------------------
CloseBtn.MouseButton1Click:Connect(function()
    stopAllModules()
    MainFrame.Visible = false
    MiniFrame.Visible = false
end)

------------------------------------------------------
--       BOUTON REDUIRE
------------------------------------------------------
local lastPos = MainFrame.Position

MinBtn.MouseButton1Click:Connect(function()
    lastPos = MainFrame.Position
    MainFrame.Visible = false
    MiniFrame.Visible = true
end)

MiniText.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MiniFrame.Visible = false
    MainFrame.Position = lastPos
end)
