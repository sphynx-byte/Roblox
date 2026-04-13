repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local request = syn and syn.request or http_request or fluxus and fluxus.request or request

if not request then
    warn("Request tidak support")
    return
end

-- tunggu player ready
local player
repeat
    player = Players.LocalPlayer
    task.wait()
until player

print("Logger Loaded")

-------------------------
-- CONFIG
-------------------------

local KEY = "SphynFree"

local LOADERS = {
    [130342654546662] = "https://raw.githubusercontent.com/sphynx-byte/Sambung-kata/refs/heads/main/Auto%20type.lua",
    [129866685202296] = "https://raw.githubusercontent.com/sphynx-byte/Last-letter/refs/heads/main/(kamus)%20last%20letter.lua",
    [121864768012064] = "https://raw.githubusercontent.com/sphynx-byte/Rusuh-fish-it/refs/heads/main/rusuh%20fishit.lua",
    [1502601752] = "https://raw.githubusercontent.com/sphynx-byte/Roblox/refs/heads/main/Rabbit%20Simulator%202.lua",
    [9872472334] = "https://raw.githubusercontent.com/sphynx-byte/Roblox/refs/heads/main/evade.lua",
    [114234929420007] = "https://raw.githubusercontent.com/sphynx-byte/Roblox/refs/heads/main/Blox%20Strike.lua",
    [103188421562819] = "https://raw.githubusercontent.com/sphynx-byte/Sambung-kata/refs/heads/main/(kamus)%20Sambung%20Kata%20Jawa.lua"
}

-------------------------
-- LOGGER
-------------------------

local WEBHOOK = "https://discord.com/api/webhooks/1493075652650340402/WKdw83o2gPcv-iqO3rT9ekw5zwm-_LpFRvsJ-2BNRWC4IpeSI4KbPdWsEx_2REgeTjlP"

local startTime = os.time()
local joinTime = os.date("%H:%M:%S")

local function getGameName()
    local success, info = pcall(function()
        return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
    end)
    return success and info.Name or "Unknown"
end

local function formatTime(sec)
    return string.format("%02d:%02d:%02d",
        sec // 3600,
        (sec % 3600) // 60,
        sec % 60
    )
end

local function send(status)
    print("Kirim:", status)

    local data = {
        embeds = {{
            title = status,
            color = status == "JOIN" and 65280 or 16711680,
            fields = {
                {name="Game", value=getGameName()},
                {name="Username", value=player.Name},
                {name="UserId", value=tostring(player.UserId)},
                {name="PlaceId", value=tostring(game.PlaceId)},
                {name="Join Time", value=joinTime},
                {name="Time Now", value=os.date("%H:%M:%S")},
                {name="Uptime", value=formatTime(os.time() - startTime)}
            },
            timestamp = DateTime.now():ToIsoDate()
        }}
    }

    local success, err = pcall(function()
        request({
            Url = WEBHOOK,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(data)
        })
    end)

    if not success then
        warn("Webhook error:", err)
    end
end

-- kirim JOIN (aman)
task.spawn(function()
    task.wait(3)
    send("JOIN")
end)

-- LEAVE
Players.PlayerRemoving:Connect(function(plr)
    if plr == player then
        send("LEAVE")
    end
end)

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

-------------------------
-- UI
-------------------------

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

Tab:CreateInput({
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
        setclipboard("https://discord.gg/nQmhZVbG7v")
    end,
})

Tab:CreateButton({
    Name = "Submit",
    Callback = function()
        if _G.EnteredKey ~= KEY then
            player:Kick("🔐Wrong Key!!🔑")
            return
        end

        Rayfield:Destroy()

        local url = LOADERS[placeId]
        pcall(function()
            loadstring(game:HttpGet(url))()
        end)
    end,
})
