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

local ToggleCrawlMobile = Misc:Toggle({
    Title = "Botão de Agachar Flutuante",
    Desc = "Cria um botão arrastável na tela para não ficar em cima do Q",
    Value = false,
    Callback = function(state)
        local VirtualInputManager = game:GetService("VirtualInputManager")
        local player = game.Players.LocalPlayer
        
        -- Se ligar o Toggle, cria o botão na tela do celular
        if state then
            -- Se o botão já existir, não cria outro
            if player.PlayerGui:FindFirstChild("MobileCrouchBtn") then return end
            
            local sg = Instance.new("ScreenGui")
            sg.Name = "MobileCrouchBtn"
            sg.ResetOnSpawn = false
            sg.Parent = player.PlayerGui
            
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 65, 0, 65)
            btn.Position = UDim2.new(0.7, 0, 0.5, 0) -- Posição inicial na tela
            btn.BackgroundColor3 = Color3.fromHex("8b5cf6") -- Roxo do seu tema
            btn.Text = "C"
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.TextSize = 24
            btn.Font = Enum.Font.SourceSansBold
            btn.Parent = sg
            
            -- Deixa o botão redondo e bonito
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 50)
            corner.Parent = btn
            
            -- Faz o botão ser arrastável no Mobile para você colocar onde quiser
            btn.Active = true
            btn.Draggable = true
            
            -- Função de clique (Simula a tecla C do teclado)
            btn.MouseButton1Click:Connect(function()
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.C, false, game)
                task.wait(0.05)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.C, false, game)
            end)
        else
            -- Se desligar o Toggle, deleta o botão da tela
            local existingBtn = player.PlayerGui:FindFirstChild("MobileCrouchBtn")
            if existingBtn then
                existingBtn:Destroy()
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
