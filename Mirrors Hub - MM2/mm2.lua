local Players = game:GetService("Players")
local Stats = game:GetService("Stats")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LP = Players.LocalPlayer

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Gameplay = Remotes:WaitForChild("Gameplay")
local Extras = Remotes:WaitForChild("Extras")

local GetCurrentPlayerData = Gameplay:WaitForChild("GetCurrentPlayerData")
local GetChance = Extras:WaitForChild("GetChance")

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

    Transparent = true,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 200,
    HideSearchBar = false,
    ScrollBarEnabled = false,

    User = {
        Enabled = true,
        Anonymous = true,

        Callback = function()
            print("print(print)")
        end,
    },
})

Window:EditOpenButton({
    Title = "Open Mirrors Hub - MM2",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 16),
    StrokeThickness = 2,

    Color = ColorSequence.new(
        Color3.fromHex("9400FF"),
        Color3.fromHex("3F006C")
    ),

    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

local InfoTab = Window:Tab({
    Title = "Info",
    Icon = "info"
})

local MainTab = Window:Tab({
    Title = "Main",
    Icon = "house"
})

local EspTab = Window:Tab({
    Title = "ESP",
    Icon = "eye"
})

local MurderTab = Window:Tab({
    Title = "Murder",
    Icon = "sword"
})

local SheriffTab = Window:Tab({
    Title = "Sheriff",
    Icon = "shield-user"
})

local InnocentTab = Window:Tab({
    Title = "Innocent",
    Icon = "user"
})

local ShortcutsTab = Window:Tab({
    Title = "Shortcuts",
    Icon = "zap"
})

local MiscTab = Window:Tab({
    Title = "Misc",
    Icon = "layers"
})

local ConfigTab = Window:Tab({
    Title = "Config",
    Icon = "cog"
})

local Roles = {}

local Executor = "Unknown"

local ServerInfo
local GameInfo

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

local AimSettings = {
    Enabled = false,
    FOV = 250,
    Smoothness = 0.18,
    TargetPart = "Head"
}

local AimTarget

local SelectedPlayer
local PlayerDropdown

local FollowActive = false
local FollowConnection
local FollowSession = 0
local FollowOriginalCFrame

local TouchFlingEnabled = false
local TouchFlingThread
local TouchFlingSession = 0

local FlingAllActive = false
local FlingAllThread
local FlingAllSession = 0
local FlingAllOriginalCFrame

local MAX_TARGET_SPEED = 150
local TIME_PER_PLAYER = 2.5

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
    local Success, Value = pcall(function()
        local Item =
            Stats.Network.ServerStatsItem:FindFirstChild("Data Ping")

        return Item
            and math.round(Item:GetValue())
            or 0
    end)

    return Success and Value or 0
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
    local Timer =
        Workspace:FindFirstChild("RoundTimerPart")

    local Time =
        Timer
        and Timer:GetAttribute("Time")

    if typeof(Time) == "number" then
        return math.max(
            0,
            math.floor(Time)
        )
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

    if Success
    and typeof(Result) == "number" then
        return math.round(Result)
    end

    return "?"
end

local function UpdateRoles()
    local Success, Data = pcall(function()
        return GetCurrentPlayerData:InvokeServer()
    end)

    if not Success
    or typeof(Data) ~= "table" then
        return
    end

    table.clear(Roles)

    for Name, Info in pairs(Data) do
        if typeof(Info) == "table" then
            local Role =
                Info.Role
                or Info.role

            if Role then
                Roles[tostring(Name)] =
                    tostring(Role)
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
    local Murderer = "Unknown"
    local Sheriff = "Unknown"

    for _, Player in ipairs(
        Players:GetPlayers()
    ) do
        local Role =
            GetRole(Player)

        if Role == "Murderer" then
            Murderer =
                Player.Name

        elseif Role == "Sheriff"
        or Role == "Hero" then
            Sheriff =
                Player.Name
        end
    end

    return
        GetRole(LP),
        Murderer,
        Sheriff
end

local function UpdateInfo()
    if not ServerInfo
    or not GameInfo then
        return
    end

    UpdateRoles()

    ServerInfo:SetDesc(
        "Players: "
        .. #Players:GetPlayers()
        .. "/"
        .. Players.MaxPlayers
        .. "\nJob ID: "
        .. game.JobId
        .. "\nPing: "
        .. GetPing()
        .. " ms"
        .. "\nExecutor: "
        .. Executor
    )

    local Role,
    Murderer,
    Sheriff =
        GetRoundRoles()

    GameInfo:SetDesc(
        "Map: "
        .. GetMap()
        .. "\nGame Mode: "
        .. tostring(
            Workspace:GetAttribute("GameMode")
            or "Unknown"
        )
        .. "\nRound Time: "
        .. GetRoundTime()
        .. "s"
        .. "\nYour Role: "
        .. Role
        .. "\nMurderer: "
        .. Murderer
        .. "\nSheriff: "
        .. Sheriff
        .. "\nAlive Players: "
        .. GetAlivePlayers()
        .. "\nMurder Chance: "
        .. GetMurderChance()
        .. "%"
    )
end

local function GetRoot()
    local Character =
        LP.Character

    if not Character then
        return
    end

    local Root =
        Character:FindFirstChild(
            "HumanoidRootPart"
        )

    local Humanoid =
        Character:FindFirstChildOfClass(
            "Humanoid"
        )

    if not Root
    or not Humanoid
    or Humanoid.Health <= 0 then
        return
    end

    return Root
end

local function ResetRootPhysics(Root)
    if not Root
    or not Root.Parent then
        return
    end

    Root.AssemblyLinearVelocity =
        Vector3.zero

    Root.AssemblyAngularVelocity =
        Vector3.zero
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

    for _, Object in ipairs(
        Workspace:GetChildren()
    ) do
        local Container =
            Object:FindFirstChild(
                "CoinContainer"
            )

        if Object:GetAttribute("MapID") ~= nil
        and Container then

            CachedMap =
                Object

            CachedContainer =
                Container

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
        Coin:FindFirstChild(
            "CoinVisual"
        )

    if not Visual
    or Visual:GetAttribute("Collected") == true then
        return
    end

    return Visual
end

local function GetNearestCoin(
    Root,
    Container
)
    local Closest
    local ClosestVisual

    local ClosestDistance =
        math.huge

    local Now =
        os.clock()

    for _, Coin in ipairs(
        Container:GetChildren()
    ) do
        local BlockedUntil =
            BlockedCoins[Coin]

        if BlockedUntil
        and BlockedUntil <= Now then
            BlockedCoins[Coin] =
                nil

            BlockedUntil =
                nil
        end

        if not Coin.Parent then
            BlockedCoins[Coin] =
                nil

        elseif not BlockedUntil then
            local Visual =
                GetCoinVisual(Coin)

            if Visual then
                local Distance =
                    (
                        Root.Position
                        - Coin.Position
                    ).Magnitude

                if Distance < ClosestDistance then
                    Closest =
                        Coin

                    ClosestVisual =
                        Visual

                    ClosestDistance =
                        Distance
                end
            end
        end
    end

    return
        Closest,
        ClosestVisual
end

local function CancelCoinMovement()
    local Tween =
        CurrentTween

    CurrentTween =
        nil

    if Tween then
        pcall(function()
            Tween:Cancel()
        end)
    end
end

local function MoveToCoin(
    Root,
    Coin,
    Visual,
    ID
)
    if not Root.Parent
    or not Coin.Parent
    or not Visual.Parent
    or not Farming
    or ID ~= FarmID then
        return false, false
    end

    local Position =
        Coin.Position

    local Distance =
        (
            Root.Position
            - Position
        ).Magnitude

    if Distance <= ARRIVE_DISTANCE then
        return
            true,
            false,
            Position
    end

    local Duration =
        math.max(
            Distance / FARM_SPEED,
            0.03
        )

    local Tween =
        TweenService:Create(
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

    CurrentTween =
        Tween

    local Finished =
        false

    local State

    local Connection =
        Tween.Completed:Connect(
            function(NewState)
                State =
                    NewState

                Finished =
                    true
            end
        )

    Tween:Play()

    local Deadline =
        os.clock()
        + Duration
        + 0.75

    while Farming
    and ID == FarmID
    and not Finished do

        if not Root.Parent
        or LP:GetAttribute("Alive") ~= true then
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
        CurrentTween =
            nil
    end

    if not Farming
    or ID ~= FarmID
    or not Root.Parent then
        return
            false,
            false,
            Position
    end

    local Near =
        (
            Root.Position
            - Position
        ).Magnitude
        <= CLAIM_DISTANCE

    local Collected =
        not Coin.Parent
        or not Visual.Parent
        or Visual:GetAttribute("Collected") == true

    if Collected then
        return
            Near,
            Near,
            Position
    end

    return
        (
            State == Enum.PlaybackState.Completed
            and Near
        ),
        false,
        Position
end

local function WaitForCoin(
    Coin,
    Visual,
    Root,
    Position,
    ID
)
    local Deadline =
        os.clock()
        + CLAIM_TIMEOUT

    while Farming
    and ID == FarmID do

        if not Root.Parent
        or LP:GetAttribute("Alive") ~= true then
            return false
        end

        local Near =
            (
                Root.Position
                - Position
            ).Magnitude
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
    Farming =
        false

    FarmID += 1

    CancelCoinMovement()
end

local function StartCoinFarm()
    StopCoinFarm()

    Farming =
        true

    local ID =
        FarmID

    task.spawn(function()
        while Farming
        and ID == FarmID do

            local Success, Error =
                pcall(function()

                    if LP:GetAttribute("Alive") ~= true then
                        CancelCoinMovement()
                        task.wait(0.25)
                        return
                    end

                    local Root =
                        GetRoot()

                    if not Root then
                        CancelCoinMovement()
                        task.wait(0.2)
                        return
                    end

                    local Container =
                        GetCoinContainer()

                    if not Container then
                        CancelCoinMovement()
                        task.wait(0.35)
                        return
                    end

                    local Coin,
                    Visual =
                        GetNearestCoin(
                            Root,
                            Container
                        )

                    if not Coin
                    or not Visual then
                        task.wait(0.12)
                        return
                    end

                    local Reached,
                    Collected,
                    Position =
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
                            os.clock()
                            + BLOCK_TIME
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

local function GetAimCamera()
    return Workspace.CurrentCamera
end

local function GetAimPart(Player)
    if not Player
    or Player == LP
    or not Player.Character then
        return
    end

    local Character =
        Player.Character

    local Humanoid =
        Character:FindFirstChildOfClass(
            "Humanoid"
        )

    if not Humanoid
    or Humanoid.Health <= 0 then
        return
    end

    return
        Character:FindFirstChild(
            AimSettings.TargetPart
        )
        or Character:FindFirstChild("Head")
        or Character:FindFirstChild(
            "HumanoidRootPart"
        )
end

local function GetScreenCenter()
    local Camera =
        GetAimCamera()

    if not Camera then
        return Vector2.zero
    end

    return
        Camera.ViewportSize
        * 0.5
end

local function IsAimTargetValid(Player)
    local Camera =
        GetAimCamera()

    local Part =
        GetAimPart(Player)

    if not Camera
    or not Part then
        return false
    end

    local Position,
    OnScreen =
        Camera:WorldToViewportPoint(
            Part.Position
        )

    if not OnScreen
    or Position.Z <= 0 then
        return false
    end

    local Distance =
        (
            Vector2.new(
                Position.X,
                Position.Y
            )
            - GetScreenCenter()
        ).Magnitude

    return
        Distance
        <= AimSettings.FOV
end

local function GetClosestAimTarget()
    local Camera =
        GetAimCamera()

    if not Camera then
        return
    end

    local Center =
        GetScreenCenter()

    local Closest

    local ClosestDistance =
        AimSettings.FOV

    for _, Player in ipairs(
        Players:GetPlayers()
    ) do
        if Player ~= LP then
            local Part =
                GetAimPart(Player)

            if Part then
                local Position,
                OnScreen =
                    Camera:WorldToViewportPoint(
                        Part.Position
                    )

                if OnScreen
                and Position.Z > 0 then

                    local Distance =
                        (
                            Vector2.new(
                                Position.X,
                                Position.Y
                            )
                            - Center
                        ).Magnitude

                    if Distance
                    < ClosestDistance then

                        ClosestDistance =
                            Distance

                        Closest =
                            Player
                    end
                end
            end
        end
    end

    return Closest
end

local function ClearAimTarget()
    AimTarget =
        nil
end

local function SetAimEnabled(Value)
    AimSettings.Enabled =
        Value

    if not Value then
        ClearAimTarget()
    end
end

local function GetPlayerNames()
    local List = {}

    for _, Player in ipairs(
        Players:GetPlayers()
    ) do
        if Player ~= LP then
            table.insert(
                List,
                Player.Name
            )
        end
    end

    table.sort(List)

    return List
end

local function GetPlayerFromName(Name)
    if not Name then
        return
    end

    return
        Players:FindFirstChild(Name)
end

local function RefreshPlayerDropdown()
    if not PlayerDropdown then
        return
    end

    PlayerDropdown:Refresh(
        GetPlayerNames()
    )

    if SelectedPlayer
    and not SelectedPlayer.Parent then
        SelectedPlayer =
            nil
    end
end

local function StopTouchFling()
    TouchFlingEnabled =
        false

    TouchFlingSession += 1
end

local function StartTouchFling()
    if TouchFlingEnabled then
        return
    end

    TouchFlingEnabled =
        true

    TouchFlingSession += 1

    local Session =
        TouchFlingSession

    TouchFlingThread =
        task.spawn(function()

            local Character
            local Root
            local Velocity
            local MoveL = 0.1

            while TouchFlingEnabled
            and Session == TouchFlingSession do

                RunService.Heartbeat:Wait()

                if not TouchFlingEnabled
                or Session ~= TouchFlingSession then
                    break
                end

                Character =
                    LP.Character

                Root =
                    Character
                    and Character:FindFirstChild(
                        "HumanoidRootPart"
                    )

                if Root then
                    Velocity =
                        Root.AssemblyLinearVelocity

                    Root.AssemblyLinearVelocity =
                        Velocity * 10000
                        + Vector3.new(
                            0,
                            10000,
                            0
                        )

                    RunService.RenderStepped:Wait()

                    if not TouchFlingEnabled
                    or Session ~= TouchFlingSession
                    or not Root.Parent then
                        break
                    end

                    Root.AssemblyLinearVelocity =
                        Velocity

                    RunService.Stepped:Wait()

                    if not TouchFlingEnabled
                    or Session ~= TouchFlingSession
                    or not Root.Parent then
                        break
                    end

                    Root.AssemblyLinearVelocity =
                        Velocity
                        + Vector3.new(
                            0,
                            MoveL,
                            0
                        )

                    MoveL =
                        -MoveL
                end
            end

            if Session == TouchFlingSession then
                TouchFlingThread =
                    nil
            end
        end)
end

local function StopFollowPlayer(TeleportBack)
    local WasActive =
        FollowActive
        or FollowConnection ~= nil

    FollowActive =
        false

    FollowSession += 1

    if FollowConnection then
        FollowConnection:Disconnect()
        FollowConnection =
            nil
    end

    if not WasActive then
        FollowOriginalCFrame =
            nil

        return
    end

    StopTouchFling()

    local Root =
        GetRoot()

    if Root then
        ResetRootPhysics(Root)

        if TeleportBack
        and FollowOriginalCFrame then
            Root.CFrame =
                FollowOriginalCFrame

            ResetRootPhysics(Root)
        end
    end

    FollowOriginalCFrame =
        nil
end

local function StopFlingAll(TeleportBack)
    local WasActive =
        FlingAllActive
        or FlingAllThread ~= nil

    FlingAllActive =
        false

    FlingAllSession += 1

    if not WasActive then
        FlingAllOriginalCFrame =
            nil

        return
    end

    StopTouchFling()

    local Root =
        GetRoot()

    if Root then
        ResetRootPhysics(Root)

        if TeleportBack
        and FlingAllOriginalCFrame then

            Root.CFrame =
                FlingAllOriginalCFrame

            ResetRootPhysics(Root)
        end
    end

    FlingAllOriginalCFrame =
        nil

    FlingAllThread =
        nil
end

local function FollowAndFlingPlayer(Player)
    if not Player
    or Player == LP
    or not Player.Parent then
        return
    end

    if FlingAllActive then
        StopFlingAll(true)
    end

    if FollowActive then
        StopFollowPlayer(true)
    end

    local Root =
        GetRoot()

    if not Root then
        return
    end

    FollowOriginalCFrame =
        Root.CFrame

    FollowActive =
        true

    FollowSession += 1

    local Session =
        FollowSession

    StartTouchFling()

    FollowConnection =
        RunService.Heartbeat:Connect(
            function()

                if not FollowActive
                or Session ~= FollowSession then
                    return
                end

                if not Player.Parent then
                    StopFollowPlayer(true)
                    return
                end

                local MyCharacter =
                    LP.Character

                local TargetCharacter =
                    Player.Character

                if not MyCharacter
                or not TargetCharacter then
                    StopFollowPlayer(true)
                    return
                end

                local MyRoot =
                    MyCharacter:FindFirstChild(
                        "HumanoidRootPart"
                    )

                local TargetRoot =
                    TargetCharacter:FindFirstChild(
                        "HumanoidRootPart"
                    )

                local TargetHumanoid =
                    TargetCharacter:FindFirstChildOfClass(
                        "Humanoid"
                    )

                if not MyRoot
                or not TargetRoot
                or not TargetHumanoid
                or TargetHumanoid.Health <= 0 then

                    StopFollowPlayer(true)
                    return
                end

                MyRoot.CFrame =
                    TargetRoot.CFrame
                    * CFrame.Angles(
                        math.rad(90),
                        0,
                        math.rad(180)
                    )

                if
                    TargetRoot
                        .AssemblyLinearVelocity
                        .Magnitude
                    >= MAX_TARGET_SPEED
                then
                    StopFollowPlayer(true)
                end
            end
        )
end

local function FlingAllPlayers()
    if FlingAllActive then
        StopFlingAll(true)
        return
    end

    if FollowActive then
        StopFollowPlayer(true)
    end

    local Root =
        GetRoot()

    if not Root then
        return
    end

    FlingAllOriginalCFrame =
        Root.CFrame

    FlingAllActive =
        true

    FlingAllSession += 1

    local Session =
        FlingAllSession

    StartTouchFling()

    FlingAllThread =
        task.spawn(function()

            local Targets = {}

            for _, Player in ipairs(
                Players:GetPlayers()
            ) do
                if Player ~= LP then
                    table.insert(
                        Targets,
                        Player
                    )
                end
            end

            for _, TargetPlayer in ipairs(Targets) do
                if not FlingAllActive
                or Session ~= FlingAllSession then
                    break
                end

                if TargetPlayer.Parent then
                    local StartTime =
                        os.clock()

                    while FlingAllActive
                    and Session == FlingAllSession
                    and TargetPlayer.Parent do

                        RunService.Heartbeat:Wait()

                        if not FlingAllActive
                        or Session ~= FlingAllSession then
                            break
                        end

                        local MyCharacter =
                            LP.Character

                        local TargetCharacter =
                            TargetPlayer.Character

                        if not MyCharacter
                        or not TargetCharacter then
                            break
                        end

                        local MyRoot =
                            MyCharacter:FindFirstChild(
                                "HumanoidRootPart"
                            )

                        local TargetRoot =
                            TargetCharacter:FindFirstChild(
                                "HumanoidRootPart"
                            )

                        local TargetHumanoid =
                            TargetCharacter:FindFirstChildOfClass(
                                "Humanoid"
                            )

                        if not MyRoot
                        or not TargetRoot
                        or not TargetHumanoid
                        or TargetHumanoid.Health <= 0 then
                            break
                        end

                        MyRoot.CFrame =
                            TargetRoot.CFrame
                            * CFrame.Angles(
                                math.rad(90),
                                0,
                                math.rad(180)
                            )

                        if
                            TargetRoot
                                .AssemblyLinearVelocity
                                .Magnitude
                            >= MAX_TARGET_SPEED
                        then
                            break
                        end

                        if
                            os.clock()
                            - StartTime
                            >= TIME_PER_PLAYER
                        then
                            break
                        end
                    end

                    if FlingAllActive
                    and Session == FlingAllSession then
                        task.wait(0.1)
                    end
                end
            end

            if FlingAllActive
            and Session == FlingAllSession then
                StopFlingAll(true)
            end
        end)
end

RunService.RenderStepped:Connect(function()
    if not AimSettings.Enabled then
        return
    end

    local Camera =
        GetAimCamera()

    if not Camera then
        return
    end

    if not IsAimTargetValid(AimTarget) then
        AimTarget =
            GetClosestAimTarget()
    end

    local TargetPart =
        GetAimPart(AimTarget)

    if not TargetPart then
        return
    end

    local Current =
        Camera.CFrame

    local Direction =
        TargetPart.Position
        - Current.Position

    if Direction.Magnitude <= 0.001 then
        return
    end

    local Desired =
        CFrame.lookAt(
            Current.Position,
            TargetPart.Position
        )

    Camera.CFrame =
        Current:Lerp(
            Desired,

            math.clamp(
                AimSettings.Smoothness,
                0.01,
                1
            )
        )
end)

Players.PlayerAdded:Connect(function()
    task.defer(
        RefreshPlayerDropdown
    )
end)

Players.PlayerRemoving:Connect(function(Player)
    if Player == AimTarget then
        ClearAimTarget()
    end

    if Player == SelectedPlayer then
        SelectedPlayer =
            nil

        if FollowActive then
            StopFollowPlayer(true)
        end
    end

    task.defer(
        RefreshPlayerDropdown
    )
end)

LP.CharacterRemoving:Connect(function()
    CancelCoinMovement()
    ClearAimTarget()

    StopFollowPlayer(false)
    StopFlingAll(false)
    StopTouchFling()
end)

LP:GetAttributeChangedSignal(
    "Alive"
):Connect(function()

    if LP:GetAttribute("Alive") ~= true then
        CancelCoinMovement()
        ClearAimTarget()

        StopFollowPlayer(false)
        StopFlingAll(false)
        StopTouchFling()
    end
end)

ServerInfo = InfoTab:Paragraph({
    Title = "Server Information",
    Desc = "Loading...",

    Buttons = {
        {
            Icon = "copy",
            Title = "Copy Job ID",

            Callback = function()
                if typeof(setclipboard) == "function" then
                    setclipboard(
                        game.JobId
                    )
                end
            end,
        }
    }
})

GameInfo = InfoTab:Paragraph({
    Title = "Game Information",
    Desc = "Loading..."
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

MainTab:Toggle({
    Title = "Aim Assist",
    Desc = "Automatically aims at nearby players",
    Value = false,

    Callback = function(Value)
        SetAimEnabled(Value)
    end
})

MainTab:Dropdown({
    Title = "Aim Part",
    Desc = "Choose which body part to target",

    Values = {
        "Head",
        "HumanoidRootPart",
        "UpperTorso",
        "LowerTorso",
        "Torso"
    },

    Value = "Head",

    Callback = function(Value)
        if type(Value) == "table" then
            Value =
                Value.Value
                or Value.Title
                or Value[1]
        end

        AimSettings.TargetPart =
            Value
            or "Head"

        ClearAimTarget()
    end
})

MainTab:Slider({
    Title = "Aim Smoothness",
    Desc = "Controls aim movement speed",

    Step = 1,

    Value = {
        Min = 1,
        Max = 100,
        Default = 18
    },

    Callback = function(Value)
        AimSettings.Smoothness =
            math.clamp(
                Value / 100,
                0.01,
                1
            )
    end
})

MainTab:Slider({
    Title = "Aim FOV",
    Desc = "Target acquisition radius",

    Step = 5,

    Value = {
        Min = 50,
        Max = 600,
        Default = 250
    },

    Callback = function(Value)
        AimSettings.FOV =
            Value

        ClearAimTarget()
    end
})

PlayerDropdown = MainTab:Dropdown({
    Title = "Select Player",
    Desc = "Select a player",

    Values = GetPlayerNames(),

    AllowNone = true,
    SearchBarEnabled = true,

    Callback = function(Value)
        if type(Value) == "table" then
            Value =
                Value.Value
                or Value.Title
                or Value[1]
        end

        SelectedPlayer =
            GetPlayerFromName(Value)
    end
})

MainTab:Button({
    Title = "Fling Player",
    Desc = "Fling the selected player",
    Icon = "zap",

    Callback = function()
        FollowAndFlingPlayer(
            SelectedPlayer
        )
    end
})

MainTab:Button({
    Title = "Stop Fling",
    Desc = "Stop and return to your original position",
    Icon = "x",

    Callback = function()
        StopFollowPlayer(true)
    end
})

MainTab:Button({
    Title = "Fling All Server",
    Desc = "Fling every player in the server",
    Icon = "users",

    Callback = function()
        FlingAllPlayers()
    end
})

MainTab:Button({
    Title = "Stop Fling All",
    Desc = "Stop and return to your original position",
    Icon = "x",

    Callback = function()
        StopFlingAll(true)
    end
})

Executor =
    GetExecutor()

InfoTab:Select()

UpdateInfo()

task.spawn(function()
    while task.wait(1) do
        UpdateInfo()
    end
end)

--// ABA MAIN FINALIZADA \\--

local ESPColors = {
    Murderer = Color3.fromRGB(255, 70, 70),
    Sheriff = Color3.fromRGB(70, 150, 255),
    Hero = Color3.fromRGB(70, 150, 255),
    Innocent = Color3.fromRGB(80, 255, 120)
}

local ESPSettings = {
    Enabled = false,
    Mode = "Highlight",

    Box = true,
    Name = true,
    Role = true,
    Distance = true,
    Tracer = false,

    Murderer = true,
    Sheriff = true,
    Innocent = true,

    MaxDistance = 1000,

    TracerOrigin = "Bottom",

    HighlightFillTransparency = 0.72,
    HighlightOutlineTransparency = 0,

    DrawingThickness = 2,
    TextSize = 13
}

local ESPObjects = {}
local ESPAccumulator = 0
local ESP_UPDATE_RATE = 1 / 30

local function GetESPDropdownValue(Value)
    if type(Value) == "table" then
        return
            Value.Value
            or Value.Title
            or Value[1]
    end

    return Value
end

local function NormalizeESPRole(Role)
    if Role == "Murderer" then
        return "Murderer"
    end

    if Role == "Sheriff"
    or Role == "Hero" then
        return "Sheriff"
    end

    return "Innocent"
end

local function GetESPColor(Role)
    return
        ESPColors[Role]
        or ESPColors[
            NormalizeESPRole(Role)
        ]
        or ESPColors.Innocent
end

local function IsESPRoleEnabled(Role)
    local Normalized =
        NormalizeESPRole(Role)

    if Normalized == "Murderer" then
        return ESPSettings.Murderer
    end

    if Normalized == "Sheriff" then
        return ESPSettings.Sheriff
    end

    return ESPSettings.Innocent
end

local function HasDrawingSupport()
    return
        typeof(Drawing) == "table"
        and typeof(Drawing.new) == "function"
end

local function NewDrawing(Type)
    if not HasDrawingSupport() then
        return
    end

    local Success, Object =
        pcall(function()
            return Drawing.new(Type)
        end)

    if Success then
        return Object
    end
end

local function RemoveDrawing(Object)
    if not Object then
        return
    end

    pcall(function()
        Object:Remove()
    end)
end

local function HideDrawings(Drawings)
    if not Drawings then
        return
    end

    for _, Object in pairs(Drawings) do
        if Object then
            pcall(function()
                Object.Visible = false
            end)
        end
    end
end

local function DestroyDrawings(Drawings)
    if not Drawings then
        return
    end

    for _, Object in pairs(Drawings) do
        RemoveDrawing(Object)
    end
end

local function GetESPData(Player)
    local Data =
        ESPObjects[Player]

    if Data then
        return Data
    end

    Data = {
        Highlight = nil,
        HighlightCharacter = nil,
        Drawings = nil
    }

    ESPObjects[Player] =
        Data

    return Data
end

local function EnsureDrawings(Player)
    local Data =
        GetESPData(Player)

    if Data.Drawings then
        return Data.Drawings
    end

    if not HasDrawingSupport() then
        return
    end

    local Box =
        NewDrawing("Square")

    local Name =
        NewDrawing("Text")

    local Role =
        NewDrawing("Text")

    local Distance =
        NewDrawing("Text")

    local Tracer =
        NewDrawing("Line")

    if not Box
    or not Name
    or not Role
    or not Distance
    or not Tracer then

        RemoveDrawing(Box)
        RemoveDrawing(Name)
        RemoveDrawing(Role)
        RemoveDrawing(Distance)
        RemoveDrawing(Tracer)

        return
    end

    Box.Visible = false
    Box.Filled = false
    Box.Transparency = 1

    Name.Visible = false
    Name.Center = true
    Name.Outline = true
    Name.Transparency = 1

    Role.Visible = false
    Role.Center = true
    Role.Outline = true
    Role.Transparency = 1

    Distance.Visible = false
    Distance.Center = true
    Distance.Outline = true
    Distance.Transparency = 1

    Tracer.Visible = false
    Tracer.Transparency = 1

    Data.Drawings = {
        Box = Box,
        Name = Name,
        Role = Role,
        Distance = Distance,
        Tracer = Tracer
    }

    return Data.Drawings
end

local function DestroyHighlight(Data)
    if not Data then
        return
    end

    if Data.Highlight then
        pcall(function()
            Data.Highlight:Destroy()
        end)
    end

    Data.Highlight =
        nil

    Data.HighlightCharacter =
        nil
end

local function EnsureHighlight(
    Player,
    Character
)
    local Data =
        GetESPData(Player)

    if Data.Highlight
    and Data.Highlight.Parent
    and Data.HighlightCharacter == Character then
        return Data.Highlight
    end

    DestroyHighlight(Data)

    local Highlight =
        Instance.new("Highlight")

    Highlight.Name =
        "MirrorsHubESP"

    Highlight.Adornee =
        Character

    Highlight.DepthMode =
        Enum.HighlightDepthMode.AlwaysOnTop

    Highlight.FillTransparency =
        ESPSettings.HighlightFillTransparency

    Highlight.OutlineTransparency =
        ESPSettings.HighlightOutlineTransparency

    Highlight.Enabled =
        false

    Highlight.Parent =
        Character

    Data.Highlight =
        Highlight

    Data.HighlightCharacter =
        Character

    return Highlight
end

local function HideESPPlayer(Player)
    local Data =
        ESPObjects[Player]

    if not Data then
        return
    end

    if Data.Highlight then
        Data.Highlight.Enabled =
            false
    end

    HideDrawings(
        Data.Drawings
    )
end

local function DestroyESPPlayer(Player)
    local Data =
        ESPObjects[Player]

    if not Data then
        return
    end

    DestroyHighlight(Data)

    DestroyDrawings(
        Data.Drawings
    )

    ESPObjects[Player] =
        nil
end

local function DestroyAllESP()
    for Player in pairs(ESPObjects) do
        DestroyESPPlayer(Player)
    end
end

local function HideAllESP()
    for Player in pairs(ESPObjects) do
        HideESPPlayer(Player)
    end
end

local function GetESPCharacter(Player)
    if not Player
    or Player == LP then
        return
    end

    local Character =
        Player.Character

    if not Character then
        return
    end

    local Root =
        Character:FindFirstChild(
            "HumanoidRootPart"
        )

    local Humanoid =
        Character:FindFirstChildOfClass(
            "Humanoid"
        )

    if not Root
    or not Humanoid
    or Humanoid.Health <= 0 then
        return
    end

    return
        Character,
        Root,
        Humanoid
end

local function GetESPDistance(
    TargetRoot,
    Camera
)
    local MyRoot =
        LP.Character
        and LP.Character:FindFirstChild(
            "HumanoidRootPart"
        )

    if MyRoot then
        return
            (
                MyRoot.Position
                - TargetRoot.Position
            ).Magnitude
    end

    return
        (
            Camera.CFrame.Position
            - TargetRoot.Position
        ).Magnitude
end

local function GetCharacterScreenBounds(
    Character,
    Camera
)
    local Success,
    BoundingCFrame,
    BoundingSize =
        pcall(function()
            local CF, Size =
                Character:GetBoundingBox()

            return CF, Size
        end)

    if not Success
    or not BoundingCFrame
    or not BoundingSize then
        return
    end

    local MinX =
        math.huge

    local MinY =
        math.huge

    local MaxX =
        -math.huge

    local MaxY =
        -math.huge

    local VisiblePoints =
        0

    for X = -1, 1, 2 do
        for Y = -1, 1, 2 do
            for Z = -1, 1, 2 do
                local WorldPosition =
                    (
                        BoundingCFrame
                        * CFrame.new(
                            BoundingSize.X
                            * 0.5
                            * X,

                            BoundingSize.Y
                            * 0.5
                            * Y,

                            BoundingSize.Z
                            * 0.5
                            * Z
                        )
                    ).Position

                local ScreenPosition =
                    Camera:WorldToViewportPoint(
                        WorldPosition
                    )

                if ScreenPosition.Z > 0 then
                    VisiblePoints += 1

                    MinX =
                        math.min(
                            MinX,
                            ScreenPosition.X
                        )

                    MinY =
                        math.min(
                            MinY,
                            ScreenPosition.Y
                        )

                    MaxX =
                        math.max(
                            MaxX,
                            ScreenPosition.X
                        )

                    MaxY =
                        math.max(
                            MaxY,
                            ScreenPosition.Y
                        )
                end
            end
        end
    end

    if VisiblePoints == 0 then
        return
    end

    if MaxX <= MinX
    or MaxY <= MinY then
        return
    end

    return
        MinX,
        MinY,
        MaxX,
        MaxY
end

local function GetTracerOrigin(Camera)
    local Viewport =
        Camera.ViewportSize

    if ESPSettings.TracerOrigin == "Center" then
        return Vector2.new(
            Viewport.X * 0.5,
            Viewport.Y * 0.5
        )
    end

    if ESPSettings.TracerOrigin == "Top" then
        return Vector2.new(
            Viewport.X * 0.5,
            0
        )
    end

    return Vector2.new(
        Viewport.X * 0.5,
        Viewport.Y
    )
end

local function GetESPDisplayName(Player)
    if Player.DisplayName
    and Player.DisplayName ~= Player.Name then

        return
            Player.DisplayName
            .. " (@"
            .. Player.Name
            .. ")"
    end

    return Player.Name
end

local function UpdateHighlightESP(
    Player,
    Character,
    Role,
    Color
)
    local Data =
        GetESPData(Player)

    local UseHighlight =
        ESPSettings.Mode == "Highlight"
        or ESPSettings.Mode == "Both"

    if not UseHighlight then
        if Data.Highlight then
            Data.Highlight.Enabled =
                false
        end

        return
    end

    local Highlight =
        EnsureHighlight(
            Player,
            Character
        )

    if not Highlight then
        return
    end

    Highlight.FillColor =
        Color

    Highlight.OutlineColor =
        Color

    Highlight.FillTransparency =
        ESPSettings.HighlightFillTransparency

    Highlight.OutlineTransparency =
        ESPSettings.HighlightOutlineTransparency

    Highlight.Enabled =
        true
end

local function UpdateDrawingESP(
    Player,
    Character,
    Role,
    Color,
    Distance,
    Camera
)
    local Data =
        GetESPData(Player)

    local UseDrawing =
        ESPSettings.Mode == "Drawing"
        or ESPSettings.Mode == "Both"

    if not UseDrawing then
        HideDrawings(
            Data.Drawings
        )

        return
    end

    local Drawings =
        EnsureDrawings(Player)

    if not Drawings then
        return
    end

    local MinX,
    MinY,
    MaxX,
    MaxY =
        GetCharacterScreenBounds(
            Character,
            Camera
        )

    if not MinX then
        HideDrawings(Drawings)
        return
    end

    local Width =
        MaxX - MinX

    local Height =
        MaxY - MinY

    if Width <= 1
    or Height <= 1 then
        HideDrawings(Drawings)
        return
    end

    local CenterX =
        MinX + Width * 0.5

    local CenterY =
        MinY + Height * 0.5

    local TextSize =
        ESPSettings.TextSize

    local LineHeight =
        TextSize + 2

    Drawings.Box.Color =
        Color

    Drawings.Box.Thickness =
        ESPSettings.DrawingThickness

    Drawings.Box.Position =
        Vector2.new(
            MinX,
            MinY
        )

    Drawings.Box.Size =
        Vector2.new(
            Width,
            Height
        )

    Drawings.Box.Visible =
        ESPSettings.Box

    Drawings.Name.Color =
        Color

    Drawings.Name.Size =
        TextSize

    Drawings.Name.Text =
        GetESPDisplayName(
            Player
        )

    Drawings.Name.Position =
        Vector2.new(
            CenterX,
            MinY - LineHeight
        )

    Drawings.Name.Visible =
        ESPSettings.Name

    local BottomOffset =
        2

    Drawings.Role.Color =
        Color

    Drawings.Role.Size =
        TextSize

    Drawings.Role.Text =
        tostring(Role)

    Drawings.Role.Position =
        Vector2.new(
            CenterX,
            MaxY + BottomOffset
        )

    Drawings.Role.Visible =
        ESPSettings.Role

    if ESPSettings.Role then
        BottomOffset +=
            LineHeight
    end

    Drawings.Distance.Color =
        Color

    Drawings.Distance.Size =
        TextSize

    Drawings.Distance.Text =
        tostring(
            math.floor(
                Distance + 0.5
            )
        )
        .. " studs"

    Drawings.Distance.Position =
        Vector2.new(
            CenterX,
            MaxY + BottomOffset
        )

    Drawings.Distance.Visible =
        ESPSettings.Distance

    Drawings.Tracer.Color =
        Color

    Drawings.Tracer.Thickness =
        ESPSettings.DrawingThickness

    Drawings.Tracer.From =
        GetTracerOrigin(
            Camera
        )

    Drawings.Tracer.To =
        Vector2.new(
            CenterX,
            CenterY
        )

    Drawings.Tracer.Visible =
        ESPSettings.Tracer
end

local function UpdateESPPlayer(
    Player,
    Camera
)
    if Player == LP then
        return
    end

    local Character,
    Root =
        GetESPCharacter(Player)

    if not Character
    or not Root then
        HideESPPlayer(Player)
        return
    end

    local Role =
        GetRole(Player)

    if not IsESPRoleEnabled(Role) then
        HideESPPlayer(Player)
        return
    end

    local Distance =
        GetESPDistance(
            Root,
            Camera
        )

    if Distance
    > ESPSettings.MaxDistance then
        HideESPPlayer(Player)
        return
    end

    local Color =
        GetESPColor(Role)

    UpdateHighlightESP(
        Player,
        Character,
        Role,
        Color
    )

    UpdateDrawingESP(
        Player,
        Character,
        Role,
        Color,
        Distance,
        Camera
    )
end

local function UpdateESP()
    if not ESPSettings.Enabled then
        return
    end

    local Camera =
        Workspace.CurrentCamera

    if not Camera then
        return
    end

    for _, Player in ipairs(
        Players:GetPlayers()
    ) do
        if Player ~= LP then
            UpdateESPPlayer(
                Player,
                Camera
            )
        end
    end
end

local function RefreshESP()
    if not ESPSettings.Enabled then
        HideAllESP()
        return
    end

    UpdateESP()
end

local function SetESPEnabled(Value)
    ESPSettings.Enabled =
        Value

    if not Value then
        HideAllESP()
        return
    end

    RefreshESP()
end

RunService.RenderStepped:Connect(function(DeltaTime)
    if not ESPSettings.Enabled then
        return
    end

    ESPAccumulator +=
        DeltaTime

    if ESPAccumulator
    < ESP_UPDATE_RATE then
        return
    end

    ESPAccumulator =
        0

    UpdateESP()
end)

Players.PlayerRemoving:Connect(function(Player)
    DestroyESPPlayer(Player)
end)

EspTab:Paragraph({
    Title = "MM2 Role ESP",
    Desc =
        "Murderer: Red"
        .. "\nSheriff / Hero: Blue"
        .. "\nInnocent: Green"
})

EspTab:Toggle({
    Title = "Enable ESP",
    Desc = "Enable player ESP",
    Value = false,

    Callback = function(Value)
        SetESPEnabled(Value)
    end
})

EspTab:Dropdown({
    Title = "ESP Mode",
    Desc = "Choose the ESP rendering mode",

    Values = {
        "Highlight",
        "Drawing",
        "Both"
    },

    Value = "Highlight",

    Callback = function(Value)
        Value =
            GetESPDropdownValue(
                Value
            )

        ESPSettings.Mode =
            Value
            or "Highlight"

        RefreshESP()
    end
})

EspTab:Toggle({
    Title = "Box",
    Desc = "Draw a box around players",
    Value = true,

    Callback = function(Value)
        ESPSettings.Box =
            Value

        RefreshESP()
    end
})

EspTab:Toggle({
    Title = "Name",
    Desc = "Show player names",
    Value = true,

    Callback = function(Value)
        ESPSettings.Name =
            Value

        RefreshESP()
    end
})

EspTab:Toggle({
    Title = "Role",
    Desc = "Show Murderer, Sheriff, Hero or Innocent",
    Value = true,

    Callback = function(Value)
        ESPSettings.Role =
            Value

        RefreshESP()
    end
})

EspTab:Toggle({
    Title = "Distance",
    Desc = "Show distance in studs",
    Value = true,

    Callback = function(Value)
        ESPSettings.Distance =
            Value

        RefreshESP()
    end
})

EspTab:Toggle({
    Title = "Tracer",
    Desc = "Draw a line to players",
    Value = false,

    Callback = function(Value)
        ESPSettings.Tracer =
            Value

        RefreshESP()
    end
})

EspTab:Dropdown({
    Title = "Tracer Origin",
    Desc = "Choose where tracers start",

    Values = {
        "Bottom",
        "Center",
        "Top"
    },

    Value = "Bottom",

    Callback = function(Value)
        Value =
            GetESPDropdownValue(
                Value
            )

        ESPSettings.TracerOrigin =
            Value
            or "Bottom"
    end
})

EspTab:Slider({
    Title = "Max Distance",
    Desc = "Maximum ESP render distance",

    Step = 50,

    Value = {
        Min = 50,
        Max = 2500,
        Default = 1000
    },

    Callback = function(Value)
        ESPSettings.MaxDistance =
            Value

        RefreshESP()
    end
})

EspTab:Slider({
    Title = "Drawing Thickness",
    Desc = "Box and tracer thickness",

    Step = 1,

    Value = {
        Min = 1,
        Max = 4,
        Default = 2
    },

    Callback = function(Value)
        ESPSettings.DrawingThickness =
            Value
    end
})

EspTab:Slider({
    Title = "Text Size",
    Desc = "Drawing ESP text size",

    Step = 1,

    Value = {
        Min = 10,
        Max = 20,
        Default = 13
    },

    Callback = function(Value)
        ESPSettings.TextSize =
            Value
    end
})

EspTab:Slider({
    Title = "Highlight Transparency",
    Desc = "Controls highlight fill transparency",

    Step = 5,

    Value = {
        Min = 0,
        Max = 100,
        Default = 70
    },

    Callback = function(Value)
        ESPSettings.HighlightFillTransparency =
            math.clamp(
                Value / 100,
                0,
                1
            )

        RefreshESP()
    end
})

EspTab:Toggle({
    Title = "Murderer ESP",
    Desc = "Show Murderer players",
    Value = true,

    Callback = function(Value)
        ESPSettings.Murderer =
            Value

        RefreshESP()
    end
})

EspTab:Toggle({
    Title = "Sheriff ESP",
    Desc = "Show Sheriff and Hero players",
    Value = true,

    Callback = function(Value)
        ESPSettings.Sheriff =
            Value

        RefreshESP()
    end
})

EspTab:Toggle({
    Title = "Innocent ESP",
    Desc = "Show Innocent players",
    Value = true,

    Callback = function(Value)
        ESPSettings.Innocent =
            Value

        RefreshESP()
    end
})

--// ABA ESP TERMINADA \\--

local MurderSettings = {
    KnifeAura = false,
    KnifeAuraRange = 15,

    ThrowAssist = false,

    AutoThrow = false,
    AutoThrowCooldown = 1.15,

    Prediction = 0.12,
    HitCooldown = 0.12
}

local MurderSelectedPlayer
local MurderPlayerDropdown

local MurderLastHit = {}
local MurderLastAutoThrow = 0
local MurderLastAssistThrow = 0

local MurderThrowButton
local MurderThrowConnection

local function GetMurderKnife()
    local Character = LP.Character

    if not Character then
        return
    end

    local Knife = Character:FindFirstChild("Knife")

    if Knife and Knife:IsA("Tool") then
        return Knife
    end

    for _, Object in ipairs(Character:GetChildren()) do
        if Object:IsA("Tool")
        and Object:GetAttribute("IsKnife") == true then
            return Object
        end
    end
end

local function GetMurderRemote(Name)
    local Knife = GetMurderKnife()

    if not Knife then
        return
    end

    local Events = Knife:FindFirstChild("Events")

    if not Events then
        return
    end

    local Remote = Events:FindFirstChild(Name)

    if Remote
    and Remote:IsA("RemoteEvent") then
        return Remote, Knife
    end
end

local function IsMurderPlayerAlive(Player)
    if not Player
    or Player == LP
    or not Player.Parent then
        return false
    end

    local Character = Player.Character

    if not Character then
        return false
    end

    local Humanoid =
        Character:FindFirstChildOfClass("Humanoid")

    if not Humanoid
    or Humanoid.Health <= 0 then
        return false
    end

    if Player:GetAttribute("Alive") == false then
        return false
    end

    return true
end

local function GetMurderTargetPart(Player)
    if not IsMurderPlayerAlive(Player) then
        return
    end

    local Character = Player.Character

    return
        Character:FindFirstChild("HumanoidRootPart")
        or Character:FindFirstChild("UpperTorso")
        or Character:FindFirstChild("Torso")
        or Character:FindFirstChild("Head")
end

local function RefreshMurderRoles()
    if typeof(UpdateRoles) == "function" then
        pcall(UpdateRoles)
    end
end

local function GetMurderSheriff()
    RefreshMurderRoles()

    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LP
        and IsMurderPlayerAlive(Player) then
            local Role = GetRole(Player)

            if Role == "Sheriff"
            or Role == "Hero" then
                return Player
            end
        end
    end
end

local function GetNearestMurderPlayer()
    local Character = LP.Character

    local Root =
        Character
        and Character:FindFirstChild("HumanoidRootPart")

    if not Root then
        return
    end

    local Best
    local BestDistance = math.huge

    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LP
        and IsMurderPlayerAlive(Player) then
            local Part =
                GetMurderTargetPart(Player)

            if Part then
                local Distance =
                    (
                        Root.Position
                        - Part.Position
                    ).Magnitude

                if Distance < BestDistance then
                    Best = Player
                    BestDistance = Distance
                end
            end
        end
    end

    return Best
end

local function GetMurderThrowTarget()
    local Sheriff = GetMurderSheriff()

    if Sheriff then
        return Sheriff
    end

    return GetNearestMurderPlayer()
end

local function MurderHitPlayer(Player, IgnoreCooldown)
    local Part =
        GetMurderTargetPart(Player)

    if not Part then
        return false
    end

    local Remote =
        GetMurderRemote("HandleTouched")

    if not Remote then
        return false
    end

    local Now = os.clock()

    if not IgnoreCooldown
    and MurderLastHit[Player]
    and Now - MurderLastHit[Player]
        < MurderSettings.HitCooldown then
        return false
    end

    MurderLastHit[Player] = Now

    local Success =
        pcall(function()
            Remote:FireServer(Part)
        end)

    return Success
end

local function MurderThrowPlayer(Player)
    local Part =
        GetMurderTargetPart(Player)

    if not Part then
        return false
    end

    local Remote, Knife =
        GetMurderRemote("KnifeThrown")

    if not Remote or not Knife then
        return false
    end

    local Handle =
        Knife:FindFirstChild("Handle")
        or Knife:FindFirstChildWhichIsA("BasePart")

    if not Handle then
        return false
    end

    local TargetPosition =
        Part.Position
        + Part.AssemblyLinearVelocity
        * MurderSettings.Prediction

    local Origin =
        Handle.Position

    local ThrowCFrame =
        CFrame.lookAt(
            Origin,
            TargetPosition
        )

    local Success =
        pcall(function()
            Remote:FireServer(
                ThrowCFrame,
                CFrame.new(TargetPosition)
            )
        end)

    return Success
end

local function MurderSilentThrow()
    local Target =
        GetMurderThrowTarget()

    if not Target then
        return false
    end

    return MurderThrowPlayer(Target)
end

local function KillSelectedMurderPlayer()
    if not MurderSelectedPlayer then
        return
    end

    MurderHitPlayer(
        MurderSelectedPlayer,
        true
    )
end

local function KillMurderSheriff()
    local Sheriff =
        GetMurderSheriff()

    if not Sheriff then
        return
    end

    MurderHitPlayer(
        Sheriff,
        true
    )
end

local function KillAllMurderInnocents()
    RefreshMurderRoles()

    task.spawn(function()
        for _, Player in ipairs(Players:GetPlayers()) do
            if Player ~= LP
            and IsMurderPlayerAlive(Player)
            and GetRole(Player) == "Innocent" then
                MurderHitPlayer(
                    Player,
                    true
                )

                task.wait(0.05)
            end
        end
    end)
end

local function KillAllMurderPlayers()
    task.spawn(function()
        for _, Player in ipairs(Players:GetPlayers()) do
            if Player ~= LP
            and IsMurderPlayerAlive(Player) then
                MurderHitPlayer(
                    Player,
                    true
                )

                task.wait(0.05)
            end
        end
    end)
end

local function FlingMurderSheriff()
    local Sheriff =
        GetMurderSheriff()

    if not Sheriff then
        return
    end

    FollowAndFlingPlayer(Sheriff)
end

local function GetMurderPlayerNames()
    local List = {}

    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LP then
            table.insert(
                List,
                Player.Name
            )
        end
    end

    table.sort(List)

    return List
end

local function GetMurderPlayerFromName(Name)
    if not Name then
        return
    end

    return Players:FindFirstChild(Name)
end

local function RefreshMurderPlayerDropdown()
    if not MurderPlayerDropdown then
        return
    end

    MurderPlayerDropdown:Refresh(
        GetMurderPlayerNames()
    )

    if MurderSelectedPlayer
    and not MurderSelectedPlayer.Parent then
        MurderSelectedPlayer = nil
    end
end

local function GetMurderThrowButton()
    local PlayerGui =
        LP:FindFirstChild("PlayerGui")

    if not PlayerGui then
        return
    end

    local Controls =
        PlayerGui:FindFirstChild(
            "GameplayControlsUI"
        )

    if not Controls then
        return
    end

    local Button =
        Controls:FindFirstChild(
            "Throw",
            true
        )

    if Button
    and Button:IsA("GuiButton") then
        return Button
    end
end

local function BindMurderThrowButton()
    local Button =
        GetMurderThrowButton()

    if Button == MurderThrowButton
    and MurderThrowConnection then
        return
    end

    if MurderThrowConnection then
        MurderThrowConnection:Disconnect()
        MurderThrowConnection = nil
    end

    MurderThrowButton = Button

    if not Button then
        return
    end

    MurderThrowConnection =
        Button.MouseButton1Down:Connect(function()
            if not MurderSettings.ThrowAssist then
                return
            end

            local Now = os.clock()

            if Now - MurderLastAssistThrow < 0.15 then
                return
            end

            MurderLastAssistThrow = Now

            task.defer(
                MurderSilentThrow
            )
        end)
end

RunService.Heartbeat:Connect(function()
    if MurderSettings.KnifeAura then
        local Character = LP.Character

        local Root =
            Character
            and Character:FindFirstChild(
                "HumanoidRootPart"
            )

        local Remote =
            GetMurderRemote(
                "HandleTouched"
            )

        if Root and Remote then
            for _, Player in ipairs(
                Players:GetPlayers()
            ) do
                if Player ~= LP
                and IsMurderPlayerAlive(Player) then
                    local Part =
                        GetMurderTargetPart(Player)

                    if Part then
                        local Distance =
                            (
                                Root.Position
                                - Part.Position
                            ).Magnitude

                        if Distance
                        <= MurderSettings.KnifeAuraRange then

                            local Now =
                                os.clock()

                            if not MurderLastHit[Player]
                            or Now
                                - MurderLastHit[Player]
                                >= MurderSettings.HitCooldown then

                                MurderLastHit[Player] =
                                    Now

                                pcall(function()
                                    Remote:FireServer(
                                        Part
                                    )
                                end)
                            end
                        end
                    end
                end
            end
        end
    end

    if MurderSettings.AutoThrow then
        local Now = os.clock()

        if Now - MurderLastAutoThrow
        >= MurderSettings.AutoThrowCooldown then

            if MurderSilentThrow() then
                MurderLastAutoThrow = Now
            end
        end
    end
end)

Players.PlayerAdded:Connect(function()
    task.defer(
        RefreshMurderPlayerDropdown
    )
end)

Players.PlayerRemoving:Connect(function(Player)
    MurderLastHit[Player] = nil

    if Player == MurderSelectedPlayer then
        MurderSelectedPlayer = nil
    end

    task.defer(
        RefreshMurderPlayerDropdown
    )
end)

LP.CharacterAdded:Connect(function()
    table.clear(MurderLastHit)

    task.delay(
        1,
        BindMurderThrowButton
    )
end)

LP.CharacterRemoving:Connect(function()
    table.clear(MurderLastHit)

    MurderLastAutoThrow = 0
end)

local MurderPlayerGui =
    LP:WaitForChild("PlayerGui")

MurderPlayerGui.DescendantAdded:Connect(function(Object)
    if Object.Name == "Throw"
    and Object:IsA("GuiButton") then
        task.defer(
            BindMurderThrowButton
        )
    end
end)

MurderTab:Toggle({
    Title = "Knife Aura",
    Desc = "Automatically kills players inside the selected range",
    Value = false,

    Callback = function(Value)
        MurderSettings.KnifeAura = Value

        if not Value then
            table.clear(MurderLastHit)
        end
    end
})

MurderTab:Slider({
    Title = "Knife Aura Range",
    Desc = "Maximum Knife Aura distance",
    Step = 1,

    Value = {
        Min = 2,
        Max = 50,
        Default = 15
    },

    Callback = function(Value)
        MurderSettings.KnifeAuraRange =
            math.clamp(
                Value,
                2,
                50
            )
    end
})

MurderTab:Toggle({
    Title = "Throw Assist",
    Desc = "Redirects knife throws to Sheriff/Hero or the nearest player",
    Value = false,

    Callback = function(Value)
        MurderSettings.ThrowAssist =
            Value

        if Value then
            BindMurderThrowButton()
        end
    end
})

MurderTab:Toggle({
    Title = "Auto Throw",
    Desc = "Automatically throws the knife at valid targets",
    Value = false,

    Callback = function(Value)
        MurderSettings.AutoThrow =
            Value

        MurderLastAutoThrow = 0
    end
})

MurderPlayerDropdown = MurderTab:Dropdown({
    Title = "Select Player",
    Desc = "Choose a player to kill",

    Values =
        GetMurderPlayerNames(),

    AllowNone = true,
    SearchBarEnabled = true,

    Callback = function(Value)
        if type(Value) == "table" then
            Value =
                Value.Value
                or Value.Title
                or Value[1]
        end

        MurderSelectedPlayer =
            GetMurderPlayerFromName(
                Value
            )
    end
})

MurderTab:Button({
    Title = "Kill Selected Player",
    Desc = "Kill the selected player",
    Icon = "skull",

    Callback = function()
        KillSelectedMurderPlayer()
    end
})

MurderTab:Button({
    Title = "Kill Sheriff",
    Desc = "Kill the current Sheriff or Hero",
    Icon = "crosshair",

    Callback = function()
        KillMurderSheriff()
    end
})

MurderTab:Button({
    Title = "Kill All Innocents",
    Desc = "Kill every alive Innocent",
    Icon = "users",

    Callback = function()
        KillAllMurderInnocents()
    end
})

MurderTab:Button({
    Title = "Kill All Players",
    Desc = "Kill every alive player",
    Icon = "skull",

    Callback = function()
        KillAllMurderPlayers()
    end
})

MurderTab:Button({
    Title = "Fling Sheriff",
    Desc = "Fling the current Sheriff or Hero",
    Icon = "zap",

    Callback = function()
        FlingMurderSheriff()
    end
})

BindMurderThrowButton()

local SheriffSettings = {
    AutoShoot = false,
    MurdererESP = false,
    GunDropESP = false,
    AutoEscape = false,

    AutoShootCooldown = 0.85,
    EscapeDistance = 5,
    EscapeCooldown = 1.2
}

local SheriffMurderHighlight
local SheriffGunDropHighlight

local SheriffLastShot = 0
local SheriffLastEscape = 0
local SheriffLastRoleRefresh = 0
local SheriffLastSafeCFrame

local function GetSheriffGun()
    local Character = LP.Character
    local Backpack = LP:FindFirstChild("Backpack")

    return
        (Character and Character:FindFirstChild("Gun"))
        or
        (Backpack and Backpack:FindFirstChild("Gun"))
end

local function GetSheriffRoot()
    local Character = LP.Character

    if not Character then
        return
    end

    local Humanoid =
        Character:FindFirstChildOfClass("Humanoid")

    local Root =
        Character:FindFirstChild("HumanoidRootPart")

    if not Humanoid
    or not Root
    or Humanoid.Health <= 0 then
        return
    end

    return Root, Humanoid
end

local function IsSheriffPlayerAlive(Player)
    if not Player
    or Player == LP
    or not Player.Parent then
        return false
    end

    local Character = Player.Character

    if not Character then
        return false
    end

    local Humanoid =
        Character:FindFirstChildOfClass("Humanoid")

    if not Humanoid
    or Humanoid.Health <= 0 then
        return false
    end

    if Player:GetAttribute("Alive") == false then
        return false
    end

    return true
end

local function GetSheriffTargetPart(Player)
    if not IsSheriffPlayerAlive(Player) then
        return
    end

    local Character = Player.Character

    return
        Character:FindFirstChild("HumanoidRootPart")
        or Character:FindFirstChild("UpperTorso")
        or Character:FindFirstChild("Torso")
        or Character:FindFirstChild("Head")
end

local function RefreshSheriffRoles(Force)
    local Now = os.clock()

    if not Force
    and Now - SheriffLastRoleRefresh < 0.75 then
        return
    end

    SheriffLastRoleRefresh = Now

    pcall(UpdateRoles)
end

local function GetSheriffMurderer()
    RefreshSheriffRoles(false)

    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LP
        and IsSheriffPlayerAlive(Player)
        and GetRole(Player) == "Murderer" then
            return Player
        end
    end
end

local function SheriffShootPlayer(Player)
    local Root =
        GetSheriffRoot()

    if not Root then
        return false
    end

    local Gun =
        GetSheriffGun()

    if not Gun then
        return false
    end

    local Shoot =
        Gun:FindFirstChild("Shoot")

    if not Shoot
    or not Shoot:IsA("RemoteEvent") then
        return false
    end

    local TargetPart =
        GetSheriffTargetPart(Player)

    if not TargetPart then
        return false
    end

    local Origin =
        Root.CFrame
        * CFrame.new(
            1.400390625,
            1.25,
            -3.4501953125
        )

    local Success =
        pcall(function()
            Shoot:FireServer(
                Origin,
                CFrame.new(
                    TargetPart.Position
                )
            )
        end)

    return Success
end

local function ShootSheriffMurderer()
    RefreshSheriffRoles(true)

    local Murderer =
        GetSheriffMurderer()

    if not Murderer then
        return false
    end

    return SheriffShootPlayer(
        Murderer
    )
end

local function UpdateSheriffMurdererESP()
    if not SheriffSettings.MurdererESP then
        if SheriffMurderHighlight then
            SheriffMurderHighlight:Destroy()
            SheriffMurderHighlight = nil
        end

        return
    end

    local Murderer =
        GetSheriffMurderer()

    local Character =
        Murderer
        and Murderer.Character

    if not Character then
        if SheriffMurderHighlight then
            SheriffMurderHighlight:Destroy()
            SheriffMurderHighlight = nil
        end

        return
    end

    if SheriffMurderHighlight
    and SheriffMurderHighlight.Adornee == Character
    and SheriffMurderHighlight.Parent then
        return
    end

    if SheriffMurderHighlight then
        SheriffMurderHighlight:Destroy()
        SheriffMurderHighlight = nil
    end

    local Highlight =
        Instance.new("Highlight")

    Highlight.Name =
        "MirrorsSheriffMurderESP"

    Highlight.Adornee =
        Character

    Highlight.DepthMode =
        Enum.HighlightDepthMode.AlwaysOnTop

    Highlight.FillColor =
        Color3.fromRGB(
            255,
            65,
            65
        )

    Highlight.OutlineColor =
        Color3.fromRGB(
            255,
            255,
            255
        )

    Highlight.FillTransparency =
        0.55

    Highlight.OutlineTransparency =
        0

    Highlight.Parent =
        Character

    SheriffMurderHighlight =
        Highlight
end

local function GetSheriffGunDrop()
    return Workspace:FindFirstChild(
        "GunDrop",
        true
    )
end

local function UpdateSheriffGunDropESP()
    if not SheriffSettings.GunDropESP then
        if SheriffGunDropHighlight then
            SheriffGunDropHighlight:Destroy()
            SheriffGunDropHighlight = nil
        end

        return
    end

    local GunDrop =
        GetSheriffGunDrop()

    if not GunDrop then
        if SheriffGunDropHighlight then
            SheriffGunDropHighlight:Destroy()
            SheriffGunDropHighlight = nil
        end

        return
    end

    if SheriffGunDropHighlight
    and SheriffGunDropHighlight.Adornee == GunDrop
    and SheriffGunDropHighlight.Parent then
        return
    end

    if SheriffGunDropHighlight then
        SheriffGunDropHighlight:Destroy()
        SheriffGunDropHighlight = nil
    end

    local Highlight =
        Instance.new("Highlight")

    Highlight.Name =
        "MirrorsSheriffGunDropESP"

    Highlight.Adornee =
        GunDrop

    Highlight.DepthMode =
        Enum.HighlightDepthMode.AlwaysOnTop

    Highlight.FillColor =
        Color3.fromRGB(
            255,
            210,
            60
        )

    Highlight.OutlineColor =
        Color3.fromRGB(
            255,
            255,
            255
        )

    Highlight.FillTransparency =
        0.35

    Highlight.OutlineTransparency =
        0

    Highlight.Parent =
        GunDrop

    SheriffGunDropHighlight =
        Highlight
end

local function UpdateSheriffSafePosition(
    Root,
    Humanoid,
    Murderer
)
    local MurderPart =
        GetSheriffTargetPart(Murderer)

    if not MurderPart then
        return
    end

    local Distance =
        (
            Root.Position
            - MurderPart.Position
        ).Magnitude

    if Distance < 18 then
        return
    end

    if Humanoid.FloorMaterial
    == Enum.Material.Air then
        return
    end

    SheriffLastSafeCFrame =
        Root.CFrame
end

local function FindSheriffEscapeCFrame(
    Root,
    Murderer
)
    local MurderPart =
        GetSheriffTargetPart(Murderer)

    if not MurderPart then
        return
    end

    if SheriffLastSafeCFrame then
        local SafeDistance =
            (
                SheriffLastSafeCFrame.Position
                - MurderPart.Position
            ).Magnitude

        if SafeDistance >= 15 then
            return SheriffLastSafeCFrame
        end
    end

    local Params =
        RaycastParams.new()

    Params.FilterType =
        Enum.RaycastFilterType.Exclude

    local Ignore = {}

    if LP.Character then
        table.insert(
            Ignore,
            LP.Character
        )
    end

    if Murderer.Character then
        table.insert(
            Ignore,
            Murderer.Character
        )
    end

    Params.FilterDescendantsInstances =
        Ignore

    local BestPosition
    local BestScore = -math.huge

    local Radii = {
        25,
        35,
        45
    }

    for _, Radius in ipairs(Radii) do
        for Index = 0, 15 do
            local Angle =
                math.rad(
                    Index * 22.5
                )

            local Offset =
                Vector3.new(
                    math.cos(Angle)
                    * Radius,
                    0,
                    math.sin(Angle)
                    * Radius
                )

            local Candidate =
                Root.Position
                + Offset

            local Result =
                Workspace:Raycast(
                    Candidate
                    + Vector3.new(
                        0,
                        25,
                        0
                    ),
                    Vector3.new(
                        0,
                        -60,
                        0
                    ),
                    Params
                )

            if Result
            and Result.Instance
            and Result.Instance.CanCollide then

                local Position =
                    Result.Position
                    + Vector3.new(
                        0,
                        3,
                        0
                    )

                local Score =
                    (
                        Position
                        - MurderPart.Position
                    ).Magnitude

                if Score > BestScore then
                    BestScore = Score
                    BestPosition = Position
                end
            end
        end
    end

    if BestPosition then
        return
            CFrame.new(
                BestPosition
            )
            * Root.CFrame.Rotation
    end
end

local function SheriffAutoEscape()
    if not SheriffSettings.AutoEscape then
        return
    end

    local Root, Humanoid =
        GetSheriffRoot()

    if not Root then
        return
    end

    local Murderer =
        GetSheriffMurderer()

    if not Murderer then
        return
    end

    local MurderPart =
        GetSheriffTargetPart(
            Murderer
        )

    if not MurderPart then
        return
    end

    UpdateSheriffSafePosition(
        Root,
        Humanoid,
        Murderer
    )

    local Distance =
        (
            Root.Position
            - MurderPart.Position
        ).Magnitude

    if Distance
    > SheriffSettings.EscapeDistance then
        return
    end

    local Now = os.clock()

    if Now - SheriffLastEscape
    < SheriffSettings.EscapeCooldown then
        return
    end

    local EscapeCFrame =
        FindSheriffEscapeCFrame(
            Root,
            Murderer
        )

    if not EscapeCFrame then
        return
    end

    SheriffLastEscape =
        Now

    Root.CFrame =
        EscapeCFrame

    ResetRootPhysics(
        Root
    )
end

local function FlingSheriffMurderer()
    RefreshSheriffRoles(true)

    local Murderer =
        GetSheriffMurderer()

    if not Murderer then
        return
    end

    FollowAndFlingPlayer(
        Murderer
    )
end

RunService.Heartbeat:Connect(function()
    RefreshSheriffRoles(false)

    UpdateSheriffMurdererESP()
    UpdateSheriffGunDropESP()

    if SheriffSettings.AutoShoot then
        local Now =
            os.clock()

        if Now - SheriffLastShot
        >= SheriffSettings.AutoShootCooldown then

            local Murderer =
                GetSheriffMurderer()

            if Murderer
            and SheriffShootPlayer(
                Murderer
            ) then
                SheriffLastShot =
                    Now
            end
        end
    end

    SheriffAutoEscape()
end)

Players.PlayerRemoving:Connect(function(Player)
    if SheriffMurderHighlight
    and SheriffMurderHighlight.Adornee
    == Player.Character then

        SheriffMurderHighlight:Destroy()
        SheriffMurderHighlight = nil
    end
end)

LP.CharacterRemoving:Connect(function()
    SheriffLastSafeCFrame = nil
    SheriffLastShot = 0
    SheriffLastEscape = 0

    if SheriffMurderHighlight then
        SheriffMurderHighlight:Destroy()
        SheriffMurderHighlight = nil
    end
end)

SheriffTab:Toggle({
    Title = "Auto Shoot Murderer",
    Desc = "Automatically shoots the current Murderer",
    Value = false,

    Callback = function(Value)
        SheriffSettings.AutoShoot =
            Value

        SheriffLastShot = 0
    end
})

SheriffTab:Button({
    Title = "Shoot Murderer",
    Desc = "Shoot the Murderer directly, even without aiming at them",
    Icon = "crosshair",

    Callback = function()
        ShootSheriffMurderer()
    end
})

SheriffTab:Toggle({
    Title = "Murderer ESP",
    Desc = "Highlights the current Murderer through walls",
    Value = false,

    Callback = function(Value)
        SheriffSettings.MurdererESP =
            Value

        if not Value
        and SheriffMurderHighlight then
            SheriffMurderHighlight:Destroy()
            SheriffMurderHighlight = nil
        end
    end
})

SheriffTab:Toggle({
    Title = "Gun Drop ESP",
    Desc = "Highlights the dropped gun",
    Value = false,

    Callback = function(Value)
        SheriffSettings.GunDropESP =
            Value

        if not Value
        and SheriffGunDropHighlight then
            SheriffGunDropHighlight:Destroy()
            SheriffGunDropHighlight = nil
        end
    end
})

SheriffTab:Toggle({
    Title = "Auto Escape Murderer",
    Desc = "Teleports to a safer position when the Murderer gets within 5 studs",
    Value = false,

    Callback = function(Value)
        SheriffSettings.AutoEscape =
            Value

        SheriffLastEscape = 0

        if not Value then
            SheriffLastSafeCFrame =
                nil
        end
    end
})

SheriffTab:Button({
    Title = "Fling Murderer",
    Desc = "Fling the current Murderer",
    Icon = "zap",

    Callback = function()
        FlingSheriffMurderer()
    end
})

local InnocentSettings = {
    AutoGun = false,
    GunDropESP = false,
    MurdererESP = false,
    SheriffESP = false,
    AutoEscape = false,

    EscapeDistance = 5,
    EscapeCooldown = 1.2,
    AutoGunCooldown = 1.5
}

local InnocentGettingGun = false

local InnocentLastGunTry = 0
local InnocentLastEscape = 0
local InnocentLastRoleRefresh = 0

local InnocentLastSafeCFrame

local InnocentGunDropHighlight
local InnocentMurderHighlight
local InnocentSheriffHighlight

local function GetInnocentRoot()
    local Character = LP.Character

    if not Character then
        return
    end

    local Humanoid =
        Character:FindFirstChildOfClass("Humanoid")

    local Root =
        Character:FindFirstChild("HumanoidRootPart")

    if not Root
    or not Humanoid
    or Humanoid.Health <= 0 then
        return
    end

    return Root, Humanoid
end

local function HasInnocentGun()
    local Character = LP.Character
    local Backpack = LP:FindFirstChild("Backpack")

    return (
        Character
        and Character:FindFirstChild("Gun")
    ) ~= nil
    or (
        Backpack
        and Backpack:FindFirstChild("Gun")
    ) ~= nil
end

local function IsInnocentPlayerAlive(Player)
    if not Player
    or Player == LP
    or not Player.Parent then
        return false
    end

    local Character =
        Player.Character

    if not Character then
        return false
    end

    local Humanoid =
        Character:FindFirstChildOfClass("Humanoid")

    if not Humanoid
    or Humanoid.Health <= 0 then
        return false
    end

    if Player:GetAttribute("Alive") == false then
        return false
    end

    return true
end

local function GetInnocentTargetPart(Player)
    if not IsInnocentPlayerAlive(Player) then
        return
    end

    local Character =
        Player.Character

    return
        Character:FindFirstChild("HumanoidRootPart")
        or Character:FindFirstChild("UpperTorso")
        or Character:FindFirstChild("Torso")
        or Character:FindFirstChild("Head")
end

local function RefreshInnocentRoles(Force)
    local Now =
        os.clock()

    if not Force
    and Now - InnocentLastRoleRefresh < 0.75 then
        return
    end

    InnocentLastRoleRefresh =
        Now

    pcall(UpdateRoles)
end

local function GetInnocentMurderer()
    RefreshInnocentRoles(false)

    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LP
        and IsInnocentPlayerAlive(Player)
        and GetRole(Player) == "Murderer" then
            return Player
        end
    end
end

local function GetInnocentSheriff()
    RefreshInnocentRoles(false)

    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LP
        and IsInnocentPlayerAlive(Player) then
            local Role =
                GetRole(Player)

            if Role == "Sheriff"
            or Role == "Hero" then
                return Player
            end
        end
    end
end

local function GetInnocentGunDrop()
    return Workspace:FindFirstChild(
        "GunDrop",
        true
    )
end

local function GetInnocentObjectCFrame(Object)
    if not Object
    or not Object.Parent then
        return
    end

    if Object:IsA("BasePart") then
        return Object.CFrame
    end

    if Object:IsA("Model") then
        return Object:GetPivot()
    end

    local Part =
        Object:FindFirstChildWhichIsA(
            "BasePart",
            true
        )

    return Part and Part.CFrame
end

local function TeleportInnocentGunDrop()
    local Root =
        GetInnocentRoot()

    local GunDrop =
        GetInnocentGunDrop()

    local GunCFrame =
        GetInnocentObjectCFrame(
            GunDrop
        )

    if not Root
    or not GunCFrame then
        return
    end

    Root.CFrame =
        CFrame.new(
            GunCFrame.Position
            + Vector3.new(
                0,
                2,
                0
            )
        )
        * Root.CFrame.Rotation

    ResetRootPhysics(
        Root
    )
end

local function GrabInnocentGun()
    if InnocentGettingGun
    or HasInnocentGun() then
        return
    end

    local Root =
        GetInnocentRoot()

    local GunDrop =
        GetInnocentGunDrop()

    local GunCFrame =
        GetInnocentObjectCFrame(
            GunDrop
        )

    if not Root
    or not GunCFrame then
        return
    end

    InnocentGettingGun =
        true

    local OriginalCFrame =
        Root.CFrame

    local Deadline =
        os.clock() + 1.6

    while Root.Parent
    and not HasInnocentGun()
    and os.clock() < Deadline do
        local CurrentDrop =
            GetInnocentGunDrop()

        local CurrentCFrame =
            GetInnocentObjectCFrame(
                CurrentDrop
            )

        if not CurrentCFrame then
            break
        end

        Root.CFrame =
            CFrame.new(
                CurrentCFrame.Position
                + Vector3.new(
                    0,
                    1.5,
                    0
                )
            )
            * Root.CFrame.Rotation

        ResetRootPhysics(
            Root
        )

        task.wait(0.08)
    end

    task.wait(0.05)

    if Root.Parent then
        Root.CFrame =
            OriginalCFrame

        ResetRootPhysics(
            Root
        )
    end

    InnocentGettingGun =
        false
end

local function UpdateInnocentGunDropESP()
    if not InnocentSettings.GunDropESP then
        if InnocentGunDropHighlight then
            InnocentGunDropHighlight:Destroy()
            InnocentGunDropHighlight = nil
        end

        return
    end

    local GunDrop =
        GetInnocentGunDrop()

    if not GunDrop then
        if InnocentGunDropHighlight then
            InnocentGunDropHighlight:Destroy()
            InnocentGunDropHighlight = nil
        end

        return
    end

    if InnocentGunDropHighlight
    and InnocentGunDropHighlight.Parent
    and InnocentGunDropHighlight.Adornee == GunDrop then
        return
    end

    if InnocentGunDropHighlight then
        InnocentGunDropHighlight:Destroy()
    end

    local Highlight =
        Instance.new("Highlight")

    Highlight.Name =
        "MirrorsInnocentGunDropESP"

    Highlight.Adornee =
        GunDrop

    Highlight.DepthMode =
        Enum.HighlightDepthMode.AlwaysOnTop

    Highlight.FillColor =
        Color3.fromRGB(
            255,
            215,
            70
        )

    Highlight.OutlineColor =
        Color3.fromRGB(
            255,
            255,
            255
        )

    Highlight.FillTransparency =
        0.35

    Highlight.OutlineTransparency =
        0

    Highlight.Parent =
        GunDrop

    InnocentGunDropHighlight =
        Highlight
end

local function UpdateInnocentMurderESP()
    if not InnocentSettings.MurdererESP then
        if InnocentMurderHighlight then
            InnocentMurderHighlight:Destroy()
            InnocentMurderHighlight = nil
        end

        return
    end

    local Murderer =
        GetInnocentMurderer()

    local Character =
        Murderer
        and Murderer.Character

    if not Character then
        if InnocentMurderHighlight then
            InnocentMurderHighlight:Destroy()
            InnocentMurderHighlight = nil
        end

        return
    end

    if InnocentMurderHighlight
    and InnocentMurderHighlight.Parent
    and InnocentMurderHighlight.Adornee == Character then
        return
    end

    if InnocentMurderHighlight then
        InnocentMurderHighlight:Destroy()
    end

    local Highlight =
        Instance.new("Highlight")

    Highlight.Name =
        "MirrorsInnocentMurderESP"

    Highlight.Adornee =
        Character

    Highlight.DepthMode =
        Enum.HighlightDepthMode.AlwaysOnTop

    Highlight.FillColor =
        Color3.fromRGB(
            255,
            65,
            65
        )

    Highlight.OutlineColor =
        Color3.fromRGB(
            255,
            255,
            255
        )

    Highlight.FillTransparency =
        0.55

    Highlight.OutlineTransparency =
        0

    Highlight.Parent =
        Character

    InnocentMurderHighlight =
        Highlight
end

local function UpdateInnocentSheriffESP()
    if not InnocentSettings.SheriffESP then
        if InnocentSheriffHighlight then
            InnocentSheriffHighlight:Destroy()
            InnocentSheriffHighlight = nil
        end

        return
    end

    local Sheriff =
        GetInnocentSheriff()

    local Character =
        Sheriff
        and Sheriff.Character

    if not Character then
        if InnocentSheriffHighlight then
            InnocentSheriffHighlight:Destroy()
            InnocentSheriffHighlight = nil
        end

        return
    end

    if InnocentSheriffHighlight
    and InnocentSheriffHighlight.Parent
    and InnocentSheriffHighlight.Adornee == Character then
        return
    end

    if InnocentSheriffHighlight then
        InnocentSheriffHighlight:Destroy()
    end

    local Highlight =
        Instance.new("Highlight")

    Highlight.Name =
        "MirrorsInnocentSheriffESP"

    Highlight.Adornee =
        Character

    Highlight.DepthMode =
        Enum.HighlightDepthMode.AlwaysOnTop

    Highlight.FillColor =
        Color3.fromRGB(
            70,
            150,
            255
        )

    Highlight.OutlineColor =
        Color3.fromRGB(
            255,
            255,
            255
        )

    Highlight.FillTransparency =
        0.55

    Highlight.OutlineTransparency =
        0

    Highlight.Parent =
        Character

    InnocentSheriffHighlight =
        Highlight
end

local function UpdateInnocentSafePosition(
    Root,
    Humanoid,
    Murderer
)
    local MurderPart =
        GetInnocentTargetPart(
            Murderer
        )

    if not MurderPart then
        return
    end

    local Distance =
        (
            Root.Position
            - MurderPart.Position
        ).Magnitude

    if Distance < 18 then
        return
    end

    if Humanoid.FloorMaterial
    == Enum.Material.Air then
        return
    end

    InnocentLastSafeCFrame =
        Root.CFrame
end

local function FindInnocentEscapeCFrame(
    Root,
    Murderer
)
    local MurderPart =
        GetInnocentTargetPart(
            Murderer
        )

    if not MurderPart then
        return
    end

    if InnocentLastSafeCFrame then
        local Distance =
            (
                InnocentLastSafeCFrame.Position
                - MurderPart.Position
            ).Magnitude

        if Distance >= 15 then
            return InnocentLastSafeCFrame
        end
    end

    local Params =
        RaycastParams.new()

    Params.FilterType =
        Enum.RaycastFilterType.Exclude

    local Ignore = {}

    if LP.Character then
        table.insert(
            Ignore,
            LP.Character
        )
    end

    if Murderer.Character then
        table.insert(
            Ignore,
            Murderer.Character
        )
    end

    Params.FilterDescendantsInstances =
        Ignore

    local BestPosition
    local BestScore = -math.huge

    local Radii = {
        25,
        35,
        45
    }

    for _, Radius in ipairs(Radii) do
        for Index = 0, 15 do
            local Angle =
                math.rad(
                    Index * 22.5
                )

            local Candidate =
                Root.Position
                + Vector3.new(
                    math.cos(Angle)
                    * Radius,
                    0,
                    math.sin(Angle)
                    * Radius
                )

            local Result =
                Workspace:Raycast(
                    Candidate
                    + Vector3.new(
                        0,
                        25,
                        0
                    ),
                    Vector3.new(
                        0,
                        -60,
                        0
                    ),
                    Params
                )

            if Result
            and Result.Instance
            and Result.Instance.CanCollide then
                local Position =
                    Result.Position
                    + Vector3.new(
                        0,
                        3,
                        0
                    )

                local Score =
                    (
                        Position
                        - MurderPart.Position
                    ).Magnitude

                if Score > BestScore then
                    BestScore =
                        Score

                    BestPosition =
                        Position
                end
            end
        end
    end

    if BestPosition then
        return
            CFrame.new(
                BestPosition
            )
            * Root.CFrame.Rotation
    end
end

local function InnocentAutoEscape()
    if not InnocentSettings.AutoEscape
    or InnocentGettingGun then
        return
    end

    local Root, Humanoid =
        GetInnocentRoot()

    if not Root then
        return
    end

    local Murderer =
        GetInnocentMurderer()

    if not Murderer then
        return
    end

    local MurderPart =
        GetInnocentTargetPart(
            Murderer
        )

    if not MurderPart then
        return
    end

    UpdateInnocentSafePosition(
        Root,
        Humanoid,
        Murderer
    )

    local Distance =
        (
            Root.Position
            - MurderPart.Position
        ).Magnitude

    if Distance
    > InnocentSettings.EscapeDistance then
        return
    end

    local Now =
        os.clock()

    if Now - InnocentLastEscape
    < InnocentSettings.EscapeCooldown then
        return
    end

    local EscapeCFrame =
        FindInnocentEscapeCFrame(
            Root,
            Murderer
        )

    if not EscapeCFrame then
        return
    end

    InnocentLastEscape =
        Now

    Root.CFrame =
        EscapeCFrame

    ResetRootPhysics(
        Root
    )
end

local function TeleportInnocentSheriff()
    RefreshInnocentRoles(true)

    local Sheriff =
        GetInnocentSheriff()

    local TargetRoot =
        Sheriff
        and GetInnocentTargetPart(
            Sheriff
        )

    local Root =
        GetInnocentRoot()

    if not Sheriff
    or not TargetRoot
    or not Root then
        return
    end

    Root.CFrame =
        TargetRoot.CFrame
        * CFrame.new(
            0,
            0,
            3
        )

    ResetRootPhysics(
        Root
    )
end

local function FlingInnocentMurderer()
    RefreshInnocentRoles(true)

    local Murderer =
        GetInnocentMurderer()

    if not Murderer then
        return
    end

    FollowAndFlingPlayer(
        Murderer
    )
end

local function FlingInnocentSheriff()
    RefreshInnocentRoles(true)

    local Sheriff =
        GetInnocentSheriff()

    if not Sheriff then
        return
    end

    FollowAndFlingPlayer(
        Sheriff
    )
end

RunService.Heartbeat:Connect(function()
    UpdateInnocentGunDropESP()
    UpdateInnocentMurderESP()
    UpdateInnocentSheriffESP()

    if InnocentSettings.AutoGun
    and not InnocentGettingGun
    and not HasInnocentGun() then
        local GunDrop =
            GetInnocentGunDrop()

        local Now =
            os.clock()

        if GunDrop
        and Now - InnocentLastGunTry
        >= InnocentSettings.AutoGunCooldown then

            InnocentLastGunTry =
                Now

            task.spawn(
                GrabInnocentGun
            )
        end
    end

    InnocentAutoEscape()
end)

Players.PlayerRemoving:Connect(function(Player)
    if InnocentMurderHighlight
    and InnocentMurderHighlight.Adornee
    == Player.Character then
        InnocentMurderHighlight:Destroy()
        InnocentMurderHighlight = nil
    end

    if InnocentSheriffHighlight
    and InnocentSheriffHighlight.Adornee
    == Player.Character then
        InnocentSheriffHighlight:Destroy()
        InnocentSheriffHighlight = nil
    end
end)

LP.CharacterRemoving:Connect(function()
    InnocentGettingGun =
        false

    InnocentLastSafeCFrame =
        nil

    InnocentLastEscape =
        0

    InnocentLastGunTry =
        0

    if InnocentMurderHighlight then
        InnocentMurderHighlight:Destroy()
        InnocentMurderHighlight = nil
    end

    if InnocentSheriffHighlight then
        InnocentSheriffHighlight:Destroy()
        InnocentSheriffHighlight = nil
    end
end)

InnocentTab:Toggle({
    Title = "Auto Gun",
    Desc = "Automatically grabs the dropped gun and returns to your previous position",
    Value = false,

    Callback = function(Value)
        InnocentSettings.AutoGun =
            Value

        InnocentLastGunTry =
            0
    end
})

InnocentTab:Button({
    Title = "Teleport Gun Drop",
    Desc = "Teleport directly to the dropped gun",
    Icon = "zap",

    Callback = function()
        TeleportInnocentGunDrop()
    end
})

InnocentTab:Toggle({
    Title = "Gun Drop ESP",
    Desc = "Highlights the dropped gun through walls",
    Value = false,

    Callback = function(Value)
        InnocentSettings.GunDropESP =
            Value

        if not Value
        and InnocentGunDropHighlight then
            InnocentGunDropHighlight:Destroy()
            InnocentGunDropHighlight = nil
        end
    end
})

InnocentTab:Toggle({
    Title = "Murderer ESP",
    Desc = "Highlights the current Murderer",
    Value = false,

    Callback = function(Value)
        InnocentSettings.MurdererESP =
            Value

        if not Value
        and InnocentMurderHighlight then
            InnocentMurderHighlight:Destroy()
            InnocentMurderHighlight = nil
        end
    end
})

InnocentTab:Toggle({
    Title = "Sheriff ESP",
    Desc = "Highlights the current Sheriff or Hero",
    Value = false,

    Callback = function(Value)
        InnocentSettings.SheriffESP =
            Value

        if not Value
        and InnocentSheriffHighlight then
            InnocentSheriffHighlight:Destroy()
            InnocentSheriffHighlight = nil
        end
    end
})

InnocentTab:Toggle({
    Title = "Auto Escape Murderer",
    Desc = "Teleports to a safer position when the Murderer gets within 5 studs",
    Value = false,

    Callback = function(Value)
        InnocentSettings.AutoEscape =
            Value

        InnocentLastEscape =
            0

        if not Value then
            InnocentLastSafeCFrame =
                nil
        end
    end
})

InnocentTab:Button({
    Title = "Fling Murderer",
    Desc = "Fling the current Murderer",
    Icon = "zap",

    Callback = function()
        FlingInnocentMurderer()
    end
})

InnocentTab:Button({
    Title = "Teleport Sheriff",
    Desc = "Teleport to the current Sheriff or Hero",
    Icon = "map-pin",

    Callback = function()
        TeleportInnocentSheriff()
    end
})

InnocentTab:Button({
    Title = "Fling Sheriff",
    Desc = "Fling the current Sheriff or Hero",
    Icon = "zap",

    Callback = function()
        FlingInnocentSheriff()
    end
})
