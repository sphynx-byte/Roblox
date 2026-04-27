--// LOAD UI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

--// WINDOW
local Window = Rayfield:CreateWindow({
    Name = "Koala Hub - Swing Obby",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "Clean Version",
    ConfigurationSaving = {
        Enabled = true,
        FileName = "KoalaHub",
        FolderName = "KoalaHub"
    }
})

--// SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer

--// TABS
local FarmTab = Window:CreateTab("Farm", 4483362458)
local UpgradeTab = Window:CreateTab("Upgrades", 4483362458)
local AutoTab = Window:CreateTab("Automation", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)

--------------------------------------------------
-- SETTINGS
--------------------------------------------------
local ExcludeRarity = {}
local ExcludeRank = {}
local MinLevel = 0

--------------------------------------------------
-- FARM TAB
--------------------------------------------------
FarmTab:CreateDropdown({
    Name = "Exclude Rarity",
    MultipleOptions = true,
    Options = {"COMMON","UNCOMMON","RARE","EPIC","LEGENDARY","MYTHIC","SECRET","ANCIENT","DIVINE"},
    Callback = function(v)
        ExcludeRarity = v
    end
})

FarmTab:CreateDropdown({
    Name = "Exclude Rank",
    MultipleOptions = true,
    Options = {"NORMAL","GOLDEN","DIAMOND","EMERALD","RUBY","RAINBOW","VOID","ETHEREAL","CELESTIAL"},
    Callback = function(v)
        ExcludeRank = v
    end
})

FarmTab:CreateInput({
    Name = "Minimum Level",
    PlaceholderText = "Number",
    Callback = function(v)
        MinLevel = tonumber(v) or 0
    end
})

--------------------------------------------------
-- HELPER FUNCTIONS
--------------------------------------------------
local function teleport(cf)
    Player.Character.HumanoidRootPart.CFrame = cf
end

local function tweenTo(cf)
    local root = Player.Character.HumanoidRootPart
    local tween = TweenService:Create(root, TweenInfo.new(0.2), {CFrame = cf})
    tween:Play()
    tween.Completed:Wait()
end

--------------------------------------------------
-- AUTO FARM LOGIC (SIMPLIFIED)
--------------------------------------------------
local function getBestTarget()
    local bestTarget = nil
    local bestValue = 0

    for _, obj in pairs(workspace.ActiveBrainrots:GetChildren()) do
        if obj:FindFirstChild("LevelBoard") then
            local board = obj.LevelBoard.Frame

            local earnings = tonumber(string.match(board.CurrencyFrame.Earnings.Text, "%d+")) or 0
            local level = tonumber(string.match(board.Level.Text, "%d+")) or 0
            local rarity = board.Rarity.Text
            local rank = board.Rank.Text

            if level >= MinLevel 
            and not ExcludeRarity[rarity] 
            and not ExcludeRank[rank] then
                
                if earnings > bestValue then
                    bestValue = earnings
                    bestTarget = obj
                end
            end
        end
    end

    return bestTarget
end

--------------------------------------------------
-- AUTO FARM
--------------------------------------------------
local AutoFarm = false

FarmTab:CreateToggle({
    Name = "Auto Farm",
    Callback = function(v)
        AutoFarm = v

        if v then
            task.spawn(function()
                while AutoFarm do
                    pcall(function()
                        local target = getBestTarget()
                        if target then
                            local part = target:FindFirstChild("MainPart") or target:FindFirstChildWhichIsA("BasePart")
                            if part then
                                teleport(part.CFrame + Vector3.new(0,3,0))
                                task.wait(0.3)

                                local prompt = target:FindFirstChildWhichIsA("ProximityPrompt", true)
                                if prompt then
                                    fireproximityprompt(prompt)
                                end
                            end
                        end
                    end)

                    task.wait(1.5)
                end
            end)
        end
    end
})

--------------------------------------------------
-- AUTO UPGRADE
--------------------------------------------------
local UpgradeService = ReplicatedStorage.Packages.Knit.Services.StatUpgradeService.RF.Upgrade

local SelectedUpgrades = {}
local UpgradeDelay = 1

UpgradeTab:CreateDropdown({
    Name = "Select Upgrades",
    MultipleOptions = true,
    Options = {"Power","Reach","Carry"},
    Callback = function(v)
        SelectedUpgrades = v
    end
})

UpgradeTab:CreateSlider({
    Name = "Interval",
    Range = {0,5},
    Increment = 1,
    CurrentValue = 1,
    Callback = function(v)
        UpgradeDelay = v
    end
})

UpgradeTab:CreateToggle({
    Name = "Auto Upgrade",
    Callback = function(v)
        if v then
            task.spawn(function()
                while v do
                    for name,_ in pairs(SelectedUpgrades) do
                        UpgradeService:InvokeServer(name, 1)
                    end
                    task.wait(UpgradeDelay)
                end
            end)
        end
    end
})

--------------------------------------------------
-- AUTO REBIRTH
--------------------------------------------------
local RebirthService = ReplicatedStorage.Packages.Knit.Services.StatUpgradeService.RF.Rebirth

AutoTab:CreateToggle({
    Name = "Auto Rebirth",
    Callback = function(v)
        if v then
            task.spawn(function()
                while v do
                    pcall(function()
                        RebirthService:InvokeServer()
                    end)
                    task.wait(1)
                end
            end)
        end
    end
})

--------------------------------------------------
-- AUTO COLLECT
--------------------------------------------------
local CollectMode = "Teleport"
local AutoCollect = false

AutoTab:CreateDropdown({
    Name = "Collect Method",
    Options = {"Teleport","Tween"},
    CurrentOption = "Teleport",
    Callback = function(v)
        CollectMode = v
    end
})

AutoTab:CreateToggle({
    Name = "Auto Collect",
    Callback = function(v)
        AutoCollect = v

        if v then
            task.spawn(function()
                while AutoCollect do
                    pcall(function()
                        for _, obj in pairs(workspace:GetDescendants()) do
                            if obj:IsA("BasePart") and obj.Name == "TouchPart" then
                                if CollectMode == "Tween" then
                                    tweenTo(obj.CFrame)
                                else
                                    teleport(obj.CFrame)
                                end
                            end
                        end
                    end)

                    task.wait(0.5)
                end
            end)
        end
    end
})

--------------------------------------------------
-- MISC
--------------------------------------------------
MiscTab:CreateButton({
    Name = "Teleport to End",
    Callback = function()
        teleport(CFrame.new(21, -10, -34044))
    end
})

--// LOAD CONFIG
Rayfield:LoadConfiguration()