local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")

local player = Players.LocalPlayer

-------------------------
-- CONFIG
-------------------------

local KEY = "SphynFree"

local a = "https://discord.com/api/webhooks/"
local b = "1493075638205026394/"
local c = "w0-Sl1USfkglNnk03mdZGQY_mU0Jgvvg8fVgpG-Cl9e39aL41QB5GiWVrIz9qEBVNvRm"

local WEBHOOK_URL = a..b..c

local LOADERS = {
    [130342654546662] = "https://raw.githubusercontent.com/sphynx-byte/Sambung-kata/refs/heads/main/Auto%20type.lua",
    [129866685202296] = "https://raw.githubusercontent.com/sphynx-byte/Last-letter/refs/heads/main/(kamus)%20last%20letter.lua",
    [121864768012064] = "https://raw.githubusercontent.com/sphynx-byte/Rusuh-fish-it/refs/heads/main/rusuh%20fishit.lua",
    [1502601752] = "https://raw.githubusercontent.com/sphynx-byte/Roblox/refs/heads/main/Rabbit%20Simulator%202.lua",
    [9872472334] = "https://raw.githubusercontent.com/sphynx-byte/Roblox/refs/heads/main/evade.lua",
    [114234929420007] = "https://raw.githubusercontent.com/sphynx-byte/Roblox/refs/heads/main/Blox%20Strike.lua",
    [103188421562819] = "https://raw.githubusercontent.com/sphynx-byte/Sambung-kata/refs/heads/main/(kamus)%20Sambung%20Kata%20Jawa.lua",
    [83312952548612] = "https://raw.githubusercontent.com/sphynx-byte/Roblox/refs/heads/main/troll%20is%20a%20pinning%20tower%202.lua" 
}

-------------------------
-- PLACE CHECK
-------------------------

local placeId = game.PlaceId

if not LOADERS[placeId] then
    player:Kick("Game Not Supported!")
    return
end

-------------------------
-- WEBHOOK FUNCTION
-------------------------

local function sendWebhook()
    local gameName = "Unknown"

    pcall(function()
        gameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
    end)

    local data = {
        ["content"] = "",
        ["embeds"] = {{
            ["title"] = "🎮 Player Execute Script",
            ["color"] = 65280,
            ["fields"] = {
                {
                    ["name"] = "👤 Username",
                    ["value"] = player.Name,
                    ["inline"] = true
                },
                {
                    ["name"] = "🆔 User ID",
                    ["value"] = tostring(player.UserId),
                    ["inline"] = true
                },
                {
                    ["name"] = "🎯 Game",
                    ["value"] = gameName,
                    ["inline"] = false
                },
                {
                    ["name"] = "⏰ Time",
                    ["value"] = os.date("%Y-%m-%d %H:%M:%S"),
                    ["inline"] = false
                }
            }
        }}
    }

    local jsonData = HttpService:JSONEncode(data)

    if syn and syn.request then
        syn.request({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = jsonData
        })
    elseif request then
        request({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = jsonData
        })
    elseif http_request then
        http_request({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = jsonData
        })
    end
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

        -- 🔥 SEND WEBHOOK DI SINI
        sendWebhook()

        task.wait(1)

        Rayfield:Destroy()

        local url = LOADERS[placeId]

        pcall(function()
            loadstring(game:HttpGet(url))()
        end)
    end,
})
