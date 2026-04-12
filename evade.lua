
-- ┌─────────────────────────────────────────────────────────────┐
-- │                   MAIN HUB SCRIPT STARTS HERE               │
-- └─────────────────────────────────────────────────────────────┘
repeat task.wait() until game:IsLoaded()

local Players              = game:GetService("Players")
local ReplicatedStorage    = game:GetService("ReplicatedStorage")
local UserInputService     = game:GetService("UserInputService")
local TweenService         = game:GetService("TweenService")
local RunService           = game:GetService("RunService")
local VirtualUser          = game:GetService("VirtualUser")
local Workspace            = game:GetService("Workspace")
local CoreGui              = game:GetService("CoreGui")
local LocalPlayer          = Players.LocalPlayer

-- Clear previous UI
if CoreGui:FindFirstChild("ZenithReplica") then
    CoreGui.ZenithReplica:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZenithReplica"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

local viewSize = workspace.CurrentCamera.ViewportSize
local baseWidth = math.clamp(viewSize.X * 0.65, 380, 620)
local baseHeight = math.clamp(viewSize.Y * 0.68, 280, 460)
local scaleFactor = 1

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, baseWidth, 0, baseHeight)
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
TitleText.Name = "TitleText"
TitleText.Parent = TitleBar
TitleText.Size = UDim2.new(1, -60, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "Sphyn Hub"
TitleText.Font = Enum.Font.GothamBold
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 18
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.TextScaled = true

-- Close Button (your updated version kept)
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = TitleBar
CloseButton.AnchorPoint = Vector2.new(1, 0.5)
CloseButton.Position = UDim2.new(1, -12, 0.5, 0)
CloseButton.Size = UDim2.new(0, 32, 0, 32)
CloseButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
CloseButton.Text = "✕"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18
CloseButton.BorderSizePixel = 0
CloseButton.Active = true
CloseButton.ZIndex = 20

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    print("X button clicked - hiding GUI")
    TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Rotation = 8
    }):Play()

    TweenService:Create(MainStroke, TweenInfo.new(0.35), {Transparency = 1}):Play()

    task.delay(0.4, function()
        MainFrame.Visible = false
        MainFrame.Rotation = 0
        MainFrame.Size = UDim2.new(0, baseWidth * scaleFactor, 0, baseHeight * scaleFactor)
        MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        MainStroke.Transparency = 0
    end)
end)

CloseButton.MouseEnter:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}):Play()
end)

CloseButton.MouseLeave:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
end)

-- Separator + Content + Tabs + all the rest of your code remains unchanged below this point...
-- (paste the rest of your original script from -- Separator onward here)

-- Separator
local Separator = Instance.new("Frame")
Separator.Parent = MainFrame
Separator.Position = UDim2.new(0, 0, 0, 45)
Separator.Size = UDim2.new(1, 0, 0, 2)
Separator.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
Separator.BorderSizePixel = 0

repeat task.wait() until game:IsLoaded()

local Players              = game:GetService("Players")
local ReplicatedStorage    = game:GetService("ReplicatedStorage")
local UserInputService     = game:GetService("UserInputService")
local TweenService         = game:GetService("TweenService")
local RunService           = game:GetService("RunService")
local VirtualUser          = game:GetService("VirtualUser")
local Workspace            = game:GetService("Workspace")
local CoreGui              = game:GetService("CoreGui")
local LocalPlayer          = Players.LocalPlayer

-- Clear previous UI
if CoreGui:FindFirstChild("ZenithReplica") then
    CoreGui.ZenithReplica:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZenithReplica"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

local viewSize = workspace.CurrentCamera.ViewportSize
local baseWidth = math.clamp(viewSize.X * 0.65, 380, 620)
local baseHeight = math.clamp(viewSize.Y * 0.68, 280, 460)
local scaleFactor = 1

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.Size = UDim2.new(0, baseWidth, 0, baseHeight)
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
TitleText.Name = "TitleText"
TitleText.Parent = TitleBar
TitleText.Size = UDim2.new(1, -60, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "Sphyn Hub"
TitleText.Font = Enum.Font.GothamBold
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 18
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.TextScaled = true

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = TitleBar
CloseButton.AnchorPoint = Vector2.new(1, 0.5)
CloseButton.Position = UDim2.new(1, -12, 0.5, 0)
CloseButton.Size = UDim2.new(0, 32, 0, 32)
CloseButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
CloseButton.Text = "✕"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18
CloseButton.BorderSizePixel = 0

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

-- Close Button (updated & cleaned - March 2026 fix)
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = TitleBar
CloseButton.AnchorPoint = Vector2.new(1, 0.5)
CloseButton.Position = UDim2.new(1, -12, 0.5, 0)
CloseButton.Size = UDim2.new(0, 32, 0, 32)
CloseButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
CloseButton.Text = "✕"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18
CloseButton.BorderSizePixel = 0
CloseButton.Active = true          -- Critical: allows input
CloseButton.ZIndex = 20            -- Makes sure it's clickable

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

-- Close logic - hide instead of destroy (recommended for toggle button compatibility)
CloseButton.MouseButton1Click:Connect(function()
    print("X button clicked - hiding GUI")  -- debug

    -- Collapse animation
    TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Rotation = 8
    }):Play()

    TweenService:Create(MainStroke, TweenInfo.new(0.35), {
        Transparency = 1
    }):Play()

    task.delay(0.4, function()
        MainFrame.Visible = false
        -- Reset for next open
        MainFrame.Rotation = 0
        MainFrame.Size = UDim2.new(0, baseWidth * scaleFactor, 0, baseHeight * scaleFactor)  -- use your original size vars
        MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        MainStroke.Transparency = 0
    end)
end)

-- Hover effect
CloseButton.MouseEnter:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.18), {
        BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    }):Play()
end)

CloseButton.MouseLeave:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.18), {
        BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    }):Play()
end)

-- Separator
local Separator = Instance.new("Frame")
Separator.Parent = MainFrame
Separator.Position = UDim2.new(0, 0, 0, 45)
Separator.Size = UDim2.new(1, 0, 0, 2)
Separator.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
Separator.BorderSizePixel = 0

-- Content Area
local Content = Instance.new("Frame")
Content.Parent = MainFrame
Content.Position = UDim2.new(0, 20, 0, 55)
Content.Size = UDim2.new(1, -40, 1, -65)
Content.BackgroundTransparency = 1

-- Tab Buttons Frame
local TabFrame = Instance.new("Frame")
TabFrame.Parent = Content
TabFrame.Size = UDim2.new(1, 0, 0, 38)
TabFrame.BackgroundTransparency = 1

-- Tab Content Frames (Scrolling)
local function CreateTabContent(name)
    local sc = Instance.new("ScrollingFrame")
    sc.Name = name .. "Content"
    sc.Parent = Content
    sc.Position = UDim2.new(0, 0, 0, 45)
    sc.Size = UDim2.new(1, 0, 1, -45)
    sc.BackgroundTransparency = 1
    sc.ScrollBarThickness = 3
    sc.ScrollBarImageColor3 = Color3.fromRGB(255, 85, 85)
    sc.CanvasSize = UDim2.new(0, 0, 0, 800)
    sc.Visible = false

    local list = Instance.new("UIListLayout")
    list.Parent = sc
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding = UDim.new(0, 10)
    list.HorizontalAlignment = Enum.HorizontalAlignment.Center

    return sc
end

local PlayerContent = CreateTabContent("Player")
local AutoContent   = CreateTabContent("Auto")
local EspContent    = CreateTabContent("Esp")
local MiscContent   = CreateTabContent("Misc")
local SettingsContent = CreateTabContent("Settings")

PlayerContent.Visible = true  -- default tab

-- Tab Buttons
local tabButtons = {}
local tabContents = {
    Player   = PlayerContent,
    Auto     = AutoContent,
    ESP      = EspContent,
    Misc     = MiscContent,
    Settings = SettingsContent
}

local xOffset = 0
for name in pairs(tabContents) do
    local btn = Instance.new("TextButton")
    btn.Name = name .. "Tab"
    btn.Parent = TabFrame
    btn.Size = UDim2.new(0, 90, 1, -4)
    btn.Position = UDim2.new(0, xOffset, 0, 2)
    btn.BackgroundColor3 = (name == "Player") and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(28, 28, 28)
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = name
    btn.TextColor3 = (name == "Player") and Color3.fromRGB(255,255,255) or Color3.fromRGB(180,180,180)
    btn.TextSize = 14
    btn.AutoButtonColor = false

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    table.insert(tabButtons, btn)
    xOffset += 98

    btn.MouseButton1Click:Connect(function()
        for _, content in pairs(tabContents) do
            content.Visible = false
        end
        tabContents[name].Visible = true

        for _, b in ipairs(tabButtons) do
            b.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
            b.TextColor3 = Color3.fromRGB(180,180,180)
        end
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        btn.TextColor3 = Color3.fromRGB(255,255,255)
    end)

    -- Hover
    btn.MouseEnter:Connect(function()
        if btn.BackgroundColor3 ~= Color3.fromRGB(40,40,40) then
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(50,50,50)}):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if btn.BackgroundColor3 ~= Color3.fromRGB(40,40,40) then
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(28,28,28)}):Play()
        end
    end)
end

local UserInputService = game:GetService("UserInputService")

local MainFrame = ScreenGui:WaitForChild("MainFrame")     -- reference your main window
local TitleBar   = MainFrame:WaitForChild("TitleBar")     -- the part you drag from

local dragging = false
local dragInput = nil
local dragStart = nil
local startPos = nil

-- Update position function
local function updateDrag(input)
    if not dragging then return end
    
    local delta = input.Position - dragStart
    local newX = startPos.X.Offset + delta.X
    local newY = startPos.Y.Offset + delta.Y
    
    -- Optional: clamp to screen edges (prevents dragging off-screen)
    local screenSize = workspace.CurrentCamera.ViewportSize
    local frameSize = MainFrame.AbsoluteSize
    
    newX = math.clamp(newX, frameSize.X / 2, screenSize.X - frameSize.X / 2)
    newY = math.clamp(newY, frameSize.Y / 2, screenSize.Y - frameSize.Y / 2)
    
    MainFrame.Position = UDim2.new(0, newX, 0, newY)
end

-- Start dragging
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 
       or input.UserInputType == Enum.UserInputType.Touch then
        
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        -- Clean up when input ends
        local conn
        conn = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                conn:Disconnect()
            end
        end)
    end
end)

-- Track movement
TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement 
       or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

-- Global input changed (handles the actual movement)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput then
        updateDrag(input)
    end
end)

-- ──────────────────────────────────────────────────────────────
-- VARIABLES
-- ──────────────────────────────────────────────────────────────

local ValueSpeed = 16
local ActiveCFrameSpeedBoost = false
local cframeSpeedConnection = nil
local IsHoldingSpace = false
local bhopEnabled = false
local ButtonGui
local InputConnections = {}
local IsHoldingButton = false
local afk = true
local selectedMapNumber = 1
local autoVoteEnabled = false
local voteConnection = nil
local ActiveEspPlayers = false
local ActiveEspBots = false
local ActiveDistanceEsp = false
local playerAddedConnection = nil
local botLoopConnection = nil
local autoReviveEnabled = false
local lastCheckTime = 0
local checkInterval = 5

local originalBrightness      = game.Lighting.Brightness
local originalOutdoorAmbient  = game.Lighting.OutdoorAmbient
local originalAmbient         = game.Lighting.Ambient
local originalGlobalShadows   = game.Lighting.GlobalShadows
local originalFogEnd          = game.Lighting.FogEnd
local originalFogStart        = game.Lighting.FogStart
local originalColorCorrectionEnabled = game.Lighting.ColorCorrection.Enabled
local originalSaturation      = game.Lighting.ColorCorrection.Saturation
local originalContrast        = game.Lighting.ColorCorrection.Contrast

-- ──────────────────────────────────────────────────────────────
-- HELPER FUNCTIONS
-- ──────────────────────────────────────────────────────────────

local function fireVoteServer(num)
    local events = ReplicatedStorage:FindFirstChild("Events")
    if events then
        local pf = events:FindFirstChild("Player")
        if pf then
            local vote = pf:FindFirstChild("Vote")
            if vote and vote:IsA("RemoteEvent") then
                vote:FireServer(num)
            end
        end
    end
end

local function applyFullBrightness()
    game.Lighting.Brightness = 2
    game.Lighting.OutdoorAmbient = Color3.fromRGB(255,255,255)
    game.Lighting.Ambient = Color3.fromRGB(255,255,255)
    game.Lighting.GlobalShadows = false
end

local function removeFullBrightness()
    game.Lighting.Brightness = originalBrightness
    game.Lighting.OutdoorAmbient = originalOutdoorAmbient
    game.Lighting.Ambient = originalAmbient
    game.Lighting.GlobalShadows = originalGlobalShadows
end

local function applySuperFullBrightness()
    game.Lighting.Brightness = 15
    game.Lighting.OutdoorAmbient = Color3.fromRGB(255,255,255)
    game.Lighting.Ambient = Color3.fromRGB(255,255,255)
    game.Lighting.GlobalShadows = false
end

local function applyNoFog()
    game.Lighting.FogEnd = 1000000
    game.Lighting.FogStart = 999999
end

local function removeNoFog()
    game.Lighting.FogEnd = originalFogEnd
    game.Lighting.FogStart = originalFogStart
end

local function applyVibrant()
    game.Lighting.ColorCorrection.Enabled = true
    game.Lighting.ColorCorrection.Saturation = 0.8
    game.Lighting.ColorCorrection.Contrast = 0.4
end

local function removeVibrant()
    game.Lighting.ColorCorrection.Enabled = originalColorCorrectionEnabled
    game.Lighting.ColorCorrection.Saturation = originalSaturation
    game.Lighting.ColorCorrection.Contrast = originalContrast
end

local function getLocalPlayerCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function CreateEsp(Char, Color, Text, ParentPart, YOffset)
    if not Char or not ParentPart or not ParentPart:IsA("BasePart") then return end
    if Char:FindFirstChild("ESP_Highlight") then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.Adornee = Char
    highlight.FillColor = Color
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = Char

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP"
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, YOffset, 0)
    billboard.Adornee = ParentPart
    billboard.Parent = ParentPart

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.Text = Text
    label.TextColor3 = Color
    label.TextScaled = true
    label.Font = Enum.Font.SourceSansBold
    label.Parent = billboard

    task.spawn(function()
        local cam = workspace.CurrentCamera
        while highlight.Parent and billboard.Parent do
            local dist = (cam.CFrame.Position - ParentPart.Position).Magnitude
            label.Text = ActiveDistanceEsp and (Text .. " [" .. math.floor(dist + 0.5) .. "m]") or Text
            task.wait(0.15)
        end
        highlight:Destroy()
        billboard:Destroy()
    end)
end

local function RemoveEsp(Char, ParentPart)
    if Char then
        local h = Char:FindFirstChild("ESP_Highlight")
        if h then h:Destroy() end
    end
    if ParentPart then
        local b = ParentPart:FindFirstChild("ESP")
        if b then b:Destroy() end
    end
end

local function handlePlayerEsp(player)
    if player == LocalPlayer then return end
    local function addEsp(char)
        if ActiveEspPlayers and char:FindFirstChild("Head") then
            CreateEsp(char, Color3.fromRGB(100,255,100), player.Name, char.Head, 3)
        end
    end
    if player.Character then addEsp(player.Character) end
    player.CharacterAdded:Connect(addEsp)
    player.CharacterRemoving:Connect(function(old) RemoveEsp(old, old:FindFirstChild("Head")) end)
end

local function MobileBhopButton(Character)
    if ButtonGui then ButtonGui:Destroy() end

    local sg = Instance.new("ScreenGui")
    sg.Name = "BhopGui"
    sg.ResetOnSpawn = false
    sg.Parent = LocalPlayer.PlayerGui
    ButtonGui = sg

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,60,0,60)
    btn.Position = UDim2.new(0.92, -30, 0.82, -30)
    btn.BackgroundColor3 = Color3.fromRGB(40,200,40)
    btn.BackgroundTransparency = 0.4
    btn.Text = "Bhop"
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.Parent = sg

    local dragging, dragInput, mousePos, framePos
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            framePos = btn.Position
            IsHoldingButton = true
        end
    end)

    btn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            IsHoldingButton = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - mousePos
            btn.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)

    local hum = Character:WaitForChild("Humanoid")
    table.insert(InputConnections, RunService.RenderStepped:Connect(function()
        if IsHoldingButton and hum:GetState() ~= Enum.HumanoidStateType.Jumping then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end))
end

-- ──────────────────────────────────────────────────────────────
-- UI ELEMENT CREATORS
-- ──────────────────────────────────────────────────────────────

local function CreateToggle(parent, name, default, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.Size = UDim2.new(1,0,0,36)
    frame.BackgroundColor3 = Color3.fromRGB(30,30,30)

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,8)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,-50,1,0)
    label.Position = UDim2.new(0,12,0,0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(220,220,220)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local tog = Instance.new("TextButton")
    tog.Size = UDim2.new(0,34,0,18)
    tog.Position = UDim2.new(1,-44,0.5,0)
    tog.AnchorPoint = Vector2.new(1,0.5)
    tog.BackgroundColor3 = default and Color3.fromRGB(255,85,85) or Color3.fromRGB(60,60,60)
    tog.Text = ""
    tog.AutoButtonColor = false
    tog.Parent = frame

    local togCorner = Instance.new("UICorner")
    togCorner.CornerRadius = UDim.new(1,0)
    togCorner.Parent = tog

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(0,14,0,14)
    circle.Position = default and UDim2.new(0,18,0.5,0) or UDim2.new(0,4,0.5,0)
    circle.AnchorPoint = Vector2.new(0,0.5)
    circle.BackgroundColor3 = Color3.fromRGB(255,255,255)
    circle.Parent = tog

    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1,0)
    circleCorner.Parent = circle

    local state = default

    tog.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(tog, TweenInfo.new(0.22), {BackgroundColor3 = state and Color3.fromRGB(255,85,85) or Color3.fromRGB(60,60,60)}):Play()
        TweenService:Create(circle, TweenInfo.new(0.22, Enum.EasingStyle.Quad), {Position = state and UDim2.new(0,18,0.5,0) or UDim2.new(0,4,0.5,0)}):Play()
        callback(state)
    end)

    return frame
end

local function CreateButton(parent, name, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.Size = UDim2.new(1,0,0,38)
    btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(240,240,240)
    btn.TextSize = 14
    btn.AutoButtonColor = false

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,8)
    c.Parent = btn

    btn.MouseButton1Click:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(55,55,55)}):Play()
        task.delay(0.12, function()
            TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(35,35,35)}):Play()
        end)
        callback()
    end)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(50,50,50)}):Play()
    end)

    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(35,35,35)}):Play()
    end)
end

local function CreateSlider(parent, name, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.Size = UDim2.new(1,0,0,50)
    frame.BackgroundColor3 = Color3.fromRGB(30,30,30)

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,8)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,-70,0,20)
    label.Position = UDim2.new(0,12,0,6)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. default
    label.TextColor3 = Color3.fromRGB(220,220,220)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1,-24,0,6)
    bar.Position = UDim2.new(0,12,1,-12)
    bar.BackgroundColor3 = Color3.fromRGB(50,50,50)
    bar.Parent = frame

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0,3)
    barCorner.Parent = bar

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default-min)/(max-min), 0, 1,0)
    fill.BackgroundColor3 = Color3.fromRGB(255,85,85)
    fill.Parent = bar

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0,3)
    fillCorner.Parent = fill

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0,16,0,16)
    knob.Position = UDim2.new((default-min)/(max-min),0,0.5,0)
    knob.AnchorPoint = Vector2.new(0.5,0.5)
    knob.BackgroundColor3 = Color3.fromRGB(255,85,85)
    knob.Parent = bar

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1,0)
    knobCorner.Parent = knob

    local dragging = false

    local function update(posX)
        local ratio = math.clamp((posX - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * ratio + 0.5)
        fill.Size = UDim2.new(ratio,0,1,0)
        knob.Position = UDim2.new(ratio,0,0.5,0)
        label.Text = name .. ": " .. val
        callback(val)
    end

    knob.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)

    knob.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            update(inp.Position.X)
        end
    end)

    -- initial
    update(bar.AbsolutePosition.X + (default-min)/(max-min) * bar.AbsoluteSize.X)

    return frame
end

-- ──────────────────────────────────────────────────────────────
-- CREATE UI ELEMENTS
-- ──────────────────────────────────────────────────────────────

-- Player Tab
CreateSlider(PlayerContent, "Walk Speed", 1, 50, 16, function(v)
    ValueSpeed = v
end)

CreateToggle(PlayerContent, "CFrame Speed Boost", false, function(state)
    ActiveCFrameSpeedBoost = state
    if state then
        if cframeSpeedConnection then cframeSpeedConnection:Disconnect() end
        cframeSpeedConnection = RunService.RenderStepped:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.MoveDirection.Magnitude > 0 then
                hrp.CFrame += hum.MoveDirection * ValueSpeed * 0.08
            end
        end)
    else
        if cframeSpeedConnection then
            cframeSpeedConnection:Disconnect()
            cframeSpeedConnection = nil
        end
    end
end)

CreateToggle(PlayerContent, "Auto Bhop (hold space)", false, function(v)
    bhopEnabled = v
end)

CreateButton(PlayerContent, "Mobile Bhop Button", function()
    if LocalPlayer.Character then
        MobileBhopButton(LocalPlayer.Character)
    end
end)

CreateSlider(PlayerContent, "Jump Power", 0, 1000, 50, function(v)
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.JumpPower = v end
end)

CreateSlider(PlayerContent, "Gravity", 0, 1000, 196, function(v)
    Workspace.Gravity = v
end)

-- Auto Tab
CreateButton(AutoContent, "Vote Map 1", function() selectedMapNumber = 1 fireVoteServer(1) end)
CreateButton(AutoContent, "Vote Map 2", function() selectedMapNumber = 2 fireVoteServer(2) end)
CreateButton(AutoContent, "Vote Map 3", function() selectedMapNumber = 3 fireVoteServer(3) end)
CreateButton(AutoContent, "Vote Map 4", function() selectedMapNumber = 4 fireVoteServer(4) end)

CreateToggle(AutoContent, "Auto Vote (selected map)", false, function(v)
    autoVoteEnabled = v
    if v then
        if voteConnection then voteConnection:Disconnect() end
        voteConnection = RunService.Heartbeat:Connect(function()
            fireVoteServer(selectedMapNumber)
        end)
    else
        if voteConnection then voteConnection:Disconnect() end
    end
end)

CreateButton(AutoContent, "Revive Yourself", function()
    local char = LocalPlayer.Character
    if char and char:GetAttribute("Downed") then
        ReplicatedStorage.Events.Player.ChangePlayerMode:FireServer(true)
    end
end)

CreateToggle(AutoContent, "Auto Revive", false, function(v)
    autoReviveEnabled = v
end)

-- ESP Tab
CreateToggle(EspContent, "Players ESP", false, function(v)
    ActiveEspPlayers = v
    if v then
        for _, plr in ipairs(Players:GetPlayers()) do
            handlePlayerEsp(plr)
        end
        playerAddedConnection = Players.PlayerAdded:Connect(handlePlayerEsp)
    else
        if playerAddedConnection then playerAddedConnection:Disconnect() end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character then
                RemoveEsp(plr.Character, plr.Character:FindFirstChild("Head"))
            end
        end
    end
end)

CreateToggle(EspContent, "NextBots ESP", false, function(v)
    ActiveEspBots = v
    if v then
        botLoopConnection = RunService.Heartbeat:Connect(function()
            local gameFolder = Workspace:FindFirstChild("Game")
            if gameFolder then
                local bots = gameFolder:FindFirstChild("Players")
                if bots then
                    for _, bot in ipairs(bots:GetChildren()) do
                        if bot:IsA("Model") and bot:FindFirstChild("Hitbox") then
                            CreateEsp(bot, Color3.fromRGB(255,80,80), bot.Name or "Bot", bot.Hitbox, -1.5)
                        end
                    end
                end
            end
        end)
    else
        if botLoopConnection then botLoopConnection:Disconnect() end
        -- cleanup existing
        local gameFolder = Workspace:FindFirstChild("Game")
        if gameFolder and gameFolder:FindFirstChild("Players") then
            for _, bot in ipairs(gameFolder.Players:GetChildren()) do
                if bot:IsA("Model") and bot:FindFirstChild("Hitbox") then
                    RemoveEsp(bot, bot.Hitbox)
                end
            end
        end
    end
end)

CreateToggle(EspContent, "Show Distance", false, function(v)
    ActiveDistanceEsp = v
end)

-- Misc Tab
CreateToggle(MiscContent, "Anti-AFK", true, function(v)
    afk = v
end)

CreateToggle(MiscContent, "Full Brightness", false, function(v)
    if v then applyFullBrightness() else removeFullBrightness() end
end)

CreateToggle(MiscContent, "Super Brightness", false, function(v)
    if v then applySuperFullBrightness() else removeFullBrightness() end
end)

CreateToggle(MiscContent, "No Fog", false, function(v)
    if v then applyNoFog() else removeNoFog() end
end)

CreateToggle(MiscContent, "Vibrant Colors", false, function(v)
    if v then applyVibrant() else removeVibrant() end
end)

-- Settings Tab
CreateSlider(SettingsContent, "GUI Scale", 60, 140, 100, function(value)
    local scale = value / 100
    TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, baseWidth * scale, 0, baseHeight * scale)
    }):Play()
end)

-- ──────────────────────────────────────────────────────────────
-- PERSISTENT LOGIC & CONNECTIONS
-- ──────────────────────────────────────────────────────────────

-- Auto Revive
RunService.Heartbeat:Connect(function()
    if autoReviveEnabled and tick() - lastCheckTime >= checkInterval then
        lastCheckTime = tick()
        local char = LocalPlayer.Character
        if char and char:GetAttribute("Downed") then
            ReplicatedStorage.Events.Player.ChangePlayerMode:FireServer(true)
        end
    end
end)

-- Bhop - hold space
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Space then
        IsHoldingSpace = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Space then
        IsHoldingSpace = false
    end
end)

-- Auto jump when landed + holding space
local function setupBhop(humanoid)
    humanoid.StateChanged:Connect(function(old, new)
        if new == Enum.HumanoidStateType.Landed and IsHoldingSpace and bhopEnabled then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end

if LocalPlayer.Character then
    local hum = LocalPlayer.Character:WaitForChild("Humanoid")
    setupBhop(hum)
end

LocalPlayer.CharacterAdded:Connect(function(char)
    local hum = char:WaitForChild("Humanoid")
    setupBhop(hum)
    -- re-create mobile button if needed
    if IsHoldingButton then
        MobileBhopButton(char)
    end
end)

-- Anti-AFK
task.spawn(function()
    while afk do
        VirtualUser:Button2Down(Vector2.new())
        task.wait(0.1)
        VirtualUser:Button2Up(Vector2.new())
        task.wait(60)
    end
end)

-- Cleanup on character remove
LocalPlayer.CharacterRemoving:Connect(function()
    if ButtonGui then ButtonGui:Destroy() ButtonGui = nil end
    for _, c in ipairs(InputConnections) do c:Disconnect() end
    InputConnections = {}
end)
-- ──────────────────────────────────────────────────────────────
-- Floating Toggle Button – FIXED + Requested style
-- bigger red circle, always "V", draggable, toggles main GUI visibility
-- ──────────────────────────────────────────────────────────────

local ToggleGui = Instance.new("ScreenGui")
ToggleGui.Name = "ZenithToggleGui"
ToggleGui.Parent = CoreGui
ToggleGui.ResetOnSpawn = false
ToggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ToggleGui.IgnoreGuiInset = true

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = ToggleGui
ToggleButton.Size = UDim2.new(0, 70, 0, 70)           -- bigger
ToggleButton.Position = UDim2.new(0.05, 0, 0.85, 0)   -- bottom-left start
ToggleButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)   -- always red
ToggleButton.BorderSizePixel = 0
ToggleButton.Text = "S"                               -- always V
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 36                            -- bigger letter
ToggleButton.AutoButtonColor = false

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)            -- perfect circle
ToggleCorner.Parent = ToggleButton

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(255, 255, 255)
ToggleStroke.Thickness = 2.5
ToggleStroke.Transparency = 0.3
ToggleStroke.Parent = ToggleButton

-- Slight hover/pressed effect (still red background)
ToggleButton.MouseEnter:Connect(function()
    TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(240, 70, 70)
    }):Play()
end)

ToggleButton.MouseLeave:Connect(function()
    TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
        BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    }):Play()
end)

-- Dragging (PC mouse + mobile touch)
local draggingToggle = false
local dragInputToggle = nil
local dragStartToggle = nil
local startPosToggle = nil

local function updateToggleDrag(input)
    if not draggingToggle then return end
    
    local delta = input.Position - dragStartToggle
    local newX = startPosToggle.X.Offset + delta.X
    local newY = startPosToggle.Y.Offset + delta.Y
    
    local screen = workspace.CurrentCamera.ViewportSize
    local btnSize = ToggleButton.AbsoluteSize
    
    newX = math.clamp(newX, btnSize.X / 2, screen.X - btnSize.X / 2)
    newY = math.clamp(newY, btnSize.Y / 2, screen.Y - btnSize.Y / 2)
    
    ToggleButton.Position = UDim2.new(0, newX, 0, newY)
end

ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 
       or input.UserInputType == Enum.UserInputType.Touch then
        
        draggingToggle = true
        dragStartToggle = input.Position
        startPosToggle = ToggleButton.Position
        
        local conn
        conn = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingToggle = false
                conn:Disconnect()
            end
        end)
    end
end)

ToggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement 
       or input.UserInputType == Enum.UserInputType.Touch then
        dragInputToggle = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInputToggle then
        updateToggleDrag(input)
    end
end)

-- Toggle main GUI visibility on tap/click
ToggleButton.MouseButton1Click:Connect(function()
    -- Toggle visibility
    MainFrame.Visible = not MainFrame.Visible
    
    -- Optional: slight scale feedback when pressed
    TweenService:Create(ToggleButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0, 64, 0, 64)
    }):Play()
    task.delay(0.1, function()
        TweenService:Create(ToggleButton, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 70, 0, 70)
        }):Play()
    end)
end)

-- Make sure main GUI starts visible
MainFrame.Visible = true

print("Sphyn Hub loaded")
print("https://discord.gg/nQmhZVbG7v")
print("join for more updates and to report bugs")