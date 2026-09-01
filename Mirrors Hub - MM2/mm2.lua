-- Services

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

-- MM2

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Gameplay = Remotes:WaitForChild("Gameplay")
local Extras = Remotes:WaitForChild("Extras")

local GetCurrentPlayerData = Gameplay:WaitForChild("GetCurrentPlayerData")
local GetChance = Extras:WaitForChild("GetChance")

-- WindUI

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
            print("triple t x50")
        end,
    }
})

Window:EditOpenButton({
    Title = "Mirrors Hub - MM2",
    Icon = "monitor",

    CornerRadius = UDim.new(0, 16),
    StrokeThickness = 2,

    Color = ColorSequence.new(
        Color3.fromHex("8500FF"),
        Color3.fromHex("47007F")
    ),

    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

-- Tabs

local InfoTab = Window:Tab({
    Title = "Info",
    Icon = "info"
})

local MainTab = Window:Tab({
    Title = "Main",
    Icon = "house"
})

local PlayerTab = Window:Tab({
    Title = "Player",
    Icon = "user"
})

local MiscTab = Window:Tab({
    Title = "Misc",
    Icon = "layers"
})

local ConfigTab = Window:Tab({
    Title = "Config",
    Icon = "cog"
})

-- Variáveis

local FPS = 0
local Frames = 0
local LastFPSUpdate = os.clock()

local Roles = {}

local ESPMode = "Off"
local TracerEnabled = true

local RoleFilter = {
    Murderer = true,
    Sheriff = true,
    Innocent = true
}

local ESPColors = {
    Murderer = Color3.fromRGB(255, 70, 70),
    Sheriff = Color3.fromRGB(70, 150, 255),
    Hero = Color3.fromRGB(70, 150, 255),
    Innocent = Color3.fromRGB(80, 255, 120)
}

local HighlightESP = {}
local DrawingESP = {}

local AutoGunDropped = false
local GettingGun = false

local ServerParagraph
local MM2Paragraph

-- Funções

local function GetExecutor()
    if typeof(identifyexecutor) == "function" then
        local Success, Name = pcall(identifyexecutor)

        if Success and Name then
            return tostring(Name)
        end
    end

    if typeof(getexecutorname) == "function" then
        local Success, Name = pcall(getexecutorname)

        if Success and Name then
            return tostring(Name)
        end
    end

    return "Unknown"
end

local function GetPing()
    local Ping = 0

    pcall(function()
        local Item = Stats.Network.ServerStatsItem:FindFirstChild("Data Ping")

        if Item then
            Ping = math.round(Item:GetValue())
        end
    end)

    return Ping
end

local function GetMap()
    for _, Object in ipairs(Workspace:GetChildren()) do
        local MapID = Object:GetAttribute("MapID")

        if MapID ~= nil then
            return tostring(MapID)
        end
    end

    return "Lobby"
end

local function GetRoundTime()
    local Timer = Workspace:FindFirstChild("RoundTimerPart")
    if not Timer then
        return 0
    end

    local Time = Timer:GetAttribute("Time")

    if typeof(Time) == "number" and Time >= 0 then
        return math.floor(Time)
    end

    return 0
end

local function GetAlivePlayers()
    local Count = 0

    for _, Player in ipairs(Players:GetPlayers()) do
        if Player:GetAttribute("Alive") == true then
            Count += 1
        end
    end

    return Count
end

local function GetMurderChance()
    local Success, Result = pcall(function()
        return GetChance:InvokeServer()
    end)

    if Success and typeof(Result) == "number" then
        return math.round(Result)
    end

    return "?"
end

-- Roles

local function UpdateRoles()
    local Success, Data = pcall(function()
        return GetCurrentPlayerData:InvokeServer()
    end)

    if not Success or typeof(Data) ~= "table" then
        return
    end

    table.clear(Roles)

    for Name, Info in pairs(Data) do
        if typeof(Info) == "table" then
            local Role = Info.Role or Info.role

            if Role then
                Roles[tostring(Name)] = tostring(Role)
            end
        end
    end
end

local function GetRole(Player)
    return Roles[Player.Name]
        or Roles[tostring(Player.UserId)]
        or "Innocent"
end

local function GetRoundRoles()
    local MyRole = GetRole(LocalPlayer)

    local Murderer = "Unknown"
    local Sheriff = "Unknown"

    for _, Player in ipairs(Players:GetPlayers()) do
        local Role = GetRole(Player)

        if Role == "Murderer" then
            Murderer = Player.Name

        elseif Role == "Sheriff" or Role == "Hero" then
            Sheriff = Player.Name
        end
    end

    return MyRole, Murderer, Sheriff
end

-- Info

local Executor = GetExecutor()

local function UpdateServerInfo()
    if not ServerParagraph then
        return
    end

    ServerParagraph:SetDesc(
        "Players: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers ..
        "\nJob ID: " .. game.JobId ..
        "\nPing: " .. GetPing() .. " ms" ..
        "\nFPS: " .. FPS ..
        "\nExecutor: " .. Executor
    )
end

local function UpdateMM2Info()
    if not MM2Paragraph then
        return
    end

    local Role, Murderer, Sheriff = GetRoundRoles()

    MM2Paragraph:SetDesc(
        "Map: " .. GetMap() ..
        "\nGame Mode: " .. tostring(Workspace:GetAttribute("GameMode") or "Unknown") ..
        "\nRound Time: " .. GetRoundTime() .. "s" ..
        "\nYour Role: " .. Role ..
        "\nMurderer: " .. Murderer ..
        "\nSheriff: " .. Sheriff ..
        "\nAlive Players: " .. GetAlivePlayers() ..
        "\nMurder Chance: " .. GetMurderChance() .. "%"
    )
end

-- ESP

local function CanShowRole(Role)
    if Role == "Hero" then
        return RoleFilter.Sheriff
    end

    return RoleFilter[Role] == true
end

local function HighlightEnabled()
    return ESPMode == "Highlight"
        or ESPMode == "Both"
end

local function DrawingEnabled()
    return ESPMode == "Drawing"
        or ESPMode == "Both"
end

local function NewDrawing(Type, Properties)
    local Object = Drawing.new(Type)

    for Property, Value in pairs(Properties) do
        Object[Property] = Value
    end

    return Object
end

-- Highlight

local function RemoveHighlight(Player)
    local Highlight = HighlightESP[Player]

    if Highlight then
        Highlight:Destroy()
        HighlightESP[Player] = nil
    end
end

local function UpdateHighlight(Player)
    local Role = GetRole(Player)

    if not HighlightEnabled() or not CanShowRole(Role) then
        RemoveHighlight(Player)
        return
    end

    local Character = Player.Character

    if not Character then
        RemoveHighlight(Player)
        return
    end

    local Highlight = HighlightESP[Player]

    if not Highlight or Highlight.Parent ~= Character then
        RemoveHighlight(Player)

        Highlight = Instance.new("Highlight")
        Highlight.Name = "MM2_ESP"

        Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        Highlight.FillTransparency = 0.65
        Highlight.OutlineTransparency = 0

        Highlight.Parent = Character
        HighlightESP[Player] = Highlight
    end

    local Color = ESPColors[Role] or ESPColors.Innocent

    Highlight.FillColor = Color
    Highlight.OutlineColor = Color
end

-- Drawing

local function CreateDrawing(Player)
    if DrawingESP[Player] then
        return
    end

    DrawingESP[Player] = {
        Outline = NewDrawing("Square", {
            Filled = false,
            Thickness = 3,
            Color = Color3.new(0, 0, 0)
        }),

        Box = NewDrawing("Square", {
            Filled = false,
            Thickness = 1
        }),

        Name = NewDrawing("Text", {
            Center = true,
            Outline = true,
            Size = 13
        }),

        Role = NewDrawing("Text", {
            Center = true,
            Outline = true,
            Size = 12
        }),

        Distance = NewDrawing("Text", {
            Center = true,
            Outline = true,
            Size = 12,
            Color = Color3.new(1, 1, 1)
        }),

        HealthBG = NewDrawing("Line", {
            Thickness = 4,
            Color = Color3.new(0, 0, 0)
        }),

        Health = NewDrawing("Line", {
            Thickness = 2
        }),

        Tracer = NewDrawing("Line", {
            Thickness = 1
        })
    }
end

local function HideDrawing(Data)
    if not Data then
        return
    end

    for _, Object in pairs(Data) do
        Object.Visible = false
    end
end

local function RemoveDrawing(Player)
    local Data = DrawingESP[Player]

    if not Data then
        return
    end

    for _, Object in pairs(Data) do
        pcall(function()
            Object:Remove()
        end)
    end

    DrawingESP[Player] = nil
end

local function UpdateDrawing(Player)
    local Role = GetRole(Player)

    if not DrawingEnabled() or not CanShowRole(Role) then
        HideDrawing(DrawingESP[Player])
        return
    end

    if not DrawingESP[Player] then
        CreateDrawing(Player)
    end

    local Data = DrawingESP[Player]

    local Character = Player.Character
    local Root = Character and Character:FindFirstChild("HumanoidRootPart")
    local Head = Character and Character:FindFirstChild("Head")
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

    if not Root
    or not Head
    or not Humanoid
    or Humanoid.Health <= 0 then
        HideDrawing(Data)
        return
    end

    local Camera = Workspace.CurrentCamera

    if not Camera then
        HideDrawing(Data)
        return
    end

    local RootPos, Visible =
        Camera:WorldToViewportPoint(Root.Position)

    if not Visible or RootPos.Z <= 0 then
        HideDrawing(Data)
        return
    end

    local Top = Camera:WorldToViewportPoint(
        Head.Position + Vector3.new(0, 0.7, 0)
    )

    local Bottom = Camera:WorldToViewportPoint(
        Root.Position - Vector3.new(0, 3.2, 0)
    )

    local Height = math.abs(Top.Y - Bottom.Y)
    local Width = Height * 0.55

    local X = RootPos.X - Width / 2
    local Y = RootPos.Y - Height / 2

    local Color = ESPColors[Role] or ESPColors.Innocent

    local Distance = math.floor(
        (Camera.CFrame.Position - Root.Position).Magnitude
    )

    local Health = math.clamp(
        Humanoid.Health / math.max(Humanoid.MaxHealth, 1),
        0,
        1
    )

    Data.Outline.Position = Vector2.new(X, Y)
    Data.Outline.Size = Vector2.new(Width, Height)
    Data.Outline.Visible = true

    Data.Box.Position = Vector2.new(X, Y)
    Data.Box.Size = Vector2.new(Width, Height)
    Data.Box.Color = Color
    Data.Box.Visible = true

    Data.Name.Text = Player.DisplayName
    Data.Name.Position = Vector2.new(RootPos.X, Y - 30)
    Data.Name.Color = Color
    Data.Name.Visible = true

    Data.Role.Text = Role
    Data.Role.Position = Vector2.new(RootPos.X, Y - 16)
    Data.Role.Color = Color
    Data.Role.Visible = true

    Data.Distance.Text = Distance .. " studs"
    Data.Distance.Position = Vector2.new(
        RootPos.X,
        Y + Height + 3
    )
    Data.Distance.Visible = true

    Data.HealthBG.From = Vector2.new(
        X - 6,
        Y + Height
    )

    Data.HealthBG.To = Vector2.new(
        X - 6,
        Y
    )

    Data.HealthBG.Visible = true

    Data.Health.From = Vector2.new(
        X - 6,
        Y + Height
    )

    Data.Health.To = Vector2.new(
        X - 6,
        Y + Height - Height * Health
    )

    Data.Health.Color = Color3.fromRGB(
        255 * (1 - Health),
        255 * Health,
        0
    )

    Data.Health.Visible = true

    if TracerEnabled then
        Data.Tracer.From = Vector2.new(
            Camera.ViewportSize.X / 2,
            Camera.ViewportSize.Y
        )

        Data.Tracer.To = Vector2.new(
            RootPos.X,
            Y + Height
        )

        Data.Tracer.Color = Color
        Data.Tracer.Visible = true
    else
        Data.Tracer.Visible = false
    end
end

local function RefreshESP()
    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer then
            UpdateHighlight(Player)
            UpdateDrawing(Player)
        end
    end
end

local function ClearESP()
    for Player in pairs(HighlightESP) do
        RemoveHighlight(Player)
    end

    for _, Data in pairs(DrawingESP) do
        HideDrawing(Data)
    end
end

-- Gun

local function HasGun()
    local Character = LocalPlayer.Character
    local Backpack = LocalPlayer:FindFirstChild("Backpack")

    return (
        Character
        and Character:FindFirstChild("Gun")
    ) ~= nil
    or (
        Backpack
        and Backpack:FindFirstChild("Gun")
    ) ~= nil
end

local function GetGunDrop()
    local Gun = Workspace:FindFirstChild("GunDrop", true)

    if Gun and Gun:IsA("BasePart") then
        return Gun
    end
end

local function TeleportToGun()
    if GettingGun or HasGun() then
        return
    end

    local Character = LocalPlayer.Character
    local Root = Character
        and Character:FindFirstChild("HumanoidRootPart")

    local GunDrop = GetGunDrop()

    if not Root or not GunDrop then
        return
    end

    GettingGun = true

    Root.CFrame =
        GunDrop.CFrame
        + Vector3.new(0, 2, 0)

    task.wait(0.25)

    GettingGun = false
end

-- Coin Farm

local FARM_SPEED = 25
local ARRIVE_DISTANCE = 1
local CLAIM_DISTANCE = 4
local CLAIM_TIMEOUT = 0.9
local BLOCK_TIME = 1.25

local Farming = false
local FarmID = 0
local CurrentTween

local CachedMap
local CachedContainer
local BlockedCoins = {}

local function GetRoot()
    local Character = LocalPlayer.Character

    if not Character then
        return
    end

    local Root = Character:FindFirstChild("HumanoidRootPart")
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")

    if not Root
    or not Humanoid
    or Humanoid.Health <= 0 then
        return
    end

    return Root
end

local function GetCoinContainer()
    if CachedMap
    and CachedMap.Parent
    and CachedContainer
    and CachedContainer.Parent then
        return CachedContainer
    end

    CachedMap = nil
    CachedContainer = nil

    table.clear(BlockedCoins)

    for _, Object in ipairs(Workspace:GetChildren()) do
        local Container =
            Object:FindFirstChild("CoinContainer")

        if Object:GetAttribute("MapID") ~= nil
        and Container then
            CachedMap = Object
            CachedContainer = Container

            return Container
        end
    end
end

local function GetCoinVisual(Coin)
    if not Coin
    or not Coin.Parent
    or not Coin:IsA("BasePart") then
        return
    end

    local Visual =
        Coin:FindFirstChild("CoinVisual")

    if not Visual
    or Visual:GetAttribute("Collected") == true then
        return
    end

    return Visual
end

local function GetNearestCoin(Root, Container)
    local Closest
    local ClosestVisual
    local ClosestDistance = math.huge

    local Now = os.clock()

    for _, Coin in ipairs(Container:GetChildren()) do
        local BlockedUntil = BlockedCoins[Coin]

        if BlockedUntil
        and BlockedUntil <= Now then
            BlockedCoins[Coin] = nil
            BlockedUntil = nil
        end

        if not Coin.Parent then
            BlockedCoins[Coin] = nil

        elseif not BlockedUntil then
            local Visual = GetCoinVisual(Coin)

            if Visual then
                local Distance =
                    (Root.Position - Coin.Position).Magnitude

                if Distance < ClosestDistance then
                    Closest = Coin
                    ClosestVisual = Visual
                    ClosestDistance = Distance
                end
            end
        end
    end

    return Closest, ClosestVisual
end

local function CancelCoinMovement()
    local Tween = CurrentTween
    CurrentTween = nil

    if Tween then
        pcall(function()
            Tween:Cancel()
        end)
    end
end

local function MoveToCoin(Root, Coin, Visual, ID)
    if not Root.Parent
    or not Coin.Parent
    or not Visual.Parent
    or not Farming
    or ID ~= FarmID then
        return false, false
    end

    local Position = Coin.Position
    local Distance =
        (Root.Position - Position).Magnitude

    if Distance <= ARRIVE_DISTANCE then
        return true, false, Position
    end

    local Duration = math.max(
        Distance / FARM_SPEED,
        0.03
    )

    local Tween = TweenService:Create(
        Root,

        TweenInfo.new(
            Duration,
            Enum.EasingStyle.Linear
        ),

        {
            CFrame =
                CFrame.new(Position)
                * Root.CFrame.Rotation
        }
    )

    CurrentTween = Tween

    local Finished = false
    local State

    local Connection =
        Tween.Completed:Connect(function(NewState)
            State = NewState
            Finished = true
        end)

    Tween:Play()

    local Deadline =
        os.clock()
        + Duration
        + 0.75

    while Farming
    and ID == FarmID
    and not Finished do

        if not Root.Parent
        or LocalPlayer:GetAttribute("Alive") ~= true then
            break
        end

        if not Coin.Parent
        or not Visual.Parent
        or Visual:GetAttribute("Collected") == true then
            break
        end

        if os.clock() >= Deadline then
            break
        end

        task.wait(0.03)
    end

    if not Finished then
        pcall(function()
            Tween:Cancel()
        end)
    end

    Connection:Disconnect()

    if CurrentTween == Tween then
        CurrentTween = nil
    end

    if not Farming
    or ID ~= FarmID
    or not Root.Parent then
        return false, false, Position
    end

    local Near =
        (Root.Position - Position).Magnitude
        <= CLAIM_DISTANCE

    local Collected =
        not Coin.Parent
        or not Visual.Parent
        or Visual:GetAttribute("Collected") == true

    if Collected then
        return Near, Near, Position
    end

    return (
        State == Enum.PlaybackState.Completed
        and Near
    ), false, Position
end

local function WaitForCoin(
    Coin,
    Visual,
    Root,
    Position,
    ID
)
    local Deadline =
        os.clock() + CLAIM_TIMEOUT

    while Farming and ID == FarmID do
        if not Root.Parent
        or LocalPlayer:GetAttribute("Alive") ~= true then
            return false
        end

        local Near =
            (Root.Position - Position).Magnitude
            <= CLAIM_DISTANCE

        if not Coin.Parent
        or not Visual.Parent
        or Visual:GetAttribute("Collected") == true then
            return Near
        end

        if not Near
        or os.clock() >= Deadline then
            return false
        end

        task.wait(0.03)
    end

    return false
end

local function StopCoinFarm()
    Farming = false
    FarmID += 1

    CancelCoinMovement()
end

local function StartCoinFarm()
    StopCoinFarm()

    Farming = true

    local ID = FarmID

    task.spawn(function()
        while Farming and ID == FarmID do
            local Success, Error = pcall(function()
                if LocalPlayer:GetAttribute("Alive") ~= true then
                    CancelCoinMovement()
                    task.wait(0.25)
                    return
                end

                local Root = GetRoot()

                if not Root then
                    CancelCoinMovement()
                    task.wait(0.2)
                    return
                end

                local Container = GetCoinContainer()

                if not Container then
                    CancelCoinMovement()
                    task.wait(0.35)
                    return
                end

                local Coin, Visual =
                    GetNearestCoin(Root, Container)

                if not Coin or not Visual then
                    task.wait(0.12)
                    return
                end

                local Reached, Collected, Position =
                    MoveToCoin(
                        Root,
                        Coin,
                        Visual,
                        ID
                    )

                if Collected then
                    task.wait(0.03)
                    return
                end

                if Reached
                and WaitForCoin(
                    Coin,
                    Visual,
                    Root,
                    Position,
                    ID
                ) then
                    task.wait(0.03)
                    return
                end

                if Coin.Parent then
                    BlockedCoins[Coin] =
                        os.clock() + BLOCK_TIME
                end

                task.wait(0.04)
            end)

            if not Success then
                CancelCoinMovement()

                warn(
                    "[Coin Farm] "
                    .. tostring(Error)
                )

                task.wait(0.35)
            end
        end
    end)
end

-- UI

ServerParagraph = InfoTab:Paragraph({
    Title = "Server Information",
    Desc = "Loading...",

    Buttons = {
        {
            Icon = "copy",
            Title = "Copy Job ID",

            Callback = function()
                if setclipboard then
                    setclipboard(game.JobId)
                end
            end,
        }
    }
})

MM2Paragraph = InfoTab:Paragraph({
    Title = "Game Information",
    Desc = "Loading..."
})

-- Main

MainTab:Dropdown({
    Title = "ESP Mode",
    Desc = "Choose ESP style",

    Values = {
        "Off",
        "Highlight",
        "Drawing",
        "Both"
    },

    Value = "Off",

    Callback = function(Option)
        ESPMode = Option

        if Option == "Off" then
            ClearESP()

        elseif Option == "Highlight" then
            for _, Data in pairs(DrawingESP) do
                HideDrawing(Data)
            end

        elseif Option == "Drawing" then
            for Player in pairs(HighlightESP) do
                RemoveHighlight(Player)
            end
        end

        RefreshESP()
    end
})

MainTab:Dropdown({
    Title = "ESP Roles",
    Desc = "Choose which roles to show",

    Values = {
        "Murderer",
        "Sheriff",
        "Innocent"
    },

    Value = {
        "Murderer",
        "Sheriff",
        "Innocent"
    },

    Multi = true,
    AllowNone = true,

    Callback = function(Options)
        RoleFilter.Murderer = false
        RoleFilter.Sheriff = false
        RoleFilter.Innocent = false

        for _, Role in ipairs(Options) do
            RoleFilter[Role] = true
        end

        RefreshESP()
    end
})

MainTab:Toggle({
    Title = "Tracers",
    Desc = "Show lines to players",
    Value = true,

    Callback = function(Value)
        TracerEnabled = Value

        if not Value then
            for _, Data in pairs(DrawingESP) do
                Data.Tracer.Visible = false
            end
        end
    end
})

MainTab:Toggle({
    Title = "Coin Farm",
    Desc = "Automatically collects nearby coins",
    Value = false,

    Callback = function(Value)
        if Value then
            StartCoinFarm()
        else
            StopCoinFarm()
        end
    end
})

-- Player

PlayerTab:Button({
    Title = "Teleport to Gun",
    Desc = "Teleport to the dropped gun",

    Callback = TeleportToGun
})

PlayerTab:Toggle({
    Title = "Auto Gun Dropped",
    Desc = "Automatically get the dropped gun",
    Value = false,

    Callback = function(Value)
        AutoGunDropped = Value
    end
})

-- Connections

RunService.RenderStepped:Connect(function()
    Frames += 1

    local Now = os.clock()
    local Delta = Now - LastFPSUpdate

    if Delta >= 1 then
        FPS = math.round(Frames / Delta)

        Frames = 0
        LastFPSUpdate = Now
    end

    if DrawingEnabled() then
        for _, Player in ipairs(Players:GetPlayers()) do
            if Player ~= LocalPlayer then
                UpdateDrawing(Player)
            end
        end
    end
end)

Players.PlayerAdded:Connect(function()
    task.delay(0.1, UpdateServerInfo)
end)

Players.PlayerRemoving:Connect(function(Player)
    RemoveHighlight(Player)
    RemoveDrawing(Player)

    Roles[Player.Name] = nil
    Roles[tostring(Player.UserId)] = nil

    task.delay(0.1, UpdateServerInfo)
end)

LocalPlayer.CharacterRemoving:Connect(function()
    CancelCoinMovement()
end)

LocalPlayer:GetAttributeChangedSignal("Alive"):Connect(function()
    if LocalPlayer:GetAttribute("Alive") ~= true then
        CancelCoinMovement()
    end
end)

-- Loops

UpdateRoles()
UpdateServerInfo()
UpdateMM2Info()

task.spawn(function()
    while task.wait(1) do
        UpdateRoles()
        UpdateServerInfo()
        UpdateMM2Info()
    end
end)

task.spawn(function()
    while task.wait(0.25) do
        if HighlightEnabled() then
            for _, Player in ipairs(Players:GetPlayers()) do
                if Player ~= LocalPlayer then
                    UpdateHighlight(Player)
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.2) do
        if AutoGunDropped
        and not HasGun()
        and GetGunDrop() then
            TeleportToGun()
        end
    end
end)
