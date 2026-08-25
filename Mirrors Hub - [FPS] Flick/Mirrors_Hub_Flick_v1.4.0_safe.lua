--==================================================
-- MIRRORS HUB - [FPS] FLICK
-- v1.4.0 SAFE UI / CONFIG REFACTOR
--==================================================

local WindUI = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")

local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")

local Env = getgenv()
if Env.MirrorsFlickRuntime and Env.MirrorsFlickRuntime.Cleanup then
    pcall(Env.MirrorsFlickRuntime.Cleanup)
end

local Runtime = {
    Alive = true,
    Connections = {},
    Cleanups = {},
    Window = nil,
    CurrentConfig = nil,
    CurrentConfigName = "default",
    Notifications = true,
    FPSCap = 0,
}
Env.MirrorsFlickRuntime = Runtime

local function AddConnection(connection)
    if connection then table.insert(Runtime.Connections, connection) end
    return connection
end

local function AddCleanup(callback)
    if type(callback) == "function" then table.insert(Runtime.Cleanups, callback) end
    return callback
end

local function Notify(title, content, icon, duration)
    if not Runtime.Notifications then return end
    pcall(function()
        WindUI:Notify({
            Title = title or "Mirrors Hub",
            Content = content or "",
            Icon = icon,
            Duration = duration or 3,
        })
    end)
end

local function CopyText(text)
    local copy = setclipboard or toclipboard
    if not copy then
        Notify("Clipboard", "Clipboard is not supported by this executor.", "x", 3)
        return false
    end
    local ok = pcall(copy, tostring(text))
    if ok then Notify("Mirrors Hub", "Copied to clipboard.", "copy", 2) end
    return ok
end

local function FormatTime(seconds)
    seconds = math.max(0, math.floor(seconds or 0))
    return string.format("%02d:%02d:%02d", math.floor(seconds / 3600), math.floor((seconds % 3600) / 60), seconds % 60)
end

local function GetPing()
    local ok, value = pcall(function()
        return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    end)
    return ok and math.floor(value) or 0
end

local Window = WindUI:CreateWindow({
    Title = "Mirrors Hub - [FPS] Flick",
    Icon = "crosshair",
    Author = "by blackzw.mp3",
    Folder = "MirrorsHub/[FPS] Flick",
    Size = UDim2.fromOffset(580, 460),
    MinSize = Vector2.new(520, 340),
    MaxSize = Vector2.new(900, 620),
    ToggleKey = Enum.KeyCode.K,
    Transparent = true,
    Theme = "Violet",
    Resizable = true,
    SideBarWidth = 200,
    BackgroundImageTransparency = 0.42,
    HideSearchBar = true,
    ScrollBarEnabled = false,
    AutoScale = true,
    User = { Enabled = true, Anonymous = false },
})
Runtime.Window = Window

Window:Tag({
    Title = "v1.4.0",
    Color = Color3.fromHex("A855F7"),
    Radius = 13,
})

Window:EditOpenButton({
    Title = "Open Mirrors Hub - [FPS] Flick",
    Icon = "crosshair",
    CornerRadius = UDim.new(0, 16),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromHex("8B00FF"), Color3.fromHex("430078")),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

local Info = Window:Tab({ Title = "Info", Icon = "info" })
local Main = Window:Tab({ Title = "Main", Icon = "move" })
local Visuals = Window:Tab({ Title = "Visuals", Icon = "palette" })
local Misc = Window:Tab({ Title = "Misc", Icon = "layers" })
local Config = Window:Tab({ Title = "Config", Icon = "cog" })
Info:Select()

--==================================================
-- INFO / LIVE STATUS
--==================================================

Info:Paragraph({
    Title = "Mirrors Hub",
    Desc = "[FPS] Flick • v1.4.0\nUI and runtime refactor",
    Image = "crosshair",
    ImageSize = 24,
    Thumbnail = "rbxassetid://91587269886962",
    ThumbnailSize = 70,
})

local JoinTime = os.time()
local FrameCount, FPS, LastFPS = 0, 0, os.clock()

AddConnection(RunService.RenderStepped:Connect(function()
    FrameCount += 1
    local now = os.clock()
    if now - LastFPS >= 1 then
        FPS = math.floor(FrameCount / (now - LastFPS) + 0.5)
        FrameCount = 0
        LastFPS = now
    end
end))

local LiveStatus = Info:Paragraph({
    Title = "Live Status",
    Desc = "Loading...",
    Image = "activity",
})

local function GetThemeName()
    local ok, value = pcall(function()
        return WindUI:GetCurrentTheme()
    end)
    return ok and tostring(value) or "Violet"
end

local function GetUIScale()
    local ok, value = pcall(function()
        return Window:GetUIScale()
    end)
    return ok and tonumber(value) or 1
end

local function UpdateLiveStatus()
    if not Runtime.Alive then return end
    pcall(function()
        LiveStatus:SetDesc(string.format(
            "FPS        %d\nPing       %d ms\nPlayers    %d/%d\nSession    %s\nConfig     %s\nTheme      %s\nUI Scale   %.2fx",
            FPS,
            GetPing(),
            #Players:GetPlayers(),
            Players.MaxPlayers,
            FormatTime(os.time() - JoinTime),
            Runtime.CurrentConfigName or "None",
            GetThemeName(),
            GetUIScale()
        ))
    end)
end

UpdateLiveStatus()
task.spawn(function()
    while Runtime.Alive do
        task.wait(1)
        UpdateLiveStatus()
    end
end)

Info:Button({
    Title = "Copy Discord",
    Icon = "copy",
    Callback = function()
        CopyText("https://discord.gg/YZEg6FyRSF")
    end,
})

--==================================================
-- MOVEMENT
--==================================================

local Movement = {
    SpeedEnabled = false,
    Speed = 32,
    JumpEnabled = false,
    JumpPower = 75,
    InfiniteJump = false,
}
local HumanoidDefaults = setmetatable({}, { __mode = "k" })

local function GetHumanoid()
    local character = LP.Character
    return character and character:FindFirstChildOfClass("Humanoid")
end

local function SaveHumanoid(humanoid)
    if not humanoid or HumanoidDefaults[humanoid] then return end
    HumanoidDefaults[humanoid] = {
        WalkSpeed = humanoid.WalkSpeed,
        JumpPower = humanoid.JumpPower,
        JumpHeight = humanoid.JumpHeight,
        UseJumpPower = humanoid.UseJumpPower,
    }
end

local function RestoreMovement(humanoid, speed, jump)
    local defaults = humanoid and HumanoidDefaults[humanoid]
    if not defaults then return end
    pcall(function()
        if speed then humanoid.WalkSpeed = defaults.WalkSpeed end
        if jump then
            humanoid.UseJumpPower = defaults.UseJumpPower
            humanoid.JumpPower = defaults.JumpPower
            humanoid.JumpHeight = defaults.JumpHeight
        end
    end)
end

local function ApplyMovement()
    local humanoid = GetHumanoid()
    if not humanoid then return end
    SaveHumanoid(humanoid)

    if Movement.SpeedEnabled and humanoid.WalkSpeed ~= Movement.Speed then
        pcall(function() humanoid.WalkSpeed = Movement.Speed end)
    end

    if Movement.JumpEnabled then
        pcall(function()
            if humanoid.UseJumpPower then
                if humanoid.JumpPower ~= Movement.JumpPower then humanoid.JumpPower = Movement.JumpPower end
            else
                local scaledHeight = math.max(7.2, Movement.JumpPower / 7)
                if humanoid.JumpHeight ~= scaledHeight then humanoid.JumpHeight = scaledHeight end
            end
        end)
    end
end

AddConnection(RunService.Heartbeat:Connect(function()
    if Runtime.Alive and (Movement.SpeedEnabled or Movement.JumpEnabled) then
        ApplyMovement()
    end
end))

AddConnection(UserInputService.JumpRequest:Connect(function()
    if not Runtime.Alive or not Movement.InfiniteJump then return end
    local humanoid = GetHumanoid()
    if humanoid then
        pcall(function()
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end)
    end
end))

AddCleanup(function()
    Movement.SpeedEnabled = false
    Movement.JumpEnabled = false
    Movement.InfiniteJump = false
    for humanoid in pairs(HumanoidDefaults) do
        RestoreMovement(humanoid, true, true)
    end
end)

Main:Section({ Title = "Movement", TextSize = 18 })

Main:Toggle({
    Title = "Speed Boost",
    Desc = "Use a custom WalkSpeed.",
    Value = false,
    Flag = "movement_speed_enabled",
    Callback = function(value)
        Movement.SpeedEnabled = value
        local humanoid = GetHumanoid()
        if humanoid then
            SaveHumanoid(humanoid)
            if value then ApplyMovement() else RestoreMovement(humanoid, true, false) end
        end
    end,
})

Main:Slider({
    Title = "Speed",
    Step = 1,
    Value = { Min = 16, Max = 100, Default = 32 },
    Flag = "movement_speed_value",
    Callback = function(value)
        Movement.Speed = tonumber(value) or 32
        if Movement.SpeedEnabled then ApplyMovement() end
    end,
})

Main:Space()

Main:Toggle({
    Title = "Jump Boost",
    Desc = "Use a custom jump strength.",
    Value = false,
    Flag = "movement_jump_enabled",
    Callback = function(value)
        Movement.JumpEnabled = value
        local humanoid = GetHumanoid()
        if humanoid then
            SaveHumanoid(humanoid)
            if value then ApplyMovement() else RestoreMovement(humanoid, false, true) end
        end
    end,
})

Main:Slider({
    Title = "Jump Strength",
    Step = 1,
    Value = { Min = 50, Max = 150, Default = 75 },
    Flag = "movement_jump_value",
    Callback = function(value)
        Movement.JumpPower = tonumber(value) or 75
        if Movement.JumpEnabled then ApplyMovement() end
    end,
})

Main:Space()

Main:Toggle({
    Title = "Infinite Jump",
    Desc = "Allow another jump while airborne.",
    Value = false,
    Flag = "movement_infinite_jump",
    Callback = function(value)
        Movement.InfiniteJump = value
    end,
})

--==================================================
-- VISUALS / PERFORMANCE MODE
--==================================================

local Performance = {
    Enabled = false,
    Saved = setmetatable({}, { __mode = "k" }),
    Removed = setmetatable({}, { __mode = "k" }),
    Connection = nil,
    Token = 0,
    Queue = {},
    QueueRunning = false,
}

local function IsCharacterObject(object)
    local node = object
    while node and node ~= Workspace do
        if node:IsA("Model") and Players:GetPlayerFromCharacter(node) then return true end
        node = node.Parent
    end
    return false
end

local function PerformanceProtected(object)
    if IsCharacterObject(object) then return true end

    local node = object
    local camera = Workspace.CurrentCamera
    while node and node ~= Workspace do
        if node:IsA("Tool") then return true end
        if node.Name == "_MirrorsVisual" then return true end
        if camera and node:IsDescendantOf(camera) then return true end
        node = node.Parent
    end
    return false
end

local function PerformanceSet(object, property, value)
    Performance.Saved[object] = Performance.Saved[object] or {}
    local saved = Performance.Saved[object]
    if saved[property] == nil then
        pcall(function() saved[property] = object[property] end)
    end
    pcall(function() object[property] = value end)
end

local function PerformanceFlat(object)
    if not Performance.Enabled or not object or not object.Parent or PerformanceProtected(object) then return end

    if object:IsA("BasePart") then
        PerformanceSet(object, "Material", Enum.Material.SmoothPlastic)
        PerformanceSet(object, "MaterialVariant", "")
        PerformanceSet(object, "Reflectance", 0)
        PerformanceSet(object, "CastShadow", false)
        if object:IsA("MeshPart") then PerformanceSet(object, "TextureID", "") end
    elseif object:IsA("SpecialMesh") then
        PerformanceSet(object, "TextureId", "")
    elseif object:IsA("Decal") or object:IsA("Texture") then
        PerformanceSet(object, "Transparency", 1)
    elseif object:IsA("SurfaceAppearance") then
        if not Performance.Removed[object] then
            Performance.Removed[object] = object.Parent
            object.Parent = nil
        end
    elseif object:IsA("ParticleEmitter") or object:IsA("Trail") or object:IsA("Beam")
        or object:IsA("Smoke") or object:IsA("Fire") or object:IsA("Sparkles") then
        PerformanceSet(object, "Enabled", false)
    end
end

local function ProcessPerformanceQueue()
    if Performance.QueueRunning then return end
    Performance.QueueRunning = true
    task.spawn(function()
        while Runtime.Alive and Performance.Enabled and #Performance.Queue > 0 do
            for _ = 1, math.min(150, #Performance.Queue) do
                local object = table.remove(Performance.Queue, 1)
                if object then PerformanceFlat(object) end
            end
            task.wait()
        end
        Performance.QueueRunning = false
    end)
end

local function PerformanceDisable()
    Performance.Token += 1
    Performance.Enabled = false
    table.clear(Performance.Queue)

    if Performance.Connection then
        Performance.Connection:Disconnect()
        Performance.Connection = nil
    end

    for object, parent in pairs(Performance.Removed) do
        if object and parent and parent.Parent then
            pcall(function() object.Parent = parent end)
        end
    end

    for object, properties in pairs(Performance.Saved) do
        if object and object.Parent then
            for property, value in pairs(properties) do
                pcall(function() object[property] = value end)
            end
        end
    end

    table.clear(Performance.Removed)
    table.clear(Performance.Saved)
end

local function PerformanceEnable()
    PerformanceDisable()
    Performance.Token += 1
    local token = Performance.Token
    Performance.Enabled = true

    local descendants = Workspace:GetDescendants()
    for i, object in ipairs(descendants) do
        if not Runtime.Alive or not Performance.Enabled or token ~= Performance.Token then break end
        PerformanceFlat(object)
        if i % 500 == 0 then task.wait() end
    end

    if Performance.Enabled and token == Performance.Token then
        Performance.Connection = Workspace.DescendantAdded:Connect(function(object)
            if not Performance.Enabled or token ~= Performance.Token then return end
            table.insert(Performance.Queue, object)
            ProcessPerformanceQueue()
        end)
    end
end

AddCleanup(PerformanceDisable)

Visuals:Section({ Title = "World", TextSize = 18 })
Visuals:Toggle({
    Title = "Performance Mode",
    Desc = "Flatten map textures and effects without changing Lighting or player characters.",
    Value = false,
    Flag = "visuals_performance_mode",
    Callback = function(value)
        if value then task.spawn(PerformanceEnable) else PerformanceDisable() end
    end,
})

--==================================================
-- MISC
--==================================================

local AntiAFKConnection

Misc:Section({ Title = "Server", TextSize = 18 })

Misc:Button({
    Title = "Rejoin Server",
    Icon = "refresh-cw",
    Callback = function()
        pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LP)
        end)
    end,
})

Misc:Button({
    Title = "Copy Job ID",
    Icon = "clipboard-copy",
    Callback = function() CopyText(game.JobId) end,
})

Misc:Button({
    Title = "Copy Place ID",
    Icon = "copy",
    Callback = function() CopyText(game.PlaceId) end,
})

Misc:Button({
    Title = "Copy Join URI",
    Icon = "link",
    Callback = function()
        CopyText(string.format("roblox://placeId=%s&gameInstanceId=%s", game.PlaceId, game.JobId))
    end,
})

Misc:Space()
Misc:Section({ Title = "Runtime", TextSize = 18 })

Misc:Toggle({
    Title = "Anti AFK",
    Desc = "Prevents idle disconnects when supported.",
    Value = false,
    Flag = "script_anti_afk",
    Callback = function(value)
        if AntiAFKConnection then
            AntiAFKConnection:Disconnect()
            AntiAFKConnection = nil
        end

        if value then
            AntiAFKConnection = LP.Idled:Connect(function()
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.zero)
                end)
            end)
        end
    end,
})

Misc:Dropdown({
    Title = "FPS Cap",
    Desc = "Executor FPS cap. Unlimited uses 0 when supported.",
    Values = { "30", "60", "90", "120", "144", "240", "Unlimited" },
    Value = "60",
    Flag = "script_fps_cap",
    Callback = function(value)
        if type(value) == "table" then value = value.Value or value.Title or value[1] end
        local cap = value == "Unlimited" and 0 or tonumber(value)
        Runtime.FPSCap = cap or 60
        if setfpscap then pcall(setfpscap, Runtime.FPSCap) end
    end,
})

Misc:Toggle({
    Title = "Notifications",
    Desc = "Show Mirrors Hub notifications.",
    Value = true,
    Flag = "script_notifications",
    Callback = function(value)
        Runtime.Notifications = value
    end,
})

Misc:Button({
    Title = "Unload Script",
    Icon = "power",
    Color = Color3.fromHex("EF4444"),
    Callback = function()
        Runtime.Cleanup()
    end,
})

AddCleanup(function()
    if AntiAFKConnection then
        AntiAFKConnection:Disconnect()
        AntiAFKConnection = nil
    end
end)

--==================================================
-- CONFIG / GUI SETTINGS
--==================================================

Config:Section({ Title = "Interface", TextSize = 18 })

local Themes = {}
local okThemes, themeTable = pcall(function() return WindUI:GetThemes() end)
if okThemes and type(themeTable) == "table" then
    for name in pairs(themeTable) do table.insert(Themes, name) end
end
if #Themes == 0 then Themes = { "Violet", "Dark", "Light" } end
table.sort(Themes)

Config:Dropdown({
    Title = "Theme",
    Values = Themes,
    SearchBarEnabled = true,
    Value = table.find(Themes, "Violet") and "Violet" or Themes[1],
    Flag = "gui_theme",
    Callback = function(value)
        if type(value) == "table" then value = value.Value or value.Title or value[1] end
        if value then pcall(function() WindUI:SetTheme(value) end) end
    end,
})

Config:Slider({
    Title = "UI Scale",
    Step = 0.05,
    Value = { Min = 0.65, Max = 1.25, Default = 1 },
    Flag = "gui_scale",
    Callback = function(value)
        pcall(function() Window:SetUIScale(tonumber(value) or 1) end)
    end,
})

Config:Slider({
    Title = "Background Transparency",
    Step = 0.05,
    Value = { Min = 0, Max = 1, Default = 0.42 },
    Flag = "gui_transparency",
    Callback = function(value)
        value = tonumber(value) or 0.42
        pcall(function() Window:SetBackgroundTransparency(value) end)
        pcall(function() Window:SetBackgroundImageTransparency(value) end)
    end,
})

Config:Toggle({
    Title = "Resizable Window",
    Value = true,
    Flag = "gui_resizable",
    Callback = function(value)
        pcall(function() Window:IsResizable(value) end)
    end,
})

Config:Toggle({
    Title = "Panel Background",
    Desc = "Show the panel background when supported.",
    Value = true,
    Flag = "gui_panel_background",
    Callback = function(value)
        pcall(function() Window:SetPanelBackground(value) end)
    end,
})

Config:Keybind({
    Title = "UI Toggle Key",
    Desc = "Key used to open and close the hub.",
    Value = "K",
    Flag = "gui_toggle_key",
    Callback = function(value)
        local keyCode = value
        if typeof(value) ~= "EnumItem" then
            local name = tostring(value):gsub("Enum.KeyCode%.", "")
            keyCode = Enum.KeyCode[name]
        end
        if keyCode then pcall(function() Window:SetToggleKey(keyCode) end) end
    end,
})

Config:Button({
    Title = "Center Window",
    Icon = "move",
    Callback = function()
        pcall(function() Window:SetToTheCenter() end)
    end,
})

Config:Space()
Config:Section({ Title = "Configuration Manager", TextSize = 18 })

local ConfigManager = Window.ConfigManager
local ConfigAvailable = ConfigManager ~= nil
local ConfigName = "default"
local ConfigFile
local AutoSaveOnClose = true
local AutoLoadSelected = false
local ConfigInput
local ConfigDropdown
local ConfigStatus

local function NormalizeConfigName(value)
    value = tostring(value or ""):gsub("[^%w%-%_ ]", ""):gsub("^%s+", ""):gsub("%s+$", "")
    if value == "" then value = "default" end
    return value:sub(1, 40)
end

local function GetConfigList()
    if not ConfigAvailable then return {} end
    local ok, result = pcall(function() return ConfigManager:AllConfigs() end)
    if not ok or type(result) ~= "table" then return {} end
    table.sort(result)
    return result
end

local function RefreshConfigDropdown(selectName)
    if not ConfigDropdown then return end
    local configs = GetConfigList()
    pcall(function() ConfigDropdown:Refresh(configs) end)
    if selectName and table.find(configs, selectName) then
        pcall(function() ConfigDropdown:Select(selectName) end)
    end
end

local function UpdateConfigStatus(message)
    if not ConfigStatus then return end
    local configs = GetConfigList()
    pcall(function()
        ConfigStatus:SetDesc(string.format(
            "Selected   %s\nSaved      %d\nAuto Save  %s\nAuto Load  %s%s",
            ConfigName,
            #configs,
            AutoSaveOnClose and "ON" or "OFF",
            AutoLoadSelected and "ON" or "OFF",
            message and ("\n" .. message) or ""
        ))
    end)
end

ConfigStatus = Config:Paragraph({
    Title = "Config Status",
    Desc = "Loading...",
    Image = "save",
})

if ConfigAvailable then
    pcall(function() ConfigManager:Init(Window) end)

    ConfigInput = Config:Input({
        Title = "Config Name",
        Value = ConfigName,
        Placeholder = "default",
        Callback = function(value)
            ConfigName = NormalizeConfigName(value)
            Runtime.CurrentConfigName = ConfigName
        end,
    })

    ConfigDropdown = Config:Dropdown({
        Title = "Saved Configs",
        Values = GetConfigList(),
        AllowNone = true,
        SearchBarEnabled = true,
        Callback = function(value)
            if type(value) == "table" then value = value.Value or value.Title or value[1] end
            if value then
                ConfigName = NormalizeConfigName(value)
                Runtime.CurrentConfigName = ConfigName
                if ConfigInput then pcall(function() ConfigInput:Set(ConfigName) end) end
                UpdateConfigStatus()
            end
        end,
    })

    Config:Toggle({
        Title = "Auto Save on UI Close",
        Value = true,
        Callback = function(value)
            AutoSaveOnClose = value
            UpdateConfigStatus()
        end,
    })

    Config:Toggle({
        Title = "Auto Load Selected",
        Desc = "Marks the selected config for automatic loading on next execution.",
        Value = false,
        Callback = function(value)
            AutoLoadSelected = value
            UpdateConfigStatus()
        end,
    })

    Config:Button({
        Title = "Save Config",
        Icon = "save",
        Color = Color3.fromHex("315DFF"),
        Callback = function()
            ConfigName = NormalizeConfigName(ConfigName)
            ConfigFile = ConfigManager:CreateConfig(ConfigName)
            if not ConfigFile then
                UpdateConfigStatus("Save failed")
                Notify("Config", "Could not create config.", "x", 3)
                return
            end

            pcall(function() ConfigFile:SetAutoLoad(AutoLoadSelected) end)
            pcall(function() ConfigFile:Set("lastSave", os.date("%Y-%m-%d %H:%M:%S")) end)
            pcall(function() ConfigFile:Set("scriptVersion", "1.4.0") end)

            local ok = pcall(function() ConfigFile:Save() end)
            if ok then
                Runtime.CurrentConfig = ConfigFile
                Runtime.CurrentConfigName = ConfigName
                RefreshConfigDropdown(ConfigName)
                UpdateConfigStatus("Saved now")
                Notify("Config", "Saved: " .. ConfigName, "check", 3)
            else
                UpdateConfigStatus("Save failed")
                Notify("Config", "Failed to save config.", "x", 3)
            end
        end,
    })

    Config:Button({
        Title = "Load Config",
        Icon = "folder-open",
        Callback = function()
            ConfigName = NormalizeConfigName(ConfigName)
            ConfigFile = ConfigManager:CreateConfig(ConfigName)
            local ok, data = pcall(function() return ConfigFile:Load() end)
            if ok and data ~= false then
                Runtime.CurrentConfig = ConfigFile
                Runtime.CurrentConfigName = ConfigName
                local cfg = pcall(function() return ConfigFile:GetData() end)
                AutoLoadSelected = ConfigFile.AutoLoad == true
                UpdateConfigStatus("Loaded now")
                Notify("Config", "Loaded: " .. ConfigName, "refresh-cw", 3)
            else
                UpdateConfigStatus("Load failed")
                Notify("Config", "Config not found or invalid.", "x", 3)
            end
        end,
    })

    Config:Button({
        Title = "Delete Config",
        Icon = "trash-2",
        Color = Color3.fromHex("EF4444"),
        Callback = function()
            ConfigName = NormalizeConfigName(ConfigName)
            local ok, success, message = pcall(function()
                return ConfigManager:DeleteConfig(ConfigName)
            end)
            if ok and success then
                if Runtime.CurrentConfigName == ConfigName then
                    Runtime.CurrentConfig = nil
                    Runtime.CurrentConfigName = "default"
                    ConfigName = "default"
                    if ConfigInput then pcall(function() ConfigInput:Set(ConfigName) end) end
                end
                RefreshConfigDropdown()
                UpdateConfigStatus("Deleted")
                Notify("Config", message or "Config deleted.", "trash-2", 3)
            else
                UpdateConfigStatus("Delete failed")
                Notify("Config", tostring(message or "Delete failed."), "x", 3)
            end
        end,
    })

    Config:Button({
        Title = "Refresh Config List",
        Icon = "refresh-cw",
        Callback = function()
            RefreshConfigDropdown(ConfigName)
            UpdateConfigStatus("List refreshed")
        end,
    })

    task.defer(function()
        local configs = GetConfigList()
        for _, name in ipairs(configs) do
            local cfg = ConfigManager:CreateConfig(name)
            if cfg and cfg.AutoLoad then
                ConfigName = name
                ConfigFile = cfg
                Runtime.CurrentConfig = cfg
                Runtime.CurrentConfigName = name
                AutoLoadSelected = true
                if ConfigInput then pcall(function() ConfigInput:Set(name) end) end
                if ConfigDropdown then pcall(function() ConfigDropdown:Select(name) end) end
                break
            end
        end
        RefreshConfigDropdown(ConfigName)
        UpdateConfigStatus()
    end)
else
    ConfigStatus:SetDesc("ConfigManager unavailable. This executor may not support file APIs.")
end

Window:OnClose(function()
    if not Runtime.Alive or not AutoSaveOnClose or not ConfigAvailable then return end
    if Runtime.CurrentConfig then
        pcall(function()
            Runtime.CurrentConfig:Set("lastSave", os.date("%Y-%m-%d %H:%M:%S"))
            Runtime.CurrentConfig:Save()
        end)
    end
end)

--==================================================
-- CLEANUP
--==================================================

Runtime.Cleanup = function()
    if not Runtime.Alive then return end
    Runtime.Alive = false

    for i = #Runtime.Cleanups, 1, -1 do
        pcall(Runtime.Cleanups[i])
    end

    for _, connection in ipairs(Runtime.Connections) do
        pcall(function() connection:Disconnect() end)
    end

    table.clear(Runtime.Connections)
    table.clear(Runtime.Cleanups)

    pcall(function()
        if Runtime.Window and Runtime.Window.Destroy then Runtime.Window:Destroy() end
    end)

    if Env.MirrorsFlickRuntime == Runtime then
        Env.MirrorsFlickRuntime = nil
    end
end

Window:OnDestroy(function()
    if Runtime.Alive then Runtime.Cleanup() end
end)
