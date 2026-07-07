local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

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
    Icon = "door-open", -- lucide icon
    Author = "by blackzw.mp3",
    Folder = "MirrorsHub/FTF2",
    
    -- ↓ This all is Optional. You can remove it.
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
        Anonymous = true,
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
        Color3.fromHex("840ee6"), -- Roxo principal
        Color3.fromHex("35065c")  -- Roxo claro
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

local SuperESP = {}
SuperESP.__index = SuperESP

local CONFIG = {
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
        return CONFIG.Colors.Beast
    end
    return CONFIG.Colors.Survivor
end

function SuperESP:createVisuals(character, rootPart)
    local key = "visuals_" .. character.Name
    
    local existingFolder = character:FindFirstChild(CONFIG.FolderName)
    if existingFolder then
        existingFolder:Destroy()
    end
    
    local folder = Instance.new("Folder")
    folder.Name = CONFIG.FolderName
    folder.Parent = character
    self.resources:addInstance(key, folder)
    
    local highlight = Instance.new("Highlight")
    highlight.Adornee = character
    highlight.FillTransparency = CONFIG.FillTransparency
    highlight.OutlineTransparency = CONFIG.OutlineTransparency
    highlight.Parent = folder
    self.resources:addInstance(key, highlight)
    
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = rootPart
    billboard.Size = CONFIG.BillboardSize
    billboard.StudsOffset = CONFIG.BillboardOffset
    billboard.AlwaysOnTop = true
    billboard.Name = "EspGui"
    billboard.Parent = folder
    self.resources:addInstance(key, billboard)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Font = CONFIG.Font
    label.TextSize = CONFIG.TextSize
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
            
            task.wait(CONFIG.UpdateInterval)
        end
    end)
    
    self.resources:addThread(key, thread)
end

function SuperESP:setupPlayer(player)
    if player == self.getLocalPlayer() then return end
    
    local key = "player_" .. player.Name
    
    local function onCharacterAdded(character)
        local rootPart = character:WaitForChild("HumanoidRootPart", CONFIG.HumanoidRootPartTimeout)
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
            local folder = character:FindFirstChild(CONFIG.FolderName)
            if folder then
                folder:Destroy()
            end
        end
    end
    
    self.resources:cleanupAll()
end

local espSystem = SuperESP.new()

local Toggle = Esp:Toggle({
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

local Config = {
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

local HighlightFactory = {}
HighlightFactory.__index = HighlightFactory

function HighlightFactory.new(config)
    local self = setmetatable({}, HighlightFactory)
    self._config = config or Config.HighlightDefaults
    return self
end

function HighlightFactory:create(parent)
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
    self._config = stateConfig or Config.StateValues
    return self
end

function DoorStateReader:read(door, doorTypeConfig)
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

local ResourceManager = {}
ResourceManager.__index = ResourceManager

function ResourceManager.new()
    local self = setmetatable({}, ResourceManager)
    self._highlights = {}
    self._threads = {}
    self._connections = {}
    self._active = false
    return self
end

function ResourceManager:addHighlight(key, highlight)
    local bucket = self._highlights[key]
    if not bucket then
        bucket = {}
        self._highlights[key] = bucket
    end
    table.insert(bucket, highlight)
end

function ResourceManager:addThread(key, thread)
    local bucket = self._threads[key]
    if not bucket then
        bucket = {}
        self._threads[key] = bucket
    end
    table.insert(bucket, thread)
end

function ResourceManager:addConnection(key, connection)
    local bucket = self._connections[key]
    if not bucket then
        bucket = {}
        self._connections[key] = bucket
    end
    table.insert(bucket, connection)
end

function ResourceManager:cleanupKey(key)
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

function ResourceManager:cleanupAll()
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

function ResourceManager:activate()
    self._active = true
end

function ResourceManager:isActive()
    return self._active
end

local UpdateScheduler = {}
UpdateScheduler.__index = UpdateScheduler

function UpdateScheduler.new(resourceManager, updateInterval)
    local self = setmetatable({}, UpdateScheduler)
    self._resources = resourceManager
    self._interval = updateInterval or Config.Timing.UpdateInterval
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
    self._factory = deps.factory or HighlightFactory.new()
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

        local color = self._stateReader:getColor(door, doorTypeConfig, Config.Colors)
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

    self._resources = ResourceManager.new()
    self._resources:activate()

    self._scheduler = UpdateScheduler.new(self._resources)

    for _, doorTypeConfig in pairs(Config.DoorTypes) do
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

local Toggle = Esp:Toggle({
    Title = "Door ESP",
    Desc = "Azul: Destrancada | Vermelho: Trancada",
    Icon = "door",
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

local Config = {
	ComputerName = "ComputerTable",
	Colors = {
		Default = Color3.new(1, 1, 1),
		Hacking = Color3.new(0, 0, 1),
		Hacked = Color3.new(0, 1, 0),
	},
	BrickColors = {
		Hacking = BrickColor.new("Bright blue"),
		Hacked = BrickColor.new("Dark green"),
	},
	HighlightDefaults = {
		FillColor = Color3.new(1, 1, 1),
		OutlineColor = Color3.new(1, 1, 1),
		FillTransparency = 0.5,
		OutlineTransparency = 0,
	},
}

local ComputerDiscoveryService = {}
ComputerDiscoveryService.__index = ComputerDiscoveryService

function ComputerDiscoveryService.new(workspaceInstance)
	local self = setmetatable({}, ComputerDiscoveryService)
	self._workspace = workspaceInstance or workspace
	self._cache = {}
	self._descendantAddedConn = nil
	self._descendantRemovingConn = nil
	self._addedListeners = {}
	self._removingListeners = {}
	return self
end

function ComputerDiscoveryService:discover()
	local cacheKey = "__all__"
	if self._cache[cacheKey] then
		return self._cache[cacheKey]
	end

	local computers = {}
	for _, descendant in pairs(self._workspace:GetDescendants()) do
		if descendant.Name == Config.ComputerName then
			table.insert(computers, descendant)
		end
	end

	self._cache[cacheKey] = computers
	return computers
end

function ComputerDiscoveryService:onComputerAdded(callback)
	table.insert(self._addedListeners, callback)
end

function ComputerDiscoveryService:onComputerRemoving(callback)
	table.insert(self._removingListeners, callback)
end

function ComputerDiscoveryService:startListening()
	if self._descendantAddedConn then
		return
	end

	self._descendantAddedConn = self._workspace.DescendantAdded:Connect(function(descendant)
		if descendant.Name ~= Config.ComputerName then
			return
		end
		local cacheKey = "__all__"
		if self._cache[cacheKey] then
			table.insert(self._cache[cacheKey], descendant)
		end
		for _, callback in pairs(self._addedListeners) do
			callback(descendant)
		end
	end)

	self._descendantRemovingConn = self._workspace.DescendantRemoving:Connect(function(descendant)
		if descendant.Name ~= Config.ComputerName then
			return
		end
		local cacheKey = "__all__"
		if self._cache[cacheKey] then
			for i, computer in pairs(self._cache[cacheKey]) do
				if computer == descendant then
					table.remove(self._cache[cacheKey], i)
					break
				end
			end
		end
		for _, callback in pairs(self._removingListeners) do
			callback(descendant)
		end
	end)
end

function ComputerDiscoveryService:stopListening()
	if self._descendantAddedConn then
		self._descendantAddedConn:Disconnect()
		self._descendantAddedConn = nil
	end
	if self._descendantRemovingConn then
		self._descendantRemovingConn:Disconnect()
		self._descendantRemovingConn = nil
	end
end

function ComputerDiscoveryService:invalidateCache()
	self._cache = {}
end

local HighlightFactory = {}
HighlightFactory.__index = HighlightFactory

function HighlightFactory.new(config)
	local self = setmetatable({}, HighlightFactory)
	self._config = config or Config.HighlightDefaults
	return self
end

function HighlightFactory:create(parent)
	local existing = parent:FindFirstChildOfClass("Highlight")
	if existing then
		existing:Destroy()
	end

	local highlight = Instance.new("Highlight")
	highlight.FillColor = self._config.FillColor
	highlight.OutlineColor = self._config.OutlineColor
	highlight.FillTransparency = self._config.FillTransparency
	highlight.OutlineTransparency = self._config.OutlineTransparency
	highlight.Parent = parent
	return highlight
end

local ComputerStateReader = {}
ComputerStateReader.__index = ComputerStateReader

function ComputerStateReader.new(brickColorConfig)
	local self = setmetatable({}, ComputerStateReader)
	self._config = brickColorConfig or Config.BrickColors
	return self
end

function ComputerStateReader:read(computer)
	local screen = computer:FindFirstChild("Screen")
	if not screen then
		return nil
	end

	if not screen:IsA("BasePart") then
		return nil
	end

	return screen.BrickColor
end

function ComputerStateReader:getColor(computer, colorConfig)
	local brickColor = self:read(computer)
	if not brickColor then
		return nil
	end

	if brickColor == self._config.Hacking then
		return colorConfig.Hacking
	end
	if brickColor == self._config.Hacked then
		return colorConfig.Hacked
	end

	return colorConfig.Default
end

local ResourceManager = {}
ResourceManager.__index = ResourceManager

function ResourceManager.new()
	local self = setmetatable({}, ResourceManager)
	self._highlights = {}
	self._connections = {}
	self._active = false
	return self
end

function ResourceManager:addHighlight(key, highlight)
	local bucket = self._highlights[key]
	if not bucket then
		bucket = {}
		self._highlights[key] = bucket
	end
	table.insert(bucket, highlight)
end

function ResourceManager:addConnection(key, connection)
	local bucket = self._connections[key]
	if not bucket then
		bucket = {}
		self._connections[key] = bucket
	end
	table.insert(bucket, connection)
end

function ResourceManager:hasKey(key)
	return self._highlights[key] ~= nil or self._connections[key] ~= nil
end

function ResourceManager:cleanupKey(key)
	local connections = self._connections[key]
	if connections then
		for _, connection in pairs(connections) do
			if connection.Connected then
				connection:Disconnect()
			end
		end
		self._connections[key] = nil
	end

	local highlights = self._highlights[key]
	if highlights then
		for _, highlight in pairs(highlights) do
			if highlight.Parent then
				highlight:Destroy()
			end
		end
		self._highlights[key] = nil
	end
end

function ResourceManager:cleanupAll()
	local keys = {}

	for key in pairs(self._highlights) do
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

function ResourceManager:activate()
	self._active = true
end

function ResourceManager:isActive()
	return self._active
end

local ComputerESP = {}
ComputerESP.__index = ComputerESP

function ComputerESP.new(dependencies)
	local deps = dependencies or {}
	local self = setmetatable({}, ComputerESP)
	self._discovery = deps.discovery or ComputerDiscoveryService.new()
	self._factory = deps.factory or HighlightFactory.new()
	self._stateReader = deps.stateReader or ComputerStateReader.new()
	self._resources = nil
	self._enabled = false
	return self
end

function ComputerESP:_initializeComputer(computer)
	local computerKey = computer:GetFullName()

	if self._resources:hasKey(computerKey) then
		return
	end

	local highlight = self._factory:create(computer)
	self._resources:addHighlight(computerKey, highlight)

	self:_updateComputerColor(computer, highlight)

	self:_listenToScreenChanges(computer, computerKey, highlight)
end

function ComputerESP:_updateComputerColor(computer, highlight)
	if not computer:IsDescendantOf(game) then
		return
	end

	if not highlight:IsDescendantOf(game) then
		return
	end

	local color = self._stateReader:getColor(computer, Config.Colors)
	if color then
		highlight.FillColor = color
		highlight.OutlineColor = color
	end
end

function ComputerESP:_listenToScreenChanges(computer, computerKey, highlight)
	local screen = computer:FindFirstChild("Screen")
	if not screen then
		return
	end

	if not screen:IsA("BasePart") then
		return
	end

	local connectionKey = computerKey .. "_screen"
	local connection = screen:GetPropertyChangedSignal("BrickColor"):Connect(function()
		self:_updateComputerColor(computer, highlight)
	end)

	self._resources:addConnection(connectionKey, connection)
end

function ComputerESP:_onComputerAdded(computer)
	if not self._enabled then
		return
	end

	self:_initializeComputer(computer)
end

function ComputerESP:_onComputerRemoving(computer)
	local computerKey = computer:GetFullName()
	self._resources:cleanupKey(computerKey)
end

function ComputerESP:_processAllComputers()
	local computers = self._discovery:discover()

	for _, computer in pairs(computers) do
		self:_initializeComputer(computer)
	end
end

function ComputerESP:enable()
	if self._enabled then
		return
	end

	self._enabled = true
	self._discovery:invalidateCache()

	self._resources = ResourceManager.new()
	self._resources:activate()

	self._discovery:onComputerAdded(function(computer)
		self:_onComputerAdded(computer)
	end)

	self._discovery:onComputerRemoving(function(computer)
		self:_onComputerRemoving(computer)
	end)

	self._discovery:startListening()

	self:_processAllComputers()
end

function ComputerESP:disable()
	if not self._enabled then
		return
	end

	self._enabled = false

	self._discovery:stopListening()

	if self._resources then
		self._resources:cleanupAll()
		self._resources = nil
	end
end

local computerEspSystem = ComputerESP.new()

local Toggle = Esp:Toggle({
	Title = "Computer ESP",
	Desc = "Branco: Normal | Azul: Hackeando | Verde: Hackeado",
	Type = "Toggle",
	Value = false,
	Callback = function(state)
		if state then
			computerEspSystem:enable()
		else
			computerEspSystem:disable()
		end
	end,
})