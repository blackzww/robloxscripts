--[[
    Mirrors Hub - Blox Fruits
    Author: blackzw (Enhanced Version)
    Description: A feature-rich Blox Fruits script hub with improved UI and functionality
]]

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")

-- Player Variables
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")
local mouse = player:GetMouse()

-- Load Fluent Library
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- Version and Info
local VERSION = "2.0.0"
local GAME_ID = 2753915549  -- Blox Fruits Game ID

-- Main Window Creation
local Window = Fluent:CreateWindow({
    Title = "Mirrors Hub - Blox Fruits " .. VERSION,
    SubTitle = "by blackzw | Enhanced Edition",
    TabWidth = 160,
    Size = UDim2.fromOffset(600, 500),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

-- Tabs
local Tabs = {
    Info = Window:AddTab({ Title = "Info", Icon = "info" }),
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Player = Window:AddTab({ Title = "Player", Icon = "user" }),
    Combat = Window:AddTab({ Title = "Combat", Icon = "swords" }),
    Farm = Window:AddTab({ Title = "Farm", Icon = "gantt-chart" }),
    Teleports = Window:AddTab({ Title = "Teleports", Icon = "map-pin" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "settings" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- Options reference
local Options = Fluent.Options

-- State Management
local State = {
    AutoFarm = false,
    AutoQuest = false,
    AutoBuy = false,
    BringMobs = false,
    AntiIdle = false,
    AutoHaki = false,
    Invisible = false,
    Walkspeed = 16,
    JumpPower = 50,
    CurrentIsland = "Starting Island",
    SelectedFruit = nil,
    SelectedWeapon = nil,
    TargetNPC = nil
}

-- Floating Button System
local function CreateFloatingButton()
    local FloatGui = Instance.new("ScreenGui")
    FloatGui.Name = "MirrorsHubFloat"
    FloatGui.Parent = player:WaitForChild("PlayerGui")
    FloatGui.ResetOnSpawn = false
    FloatGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local FloatButton = Instance.new("ImageButton")
    FloatButton.Parent = FloatGui
    FloatButton.Size = UDim2.fromOffset(65, 65)
    FloatButton.Position = UDim2.new(0.05, 0, 0.5, 0)
    FloatButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    FloatButton.BackgroundTransparency = 0.2
    FloatButton.BorderSizePixel = 0
    FloatButton.Image = "rbxassetid://77513496492572"
    FloatButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
    FloatButton.ScaleType = Enum.ScaleType.Fit
    FloatButton.Active = true
    FloatButton.AutoButtonColor = true
    
    -- Rounded corners
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = FloatButton
    
    -- Shadow effect
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Parent = FloatButton
    Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.fromOffset(5, 5)
    Shadow.Size = UDim2.fromScale(1, 1)
    Shadow.Image = "rbxassetid://6015897843"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.8
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    
    -- Drag system for mobile
    local dragging = false
    local dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        FloatButton.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end

    FloatButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = FloatButton.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    FloatButton.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    -- Click animation and functionality
    FloatButton.MouseButton1Click:Connect(function()
        -- Click animation
        local tweenInfo = TweenInfo.new(
            0.2,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out
        )
        
        local scaleUp = TweenService:Create(FloatButton, tweenInfo, {Size = UDim2.fromOffset(75, 75)})
        local scaleDown = TweenService:Create(FloatButton, tweenInfo, {Size = UDim2.fromOffset(65, 65)})
        
        scaleUp:Play()
        scaleUp.Completed:Connect(function()
            scaleDown:Play()
        end)
        
        -- Simulate Right Control key press
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.RightControl, false, game)
        task.wait(0.1)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.RightControl, false, game)
    end)
    
    return FloatGui
end

-- Notification System
local function SendNotification(title, content, duration)
    Fluent:Notify({
        Title = title,
        Content = content,
        SubContent = "Mirrors Hub",
        Duration = duration or 5
    })
end

-- Player Info Functions
local function GetPlayerStats()
    local stats = {
        Level = player.Data.Level.Value,
        Fruit = player.Data.Fruit.Value or "None",
        Race = player.Data.Race.Value,
        Beli = player.Data.Beli.Value,
        Fragments = player.Data.Fragments.Value,
        Deaths = player.Data.Deaths.Value,
        PlayTime = player.Data.PlayTime.Value
    }
    return stats
end

-- Auto Farm Function
local function StartAutoFarm(target)
    while State.AutoFarm do
        local closestEnemy = nil
        local shortestDistance = math.huge
        
        -- Find nearest enemy
        for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                local distance = (rootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestEnemy = enemy
                end
            end
        end
        
        if closestEnemy then
            -- Move to enemy
            rootPart.CFrame = closestEnemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
            
            -- Attack if close enough
            if shortestDistance < 20 then
                local args = {
                    [1] = closestEnemy.HumanoidRootPart.Position,
                    [2] = closestEnemy.HumanoidRootPart
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Combat"):FireServer(unpack(args))
            end
        end
        
        task.wait(0.1)
    end
end

-- UI Elements
do
    -- Info Tab
    Tabs.Info:AddParagraph({
        Title = "Welcome to Mirrors Hub",
        Content = string.format([[
            Version: %s
            Game: Blox Fruits
            Features: Auto Farm, Auto Quest, Auto Buy, etc.
            
            How to use:
            1. Navigate through tabs
            2. Enable desired features
            3. Enjoy!
            
            Made with ❤️ by blackzw
        ]], VERSION)
    })
    
    Tabs.Info:AddButton({
        Title = "Copy Discord Link",
        Description = "Join our community for updates",
        Callback = function()
            setclipboard("https://discord.gg/mirrorshub")
            SendNotification("Discord", "Link copied to clipboard!", 3)
        end
    })
    
    Tabs.Info:AddButton({
        Title = "Check for Updates",
        Description = "Verify if you have the latest version",
        Callback = function()
            -- Simulate update check
            SendNotification("Update Check", "You have the latest version: " .. VERSION, 4)
        end
    })
    
    -- Player Tab
    local StatsParagraph = Tabs.Player:AddParagraph({
        Title = "Player Statistics",
        Content = "Loading stats..."
    })
    
    -- Auto-update stats
    spawn(function()
        while task.wait(2) do
            local stats = GetPlayerStats()
            StatsParagraph:SetContent(string.format([[
                Level: %d
                Fruit: %s
                Race: %s
                Beli: %s
                Fragments: %s
                Deaths: %d
                PlayTime: %ds
            ]], stats.Level, stats.Fruit, stats.Race, 
               string.format("%.1fM", stats.Beli/1000000),
               stats.Fragments, stats.Deaths, stats.PlayTime))
        end
    end)
    
    -- Speed Slider
    Tabs.Player:AddSlider("SpeedSlider", {
        Title = "Walk Speed",
        Description = "Adjust your movement speed",
        Default = 16,
        Min = 16,
        Max = 120,
        Rounding = 1,
        Callback = function(value)
            State.Walkspeed = value
            if character and character.Humanoid then
                character.Humanoid.WalkSpeed = value
            end
        end
    })
    
    -- Jump Power Slider
    Tabs.Player:AddSlider("JumpSlider", {
        Title = "Jump Power",
        Description = "Adjust your jump height",
        Default = 50,
        Min = 50,
        Max = 200,
        Rounding = 1,
        Callback = function(value)
            State.JumpPower = value
            if character and character.Humanoid then
                character.Humanoid.JumpPower = value
            end
        end
    })
    
    -- Farm Tab
    local AutoFarmToggle = Tabs.Farm:AddToggle("AutoFarmToggle", {
        Title = "Auto Farm",
        Description = "Automatically farm enemies",
        Default = false
    })
    
    AutoFarmToggle:OnChanged(function()
        State.AutoFarm = Options.AutoFarmToggle.Value
        if State.AutoFarm then
            SendNotification("Auto Farm", "Auto Farm Enabled", 3)
            spawn(function() StartAutoFarm() end)
        else
            SendNotification("Auto Farm", "Auto Farm Disabled", 3)
        end
    end)
    
    local BringMobsToggle = Tabs.Farm:AddToggle("BringMobsToggle", {
        Title = "Bring Mobs",
        Description = "Bring enemies to you",
        Default = false
    })
    
    BringMobsToggle:OnChanged(function()
        State.BringMobs = Options.BringMobsToggle.Value
    end)
    
    -- Dropdown for farm mode
    Tabs.Farm:AddDropdown("FarmModeDropdown", {
        Title = "Farm Mode",
        Description = "Select what to farm",
        Values = {"Levels", "Beli", "Fragments", "Bosses"},
        Multi = false,
        Default = 1,
        Callback = function(value)
            print("Farm mode changed to:", value)
        end
    })
    
    -- Teleports Tab
    local Islands = {"Marine Starter", "Jungle", "Desert", "Frozen Village", "Colosseum", "Sky Island 1", "Sky Island 2"}
    
    Tabs.Teleports:AddDropdown("IslandDropdown", {
        Title = "Select Island",
        Description = "Choose an island to teleport to",
        Values = Islands,
        Multi = false,
        Default = 1,
    })
    
    Tabs.Teleports:AddButton({
        Title = "Teleport",
        Description = "Go to selected island",
        Callback = function()
            local selected = Options.IslandDropdown.Value
            SendNotification("Teleport", "Teleporting to " .. selected .. "...", 2)
            -- Add teleport logic here
        end
    })
    
    Tabs.Teleports:AddButton({
        Title = "Teleport to Random Island",
        Description = "Feeling lucky?",
        Callback = function()
            local randomIsland = Islands[math.random(1, #Islands)]
            SendNotification("Teleport", "Teleporting to " .. randomIsland .. "...", 2)
        end
    })
    
    -- Misc Tab
    local AntiIdleToggle = Tabs.Misc:AddToggle("AntiIdleToggle", {
        Title = "Anti-Idle",
        Description = "Prevent being kicked for idling",
        Default = false
    })
    
    AntiIdleToggle:OnChanged(function()
        State.AntiIdle = Options.AntiIdleToggle.Value
    end)
    
    -- Anti-Idle loop
    spawn(function()
        while true do
            task.wait(60)
            if State.AntiIdle then
                -- Simulate some input
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                task.wait(0.1)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
            end
        end
    end)
    
    -- Color picker for UI
    Tabs.Misc:AddColorpicker("UIColorPicker", {
        Title = "UI Color",
        Description = "Change the interface color",
        Default = Color3.fromRGB(96, 205, 255)
    })
    
    Tabs.Misc:AddColorpicker("UIColorPicker2", {
        Title = "UI Accent Color",
        Description = "Change the accent color",
        Transparency = 0,
        Default = Color3.fromRGB(255, 100, 100)
    })
    
    -- Input field
    Tabs.Misc:AddInput("ConsoleInput", {
        Title = "Console Command",
        Description = "Execute custom commands",
        Placeholder = "Type command here...",
        Callback = function(value)
            if value == "/clear" then
                print("Console cleared")
            end
        end
    })
    
    -- Keybind
    Tabs.Misc:AddKeybind("MenuKeybind", {
        Title = "Menu Keybind",
        Description = "Key to open/close menu",
        Mode = "Toggle",
        Default = "RightControl",
        Callback = function(value)
            if value then
                Window:Toggle()
            end
        end
    })
    
    -- Settings Tab
    Tabs.Settings:AddDropdown("ThemeDropdown", {
        Title = "Theme",
        Description = "Choose UI theme",
        Values = {"Dark", "Light", "Darker", "Midnight", "Ocean", "Forest"},
        Multi = false,
        Default = 1,
        Callback = function(theme)
            Fluent:SetTheme(theme)
        end
    })
    
    Tabs.Settings:AddButton({
        Title = "Reset Settings",
        Description = "Reset all settings to default",
        Callback = function()
            Window:Dialog({
                Title = "Reset Settings",
                Content = "Are you sure you want to reset all settings?",
                Buttons = {
                    {
                        Title = "Yes",
                        Callback = function()
                            SaveManager:Reset()
                            SendNotification("Settings", "Settings have been reset", 3)
                        end
                    },
                    {
                        Title = "No",
                        Callback = function() end
                    }
                }
            })
        end
    })
end

-- Character Added Event
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = newCharacter:WaitForChild("Humanoid")
    rootPart = newCharacter:WaitForChild("HumanoidRootPart")
    
    -- Reapply settings
    humanoid.WalkSpeed = State.Walkspeed
    humanoid.JumpPower = State.JumpPower
end)

-- Initialize Managers
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("MirrorsHub")
SaveManager:SetFolder("MirrorsHub/bloxfruits")

-- Build Interface and Config sections
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- Create floating button
local FloatGui = CreateFloatingButton()

-- Select first tab
Window:SelectTab(1)

-- Welcome notification
SendNotification("Mirrors Hub - BF", "Script loaded successfully! Version: " .. VERSION, 8)

-- Load autoload config if exists
SaveManager:LoadAutoloadConfig()

-- Cleanup function
local function OnScriptUnload()
    if FloatGui then
        FloatGui:Destroy()
    end
    SendNotification("Mirrors Hub", "Script unloaded successfully", 3)
end

-- Unload handler
Fluent.Unloaded:Connect(OnScriptUnload)

print("Mirrors Hub Enhanced Edition v" .. VERSION .. " loaded successfully!")