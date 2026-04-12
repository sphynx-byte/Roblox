-- V0id Hub - Zenith Replica UI + Single Floating Toggle Button
-- Only ONE "V" button that toggles the GUI - no duplicates

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local ReplicatedStorage= game:GetService("ReplicatedStorage")
local TeleportService  = game:GetService("TeleportService")
local GuiService       = game:GetService("GuiService")

local lp = Players.LocalPlayer
local PlayerGui = lp:WaitForChild("PlayerGui")

-- ── Persistent ScreenGui (survives respawn) ────────────────────────────────
if PlayerGui:FindFirstChild("V0idHub") then
    PlayerGui.V0idHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "V0idHub"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ── SINGLE Floating "V" Toggle Button ──────────────────────────────────────
local FloatingButton = Instance.new("TextButton")
FloatingButton.Name = "V0idToggle"
FloatingButton.Parent = ScreenGui
FloatingButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
FloatingButton.Size = UDim2.new(0, 90, 0, 90)
FloatingButton.Position = UDim2.new(0.5, -45, 0.5, -45)  -- starts in center
FloatingButton.AnchorPoint = Vector2.new(0.5, 0.5)
FloatingButton.BackgroundTransparency = 0.1
FloatingButton.Text = "S"
FloatingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatingButton.Font = Enum.Font.GothamBold
FloatingButton.TextSize = 54
FloatingButton.TextStrokeTransparency = 0.5
FloatingButton.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
FloatingButton.BorderSizePixel = 0
FloatingButton.ZIndex = 10000
FloatingButton.Visible = true

local FloatCorner = Instance.new("UICorner")
FloatCorner.CornerRadius = UDim.new(1, 0)
FloatCorner.Parent = FloatingButton

local FloatStroke = Instance.new("UIStroke")
FloatStroke.Color = Color3.fromRGB(255, 255, 255)
FloatStroke.Thickness = 2.5
FloatStroke.Transparency = 0.3
FloatStroke.Parent = FloatingButton

-- Dragging for the floating button (PC + Mobile)
local fbDragging = false
local fbDragStart, fbStartPos

FloatingButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        fbDragging = true
        fbDragStart = input.Position
        fbStartPos = FloatingButton.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                fbDragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if fbDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - fbDragStart
        local newPos = UDim2.new(
            fbStartPos.X.Scale, fbStartPos.X.Offset + delta.X,
            fbStartPos.Y.Scale, fbStartPos.Y.Offset + delta.Y
        )
        local screen = workspace.CurrentCamera.ViewportSize
        local half = FloatingButton.AbsoluteSize / 2
        FloatingButton.Position = UDim2.new(
            0, math.clamp(newPos.X.Offset, half.X, screen.X - half.X),
            0, math.clamp(newPos.Y.Offset, half.Y, screen.Y - half.Y)
        )
    end
end)

-- ── Main GUI ────────────────────────────────────────────────────────────────
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 500, 0, 370)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 85, 85)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
TitleBar.BorderSizePixel = 0

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Parent = TitleBar
TitleText.Size = UDim2.new(1, -50, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "Sphyn Hub"
TitleText.Font = Enum.Font.GothamBold
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 18
TitleText.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button (minimizes GUI)
local CloseButton = Instance.new("TextButton")
CloseButton.Parent = TitleBar
CloseButton.AnchorPoint = Vector2.new(1, 0.5)
CloseButton.Position = UDim2.new(1, -12, 0.5, 0)
CloseButton.Size = UDim2.new(0, 32, 0, 32)
CloseButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
CloseButton.Text = "✕"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 16
CloseButton.BorderSizePixel = 0

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

-- Separator
local Separator = Instance.new("Frame")
Separator.Parent = MainFrame
Separator.Position = UDim2.new(0, 0, 0, 45)
Separator.Size = UDim2.new(1, 0, 0, 2)
Separator.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
Separator.BorderSizePixel = 0

-- Content
local Content = Instance.new("Frame")
Content.Parent = MainFrame
Content.Position = UDim2.new(0, 25, 0, 65)
Content.Size = UDim2.new(1, -50, 1, -85)
Content.BackgroundTransparency = 1

-- Tab Frame
local TabFrame = Instance.new("Frame")
TabFrame.Parent = Content
TabFrame.Size = UDim2.new(1, 0, 0, 40)
TabFrame.BackgroundTransparency = 1

local MainTabBtn = Instance.new("TextButton")
MainTabBtn.Name = "MainTab"
MainTabBtn.Parent = TabFrame
MainTabBtn.Size = UDim2.new(0, 100, 1, 0)
MainTabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainTabBtn.BorderSizePixel = 0
MainTabBtn.Font = Enum.Font.GothamBold
MainTabBtn.Text = "Main"
MainTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MainTabBtn.TextSize = 14
MainTabBtn.AutoButtonColor = false

local MainTabCorner = Instance.new("UICorner")
MainTabCorner.CornerRadius = UDim.new(0, 8)
MainTabCorner.Parent = MainTabBtn

local CombatTabBtn = Instance.new("TextButton")
CombatTabBtn.Name = "CombatTab"
CombatTabBtn.Parent = TabFrame
CombatTabBtn.Size = UDim2.new(0, 100, 1, 0)
CombatTabBtn.Position = UDim2.new(0, 110, 0, 0)
CombatTabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
CombatTabBtn.BorderSizePixel = 0
CombatTabBtn.Font = Enum.Font.GothamBold
CombatTabBtn.Text = "Combat"
CombatTabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
CombatTabBtn.TextSize = 14
CombatTabBtn.AutoButtonColor = false

local CombatTabCorner = Instance.new("UICorner")
CombatTabCorner.CornerRadius = UDim.new(0, 8)
CombatTabCorner.Parent = CombatTabBtn

-- Tab Contents
local MainTabContent = Instance.new("ScrollingFrame")
MainTabContent.Parent = Content
MainTabContent.Position = UDim2.new(0, 0, 0, 50)
MainTabContent.Size = UDim2.new(1, 0, 1, -50)
MainTabContent.BackgroundTransparency = 1
MainTabContent.ScrollBarThickness = 4
MainTabContent.ScrollBarImageColor3 = Color3.fromRGB(255, 85, 85)
MainTabContent.CanvasSize = UDim2.new(0, 0, 0, 600)
MainTabContent.Visible = true

local UIList1 = Instance.new("UIListLayout")
UIList1.Parent = MainTabContent
UIList1.SortOrder = Enum.SortOrder.LayoutOrder
UIList1.Padding = UDim.new(0, 10)

local CombatTabContent = Instance.new("ScrollingFrame")
CombatTabContent.Parent = Content
CombatTabContent.Position = UDim2.new(0, 0, 0, 50)
CombatTabContent.Size = UDim2.new(1, 0, 1, -50)
CombatTabContent.BackgroundTransparency = 1
CombatTabContent.ScrollBarThickness = 4
CombatTabContent.ScrollBarImageColor3 = Color3.fromRGB(255, 85, 85)
CombatTabContent.CanvasSize = UDim2.new(0, 0, 0, 500)
CombatTabContent.Visible = false

local UIList2 = Instance.new("UIListLayout")
UIList2.Parent = CombatTabContent
UIList2.SortOrder = Enum.SortOrder.LayoutOrder
UIList2.Padding = UDim.new(0, 10)

-- ── UI Helpers ──────────────────────────────────────────────────────────────
local function CreateToggle(parent, name, default, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Parent = parent
    ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = ToggleFrame
    
    local Label = Instance.new("TextLabel")
    Label.Parent = ToggleFrame
    Label.Size = UDim2.new(1, -45, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.Font = Enum.Font.Gotham
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Parent = ToggleFrame
    ToggleBtn.AnchorPoint = Vector2.new(1, 0.5)
    ToggleBtn.Position = UDim2.new(1, -10, 0.5, 0)
    ToggleBtn.Size = UDim2.new(0, 30, 0, 18)
    ToggleBtn.BackgroundColor3 = default and Color3.fromRGB(255, 85, 85) or Color3.fromRGB(50, 50, 50)
    ToggleBtn.Text = ""
    ToggleBtn.BorderSizePixel = 0
    ToggleBtn.AutoButtonColor = false
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 9)
    BtnCorner.Parent = ToggleBtn
    
    local Circle = Instance.new("Frame")
    Circle.Parent = ToggleBtn
    Circle.Size = UDim2.new(0, 14, 1, -2)
    Circle.Position = default and UDim2.new(1, -16, 0, 1) or UDim2.new(0, 1, 0, 1)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.BorderSizePixel = 0
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(0, 7)
    CircleCorner.Parent = Circle
    
    local state = default
    ToggleBtn.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = state and Color3.fromRGB(255, 85, 85) or Color3.fromRGB(50, 50, 50)}):Play()
        TweenService:Create(Circle, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -16, 0, 1) or UDim2.new(0, 1, 0, 1)}):Play()
        callback(state)
    end)
    
    return ToggleFrame
end

local function CreateSlider(parent, name, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Parent = parent
    SliderFrame.Size = UDim2.new(1, 0, 0, 50)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = SliderFrame
    
    local Label = Instance.new("TextLabel")
    Label.Parent = SliderFrame
    Label.Size = UDim2.new(1, -80, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, 5)
    Label.BackgroundTransparency = 1
    Label.Text = name .. ": " .. default
    Label.Font = Enum.Font.Gotham
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local Bar = Instance.new("Frame")
    Bar.Parent = SliderFrame
    Bar.Position = UDim2.new(0, 10, 1, -15)
    Bar.Size = UDim2.new(1, -20, 0, 6)
    Bar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    
    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(0, 3)
    BarCorner.Parent = Bar
    
    local Fill = Instance.new("Frame")
    Fill.Parent = Bar
    Fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(0, 3)
    FillCorner.Parent = Fill
    
    local dragging = false
    
    local function update(posX)
        local ratio = math.clamp((posX - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (max - min) * ratio + 0.5)
        Fill.Size = UDim2.new(ratio, 0, 1, 0)
        Label.Text = name .. ": " .. value
        callback(value)
    end
    
    Bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input.Position.X)
        end
    end)
    
    Bar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input.Position.X)
        end
    end)
    
    return SliderFrame
end

local function CreateButton(parent, name, callback)
    local Button = Instance.new("TextButton")
    Button.Parent = parent
    Button.Size = UDim2.new(1, 0, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Button.BorderSizePixel = 0
    Button.Font = Enum.Font.GothamBold
    Button.Text = name
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 14
    Button.AutoButtonColor = false
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = Button
    
    Button.MouseButton1Click:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.1), {Size = UDim2.new(1, -4, 0, 36)}):Play()
        task.wait(0.1)
        TweenService:Create(Button, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 40)}):Play()
        callback()
    end)
    
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
    end)
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
    end)
    
    return Button
end

-- ── Features ────────────────────────────────────────────────────────────────
local kVars = {
    boolCarrots = false,
    boolRebirth = false,
    fireMultiplier = 1,
    boolKillAll = false,
    lp = lp
}

local carrotConnection
local rebirthConnection
local killConnection
local currentTarget = nil

local function startCarrots()
    if carrotConnection then return end
    carrotConnection = RunService.Heartbeat:Connect(function()
        if not kVars.boolCarrots then
            carrotConnection:Disconnect()
            carrotConnection = nil
            return
        end
        pcall(function()
            local char = lp.Character
            if not char then return end
            local carrot = char:FindFirstChild("Carrot") or lp.Backpack:FindFirstChild("Carrot")
            if carrot and carrot:FindFirstChild("E") then
                for _ = 1, math.min(kVars.fireMultiplier, 20) do carrot.E:FireServer() end
            end
            local sky = char:FindFirstChild("Sky Carrot") or lp.Backpack:FindFirstChild("Sky Carrot")
            if sky and sky:FindFirstChild("E") then
                for _ = 1, math.min(kVars.fireMultiplier, 20) do sky.E:FireServer() end
            end
        end)
    end)
end

local function stopCarrots()
    kVars.boolCarrots = false
    if carrotConnection then carrotConnection:Disconnect() carrotConnection = nil end
end

local function startRebirth()
    if rebirthConnection then return end
    rebirthConnection = RunService.Heartbeat:Connect(function()
        if not kVars.boolRebirth then
            rebirthConnection:Disconnect()
            rebirthConnection = nil
            return
        end
        for _ = 1, 5 do
            pcall(function() ReplicatedStorage.RebirthMe:FireServer() end)
        end
    end)
end

local function stopRebirth()
    kVars.boolRebirth = false
    if rebirthConnection then rebirthConnection:Disconnect() rebirthConnection = nil end
end

local function getAlivePlayers()
    local list = {}
    for _, plr in Players:GetPlayers() do
        if plr ~= lp and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            table.insert(list, plr)
        end
    end
    return list
end

local function isTargetStillAlive()
    if not currentTarget or not currentTarget.Character then return false end
    local hum = currentTarget.Character:FindFirstChildWhichIsA("Humanoid")
    return hum and hum.Health > 0
end

local function startKillAll()
    if killConnection then return end
    local fightTool = game:GetService("StarterPack"):FindFirstChild("Fight")
    if not fightTool then warn("Fight tool not found") return end
    local remote = fightTool:FindFirstChild("E") or fightTool:FindFirstChild("ServerUse") or fightTool:FindFirstChild("LocalUse")
    if not remote or not remote:IsA("RemoteEvent") then warn("No valid remote in Fight") return end

    killConnection = RunService.Heartbeat:Connect(function()
        if not kVars.boolKillAll then
            killConnection:Disconnect()
            killConnection = nil
            currentTarget = nil
            return
        end
        pcall(function()
            local char = lp.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            local hrp = char.HumanoidRootPart
            if not isTargetStillAlive() then
                local alive = getAlivePlayers()
                if #alive == 0 then currentTarget = nil return end
                currentTarget = alive[1]
            end
            if not currentTarget then return end
            local tchar = currentTarget.Character
            if not tchar or not tchar:FindFirstChild("HumanoidRootPart") then return end
            local thrp = tchar.HumanoidRootPart
            local pos = thrp.Position + Vector3.new(0, 3, 0)
            hrp.CFrame = CFrame.new(pos, thrp.Position)
            for _ = 1, 8 do
                remote:FireServer(currentTarget)
                remote:FireServer(tchar)
                remote:FireServer(thrp)
                remote:FireServer(currentTarget, thrp)
            end
        end)
    end)
end

local function stopKillAll()
    kVars.boolKillAll = false
    if killConnection then killConnection:Disconnect() killConnection = nil end
    currentTarget = nil
end

-- ── Add UI Elements ─────────────────────────────────────────────────────────
CreateToggle(MainTabContent, "Auto Carrots", false, function(v)
    kVars.boolCarrots = v
    if v then startCarrots() else stopCarrots() end
end)

CreateSlider(MainTabContent, "Carrot Fire Multiplier", 1, 20, 1, function(v)
    kVars.fireMultiplier = v
end)

CreateToggle(MainTabContent, "Auto Rebirth (max spam)", false, function(v)
    kVars.boolRebirth = v
    if v then startRebirth() else stopRebirth() end
end)

CreateToggle(CombatTabContent, "Kill All (TP + auto swing)", false, function(v)
    kVars.boolKillAll = v
    if v then startKillAll() else stopKillAll() end
end)

-- Player List
local PlayerListFrame = Instance.new("Frame")
PlayerListFrame.Parent = CombatTabContent
PlayerListFrame.Size = UDim2.new(1, 0, 0, 180)
PlayerListFrame.BackgroundTransparency = 1

local ListLayout = Instance.new("UIListLayout")
ListLayout.Parent = PlayerListFrame
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 4)

local playerLabels = {}

local function updatePlayerList()
    for _, lbl in ipairs(playerLabels) do lbl:Destroy() end
    playerLabels = {}
    for _, plr in Players:GetPlayers() do
        local status = (plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0) and "Alive" or "Dead"
        local lbl = Instance.new("TextLabel")
        lbl.Parent = PlayerListFrame
        lbl.Size = UDim2.new(1, 0, 0, 24)
        lbl.BackgroundTransparency = 1
        lbl.Text = plr.Name .. " [" .. status .. "]"
        lbl.TextColor3 = status == "Alive" and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 14
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        table.insert(playerLabels, lbl)
    end
end

updatePlayerList()
CreateButton(CombatTabContent, "Refresh Player List", updatePlayerList)

-- Tab Switching
MainTabBtn.MouseButton1Click:Connect(function()
    MainTabContent.Visible = true
    CombatTabContent.Visible = false
    MainTabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    CombatTabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CombatTabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
end)

CombatTabBtn.MouseButton1Click:Connect(function()
    MainTabContent.Visible = false
    CombatTabContent.Visible = true
    CombatTabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    MainTabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    CombatTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MainTabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
end)

-- Hover effects
local function AddHover(btn)
    btn.MouseEnter:Connect(function()
        if btn.BackgroundColor3 ~= Color3.fromRGB(35, 35, 35) then
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if btn.BackgroundColor3 ~= Color3.fromRGB(35, 35, 35) then
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
        end
    end)
end

AddHover(MainTabBtn)
AddHover(CombatTabBtn)
AddHover(CloseButton)

-- Close button minimizes GUI
CloseButton.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    task.wait(0.35)
    MainFrame.Visible = false
end)

-- SINGLE "V" button toggles the GUI
FloatingButton.MouseButton1Click:Connect(function()
    if MainFrame.Visible then
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.wait(0.35)
        MainFrame.Visible = false
    else
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 500, 0, 370)}):Play()
    end
end)

-- Main GUI dragging
local dragging, dragInput, dragStart, startPos = false, nil, nil, nil

local function updateInput(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and dragInput == input then updateInput(input) end
end)

-- Initial animation
MainFrame.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 500, 0, 370)}):Play()

-- Auto-rejoin on kick
GuiService.ErrorMessageChanged:Connect(function()
    if GuiService:GetErrorMessage() ~= "" then
        task.wait(1.5)
        TeleportService:Teleport(game.PlaceId, lp)
    end
end)

print("Sphyn Hub loaded")
print("https://discord.gg/nQmhZVbG7v")
print("join for more updates and to report bugs")