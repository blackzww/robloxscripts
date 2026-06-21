-- Mirrors Hub - MM2 | Version 1.0
-- Built for the Robox 2 MM2 environment.

hub = "mm2"

--// CONFIG
local SCRIPT_VERSION = "1.0"
local WALK_SPEED_MIN = 16
local WALK_SPEED_MAX = 50
local VOID_Y = -50
local ANTI_AFK_JUMP_INTERVAL = 600 -- 10 minutes

--// STATS
-- Runs separately so an unavailable endpoint never blocks the UI.
task.spawn(function()
    pcall(function()
        local HttpService = game:GetService("HttpService")
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer

        local requestFunction = request
            or http_request
            or (syn and syn.request)

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
                hub = hub,
                player = player.Name,
                userId = player.UserId,
                executor = executor,
                placeId = game.PlaceId,
                jobId = game.JobId,
                version = SCRIPT_VERSION
            })
        })
    end)
end)

--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer

--// WINDUI
local WindUI = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

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
            print("Mirrors Hub user button clicked")
        end,
    },
})

pcall(function()
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
end)

--// TABS
-- Every tab has an Icon because WindUI v1.6.65 requires it.
local Info = Window:Tab({Title = "Info", Icon = "info"})
local Main = Window:Tab({Title = "Main", Icon = "house"})
local Farm = Window:Tab({Title = "Farm", Icon = "tractor"})
local Murder = Window:Tab({Title = "Murder", Icon = "skull"})
local Sheriff = Window:Tab({Title = "Sheriff", Icon = "siren"})
local Innocent = Window:Tab({Title = "Innocent", Icon = "user"})
local Misc = Window:Tab({Title = "Misc", Icon = "layers"})
local Config = Window:Tab({Title = "Config", Icon = "cog"})

--// STATE
local ESPEnabled = false
local AutoGunEnabled = false
local FullbrightEnabled = false
local NoFogEnabled = false
local InfiniteZoomEnabled = false
local NoclipEnabled = false
local AntiAFKEnabled = false
local AntiVoidEnabled = false
local RoleNotificationsEnabled = false
local RoundNotificationsEnabled = false

local WalkSpeedValue = WALK_SPEED_MIN
local TargetJobId = ""

local AutoGunToggle = nil
local StatusParagraph = nil
local RoleConnections = {}
local NoclipConnection = nil

local OriginalLighting = nil
local OriginalFog = nil
local OriginalZoom = nil
local OriginalNoclip = {}
local OriginalAtmospheres = {}

local LastSafeCFrame = nil
local LastSafeUpdate = 0
local LastLocalRole = nil
local LastRoundStatus = nil

--// UI HELPERS
local function notify(title, content)
    pcall(function()
        WindUI:Notify({
            Title = title,
            Content = content,
            Duration = 4,
        })
    end)
end

local function disconnectAll(connections)
    if not connections then
        return
    end

    for _, connection in ipairs(connections) do
        pcall(function()
            connection:Disconnect()
        end)
    end

    table.clear(connections)
end

local function getBackpack(player)
    return player:FindFirstChildOfClass("Backpack")
        or player:FindFirstChild("Backpack")
end

local function getCharacter(player)
    return player and player.Character or nil
end

local function getRootPart(player)
    local character = getCharacter(player)
    return character and character:FindFirstChild("HumanoidRootPart") or nil
end

local function getHumanoid(player)
    local character = getCharacter(player)
    return character and character:FindFirstChildOfClass("Humanoid") or nil
end

local function isAlive(player)
    local humanoid = getHumanoid(player)
    return humanoid ~= nil and humanoid.Health > 0
end

local function hasTool(player, toolName)
    local character = getCharacter(player)
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

local function formatTime(seconds)
    seconds = math.max(0, math.floor(seconds or 0))

    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60

    return string.format("%02d:%02d:%02d", hours, minutes, secs)
end

--// ROLE ESP
local function removeRoleESP(player)
    local character = getCharacter(player)
    if not character then
        return
    end

    local highlight = character:FindFirstChild("RoleHighlight")
    if highlight then
        highlight:Destroy()
    end
end

local function clearRoleESP()
    for _, player in ipairs(Players:GetPlayers()) do
        removeRoleESP(player)
    end
end

local function updateSingleRoleESP(player)
    if player == LocalPlayer then
        return
    end

    local character = getCharacter(player)
    if not character then
        return
    end

    if not ESPEnabled then
        removeRoleESP(player)
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

local function updateAllRoleESP()
    for _, player in ipairs(Players:GetPlayers()) do
        updateSingleRoleESP(player)
    end
end

--// GUN DROP
local CachedGunDrop = nil

local function isValidGunDrop(object)
    return object
        and object.Parent ~= nil
        and object.Name == "GunDrop"
end

local function getGunDrop()
    if isValidGunDrop(CachedGunDrop) then
        return CachedGunDrop
    end

    CachedGunDrop = workspace:FindFirstChild("GunDrop") or workspace:FindFirstChild("GunDrop", true)
    return CachedGunDrop
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

local function stopAutoGun()
    AutoGunEnabled = false

    if AutoGunToggle then
        task.defer(function()
            pcall(function()
                -- Second argument suppresses the callback in WindUI.
                AutoGunToggle:Set(false, false)
            end)
        end)
    end
end

local function teleportToGun()
    local root = getRootPart(LocalPlayer)
    if not root then
        return false
    end

    if hasTool(LocalPlayer, "Gun") then
        stopAutoGun()
        return "HAS_GUN"
    end

    local gun = getGunDrop()
    local gunCFrame = getObjectCFrame(gun)

    if not gunCFrame then
        return false
    end

    -- Same positioning requested: exact gun location with a 3-stud offset.
    root.CFrame = gunCFrame + Vector3.new(0, 3, 0)

    -- Optional immediate collection when the executor exposes firetouchinterest.
    local gunPart = getObjectPart(gun)
    if gunPart and type(firetouchinterest) == "function" then
        pcall(function()
            firetouchinterest(root, gunPart, 0)
            firetouchinterest(root, gunPart, 1)
        end)
    end

    return true
end

--// ROLE AND ROUND STATUS
local function getRolePlayer(role)
    for _, player in ipairs(Players:GetPlayers()) do
        if getRole(player) == role then
            return player
        end
    end

    return nil
end

local function getRoundStatus()
    if getGunDrop() then
        return "Gun Dropped"
    end

    local murderer = getRolePlayer("Murderer")
    local sheriff = getRolePlayer("Sheriff")

    if murderer or sheriff then
        return "In Round"
    end

    return "Waiting"
end

local function teleportNearPlayer(player)
    local root = getRootPart(LocalPlayer)
    local targetRoot = getRootPart(player)

    if not root or not targetRoot then
        return false
    end

    root.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 4)
    return true
end

local function updateLocalRoleNotification()
    local currentRole = getRole(LocalPlayer)

    if LastLocalRole ~= nil
        and currentRole ~= LastLocalRole
        and RoleNotificationsEnabled then
        notify("Role Changed", "You are now " .. currentRole)
    end

    LastLocalRole = currentRole

    if currentRole == "Sheriff" and AutoGunEnabled then
        stopAutoGun()
    end
end

local function onRoleChanged(player)
    updateSingleRoleESP(player)

    if player == LocalPlayer then
        updateLocalRoleNotification()
    end
end

local function watchToolContainer(player, container, connections)
    if not container then
        return
    end

    table.insert(connections, container.ChildAdded:Connect(function(child)
        if child:IsA("Tool") and (child.Name == "Knife" or child.Name == "Gun") then
            task.defer(onRoleChanged, player)
        end
    end))

    table.insert(connections, container.ChildRemoved:Connect(function(child)
        if child:IsA("Tool") and (child.Name == "Knife" or child.Name == "Gun") then
            task.defer(onRoleChanged, player)
        end
    end))
end

local function setupRoleWatcher(player)
    local oldRecord = RoleConnections[player]
    if oldRecord then
        disconnectAll(oldRecord.Player)
        disconnectAll(oldRecord.Backpack)
        disconnectAll(oldRecord.Character)
    end

    local record = {
        Player = {},
        Backpack = {},
        Character = {},
    }

    RoleConnections[player] = record

    local function bindBackpack(backpack)
        disconnectAll(record.Backpack)
        watchToolContainer(player, backpack, record.Backpack)
        task.defer(onRoleChanged, player)
    end

    local function bindCharacter(character)
        disconnectAll(record.Character)
        watchToolContainer(player, character, record.Character)
        task.defer(onRoleChanged, player)
    end

    table.insert(record.Player, player.CharacterAdded:Connect(function(character)
        task.wait(0.15)
        bindCharacter(character)
    end))

    table.insert(record.Player, player.ChildAdded:Connect(function(child)
        if child:IsA("Backpack") then
            bindBackpack(child)
        end
    end))

    local backpack = getBackpack(player)
    if backpack then
        bindBackpack(backpack)
    end

    local character = getCharacter(player)
    if character then
        bindCharacter(character)
    end

    task.defer(onRoleChanged, player)
end

--// INFO
StatusParagraph = Info:Paragraph({
    Title = "Live Status",
    Desc = "Status: Loading...",
    Locked = false,
})

local function updateLiveStatus()
    local murderer = getRolePlayer("Murderer")
    local sheriff = getRolePlayer("Sheriff")

    local alivePlayers = 0
    for _, player in ipairs(Players:GetPlayers()) do
        if isAlive(player) then
            alivePlayers += 1
        end
    end

    local roundStatus = getRoundStatus()

    if LastRoundStatus ~= nil
        and roundStatus ~= LastRoundStatus
        and RoundNotificationsEnabled then
        notify("Round Status", roundStatus)
    end

    LastRoundStatus = roundStatus

    local murdererAlive = murderer and isAlive(murderer) and "Yes" or "No"
    local sheriffAlive = sheriff and isAlive(sheriff) and "Yes" or "No"

    local serverTime = 0
    pcall(function()
        serverTime = workspace.DistributedGameTime
    end)

    local description = table.concat({
        "Version: " .. SCRIPT_VERSION,
        "Status: Loaded",
        "",
        "Your Role: " .. getRole(LocalPlayer),
        "Murderer: " .. (murderer and murderer.Name or "Unknown"),
        "Sheriff: " .. (sheriff and sheriff.Name or "Unknown"),
        "",
        "Round Status: " .. roundStatus,
        "",
        "Players: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers,
        "Alive Players: " .. alivePlayers,
        "Murder Alive: " .. murdererAlive,
        "Sheriff Alive: " .. sheriffAlive,
        "",
        "Server Time: " .. formatTime(serverTime),
        "JobId: " .. game.JobId,
    }, "\n")

    pcall(function()
        StatusParagraph:SetDesc(description)
    end)
end

--// MAIN
Main:Toggle({
    Title = "Role ESP",
    Desc = "Murderer red, Sheriff blue, Innocent green",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        ESPEnabled = state

        if state then
            updateAllRoleESP()
        else
            clearRoleESP()
        end
    end,
})

--// MURDER
Murder:Button({
    Title = "Teleport to Sheriff",
    Desc = "Teleports near current Sheriff",
    Icon = "siren",
    Locked = false,
    Callback = function()
        local sheriff = getRolePlayer("Sheriff")

        if not sheriff or sheriff == LocalPlayer then
            notify("Sheriff", "Sheriff not found.")
            return
        end

        if not teleportNearPlayer(sheriff) then
            notify("Sheriff", "Target character unavailable.")
        end
    end,
})

--// SHERIFF
Sheriff:Button({
    Title = "Teleport to Murderer",
    Desc = "Teleports near current Murderer",
    Icon = "skull",
    Locked = false,
    Callback = function()
        local murderer = getRolePlayer("Murderer")

        if not murderer or murderer == LocalPlayer then
            notify("Murderer", "Murderer not found.")
            return
        end

        if not teleportNearPlayer(murderer) then
            notify("Murderer", "Target character unavailable.")
        end
    end,
})

--// INNOCENT
Innocent:Button({
    Title = "Teleport to Gun",
    Desc = "Teleports to dropped GunDrop",
    Icon = "crosshair",
    Locked = false,
    Callback = function()
        if not teleportToGun() then
            notify("Gun", "GunDrop not found.")
        end
    end,
})

AutoGunToggle = Innocent:Toggle({
    Title = "Auto Teleport Gun",
    Desc = "Teleports when GunDrop appears and stops after getting Gun",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        AutoGunEnabled = state

        if not state then
            return
        end

        if hasTool(LocalPlayer, "Gun") then
            stopAutoGun()
            return
        end

        teleportToGun()
    end,
})

--// MISC - VISUAL
Misc:Toggle({
    Title = "Fullbright",
    Desc = "Improves lighting visibility",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        FullbrightEnabled = state

        if state then
            if not OriginalLighting then
                OriginalLighting = {
                    Brightness = Lighting.Brightness,
                    ClockTime = Lighting.ClockTime,
                    GlobalShadows = Lighting.GlobalShadows,
                    Ambient = Lighting.Ambient,
                    OutdoorAmbient = Lighting.OutdoorAmbient,
                }
            end

            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = false
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        elseif OriginalLighting then
            Lighting.Brightness = OriginalLighting.Brightness
            Lighting.ClockTime = OriginalLighting.ClockTime
            Lighting.GlobalShadows = OriginalLighting.GlobalShadows
            Lighting.Ambient = OriginalLighting.Ambient
            Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient
        end
    end,
})

Misc:Toggle({
    Title = "No Fog",
    Desc = "Removes Lighting and Atmosphere fog",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        NoFogEnabled = state

        if state then
            if not OriginalFog then
                OriginalFog = {
                    FogStart = Lighting.FogStart,
                    FogEnd = Lighting.FogEnd,
                }
            end

            Lighting.FogStart = 0
            Lighting.FogEnd = 1000000

            table.clear(OriginalAtmospheres)
            for _, object in ipairs(Lighting:GetDescendants()) do
                if object:IsA("Atmosphere") then
                    OriginalAtmospheres[object] = object.Density
                    object.Density = 0
                end
            end
        else
            if OriginalFog then
                Lighting.FogStart = OriginalFog.FogStart
                Lighting.FogEnd = OriginalFog.FogEnd
            end

            for atmosphere, density in pairs(OriginalAtmospheres) do
                if atmosphere and atmosphere.Parent then
                    atmosphere.Density = density
                end
            end

            table.clear(OriginalAtmospheres)
        end
    end,
})

Misc:Toggle({
    Title = "Infinite Zoom",
    Desc = "Removes the maximum camera zoom limit",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        InfiniteZoomEnabled = state

        if not OriginalZoom then
            OriginalZoom = {
                Min = LocalPlayer.CameraMinZoomDistance,
                Max = LocalPlayer.CameraMaxZoomDistance,
            }
        end

        if state then
            LocalPlayer.CameraMaxZoomDistance = 1000000
        else
            LocalPlayer.CameraMinZoomDistance = OriginalZoom.Min
            LocalPlayer.CameraMaxZoomDistance = OriginalZoom.Max
        end
    end,
})

--// MISC - CHARACTER
Misc:Slider({
    Title = "WalkSpeed",
    Desc = "Choose a WalkSpeed from 16 to 50",
    Value = {
        Min = WALK_SPEED_MIN,
        Max = WALK_SPEED_MAX,
        Default = WALK_SPEED_MIN,
    },
    Step = 1,
    Callback = function(value)
        WalkSpeedValue = value

        local humanoid = getHumanoid(LocalPlayer)
        if humanoid then
            humanoid.WalkSpeed = WalkSpeedValue
        end
    end,
})

local function restoreNoclip()
    for part, originalCanCollide in pairs(OriginalNoclip) do
        if part and part.Parent then
            part.CanCollide = originalCanCollide
        end
    end

    table.clear(OriginalNoclip)
end

Misc:Toggle({
    Title = "Noclip",
    Desc = "Pass through parts until disabled",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        NoclipEnabled = state

        if NoclipConnection then
            NoclipConnection:Disconnect()
            NoclipConnection = nil
        end

        if not state then
            restoreNoclip()
            return
        end

        NoclipConnection = RunService.Stepped:Connect(function()
            if not NoclipEnabled then
                return
            end

            local character = getCharacter(LocalPlayer)
            if not character then
                return
            end

            for _, object in ipairs(character:GetDescendants()) do
                if object:IsA("BasePart") then
                    if OriginalNoclip[object] == nil then
                        OriginalNoclip[object] = object.CanCollide
                    end

                    object.CanCollide = false
                end
            end
        end)
    end,
})

Misc:Button({
    Title = "Reset Character",
    Desc = "Resets your current character",
    Icon = "rotate-ccw",
    Locked = false,
    Callback = function()
        local humanoid = getHumanoid(LocalPlayer)
        if humanoid then
            humanoid.Health = 0
        end
    end,
})

--// MISC - PROTECTION
Misc:Toggle({
    Title = "Anti AFK",
    Desc = "Prevents AFK kick. Jumps once every 10 minutes for safety.",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        AntiAFKEnabled = state
    end,
})

Misc:Toggle({
    Title = "Anti Void",
    Desc = "Returns to the last safe position after falling",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        AntiVoidEnabled = state

        if state then
            local root = getRootPart(LocalPlayer)
            if root then
                LastSafeCFrame = root.CFrame
            end
        end
    end,
})

--// CONFIG - NOTIFICATIONS
Config:Toggle({
    Title = "Role Notifications",
    Desc = "Notifies when your role changes",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        RoleNotificationsEnabled = state
    end,
})

Config:Toggle({
    Title = "Round Notifications",
    Desc = "Notifies when round status changes",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        RoundNotificationsEnabled = state
    end,
})

--// CONFIG - SERVER
Config:Button({
    Title = "Rejoin",
    Desc = "Rejoins the current server",
    Icon = "refresh-cw",
    Locked = false,
    Callback = function()
        pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end)
    end,
})

Config:Button({
    Title = "Copy JobId",
    Desc = "Copies the current JobId",
    Icon = "copy",
    Locked = false,
    Callback = function()
        local clipboard = setclipboard or toclipboard

        if type(clipboard) ~= "function" then
            notify("Copy JobId", "Clipboard is not supported by this executor.")
            return
        end

        local success = pcall(function()
            clipboard(game.JobId)
        end)

        if success then
            notify("Copy JobId", "JobId copied to clipboard.")
        else
            notify("Copy JobId", "Unable to copy JobId.")
        end
    end,
})

Config:Input({
    Title = "JobId",
    Desc = "Paste a server JobId to join",
    Placeholder = "Enter JobId...",
    Value = "",
    ClearTextOnFocus = false,
    Callback = function(value)
        TargetJobId = tostring(value or "")
    end,
})

Config:Button({
    Title = "Join JobId",
    Desc = "Joins the JobId entered above",
    Icon = "log-in",
    Locked = false,
    Callback = function()
        local cleanJobId = TargetJobId:gsub("%s+", "")

        if cleanJobId == "" then
            notify("Join JobId", "Enter a valid JobId first.")
            return
        end

        pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, cleanJobId, LocalPlayer)
        end)
    end,
})

local function getHttpBody(url)
    local requestFunction = request
        or http_request
        or (syn and syn.request)

    if type(requestFunction) == "function" then
        local response = requestFunction({
            Url = url,
            Method = "GET",
        })

        if type(response) == "table" then
            return response.Body
        end

        if type(response) == "string" then
            return response
        end
    end

    return game:HttpGet(url)
end

local function joinPublicServer(maxPlayersAllowed)
    task.spawn(function()
        local success, result = pcall(function()
            local url = string.format(
                "https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100",
                tostring(game.PlaceId)
            )

            local body = getHttpBody(url)
            local data = HttpService:JSONDecode(body)
            local candidates = {}

            for _, server in ipairs(data.data or {}) do
                local open = server.playing < server.maxPlayers
                local differentServer = server.id ~= game.JobId
                local withinLimit = not maxPlayersAllowed or server.playing < maxPlayersAllowed

                if open and differentServer and withinLimit then
                    table.insert(candidates, server)
                end
            end

            if #candidates == 0 then
                return nil
            end

            return candidates[math.random(1, #candidates)]
        end)

        if not success or not result then
            notify("Server", "No matching public server found.")
            return
        end

        notify("Server", "Joining a new server...")

        pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, result.id, LocalPlayer)
        end)
    end)
end

Config:Button({
    Title = "Server Hop",
    Desc = "Joins a random public server",
    Icon = "shuffle",
    Locked = false,
    Callback = function()
        joinPublicServer(nil)
    end,
})

Config:Button({
    Title = "Small Server",
    Desc = "Joins a server with less than 5 players",
    Icon = "users",
    Locked = false,
    Callback = function()
        joinPublicServer(5)
    end,
})

--// EVENTS
for _, player in ipairs(Players:GetPlayers()) do
    setupRoleWatcher(player)
end

Players.PlayerAdded:Connect(function(player)
    setupRoleWatcher(player)
end)

Players.PlayerRemoving:Connect(function(player)
    local record = RoleConnections[player]
    if record then
        disconnectAll(record.Player)
        disconnectAll(record.Backpack)
        disconnectAll(record.Character)
        RoleConnections[player] = nil
    end
end)

workspace.DescendantAdded:Connect(function(object)
    if object.Name ~= "GunDrop" then
        return
    end

    CachedGunDrop = object

    task.defer(function()
        task.wait(0.05)

        if AutoGunEnabled and not hasTool(LocalPlayer, "Gun") then
            teleportToGun()
        end
    end)
end)

LocalPlayer.Idled:Connect(function()
    if not AntiAFKEnabled then
        return
    end

    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end)
end)

-- Jumps once every 10 minutes while Anti AFK is active.
task.spawn(function()
    while true do
        task.wait(ANTI_AFK_JUMP_INTERVAL)

        if AntiAFKEnabled then
            local humanoid = getHumanoid(LocalPlayer)
            if humanoid and humanoid.Health > 0 then
                humanoid.Jump = true
            end
        end
    end
end)

-- Updates the stored safe position and returns the player after a void fall.
RunService.Heartbeat:Connect(function()
    if not AntiVoidEnabled then
        return
    end

    local root = getRootPart(LocalPlayer)
    if not root then
        return
    end

    local now = os.clock()

    if root.Position.Y > VOID_Y and now - LastSafeUpdate >= 0.2 then
        LastSafeUpdate = now

        local rayParams = RaycastParams.new()
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        rayParams.FilterDescendantsInstances = {getCharacter(LocalPlayer)}

        local hit = workspace:Raycast(root.Position, Vector3.new(0, -8, 0), rayParams)
        if hit then
            LastSafeCFrame = root.CFrame
        end
    end

    if root.Position.Y < VOID_Y and LastSafeCFrame then
        root.CFrame = LastSafeCFrame + Vector3.new(0, 4, 0)
        root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end
end)

LocalPlayer.CharacterAdded:Connect(function(character)
    task.wait(0.25)

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = WalkSpeedValue
    end

    if NoclipEnabled then
        restoreNoclip()
    end

    if AntiVoidEnabled then
        local root = character:FindFirstChild("HumanoidRootPart")
        if root then
            LastSafeCFrame = root.CFrame
        end
    end
end)

--// LIVE INFO
-- One light update loop drives all Info values and round notifications.
task.spawn(function()
    while true do
        updateLiveStatus()
        task.wait(0.5)
    end
end)

LastLocalRole = getRole(LocalPlayer)
updateLiveStatus()

notify("Mirrors Hub", "MM2 v1.0 loaded.")
print("[Mirrors Hub] MM2 v1.0 loaded successfully.")
