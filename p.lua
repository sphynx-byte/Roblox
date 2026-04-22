--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
--[[
    Nexus Tracker v10.0 – Advanced ESP, LOD, Auto Teleport, Enhanced Favorites, Debug
    Combined with Death Return, P bind removed.
    PART 1/4
]]

local function tableFind(t, value)
    for i, v in ipairs(t) do
        if v == value then return i end
    end
    return nil
end

local Settings = {
    UPDATE_INTERVAL = 0.05,
    LIST_UPDATE_INTERVAL = 0.5,
    MAX_DISTANCE = 15000,
    FADE_START_DISTANCE = 300,
    NOTIFICATION_DURATION = 5,
    TELEPORT_RANGE = 15000,
    SOUND_ENABLED = true,
    SOUND_VOLUME = 1,
    NOTIFICATION_POSITION = "CenterTop",
    HIDE_NEAR_DISTANCE = 20,          -- if closer than this distance, ESP becomes transparent
    MOBILE_SCALE = 1.5,               -- scale factor on mobile
    VISUAL_BOSS_BYPASS_LOD = true,     -- bosses always show full info

    -- Colors
    PRIMARY_COLOR = Color3.fromRGB(0, 184, 255),
    SECONDARY_COLOR = Color3.fromRGB(147, 112, 255),
    TEXT_COLOR = Color3.fromRGB(255, 255, 255),
    BACKGROUND_COLOR = Color3.fromRGB(20, 20, 30),
    BACKGROUND_TRANSPARENCY = 0.7,
    GLOW_COLOR = Color3.fromRGB(100, 200, 255),
    NOTIFICATION_COLOR = Color3.fromRGB(46, 204, 113),
    TELEPORT_COLOR = Color3.fromRGB(241, 196, 15),
    TOGGLE_COLOR = Color3.fromRGB(52, 152, 219),
    DISABLED_COLOR = Color3.fromRGB(231, 76, 60),
    LIST_COLOR = Color3.fromRGB(30, 40, 50),
    LIST_HOVER_COLOR = Color3.fromRGB(40, 50, 70),
    FAVORITE_COLOR = Color3.fromRGB(255, 215, 0),
    ESP_ENABLED_COLOR = Color3.fromRGB(46, 204, 113),
    ESP_DISABLED_COLOR = Color3.fromRGB(150, 150, 150),
    
    -- Death return settings
    DEATH_RETURN_ENABLED = false,
    DEATH_ANIMATION_ID = "87316561339285",
    
    -- ========== NEW SETTINGS ==========
    -- Visuals (item 2)
    VISUAL_COLORS = {
        Boss = Color3.fromRGB(255, 100, 0),
        Sukuna = Color3.fromRGB(255, 100, 0),
        Crate = Color3.fromRGB(210, 180, 140),
        Portal = Color3.fromRGB(150, 0, 255),
        Tool = Color3.fromRGB(100, 100, 200),
        Note = Color3.fromRGB(240, 200, 80),
    },
    VISUAL_SIZE_SCALE = 1.0,
    VISUAL_TRANSPARENCY = 0.7,
    VISUAL_ICON_ONLY_THRESHOLD = 7,    -- when object count exceeds this, icon-only mode activates
    VISUAL_LOD_ENABLED = false,          -- will be set in init depending on platform
    VISUAL_LOD_DIST_ICON = 1000,
    VISUAL_LOD_DIST_BRIEF = 500,
    VISUAL_FRUSTUM_CULLING = false,
    
    -- Auto Teleport (item 10)
    AUTO_TELEPORT_ENABLED = false,
    AUTO_TELEPORT_DELAY = 2,
    AUTO_TELEPORT_WARNING = true,
    
    -- Favorites (item 14)
    FAVORITE_GROUPS = { "Main" },
    FAVORITE_ACTIVE_GROUP = 1,
    FAVORITE_AUTO_KEYWORDS = {},          -- list of keywords for auto-favorite
    AUTO_FAVORITE_NAMES = {},
    
    -- Debug (item 15)
    DEBUG_MODE = false,
    DEBUG_SHOW_PATHS = false,
}

-- ========== STYLES FOR DIFFERENT OBJECT TYPES ==========
local TypeStyles = {
    Boss = {
        Background = Color3.fromRGB(40, 20, 20),
        Header = Settings.VISUAL_COLORS.Boss,
        Glow = Color3.fromRGB(255, 50, 0),
        Icon = "💀",
        TextColor = Color3.fromRGB(255, 255, 255),
        HasHealthBar = true,
        HasSkull = true,
        PulseOutline = true,
        HeaderGradient = {Settings.VISUAL_COLORS.Boss, Color3.fromRGB(200, 50, 0)},
        HealthBarColor = Color3.fromRGB(255, 70, 70),
        ExtraIconAnimation = true,
        Compact = true,
    },
    Sukuna = {
        Background = Color3.fromRGB(40, 20, 20),
        Header = Settings.VISUAL_COLORS.Sukuna,
        Glow = Color3.fromRGB(255, 50, 0),
        Icon = "💀",
        TextColor = Color3.fromRGB(255, 255, 255),
        HasHealthBar = true,
        HasSkull = true,
        PulseOutline = true,
        HeaderGradient = {Settings.VISUAL_COLORS.Sukuna, Color3.fromRGB(200, 50, 0)},
        HealthBarColor = Color3.fromRGB(255, 70, 70),
        ExtraIconAnimation = true,
        Compact = true,
    },
    Crate = {
        Background = Color3.fromRGB(40, 30, 20),
        Header = Settings.VISUAL_COLORS.Crate,
        Glow = Color3.fromRGB(160, 120, 80),
        Icon = "📦",
        TextColor = Color3.fromRGB(255, 255, 255),
        HeaderGradient = {Settings.VISUAL_COLORS.Crate, Color3.fromRGB(160, 120, 80)},
    },
    Portal = {
        Background = Color3.fromRGB(20, 0, 40),
        Header = Settings.VISUAL_COLORS.Portal,
        Glow = Color3.fromRGB(200, 0, 255),
        Icon = "🌀",
        TextColor = Color3.fromRGB(255, 255, 255),
        HeaderGradient = {Settings.VISUAL_COLORS.Portal, Color3.fromRGB(200, 0, 255)},
    },
    Tool = {
        Background = Color3.fromRGB(30, 30, 40),
        Header = Settings.VISUAL_COLORS.Tool,
        Glow = Color3.fromRGB(80, 80, 180),
        Icon = "🛠️",
        TextColor = Color3.fromRGB(255, 255, 255),
        HeaderGradient = {Settings.VISUAL_COLORS.Tool, Color3.fromRGB(70, 70, 150)},
    },
    Note = {
        Background = Color3.fromRGB(50, 40, 20),
        Header = Settings.VISUAL_COLORS.Note,
        Glow = Color3.fromRGB(200, 160, 40),
        Icon = "📝",
        TextColor = Color3.fromRGB(255, 255, 255),
        HeaderGradient = {Settings.VISUAL_COLORS.Note, Color3.fromRGB(180, 140, 40)},
    }
}

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

-- File system check
local canSaveToFile = (writefile ~= nil and readfile ~= nil)
local SETTINGS_FILE = "NexusTracker_Settings.json"

-- ========== SPECIAL PATHS ==========
local SPECIAL_PATHS = {
    Boss = "Models.Chara",
    Sukuna = "Models.Sukuna",
    Crate = "Visuals.Crate",
    Portal = "Visuals.Portal"
}

local SPECIAL_NAMES = {
    Boss = "💀 Chara",
    Sukuna = "💀 Sukuna",
    Crate = "📦 Crate",
    Portal = "🌀 Mystic Portal"
}

local SPECIAL_ICONS = {
    Boss = "💀",
    Sukuna = "💀",
    Crate = "📦",
    Portal = "🌀"
}

-- ========== SOUNDS ==========
local SOUNDS = {
    BossSpawn = "rbxassetid://127863687687397",
    LowHealth = "rbxassetid://104973625032761",
    BossDeath = "rbxassetid://132722270251143",
    Teleport = "rbxassetid://4826619573",
    ButtonClick = "rbxassetid://93846959137150",
    ItemSpawn = "rbxassetid://5773338685"
}
local soundCache = {}

local function playSound(soundName)
    if not Settings.SOUND_ENABLED then return end
    local soundId = SOUNDS[soundName]
    if not soundId then return end
    if not soundCache[soundName] then
        local sound = Instance.new("Sound")
        sound.SoundId = soundId
        sound.Volume = Settings.SOUND_VOLUME
        sound.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
        soundCache[soundName] = sound
    else
        soundCache[soundName].Volume = Settings.SOUND_VOLUME
    end
    local sound = soundCache[soundName]
    sound:Stop()
    sound:Play()
end

-- ========== MAIN VARIABLES ==========
local TRACK_PATH = workspace:FindFirstChild("Visuals") or workspace
local SPECIFIC_MODEL_NAME = "Note"

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local objectCache = {}
local notifications = {}
local connections = {}
local teleportQueue = {}
local guiEnabled = true
local itemListGUI = nil
local itemListVisible = false
local settingsGUI = nil
local settingsVisible = false
local screenGui = nil
local notificationContainer = nil
local mainToggle = nil
local listToggle = nil
local settingsToggle = nil

-- Saved positions
local savedMainTogglePos = nil
local savedListTogglePos = nil
local savedSettingsTogglePos = nil
local savedItemListGUIPos = nil
local savedSettingsGUIPos = nil
local savedBossButtonPos = nil

-- Boss panel
local bossPanel = nil
local bossPanelVisible = false
local bossPanelButton = nil
local savedBossPanelPos = nil

-- Saved object states
local savedObjectFavorites = {}
local savedObjectESP = {}

-- List state
local listState = {
    filterType = "all",
    sortMode = "distance",
    sortAsc = true,
    searchText = ""
}

-- For boss tracking
local lastLowHealthTime = 0
local lastDeathTime = 0
local bossWasPresent = false

-- ========== VARIABLES FOR RETURN ==========
local lastPositionBeforeTeleport = nil

local lastBossSpawnNotification = 0
local BOSS_NOTIFICATION_COOLDOWN = 10
local lastBossType = nil

-- Mobile detection
local IS_MOBILE = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

-- Debug
local DEBUG = true  -- for script debugging
local function debugPrint(...)
    if DEBUG then
        print("[NexusTracker]", ...)
    end
end

local function debugLog(...)
    if Settings.DEBUG_MODE then
        print("[DEBUG]", ...)
    end
end

-- ========== DEATH RETURN VARIABLES ==========
local deathPosition = nil
local deathConnections = {}
local deathAnimationTrack = nil

-- ========== PATH LINES FOR DEBUG ==========
local pathLines = {}

-- ========== IMPROVED OBJECT SEARCH BY PATH ==========
local function getObjectFromPath(pathString)
    local current = workspace
    for part in string.gmatch(pathString, "[^%.]+") do
        current = current:FindFirstChild(part)
        if not current then break end
    end
    if current then return current end
    return workspace:FindFirstChild(pathString, true)
end

local function getSpecialType(obj)
    if not obj then return nil end
    local fullPath = obj:GetFullName()
    for sType, pathPattern in pairs(SPECIAL_PATHS) do
        if fullPath:find(pathPattern .. "$") or fullPath == pathPattern then
            return sType
        end
    end
    return nil
end

local function getObjectStyle(obj)
    if not TypeStyles then
        error("TypeStyles is nil! Check syntax at the beginning of the script.")
    end
    local specialType = getSpecialType(obj)
    if specialType then
        return TypeStyles[specialType] or TypeStyles.Tool
    elseif obj:IsA("Tool") then
        return TypeStyles.Tool
    elseif obj:IsA("Model") and obj.Name == SPECIFIC_MODEL_NAME then
        return TypeStyles.Note
    else
        return TypeStyles.Tool
    end
end

local function shouldTrackObject(object)
    if object:IsA("Tool") or (object:IsA("Model") and object.Name == SPECIFIC_MODEL_NAME) then
        return true
    end
    if getSpecialType(object) then
        return true
    end
    return false
end

local function createGradient(parent, color1, color2, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, color1), ColorSequenceKeypoint.new(1, color2)})
    gradient.Rotation = rotation or 90
    gradient.Parent = parent
    return gradient
end

local function getObjectPosition(object)
    if object:IsA("BasePart") then
        return object.Position
    elseif object:IsA("Model") then
        local data = objectCache[object]
        if data and data.tempPart and data.tempPart.Parent then
            return data.tempPart.Position
        end
        local primary = object.PrimaryPart
        if primary then return primary.Position end
        for _, descendant in ipairs(object:GetDescendants()) do
            if descendant:IsA("BasePart") then
                return descendant.Position
            end
        end
        return object:GetPivot().Position
    end
    return Vector3.new(0,0,0)
end

local function getDisplayName(object)
    local specialType = getSpecialType(object)
    if specialType then
        return SPECIAL_NAMES[specialType] or object.Name
    elseif object:IsA("Model") and object.Name == SPECIFIC_MODEL_NAME then
        return "📝 " .. object.Name
    elseif object:IsA("Tool") then
        return "🛠️ " .. object.Name
    end
    return object.Name
end

-- ========== RETURN FUNCTIONS ==========
local function savePositionBeforeTeleport()
    local character = LocalPlayer.Character
    if character then
        local root = character:FindFirstChild("HumanoidRootPart")
        if root then
            lastPositionBeforeTeleport = root.Position
        end
    end
end

local function teleportReturn()
    if not lastPositionBeforeTeleport then return false, "No saved position" end
    local character = LocalPlayer.Character
    if not character then return false, "No character" end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return false, "No HumanoidRootPart" end
    
    humanoidRootPart.CFrame = CFrame.new(lastPositionBeforeTeleport)
    lastPositionBeforeTeleport = nil
    return true, "Returned to previous position"
end

-- ========== DEATH RETURN FUNCTIONS ==========
local function stopAllAnimations(character)
    if not character then return end
    local humanoid = character:FindFirstChildWhichIsA("Humanoid")
    if not humanoid then return end
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if animator then
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            track:Stop()
        end
    end
    deathAnimationTrack = nil
end

local function playNewAnimation(character)
    if not character or not Settings.DEATH_RETURN_ENABLED then return end
    stopAllAnimations(character)
    local humanoid = character:FindFirstChildWhichIsA("Humanoid")
    if not humanoid then return end
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then
        animator = Instance.new("Animator")
        animator.Parent = humanoid
    end
    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://" .. Settings.DEATH_ANIMATION_ID
    local track = animator:LoadAnimation(animation)
    if track then
        track:Play()
        deathAnimationTrack = track
    end
end

local function saveDeathPosition()
    if not Settings.DEATH_RETURN_ENABLED then return false end
    local character = LocalPlayer.Character
    if character then
        local root = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso") or character:FindFirstChild("Head")
        if root then
            deathPosition = root.Position
            return true
        end
    end
    return false
end

local function teleportToDeathPosition()
    if not Settings.DEATH_RETURN_ENABLED or not deathPosition then return false, "No saved death position" end
    local character = LocalPlayer.Character
    if not character then return false, "No character" end
    local root = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
    if not root then return false, "No root part" end
    
    stopAllAnimations(character)
    root.CFrame = CFrame.new(deathPosition)
    playNewAnimation(character)
    deathPosition = nil
    return true, "Returned to death position"
end

local function setupMovementDetection(character)
    if not Settings.DEATH_RETURN_ENABLED then return end
    if deathConnections.movement then
        deathConnections.movement:Disconnect()
        deathConnections.movement = nil
    end
    deathConnections.movement = RunService.Heartbeat:Connect(function()
        if not Settings.DEATH_RETURN_ENABLED then return end
        local char = LocalPlayer.Character
        if not char then return end
        local humanoid = char:FindFirstChildWhichIsA("Humanoid")
        if humanoid and deathAnimationTrack and deathAnimationTrack.IsPlaying then
            if humanoid.MoveDirection.Magnitude > 0.1 then
                deathAnimationTrack:Stop()
                deathAnimationTrack = nil
            end
        end
    end)
end

local function enableDeathReturn(enable)
    if enable then
        if deathConnections.enabled then return end
        deathConnections.enabled = true
        
        if not deathConnections.characterAdded then
            deathConnections.characterAdded = LocalPlayer.CharacterAdded:Connect(function(character)
                if not Settings.DEATH_RETURN_ENABLED then return end
                if deathPosition then
                    task.wait(0.2)
                    teleportToDeathPosition()
                end
                task.wait(0.1)
                setupMovementDetection(character)
            end)
        end
        
        if LocalPlayer.Character then
            setupMovementDetection(LocalPlayer.Character)
        end
    else
        if not deathConnections.enabled then return end
        deathConnections.enabled = false
        
        if deathConnections.movement then
            deathConnections.movement:Disconnect()
            deathConnections.movement = nil
        end
        if deathConnections.characterAdded then
            deathConnections.characterAdded:Disconnect()
            deathConnections.characterAdded = nil
        end
        if deathAnimationTrack then
            deathAnimationTrack:Stop()
            deathAnimationTrack = nil
        end
        deathPosition = nil
    end
end

-- ========== TELEPORT ==========
local function teleportToObject(object)
    if not object or not object.Parent then return false, "Object no longer exists" end
    local character = LocalPlayer.Character
    if not character then return false, "No character" end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return false, "No HumanoidRootPart" end
    local objectPos = getObjectPosition(object)
    if objectPos == Vector3.new(0,0,0) then return false, "Cannot determine position" end
    local distance = (humanoidRootPart.Position - objectPos).Magnitude
    if distance > Settings.TELEPORT_RANGE then return false, "Too far (" .. math.floor(distance) .. " studs)" end
    
    savePositionBeforeTeleport()
    playSound("Teleport")
    
    teleportQueue[object] = true
    humanoidRootPart.CFrame = CFrame.new(objectPos + Vector3.new(0,3,0))
    task.wait(0.1)
    teleportQueue[object] = nil
    return true, "Teleported"
end

local function teleportToNearest()
    local character = LocalPlayer.Character
    if not character then return false, "No character" end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return false, "No HumanoidRootPart" end
    local nearestDist = math.huge
    local nearestObj = nil
    for obj, data in pairs(objectCache) do
        if obj and obj.Parent then
            local dist = (humanoidRootPart.Position - getObjectPosition(obj)).Magnitude
            if dist < nearestDist and dist <= Settings.TELEPORT_RANGE then
                nearestDist = dist
                nearestObj = obj
            end
        end
    end
    if nearestObj then return teleportToObject(nearestObj) end
    return false, "No objects in range"
end

-- ========== AUTO TELEPORT TO BOSS ==========
local function scheduleAutoTeleport(bossObj, bossType)
    if not Settings.AUTO_TELEPORT_ENABLED then return end
    if bossType ~= "Boss" and bossType ~= "Sukuna" then return end  -- only bosses
    
    task.delay(Settings.AUTO_TELEPORT_DELAY, function()
        if not Settings.AUTO_TELEPORT_ENABLED then return end
        if not bossObj or not bossObj.Parent then return end  -- boss disappeared
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
        
        if Settings.AUTO_TELEPORT_WARNING then
            createSpawnNotification("⚠️ Auto Teleport", "Teleporting to " .. SPECIAL_NAMES[bossType] .. " in 1 second...", nil, 1, Color3.fromRGB(255,200,0))
            task.wait(1)
        end
        
        local success, msg = teleportToObject(bossObj)
        if success then
            createSpawnNotification("✨ Auto Teleport", "Teleported to " .. SPECIAL_NAMES[bossType], nil, 2, Color3.fromRGB(100,255,100))
        else
            createSpawnNotification("❌ Auto Teleport", "Failed: " .. msg, nil, 3, Color3.fromRGB(255,100,100))
        end
    end)
end

-- ========== AUTO FAVORITE CHECK ==========
local function checkAutoFavorite(obj)
    if not Settings.FAVORITE_AUTO_KEYWORDS or #Settings.FAVORITE_AUTO_KEYWORDS == 0 then return false end
    local name = obj.Name:lower()
    for _, keyword in ipairs(Settings.FAVORITE_AUTO_KEYWORDS) do
        if name:find(keyword:lower(), 1, true) then
            return true
        end
    end
    return false
end

-- ========== NOTIFICATIONS ==========
local function updateNotificationPosition()
    if not notificationContainer then return end
    local pos = Settings.NOTIFICATION_POSITION
    local layout = notificationContainer:FindFirstChildOfClass("UIListLayout")
    if not layout then return end
    
    if pos == "BottomRight" then
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
        layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    elseif pos == "TopRight" then
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
        layout.VerticalAlignment = Enum.VerticalAlignment.Top
    elseif pos == "BottomLeft" then
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
        layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    elseif pos == "TopLeft" then
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
        layout.VerticalAlignment = Enum.VerticalAlignment.Top
    elseif pos == "CenterTop" then
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.VerticalAlignment = Enum.VerticalAlignment.Top
    elseif pos == "CenterBottom" then
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    end
end

local function closeNotification(notifFrame)
    for i, data in ipairs(notifications) do
        if data.frame == notifFrame then
            if data.timerThread then pcall(task.cancel, data.timerThread) end
            local tween = TweenService:Create(notifFrame, TweenInfo.new(0.3), {Position = UDim2.new(1, 320, 1, -90), BackgroundTransparency = 1})
            tween:Play()
            tween.Completed:Wait()
            if notifFrame and notifFrame.Parent then notifFrame:Destroy() end
            table.remove(notifications, i)
            break
        end
    end
end

local function createSpawnNotification(title, text, object, duration, color)
    duration = duration or Settings.NOTIFICATION_DURATION
    color = color or Settings.NOTIFICATION_COLOR
    
    local notification = Instance.new("Frame")
    notification.Name = "SpawnNotification"
    notification.BackgroundColor3 = color
    notification.BackgroundTransparency = 1
    notification.Size = UDim2.new(0, 300, 0, 90)
    notification.Position = UDim2.new(1, 10, 1, -100)
    notification.BorderSizePixel = 0
    notification.LayoutOrder = #notifications + 1
    notification.Active = true
    notification.ClipsDescendants = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = notification
    
    local timerBar = Instance.new("Frame")
    timerBar.Name = "TimerBar"
    timerBar.BackgroundColor3 = Color3.fromRGB(255,255,255)
    timerBar.BackgroundTransparency = 0.7
    timerBar.Size = UDim2.new(1, -20, 0, 3)
    timerBar.Position = UDim2.new(0, 10, 1, -5)
    timerBar.BorderSizePixel = 0
    timerBar.ZIndex = 23
    timerBar.Parent = notification
    
    local timerProgress = Instance.new("Frame")
    timerProgress.Name = "TimerProgress"
    timerProgress.BackgroundColor3 = color
    timerProgress.Size = UDim2.new(1, 0, 1, 0)
    timerProgress.BorderSizePixel = 0
    timerProgress.ZIndex = 24
    timerProgress.Parent = timerBar
    
    local icon = Instance.new("TextLabel")
    icon.Name = "Icon"
    icon.Text = "✨"
    icon.TextColor3 = Settings.TEXT_COLOR
    icon.TextTransparency = 1
    icon.TextSize = 30
    icon.Font = Enum.Font.GothamBold
    icon.BackgroundTransparency = 1
    icon.Size = UDim2.new(0, 40, 0, 40)
    icon.Position = UDim2.new(0, 10, 0.5, -20)
    icon.Parent = notification
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Text = title
    titleLabel.TextColor3 = Settings.TEXT_COLOR
    titleLabel.TextTransparency = 1
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(1, -60, 0, 25)
    titleLabel.Position = UDim2.new(0, 60, 0, 10)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notification
    
    local itemName = Instance.new("TextLabel")
    itemName.Name = "ItemName"
    itemName.Text = text
    itemName.TextColor3 = Settings.TEXT_COLOR
    itemName.TextTransparency = 1
    itemName.TextSize = 18
    itemName.Font = Enum.Font.GothamBold
    itemName.BackgroundTransparency = 1
    itemName.Size = UDim2.new(1, -60, 0, 30)
    itemName.Position = UDim2.new(0, 60, 0, 35)
    itemName.TextXAlignment = Enum.TextXAlignment.Left
    itemName.Parent = notification
    
    local closeNotifButton = Instance.new("TextButton")
    closeNotifButton.Name = "CloseNotificationButton"
    closeNotifButton.Text = "✕"
    closeNotifButton.TextColor3 = Settings.TEXT_COLOR
    closeNotifButton.TextTransparency = 1
    closeNotifButton.TextSize = 16
    closeNotifButton.Font = Enum.Font.GothamBold
    closeNotifButton.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
    closeNotifButton.BackgroundTransparency = 1
    closeNotifButton.Size = UDim2.new(0, 25, 0, 25)
    closeNotifButton.Position = UDim2.new(1, -30, 0, 5)
    closeNotifButton.BorderSizePixel = 0
    closeNotifButton.ZIndex = 22
    closeNotifButton.AutoButtonColor = true
    Instance.new("UICorner", closeNotifButton).CornerRadius = UDim.new(0, 6)
    closeNotifButton.MouseButton1Click:Connect(function() closeNotification(notification) end)
    closeNotifButton.Parent = notification
    
    local teleportButton = nil
    if object then
        teleportButton = Instance.new("TextButton")
        teleportButton.Name = "TeleportButton"
        teleportButton.Text = "TELEPORT"
        teleportButton.TextColor3 = Settings.TEXT_COLOR
        teleportButton.TextTransparency = 1
        teleportButton.TextSize = 14
        teleportButton.Font = Enum.Font.GothamBold
        teleportButton.BackgroundColor3 = Settings.TELEPORT_COLOR
        teleportButton.BackgroundTransparency = 1
        teleportButton.Size = UDim2.new(0, 100, 0, 30)
        teleportButton.Position = UDim2.new(1, -110, 1, -45)
        teleportButton.BorderSizePixel = 0
        teleportButton.AutoButtonColor = true
        Instance.new("UICorner", teleportButton).CornerRadius = UDim.new(0, 8)
        createGradient(teleportButton, Settings.TELEPORT_COLOR, Color3.fromRGB(230,126,34), 45)
        teleportButton.Parent = notification
        
        local tpDebounce = false
        teleportButton.MouseButton1Click:Connect(function()
            if tpDebounce then return end
            tpDebounce = true
            local success, msg = teleportToObject(object)
            if success then
                teleportButton.Text = "✓ SUCCESS"
                teleportButton.BackgroundColor3 = Color3.fromRGB(46,204,113)
                teleportButton.AutoButtonColor = false
                task.wait(1)
                teleportButton.Text = "TELEPORT"
                teleportButton.BackgroundColor3 = Settings.TELEPORT_COLOR
                teleportButton.AutoButtonColor = true
            else
                local old = teleportButton.Text
                teleportButton.Text = msg
                teleportButton.BackgroundColor3 = Color3.fromRGB(231,76,60)
                teleportButton.AutoButtonColor = false
                task.wait(1.5)
                teleportButton.Text = old
                teleportButton.BackgroundColor3 = Settings.TELEPORT_COLOR
                teleportButton.AutoButtonColor = true
            end
            tpDebounce = false
        end)
    end
    
    if notificationContainer then notification.Parent = notificationContainer end
    
    notification.Position = UDim2.new(1, 50, 1, -100)
    notification.BackgroundTransparency = 1
    icon.TextTransparency = 1
    titleLabel.TextTransparency = 1
    itemName.TextTransparency = 1
    closeNotifButton.TextTransparency = 1
    closeNotifButton.BackgroundTransparency = 1
    if teleportButton then
        teleportButton.TextTransparency = 1
        teleportButton.BackgroundTransparency = 1
    end
    
    TweenService:Create(notification, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, 10, 1, -100),
        BackgroundTransparency = 0.9
    }):Play()
    
    TweenService:Create(icon, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
    TweenService:Create(titleLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
    TweenService:Create(itemName, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
    TweenService:Create(closeNotifButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 0,
        BackgroundTransparency = 0.3
    }):Play()
    if teleportButton then
        TweenService:Create(teleportButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextTransparency = 0,
            BackgroundTransparency = 0.2
        }):Play()
    end
    
    local notifData = {frame = notification, timer = tick(), timerProgress = timerProgress}
    table.insert(notifications, notifData)
    
    notifData.timerThread = task.spawn(function()
        local start = tick()
        while tick() - start < duration and notification and notification.Parent do
            timerProgress.Size = UDim2.new(1 - (tick()-start)/duration, 0, 1, 0)
            task.wait(0.1)
        end
        if notification and notification.Parent then closeNotification(notification) end
    end)
end

-- ========== SAVE/LOAD SETTINGS ==========
local function encodeUDim2(udim2)
    if not udim2 then return nil end
    return {X = {Scale = udim2.X.Scale, Offset = udim2.X.Offset}, Y = {Scale = udim2.Y.Scale, Offset = udim2.Y.Offset}}
end

local function decodeUDim2(data)
    if not data then return nil end
    return UDim2.new(data.X.Scale, data.X.Offset, data.Y.Scale, data.Y.Offset)
end

local function saveSettings()
    if not canSaveToFile then return end
    local objectFavorites = {}
    local objectESP = {}
    for obj, data in pairs(objectCache) do
        if obj and obj.Parent then
            local path = obj:GetFullName()
            objectFavorites[path] = data.favorite or false
            objectESP[path] = data.espEnabled or false
        end
    end
    
    local settingsData = {
        mainTogglePos = mainToggle and encodeUDim2(mainToggle.Position) or nil,
        listTogglePos = listToggle and encodeUDim2(listToggle.Position) or nil,
        settingsTogglePos = settingsToggle and encodeUDim2(settingsToggle.Position) or nil,
        itemListPos = itemListGUI and encodeUDim2(itemListGUI.Position) or nil,
        settingsGUIPos = settingsGUI and encodeUDim2(settingsGUI.Position) or nil,
        bossPanelPos = bossPanel and encodeUDim2(bossPanel.Position) or nil,
        bossButtonPos = bossPanelButton and encodeUDim2(bossPanelButton.Position) or nil,
        guiEnabled = guiEnabled,
        MAX_DISTANCE = Settings.MAX_DISTANCE,
        FADE_START_DISTANCE = Settings.FADE_START_DISTANCE,
        NOTIFICATION_DURATION = Settings.NOTIFICATION_DURATION,
        TELEPORT_RANGE = Settings.TELEPORT_RANGE,
        UPDATE_INTERVAL = Settings.UPDATE_INTERVAL,
        LIST_UPDATE_INTERVAL = Settings.LIST_UPDATE_INTERVAL,
        HIDE_NEAR_DISTANCE = Settings.HIDE_NEAR_DISTANCE,
        DEBUG = DEBUG,
        SOUND_ENABLED = Settings.SOUND_ENABLED,
        SOUND_VOLUME = Settings.SOUND_VOLUME,
        NOTIFICATION_POSITION = Settings.NOTIFICATION_POSITION,
        listFilter = listState.filterType,
        listSortMode = listState.sortMode,
        listSortAsc = listState.sortAsc,
        objectFavorites = objectFavorites,
        objectESP = objectESP,
        -- Death return
        DEATH_RETURN_ENABLED = Settings.DEATH_RETURN_ENABLED,
        DEATH_ANIMATION_ID = Settings.DEATH_ANIMATION_ID,
        -- Visuals
        VISUAL_COLORS = Settings.VISUAL_COLORS,
        VISUAL_SIZE_SCALE = Settings.VISUAL_SIZE_SCALE,
        VISUAL_TRANSPARENCY = Settings.VISUAL_TRANSPARENCY,
        VISUAL_ICON_ONLY_THRESHOLD = Settings.VISUAL_ICON_ONLY_THRESHOLD,
        VISUAL_LOD_ENABLED = Settings.VISUAL_LOD_ENABLED,
        VISUAL_LOD_DIST_ICON = Settings.VISUAL_LOD_DIST_ICON,
        VISUAL_LOD_DIST_BRIEF = Settings.VISUAL_LOD_DIST_BRIEF,
        VISUAL_FRUSTUM_CULLING = Settings.VISUAL_FRUSTUM_CULLING,
        -- Auto teleport
        AUTO_TELEPORT_ENABLED = Settings.AUTO_TELEPORT_ENABLED,
        AUTO_TELEPORT_DELAY = Settings.AUTO_TELEPORT_DELAY,
        AUTO_TELEPORT_WARNING = Settings.AUTO_TELEPORT_WARNING,
        -- Favorites
        FAVORITE_GROUPS = Settings.FAVORITE_GROUPS,
        FAVORITE_ACTIVE_GROUP = Settings.FAVORITE_ACTIVE_GROUP,
        FAVORITE_AUTO_KEYWORDS = Settings.FAVORITE_AUTO_KEYWORDS,
        AUTO_FAVORITE_NAMES = Settings.AUTO_FAVORITE_NAMES,
        -- Debug
        DEBUG_MODE = Settings.DEBUG_MODE,
        DEBUG_SHOW_PATHS = Settings.DEBUG_SHOW_PATHS,
    }
    
    local jsonData = HttpService:JSONEncode(settingsData)
    pcall(function() writefile(SETTINGS_FILE, jsonData) end)
end

local function loadSettings()
    if not canSaveToFile then return nil end
    local success, data = pcall(function()
        local json = readfile(SETTINGS_FILE)
        return json and json ~= "" and HttpService:JSONDecode(json) or nil
    end)
    return success and data or nil
end

local function applyLoadedSettings(settingsData)
    if not settingsData then return end
    -- Positions
    if settingsData.mainTogglePos then savedMainTogglePos = decodeUDim2(settingsData.mainTogglePos) end
    if settingsData.listTogglePos then savedListTogglePos = decodeUDim2(settingsData.listTogglePos) end
    if settingsData.settingsTogglePos then savedSettingsTogglePos = decodeUDim2(settingsData.settingsTogglePos) end
    if settingsData.itemListPos then savedItemListGUIPos = decodeUDim2(settingsData.itemListPos) end
    if settingsData.settingsGUIPos then savedSettingsGUIPos = decodeUDim2(settingsData.settingsGUIPos) end
    if settingsData.bossButtonPos then savedBossButtonPos = decodeUDim2(settingsData.bossButtonPos) end
    
    -- General
    if settingsData.MAX_DISTANCE then Settings.MAX_DISTANCE = settingsData.MAX_DISTANCE end
    if settingsData.FADE_START_DISTANCE then Settings.FADE_START_DISTANCE = settingsData.FADE_START_DISTANCE end
    if settingsData.NOTIFICATION_DURATION then Settings.NOTIFICATION_DURATION = settingsData.NOTIFICATION_DURATION end
    if settingsData.TELEPORT_RANGE then Settings.TELEPORT_RANGE = settingsData.TELEPORT_RANGE end
    if settingsData.UPDATE_INTERVAL then Settings.UPDATE_INTERVAL = settingsData.UPDATE_INTERVAL end
    if settingsData.LIST_UPDATE_INTERVAL then Settings.LIST_UPDATE_INTERVAL = settingsData.LIST_UPDATE_INTERVAL end
    if settingsData.HIDE_NEAR_DISTANCE then Settings.HIDE_NEAR_DISTANCE = settingsData.HIDE_NEAR_DISTANCE end
    if settingsData.guiEnabled ~= nil then guiEnabled = settingsData.guiEnabled end
    if settingsData.DEBUG ~= nil then DEBUG = settingsData.DEBUG end
    if settingsData.SOUND_ENABLED ~= nil then Settings.SOUND_ENABLED = settingsData.SOUND_ENABLED end
    if settingsData.SOUND_VOLUME ~= nil then Settings.SOUND_VOLUME = settingsData.SOUND_VOLUME end
    if settingsData.NOTIFICATION_POSITION then Settings.NOTIFICATION_POSITION = settingsData.NOTIFICATION_POSITION end
    if settingsData.listFilter then listState.filterType = settingsData.listFilter end
    if settingsData.listSortMode then listState.sortMode = settingsData.listSortMode end
    if settingsData.listSortAsc ~= nil then listState.sortAsc = settingsData.listSortAsc end
    if settingsData.objectFavorites then savedObjectFavorites = settingsData.objectFavorites end
    if settingsData.objectESP then savedObjectESP = settingsData.objectESP end
    
    -- Death return
    if settingsData.DEATH_RETURN_ENABLED ~= nil then Settings.DEATH_RETURN_ENABLED = settingsData.DEATH_RETURN_ENABLED end
    if settingsData.DEATH_ANIMATION_ID then Settings.DEATH_ANIMATION_ID = settingsData.DEATH_ANIMATION_ID end
    
    -- Visuals
    if settingsData.VISUAL_COLORS then 
        for k, v in pairs(settingsData.VISUAL_COLORS) do
            Settings.VISUAL_COLORS[k] = v
        end
    end
    if settingsData.VISUAL_SIZE_SCALE then Settings.VISUAL_SIZE_SCALE = settingsData.VISUAL_SIZE_SCALE end
    if settingsData.VISUAL_TRANSPARENCY then Settings.VISUAL_TRANSPARENCY = settingsData.VISUAL_TRANSPARENCY end
    if settingsData.VISUAL_ICON_ONLY_THRESHOLD then Settings.VISUAL_ICON_ONLY_THRESHOLD = settingsData.VISUAL_ICON_ONLY_THRESHOLD end
    if settingsData.VISUAL_LOD_ENABLED ~= nil then Settings.VISUAL_LOD_ENABLED = settingsData.VISUAL_LOD_ENABLED end
    if settingsData.VISUAL_LOD_DIST_ICON then Settings.VISUAL_LOD_DIST_ICON = settingsData.VISUAL_LOD_DIST_ICON end
    if settingsData.VISUAL_LOD_DIST_BRIEF then Settings.VISUAL_LOD_DIST_BRIEF = settingsData.VISUAL_LOD_DIST_BRIEF end
    if settingsData.VISUAL_FRUSTUM_CULLING ~= nil then Settings.VISUAL_FRUSTUM_CULLING = settingsData.VISUAL_FRUSTUM_CULLING end
    
    -- Auto teleport
    if settingsData.AUTO_TELEPORT_ENABLED ~= nil then Settings.AUTO_TELEPORT_ENABLED = settingsData.AUTO_TELEPORT_ENABLED end
    if settingsData.AUTO_TELEPORT_DELAY then Settings.AUTO_TELEPORT_DELAY = settingsData.AUTO_TELEPORT_DELAY end
    if settingsData.AUTO_TELEPORT_WARNING ~= nil then Settings.AUTO_TELEPORT_WARNING = settingsData.AUTO_TELEPORT_WARNING end
    
    -- Favorites
    if settingsData.FAVORITE_GROUPS then Settings.FAVORITE_GROUPS = settingsData.FAVORITE_GROUPS end
    if settingsData.FAVORITE_ACTIVE_GROUP then Settings.FAVORITE_ACTIVE_GROUP = settingsData.FAVORITE_ACTIVE_GROUP end
    if settingsData.FAVORITE_AUTO_KEYWORDS then Settings.FAVORITE_AUTO_KEYWORDS = settingsData.FAVORITE_AUTO_KEYWORDS end
    if settingsData.AUTO_FAVORITE_NAMES then Settings.AUTO_FAVORITE_NAMES = settingsData.AUTO_FAVORITE_NAMES end
    
    -- Debug
    if settingsData.DEBUG_MODE ~= nil then Settings.DEBUG_MODE = settingsData.DEBUG_MODE end
    if settingsData.DEBUG_SHOW_PATHS ~= nil then Settings.DEBUG_SHOW_PATHS = settingsData.DEBUG_SHOW_PATHS end
end

local saveDebounce = false
local function debouncedSaveSettings()
    if not canSaveToFile or saveDebounce then return end
    saveDebounce = true
    task.delay(1, function() saveSettings(); saveDebounce = false end)
end

-- ========== PATH LINES UPDATE ==========
local function updatePathLines()
    if not Settings.DEBUG_SHOW_PATHS then
        -- delete all lines
        for _, line in pairs(pathLines) do
            if line then pcall(line.Destroy, line) end
        end
        pathLines = {}
        return
    end
    
    local character = LocalPlayer.Character
    if not character then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    for obj, data in pairs(objectCache) do
        if obj and obj.Parent then
            local pos = getObjectPosition(obj)
            local line = pathLines[obj]
            if not line then
                local part = Instance.new("Part")
                part.Name = "PathLine"
                part.Size = Vector3.new(0.2, 0.2, (root.Position - pos).Magnitude)
                part.CFrame = CFrame.lookAt(root.Position, pos) * CFrame.new(0, 0, -part.Size.Z/2)
                part.Anchored = true
                part.CanCollide = false
                part.Transparency = 0.5
                part.BrickColor = BrickColor.new("Bright red")
                part.Material = Enum.Material.Neon
                part.Parent = workspace
                pathLines[obj] = part
            else
                local dist = (root.Position - pos).Magnitude
                line.Size = Vector3.new(0.2, 0.2, dist)
                line.CFrame = CFrame.lookAt(root.Position, pos) * CFrame.new(0, 0, -dist/2)
            end
        else
            if pathLines[obj] then
                pcall(pathLines[obj].Destroy, pathLines[obj])
                pathLines[obj] = nil
            end
        end
    end
end

-- ========== LOD HELPER ==========
local function getLODLevel(dist)
    if not Settings.VISUAL_LOD_ENABLED then return 3 end
    if dist > Settings.VISUAL_LOD_DIST_ICON then
        return 1
    elseif dist > Settings.VISUAL_LOD_DIST_BRIEF then
        return 2
    else
        return 3
    end
end

local function isObjectVisible(pos)
    if not Settings.VISUAL_FRUSTUM_CULLING then return true end
    local onScreen, visPos = Camera:WorldToViewportPoint(pos)
    return onScreen and visPos.Z > 0
end

-- ========== COMPACT BOSS ESP WITH LOD SUPPORT ==========
local function createInfoCard(object)
    if not guiEnabled then return nil end
    local data = objectCache[object]
    if not data then
        debugPrint("❌ No data for object", object.Name, "- cannot create ESP")
        return nil
    end
    local style = getObjectStyle(object)
    local isBoss = (style == TypeStyles.Boss or style == TypeStyles.Sukuna)
    local isCompact = style.Compact or false
    
    local cardWidth, cardHeight
    if isCompact then
        cardWidth = 280
        cardHeight = 140
    else
        cardWidth = isBoss and 400 or 320
        cardHeight = isBoss and 220 or 140
    end
    
    if IS_MOBILE then
        cardWidth = cardWidth * Settings.MOBILE_SCALE
        cardHeight = cardHeight * Settings.MOBILE_SCALE
    end
    
    cardWidth = cardWidth * Settings.VISUAL_SIZE_SCALE
    cardHeight = cardHeight * Settings.VISUAL_SIZE_SCALE
    
    local container = Instance.new("BillboardGui")
    container.Name = "ObjectInfoCard"
    container.AlwaysOnTop = true
    container.Size = UDim2.new(0, cardWidth, 0, cardHeight)
    container.StudsOffset = Vector3.new(0, 3, 0)
    container.MaxDistance = Settings.MAX_DISTANCE
    container.Enabled = true
    container.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    container.Active = true
    
    -- Adornee (attachment)
    local adornee = nil
    if object:IsA("BasePart") then
        adornee = object
    elseif object:IsA("Model") then
        adornee = object.PrimaryPart or object:FindFirstChildWhichIsA("BasePart")
        if not adornee then
            for _, descendant in ipairs(object:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    adornee = descendant
                    break
                end
            end
        end
    end
    
    if adornee then
        container.Adornee = adornee
    else
        local humanoid = object:FindFirstChildOfClass("Humanoid")
        local rootPart = humanoid and humanoid.RootPart
        if rootPart then
            container.Adornee = rootPart
        else
            local tempPart = Instance.new("Part")
            tempPart.Name = "ESPTempPart"
            tempPart.Size = Vector3.new(1, 1, 1)
            tempPart.Transparency = 1
            tempPart.CanCollide = false
            tempPart.Anchored = false
            tempPart.Parent = object
            
            local pivot = object:GetPivot()
            tempPart.CFrame = pivot
            
            container.Adornee = tempPart
            data.tempPart = tempPart
            
            data.updateConnection = RunService.Heartbeat:Connect(function()
                if tempPart and tempPart.Parent and object and object.Parent then
                    tempPart.CFrame = object:GetPivot()
                else
                    if data.updateConnection then
                        data.updateConnection:Disconnect()
                        data.updateConnection = nil
                    end
                end
            end)
        end
    end
    
    -- Main frame
    local main = Instance.new("Frame")
    main.Name = "MainFrame"
    main.BackgroundColor3 = style.Background
    main.BackgroundTransparency = Settings.VISUAL_TRANSPARENCY
    main.Size = UDim2.new(1,0,1,0)
    main.BorderSizePixel = 0
    Instance.new("UICorner", main).CornerRadius = UDim.new(0,12)
    
    -- === LOD 1: icon and name only ===
    local lod1 = Instance.new("Frame")
    lod1.Name = "LOD1"
    lod1.BackgroundTransparency = 1
    lod1.Size = UDim2.new(1,0,1,0)
    lod1.Visible = false
    do
        local icon = Instance.new("TextLabel")
        icon.Name = "Icon"
        icon.Text = style.Icon
        icon.TextColor3 = style.TextColor
        icon.TextSize = 40 * Settings.VISUAL_SIZE_SCALE
        icon.Font = Enum.Font.GothamBold
        icon.BackgroundTransparency = 1
        icon.Size = UDim2.new(1,0,0.5,0)
        icon.Position = UDim2.new(0,0,0,0)
        icon.Parent = lod1
        
        local name = Instance.new("TextLabel")
        name.Name = "Name"
        name.Text = getDisplayName(object) .. (data.favorite and ' <font color="#FFD700">★</font>' or '')
        name.RichText = true
        name.TextColor3 = style.TextColor
        name.TextSize = 14 * Settings.VISUAL_SIZE_SCALE
        name.Font = Enum.Font.Gotham
        name.BackgroundTransparency = 1
        name.Size = UDim2.new(1,0,0.3,0)
        name.Position = UDim2.new(0,0,0.5,0)
        name.Parent = lod1
    end
    lod1.Parent = main
    
    -- === LOD 2: icon, name, type, distance ===
    local lod2 = Instance.new("Frame")
    lod2.Name = "LOD2"
    lod2.BackgroundTransparency = 1
    lod2.Size = UDim2.new(1,0,1,0)
    lod2.Visible = false
    do
        local icon = Instance.new("TextLabel")
        icon.Name = "Icon"
        icon.Text = style.Icon
        icon.TextColor3 = style.TextColor
        icon.TextSize = 30 * Settings.VISUAL_SIZE_SCALE
        icon.Font = Enum.Font.GothamBold
        icon.BackgroundTransparency = 1
        icon.Size = UDim2.new(0,40,0,40)
        icon.Position = UDim2.new(0,5,0.5,-20)
        icon.Parent = lod2
        
        local name = Instance.new("TextLabel")
        name.Name = "Name"
        name.Text = getDisplayName(object) .. (data.favorite and ' <font color="#FFD700">★</font>' or '')
        name.RichText = true
        name.TextColor3 = style.TextColor
        name.TextSize = 16 * Settings.VISUAL_SIZE_SCALE
        name.Font = Enum.Font.GothamBold
        name.BackgroundTransparency = 1
        name.Size = UDim2.new(1,-60,0,30)
        name.Position = UDim2.new(0,50,0.2,0)
        name.TextXAlignment = Enum.TextXAlignment.Left
        name.Parent = lod2
        
        local typeLabel = Instance.new("TextLabel")
        typeLabel.Name = "TypeLabel"
        typeLabel.Text = "Type: " .. (getSpecialType(object) or object.ClassName)
        typeLabel.TextColor3 = Color3.fromRGB(200,200,200)
        typeLabel.TextSize = 12 * Settings.VISUAL_SIZE_SCALE
        typeLabel.Font = Enum.Font.Gotham
        typeLabel.BackgroundTransparency = 1
        typeLabel.Size = UDim2.new(1,-60,0,20)
        typeLabel.Position = UDim2.new(0,50,0.5,0)
        typeLabel.TextXAlignment = Enum.TextXAlignment.Left
        typeLabel.Parent = lod2
        
        local dist = Instance.new("TextLabel")
        dist.Name = "DistanceLabel"
        dist.Text = "Distance: ?"
        dist.TextColor3 = Color3.fromRGB(200,200,200)
        dist.TextSize = 12 * Settings.VISUAL_SIZE_SCALE
        dist.Font = Enum.Font.Gotham
        dist.BackgroundTransparency = 1
        dist.Size = UDim2.new(1,-60,0,20)
        dist.Position = UDim2.new(0,50,0.7,0)
        dist.TextXAlignment = Enum.TextXAlignment.Left
        dist.Parent = lod2
    end
    lod2.Parent = main
    
    -- === LOD 3: full version (original ESP with boss support) ===
    local lod3 = Instance.new("Frame")
    lod3.Name = "LOD3"
    lod3.BackgroundTransparency = 1
    lod3.Size = UDim2.new(1,0,1,0)
    lod3.Visible = true
    do
        -- Glow effect
        local glow = Instance.new("Frame")
        glow.BackgroundColor3 = style.Glow
        glow.BackgroundTransparency = 0.9
        glow.Size = UDim2.new(1,10,1,10)
        glow.Position = UDim2.new(0,-5,0,-5)
        glow.BorderSizePixel = 0
        glow.ZIndex = 0
        Instance.new("UICorner", glow).CornerRadius = UDim.new(0,16)
        glow.Parent = lod3
        
        -- Header
        local header = Instance.new("Frame")
        header.BackgroundColor3 = style.Header
        header.Size = UDim2.new(1,0,0,isCompact and 30 or 40)
        header.BorderSizePixel = 0
        header.ZIndex = 2
        Instance.new("UICorner", header).CornerRadius = UDim.new(0,12,0,0)
        if style.HeaderGradient then
            createGradient(header, style.HeaderGradient[1], style.HeaderGradient[2], 45)
        else
            createGradient(header, style.Header, style.Header:lerp(Color3.new(0,0,0), 0.3), 45)
        end
        
        local headerIcon = Instance.new("TextLabel")
        headerIcon.Text = style.Icon
        headerIcon.TextColor3 = style.TextColor
        headerIcon.TextSize = isCompact and 20 or 28
        if IS_MOBILE then headerIcon.TextSize = headerIcon.TextSize * 1.2 end
        headerIcon.Font = Enum.Font.GothamBold
        headerIcon.BackgroundTransparency = 1
        headerIcon.Size = UDim2.new(0, isCompact and 20 or 28, 0, isCompact and 20 or 28)
        headerIcon.Position = UDim2.new(0, isCompact and 5 or 10, 0.5, isCompact and -10 or -14)
        headerIcon.ZIndex = 3
        headerIcon.Parent = header
        
        local headerName = Instance.new("TextLabel")
        headerName.Name = "HeaderName"
        headerName.Text = getDisplayName(object) .. (data.favorite and ' <font color="#FFD700">★</font>' or '')
        headerName.RichText = true
        headerName.TextColor3 = style.TextColor
        headerName.TextSize = isCompact and 14 or 18
        if IS_MOBILE then headerName.TextSize = headerName.TextSize * 1.2 end
        headerName.Font = Enum.Font.GothamBold
        headerName.BackgroundTransparency = 1
        headerName.Size = UDim2.new(1, -(isCompact and 30 or 50), 1, 0)
        headerName.Position = UDim2.new(0, isCompact and 30 or 50, 0, 0)
        headerName.TextXAlignment = Enum.TextXAlignment.Left
        headerName.ZIndex = 3
        headerName.Parent = header
        
        if style.ExtraIconAnimation and not isCompact then
            local extraIcon = Instance.new("TextLabel")
            extraIcon.Text = style.Icon
            extraIcon.TextColor3 = Color3.fromRGB(255, 200, 0)
            extraIcon.TextSize = 24
            if IS_MOBILE then extraIcon.TextSize = extraIcon.TextSize * 1.2 end
            extraIcon.Font = Enum.Font.GothamBold
            extraIcon.BackgroundTransparency = 1
            extraIcon.Size = UDim2.new(0, 30, 0, 30)
            extraIcon.Position = UDim2.new(1, -35, 0.5, -15)
            extraIcon.ZIndex = 4
            extraIcon.Parent = header
            TweenService:Create(extraIcon, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), 
                {TextTransparency = 0.5, TextSize = 28}):Play()
        end
        
        header.Parent = lod3
        
        -- Content
        local content = Instance.new("Frame")
        content.BackgroundTransparency = 1
        local contentHeight = isCompact and 100 or (isBoss and 170 or 90)
        if IS_MOBILE then contentHeight = contentHeight * 1.2 end
        content.Size = UDim2.new(1,-20,0, contentHeight)
        content.Position = UDim2.new(0,10,0, isCompact and 35 or 45)
        content.ZIndex = 2
        
        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, isCompact and 4 or 8)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
        layout.VerticalAlignment = Enum.VerticalAlignment.Top
        layout.Parent = content
        
        -- Type
        local typeRow = Instance.new("Frame")
        typeRow.BackgroundTransparency = 1
        typeRow.Size = UDim2.new(1,0,0, isCompact and 20 or 24)
        if IS_MOBILE then typeRow.Size = UDim2.new(1,0,0, isCompact and 30 or 36) end
        local typeIcon = Instance.new("TextLabel")
        typeIcon.Text = "📦"
        typeIcon.TextColor3 = style.TextColor
        typeIcon.TextSize = isCompact and 16 or 20
        if IS_MOBILE then typeIcon.TextSize = typeIcon.TextSize * 1.2 end
        typeIcon.Font = Enum.Font.GothamBold
        typeIcon.BackgroundTransparency = 1
        typeIcon.Size = UDim2.new(0, isCompact and 16 or 20, 0, isCompact and 16 or 20)
        typeIcon.Position = UDim2.new(0,0,0.5, isCompact and -8 or -10)
        typeIcon.Parent = typeRow
        local typeLabel = Instance.new("TextLabel")
        typeLabel.Text = "Type: " .. (getSpecialType(object) or object.ClassName)
        typeLabel.TextColor3 = Color3.fromRGB(200,200,200)
        typeLabel.TextSize = isCompact and 12 or 14
        if IS_MOBILE then typeLabel.TextSize = typeLabel.TextSize * 1.2 end
        typeLabel.Font = Enum.Font.Gotham
        typeLabel.BackgroundTransparency = 1
        typeLabel.Size = UDim2.new(1,-30,1,0)
        typeLabel.Position = UDim2.new(0, isCompact and 20 or 30, 0,0)
        typeLabel.TextXAlignment = Enum.TextXAlignment.Left
        typeLabel.Parent = typeRow
        typeRow.Parent = content
        
        -- Distance
        local distRow = Instance.new("Frame")
        distRow.BackgroundTransparency = 1
        distRow.Size = UDim2.new(1,0,0, isCompact and 20 or 24)
        if IS_MOBILE then distRow.Size = UDim2.new(1,0,0, isCompact and 30 or 36) end
        local distIcon = Instance.new("TextLabel")
        distIcon.Text = "📍"
        distIcon.TextColor3 = style.TextColor
        distIcon.TextSize = isCompact and 16 or 20
        if IS_MOBILE then distIcon.TextSize = distIcon.TextSize * 1.2 end
        distIcon.Font = Enum.Font.GothamBold
        distIcon.BackgroundTransparency = 1
        distIcon.Size = UDim2.new(0, isCompact and 16 or 20, 0, isCompact and 16 or 20)
        distIcon.Position = UDim2.new(0,0,0.5, isCompact and -8 or -10)
        distIcon.Parent = distRow
        local distLabel = Instance.new("TextLabel")
        distLabel.Name = "DistanceLabel"
        distLabel.Text = "Distance: 0 studs"
        distLabel.TextColor3 = Color3.fromRGB(200,200,200)
        distLabel.TextSize = isCompact and 12 or 14
        if IS_MOBILE then distLabel.TextSize = distLabel.TextSize * 1.2 end
        distLabel.Font = Enum.Font.Gotham
        distLabel.BackgroundTransparency = 1
        distLabel.Size = UDim2.new(1,-30,1,0)
        distLabel.Position = UDim2.new(0, isCompact and 20 or 30, 0,0)
        distLabel.TextXAlignment = Enum.TextXAlignment.Left
        distLabel.Parent = distRow
        distRow.Parent = content
        
        -- Boss health (fixed version as in Boss Status)
        if isBoss then
            local healthRow = Instance.new("Frame")
            healthRow.Name = "HealthRow"
            healthRow.BackgroundTransparency = 1
            healthRow.Size = UDim2.new(1,0,0, isCompact and 50 or 60)
            if IS_MOBILE then healthRow.Size = UDim2.new(1,0,0, isCompact and 70 or 80) end
            
            -- Heart icon
            local hpIcon = Instance.new("TextLabel")
            hpIcon.Name = "HPIcon"
            hpIcon.Text = "❤️"
            hpIcon.TextColor3 = Color3.fromRGB(255, 100, 100)
            hpIcon.TextSize = isCompact and 16 or 20
            if IS_MOBILE then hpIcon.TextSize = hpIcon.TextSize * 1.2 end
            hpIcon.Font = Enum.Font.GothamBold
            hpIcon.BackgroundTransparency = 1
            hpIcon.Size = UDim2.new(0, isCompact and 20 or 24, 0, isCompact and 20 or 24)
            hpIcon.Position = UDim2.new(0, 0, 0, 5)
            hpIcon.Parent = healthRow
            
            -- HP text (like in Boss Status: "HP: 100/100 (100%)")
            local hpText = Instance.new("TextLabel")
            hpText.Name = "HPText"
            hpText.Text = "HP: 0/0 (0%)"
            hpText.TextColor3 = Color3.fromRGB(255, 255, 255)
            hpText.TextSize = isCompact and 12 or 14
            if IS_MOBILE then hpText.TextSize = hpText.TextSize * 1.2 end
            hpText.Font = Enum.Font.Gotham
            hpText.BackgroundTransparency = 1
            hpText.Size = UDim2.new(1, -30, 0, 20)
            hpText.Position = UDim2.new(0, 25, 0, 5)
            hpText.TextXAlignment = Enum.TextXAlignment.Left
            hpText.Parent = healthRow
            
            -- HP bar
            local hpBarBg = Instance.new("Frame")
            hpBarBg.Name = "HPBarBg"
            hpBarBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            hpBarBg.Size = UDim2.new(1, -25, 0, 10)
            hpBarBg.Position = UDim2.new(0, 25, 0, 30)
            hpBarBg.BorderSizePixel = 0
            hpBarBg.Parent = healthRow
            Instance.new("UICorner", hpBarBg).CornerRadius = UDim.new(0, 4)
            
            local hpBarFill = Instance.new("Frame")
            hpBarFill.Name = "HPBarFill"
            hpBarFill.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
            hpBarFill.Size = UDim2.new(1, 0, 1, 0)  -- will be updated
            hpBarFill.BorderSizePixel = 0
            hpBarFill.Parent = hpBarBg
            Instance.new("UICorner", hpBarFill).CornerRadius = UDim.new(0, 4)
            
            -- Percentage (for aesthetics)
            local percentLabel = Instance.new("TextLabel")
            percentLabel.Name = "HealthPercent"
            percentLabel.Text = "100%"
            percentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            percentLabel.TextSize = isCompact and 10 or 12
            if IS_MOBILE then percentLabel.TextSize = percentLabel.TextSize * 1.2 end
            percentLabel.Font = Enum.Font.Gotham
            percentLabel.BackgroundTransparency = 1
            percentLabel.Size = UDim2.new(0, 40, 0, 20)
            percentLabel.Position = UDim2.new(1, -45, 0, 5)
            percentLabel.TextXAlignment = Enum.TextXAlignment.Right
            percentLabel.Parent = healthRow
            
            healthRow.Parent = content
            
            -- Save references for updates
            data.hpText = hpText
            data.hpBarFill = hpBarFill
            data.percentLabel = percentLabel
        end
        
        -- Skull icon for bosses at low health
        if isBoss and not isCompact then
            local skullIcon = Instance.new("TextLabel")
            skullIcon.Name = "SkullIcon"
            skullIcon.Text = "💀"
            skullIcon.TextColor3 = Color3.fromRGB(255, 50, 50)
            skullIcon.TextSize = 30
            if IS_MOBILE then skullIcon.TextSize = skullIcon.TextSize * 1.2 end
            skullIcon.Font = Enum.Font.GothamBold
            skullIcon.BackgroundTransparency = 1
            skullIcon.Size = UDim2.new(0, 40, 0, 40)
            skullIcon.Position = UDim2.new(1, -50, 1, -45)
            skullIcon.ZIndex = 5
            skullIcon.Visible = false
            skullIcon.Parent = lod3
            TweenService:Create(skullIcon, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
                {TextTransparency = 0.5}):Play()
            data.skullIcon = skullIcon
        end
        
        content.Parent = lod3
        
        -- TP button
        local quickTeleport = Instance.new("TextButton")
        quickTeleport.Name = "QuickTeleport"
        quickTeleport.Text = "TP"
        quickTeleport.TextColor3 = Settings.TEXT_COLOR
        quickTeleport.TextSize = isCompact and 10 or 12
        if IS_MOBILE then quickTeleport.TextSize = quickTeleport.TextSize * 1.2 end
        quickTeleport.Font = Enum.Font.GothamBold
        quickTeleport.BackgroundColor3 = Settings.TELEPORT_COLOR
        quickTeleport.BackgroundTransparency = 0.3
        quickTeleport.Size = UDim2.new(0, isCompact and 50 or 80, 0, isCompact and 20 or 25)
        quickTeleport.Position = UDim2.new(1, -(isCompact and 55 or 85), 1, -(isCompact and 25 or 30))
        quickTeleport.BorderSizePixel = 0
        quickTeleport.ZIndex = 10
        quickTeleport.AutoButtonColor = true
        Instance.new("UICorner", quickTeleport).CornerRadius = UDim.new(0, isCompact and 4 or 6)
        quickTeleport.MouseEnter:Connect(function()
            quickTeleport.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
        end)
        quickTeleport.MouseLeave:Connect(function()
            quickTeleport.BackgroundColor3 = Settings.TELEPORT_COLOR
        end)
        quickTeleport.MouseButton1Click:Connect(function()
            playSound("ButtonClick")
            teleportToObject(object)
        end)
        quickTeleport.Parent = lod3
        
        -- Status indicator
        local status = Instance.new("Frame")
        status.Name = "StatusIndicator"
        status.BackgroundColor3 = Color3.fromRGB(0,255,127)
        status.Size = UDim2.new(0, isCompact and 6 or 8, 0, isCompact and 6 or 8)
        status.Position = UDim2.new(1, -(isCompact and 70 or 100), 0, isCompact and 8 or 10)
        status.BorderSizePixel = 0
        status.ZIndex = 3
        Instance.new("UICorner", status).CornerRadius = UDim.new(1,0)
        TweenService:Create(status, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {BackgroundTransparency = 0.5}):Play()
        status.Parent = lod3
    end
    lod3.Parent = main
    
    main.Parent = container
    
    -- Save LOD frame references
    data.lodFrames = {lod1, lod2, lod3}
    
    -- Entry animation
    container.Size = UDim2.new(0,10,0,10)
    main.BackgroundTransparency = 1
    TweenService:Create(container, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0,cardWidth,0,cardHeight)}):Play()
    TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = Settings.VISUAL_TRANSPARENCY}):Play()
    
    container.Parent = Camera
    return container
end

-- END OF PART 1/4
--[[
    Nexus Tracker v10.0 – Advanced ESP, LOD, Auto Teleport, Enhanced Favorites, Debug
    PART 2/4
]]

-- ========== ESP AND FAVORITE MANAGEMENT ==========
local function setESPEnabled(obj, enabled)
    local data = objectCache[obj]
    if not data then return end
    data.espEnabled = enabled
    if data.esp then
        data.esp.Enabled = enabled and guiEnabled
    end
    if itemListVisible then pcall(updateItemList) end
    debouncedSaveSettings()
end

local function toggleFavorite(obj)
    local data = objectCache[obj]
    if not data then return end
    
    local objName = obj.Name
    local newState = not data.favorite
    
    -- If enabling favorite
    if newState then
        -- Add name to auto-favorite list if not already present
        if not tableFind(Settings.AUTO_FAVORITE_NAMES, objName) then
            table.insert(Settings.AUTO_FAVORITE_NAMES, objName)
        end
        -- Mark all objects with same name as favorite
        for otherObj, otherData in pairs(objectCache) do
            if otherObj and otherObj.Name == objName then
                otherData.favorite = true
            end
        end
    else
        -- If disabling, remove name from list
        for i, name in ipairs(Settings.AUTO_FAVORITE_NAMES) do
            if name == objName then
                table.remove(Settings.AUTO_FAVORITE_NAMES, i)
                break
            end
        end
        -- Remove favorite from all objects with that name
        for otherObj, otherData in pairs(objectCache) do
            if otherObj and otherObj.Name == objName then
                otherData.favorite = false
            end
        end
    end
    
    -- Recreate ESP for all objects with this name to update star
    for otherObj, otherData in pairs(objectCache) do
        if otherObj and otherObj.Name == objName then
            if otherData.esp then
                otherData.esp:Destroy()
                otherData.esp = createInfoCard(otherObj)
                if otherData.esp then
                    otherData.esp.Enabled = guiEnabled and otherData.espEnabled
                end
            end
        end
    end
    
    -- Force list update if open
    if itemListVisible then pcall(updateItemList) end
    debouncedSaveSettings()
end

-- ========== ADD SPECIAL OBJECT ==========
local function tryAddSpecialObject(obj, sType)
    if not obj or objectCache[obj] then return false end
    local path = obj:GetFullName()
    local favorite = savedObjectFavorites[path] or false
    if checkAutoFavorite(obj) then
        favorite = true
    end

    if tableFind(Settings.AUTO_FAVORITE_NAMES, obj.Name) then
        favorite = true
    end

    local espEnabled = savedObjectESP[path] or true
    
    local data = {
        esp = nil,
        espEnabled = espEnabled,
        favorite = favorite,
        addedTime = tick(),
        className = obj.ClassName,
        displayName = getDisplayName(obj),
        position = getObjectPosition(obj),
        fullPath = path,
        specialType = sType,
        lowHealthPlayed = false
    }
    
    objectCache[obj] = data
    
    if sType == "Boss" or sType == "Sukuna" then
        local humanoid = obj:FindFirstChildOfClass("Humanoid")
        if humanoid then
            data.health = humanoid.Health
            data.maxHealth = humanoid.MaxHealth
        end
        local now = tick()
        if now - lastBossSpawnNotification > BOSS_NOTIFICATION_COOLDOWN then
            playSound("BossSpawn")
            createSpawnNotification("🔥 BOSS SPAWNED", SPECIAL_NAMES[sType] .. " has appeared!", obj, 5, Color3.fromRGB(255,100,0))
            lastBossSpawnNotification = now
        end
        lastBossType = sType
        scheduleAutoTeleport(obj, sType)
    else
        playSound("ItemSpawn")
        createSpawnNotification("✨ SPECIAL ITEM", SPECIAL_NAMES[sType] or obj.Name, obj, Settings.NOTIFICATION_DURATION, Settings.SECONDARY_COLOR)
    end
    
    local esp = createInfoCard(obj)
    if esp then
        data.esp = esp
        esp.Enabled = guiEnabled and espEnabled
    else
        objectCache[obj] = nil
        return false
    end
    
    updateListToggleIcon()
    if itemListVisible then pcall(updateItemList) end
    return true
end

-- ========== SETTINGS COMPONENTS ==========
local function createValueInput(parent, currentValue, minValue, maxValue, suffix, callback)
    local frame = Instance.new("Frame")
    frame.Name = "ValueInputFrame"
    frame.BackgroundTransparency = 1
    frame.Size = UDim2.new(0, 120, 0, 30)
    
    local box = Instance.new("TextBox")
    box.Name = "ValueInputBox"
    box.Text = tostring(currentValue)
    box.PlaceholderText = "Enter value..."
    box.TextColor3 = Settings.TEXT_COLOR
    box.PlaceholderColor3 = Color3.fromRGB(150,150,150)
    box.TextSize = 14
    if IS_MOBILE then box.TextSize = 18 end
    box.Font = Enum.Font.Gotham
    box.BackgroundColor3 = Color3.fromRGB(40,40,50)
    box.BackgroundTransparency = 0.2
    box.Size = UDim2.new(1,0,1,0)
    box.BorderSizePixel = 0
    Instance.new("UICorner", box).CornerRadius = UDim.new(0,6)
    Instance.new("UIPadding", box).PaddingLeft = UDim.new(0,8)
    
    box.FocusLost:Connect(function()
        local val = tonumber(box.Text)
        if val then
            val = math.clamp(val, minValue, maxValue)
            box.Text = tostring(val)
            if callback then callback(val) end
            debouncedSaveSettings()
        else
            box.Text = tostring(currentValue)
        end
    end)
    box.Parent = frame
    return frame
end

local function createToggleSetting(parent, labelText, value, callback)
    local frame = Instance.new("Frame")
    frame.Name = labelText.."Toggle"
    frame.BackgroundTransparency = 1
    frame.Size = UDim2.new(1,0,0,50)
    if IS_MOBILE then frame.Size = UDim2.new(1,0,0,70) end
    
    local label = Instance.new("TextLabel")
    label.Text = labelText
    label.TextColor3 = Settings.TEXT_COLOR
    label.TextSize = 16
    if IS_MOBILE then label.TextSize = 20 end
    label.Font = Enum.Font.GothamBold
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1,-100,0,25)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Text = value and "ON" or "OFF"
    btn.TextColor3 = Settings.TEXT_COLOR
    btn.TextSize = 14
    if IS_MOBILE then btn.TextSize = 18 end
    btn.Font = Enum.Font.GothamBold
    btn.BackgroundColor3 = value and Color3.fromRGB(46,204,113) or Color3.fromRGB(231,76,60)
    btn.BackgroundTransparency = 0.3
    btn.Size = UDim2.new(0,80,0,30)
    if IS_MOBILE then btn.Size = UDim2.new(0,100,0,40) end
    btn.Position = UDim2.new(1,-80,0,0)
    if IS_MOBILE then btn.Position = UDim2.new(1,-100,0,0) end
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = true
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
    
    btn.MouseButton1Click:Connect(function()
        playSound("ButtonClick")
        local new = not value
        btn.Text = new and "ON" or "OFF"
        btn.BackgroundColor3 = new and Color3.fromRGB(46,204,113) or Color3.fromRGB(231,76,60)
        value = new
        if callback then callback(new) end
        debouncedSaveSettings()
    end)
    btn.Parent = frame
    return frame
end

local function createDropdown(parent, labelText, options, current, callback)
    local frame = Instance.new("Frame")
    frame.Name = labelText.."Dropdown"
    frame.BackgroundTransparency = 1
    frame.Size = UDim2.new(1,0,0,50)
    if IS_MOBILE then frame.Size = UDim2.new(1,0,0,70) end
    
    local label = Instance.new("TextLabel")
    label.Text = labelText
    label.TextColor3 = Settings.TEXT_COLOR
    label.TextSize = 16
    if IS_MOBILE then label.TextSize = 20 end
    label.Font = Enum.Font.GothamBold
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1,-150,0,25)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local dropdownBtn = Instance.new("TextButton")
    dropdownBtn.Text = current
    dropdownBtn.TextColor3 = Settings.TEXT_COLOR
    dropdownBtn.TextSize = 14
    if IS_MOBILE then dropdownBtn.TextSize = 18 end
    dropdownBtn.Font = Enum.Font.GothamBold
    dropdownBtn.BackgroundColor3 = Color3.fromRGB(60,60,70)
    dropdownBtn.BackgroundTransparency = 0.3
    dropdownBtn.Size = UDim2.new(0,140,0,30)
    if IS_MOBILE then dropdownBtn.Size = UDim2.new(0,160,0,40) end
    dropdownBtn.Position = UDim2.new(1,-140,0,0)
    if IS_MOBILE then dropdownBtn.Position = UDim2.new(1,-160,0,0) end
    dropdownBtn.BorderSizePixel = 0
    dropdownBtn.ZIndex = 30
    Instance.new("UICorner", dropdownBtn).CornerRadius = UDim.new(0,6)
    dropdownBtn.Parent = frame
    
    local dropList = Instance.new("Frame")
    dropList.Name = "DropList"
    dropList.BackgroundColor3 = Color3.fromRGB(40,40,50)
    dropList.BackgroundTransparency = 0.2
    dropList.Size = UDim2.new(0,140,0,0)
    if IS_MOBILE then dropList.Size = UDim2.new(0,160,0,0) end
    dropList.Position = UDim2.new(1,-140,0,35)
    if IS_MOBILE then dropList.Position = UDim2.new(1,-160,0,40) end
    dropList.BorderSizePixel = 0
    dropList.ZIndex = 31
    dropList.ClipsDescendants = true
    dropList.Visible = false
    Instance.new("UICorner", dropList).CornerRadius = UDim.new(0,6)
    dropList.Parent = frame
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Parent = dropList
    
    local function showDropdown()
        dropList.Visible = true
        dropList:TweenSize(UDim2.new(0,140,0,#options * 30), "Out", "Quad", 0.2, true)
        if IS_MOBILE then
            dropList:TweenSize(UDim2.new(0,160,0,#options * 40), "Out", "Quad", 0.2, true)
        end
    end
    
    local function hideDropdown()
        dropList:TweenSize(UDim2.new(0,140,0,0), "Out", "Quad", 0.2, true)
        if IS_MOBILE then
            dropList:TweenSize(UDim2.new(0,160,0,0), "Out", "Quad", 0.2, true)
        end
        task.wait(0.2)
        dropList.Visible = false
    end
    
    dropdownBtn.MouseButton1Click:Connect(function()
        playSound("ButtonClick")
        if dropList.Visible then
            hideDropdown()
        else
            showDropdown()
        end
    end)
    
    for _, opt in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Text = opt
        optBtn.TextColor3 = Settings.TEXT_COLOR
        optBtn.TextSize = 14
        if IS_MOBILE then optBtn.TextSize = 18 end
        optBtn.Font = Enum.Font.Gotham
        optBtn.BackgroundColor3 = Color3.fromRGB(50,50,60)
        optBtn.BackgroundTransparency = 0.3
        optBtn.Size = UDim2.new(1,0,0,30)
        if IS_MOBILE then optBtn.Size = UDim2.new(1,0,0,40) end
        optBtn.BorderSizePixel = 0
        optBtn.ZIndex = 32
        Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0,4)
        optBtn.Parent = dropList
        
        optBtn.MouseButton1Click:Connect(function()
            playSound("ButtonClick")
            dropdownBtn.Text = opt
            hideDropdown()
            if callback then callback(opt) end
            debouncedSaveSettings()
        end)
        
        optBtn.MouseEnter:Connect(function()
            optBtn.BackgroundColor3 = Color3.fromRGB(70,70,80)
        end)
        optBtn.MouseLeave:Connect(function()
            optBtn.BackgroundColor3 = Color3.fromRGB(50,50,60)
        end)
    end
    
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local pos = UserInputService:GetMouseLocation()
            local absPos = frame.AbsolutePosition
            local absSize = frame.AbsoluteSize
            if pos.X < absPos.X or pos.X > absPos.X + absSize.X or pos.Y < absPos.Y or pos.Y > absPos.Y + absSize.Y then
                if dropList.Visible then
                    hideDropdown()
                end
            end
        end
    end)
    
    return frame
end

local function createSettingSliderWithInput(labelText, value, minValue, maxValue, suffix, callback)
    local frame = Instance.new("Frame")
    frame.Name = labelText.."Slider"
    frame.BackgroundTransparency = 1
    frame.Size = UDim2.new(1,0,0,80)
    if IS_MOBILE then frame.Size = UDim2.new(1,0,0,100) end
    
    local label = Instance.new("TextLabel")
    label.Text = labelText
    label.TextColor3 = Settings.TEXT_COLOR
    label.TextSize = 16
    if IS_MOBILE then label.TextSize = 20 end
    label.Font = Enum.Font.GothamBold
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1,0,0,25)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local input = createValueInput(frame, value, minValue, maxValue, suffix, function(newVal)
        local pct = (newVal - minValue) / (maxValue - minValue)
        fill.Size = UDim2.new(pct, 0, 1, 0)
        btn.Position = UDim2.new(pct, -10, 0.5, -10)
        valLabel.Text = tostring(newVal)..suffix
        if callback then callback(newVal) end
        debouncedSaveSettings()
    end)
    input.Position = UDim2.new(1, -120, 0, 0)
    input.Size = UDim2.new(0, 120, 0, 30)
    if IS_MOBILE then
        input.Position = UDim2.new(1, -140, 0, 0)
        input.Size = UDim2.new(0, 140, 0, 40)
    end
    input.Parent = frame
    
    local valLabel = Instance.new("TextLabel")
    valLabel.Name = "ValueLabel"
    valLabel.Text = tostring(value)..suffix
    valLabel.TextColor3 = Settings.PRIMARY_COLOR
    valLabel.TextSize = 16
    if IS_MOBILE then valLabel.TextSize = 20 end
    valLabel.Font = Enum.Font.GothamBold
    valLabel.BackgroundTransparency = 1
    valLabel.Size = UDim2.new(0,120,0,25)
    valLabel.Position = UDim2.new(0,0,0,25)
    valLabel.TextXAlignment = Enum.TextXAlignment.Left
    valLabel.Parent = frame
    
    local bg = Instance.new("Frame")
    bg.Name = "SliderBackground"
    bg.BackgroundColor3 = Color3.fromRGB(40,40,50)
    bg.BackgroundTransparency = 0.2
    bg.Size = UDim2.new(1,0,0,10)
    bg.Position = UDim2.new(0,0,0,55)
    bg.BorderSizePixel = 0
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1,0)
    
    local fill = Instance.new("Frame")
    fill.Name = "SliderFill"
    fill.BackgroundColor3 = Settings.PRIMARY_COLOR
    fill.Size = UDim2.new((value-minValue)/(maxValue-minValue),0,1,0)
    fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)
    createGradient(fill, Settings.PRIMARY_COLOR, Settings.SECONDARY_COLOR, 0)
    
    local btn = Instance.new("TextButton")
    btn.Name = "SliderButton"
    btn.Text = ""
    btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btn.Size = UDim2.new(0,20,0,20)
    btn.Position = UDim2.new((value-minValue)/(maxValue-minValue), -10, 0.5, -10)
    btn.BorderSizePixel = 0
    btn.ZIndex = 5
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1,0)
    
    local dragging = false
    local function updateFromMouse(x)
        local relX = math.clamp(x - bg.AbsolutePosition.X, 0, bg.AbsoluteSize.X)
        local pct = relX / bg.AbsoluteSize.X
        local newVal = minValue + pct * (maxValue - minValue)
        if suffix == " studs" then newVal = math.floor(newVal)
        elseif suffix == " sec" then newVal = math.floor(newVal)
        elseif suffix == " ms" then newVal = math.floor(newVal/10)*10 end
        newVal = math.clamp(newVal, minValue, maxValue)
        local fillPct = (newVal - minValue) / (maxValue - minValue)
        fill.Size = UDim2.new(fillPct, 0, 1, 0)
        btn.Position = UDim2.new(fillPct, -10, 0.5, -10)
        valLabel.Text = tostring(newVal)..suffix
        local inp = input:FindFirstChild("ValueInputBox")
        if inp then inp.Text = tostring(newVal) end
        if callback then callback(newVal) end
    end
    
    btn.MouseButton1Down:Connect(function() dragging = true end)
    bg.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateFromMouse(i.Position.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            updateFromMouse(i.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
            dragging = false
            debouncedSaveSettings()
        end
    end)
    
    fill.Parent = bg
    btn.Parent = bg
    bg.Parent = frame
    return frame
end

-- ========== LIST UPDATE FUNCTIONS ==========
function updateListToggleIcon()
    if not listToggle then return end
    local total = 0
    for _ in pairs(objectCache) do total = total + 1 end
    listToggle.Text = "📋 "..total
end

function updateItemList()
    if not itemListGUI or not itemListGUI.Visible then return end
    
    local container = itemListGUI:FindFirstChild("ItemsContainer")
    local countLabel = itemListGUI:FindFirstChild("ItemCount")
    if not container or not countLabel then return end
    
    for _, c in ipairs(container:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
    
    local items = {}
    for obj, data in pairs(objectCache) do
        if obj and obj.Parent then
            data.position = getObjectPosition(obj)
            data.displayName = getDisplayName(obj)
            table.insert(items, {obj = obj, data = data})
        else
            if data and data.esp then 
                if data.updateConnection then data.updateConnection:Disconnect() end
                if data.tempPart and data.tempPart.Parent then data.tempPart:Destroy() end
                pcall(data.esp.Destroy, data.esp) 
            end
            objectCache[obj] = nil
        end
    end
    
    local filtered = {}
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    for _, it in ipairs(items) do
        local isTool = it.obj:IsA("Tool")
        local isNote = it.obj:IsA("Model") and it.obj.Name == SPECIFIC_MODEL_NAME
        local isSpecial = it.data.specialType ~= nil
        
        if listState.filterType == "all" then
            table.insert(filtered, it)
        elseif listState.filterType == "tool" and isTool then
            table.insert(filtered, it)
        elseif listState.filterType == "note" and isNote then
            table.insert(filtered, it)
        elseif listState.filterType == "special" and isSpecial then
            table.insert(filtered, it)
        end
    end
    
    if listState.searchText and listState.searchText ~= "" then
        local search = string.lower(listState.searchText)
        local searchFiltered = {}
        for _, it in ipairs(filtered) do
            local name = string.lower(it.data.displayName or "")
            if string.find(name, search, 1, true) then
                table.insert(searchFiltered, it)
            end
        end
        filtered = searchFiltered
    end
    
    table.sort(filtered, function(a, b)
        local da, db = a.data, b.data
        local distA = root and (root.Position - da.position).Magnitude or math.huge
        local distB = root and (root.Position - db.position).Magnitude or math.huge
        
        if listState.sortMode == "name" then
            local nameA = da.displayName or ""
            local nameB = db.displayName or ""
            return (listState.sortAsc and nameA < nameB) or nameA > nameB
        elseif listState.sortMode == "distance" then
            return (listState.sortAsc and distA < distB) or distA > distB
        elseif listState.sortMode == "favorite" then
            if da.favorite ~= db.favorite then
                return da.favorite and not db.favorite
            else
                return distA < distB
            end
        else
            return distA < distB
        end
    end)
    
    local total = 0
    for _ in pairs(objectCache) do total = total + 1 end
    countLabel.Text = string.format("Items: %d (showing %d)", total, #filtered)
    updateListToggleIcon()
    
    for i, it in ipairs(filtered) do
        local obj = it.obj
        local data = it.data
        local dist = root and (root.Position - data.position).Magnitude or 0
        local distText = root and string.format("%.0f studs", dist) or "Unknown"
        local specialType = data.specialType
        local icon = specialType and SPECIAL_ICONS[specialType] or (obj:IsA("Tool") and "🛠️" or "📝")
        
        local card = Instance.new("Frame")
        card.Name = "ItemCard"
        card.BackgroundColor3 = Color3.fromRGB(40,50,60)
        card.BackgroundTransparency = 0.1
        card.Size = UDim2.new(1, -20, 0, 70)
        if IS_MOBILE then card.Size = UDim2.new(1, -20, 0, 100) end
        card.BorderSizePixel = 0
        card.LayoutOrder = i
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
        
        -- Hover ESP
        local hoverTimer = nil
        card.MouseEnter:Connect(function()
            if hoverTimer then hoverTimer:Cancel() end
            if data.esp and not data.esp.Enabled and guiEnabled then
                data.esp.Enabled = true
            end
        end)
        card.MouseLeave:Connect(function()
            hoverTimer = task.delay(0.5, function()
                if data.esp and data.espEnabled == false then
                    data.esp.Enabled = false
                end
            end)
        end)
        
        local iconLabel = Instance.new("TextLabel")
        iconLabel.Text = icon
        iconLabel.TextColor3 = Settings.TEXT_COLOR
        iconLabel.TextSize = 24
        if IS_MOBILE then iconLabel.TextSize = 32 end
        iconLabel.Font = Enum.Font.GothamBold
        iconLabel.BackgroundTransparency = 1
        iconLabel.Size = UDim2.new(0, 30, 0, 30)
        if IS_MOBILE then iconLabel.Size = UDim2.new(0, 40, 0, 40) end
        iconLabel.Position = UDim2.new(0, 5, 0.5, -15)
        iconLabel.Parent = card
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Text = data.displayName or obj.Name
        nameLabel.TextColor3 = Settings.TEXT_COLOR
        nameLabel.TextSize = 14
        if IS_MOBILE then nameLabel.TextSize = 18 end
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.BackgroundTransparency = 1
        nameLabel.Size = UDim2.new(0, 150, 0, 30)
        nameLabel.Position = UDim2.new(0, 40, 0.5, -15)
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
        nameLabel.Parent = card
        
        local distLabel = Instance.new("TextLabel")
        distLabel.Text = distText
        distLabel.TextColor3 = Settings.PRIMARY_COLOR
        distLabel.TextSize = 12
        if IS_MOBILE then distLabel.TextSize = 16 end
        distLabel.Font = Enum.Font.Gotham
        distLabel.BackgroundTransparency = 1
        distLabel.Size = UDim2.new(0, 80, 0, 30)
        distLabel.Position = UDim2.new(0, 200, 0.5, -15)
        distLabel.Parent = card
        
        if (specialType == "Boss" or specialType == "Sukuna") and data.health then
            local healthText = Instance.new("TextLabel")
            healthText.Text = string.format("❤️ %d/%d (%d%%)", data.health, data.maxHealth, math.floor((data.health/data.maxHealth)*100))
            healthText.TextColor3 = Color3.fromRGB(255,100,100)
            healthText.TextSize = 11
            if IS_MOBILE then healthText.TextSize = 14 end
            healthText.Font = Enum.Font.GothamBold
            healthText.BackgroundTransparency = 1
            healthText.Size = UDim2.new(0, 120, 0, 20)
            healthText.Position = UDim2.new(0, 290, 0.5, -25)
            healthText.Parent = card
            
            local hpBarBg = Instance.new("Frame")
            hpBarBg.BackgroundColor3 = Color3.fromRGB(60,60,60)
            hpBarBg.Size = UDim2.new(0, 60, 0, 6)
            hpBarBg.Position = UDim2.new(0, 290, 0.5, 5)
            hpBarBg.BorderSizePixel = 0
            Instance.new("UICorner", hpBarBg).CornerRadius = UDim.new(0,3)
            hpBarBg.Parent = card
            
            local hpBarFill = Instance.new("Frame")
            hpBarFill.BackgroundColor3 = Color3.fromRGB(255,70,70)
            hpBarFill.Size = UDim2.new(data.health/data.maxHealth, 0, 1, 0)
            hpBarFill.BorderSizePixel = 0
            Instance.new("UICorner", hpBarFill).CornerRadius = UDim.new(0,3)
            hpBarFill.Parent = hpBarBg
        end
        
        local favBtn = Instance.new("TextButton")
        favBtn.Text = data.favorite and "★" or "☆"
        favBtn.TextColor3 = data.favorite and Settings.FAVORITE_COLOR or Color3.fromRGB(150,150,150)
        favBtn.TextSize = 20
        if IS_MOBILE then favBtn.TextSize = 26 end
        favBtn.Font = Enum.Font.GothamBold
        favBtn.BackgroundTransparency = 1
        favBtn.Size = UDim2.new(0, 30, 0, 30)
        favBtn.Position = UDim2.new(0, 400, 0.5, -15)
        favBtn.ZIndex = 23
        favBtn.AutoButtonColor = false
        favBtn.Parent = card
        favBtn.MouseButton1Click:Connect(function() playSound("ButtonClick"); toggleFavorite(obj) end)
        
        local espBtn = Instance.new("TextButton")
        espBtn.Text = "👁️"
        espBtn.TextColor3 = data.esp and data.espEnabled and Settings.ESP_ENABLED_COLOR or Settings.ESP_DISABLED_COLOR
        espBtn.TextSize = 20
        if IS_MOBILE then espBtn.TextSize = 26 end
        espBtn.Font = Enum.Font.GothamBold
        espBtn.BackgroundTransparency = 1
        espBtn.Size = UDim2.new(0, 30, 0, 30)
        espBtn.Position = UDim2.new(0, 440, 0.5, -15)
        espBtn.ZIndex = 23
        espBtn.AutoButtonColor = false
        espBtn.Parent = card
        espBtn.MouseButton1Click:Connect(function()
            playSound("ButtonClick")
            if data.esp then
                setESPEnabled(obj, not data.espEnabled)
            else
                local esp = createInfoCard(obj)
                if esp then
                    data.esp = esp
                    data.espEnabled = true
                    esp.Enabled = guiEnabled
                end
            end
            espBtn.TextColor3 = data.esp and data.espEnabled and Settings.ESP_ENABLED_COLOR or Settings.ESP_DISABLED_COLOR
        end)
        
        local tpBtn = Instance.new("TextButton")
        tpBtn.Text = "TP"
        tpBtn.TextColor3 = Settings.TEXT_COLOR
        tpBtn.TextSize = 12
        if IS_MOBILE then tpBtn.TextSize = 16 end
        tpBtn.Font = Enum.Font.GothamBold
        tpBtn.BackgroundColor3 = Settings.TELEPORT_COLOR
        tpBtn.BackgroundTransparency = 0.2
        tpBtn.Size = UDim2.new(0, 40, 0, 30)
        if IS_MOBILE then tpBtn.Size = UDim2.new(0, 50, 0, 40) end
        tpBtn.Position = UDim2.new(1, -50, 0.5, -15)
        tpBtn.BorderSizePixel = 0
        tpBtn.ZIndex = 22
        tpBtn.AutoButtonColor = true
        Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 6)
        local deb = false
        tpBtn.MouseButton1Click:Connect(function()
            playSound("ButtonClick")
            if deb then return end
            deb = true
            teleportToObject(obj)
            deb = false
        end)
        tpBtn.Parent = card
        
        card.Parent = container
    end
    
    updateBossStatusPanel()
end

function updateBossStatusPanel()
    local panel = itemListGUI and itemListGUI:FindFirstChild("BossStatusPanel")
    if not panel then return end
    
    local bossObj, bossData = nil, nil
    for obj, data in pairs(objectCache) do
        if (data.specialType == "Boss" or data.specialType == "Sukuna") and obj and obj.Parent then
            bossObj = obj
            bossData = data
            break
        end
    end
    
    if bossObj and bossData then
        panel.Visible = true
        local nameLabel = panel:FindFirstChild("BossName")
        local hpLabel = panel:FindFirstChild("BossHP")
        local tpButton = panel:FindFirstChild("TeleportButton")
        if nameLabel then
            nameLabel.Text = SPECIAL_NAMES[bossData.specialType]
        end
        if hpLabel and bossData.health and bossData.maxHealth then
            local percent = math.floor((bossData.health / bossData.maxHealth) * 100)
            hpLabel.Text = string.format("❤️ %d / %d (%d%%)", bossData.health, bossData.maxHealth, percent)
        end
        if tpButton then
            tpButton.MouseButton1Click:Connect(function()
                teleportToObject(bossObj)
            end)
        end
    else
        panel.Visible = false
    end
end

-- END OF PART 2/4

--[[
    Nexus Tracker v10.0 – Advanced ESP, LOD, Auto Teleport, Enhanced Favorites, Debug
    PART 3/4
]]

-- ========== SETTINGS WITH TABS (including new tabs) ==========
local function createSettingsGUI()
    if settingsGUI and settingsGUI.Parent then settingsGUI:Destroy() end
    settingsGUI = Instance.new("Frame")
    settingsGUI.Name = "SettingsGUI"
    settingsGUI.BackgroundColor3 = Settings.LIST_COLOR
    settingsGUI.BackgroundTransparency = 0.2
    settingsGUI.Size = UDim2.new(0, 800, 0, 600)  -- increased for new tabs
    if IS_MOBILE then settingsGUI.Size = UDim2.new(0, 900, 0, 700) end
    settingsGUI.Position = savedSettingsGUIPos or UDim2.new(0.5, -400, 0.5, -300)
    settingsGUI.BorderSizePixel = 0
    settingsGUI.Visible = false
    settingsGUI.ZIndex = 20
    Instance.new("UICorner", settingsGUI).CornerRadius = UDim.new(0, 12)
    
    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.BackgroundColor3 = Settings.PRIMARY_COLOR
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.BorderSizePixel = 0
    titleBar.ZIndex = 21
    Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12, 0, 0)
    createGradient(titleBar, Settings.PRIMARY_COLOR, Settings.SECONDARY_COLOR, 45)
    
    local title = Instance.new("TextLabel")
    title.Text = "SETTINGS"
    title.TextColor3 = Settings.TEXT_COLOR
    title.TextSize = 22
    if IS_MOBILE then title.TextSize = 28 end
    title.Font = Enum.Font.GothamBold
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -100, 1, 0)
    title.Position = UDim2.new(0, 20, 0, 0)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 23
    title.Parent = titleBar
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Settings.TEXT_COLOR
    closeBtn.TextSize = 24
    if IS_MOBILE then closeBtn.TextSize = 30 end
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
    closeBtn.BackgroundTransparency = 0.3
    closeBtn.Size = UDim2.new(0, 40, 0, 40)
    if IS_MOBILE then closeBtn.Size = UDim2.new(0, 50, 0, 50) end
    closeBtn.Position = UDim2.new(1, -50, 0, 5)
    closeBtn.BorderSizePixel = 0
    closeBtn.ZIndex = 22
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
    closeBtn.MouseButton1Click:Connect(function() playSound("ButtonClick"); toggleSettings(false) end)
    closeBtn.Parent = titleBar
    titleBar.Parent = settingsGUI
    
    -- Tab bar
    local tabBar = Instance.new("Frame")
    tabBar.Name = "TabBar"
    tabBar.BackgroundTransparency = 1
    tabBar.Size = UDim2.new(1, -20, 0, 40)
    tabBar.Position = UDim2.new(0, 10, 0, 60)
    tabBar.ZIndex = 21
    tabBar.Parent = settingsGUI
    
    -- Tab buttons
    local tabs = {
        {name = "🌍 Global", color = Settings.PRIMARY_COLOR},
        {name = "🔔 Notifications", color = Settings.SECONDARY_COLOR},
        {name = "💀 Death", color = Color3.fromRGB(150,0,0)},
        {name = "🎨 Visuals", color = Color3.fromRGB(150,100,200)},
        {name = "⚡ Auto TP", color = Color3.fromRGB(200,150,0)},
        {name = "⭐ Favorites", color = Settings.FAVORITE_COLOR},
        {name = "🐞 Debug", color = Color3.fromRGB(100,100,100)},
    }
    
    local tabButtons = {}
    local containers = {}
    for i, tab in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Name = "Tab"..i
        btn.Text = tab.name
        btn.TextColor3 = Settings.TEXT_COLOR
        btn.TextSize = 14
        if IS_MOBILE then btn.TextSize = 18 end
        btn.Font = Enum.Font.GothamBold
        btn.BackgroundColor3 = tab.color
        btn.BackgroundTransparency = i == 1 and 0.2 or 0.5
        btn.Size = UDim2.new(0, 100, 0, 30)
        if IS_MOBILE then btn.Size = UDim2.new(0, 120, 0, 40) end
        btn.Position = UDim2.new(0, (i-1)*110, 0.5, -15)
        btn.BorderSizePixel = 0
        btn.ZIndex = 22
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        btn.Parent = tabBar
        tabButtons[i] = btn
        
        local container = Instance.new("ScrollingFrame")
        container.Name = "Container"..i
        container.BackgroundTransparency = 1
        container.Size = UDim2.new(1, -20, 1, -140)
        container.Position = UDim2.new(0, 10, 0, 110)
        container.BorderSizePixel = 0
        container.ScrollBarThickness = 8
        container.AutomaticCanvasSize = Enum.AutomaticSize.Y
        container.ZIndex = 21
        container.Visible = (i == 1)
        Instance.new("UIListLayout", container).Padding = UDim.new(0, 15)
        container.Parent = settingsGUI
        containers[i] = container
    end
    
    local function setActiveTab(index)
        for i, btn in ipairs(tabButtons) do
            btn.BackgroundTransparency = i == index and 0.2 or 0.5
            containers[i].Visible = (i == index)
        end
    end
    
    for i, btn in ipairs(tabButtons) do
        btn.MouseButton1Click:Connect(function() playSound("ButtonClick"); setActiveTab(i) end)
    end
    
    -- Fill tabs
    
    -- Tab 1: Global
    do
        local c = containers[1]
        createSettingSliderWithInput("Max Distance", Settings.MAX_DISTANCE, 100, 15000, " studs", function(v) Settings.MAX_DISTANCE = v end).Parent = c
        createSettingSliderWithInput("Fade Start", Settings.FADE_START_DISTANCE, 50, 10000, " studs", function(v) Settings.FADE_START_DISTANCE = v end).Parent = c
        createSettingSliderWithInput("Teleport Range", Settings.TELEPORT_RANGE, 10, 5000, " studs", function(v) Settings.TELEPORT_RANGE = v end).Parent = c
        createSettingSliderWithInput("ESP Update (ms)", Settings.UPDATE_INTERVAL * 1000, 10, 5000, " ms", function(v) Settings.UPDATE_INTERVAL = v/1000 end).Parent = c
        createSettingSliderWithInput("List Refresh (ms)", Settings.LIST_UPDATE_INTERVAL * 1000, 100, 5000, " ms", function(v) Settings.LIST_UPDATE_INTERVAL = v/1000 end).Parent = c
        createSettingSliderWithInput("Sound Volume", Settings.SOUND_VOLUME * 100, 0, 100, "%", function(v) Settings.SOUND_VOLUME = v/100 end).Parent = c
        createSettingSliderWithInput("Hide ESP Near (studs)", Settings.HIDE_NEAR_DISTANCE, 0, 500, " studs", function(v) Settings.HIDE_NEAR_DISTANCE = v end).Parent = c
        createToggleSetting(c, "Debug Mode (script)", DEBUG, function(v) DEBUG = v end).Parent = c
        createToggleSetting(c, "Sound Enabled", Settings.SOUND_ENABLED, function(v) Settings.SOUND_ENABLED = v end).Parent = c
    end
    
    -- Tab 2: Notifications
    do
        local c = containers[2]
        createSettingSliderWithInput("Notif Duration", Settings.NOTIFICATION_DURATION, 1, 60, " sec", function(v) Settings.NOTIFICATION_DURATION = v end).Parent = c
        
        local notifPosDropdown = createDropdown(c, "Notification Position", 
            {"BottomRight", "TopRight", "BottomLeft", "TopLeft", "CenterTop", "CenterBottom"}, 
            Settings.NOTIFICATION_POSITION, 
            function(val) 
                Settings.NOTIFICATION_POSITION = val
                updateNotificationPosition()
            end)
        notifPosDropdown.Parent = c
        
        local numFrame = Instance.new("Frame")
        numFrame.Name = "NotifNumFrame"
        numFrame.BackgroundTransparency = 1
        numFrame.Size = UDim2.new(1,0,0,40)
        numFrame.Parent = c
        
        local numLabel = Instance.new("TextLabel")
        numLabel.Text = "Or enter number (1-6):"
        numLabel.TextColor3 = Settings.TEXT_COLOR
        numLabel.TextSize = 14
        if IS_MOBILE then numLabel.TextSize = 18 end
        numLabel.Font = Enum.Font.Gotham
        numLabel.BackgroundTransparency = 1
        numLabel.Size = UDim2.new(0,150,0,30)
        numLabel.Position = UDim2.new(0,0,0.5,-15)
        numLabel.TextXAlignment = Enum.TextXAlignment.Left
        numLabel.Parent = numFrame
        
        local numInput = Instance.new("TextBox")
        numInput.Name = "NotifNumInput"
        local indexMap = {BottomRight=1, TopRight=2, BottomLeft=3, TopLeft=4, CenterTop=5, CenterBottom=6}
        numInput.Text = tostring(indexMap[Settings.NOTIFICATION_POSITION] or 1)
        numInput.TextColor3 = Settings.TEXT_COLOR
        numInput.PlaceholderText = "1-6"
        numInput.TextSize = 14
        if IS_MOBILE then numInput.TextSize = 18 end
        numInput.Font = Enum.Font.Gotham
        numInput.BackgroundColor3 = Color3.fromRGB(40,40,50)
        numInput.BackgroundTransparency = 0.2
        numInput.Size = UDim2.new(0,50,0,30)
        if IS_MOBILE then numInput.Size = UDim2.new(0,70,0,40) end
        numInput.Position = UDim2.new(1,-60,0.5,-15)
        numInput.BorderSizePixel = 0
        Instance.new("UICorner", numInput).CornerRadius = UDim.new(0,6)
        Instance.new("UIPadding", numInput).PaddingLeft = UDim.new(0,8)
        numInput.Parent = numFrame
        
        numInput.FocusLost:Connect(function()
            local val = tonumber(numInput.Text)
            if val and val >=1 and val <=6 then
                local options = {"BottomRight", "TopRight", "BottomLeft", "TopLeft", "CenterTop", "CenterBottom"}
                local selected = options[val]
                Settings.NOTIFICATION_POSITION = selected
                updateNotificationPosition()
                local dropdownBtn = notifPosDropdown:FindFirstChildOfClass("TextButton")
                if dropdownBtn then dropdownBtn.Text = selected end
                debouncedSaveSettings()
            else
                local currentIndex = indexMap[Settings.NOTIFICATION_POSITION] or 1
                numInput.Text = tostring(currentIndex)
            end
        end)
        
        local testNotifBtn = Instance.new("TextButton")
        testNotifBtn.Text = "🔔 TEST NOTIFICATION"
        testNotifBtn.TextColor3 = Settings.TEXT_COLOR
        testNotifBtn.TextSize = 16
        if IS_MOBILE then testNotifBtn.TextSize = 20 end
        testNotifBtn.Font = Enum.Font.GothamBold
        testNotifBtn.BackgroundColor3 = Color3.fromRGB(100,100,200)
        testNotifBtn.BackgroundTransparency = 0.2
        testNotifBtn.Size = UDim2.new(1, -40, 0, 40)
        testNotifBtn.Position = UDim2.new(0, 20, 0, 0)
        testNotifBtn.BorderSizePixel = 0
        Instance.new("UICorner", testNotifBtn).CornerRadius = UDim.new(0, 8)
        testNotifBtn.MouseButton1Click:Connect(function()
            playSound("ButtonClick")
            createSpawnNotification("📢 TEST", "This is a test notification", nil, 3, Color3.fromRGB(100,200,100))
        end)
        testNotifBtn.Parent = c
    end
    
    -- Tab 3: Death Return
    do
        local c = containers[3]
        local deathToggle = createToggleSetting(c, "Enable Death Return", Settings.DEATH_RETURN_ENABLED, function(v)
            Settings.DEATH_RETURN_ENABLED = v
            enableDeathReturn(v)
            debouncedSaveSettings()
        end)
        deathToggle.Parent = c
        
        local animIdFrame = Instance.new("Frame")
        animIdFrame.Name = "AnimationIdFrame"
        animIdFrame.BackgroundTransparency = 1
        animIdFrame.Size = UDim2.new(1,0,0,50)
        animIdFrame.Parent = c
        
        local animIdLabel = Instance.new("TextLabel")
        animIdLabel.Text = "Animation ID:"
        animIdLabel.TextColor3 = Settings.TEXT_COLOR
        animIdLabel.TextSize = 16
        if IS_MOBILE then animIdLabel.TextSize = 20 end
        animIdLabel.Font = Enum.Font.GothamBold
        animIdLabel.BackgroundTransparency = 1
        animIdLabel.Size = UDim2.new(0,150,0,25)
        animIdLabel.Position = UDim2.new(0,0,0.5,-12.5)
        animIdLabel.TextXAlignment = Enum.TextXAlignment.Left
        animIdLabel.Parent = animIdFrame
        
        local animIdInput = Instance.new("TextBox")
        animIdInput.Name = "AnimationIdInput"
        animIdInput.Text = tostring(Settings.DEATH_ANIMATION_ID)
        animIdInput.PlaceholderText = "Enter animation ID"
        animIdInput.TextColor3 = Settings.TEXT_COLOR
        animIdInput.PlaceholderColor3 = Color3.fromRGB(150,150,150)
        animIdInput.TextSize = 14
        if IS_MOBILE then animIdInput.TextSize = 18 end
        animIdInput.Font = Enum.Font.Gotham
        animIdInput.BackgroundColor3 = Color3.fromRGB(40,40,50)
        animIdInput.BackgroundTransparency = 0.2
        animIdInput.Size = UDim2.new(0,200,0,30)
        if IS_MOBILE then animIdInput.Size = UDim2.new(0,250,0,40) end
        animIdInput.Position = UDim2.new(1,-210,0.5,-15)
        animIdInput.BorderSizePixel = 0
        animIdInput.ZIndex = 22
        Instance.new("UICorner", animIdInput).CornerRadius = UDim.new(0,6)
        Instance.new("UIPadding", animIdInput).PaddingLeft = UDim.new(0,8)
        animIdInput.Parent = animIdFrame
        
        animIdInput:GetPropertyChangedSignal("Text"):Connect(function()
            local text = animIdInput.Text
            local filtered = text:gsub("%D", "")
            if filtered ~= text then animIdInput.Text = filtered end
        end)
        
        animIdInput.FocusLost:Connect(function()
            local val = animIdInput.Text
            if val == "" then val = "0" end
            Settings.DEATH_ANIMATION_ID = val
            debouncedSaveSettings()
        end)
        
        local testAnimBtn = Instance.new("TextButton")
        testAnimBtn.Text = "▶ Test Animation"
        testAnimBtn.TextColor3 = Settings.TEXT_COLOR
        testAnimBtn.TextSize = 14
        if IS_MOBILE then testAnimBtn.TextSize = 18 end
        testAnimBtn.Font = Enum.Font.GothamBold
        testAnimBtn.BackgroundColor3 = Color3.fromRGB(100,100,200)
        testAnimBtn.BackgroundTransparency = 0.2
        testAnimBtn.Size = UDim2.new(1,-40,0,40)
        testAnimBtn.Position = UDim2.new(0,20,0,0)
        testAnimBtn.BorderSizePixel = 0
        Instance.new("UICorner", testAnimBtn).CornerRadius = UDim.new(0,8)
        testAnimBtn.MouseButton1Click:Connect(function()
            playSound("ButtonClick")
            if LocalPlayer.Character then
                stopAllAnimations(LocalPlayer.Character)
                playNewAnimation(LocalPlayer.Character)
            end
        end)
        testAnimBtn.Parent = c
    end
    
        -- Tab 4: Visuals
    do
        local c = containers[4]
        
        -- LOD Section header
        local lodHeader = Instance.new("TextLabel")
        lodHeader.Text = "LOD Settings"
        lodHeader.TextColor3 = Settings.PRIMARY_COLOR
        lodHeader.TextSize = 18
        lodHeader.Font = Enum.Font.GothamBold
        lodHeader.BackgroundTransparency = 1
        lodHeader.Size = UDim2.new(1,0,0,30)
        lodHeader.TextXAlignment = Enum.TextXAlignment.Left
        lodHeader.Parent = c
        
        createToggleSetting(c, "Enable LOD (mobile default)", Settings.VISUAL_LOD_ENABLED, function(v) Settings.VISUAL_LOD_ENABLED = v; debouncedSaveSettings() end).Parent = c
        createSettingSliderWithInput("Icon Only Threshold", Settings.VISUAL_ICON_ONLY_THRESHOLD, 1, 50, " objects", function(v) Settings.VISUAL_ICON_ONLY_THRESHOLD = v end).Parent = c
        createSettingSliderWithInput("LOD Icon Distance", Settings.VISUAL_LOD_DIST_ICON, 100, 5000, " studs", function(v) Settings.VISUAL_LOD_DIST_ICON = v end).Parent = c
        createSettingSliderWithInput("LOD Brief Distance", Settings.VISUAL_LOD_DIST_BRIEF, 50, 2000, " studs", function(v) Settings.VISUAL_LOD_DIST_BRIEF = v end).Parent = c
        createToggleSetting(c, "Frustum Culling", Settings.VISUAL_FRUSTUM_CULLING, function(v) Settings.VISUAL_FRUSTUM_CULLING = v; debouncedSaveSettings() end).Parent = c
        createToggleSetting(c, "Bypass LOD for Bosses", Settings.VISUAL_BOSS_BYPASS_LOD or false, function(v) Settings.VISUAL_BOSS_BYPASS_LOD = v; debouncedSaveSettings() end).Parent = c
        
        -- Separator
        local separator1 = Instance.new("Frame")
        separator1.BackgroundColor3 = Color3.fromRGB(100,100,100)
        separator1.BackgroundTransparency = 0.7
        separator1.Size = UDim2.new(1,0,0,2)
        separator1.BorderSizePixel = 0
        separator1.Parent = c
        
        -- General Visual Settings header
        local generalHeader = Instance.new("TextLabel")
        generalHeader.Text = "General Visual Settings"
        generalHeader.TextColor3 = Settings.PRIMARY_COLOR
        generalHeader.TextSize = 18
        generalHeader.Font = Enum.Font.GothamBold
        generalHeader.BackgroundTransparency = 1
        generalHeader.Size = UDim2.new(1,0,0,30)
        generalHeader.TextXAlignment = Enum.TextXAlignment.Left
        generalHeader.Parent = c
        
        createSettingSliderWithInput("Visual Size Scale", Settings.VISUAL_SIZE_SCALE * 100, 50, 200, "%", function(v) Settings.VISUAL_SIZE_SCALE = v/100 end).Parent = c
        createSettingSliderWithInput("Visual Transparency", Settings.VISUAL_TRANSPARENCY * 100, 0, 100, "%", function(v) Settings.VISUAL_TRANSPARENCY = v/100 end).Parent = c
        
        -- Separator
        local separator2 = Instance.new("Frame")
        separator2.BackgroundColor3 = Color3.fromRGB(100,100,100)
        separator2.BackgroundTransparency = 0.7
        separator2.Size = UDim2.new(1,0,0,2)
        separator2.BorderSizePixel = 0
        separator2.Parent = c
        
        -- Object Colors header
        local colorHeader = Instance.new("TextLabel")
        colorHeader.Text = "Object Colors"
        colorHeader.TextColor3 = Settings.PRIMARY_COLOR
        colorHeader.TextSize = 18
        colorHeader.Font = Enum.Font.GothamBold
        colorHeader.BackgroundTransparency = 1
        colorHeader.Size = UDim2.new(1,0,0,30)
        colorHeader.TextXAlignment = Enum.TextXAlignment.Left
        colorHeader.Parent = c
        
        -- Colors for each type
        for objType, color in pairs(Settings.VISUAL_COLORS) do
            local frame = Instance.new("Frame")
            frame.BackgroundTransparency = 1
            frame.Size = UDim2.new(1,0,0,40)
            frame.Parent = c
            
            local label = Instance.new("TextLabel")
            label.Text = objType .. ":"
            label.TextColor3 = Settings.TEXT_COLOR
            label.TextSize = 14
            label.Font = Enum.Font.Gotham
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(0,100,1,0)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = frame
            
            local colorBox = Instance.new("TextBox")
            colorBox.Text = string.format("%d,%d,%d", color.R*255, color.G*255, color.B*255)
            colorBox.PlaceholderText = "R,G,B"
            colorBox.TextColor3 = Settings.TEXT_COLOR
            colorBox.TextSize = 14
            colorBox.Font = Enum.Font.Gotham
            colorBox.BackgroundColor3 = Color3.fromRGB(40,40,50)
            colorBox.BackgroundTransparency = 0.2
            colorBox.Size = UDim2.new(0,120,0,30)
            colorBox.Position = UDim2.new(1,-130,0.5,-15)
            colorBox.BorderSizePixel = 0
            Instance.new("UICorner", colorBox).CornerRadius = UDim.new(0,6)
            colorBox.FocusLost:Connect(function()
                local r,g,b = colorBox.Text:match("(%d+),%s*(%d+),%s*(%d+)")
                if r and g and b then
                    Settings.VISUAL_COLORS[objType] = Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b))
                    debouncedSaveSettings()
                end
            end)
            colorBox.Parent = frame
        end
    end
    -- Tab 5: Auto Teleport
    do
        local c = containers[5]
        createToggleSetting(c, "Enable Auto Teleport to Boss", Settings.AUTO_TELEPORT_ENABLED, function(v) Settings.AUTO_TELEPORT_ENABLED = v; debouncedSaveSettings() end).Parent = c
        createSettingSliderWithInput("Teleport Delay", Settings.AUTO_TELEPORT_DELAY, 0, 10, " sec", function(v) Settings.AUTO_TELEPORT_DELAY = v end).Parent = c
        createToggleSetting(c, "Show Warning", Settings.AUTO_TELEPORT_WARNING, function(v) Settings.AUTO_TELEPORT_WARNING = v; debouncedSaveSettings() end).Parent = c
    end
    
    -- Tab 6: Favorites
    do
        local c = containers[6]
        -- Favorite groups (simplified - just list)
        local groupsFrame = Instance.new("Frame")
        groupsFrame.BackgroundTransparency = 1
        groupsFrame.Size = UDim2.new(1,0,0,60)
        groupsFrame.Parent = c
        
        local groupsLabel = Instance.new("TextLabel")
        groupsLabel.Text = "Favorite Groups (comma separated):"
        groupsLabel.TextColor3 = Settings.TEXT_COLOR
        groupsLabel.TextSize = 14
        groupsLabel.Font = Enum.Font.Gotham
        groupsLabel.BackgroundTransparency = 1
        groupsLabel.Size = UDim2.new(1,0,0,20)
        groupsLabel.TextXAlignment = Enum.TextXAlignment.Left
        groupsLabel.Parent = groupsFrame
        
        local groupsInput = Instance.new("TextBox")
        groupsInput.Text = table.concat(Settings.FAVORITE_GROUPS, ",")
        groupsInput.PlaceholderText = "Main,Secondary,Bosses"
        groupsInput.TextColor3 = Settings.TEXT_COLOR
        groupsInput.TextSize = 14
        groupsInput.Font = Enum.Font.Gotham
        groupsInput.BackgroundColor3 = Color3.fromRGB(40,40,50)
        groupsInput.BackgroundTransparency = 0.2
        groupsInput.Size = UDim2.new(1,-20,0,30)
        groupsInput.Position = UDim2.new(0,10,0,25)
        groupsInput.BorderSizePixel = 0
        Instance.new("UICorner", groupsInput).CornerRadius = UDim.new(0,6)
        groupsInput.FocusLost:Connect(function()
            local list = {}
            for word in groupsInput.Text:gmatch("[^,]+") do
                table.insert(list, word:match("^%s*(.-)%s*$"))
            end
            if #list > 0 then
                Settings.FAVORITE_GROUPS = list
                debouncedSaveSettings()
            end
        end)
        groupsInput.Parent = groupsFrame
        
        -- Active group (select from list)
        local activeFrame = Instance.new("Frame")
        activeFrame.BackgroundTransparency = 1
        activeFrame.Size = UDim2.new(1,0,0,40)
        activeFrame.Parent = c
        
        local activeLabel = Instance.new("TextLabel")
        activeLabel.Text = "Active Group:"
        activeLabel.TextColor3 = Settings.TEXT_COLOR
        activeLabel.TextSize = 14
        activeLabel.Font = Enum.Font.Gotham
        activeLabel.BackgroundTransparency = 1
        activeLabel.Size = UDim2.new(0,100,1,0)
        activeLabel.TextXAlignment = Enum.TextXAlignment.Left
        activeLabel.Parent = activeFrame
        
        local activeDropdown = createDropdown(activeFrame, "", Settings.FAVORITE_GROUPS, Settings.FAVORITE_GROUPS[Settings.FAVORITE_ACTIVE_GROUP] or "Main", function(val)
            for i, name in ipairs(Settings.FAVORITE_GROUPS) do
                if name == val then
                    Settings.FAVORITE_ACTIVE_GROUP = i
                    break
                end
            end
            debouncedSaveSettings()
        end)
        activeDropdown.Position = UDim2.new(1,-150,0,0)
        activeDropdown.Size = UDim2.new(0,150,0,30)
        activeDropdown.Parent = activeFrame
        
        -- Auto keywords
        local autoFrame = Instance.new("Frame")
        autoFrame.BackgroundTransparency = 1
        autoFrame.Size = UDim2.new(1,0,0,60)
        autoFrame.Parent = c

        -- Auto-favorite names display/edit
        local autoNamesFrame = Instance.new("Frame")
        autoNamesFrame.BackgroundTransparency = 1
        autoNamesFrame.Size = UDim2.new(1,0,0,80)
        autoNamesFrame.Parent = c
        
        local autoNamesLabel = Instance.new("TextLabel")
        autoNamesLabel.Text = "Auto-favorite names (comma separated):"
        autoNamesLabel.TextColor3 = Settings.TEXT_COLOR
        autoNamesLabel.TextSize = 14
        autoNamesLabel.Font = Enum.Font.Gotham
        autoNamesLabel.BackgroundTransparency = 1
        autoNamesLabel.Size = UDim2.new(1,0,0,20)
        autoNamesLabel.TextXAlignment = Enum.TextXAlignment.Left
        autoNamesLabel.Parent = autoNamesFrame
        
        local autoNamesInput = Instance.new("TextBox")
        autoNamesInput.Text = table.concat(Settings.AUTO_FAVORITE_NAMES, ", ")
        autoNamesInput.PlaceholderText = "e.g. Stand Arrow, Mystic Hourglass"
        autoNamesInput.TextColor3 = Settings.TEXT_COLOR
        autoNamesInput.TextSize = 14
        autoNamesInput.Font = Enum.Font.Gotham
        autoNamesInput.BackgroundColor3 = Color3.fromRGB(40,40,50)
        autoNamesInput.BackgroundTransparency = 0.2
        autoNamesInput.Size = UDim2.new(1,-20,0,30)
        autoNamesInput.Position = UDim2.new(0,10,0,25)
        autoNamesInput.BorderSizePixel = 0
        Instance.new("UICorner", autoNamesInput).CornerRadius = UDim.new(0,6)
        Instance.new("UIPadding", autoNamesInput).PaddingLeft = UDim.new(0,8)
        autoNamesInput.Parent = autoNamesFrame
        
        -- Update list on focus lost
        autoNamesInput.FocusLost:Connect(function()
            local list = {}
            for word in autoNamesInput.Text:gmatch("[^,]+") do
                table.insert(list, word:match("^%s*(.-)%s*$")) -- trim spaces
            end
            Settings.AUTO_FAVORITE_NAMES = list
            -- Apply new rule to all existing objects
            for obj, data in pairs(objectCache) do
                local shouldBeFavorite = tableFind(list, obj.Name) or false
                if data.favorite ~= shouldBeFavorite then
                    data.favorite = shouldBeFavorite
                end
            end
            if itemListVisible then pcall(updateItemList) end
            debouncedSaveSettings()
        end)
        
        local autoLabel = Instance.new("TextLabel")
        autoLabel.Text = "Auto-favorite keywords (comma):"
        autoLabel.TextColor3 = Settings.TEXT_COLOR
        autoLabel.TextSize = 14
        autoLabel.Font = Enum.Font.Gotham
        autoLabel.BackgroundTransparency = 1
        autoLabel.Size = UDim2.new(1,0,0,20)
        autoLabel.TextXAlignment = Enum.TextXAlignment.Left
        autoLabel.Parent = autoFrame
        
        local autoInput = Instance.new("TextBox")
        autoInput.Text = table.concat(Settings.FAVORITE_AUTO_KEYWORDS, ",")
        autoInput.PlaceholderText = "boss,legendary,rare"
        autoInput.TextColor3 = Settings.TEXT_COLOR
        autoInput.TextSize = 14
        autoInput.Font = Enum.Font.Gotham
        autoInput.BackgroundColor3 = Color3.fromRGB(40,40,50)
        autoInput.BackgroundTransparency = 0.2
        autoInput.Size = UDim2.new(1,-20,0,30)
        autoInput.Position = UDim2.new(0,10,0,25)
        autoInput.BorderSizePixel = 0
        Instance.new("UICorner", autoInput).CornerRadius = UDim.new(0,6)
        autoInput.FocusLost:Connect(function()
            local list = {}
            for word in autoInput.Text:gmatch("[^,]+") do
                table.insert(list, word:match("^%s*(.-)%s*$"))
            end
            Settings.FAVORITE_AUTO_KEYWORDS = list
            debouncedSaveSettings()
        end)
        autoInput.Parent = autoFrame
    end
    
    -- Tab 7: Debug
    do
        local c = containers[7]
        createToggleSetting(c, "Debug Mode (detailed logs)", Settings.DEBUG_MODE, function(v) Settings.DEBUG_MODE = v; debouncedSaveSettings() end).Parent = c
        createToggleSetting(c, "Show Path Lines", Settings.DEBUG_SHOW_PATHS, function(v) Settings.DEBUG_SHOW_PATHS = v; debouncedSaveSettings() end).Parent = c
    end
    
    -- Save button
    local saveBtn = Instance.new("TextButton")
    saveBtn.Text = "💾 SAVE SETTINGS"
    saveBtn.TextColor3 = Settings.TEXT_COLOR
    saveBtn.TextSize = 16
    if IS_MOBILE then saveBtn.TextSize = 20 end
    saveBtn.Font = Enum.Font.GothamBold
    saveBtn.BackgroundColor3 = Color3.fromRGB(46,204,113)
    saveBtn.BackgroundTransparency = 0.2
    saveBtn.Size = UDim2.new(1, -40, 0, 40)
    saveBtn.Position = UDim2.new(0, 20, 1, -60)
    saveBtn.BorderSizePixel = 0
    saveBtn.ZIndex = 22
    Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 8)
    saveBtn.MouseButton1Click:Connect(function() playSound("ButtonClick"); saveSettings() end)
    saveBtn.Parent = settingsGUI
    
    -- Dragging
    local dragging, dragStart, startPos = false, nil, nil
    if not IS_MOBILE then
        titleBar.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = i.Position
                startPos = settingsGUI.Position
                i.Changed:Connect(function()
                    if i.UserInputState == Enum.UserInputState.End then
                        dragging = false
                        savedSettingsGUIPos = settingsGUI.Position
                        debouncedSaveSettings()
                    end
                end)
            end
        end)
        titleBar.InputChanged:Connect(function(i)
            if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = i.Position - dragStart
                settingsGUI.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end
    
    settingsGUI.Parent = screenGui
    return settingsGUI
end

-- ========== ITEM LIST GUI (full version from first script) ==========
local function createItemListGUI()
    if itemListGUI and itemListGUI.Parent then itemListGUI:Destroy() end
    
    itemListGUI = Instance.new("Frame")
    itemListGUI.Name = "ItemListGUI"
    itemListGUI.BackgroundColor3 = Settings.LIST_COLOR
    itemListGUI.BackgroundTransparency = 0.2
    itemListGUI.Size = UDim2.new(0, 800, 0, 600)
    if IS_MOBILE then itemListGUI.Size = UDim2.new(0, 900, 0, 700) end
    itemListGUI.Position = savedItemListGUIPos or UDim2.new(0.5, -400, 0.5, -300)
    itemListGUI.BorderSizePixel = 0
    itemListGUI.Visible = false
    itemListGUI.ZIndex = 20
    Instance.new("UICorner", itemListGUI).CornerRadius = UDim.new(0, 12)
    
    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.BackgroundColor3 = Settings.PRIMARY_COLOR
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.BorderSizePixel = 0
    titleBar.ZIndex = 21
    Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12, 0, 0)
    createGradient(titleBar, Settings.PRIMARY_COLOR, Settings.SECONDARY_COLOR, 45)
    
    local title = Instance.new("TextLabel")
    title.Text = "TRACKED ITEMS"
    title.TextColor3 = Settings.TEXT_COLOR
    title.TextSize = 22
    if IS_MOBILE then title.TextSize = 28 end
    title.Font = Enum.Font.GothamBold
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -100, 1, 0)
    title.Position = UDim2.new(0, 20, 0, 0)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 23
    title.Parent = titleBar
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Settings.TEXT_COLOR
    closeBtn.TextSize = 24
    if IS_MOBILE then closeBtn.TextSize = 30 end
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
    closeBtn.BackgroundTransparency = 0.3
    closeBtn.Size = UDim2.new(0, 40, 0, 40)
    if IS_MOBILE then closeBtn.Size = UDim2.new(0, 50, 0, 50) end
    closeBtn.Position = UDim2.new(1, -50, 0, 5)
    closeBtn.BorderSizePixel = 0
    closeBtn.ZIndex = 22
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
    closeBtn.MouseButton1Click:Connect(function() playSound("ButtonClick"); toggleItemList(false) end)
    closeBtn.Parent = titleBar
    titleBar.Parent = itemListGUI
    
    -- Boss status panel
    local bossPanel = Instance.new("Frame")
    bossPanel.Name = "BossStatusPanel"
    bossPanel.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
    bossPanel.BackgroundTransparency = 0.3
    bossPanel.Size = UDim2.new(1, -20, 0, 60)
    if IS_MOBILE then bossPanel.Size = UDim2.new(1, -20, 0, 80) end
    bossPanel.Position = UDim2.new(0, 10, 0, 55)
    bossPanel.BorderSizePixel = 0
    bossPanel.ZIndex = 22
    bossPanel.Visible = false
    Instance.new("UICorner", bossPanel).CornerRadius = UDim.new(0, 8)
    
    local bossIcon = Instance.new("TextLabel")
    bossIcon.Text = "💀"
    bossIcon.TextColor3 = Color3.fromRGB(255,200,0)
    bossIcon.TextSize = 30
    if IS_MOBILE then bossIcon.TextSize = 40 end
    bossIcon.Font = Enum.Font.GothamBold
    bossIcon.BackgroundTransparency = 1
    bossIcon.Size = UDim2.new(0, 40, 0, 40)
    bossIcon.Position = UDim2.new(0, 10, 0.5, -20)
    bossIcon.Parent = bossPanel
    
    local bossName = Instance.new("TextLabel")
    bossName.Name = "BossName"
    bossName.Text = SPECIAL_NAMES.Boss
    bossName.TextColor3 = Color3.fromRGB(255,200,200)
    bossName.TextSize = 18
    if IS_MOBILE then bossName.TextSize = 22 end
    bossName.Font = Enum.Font.GothamBold
    bossName.BackgroundTransparency = 1
    bossName.Size = UDim2.new(0, 200, 0, 30)
    bossName.Position = UDim2.new(0, 60, 0.5, -15)
    bossName.TextXAlignment = Enum.TextXAlignment.Left
    bossName.Parent = bossPanel
    
    local bossHP = Instance.new("TextLabel")
    bossHP.Name = "BossHP"
    bossHP.Text = "❤️ 0/0 (0%)"
    bossHP.TextColor3 = Color3.fromRGB(255,255,255)
    bossHP.TextSize = 16
    if IS_MOBILE then bossHP.TextSize = 20 end
    bossHP.Font = Enum.Font.GothamBold
    bossHP.BackgroundTransparency = 1
    bossHP.Size = UDim2.new(0, 200, 0, 30)
    bossHP.Position = UDim2.new(0, 270, 0.5, -15)
    bossHP.TextXAlignment = Enum.TextXAlignment.Left
    bossHP.Parent = bossPanel
    
    local tpBossBtn = Instance.new("TextButton")
    tpBossBtn.Name = "TeleportButton"
    tpBossBtn.Text = "TELEPORT"
    tpBossBtn.TextColor3 = Settings.TEXT_COLOR
    tpBossBtn.TextSize = 14
    if IS_MOBILE then tpBossBtn.TextSize = 18 end
    tpBossBtn.Font = Enum.Font.GothamBold
    tpBossBtn.BackgroundColor3 = Settings.TELEPORT_COLOR
    tpBossBtn.BackgroundTransparency = 0.2
    tpBossBtn.Size = UDim2.new(0, 100, 0, 35)
    if IS_MOBILE then tpBossBtn.Size = UDim2.new(0, 120, 0, 45) end
    tpBossBtn.Position = UDim2.new(1, -120, 0.5, -17)
    tpBossBtn.BorderSizePixel = 0
    tpBossBtn.ZIndex = 23
    Instance.new("UICorner", tpBossBtn).CornerRadius = UDim.new(0, 8)
    tpBossBtn.MouseButton1Click:Connect(function() playSound("ButtonClick") end)
    tpBossBtn.Parent = bossPanel
    
    bossPanel.Parent = itemListGUI
    
    -- Filter bar
    local filterBar = Instance.new("Frame")
    filterBar.Name = "FilterBar"
    filterBar.BackgroundTransparency = 1
    filterBar.Size = UDim2.new(1, -20, 0, 40)
    filterBar.Position = UDim2.new(0, 10, 0, 120)
    filterBar.ZIndex = 21
    filterBar.Parent = itemListGUI
    
    local filterLayout = Instance.new("UIListLayout")
    filterLayout.FillDirection = Enum.FillDirection.Horizontal
    filterLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    filterLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    filterLayout.Padding = UDim.new(0, 8)
    filterLayout.Parent = filterBar
    
    -- Filters
    local filterAll = Instance.new("TextButton")
    filterAll.Name = "FilterAll"
    filterAll.Text = "📋 All"
    filterAll.TextColor3 = Settings.TEXT_COLOR
    filterAll.TextSize = 14
    if IS_MOBILE then filterAll.TextSize = 18 end
    filterAll.Font = Enum.Font.GothamBold
    filterAll.BackgroundColor3 = Settings.PRIMARY_COLOR
    filterAll.BackgroundTransparency = 0.3
    filterAll.Size = UDim2.new(0, 80, 0, 30)
    if IS_MOBILE then filterAll.Size = UDim2.new(0, 100, 0, 40) end
    filterAll.BorderSizePixel = 0
    filterAll.ZIndex = 22
    filterAll.AutoButtonColor = true
    Instance.new("UICorner", filterAll).CornerRadius = UDim.new(0, 8)
    filterAll.Parent = filterBar
    
    local filterTools = Instance.new("TextButton")
    filterTools.Name = "FilterTools"
    filterTools.Text = "🛠️ Tools"
    filterTools.TextColor3 = Settings.TEXT_COLOR
    filterTools.TextSize = 14
    if IS_MOBILE then filterTools.TextSize = 18 end
    filterTools.Font = Enum.Font.GothamBold
    filterTools.BackgroundColor3 = Settings.SECONDARY_COLOR
    filterTools.BackgroundTransparency = 0.3
    filterTools.Size = UDim2.new(0, 90, 0, 30)
    if IS_MOBILE then filterTools.Size = UDim2.new(0, 110, 0, 40) end
    filterTools.BorderSizePixel = 0
    filterTools.ZIndex = 22
    filterTools.AutoButtonColor = true
    Instance.new("UICorner", filterTools).CornerRadius = UDim.new(0, 8)
    filterTools.Parent = filterBar
    
    local filterNotes = Instance.new("TextButton")
    filterNotes.Name = "FilterNotes"
    filterNotes.Text = "📝 Notes"
    filterNotes.TextColor3 = Settings.TEXT_COLOR
    filterNotes.TextSize = 14
    if IS_MOBILE then filterNotes.TextSize = 18 end
    filterNotes.Font = Enum.Font.GothamBold
    filterNotes.BackgroundColor3 = Settings.TELEPORT_COLOR
    filterNotes.BackgroundTransparency = 0.3
    filterNotes.Size = UDim2.new(0, 90, 0, 30)
    if IS_MOBILE then filterNotes.Size = UDim2.new(0, 110, 0, 40) end
    filterNotes.BorderSizePixel = 0
    filterNotes.ZIndex = 22
    filterNotes.AutoButtonColor = true
    Instance.new("UICorner", filterNotes).CornerRadius = UDim.new(0, 8)
    filterNotes.Parent = filterBar
    
    local filterSpecial = Instance.new("TextButton")
    filterSpecial.Name = "FilterSpecial"
    filterSpecial.Text = "🔥 Events"
    filterSpecial.TextColor3 = Settings.TEXT_COLOR
    filterSpecial.TextSize = 14
    if IS_MOBILE then filterSpecial.TextSize = 18 end
    filterSpecial.Font = Enum.Font.GothamBold
    filterSpecial.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
    filterSpecial.BackgroundTransparency = 0.3
    filterSpecial.Size = UDim2.new(0, 90, 0, 30)
    if IS_MOBILE then filterSpecial.Size = UDim2.new(0, 110, 0, 40) end
    filterSpecial.BorderSizePixel = 0
    filterSpecial.ZIndex = 22
    filterSpecial.AutoButtonColor = true
    Instance.new("UICorner", filterSpecial).CornerRadius = UDim.new(0, 8)
    filterSpecial.Parent = filterBar
    
    -- Return button
    local returnBtn = Instance.new("TextButton")
    returnBtn.Name = "ReturnButton"
    returnBtn.Text = "↩ Return"
    returnBtn.TextColor3 = Settings.TEXT_COLOR
    returnBtn.TextSize = 14
    if IS_MOBILE then returnBtn.TextSize = 18 end
    returnBtn.Font = Enum.Font.GothamBold
    returnBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 100)
    returnBtn.BackgroundTransparency = 0.2
    returnBtn.Size = UDim2.new(0, 80, 0, 30)
    if IS_MOBILE then returnBtn.Size = UDim2.new(0, 100, 0, 40) end
    returnBtn.BorderSizePixel = 0
    returnBtn.ZIndex = 22
    returnBtn.AutoButtonColor = true
    Instance.new("UICorner", returnBtn).CornerRadius = UDim.new(0, 8)
    returnBtn.Parent = filterBar
    
    -- Refresh
    local refreshBtn = Instance.new("TextButton")
    refreshBtn.Name = "RefreshButton"
    refreshBtn.Text = "🔄"
    refreshBtn.TextColor3 = Settings.TEXT_COLOR
    refreshBtn.TextSize = 20
    if IS_MOBILE then refreshBtn.TextSize = 26 end
    refreshBtn.Font = Enum.Font.GothamBold
    refreshBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    refreshBtn.BackgroundTransparency = 0.3
    refreshBtn.Size = UDim2.new(0, 40, 0, 30)
    if IS_MOBILE then refreshBtn.Size = UDim2.new(0, 50, 0, 40) end
    refreshBtn.BorderSizePixel = 0
    refreshBtn.ZIndex = 22
    refreshBtn.AutoButtonColor = true
    Instance.new("UICorner", refreshBtn).CornerRadius = UDim.new(0, 8)
    refreshBtn.Parent = filterBar
    
    -- Search bar
    local searchBar = Instance.new("TextBox")
    searchBar.Name = "SearchBar"
    searchBar.PlaceholderText = "🔍 Search..."
    searchBar.Text = ""
    searchBar.TextColor3 = Settings.TEXT_COLOR
    searchBar.PlaceholderColor3 = Color3.fromRGB(150,150,150)
    searchBar.TextSize = 14
    if IS_MOBILE then searchBar.TextSize = 18 end
    searchBar.Font = Enum.Font.Gotham
    searchBar.BackgroundColor3 = Color3.fromRGB(40,40,50)
    searchBar.BackgroundTransparency = 0.2
    searchBar.Size = UDim2.new(0, 120, 0, 30)
    if IS_MOBILE then searchBar.Size = UDim2.new(0, 140, 0, 40) end
    searchBar.BorderSizePixel = 0
    searchBar.ZIndex = 21
    Instance.new("UICorner", searchBar).CornerRadius = UDim.new(0, 8)
    Instance.new("UIPadding", searchBar).PaddingLeft = UDim.new(0, 10)
    searchBar:GetPropertyChangedSignal("Text"):Connect(function()
        listState.searchText = searchBar.Text
        pcall(updateItemList)
    end)
    searchBar.Parent = filterBar
    
    -- Sort bar
    local sortBar = Instance.new("Frame")
    sortBar.Name = "SortBar"
    sortBar.BackgroundColor3 = Color3.fromRGB(40, 50, 60)
    sortBar.BackgroundTransparency = 0.5
    sortBar.Size = UDim2.new(1, -20, 0, 30)
    if IS_MOBILE then sortBar.Size = UDim2.new(1, -20, 0, 40) end
    sortBar.Position = UDim2.new(0, 10, 0, 165)
    sortBar.BorderSizePixel = 0
    sortBar.ZIndex = 21
    Instance.new("UICorner", sortBar).CornerRadius = UDim.new(0, 6)
    sortBar.Parent = itemListGUI
    
    local iconHeader = Instance.new("TextLabel")
    iconHeader.Text = "📦"
    iconHeader.TextColor3 = Color3.fromRGB(200,200,200)
    iconHeader.TextSize = 18
    if IS_MOBILE then iconHeader.TextSize = 22 end
    iconHeader.Font = Enum.Font.GothamBold
    iconHeader.BackgroundTransparency = 1
    iconHeader.Size = UDim2.new(0, 30, 1, 0)
    iconHeader.Position = UDim2.new(0, 5, 0, 0)
    iconHeader.ZIndex = 22
    iconHeader.Parent = sortBar
    
    local nameHeader = Instance.new("TextButton")
    nameHeader.Name = "SortName"
    nameHeader.Text = "Name ▲"
    nameHeader.TextColor3 = Settings.TEXT_COLOR
    nameHeader.TextSize = 14
    if IS_MOBILE then nameHeader.TextSize = 18 end
    nameHeader.Font = Enum.Font.GothamBold
    nameHeader.BackgroundTransparency = 1
    nameHeader.Size = UDim2.new(0, 150, 1, 0)
    nameHeader.Position = UDim2.new(0, 40, 0, 0)
    nameHeader.ZIndex = 22
    nameHeader.TextXAlignment = Enum.TextXAlignment.Left
    nameHeader.Parent = sortBar
    
    local distanceHeader = Instance.new("TextButton")
    distanceHeader.Name = "SortDistance"
    distanceHeader.Text = "Distance ▲"
    distanceHeader.TextColor3 = Settings.PRIMARY_COLOR
    distanceHeader.TextSize = 14
    if IS_MOBILE then distanceHeader.TextSize = 18 end
    distanceHeader.Font = Enum.Font.GothamBold
    distanceHeader.BackgroundTransparency = 1
    distanceHeader.Size = UDim2.new(0, 100, 1, 0)
    distanceHeader.Position = UDim2.new(0, 200, 0, 0)
    distanceHeader.ZIndex = 22
    distanceHeader.TextXAlignment = Enum.TextXAlignment.Left
    distanceHeader.Parent = sortBar
    
    local favHeader = Instance.new("TextButton")
    favHeader.Name = "SortFavorite"
    favHeader.Text = "★"
    favHeader.TextColor3 = Color3.fromRGB(200,200,200)
    favHeader.TextSize = 18
    if IS_MOBILE then favHeader.TextSize = 22 end
    favHeader.Font = Enum.Font.GothamBold
    favHeader.BackgroundTransparency = 1
    favHeader.Size = UDim2.new(0, 40, 1, 0)
    favHeader.Position = UDim2.new(0, 310, 0, 0)
    favHeader.ZIndex = 22
    favHeader.Parent = sortBar
    
    local espHeader = Instance.new("TextLabel")
    espHeader.Text = "👁️"
    espHeader.TextColor3 = Color3.fromRGB(200,200,200)
    espHeader.TextSize = 18
    if IS_MOBILE then espHeader.TextSize = 22 end
    espHeader.Font = Enum.Font.GothamBold
    espHeader.BackgroundTransparency = 1
    espHeader.Size = UDim2.new(0, 40, 1, 0)
    espHeader.Position = UDim2.new(0, 360, 0, 0)
    espHeader.ZIndex = 22
    espHeader.Parent = sortBar
    
    local actionHeader = Instance.new("TextLabel")
    actionHeader.Text = "Action"
    actionHeader.TextColor3 = Color3.fromRGB(200,200,200)
    actionHeader.TextSize = 14
    if IS_MOBILE then actionHeader.TextSize = 18 end
    actionHeader.Font = Enum.Font.GothamBold
    actionHeader.BackgroundTransparency = 1
    actionHeader.Size = UDim2.new(0, 60, 1, 0)
    actionHeader.Position = UDim2.new(0, 410, 0, 0)
    actionHeader.ZIndex = 22
    actionHeader.TextXAlignment = Enum.TextXAlignment.Center
    actionHeader.Parent = sortBar
    
    -- Items container
    local itemsContainer = Instance.new("ScrollingFrame")
    itemsContainer.Name = "ItemsContainer"
    itemsContainer.BackgroundTransparency = 1
    itemsContainer.Size = UDim2.new(1, -20, 1, -240)
    itemsContainer.Position = UDim2.new(0, 10, 0, 200)
    itemsContainer.BorderSizePixel = 0
    itemsContainer.ScrollBarThickness = 8
    itemsContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    itemsContainer.ZIndex = 21
    local itemListLayout = Instance.new("UIListLayout")
    itemListLayout.Padding = UDim.new(0, 8)
    itemListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    itemListLayout.Parent = itemsContainer
    itemsContainer.Parent = itemListGUI
    
    -- Item counter
    local itemCount = Instance.new("TextLabel")
    itemCount.Name = "ItemCount"
    itemCount.Text = "Items: 0"
    itemCount.TextColor3 = Color3.fromRGB(200,200,200)
    itemCount.TextSize = 14
    if IS_MOBILE then itemCount.TextSize = 18 end
    itemCount.Font = Enum.Font.Gotham
    itemCount.BackgroundTransparency = 1
    itemCount.Size = UDim2.new(1, -20, 0, 30)
    itemCount.Position = UDim2.new(0, 10, 1, -40)
    itemCount.TextXAlignment = Enum.TextXAlignment.Left
    itemCount.Parent = itemListGUI
    
    -- Filter handlers
    local function setActiveFilter(activeBtn)
        filterAll.BackgroundTransparency = 0.7
        filterTools.BackgroundTransparency = 0.7
        filterNotes.BackgroundTransparency = 0.7
        filterSpecial.BackgroundTransparency = 0.7
        activeBtn.BackgroundTransparency = 0.1
    end
    
    filterAll.MouseButton1Click:Connect(function()
        playSound("ButtonClick")
        listState.filterType = "all"
        setActiveFilter(filterAll)
        pcall(updateItemList)
    end)
    filterTools.MouseButton1Click:Connect(function()
        playSound("ButtonClick")
        listState.filterType = "tool"
        setActiveFilter(filterTools)
        pcall(updateItemList)
    end)
    filterNotes.MouseButton1Click:Connect(function()
        playSound("ButtonClick")
        listState.filterType = "note"
        setActiveFilter(filterNotes)
        pcall(updateItemList)
    end)
    filterSpecial.MouseButton1Click:Connect(function()
        playSound("ButtonClick")
        listState.filterType = "special"
        setActiveFilter(filterSpecial)
        pcall(updateItemList)
    end)
    setActiveFilter(filterAll)
    
    -- Return handler
    returnBtn.MouseButton1Click:Connect(function()
        playSound("ButtonClick")
        local success, msg = teleportReturn()
        if success then
            createSpawnNotification("↩ Return", "Returned to previous position", nil, 2, Color3.fromRGB(100,200,100))
        else
            createSpawnNotification("❌ Return", msg, nil, 2, Color3.fromRGB(255,100,100))
        end
    end)
    
    refreshBtn.MouseButton1Click:Connect(function()
        playSound("ButtonClick")
        pcall(findAndSetupObjects)
        pcall(updateItemList)
    end)
    
    -- Sort handlers
    local function setSort(mode, asc)
        listState.sortMode = mode
        listState.sortAsc = asc
        nameHeader.Text = "Name" .. (mode == "name" and (asc and " ▲" or " ▼") or "")
        distanceHeader.Text = "Distance" .. (mode == "distance" and (asc and " ▲" or " ▼") or "")
        favHeader.Text = "★" .. (mode == "favorite" and (asc and " ▲" or " ▼") or "")
        nameHeader.TextColor3 = mode == "name" and Settings.PRIMARY_COLOR or Color3.fromRGB(200,200,200)
        distanceHeader.TextColor3 = mode == "distance" and Settings.PRIMARY_COLOR or Color3.fromRGB(200,200,200)
        favHeader.TextColor3 = mode == "favorite" and Settings.FAVORITE_COLOR or Color3.fromRGB(200,200,200)
        pcall(updateItemList)
    end
    
    nameHeader.MouseButton1Click:Connect(function()
        playSound("ButtonClick")
        if listState.sortMode == "name" then setSort("name", not listState.sortAsc) else setSort("name", true) end
    end)
    distanceHeader.MouseButton1Click:Connect(function()
        playSound("ButtonClick")
        if listState.sortMode == "distance" then setSort("distance", not listState.sortAsc) else setSort("distance", true) end
    end)
    favHeader.MouseButton1Click:Connect(function()
        playSound("ButtonClick")
        if listState.sortMode == "favorite" then setSort("favorite", not listState.sortAsc) else setSort("favorite", true) end
    end)
    
    -- Window drag
    local dragging, dragStart, startPos = false, nil, nil
    if not IS_MOBILE then
        titleBar.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = i.Position
                startPos = itemListGUI.Position
                i.Changed:Connect(function()
                    if i.UserInputState == Enum.UserInputState.End then
                        dragging = false
                        savedItemListGUIPos = itemListGUI.Position
                        debouncedSaveSettings()
                    end
                end)
            end
        end)
        titleBar.InputChanged:Connect(function(i)
            if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = i.Position - dragStart
                itemListGUI.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end
    
    itemListGUI.Parent = screenGui
    return itemListGUI
end

-- ========== BossPanel ==========

local function createBossPanel()
    if bossPanel and bossPanel.Parent then bossPanel:Destroy() end
    
    bossPanel = Instance.new("Frame")
    bossPanel.Name = "BossPanel"
    bossPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    bossPanel.BackgroundTransparency = 0.2
    bossPanel.Size = UDim2.new(0, 250, 0, 120)
    bossPanel.Position = savedBossPanelPos or UDim2.new(0, 10, 0.5, -60)
    bossPanel.BorderSizePixel = 0
    bossPanel.ZIndex = 30
    bossPanel.Visible = false
    Instance.new("UICorner", bossPanel).CornerRadius = UDim.new(0, 8)
    
    -- Title (for dragging)
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Text = "BOSS STATUS"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    title.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    title.BackgroundTransparency = 0.3
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BorderSizePixel = 0
    title.ZIndex = 31
    Instance.new("UICorner", title).CornerRadius = UDim.new(0, 8, 0, 0)
    title.Parent = bossPanel
    
    -- Content container
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.BackgroundTransparency = 1
    content.Size = UDim2.new(1, -10, 1, -40)
    content.Position = UDim2.new(0, 5, 0, 35)
    content.ZIndex = 31
    content.Parent = bossPanel
    
    -- Boss name
    local bossName = Instance.new("TextLabel")
    bossName.Name = "BossName"
    bossName.Text = "No boss"
    bossName.TextColor3 = Color3.fromRGB(255, 255, 255)
    bossName.TextSize = 14
    bossName.Font = Enum.Font.GothamBold
    bossName.BackgroundTransparency = 1
    bossName.Size = UDim2.new(1, 0, 0, 20)
    bossName.TextXAlignment = Enum.TextXAlignment.Left
    bossName.Parent = content
    
    -- HP text
    local hpText = Instance.new("TextLabel")
    hpText.Name = "HPText"
    hpText.Text = "HP: 0/0 (0%)"
    hpText.TextColor3 = Color3.fromRGB(255, 255, 255)
    hpText.TextSize = 12
    hpText.Font = Enum.Font.Gotham
    hpText.BackgroundTransparency = 1
    hpText.Size = UDim2.new(1, 0, 0, 20)
    hpText.Position = UDim2.new(0, 0, 0, 20)
    hpText.TextXAlignment = Enum.TextXAlignment.Left
    hpText.Parent = content
    
    -- HP bar
    local hpBarBg = Instance.new("Frame")
    hpBarBg.Name = "HPBarBg"
    hpBarBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    hpBarBg.Size = UDim2.new(1, 0, 0, 10)
    hpBarBg.Position = UDim2.new(0, 0, 0, 45)
    hpBarBg.BorderSizePixel = 0
    hpBarBg.Parent = content
    Instance.new("UICorner", hpBarBg).CornerRadius = UDim.new(0, 4)
    
    local hpBarFill = Instance.new("Frame")
    hpBarFill.Name = "HPBarFill"
    hpBarFill.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    hpBarFill.Size = UDim2.new(1, 0, 1, 0)
    hpBarFill.BorderSizePixel = 0
    hpBarFill.Parent = hpBarBg
    Instance.new("UICorner", hpBarFill).CornerRadius = UDim.new(0, 4)
    
    -- Distance
    local distance = Instance.new("TextLabel")
    distance.Name = "Distance"
    distance.Text = "Distance: --"
    distance.TextColor3 = Color3.fromRGB(200, 200, 200)
    distance.TextSize = 12
    distance.Font = Enum.Font.Gotham
    distance.BackgroundTransparency = 1
    distance.Size = UDim2.new(1, 0, 0, 20)
    distance.Position = UDim2.new(0, 0, 0, 60)
    distance.TextXAlignment = Enum.TextXAlignment.Left
    distance.Parent = content
    
    -- Teleport button
    local tpButton = Instance.new("TextButton")
    tpButton.Name = "TeleportButton"
    tpButton.Text = "TP"
    tpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    tpButton.TextSize = 12
    tpButton.Font = Enum.Font.GothamBold
    tpButton.BackgroundColor3 = Settings.TELEPORT_COLOR
    tpButton.BackgroundTransparency = 0.2
    tpButton.Size = UDim2.new(0, 50, 0, 25)
    tpButton.Position = UDim2.new(1, -55, 1, -30)
    tpButton.BorderSizePixel = 0
    tpButton.ZIndex = 32
    Instance.new("UICorner", tpButton).CornerRadius = UDim.new(0, 6)
    tpButton.MouseButton1Click:Connect(function()
        -- Find current boss
        for obj, data in pairs(objectCache) do
            if (data.specialType == "Boss" or data.specialType == "Sukuna") and obj and obj.Parent then
                teleportToObject(obj)
                break
            end
        end
    end)
    tpButton.Parent = bossPanel
    
    -- Dragging the panel
    local dragging, dragStart, startPos = false, nil, nil
    if not IS_MOBILE then
        title.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = i.Position
                startPos = bossPanel.Position
                i.Changed:Connect(function()
                    if i.UserInputState == Enum.UserInputState.End then
                        dragging = false
                        savedBossPanelPos = bossPanel.Position
                        debouncedSaveSettings()
                    end
                end)
            end
        end)
        title.InputChanged:Connect(function(i)
            if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = i.Position - dragStart
                bossPanel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end
    
    bossPanel.Parent = screenGui
    return bossPanel
end

-- ========== WINDOW MANAGEMENT ==========
function toggleSettings(visible)
    if visible == nil then visible = not settingsVisible end
    settingsVisible = visible
    if not settingsGUI then
        settingsGUI = createSettingsGUI()
    end
    if settingsGUI then
        settingsGUI.Visible = visible
    end
    if not visible then saveSettings() end
end

function toggleItemList(visible)
    if visible == nil then visible = not itemListVisible end
    itemListVisible = visible
    if not itemListGUI then
        itemListGUI = createItemListGUI()
    end
    if itemListGUI then
        itemListGUI.Visible = visible
    end
    if visible then pcall(updateItemList) else saveSettings() end
end
-- Continuation

--[[
    Nexus Tracker v10.0 – Advanced ESP, LOD, Auto Teleport, Enhanced Favorites, Debug
    PART 4/4 (final)
]]

-- ========== UPDATE ==========
local lastESPUpdate = tick()
local lastListUpdate = tick()
local lastSpecialCheck = tick()

local function updateDistances()
    if not LocalPlayer.Character then return end
    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local now = tick()
    
    if now - lastESPUpdate >= Settings.UPDATE_INTERVAL then
        local bossPresentNow = false
        local currentBossType = nil
        
        -- Count total objects for icon-only mode
        local totalObjects = 0
        for _ in pairs(objectCache) do totalObjects = totalObjects + 1 end
        local forceIconMode = totalObjects > Settings.VISUAL_ICON_ONLY_THRESHOLD
        
        for obj, data in pairs(objectCache) do
            if obj and obj.Parent then
                data.position = getObjectPosition(obj)
                local dist = (root.Position - data.position).Magnitude
                
                -- Update distance in card
                if data.esp and data.esp:FindFirstChild("MainFrame") then
                    local main = data.esp.MainFrame
                    for _, label in ipairs(main:GetDescendants()) do
                        if label.Name == "DistanceLabel" then
                            label.Text = string.format("Distance: %.0f studs", dist)
                            if dist < 100 then
                                label.TextColor3 = Color3.fromRGB(0, 255, 0)
                            elseif dist < 500 then
                                label.TextColor3 = Color3.fromRGB(255, 255, 0)
                            else
                                label.TextColor3 = Color3.fromRGB(255, 0, 0)
                            end
                        end
                    end
                end
                
                -- LOD and visibility
                if data.esp then
                    local visible = true
                    if Settings.VISUAL_FRUSTUM_CULLING then
                        visible = isObjectVisible(data.position)
                    end
                    
                    if visible and guiEnabled and data.espEnabled and dist <= Settings.MAX_DISTANCE and dist > Settings.HIDE_NEAR_DISTANCE then
                        data.esp.Enabled = true
                        
                        local lodLevel
                        if forceIconMode and not (Settings.VISUAL_BOSS_BYPASS_LOD and (data.specialType == "Boss" or data.specialType == "Sukuna")) then
                            lodLevel = 1
                        else
                            lodLevel = getLODLevel(dist)
                            -- If boss and bypass enabled, always show full info
                            if Settings.VISUAL_BOSS_BYPASS_LOD and (data.specialType == "Boss" or data.specialType == "Sukuna") then
                                lodLevel = 3
                            end
                        end
                        
                        if data.lodFrames then
                            for i, frame in ipairs(data.lodFrames) do
                                frame.Visible = (i == lodLevel)
                            end
                        end
                    else
                        data.esp.Enabled = false
                    end
                end
                
                -- Boss logic and HP update
                if data.specialType == "Boss" or data.specialType == "Sukuna" then
                    bossPresentNow = true
                    currentBossType = data.specialType
                    local humanoid = obj:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        local health = humanoid.Health
                        local maxHealth = humanoid.MaxHealth
                        data.health = health
                        data.maxHealth = maxHealth
                        
                        -- Update HP in ESP card
                        if data.esp and data.esp:FindFirstChild("MainFrame") then
                            local main = data.esp.MainFrame
                            local lod3 = main:FindFirstChild("LOD3")
                            if lod3 then
                                local hpText = lod3:FindFirstChild("HPText", true)
                                local hpBarFill = lod3:FindFirstChild("HPBarFill", true)
                                local percentLabel = lod3:FindFirstChild("HealthPercent", true)
                                
                                if hpText and hpBarFill and percentLabel then
                                    local percent = (health / maxHealth) * 100
                                    hpText.Text = string.format("HP: %d/%d (%d%%)", math.floor(health), math.floor(maxHealth), math.floor(percent))
                                    hpBarFill.Size = UDim2.new(health / maxHealth, 0, 1, 0)
                                    percentLabel.Text = math.floor(percent) .. "%"
                                    
                                    -- Change bar color based on health percentage
                                    if percent < 25 then
                                        hpBarFill.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                                    elseif percent < 50 then
                                        hpBarFill.BackgroundColor3 = Color3.fromRGB(255, 150, 50)
                                    else
                                        hpBarFill.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
                                    end
                                end
                            end
                        end
                        
                        if data.specialType == "Boss" and health < 450 and not data.lowHealthPlayed and now - lastLowHealthTime > 10 then
                            lastLowHealthTime = now
                            data.lowHealthPlayed = true
                            playSound("LowHealth")
                            createSpawnNotification("⚠️ LOW HEALTH", SPECIAL_NAMES[data.specialType] .. " is below 450 HP!", obj, 5, Color3.fromRGB(255,200,0))
                        end
                    end
                end
            else
                if data and data.esp then 
                    if data.updateConnection then data.updateConnection:Disconnect() end
                    if data.tempPart and data.tempPart.Parent then data.tempPart:Destroy() end
                    pcall(data.esp.Destroy, data.esp) 
                end
                objectCache[obj] = nil
                updateListToggleIcon()
            end
        end
        
        -- Death return check
        if Settings.DEATH_RETURN_ENABLED then
            local character = LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChildWhichIsA("Humanoid")
                if humanoid and humanoid.Health <= 0 and deathPosition == nil then
                    saveDeathPosition()
                end
            end
        end
        
        if bossWasPresent and not bossPresentNow and now - lastDeathTime > 5 then
            lastDeathTime = now
            playSound("BossDeath")
            local bossName = lastBossType and SPECIAL_NAMES[lastBossType] or "A boss"
            createSpawnNotification("💀 BOSS DEFEATED", bossName .. " has been defeated!", nil, 5, Color3.fromRGB(255,100,100))
            for _, d in pairs(objectCache) do
                if d.specialType == "Boss" or d.specialType == "Sukuna" then
                    d.lowHealthPlayed = nil
                end
            end
            lastBossType = nil
        end
        bossWasPresent = bossPresentNow
        if bossPresentNow and currentBossType then
            lastBossType = currentBossType
        end

        -- Update path lines
        if Settings.DEBUG_SHOW_PATHS then
            updatePathLines()
        end
        
        -- Update boss panel
        if bossPanel and bossPanel.Visible then
            local bossObj, bossData = nil, nil
            for obj, data in pairs(objectCache) do
                if (data.specialType == "Boss" or data.specialType == "Sukuna") and obj and obj.Parent then
                    bossObj = obj
                    bossData = data
                    break
                end
            end
            
            local content = bossPanel:FindFirstChild("Content")
            if content then
                local nameLabel = content:FindFirstChild("BossName")
                local hpText = content:FindFirstChild("HPText")
                local hpBarFill = content:FindFirstChild("HPBarBg") and content.HPBarBg:FindFirstChild("HPBarFill")
                local distLabel = content:FindFirstChild("Distance")
                
                if bossObj and bossData then
                    local bossName = SPECIAL_NAMES[bossData.specialType] or bossData.displayName
                    nameLabel.Text = bossName
                    
                    if bossData.health and bossData.maxHealth then
                        local percent = (bossData.health / bossData.maxHealth) * 100
                        hpText.Text = string.format("HP: %d/%d (%.1f%%)", bossData.health, bossData.maxHealth, percent)
                        hpBarFill.Size = UDim2.new(bossData.health / bossData.maxHealth, 0, 1, 0)
                    else
                        hpText.Text = "HP: --/--"
                        hpBarFill.Size = UDim2.new(1,0,1,0)
                    end
                    
                    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        local dist = (root.Position - bossData.position).Magnitude
                        distLabel.Text = string.format("Distance: %.0f studs", dist)
                    else
                        distLabel.Text = "Distance: --"
                    end
                else
                    nameLabel.Text = "No boss"
                    hpText.Text = "HP: --/--"
                    hpBarFill.Size = UDim2.new(1,0,1,0)
                    distLabel.Text = "Distance: --"
                end
            end
        end

        lastESPUpdate = now
    end  -- close if now - lastESPUpdate...
    
    if now - lastSpecialCheck >= 2 then
        for sType, pathPattern in pairs(SPECIAL_PATHS) do
            local obj = getObjectFromPath(pathPattern)
            if obj and not objectCache[obj] then
                debugPrint("Found special object by direct path (periodic):", pathPattern)
                tryAddSpecialObject(obj, sType)
            end
        end
        lastSpecialCheck = now
    end
    
    if itemListVisible and now - lastListUpdate >= Settings.LIST_UPDATE_INTERVAL then
        pcall(updateItemList)
        lastListUpdate = now
    end
end  -- close function updateDistances

-- ========== SEARCH AND TRACKING ==========
local function findAndSetupObjects()
    local count = 0
    local function scan(parent)
        for _, obj in ipairs(parent:GetChildren()) do
            if shouldTrackObject(obj) and not objectCache[obj] then
                local path = obj:GetFullName()
                local favorite = savedObjectFavorites[path] or false
                if checkAutoFavorite(obj) then
                    favorite = true
                end
                local espEnabled = savedObjectESP[path] or true
                local specialType = getSpecialType(obj)
                
                local data = {
                    esp = nil,
                    espEnabled = espEnabled,
                    favorite = favorite,
                    addedTime = tick(),
                    className = obj.ClassName,
                    displayName = getDisplayName(obj),
                    position = getObjectPosition(obj),
                    fullPath = path,
                    specialType = specialType,
                    lowHealthPlayed = false
                }
                
                objectCache[obj] = data
                
                if specialType == "Boss" or specialType == "Sukuna" then
                    local humanoid = obj:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        data.health = humanoid.Health
                        data.maxHealth = humanoid.MaxHealth
                    end
                    local now = tick()
                    if now - lastBossSpawnNotification > BOSS_NOTIFICATION_COOLDOWN then
                        playSound("BossSpawn")
                        createSpawnNotification("🔥 BOSS SPAWNED", SPECIAL_NAMES[specialType] .. " has appeared!", obj, 5, Color3.fromRGB(255,100,0))
                        lastBossSpawnNotification = now
                    end
                    lastBossType = specialType
                    scheduleAutoTeleport(obj, specialType)
                else
                    playSound("ItemSpawn")
                    createSpawnNotification("✨ NEW ITEM", getDisplayName(obj), obj, Settings.NOTIFICATION_DURATION, Settings.NOTIFICATION_COLOR)
                end
                
                local esp = createInfoCard(obj)
                if esp then
                    data.esp = esp
                    esp.Enabled = guiEnabled and espEnabled
                else
                    objectCache[obj] = nil
                end
                
                count = count + 1
            end
            if obj:IsA("Model") or obj:IsA("Folder") then pcall(scan, obj) end
        end
    end
    pcall(scan, TRACK_PATH)
    
    for sType, pathPattern in pairs(SPECIAL_PATHS) do
        local obj = getObjectFromPath(pathPattern)
        if obj and not objectCache[obj] then
            debugPrint("Found special object by direct path (initial):", pathPattern)
            tryAddSpecialObject(obj, sType)
            count = count + 1
        end
    end
    
    debugPrint("🔍 Initial scan:", count, "objects")
    updateListToggleIcon()
end

local function onChildAdded(child)
    if shouldTrackObject(child) and not objectCache[child] then
        task.wait(0.2)
        local path = child:GetFullName()
        local favorite = savedObjectFavorites[path] or false
        if checkAutoFavorite(child) then
            favorite = true
        end
        
        if tableFind(Settings.AUTO_FAVORITE_NAMES, child.Name) then
            favorite = true
        end
        
        local espEnabled = savedObjectESP[path] or true
        local specialType = getSpecialType(child)
        
        local data = {
            esp = nil,
            espEnabled = espEnabled,
            favorite = favorite,
            addedTime = tick(),
            className = child.ClassName,
            displayName = getDisplayName(child),
            position = getObjectPosition(child),
            fullPath = path,
            specialType = specialType,
            lowHealthPlayed = false
        }
        
        objectCache[child] = data
        
        if specialType == "Boss" or specialType == "Sukuna" then
            local humanoid = child:FindFirstChildOfClass("Humanoid")
            if humanoid then
                data.health = humanoid.Health
                data.maxHealth = humanoid.MaxHealth
            end
            local now = tick()
            if now - lastBossSpawnNotification > BOSS_NOTIFICATION_COOLDOWN then
                playSound("BossSpawn")
                createSpawnNotification("🔥 BOSS SPAWNED", SPECIAL_NAMES[specialType] .. " has appeared!", child, 5, Color3.fromRGB(255,100,0))
                lastBossSpawnNotification = now
            end
            lastBossType = specialType
            scheduleAutoTeleport(child, specialType)
            
            -- Automatically show boss panel
            if bossPanel and not bossPanel.Visible then
                bossPanel.Visible = true
                bossPanelVisible = true
            end
        else
            playSound("ItemSpawn")
            createSpawnNotification("✨ NEW ITEM", getDisplayName(child), child, Settings.NOTIFICATION_DURATION, Settings.NOTIFICATION_COLOR)
        end
        
        local esp = createInfoCard(child)
        if esp then
            data.esp = esp
            esp.Enabled = guiEnabled and espEnabled
        else
            objectCache[child] = nil
            return
        end
        
        updateListToggleIcon()
        if itemListVisible then pcall(updateItemList) end
        debugLog("Object added:", child:GetFullName(), "Type:", specialType or child.ClassName)
    end
end

local function onChildRemoving(child)
    if objectCache[child] then
        if objectCache[child].esp then 
            if objectCache[child].updateConnection then objectCache[child].updateConnection:Disconnect() end
            if objectCache[child].tempPart and objectCache[child].tempPart.Parent then objectCache[child].tempPart:Destroy() end
            pcall(objectCache[child].esp.Destroy, objectCache[child].esp) 
        end
        objectCache[child] = nil
        updateListToggleIcon()
        if itemListVisible then pcall(updateItemList) end
        debugLog("Object removed:", child:GetFullName())
    end
end

-- ========== TOGGLE BUTTONS ==========
local function createToggleButtons()
    mainToggle = Instance.new("TextButton")
    mainToggle.Name = "MainToggleButton"
    mainToggle.Text = "🔍"
    mainToggle.TextColor3 = Settings.TEXT_COLOR
    mainToggle.TextSize = 20
    if IS_MOBILE then mainToggle.TextSize = 26 end
    mainToggle.Font = Enum.Font.GothamBold
    mainToggle.BackgroundColor3 = Settings.TOGGLE_COLOR
    mainToggle.BackgroundTransparency = 0.3
    mainToggle.Size = UDim2.new(0,50,0,50)
    if IS_MOBILE then mainToggle.Size = UDim2.new(0,70,0,70) end
    mainToggle.Position = savedMainTogglePos or UDim2.new(0,20,0.5,-25)
    mainToggle.BorderSizePixel = 0
    mainToggle.ZIndex = 100
    mainToggle.Draggable = not IS_MOBILE
    Instance.new("UICorner", mainToggle).CornerRadius = UDim.new(1,0)
    
    listToggle = Instance.new("TextButton")
    listToggle.Name = "ListToggleButton"
    listToggle.Text = "📋 0"
    listToggle.TextColor3 = Settings.TEXT_COLOR
    listToggle.TextSize = 18
    if IS_MOBILE then listToggle.TextSize = 24 end
    listToggle.Font = Enum.Font.GothamBold
    listToggle.BackgroundColor3 = Settings.SECONDARY_COLOR
    listToggle.BackgroundTransparency = 0.3
    listToggle.Size = UDim2.new(0,40,0,40)
    if IS_MOBILE then listToggle.Size = UDim2.new(0,60,0,60) end
    listToggle.Position = savedListTogglePos or UDim2.new(0,75,0.5,-20)
    listToggle.BorderSizePixel = 0
    listToggle.ZIndex = 100
    listToggle.Draggable = not IS_MOBILE
    listToggle.Visible = guiEnabled
    Instance.new("UICorner", listToggle).CornerRadius = UDim.new(1,0)
    
    settingsToggle = Instance.new("TextButton")
    settingsToggle.Name = "SettingsToggleButton"
    settingsToggle.Text = "⚙️"
    settingsToggle.TextColor3 = Settings.TEXT_COLOR
    settingsToggle.TextSize = 18
    if IS_MOBILE then settingsToggle.TextSize = 24 end
    settingsToggle.Font = Enum.Font.GothamBold
    settingsToggle.BackgroundColor3 = Color3.fromRGB(155,89,182)
    settingsToggle.BackgroundTransparency = 0.3
    settingsToggle.Size = UDim2.new(0,40,0,40)
    if IS_MOBILE then settingsToggle.Size = UDim2.new(0,60,0,60) end
    settingsToggle.Position = savedSettingsTogglePos or UDim2.new(0,120,0.5,-20)
    settingsToggle.BorderSizePixel = 0
    settingsToggle.ZIndex = 100
    settingsToggle.Draggable = not IS_MOBILE
    settingsToggle.Visible = guiEnabled
    Instance.new("UICorner", settingsToggle).CornerRadius = UDim.new(1,0)
    
    local function savePosOnDragEnd(btn)
        btn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                if btn == mainToggle then savedMainTogglePos = btn.Position
                elseif btn == listToggle then savedListTogglePos = btn.Position
                elseif btn == settingsToggle then savedSettingsTogglePos = btn.Position end
                debouncedSaveSettings()
            end
        end)
    end
    savePosOnDragEnd(mainToggle)
    savePosOnDragEnd(listToggle)
    savePosOnDragEnd(settingsToggle)
    
    mainToggle.MouseButton1Click:Connect(function()
        playSound("ButtonClick")
        guiEnabled = not guiEnabled
        if guiEnabled then
            mainToggle.BackgroundColor3 = Settings.TOGGLE_COLOR
            mainToggle.Text = "🔍"
            listToggle.Visible = true
            settingsToggle.Visible = true
        else
            mainToggle.BackgroundColor3 = Settings.DISABLED_COLOR
            mainToggle.Text = "👁️"
            listToggle.Visible = false
            settingsToggle.Visible = false
        end
        for _, data in pairs(objectCache) do
            if data.esp then data.esp.Enabled = guiEnabled and data.espEnabled end
        end
        debouncedSaveSettings()
    end)
    
    listToggle.MouseButton1Click:Connect(function() playSound("ButtonClick"); toggleItemList() end)
    settingsToggle.MouseButton1Click:Connect(function() playSound("ButtonClick"); toggleSettings() end)
    
    mainToggle.Parent = screenGui
    listToggle.Parent = screenGui
    settingsToggle.Parent = screenGui
end

-- ========== BOSS PANEL BUTTON (WITH POSITION SAVING) ==========
local function createBossPanelButton()
    bossPanelButton = Instance.new("TextButton")
    bossPanelButton.Name = "BossPanelButton"
    bossPanelButton.Text = "👑"
    bossPanelButton.TextColor3 = Settings.TEXT_COLOR
    bossPanelButton.TextSize = 18
    if IS_MOBILE then bossPanelButton.TextSize = 24 end
    bossPanelButton.Font = Enum.Font.GothamBold
    bossPanelButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    bossPanelButton.BackgroundTransparency = 0.3
    bossPanelButton.Size = UDim2.new(0, 40, 0, 40)
    if IS_MOBILE then bossPanelButton.Size = UDim2.new(0, 60, 0, 60) end
    bossPanelButton.Position = savedBossButtonPos or UDim2.new(0, 170, 0.5, -20) -- use saved position or default
    bossPanelButton.BorderSizePixel = 0
    bossPanelButton.ZIndex = 100
    bossPanelButton.Draggable = not IS_MOBILE
    Instance.new("UICorner", bossPanelButton).CornerRadius = UDim.new(1,0)
    
    bossPanelButton.MouseButton1Click:Connect(function()
        playSound("ButtonClick")
        bossPanelVisible = not bossPanelVisible
        if bossPanel then
            bossPanel.Visible = bossPanelVisible
        end
    end)
    
    -- Save button position when dragged
    bossPanelButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            savedBossButtonPos = bossPanelButton.Position
            debouncedSaveSettings()
        end
    end)
    
    bossPanelButton.Parent = screenGui
end


-- ========== SPLASH SCREEN ==========
local function createSplashScreen()
    local splash = Instance.new("Frame")
    splash.Name = "SplashScreen"
    splash.BackgroundColor3 = Color3.fromRGB(20,20,30)
    splash.BackgroundTransparency = 0.3
    splash.Size = UDim2.new(0,10,0,10)
    splash.Position = UDim2.new(0.5,-5,0.5,-5)
    splash.BorderSizePixel = 0
    splash.ZIndex = 200
    Instance.new("UICorner", splash).CornerRadius = UDim.new(0,16)
    
    local logo = Instance.new("TextLabel")
    logo.Text = "🔍"
    logo.TextColor3 = Settings.PRIMARY_COLOR
    logo.TextSize = 60
    if IS_MOBILE then logo.TextSize = 80 end
    logo.Font = Enum.Font.GothamBold
    logo.BackgroundTransparency = 1
    logo.Size = UDim2.new(0,80,0,80)
    logo.Position = UDim2.new(0.5,-40,0,20)
    logo.ZIndex = 201
    logo.Parent = splash
    
    local title = Instance.new("TextLabel")
    title.Text = "NEXUS TRACKER"
    title.TextColor3 = Settings.PRIMARY_COLOR
    title.TextSize = 28
    if IS_MOBILE then title.TextSize = 36 end
    title.Font = Enum.Font.GothamBold
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1,0,0,50)
    title.Position = UDim2.new(0,0,0,100)
    title.ZIndex = 201
    title.Parent = splash
    
    local subtitle = Instance.new("TextLabel")
    subtitle.Text = "Universal Tracker + Enhanced Boss ESP + Auto TP"
    subtitle.TextColor3 = Color3.fromRGB(200,200,200)
    subtitle.TextSize = 16
    if IS_MOBILE then subtitle.TextSize = 20 end
    subtitle.Font = Enum.Font.Gotham
    subtitle.BackgroundTransparency = 1
    subtitle.Size = UDim2.new(1,0,0,30)
    subtitle.Position = UDim2.new(0,0,0,150)
    subtitle.ZIndex = 201
    subtitle.Parent = splash
    
    local version = Instance.new("TextLabel")
    version.Text = "v10.0 (Full Feature)"
    version.TextColor3 = Color3.fromRGB(150,150,150)
    version.TextSize = 14
    if IS_MOBILE then version.TextSize = 18 end
    version.Font = Enum.Font.Gotham
    version.BackgroundTransparency = 1
    version.Size = UDim2.new(1,0,0,20)
    version.Position = UDim2.new(0,0,0,185)
    version.ZIndex = 201
    version.Parent = splash
    
    splash.Parent = screenGui
    
    TweenService:Create(splash, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0,400,0,250),
        Position = UDim2.new(0.5,-200,0.5,-125),
        BackgroundTransparency = 0.3
    }):Play()
    
    task.delay(3, function()
        if splash and splash.Parent then
            local t = TweenService:Create(splash, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Size = UDim2.new(0,10,0,10),
                Position = UDim2.new(0.5,-5,0.5,-5),
                BackgroundTransparency = 1
            })
            t:Play()
            t.Completed:Wait()
            splash:Destroy()
        end
    end)
end

-- ========== INITIALIZATION ==========
local function init()
    debugPrint("Initializing Nexus Tracker v10.0...")
    
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NexusTrackerUI"
    screenGui.DisplayOrder = 10
    screenGui.ResetOnSpawn = false
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    createSplashScreen()
    
    notificationContainer = Instance.new("Frame")
    notificationContainer.Name = "NotificationContainer"
    notificationContainer.BackgroundTransparency = 1
    notificationContainer.Size = UDim2.new(1,0,1,0)
    notificationContainer.Parent = screenGui
    
    local notifLayout = Instance.new("UIListLayout")
    notifLayout.Padding = UDim.new(0,10)
    notifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    notifLayout.Parent = notificationContainer
    
    local saved = loadSettings()
    applyLoadedSettings(saved)
    updateNotificationPosition()
    
    -- For mobile, force LOD on if not otherwise set
    if IS_MOBILE then
        Settings.VISUAL_LOD_ENABLED = true
    end
    
    createToggleButtons()
    createBossPanelButton()
    if bossPanelButton then
        bossPanelButton.Visible = guiEnabled
        -- Apply saved button position if needed (already done in constructor)
        if savedBossButtonPos then
            bossPanelButton.Position = savedBossButtonPos
        end
    end
    bossPanel = createBossPanel()
    createSettingsGUI()
    createItemListGUI()
    
    -- Apply saved positions
    if savedMainTogglePos and mainToggle then mainToggle.Position = savedMainTogglePos end
    if savedListTogglePos and listToggle then listToggle.Position = savedListTogglePos end
    if savedSettingsTogglePos and settingsToggle then settingsToggle.Position = savedSettingsTogglePos end
    if savedItemListGUIPos and itemListGUI then itemListGUI.Position = savedItemListGUIPos end
    if savedSettingsGUIPos and settingsGUI then settingsGUI.Position = savedSettingsGUIPos end
    if savedBossPanelPos and bossPanel then bossPanel.Position = savedBossPanelPos end
    
    if not guiEnabled then
        mainToggle.BackgroundColor3 = Settings.DISABLED_COLOR
        mainToggle.Text = "👁️"
        listToggle.Visible = false
        settingsToggle.Visible = false
    end
    
    -- Enable death return based on loaded setting
    enableDeathReturn(Settings.DEATH_RETURN_ENABLED)
    
    connections[#connections+1] = TRACK_PATH.DescendantAdded:Connect(onChildAdded)
    connections[#connections+1] = TRACK_PATH.DescendantRemoving:Connect(onChildRemoving)
    
    findAndSetupObjects()
    
    lastESPUpdate = tick()
    lastListUpdate = tick()
    lastSpecialCheck = tick()
    
    connections[#connections+1] = RunService.Heartbeat:Connect(updateDistances)
    
    debugPrint("✅ Initialization complete")
end

-- ========== START ==========
local function startScript()
    if LocalPlayer then
        if not LocalPlayer.Character then
            LocalPlayer.CharacterAdded:Wait()
        end
        task.wait(1)
        init()
    end
end

startScript()

-- ========== API ==========
return {
    ToggleGUI = function() if mainToggle then mainToggle:MouseButton1Click() end end,
    ShowItemList = function() toggleItemList(true) end,
    ShowSettings = function() toggleSettings(true) end,
    TeleportToNearest = teleportToNearest,
    SaveSettings = saveSettings,
    LoadSettings = loadSettings
}

-- END OF PART 4/4 (FULL SCRIPT READY)