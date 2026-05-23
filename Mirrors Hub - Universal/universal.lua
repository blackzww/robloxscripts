--// ==========================================================
--// MIRRORS HUB - UNIVERSAL CLEAN + LANGUAGE SYSTEM
--// Folder: MirrorsHub
--// Config: universal-config
--// Language file: language.json
--// ==========================================================

--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// ==========================================================
--// OP WHITELIST
--// Coloque aqui os UserIds autorizados a acessar a aba OP.
--// Exemplo: [123456789] = true,
--// ==========================================================

local AuthorizedOPUsers = {
    [4227153912] = true, -- TROQUE PELO SEU USERID
}

local IsOPAuthorized = AuthorizedOPUsers[LocalPlayer.UserId] == true

--// CONSTANTS
local HUB_NAME = "Mirrors Hub"
local HUB_VERSION = "1.3"
local HUB_FOLDER = "MirrorsHub"
local LANGUAGE_FILE = HUB_FOLDER .. "/language.json"

--// FILE HELPERS
local function EnsureFolder()
    if makefolder and not isfolder(HUB_FOLDER) then
        pcall(function()
            makefolder(HUB_FOLDER)
        end)
    end
end

EnsureFolder()

--// ==========================================================
--// LANGUAGE SYSTEM
--// ==========================================================

local CurrentLanguage = "English"

local Languages = {
    English = {
        WindowTitle = "Mirrors Hub - Universal",
        OpenButton = "Open Mirrors Hub",

        TabScripts = "Scripts",
        TabAimbot = "Aimbot",
        TabESP = "ESP",
        TabTroll = "Troll",
        TabMisc = "Misc",
        TabConfig = "Config",

        SectionHome = "Home",
        SectionMain = "Main",
        SectionFOV = "FOV",
        SectionTuning = "Tuning",
        SectionInfo = "Info",
        SectionVisual = "Visual",
        SectionComingSoon = "Coming Soon",
        SectionMovement = "Movement",
        SectionUtility = "Utility",
        SectionConfigFile = "Config File",
        SectionStartup = "Startup",
        SectionInterface = "Interface",
        SectionLanguage = "Language",

        HomeTitle = "Mirrors Hub",
        HomeDesc = "Universal script hub.\nVersion: ",
        LoadScript = "Load Script",
        LoadScriptDesc = "Placeholder.",
        NoScriptConfigured = "No script configured yet.",

        EnableAimbot = "Enable Aimbot",
        EnableAimbotDesc = "Enable or disable aim assist.",
        TeamCheck = "Team Check",
        TeamCheckDesc = "Ignore players from your own team.",
        VisibleCheck = "Visible Check",
        VisibleCheckDesc = "Only target visible players.",
        TargetPart = "Target Part",
        TargetPartDesc = "Body part to target.",
        AimbotFOV = "Aimbot FOV",
        AimbotFOVDesc = "FOV radius size.",
        ShowFOVCircle = "Show FOV Circle",
        ShowFOVCircleDesc = "Display the FOV circle.",
        FOVColor = "FOV Color",
        FOVColorDesc = "FOV circle color.",
        Smoothness = "Smoothness",
        SmoothnessDesc = "Aim smoothing.",
        AimStrength = "Aim Strength",
        AimStrengthDesc = "Aim pull strength.",
        TargetSwitchDelay = "Target Switch Delay",
        TargetSwitchDelayDesc = "Delay before switching targets.",

        EnableESP = "Enable ESP",
        EnableESPDesc = "Enable or disable ESP.",
        ESPColor = "ESP Color",
        ESPColorDesc = "Main ESP color.",
        ShowNames = "Show Names",
        ShowNamesDesc = "Show player names.",
        ShowHealth = "Show Health",
        ShowHealthDesc = "Show player health.",
        ShowDistance = "Show Distance",
        ShowDistanceDesc = "Show player distance.",
        ShowLines = "Show Lines",
        ShowLinesDesc = "Draw lines from screen bottom to players.",
        FillBox = "Fill Box",
        FillBoxDesc = "Fill player body with transparent color.",
        FillTransparency = "Fill Transparency",
        FillTransparencyDesc = "Fill transparency.",
        OutlineTransparency = "Outline Transparency",
        OutlineTransparencyDesc = "Outline transparency.",
        TextSize = "Text Size",
        TextSizeDesc = "ESP text size.",
        MaxDistance = "Max Distance",
        MaxDistanceDesc = "Maximum ESP distance.",
        RefreshESP = "Refresh ESP",
        RefreshESPDesc = "Reload ESP objects.",
        ESPUpdated = "ESP refreshed.",

        TrollAction1 = "Troll Action 1",
        TrollAction2 = "Troll Action 2",
        Placeholder = "Placeholder.",
        NotConfigured = "Not configured yet.",

        WalkSpeed = "WalkSpeed",
        WalkSpeedDesc = "Movement speed.",
        JumpPower = "JumpPower",
        JumpPowerDesc = "Jump power.",
        Noclip = "Noclip",
        NoclipDesc = "Walk through collisions.",
        InfiniteJump = "Infinite Jump",
        InfiniteJumpDesc = "Jump infinitely.",
        AntiAFK = "Anti AFK",
        AntiAFKDesc = "Prevents idle kick.",
        ResetCharacter = "Reset Character",
        ResetCharacterDesc = "Reset your character.",
        RejoinServer = "Rejoin Server",
        RejoinServerDesc = "Reconnect to the same game.",
        ServerHop = "Server Hop",
        ServerHopDesc = "Move to another server.",
        SmallServer = "Small Server",
        SmallServerDesc = "Find a smaller server.",

        ConfigParagraph = "Folder: MirrorsHub\nFile: universal-config.json",
        SaveConfig = "Save Config",
        SaveConfigDesc = "Save universal-config.json.",
        LoadConfig = "Load Config",
        LoadConfigDesc = "Load universal-config.json.",
        ResetSession = "Reset Session",
        ResetSessionDesc = "Disable risky session features.",
        AutoLoadConfig = "Auto Load Config",
        AutoLoadConfigDesc = "Save auto load preference.",
        AutoLoadScript = "Auto Load Script",
        AutoLoadScriptDesc = "Save auto execute preference.",
        ToggleUIKey = "Toggle UI Key",
        ToggleUIKeyDesc = "Key to open/close the UI.",
        LanguageDropdown = "Interface Language",
        LanguageDropdownDesc = "Changes hub language. Re-execute to fully refresh labels.",
        SaveLanguage = "Save Language",
        SaveLanguageDesc = "Save the selected interface language.",

        ConfigSaved = "Config saved.",
        ConfigLoaded = "Config loaded.",
        SessionReset = "Session reset.",
        KeyChanged = "Toggle key changed to: ",
        LanguageSaved = "Language saved. Re-execute the hub to fully apply.",
        Loaded = "Loaded successfully.",

        SectionHitbox = "Hitbox Expander",
        EnableHitbox = "Enable Hitbox Expander",
        EnableHitboxDesc = "Expands selected character hitbox locally.",
        HitboxSize = "Hitbox Size",
        HitboxSizeDesc = "Size applied to the selected hitbox part.",
        HitboxTransparency = "Hitbox Transparency",
        HitboxTransparencyDesc = "Transparency of the expanded hitbox.",
        HitboxColor = "Hitbox Color",
        HitboxColorDesc = "Color of the expanded hitbox.",
        HitboxTeamCheck = "Hitbox Team Check",
        HitboxTeamCheckDesc = "Ignore players from your own team.",
        HitboxTargetPart = "Hitbox Target Part",
        HitboxTargetPartDesc = "Body part used as the expanded hitbox.",
        ResetHitboxes = "Reset Hitboxes",
        ResetHitboxesDesc = "Restores all modified hitboxes.",
        HitboxesReset = "Hitboxes reset.",

        ServerHopNotify = "Trying to switch server...",
        SmallServerNotify = "Searching for smaller server...",
        ServerSearchError = "Failed to fetch servers.",
        NoSmallServer = "No smaller server found."
    },

    Portuguese = {
        WindowTitle = "Mirrors Hub - Universal",
        OpenButton = "Abrir Mirrors Hub",

        TabScripts = "Scripts",
        TabAimbot = "Aimbot",
        TabESP = "ESP",
        TabTroll = "Troll",
        TabMisc = "Misc",
        TabConfig = "Config",

        SectionHome = "Início",
        SectionMain = "Principal",
        SectionFOV = "FOV",
        SectionTuning = "Ajustes",
        SectionInfo = "Informações",
        SectionVisual = "Visual",
        SectionComingSoon = "Em breve",
        SectionMovement = "Movimento",
        SectionUtility = "Utilidades",
        SectionConfigFile = "Arquivo de Config",
        SectionStartup = "Inicialização",
        SectionInterface = "Interface",
        SectionLanguage = "Idioma",

        HomeTitle = "Mirrors Hub",
        HomeDesc = "Hub universal de scripts.\nVersão: ",
        LoadScript = "Carregar Script",
        LoadScriptDesc = "Placeholder.",
        NoScriptConfigured = "Nenhum script configurado ainda.",

        EnableAimbot = "Ativar Aimbot",
        EnableAimbotDesc = "Liga ou desliga o assistente de mira.",
        TeamCheck = "Verificar Time",
        TeamCheckDesc = "Ignora jogadores do seu próprio time.",
        VisibleCheck = "Verificar Visibilidade",
        VisibleCheckDesc = "Mira apenas em jogadores visíveis.",
        TargetPart = "Parte do Alvo",
        TargetPartDesc = "Parte do corpo para mirar.",
        AimbotFOV = "FOV do Aimbot",
        AimbotFOVDesc = "Tamanho do raio do FOV.",
        ShowFOVCircle = "Mostrar Círculo FOV",
        ShowFOVCircleDesc = "Mostra o círculo do FOV.",
        FOVColor = "Cor do FOV",
        FOVColorDesc = "Cor do círculo do FOV.",
        Smoothness = "Suavidade",
        SmoothnessDesc = "Suavidade da mira.",
        AimStrength = "Força da Mira",
        AimStrengthDesc = "Força da puxada da mira.",
        TargetSwitchDelay = "Delay de Troca de Alvo",
        TargetSwitchDelayDesc = "Tempo antes de trocar de alvo.",

        EnableESP = "Ativar ESP",
        EnableESPDesc = "Liga ou desliga o ESP.",
        ESPColor = "Cor do ESP",
        ESPColorDesc = "Cor principal do ESP.",
        ShowNames = "Mostrar Nomes",
        ShowNamesDesc = "Mostra o nome dos jogadores.",
        ShowHealth = "Mostrar Vida",
        ShowHealthDesc = "Mostra a vida dos jogadores.",
        ShowDistance = "Mostrar Distância",
        ShowDistanceDesc = "Mostra a distância dos jogadores.",
        ShowLines = "Mostrar Linhas",
        ShowLinesDesc = "Desenha linhas do fundo da tela até os jogadores.",
        FillBox = "Preencher Box",
        FillBoxDesc = "Preenche o corpo com cor transparente.",
        FillTransparency = "Transparência do Fill",
        FillTransparencyDesc = "Transparência do preenchimento.",
        OutlineTransparency = "Transparência da Borda",
        OutlineTransparencyDesc = "Transparência da borda.",
        TextSize = "Tamanho do Texto",
        TextSizeDesc = "Tamanho do texto do ESP.",
        MaxDistance = "Distância Máxima",
        MaxDistanceDesc = "Distância máxima do ESP.",
        RefreshESP = "Atualizar ESP",
        RefreshESPDesc = "Recarrega os objetos do ESP.",
        ESPUpdated = "ESP atualizado.",

        TrollAction1 = "Ação Troll 1",
        TrollAction2 = "Ação Troll 2",
        Placeholder = "Placeholder.",
        NotConfigured = "Ainda não configurado.",

        WalkSpeed = "Velocidade",
        WalkSpeedDesc = "Velocidade de movimento.",
        JumpPower = "Força do Pulo",
        JumpPowerDesc = "Força do pulo.",
        Noclip = "Noclip",
        NoclipDesc = "Atravessar colisões.",
        InfiniteJump = "Pulo Infinito",
        InfiniteJumpDesc = "Permite pular infinitamente.",
        AntiAFK = "Anti AFK",
        AntiAFKDesc = "Evita ser removido por inatividade.",
        ResetCharacter = "Resetar Personagem",
        ResetCharacterDesc = "Reseta seu personagem.",
        RejoinServer = "Reconectar Servidor",
        RejoinServerDesc = "Reconecta no mesmo jogo.",
        ServerHop = "Trocar Servidor",
        ServerHopDesc = "Vai para outro servidor.",
        SmallServer = "Servidor Menor",
        SmallServerDesc = "Procura um servidor com menos jogadores.",

        ConfigParagraph = "Pasta: MirrorsHub\nArquivo: universal-config.json",
        SaveConfig = "Salvar Config",
        SaveConfigDesc = "Salva universal-config.json.",
        LoadConfig = "Carregar Config",
        LoadConfigDesc = "Carrega universal-config.json.",
        ResetSession = "Resetar Sessão",
        ResetSessionDesc = "Desliga funções arriscadas da sessão.",
        AutoLoadConfig = "Auto Carregar Config",
        AutoLoadConfigDesc = "Salva preferência de auto load.",
        AutoLoadScript = "Auto Carregar Script",
        AutoLoadScriptDesc = "Salva preferência de auto execução.",
        ToggleUIKey = "Tecla da UI",
        ToggleUIKeyDesc = "Tecla para abrir/fechar a interface.",
        LanguageDropdown = "Idioma da Interface",
        LanguageDropdownDesc = "Muda o idioma do hub. Reexecute para atualizar tudo.",
        SaveLanguage = "Salvar Idioma",
        SaveLanguageDesc = "Salva o idioma selecionado da interface.",

        ConfigSaved = "Config salva.",
        ConfigLoaded = "Config carregada.",
        SessionReset = "Sessão resetada.",
        KeyChanged = "Tecla da UI alterada para: ",
        LanguageSaved = "Idioma salvo. Reexecute o hub para aplicar tudo.",
        Loaded = "Carregado com sucesso.",

        SectionHitbox = "Expansor de Hitbox",
        EnableHitbox = "Ativar Expansor de Hitbox",
        EnableHitboxDesc = "Expande localmente a hitbox selecionada dos personagens.",
        HitboxSize = "Tamanho da Hitbox",
        HitboxSizeDesc = "Tamanho aplicado na parte selecionada.",
        HitboxTransparency = "Transparência da Hitbox",
        HitboxTransparencyDesc = "Transparência da hitbox expandida.",
        HitboxColor = "Cor da Hitbox",
        HitboxColorDesc = "Cor da hitbox expandida.",
        HitboxTeamCheck = "Verificar Time da Hitbox",
        HitboxTeamCheckDesc = "Ignora jogadores do seu próprio time.",
        HitboxTargetPart = "Parte da Hitbox",
        HitboxTargetPartDesc = "Parte do corpo usada como hitbox expandida.",
        ResetHitboxes = "Resetar Hitboxes",
        ResetHitboxesDesc = "Restaura todas as hitboxes modificadas.",
        HitboxesReset = "Hitboxes resetadas.",

        ServerHopNotify = "Tentando trocar de servidor...",
        SmallServerNotify = "Procurando servidor menor...",
        ServerSearchError = "Erro ao buscar servidores.",
        NoSmallServer = "Nenhum servidor menor encontrado."
    },

    Spanish = {
        WindowTitle = "Mirrors Hub - Universal",
        OpenButton = "Abrir Mirrors Hub",

        TabScripts = "Scripts",
        TabAimbot = "Aimbot",
        TabESP = "ESP",
        TabTroll = "Troll",
        TabMisc = "Misc",
        TabConfig = "Config",

        SectionHome = "Inicio",
        SectionMain = "Principal",
        SectionFOV = "FOV",
        SectionTuning = "Ajustes",
        SectionInfo = "Información",
        SectionVisual = "Visual",
        SectionComingSoon = "Próximamente",
        SectionMovement = "Movimiento",
        SectionUtility = "Utilidad",
        SectionConfigFile = "Archivo de Config",
        SectionStartup = "Inicio",
        SectionInterface = "Interfaz",
        SectionLanguage = "Idioma",

        HomeTitle = "Mirrors Hub",
        HomeDesc = "Hub universal de scripts.\nVersión: ",
        LoadScript = "Cargar Script",
        LoadScriptDesc = "Placeholder.",
        NoScriptConfigured = "No hay script configurado todavía.",

        EnableAimbot = "Activar Aimbot",
        EnableAimbotDesc = "Activa o desactiva la asistencia de mira.",
        TeamCheck = "Verificar Equipo",
        TeamCheckDesc = "Ignora jugadores de tu equipo.",
        VisibleCheck = "Verificar Visibilidad",
        VisibleCheckDesc = "Solo apunta a jugadores visibles.",
        TargetPart = "Parte del Objetivo",
        TargetPartDesc = "Parte del cuerpo para apuntar.",
        AimbotFOV = "FOV del Aimbot",
        AimbotFOVDesc = "Tamaño del radio del FOV.",
        ShowFOVCircle = "Mostrar Círculo FOV",
        ShowFOVCircleDesc = "Muestra el círculo del FOV.",
        FOVColor = "Color del FOV",
        FOVColorDesc = "Color del círculo FOV.",
        Smoothness = "Suavidad",
        SmoothnessDesc = "Suavidad de la mira.",
        AimStrength = "Fuerza de Mira",
        AimStrengthDesc = "Fuerza de arrastre de la mira.",
        TargetSwitchDelay = "Delay de Cambio de Objetivo",
        TargetSwitchDelayDesc = "Tiempo antes de cambiar objetivo.",

        EnableESP = "Activar ESP",
        EnableESPDesc = "Activa o desactiva el ESP.",
        ESPColor = "Color del ESP",
        ESPColorDesc = "Color principal del ESP.",
        ShowNames = "Mostrar Nombres",
        ShowNamesDesc = "Muestra nombres de jugadores.",
        ShowHealth = "Mostrar Vida",
        ShowHealthDesc = "Muestra la vida de jugadores.",
        ShowDistance = "Mostrar Distancia",
        ShowDistanceDesc = "Muestra la distancia de jugadores.",
        ShowLines = "Mostrar Líneas",
        ShowLinesDesc = "Dibuja líneas desde abajo de la pantalla.",
        FillBox = "Rellenar Box",
        FillBoxDesc = "Rellena el cuerpo con color transparente.",
        FillTransparency = "Transparencia del Relleno",
        FillTransparencyDesc = "Transparencia del relleno.",
        OutlineTransparency = "Transparencia del Borde",
        OutlineTransparencyDesc = "Transparencia del borde.",
        TextSize = "Tamaño del Texto",
        TextSizeDesc = "Tamaño del texto del ESP.",
        MaxDistance = "Distancia Máxima",
        MaxDistanceDesc = "Distancia máxima del ESP.",
        RefreshESP = "Actualizar ESP",
        RefreshESPDesc = "Recarga objetos del ESP.",
        ESPUpdated = "ESP actualizado.",

        TrollAction1 = "Acción Troll 1",
        TrollAction2 = "Acción Troll 2",
        Placeholder = "Placeholder.",
        NotConfigured = "Todavía no configurado.",

        WalkSpeed = "Velocidad",
        WalkSpeedDesc = "Velocidad de movimiento.",
        JumpPower = "Poder de Salto",
        JumpPowerDesc = "Fuerza del salto.",
        Noclip = "Noclip",
        NoclipDesc = "Atravesar colisiones.",
        InfiniteJump = "Salto Infinito",
        InfiniteJumpDesc = "Permite saltar infinitamente.",
        AntiAFK = "Anti AFK",
        AntiAFKDesc = "Evita expulsión por inactividad.",
        ResetCharacter = "Resetear Personaje",
        ResetCharacterDesc = "Resetea tu personaje.",
        RejoinServer = "Reconectar Servidor",
        RejoinServerDesc = "Reconecta al mismo juego.",
        ServerHop = "Cambiar Servidor",
        ServerHopDesc = "Va a otro servidor.",
        SmallServer = "Servidor Pequeño",
        SmallServerDesc = "Busca un servidor con menos jugadores.",

        ConfigParagraph = "Carpeta: MirrorsHub\nArchivo: universal-config.json",
        SaveConfig = "Guardar Config",
        SaveConfigDesc = "Guarda universal-config.json.",
        LoadConfig = "Cargar Config",
        LoadConfigDesc = "Carga universal-config.json.",
        ResetSession = "Resetear Sesión",
        ResetSessionDesc = "Desactiva funciones arriesgadas de la sesión.",
        AutoLoadConfig = "Auto Cargar Config",
        AutoLoadConfigDesc = "Guarda preferencia de auto load.",
        AutoLoadScript = "Auto Cargar Script",
        AutoLoadScriptDesc = "Guarda preferencia de auto ejecución.",
        ToggleUIKey = "Tecla de UI",
        ToggleUIKeyDesc = "Tecla para abrir/cerrar la interfaz.",
        LanguageDropdown = "Idioma de Interfaz",
        LanguageDropdownDesc = "Cambia el idioma del hub. Reejecuta para actualizar todo.",
        SaveLanguage = "Guardar Idioma",
        SaveLanguageDesc = "Guarda el idioma seleccionado.",

        ConfigSaved = "Config guardada.",
        ConfigLoaded = "Config cargada.",
        SessionReset = "Sesión reseteada.",
        KeyChanged = "Tecla de UI cambiada a: ",
        LanguageSaved = "Idioma guardado. Reejecuta el hub para aplicar todo.",
        Loaded = "Cargado con éxito.",

        SectionHitbox = "Expansor de Hitbox",
        EnableHitbox = "Activar Expansor de Hitbox",
        EnableHitboxDesc = "Expande localmente la hitbox seleccionada.",
        HitboxSize = "Tamaño de Hitbox",
        HitboxSizeDesc = "Tamaño aplicado a la parte seleccionada.",
        HitboxTransparency = "Transparencia de Hitbox",
        HitboxTransparencyDesc = "Transparencia de la hitbox expandida.",
        HitboxColor = "Color de Hitbox",
        HitboxColorDesc = "Color de la hitbox expandida.",
        HitboxTeamCheck = "Verificar Equipo de Hitbox",
        HitboxTeamCheckDesc = "Ignora jugadores de tu equipo.",
        HitboxTargetPart = "Parte de Hitbox",
        HitboxTargetPartDesc = "Parte del cuerpo usada como hitbox expandida.",
        ResetHitboxes = "Resetear Hitboxes",
        ResetHitboxesDesc = "Restaura todas las hitboxes modificadas.",
        HitboxesReset = "Hitboxes reseteadas.",

        ServerHopNotify = "Intentando cambiar servidor...",
        SmallServerNotify = "Buscando servidor pequeño...",
        ServerSearchError = "Error al buscar servidores.",
        NoSmallServer = "No se encontró servidor menor."
    }
}

local function LoadLanguage()
    if readfile and isfile and isfile(LANGUAGE_FILE) then
        local ok, data = pcall(function()
            return HttpService:JSONDecode(readfile(LANGUAGE_FILE))
        end)

        if ok and data and data.Language and Languages[data.Language] then
            CurrentLanguage = data.Language
        end
    end
end

local function SaveLanguage(language)
    if not Languages[language] then return end
    CurrentLanguage = language
    EnsureFolder()

    if writefile then
        pcall(function()
            writefile(LANGUAGE_FILE, HttpService:JSONEncode({
                Language = CurrentLanguage
            }))
        end)
    end
end

local function L(key)
    local selected = Languages[CurrentLanguage] or Languages.English
    local fallback = Languages.English

    return selected[key] or fallback[key] or key
end

LoadLanguage()

--// CONFIG TABLES
local AimConfig = {
    Enabled = false,
    FOV = 140,
    Smoothness = 0.09,
    Strength = 1,
    TargetPart = "Head",
    TargetSwitchDelay = 0.25,
    TeamCheck = false,
    VisibleCheck = false,
    FOVVisible = true,
    FOVColor = Color3.fromRGB(134, 0, 212)
}

local ESPConfig = {
    Enabled = false,
    Color = Color3.fromRGB(0, 255, 255),
    ShowNames = false,
    ShowHealth = false,
    ShowDistance = false,
    ShowLines = false,
    TeamCheck = false,
    FillEnabled = false,
    FillTransparency = 0.75,
    OutlineTransparency = 0,
    TextSize = 13,
    MaxDistance = 5000
}

local MiscConfig = {
    WalkSpeed = 16,
    JumpPower = 50,
    Noclip = false,
    InfiniteJump = false,
    AntiAFK = false
}

local HitboxConfig = {
    Enabled = false,
    Size = 10,
    Transparency = 0.65,
    Color = Color3.fromRGB(134, 0, 212),
    TeamCheck = false,
    TargetPart = "HumanoidRootPart"
}

--// LOAD WINDUI
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

WindUI:AddTheme({
    Name = "Mirrors Purple",
    Accent = Color3.fromHex("#1C002E"),
    Background = Color3.fromHex("#101010"),
    Outline = Color3.fromHex("#8600D4"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#8a8a8a"),
    Button = Color3.fromHex("#2A0145"),
    Icon = Color3.fromHex("#C084FC"),
})

local NotificationsEnabled = true

local function Notify(content, icon, duration)
    if not NotificationsEnabled then return end

    pcall(function()
        WindUI:Notify({
            Title = HUB_NAME,
            Content = content,
            Duration = duration or 3,
            Icon = icon or "bell",
        })
    end)
end

--// WINDOW
local Window = WindUI:CreateWindow({
    Title = L("WindowTitle"),
    Icon = "door-open",
    Author = "by blackzw.mp3",
    Folder = HUB_FOLDER,

    Size = UDim2.fromOffset(580, 460),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),

    ToggleKey = Enum.KeyCode.H,
    Transparent = true,
    Theme = "Mirrors Purple",
    Resizable = false,
    SideBarWidth = 200,
    BackgroundImageTransparency = 0.42,
    HideSearchBar = false,
    ScrollBarEnabled = true,

    User = {
        Enabled = true,
        Anonymous = false,
    },
})

Window:EditOpenButton({
    Title = L("OpenButton"),
    Icon = "monitor",
    CornerRadius = UDim.new(0, 16),
    StrokeThickness = 2,
    Color = ColorSequence.new(
        Color3.fromHex("8600D4"),
        Color3.fromHex("1C002E")
    ),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

--// CONFIG MANAGER NATIVO
local ConfigManager = Window.ConfigManager
local UniversalConfig = ConfigManager:CreateConfig("universal-config")

--// TABS
local Scripts = Window:Tab({ Title = L("TabScripts"), Icon = "house" })
local Aimbot = Window:Tab({ Title = L("TabAimbot"), Icon = "crosshair" })
local Esp = Window:Tab({ Title = L("TabESP"), Icon = "eye" })
local Troll = Window:Tab({ Title = L("TabTroll"), Icon = "laugh" })
local Misc = Window:Tab({ Title = L("TabMisc"), Icon = "circle-ellipsis" })
local Config = Window:Tab({ Title = L("TabConfig"), Icon = "cog" })

local OP = Window:Tab({
    Title = "OP",
    Icon = "flame",
    Locked = not IsOPAuthorized
})

--// DRAWING SETUP
local HasDrawing = Drawing and Drawing.new
local FOVCircle = nil

if HasDrawing then
    FOVCircle = Drawing.new("Circle")
    FOVCircle.Thickness = 1
    FOVCircle.NumSides = 64
    FOVCircle.Radius = AimConfig.FOV
    FOVCircle.Filled = false
    FOVCircle.Visible = AimConfig.FOVVisible
    FOVCircle.Color = AimConfig.FOVColor
end

--// BASIC HELPERS
local function GetChar()
    return LocalPlayer.Character
end

local function GetHumanoid()
    local char = GetChar()
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function GetScreenCenter()
    Camera = workspace.CurrentCamera
    return Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end

--// ==========================================================
--// AIMBOT
--// ==========================================================

local CurrentTarget = nil
local LastSwitch = 0

local function IsPlayerVisible(targetPart)
    if not AimConfig.VisibleCheck then return true end
    if not targetPart then return false end

    local character = targetPart.Parent
    if not character then return false end

    local origin = Camera.CFrame.Position
    local direction = targetPart.Position - origin

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = { LocalPlayer.Character, Camera }
    params.IgnoreWater = true

    local result = workspace:Raycast(origin, direction, params)

    return result and result.Instance and result.Instance:IsDescendantOf(character)
end

local function IsValidTarget(part)
    if not part or not part.Parent then return false end

    local character = part.Parent
    local player = Players:GetPlayerFromCharacter(character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if not humanoid or humanoid.Health <= 0 then return false end

    if AimConfig.TeamCheck and player and player.Team == LocalPlayer.Team then
        return false
    end

    if not IsPlayerVisible(part) then return false end

    local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
    if not onScreen then return false end

    local dist = (Vector2.new(screenPos.X, screenPos.Y) - GetScreenCenter()).Magnitude
    return dist <= AimConfig.FOV
end

local function GetClosestTarget()
    local closest = nil
    local shortest = AimConfig.FOV

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local part = char and char:FindFirstChild(AimConfig.TargetPart)

            if hum and hum.Health > 0 and part then
                if AimConfig.TeamCheck and player.Team == LocalPlayer.Team then
                    continue
                end

                if not IsPlayerVisible(part) then
                    continue
                end

                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)

                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - GetScreenCenter()).Magnitude

                    if dist < shortest then
                        shortest = dist
                        closest = part
                    end
                end
            end
        end
    end

    return closest
end

local function UpdateAimbot()
    if not AimConfig.Enabled then
        CurrentTarget = nil
        return
    end

    if not IsValidTarget(CurrentTarget) then
        if tick() - LastSwitch >= AimConfig.TargetSwitchDelay then
            CurrentTarget = GetClosestTarget()
            LastSwitch = tick()
        end
    end

    if CurrentTarget and IsValidTarget(CurrentTarget) then
        local camPos = Camera.CFrame.Position
        local targetCFrame = CFrame.new(camPos, CurrentTarget.Position)
        local smoothCFrame = Camera.CFrame:Lerp(targetCFrame, AimConfig.Smoothness)

        Camera.CFrame = Camera.CFrame:Lerp(smoothCFrame, AimConfig.Strength)
    end
end

--// ==========================================================
--// ESP
--// ==========================================================

local ESPObjects = {}

local function RemoveESP(player)
    local data = ESPObjects[player]
    if not data then return end

    for _, obj in pairs(data) do
        if typeof(obj) == "Instance" then
            obj:Destroy()
        elseif obj and obj.Remove then
            pcall(function()
                obj:Remove()
            end)
        end
    end

    ESPObjects[player] = nil
end

local function IsESPValid(player)
    if player == LocalPlayer then return false end

    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")

    if not char or not hum or not root then return false end
    if hum.Health <= 0 then return false end

    if ESPConfig.TeamCheck and player.Team == LocalPlayer.Team then
        return false
    end

    local dist = (Camera.CFrame.Position - root.Position).Magnitude
    return dist <= ESPConfig.MaxDistance
end

local function CreateESP(player)
    RemoveESP(player)

    if not ESPConfig.Enabled then return end
    if not IsESPValid(player) then return end

    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not char or not root then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "MirrorsESP_Highlight"
    highlight.Adornee = char
    highlight.FillColor = ESPConfig.Color
    highlight.OutlineColor = ESPConfig.Color
    highlight.FillTransparency = ESPConfig.FillEnabled and ESPConfig.FillTransparency or 1
    highlight.OutlineTransparency = ESPConfig.OutlineTransparency
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = char

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "MirrorsESP_Info"
    billboard.Adornee = root
    billboard.Size = UDim2.new(0, 220, 0, 80)
    billboard.StudsOffset = Vector3.new(0, 3.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Enabled = true
    billboard.Parent = root

    local text = Instance.new("TextLabel")
    text.Name = "InfoText"
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.TextColor3 = ESPConfig.Color
    text.TextStrokeTransparency = 0
    text.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    text.TextSize = ESPConfig.TextSize
    text.Font = Enum.Font.GothamBold
    text.TextYAlignment = Enum.TextYAlignment.Center
    text.Text = ""
    text.Parent = billboard

    local line = nil

    if HasDrawing then
        line = Drawing.new("Line")
        line.Visible = false
        line.Color = ESPConfig.Color
        line.Thickness = 1.5
        line.Transparency = 1
    end

    ESPObjects[player] = {
        Highlight = highlight,
        Billboard = billboard,
        Text = text,
        Line = line
    }
end

local function RefreshESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            CreateESP(player)
        end
    end
end

local function ClearESP()
    for player in pairs(ESPObjects) do
        RemoveESP(player)
    end
end

local function UpdateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if ESPConfig.Enabled and IsESPValid(player) then
                if not ESPObjects[player] then
                    CreateESP(player)
                end

                local data = ESPObjects[player]
                local char = player.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local root = char and char:FindFirstChild("HumanoidRootPart")

                if data and hum and root then
                    data.Highlight.FillColor = ESPConfig.Color
                    data.Highlight.OutlineColor = ESPConfig.Color
                    data.Highlight.FillTransparency = ESPConfig.FillEnabled and ESPConfig.FillTransparency or 1
                    data.Highlight.OutlineTransparency = ESPConfig.OutlineTransparency

                    data.Text.TextColor3 = ESPConfig.Color
                    data.Text.TextSize = ESPConfig.TextSize

                    local lines = {}
                    local dist = math.floor((Camera.CFrame.Position - root.Position).Magnitude)

                    if ESPConfig.ShowNames then
                        table.insert(lines, player.Name)
                    end

                    if ESPConfig.ShowHealth then
                        table.insert(lines, "HP: " .. math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth))
                    end

                    if ESPConfig.ShowDistance then
                        table.insert(lines, dist .. " studs")
                    end

                    data.Text.Text = table.concat(lines, "\n")
                    data.Billboard.Enabled = #lines > 0

                    if data.Line then
                        local pos, onScreen = Camera:WorldToViewportPoint(root.Position)

                        if ESPConfig.ShowLines and onScreen then
                            data.Line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                            data.Line.To = Vector2.new(pos.X, pos.Y)
                            data.Line.Color = ESPConfig.Color
                            data.Line.Visible = true
                        else
                            data.Line.Visible = false
                        end
                    end
                end
            else
                RemoveESP(player)
            end
        end
    end
end

--// ==========================================================
--// MISC
--// ==========================================================

local function ApplyMovement()
    local hum = GetHumanoid()

    if hum then
        hum.WalkSpeed = MiscConfig.WalkSpeed
        hum.JumpPower = MiscConfig.JumpPower
        hum.UseJumpPower = true
    end
end

local function ApplyNoclip()
    if not MiscConfig.Noclip then return end

    local char = GetChar()
    if not char then return end

    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

local function ServerHop()
    Notify(L("ServerHopNotify"), "server", 3)
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end

local function SmallServer()
    Notify(L("SmallServerNotify"), "search", 3)

    local success, servers = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(
            "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        ))
    end)

    if not success or not servers or not servers.data then
        Notify(L("ServerSearchError"), "triangle-alert", 3)
        return
    end

    local best = nil

    for _, server in ipairs(servers.data) do
        if server.id ~= game.JobId and server.playing < server.maxPlayers then
            if not best or server.playing < best.playing then
                best = server
            end
        end
    end

    if best then
        TeleportService:TeleportToPlaceInstance(game.PlaceId, best.id, LocalPlayer)
    else
        Notify(L("NoSmallServer"), "x", 3)
    end
end


--// ==========================================================
--// HITBOX EXPANDER
--// ==========================================================

local OriginalHitboxes = {}

local function IsHitboxPlayerValid(player)
    if player == LocalPlayer then return false end
    if not player.Character then return false end

    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end

    if HitboxConfig.TeamCheck and player.Team == LocalPlayer.Team then
        return false
    end

    return true
end

local function SaveOriginalHitbox(part)
    if not part or OriginalHitboxes[part] then return end

    OriginalHitboxes[part] = {
        Size = part.Size,
        Transparency = part.Transparency,
        Color = part.Color,
        Material = part.Material,
        CanCollide = part.CanCollide
    }
end

local function ApplyHitbox(player)
    if not HitboxConfig.Enabled then return end
    if not IsHitboxPlayerValid(player) then return end

    local char = player.Character
    local part = char and char:FindFirstChild(HitboxConfig.TargetPart)

    if not part or not part:IsA("BasePart") then return end

    SaveOriginalHitbox(part)

    part.Size = Vector3.new(HitboxConfig.Size, HitboxConfig.Size, HitboxConfig.Size)
    part.Transparency = HitboxConfig.Transparency
    part.Color = HitboxConfig.Color
    part.Material = Enum.Material.Neon
    part.CanCollide = false
end

local function ResetHitboxPart(part)
    local original = OriginalHitboxes[part]
    if not original or not part then return end

    pcall(function()
        part.Size = original.Size
        part.Transparency = original.Transparency
        part.Color = original.Color
        part.Material = original.Material
        part.CanCollide = original.CanCollide
    end)

    OriginalHitboxes[part] = nil
end

local function ResetAllHitboxes()
    for part in pairs(OriginalHitboxes) do
        ResetHitboxPart(part)
    end
end

local function UpdateHitboxes()
    if not HitboxConfig.Enabled then return end

    for _, player in ipairs(Players:GetPlayers()) do
        ApplyHitbox(player)
    end
end

--// ==========================================================
--// UI - SCRIPTS
--// ==========================================================

Scripts:Section({ Title = L("SectionHome"), Box = false, TextSize = 17 })

Scripts:Paragraph({
    Title = L("HomeTitle"),
    Desc = L("HomeDesc") .. HUB_VERSION,
    Color = "Blue",
    Locked = false,
})

Scripts:Button({
    Title = L("LoadScript"),
    Desc = L("LoadScriptDesc"),
    Locked = false,
    Callback = function()
        Notify(L("NoScriptConfigured"), "info", 3)
    end
})

--// ==========================================================
--// UI - AIMBOT
--// ==========================================================

Aimbot:Section({ Title = L("SectionMain"), Box = false, TextSize = 17 })

Aimbot:Toggle({
    Title = L("EnableAimbot"),
    Desc = L("EnableAimbotDesc"),
    Flag = "AimbotEnabled",
    Type = "Checkbox",
    Value = AimConfig.Enabled,
    Callback = function(v)
        AimConfig.Enabled = v
        if not v then CurrentTarget = nil end
    end
})

Aimbot:Toggle({
    Title = L("TeamCheck"),
    Desc = L("TeamCheckDesc"),
    Flag = "AimbotTeamCheck",
    Type = "Checkbox",
    Value = AimConfig.TeamCheck,
    Callback = function(v)
        AimConfig.TeamCheck = v
        CurrentTarget = nil
    end
})

Aimbot:Toggle({
    Title = L("VisibleCheck"),
    Desc = L("VisibleCheckDesc"),
    Flag = "AimbotVisibleCheck",
    Type = "Checkbox",
    Value = AimConfig.VisibleCheck,
    Callback = function(v)
        AimConfig.VisibleCheck = v
        CurrentTarget = nil
    end
})

Aimbot:Dropdown({
    Title = L("TargetPart"),
    Desc = L("TargetPartDesc"),
    Flag = "AimbotTargetPart",
    Values = { "Head", "HumanoidRootPart" },
    Value = AimConfig.TargetPart,
    Callback = function(v)
        AimConfig.TargetPart = v
        CurrentTarget = nil
    end
})

Aimbot:Section({ Title = L("SectionFOV"), Box = false, TextSize = 17 })

Aimbot:Slider({
    Title = L("AimbotFOV"),
    Desc = L("AimbotFOVDesc"),
    Flag = "AimbotFOV",
    Step = 1,
    Value = { Min = 10, Max = 500, Default = AimConfig.FOV },
    Callback = function(v)
        AimConfig.FOV = v
        if FOVCircle then FOVCircle.Radius = v end
    end
})

Aimbot:Toggle({
    Title = L("ShowFOVCircle"),
    Desc = L("ShowFOVCircleDesc"),
    Flag = "AimbotFOVVisible",
    Type = "Checkbox",
    Value = AimConfig.FOVVisible,
    Callback = function(v)
        AimConfig.FOVVisible = v
        if FOVCircle then FOVCircle.Visible = v end
    end
})

Aimbot:Colorpicker({
    Title = L("FOVColor"),
    Desc = L("FOVColorDesc"),
    Flag = "AimbotFOVColor",
    Default = AimConfig.FOVColor,
    Transparency = 0,
    Locked = false,
    Callback = function(v)
        AimConfig.FOVColor = v
        if FOVCircle then FOVCircle.Color = v end
    end
})

Aimbot:Section({ Title = L("SectionTuning"), Box = false, TextSize = 17 })

Aimbot:Slider({
    Title = L("Smoothness"),
    Desc = L("SmoothnessDesc"),
    Flag = "AimbotSmoothness",
    Step = 1,
    Value = { Min = 1, Max = 100, Default = 35 },
    Callback = function(v)
        AimConfig.Smoothness = v / 388
    end
})

Aimbot:Slider({
    Title = L("AimStrength"),
    Desc = L("AimStrengthDesc"),
    Flag = "AimbotStrength",
    Step = 1,
    Value = { Min = 1, Max = 100, Default = 100 },
    Callback = function(v)
        AimConfig.Strength = v / 100
    end
})

Aimbot:Slider({
    Title = L("TargetSwitchDelay"),
    Desc = L("TargetSwitchDelayDesc"),
    Flag = "AimbotSwitchDelay",
    Step = 0.05,
    Value = { Min = 0, Max = 2, Default = AimConfig.TargetSwitchDelay },
    Callback = function(v)
        AimConfig.TargetSwitchDelay = v
    end
})

--// ==========================================================
--// UI - ESP
--// ==========================================================

Esp:Section({ Title = L("SectionMain"), Box = false, TextSize = 17 })

Esp:Toggle({
    Title = L("EnableESP"),
    Desc = L("EnableESPDesc"),
    Flag = "ESPEnabled",
    Type = "Checkbox",
    Value = ESPConfig.Enabled,
    Callback = function(v)
        ESPConfig.Enabled = v
        if v then RefreshESP() else ClearESP() end
    end
})

Esp:Colorpicker({
    Title = L("ESPColor"),
    Desc = L("ESPColorDesc"),
    Flag = "ESPColor",
    Default = ESPConfig.Color,
    Transparency = 0,
    Locked = false,
    Callback = function(v)
        ESPConfig.Color = v
    end
})

Esp:Toggle({
    Title = L("TeamCheck"),
    Desc = L("TeamCheckDesc"),
    Flag = "ESPTeamCheck",
    Type = "Checkbox",
    Value = ESPConfig.TeamCheck,
    Callback = function(v)
        ESPConfig.TeamCheck = v
        RefreshESP()
    end
})

Esp:Section({ Title = L("SectionInfo"), Box = false, TextSize = 17 })

Esp:Toggle({
    Title = L("ShowNames"),
    Desc = L("ShowNamesDesc"),
    Flag = "ESPShowNames",
    Type = "Checkbox",
    Value = ESPConfig.ShowNames,
    Callback = function(v)
        ESPConfig.ShowNames = v
    end
})

Esp:Toggle({
    Title = L("ShowHealth"),
    Desc = L("ShowHealthDesc"),
    Flag = "ESPShowHealth",
    Type = "Checkbox",
    Value = ESPConfig.ShowHealth,
    Callback = function(v)
        ESPConfig.ShowHealth = v
    end
})

Esp:Toggle({
    Title = L("ShowDistance"),
    Desc = L("ShowDistanceDesc"),
    Flag = "ESPShowDistance",
    Type = "Checkbox",
    Value = ESPConfig.ShowDistance,
    Callback = function(v)
        ESPConfig.ShowDistance = v
    end
})

Esp:Toggle({
    Title = L("ShowLines"),
    Desc = L("ShowLinesDesc"),
    Flag = "ESPShowLines",
    Type = "Checkbox",
    Value = ESPConfig.ShowLines,
    Callback = function(v)
        ESPConfig.ShowLines = v
    end
})

Esp:Section({ Title = L("SectionVisual"), Box = false, TextSize = 17 })

Esp:Toggle({
    Title = L("FillBox"),
    Desc = L("FillBoxDesc"),
    Flag = "ESPFill",
    Type = "Checkbox",
    Value = ESPConfig.FillEnabled,
    Callback = function(v)
        ESPConfig.FillEnabled = v
    end
})

Esp:Slider({
    Title = L("FillTransparency"),
    Desc = L("FillTransparencyDesc"),
    Flag = "ESPFillTransparency",
    Step = 1,
    Value = { Min = 0, Max = 100, Default = 75 },
    Callback = function(v)
        ESPConfig.FillTransparency = v / 100
    end
})

Esp:Slider({
    Title = L("OutlineTransparency"),
    Desc = L("OutlineTransparencyDesc"),
    Flag = "ESPOutlineTransparency",
    Step = 1,
    Value = { Min = 0, Max = 100, Default = 0 },
    Callback = function(v)
        ESPConfig.OutlineTransparency = v / 100
    end
})

Esp:Slider({
    Title = L("TextSize"),
    Desc = L("TextSizeDesc"),
    Flag = "ESPTextSize",
    Step = 1,
    Value = { Min = 8, Max = 30, Default = ESPConfig.TextSize },
    Callback = function(v)
        ESPConfig.TextSize = v
    end
})

Esp:Slider({
    Title = L("MaxDistance"),
    Desc = L("MaxDistanceDesc"),
    Flag = "ESPMaxDistance",
    Step = 50,
    Value = { Min = 100, Max = 10000, Default = ESPConfig.MaxDistance },
    Callback = function(v)
        ESPConfig.MaxDistance = v
    end
})

Esp:Button({
    Title = L("RefreshESP"),
    Desc = L("RefreshESPDesc"),
    Locked = false,
    Callback = function()
        RefreshESP()
        Notify(L("ESPUpdated"), "refresh-cw", 2)
    end
})

--// ==========================================================
--// UI - TROLL
--// ==========================================================

Troll:Section({ Title = L("SectionComingSoon"), Box = false, TextSize = 17 })

Troll:Button({
    Title = L("TrollAction1"),
    Desc = L("Placeholder"),
    Locked = false,
    Callback = function()
        Notify(L("NotConfigured"), "info", 2)
    end
})

Troll:Button({
    Title = L("TrollAction2"),
    Desc = L("Placeholder"),
    Locked = false,
    Callback = function()
        Notify(L("NotConfigured"), "info", 2)
    end
})

--// ==========================================================
--// UI - MISC
--// ==========================================================

Misc:Section({ Title = L("SectionMovement"), Box = false, TextSize = 17 })

Misc:Slider({
    Title = L("WalkSpeed"),
    Desc = L("WalkSpeedDesc"),
    Flag = "MiscWalkSpeed",
    Step = 1,
    Value = { Min = 16, Max = 200, Default = MiscConfig.WalkSpeed },
    Callback = function(v)
        MiscConfig.WalkSpeed = v
        ApplyMovement()
    end
})

Misc:Slider({
    Title = L("JumpPower"),
    Desc = L("JumpPowerDesc"),
    Flag = "MiscJumpPower",
    Step = 1,
    Value = { Min = 50, Max = 300, Default = MiscConfig.JumpPower },
    Callback = function(v)
        MiscConfig.JumpPower = v
        ApplyMovement()
    end
})

Misc:Toggle({
    Title = L("Noclip"),
    Desc = L("NoclipDesc"),
    Flag = "MiscNoclip",
    Type = "Checkbox",
    Value = MiscConfig.Noclip,
    Callback = function(v)
        MiscConfig.Noclip = v
    end
})

Misc:Toggle({
    Title = L("InfiniteJump"),
    Desc = L("InfiniteJumpDesc"),
    Flag = "MiscInfiniteJump",
    Type = "Checkbox",
    Value = MiscConfig.InfiniteJump,
    Callback = function(v)
        MiscConfig.InfiniteJump = v
    end
})

Misc:Section({ Title = L("SectionUtility"), Box = false, TextSize = 17 })

Misc:Toggle({
    Title = L("AntiAFK"),
    Desc = L("AntiAFKDesc"),
    Flag = "MiscAntiAFK",
    Type = "Checkbox",
    Value = MiscConfig.AntiAFK,
    Callback = function(v)
        MiscConfig.AntiAFK = v
    end
})

Misc:Button({
    Title = L("ResetCharacter"),
    Desc = L("ResetCharacterDesc"),
    Locked = false,
    Callback = function()
        local hum = GetHumanoid()
        if hum then hum.Health = 0 end
    end
})

Misc:Button({
    Title = L("RejoinServer"),
    Desc = L("RejoinServerDesc"),
    Locked = false,
    Callback = function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
})

Misc:Button({
    Title = L("ServerHop"),
    Desc = L("ServerHopDesc"),
    Locked = false,
    Callback = ServerHop
})

Misc:Button({
    Title = L("SmallServer"),
    Desc = L("SmallServerDesc"),
    Locked = false,
    Callback = SmallServer
})

Misc:Section({ Title = L("SectionHitbox"), Box = false, TextSize = 17 })

Misc:Toggle({
    Title = L("EnableHitbox"),
    Desc = L("EnableHitboxDesc"),
    Flag = "HitboxEnabled",
    Type = "Checkbox",
    Value = HitboxConfig.Enabled,
    Callback = function(v)
        HitboxConfig.Enabled = v

        if not v then
            ResetAllHitboxes()
        else
            UpdateHitboxes()
        end
    end
})

Misc:Dropdown({
    Title = L("HitboxTargetPart"),
    Desc = L("HitboxTargetPartDesc"),
    Flag = "HitboxTargetPart",
    Values = { "HumanoidRootPart", "Head", "UpperTorso", "Torso" },
    Value = HitboxConfig.TargetPart,
    Callback = function(v)
        ResetAllHitboxes()
        HitboxConfig.TargetPart = v
        UpdateHitboxes()
    end
})

Misc:Slider({
    Title = L("HitboxSize"),
    Desc = L("HitboxSizeDesc"),
    Flag = "HitboxSize",
    Step = 1,
    Value = {
        Min = 2,
        Max = 50,
        Default = HitboxConfig.Size
    },
    Callback = function(v)
        HitboxConfig.Size = v
        UpdateHitboxes()
    end
})

Misc:Slider({
    Title = L("HitboxTransparency"),
    Desc = L("HitboxTransparencyDesc"),
    Flag = "HitboxTransparency",
    Step = 1,
    Value = {
        Min = 0,
        Max = 100,
        Default = math.floor(HitboxConfig.Transparency * 100)
    },
    Callback = function(v)
        HitboxConfig.Transparency = v / 100
        UpdateHitboxes()
    end
})

Misc:Colorpicker({
    Title = L("HitboxColor"),
    Desc = L("HitboxColorDesc"),
    Flag = "HitboxColor",
    Default = HitboxConfig.Color,
    Transparency = 0,
    Locked = false,
    Callback = function(v)
        HitboxConfig.Color = v
        UpdateHitboxes()
    end
})

Misc:Toggle({
    Title = L("HitboxTeamCheck"),
    Desc = L("HitboxTeamCheckDesc"),
    Flag = "HitboxTeamCheck",
    Type = "Checkbox",
    Value = HitboxConfig.TeamCheck,
    Callback = function(v)
        HitboxConfig.TeamCheck = v
        ResetAllHitboxes()
        UpdateHitboxes()
    end
})

Misc:Button({
    Title = L("ResetHitboxes"),
    Desc = L("ResetHitboxesDesc"),
    Locked = false,
    Callback = function()
        ResetAllHitboxes()
        Notify(L("HitboxesReset"), "rotate-ccw", 3)
    end
})


--// ==========================================================
--// UI - OP
--// ==========================================================

if IsOPAuthorized then
    OP:Section({
        Title = "Private Access",
        Box = false,
        TextSize = 17
    })

    OP:Paragraph({
        Title = "OP Mode",
        Desc = "Private functions for authorized users only.",
        Color = "Red",
        Locked = false
    })

    OP:Button({
        Title = "Test OP Access",
        Desc = "Checks if the OP tab is unlocked.",
        Locked = false,
        Callback = function()
            Notify("OP access confirmed.", "flame", 3)
        end
    })

    OP:Section({
        Title = "OP Functions",
        Box = false,
        TextSize = 17
    })

    OP:Button({
        Title = "Placeholder OP Function",
        Desc = "Coloque aqui sua função OP depois.",
        Locked = false,
        Callback = function()
            Notify("OP function placeholder.", "zap", 3)
        end
    })
end

--// ==========================================================
--// UI - CONFIG
--// ==========================================================

Config:Section({ Title = L("SectionConfigFile"), Box = false, TextSize = 17 })

Config:Paragraph({
    Title = L("TabConfig"),
    Desc = L("ConfigParagraph"),
    Color = "Blue",
    Locked = false,
})

Config:Button({
    Title = L("SaveConfig"),
    Desc = L("SaveConfigDesc"),
    Locked = false,
    Callback = function()
        UniversalConfig:Save()
        Notify(L("ConfigSaved"), "save", 3)
    end
})

Config:Button({
    Title = L("LoadConfig"),
    Desc = L("LoadConfigDesc"),
    Locked = false,
    Callback = function()
        UniversalConfig:Load()
        RefreshESP()
        ApplyMovement()
        Notify(L("ConfigLoaded"), "folder-open", 3)
    end
})

Config:Button({
    Title = L("ResetSession"),
    Desc = L("ResetSessionDesc"),
    Locked = false,
    Callback = function()
        AimConfig.Enabled = false
        ESPConfig.Enabled = false
        MiscConfig.Noclip = false
        MiscConfig.InfiniteJump = false
        CurrentTarget = nil
        ClearESP()
        ResetAllHitboxes()
        Notify(L("SessionReset"), "rotate-ccw", 3)
    end
})

Config:Section({ Title = L("SectionStartup"), Box = false, TextSize = 17 })

Config:Toggle({
    Title = L("AutoLoadConfig"),
    Desc = L("AutoLoadConfigDesc"),
    Flag = "ConfigAutoLoad",
    Type = "Checkbox",
    Value = true,
    Callback = function(v) end
})

Config:Toggle({
    Title = L("AutoLoadScript"),
    Desc = L("AutoLoadScriptDesc"),
    Flag = "ConfigAutoLoadScript",
    Type = "Checkbox",
    Value = false,
    Callback = function(v) end
})

Config:Section({ Title = L("SectionLanguage"), Box = false, TextSize = 17 })

Config:Dropdown({
    Title = L("LanguageDropdown"),
    Desc = L("LanguageDropdownDesc"),
    Flag = "ConfigLanguage",
    Values = { "English", "Portuguese", "Spanish" },
    Value = CurrentLanguage,
    Callback = function(v)
        if Languages[v] then
            SaveLanguage(v)
            Notify(L("LanguageSaved"), "languages", 4)
        end
    end
})

Config:Button({
    Title = L("SaveLanguage"),
    Desc = L("SaveLanguageDesc"),
    Locked = false,
    Callback = function()
        SaveLanguage(CurrentLanguage)
        Notify(L("LanguageSaved"), "languages", 4)
    end
})

Config:Section({ Title = L("SectionInterface"), Box = false, TextSize = 17 })

Config:Toggle({
    Title = "Notifications",
    Desc = "Enable or disable hub notifications.",
    Flag = "ConfigNotifications",
    Type = "Checkbox",
    Value = true,
    Callback = function(v)
        NotificationsEnabled = v
    end
})

Config:Keybind({
    Title = L("ToggleUIKey"),
    Desc = L("ToggleUIKeyDesc"),
    Flag = "ConfigToggleKey",
    Value = "H",
    Callback = function(v)
        if v and Enum.KeyCode[v] then
            Window:SetToggleKey(Enum.KeyCode[v])
            Notify(L("KeyChanged") .. v, "keyboard", 3)
        end
    end
})

--// ==========================================================
--// CONNECTIONS
--// ==========================================================

UserInputService.JumpRequest:Connect(function()
    if MiscConfig.InfiniteJump then
        local hum = GetHumanoid()
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

LocalPlayer.Idled:Connect(function()
    if MiscConfig.AntiAFK then
        VirtualUser:Button2Down(Vector2.new(0, 0), Camera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0, 0), Camera.CFrame)
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    ApplyMovement()

    if ESPConfig.Enabled then
        RefreshESP()
    end
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.7)

        if ESPConfig.Enabled then
            CreateESP(player)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    if player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                ResetHitboxPart(part)
            end
        end
    end

    RemoveESP(player)
end)

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function()
            task.wait(0.7)

            if ESPConfig.Enabled then
                CreateESP(player)
            end
        end)
    end
end

--// ==========================================================
--// LOOPS
--// ==========================================================

RunService.RenderStepped:Connect(function()
    Camera = workspace.CurrentCamera

    if FOVCircle then
        FOVCircle.Position = GetScreenCenter()
        FOVCircle.Radius = AimConfig.FOV
        FOVCircle.Color = AimConfig.FOVColor
        FOVCircle.Visible = AimConfig.FOVVisible
    end

    ApplyNoclip()
    UpdateAimbot()
end)

task.spawn(function()
    while task.wait(0.03) do
        if ESPConfig.Enabled then
            UpdateESP()
        end
    end
end)

task.spawn(function()
    while task.wait(0.15) do
        if HitboxConfig.Enabled then
            UpdateHitboxes()
        end
    end
end)

--// ==========================================================
--// AUTO LOAD CONFIG
--// ==========================================================

task.defer(function()
    task.wait(0.5)

    pcall(function()
        UniversalConfig:Load()
    end)

    RefreshESP()
    ApplyMovement()

    Notify(L("Loaded"), "check", 3)
end)
