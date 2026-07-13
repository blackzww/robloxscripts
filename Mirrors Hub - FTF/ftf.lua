-- ==========================================
-- [ INTERFACE INITIALIZATION ]
-- ==========================================
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- ==========================================
-- [ THEME CONFIGURATIONS ]
-- ==========================================
WindUI:AddTheme({
    Name = "PurpleDark", -- theme name
    
    
    -- More Soon!
    
    Accent = WindUI:Gradient({                                                      
        ["0"] = { Color = Color3.fromHex("#6d28d9"), Transparency = 0 },            
        ["100"]   = { Color = Color3.fromHex("#1e1033"), Transparency = 0 },      
    }, {                                                                            
        Rotation = 90,                                                               
    }),
    Background = WindUI:Gradient({                                                      
        ["0"] = { Color = Color3.fromHex("#2e1065"), Transparency = 0 },            
        ["100"]   = { Color = Color3.fromHex("#0a0510"), Transparency = 0 },      
    }, {                                                                            
        Rotation = 90,                                                               
    }),
    BackgroundTransparency = 0.35,
    Outline = Color3.fromHex("#6d28d9"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#a78bfa"),
    Button = WindUI:Gradient({                                                      
        ["0"] = { Color = Color3.fromHex("#4c1d95"), Transparency = 0 },            
        ["100"]   = { Color = Color3.fromHex("#150829"), Transparency = 0 },      
    }, {                                                                            
        Rotation = 90,                                                               
    }),
    Icon = Color3.fromHex("#c4b5fd"),
    
    Hover = Color3.fromHex("#c4b5fd"), -- Text
    BackgroundTransparency = 0.35,
    
    WindowBackground = WindUI:Gradient({                                                      
        ["0"] = { Color = Color3.fromHex("#2e1065"), Transparency = 0 },            
        ["100"]   = { Color = Color3.fromHex("#0a0510"), Transparency = 0 },      
    }, {                                                                            
        Rotation = 90,                                                               
    }),
    WindowShadow = Color3.fromHex("000000"),
    
    DialogBackground = WindUI:Gradient({                                                      
        ["0"] = { Color = Color3.fromHex("#1e1033"), Transparency = 0 },            
        ["100"]   = { Color = Color3.fromHex("#050208"), Transparency = 0 },      
    }, {                                                                            
        Rotation = 90,                                                               
    }),
    DialogBackgroundTransparency = 0.05,
    DialogTitle = Color3.fromHex("#FFFFFF"),
    DialogContent = Color3.fromHex("#c4b5fd"),
    DialogIcon = Color3.fromHex("#a78bfa"),
    
    WindowTopbarButtonIcon = Color3.fromHex("c4b5fd"), -- Icon
    WindowTopbarTitle = Color3.fromHex("FFFFFF"), -- Text
    WindowTopbarAuthor = Color3.fromHex("a78bfa"), -- Text
    WindowTopbarIcon = Color3.fromHex("7c3aed"), -- Text
    
    TabBackground = WindUI:Gradient({                                                      
        ["0"] = { Color = Color3.fromHex("#3b1a6e"), Transparency = 0 },            
        ["100"]   = { Color = Color3.fromHex("#150829"), Transparency = 0 },      
    }, {                                                                            
        Rotation = 90,                                                               
    }),
    TabTitle = Color3.fromHex("#FFFFFF"),
    TabIcon = Color3.fromHex("#c4b5fd"),
    
    ElementBackground = WindUI:Gradient({                                                      
        ["0"] = { Color = Color3.fromHex("#3b1a6e"), Transparency = 0 },            
        ["100"]   = { Color = Color3.fromHex("#150829"), Transparency = 0 },      
    }, {                                                                            
        Rotation = 90,                                                               
    }),
    ElementTitle = Color3.fromHex("#FFFFFF"),
    ElementDesc = Color3.fromHex("#a78bfa"),
    ElementIcon = Color3.fromHex("#c4b5fd"),
    
    PopupBackground = WindUI:Gradient({                                                      
        ["0"] = { Color = Color3.fromHex("#1e1033"), Transparency = 0 },            
        ["100"]   = { Color = Color3.fromHex("#050208"), Transparency = 0 },      
    }, {                                                                            
        Rotation = 90,                                                               
    }),
    PopupBackgroundTransparency = 0.05,
    PopupTitle = Color3.fromHex("#FFFFFF"),
    PopupContent = Color3.fromHex("#c4b5fd"),
    PopupIcon = Color3.fromHex("#a78bfa"),
    
    Toggle = Color3.fromHex("#52525b"), -- fundo cinza
    ToggleBar = Color3.fromHex("#FFFFFF"), -- alavanca branca
        
    Checkbox = Color3.fromHex("#4c1d95"),
    CheckboxIcon = Color3.fromHex("#a78bfa"),
    
    Slider = Color3.fromHex("#4c1d95"),
    SliderThumb = Color3.fromHex("#a78bfa"),
    
})

pcall(function()
    local HttpService = game:GetService("HttpService")
    local Players = game:GetService("Players")

    local player = Players.LocalPlayer

    local executor = "Unknown"
    pcall(function()
        if identifyexecutor then
            executor = identifyexecutor()
        end
    end)

    request({
        Url = "https://mirrorskey-system.vercel.app/api/send-stats",
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = HttpService:JSONEncode({
            hub = "flee the facility",
            player = player.Name,
            userId = player.UserId,
            executor = executor,
            placeId = game.PlaceId,
            jobId = game.JobId,
            version = "FTF Beta 1.0"
        })
    })
end)

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

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local noclipConnection = nil

local Toggle = Misc:Toggle({
    Title = "Noclip",
    Desc = "Permite atravessar paredes e blocos do mapa",
    Type = "Toggle",
    Value = false, -- Valor inicial desligado
    Callback = function(state) 
        if state then
            -- Se o Toggle for ativado, liga o Noclip
            noclipConnection = RunService.Stepped:Connect(function()
                if LocalPlayer.Character then
                    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide == true then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            -- Se o Toggle for desativado, desliga o Noclip
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
        end
    end
})

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local jumpConnection = nil

local Toggle = Misc:Toggle({
    Title = "Infinite Jump",
    Desc = "Permite pular infinitamente no ar",
    Type = "Toggle",
    Value = false,
    Callback = function(state) 
        if state then
            -- Ativa a conexão que detecta o pulo
            jumpConnection = UserInputService.JumpRequest:Connect(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                    -- Altera o estado do humanoide para pulo, permitindo pular no ar
                    LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        else
            -- Desativa o pulo infinito quando desliga o toggle
            if jumpConnection then
                jumpConnection:Disconnect()
                jumpConnection = nil
            end
        end
    end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local speaker = Players.LocalPlayer
local nowe = false
local tpwalking = false
local speeds = 1 -- Velocidade padrão (pode ser controlada por outros botões do seu menu)

-- Função para alterar o comportamento de estados do Humanoid
local function setHumanoidStates(state)
    local character = speaker.Character
    local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
    
    if humanoid then
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, state)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, state)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, state)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, state)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, state)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, state)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, state)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, state)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, state)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, state)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, state)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, state)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, state)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, state)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, state)
    end
end

-- Estrutura do Toggle adaptada ao seu Menu
local Toggle = Misc:Toggle({
    Title = "Toggle Fly",
    Desc = "Voa usando o analógico do Mobile e WASD do PC",
    Type = "Toggle",
    Value = false,
    Callback = function(state) 
        nowe = state
        
        local chr = speaker.Character
        local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
        
        if not nowe then
            -- DESATIVAR VÔO
            tpwalking = false
            setHumanoidStates(true)
            
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
            end
            
            if chr and chr:FindFirstChild("Animate") then
                chr.Animate.Disabled = false
            end
            
            -- Reajusta a velocidade das animações ao normal
            if hum then
                local animator = hum:FindFirstChildOfClass("Animator") or hum
                for _, track in next, animator:GetPlayingAnimationTracks() do
                    track:AdjustSpeed(1)
                end
            end
        else
            -- ATIVAR VÔO
            tpwalking = true
            
            -- Cria a quantidade de loops baseado na velocidade 'speeds' (Lógica idêntica ao seu script)
            for i = 1, speeds do
                task.spawn(function() 
                    local hb = RunService.Heartbeat
                    while tpwalking and hb:Wait() and speaker.Character and speaker.Character:FindFirstChildWhichIsA("Humanoid") do
                        local currentChr = speaker.Character
                        local currentHum = currentChr:FindFirstChildWhichIsA("Humanoid")
                        
                        if currentHum and currentHum.MoveDirection.Magnitude > 0 then
                            currentChr:TranslateBy(currentHum.MoveDirection)
                        end
                    end 
                end)
            end
            
            -- Congela animações nativas para não ficar travando o boneco
            if chr and chr:FindFirstChild("Animate") then
                chr.Animate.Disabled = true
            end
            
            if hum then
                local animator = hum:FindFirstChildOfClass("Animator") or hum
                for _, track in next, animator:GetPlayingAnimationTracks() do
                    track:AdjustSpeed(0)
                end
                
                setHumanoidStates(false)
                hum:ChangeState(Enum.HumanoidStateType.Swimming) -- Aplica o estado de natação infinita no ar
            end
        end
    end
})

-- Reseta os estados se o personagem morrer
speaker.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    tpwalking = false
    nowe = false
end)


--[[
	Robox 2 — Fly Controller
	
	Controle:
	- Ative ou desative pelo Toggle.
	- Use W/A/S/D ou o joystick para se movimentar.
	- Olhe para cima e avance para subir.
	- Olhe para baixo e avance para descer.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- Configuração

local FLY_SPEED = 55

-- Controlador de voo

local FlyController = {
	Enabled = false,
	BodyVelocity = nil,
	BodyGyro = nil,
	RenderConnection = nil,
	DeathConnection = nil,
	CharacterConnection = nil,
}

function FlyController:GetCharacterParts()
	local character = player.Character

	if not character then
		return nil, nil
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local rootPart = character:FindFirstChild("HumanoidRootPart")

	return humanoid, rootPart
end

function FlyController:DestroyMovers()
	if self.BodyVelocity then
		self.BodyVelocity:Destroy()
		self.BodyVelocity = nil
	end

	if self.BodyGyro then
		self.BodyGyro:Destroy()
		self.BodyGyro = nil
	end
end

function FlyController:DisconnectConnections()
	if self.RenderConnection then
		self.RenderConnection:Disconnect()
		self.RenderConnection = nil
	end

	if self.DeathConnection then
		self.DeathConnection:Disconnect()
		self.DeathConnection = nil
	end
end

function FlyController:Stop()
	self.Enabled = false

	self:DisconnectConnections()
	self:DestroyMovers()

	local humanoid = self:GetCharacterParts()

	if humanoid then
		humanoid.PlatformStand = false
		humanoid.AutoRotate = true
		humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
	end
end

function FlyController:Update()
	if not self.Enabled then
		return
	end

	local humanoid, rootPart = self:GetCharacterParts()
	local camera = workspace.CurrentCamera

	if not humanoid
		or not rootPart
		or not camera
		or not self.BodyVelocity
		or not self.BodyGyro then
		self:Stop()
		return
	end

	if humanoid.Health <= 0 then
		self:Stop()
		return
	end

	local moveDirection = humanoid.MoveDirection
	local cameraLook = camera.CFrame.LookVector
	local cameraRight = camera.CFrame.RightVector

	-- Direções horizontais relativas à câmera.

	local flatLook = Vector3.new(
		cameraLook.X,
		0,
		cameraLook.Z
	)

	local flatRight = Vector3.new(
		cameraRight.X,
		0,
		cameraRight.Z
	)

	-- Usa a orientação do personagem como fallback quando
	-- a câmera estiver totalmente apontada para cima ou para baixo.

	if flatLook.Magnitude <= 0.01 then
		local rootLook = rootPart.CFrame.LookVector

		flatLook = Vector3.new(
			rootLook.X,
			0,
			rootLook.Z
		)
	end

	if flatRight.Magnitude <= 0.01 then
		local rootRight = rootPart.CFrame.RightVector

		flatRight = Vector3.new(
			rootRight.X,
			0,
			rootRight.Z
		)
	end

	if flatLook.Magnitude > 0.01 then
		flatLook = flatLook.Unit
	end

	if flatRight.Magnitude > 0.01 then
		flatRight = flatRight.Unit
	end

	if moveDirection.Magnitude > 0.01 then
		-- Converte MoveDirection em movimento relativo à câmera.

		local forwardAmount = moveDirection:Dot(flatLook)
		local rightAmount = moveDirection:Dot(flatRight)

		-- O movimento frontal acompanha a inclinação da câmera.
		-- O movimento lateral permanece nivelado.

		local flyDirection =
			(cameraLook * forwardAmount)
			+ (flatRight * rightAmount)

		if flyDirection.Magnitude > 0.01 then
			self.BodyVelocity.Velocity =
				flyDirection.Unit * FLY_SPEED
		else
			self.BodyVelocity.Velocity = Vector3.zero
		end
	else
		self.BodyVelocity.Velocity = Vector3.zero
	end

	-- Orienta o personagem na direção da câmera.

	self.BodyGyro.CFrame = CFrame.lookAt(
		rootPart.Position,
		rootPart.Position + cameraLook,
		camera.CFrame.UpVector
	)
end

function FlyController:Start()
	if self.Enabled then
		return true
	end

	local humanoid, rootPart = self:GetCharacterParts()

	if not humanoid
		or not rootPart
		or humanoid.Health <= 0 then
		return false
	end

	self:DisconnectConnections()
	self:DestroyMovers()

	self.Enabled = true

	humanoid.PlatformStand = true
	humanoid.AutoRotate = false

	self.BodyVelocity = Instance.new("BodyVelocity")
	self.BodyVelocity.Name = "Robox2FlyVelocity"
	self.BodyVelocity.MaxForce = Vector3.new(
		math.huge,
		math.huge,
		math.huge
	)
	self.BodyVelocity.P = 25000
	self.BodyVelocity.Velocity = Vector3.zero
	self.BodyVelocity.Parent = rootPart

	self.BodyGyro = Instance.new("BodyGyro")
	self.BodyGyro.Name = "Robox2FlyGyro"
	self.BodyGyro.MaxTorque = Vector3.new(
		math.huge,
		math.huge,
		math.huge
	)
	self.BodyGyro.P = 25000
	self.BodyGyro.D = 500
	self.BodyGyro.CFrame = rootPart.CFrame
	self.BodyGyro.Parent = rootPart

	self.DeathConnection = humanoid.Died:Connect(function()
		self:Stop()
	end)

	self.RenderConnection = RunService.RenderStepped:Connect(function()
		self:Update()
	end)

	return true
end

function FlyController:SetEnabled(state)
	if state then
		return self:Start()
	end

	self:Stop()
	return true
end

-- Desliga e limpa o voo quando o personagem renascer.

FlyController.CharacterConnection = player.CharacterAdded:Connect(function()
	FlyController:Stop()
end)

-- Integração com a biblioteca de GUI.
-- "Tab" deve ter sido criado anteriormente pelo seu sistema de interface.

local FlyToggle = Misc:Toggle({
	Title = "Toggle Fly",
	Desc = "Voe seguindo a direção da câmera",
	Type = "Toggle",
	Value = false,

	Callback = function(state)
		local started = FlyController:SetEnabled(state)

		if state and not started then
			warn("Não foi possível ativar o Fly: personagem indisponível.")
			
			-- Se a biblioteca tiver um método para atualizar o Toggle
			-- sem disparar o Callback, ele pode ser usado aqui.
			--
			-- Exemplo:
			-- FlyToggle:SetValue(false)
		end
	end,
})


--[[
	Robox 2 — Hitbox Expander oficial

	Características:
	- Não modifica partes do personagem.
	- Não modifica o collider principal.
	- Não interfere na movimentação ou na física.
	- Usa GetPartBoundsInBox para detectar objetos próximos.
	- Exibe uma área visual não colisível sob o personagem.
	- O Toggle ativa/desativa o sistema.
	- O Slider controla o alcance.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- Configurações

local DEFAULT_RANGE = 70
local DETECTION_HEIGHT = 12
local DETECTION_INTERVAL = 0.1

local VISUALIZER_NAME = "Robox2DetectionArea"

-- Controlador da área de detecção

local HitboxController = {
	Enabled = false,
	Range = DEFAULT_RANGE,

	Visualizer = nil,
	UpdateConnection = nil,
	CharacterConnection = nil,

	ElapsedTime = 0,
	DetectedParts = {},
	DetectedModels = {},
}

-- Evento disparado sempre que uma detecção é realizada.
-- Outros sistemas podem conectar-se a esse evento.

HitboxController.Detected = Instance.new("BindableEvent")

-- Retorna o personagem e sua parte principal.

function HitboxController:GetCharacterParts()
	local character = player.Character

	if not character then
		return nil, nil, nil
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local rootPart = character:FindFirstChild("HumanoidRootPart")

	return character, humanoid, rootPart
end

-- Calcula a posição dos pés do personagem.

function HitboxController:GetFeetPosition()
	local character, humanoid, rootPart = self:GetCharacterParts()

	if not character or not humanoid or not rootPart then
		return nil
	end

	local verticalOffset =
		(rootPart.Size.Y * 0.5)
		+ humanoid.HipHeight

	return rootPart.Position - Vector3.new(0, verticalOffset, 0)
end

-- Cria o bloco que representa visualmente o alcance.

function HitboxController:CreateVisualizer()
	self:DestroyVisualizer()

	local character = player.Character

	if not character then
		return
	end

	local visualizer = Instance.new("Part")
	visualizer.Name = VISUALIZER_NAME

	-- O indicador não participa da física ou das consultas.

	visualizer.Anchored = true
	visualizer.CanCollide = false
	visualizer.CanTouch = false
	visualizer.CanQuery = false
	visualizer.CastShadow = false

	visualizer.Massless = true
	visualizer.Locked = true

	-- Aparência.

	visualizer.Material = Enum.Material.Neon
	visualizer.Color = Color3.fromRGB(34, 197, 94)
	visualizer.Transparency = 0.7

	-- É um bloco fino posicionado sob o personagem.

	visualizer.Size = Vector3.new(
		self.Range,
		0.15,
		self.Range
	)

	visualizer.Parent = workspace

	self.Visualizer = visualizer
	self:UpdateVisualizer()
end

-- Remove apenas o indicador visual.

function HitboxController:DestroyVisualizer()
	if self.Visualizer then
		self.Visualizer:Destroy()
		self.Visualizer = nil
	end
end

-- Atualiza o tamanho e a posição do indicador.

function HitboxController:UpdateVisualizer()
	if not self.Visualizer then
		return
	end

	local feetPosition = self:GetFeetPosition()

	if not feetPosition then
		return
	end

	self.Visualizer.Size = Vector3.new(
		self.Range,
		0.15,
		self.Range
	)

	self.Visualizer.CFrame = CFrame.new(
		feetPosition - Vector3.new(0, 0.1, 0)
	)
end

-- Cria os parâmetros usados pela consulta espacial.

function HitboxController:CreateOverlapParams()
	local character = player.Character
	local exclusions = {}

	if character then
		table.insert(exclusions, character)
	end

	if self.Visualizer then
		table.insert(exclusions, self.Visualizer)
	end

	local overlapParams = OverlapParams.new()
	overlapParams.FilterType = Enum.RaycastFilterType.Exclude
	overlapParams.FilterDescendantsInstances = exclusions

	-- Zero significa que não há limite de resultados.

	overlapParams.MaxParts = 0
	overlapParams.RespectCanCollide = false

	return overlapParams
end

-- Retorna o centro da área tridimensional de detecção.

function HitboxController:GetDetectionCFrame()
	local character, humanoid, rootPart = self:GetCharacterParts()

	if not character or not humanoid or not rootPart then
		return nil
	end

	-- A caixa fica centralizada verticalmente no personagem.
	-- Sua rotação permanece fixa para evitar movimentos visuais estranhos.

	return CFrame.new(rootPart.Position)
end

-- Executa uma consulta de objetos dentro da área.

function HitboxController:Scan()
	if not self.Enabled then
		return {}, {}
	end

	local character, humanoid, rootPart = self:GetCharacterParts()

	if not character
		or not humanoid
		or not rootPart
		or humanoid.Health <= 0 then
		return {}, {}
	end

	local detectionCFrame = self:GetDetectionCFrame()

	if not detectionCFrame then
		return {}, {}
	end

	local detectionSize = Vector3.new(
		self.Range,
		DETECTION_HEIGHT,
		self.Range
	)

	local overlapParams = self:CreateOverlapParams()

	local parts = workspace:GetPartBoundsInBox(
		detectionCFrame,
		detectionSize,
		overlapParams
	)

	-- Organiza os resultados sem repetir modelos.

	local detectedModels = {}
	local modelLookup = {}

	for _, part in ipairs(parts) do
		local model = part:FindFirstAncestorOfClass("Model")

		if model
			and model ~= character
			and not modelLookup[model] then
			modelLookup[model] = true
			table.insert(detectedModels, model)
		end
	end

	self.DetectedParts = parts
	self.DetectedModels = detectedModels

	-- Dispara o resultado para os sistemas interessados.

	self.Detected:Fire(parts, detectedModels)

	return parts, detectedModels
end

-- Loop de atualização.

function HitboxController:Update(deltaTime)
	if not self.Enabled then
		return
	end

	self:UpdateVisualizer()

	self.ElapsedTime += deltaTime

	if self.ElapsedTime < DETECTION_INTERVAL then
		return
	end

	self.ElapsedTime = 0
	self:Scan()
end

-- Ativa o sistema.

function HitboxController:Start()
	if self.Enabled then
		return true
	end

	local character, humanoid, rootPart = self:GetCharacterParts()

	if not character
		or not humanoid
		or not rootPart
		or humanoid.Health <= 0 then
		return false
	end

	self.Enabled = true
	self.ElapsedTime = DETECTION_INTERVAL

	self:CreateVisualizer()

	if not self.UpdateConnection then
		self.UpdateConnection = RunService.Heartbeat:Connect(
			function(deltaTime)
				self:Update(deltaTime)
			end
		)
	end

	return true
end

-- Desativa o sistema e remove todos os resultados temporários.

function HitboxController:Stop()
	self.Enabled = false
	self.ElapsedTime = 0

	if self.UpdateConnection then
		self.UpdateConnection:Disconnect()
		self.UpdateConnection = nil
	end

	self:DestroyVisualizer()

	table.clear(self.DetectedParts)
	table.clear(self.DetectedModels)
end

-- Função usada pelo Toggle.

function HitboxController:SetEnabled(state)
	if state then
		return self:Start()
	end

	self:Stop()
	return true
end

-- Função usada pelo Slider.

function HitboxController:SetRange(value)
	if typeof(value) ~= "number" then
		return
	end

	self.Range = math.clamp(value, 20, 120)

	if self.Visualizer then
		self:UpdateVisualizer()
	end

	-- Atualiza imediatamente os objetos detectados.

	if self.Enabled then
		self.ElapsedTime = DETECTION_INTERVAL
	end
end

-- Retorna uma cópia das partes detectadas atualmente.

function HitboxController:GetDetectedParts()
	return table.clone(self.DetectedParts)
end

-- Retorna uma cópia dos modelos detectados atualmente.

function HitboxController:GetDetectedModels()
	return table.clone(self.DetectedModels)
end

-- Ao renascer, recria a área caso ela estivesse ativada.

HitboxController.CharacterConnection =
	player.CharacterAdded:Connect(function(character)
		if not HitboxController.Enabled then
			return
		end

		HitboxController:DestroyVisualizer()

		character:WaitForChild("Humanoid")
		character:WaitForChild("HumanoidRootPart")

		HitboxController:CreateVisualizer()
		HitboxController.ElapsedTime = DETECTION_INTERVAL
	end)

-- Toggle de ativação

local HitboxToggle = Tab:Toggle({
	Title = "Área de detecção",
	Desc = "Ativa a área adicional de interação",
	Type = "Toggle",
	Value = false,

	Callback = function(state)
		local success = HitboxController:SetEnabled(state)

		if state and not success then
			warn(
				"Não foi possível ativar a área: "
				.. "personagem indisponível."
			)

			-- Caso sua biblioteca permita atualizar o estado:
			-- HitboxToggle:SetValue(false)
		end
	end,
})

-- Slider de alcance

local RangeSlider = Tab:Slider({
	Title = "Tamanho do alcance",
	Desc = "Define a largura da área de detecção",

	Step = 1,

	Value = {
		Min = 20,
		Max = 120,
		Default = DEFAULT_RANGE,
	},

	Callback = function(value)
		HitboxController:SetRange(value)
	end,
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
