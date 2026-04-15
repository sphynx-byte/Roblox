local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Sphyn Hub",
    LoadingTitle = "Troll Is A Pinning Tower 2",
    LoadingSubtitle = "Join Discord For More Scripts",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
    })
 
 Rayfield:Notify({
   Title = "Sphyn Hub Loaded",
   Content = "Join Discord For More Scripts",
   Duration = 6.5,
   Image = nil,
})


local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local MainTab = Window:CreateTab("Main", nil)

MainTab:CreateSection("WalkSpeed")
MainTab:CreateSlider({
    Name = "WalkSpeed Changer",
    Range = {10, 1000},
    Increment = 10,
    Suffix = " Speed",
    CurrentValue = 16,
    Flag = "WalkSpeedSlider",
    Callback = function(Value)
        local Char = LocalPlayer.Character
        if Char and Char:FindFirstChild("Humanoid") then
            Char.Humanoid.WalkSpeed = Value
        end
    end
})

MainTab:CreateSection("JumpPower")
MainTab:CreateSlider({
    Name = "JumpPower Changer",
    Range = {10, 1000},
    Increment = 10,
    Suffix = " Power",
    CurrentValue = 10,
    Flag = "JumpPowerSlider",
    Callback = function(Value)
        local Char = LocalPlayer.Character
        if Char then
            local Humanoid = Char:FindFirstChildOfClass("Humanoid")
            if Humanoid then
                Humanoid.UseJumpPower = true
                Humanoid.JumpPower = Value
            end
        end
    end
})

MainTab:CreateSection("Infinite Jump")

local InfiniteJumpEnabled = false

MainTab:CreateToggle({
    Name = "Enable Infinite Jump",
    CurrentValue = false,
    Flag = "InfiniteJumpToggle",
    Callback = function(Value)
        InfiniteJumpEnabled = Value
    end
})

-- Jump handler (runs once)
UserInputService.JumpRequest:Connect(function()
    if InfiniteJumpEnabled and LocalPlayer.Character then
        local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function(Char)
    task.wait(1) -- wait for Humanoid to exist
    local Humanoid = Char:WaitForChild("Humanoid")
    -- Re-apply sliders
    local WalkSpeed = Rayfield.Flags["WalkSpeedSlider"].Value
    local JumpPower = Rayfield.Flags["JumpPowerSlider"].Value
    Humanoid.WalkSpeed = WalkSpeed
    Humanoid.UseJumpPower = true
    Humanoid.JumpPower = JumpPower
end)

MainTab:CreateButton({
    Name = "Invisible",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/3Rnd9rHf"))()
    end
})

MainTab:CreateButton({
    Name = "Fly",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
    end
})

MainTab:CreateButton({
    Name = "Esp Player",
    Callback = function()
        loadstring(game:HttpGet("https://pastefy.app/95T5wXlP/raw"))()
    end
})
        
        
local Tab = Window:CreateTab("Scripts",nil )

local Section = Tab:CreateSection("Trolling")

Tab:CreateButton({
    Name = "Instant Trolling",
    Callback = function()
        _G.auto = true
        while _G.auto do
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-78.26, 146.5, -81.09)
            task.wait(0.3)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-45.66, 146.1, -80.96)
            task.wait(0.25)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-34.28, 146.64, -82.58)
            task.wait(0.15)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-24.63, 146.64, -82.31)
            task.wait(0.05)
        end
    end
})

Tab:CreateButton({
    Name = "Stop Trolling",
    Callback = function()
        _G.auto = false
    end
})

        
 local running = false

Tab:CreateSection("On Bypass Group Wall")
Tab:CreateButton({
    Name = "On Bypass Group Wall",
    Callback = function()
        running = true 

        local function bypassGroupDoor()
            for _, v in ipairs(workspace:GetDescendants()) do
                if v.Name == "Group" then
                    pcall(function()
                        v.CanCollide = false
                        v.Transparency = 1
                    end)
                end
            end
        end
        
        bypassGroupDoor()
        
        task.spawn(function()
            while running do
                bypassGroupDoor()
                task.wait(5)
            end
        end)
    end
})

Tab:CreateButton({
    Name = "Off Bypass Group Wall",
    Callback = function()
        running = false  

        local function restoreGroupDoor()
            for _, v in ipairs(workspace:GetDescendants()) do
                if v.Name == "Group" then
                    pcall(function()
                        v.CanCollide = true
                        v.Transparency = 3
                    end)
                end
            end
        end
        
        restoreGroupDoor()
    end
})  
        
        
Tab:CreateSection("Tool Coil")

Tab:CreateButton({
    Name = "Tool Coil",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Ahma174/Tool/refs/heads/main/Ice%20Coil%20%2B%20Infinite%20jump%20Coil"))()
    end
})        
   
        
                  
Tab:CreateSection("Leg Admin V2")

Tab:CreateButton({
    Name = "Player Join & Leave Game",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/leg1337/legadmv2/main/legadminv2.lua'))()
    end
})    

        
local AdminTab = Window:CreateTab("Information", nil)    
     
AdminTab:CreateSection("Sphyn Hub")

AdminTab:CreateButton({
    Name = "Join Discord",
    Callback = function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Sphyn Hub",
            Text = "Discord Copied!",
            Duration = 5
        })
        setclipboard("https://discord.gg/nQmhZVbG7v")
    end
})

print("Sphyn Hub Loaded Successfully!!")
print("https://discord.gg/nQmhZVbG7v")
print("JOIN DISCORD FOR MORE SCRIPTS")
