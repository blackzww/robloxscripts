-- Mirrors Hub - MM2 | Version 1.0 Clean
-- Logic is declared before tabs. UI components are declared after tabs.

hub = "mm2"

--// CONFIG
local SCRIPT_VERSION = "1.0"
local WALK_SPEED_MIN = 16
local WALK_SPEED_MAX = 50
local VOID_Y = -50
local ANTI_AFK_JUMP_INTERVAL = 600

--// STATS
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
local Remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
local Gameplay = Remotes and Remotes:FindFirstChild("Gameplay")

local RoundStart = Gameplay and Gameplay:FindFirstChild("RoundStart")
local RoundEndFade = Gameplay and Gameplay:FindFirstChild("RoundEndFade")
local CoinCollected = Gameplay and Gameplay:FindFirstChild("CoinCollected")

if RoundStart then
    RoundStart.OnClientEvent:Connect(function()
        RoundActive = true
        CollectedAmount = 0
    end)
end

if RoundEndFade then
    RoundEndFade.OnClientEvent:Connect(function()
        RoundActive = false
    end)
end

if CoinCollected then
    CoinCollected.OnClientEvent:Connect(function(coinType, amount)
        if coinType == "Candy" then
            CollectedAmount = amount or CollectedAmount

            if CollectedAmount >= BagLimit then
                AutoFarmCandy = false
                AutoFarmCoins = false
                AutoFarmRunning = false

                notify("Auto Farm", "Bag full.")
            end
        end
    end)
end

RunService.Stepped:Connect(function()
    if not AutoFarmRunning then
        return
    end

    local character = LocalPlayer.Character
    if not character then
        return
    end

    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end)

local LocalPlayer = Players.LocalPlayer

--// WINDUI
local WindUI = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

WindUI:Popup({
    Title = "Join Discord",
    Icon = "info",
    Content = "Mirrors Hub has given you the truth, do what you will. Join Us.",
    Buttons = {
        {
            Title = "Cancel",
            Variant = "Tertiary",
            Callback = function() end
        },
        {
            Title = "Copy Discord",
            Variant = "Primary",
            Callback = function()
                local copy = setclipboard or toclipboard

                if type(copy) == "function" then
                    copy("https://discord.gg/YZEg6FyRSF")

                    WindUI:Notify({
                        Title = "Discord",
                        Content = "Invite copied.",
                        Duration = 3
                    })
                else
                    WindUI:Notify({
                        Title = "Clipboard",
                        Content = "Clipboard not supported.",
                        Duration = 3
                    })
                end
            end
        }
    }
})

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

local GunTeleportMode = "Normal"
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

local CachedGunDrop = nil
local LastSafeCFrame = nil
local LastSafeUpdate = 0
local LastLocalRole = nil
local LastRoundStatus = nil

local SelectedPlayerName = nil
local PlayerDropdown = nil

local AutoFarmCoins = false
local AutoFarmCandy = false
local AutoFarmRunning = false
local FarmSpeed = 25
local FarmDistanceTeleport = 150
local FarmDelay = 0.2

local RoundActive = true
local CollectedAmount = 0
local BagLimit = 40

local TeleportTarget = "Lobby"
local SelectedPlayerName = nil
local PlayerDropdown = nil

local function getPlayerNames()
    local names = {}

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(names, player.Name)
        end
    end

    table.sort(names)
    return names
end

local function refreshPlayerDropdown()
    local names = getPlayerNames()

    if #names == 0 then
        names = {"No players found"}
        SelectedPlayerName = nil
    else
        SelectedPlayerName = names[1]
    end

    if PlayerDropdown then
        pcall(function()
            PlayerDropdown:Refresh(names)
            PlayerDropdown:Set(SelectedPlayerName)
        end)
    end

    notify("Players", "List updated.")
end

local function teleportToSelectedPlayer()
    if not SelectedPlayerName or SelectedPlayerName == "No players found" then
        notify("Teleport", "Select a player first.")
        return
    end

    local target = Players:FindFirstChild(SelectedPlayerName)

    if not target then
        notify("Teleport", "Player not found.")
        refreshPlayerDropdown()
        return
    end

    if not teleportNearPlayer(target) then
        notify("Teleport", "Target unavailable.")
    end
end

local function teleportToSelectedTarget()
    if TeleportTarget == "Murder" then
        local target = getRolePlayer("Murderer")
        if target then
            teleportNearPlayer(target)
        else
            notify("Teleport", "Murderer not found.")
        end

    elseif TeleportTarget == "Sheriff" then
        local target = getRolePlayer("Sheriff")
        if target then
            teleportNearPlayer(target)
        else
            notify("Teleport", "Sheriff not found.")
        end

    elseif TeleportTarget == "Gun" then
        teleportToGun()

    elseif TeleportTarget == "Lobby" then
        notify("Teleport", "Lobby position not configured.")

    elseif TeleportTarget == "Map" then
        notify("Teleport", "Map position not configured.")
    end
end

local function getNearestFarmItem(mode)
    local root = getRootPart(LocalPlayer)
    if not root then
        return nil, math.huge
    end

    local nearestItem = nil
    local nearestDistance = math.huge

    for _, map in ipairs(workspace:GetChildren()) do
        local coinContainer = map:FindFirstChild("CoinContainer")

        if coinContainer then
            for _, item in ipairs(coinContainer:GetChildren()) do
                if item:IsA("BasePart") and item:FindFirstChild("TouchInterest") then
                    local isCandy = item:GetAttribute("CoinID") == "Candy"

                    if mode == "Coins" or (mode == "Candy" and isCandy) then
                        local distance = (root.Position - item.Position).Magnitude

                        if distance < nearestDistance then
                            nearestItem = item
                            nearestDistance = distance
                        end
                    end
                end
            end
        end
    end

    return nearestItem, nearestDistance
end

local function moveToFarmItem(item, distance)
    local root = getRootPart(LocalPlayer)
    if not root or not item then
        return
    end

    if distance > FarmDistanceTeleport then
        root.CFrame = item.CFrame
        return
    end

    local tween = game:GetService("TweenService"):Create(
        root,
        TweenInfo.new(distance / FarmSpeed, Enum.EasingStyle.Linear),
        {
            CFrame = item.CFrame
        }
    )

    tween:Play()

    repeat
        task.wait()
    until not item.Parent
        or not item:FindFirstChild("TouchInterest")
        or not AutoFarmRunning
        or not RoundActive

    tween:Cancel()
end

local function startAutoFarmLoop()
    if AutoFarmRunning then
        return
    end

    AutoFarmRunning = true

    task.spawn(function()
        while AutoFarmRunning do
            if RoundActive and (AutoFarmCoins or AutoFarmCandy) then
                local mode = AutoFarmCandy and "Candy" or "Coins"
                local item, distance = getNearestFarmItem(mode)

                if item then
                    moveToFarmItem(item, distance)
                end
            end

            task.wait(FarmDelay)
        end
    end)
end

local function stopAutoFarmIfNeeded()
    if not AutoFarmCoins and not AutoFarmCandy then
        AutoFarmRunning = false
    end
end

local function toggleCoinFarm(state)
    AutoFarmCoins = state

    if state then
        AutoFarmCandy = false
        startAutoFarmLoop()

        notify("Auto Farm", "Coin farm enabled.")
    else
        stopAutoFarmIfNeeded()
        notify("Auto Farm", "Coin farm disabled.")
    end
end

local function toggleCandyFarm(state)
    AutoFarmCandy = state

    if state then
        AutoFarmCoins = false
        startAutoFarmLoop()

        notify("Auto Farm", "Candy farm enabled.")
    else
        stopAutoFarmIfNeeded()
        notify("Auto Farm", "Candy farm disabled.")
    end
end

local function setFarmSpeed(value)
    FarmSpeed = value
end

local function getPlayerNames()
    local names = {}

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(names, player.Name)
        end
    end

    table.sort(names)
    return names
end

local function refreshPlayerDropdown()
    local names = getPlayerNames()

    if #names == 0 then
        names = {"No players found"}
        SelectedPlayerName = nil
    else
        SelectedPlayerName = names[1]
    end

    if PlayerDropdown then
        PlayerDropdown:Refresh(names)
        PlayerDropdown:Set(SelectedPlayerName)
    end

    notify("Players", "Player list updated.")
end

local function teleportToSelectedPlayer()
    if not SelectedPlayerName or SelectedPlayerName == "No players found" then
        notify("Teleport", "Select a player first.")
        return
    end

    local target = Players:FindFirstChild(SelectedPlayerName)

    if not target then
        notify("Teleport", "Player not found.")
        refreshPlayerDropdown()
        return
    end

    if not teleportNearPlayer(target) then
        notify("Teleport", "Target character unavailable.")
    end
end

local TeleportTarget = "Lobby"

local function teleportToSelectedTarget()
    if TeleportTarget == "Lobby" then
        teleportToLobby()

    elseif TeleportTarget == "Map" then
        teleportToMap()

    elseif TeleportTarget == "Murder" then
        local murderer = getRolePlayer("Murderer")

        if murderer and murderer ~= LocalPlayer then
            teleportNearPlayer(murderer)
        else
            notify("Teleport", "Murder not found.")
        end

    elseif TeleportTarget == "Sheriff" then
        local sheriff = getRolePlayer("Sheriff")

        if sheriff and sheriff ~= LocalPlayer then
            teleportNearPlayer(sheriff)
        else
            notify("Teleport", "Sheriff not found.")
        end

    elseif TeleportTarget == "GunDrop" then
        teleportToGunButton()
    end
end

local function EquipGun()

    local Character = LocalPlayer.Character
    local Backpack = LocalPlayer:FindFirstChildOfClass("Backpack")

    if not Backpack then
        return false
    end

    local Gun = Backpack:FindFirstChild("Gun")

    if Gun then
        Gun.Parent = Character
        return true
    end

    return false

end

local function OnEquipGun()

    if EquipGun() then

        WindUI:Notify({
            Title = "Gun Equipped",
            Content = "Gun is ready!",
            Icon = "check-circle",
            Duration = 2
        })

    else

        WindUI:Notify({
            Title = "Error",
            Content = "No gun found!",
            Icon = "x-circle",
            Duration = 2
        })

    end

end

local function EquipKnife()

    local Character = LocalPlayer.Character
    local Backpack = LocalPlayer:FindFirstChildOfClass("Backpack")

    if not Backpack then
        return false
    end

    local Knife = Backpack:FindFirstChild("Knife")

    if Knife then
        Knife.Parent = Character
        return true
    end

    return false

end

local function OnEquipKnife()

    if EquipKnife() then

        WindUI:Notify({
            Title = "Knife Equipped",
            Content = "Knife is ready!",
            Icon = "check-circle",
            Duration = 2
        })

    else

        WindUI:Notify({
            Title = "Error",
            Content = "No knife found!",
            Icon = "x-circle",
            Duration = 2
        })

    end

end

--// HELPERS
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

local function setRoleESP(state)
    ESPEnabled = state

    if state then
        updateAllRoleESP()
    else
        clearRoleESP()
    end
end

--// GUN DROP
local function isValidGunDrop(object)
    return object
        and object.Parent ~= nil
        and object.Name == "GunDrop"
end

local function getGunDrop()
    if isValidGunDrop(CachedGunDrop) then
        return CachedGunDrop
    end

    CachedGunDrop = workspace:FindFirstChild("GunDrop")
        or workspace:FindFirstChild("GunDrop", true)

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

    local oldCFrame = root.CFrame
    local gun = getGunDrop()
    local gunCFrame = getObjectCFrame(gun)

    if not gunCFrame then
        return false
    end

    root.CFrame = gunCFrame + Vector3.new(0, 3, 0)

    local gunPart = getObjectPart(gun)
    if gunPart and type(firetouchinterest) == "function" then
        pcall(function()
            firetouchinterest(root, gunPart, 0)
            firetouchinterest(root, gunPart, 1)
        end)
    end

    if GunTeleportMode == "Safe" then
        task.wait(0.18)

        local updatedRoot = getRootPart(LocalPlayer)
        if updatedRoot then
            updatedRoot.CFrame = oldCFrame
        end

        if hasTool(LocalPlayer, "Gun") then
            stopAutoGun()
        end
    end

    return true
end

--// ROLES / ROUND
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

local function teleportToSheriff()
    local sheriff = getRolePlayer("Sheriff")

    if not sheriff or sheriff == LocalPlayer then
        notify("Sheriff", "Not found.")
        return
    end

    if not teleportNearPlayer(sheriff) then
        notify("Sheriff", "Target unavailable.")
    end
end

local function teleportToMurderer()
    local murderer = getRolePlayer("Murderer")

    if not murderer or murderer == LocalPlayer then
        notify("Murderer", "Not found.")
        return
    end

    if not teleportNearPlayer(murderer) then
        notify("Murderer", "Target unavailable.")
    end
end

local function teleportToGunButton()
    if not teleportToGun() then
        notify("Gun", "GunDrop not found.")
    end
end

local function updateLocalRoleNotification()
    local currentRole = getRole(LocalPlayer)

    if LastLocalRole ~= nil
        and currentRole ~= LastLocalRole
        and RoleNotificationsEnabled then
        notify("Role", currentRole)
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
local function updateLiveStatus()
    if not StatusParagraph then
        return
    end

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
        notify("Round", roundStatus)
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
        "Role: " .. getRole(LocalPlayer),
        "Murderer: " .. (murderer and murderer.Name or "Unknown"),
        "Sheriff: " .. (sheriff and sheriff.Name or "Unknown"),
        "Round: " .. roundStatus,
        "Players: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers,
        "Alive: " .. alivePlayers,
        "Murder Alive: " .. murdererAlive,
        "Sheriff Alive: " .. sheriffAlive,
        "Time: " .. formatTime(serverTime),
        "JobId: " .. game.JobId,
    }, "\n")

    pcall(function()
        StatusParagraph:SetDesc(description)
    end)
end

--// VISUAL CALLBACKS
local function setFullbright(state)
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
end

local function setNoFog(state)
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
end

local function setInfiniteZoom(state)
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
end

--// CHARACTER CALLBACKS
local function setWalkSpeed(value)
    WalkSpeedValue = value

    local humanoid = getHumanoid(LocalPlayer)
    if humanoid then
        humanoid.WalkSpeed = WalkSpeedValue
    end
end

local function restoreNoclip()
    for part, originalCanCollide in pairs(OriginalNoclip) do
        if part and part.Parent then
            part.CanCollide = originalCanCollide
        end
    end

    table.clear(OriginalNoclip)
end

local function setNoclip(state)
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
end

local function resetCharacter()
    local humanoid = getHumanoid(LocalPlayer)
    if humanoid then
        humanoid.Health = 0
    end
end

local function setAntiAFK(state)
    AntiAFKEnabled = state
end

local function setAntiVoid(state)
    AntiVoidEnabled = state

    if state then
        local root = getRootPart(LocalPlayer)
        if root then
            LastSafeCFrame = root.CFrame
        end
    end
end

--// CONFIG CALLBACKS
local function setRoleNotifications(state)
    RoleNotificationsEnabled = state
end

local function setRoundNotifications(state)
    RoundNotificationsEnabled = state
end

local function rejoinServer()
    pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end)
end

local function copyJobId()
    local clipboard = setclipboard or toclipboard

    if type(clipboard) ~= "function" then
        notify("Copy JobId", "Unsupported.")
        return
    end

    local success = pcall(function()
        clipboard(game.JobId)
    end)

    notify("Copy JobId", success and "Copied." or "Failed.")
end

local function setTargetJobId(value)
    TargetJobId = tostring(value or "")
end

local function joinJobId()
    local cleanJobId = TargetJobId:gsub("%s+", "")

    if cleanJobId == "" then
        notify("Join JobId", "Enter a JobId.")
        return
    end

    pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, cleanJobId, LocalPlayer)
    end)
end

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
            notify("Server", "Not found.")
            return
        end

        notify("Server", "Joining...")

        pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, result.id, LocalPlayer)
        end)
    end)
end

local function serverHop()
    joinPublicServer(nil)
end

local function joinSmallServer()
    joinPublicServer(5)
end

local function setGunTeleportMode(option)
    GunTeleportMode = option
end

local function setAutoGun(state)
    AutoGunEnabled = state

    if not state then
        return
    end

    if hasTool(LocalPlayer, "Gun") then
        stopAutoGun()
        return
    end

    teleportToGun()
end

--// TABS
local Info = Window:Tab({Title = "Info", Icon = "info"})
local Main = Window:Tab({Title = "Main", Icon = "house"})
local Farm = Window:Tab({Title = "Farm", Icon = "tractor"})
local Murder = Window:Tab({Title = "Murder", Icon = "skull"})
local Sheriff = Window:Tab({Title = "Sheriff", Icon = "siren"})
local Innocent = Window:Tab({Title = "Innocent", Icon = "user"})
local Misc = Window:Tab({Title = "Misc", Icon = "layers"})
local Config = Window:Tab({Title = "Config", Icon = "cog"})

--// UI: INFO
StatusParagraph = Info:Paragraph({
    Title = "Live Status",
    Desc = "Loading...",
    Locked = false,
})

Info:Paragraph({
    Title = "Info",
    Desc = "Role, round, players and JobId.",
    Locked = false,
})

--// UI: MAIN
Main:Paragraph({
    Title = "ESP",
    Desc = "Knife red. Gun blue. Others green.",
    Locked = false,
})

Main:Toggle({
    Title = "Role ESP",
    Desc = "Highlight roles.",
    Type = "Toggle",
    Value = false,
    Callback = setRoleESP,
})

--// UI: FARM
Farm:Paragraph({
    Title = "Auto Farm",
    Desc = "Collect coins or candy.",
    Locked = false,
})

Farm:Toggle({
    Title = "Coin Farm",
    Desc = "Collect coins.",
    Icon = "coins",
    Type = "Toggle",
    Value = false,
    Callback = toggleCoinFarm,
})

Farm:Toggle({
    Title = "Candy Farm (Predict?)",
    Desc = "Collect candy. Comming Soon",
    Icon = "candy",
    Type = "Toggle",
    Value = false,
    Callback = toggleCandyFarm,
    Locked = true,
})

Farm:Slider({
    Title = "Farm Speed",
    Desc = "Tween speed.",
    Step = 1,
    Value = {
        Min = 10,
        Max = 80,
        Default = 25
    },
    Callback = setFarmSpeed,
})

--// UI: MURDER
Murder:Paragraph({
    Title = "Murder",
    Desc = "Find the Sheriff.",
    Locked = false,
})

Murder:Button({
    Title = "Teleport to Sheriff",
    Desc = "Teleport near Sheriff.",
    Icon = "siren",
    Locked = false,
    Callback = teleportToSheriff,
})

Murder:Space()

Murder:Button({
    Title = "Equip Knife",
    Icon = "knife",
    Color = Color3.fromRGB(255, 60, 60),
    Justify = "Center",

    Callback = OnEquipKnife
})

Murder:Space()

--// UI: SHERIFF
Sheriff:Paragraph({
    Title = "Sheriff",
    Desc = "Find the Murderer.",
    Locked = false,
})

Sheriff:Button({
    Title = "Teleport to Murderer",
    Desc = "Teleport near Murderer.",
    Icon = "skull",
    Locked = false,
    Callback = teleportToMurderer,
})

Sheriff:Space()

Sheriff:Button({
    Title = "Equip Gun",
    Icon = "crosshair",
    Color = Color3.fromRGB(0, 120, 255),
    Justify = "Center",

    Callback = OnEquipGun
})

Sheriff:Space()


--// UI: INNOCENT
Innocent:Paragraph({
    Title = "Innocent",
    Desc = "Get the dropped gun.",
    Locked = false,
})

Innocent:Dropdown({
    Title = "Gun Mode",
    Desc = "Normal stays. Safe returns.",
    Values = {"Normal", "Safe"},
    Value = "Normal",
    Multi = false,
    AllowNone = false,
    Callback = setGunTeleportMode,
})

Innocent:Space()

Innocent:Button({
    Title = "Teleport to Gun",
    Icon = "crosshair",
    Color = Color3.fromRGB(255, 200, 0),
    Justify = "Center",

    Callback = teleportToGunButton,
})

Innocent:Space()

AutoGunToggle = Innocent:Toggle({
    Title = "Auto Teleport Gun",
    Desc = "Triggers on GunDrop.",
    Type = "Toggle",
    Value = false,
    Callback = setAutoGun,
})

Innocent:Button({
    Title = "Teleport to Murderer",
    Desc = "Teleport near Murderer.",
    Icon = "skull",
    Locked = false,
    Callback = teleportToMurderer,
})

Innocent:Button({
    Title = "Teleport to Sheriff",
    Desc = "Teleport near Sheriff.",
    Icon = "siren",
    Locked = false,
    Callback = teleportToSheriff,
})


--// UI: MISC
Misc:Button({
    Title = "Teleport",
    Desc = "Go to selected target.",
    Icon = "navigation",
    Color = Color3.fromRGB(120, 80, 255),
    Justify = "Center",
    Callback = function()
        teleportToSelectedTarget()
    end,
})

PlayerDropdown = Misc:Dropdown({
    Title = "Player Target",
    Desc = "Choose player.",
    Values = getPlayerNames(),
    Value = nil,
    Multi = false,
    AllowNone = true,
    Callback = function(option)
        SelectedPlayerName = option
    end,
})

Misc:Button({
    Title = "Teleport to Player",
    Icon = "user-round-check",
    Color = Color3.fromRGB(120, 80, 255),
    Justify = "Center",
    Callback = function()
        teleportToSelectedPlayer()
    end,
})

Misc:Button({
    Title = "Refresh Player List",
    Icon = "refresh-cw",
    Color = Color3.fromRGB(70, 170, 255),
    Justify = "Center",
    Callback = function()
        refreshPlayerDropdown()
    end,
})

Misc:Toggle({
    Title = "Fullbright",
    Desc = "Brighten map.",
    Type = "Toggle",
    Value = false,
    Callback = setFullbright,
})

Misc:Toggle({
    Title = "No Fog",
    Desc = "Remove fog.",
    Type = "Toggle",
    Value = false,
    Callback = setNoFog,
})

Misc:Toggle({
    Title = "Infinite Zoom",
    Desc = "Zoom farther.",
    Type = "Toggle",
    Value = false,
    Callback = setInfiniteZoom,
})

Misc:Slider({
    Title = "WalkSpeed",
    Desc = "Set speed.",
    Value = {
        Min = WALK_SPEED_MIN,
        Max = WALK_SPEED_MAX,
        Default = WALK_SPEED_MIN,
    },
    Step = 1,
    Callback = setWalkSpeed,
})

Misc:Toggle({
    Title = "Noclip",
    Desc = "Walk through parts.",
    Type = "Toggle",
    Value = false,
    Callback = setNoclip,
})

Misc:Button({
    Title = "Reset Character",
    Desc = "Respawn now.",
    Icon = "rotate-ccw",
    Locked = false,
    Callback = resetCharacter,
})

Misc:Toggle({
    Title = "Anti AFK",
    Desc = "Reduce AFK kick.",
    Type = "Toggle",
    Value = false,
    Callback = setAntiAFK,
})

Misc:Toggle({
    Title = "Anti Void",
    Desc = "Return after void fall.",
    Type = "Toggle",
    Value = false,
    Callback = setAntiVoid,
})

--// UI: CONFIG
Config:Paragraph({
    Title = "Config",
    Desc = "Alerts and server tools.",
    Locked = false,
})

Config:Toggle({
    Title = "Role Notifications",
    Desc = "Alert on role change.",
    Type = "Toggle",
    Value = false,
    Callback = setRoleNotifications,
})

Config:Toggle({
    Title = "Round Notifications",
    Desc = "Alert on round change.",
    Type = "Toggle",
    Value = false,
    Callback = setRoundNotifications,
})

Config:Button({
    Title = "Rejoin",
    Desc = "Rejoin this server.",
    Icon = "refresh-cw",
    Locked = false,
    Callback = rejoinServer,
})

Config:Button({
    Title = "Copy JobId",
    Desc = "Copy current JobId.",
    Icon = "copy",
    Locked = false,
    Callback = copyJobId,
})

Config:Input({
    Title = "JobId",
    Desc = "Paste server JobId.",
    Placeholder = "Enter JobId...",
    Value = "",
    ClearTextOnFocus = false,
    Callback = setTargetJobId,
})

Config:Button({
    Title = "Join JobId",
    Desc = "Join entered JobId.",
    Icon = "log-in",
    Locked = false,
    Callback = joinJobId,
})

Config:Button({
    Title = "Server Hop",
    Desc = "Join another server.",
    Icon = "shuffle",
    Locked = false,
    Callback = serverHop,
})

Config:Button({
    Title = "Small Server",
    Desc = "Join server under 5 players.",
    Icon = "users",
    Locked = false,
    Callback = joinSmallServer,
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
