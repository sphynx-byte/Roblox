local request = syn and syn.request or http_request or request
local HttpService = game:GetService("HttpService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")


-------------------------
-- CONFIG
-------------------------

local KEY = "SphynFree"

local LOADERS = {
    [130342654546662] = "https://raw.githubusercontent.com/sphynx-byte/Sambung-kata/refs/heads/main/Auto%20type.lua", --sambung kata indo
    [129866685202296] = "https://raw.githubusercontent.com/sphynx-byte/Last-letter/refs/heads/main/(kamus)%20last%20letter.lua", --last letter
    [121864768012064] = "https://raw.githubusercontent.com/sphynx-byte/Rusuh-fish-it/refs/heads/main/rusuh%20fishit.lua", --rusuh fish it
    [1502601752] = "https://raw.githubusercontent.com/sphynx-byte/Roblox/refs/heads/main/Rabbit%20Simulator%202.lua",  --Rabbit simulator 2
    [9872472334] = "https://raw.githubusercontent.com/sphynx-byte/Roblox/refs/heads/main/evade.lua", --evade
    [114234929420007] = "https://raw.githubusercontent.com/sphynx-byte/Roblox/refs/heads/main/Blox%20Strike.lua", --blox strike
    [103188421562819] = "https://raw.githubusercontent.com/sphynx-byte/Sambung-kata/refs/heads/main/(kamus)%20Sambung%20Kata%20Jawa.lua" -- SK Jawa
}


------- webhook
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local request = syn and syn.request or http_request or fluxus and fluxus.request or request
local LocalPlayer = Players.LocalPlayer

-- 🔒 WEBHOOK (ganti punyamu)
local WEBHOOK = "https://discord.com/api/webhooks/1493075652650340402/WKdw83o2gPcv-iqO3rT9ekw5zwm-_LpFRvsJ-2BNRWC4IpeSI4KbPdWsEx_2REgeTjlP"

-- ⏱️ Time
local startTime = os.time()
local joinTime = os.date("%H:%M:%S")

-- 🎮 Ambil nama game
local function getGameName()
    local success, info = pcall(function()
        return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
    end)
    return success and info.Name or "Unknown"
end

-- ⏳ Format waktu
local function formatTime(sec)
    return string.format("%02d:%02d:%02d",
        sec // 3600,
        (sec % 3600) // 60,
        sec % 60
    )
end

-- 📦 Build data
local function buildData(status)
    return {
        content = "**Player Logger**",
        embeds = {{
            title = status,
            color = status == "JOIN" and 65280 or 16711680,

            fields = {
                {name = "Game", value = getGameName(), inline = false},
                {name = "Username", value = LocalPlayer.Name, inline = true},
                {name = "UserId", value = tostring(LocalPlayer.UserId), inline = true},
                {name = "PlaceId", value = tostring(game.PlaceId), inline = true},
                {name = "Join Time", value = joinTime, inline = true},
                {name = "Current Time", value = os.date("%H:%M:%S"), inline = true},
                {name = "Uptime", value = formatTime(os.time() - startTime), inline = false},
            },

            footer = {
                text = "Simple Logger"
            },

            timestamp = DateTime.now():ToIsoDate()
        }}
    }
end

-- 📡 Kirim webhook
local function send(status)
    if not request then return end

    pcall(function()
        request({
            Url = WEBHOOK,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(buildData(status))
        })
    end)
end

-- 🚀 JOIN
send("JOIN")

-- 🚪 LEAVE (lebih reliable)
Players.PlayerRemoving:Connect(function(plr)
    if plr == LocalPlayer then
        send("LEAVE")
    end
end)

-- 🧨 Backup (kalau close)
game:BindToClose(function()
    send("LEAVE")
    task.wait(2)
end)

-------------------------
-- PLACE CHECK
-------------------------

local placeId = game.PlaceId

if not LOADERS[placeId] then
    player:Kick("Game Not Supported!")
    return
end

--------------------

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Sphyn Hub",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "by Sphyn",
    ConfigurationSaving = {
        Enabled = false
    }
})

local Tab = Window:CreateTab("Key System", 4483362458)

local Input = Tab:CreateInput({
    Name = "Enter Key",
    PlaceholderText = "Input your key here",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        _G.EnteredKey = Text
    end,
})

Tab:CreateButton({
    Name = "Join Discord",
    Callback = function()
        if syn then
            syn.request({
                Url = "https://discord.gg/nQmhZVbG7v",
                Method = "GET"
            })
        else
            setclipboard("https://discord.gg/nQmhZVbG7v")
        end
    end,
})

Tab:CreateButton({
    Name = "Submit",
    Callback = function()
        if _G.EnteredKey ~= KEY then
            Rayfield:Notify({
                Title = "Error",
                Content = "Wrong Key!",
                Duration = 3
            })

            task.wait(1)
            player:Kick("🔐Wrong Key!!🔑")
            return
        end

        Rayfield:Notify({
            Title = "Success",
            Content = "Key Accepted!",
            Duration = 2
        })

        task.wait(1)

        Rayfield:Destroy()

        local url = LOADERS[placeId]

        pcall(function()
            loadstring(game:HttpGet(url))()
        end)
    end,
})

