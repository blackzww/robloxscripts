hub = "mm2"

--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

--// STATS: nunca bloqueia a inicialização da UI
task.spawn(function()
    pcall(function()
        local requestFunction = request or http_request or (syn and syn.request)
        if type(requestFunction) ~= "function" then
            return
        end

        local executor = "Unknown"
        if type(identifyexecutor) == "function" then
            executor = identifyexecutor()
        end

        requestFunction({
            Url = "https://mirrorskey-system.vercel.app/api/send-stats",
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode({
                hub = "mm2",
                player = LocalPlayer.Name,
                userId = LocalPlayer.UserId,
                executor = executor,
                placeId = game.PlaceId,
                jobId = game.JobId,
                version = "MM2 Beta 1.6"
            })
        })
    end)
end)

--// WINDUI: loader exato que funcionou no seu executor
local WindUI = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

--// WINDOW
local Window = WindUI:CreateWindow({
    Title = "Mirrors Hub - MM2",
    Icon = "door-open",
    Author = "by blackzw.mp3",
    Folder = "MirrorsHub/MM2",

    Size = UDim2.fromOffset(580, 460),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),

    ToggleKey = Enum.KeyCode.K,
    Transparent = true,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 200,
    BackgroundImageTransparency = 0.42,
    HideSearchBar = false,
    ScrollBarEnabled = false,

    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            print("tung tung tung god x50")
        end,
    },
})

Window:EditOpenButton({
    Title = "Open Mirrors Hub - MM2",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 16),
    StrokeThickness = 2,
    Color = ColorSequence.new(
        Color3.fromRGB(99, 11, 176),
        Color3.fromRGB(31, 12, 48)
    ),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

--// TABS: todas possuem Icon, obrigatório para esta versão do WindUI
local Info = Window:Tab({Title = "Info", Icon = "info"})
local Main = Window:Tab({Title = "Main", Icon = "house"})
local Farm = Window:Tab({Title = "Farm", Icon = "tractor"})
local Misc = Window:Tab({Title = "Misc", Icon = "layers"})
local Murder = Window:Tab({Title = "Murder", Icon = "skull"})
local Sheriff = Window:Tab({Title = "Sheriff", Icon = "siren"})
local Civil = Window:Tab({Title = "Innocent", Icon = "user"})
local Config = Window:Tab({Title = "Config", Icon = "cog"})

--// STATES
local ESP_Enabled = false
local AutoGunEnabled = false
local GunMarkerEnabled = false
local SpeedEnabled = false
local NoclipEnabled = false

local DEFAULT_SPEED = 16
local BOOST_SPEED = 20

local AutoGunToggle = nil
local GunMarker = nil
local OldLighting = nil
local NoclipConnection = nil
local NoclipOriginalCollisions = {}
local RoleWatchers = {}
local AutoToggleChanging = false

--// GENERAL UTILS
local function disconnectList(list)
    if not list then
        return
    end

    for index = #list, 1, -1 do
        local connection = list[index]
        pcall(function()
            connection:Disconnect()
        end)
        list[index] = nil
    end
end

local function getBackpack(player)
    return player:FindFirstChildOfClass("Backpack") or player:FindFirstChild("Backpack")
end

local function hasTool(player, toolName)
    local character = player.Character
    local backpack = getBackpack(player)

    return (character and character:FindFirstChild(toolName))
        or (backpack and backpack:FindFirstChild(toolName))
end

local function getRole(player)
    if hasTool(player, "Knife") then
        return "Murderer"
    end

    if hasTool(player, "Gun") then
        return "Sheriff"
    end

    return "Innocent"
end

local function getRoleColor(role)
    if role == "Murderer" then
        return Color3.fromRGB(255, 0, 0)
    end

    if role == "Sheriff" then
        return Color3.fromRGB(0, 100, 255)
    end

    return Color3.fromRGB(0, 255, 100)
end

--// ROLE ESP
local function clearRoleESP()
    for _, player in ipairs(Players:GetPlayers()) do
        local character = player.Character
        if character then
            local highlight = character:FindFirstChild("RoleHighlight")
            if highlight then
                highlight:Destroy()
            end
        end
    end
end

local function updateSingleESP(player)
    if player == LocalPlayer or not ESP_Enabled then
        return
    end

    local character = player.Character
    if not character then
        return
    end

    local highlight = character:FindFirstChild("RoleHighlight")

    if not highlight then
        highlight = Instance.new("Highlight")
        highlight.Name = "RoleHighlight"
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0.15
        highlight.Parent = character
    end

    local color = getRoleColor(getRole(player))
    highlight.Adornee = character
    highlight.FillColor = color
    highlight.OutlineColor = color
end

local function updateRoleESP()
    for _, player in ipairs(Players:GetPlayers()) do
        updateSingleESP(player)
    end
end

--// AUTO GUN: event-driven, no Heartbeat polling
local function stopAutoGun()
    AutoGunEnabled = false

    if not AutoGunToggle or AutoToggleChanging then
        return
    end

    AutoToggleChanging = true

    task.defer(function()
        pcall(function()
            AutoGunToggle:Set(false)
        end)
        AutoToggleChanging = false
    end)
end

--// REAL-TIME TOOL WATCHERS
local function roleChanged(player)
    updateSingleESP(player)

    if player == LocalPlayer and hasTool(LocalPlayer, "Gun") then
        stopAutoGun()
    end
end

local function watchToolContainer(player, container, list)
    if not container then
        return
    end

    list[#list + 1] = container.ChildAdded:Connect(function(child)
        if child:IsA("Tool") and (child.Name == "Knife" or child.Name == "Gun") then
            task.defer(roleChanged, player)
        end
    end)

    list[#list + 1] = container.ChildRemoved:Connect(function(child)
        if child:IsA("Tool") and (child.Name == "Knife" or child.Name == "Gun") then
            task.defer(roleChanged, player)
        end
    end)
end

local function setupRoleWatcher(player)
    local old = RoleWatchers[player]
    if old then
        disconnectList(old.base)
        disconnectList(old.backpack)
        disconnectList(old.character)
    end

    local record = {
        base = {},
        backpack = {},
        character = {},
    }

    RoleWatchers[player] = record

    local function bindBackpack(backpack)
        disconnectList(record.backpack)
        watchToolContainer(player, backpack, record.backpack)
        task.defer(roleChanged, player)
    end

    local function bindCharacter(character)
        disconnectList(record.character)
        watchToolContainer(player, character, record.character)
        task.defer(roleChanged, player)
    end

    record.base[#record.base + 1] = player.CharacterAdded:Connect(function(character)
        bindCharacter(character)
    end)

    record.base[#record.base + 1] = player.ChildAdded:Connect(function(child)
        if child:IsA("Backpack") then
            bindBackpack(child)
        end
    end)

    local backpack = getBackpack(player)
    if backpack then
        bindBackpack(backpack)
    end

    if player.Character then
        bindCharacter(player.Character)
    end

    task.defer(roleChanged, player)
end

for _, player in ipairs(Players:GetPlayers()) do
    setupRoleWatcher(player)
end

Players.PlayerAdded:Connect(setupRoleWatcher)

Players.PlayerRemoving:Connect(function(player)
    local record = RoleWatchers[player]
    if record then
        disconnectList(record.base)
        disconnectList(record.backpack)
        disconnectList(record.character)
        RoleWatchers[player] = nil
    end
end)

--// GUN DROP
local function getGunDrop()
    return workspace:FindFirstChild("GunDrop")
        or workspace:FindFirstChild("GunDrop", true)
end

local function getObjectCFrame(object)
    if not object then
        return nil
    end

    if object:IsA("BasePart") then
        return object.CFrame
    end

    if object:IsA("Model") then
        return object:GetPivot()
    end

    local part = object:FindFirstChildWhichIsA("BasePart", true)
    return part and part.CFrame or nil
end

local function getObjectPart(object)
    if not object then
        return nil
    end

    if object:IsA("BasePart") then
        return object
    end

    return object:FindFirstChildWhichIsA("BasePart", true)
end

local function teleportToGun()
    local character = LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")

    if not root then
        return false
    end

    if hasTool(LocalPlayer, "Gun") then
        stopAutoGun()
        return "HAS_GUN"
    end

    local gun = getGunDrop()
    if not gun then
        warn("[Mirrors Hub] GunDrop not found.")
        return false
    end

    local gunCFrame = getObjectCFrame(gun)
    if not gunCFrame then
        warn("[Mirrors Hub] GunDrop has no valid CFrame.")
        return false
    end

    -- Mesmo posicionamento do botão original
    root.CFrame = gunCFrame + Vector3.new(0, 3, 0)

    local gunPart = getObjectPart(gun)
    if gunPart and type(firetouchinterest) == "function" then
        pcall(function()
            firetouchinterest(root, gunPart, 0)
            firetouchinterest(root, gunPart, 1)
        end)
    end

    return true
end

local function clearGunMarker()
    if GunMarker then
        pcall(function()
            GunMarker:Destroy()
        end)
        GunMarker = nil
    end
end

local function markGunDrop()
    clearGunMarker()

    if not GunMarkerEnabled then
        return
    end

    local gun = getGunDrop()
    if not gun then
        return
    end

    local adornee = gun
    if not gun:IsA("BasePart") and not gun:IsA("Model") then
        adornee = getObjectPart(gun)
    end

    if not adornee then
        return
    end

    GunMarker = Instance.new("Highlight")
    GunMarker.Name = "MirrorsGunDropHighlight"
    GunMarker.Adornee = adornee
    GunMarker.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    GunMarker.FillColor = Color3.fromRGB(255, 255, 255)
    GunMarker.OutlineColor = Color3.fromRGB(255, 225, 0)
    GunMarker.FillTransparency = 0.45
    GunMarker.OutlineTransparency = 0
    GunMarker.Parent = gun
end

workspace.DescendantAdded:Connect(function(object)
    if object.Name ~= "GunDrop" then
        return
    end

    task.defer(function()
        if GunMarkerEnabled then
            markGunDrop()
        end

        if AutoGunEnabled and not hasTool(LocalPlayer, "Gun") then
            task.wait(0.05)
            teleportToGun()
        end
    end)
end)

workspace.DescendantRemoving:Connect(function(object)
    if object.Name == "GunDrop" then
        clearGunMarker()
    end
end)

local function startAutoGun()
    AutoGunEnabled = true

    if hasTool(LocalPlayer, "Gun") then
        stopAutoGun()
        return
    end

    -- If GunDrop already exists, teleport now. Future drops are handled
    -- by workspace.DescendantAdded without Heartbeat polling.
    teleportToGun()
end

--// PLAYER TELEPORT
local function getPlayerByRole(role)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and getRole(player) == role then
            return player
        end
    end

    return nil
end

local function teleportToPlayer(player)
    local myCharacter = LocalPlayer.Character
    local myRoot = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")

    local targetCharacter = player and player.Character
    local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")

    if not myRoot or not targetRoot then
        return false
    end

    myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 4)
    return true
end

--// INFO
Info:Paragraph({
    Title = "Mirrors Hub - MM2",
    Desc = "MM2 Beta 1.6\nRole ESP updates instantly when Knife or Gun changes.",
    Locked = false,
})

Info:Button({
    Title = "Print Current Roles",
    Desc = "Shows Murderer and Sheriff in console",
    Locked = false,
    Callback = function()
        local murderer = "Unknown"
        local sheriff = "Unknown"

        for _, player in ipairs(Players:GetPlayers()) do
            local role = getRole(player)
            if role == "Murderer" then
                murderer = player.Name
            elseif role == "Sheriff" then
                sheriff = player.Name
            end
        end

        print("[Mirrors Hub] Murderer:", murderer)
        print("[Mirrors Hub] Sheriff:", sheriff)
    end,
})

--// MAIN
Main:Paragraph({
    Title = "Main Functions",
    Desc = "Real-time Role ESP, GunDrop teleport and GunDrop marker.",
    Locked = false,
})

Main:Toggle({
    Title = "Role ESP",
    Desc = "Murderer red, Sheriff blue, Innocent green",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        ESP_Enabled = state
        if state then
            updateRoleESP()
        else
            clearRoleESP()
        end
    end,
})

Main:Button({
    Title = "Teleport to Gun",
    Desc = "Teleports to dropped GunDrop",
    Locked = false,
    Callback = function()
        teleportToGun()
    end,
})

AutoGunToggle = Main:Toggle({
    Title = "Auto Teleport Gun",
    Desc = "Teleports on GunDrop spawn and stops after getting Gun",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        if state then
            startAutoGun()
        else
            AutoGunEnabled = false
        end
    end,
})

Main:Toggle({
    Title = "Gun Drop Marker",
    Desc = "Highlights dropped GunDrop in white and yellow",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        GunMarkerEnabled = state
        if state then
            markGunDrop()
        else
            clearGunMarker()
        end
    end,
})

--// MURDER
Murder:Button({
    Title = "Teleport to Murderer",
    Desc = "Teleports close to Murderer",
    Locked = false,
    Callback = function()
        local murderer = getPlayerByRole("Murderer")
        if murderer then
            teleportToPlayer(murderer)
        else
            warn("[Mirrors Hub] Murderer not found.")
        end
    end,
})

Murder:Button({
    Title = "Test Kill All Nearby",
    Desc = "Fires local KillEvent feed for nearby players",
    Locked = false,
    Callback = function()
        if type(firesignal) ~= "function" then
            warn("[Mirrors Hub] firesignal is unavailable.")
            return
        end

        local character = LocalPlayer.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if not root then
            return
        end

        local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        local gameplay = remotes and remotes:FindFirstChild("Gameplay")
        local killEvent = gameplay and gameplay:FindFirstChild("KillEvent")

        if not killEvent or not killEvent:IsA("RemoteEvent") then
            warn("[Mirrors Hub] KillEvent not found.")
            return
        end

        local maxDistance = 300
        local sent = 0

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                if targetRoot then
                    local distance = (root.Position - targetRoot.Position).Magnitude
                    if distance <= maxDistance then
                        local ok = pcall(function()
                            firesignal(
                                killEvent.OnClientEvent,
                                LocalPlayer.Name,
                                Color3.fromRGB(25, 225, 25),
                                player.Name,
                                "Melee Kill!"
                            )
                        end)

                        if ok then
                            sent = sent + 1
                        end
                    end
                end
            end
        end

        print("[Mirrors Hub] Local kill signals:", sent)
    end,
})

--// SHERIFF
Sheriff:Button({
    Title = "Teleport to Sheriff",
    Desc = "Teleports close to Sheriff",
    Locked = false,
    Callback = function()
        local sheriff = getPlayerByRole("Sheriff")
        if sheriff then
            teleportToPlayer(sheriff)
        else
            warn("[Mirrors Hub] Sheriff not found.")
        end
    end,
})

--// INNOCENT
Civil:Button({
    Title = "Quick Teleport to Gun",
    Desc = "Teleports to dropped GunDrop",
    Locked = false,
    Callback = function()
        teleportToGun()
    end,
})

--// FARM
Farm:Paragraph({
    Title = "GunDrop Farm",
    Desc = "Enable Auto Teleport Gun before GunDrop appears.",
    Locked = false,
})

Farm:Button({
    Title = "Check GunDrop",
    Desc = "Prints the current GunDrop path",
    Locked = false,
    Callback = function()
        local gun = getGunDrop()
        if gun then
            print("[Mirrors Hub] GunDrop:", gun:GetFullName())
        else
            warn("[Mirrors Hub] GunDrop not found.")
        end
    end,
})

--// MISC
Misc:Toggle({
    Title = "Fullbright",
    Desc = "Improves visibility and removes fog",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        if state then
            OldLighting = {
                Brightness = Lighting.Brightness,
                ClockTime = Lighting.ClockTime,
                FogEnd = Lighting.FogEnd,
                GlobalShadows = Lighting.GlobalShadows,
                Ambient = Lighting.Ambient,
                OutdoorAmbient = Lighting.OutdoorAmbient,
            }

            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        elseif OldLighting then
            Lighting.Brightness = OldLighting.Brightness
            Lighting.ClockTime = OldLighting.ClockTime
            Lighting.FogEnd = OldLighting.FogEnd
            Lighting.GlobalShadows = OldLighting.GlobalShadows
            Lighting.Ambient = OldLighting.Ambient
            Lighting.OutdoorAmbient = OldLighting.OutdoorAmbient
        end
    end,
})

Misc:Toggle({
    Title = "Speed Boost",
    Desc = "WalkSpeed: 20",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        SpeedEnabled = state
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = state and BOOST_SPEED or DEFAULT_SPEED
        end
    end,
})

Misc:Toggle({
    Title = "Noclip",
    Desc = "Disables collisions while enabled",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        NoclipEnabled = state

        if NoclipConnection then
            NoclipConnection:Disconnect()
            NoclipConnection = nil
        end

        if not state then
            for part, originalValue in pairs(NoclipOriginalCollisions) do
                if part and part.Parent then
                    part.CanCollide = originalValue
                end
            end
            NoclipOriginalCollisions = {}
            return
        end

        NoclipConnection = RunService.Stepped:Connect(function()
            if not NoclipEnabled then
                return
            end

            local character = LocalPlayer.Character
            if not character then
                return
            end

            for _, object in ipairs(character:GetDescendants()) do
                if object:IsA("BasePart") then
                    if NoclipOriginalCollisions[object] == nil then
                        NoclipOriginalCollisions[object] = object.CanCollide
                    end
                    object.CanCollide = false
                end
            end
        end)
    end,
})

Misc:Button({
    Title = "Rejoin",
    Desc = "Rejoins current server",
    Locked = false,
    Callback = function()
        pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end)
    end,
})

--// CONFIG
Config:Paragraph({
    Title = "WindUI Fix",
    Desc = "Uses only valid Paragraph fields and valid tab icons.",
    Locked = false,
})

Config:Button({
    Title = "Refresh ESP",
    Desc = "Rebuilds all current role highlights",
    Locked = false,
    Callback = function()
        if ESP_Enabled then
            clearRoleESP()
            updateRoleESP()
        end
    end,
})

--// RESPAWN SUPPORT
LocalPlayer.CharacterAdded:Connect(function(character)
    task.wait(0.2)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid and SpeedEnabled then
        humanoid.WalkSpeed = BOOST_SPEED
    end
    if ESP_Enabled then
        updateRoleESP()
    end
end)

print("[Mirrors Hub] MM2 Beta 1.6 loaded.")
