-- Proteção contra execução dupla
if game.CoreGui:FindFirstChild("MirrorsHubFloat") then
    game.CoreGui:FindFirstChild("MirrorsHubFloat"):Destroy()
end

-- Serviços
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer


-- Carregando Fluent (mantido para aparência)
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- Criando janela
local Window = Fluent:CreateWindow({
    Title = "Mirrors Hub - BF Sea 1",
    SubTitle = "by blackzw",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

-- Criar tabs completas de Blox Fruits
local Tabs = {
    Info = Window:AddTab({ Title = "Info", Icon = "info" }),
    MainFarm = Window:AddTab({ Title = "Main Farm", Icon = "leaf" }),
    ConfigFarm = Window:AddTab({ Title = "Config Farm", Icon = "cog" }),
    Fruit = Window:AddTab({ Title = "Fruit/Esp", Icon = "apple" }),
    Raid = Window:AddTab({ Title = "Raid/Dungeon", Icon = "skull" }),
    Teleports = Window:AddTab({ Title = "Teleports", Icon = "map-pin" }),
    Shop = Window:AddTab({ Title = "Buy/Shop", Icon = "shopping-cart" }),
    Settings = Window:AddTab({ Title = "Config", Icon = "settings" })
}

local Options = Fluent.Options

Fluent:Notify({
    Title = "Mirrors Hub",
    Content = " Script loading succesfully!",
    Duration = 5
})

-- ================= INFO TAB =================
Tabs.Info:AddParagraph({
    Title = "Information",
    Content = "Welcome to Mirrors Hub\nVersion: 1.0\nBlox Fruits - Sea 1\n\n⚠️ Some features can be in beta! ⚠️"
})

Tabs.Info:AddButton({
    Title = "Copy Discord",
    Description = "Click to copy the discord link.",
    Callback = function()
        setclipboard("https://discord.gg/YZEg6FyRSF")
        Fluent:Notify({
            Title = "Discord",
            Content = "Link copied succesfully!",
            Duration = 3
        })
    end
})

-- ================= MAIN FARM TAB =================
Tabs.MainFarm:AddToggle("AutoFarm", {
    Title = "Auto Farm Level",
    Description = "Enable the auto farm level",
    Default = false
})

Tabs.MainFarm:AddToggle("AutoFarmNeae", {
    Title = "Auto Farm Near",
    Description = "Enable auto farm nearest mob/boss.",
    Default = false
})

Tabs.MainFarm:AddToggle("AutoFarmBoss", {
    Title = "Auto Farm Boss (BETA)",
    Description = "🔒 Sorry, this feature is in beta\nuse auto farm near.",
    Default = false
})

-- ================= ConfigFarm TAB =================
local BringMobsToggle = Tabs.ConfigFarm:AddToggle("BringMobs", {
    Title = "Bring Mobs BETA",
    Description = "You can use this, but this is in beta!",
    Default = false
})

task.spawn(function()
    while task.wait() do
        if BringMobsToggle.Value then
            pcall(function()
                local character = game.Players.LocalPlayer.Character
                local myRoot = character and character:FindFirstChild("HumanoidRootPart")

                if myRoot then
                    for _, obj in pairs(workspace.Enemies:GetDescendants()) do
                        if obj.Name == "HumanoidRootPart" and obj.Parent:IsA("Model") then
                            local hum = obj.Parent:FindFirstChildOfClass("Humanoid")
                            if hum and hum.Health > 0 then
                                local distance = (obj.Position - myRoot.Position).Magnitude

                                if distance <= 50 then
                                    -- Em vez de CFrame, usamos Velocity e Position
                                    -- Isso tenta "arrastar" o mob para sua frente
                                    obj.CFrame = myRoot.CFrame * CFrame.new(0, 0, -3)
                                    obj.Velocity = Vector3.new(0, 0, 0) -- Para ele não sair voando
                                    
                                    -- Tenta resetar a rede de posse do objeto (Network Owner)
                                    -- Nota: Nem sempre funciona em todos os exploits
                                    if obj.CanCollide then obj.CanCollide = false end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- 1. Variável global para controle
_G.AutoClick = false

-- 2. Criar o Toggle (O primeiro argumento "AutoClickToggle" é o ID que o Fluent usa)
local MyAutoClickToggle = Tabs.ConfigFarm:AddToggle("AutoClickToggle", {
    Title = "Auto M1 Fruit",
    Description = "Ativa o clique automático (executa remote)",
    Default = false
})

-- 3. Callback do toggle (Usando o ID que definimos acima)
MyAutoClickToggle:OnChanged(function()
    _G.AutoClick = MyAutoClickToggle.Value
    
    if MyAutoClickToggle.Value then
        Fluent:Notify({
            Title = "Auto M1 Fruit",
            Content = "Auto Click ativado!",
            Duration = 2
        })
    else
        print("Auto Click desativado")
    end
end)

-- 4. Loop do Auto Click (Com os fechamentos corretos)
spawn(function()
    game:GetService("RunService").RenderStepped:Connect(function()
        if _G.AutoClick then
            pcall(function()
                -- Simula o clique do mouse
                game:GetService('VirtualUser'):CaptureController()
                game:GetService('VirtualUser'):Button1Down(Vector2.new(1280, 672, 0, 0))
            end)
        end
    end)
end) -- FECHAMENTO DO SPAWN (O que estava faltando antes)

-- 1. Variável global para controle
_G.AutoClick = false
local VIM = game:GetService("VirtualInputManager")

-- 2. Criar o Toggle na aba ConfigFarm
local MyAutoClickToggle = Tabs.ConfigFarm:AddToggle("AutoClickM1", {
    Title = "Auto Clixl",
    Description = "Clique de Hardware Ultra Rápido",
    Default = false
})

-- 3. Callback do toggle
MyAutoClickToggle:OnChanged(function()
    _G.AutoClick = MyAutoClickToggle.Value
    
    Fluent:Notify({
        Title = "Auto Click",
        Content = _G.AutoClick and "Ativado com Sucesso!" or "Desativado!",
        Duration = 2
    })
end)

-- 4. Loop de Alta Velocidade usando VIM
spawn(function()
    while true do
        if _G.AutoClick then
            -- Simula o pressionar do botão esquerdo (0) na posição 0,0 do jogo
            VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            task.wait() -- Menor intervalo possível do Roblox
            VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end
        task.wait() -- Evita que o script trave o seu Studio/Roblox
    end
end)

Tabs.ConfigFarm:AddToggle("AutoHaki", {
    Title = "Auto Haki",
    Description = "🔒 FUNÇÃO DESATIVADA - Apenas visual",
    Default = true
})

Tabs.ConfigFarm:AddToggle("AutoKen", {
    Title = "Auto Ken",
    Description = "🔒 FUNÇÃO DESATIVADA - Apenas visual",
    Default = false
})
-- ================= FRUIT TAB =================
Tabs.Fruit:AddToggle("AutoFruit", {
    Title = "Auto Farm Fruit",
    Description = "🔒 FUNÇÃO DESATIVADA - Apenas visual",
    Default = false
})

Tabs.Fruit:AddToggle("AutoStoreFruit", {
    Title = "Auto Store Fruit",
    Description = "🔒 FUNÇÃO DESATIVADA - Apenas visual",
    Default = false
})

-- ================= RAID/BOSS TAB =================
Tabs.Raid:AddToggle("AutoRaid", {
    Title = "Auto Raid",
    Description = "🔒 FUNÇÃO DESATIVADA - Apenas visual",
    Default = false
})

Tabs.Raid:AddToggle("KillAura", {
    Title = "Kill Aura",
    Description = "🔒 FUNÇÃO DESATIVADA - Apenas visual",
    Default = false
})

Tabs.Raid:AddButton({
    Title = "Auto Convert Fruit To Raid.",
    Description = "🔒 FUNÇÃO DESATIVADA",
    Callback = function()
        Fluent:Notify({
            Title = "Modo Falso",
            Content = "Teleport para boss está desativado",
            Duration = 2
        })
    end
})

-- ================= SHOP/ITENS TAB =================
Tabs.Shop:AddToggle("AutoBuyItem", {
    Title = "Auto Buy All Swords",
    Description = "🔒 FUNÇÃO DESATIVADA - Apenas visual",
    Default = false
})

Tabs.Shop:AddToggle("AutoBuyFruit", {
    Title = "Auto Buy Fruit",
    Description = "🔒 FUNÇÃO DESATIVADA - Apenas visual",
    Default = false
})

Tabs.Shop:AddDropdown("BuyFruits", {
    Title = "Select Fruit to Buy",
    Description = "🔒 Apenas visual - não funciona",
    Values = {"as", "frutas", "Sword", "Gun", "Fruit", "Equilibrado"},
    Multi = false,
    Default = 6
})

-- ================= CONFIG FARM TAB (CORRIGIDO) =================

-- Variáveis globais
_G.AutoClick = false
local BringRange = 50

-- 1. Toggle Bring Mobs (APENAS UM)
local BringMobsToggle = Tabs.ConfigFarm:AddToggle("BringMobs", {
    Title = "Bring Mobs BETA",
    Description = "You can use this, but this is in beta!",
    Default = false
})

-- 2. Dropdown para Range (APENAS UM)
Tabs.ConfigFarm:AddDropdown("BringRangeSelect", {
    Title = "Bring Mobs Range",
    Description = "Selecione a distância máxima para puxar",
    Values = {"50", "100", "150", "200", "300", "400"},
    Multi = false,
    Default = "50"
}):OnChanged(function(Value)
    BringRange = tonumber(Value)
end)

-- 3. Toggle Auto Click M1 (APENAS UM - corrigido)
local AutoClickToggle = Tabs.ConfigFarm:AddToggle("AutoClickM1", {
    Title = "Auto Click M1",
    Description = "Clique automático para frutas",
    Default = false
})

AutoClickToggle:OnChanged(function()
    _G.AutoClick = AutoClickToggle.Value
    Fluent:Notify({
        Title = "Auto Click",
        Content = _G.AutoClick and "Ativado!" or "Desativado!",
        Duration = 2
    })
end)

-- 4. Loop do Auto Click (corrigido)
spawn(function()
    while true do
        if _G.AutoClick then
            pcall(function()
                game:GetService("VirtualUser"):CaptureController()
                game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0,0,0))
            end)
        end
        task.wait(0.1) -- Delay para não travar
    end
end)

-- 5. Loop do Bring Mobs (corrigido)
task.spawn(function()
    while task.wait(0.1) do
        if BringMobsToggle.Value then
            pcall(function()
                local character = game.Players.LocalPlayer.Character
                local myRoot = character and character:FindFirstChild("HumanoidRootPart")
                
                if myRoot then
                    for _, obj in pairs(workspace:FindFirstChild("Enemies") or {}) do
                        if obj:IsA("Model") then
                            local hum = obj:FindFirstChildOfClass("Humanoid")
                            local root = obj:FindFirstChild("HumanoidRootPart")
                            
                            if hum and hum.Health > 0 and root then
                                local distance = (root.Position - myRoot.Position).Magnitude
                                
                                if distance <= BringRange then
                                    root.CFrame = myRoot.CFrame * CFrame.new(0, 0, -5)
                                    root.Velocity = Vector3.new(0, 0, 0)
                                    root.CanCollide = false
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ================= TELEPORTS TAB (CORRIGIDO) =================

-- Variáveis para teleporte
local SelectedIsland = "Starter Island"
local TeleportEnabled = false
local CurrentTween = nil
local noclipConnection

-- Dados das ilhas
local IslandData = {
    ["Starter Island"]   = {coords = Vector3.new(1120, 16, 1437),    method = "tp"},
    ["Marine Starter"]   = {coords = Vector3.new(-2520, 6, 2041),    method = "tp"},
    ["Middle Town"]      = {coords = Vector3.new(-688, 16, 1583),    method = "tween"},
    ["Jungle"]           = {coords = Vector3.new(-1614, 36, 147),    method = "tween"},
    ["Pirate Village"]   = {coords = Vector3.new(-1160, 4, 3821),    method = "tween"},
    ["Desert"]           = {coords = Vector3.new(910, 3, 4100),      method = "tween"},
    ["Frozen Village"]   = {coords = Vector3.new(1300, 90, -1300),   method = "tween"},
    ["Marine Fortress"]  = {coords = Vector3.new(-5000, 23, 4320),   method = "tween"},
    ["Sky 1"]            = {coords = Vector3.new(-5000, 720, -2611), method = "tween"},
    ["Sky 2"]            = {coords = Vector3.new(-7885, 5543, -406), method = "tp"},
    ["Sky 3"]            = {coords = Vector3.new(-7790, 5637, -1534),method = "tween"},
    ["Mafia Island"]     = {coords = Vector3.new(-2878, 6, 5400),    method = "tween"},
    ["Colosseum"]        = {coords = Vector3.new(-1500, 10, -3000),  method = "tween"},
    ["Underwater City"]  = {coords = Vector3.new(61163, 10, 1809),   method = "tp"},
    ["Prison"]           = {coords = Vector3.new(4851, 9, 34),       method = "tween"},
    ["Fountain City"]    = {coords = Vector3.new(5100, 9, 4100),     method = "tween"},
    ["Magma Village"]    = {coords = Vector3.new(-5200, 9, 8437),    method = "tween"}
}

-- Funções de suporte
local function setNoclip(state)
    if state then
        noclipConnection = game:GetService("RunService").Stepped:Connect(function()
            local character = game.Players.LocalPlayer.Character
            if character then
                for _, v in pairs(character:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
    end
end

local function startTravel(islandName)
    if not TeleportEnabled then return end
    
    local data = IslandData[islandName]
    local character = game.Players.LocalPlayer.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    
    if not data or not root then return end
    
    -- Cancela tween anterior
    if CurrentTween then
        CurrentTween:Cancel()
        CurrentTween = nil
    end
    
    -- Ativa noclip
    setNoclip(true)
    
    -- Teleport direto ou tween
    if data.method == "tp" then
        root.CFrame = CFrame.new(data.coords)
        task.wait(0.5)
        setNoclip(false)
    else
        -- Voo com tween
        local targetPos = data.coords + Vector3.new(0, 100, 0) -- Voa a 100 studs de altura
        local distance = (root.Position - targetPos).Magnitude
        local duration = distance / 350 -- Velocidade 350
        
        CurrentTween = game:GetService("TweenService"):Create(
            root,
            TweenInfo.new(duration, Enum.EasingStyle.Linear),
            {CFrame = CFrame.new(targetPos)}
        )
        
        CurrentTween:Play()
        
        CurrentTween.Completed:Connect(function()
            if TeleportEnabled and root then
                root.CFrame = CFrame.new(data.coords)
            end
            setNoclip(false)
            CurrentTween = nil
        end)
    end
end

-- Elementos UI da aba Teleports
Tabs.Teleports:AddToggle("TPToggle", {
    Title = "Habilitar Teleporte",
    Description = "Ative para usar o sistema de viagem",
    Default = false
}):OnChanged(function(Value)
    TeleportEnabled = Value
    if not Value and CurrentTween then
        CurrentTween:Cancel()
        CurrentTween = nil
        setNoclip(false)
    end
end)

-- Criar lista de ilhas para o dropdown
local islandList = {}
for name, _ in pairs(IslandData) do
    table.insert(islandList, name)
end
table.sort(islandList)

-- Dropdown de seleção de ilha
Tabs.Teleports:AddDropdown("IslandSelect", {
    Title = "Selecionar Ilha",
    Description = "Escolha a ilha para viajar",
    Values = islandList,
    Multi = false,
    Default = "Starter Island"
}):OnChanged(function(Value)
    SelectedIsland = Value
end)

-- Botão para iniciar viagem
Tabs.Teleports:AddButton({
    Title = "Iniciar Viagem",
    Description = "Teleportar para a ilha selecionada",
    Callback = function()
        if TeleportEnabled then
            startTravel(SelectedIsland)
            Fluent:Notify({
                Title = "Teleporte",
                Content = "Viajando para " .. SelectedIsland,
                Duration = 3
            })
        else
            Fluent:Notify({
                Title = "Aviso",
                Content = "Ative o toggle de teleporte primeiro!",
                Duration = 2
            })
        end
    end
})

-- ================= MISC BUTTONS =================
Tabs.Settings:AddButton({
    Title = "Rejoin Server",
    Description = "🔒 FUNÇÃO DESATIVADA",
    Callback = function()
        Fluent:Notify({
            Title = "Modo Falso",
            Content = "Rejoin está desativado - apenas visual",
            Duration = 2
        })
    end
})

Tabs.Settings:AddButton({
    Title = "Hop Server",
    Description = "🔒 FUNÇÃO DESATIVADA",
    Callback = function()
        Fluent:Notify({
            Title = "Modo Falso",
            Content = "Hop Server está desativado - apenas visual",
            Duration = 2
        })
    end
})

-- ================= SAVE MANAGER =================

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)

InterfaceManager:SetFolder("MirrorsHub")
SaveManager:SetFolder("MirrorsHub/BloxFruits")

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

SaveManager:LoadAutoloadConfig()

Window:SelectTab(2) -- Começa na Main Farm

-- ================= FLOAT BUTTON =================

local FloatGui = Instance.new("ScreenGui")
FloatGui.Name = "MirrorsHubFloat"
FloatGui.Parent = game.CoreGui
FloatGui.ResetOnSpawn = false

local FloatButton = Instance.new("TextButton")
FloatButton.Size = UDim2.fromOffset(60,60)
FloatButton.Position = UDim2.new(0.05,0,0.5,0)
FloatButton.Text = "MH"
FloatButton.Font = Enum.Font.GothamBold
FloatButton.TextSize = 20
FloatButton.BackgroundColor3 = Color3.fromRGB(25,25,25)
FloatButton.TextColor3 = Color3.new(1,1,1)
FloatButton.Parent = FloatGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1,0)
corner.Parent = FloatButton

-- Drag system melhorado
local dragging = false
local dragStart, startPos

FloatButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = FloatButton.Position
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement 
    or input.UserInputType == Enum.UserInputType.Touch) then

        local delta = input.Position - dragStart
        FloatButton.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

FloatButton.MouseButton1Click:Connect(function()
    Window:Minimize()
end)

-- ================= LOOP PRINCIPAL (FAKE) =================
print("✅ Script carregado em MODO FALSO - Interface visual apenas, nenhuma função real")
