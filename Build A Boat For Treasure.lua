
-- Zenith Hub Replica GUI + Difficulty Fling AutoFarm (Full Updated Version)
-- Features: Draggable main GUI, draggable floating "V" toggle, destroys old GUIs, fixed tabs, client settings

getgenv().autofarm = false
getgenv().autofarmDisabledByAdmin = false

local Players          = game:GetService("Players")
local LocalPlayer      = Players.LocalPlayer
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local CoreGui          = game:GetService("CoreGui")

-- ── DESTROY OLD GUIs ────────────────────────────────────────────────────────
if CoreGui:FindFirstChild("ZenithReplica") then
    CoreGui.ZenithReplica:Destroy()
end

-- ── ADMIN / ANTI-DETECTION ──────────────────────────────────────────────────
local ADMINS = {
    "w1zlm", "pizz4smoke", "thewatchcatviolation", "ElectrifiedSun",
    "tr1xist", "MrZ13596", "taketheldfs", "malfo232"
}

local function isAdmin(player)
    return table.find(ADMINS, player.Name) ~= nil
end

local function disableAutofarmByAdmin()
    getgenv().autofarm = false
    getgenv().autofarmDisabledByAdmin = true
    if statusLabel then
        statusLabel.Text = "Auto Farm: DISABLED (Admin Detected)"
    end
    if floatingToggle then
        floatingToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        floatingToggle.TextTransparency = 0.4
    end
end

local function checkForAdmins()
    for _, player in ipairs(Players:GetPlayers()) do
        if isAdmin(player) then
            disableAutofarmByAdmin()
            break
        end
    end
end

checkForAdmins()
Players.PlayerAdded:Connect(function(player)
    if isAdmin(player) then
        disableAutofarmByAdmin()
    end
end)

-- ── GAME GUI CLEANUP ────────────────────────────────────────────────────────
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local MASS_SPAWN_DELETE = {"POTATO", "LabQuest", "PopUps", "CashGems", "Messages"}

for _, child in ipairs(PlayerGui:GetChildren()) do
    if table.find(MASS_SPAWN_DELETE, child.Name) then
        child:Destroy()
    end
end

PlayerGui.ChildAdded:Connect(function(child)
    task.wait()
    if table.find(MASS_SPAWN_DELETE, child.Name) then
        child:Destroy()
    end
end)

-- ── AUTO FARM LOGIC ─────────────────────────────────────────────────────────
local flingConnection
local characterConnection

local function stopAutofarm()
    if flingConnection then flingConnection:Disconnect() flingConnection = nil end
    if characterConnection then characterConnection:Disconnect() characterConnection = nil end
    
    if LocalPlayer.Character then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root and root:FindFirstChildOfClass("BodyForce") then
            root:FindFirstChildOfClass("BodyForce"):Destroy()
        end
    end
end

local function setupCharacter(character)
    if not getgenv().autofarm or getgenv().autofarmDisabledByAdmin then return end
    
    local root = character:WaitForChild("HumanoidRootPart")
    local targetPos = Vector3.new(112, 570, 129)
    local stuckPos  = Vector3.new(101, 1366, 192)
    
    repeat
        root.CFrame = CFrame.new(targetPos)
        task.wait(0.1)
    until (stuckPos - root.Position).Magnitude > 100
    
    if root:FindFirstChildOfClass("BodyForce") then
        root:FindFirstChildOfClass("BodyForce"):Destroy()
    end
    
    local BodyForce = Instance.new("BodyForce")
    BodyForce.Force = Vector3.new(0, 2500, 50000)
    BodyForce.Parent = root
    
    flingConnection = RunService.Heartbeat:Connect(function()
        if root.Position.Z >= 60000 then
            character:BreakJoints()
        end
    end)
end

local function toggleAutofarm(state)
    getgenv().autofarm = state
    
    if statusLabel then
        statusLabel.Text = "Auto Farm: " .. (state and "ON" or "OFF")
    end
    
    if floatingToggle then
        TweenService:Create(floatingToggle, TweenInfo.new(0.2), {
            BackgroundColor3 = state and Color3.fromRGB(0, 200, 80) or Color3.fromRGB(50, 50, 50)
        }):Play()
        floatingToggle.TextTransparency = state and 0 or 0.4
    end
    
    if state then
        stopAutofarm()
        if LocalPlayer.Character then
            setupCharacter(LocalPlayer.Character)
        end
        characterConnection = LocalPlayer.CharacterAdded:Connect(setupCharacter)
    else
        stopAutofarm()
    end
end

-- ── CREATE HELPER FUNCTIONS ─────────────────────────────────────────────────
local function CreateToggle(parent, name, default, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Parent = parent
    ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    
    local Corner = Instance.new("UICorner", ToggleFrame)
    Corner.CornerRadius = UDim.new(0, 8)
    
    local Label = Instance.new("TextLabel", ToggleFrame)
    Label.Size = UDim2.new(1, -45, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.Font = Enum.Font.Gotham
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local ToggleBtn = Instance.new("TextButton", ToggleFrame)
    ToggleBtn.AnchorPoint = Vector2.new(1, 0.5)
    ToggleBtn.Position = UDim2.new(1, -10, 0.5, 0)
    ToggleBtn.Size = UDim2.new(0, 30, 0, 18)
    ToggleBtn.BackgroundColor3 = default and Color3.fromRGB(255, 85, 85) or Color3.fromRGB(50, 50, 50)
    ToggleBtn.Text = ""
    ToggleBtn.BorderSizePixel = 0
    ToggleBtn.AutoButtonColor = false
    
    local BtnCorner = Instance.new("UICorner", ToggleBtn)
    BtnCorner.CornerRadius = UDim.new(0, 9)
    
    local Circle = Instance.new("Frame", ToggleBtn)
    Circle.Size = UDim2.new(0, 14, 1, -2)
    Circle.Position = default and UDim2.new(1, -16, 0, 1) or UDim2.new(0, 1, 0, 1)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.BorderSizePixel = 0
    
    local CircleCorner = Instance.new("UICorner", Circle)
    CircleCorner.CornerRadius = UDim.new(0, 7)
    
    local state = default
    
    ToggleBtn.MouseButton1Click:Connect(function()
        if getgenv().autofarmDisabledByAdmin and name:find("Auto Farm") then return end
        state = not state
        TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = state and Color3.fromRGB(255, 85, 85) or Color3.fromRGB(50, 50, 50)
        }):Play()
        TweenService:Create(Circle, TweenInfo.new(0.2), {
            Position = state and UDim2.new(1, -16, 0, 1) or UDim2.new(0, 1, 0, 1)
        }):Play()
        callback(state)
    end)
    
    return ToggleFrame
end

local function CreateButton(parent, name, callback)
    local Button = Instance.new("TextButton", parent)
    Button.Size = UDim2.new(1, 0, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Button.BorderSizePixel = 0
    Button.Font = Enum.Font.GothamBold
    Button.Text = name
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 14
    Button.AutoButtonColor = false
    
    local Corner = Instance.new("UICorner", Button)
    Corner.CornerRadius = UDim.new(0, 8)
    
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

local function CreateSlider(parent, name, min, max, default, callback)
    local SliderFrame = Instance.new("Frame", parent)
    SliderFrame.Size = UDim2.new(1, 0, 0, 50)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    
    local Corner = Instance.new("UICorner", SliderFrame)
    Corner.CornerRadius = UDim.new(0, 8)
    
    local Label = Instance.new("TextLabel", SliderFrame)
    Label.Size = UDim2.new(1, -80, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, 5)
    Label.BackgroundTransparency = 1
    Label.Text = name .. ": " .. default
    Label.Font = Enum.Font.Gotham
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local Bar = Instance.new("Frame", SliderFrame)
    Bar.AnchorPoint = Vector2.new(0, 1)
    Bar.Position = UDim2.new(0, 10, 1, -10)
    Bar.Size = UDim2.new(1, -20, 0, 6)
    Bar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Bar.BorderSizePixel = 0
    
    local BarCorner = Instance.new("UICorner", Bar)
    BarCorner.CornerRadius = UDim.new(0, 3)
    
    local Fill = Instance.new("Frame", Bar)
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
    Fill.BorderSizePixel = 0
    
    local FillCorner = Instance.new("UICorner", Fill)
    FillCorner.CornerRadius = UDim.new(0, 3)
    
    local Knob = Instance.new("Frame", Bar)
    Knob.AnchorPoint = Vector2.new(0.5, 0.5)
    Knob.Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0)
    Knob.Size = UDim2.new(0, 16, 0, 16)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
    Knob.BorderSizePixel = 0
    
    local KnobCorner = Instance.new("UICorner", Knob)
    KnobCorner.CornerRadius = UDim.new(1, 0)
    
    local dragging = false
    
    local function update(posX)
        local ratio = math.clamp((posX - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + (max - min) * ratio)
        Fill.Size = UDim2.new(ratio, 0, 1, 0)
        Knob.Position = UDim2.new(ratio, 0, 0.5, 0)
        Label.Text = name .. ": " .. value
        callback(value)
    end
    
    Knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    
    Knob.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input.Position.X)
        end
    end)
    
    -- Initial position
    update(Bar.AbsolutePosition.X + (default - min) / (max - min) * Bar.AbsoluteSize.X)
    
    return SliderFrame
end

-- ── BUILD MAIN GUI ──────────────────────────────────────────────────────────
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZenithReplica"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, 500, 0, 370)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 12)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(255, 85, 85)
MainStroke.Thickness = 2

-- Title Bar
local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
TitleBar.BorderSizePixel = 0

local TitleCorner = Instance.new("UICorner", TitleBar)
TitleCorner.CornerRadius = UDim.new(0, 12)

local TitleText = Instance.new("TextLabel", TitleBar)
TitleText.Size = UDim2.new(1, -50, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "V0id Hub"
TitleText.Font = Enum.Font.GothamBold
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 18
TitleText.TextXAlignment = Enum.TextXAlignment.Left

local CloseButton = Instance.new("TextButton", TitleBar)
CloseButton.AnchorPoint = Vector2.new(1, 0.5)
CloseButton.Position = UDim2.new(1, -12, 0.5, 0)
CloseButton.Size = UDim2.new(0, 32, 0, 32)
CloseButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
CloseButton.Text = "✕"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 16
CloseButton.BorderSizePixel = 0

local CloseCorner = Instance.new("UICorner", CloseButton)
CloseCorner.CornerRadius = UDim.new(0, 8)

-- Separator
local Separator = Instance.new("Frame", MainFrame)
Separator.Position = UDim2.new(0, 0, 0, 45)
Separator.Size = UDim2.new(1, 0, 0, 2)
Separator.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
Separator.BorderSizePixel = 0

-- Content Area
local Content = Instance.new("Frame", MainFrame)
Content.Position = UDim2.new(0, 25, 0, 65)
Content.Size = UDim2.new(1, -50, 1, -85)
Content.BackgroundTransparency = 1

local TabFrame = Instance.new("Frame", Content)
TabFrame.Size = UDim2.new(1, 0, 0, 40)
TabFrame.BackgroundTransparency = 1

local MainTabBtn = Instance.new("TextButton", TabFrame)
MainTabBtn.Size = UDim2.new(0, 100, 1, 0)
MainTabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainTabBtn.BorderSizePixel = 0
MainTabBtn.Font = Enum.Font.GothamBold
MainTabBtn.Text = "Main"
MainTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MainTabBtn.TextSize = 14
MainTabBtn.AutoButtonColor = false

local MainTabCorner = Instance.new("UICorner", MainTabBtn)
MainTabCorner.CornerRadius = UDim.new(0, 8)

local SettingsTabBtn = Instance.new("TextButton", TabFrame)
SettingsTabBtn.Size = UDim2.new(0, 100, 1, 0)
SettingsTabBtn.Position = UDim2.new(0, 110, 0, 0)
SettingsTabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SettingsTabBtn.BorderSizePixel = 0
SettingsTabBtn.Font = Enum.Font.GothamBold
SettingsTabBtn.Text = "Client Settings"
SettingsTabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
SettingsTabBtn.TextSize = 14
SettingsTabBtn.AutoButtonColor = false

local SettingsTabCorner = Instance.new("UICorner", SettingsTabBtn)
SettingsTabCorner.CornerRadius = UDim.new(0, 8)

local MainTabContent = Instance.new("ScrollingFrame", Content)
MainTabContent.Position = UDim2.new(0, 0, 0, 50)
MainTabContent.Size = UDim2.new(1, 0, 1, -50)
MainTabContent.BackgroundTransparency = 1
MainTabContent.ScrollBarThickness = 4
MainTabContent.ScrollBarImageColor3 = Color3.fromRGB(255, 85, 85)
MainTabContent.CanvasSize = UDim2.new(0, 0, 0, 400)
MainTabContent.Visible = true

local UIList1 = Instance.new("UIListLayout", MainTabContent)
UIList1.SortOrder = Enum.SortOrder.LayoutOrder
UIList1.Padding = UDim.new(0, 8)

local SettingsTabContent = Instance.new("Frame", Content)
SettingsTabContent.Position = UDim2.new(0, 0, 0, 50)
SettingsTabContent.Size = UDim2.new(1, 0, 1, -50)
SettingsTabContent.BackgroundTransparency = 1
SettingsTabContent.Visible = false

local UIList2 = Instance.new("UIListLayout", SettingsTabContent)
UIList2.SortOrder = Enum.SortOrder.LayoutOrder
UIList2.Padding = UDim.new(0, 8)

-- Status label
local statusLabel = Instance.new("TextLabel", MainTabContent)
statusLabel.Size = UDim2.new(1, 0, 0, 30)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Auto Farm: OFF"
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextSize = 16
statusLabel.TextXAlignment = Enum.TextXAlignment.Center

-- ── MAIN TAB ELEMENTS ───────────────────────────────────────────────────────
CreateToggle(MainTabContent, "Enable Auto Farm", false, function(state)
    toggleAutofarm(state)
end)

CreateButton(MainTabContent, "Teleport to Launch", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(112, 570, 129)
    end
end)

CreateButton(MainTabContent, "Copy Discord", function()
    setclipboard("https://discord.gg/nQmhZVbG7v")
end)

-- ── CLIENT SETTINGS TAB ─────────────────────────────────────────────────────
CreateSlider(SettingsTabContent, "GUI Scale", 70, 150, 100, function(value)
    local scale = value / 100
    -- You can expand this to actually scale the whole GUI if desired
    print("GUI Scale:", scale)
end)

CreateToggle(SettingsTabContent, "Infinite Jump", false, function(v)
    print("Infinite Jump:", v)
    -- Add real infinite jump logic here if wanted
end)

CreateSlider(SettingsTabContent, "WalkSpeed", 10, 200, 16, function(v)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = v
    end
end)

CreateSlider(SettingsTabContent, "JumpPower", 50, 300, 50, function(v)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = v
    end
end)

CreateButton(SettingsTabContent, "Reset Character", function()
    if LocalPlayer.Character then
        LocalPlayer.Character:BreakJoints()
    end
end)

-- ── TAB SWITCHING (FIXED) ───────────────────────────────────────────────────
local function activateMain()
    MainTabContent.Visible = true
    SettingsTabContent.Visible = false
    MainTabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    SettingsTabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SettingsTabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
end

activateMain()  -- Start on Main tab

MainTabBtn.MouseButton1Click:Connect(activateMain)

SettingsTabBtn.MouseButton1Click:Connect(function()
    MainTabContent.Visible = false
    SettingsTabContent.Visible = true
    SettingsTabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    MainTabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    SettingsTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
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
AddHover(SettingsTabBtn)
AddHover(CloseButton)

-- Close animation
CloseButton.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0,0,0,0)}):Play()
    TweenService:Create(MainStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
    task.wait(0.3)
    ScreenGui:Destroy()
    stopAutofarm()
end)

-- Draggable main window
local dragging, dragInput, dragStart, startPos
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
    if input == dragInput and dragging then updateInput(input) end
end)

-- ── FLOATING "V" TOGGLE BUTTON ──────────────────────────────────────────────
local floatingToggle = Instance.new("TextButton", ScreenGui)
floatingToggle.Name = "FloatingToggle"
floatingToggle.Size = UDim2.new(0, 60, 0, 60)
floatingToggle.Position = UDim2.new(1, -90, 1, -90)
floatingToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
floatingToggle.Text = "S"
floatingToggle.Font = Enum.Font.GothamBold
floatingToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
floatingToggle.TextSize = 32
floatingToggle.BorderSizePixel = 0
floatingToggle.AutoButtonColor = false

local ftCorner = Instance.new("UICorner", floatingToggle)
ftCorner.CornerRadius = UDim.new(1, 0)

local ftStroke = Instance.new("UIStroke", floatingToggle)
ftStroke.Color = Color3.fromRGB(255, 85, 85)
ftStroke.Thickness = 2.5
ftStroke.Transparency = 0.2

floatingToggle.MouseButton1Click:Connect(function()
    if getgenv().autofarmDisabledByAdmin then return end
    toggleAutofarm(not getgenv().autofarm)
end)

-- Draggable floating button
local fDragging, fDragInput, fDragStart, fStartPos
local function fUpdate(input)
    local delta = input.Position - fDragStart
    floatingToggle.Position = UDim2.new(fStartPos.X.Scale, fStartPos.X.Offset + delta.X, fStartPos.Y.Scale, fStartPos.Y.Offset + delta.Y)
end

floatingToggle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        fDragging = true
        fDragStart = input.Position
        fStartPos = floatingToggle.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then fDragging = false end
        end)
    end
end)

floatingToggle.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        fDragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == fDragInput and fDragging then fUpdate(input) end
end)

-- Animate open
MainFrame.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 500, 0, 370)}):Play()

print("Sphyn Hub loaded")
print("https://discord.gg/nQmhZVbG7v")
print("join for more updates and to report bugs")