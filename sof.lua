--// XOR STRING DECODE (ASLI - TIDAK DIUBAH)
local function decode(str, key)
    local result = {}
    for i = 1, #str do
        table.insert(result, string.char(
            bit32.bxor(
                string.byte(str, i),
                string.byte(key, (i % #key) + 1)
            ) % 256
        ))
    end
    return table.concat(result)
end

--// LOAD UI (ASLI)
local Rayfield = loadstring(game:HttpGet(
    decode("\217\215\207\53\245\225\136\81\194\202\201\44\243\168\137\19\212\205\206\106\244\186\222\24\216\198\215\33",
           "\126\177\163\187\69\134\219\167")
))()

--// WINDOW
local Window = Rayfield:CreateWindow({
    Name = decode("\31\184\72\26\189\102\110\33\181\9\91\252\21\81\61\185\78\86\147\36\68\45\247\111\25\174\102\100\38\182\64\24\174\41\82\39\246","\38\84\215\41\118\220\70"),
    LoadingTitle = decode("\135\43\17\50\122\171\252\235\15\31\55\127\164\187\131\49\18","\155\203\68\112\86\19\197"),
    LoadingSubtitle = decode("\254\78\231\23\228\6\191\23\228\6","\38\156\55\199"),
})

--// SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

--------------------------------------------------
-- STATE (ASLI)
--------------------------------------------------
local AutoFarmEnabled = false
local SelectedRarity = {}
local SelectedRank = {}
local MinLevel = 0

--------------------------------------------------
-- PARSE EARNINGS (ASLI LOGIC)
--------------------------------------------------
local multipliers = {
    k = 1e3,
    m = 1e6,
    b = 1e9,
    t = 1e12,
    qa = 1e15,
    qi = 1e18
}

local function parseEarnings(text)
    if not text then return 0 end

    text = text:lower():gsub(",", ""):gsub("%s+", "")

    local num, suffix = text:match("([%d%.]+)(%a*)")
    num = tonumber(num) or 0

    return num * (multipliers[suffix] or 1)
end

--------------------------------------------------
-- FIND BEST TARGET (LOGIC IDENTIK)
--------------------------------------------------
local function getBestTarget()
    local bestModel = nil
    local bestPart = nil
    local highestValue = 0

    for _, obj in pairs(workspace.ActiveBrainrots:GetChildren()) do
        if obj:IsA("Model") then

            local board = obj:FindFirstChildOfClass("Model")
            if not board then continue end

            local success, data = pcall(function()
                local frame = board.LevelBoard.Frame
                return {
                    earnings = frame.CurrencyFrame.Earnings.Text,
                    rarity = frame.Rarity.Text,
                    rank = frame.Rank.Text,
                    level = frame.Level.Text
                }
            end)

            if success and data then
                local level = tonumber(data.level:match("%d+")) or 0
                if level <= MinLevel then continue end

                if SelectedRarity[data.rarity] then continue end
                if SelectedRank[data.rank] then continue end

                local value = parseEarnings(data.earnings)

                if value > highestValue then
                    highestValue = value
                    bestModel = obj
                    bestPart = board
                end
            end
        end
    end

    return bestModel, bestPart
end

--------------------------------------------------
-- TELEPORT (ASLI)
--------------------------------------------------
local function teleport(cf)
    LocalPlayer.Character.HumanoidRootPart.CFrame = cf
end

--------------------------------------------------
-- AUTO FARM CORE (ASLI FLOW)
--------------------------------------------------
local function doFarm()
    local model, board = getBestTarget()
    if not model or not board then return end

    local attach = board:FindFirstChild("Attachment", true)
    if not attach then return end

    teleport(attach.CFrame + Vector3.new(0,3,0))
    task.wait(0.3)

    local prompt = model:FindFirstChildWhichIsA("ProximityPrompt", true)
    if prompt then
        fireproximityprompt(prompt)
    end

    task.wait(0.3)
    teleport(CFrame.new(-18, -10, -57))
end

--------------------------------------------------
-- LOOP (ASLI)
--------------------------------------------------
task.spawn(function()
    while true do
        if AutoFarmEnabled then
            pcall(doFarm)
        end
        task.wait(1.5)
    end
end)
