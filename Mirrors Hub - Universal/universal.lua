--// ==========================================================
--// MIRRORS HUB - UNIVERSAL CLEAN
--// Folder: MirrorsHub
--// Config: universal-config
--// ==========================================================

--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// CONSTANTS
local HUB_NAME = "Mirrors Hub"
local HUB_VERSION = "1.2"
local HUB_FOLDER = "MirrorsHub"

--// CONFIG TABLES
local AimConfig = {
    Enabled = false,
    FOV = 140,
    Smoothness = 0.09,
    Strength = 1,
    TargetPart = "Head",
    TargetSwitchDelay = 0.25,
    TeamCheck = false,
    VisibleCheck = false,
    FOVVisible = true,
    FOVColor = Color3.fromRGB(134, 0, 212)
}

local ESPConfig = {
    Enabled = false,
    Color = Color3.fromRGB(0, 255, 255),
    ShowNames = false,
    ShowHealth = false,
    ShowDistance = false,
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

--// LOAD WINDUI
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

local function Notify(content, icon, duration)
    pcall(function()
        WindUI:Notify({
            Title = HUB_NAME,
            Content = content,
            Duration = duration or 3,
            Icon = icon or "bell",
        })
    end)
end

--// WINDOW
local Window = WindUI:CreateWindow({
    Title = "Mirrors Hub - Universal",
    Icon = "door-open",
    Author = "by blackzw.mp3",
    Folder = HUB_FOLDER,

    Size = UDim2.fromOffset(580, 460),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),

    ToggleKey = Enum.KeyCode.H,
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

--// CONFIG MANAGER NATIVO
local ConfigManager = Window.ConfigManager
local UniversalConfig = ConfigManager:CreateConfig("universal-config")

--// TABS
local Scripts = Window:Tab({ Title = "Scripts", Icon = "house" })
local Aimbot = Window:Tab({ Title = "Aimbot", Icon = "crosshair" })
local Esp = Window:Tab({ Title = "ESP", Icon = "eye" })
local Troll = Window:Tab({ Title = "Troll", Icon = "laugh" })
local Misc = Window:Tab({ Title = "Misc", Icon = "circle-ellipsis" })
local Config = Window:Tab({ Title = "Config", Icon = "cog" })

--// DRAWING SETUP
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

--// BASIC HELPERS
local function GetChar()
    return LocalPlayer.Character
end

local function GetHumanoid()
    local char = GetChar()
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function GetScreenCenter()
    Camera = workspace.CurrentCamera
    return Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end

--// ==========================================================
--// AIMBOT
--// ==========================================================

local CurrentTarget = nil
local LastSwitch = 0

local function IsPlayerVisible(targetPart)
    if not AimConfig.VisibleCheck then return true end
    if not targetPart then return false end

    local character = targetPart.Parent
    if not character then return false end

    local origin = Camera.CFrame.Position
    local direction = targetPart.Position - origin

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = { LocalPlayer.Character, Camera }
    params.IgnoreWater = true

    local result = workspace:Raycast(origin, direction, params)

    return result and result.Instance and result.Instance:IsDescendantOf(character)
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

    local dist = (Vector2.new(screenPos.X, screenPos.Y) - GetScreenCenter()).Magnitude
    return dist <= AimConfig.FOV
end

local function GetClosestTarget()
    local closest = nil
    local shortest = AimConfig.FOV

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local part = char and char:FindFirstChild(AimConfig.TargetPart)

            if hum and hum.Health > 0 and part then
                if AimConfig.TeamCheck and player.Team == LocalPlayer.Team then
                    continue
                end

                if not IsPlayerVisible(part) then
                    continue
                end

                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)

                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - GetScreenCenter()).Magnitude

                    if dist < shortest then
                        shortest = dist
                        closest = part
                    end
                end
            end
        end
    end

    return closest
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
        local camPos = Camera.CFrame.Position
        local targetCFrame = CFrame.new(camPos, CurrentTarget.Position)
        local smoothCFrame = Camera.CFrame:Lerp(targetCFrame, AimConfig.Smoothness)

        Camera.CFrame = Camera.CFrame:Lerp(smoothCFrame, AimConfig.Strength)
    end
end

--// ==========================================================
--// ESP
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

    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")

    if not char or not hum or not root then return false end
    if hum.Health <= 0 then return false end

    if ESPConfig.TeamCheck and player.Team == LocalPlayer.Team then
        return false
    end

    local dist = (Camera.CFrame.Position - root.Position).Magnitude
    return dist <= ESPConfig.MaxDistance
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
                    data.Highlight.FillColor = ESPConfig.Color
                    data.Highlight.OutlineColor = ESPConfig.Color
                    data.Highlight.FillTransparency = ESPConfig.FillEnabled and ESPConfig.FillTransparency or 1
                    data.Highlight.OutlineTransparency = ESPConfig.OutlineTransparency

                    data.Text.TextColor3 = ESPConfig.Color
                    data.Text.TextSize = ESPConfig.TextSize

                    local lines = {}
                    local dist = math.floor((Camera.CFrame.Position - root.Position).Magnitude)

                    if ESPConfig.ShowNames then
                        table.insert(lines, player.Name)
                    end

                    if ESPConfig.ShowHealth then
                        table.insert(lines, "HP: " .. math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth))
                    end

                    if ESPConfig.ShowDistance then
                        table.insert(lines, dist .. " studs")
                    end

                    data.Text.Text = table.concat(lines, "\n")
                    data.Billboard.Enabled = #lines > 0

                    if data.Line then
                        local pos, onScreen = Camera:WorldToViewportPoint(root.Position)

                        if ESPConfig.ShowLines and onScreen then
                            data.Line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                            data.Line.To = Vector2.new(pos.X, pos.Y)
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
--// MISC
--// ==========================================================

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
    Notify("Tentando trocar de servidor...", "server", 3)
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end

local function SmallServer()
    Notify("Procurando servidor menor...", "search", 3)

    local success, servers = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(
            "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        ))
    end)

    if not success or not servers or not servers.data then
        Notify("Erro ao buscar servidores.", "triangle-alert", 3)
        return
    end

    local best = nil

    for _, server in ipairs(servers.data) do
        if server.id ~= game.JobId and server.playing < server.maxPlayers then
            if not best or server.playing < best.playing then
                best = server
            end
        end
    end

    if best then
        TeleportService:TeleportToPlaceInstance(game.PlaceId, best.id, LocalPlayer)
    else
        Notify("Nenhum servidor menor encontrado.", "x", 3)
    end
end

--// ==========================================================
--// UI - SCRIPTS
--// ==========================================================

Scripts:Section({ Title = "Home", Box = false, TextSize = 17 })

Scripts:Paragraph({
    Title = "Mirrors Hub",
    Desc = "Universal script hub.\nVersion: " .. HUB_VERSION,
    Color = "Blue",
    Locked = false,
})

Scripts:Button({
    Title = "Load Script",
    Desc = "Placeholder.",
    Locked = false,
    Callback = function()
        Notify("Nenhum script configurado ainda.", "info", 3)
    end
})

--// ==========================================================
--// UI - AIMBOT
--// ==========================================================

Aimbot:Section({ Title = "Main", Box = false, TextSize = 17 })

Aimbot:Toggle({
    Title = "Enable Aimbot",
    Desc = "Liga/desliga o aim assist.",
    Flag = "AimbotEnabled",
    Type = "Checkbox",
    Value = AimConfig.Enabled,
    Callback = function(v)
        AimConfig.Enabled = v
        if not v then CurrentTarget = nil end
    end
})

Aimbot:Toggle({
    Title = "Team Check",
    Desc = "Ignora jogadores do mesmo time.",
    Flag = "AimbotTeamCheck",
    Type = "Checkbox",
    Value = AimConfig.TeamCheck,
    Callback = function(v)
        AimConfig.TeamCheck = v
        CurrentTarget = nil
    end
})

Aimbot:Toggle({
    Title = "Visible Check",
    Desc = "Só mira em jogador visível.",
    Flag = "AimbotVisibleCheck",
    Type = "Checkbox",
    Value = AimConfig.VisibleCheck,
    Callback = function(v)
        AimConfig.VisibleCheck = v
        CurrentTarget = nil
    end
})

Aimbot:Dropdown({
    Title = "Target Part",
    Desc = "Parte do corpo para mirar.",
    Flag = "AimbotTargetPart",
    Values = { "Head", "HumanoidRootPart" },
    Value = AimConfig.TargetPart,
    Callback = function(v)
        AimConfig.TargetPart = v
        CurrentTarget = nil
    end
})

Aimbot:Section({ Title = "FOV", Box = false, TextSize = 17 })

Aimbot:Slider({
    Title = "Aimbot FOV",
    Desc = "Tamanho do FOV.",
    Flag = "AimbotFOV",
    Step = 1,
    Value = { Min = 10, Max = 500, Default = AimConfig.FOV },
    Callback = function(v)
        AimConfig.FOV = v
        if FOVCircle then FOVCircle.Radius = v end
    end
})

Aimbot:Toggle({
    Title = "Show FOV Circle",
    Desc = "Mostra o círculo do FOV.",
    Flag = "AimbotFOVVisible",
    Type = "Checkbox",
    Value = AimConfig.FOVVisible,
    Callback = function(v)
        AimConfig.FOVVisible = v
        if FOVCircle then FOVCircle.Visible = v end
    end
})

Aimbot:Colorpicker({
    Title = "FOV Color",
    Desc = "Cor do FOV.",
    Flag = "AimbotFOVColor",
    Default = AimConfig.FOVColor,
    Transparency = 0,
    Locked = false,
    Callback = function(v)
        AimConfig.FOVColor = v
        if FOVCircle then FOVCircle.Color = v end
    end
})

Aimbot:Section({ Title = "Tuning", Box = false, TextSize = 17 })

Aimbot:Slider({
    Title = "Smoothness",
    Desc = "Suavidade da mira.",
    Flag = "AimbotSmoothness",
    Step = 1,
    Value = { Min = 1, Max = 100, Default = 35 },
    Callback = function(v)
        AimConfig.Smoothness = v / 388
    end
})

Aimbot:Slider({
    Title = "Aim Strength",
    Desc = "Força da mira.",
    Flag = "AimbotStrength",
    Step = 1,
    Value = { Min = 1, Max = 100, Default = 100 },
    Callback = function(v)
        AimConfig.Strength = v / 100
    end
})

Aimbot:Slider({
    Title = "Target Switch Delay",
    Desc = "Delay para trocar alvo.",
    Flag = "AimbotSwitchDelay",
    Step = 0.05,
    Value = { Min = 0, Max = 2, Default = AimConfig.TargetSwitchDelay },
    Callback = function(v)
        AimConfig.TargetSwitchDelay = v
    end
})

--// ==========================================================
--// UI - ESP
--// ==========================================================

Esp:Section({ Title = "Main", Box = false, TextSize = 17 })

Esp:Toggle({
    Title = "Enable ESP",
    Desc = "Liga/desliga o ESP.",
    Flag = "ESPEnabled",
    Type = "Checkbox",
    Value = ESPConfig.Enabled,
    Callback = function(v)
        ESPConfig.Enabled = v
        if v then RefreshESP() else ClearESP() end
    end
})

Esp:Colorpicker({
    Title = "ESP Color",
    Desc = "Cor principal.",
    Flag = "ESPColor",
    Default = ESPConfig.Color,
    Transparency = 0,
    Locked = false,
    Callback = function(v)
        ESPConfig.Color = v
    end
})

Esp:Toggle({
    Title = "Team Check",
    Desc = "Ignora jogadores do mesmo time.",
    Flag = "ESPTeamCheck",
    Type = "Checkbox",
    Value = ESPConfig.TeamCheck,
    Callback = function(v)
        ESPConfig.TeamCheck = v
        RefreshESP()
    end
})

Esp:Section({ Title = "Info", Box = false, TextSize = 17 })

Esp:Toggle({
    Title = "Show Names",
    Desc = "Mostra nomes.",
    Flag = "ESPShowNames",
    Type = "Checkbox",
    Value = ESPConfig.ShowNames,
    Callback = function(v)
        ESPConfig.ShowNames = v
    end
})

Esp:Toggle({
    Title = "Show Health",
    Desc = "Mostra vida.",
    Flag = "ESPShowHealth",
    Type = "Checkbox",
    Value = ESPConfig.ShowHealth,
    Callback = function(v)
        ESPConfig.ShowHealth = v
    end
})

Esp:Toggle({
    Title = "Show Distance",
    Desc = "Mostra distância.",
    Flag = "ESPShowDistance",
    Type = "Checkbox",
    Value = ESPConfig.ShowDistance,
    Callback = function(v)
        ESPConfig.ShowDistance = v
    end
})

Esp:Toggle({
    Title = "Show Lines",
    Desc = "Linhas do meio inferior da tela.",
    Flag = "ESPShowLines",
    Type = "Checkbox",
    Value = ESPConfig.ShowLines,
    Callback = function(v)
        ESPConfig.ShowLines = v
    end
})

Esp:Section({ Title = "Visual", Box = false, TextSize = 17 })

Esp:Toggle({
    Title = "Fill Box",
    Desc = "Preenche o corpo.",
    Flag = "ESPFill",
    Type = "Checkbox",
    Value = ESPConfig.FillEnabled,
    Callback = function(v)
        ESPConfig.FillEnabled = v
    end
})

Esp:Slider({
    Title = "Fill Transparency",
    Desc = "Transparência do fill.",
    Flag = "ESPFillTransparency",
    Step = 1,
    Value = { Min = 0, Max = 100, Default = 75 },
    Callback = function(v)
        ESPConfig.FillTransparency = v / 100
    end
})

Esp:Slider({
    Title = "Outline Transparency",
    Desc = "Transparência da borda.",
    Flag = "ESPOutlineTransparency",
    Step = 1,
    Value = { Min = 0, Max = 100, Default = 0 },
    Callback = function(v)
        ESPConfig.OutlineTransparency = v / 100
    end
})

Esp:Slider({
    Title = "Text Size",
    Desc = "Tamanho do texto.",
    Flag = "ESPTextSize",
    Step = 1,
    Value = { Min = 8, Max = 30, Default = ESPConfig.TextSize },
    Callback = function(v)
        ESPConfig.TextSize = v
    end
})

Esp:Slider({
    Title = "Max Distance",
    Desc = "Distância máxima.",
    Flag = "ESPMaxDistance",
    Step = 50,
    Value = { Min = 100, Max = 10000, Default = ESPConfig.MaxDistance },
    Callback = function(v)
        ESPConfig.MaxDistance = v
    end
})

Esp:Button({
    Title = "Refresh ESP",
    Desc = "Recarrega o ESP.",
    Locked = false,
    Callback = function()
        RefreshESP()
        Notify("ESP atualizado.", "refresh-cw", 2)
    end
})

--// ==========================================================
--// UI - TROLL
--// ==========================================================

Troll:Section({ Title = "Coming Soon", Box = false, TextSize = 17 })

Troll:Button({
    Title = "Troll Action 1",
    Desc = "Placeholder.",
    Locked = false,
    Callback = function()
        Notify("Ainda não configurado.", "info", 2)
    end
})

Troll:Button({
    Title = "Troll Action 2",
    Desc = "Placeholder.",
    Locked = false,
    Callback = function()
        Notify("Ainda não configurado.", "info", 2)
    end
})

--// ==========================================================
--// UI - MISC
--// ==========================================================

Misc:Section({ Title = "Movement", Box = false, TextSize = 17 })

Misc:Slider({
    Title = "WalkSpeed",
    Desc = "Velocidade.",
    Flag = "MiscWalkSpeed",
    Step = 1,
    Value = { Min = 16, Max = 200, Default = MiscConfig.WalkSpeed },
    Callback = function(v)
        MiscConfig.WalkSpeed = v
        ApplyMovement()
    end
})

Misc:Slider({
    Title = "JumpPower",
    Desc = "Força do pulo.",
    Flag = "MiscJumpPower",
    Step = 1,
    Value = { Min = 50, Max = 300, Default = MiscConfig.JumpPower },
    Callback = function(v)
        MiscConfig.JumpPower = v
        ApplyMovement()
    end
})

Misc:Toggle({
    Title = "Noclip",
    Desc = "Atravessar colisões.",
    Flag = "MiscNoclip",
    Type = "Checkbox",
    Value = MiscConfig.Noclip,
    Callback = function(v)
        MiscConfig.Noclip = v
    end
})

Misc:Toggle({
    Title = "Infinite Jump",
    Desc = "Pulo infinito.",
    Flag = "MiscInfiniteJump",
    Type = "Checkbox",
    Value = MiscConfig.InfiniteJump,
    Callback = function(v)
        MiscConfig.InfiniteJump = v
    end
})

Misc:Section({ Title = "Utility", Box = false, TextSize = 17 })

Misc:Toggle({
    Title = "Anti AFK",
    Desc = "Evita ficar inativo.",
    Flag = "MiscAntiAFK",
    Type = "Checkbox",
    Value = MiscConfig.AntiAFK,
    Callback = function(v)
        MiscConfig.AntiAFK = v
    end
})

Misc:Button({
    Title = "Reset Character",
    Desc = "Reseta seu personagem.",
    Locked = false,
    Callback = function()
        local hum = GetHumanoid()
        if hum then hum.Health = 0 end
    end
})

Misc:Button({
    Title = "Rejoin Server",
    Desc = "Reconecta.",
    Locked = false,
    Callback = function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
})

Misc:Button({
    Title = "Server Hop",
    Desc = "Troca de servidor.",
    Locked = false,
    Callback = ServerHop
})

Misc:Button({
    Title = "Small Server",
    Desc = "Vai para servidor menor.",
    Locked = false,
    Callback = SmallServer
})

--// ==========================================================
--// UI - CONFIG
--// ==========================================================

Config:Section({ Title = "Config File", Box = false, TextSize = 17 })

Config:Paragraph({
    Title = "Config",
    Desc = "Pasta: MirrorsHub\nArquivo: universal-config.json",
    Color = "Blue",
    Locked = false,
})

Config:Button({
    Title = "Save Config",
    Desc = "Salva universal-config.json.",
    Locked = false,
    Callback = function()
        UniversalConfig:Save()
        Notify("Config salva.", "save", 3)
    end
})

Config:Button({
    Title = "Load Config",
    Desc = "Carrega universal-config.json.",
    Locked = false,
    Callback = function()
        UniversalConfig:Load()
        RefreshESP()
        ApplyMovement()
        Notify("Config carregada.", "folder-open", 3)
    end
})

Config:Button({
    Title = "Reset Session",
    Desc = "Desliga funções perigosas da sessão atual.",
    Locked = false,
    Callback = function()
        AimConfig.Enabled = false
        ESPConfig.Enabled = false
        MiscConfig.Noclip = false
        MiscConfig.InfiniteJump = false
        CurrentTarget = nil
        ClearESP()
        Notify("Sessão resetada.", "rotate-ccw", 3)
    end
})

Config:Section({ Title = "Startup", Box = false, TextSize = 17 })

Config:Toggle({
    Title = "Auto Load Config",
    Desc = "Salva preferência de auto load.",
    Flag = "ConfigAutoLoad",
    Type = "Checkbox",
    Value = true,
    Callback = function(v) end
})

Config:Toggle({
    Title = "Auto Load Script",
    Desc = "Salva preferência de auto execução.",
    Flag = "ConfigAutoLoadScript",
    Type = "Checkbox",
    Value = false,
    Callback = function(v) end
})

Config:Section({ Title = "Interface", Box = false, TextSize = 17 })

Config:Keybind({
    Title = "Toggle UI Key",
    Desc = "Tecla para abrir/fechar a UI.",
    Flag = "ConfigToggleKey",
    Value = "H",
    Callback = function(v)
        if v and Enum.KeyCode[v] then
            Window:SetToggleKey(Enum.KeyCode[v])
            Notify("Toggle key alterada para: " .. v, "keyboard", 3)
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

    pcall(function()
        UniversalConfig:Load()
    end)

    RefreshESP()
    ApplyMovement()

    Notify("Carregado com sucesso.", "check", 3)
end)
