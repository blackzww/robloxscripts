local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ==========================================================
-- AIMBOT CONFIGURATION TABLE (Controlada via GUI)
-- ==========================================================
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

local CurrentTarget = nil
local LastSwitch = 0

-- DRAWING API FOR FOV
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.NumSides = 64
FOVCircle.Radius = AimConfig.FOV
FOVCircle.Filled = false
FOVCircle.Visible = AimConfig.FOVVisible
FOVCircle.Color = AimConfig.FOVColor

-- ==========================================================
-- MATH & TARGETING FUNCTIONS
-- ==========================================================
local function GetScreenCenter()
    return Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end

local function IsPlayerVisible(targetPart)
    if not AimConfig.VisibleCheck then return true end
    
    local character = targetPart.Parent
    if not character then return false end
    
    local origin = Camera.CFrame.Position
    local direction = targetPart.Position - origin
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    raycastParams.IgnoreWater = true
    
    local result = workspace:Raycast(origin, direction, raycastParams)
    
    if result and result.Instance:IsDescendantOf(character) then
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
    if distanceFromCenter > AimConfig.FOV then
        return false
    end

    return true
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
                if AimConfig.TeamCheck and player.Team == LocalPlayer.Team then continue end
                if not IsPlayerVisible(targetPart) then continue end

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

-- ==========================================================
-- WINDUI INITIALIZATION
-- ==========================================================
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "Mirrors Hub - Universal",
    Icon = "door-open",
    Author = "by blackzw.mp3",
    Folder = "MirrorsHub",

    Size = UDim2.fromOffset(580, 460),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),

    ToggleKey = Enum.KeyCode.H,
    Transparent = true,
    Theme = "Dark",
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
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new(
        Color3.fromHex("8600D4"),
        Color3.fromHex("1C002E")
    ),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

-- TABS DEFINITION
local Scripts = Window:Tab({Title = "Scripts", Icon = "house"})
local Aimbot = Window:Tab({Title = "Aimbot", Icon = "crosshair"})
local Esp = Window:Tab({Title = "ESP", Icon = "eye"})
local Troll = Window:Tab({Title = "Troll", Icon = "laugh"})
local Misc = Window:Tab({Title = "Misc", Icon = "circle-ellipsis"})
local Config = Window:Tab({Title = "Config", Icon = "cog"})

-- SCRIPTS TAB
Scripts:Paragraph({
    Title = "Mirrors Hub",
    Desc = "Universal script hub interface.",
    Color = "Blue",
    ImageSize = 30,
    ThumbnailSize = 80,
    Locked = false,
})

Scripts:Button({
    Title = "Load Script",
    Desc = "Placeholder button.",
    Locked = false,
    Callback = function()
        -- colocar código depois
    end
})

-- ==========================================================
-- INTEGRATED AIMBOT TAB (Original com Toggles/Checkboxes)
-- ==========================================================

Aimbot:Toggle({
    Title = "Enable Aimbot",
    Desc = "Turn on/off the aim assist system.",
    Type = "Checkbox",
    Value = AimConfig.Enabled,
    Callback = function(state)
        AimConfig.Enabled = state
        if not state then CurrentTarget = nil end
    end
})

Aimbot:Toggle({
    Title = "Team Check",
    Desc = "Ignore players on your own team.",
    Type = "Checkbox",
    Value = AimConfig.TeamCheck,
    Callback = function(state)
        AimConfig.TeamCheck = state
        CurrentTarget = nil
    end
})

Aimbot:Toggle({
    Title = "Visible Check",
    Desc = "Only lock onto players visible to your camera.",
    Type = "Checkbox",
    Value = AimConfig.VisibleCheck,
    Callback = function(state)
        AimConfig.VisibleCheck = state
        CurrentTarget = nil
    end
})

Aimbot:Dropdown({
    Title = "Target Part",
    Desc = "Select the specific body part to target.",
    Values = { "Head", "HumanoidRootPart" },
    Value = "Head",
    Callback = function(selected)
        AimConfig.TargetPart = selected
        CurrentTarget = nil
    end
})

Aimbot:Slider({
    Title = "Aimbot FOV",
    Desc = "Size of the aiming field radius.",
    Step = 1,
    Value = {
        Min = 10,
        Max = 500,
        Default = AimConfig.FOV,
    },
    Callback = function(value)
        AimConfig.FOV = value
        FOVCircle.Radius = value
    end
})

Aimbot:Toggle({
    Title = "Show FOV Circle",
    Desc = "Render the visual FOV radius on screen.",
    Type = "Checkbox",
    Value = AimConfig.FOVVisible,
    Callback = function(state)
        AimConfig.FOVVisible = state
        FOVCircle.Visible = state
    end
})

Aimbot:Colorpicker({
    Title = "FOV Color",
    Desc = "Customizable color for the FOV ring line.",
    Default = AimConfig.FOVColor,
    Transparency = 0,
    Locked = false,
    Callback = function(color)
        AimConfig.FOVColor = color
        FOVCircle.Color = color
    end
})

Aimbot:Slider({
    Title = "Smoothness",
    Desc = "Movement smoothing factor (higher values = slower movement).",
    Step = 1,
    Value = {
        Min = 1,
        Max = 100,
        Default = 35,
    },
    Callback = function(value)
        AimConfig.Smoothness = (value / 388)
    end
})

Aimbot:Slider({
    Title = "Aim Strength",
    Desc = "Power scale applied to camera tracking.",
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
    Desc = "Delay window before switching to the next target.",
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

-- ==========================================================
-- OTHER ORIGINAL TABS (Voltou tudo para Checkbox)
-- ==========================================================

-- ==========================================================
-- CUSTOM ESP SYSTEM FIXED + LINES
-- ==========================================================

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

local ESPObjects = {}

local function RemoveESP(player)
    if ESPObjects[player] then
        for _, obj in pairs(ESPObjects[player]) do
            if obj and obj.Remove then
                obj:Remove()
            elseif obj and obj.Destroy then
                obj:Destroy()
            end
        end

        ESPObjects[player] = nil
    end
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
    local root = char:FindFirstChild("HumanoidRootPart")

    local highlight = Instance.new("Highlight")
    highlight.Name = "MirrorsESP_Highlight"
    highlight.Adornee = char
    highlight.FillColor = ESPConfig.Color
    highlight.OutlineColor = ESPConfig.Color
    highlight.FillTransparency = ESPConfig.FillEnabled and ESPConfig.FillTransparency or 1
    highlight.OutlineTransparency = ESPConfig.OutlineTransparency
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = game:GetService("CoreGui")

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "MirrorsESP_Info"
    billboard.Adornee = root
    billboard.Size = UDim2.new(0, 220, 0, 80)
    billboard.StudsOffset = Vector3.new(0, 3.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Enabled = true
    billboard.Parent = game:GetService("CoreGui")

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

    local line = Drawing.new("Line")
    line.Visible = false
    line.Color = ESPConfig.Color
    line.Thickness = 1.5
    line.Transparency = 1

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

                    local lines = {}

                    if ESPConfig.ShowNames then
                        table.insert(lines, player.Name)
                    end

                    if ESPConfig.ShowHealth then
                        table.insert(lines, "HP: " .. math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth))
                    end

                    if ESPConfig.ShowDistance then
                        table.insert(lines, distance .. " studs")
                    end

                    data.Text.Text = table.concat(lines, "\n")
                    data.Billboard.Enabled = (#lines > 0)

                    local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)

                    if ESPConfig.ShowLines and onScreen then
                        local fromPos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        local toPos = Vector2.new(screenPos.X, screenPos.Y)

                        data.Line.From = fromPos
                        data.Line.To = toPos
                        data.Line.Color = ESPConfig.Color
                        data.Line.Visible = true
                    else
                        data.Line.Visible = false
                    end
                end
            else
                RemoveESP(player)
            end
        end
    end
end
-- ==========================================================
-- ESP TAB CUSTOMIZADA
-- ==========================================================

Esp:Toggle({
    Title = "Enable ESP",
    Desc = "Ativar/desativar o ESP completo.",
    Type = "Checkbox",
    Value = ESPConfig.Enabled,
    Callback = function(state)
        ESPConfig.Enabled = state

        if state then
            RefreshESP()
        else
            ClearESP()
        end
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
    Title = "Show Names",
    Desc = "Mostrar nome dos jogadores.",
    Type = "Checkbox",
    Value = ESPConfig.ShowNames,
    Callback = function(state)
        ESPConfig.ShowNames = state
    end
})

Esp:Toggle({
    Title = "Show Distance",
    Desc = "Mostrar distância até o jogador.",
    Type = "Checkbox",
    Value = ESPConfig.ShowDistance,
    Callback = function(state)
        ESPConfig.ShowDistance = state
    end
})

Esp:Toggle({
    Title = "Show Lines",
    Desc = "Mostra linhas do meio inferior da tela até os jogadores.",
    Type = "Checkbox",
    Value = ESPConfig.ShowLines,
    Callback = function(state)
        ESPConfig.ShowLines = state
    end
})

Esp:Toggle({
    Title = "Show Health",
    Desc = "Mostrar vida do jogador.",
    Type = "Checkbox",
    Value = ESPConfig.ShowHealth,
    Callback = function(state)
        ESPConfig.ShowHealth = state
    end
})

Esp:Toggle({
    Title = "Team Check",
    Desc = "Ignorar jogadores do mesmo time.",
    Type = "Checkbox",
    Value = ESPConfig.TeamCheck,
    Callback = function(state)
        ESPConfig.TeamCheck = state
        RefreshESP()
    end
})

Esp:Toggle({
    Title = "Fill Box",
    Desc = "Preencher o corpo com cor transparente.",
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
    Desc = "Tamanho do texto do ESP.",
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
    Desc = "Distância máxima para mostrar ESP.",
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
    Desc = "Recarrega todos os jogadores.",
    Locked = false,
    Callback = function()
        RefreshESP()
    end
})



-- abas restantes


-- TROLL
Troll:Button({
    Title = "Troll Action 1",
    Desc = "Botão placeholder.",
    Locked = false,
    Callback = function() end
})

Troll:Button({
    Title = "Troll Action 2",
    Desc = "Botão placeholder.",
    Locked = false,
    Callback = function() end
})

-- MISC
Misc:Slider({
    Title = "WalkSpeed",
    Desc = "Controle de velocidade.",
    Step = 1,
    Value = {
        Min = 16,
        Max = 200,
        Default = 16,
    },
    Callback = function(value) end
})

Misc:Slider({
    Title = "JumpPower",
    Desc = "Controle de pulo.",
    Step = 1,
    Value = {
        Min = 50,
        Max = 300,
        Default = 50,
    },
    Callback = function(value) end
})

Misc:Toggle({
    Title = "Anti AFK",
    Desc = "Placeholder.",
    Type = "Checkbox",
    Value = false,
    Callback = function(state) end
})

-- CONFIG
Config:Toggle({
    Title = "UI Blur",
    Desc = "Configuração visual.",
    Type = "Checkbox",
    Value = true,
    Callback = function(state) end
})

Config:Colorpicker({
    Title = "Theme Color",
    Desc = "Cor principal da interface.",
    Default = Color3.fromRGB(134, 0, 212),
    Transparency = 0,
    Locked = false,
    Callback = function(color) end
})

-- ==========================================================
-- RUNSERVICE COMPILER LOOP (RenderStepped)
-- ==========================================================
RunService.RenderStepped:Connect(function()
    if FOVCircle then
        FOVCircle.Position = GetScreenCenter()
    end

    UpdateESP()

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
end)
