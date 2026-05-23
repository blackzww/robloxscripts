--// ==========================================================
--// MIRRORS HUB - UNIVERSAL
--// Reformado / organizado
--// Pasta: MirrorsHub
--// Config: universal-config.json
--// ==========================================================

--// ==========================================================
--// SERVICES
--// ==========================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// ==========================================================
--// GLOBAL CONSTANTS
--// ==========================================================

local HUB_NAME = "Mirrors Hub"
local HUB_VERSION = "1.1"
local CONFIG_FOLDER = "MirrorsHub"
local CONFIG_FILE = CONFIG_FOLDER .. "/universal-config.json"

--// ==========================================================
--// CONFIG TABLES
--// ==========================================================

local AimConfig = {
    Enabled = false,
    FOV = 140,
    Smoothness = 0.09,
    Strength = 1.0,
    TargetPart = "Head",
    TargetSwitchDelay = 0.25,
    TeamCheck = false,
    VisibleCheck = false,
    FOVColor = Color3.fromRGB(134, 0, 212),
    FOVVisible = true
}

local ESPConfig = {
    Enabled = false,
    Color = Color3.fromRGB(0, 255, 255),

    ShowNames = false,
    ShowDistance = false,
    ShowHealth = false,
    ShowLines = false,

    TeamCheck = false,
    FillEnabled = false,

    FillTransparency = 0.75,
    OutlineTransparency = 0,
    TextSize = 13,
    MaxDistance = 5000
}

local MiscConfig = {
    WalkSpeed = 16,
    JumpPower = 50,
    Noclip = false,
    InfiniteJump = false,
    AntiAFK = false
}

local ConfigSettings = {
    AutoLoadConfig = false,
    AutoLoadScript = false,
    ToggleKey = "H"
}

local DefaultAimConfig = table.clone(AimConfig)
local DefaultESPConfig = table.clone(ESPConfig)
local DefaultMiscConfig = table.clone(MiscConfig)
local DefaultConfigSettings = table.clone(ConfigSettings)

--// ==========================================================
--// DRAWING SAFE SETUP
--// ==========================================================

local HasDrawing = Drawing and Drawing.new
local FOVCircle = nil

if HasDrawing then
    FOVCircle = Drawing.new("Circle")
    FOVCircle.Thickness = 1
    FOVCircle.NumSides = 64
    FOVCircle.Radius = AimConfig.FOV
    FOVCircle.Filled = false
    FOVCircle.Visible = AimConfig.FOVVisible
    FOVCircle.Color = AimConfig.FOVColor
end

--// ==========================================================
--// WINDUI LOAD
--// ==========================================================

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

WindUI:AddTheme({
    Name = "Mirrors Purple",

    Accent = Color3.fromHex("#1C002E"),
    Background = Color3.fromHex("#101010"),
    Outline = Color3.fromHex("#8600D4"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#8a8a8a"),
    Button = Color3.fromHex("#2A0145"),
    Icon = Color3.fromHex("#C084FC"),
})

local function Notify(title, content, icon, duration)
    pcall(function()
        WindUI:Notify({
            Title = title or HUB_NAME,
            Content = content or "",
            Duration = duration or 3,
            Icon = icon or "bell",
        })
    end)
end

--// ==========================================================
--// WINDOW
--// ==========================================================

local Window = WindUI:CreateWindow({
    Title = "Mirrors Hub - Universal",
    Icon = "door-open",
    Author = "by blackzw.mp3",
    Folder = CONFIG_FOLDER,

    Size = UDim2.fromOffset(580, 460),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),

    ToggleKey = Enum.KeyCode[ConfigSettings.ToggleKey] or Enum.KeyCode.H,
    Transparent = true,
    Theme = "Mirrors Purple",
    Resizable = false,
    SideBarWidth = 200,
    BackgroundImageTransparency = 0.42,
    HideSearchBar = false,
    ScrollBarEnabled = true,

    User = {
        Enabled = true,
        Anonymous = false,
    },
})

Window:EditOpenButton({
    Title = "Open Mirrors Hub",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 16),
    StrokeThickness = 2,
    Color = ColorSequence.new(
        Color3.fromHex("8600D4"),
        Color3.fromHex("1C002E")
    ),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

--// ==========================================================
--// TABS
--// ==========================================================

local Scripts = Window:Tab({ Title = "Scripts", Icon = "house" })
local Aimbot = Window:Tab({ Title = "Aimbot", Icon = "crosshair" })
local Esp = Window:Tab({ Title = "ESP", Icon = "eye" })
local Troll = Window:Tab({ Title = "Troll", Icon = "laugh" })
local Misc = Window:Tab({ Title = "Misc", Icon = "circle-ellipsis" })
local Config = Window:Tab({ Title = "Config", Icon = "cog" })

--// ==========================================================
--// AIMBOT VARIABLES
--// ==========================================================

local CurrentTarget = nil
local LastSwitch = 0

--// ==========================================================
--// AIMBOT FUNCTIONS
--// ==========================================================

local function GetScreenCenter()
    return Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end

local function IsPlayerVisible(targetPart)
    if not AimConfig.VisibleCheck then return true end
    if not targetPart then return false end

    local character = targetPart.Parent
    if not character then return false end

    local origin = Camera.CFrame.Position
    local direction = targetPart.Position - origin

    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = { LocalPlayer.Character, Camera }
    raycastParams.IgnoreWater = true

    local result = workspace:Raycast(origin, direction, raycastParams)

    if result and result.Instance and result.Instance:IsDescendantOf(character) then
        return true
    end

    return false
end

local function IsValidTarget(part)
    if not part or not part.Parent then return false end

    local character = part.Parent
    local player = Players:GetPlayerFromCharacter(character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if not humanoid or humanoid.Health <= 0 then return false end

    if AimConfig.TeamCheck and player and player.Team == LocalPlayer.Team then
        return false
    end

    if not IsPlayerVisible(part) then return false end

    local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
    if not onScreen then return false end

    local distanceFromCenter = (Vector2.new(screenPos.X, screenPos.Y) - GetScreenCenter()).Magnitude

    return distanceFromCenter <= AimConfig.FOV
end

local function GetClosestTarget()
    local closestTarget = nil
    local shortestDistance = AimConfig.FOV

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            local targetPart = character and character:FindFirstChild(AimConfig.TargetPart)

            if humanoid and humanoid.Health > 0 and targetPart then
                if AimConfig.TeamCheck and player.Team == LocalPlayer.Team then
                    continue
                end

                if not IsPlayerVisible(targetPart) then
                    continue
                end

                local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)

                if onScreen then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - GetScreenCenter()).Magnitude

                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestTarget = targetPart
                    end
                end
            end
        end
    end

    return closestTarget
end

local function UpdateAimbot()
    if not AimConfig.Enabled then
        CurrentTarget = nil
        return
    end

    if not IsValidTarget(CurrentTarget) then
        if tick() - LastSwitch >= AimConfig.TargetSwitchDelay then
            CurrentTarget = GetClosestTarget()
            LastSwitch = tick()
        end
    end

    if CurrentTarget and IsValidTarget(CurrentTarget) then
        local cameraPos = Camera.CFrame.Position
        local targetPos = CurrentTarget.Position

        local targetCFrame = CFrame.new(cameraPos, targetPos)
        local smoothCFrame = Camera.CFrame:Lerp(targetCFrame, AimConfig.Smoothness)

        Camera.CFrame = Camera.CFrame:Lerp(smoothCFrame, AimConfig.Strength)
    end
end

--// ==========================================================
--// ESP SYSTEM
--// ==========================================================

local ESPObjects = {}

local function RemoveESP(player)
    local data = ESPObjects[player]
    if not data then return end

    for _, obj in pairs(data) do
        if typeof(obj) == "Instance" then
            obj:Destroy()
        elseif obj and obj.Remove then
            pcall(function()
                obj:Remove()
            end)
        end
    end

    ESPObjects[player] = nil
end

local function IsESPValid(player)
    if player == LocalPlayer then return false end
    if not player.Character then return false end

    local char = player.Character
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")

    if not hum or hum.Health <= 0 then return false end
    if not root then return false end

    if ESPConfig.TeamCheck and player.Team == LocalPlayer.Team then
        return false
    end

    local distance = (Camera.CFrame.Position - root.Position).Magnitude
    if distance > ESPConfig.MaxDistance then
        return false
    end

    return true
end

local function CreateESP(player)
    RemoveESP(player)

    if not ESPConfig.Enabled then return end
    if not IsESPValid(player) then return end

    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not char or not root then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "MirrorsESP_Highlight"
    highlight.Adornee = char
    highlight.FillColor = ESPConfig.Color
    highlight.OutlineColor = ESPConfig.Color
    highlight.FillTransparency = ESPConfig.FillEnabled and ESPConfig.FillTransparency or 1
    highlight.OutlineTransparency = ESPConfig.OutlineTransparency
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = char

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "MirrorsESP_Info"
    billboard.Adornee = root
    billboard.Size = UDim2.new(0, 220, 0, 80)
    billboard.StudsOffset = Vector3.new(0, 3.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Enabled = true
    billboard.Parent = root

    local text = Instance.new("TextLabel")
    text.Name = "InfoText"
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.TextColor3 = ESPConfig.Color
    text.TextStrokeTransparency = 0
    text.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    text.TextSize = ESPConfig.TextSize
    text.Font = Enum.Font.GothamBold
    text.TextWrapped = false
    text.TextYAlignment = Enum.TextYAlignment.Center
    text.Text = ""
    text.Parent = billboard

    local line = nil

    if HasDrawing then
        line = Drawing.new("Line")
        line.Visible = false
        line.Color = ESPConfig.Color
        line.Thickness = 1.5
        line.Transparency = 1
    end

    ESPObjects[player] = {
        Highlight = highlight,
        Billboard = billboard,
        Text = text,
        Line = line
    }
end

local function RefreshESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            CreateESP(player)
        end
    end
end

local function ClearESP()
    for player in pairs(ESPObjects) do
        RemoveESP(player)
    end
end

local function UpdateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if ESPConfig.Enabled and IsESPValid(player) then
                if not ESPObjects[player] then
                    CreateESP(player)
                end

                local data = ESPObjects[player]
                local char = player.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local root = char and char:FindFirstChild("HumanoidRootPart")

                if data and hum and root then
                    data.Highlight.Adornee = char
                    data.Highlight.FillColor = ESPConfig.Color
                    data.Highlight.OutlineColor = ESPConfig.Color
                    data.Highlight.FillTransparency = ESPConfig.FillEnabled and ESPConfig.FillTransparency or 1
                    data.Highlight.OutlineTransparency = ESPConfig.OutlineTransparency

                    data.Text.TextColor3 = ESPConfig.Color
                    data.Text.TextSize = ESPConfig.TextSize

                    local distance = math.floor((Camera.CFrame.Position - root.Position).Magnitude)
                    local infoLines = {}

                    if ESPConfig.ShowNames then
                        table.insert(infoLines, player.Name)
                    end

                    if ESPConfig.ShowHealth then
                        table.insert(infoLines, "HP: " .. math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth))
                    end

                    if ESPConfig.ShowDistance then
                        table.insert(infoLines, distance .. " studs")
                    end

                    data.Text.Text = table.concat(infoLines, "\n")
                    data.Billboard.Enabled = (#infoLines > 0)

                    if data.Line then
                        local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)

                        if ESPConfig.ShowLines and onScreen then
                            data.Line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                            data.Line.To = Vector2.new(screenPos.X, screenPos.Y)
                            data.Line.Color = ESPConfig.Color
                            data.Line.Visible = true
                        else
                            data.Line.Visible = false
                        end
                    end
                end
            else
                RemoveESP(player)
            end
        end
    end
end

--// ==========================================================
--// MISC SYSTEM
--// ==========================================================

local function GetChar()
    return LocalPlayer.Character
end

local function GetHumanoid()
    local char = GetChar()
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function ApplyMovement()
    local hum = GetHumanoid()
    if hum then
        hum.WalkSpeed = MiscConfig.WalkSpeed
        hum.JumpPower = MiscConfig.JumpPower
        hum.UseJumpPower = true
    end
end

local function ApplyNoclip()
    if not MiscConfig.Noclip then return end

    local char = GetChar()
    if not char then return end

    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

local function ServerHop()
    Notify(HUB_NAME, "Tentando trocar de servidor...", "server", 3)
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end

local function SmallServer()
    Notify(HUB_NAME, "Procurando servidor menor...", "search", 3)

    local success, servers = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(
            "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        ))
    end)

    if not success or not servers or not servers.data then
        Notify(HUB_NAME, "Não consegui buscar servidores.", "triangle-alert", 3)
        return
    end

    local bestServer = nil

    for _, server in ipairs(servers.data) do
        if server.id ~= game.JobId and server.playing < server.maxPlayers then
            if not bestServer or server.playing < bestServer.playing then
                bestServer = server
            end
        end
    end

    if bestServer then
        TeleportService:TeleportToPlaceInstance(game.PlaceId, bestServer.id, LocalPlayer)
    else
        Notify(HUB_NAME, "Nenhum servidor menor encontrado.", "x", 3)
    end
end

--// ==========================================================
--// CONFIG SYSTEM
--// ==========================================================

local function EnsureConfigFolder()
    if makefolder and not isfolder(CONFIG_FOLDER) then
        makefolder(CONFIG_FOLDER)
    end
end

local function EncodeColor(color)
    return {
        R = math.floor(color.R * 255),
        G = math.floor(color.G * 255),
        B = math.floor(color.B * 255)
    }
end

local function DecodeColor(data)
    if typeof(data) == "table" and data.R and data.G and data.B then
        return Color3.fromRGB(data.R, data.G, data.B)
    end

    return nil
end

local function CleanTable(tbl)
    local result = {}

    for k, v in pairs(tbl) do
        if typeof(v) == "Color3" then
            result[k] = EncodeColor(v)
        elseif typeof(v) == "EnumItem" then
            result[k] = v.Name
        elseif typeof(v) == "table" then
            result[k] = CleanTable(v)
        elseif typeof(v) ~= "function" then
            result[k] = v
        end
    end

    return result
end

local function ApplyTable(target, data)
    if not data then return end

    for k, v in pairs(data) do
        if target[k] ~= nil then
            if typeof(target[k]) == "Color3" then
                local decoded = DecodeColor(v)
                if decoded then
                    target[k] = decoded
                end
            else
                target[k] = v
            end
        end
    end
end

local function ApplyLoadedConfig()
    if FOVCircle then
        FOVCircle.Radius = AimConfig.FOV
        FOVCircle.Color = AimConfig.FOVColor
        FOVCircle.Visible = AimConfig.FOVVisible
    end

    if ConfigSettings.ToggleKey and Enum.KeyCode[ConfigSettings.ToggleKey] then
        pcall(function()
            Window:SetToggleKey(Enum.KeyCode[ConfigSettings.ToggleKey])
        end)
    end

    ApplyMovement()

    if ESPConfig.Enabled then
        RefreshESP()
    else
        ClearESP()
    end
end

local function SaveConfig()
    EnsureConfigFolder()

    local data = {
        Hub = {
            Name = HUB_NAME,
            Version = HUB_VERSION,
            SavedAt = os.date("%d/%m/%Y %H:%M:%S")
        },

        Settings = CleanTable(ConfigSettings),
        Aimbot = CleanTable(AimConfig),
        ESP = CleanTable(ESPConfig),
        Misc = CleanTable(MiscConfig)
    }

    if writefile then
        writefile(CONFIG_FILE, HttpService:JSONEncode(data))
        Notify(HUB_NAME, "Config salva em " .. CONFIG_FILE, "save", 3)
    else
        Notify(HUB_NAME, "writefile não está disponível.", "triangle-alert", 3)
    end
end

local function LoadConfig()
    if not readfile or not isfile then
        Notify(HUB_NAME, "readfile/isfile não estão disponíveis.", "triangle-alert", 3)
        return
    end

    if not isfile(CONFIG_FILE) then
        Notify(HUB_NAME, "Arquivo de config não encontrado.", "file-x", 3)
        return
    end

    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(CONFIG_FILE))
    end)

    if not success or not data then
        Notify(HUB_NAME, "Falha ao ler config.", "triangle-alert", 3)
        return
    end

    ApplyTable(ConfigSettings, data.Settings)
    ApplyTable(AimConfig, data.Aimbot)
    ApplyTable(ESPConfig, data.ESP)
    ApplyTable(MiscConfig, data.Misc)

    ApplyLoadedConfig()

    Notify(HUB_NAME, "Config carregada com sucesso.", "check", 3)
end

local function ResetConfig()
    ApplyTable(AimConfig, DefaultAimConfig)
    ApplyTable(ESPConfig, DefaultESPConfig)
    ApplyTable(MiscConfig, DefaultMiscConfig)
    ApplyTable(ConfigSettings, DefaultConfigSettings)

    CurrentTarget = nil
    ClearESP()
    ApplyLoadedConfig()

    Notify(HUB_NAME, "Config resetada.", "rotate-ccw", 3)
end

--// ==========================================================
--// UI - SCRIPTS TAB
--// ==========================================================

Scripts:Section({
    Title = "Home",
    Box = false,
    FontWeight = "Medium",
    TextSize = 17,
})

Scripts:Paragraph({
    Title = "Mirrors Hub",
    Desc = "Universal script hub interface.\nVersão: " .. HUB_VERSION,
    Color = "Blue",
    ImageSize = 30,
    ThumbnailSize = 80,
    Locked = false,
})

Scripts:Button({
    Title = "Load Script",
    Desc = "Placeholder para scripts futuros.",
    Locked = false,
    Callback = function()
        Notify(HUB_NAME, "Nenhum script configurado ainda.", "info", 3)
    end
})

--// ==========================================================
--// UI - AIMBOT TAB
--// ==========================================================

Aimbot:Section({
    Title = "Main",
    Box = false,
    FontWeight = "Medium",
    TextSize = 17,
})

Aimbot:Toggle({
    Title = "Enable Aimbot",
    Desc = "Liga/desliga o aim assist.",
    Type = "Checkbox",
    Value = AimConfig.Enabled,
    Callback = function(state)
        AimConfig.Enabled = state

        if not state then
            CurrentTarget = nil
        end

        Notify(HUB_NAME, "Aimbot: " .. tostring(state), "crosshair", 2)
    end
})

Aimbot:Toggle({
    Title = "Team Check",
    Desc = "Ignora jogadores do mesmo time.",
    Type = "Checkbox",
    Value = AimConfig.TeamCheck,
    Callback = function(state)
        AimConfig.TeamCheck = state
        CurrentTarget = nil
    end
})

Aimbot:Toggle({
    Title = "Visible Check",
    Desc = "Só mira em jogador visível.",
    Type = "Checkbox",
    Value = AimConfig.VisibleCheck,
    Callback = function(state)
        AimConfig.VisibleCheck = state
        CurrentTarget = nil
    end
})

Aimbot:Dropdown({
    Title = "Target Part",
    Desc = "Parte do corpo para mirar.",
    Values = { "Head", "HumanoidRootPart" },
    Value = AimConfig.TargetPart,
    Callback = function(selected)
        AimConfig.TargetPart = selected
        CurrentTarget = nil
    end
})

Aimbot:Section({
    Title = "FOV",
    Box = false,
    FontWeight = "SemiBold",
    TextSize = 17,
})

Aimbot:Slider({
    Title = "Aimbot FOV",
    Desc = "Tamanho do campo de mira.",
    Step = 1,
    Value = {
        Min = 10,
        Max = 500,
        Default = AimConfig.FOV,
    },
    Callback = function(value)
        AimConfig.FOV = value

        if FOVCircle then
            FOVCircle.Radius = value
        end
    end
})

Aimbot:Toggle({
    Title = "Show FOV Circle",
    Desc = "Mostra o círculo do FOV.",
    Type = "Checkbox",
    Value = AimConfig.FOVVisible,
    Callback = function(state)
        AimConfig.FOVVisible = state

        if FOVCircle then
            FOVCircle.Visible = state
        end
    end
})

Aimbot:Colorpicker({
    Title = "FOV Color",
    Desc = "Cor do círculo do FOV.",
    Default = AimConfig.FOVColor,
    Transparency = 0,
    Locked = false,
    Callback = function(color)
        AimConfig.FOVColor = color

        if FOVCircle then
            FOVCircle.Color = color
        end
    end
})

Aimbot:Section({
    Title = "Tuning",
    Box = false,
    FontWeight = "SemiBold",
    TextSize = 17,
})

Aimbot:Slider({
    Title = "Smoothness",
    Desc = "Suavidade da mira.",
    Step = 1,
    Value = {
        Min = 1,
        Max = 100,
        Default = 35,
    },
    Callback = function(value)
        AimConfig.Smoothness = value / 388
    end
})

Aimbot:Slider({
    Title = "Aim Strength",
    Desc = "Força da puxada da câmera.",
    Step = 1,
    Value = {
        Min = 1,
        Max = 100,
        Default = 100,
    },
    Callback = function(value)
        AimConfig.Strength = value / 100
    end
})

Aimbot:Slider({
    Title = "Target Switch Delay",
    Desc = "Delay antes de trocar alvo.",
    Step = 0.05,
    Value = {
        Min = 0,
        Max = 2,
        Default = AimConfig.TargetSwitchDelay,
    },
    Callback = function(value)
        AimConfig.TargetSwitchDelay = value
    end
})

--// ==========================================================
--// UI - ESP TAB
--// ==========================================================

Esp:Section({
    Title = "Main",
    Box = false,
    FontWeight = "Medium",
    TextSize = 17,
})

Esp:Toggle({
    Title = "Enable ESP",
    Desc = "Liga/desliga ESP completo.",
    Type = "Checkbox",
    Value = ESPConfig.Enabled,
    Callback = function(state)
        ESPConfig.Enabled = state

        if state then
            RefreshESP()
        else
            ClearESP()
        end

        Notify(HUB_NAME, "ESP: " .. tostring(state), "eye", 2)
    end
})

Esp:Colorpicker({
    Title = "ESP Color",
    Desc = "Cor principal do ESP.",
    Default = ESPConfig.Color,
    Transparency = 0,
    Locked = false,
    Callback = function(color)
        ESPConfig.Color = color
    end
})

Esp:Toggle({
    Title = "Team Check",
    Desc = "Ignora jogadores do mesmo time.",
    Type = "Checkbox",
    Value = ESPConfig.TeamCheck,
    Callback = function(state)
        ESPConfig.TeamCheck = state
        RefreshESP()
    end
})

Esp:Section({
    Title = "Info",
    Box = false,
    FontWeight = "SemiBold",
    TextSize = 17,
})

Esp:Toggle({
    Title = "Show Names",
    Desc = "Mostra nome dos jogadores.",
    Type = "Checkbox",
    Value = ESPConfig.ShowNames,
    Callback = function(state)
        ESPConfig.ShowNames = state
    end
})

Esp:Toggle({
    Title = "Show Health",
    Desc = "Mostra vida dos jogadores.",
    Type = "Checkbox",
    Value = ESPConfig.ShowHealth,
    Callback = function(state)
        ESPConfig.ShowHealth = state
    end
})

Esp:Toggle({
    Title = "Show Distance",
    Desc = "Mostra distância dos jogadores.",
    Type = "Checkbox",
    Value = ESPConfig.ShowDistance,
    Callback = function(state)
        ESPConfig.ShowDistance = state
    end
})

Esp:Toggle({
    Title = "Show Lines",
    Desc = "Mostra linhas do meio inferior da tela.",
    Type = "Checkbox",
    Value = ESPConfig.ShowLines,
    Callback = function(state)
        ESPConfig.ShowLines = state
    end
})

Esp:Section({
    Title = "Visual",
    Box = false,
    FontWeight = "SemiBold",
    TextSize = 17,
})

Esp:Toggle({
    Title = "Fill Box",
    Desc = "Preenche o corpo com cor transparente.",
    Type = "Checkbox",
    Value = ESPConfig.FillEnabled,
    Callback = function(state)
        ESPConfig.FillEnabled = state
    end
})

Esp:Slider({
    Title = "Fill Transparency",
    Desc = "Transparência do preenchimento.",
    Step = 1,
    Value = {
        Min = 0,
        Max = 100,
        Default = 75,
    },
    Callback = function(value)
        ESPConfig.FillTransparency = value / 100
    end
})

Esp:Slider({
    Title = "Outline Transparency",
    Desc = "Transparência da borda.",
    Step = 1,
    Value = {
        Min = 0,
        Max = 100,
        Default = 0,
    },
    Callback = function(value)
        ESPConfig.OutlineTransparency = value / 100
    end
})

Esp:Slider({
    Title = "Text Size",
    Desc = "Tamanho do texto.",
    Step = 1,
    Value = {
        Min = 8,
        Max = 30,
        Default = ESPConfig.TextSize,
    },
    Callback = function(value)
        ESPConfig.TextSize = value
    end
})

Esp:Slider({
    Title = "Max Distance",
    Desc = "Distância máxima do ESP.",
    Step = 50,
    Value = {
        Min = 100,
        Max = 10000,
        Default = ESPConfig.MaxDistance,
    },
    Callback = function(value)
        ESPConfig.MaxDistance = value
    end
})

Esp:Button({
    Title = "Refresh ESP",
    Desc = "Recria o ESP dos jogadores.",
    Locked = false,
    Callback = function()
        RefreshESP()
        Notify(HUB_NAME, "ESP atualizado.", "refresh-cw", 2)
    end
})

--// ==========================================================
--// UI - TROLL TAB
--// ==========================================================

Troll:Section({
    Title = "Coming Soon",
    Box = false,
    FontWeight = "Medium",
    TextSize = 17,
})

Troll:Button({
    Title = "Troll Action 1",
    Desc = "Placeholder.",
    Locked = false,
    Callback = function()
        Notify(HUB_NAME, "Ainda não configurado.", "info", 2)
    end
})

Troll:Button({
    Title = "Troll Action 2",
    Desc = "Placeholder.",
    Locked = false,
    Callback = function()
        Notify(HUB_NAME, "Ainda não configurado.", "info", 2)
    end
})

--// ==========================================================
--// UI - MISC TAB
--// ==========================================================

Misc:Section({
    Title = "Movement",
    Box = false,
    FontWeight = "Medium",
    TextSize = 17,
})

Misc:Slider({
    Title = "WalkSpeed",
    Desc = "Controle de velocidade.",
    Step = 1,
    Value = {
        Min = 16,
        Max = 200,
        Default = MiscConfig.WalkSpeed,
    },
    Callback = function(value)
        MiscConfig.WalkSpeed = value
        ApplyMovement()
    end
})

Misc:Slider({
    Title = "JumpPower",
    Desc = "Controle de pulo.",
    Step = 1,
    Value = {
        Min = 50,
        Max = 300,
        Default = MiscConfig.JumpPower,
    },
    Callback = function(value)
        MiscConfig.JumpPower = value
        ApplyMovement()
    end
})

Misc:Toggle({
    Title = "Noclip",
    Desc = "Atravessar colisões.",
    Type = "Checkbox",
    Value = MiscConfig.Noclip,
    Callback = function(state)
        MiscConfig.Noclip = state
    end
})

Misc:Toggle({
    Title = "Infinite Jump",
    Desc = "Pular infinitamente.",
    Type = "Checkbox",
    Value = MiscConfig.InfiniteJump,
    Callback = function(state)
        MiscConfig.InfiniteJump = state
    end
})

Misc:Section({
    Title = "Utility",
    Box = false,
    FontWeight = "SemiBold",
    TextSize = 17,
})

Misc:Toggle({
    Title = "Anti AFK",
    Desc = "Evita ficar inativo.",
    Type = "Checkbox",
    Value = MiscConfig.AntiAFK,
    Callback = function(state)
        MiscConfig.AntiAFK = state
    end
})

Misc:Button({
    Title = "Reset Character",
    Desc = "Reseta seu personagem.",
    Locked = false,
    Callback = function()
        local hum = GetHumanoid()
        if hum then
            hum.Health = 0
        end
    end
})

Misc:Button({
    Title = "Rejoin Server",
    Desc = "Reconecta no mesmo jogo.",
    Locked = false,
    Callback = function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
})

Misc:Button({
    Title = "Server Hop",
    Desc = "Vai para outro servidor.",
    Locked = false,
    Callback = function()
        ServerHop()
    end
})

Misc:Button({
    Title = "Small Server",
    Desc = "Procura servidor com menos jogadores.",
    Locked = false,
    Callback = function()
        SmallServer()
    end
})

--// ==========================================================
--// UI - CONFIG TAB
--// ==========================================================

Config:Section({
    Title = "Config File",
    Box = false,
    FontWeight = "Medium",
    TextSize = 17,
})

Config:Paragraph({
    Title = "Config Path",
    Desc = CONFIG_FILE,
    Color = "Blue",
    Locked = false,
})

Config:Button({
    Title = "Save Config",
    Desc = "Salva todas as configurações.",
    Locked = false,
    Callback = function()
        SaveConfig()
    end
})

Config:Button({
    Title = "Load Config",
    Desc = "Carrega universal-config.json.",
    Locked = false,
    Callback = function()
        LoadConfig()
    end
})

Config:Button({
    Title = "Reset Config",
    Desc = "Volta tudo para o padrão.",
    Locked = false,
    Callback = function()
        Window:Dialog({
            Icon = "triangle-alert",
            Title = "Reset Config?",
            Content = "Isso vai resetar todas as configurações do hub.",
            Buttons = {
                {
                    Title = "Confirmar",
                    Callback = function()
                        ResetConfig()
                    end,
                },
                {
                    Title = "Cancelar",
                    Callback = function() end,
                }
            }
        })
    end
})

Config:Section({
    Title = "Startup",
    Box = false,
    FontWeight = "Medium",
    TextSize = 17,
})

Config:Toggle({
    Title = "Auto Load Config",
    Desc = "Carrega a config automaticamente ao iniciar.",
    Type = "Checkbox",
    Value = ConfigSettings.AutoLoadConfig,
    Callback = function(state)
        ConfigSettings.AutoLoadConfig = state
        SaveConfig()
    end
})

Config:Toggle({
    Title = "Auto Load Script",
    Desc = "Salva preferência de auto execução.",
    Type = "Checkbox",
    Value = ConfigSettings.AutoLoadScript,
    Callback = function(state)
        ConfigSettings.AutoLoadScript = state
        SaveConfig()
    end
})

Config:Section({
    Title = "Interface",
    Box = false,
    FontWeight = "SemiBold",
    TextSize = 17,
})

Config:Keybind({
    Title = "Toggle UI Key",
    Desc = "Tecla para abrir/fechar o hub.",
    Value = ConfigSettings.ToggleKey,
    Callback = function(key)
        if key and Enum.KeyCode[key] then
            ConfigSettings.ToggleKey = key

            pcall(function()
                Window:SetToggleKey(Enum.KeyCode[key])
            end)

            SaveConfig()

            Notify(HUB_NAME, "Toggle key alterada para: " .. key, "keyboard", 3)
        end
    end
})

--// ==========================================================
--// CONNECTIONS
--// ==========================================================

UserInputService.JumpRequest:Connect(function()
    if MiscConfig.InfiniteJump then
        local hum = GetHumanoid()

        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

LocalPlayer.Idled:Connect(function()
    if MiscConfig.AntiAFK then
        VirtualUser:Button2Down(Vector2.new(0, 0), Camera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0, 0), Camera.CFrame)
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    ApplyMovement()

    if ESPConfig.Enabled then
        RefreshESP()
    end
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.7)

        if ESPConfig.Enabled then
            CreateESP(player)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
end)

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function()
            task.wait(0.7)

            if ESPConfig.Enabled then
                CreateESP(player)
            end
        end)
    end
end

--// ==========================================================
--// MAIN LOOP
--// ==========================================================

RunService.RenderStepped:Connect(function()
    Camera = workspace.CurrentCamera

    if FOVCircle then
        FOVCircle.Position = GetScreenCenter()
        FOVCircle.Radius = AimConfig.FOV
        FOVCircle.Color = AimConfig.FOVColor
        FOVCircle.Visible = AimConfig.FOVVisible
    end

    UpdateESP()
    ApplyMovement()
    ApplyNoclip()
    UpdateAimbot()
end)

--// ==========================================================
--// AUTO LOAD CONFIG
--// ==========================================================

task.defer(function()
    task.wait(0.5)

    if isfile and readfile and isfile(CONFIG_FILE) then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(CONFIG_FILE))
        end)

        if success and data and data.Settings and data.Settings.AutoLoadConfig then
            LoadConfig()
        end
    end
end)

Notify(HUB_NAME, "Carregado com sucesso.", "check", 3)