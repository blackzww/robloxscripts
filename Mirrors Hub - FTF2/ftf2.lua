local WindUI
local success = pcall(function()
    WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)

if not WindUI then
    WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/src/main.lua"))()
end

if not WindUI then
    error("Falha ao carregar WindUI! Verifique sua conexão.")
    return
end

WindUI:AddTheme({
    Name = "Amethyst",

    Accent = Color3.fromHex("#840ee6"),
    Background = Color3.fromHex("#09090b"),
    Outline = Color3.fromHex("#6d28d9"),
    Text = Color3.fromHex("#f5f5f5"),
    Placeholder = Color3.fromHex("#71717a"),
    Button = Color3.fromHex("#2a1244"),
    Icon = Color3.fromHex("#d8b4fe"),
})


local Window = WindUI:CreateWindow({
    Title = "Mirrors Hub - FTF2",
    Icon = "door-open",
    Author = "by blackzw.mp3",
    Folder = "MirrorsHub/FTF2",
    
    Size = UDim2.fromOffset(580, 460),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),
    ToggleKey = Enum.KeyCode.K,
    Transparent = true,
    Theme = "Amethyst",
    Resizable = true,
    SideBarWidth = 200,
    BackgroundImageTransparency = 0.42,
    HideSearchBar = false,
    ScrollBarEnabled = false,

    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            print("clicked")
        end,
    },
})

Window:EditOpenButton({
    Title = "Open Mirrors Hub - FTF2",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 16),
    StrokeThickness = 2,
    Color = ColorSequence.new(
        Color3.fromHex("840ee6"),
        Color3.fromHex("35065c")
    ),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})


local Main = Window:Tab({Title = "Main", Icon = "house"})
local Esp = Window:Tab({Title = "Esp", Icon = "eye"})
local Beast = Window:Tab({Title = "Beast", Icon = "skull"})
local Hider = Window:Tab({Title = "Hider", Icon = "user"})
local Misc = Window:Tab({Title = "Misc", Icon = "circle-ellipsis"})
local Config = Window:Tab({Title = "Config", Icon = "cog"})

-- ============================================
-- ============= SUPER ESP SYSTEM =============
-- ============================================

local SuperESP = {}
SuperESP.__index = SuperESP

local PLAYER_ESP_CONFIG = {
    Colors = {
        Survivor = Color3.fromRGB(50, 150, 255),
        Beast = Color3.fromRGB(255, 50, 50)
    },
    UpdateInterval = 0.2,
    FolderName = "SuperESP_Folder",
    HumanoidRootPartTimeout = 10,
    BillboardSize = UDim2.new(0, 100, 0, 50),
    BillboardOffset = Vector3.new(0, 3, 0),
    Font = Enum.Font.RobotoMono,
    TextSize = 18,
    FillTransparency = 0.5,
    OutlineTransparency = 0
}

-- ============ RESOURCE MANAGER ============
local ResourceManager = {}
ResourceManager.__index = ResourceManager

function ResourceManager.new()
    return setmetatable({
        connections = {},
        threads = {},
        instances = {}
    }, ResourceManager)
end

function ResourceManager:addConnection(key, connection)
    if not self.connections[key] then
        self.connections[key] = {}
    end
    table.insert(self.connections[key], connection)
end

function ResourceManager:addThread(key, thread)
    if self.threads[key] then
        task.cancel(self.threads[key])
    end
    self.threads[key] = thread
end

function ResourceManager:addInstance(key, instance)
    if not self.instances[key] then
        self.instances[key] = {}
    end
    table.insert(self.instances[key], instance)
end

function ResourceManager:cleanupKey(key)
    if self.connections[key] then
        for _, conn in pairs(self.connections[key]) do
            if conn and conn.Connected then
                conn:Disconnect()
            end
        end
        self.connections[key] = nil
    end
    
    if self.threads[key] then
        if task.cancel then
            task.cancel(self.threads[key])
        end
        self.threads[key] = nil
    end
    
    if self.instances[key] then
        for _, instance in pairs(self.instances[key]) do
            if instance and instance.Parent then
                instance:Destroy()
            end
        end
        self.instances[key] = nil
    end
end

function ResourceManager:cleanupAll()
    for key in pairs(self.connections) do
        self:cleanupKey(key)
    end
    for key in pairs(self.threads) do
        self:cleanupKey(key)
    end
    for key in pairs(self.instances) do
        self:cleanupKey(key)
    end
end

function SuperESP.new(dependencies)
    local deps = dependencies or {}
    
    local self = setmetatable({
        enabled = false,
        resources = ResourceManager.new(),
        getLocalPlayer = deps.getLocalPlayer or function() return game.Players.LocalPlayer end,
        getPlayers = deps.getPlayers or function() return game.Players:GetPlayers() end,
        onPlayerAdded = deps.onPlayerAdded or function(callback) return game.Players.PlayerAdded:Connect(callback) end,
        onPlayerRemoving = deps.onPlayerRemoving or function(callback) return game.Players.PlayerRemoving:Connect(callback) end
    }, SuperESP)
    
    return self
end

function SuperESP:isPlayerBeast(player)
    local statsModule = player:FindFirstChild("TempPlayerStatsModule")
    if not statsModule then return false end
    
    local beastValue = statsModule:FindFirstChild("IsBeast")
    if not beastValue then return false end
    
    if not beastValue:IsA("BoolValue") then return false end
    
    return beastValue.Value
end

function SuperESP:getPlayerColor(player)
    if self:isPlayerBeast(player) then
        return PLAYER_ESP_CONFIG.Colors.Beast
    end
    return PLAYER_ESP_CONFIG.Colors.Survivor
end

function SuperESP:createVisuals(character, rootPart)
    local key = "visuals_" .. character.Name
    
    local existingFolder = character:FindFirstChild(PLAYER_ESP_CONFIG.FolderName)
    if existingFolder then
        existingFolder:Destroy()
    end
    
    local folder = Instance.new("Folder")
    folder.Name = PLAYER_ESP_CONFIG.FolderName
    folder.Parent = character
    self.resources:addInstance(key, folder)
    
    local highlight = Instance.new("Highlight")
    highlight.Adornee = character
    highlight.FillTransparency = PLAYER_ESP_CONFIG.FillTransparency
    highlight.OutlineTransparency = PLAYER_ESP_CONFIG.OutlineTransparency
    highlight.Parent = folder
    self.resources:addInstance(key, highlight)
    
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = rootPart
    billboard.Size = PLAYER_ESP_CONFIG.BillboardSize
    billboard.StudsOffset = PLAYER_ESP_CONFIG.BillboardOffset
    billboard.AlwaysOnTop = true
    billboard.Name = "EspGui"
    billboard.Parent = folder
    self.resources:addInstance(key, billboard)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Font = PLAYER_ESP_CONFIG.Font
    label.TextSize = PLAYER_ESP_CONFIG.TextSize
    label.TextStrokeTransparency = 0
    label.Parent = billboard
    self.resources:addInstance(key, label)
    
    return {
        Folder = folder,
        Highlight = highlight,
        Billboard = billboard,
        Label = label
    }
end

function SuperESP:updateVisuals(visuals, color, name, distance)
    visuals.Highlight.FillColor = color
    visuals.Highlight.OutlineColor = color
    visuals.Label.TextColor3 = color
    visuals.Label.Text = name .. " [" .. distance .. "]"
end

function SuperESP:startUpdateLoop(player, character, rootPart, visuals)
    local key = "update_" .. player.Name
    
    local thread = task.spawn(function()
        while self.enabled do
            if not character or not character.Parent then break end
            if not rootPart or not rootPart.Parent then break end
            
            local color = self:getPlayerColor(player)
            
            local localChar = self.getLocalPlayer().Character
            local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")
            
            if localRoot then
                local distance = math.floor((localRoot.Position - rootPart.Position).Magnitude)
                self:updateVisuals(visuals, color, player.Name, distance)
            end
            
            task.wait(PLAYER_ESP_CONFIG.UpdateInterval)
        end
    end)
    
    self.resources:addThread(key, thread)
end

function SuperESP:setupPlayer(player)
    if player == self.getLocalPlayer() then return end
    
    local key = "player_" .. player.Name
    
    local function onCharacterAdded(character)
        local rootPart = character:WaitForChild("HumanoidRootPart", PLAYER_ESP_CONFIG.HumanoidRootPartTimeout)
        if not rootPart then
            warn("[SuperESP] HumanoidRootPart não encontrado para " .. player.Name)
            return
        end
        
        task.wait()
        
        local visuals = self:createVisuals(character, rootPart)
        self:startUpdateLoop(player, character, rootPart, visuals)
    end
    
    local charConnection = player.CharacterAdded:Connect(onCharacterAdded)
    self.resources:addConnection(key, charConnection)
    
    if player.Character then
        onCharacterAdded(player.Character)
    end
end

function SuperESP:enable()
    if self.enabled then return end
    self.enabled = true
    
    for _, player in pairs(self.getPlayers()) do
        self:setupPlayer(player)
    end
    
    local addedConn = self.onPlayerAdded(function(player)
        self:setupPlayer(player)
    end)
    self.resources:addConnection("__global_player_added", addedConn)
    
    local removingConn = self.onPlayerRemoving(function(player)
        self.resources:cleanupKey("player_" .. player.Name)
        self.resources:cleanupKey("update_" .. player.Name)
        self.resources:cleanupKey("visuals_" .. player.Name)
    end)
    self.resources:addConnection("__global_player_removing", removingConn)
end

function SuperESP:disable()
    if not self.enabled then return end
    self.enabled = false
    
    for _, player in pairs(self.getPlayers()) do
        local character = player.Character
        if character then
            local folder = character:FindFirstChild(PLAYER_ESP_CONFIG.FolderName)
            if folder then
                folder:Destroy()
            end
        end
    end
    
    self.resources:cleanupAll()
end

local espSystem = SuperESP.new()

Esp:Toggle({
    Title = "Player ESP",
    Desc = "Azul: Sobreviventes | Vermelho: Besta",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        if state then
            espSystem:enable()
        else
            espSystem:disable()
        end
    end
})

-- ============================================
-- ============= DOOR ESP SYSTEM ==============
-- ============================================

local DOOR_ESP_CONFIG = {
    DoorTypes = {
        {
            Name = "SingleDoor",
            HighlightParent = function(door)
                return door.Door
            end,
            TriggerPath = function(door)
                return door.DoorTrigger
            end
        },
        {
            Name = "DoubleDoor",
            HighlightParent = function(door)
                return door
            end,
            TriggerPath = function(door)
                return door.DoorTrigger
            end
        },
        {
    Name = "ExitDoor",
    HighlightParent = function(door)
        return door
    end,
    TriggerPath = function(door)
        return door
    end
        }
    },
    Colors = {
        Locked = Color3.new(1, 0, 0),
        Unlocked = Color3.new(0, 1, 0)
    },
    StateValues = {
        Locked = 10,
        Unlocked = 11
    },
    Timing = {
        UpdateInterval = 0.1,
        InitializationDelay = 1
    },
    HighlightDefaults = {
        FillColor = Color3.new(1, 1, 1),
        OutlineColor = Color3.new(1, 1, 1),
        FillTransparency = 0.5,
        OutlineTransparency = 0
    }
}

local DoorDiscoveryService = {}
DoorDiscoveryService.__index = DoorDiscoveryService

function DoorDiscoveryService.new(workspaceInstance)
    local self = setmetatable({}, DoorDiscoveryService)
    self._workspace = workspaceInstance or workspace
    self._cache = {}
    return self
end

function DoorDiscoveryService:discover(doorTypeName)
    local cached = self._cache[doorTypeName]
    if cached then
        return cached
    end

    local doors = {}
    for _, descendant in pairs(self._workspace:GetDescendants()) do
        if descendant.Name == doorTypeName then
            table.insert(doors, descendant)
        end
    end

    self._cache[doorTypeName] = doors
    return doors
end

function DoorDiscoveryService:invalidateCache()
    self._cache = {}
end

local DoorHighlightFactory = {}
DoorHighlightFactory.__index = DoorHighlightFactory

function DoorHighlightFactory.new(config)
    local self = setmetatable({}, DoorHighlightFactory)
    self._config = config or DOOR_ESP_CONFIG.HighlightDefaults
    return self
end

function DoorHighlightFactory:create(parent)
    local highlight = Instance.new("Highlight")
    highlight.FillColor = self._config.FillColor
    highlight.OutlineColor = self._config.OutlineColor
    highlight.FillTransparency = self._config.FillTransparency
    highlight.OutlineTransparency = self._config.OutlineTransparency
    highlight.Parent = parent
    return highlight
end

local DoorStateReader = {}
DoorStateReader.__index = DoorStateReader

function DoorStateReader.new(stateConfig)
    local self = setmetatable({}, DoorStateReader)
    self._config = stateConfig or DOOR_ESP_CONFIG.StateValues
    return self
end

function DoorStateReader:read(door, doorTypeConfig)

    if door.Name == "ExitDoor" then
        return 11
    end

    local trigger = doorTypeConfig.TriggerPath(door)

    if not trigger then
        return nil
    end

    local actionSign = trigger:FindFirstChild("ActionSign")

    if not actionSign then
        return nil
    end

    return actionSign.Value
end
function DoorStateReader:getColor(door, doorTypeConfig, colorConfig)
    local state = self:read(door, doorTypeConfig)
    if state == nil then
        return nil
    end

    if state == self._config.Unlocked then
        return colorConfig.Unlocked
    end
    if state == self._config.Locked then
        return colorConfig.Locked
    end

    return nil
end

local DoorResourceManager = {}
DoorResourceManager.__index = DoorResourceManager

function DoorResourceManager.new()
    local self = setmetatable({}, DoorResourceManager)
    self._highlights = {}
    self._threads = {}
    self._connections = {}
    self._active = false
    return self
end

function DoorResourceManager:addHighlight(key, highlight)
    local bucket = self._highlights[key]
    if not bucket then
        bucket = {}
        self._highlights[key] = bucket
    end
    table.insert(bucket, highlight)
end

function DoorResourceManager:addThread(key, thread)
    local bucket = self._threads[key]
    if not bucket then
        bucket = {}
        self._threads[key] = bucket
    end
    table.insert(bucket, thread)
end

function DoorResourceManager:addConnection(key, connection)
    local bucket = self._connections[key]
    if not bucket then
        bucket = {}
        self._connections[key] = bucket
    end
    table.insert(bucket, connection)
end

function DoorResourceManager:cleanupKey(key)
    local threads = self._threads[key]
    if threads then
        for _, thread in pairs(threads) do
            if thread and thread:IsRunning() then
                task.cancel(thread)
            end
        end
        self._threads[key] = nil
    end

    local connections = self._connections[key]
    if connections then
        for _, connection in pairs(connections) do
            if connection and connection.Connected then
                connection:Disconnect()
            end
        end
        self._connections[key] = nil
    end

    local highlights = self._highlights[key]
    if highlights then
        for _, highlight in pairs(highlights) do
            if highlight and highlight.Parent then
                highlight:Destroy()
            end
        end
        self._highlights[key] = nil
    end
end

function DoorResourceManager:cleanupAll()
    local keys = {}

    for key in pairs(self._highlights) do
        keys[key] = true
    end
    for key in pairs(self._threads) do
        keys[key] = true
    end
    for key in pairs(self._connections) do
        keys[key] = true
    end

    for key in pairs(keys) do
        self:cleanupKey(key)
    end

    self._active = false
end

function DoorResourceManager:activate()
    self._active = true
end

function DoorResourceManager:isActive()
    return self._active
end

local UpdateScheduler = {}
UpdateScheduler.__index = UpdateScheduler

function UpdateScheduler.new(resourceManager, updateInterval)
    local self = setmetatable({}, UpdateScheduler)
    self._resources = resourceManager
    self._interval = updateInterval or DOOR_ESP_CONFIG.Timing.UpdateInterval
    self._tasks = {}
    return self
end

function UpdateScheduler:registerTask(key, taskFunction)
    self._tasks[key] = taskFunction
end

function UpdateScheduler:unregisterTask(key)
    self._tasks[key] = nil
end

function UpdateScheduler:start()
    local thread = task.spawn(function()
        while self._resources:isActive() do
            for key, taskFunction in pairs(self._tasks) do
                local success, err = pcall(taskFunction)
                if not success then
                    warn("[UpdateScheduler] Task '" .. key .. "' failed: " .. tostring(err))
                    self._tasks[key] = nil
                end
            end
            task.wait(self._interval)
        end
    end)

    self._resources:addThread("__scheduler__", thread)
    return thread
end

local DoorESP = {}
DoorESP.__index = DoorESP

function DoorESP.new(dependencies)
    local deps = dependencies or {}
    local self = setmetatable({}, DoorESP)
    self._discovery = deps.discovery or DoorDiscoveryService.new()
    self._factory = deps.factory or DoorHighlightFactory.new()
    self._stateReader = deps.stateReader or DoorStateReader.new()
    self._resources = nil
    self._scheduler = nil
    self._enabled = false
    return self
end

function DoorESP:_initializeDoor(door, doorTypeConfig)
    local doorKey = door:GetFullName()
    local highlightParent = doorTypeConfig.HighlightParent(door)

    if not highlightParent then
        return
    end

    local highlight = self._factory:create(highlightParent)
    self._resources:addHighlight(doorKey, highlight)

    self._scheduler:registerTask(doorKey, function()
        if not door or not door.Parent then
            self._scheduler:unregisterTask(doorKey)
            self._resources:cleanupKey(doorKey)
            return
        end

        if not highlight or not highlight.Parent then
            self._scheduler:unregisterTask(doorKey)
            self._resources:cleanupKey(doorKey)
            return
        end

        local color = self._stateReader:getColor(door, doorTypeConfig, DOOR_ESP_CONFIG.Colors)
        if color then
            highlight.FillColor = color
            highlight.OutlineColor = color
        end
    end)
end

function DoorESP:_processDoorsOfType(doorTypeConfig)
    local doors = self._discovery:discover(doorTypeConfig.Name)

    for _, door in pairs(doors) do
        self:_initializeDoor(door, doorTypeConfig)
    end
end

function DoorESP:enable()
    if self._enabled then
        return
    end

    self._enabled = true
    self._discovery:invalidateCache()

    self._resources = DoorResourceManager.new()
    self._resources:activate()

    self._scheduler = UpdateScheduler.new(self._resources)

    for _, doorTypeConfig in pairs(DOOR_ESP_CONFIG.DoorTypes) do
        self:_processDoorsOfType(doorTypeConfig)
    end

    self._scheduler:start()
end

function DoorESP:disable()
    if not self._enabled then
        return
    end

    self._enabled = false

    if self._resources then
        self._resources:cleanupAll()
        self._resources = nil
    end

    self._scheduler = nil
end

local doorEspSystem = DoorESP.new()

Esp:Toggle({
    Title = "Doors ESP",
    Desc = "Verde: Destrancada | Vermelho: Trancada",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        if state then
            doorEspSystem:enable()
        else
            doorEspSystem:disable()
        end
    end
})

local ComputerESPEnabled = false

local function ComputerESP()
    ComputerESPEnabled = true

    local map = game.ReplicatedStorage.CurrentMap.Value
    if map then
        for _, obj in pairs(map:GetChildren()) do
            if obj.Name == "ComputerTable" then
                if not obj:FindFirstChild("Highlight") then
                    local highlight = Instance.new("Highlight")
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    highlight.FillColor = Color3.fromRGB(13,105,172)
                    highlight.OutlineColor = Color3.fromRGB(20,165,255)
                    highlight.Parent = obj

                    task.spawn(function()
                        while ComputerESPEnabled and highlight.Parent do
                            local screen = obj:FindFirstChild("Screen")

                            if screen then
                                highlight.FillColor = screen.Color
                            end

                            task.wait(1)
                        end
                    end)
                end
            end
        end
    end
end


local function RemoveComputerESP()
    ComputerESPEnabled = false

    local map = game.ReplicatedStorage.CurrentMap.Value
    if map then
        for _, obj in pairs(map:GetChildren()) do
            if obj.Name == "ComputerTable" then
                local highlight = obj:FindFirstChild("Highlight")
                if highlight then
                    highlight:Destroy()
                end
            end
        end
    end
end


Esp:Toggle({
    Title = "Computer ESP",
    Desc = "Mostre os Computadores",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        if state then
            ComputerESP()
        else
            RemoveComputerESP()
        end
    end
})

local FreezePodESPEnabled = false

local function FreezePodESP()
    FreezePodESPEnabled = true

    local map = game.ReplicatedStorage.CurrentMap.Value

    if map then
        for _, pod in pairs(map:GetChildren()) do
            if pod.Name == "FreezePod" then
                
                if not pod:FindFirstChild("Highlight") then
                    local highlight = Instance.new("Highlight")
                    
                    highlight.Name = "FreezePodESP"
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    highlight.FillColor = Color3.fromRGB(120,200,255)
                    highlight.OutlineColor = Color3.fromRGB(160,255,255)
                    highlight.FillTransparency = 0.3
                    highlight.OutlineTransparency = 0
                    
                    highlight.Parent = pod
                end
            end
        end
    end
end


local function RemoveFreezePodESP()
    FreezePodESPEnabled = false

    local map = game.ReplicatedStorage.CurrentMap.Value

    if map then
        for _, pod in pairs(map:GetChildren()) do
            if pod.Name == "FreezePod" then
                
                local highlight = pod:FindFirstChild("FreezePodESP")
                
                if highlight then
                    highlight:Destroy()
                end
            end
        end
    end
end

Esp:Toggle({
    Title = "Freeze Pod ESP",
    Desc = "Mostra as cápsulas de congelamento",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        if state then
            FreezePodESP()
        else
            RemoveFreezePodESP()
        end
    end
})

-- ============================================
-- ============= HACK DETECTOR ================
-- ============================================

function IsPlayerHacking()

    local player = game.Players.LocalPlayer
    local character = player.Character

    if not character then
        return false
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if not humanoid then
        return false
    end

    local animations = humanoid:GetPlayingAnimationTracks()

    for _, anim in pairs(animations) do
        if anim.Name == "AnimTyping" then
            return true
        end
    end

    return false
end


-- ============================================
-- ============= NEVER FAIL SYSTEM ============
-- ============================================

local HackAssistEnabled = false


local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall

setreadonly(mt,false)

mt.__namecall = newcclosure(function(self,...)

    local args = {...}

    if getnamecallmethod() == "FireServer"
    and args[1] == "SetPlayerMinigameResult"
    and HackAssistEnabled
    and IsPlayerHacking() then

        args[2] = true

    end

    return oldNamecall(self, unpack(args))
end)

setreadonly(mt,true)

Hider:Toggle({
    Title = "Q to Sprint",
    Desc = "Segure Q para correr mais rápido",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        QSprint(state)
    end
})

local SpeedLock = {}

SpeedLock.Enabled = false
SpeedLock.Speed = 20
SpeedLock.Connection = nil

function SpeedLock:Enable(humanoid)
	if self.Connection then
		self.Connection:Disconnect()
	end

	self.Enabled = true

	humanoid.WalkSpeed = self.Speed

	self.Connection = humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
		if self.Enabled and humanoid.WalkSpeed ~= self.Speed then
			humanoid.WalkSpeed = self.Speed
		end
	end)
end

function SpeedLock:Disable()
	self.Enabled = false

	if self.Connection then
		self.Connection:Disconnect()
		self.Connection = nil
	end
end


Beast:Toggle({
    Title = "No Slow",
    Desc = "Mantém a velocidade em 20",
    Type = "Toggle",
    Value = false,

    Callback = function(state)

        local character = game.Players.LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            if state then
                SpeedLock:Enable(humanoid)
            else
                SpeedLock:Disable()
            end
        end
    end
})

local CrawlEnabled = false

local function EnableCrawl(state)
    CrawlEnabled = state

    local player = game.Players.LocalPlayer

    pcall(function()
        if player:FindFirstChild("TempPlayerStatsModule") then
            player.TempPlayerStatsModule.DisableCrawl.Value = not state
        end
    end)
end


Beast:Toggle({
    Title = "Enable Crawl",
    Desc = "Permite usar Crawl",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        EnableCrawl(state)
    end
})

local RemoveSoundGlowEnabled = false

local function RemoveSoundGlow(state)
    RemoveSoundGlowEnabled = state

    if state then
        local player = game.Players.LocalPlayer

        pcall(function()
            if player.Character
            and player.Character:FindFirstChild("Hammer")
            and player.Character.Hammer:FindFirstChild("Handle") then

                for _,v in pairs(player.Character.Hammer.Handle:GetChildren()) do
                    if v:IsA("Sound") then
                        v:Destroy()
                    end
                end
            end
        end)

        pcall(function()
            if player.Character
            and player.Character:FindFirstChild("Gemstone")
            and player.Character.Gemstone:FindFirstChild("Handle")
            and player.Character.Gemstone.Handle:FindFirstChild("PointLight") then

                player.Character.Gemstone.Handle.PointLight:Destroy()
            end
        end)
    end
end


Beast:Toggle({
    Title = "Remove Sound And Glow",
    Desc = "Remove som do martelo e brilho da gema",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        RemoveSoundGlow(state)
    end
})

local FixCameraEnabled = false

local function FixCamera(state)
    FixCameraEnabled = state

    if state then
        local player = game.Players.LocalPlayer

        pcall(function()
            local character = player.Character
            if not character then return end

            local humanoid = character:FindFirstChildWhichIsA("Humanoid")

            if humanoid then
                workspace.CurrentCamera.CameraSubject = humanoid
            end

            workspace.CurrentCamera.CameraType = Enum.CameraType.Custom

            player.CameraMinZoomDistance = 0.5
            player.CameraMaxZoomDistance = math.huge
            player.CameraMode = Enum.CameraMode.Classic

            if character:FindFirstChild("Head") then
                character.Head.Anchored = false
            end
        end)
    end
end


Beast:Toggle({
    Title = "Fix Camera",
    Desc = "Corrige a câmera travada",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        FixCamera(state)
    end
})

local QSprintEnabled = false
local QSprintBegan
local QSprintEnded

local function QSprint(state)
    QSprintEnabled = state

    if QSprintBegan then
        QSprintBegan:Disconnect()
        QSprintBegan = nil
    end

    if QSprintEnded then
        QSprintEnded:Disconnect()
        QSprintEnded = nil
    end

    if state then
        local UIS = game:GetService("UserInputService")
        local player = game.Players.LocalPlayer

        QSprintBegan = UIS.InputBegan:Connect(function(key)
            if key.KeyCode == Enum.KeyCode.Q then
                pcall(function()
                    if player.Character and player.Character:FindFirstChild("Humanoid") then
                        player.Character.Humanoid.WalkSpeed = 30
                    end
                end)
            end
        end)

        QSprintEnded = UIS.InputEnded:Connect(function(key)
            if key.KeyCode == Enum.KeyCode.Q then
                pcall(function()
                    if player.Character and player.Character:FindFirstChild("Humanoid") then
                        player.Character.Humanoid.WalkSpeed = 16
                    end
                end)
            end
        end)

        pcall(function()
            player.Character.PowersLocalScript:Destroy()
        end)

    else
        pcall(function()
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = 16
            end
        end)
    end
end


Hider:Toggle({
    Title = "Q to Sprint",
    Desc = "Segure Q para correr mais rápido",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        QSprint(state)
    end
})
