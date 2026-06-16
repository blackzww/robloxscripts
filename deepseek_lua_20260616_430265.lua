-- ═══════════════════════════════════════════════════════════════
--  🚀 SISTEMA DE DUPE PARA DELTA - ROBOX 2 COMPATIBLE
--  Arquitetura: Servidor-Autoritativa + Replica System
--  Engine: Delta / Synapse / ScriptWare
-- ═══════════════════════════════════════════════════════════════

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer

-- ═══════════════════════════════════════════════════════════════
--  🔍 PHASE 1: DISCOVERY - VARRE DURA MÓDULOS
-- ═══════════════════════════════════════════════════════════════

local function DeepScanModules()
    local modules = {
        found = {},
        remotes = {},
        buffers = {},
        controllers = {}
    }
    
    -- Varre ReplicatedStorage
    local function scanInstance(instance, path)
        if not instance then return end
        
        for _, child in ipairs(instance:GetChildren()) do
            local fullPath = path .. "." .. child.Name
            
            -- Módulos Compartilhados
            if child:IsA("ModuleScript") then
                local moduleName = child.Name
                if moduleName:match("Replica") or 
                   moduleName:match("Inventory") or 
                   moduleName:match("Item") or
                   moduleName:match("Packet") or
                   moduleName:match("Buffer") then
                    table.insert(modules.found, {
                        name = moduleName,
                        path = fullPath,
                        type = "ModuleScript"
                    })
                end
            end
            
            -- RemoteEvents
            if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                table.insert(modules.remotes, {
                    name = child.Name,
                    path = fullPath,
                    type = child.ClassName
                })
            end
            
            -- Continua escaneando
            if child:GetChildren() then
                scanInstance(child, fullPath)
            end
        end
    end
    
    scanInstance(ReplicatedStorage, "ReplicatedStorage")
    scanInstance(player:FindFirstChild("PlayerScripts"), "PlayerScripts")
    
    return modules
end

-- ============================================
--  DISCOVERY EXECUTION
-- ============================================

local modulesFound = DeepScanModules()
print("🔍 Módulos encontrados:", #modulesFound.found)
print("📡 Remotes encontrados:", #modulesFound.remotes)

-- ============================================
--  CARREGA MÓDULOS ESSENCIAIS
-- ============================================

local ReplicaShared = nil
local InventoryController = nil
local ItemCatalog = nil
local PacketRemote = nil
local BufferToHex = nil
local HexToBuffer = nil

-- Tenta carregar módulos
for _, module in ipairs(modulesFound.found) do
    local moduleInstance = ReplicatedStorage:FindFirstChild(module.name, true)
    if moduleInstance and moduleInstance:IsA("ModuleScript") then
        local success, result = pcall(function()
            return require(moduleInstance)
        end)
        if success and result then
            if module.name:match("Replica") then
                ReplicaShared = result
            elseif module.name:match("Inventory") then
                InventoryController = result
            elseif module.name:match("ItemCatalog") then
                ItemCatalog = result
            elseif module.name:match("Buffer") then
                if module.name:match("BufferToHex") then
                    BufferToHex = result
                elseif module.name:match("HexToBuffer") then
                    HexToBuffer = result
                end
            end
        end
    end
end

-- Encontra RemoteEvent
for _, remote in ipairs(modulesFound.remotes) do
    if remote.name:match("Packet") or remote.name:match("RemoteEvent") then
        local remoteInstance = ReplicatedStorage:FindFirstChild(remote.name, true)
        if remoteInstance and remoteInstance:IsA("RemoteEvent") then
            PacketRemote = remoteInstance
        end
    end
end

print("✅ Módulos carregados:")
print("  📦 ReplicaShared:", ReplicaShared and "✅" or "❌")
print("  📦 InventoryController:", InventoryController and "✅" or "❌")
print("  📦 ItemCatalog:", ItemCatalog and "✅" or "❌")
print("  📡 PacketRemote:", PacketRemote and "✅" or "❌")

-- ═══════════════════════════════════════════════════════════════
--  🎨 PHASE 2: UI AVANÇADA - TEMA ROBOX 2
-- ═══════════════════════════════════════════════════════════════

local gui = Instance.new("ScreenGui")
gui.Name = "DevDupeSystem"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- ============================================
--  MAIN FRAME - GLASSMORPHISM
-- ============================================

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 380, 0, 280)
frame.Position = UDim2.new(0.5, -190, 0.4, -140)
frame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
frame.BackgroundTransparency = 0.15
frame.BorderSizePixel = 0
frame.Active = true
frame.ClipsDescendants = true
frame.Parent = gui

-- Glass Effect
local glass = Instance.new("Frame")
glass.Size = UDim2.new(1, 0, 1, 0)
glass.BackgroundTransparency = 1
glass.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
glass.Parent = frame

local glassCorner = Instance.new("UICorner")
glassCorner.CornerRadius = UDim.new(0, 16)
glassCorner.Parent = frame

-- Border Neon
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(140, 50, 255)
stroke.Thickness = 1.5
stroke.Transparency = 0.3
stroke.Parent = frame

-- Glow Effect (Background gradient)
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 10, 60)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 5, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 5, 25))
})
gradient.Rotation = 45
gradient.Parent = frame

-- ============================================
--  HEADER
-- ============================================

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundColor3 = Color3.fromRGB(140, 50, 255)
header.BackgroundTransparency = 0.2
header.BorderSizePixel = 0
header.Parent = frame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 16)
headerCorner.Parent = header

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 16, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🚀 DEV DUPE v3.0"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Status do Sistema
local sysStatus = Instance.new("TextLabel")
sysStatus.Size = UDim2.new(0, 70, 1, 0)
sysStatus.Position = UDim2.new(1, -80, 0, 0)
sysStatus.BackgroundTransparency = 1
sysStatus.Text = "🟢 ATIVO"
sysStatus.TextColor3 = Color3.fromRGB(0, 255, 100)
sysStatus.TextSize = 11
sysStatus.Font = Enum.Font.GothamBold
sysStatus.TextXAlignment = Enum.TextXAlignment.Right
sysStatus.Parent = header

-- ============================================
--  MÉTRICAS EM TEMPO REAL
-- ============================================

local metricsFrame = Instance.new("Frame")
metricsFrame.Size = UDim2.new(1, -24, 0, 35)
metricsFrame.Position = UDim2.new(0, 12, 0, 58)
metricsFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 30)
metricsFrame.BackgroundTransparency = 0.5
metricsFrame.BorderSizePixel = 0
metricsFrame.Parent = frame

local metricsCorner = Instance.new("UICorner")
metricsCorner.CornerRadius = UDim.new(0, 8)
metricsCorner.Parent = metricsFrame

-- Ping
local pingLabel = Instance.new("TextLabel")
pingLabel.Size = UDim2.new(0.5, -6, 1, 0)
pingLabel.Position = UDim2.new(0, 6, 0, 0)
pingLabel.BackgroundTransparency = 1
pingLabel.Text = "📶 Ping: 0ms"
pingLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
pingLabel.TextSize = 12
pingLabel.Font = Enum.Font.GothamMedium
pingLabel.TextXAlignment = Enum.TextXAlignment.Left
pingLabel.Parent = metricsFrame

-- Memória
local memLabel = Instance.new("TextLabel")
memLabel.Size = UDim2.new(0.5, -6, 1, 0)
memLabel.Position = UDim2.new(0.5, 6, 0, 0)
memLabel.BackgroundTransparency = 1
memLabel.Text = "💾 Mem: 0MB"
memLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
memLabel.TextSize = 12
memLabel.Font = Enum.Font.GothamMedium
memLabel.TextXAlignment = Enum.TextXAlignment.Left
memLabel.Parent = metricsFrame

-- ============================================
--  MONITOR DE ITEM
-- ============================================

local itemMonitor = Instance.new("Frame")
itemMonitor.Size = UDim2.new(1, -24, 0, 35)
itemMonitor.Position = UDim2.new(0, 12, 0, 101)
itemMonitor.BackgroundColor3 = Color3.fromRGB(20, 15, 30)
itemMonitor.BackgroundTransparency = 0.5
itemMonitor.BorderSizePixel = 0
itemMonitor.Parent = frame

local itemCorner = Instance.new("UICorner")
itemCorner.CornerRadius = UDim.new(0, 8)
itemCorner.Parent = itemMonitor

-- Ícone do Item
local itemIcon = Instance.new("TextLabel")
itemIcon.Size = UDim2.new(0, 30, 1, 0)
itemIcon.Position = UDim2.new(0, 6, 0, 0)
itemIcon.BackgroundTransparency = 1
itemIcon.Text = "📦"
itemIcon.TextColor3 = Color3.fromRGB(200, 180, 255)
itemIcon.TextSize = 18
itemIcon.Font = Enum.Font.Gotham
itemIcon.Parent = itemMonitor

-- Nome do Item
local itemName = Instance.new("TextLabel")
itemName.Size = UDim2.new(1, -100, 1, 0)
itemName.Position = UDim2.new(0, 40, 0, 0)
itemName.BackgroundTransparency = 1
itemName.Text = "Item: Nenhum"
itemName.TextColor3 = Color3.fromRGB(205, 180, 255)
itemName.TextSize = 14
itemName.Font = Enum.Font.GothamMedium
itemName.TextXAlignment = Enum.TextXAlignment.Left
itemName.Parent = itemMonitor

-- ID do Item
local itemId = Instance.new("TextLabel")
itemId.Size = UDim2.new(0, 80, 1, 0)
itemId.Position = UDim2.new(1, -86, 0, 0)
itemId.BackgroundTransparency = 1
itemId.Text = "ID: ---"
itemId.TextColor3 = Color3.fromRGB(150, 150, 180)
itemId.TextSize = 10
itemId.Font = Enum.Font.Gotham
itemId.TextXAlignment = Enum.TextXAlignment.Right
itemId.Parent = itemMonitor

-- ============================================
--  STATUS E COOLDOWN
-- ============================================

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -24, 0, 25)
statusLabel.Position = UDim2.new(0, 12, 0, 144)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "⏳ Status: Aguardando ação..."
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 165)
statusLabel.TextSize = 13
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = frame

local cooldownLabel = Instance.new("TextLabel")
cooldownLabel.Size = UDim2.new(1, -24, 0, 25)
cooldownLabel.Position = UDim2.new(0, 12, 0, 169)
cooldownLabel.BackgroundTransparency = 1
cooldownLabel.Text = "⏱️ Cooldown: Pronto"
cooldownLabel.TextColor3 = Color3.fromRGB(150, 200, 150)
cooldownLabel.TextSize = 12
cooldownLabel.Font = Enum.Font.Gotham
cooldownLabel.TextXAlignment = Enum.TextXAlignment.Left
cooldownLabel.Parent = frame

-- ============================================
--  BOTÃO PRINCIPAL - EXECUTAR DUPE
-- ============================================

local dupeButton = Instance.new("TextButton")
dupeButton.Size = UDim2.new(1, -24, 0, 40)
dupeButton.Position = UDim2.new(0, 12, 0, 200)
dupeButton.BackgroundColor3 = Color3.fromRGB(140, 50, 255)
dupeButton.BackgroundTransparency = 0.2
dupeButton.BorderSizePixel = 0
dupeButton.Text = "🔄 EXECUTAR REQUISIÇÃO"
dupeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
dupeButton.TextSize = 15
dupeButton.Font = Enum.Font.GothamBold
dupeButton.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 10)
btnCorner.Parent = dupeButton

local btnStroke = Instance.new("UIStroke")
btnStroke.Color = Color3.fromRGB(140, 50, 255)
btnStroke.Thickness = 1.5
btnStroke.Transparency = 0.2
btnStroke.Parent = dupeButton

-- Efeito Glow no botão
local btnGlow = Instance.new("Frame")
btnGlow.Size = UDim2.new(1, 0, 1, 0)
btnGlow.Position = UDim2.new(0, 0, 0, 0)
btnGlow.BackgroundColor3 = Color3.fromRGB(140, 50, 255)
btnGlow.BackgroundTransparency = 0.9
btnGlow.BorderSizePixel = 0
btnGlow.Parent = dupeButton

local glowCorner = Instance.new("UICorner")
glowCorner.CornerRadius = UDim.new(0, 10)
glowCorner.Parent = btnGlow

-- ============================================
--  BOTÃO DE EXPORTAR LOGS
-- ============================================

local exportBtn = Instance.new("TextButton")
exportBtn.Size = UDim2.new(0, 80, 0, 25)
exportBtn.Position = UDim2.new(1, -92, 1, -32)
exportBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
exportBtn.BackgroundTransparency = 0.5
exportBtn.BorderSizePixel = 0
exportBtn.Text = "📋 Export"
exportBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
exportBtn.TextSize = 11
exportBtn.Font = Enum.Font.GothamMedium
exportBtn.Parent = frame

local exportCorner = Instance.new("UICorner")
exportCorner.CornerRadius = UDim.new(0, 6)
exportCorner.Parent = exportBtn

-- ═══════════════════════════════════════════════════════════════
--  🧠 PHASE 3: ENGINE DE AUTOMAÇÃO
-- ═══════════════════════════════════════════════════════════════

-- ============================================
--  SISTEMA DE COOLDOWN
-- ============================================

local CooldownSystem = {
    lastUse = 0,
    duration = 3.5,
    isReady = true,
    
    CanUse = function(self)
        local elapsed = os.clock() - self.lastUse
        return elapsed >= self.duration
    end,
    
    GetRemaining = function(self)
        local elapsed = os.clock() - self.lastUse
        return math.max(0, self.duration - elapsed)
    end,
    
    Use = function(self)
        self.lastUse = os.clock()
        self.isReady = false
        task.spawn(function()
            task.wait(self.duration)
            self.isReady = true
        end)
    end
}

-- ============================================
--  SISTEMA DE LOGS INTERNOS
-- ============================================

local Logger = {
    entries = {},
    
    Add = function(self, message, type)
        type = type or "INFO"
        local entry = {
            timestamp = os.time(),
            date = os.date("%H:%M:%S"),
            message = message,
            type = type
        }
        table.insert(self.entries, entry)
        
        -- Mostra no status
        statusLabel.Text = string.format("[%s] %s", entry.date, message)
        
        -- Cor por tipo
        if type == "ERROR" then
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        elseif type == "SUCCESS" then
            statusLabel.TextColor3 = Color3.fromRGB(120, 255, 170)
        elseif type == "WARNING" then
            statusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
        else
            statusLabel.TextColor3 = Color3.fromRGB(150, 150, 165)
        end
        
        print(string.format("[DUPE] [%s] %s", entry.date, message))
    end,
    
    Export = function(self)
        local text = "=== DUPE LOGS ===\n"
        for _, entry in ipairs(self.entries) do
            text = text .. string.format("[%s] [%s] %s\n", 
                entry.date, entry.type, entry.message)
        end
        return text
    end
}

-- ============================================
--  SISTEMA DE DETECÇÃO DE ITEM
-- ============================================

local ItemDetector = {
    currentTool = nil,
    currentId = nil,
    
    GetHeldTool = function(self)
        local character = player.Character
        if not character then return nil end
        return character:FindFirstChildOfClass("Tool")
    end,
    
    GetItemId = function(self, tool)
        if not tool then return nil end
        
        -- Tenta pegar ID de várias formas
        local id = tool:GetAttribute("ItemId")
        if id then return id end
        
        id = tool:GetAttribute("ID")
        if id then return id end
        
        -- Se tem Handle, tenta pegar de lá
        local handle = tool:FindFirstChild("Handle")
        if handle then
            id = handle:GetAttribute("ItemId")
            if id then return id end
        end
        
        -- Fallback: usar nome como ID
        return tool.Name
    end,
    
    Update = function(self)
        local tool = self:GetHeldTool()
        
        if tool then
            self.currentTool = tool
            self.currentId = self:GetItemId(tool)
            
            itemName.Text = "📦 Item: " .. tool.Name
            itemId.Text = "ID: " .. (self.currentId or "---")
            
            -- Atualiza estilo
            itemMonitor.BackgroundColor3 = Color3.fromRGB(30, 20, 50)
            
            return true
        else
            self.currentTool = nil
            self.currentId = nil
            
            itemName.Text = "📦 Item: Nenhum"
            itemId.Text = "ID: ---"
            
            itemMonitor.BackgroundColor3 = Color3.fromRGB(20, 15, 30)
            
            return false
        end
    end
}

-- ============================================
--  PIPELINE DE REQUISIÇÃO
-- ============================================

local RequestPipeline = {
    processing = false,
    
    BuildPayload = function(self, tool)
        if not tool then return nil end
        
        local payload = {
            action = "DUPLICATE_ITEM",
            itemName = tool.Name,
            itemId = ItemDetector:GetItemId(tool) or "unknown",
            timestamp = os.time(),
            playerId = player.UserId,
            sessionId = HttpService:GenerateGUID(false)
        }
        
        -- Se tiver ReplicaShared, usa estrutura correta
        if ReplicaShared and ReplicaShared.Create then
            payload = ReplicaShared.Create(payload)
        end
        
        return payload
    end,
    
    Execute = function(self)
        if self.processing then
            Logger:Add("⚠️ Já existe uma requisição em andamento", "WARNING")
            return false
        end
        
        -- Verifica cooldown
        if not CooldownSystem:CanUse() then
            local remaining = CooldownSystem:GetRemaining()
            Logger:Add(string.format("⏱️ Aguarde cooldown: %.1fs", remaining), "WARNING")
            return false
        end
        
        -- Verifica se tem item
        local tool = ItemDetector:GetHeldTool()
        if not tool then
            Logger:Add("❌ Nenhum item equipado!", "ERROR")
            return false
        end
        
        self.processing = true
        dupeButton.Text = "⏳ PROCESSANDO..."
        dupeButton.BackgroundColor3 = Color3.fromRGB(80, 30, 150)
        dupeButton.Active = false
        
        -- FASE 1: Captura dados
        Logger:Add(string.format("📦 Item detectado: %s (ID: %s)", 
            tool.Name, ItemDetector:GetItemId(tool) or "unknown"), "INFO")
        
        -- FASE 2: Construir payload
        Logger:Add("📦 Construindo payload do pacote...", "INFO")
        local payload = self:BuildPayload(tool)
        
        if not payload then
            Logger:Add("❌ Falha ao construir payload", "ERROR")
            self:Reset()
            return false
        end
        
        -- FASE 3: Bufferização (se disponível)
        local buffer = payload
        if HexToBuffer then
            Logger:Add("🔄 Convertendo para buffer...", "INFO")
            buffer = HexToBuffer(payload)
        end
        
        -- FASE 4: Envio
        Logger:Add("📡 Enviando requisição via RemoteEvent...", "INFO")
        
        local success, err = pcall(function()
            if PacketRemote then
                PacketRemote:FireServer(buffer)
            elseif ReplicaShared and ReplicaShared.Remote then
                ReplicaShared.Remote:FireServer(buffer)
            else
                -- Fallback: tenta enviar direto se encontrar algum remote
                local foundRemote = ReplicatedStorage:FindFirstChild("Packet") or 
                                   ReplicatedStorage:FindFirstChild("RemoteEvent")
                if foundRemote and foundRemote:IsA("RemoteEvent") then
                    foundRemote:FireServer(buffer)
                else
                    error("Nenhum RemoteEvent encontrado")
                end
            end
        end)
        
        if not success then
            Logger:Add("❌ Erro no envio: " .. tostring(err), "ERROR")
            self:Reset()
            return false
        end
        
        -- FASE 5: Aguarda resposta
        Logger:Add("⏳ Aguardando resposta do servidor...", "INFO")
        
        -- Resposta via Notify (se disponível)
        local notifyEvent = ReplicatedStorage:FindFirstChild("Notify", true)
        if notifyEvent and notifyEvent:IsA("RemoteEvent") then
            local responseReceived = false
            local connection
            
            connection = notifyEvent.OnClientEvent:Connect(function(message, type)
                responseReceived = true
                if type == "success" then
                    Logger:Add("✅ " .. message, "SUCCESS")
                    CooldownSystem:Use()
                else
                    Logger:Add("❌ " .. message, "ERROR")
                end
                connection:Disconnect()
                self:Reset()
            end)
            
            -- Timeout
            task.spawn(function()
                task.wait(5)
                if not responseReceived then
                    Logger:Add("⏰ Timeout - sem resposta do servidor", "WARNING")
                    if connection then connection:Disconnect() end
                    self:Reset()
                end
            end)
        else
            -- Sem sistema de notificação, assume sucesso
            Logger:Add("✅ Requisição enviada (sem sistema de confirmação)", "SUCCESS")
            CooldownSystem:Use()
            self:Reset()
        end
        
        return true
    end,
    
    Reset = function(self)
        self.processing = false
        dupeButton.Text = "🔄 EXECUTAR REQUISIÇÃO"
        dupeButton.BackgroundColor3 = Color3.fromRGB(140, 50, 255)
        dupeButton.Active = true
    end
}

-- ============================================
--  MONITOR DE MÉTRICAS
-- ============================================

local MetricsMonitor = {
    ping = 0,
    memory = 0,
    
    Update = function(self)
        -- Ping (simulado)
        local stats = game:GetService("Stats")
        if stats and stats.Network then
            local pingStat = stats.Network:FindFirstChild("Ping")
            if pingStat then
                self.ping = math.floor(pingStat:GetValue() or 0)
            end
        end
        
        -- Memória
        if stats and stats.Performance then
            local memStat = stats.Performance:FindFirstChild("MemoryUsed")
            if memStat then
                self.memory = math.floor((memStat:GetValue() or 0) / 1024 / 1024)
            end
        end
        
        -- Atualiza UI
        pingLabel.Text = string.format("📶 Ping: %dms", self.ping)
        memLabel.Text = string.format("💾 Mem: %dMB", self.memory)
    end
}

-- ============================================
--  EVENTOS E CONNECTIONS
-- ============================================

-- Botão Principal
dupeButton.MouseButton1Click:Connect(function()
    RequestPipeline:Execute()
end)

-- Efeitos Hover
dupeButton.MouseEnter:Connect(function()
    if dupeButton.Active then
        dupeButton.BackgroundTransparency = 0.1
        dupeButton.Size = UDim2.new(1, -20, 0, 42)
        local tween = TweenService:Create(dupeButton, 
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(1, -20, 0, 42)}
        )
        tween:Play()
    end
end)

dupeButton.MouseLeave:Connect(function()
    if dupeButton.Active then
        dupeButton.BackgroundTransparency = 0.2
        dupeButton.Size = UDim2.new(1, -24, 0, 40)
        local tween = TweenService:Create(dupeButton,
            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(1, -24, 0, 40)}
        )
        tween:Play()
    end
end)

-- Exportar Logs
exportBtn.MouseButton1Click:Connect(function()
    local logs = Logger:Export()
    if setclipboard then
        setclipboard(logs)
        Logger:Add("📋 Logs exportados para área de transferência!", "SUCCESS")
    elseif writefile then
        writefile("dupe_logs_" .. os.date("%Y%m%d_%H%M%S") .. ".txt", logs)
        Logger:Add("📁 Logs salvos em arquivo!", "SUCCESS")
    else
        Logger:Add("⚠️ Não foi possível exportar logs", "WARNING")
    end
end)

-- ============================================
--  DETECÇÃO DE ITEM EM TEMPO REAL
-- ============================================

local function SetupCharacter(character)
    if not character then return end
    
    character.ChildAdded:Connect(function()
        ItemDetector:Update()
    end)
    
    character.ChildRemoved:Connect(function()
        ItemDetector:Update()
    end)
    
    ItemDetector:Update()
end

if player.Character then
    SetupCharacter(player.Character)
end

player.CharacterAdded:Connect(SetupCharacter)

-- ============================================
--  LOOP DE ATUALIZAÇÃO
-- ============================================

RunService.Heartbeat:Connect(function()
    -- Atualiza cooldown
    if not CooldownSystem.isReady then
        local remaining = CooldownSystem:GetRemaining()
        cooldownLabel.Text = string.format("⏱️ Cooldown: %.1fs", remaining)
        cooldownLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    else
        cooldownLabel.Text = "⏱️ Cooldown: Pronto"
        cooldownLabel.TextColor3 = Color3.fromRGB(150, 200, 150)
    end
    
    -- Atualiza métricas a cada 2 segundos
    if os.time() % 2 == 0 then
        MetricsMonitor:Update()
    end
end)

-- ============================================
--  DRAG DA UI (TOUCH E MOUSE)
-- ============================================

local dragging = false
local dragInput
local dragStart
local startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or
       input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- ============================================
--  INICIALIZAÇÃO
-- ============================================

Logger:Add("🚀 Sistema iniciado!", "SUCCESS")
Logger:Add("🔍 Aguardando item...", "INFO")

-- Tenta detectar item inicial
task.wait(0.5)
ItemDetector:Update()

-- Mostra info do sistema
print("═══════════════════════════════════════════════════")
print("  🚀 DEV DUPE v3.0 - ROBOX 2 COMPATIBLE")
print("═══════════════════════════════════════════════════")
print("  📦 Módulos carregados:")
print("    • ReplicaShared:", ReplicaShared and "✅" or "❌")
print("    • InventoryController:", InventoryController and "✅" or "❌")
print("    • ItemCatalog:", ItemCatalog and "✅" or "❌")
print("    • PacketRemote:", PacketRemote and "✅" or "❌")
print("  📡 Remotes encontrados:", #modulesFound.remotes)
print("  🔄 Cooldown:", CooldownSystem.duration, "segundos")
print("═══════════════════════════════════════════════════")

-- ═══════════════════════════════════════════════════════════════
--  📋 INSTRUÇÕES DE USO - DELTA
-- ═══════════════════════════════════════════════════════════════

-- 1. COLE este script no executor Delta
-- 2. Execute no jogo (ROBOX 2)
-- 3. A interface aparecerá automaticamente
-- 4. Pegue um item no jogo
-- 5. Clique em "EXECUTAR REQUISIÇÃO"
-- 6. Aguarde a resposta do servidor

-- ═══════════════════════════════════════════════════════════════
--  🔧 SOLUÇÃO DE PROBLEMAS
-- ═══════════════════════════════════════════════════════════════

-- Se o RemoteEvent não for encontrado:
-- O script tenta automaticamente encontrar o Packet.RemoteEvent
-- Se falhar, tenta usar ReplicaShared.Remote ou algum RemoteEvent genérico

-- Se o dupe não funcionar:
-- 1. Verifique se o jogo é ROBOX 2
-- 2. Verifique se você tem um item equipado
-- 3. Verifique os logs na interface
-- 4. Aguarde o cooldown de 3.5 segundos

-- Se a UI não aparecer:
-- 1. Verifique se o script foi executado
-- 2. Verifique se o PlayerGui existe
-- 3. Tente reiniciar o script