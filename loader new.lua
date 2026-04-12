local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer

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
