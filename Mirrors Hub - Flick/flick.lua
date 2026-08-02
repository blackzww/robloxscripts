local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "Mirrors Hub - [FPS] Flick",
    Icon = "door-open", -- lucide icon
    Author = "by blackzw.mp3",
    Folder = "MirrorsHub/[FPS] Flick",
    
    Size = UDim2.fromOffset(580, 460),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),
    ToggleKey = Enum.KeyCode.K,
    Transparent = true,
    Theme = "Violet",
    Resizable = true,
    SideBarWidth = 200,
    BackgroundImageTransparency = 0.42,
    HideSearchBar = true,
    ScrollBarEnabled = false,
    
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            warn("spotify farlands")
        end,
    },
})

Window:Tag({
    Title = "v1.0.0",
    Color = Color3.fromHex("00FF66"),
    Radius = 13,
})

Window:SetToggleKey(Enum.KeyCode.K)

Window:EditOpenButton({
    Title = "Open Mirrors Hub - [FPS] Flick",
    Icon = "monitor",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new( -- gradient
        Color3.fromHex("7B00FF"), 
        Color3.fromHex("3C007D")
    ),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

local Info = Window:Tab({ Title = "Info", Icon = "info" })
local Main = Window:Tab({ Title = "Main", Icon = "house" })
local Esp = Window:Tab({ Title = "Esp", Icon = "eye" })
local Visual = Window:Tab({ Title = "Visual", Icon = "shirt" })
local Misc = Window:Tab({ Title = "Misc", Icon = "layers" })
local Config = Window:Tab({ Title = "Config", Icon = "cog" })

Info:Select()

Info:Paragraph({
    Title = "Mirrors Hub - [FPS] Flick",
    Desc = "Script feito por blackzw.mp3 Entra no nosso Discord pra ficar por dentro de atualizações, tirar dúvidas e reportar bugs!",
    Image = "info",
    ImageSize = 24,
    Thumbnail = "rbxassetid://91587269886962",
    ThumbnailSize = 70,
    Buttons = {
        {
            Title = "Entrar no Discord",
            Icon = "message-circle",
            Callback = function()
                setclipboard("https://discord.gg/YZEg6FyRSF")

                WindUI:Notify({
                    Title = "Discord",
                    Content = "Convite copiado! Cola no navegador pra entrar.",
                    Duration = 3
                })
            end
        }
    }
})

local ServerInfo
local JoinTime = os.time() 

local function FormatTime(seconds)
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = seconds % 60
    return string.format("%02d:%02d:%02d", h, m, s)
end

local function UpdateStatus()
    local player = game.Players.LocalPlayer
    local players = #game.Players:GetPlayers()
    local maxPlayers = game.Players.MaxPlayers
    local ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
    local timeInServer = FormatTime(os.time() - JoinTime)
    local accountAge = player.AccountAge 

    ServerInfo:SetDesc(string.format(
        "👥 Jogadores: %d / %d\n📶 Ping: %d ms\n⏱️ Tempo no servidor: %s\n🧑 Nome: %s (@%s)\n🎂 Conta criada há: %d dias\n🖥️ PlaceId: %d\n🔑 JobId: %s",
        players, maxPlayers, ping, timeInServer, player.DisplayName, player.Name, accountAge, game.PlaceId, game.JobId
    ))
end

ServerInfo = Info:Paragraph({
    Title = "Informações do Servidor",
    Desc = "Carregando...",
})

UpdateStatus()

task.spawn(function()
    while task.wait(5) do
        UpdateStatus()
    end
end)

Info:Space()

local Button = Info:Button({
    Title = "Copiar Job ID",
    Color = Color3.fromHex("#a2ff30"),
    Justify = "Center",
    IconAlign = "Left",
    Icon = "clipboard-copy",
    Callback = function()
        if setclipboard then
            setclipboard(game.JobId)
            WindUI:Notify({
                Title = "Copiado!",
                Content = "Job ID copiado para a área de transferência.",
                Duration = 3,
            })
        else
            warn("Seu executor não suporta setclipboard.")
        end
    end
})

-- ==========================================
-- SERVIÇOS E VARIÁVEIS INICIAIS
-- ==========================================
local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")
local coreGui = game:GetService("CoreGui")

local localPlayer = players.LocalPlayer
local camera = workspace.CurrentCamera

getgenv().AimbotEnabled = false
getgenv().ProximityMode = false
getgenv().ViewMode = false

-- ==========================================
-- CAPTURA DO ALCANCE REAL DA ARMA (STUDS)
-- ==========================================
local bulletHandler = require(replicatedStorage.ModuleScripts.GunModules.BulletHandler)
local originalFire = bulletHandler.Fire

local function getWeaponTrueRange()
    local success, range = pcall(function()
        return bulletHandler.Range or bulletHandler.MaxDistance or bulletHandler.BulletRange or 300
    end)
    return success and range or 300
end

-- ==========================================
-- SISTEMA DE ESP: CAIXA NOS JOGADORES (ESCALA FIXA DE 30 STUDS)
-- ==========================================
local boxCache = {}

local function createPlayerRangeBox(player)
    if boxCache[player] then return end
    
    local sizePart = Instance.new("Part")
    sizePart.Name = "Fixed30StudsPart"
    sizePart.Size = Vector3.new(30, 30, 30)
    sizePart.Anchored = false
    sizePart.CanCollide = false
    sizePart.Transparency = 1
    sizePart.Parent = workspace

    local box = Instance.new("SelectionBox")
    box.Name = "TrueRangePlayerBox"
    box.Adornee = sizePart
    box.Color3 = Color3.fromRGB(148, 0, 211)
    box.SurfaceColor3 = Color3.fromRGB(148, 0, 211)
    box.SurfaceTransparency = 0.75
    box.Transparency = 0.2
    box.Parent = coreGui
    
    boxCache[player] = {Box = box, Part = sizePart}
end

local function removePlayerRangeBox(player)
    if boxCache[player] then
        if boxCache[player].Box then boxCache[player].Box:Destroy() end
        if boxCache[player].Part then boxCache[player].Part:Destroy() end
        boxCache[player] = nil
    end
end

players.PlayerRemoving:Connect(removePlayerRangeBox)

-- ==========================================
-- FUNÇÃO DE ALVO COM SUPORTE AOS DOIS MODOS
-- ==========================================
local function getTargetByMode()
    local bestTarget = nil
    local currentMaxRange = getWeaponTrueRange()
    
    local char = localPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    if getgenv().ProximityMode then
        local shortestDistance = math.huge
        for _, player in ipairs(players:GetPlayers()) do
            if player == localPlayer then continue end
            local character = player.Character
            if not character then continue end
            
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local head = character:FindFirstChild("Head")
            if not head or not humanoid or humanoid.Health <= 0 then continue end
            
            local distance3D = (head.Position - root.Position).Magnitude
            if distance3D <= currentMaxRange and distance3D < shortestDistance then
                shortestDistance = distance3D
                bestTarget = head
            end
        end
        return bestTarget

    elseif getgenv().ViewMode then
        local closestDist = math.huge
        local mousePos = camera.ViewportSize / 2
        
        for _, player in ipairs(players:GetPlayers()) do
            if player == localPlayer then continue end
            local character = player.Character
            if not character then continue end
            
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local head = character:FindFirstChild("Head")
            if not head or not humanoid or humanoid.Health <= 0 then continue end
            
            local distance3D = (head.Position - root.Position).Magnitude
            if distance3D <= currentMaxRange then
                local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        bestTarget = head
                    end
                end
            end
        end
        return bestTarget
    end

    return nil
end

-- ==========================================
-- ATUALIZAÇÃO DO ESP DOS JOGADORES EM TEMPO REAL
-- ==========================================
runService.RenderStepped:Connect(function()
    local char = localPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local currentMaxRange = getWeaponTrueRange()
    local currentTarget = getTargetByMode()

    for _, player in ipairs(players:GetPlayers()) do
        if player ~= localPlayer then
            local character = player.Character
            local targetRoot = character and character:FindFirstChild("HumanoidRootPart")
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            
            if (getgenv().ProximityMode or getgenv().ViewMode) and getgenv().AimbotEnabled and root and targetRoot and humanoid and humanoid.Health > 0 then
                if not boxCache[player] then
                    createPlayerRangeBox(player)
                end
                
                local cacheData = boxCache[player]
                if cacheData and cacheData.Box and cacheData.Part then
                    local distanceToPlayer = (targetRoot.Position - root.Position).Magnitude
                    
                    if distanceToPlayer <= currentMaxRange then
                        cacheData.Part.CFrame = targetRoot.CFrame
                        cacheData.Box.Adornee = cacheData.Part
                        
                        local head = character:FindFirstChild("Head")
                        if head and head == currentTarget then
                            cacheData.Box.Color3 = Color3.fromRGB(255, 0, 255)
                            cacheData.Box.SurfaceTransparency = 0.5
                        else
                            cacheData.Box.Color3 = Color3.fromRGB(148, 0, 211)
                            cacheData.Box.SurfaceTransparency = 0.75
                        end
                    else
                        cacheData.Box.Adornee = nil
                    end
                end
            else
                if boxCache[player] and boxCache[player].Box then
                    boxCache[player].Box.Adornee = nil
                end
            end
        end
    end
end)

-- ==========================================
-- INTERCEPTAÇÃO DO TIRO
-- ==========================================
pcall(function()
    if make_writeable then make_writeable(bulletHandler) end
end)

bulletHandler.Fire = function(arg1)
    if getgenv().AimbotEnabled and (getgenv().ProximityMode or getgenv().ViewMode) and (arg1 and arg1.Misc) then
        local target = getTargetByMode()
        if target then
            local headPos = target.Position
            
            arg1.Direction = (headPos - arg1.Origin).Unit
            if arg1.Misc then
                arg1.Misc.CamCFrame = CFrame.new(arg1.Origin, headPos)
            end
        end
    end
    return originalFire(arg1)
end

-- ==========================================
-- INTERFACE - TOGGLES E DROPDOWNS MAIN
-- ==========================================

local ToggleMain = Main:Toggle({
    Title = "Silent Aim + ESP (Kick Risk!)",
    Desc = "Redirects your shots to targets within true weapon range and shows a 30-stud ESP box around them.",
    Value = false,
    Type = "Toggle",
    Locked = false,
    Flag = "range_esp_main",
    Callback = function(state)
        getgenv().AimbotEnabled = state
        if not state then
            for _, cacheData in pairs(boxCache) do
                if cacheData.Box then
                    cacheData.Box.Adornee = nil
                end
            end
        end
        print("Master Box ESP state:", state)
    end
})

local PriorityDropdown = Main:Dropdown({
    Title = "Target Priority Mode",
    Values = {
        "Proximity Priority",
        "Crosshair Priority"
    },
    Callback = function(selected)
        if selected == "Proximity Priority" then
            getgenv().ProximityMode = true
            getgenv().ViewMode = false
        elseif selected == "Crosshair Priority" then
            getgenv().ProximityMode = false
            getgenv().ViewMode = true
        else
            getgenv().ProximityMode = false
            getgenv().ViewMode = false
        end
        print("Priority changed to:", selected)
    end
})

-- ==========================================
-- AUTO FIRE / TRIGGER BOT
-- ==========================================
local SignalManager = require(replicatedStorage:WaitForChild("SignalManager"))
local oldFire = bulletHandler.Fire
local maxDistance = 500

getgenv().TriggerActive = false

local function getTarget()
    if not getgenv().TriggerActive then return nil end
    
    local target = nil
    local dist = maxDistance
    local cam = workspace.CurrentCamera
    
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    if localPlayer.Character then
        rayParams.FilterDescendantsInstances = {localPlayer.Character}
    end

    for _, v in ipairs(players:GetPlayers()) do
        if v ~= localPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local head = v.Character:FindFirstChild("Head")
            if head then
                local d = (head.Position - cam.CFrame.Position).Magnitude
                if d < dist then
                    local dir = (head.Position - cam.CFrame.Position).Unit * d
                    local hit = workspace:Raycast(cam.CFrame.Position, dir, rayParams)
                    
                    if not hit or hit.Instance:IsDescendantOf(v.Character) then
                        dist = d
                        target = head
                    end
                end
            end
        end
    end
    return target
end

task.spawn(function()
    while task.wait(0.05) do
        if getgenv().TriggerActive and getTarget() then
            SignalManager.Fire("FireWeapon", Enum.UserInputState.Begin)
            task.wait(0.05)
            SignalManager.Fire("FireWeapon", Enum.UserInputState.End)
        end
    end
end)

local ToggleAutoFire = Main:Toggle({
    Title = "Auto Fire",
    Desc = "Redirects bullet direction and auto-fires at targets in line of sight.",
    Value = false,
    Type = "Toggle",
    Locked = false,
    Flag = "silent_trigger_toggle",
    Callback = function(state)
        getgenv().TriggerActive = state
        print("Feature state:", state)
    end
})

-- ==========================================
-- LÓGICA REFORMULADA E BLINDADA DO SKIN CHANGER
-- ==========================================
getgenv().SkinChangerEnabled = false
getgenv().SelectedSkin = "RedDragon"

-- Tabela para guardar os componentes originais e restaurá-los sem falhas no Reset
local originalPartsStorage = {}

local skinModels = {
    ["RedDragon"]  = replicatedStorage:FindFirstChild("Models") and replicatedStorage.Models:FindFirstChild("NewA") and replicatedStorage.Models.NewA:FindFirstChild("RedDragon"),
    ["Axe"]        = replicatedStorage:FindFirstChild("Models") and replicatedStorage.Models:FindFirstChild("Axe"),
    ["FlameAxe"]   = replicatedStorage:FindFirstChild("Models") and replicatedStorage.Models:FindFirstChild("Season1Chal") and replicatedStorage.Models.Season1Chal:FindFirstChild("FlameAxe"),
    ["DarkAxe"]    = replicatedStorage:FindFirstChild("Models") and replicatedStorage.Models:FindFirstChild("Lim1") and replicatedStorage.Models.Lim1:FindFirstChild("DarkAxe"),
    ["RedDagger"]  = replicatedStorage:FindFirstChild("Models") and replicatedStorage.Models:FindFirstChild("NewA") and replicatedStorage.Models.NewA:FindFirstChild("RedDagger"),
    ["RedShot"]    = replicatedStorage:FindFirstChild("Models") and replicatedStorage.Models:FindFirstChild("NewA") and replicatedStorage.Models.NewA:FindFirstChild("RedShot")
}

local function cleanCustomSkin(tool)
    local customVisual = tool:FindFirstChild("MirrorsSkinVisual")
    if customVisual then customVisual:Destroy() end
    
    -- Restaura as partes originais da arma que foram guardadas
    if originalPartsStorage[tool] then
        for _, part in ipairs(originalPartsStorage[tool]) do
            if part and part.Parent then
                part.Transparency = 0
                pcall(function() part.CanCollide = true end)
            end
        end
        originalPartsStorage[tool] = nil
    end
end

local function applySkin()
    if not getgenv().SkinChangerEnabled then return end
    local char = localPlayer.Character
    if not char then return end
    
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            -- Limpa qualquer resquício ou bug de skin anterior antes de aplicar a nova
            cleanCustomSkin(tool)

            -- Atualiza referências caso tenham carregado atrasadas
            local targetModel = skinModels[getgenv().SelectedSkin]
            if not targetModel and replicatedStorage:FindFirstChild("Models") then
                skinModels = {
                    ["RedDragon"]  = replicatedStorage.Models.NewA:FindFirstChild("RedDragon"),
                    ["Axe"]        = replicatedStorage.Models:FindFirstChild("Axe"),
                    ["FlameAxe"]   = replicatedStorage.Models.Season1Chal:FindFirstChild("FlameAxe"),
                    ["DarkAxe"]    = replicatedStorage.Models.Lim1:FindFirstChild("DarkAxe"),
                    ["RedDagger"]  = replicatedStorage.Models.NewA:FindFirstChild("RedDagger"),
                    ["RedShot"]    = replicatedStorage.Models.NewA:FindFirstChild("RedShot")
                }
                targetModel = skinModels[getgenv().SelectedSkin]
            end

            local handle = tool:FindFirstChild("Handle")
            if targetModel and handle then
                originalPartsStorage[tool] = {}
                
                -- Oculta os componentes originais com segurança
                for _, child in ipairs(tool:GetChildren()) do
                    if (child:IsA("BasePart") or child:IsA("MeshPart")) and child.Name ~= "Handle" then
                        child.Transparency = 1
                        child.CanCollide = false
                        table.insert(originalPartsStorage[tool], child)
                    end
                end
                
                -- Se o Handle original tiver mesh visível, esconde também
                if handle:IsA("MeshPart") or handle:FindFirstChildOfClass("SpecialMesh") then
                    handle.Transparency = 1
                    table.insert(originalPartsStorage[tool], handle)
                end
                
                -- Prepara e injeta o clone da nova Skin
                local skinClone = targetModel:Clone()
                skinClone.Name = "MirrorsSkinVisual"
                
                -- FORÇA O ALINHAMENTO ZERANDO COORDENADAS GLOBAIS ANTES DA SOLDA
                if skinClone:IsA("Model") then
                    local primary = skinClone.PrimaryPart or skinClone:FindFirstChildOfClass("BasePart")
                    if primary then
                        skinClone:SetPrimaryPartCFrame(handle.CFrame)
                    else
                        skinClone:MoveTo(handle.Position)
                    end
                elseif skinClone:IsA("BasePart") then
                    skinClone.CFrame = handle.CFrame
                end
                
                skinClone.Parent = tool
                
                -- Cria ancoragem física estável (funciona para Part única ou Model composto)
                local function weldInstances(base, current)
                    if current:IsA("BasePart") then
                        current.CanCollide = false
                        current.Massless = true
                        local weld = Instance.new("WeldConstraint")
                        weld.Name = "SkinWeld"
                        weld.Part0 = base
                        weld.Part1 = current
                        weld.Parent = current
                    end
                    for _, child in ipairs(current:GetChildren()) do
                        weldInstances(base, child)
                    end
                end
                
                weldInstances(handle, skinClone)
            end
        end
    end
end

-- Ouvintes de eventos para troca de arma em tempo de execução
localPlayer.CharacterAppearanceLoaded:Connect(function(char)
    char.ChildAdded:Connect(function(child)
        if child:IsA("Tool") and getgenv().SkinChangerEnabled then
            task.wait(0.1)
            applySkin()
        end
    end)
end)

if localPlayer.Character then
    localPlayer.Character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") and getgenv().SkinChangerEnabled then
            task.wait(0.1)
            applySkin()
        end
    end)
end

-- ==========================================
-- INTERFACE - ABA DE SKINS ATUALIZADA (WINDUI)
-- ==========================================

local SkinDropdown = Visual:Dropdown({
    Title = "Select Weapon Skin",
    Desc = "Choose the skin model to be injected into your current weapon.",
    Values = { "RedDragon", "Axe", "FlameAxe", "DarkAxe", "RedDagger", "RedShot" },
    Value = "RedDragon",
    Callback = function(option) 
        getgenv().SelectedSkin = option
        print("[Mirrors Hub] Selected skin option changed to: " .. option) 
        if getgenv().SkinChangerEnabled then
            applySkin()
        end
    end
})

local ButtonEnable = Visual:Button({
    Title = "Enable Skins",
    Desc = "Applies the chosen model from the dropdown to your equipped weapon.",
    Icon = "check",
    Callback = function()
        getgenv().SkinChangerEnabled = true
        applySkin()
        print("[Mirrors Hub] Skin Changer successfully applied!")
    end
})

local ButtonReset = Visual:Button({
    Title = "Reset Skins",
    Desc = "Removes the customized skin and returns the weapon to its default look.",
    Icon = "refresh-cw",
    Callback = function()
        getgenv().SkinChangerEnabled = false
        
        local char = localPlayer.Character
        if char then
            for _, tool in ipairs(char:GetChildren()) do
                if tool:IsA("Tool") then
                    cleanCustomSkin(tool)
                end
            end
            
            -- Também limpa a mochila (caso a arma não esteja na mão no momento do reset)
            local backpack = localPlayer:FindFirstChild("Backpack")
            if backpack then
                for _, tool in ipairs(backpack:GetChildren()) do
                    if tool:IsA("Tool") then
                        cleanCustomSkin(tool)
                    end
                end
            end
        end
        print("[Mirrors Hub] Skins successfully reset to original without glitches.")
    end
})
