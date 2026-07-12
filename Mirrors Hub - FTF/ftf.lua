-- ==========================================
-- [ INTERFACE INITIALIZATION ]
-- ==========================================
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- ==========================================
-- [ THEME CONFIGURATIONS ]
-- ==========================================
WindUI:AddTheme({
    Name = "PurpleDark",
    Accent = WindUI:Gradient({                                                      
        ["0"] = { Color = Color3.fromHex("8b5cf6"), Transparency = 0 },            
        ["100"]   = { Color = Color3.fromHex("6d28d9"), Transparency = 0 },        
    }, { Rotation = 90 }),
    Background = Color3.fromHex("090611"), 
    Outline = Color3.fromHex("211a30"),
    Text = Color3.fromHex("f3f4f6"),
    Placeholder = Color3.fromHex("6b7280"),
    Button = WindUI:Gradient({                                                      
        ["0"] = { Color = Color3.fromHex("2e165b"), Transparency = 0 },            
        ["100"]   = { Color = Color3.fromHex("1c0d3a"), Transparency = 0 },        
    }, { Rotation = 90 }),
    Icon = Color3.fromHex("c084fc"),
    Hover = Color3.fromHex("a78bfa"),
    BackgroundTransparency = 0,
    WindowBackground = Color3.fromHex("090611"), 
    WindowShadow = Color3.fromHex("020105"),
    DialogBackground = Color3.fromHex("110c22"),
    DialogBackgroundTransparency = 0,
    DialogTitle = Color3.fromHex("f3f4f6"),
    DialogContent = Color3.fromHex("d8b4fe"),
    DialogIcon = Color3.fromHex("c084fc"),
    WindowTopbarButtonIcon = Color3.fromHex("c084fc"),
    WindowTopbarTitle = Color3.fromHex("f3f4f6"),
    WindowTopbarAuthor = Color3.fromHex("a78bfa"),
    WindowTopbarIcon = Color3.fromHex("8b5cf6"),
    TabBackground = Color3.fromHex("140e28"),
    TabTitle = Color3.fromHex("f3f4f6"),
    TabIcon = Color3.fromHex("c084fc"),
    ElementBackground = Color3.fromHex("110c22"),
    ElementTitle = Color3.fromHex("f3f4f6"),
    ElementDesc = Color3.fromHex("9ca3af"),
    ElementIcon = Color3.fromHex("c084fc"),
    PopupBackground = Color3.fromHex("110c22"),
    PopupBackgroundTransparency = 0,
    PopupTitle = Color3.fromHex("f3f4f6"),
    PopupContent = Color3.fromHex("d8b4fe"),
    PopupIcon = Color3.fromHex("c084fc"),
    Toggle = Color3.fromHex("2e165b"),
    ToggleBar = Color3.fromHex("8b5cf6"),
    Checkbox = Color3.fromHex("2e165b"),
    CheckboxIcon = Color3.fromHex("8b5cf6"),
    Slider = Color3.fromHex("2e165b"),
    SliderThumb = Color3.fromHex("a78bfa"),
})

-- ==========================================
-- [ MAIN WINDOW CREATION ]
-- ==========================================
local Window = WindUI:CreateWindow({
    Title = "Mirrors Hub - Flee The Facility",
    Icon = "door-open",
    Author = "by blackzw.mp3",
    Folder = "MirrorsHub/FTF",
    Size = UDim2.fromOffset(580, 460),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),
    Transparent = true,
    Resizable = true,
    Theme = "PurpleDark",
    SideBarWidth = 200,
    BackgroundImageTransparency = 0.42,
    HideSearchBar = true,
    ScrollBarEnabled = false,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function() print("hi guys") end,
    },
})

Window:SetToggleKey(Enum.KeyCode.K)

Window:EditOpenButton({
    Title = "Open Mirrors Hub - FTF",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 16),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromHex("6d28d9"), Color3.fromHex("1c0d3a")),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

-- ==========================================
-- [ TABS NAVIGATION ]
-- ==========================================
local Main = Window:Tab({Title = "Main", Icon = "house"})
local Esp = Window:Tab({Title = "ESP", Icon = "eye"})
local Beast = Window:Tab({Title = "Beast", Icon = "skull"})
local Hider = Window:Tab({Title = "Hider", Icon = "user"})
local Misc = Window:Tab({Title = "Misc", Icon = "layers"})
local Config = Window:Tab({Title = "Config", Icon = "cog"})

-- ==========================================
-- [ ESP FUNCTIONS / LOGIC - PORTAS ]
-- ==========================================
getgenv().DoorESP = false

local function removeDoorESP()
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "SingleDoor" and v:FindFirstChild("Door") then
            local hl = v.Door:FindFirstChild("Highlight")
            if hl then pcall(function() hl:Destroy() end) end
        elseif v.Name == "DoubleDoor" then
            local hl = v:FindFirstChild("Highlight")
            if hl then pcall(function() hl:Destroy() end) end
        end
    end
end

local function startDoorESP()
    removeDoorESP()
    task.spawn(function()
        while getgenv().DoorESP do
            for _, v in pairs(workspace:GetDescendants()) do
                if not getgenv().DoorESP then break end

                if v.Name == "SingleDoor" and v:FindFirstChild("Door") and v:FindFirstChild("DoorTrigger") then
                    pcall(function()
                        local highlight = v.Door:FindFirstChild("Highlight")
                        if not highlight then
                            highlight = Instance.new("Highlight")
                            highlight.FillTransparency = 0.7
                            highlight.OutlineTransparency = 0.5
                            highlight.Parent = v.Door
                        end
                        
                        if v.DoorTrigger.ActionSign.Value == 11 then
                            highlight.FillColor = Color3.fromRGB(150, 255, 180)
                            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        elseif v.DoorTrigger.ActionSign.Value == 10 then
                            highlight.FillColor = Color3.fromRGB(255, 255, 255)
                            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        end
                    end)
                elseif v.Name == "DoubleDoor" and v:FindFirstChild("DoorTrigger") then
                    pcall(function()
                        local highlight = v:FindFirstChild("Highlight")
                        if not highlight then
                            highlight = Instance.new("Highlight")
                            highlight.FillTransparency = 0.7
                            highlight.OutlineTransparency = 0.5
                            highlight.Parent = v
                        end
                        
                        if v.DoorTrigger.ActionSign.Value == 11 then
                            highlight.FillColor = Color3.fromRGB(150, 255, 180)
                            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        elseif v.DoorTrigger.ActionSign.Value == 10 then
                            highlight.FillColor = Color3.fromRGB(255, 255, 255)
                            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        end
                    end)
                end
            end
            task.wait(0.5) 
        end
    end)
end

-- ==========================================
-- [ PLAYER ESP FUNCTIONS / LOGIC ]
-- ==========================================
getgenv().PlayerESP = false

local function removePlayerESP()
    for _, v in pairs(game.Players:GetPlayers()) do
        if v.Character then
            local folder = v.Character:FindFirstChild(v.Name .. "'s ESP")
            if folder then pcall(function() folder:Destroy() end) end
        end
    end
end

local function startPlayerESP()
    removePlayerESP()
    task.spawn(function()
        while getgenv().PlayerESP do
            local localPlayer = game.Players.LocalPlayer
            for _, v in pairs(game.Players:GetPlayers()) do
                if not getgenv().PlayerESP then break end
                
                if v ~= localPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("HumanoidRootPart") then
                    pcall(function()
                        local char = v.Character
                        local folder = char:FindFirstChild(v.Name .. "'s ESP")
                        
                        if not folder then
                            folder = Instance.new("Folder")
                            folder.Name = v.Name .. "'s ESP"
                            folder.Parent = char
                            
                            local highlight = Instance.new("Highlight")
                            highlight.Name = "PlrHighlight"
                            highlight.FillTransparency = 0.5
                            highlight.OutlineTransparency = 0
                            highlight.Adornee = char
                            highlight.Parent = folder
                            
                            local bbg = Instance.new("BillboardGui")
                            bbg.Name = "TagGui"
                            bbg.AlwaysOnTop = true
                            bbg.Size = UDim2.new(0, 200, 0, 50)
                            bbg.StudsOffset = Vector3.new(0, 1.8, 0)
                            bbg.Parent = folder
                            bbg.Adornee = char.Head
                            
                            local textLabel = Instance.new("TextLabel")
                            textLabel.Name = "InfoLabel"
                            textLabel.BackgroundTransparency = 1
                            textLabel.Size = UDim2.new(1, 0, 1, 0)
                            textLabel.Font = Enum.Font.Roboto
                            textLabel.TextSize = 16
                            textLabel.TextStrokeTransparency = 0
                            textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                            textLabel.Parent = bbg
                        end
                        
                        local highlight = folder:FindFirstChild("PlrHighlight")
                        local label = folder:FindFirstChild("TagGui") and folder.TagGui:FindFirstChild("InfoLabel")
                        
                        if highlight and label then
                            local distance = math.floor((localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") and (char.HumanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude) or 0)
                            local isBeast = v:FindFirstChild("TempPlayerStatsModule") and v.TempPlayerStatsModule:FindFirstChild("IsBeast") and v.TempPlayerStatsModule.IsBeast.Value
                            
                            if isBeast then
                                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                                highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
                                label.TextColor3 = Color3.fromRGB(255, 20, 20)
                                label.Text = "Beast: " .. v.Name .. " [" .. distance .. "]"
                            else
                                highlight.FillColor = Color3.fromRGB(0, 150, 255)
                                highlight.OutlineColor = Color3.fromRGB(0, 255, 255)
                                label.TextColor3 = Color3.fromRGB(0, 180, 255)
                                label.Text = v.Name .. " [" .. distance .. "]"
                            end
                        end
                    end)
                end
            end
            task.wait(0.05)
        end
    end)
end

local currentAnimTrack = nil
local connection = nil
local player = game.Players.LocalPlayer
local remote = game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvent")
local animStorage = game:GetService("ReplicatedStorage"):FindFirstChild("Animations")
local animPath = animStorage and animStorage:FindFirstChild("AnimCrawl")

local Toggle = Beast:Toggle({
    Title = "Crawl Button",
    Desc = "Ativa o rastejo sincronizado e visivel para todos",
    Type = "Toggle",
    Value = false,
    Callback = function(state) 
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local animator = hum and hum:FindFirstChildOfClass("Animator")
        
        if state then
            if hum and animator and animPath then
                hum.HipHeight = -1.85 
                hum.WalkSpeed = 11
                
                currentAnimTrack = animator:LoadAnimation(animPath)
                currentAnimTrack.Priority = Enum.AnimationPriority.Action4
                
                currentAnimTrack:Play()
                currentAnimTrack:AdjustSpeed(0)
                
                connection = hum:GetPropertyChangedSignal("MoveDirection"):Connect(function()
                    if currentAnimTrack then
                        if hum.MoveDirection.Magnitude > 0 then
                            currentAnimTrack:AdjustSpeed(1.6)
                        else
                            currentAnimTrack:AdjustSpeed(0)
                        end
                    end
                end)
                
                if hum.MoveDirection.Magnitude > 0 then
                    currentAnimTrack:AdjustSpeed(1.6)
                end
            end
            
            task.spawn(function()
                while state and player.Character == char do
                    if remote then 
                        remote:FireServer("Input", "Crawl", true) 
                    end
                    task.wait(0.05)
                end
            end)
            
        else
            if connection then connection:Disconnect() end
            if currentAnimTrack then currentAnimTrack:Stop() end
            
            if hum then
                hum.HipHeight = 0
                hum.WalkSpeed = 16
            end
            
            if remote then 
                remote:FireServer("Input", "Crawl", false) 
            end
        end
    end
})

-- ==========================================
-- [ COMPUTER ESP FUNCTIONS / LOGIC ]
-- ==========================================
getgenv().ComputerESP = false

local function removeComputerESP()
    for _, v in pairs(workspace:GetDescendants()) do 
        if v.Name == "ComputerTable" then
            local hl = v:FindFirstChild("Highlight")
            if hl then pcall(function() hl:Destroy() end) end
        end
    end
end

local function startComputerESP()
    removeComputerESP()
    task.spawn(function()
        while getgenv().ComputerESP do
            for _, v in pairs(workspace:GetDescendants()) do
                if not getgenv().ComputerESP then break end
                
                if v.Name == "ComputerTable" and v:FindFirstChild("Screen") then
                    pcall(function()
                        local highlight = v:FindFirstChild("Highlight")
                        if not highlight then
                            highlight = Instance.new("Highlight")
                            highlight.FillTransparency = 0.5
                            highlight.OutlineTransparency = 0.3
                            highlight.Parent = v
                        end
                        
                        if v.Screen.BrickColor == BrickColor.new("Bright blue") then
                            highlight.FillColor = Color3.fromRGB(0, 120, 255) 
                            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        elseif v.Screen.BrickColor == BrickColor.new("Dark green") then
                            highlight.FillColor = Color3.fromRGB(0, 255, 100) 
                            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        end
                    end)
                end
            end
            task.wait(0.5)
        end
    end)
end

-- ==========================================
-- [ FREEZE POD ESP FUNCTIONS / LOGIC ]
-- ==========================================
getgenv().FreezePodESP = false

local function removeFreezePodESP()
    for _, v in pairs(workspace:GetDescendants()) do 
        if v.Name == "FreezePod" then
            local hl = v:FindFirstChild("Highlight")
            if hl then pcall(function() hl:Destroy() end) end
        end
    end
end

local function startFreezePodESP()
    removeFreezePodESP()
    task.spawn(function()
        while getgenv().FreezePodESP do
            for _, v in pairs(workspace:GetDescendants()) do
                if not getgenv().FreezePodESP then break end
                
                if v.Name == "FreezePod" then
                    pcall(function()
                        local highlight = v:FindFirstChild("Highlight")
                        if not highlight then
                            highlight = Instance.new("Highlight")
                            highlight.FillColor = Color3.fromRGB(200, 50, 255)
                            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                            highlight.FillTransparency = 0.5
                            highlight.OutlineTransparency = 0.3
                            highlight.Parent = v
                        end
                    end)
                end
            end
            task.wait(0.5)
        end
    end)
end

-- ==========================================
-- [ INTERFACE TOGGLES (ESP) ]
-- ==========================================
local ToggleDoor = Esp:Toggle({
    Title = "Door Esp",
    Desc = "Mostra o status das portas (Verde/Vermelho)",
    Type = "Toggle",
    Value = false,
    Callback = function(state) 
        getgenv().DoorESP = state
        if state then startDoorESP() else removeDoorESP() end
    end
})

local TogglePlayer = Esp:Toggle({
    Title = "Player Esp",
    Desc = "Mostra a localizacao dos jogadores e destaca a Beast",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        getgenv().PlayerESP = state
        if state then startPlayerESP() else removePlayerESP() end
    end
})

local ToggleComputer = Esp:Toggle({
    Title = "Computer Esp",
    Desc = "Mostra e atualiza a cor dos computadores do mapa",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        getgenv().ComputerESP = state
        if state then startComputerESP() else removeComputerESP() end
    end
})

local ToggleFreeze = Esp:Toggle({
    Title = "Freeze Pod Esp",
    Desc = "Mostra a localizacao dos tubos de congelamento",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        getgenv().FreezePodESP = state 
        if state then startFreezePodESP() else removeFreezePodESP() end
    end
})

-- ==========================================
-- [ HIDER FUNCTIONS (SOBREVIVENTE) ]
-- ==========================================
getgenv().AutoHack = false

local ToggleAutoHack = Hider:Toggle({
    Title = "Auto Hack Perfeito",
    Desc = "Acerta automaticamente todos os minijogos dos computadores",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        getgenv().AutoHack = state
        if state then
            task.spawn(function()
                while getgenv().AutoHack do
                    pcall(function()
                        game.ReplicatedStorage.RemoteEvent:FireServer("SetPlayerMinigameResult", true)
                    end)
                    task.wait(0.05) 
                end
            end)
        end
    end
})

getgenv().FE_Invisible_Active = false

local ToggleInvisible = Hider:Toggle({
    Title = "Invisibilidade FE (Tecla F)",
    Desc = "Te deixa invisível no servidor. Requer Anti-Cheat desativado!",
    Type = "Toggle",
    Value = false,
    Callback = function(state)
        getgenv().FE_Invisible_Active = state
        if state then
            task.spawn(function()
                local Global = getgenv()
                local First = true
                local SoundService = game:GetService("SoundService")
                local StoredCF
                local SafeZone = Global.SafeZone or CFrame.new(0, -300, 0)
                local ScriptStart = true
                local DeleteOnDeath = {}
                local Activate = Global.Key or "F"

                if Global.Running then return end
                Global.Running = true

                local IsInvisible = false
                local LP = game:GetService("Players").LocalPlayer
                local UserInputService = game:GetService("UserInputService")
                
                repeat task.wait() until LP.Character and LP.Character:FindFirstChild("Humanoid")
                local RealChar = LP.Character
                RealChar.Archivable = true
                
                local FakeChar = RealChar:Clone()
                FakeChar:WaitForChild("Humanoid").DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                FakeChar.Parent = workspace

                for _, child in pairs(FakeChar:GetDescendants()) do
                    if child:IsA("BasePart") and child.CanCollide == true then
                        child.CanCollide = false
                    end
                end

                FakeChar:SetPrimaryPartCFrame(SafeZone * CFrame.new(0, 5, 0))

                local Part = Instance.new("Part", workspace)
                Part.Anchored = true
                Part.Size = Vector3.new(200, 1, 200)
                Part.CFrame = SafeZone
                Part.CanCollide = true

                for i, v in pairs(FakeChar:GetDescendants()) do
                    if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
                        v.Transparency = 0.7
                    end
                end

                local function Visible()
                    StoredCF = FakeChar:GetPrimaryPartCFrame()
                    for _, child in pairs(RealChar:GetDescendants()) do
                        if child:IsA("BasePart") and child.CanCollide == true then
                            child.CanCollide = true
                        end
                    end
                    RealChar:WaitForChild("HumanoidRootPart").Anchored = false
                    RealChar:SetPrimaryPartCFrame(StoredCF)
                    LP.Character = RealChar
                    FakeChar:WaitForChild("Humanoid"):UnequipTools()
                    workspace.CurrentCamera.CameraSubject = RealChar:WaitForChild("Humanoid")
                    FakeChar:SetPrimaryPartCFrame(SafeZone * CFrame.new(0, 5, 0))
                end

                local function Invisible()
                    StoredCF = RealChar:GetPrimaryPartCFrame()
                    FakeChar:SetPrimaryPartCFrame(StoredCF)
                    FakeChar:WaitForChild("HumanoidRootPart").Anchored = false
                    LP.Character = FakeChar
                    workspace.CurrentCamera.CameraSubject = FakeChar:WaitForChild("Humanoid")
                    for _, child in pairs(RealChar:GetDescendants()) do
                        if child:IsA("BasePart") and child.CanCollide == true then
                            child.CanCollide = false
                        end
                    end
                    RealChar:SetPrimaryPartCFrame(SafeZone * CFrame.new(0, 5, 0))
                end

                local function StopScript()
                    if not ScriptStart then return end
                    pcall(function() Part:Destroy() end)
                    if IsInvisible and RealChar:FindFirstChild("HumanoidRootPart") then Visible() end
                    workspace.CurrentCamera.CameraSubject = RealChar:WaitForChild("Humanoid")
                    if FakeChar then pcall(function() FakeChar:Destroy() end) end
                    Global.Running = false
                    ScriptStart = false
                end

                RealChar:WaitForChild("Humanoid").Died:Connect(StopScript)
                FakeChar:WaitForChild("Humanoid").Died:Connect(StopScript)

                local connection
                connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if not getgenv().FE_Invisible_Active or not ScriptStart then 
                        connection:Disconnect() 
                        StopScript()
                        return 
                    end
                    if gameProcessed then return end
                    if input.KeyCode.Name:lower() ~= Activate:lower() then return end
                    
                    if not IsInvisible then
                        Invisible()
                        IsInvisible = true
                    else
                        Visible()
                        IsInvisible = false
                    end
                end)
            end)
        else
            getgenv().Running = false
        end
    end
})

-- 1. VARIÁVEL DE CONTROLE
local RemoveRope_Ativo = false

-- 2. CRIAÇÃO DO TOGGLE NA WINDUI
local ToggleRemoveRope = Hider:Toggle({
    Title = "Remove Rope (You)",
    Desc = "Liberta você automaticamente se a Besta te puxar ou carregar",
    Type = "Toggle",
    Value = false,
    Callback = function(state) 
        RemoveRope_Ativo = state
    end
})

-- 3. FUNÇÕES AUXILIARES DE CHECAGEM
local function IsThereChar(plr)
    local p = plr or game.Players.LocalPlayer
    return p and p.Character and p.Character:FindFirstChild("HumanoidRootPart")
end

-- 4. FUNÇÃO COM A LÓGICA DO UNTIEME
local function ExecutarRemoveRope()
    -- Se o botão estiver desativado, não faz nada
    if not RemoveRope_Ativo then return end

    local localChar = game.Players.LocalPlayer.Character
    if not IsThereChar(game.Players.LocalPlayer) then return end

    -- Procura pela Besta na partida
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v:FindFirstChild("TempPlayerStatsModule") then
            local isBeastObj = v.TempPlayerStatsModule:FindFirstChild("IsBeast")
            
            -- Se o jogador for a Besta e tiver um personagem válido
            if isBeastObj and isBeastObj.Value == true and IsThereChar(v) then
                local char = v.Character
                local hammer = char:FindFirstChild("Hammer")

                -- Verifica se ela tem o martelo e o evento remoto
                if hammer and hammer:FindFirstChild("HammerEvent") then
                    
                    -- Escaneia o personagem da Besta procurando por cordas presas em você
                    for _, descendant in pairs(char:GetDescendants()) do
                        if descendant:IsA("RopeConstraint") then
                            local att0 = descendant.Attachment0
                            local att1 = descendant.Attachment1
                            
                            -- Se a corda estiver conectada a qualquer parte do seu corpo, força a Besta a te soltar
                            if (att0 and att0:IsDescendantOf(localChar)) or (att1 and att1:IsDescendantOf(localChar)) then
                                hammer.HammerEvent:FireServer("HammerClick", true)
                            end
                        end
                    end

                end
            end
        end
    end
end

-- 5. LOOP DE ATUALIZAÇÃO (Coloque junto com seus outros loops no final do script)
task.spawn(function()
    while true do
        task.wait(0.1) -- Checa 10 vezes por segundo de forma super leve
        pcall(ExecutarRemoveRope)
    end
end)

-- 1. VARIÁVEIS DE CONTROLE
local RemoveRopeAll_Ativo = false
local SlowBeast_Ativo = false

-- 2. CRIAÇÃO DOS TOGGLES NA WINDUI
local ToggleRemoveRopeAll = Hider:Toggle({
    Title = "Remove Rope (All)",
    Desc = "Força a Besta a soltar qualquer jogador que ela tente carregar ou prender",
    Type = "Toggle",
    Value = false,
    Callback = function(state) 
        RemoveRopeAll_Ativo = state
    end
})

local ToggleSlowBeast = Hider:Toggle({
    Title = "Slow Down Beast",
    Desc = "Deixa a Besta lenta ou travada forçando o evento de pulo dela",
    Type = "Toggle",
    Value = false,
    Callback = function(state) 
        SlowBeast_Ativo = state
    end
})

-- 3. FUNÇÕES AUXILIARES DE CHECAGEM
local function IsThereChar(plr)
    local p = plr or game.Players.LocalPlayer
    return p and p.Character and p.Character:FindFirstChild("HumanoidRootPart")
end

-- 4. FUNÇÃO COM A LÓGICA DO ALL E SLOW BEAST
local function ExecutarExploitsBeast()
    -- Se nenhum dos dois estiver ligado, mata a execução para economizar desempenho
    if not (RemoveRopeAll_Ativo or SlowBeast_Ativo) then return end

    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer and v:FindFirstChild("TempPlayerStatsModule") then
            local isBeastObj = v.TempPlayerStatsModule:FindFirstChild("IsBeast")
            
            -- Detecta se o jogador atual do loop é a Besta
            if isBeastObj and isBeastObj.Value == true and IsThereChar(v) then
                local char = v.Character
                local hammer = char:FindFirstChild("Hammer")
                local bPowers = char:FindFirstChild("BeastPowers")

                -- LOGICA: Remove Rope (All)
                if RemoveRopeAll_Ativo and hammer and hammer:FindFirstChild("HammerEvent") then
                    -- Envia spam de cliques falsos de martelo, fazendo a besta soltar todo mundo instantaneamente
                    hammer.HammerEvent:FireServer("HammerClick", true)
                end

                -- LOGICA: Slow Down Beast
                if SlowBeast_Ativo and bPowers and bPowers:FindFirstChild("PowersEvent") then
                    -- Spama o evento de pulo/habilidade da besta para bugar a velocidade dela
                    bPowers.PowersEvent:FireServer("Jumped")
                end
            end
        end
    end
end

-- 5. LOOP DE ATUALIZAÇÃO (Coloque no final do seu script junto com os outros)
task.spawn(function()
    while true do
        task.wait(0.1) -- Roda de forma leve e contínua
        pcall(ExecutarExploitsBeast)
    end
end)

-- 1. Criação do botão na WindUI
local Button = Hider:Button({
    Title = "Ver Poder da Besta",
    Desc = "Mostra uma notificação com o poder atual da Beast",
    Locked = false,
    Callback = function()
        -- Procura o objeto que armazena o poder no ReplicatedStorage
        local CurrentPowerObj = game.ReplicatedStorage:FindFirstChild("CurrentPower")
        
        if CurrentPowerObj then
            local poderAtual = CurrentPowerObj.Value
            
            -- Se o valor estiver vazio ou nulo (ex: intervalo de partida)
            if poderAtual == "" or poderAtual == nil then
                poderAtual = "Nenhum (Esperando Partida)"
            end
            
            -- Envia a notificação com o poder encontrado
            WindUI:Notify({
                Title = "Beast Power",
                Content = "O poder atual da Besta é: " .. tostring(poderAtual),
                Duration = 4,
                Icon = "swords", -- Ícone combinando com poder/luta
            })
        else
            -- Caso o jogo mude ou o objeto não seja encontrado
            WindUI:Notify({
                Title = "Erro",
                Content = "Não foi possível detectar o poder da Besta!",
                Duration = 4,
                Icon = "shield-alert",
            })
        end
    end
})

-- ==========================================
-- [ INTERFACE BUTTONS (BEAST) ]
-- ==========================================
local ButtonNoSlow = Beast:Button({
    Title = "No Slow",
    Desc = "Remove a lentidão da Besta ao errar marretadas",
    Locked = false,
    Callback = function()
        local player = game.Players.LocalPlayer
        if player:FindFirstChild("TempPlayerStatsModule") and player.TempPlayerStatsModule:FindFirstChild("IsBeast") and player.TempPlayerStatsModule.IsBeast.Value == true then
            pcall(function()
                if player.Character and player.Character:FindFirstChild("PowersLocalScript") then
                    player.Character.PowersLocalScript:Destroy()
                end
            end)
        end
    end
})

local ButtonEnableCrawl = Beast:Button({
    Title = "Enable Crawl",
    Desc = "Permite que a Besta agache e passe por dutos/buracos",
    Locked = false,
    Callback = function()
        local player = game.Players.LocalPlayer
        if player:FindFirstChild("TempPlayerStatsModule") and player.TempPlayerStatsModule:FindFirstChild("IsBeast") and player.TempPlayerStatsModule.IsBeast.Value == true then
            pcall(function()
                if player.TempPlayerStatsModule:FindFirstChild("DisableCrawl") then
                    player.TempPlayerStatsModule.DisableCrawl.Value = false
                end
            end)
        end
    end
})

local ButtonSilentBeast = Beast:Button({
    Title = "Remove Sound And Glow",
    Desc = "Remove o som da marreta e o brilho das costas (Modo Fantasma)",
    Locked = false,
    Callback = function()
        local player = game.Players.LocalPlayer
        if player:FindFirstChild("TempPlayerStatsModule") and player.TempPlayerStatsModule:FindFirstChild("IsBeast") and player.TempPlayerStatsModule.IsBeast.Value == true then
            local char = player.Character
            if char then
                pcall(function()
                    if char:FindFirstChild("Hammer") and char.Hammer:FindFirstChild("Handle") then
                        for _, v in pairs(char.Hammer.Handle:GetChildren()) do
                            if v:IsA("Sound") then v:Destroy() end
                        end
                    end
                end)
                pcall(function()
                    if char:FindFirstChild("Gemstone") and char.Gemstone:FindFirstChild("Handle") and char.Gemstone.Handle:FindFirstChild("PointLight") then
                        char.Gemstone.Handle.PointLight:Destroy()
                    end
                end)
            end
        end
    end
})

--[=[
    1. CONFIGURAÇÕES E TABELAS
--]=]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local PlrRagTimeBillboards = {}
local ToggleAtivo = false -- Variável que controla se o ESP deve rodar

--[=[
    2. FUNÇÕES AUXILIARES
--]=]
local function IsValidCharacter(plr)
    return plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
end

local function IsPlayerDowned(plr)
    if not IsValidCharacter(plr) or plr == LocalPlayer then return false end
    local stats = plr:FindFirstChild("TempPlayerStatsModule")
    if stats then
        local ragdoll = stats:FindFirstChild("Ragdoll")
        local progress = stats:FindFirstChild("ActionProgress")
        return ragdoll and progress and ragdoll.Value == true
    end
    return false
end

local function LimparTodosBillboards()
    for player, billboard in pairs(PlrRagTimeBillboards) do
        if billboard then billboard:Destroy() end
    end
    table.clear(PlrRagTimeBillboards)
end

--[=[
    3. A SUA ESTRUTURA DE TOGGLE (APENAS ATUALIZA O ESTADO)
--]=]
local Toggle = Beast:Toggle({
    Title = "Show Player Ragdoll Time",
    Desc = "Displays countdown visualizer above downed targets",
    Type = "Toggle",
    Value = false,
    Callback = function(state) 
        ToggleAtivo = state -- Define se está ativo (true) ou desativado (false)
        
        if not state then
            LimparTodosBillboards() -- Se desligou, limpa a tela imediatamente
        end
    end
})

--[=[
    4. FUNÇÃO PRINCIPAL DE ATUALIZAÇÃO
--]=]
function UpdateShowPlrRagTime()
    -- Se o toggle estiver falso, corta a execução aqui e não gasta processamento
    if not ToggleAtivo then return end

    -- Criar os Billboards para quem caiu
    for _, player in pairs(Players:GetPlayers()) do
        if IsPlayerDowned(player) then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            
            if root and not PlrRagTimeBillboards[player] then
                local NewBillboard = Instance.new("BillboardGui")
                NewBillboard.Name = "RagTimeESP"
                NewBillboard.AlwaysOnTop = true
                NewBillboard.ExtentsOffsetWorldSpace = Vector3.new(0, 3, 0)
                NewBillboard.Size = UDim2.new(0, 200, 0, 40)
                
                local NewLabel = Instance.new("TextLabel")
                NewLabel.Name = "TextLabel"
                NewLabel.BackgroundTransparency = 1
                NewLabel.TextStrokeTransparency = 0
                NewLabel.TextColor3 = Color3.fromRGB(255, 65, 65)
                NewLabel.TextScaled = true
                NewLabel.Font = Enum.Font.SourceSansBold
                NewLabel.Size = UDim2.new(1, 0, 1, 0)
                NewLabel.RichText = true
                
                NewLabel.Parent = NewBillboard
                NewBillboard.Parent = root
                PlrRagTimeBillboards[player] = NewBillboard
            end
        end
    end

    -- Atualizar o texto ou remover se o jogador levantou
    for player, billboard in pairs(PlrRagTimeBillboards) do
        if not IsPlayerDowned(player) then
            if billboard then billboard:Destroy() end
            PlrRagTimeBillboards[player] = nil
        else
            local label = billboard:FindFirstChild("TextLabel")
            if label then
                local progressValue = player.TempPlayerStatsModule.ActionProgress.Value
                local percent = math.clamp(math.floor(progressValue * 100), 0, 100)
                label.Text = string.format("<b>%s</b><br/><font color='#FFDF00'>Progresso: %d%%</font>", player.DisplayName or player.Name, percent)
            end
        end
    end
end

--[=[
    5. O SEU LOOP PRINCIPAL (Coloque no final do seu script)
--]=]
task.spawn(function()
    while true do
        task.wait(0.1) -- Roda 10 vezes por segundo de forma leve
        pcall(UpdateShowPlrRagTime)
    end
end)

-- ==========================================
-- [ MISC BUTTONS ]
-- ==========================================
local ButtonFixCamera = Misc:Button({
    Title = "Fix Camera",
    Desc = "Destrava a câmera e foca de volta no seu personagem se travar",
    Locked = false,
    Callback = function()
        local player = game.Players.LocalPlayer
        local char = player.Character
        if char then
            pcall(function()
                local humanoid = char:FindFirstChildWhichIsA("Humanoid")
                if humanoid then workspace.CurrentCamera.CameraSubject = humanoid end
                workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
                player.CameraMinZoomDistance = 0.5
                player.CameraMaxZoomDistance = math.huge
                player.CameraMode = Enum.CameraMode.Classic
                if char:FindFirstChild("Head") then char.Head.Anchored = false end
            end)
        end
    end
})

local ButtonBypass = Misc:Button({
    Title = "Bypass Anticheat",
    Desc = "Modifica a estrutura do personagem. Não use se for a Besta!",
    Locked = false,
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character
        if character then
            pcall(function()
                local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
                local root = character:FindFirstChild("HumanoidRootPart")
                if torso and root then
                    character.Parent = nil
                    root.Parent = nil 
                    task.wait(0.5)
                    local fake = torso:Clone()
                    fake.Parent = character
                    torso.Name = "HumanoidRootPart"
                    torso.Transparency = 1
                    getgenv().Torsoo = torso
                    character.Parent = workspace
                end
            end) -- Corrigido de pcall) para end)
        end
    end
})
