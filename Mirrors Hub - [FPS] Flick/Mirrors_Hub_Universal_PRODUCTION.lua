--==================================================
-- MIRRORS HUB - UNIVERSAL
-- Production refactor based on the original Universal 1.5
--==================================================

local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local UIS=game:GetService("UserInputService")
local VU=game:GetService("VirtualUser")
local TP=game:GetService("TeleportService")
local Http=game:GetService("HttpService")
local RS=game:GetService("ReplicatedStorage")
local Lighting=game:GetService("Lighting")
local LocalizationService=game:GetService("LocalizationService")
local RbxAnalyticsService=game:GetService("RbxAnalyticsService")
local Stats=game:GetService("Stats")

local LP=Players.LocalPlayer
local Camera=workspace.CurrentCamera

local ENV=(type(getgenv)=="function" and getgenv()) or _G
local previousRuntime=ENV.MirrorsHubUniversalRuntime
if type(previousRuntime)=="table" and type(previousRuntime.Cleanup)=="function" then
    pcall(function()previousRuntime:Cleanup()end)
end

local Runtime={
    Alive=true,
    Cleaning=false,
    Cleaned=false,
    Connections={},
    ConnectionSlots={},
    Cleanups={},
    Instances=setmetatable({}, {__mode="k"}),
    Drawings=setmetatable({}, {__mode="k"}),
    Tasks={},
    Tokens={},
    Window=nil,
}
ENV.MirrorsHubUniversalRuntime=Runtime

function Runtime:AddConnection(conn)
    if conn then table.insert(self.Connections,conn) end
    return conn
end

function Runtime:SetConnection(name,conn)
    local old=self.ConnectionSlots[name]
    if old and old~=conn then pcall(function()old:Disconnect()end) end
    self.ConnectionSlots[name]=conn
    return conn
end

function Runtime:AddCleanup(fn)
    if type(fn)=="function" then table.insert(self.Cleanups,1,fn) end
    return fn
end

function Runtime:AddInstance(inst)
    if typeof(inst)=="Instance" then self.Instances[inst]=true end
    return inst
end

function Runtime:AddDrawing(obj)
    if obj then self.Drawings[obj]=true end
    return obj
end

function Runtime:NewToken(name)
    local n=(self.Tokens[name] or 0)+1
    self.Tokens[name]=n
    return n
end

function Runtime:IsTokenCurrent(name,token)
    return self.Alive and self.Tokens[name]==token
end

function Runtime:Spawn(name,fn)
    local old=self.Tasks[name]
    if old and type(task.cancel)=="function" then pcall(task.cancel,old) end
    local token=self:NewToken(name)
    local thread=task.spawn(function()
        local ok,err=pcall(fn,token)
        if not ok and self.Alive then warn("[MIRRORS] Task "..tostring(name).." failed: "..tostring(err)) end
    end)
    self.Tasks[name]=thread
    return token,thread
end

function Runtime:Delay(name,delayTime,fn)
    local old=self.Tasks[name]
    if old and type(task.cancel)=="function" then pcall(task.cancel,old) end
    local token=self:NewToken(name)
    local thread=task.delay(delayTime,function()
        if not self:IsTokenCurrent(name,token) then return end
        local ok,err=pcall(fn,token)
        if not ok and self.Alive then warn("[MIRRORS] Delayed task "..tostring(name).." failed: "..tostring(err)) end
    end)
    self.Tasks[name]=thread
    return token,thread
end

function Runtime:Cleanup()
    if self.Cleaned or self.Cleaning then return end
    self.Cleaning=true
    self.Alive=false

    for name,value in pairs(self.Tokens) do self.Tokens[name]=value+1 end

    for _,thread in pairs(self.Tasks) do
        if thread and type(task.cancel)=="function" then pcall(task.cancel,thread) end
    end
    self.Tasks={}

    for _,conn in pairs(self.ConnectionSlots) do
        if conn then pcall(function()conn:Disconnect()end) end
    end
    self.ConnectionSlots={}

    for _,conn in ipairs(self.Connections) do
        if conn then pcall(function()conn:Disconnect()end) end
    end
    self.Connections={}

    for _,fn in ipairs(self.Cleanups) do pcall(fn) end
    self.Cleanups={}

    for obj in pairs(self.Drawings) do
        pcall(function()
            if obj.Remove then obj:Remove() elseif obj.Destroy then obj:Destroy() end
        end)
    end
    self.Drawings=setmetatable({}, {__mode="k"})

    for inst in pairs(self.Instances) do
        if typeof(inst)=="Instance" then pcall(function()inst:Destroy()end) end
    end
    self.Instances=setmetatable({}, {__mode="k"})

    local window=self.Window
    self.Window=nil
    if window then pcall(function()window:Destroy()end) end

    if ENV.MirrorsHubUniversalRuntime==self then ENV.MirrorsHubUniversalRuntime=nil end
    self.Cleaned=true
    self.Cleaning=false
end

local function getRequestFunction()
    local req=nil
    pcall(function()
        req=(syn and syn.request) or (http and http.request) or http_request or request or (fluxus and fluxus.request)
    end)
    return type(req)=="function" and req or nil
end

local Request=getRequestFunction()

local HUB_FOLDER="MirrorsHub"
local CONFIG_FOLDER="MirrorsHub/config"
local LANG_FILE=CONFIG_FOLDER.."/language.json"
local booting=true




local function fs()
	return typeof(writefile)=="function" and typeof(readfile)=="function" and typeof(isfile)=="function" and typeof(makefolder)=="function" and typeof(isfolder)=="function"
end
local function mk()
	if fs() then
		if not isfolder(HUB_FOLDER) then pcall(makefolder,HUB_FOLDER) end
		if not isfolder(CONFIG_FOLDER) then pcall(makefolder,CONFIG_FOLDER) end
	end
end
mk()

local function detectRobloxLanguage()
	local locale=""
	pcall(function()locale=tostring(LocalizationService.RobloxLocaleId or LocalizationService.SystemLocaleId or "")end)
	if locale==""then pcall(function()locale=tostring(LP.LocaleId or "")end)end
	locale=locale:lower()
	if locale:find("pt")then return "Portuguese"end
	if locale:find("es")then return "Spanish"end
	return "English"
end
local Lang=detectRobloxLanguage()
local TXT={
English={
WindowTitle="Mirrors Hub - Universal",OpenButton="Open Mirrors Hub",Scripts="Scripts",Aimbot="Aimbot",ESP="ESP",Misc="Misc",OP="OP",Troll="Troll",Config="Config",Status="Status",
Home="Home",Main="Main",FOV="FOV",Tuning="Tuning",Info="Info",Visual="Visual",Movement="Movement",Utility="Utility",Hitbox="Hitbox",Server="Server",ConfigFile="Config File",Startup="Startup",Language="Language",Interface="Interface",Danger="Danger Zone",God="God Mode",Protection="Protection",Fling="Fling Tools",Freeze="Freeze Tools",
HomeTitle="Mirrors Hub",HomeDesc="Universal script hub.\nVersion: 1.5\nCreated by blackzw.mp3",BetaTitle="Beta Notice",BetaDesc="This hub is still in beta and may contain bugs. Report issues on Discord.",DiscordTitle="Community",DiscordDesc="Found bugs or have suggestions? Send them on Discord.",StatusTitle="Status",StatusDesc="Build: 1.5 Beta.",
EnableAimbot="Enable Aimbot",TeamCheck="Team Check",VisibleCheck="Visible Check",TargetPart="Target Part",AimbotFOV="Aimbot FOV",ShowFOV="Show FOV Circle",FOVColor="FOV Color",Smoothness="Smoothness",Strength="Aim Strength",SwitchDelay="Target Switch Delay",Crosshair="Crosshair",CrosshairSize="Crosshair Size",
EnableESP="Enable ESP",ESPColor="ESP Color",ShowNames="Show Names",ShowHealth="Show Health",ShowDistance="Show Distance",ShowLines="Show Lines",FillBox="Fill Box",FillTransparency="Fill Transparency",OutlineTransparency="Outline Transparency",TextSize="Text Size",MaxDistance="Max Distance",RefreshESP="Refresh ESP",ESPUpdated="ESP refreshed.",TeamColor="Team Color",RainbowESP="Rainbow ESP",TracerOrigin="Tracer Origin",
WalkSpeed="WalkSpeed",JumpPower="JumpPower",Noclip="Noclip",NoclipMode="Noclip Mode",NoclipPower="Noclip Assist Power",InfiniteJump="Infinite Jump",AntiAFK="Anti AFK",ResetCharacter="Reset Character",AntiVoid="Anti Void",Fullbright="Fullbright",NoFog="No Fog",
Rejoin="Rejoin Server",ServerHop="Server Hop",SmallServer="Small Server",CopyJobId="Copy Job ID",JobIdInput="Job ID",JoinJobId="Join Job ID",
EnableHitbox="Enable Hitbox Expander",HitboxSize="Hitbox Size",HitboxTransparency="Hitbox Transparency",HitboxColor="Hitbox Color",HitboxTeam="Hitbox Team Check",ResetHitboxes="Reset Hitboxes",HitboxesReset="Hitboxes reset.",
God100="God Mode 1",GodInf="God Mode 2",AntiFling="Anti Fling",TouchFling="Touch Fling",FlingPower="Touch Fling Power",FlingPulse="Touch Fling Pulse",RefreshFling="Refresh Touch Fling",
SelectPlayer="Select Player",RefreshPlayers="Refresh Players",TeleportPlayer="Teleport To Player",BringPlayer="Bring Selected Player",SpectatePlayer="Spectate Player",Unspectate="Unspectate",TeleportBack="Teleport Back",FreezeSelected="Freeze Selected Player",FreezeAll="Freeze All Players",UnfreezeAll="Unfreeze All Players",NoPlayer="No player selected.",PlayerListUpdated="Player list updated.",Teleported="Teleported.",
FakeLag="Fake Lag",FakeLagRate="Fake Lag Rate",FakeLagHold="Fake Lag Hold",FakeDeath="Fake Death",FakeDeathCooldown="Stand Up",Orbit="Orbit Player",OrbitMode="Orbit Mode",OrbitRadius="Orbit Radius",OrbitSpeed="Orbit Speed",OrbitHeight="Orbit Height",SpinBot="Spin Bot",SpinSpeed="Spin Speed",HeadSit="Head Sit Follow",Annoy="Annoy Teleport",AnnoyMode="Annoy Mode",AnnoySpeed="Annoy Speed",GhostTrail="Ghost Trail",
ConfigPath="Folder: MirrorsHub/config\nFile: universal-config.json",SaveConfig="Save Config",LoadConfig="Load Config",ResetSession="Reset Session",AutoLoadConfig="Auto Load Config",AutoSave="Auto Save",ExportConfig="Export Config",ImportConfig="Import Config",ProfileName="Profile Name",LanguageDropdown="Interface Language",Notifications="Notifications",Theme="Theme",ToggleKey="Toggle UI Key",DestroyUI="Destroy UI",BoostFPS="Boost FPS",
CopyDiscord="Copy Discord",CopyStatus="Copy Full Status",ShowPlayers="Show Players",ShowServerTime="Show Server Time",ShowPing="Show Ping",ShowPlaceId="Show Place ID",ShowJobId="Show Job ID",ShowGameId="Show Game ID",ShowGravity="Show Gravity",ShowExecutor="Show Executor Support",ShowAccountAge="Show Account Age",ShowPosition="Show Position",RefreshStatus="Refresh Status",ServerPlayers="Players",ServerTime="Server Time",PlayerInfo="Player Info",AccountAge="Account Age",Team="Team",Health="Health",Position="Position",None="None",Yes="Yes",No="No",Days="days",BoostApplied="FPS Boost applied. Cap set to 120 when supported.",
Saved="Config saved.",LoadedConfig="Config loaded.",ResetDone="Session reset.",Loaded="Script loaded successfully.",Copied="Copied.",ServerErr="Failed to fetch servers.",NoServer="No server with less than 5 players found.",NotConfigured="Not configured yet.",
AskAI="Ask AI",
YourQuestion="Your Question",
QuestionDesc="Type what you want to ask about the script",
QuestionPlaceholder="Ex: How to enable Aimbot?",
AIResponse="AI Response:",
AIAwaiting="Awaiting your question...",
SendButton="Ask AI 🚀",
SendDesc="Click to process your question",
InvalidQuestion="Please write a valid question first!",
Thinking="⏳ Thinking...",
CooldownText="Wait %ss to ask again!"
},
Portuguese={
WindowTitle="Mirrors Hub - Universal",OpenButton="Abrir Mirrors Hub",Scripts="Scripts",Aimbot="Aimbot",ESP="ESP",Misc="Misc",OP="OP",Troll="Troll",Config="Config",Status="Status",
Home="Início",Main="Principal",FOV="FOV",Tuning="Ajustes",Info="Informações",Visual="Visual",Movement="Movimento",Utility="Utilidades",Hitbox="Hitbox",Server="Servidor",ConfigFile="Arquivo de Config",Startup="Inicialização",Language="Idioma",Interface="Interface",Danger="Zona de Perigo",God="God Mode",Protection="Proteção",Fling="Ferramentas de Fling",Freeze="Ferramentas de Freeze",
HomeTitle="Mirrors Hub",HomeDesc="Hub universal de scripts.\nVersão: 1.5\nCriado por blackzw.mp3",BetaTitle="Aviso Beta",BetaDesc="Este hub ainda está em beta e pode conter bugs. Avise no Discord.",DiscordTitle="Comunidade",DiscordDesc="Achou bugs ou tem sugestões? Manda no Discord.",StatusTitle="Status",StatusDesc="Build: 1.5 Beta.",
EnableAimbot="Ativar Aimbot",TeamCheck="Verificar Time",VisibleCheck="Verificar Visibilidade",TargetPart="Parte do Alvo",AimbotFOV="FOV do Aimbot",ShowFOV="Mostrar Círculo FOV",FOVColor="Cor do FOV",Smoothness="Suavidade",Strength="Força da Mira",SwitchDelay="Delay de Troca de Alvo",Crosshair="Crosshair",CrosshairSize="Tamanho do Crosshair",
EnableESP="Ativar ESP",ESPColor="Cor do ESP",ShowNames="Mostrar Nomes",ShowHealth="Mostrar Vida",ShowDistance="Mostrar Distância",ShowLines="Mostrar Linhas",FillBox="Preencher Box",FillTransparency="Transparência do Fill",OutlineTransparency="Transparência da Borda",TextSize="Tamanho do Texto",MaxDistance="Distância Máxima",RefreshESP="Atualizar ESP",ESPUpdated="ESP atualizado.",TeamColor="Cor do Time",RainbowESP="ESP Arco-Íris",TracerOrigin="Origem da Linha",
WalkSpeed="Velocidade",JumpPower="Força do Pulo",Noclip="Noclip",NoclipMode="Modo Noclip",NoclipPower="Força do Noclip",InfiniteJump="Pulo Infinito",AntiAFK="Anti AFK",ResetCharacter="Resetar Personagem",AntiVoid="Anti Void",Fullbright="Fullbright",NoFog="Sem Neblina",
Rejoin="Reconectar Servidor",ServerHop="Trocar Servidor",SmallServer="Servidor Menor",CopyJobId="Copiar Job ID",JobIdInput="Job ID",JoinJobId="Entrar no Job ID",
EnableHitbox="Ativar Expansor de Hitbox",HitboxSize="Tamanho da Hitbox",HitboxTransparency="Transparência da Hitbox",HitboxColor="Cor da Hitbox",HitboxTeam="Verificar Time da Hitbox",ResetHitboxes="Resetar Hitboxes",HitboxesReset="Hitboxes resetadas.",
God100="God Mode 1",GodInf="God Mode 2",AntiFling="Anti Fling",TouchFling="Touch Fling",FlingPower="Força do Touch Fling",FlingPulse="Pulso do Touch Fling",RefreshFling="Atualizar Touch Fling",
SelectPlayer="Selecionar Jogador",RefreshPlayers="Atualizar Jogadores",TeleportPlayer="Teleportar Para Jogador",BringPlayer="Trazer Jogador Selecionado",SpectatePlayer="Espectar Jogador",Unspectate="Parar Espectar",TeleportBack="Voltar Teleporte",FreezeSelected="Congelar Jogador Selecionado",FreezeAll="Congelar Todos Jogadores",UnfreezeAll="Descongelar Todos",NoPlayer="Nenhum jogador selecionado.",PlayerListUpdated="Lista de jogadores atualizada.",Teleported="Teleportado.",
FakeLag="Fake Lag",FakeLagRate="Taxa do Fake Lag",FakeLagHold="Força do Fake Lag",FakeDeath="Fake Death",FakeDeathCooldown="Levantar",Orbit="Orbitar Jogador",OrbitMode="Modo da Órbita",OrbitRadius="Raio da Órbita",OrbitSpeed="Velocidade da Órbita",OrbitHeight="Altura da Órbita",SpinBot="Spin Bot",SpinSpeed="Velocidade do Spin",HeadSit="Sentar na Cabeça",Annoy="Annoy Teleport",AnnoyMode="Modo Annoy",AnnoySpeed="Velocidade Annoy",GhostTrail="Rastro Fantasma",
ConfigPath="Pasta: MirrorsHub/config\nArquivo: universal-config.json",SaveConfig="Salvar Config",LoadConfig="Carregar Config",ResetSession="Resetar Sessão",AutoLoadConfig="Auto Carregar Config",AutoSave="Auto Save",ExportConfig="Exportar Config",ImportConfig="Importar Config",ProfileName="Nome do Perfil",LanguageDropdown="Idioma da Interface",Notifications="Notificações",Theme="Tema",ToggleKey="Tecla da UI",DestroyUI="Destruir UI",BoostFPS="Boost de FPS",
CopyDiscord="Copiar Discord",CopyStatus="Copiar Status Completo",ShowPlayers="Mostrar Jogadores",ShowServerTime="Mostrar Tempo do Servidor",ShowPing="Mostrar Ping",ShowPlaceId="Mostrar Place ID",ShowJobId="Mostrar Job ID",ShowGameId="Mostrar Game ID",ShowGravity="Mostrar Gravidade",ShowExecutor="Mostrar Suporte do Executor",ShowAccountAge="Mostrar Idade da Conta",ShowPosition="Mostrar Posição",RefreshStatus="Atualizar Status",ServerPlayers="Jogadores",ServerTime="Tempo do Servidor",PlayerInfo="Informações do Player",AccountAge="Idade da Conta",Team="Time",Health="Vida",Position="Posição",None="Nenhum",Yes="Sim",No="Não",Days="dias",BoostApplied="Boost de FPS aplicado. Limite definido para 120 quando suportado.",
Saved="Config salva.",LoadedConfig="Config carregada.",ResetDone="Sessão resetada.",Loaded="Script foi carregado com sucesso.",Copied="Copiado.",ServerErr="Erro ao buscar servidores.",NoServer="Nenhum servidor com menos de 5 pessoas encontrado.",NotConfigured="Ainda não configurado.",
AskAI="Assistente IA",
YourQuestion="Sua Dúvida",
QuestionDesc="Digite o que você quer saber sobre o script",
QuestionPlaceholder="Ex: Como ligar o Aimbot?",
AIResponse="Resposta da IA:",
AIAwaiting="Aguardando sua pergunta...",
SendButton="Perguntar para IA 🚀",
SendDesc="Clique para processar sua dúvida",
InvalidQuestion="Escreva uma pergunta válida primeiro!",
Thinking="⏳ Pensando na resposta...",
CooldownText="Aguarde %ss para perguntar de novo!"
},
Spanish={
WindowTitle="Mirrors Hub - Universal",OpenButton="Abrir Mirrors Hub",Scripts="Scripts",Aimbot="Aimbot",ESP="ESP",Misc="Misc",OP="OP",Troll="Troll",Config="Config",Status="Status",
Home="Inicio",Main="Principal",FOV="FOV",Tuning="Ajustes",Info="Información",Visual="Visual",Movement="Movimiento",Utility="Utilidad",Hitbox="Hitbox",Server="Servidor",ConfigFile="Archivo de Config",Startup="Inicio",Language="Idioma",Interface="Interfaz",Danger="Zona de Peligro",God="God Mode",Protection="Protección",Fling="Herramientas de Fling",Freeze="Herramientas de Freeze",
HomeTitle="Mirrors Hub",HomeDesc="Hub universal de scripts.\nVersión: 1.5\nCreado por blackzw.mp3",BetaTitle="Aviso Beta",BetaDesc="Este hub todavía está en beta y puede tener bugs. Avísalo en Discord.",DiscordTitle="Comunidad",DiscordDesc="¿Bugs o sugerencias? Mándalos en Discord.",StatusTitle="Estado",StatusDesc="Build: 1.5 Beta.",
EnableAimbot="Activar Aimbot",TeamCheck="Verificar Equipo",VisibleCheck="Verificar Visibilidad",TargetPart="Parte del Objetivo",AimbotFOV="FOV del Aimbot",ShowFOV="Mostrar Círculo FOV",FOVColor="Color del FOV",Smoothness="Suavidad",Strength="Fuerza de Mira",SwitchDelay="Delay de Cambio de Objetivo",Crosshair="Crosshair",CrosshairSize="Tamaño del Crosshair",
EnableESP="Activar ESP",ESPColor="Color del ESP",ShowNames="Mostrar Nombres",ShowHealth="Mostrar Vida",ShowDistance="Mostrar Distancia",ShowLines="Mostrar Líneas",FillBox="Rellenar Box",FillTransparency="Transparencia del Relleno",OutlineTransparency="Transparencia del Borde",TextSize="Tamaño del Texto",MaxDistance="Distancia Máxima",RefreshESP="Actualizar ESP",ESPUpdated="ESP actualizado.",TeamColor="Color del Equipo",RainbowESP="ESP Arcoíris",TracerOrigin="Origen de Línea",
WalkSpeed="Velocidad",JumpPower="Poder de Salto",Noclip="Noclip",NoclipMode="Modo Noclip",NoclipPower="Fuerza del Noclip",InfiniteJump="Salto Infinito",AntiAFK="Anti AFK",ResetCharacter="Resetear Personaje",AntiVoid="Anti Void",Fullbright="Fullbright",NoFog="Sin Niebla",
Rejoin="Reconectar Servidor",ServerHop="Cambiar Servidor",SmallServer="Servidor Pequeño",CopyJobId="Copiar Job ID",JobIdInput="Job ID",JoinJobId="Entrar al Job ID",
EnableHitbox="Activar Expansor de Hitbox",HitboxSize="Tamaño de Hitbox",HitboxTransparency="Transparencia de Hitbox",HitboxColor="Color de Hitbox",HitboxTeam="Verificar Equipo de Hitbox",ResetHitboxes="Resetear Hitboxes",HitboxesReset="Hitboxes reseteadas.",
God100="God Mode 1",GodInf="God Mode 2",AntiFling="Anti Fling",TouchFling="Touch Fling",FlingPower="Fuerza del Touch Fling",FlingPulse="Pulso del Touch Fling",RefreshFling="Actualizar Touch Fling",
SelectPlayer="Seleccionar Jugador",RefreshPlayers="Actualizar Jugadores",TeleportPlayer="Teleportar al Jugador",BringPlayer="Traer Jugador Seleccionado",SpectatePlayer="Espectar Jugador",Unspectate="Dejar de Espectar",TeleportBack="Volver Teleporte",FreezeSelected="Congelar Jugador Seleccionado",FreezeAll="Congelar Todos Jugadores",UnfreezeAll="Descongelar Todos",NoPlayer="Ningún jugador seleccionado.",PlayerListUpdated="Lista actualizada.",Teleported="Teleportado.",
FakeLag="Fake Lag",FakeLagRate="Tasa del Fake Lag",FakeLagHold="Fuerza del Fake Lag",FakeDeath="Fingir Muerte",FakeDeathCooldown="Levantarse",Orbit="Orbitar Jugador",OrbitMode="Modo de Órbita",OrbitRadius="Radio de Órbita",OrbitSpeed="Velocidad de Órbita",OrbitHeight="Altura de Órbita",SpinBot="Spin Bot",SpinSpeed="Velocidad de Spin",HeadSit="Sentarse en Cabeza",Annoy="Annoy Teleport",AnnoyMode="Modo Annoy",AnnoySpeed="Velocidad Annoy",GhostTrail="Rastro Fantasma",
ConfigPath="Carpeta: MirrorsHub/config\nArchivo: universal-config.json",SaveConfig="Guardar Config",LoadConfig="Cargar Config",ResetSession="Resetear Sesión",AutoLoadConfig="Auto Cargar Config",AutoSave="Auto Guardar",ExportConfig="Exportar Config",ImportConfig="Importar Config",ProfileName="Nombre del Perfil",LanguageDropdown="Idioma de Interfaz",Notifications="Notificaciones",Theme="Tema",ToggleKey="Tecla de UI",DestroyUI="Destruir UI",BoostFPS="Boost de FPS",
CopyDiscord="Copiar Discord",CopyStatus="Copiar Estado Completo",ShowPlayers="Mostrar Jugadores",ShowServerTime="Mostrar Tiempo del Servidor",ShowPing="Mostrar Ping",ShowPlaceId="Mostrar Place ID",ShowJobId="Mostrar Job ID",ShowGameId="Mostrar Game ID",ShowGravity="Mostrar Gravedad",ShowExecutor="Mostrar Soporte del Executor",ShowAccountAge="Mostrar Edad de la Cuenta",ShowPosition="Mostrar Posición",RefreshStatus="Actualizar Estado",ServerPlayers="Jugadores",ServerTime="Tiempo del Servidor",PlayerInfo="Información del Jugador",AccountAge="Edad de la Cuenta",Team="Equipo",Health="Vida",Position="Posición",None="Ninguno",Yes="Sí",No="No",Days="días",BoostApplied="Boost de FPS aplicado. Límite definido en 120 cuando sea compatible.",
Saved="Config guardada.",LoadedConfig="Config cargada.",ResetDone="Sesión reseteada.",Loaded="Script cargado correctamente.",Copied="Copiado.",ServerErr="Error al buscar servidores.",NoServer="No se encontró servidor con menos de 5 personas.",NotConfigured="Todavía no configurado.",
AskAI="Asistente IA",
YourQuestion="Tu Duda",
QuestionDesc="Escribe lo que quieres saber sobre el script",
QuestionPlaceholder="Ex: ¿Cómo activar el Aimbot?",
AIResponse="Respuesta de la IA:",
AIAwaiting="Esperando tu pregunta...",
SendButton="Preguntar a la IA 🚀",
SendDesc="Haz clic para procesar tu duda",
InvalidQuestion="¡Escribe una pregunta válida primero!",
Thinking="⏳ Pensando...",
CooldownText="¡Espera %ss para preguntar de nuevo!"
}
}

local function loadLang()
	if fs() and isfile(LANG_FILE) then
		local ok,d=pcall(function()return Http:JSONDecode(readfile(LANG_FILE))end)
		if ok and d and TXT[d.Language] then Lang=d.Language end
	end
end
local function saveLang(v)
	if TXT[v] then Lang=v;mk();if fs() then pcall(function()writefile(LANG_FILE,Http:JSONEncode({Language=v}))end)end end
end
local function L(k)local s=TXT[Lang]or TXT.English;return s[k]or TXT.English[k]or k end
loadLang()


-- Additional production strings without duplicating the original translation table.
local EXTRA_TXT={
    English={
        SpeedEnabled="Enable Speed Boost",JumpEnabled="Enable Jump Boost",PerformanceMode="Performance Mode",
        UIScale="UI Scale",BackgroundTransparency="Background Transparency",CenterWindow="Center Window",UnloadScript="Unload Script",
        ConfigList="Config Profile",RefreshConfigs="Refresh Configs",DeleteConfig="Delete Config",LanguageReload="Language saved. Re-execute the hub to apply all texts.",
        KeyInformation="Key Information",KeyStatus="Status",KeyProvider="Provider",KeyExpires="Expires",LiveStatus="Live Status",
        LegacyApiDisabled="This integration is disabled until a verified endpoint is configured.",ConfigDeleted="Config deleted.",ConfigNotFound="Config unavailable.",
        PerformanceApplied="Performance Mode enabled.",PerformanceRestored="Performance Mode restored.",FreezeTools="Freeze Tools",
        HomeDesc="Universal script hub.\nVersion: 1.6 Production\nCreated by blackzw.mp3",StatusDesc="Build: 1.6 Production.",ConfigPath="Folder: MirrorsHub/config\nProfile-based WindUI ConfigManager"
    },
    Portuguese={
        SpeedEnabled="Ativar Boost de Velocidade",JumpEnabled="Ativar Boost de Pulo",PerformanceMode="Modo Performance",
        UIScale="Escala da UI",BackgroundTransparency="Transparência do Fundo",CenterWindow="Centralizar Janela",UnloadScript="Descarregar Script",
        ConfigList="Perfil de Config",RefreshConfigs="Atualizar Configs",DeleteConfig="Excluir Config",LanguageReload="Idioma salvo. Reexecute o hub para aplicar todos os textos.",
        KeyInformation="Informações da Key",KeyStatus="Status",KeyProvider="Provedor",KeyExpires="Expira",LiveStatus="Status Ao Vivo",
        LegacyApiDisabled="Esta integração está desativada até existir um endpoint verificado.",ConfigDeleted="Config excluída.",ConfigNotFound="Config indisponível.",
        PerformanceApplied="Modo Performance ativado.",PerformanceRestored="Modo Performance restaurado.",FreezeTools="Ferramentas de Freeze",
        HomeDesc="Hub universal de scripts.\nVersão: 1.6 Production\nCriado por blackzw.mp3",StatusDesc="Build: 1.6 Production.",ConfigPath="Pasta: MirrorsHub/config\nConfigManager WindUI por perfil"
    },
    Spanish={
        SpeedEnabled="Activar Boost de Velocidad",JumpEnabled="Activar Boost de Salto",PerformanceMode="Modo Rendimiento",
        UIScale="Escala de UI",BackgroundTransparency="Transparencia del Fondo",CenterWindow="Centrar Ventana",UnloadScript="Descargar Script",
        ConfigList="Perfil de Config",RefreshConfigs="Actualizar Configs",DeleteConfig="Eliminar Config",LanguageReload="Idioma guardado. Vuelve a ejecutar el hub para aplicar todos los textos.",
        KeyInformation="Información de Key",KeyStatus="Estado",KeyProvider="Proveedor",KeyExpires="Expira",LiveStatus="Estado en Vivo",
        LegacyApiDisabled="Esta integración está desactivada hasta configurar un endpoint verificado.",ConfigDeleted="Config eliminada.",ConfigNotFound="Config no disponible.",
        PerformanceApplied="Modo Rendimiento activado.",PerformanceRestored="Modo Rendimiento restaurado.",FreezeTools="Herramientas de Freeze",
        HomeDesc="Hub universal de scripts.\nVersión: 1.6 Production\nCreado por blackzw.mp3",StatusDesc="Build: 1.6 Production.",ConfigPath="Carpeta: MirrorsHub/config\nConfigManager WindUI por perfil"
    }
}
for lang,values in pairs(EXTRA_TXT) do
    TXT[lang]=TXT[lang] or {}
    for key,value in pairs(values) do TXT[lang][key]=value end
end

local STARTUP_FILE=CONFIG_FOLDER.."/startup.json"
local function readStartupMeta()
    if not fs() or not isfile(STARTUP_FILE) then return {} end
    local ok,data=pcall(function()return Http:JSONDecode(readfile(STARTUP_FILE))end)
    return ok and type(data)=="table" and data or {}
end
local startupMeta=readStartupMeta()

local Aim={Enabled=false,FOV=140,Smoothness=.09,Strength=1,TargetPart="Head",TargetSwitchDelay=.25,TeamCheck=false,VisibleCheck=false,FOVVisible=false,FOVColor=Color3.fromRGB(134,0,212),Crosshair=false,CrosshairSize=8}
local EspC={Enabled=false,Color=Color3.fromRGB(0,255,255),ShowNames=false,ShowHealth=false,ShowDistance=false,ShowLines=false,TeamCheck=false,Fill=false,FillTransparency=.75,OutlineTransparency=0,TextSize=13,MaxDistance=5000,TeamColor=false,Rainbow=false,TracerOrigin="Bottom"}
local MiscC={SpeedEnabled=false,WalkSpeed=16,JumpEnabled=false,JumpPower=50,Noclip=false,InfiniteJump=false,AntiAFK=false,AntiVoid=true,Fullbright=false,NoFog=false,Performance=false}
local HitC={Enabled=false,Size=10,MaxSize=200,Transparency=.65,Color=Color3.fromRGB(134,0,212),TeamCheck=false}
local OpC={God100=false,GodInf=false,AntiFling=false,TouchFling=false,FlingPower=10000,FlingPulse=.1,FreezeSelected=false,FreezeAll=false}
local TrollC={FakeLag=false,FakeLagRate=.22,FakeLagHold=.08,FakeDeath=false,FakeDeathCooldown=1.2,Orbit=false,OrbitMode="Circle",OrbitRadius=7,OrbitSpeed=8,OrbitHeight=4,Spin=false,SpinSpeed=35,HeadSit=false,Annoy=false,AnnoyMode="Circle",AnnoySpeed=.05,Ghost=true}

local OPSelectedPlayer="None"
local TrollSelectedPlayer="None"
local JobInput=""
local LastTeleportCF=nil
local ProfileName=tostring(startupMeta.ProfileName or "default")
local AutoSave=false
local AutoLoadConfig=startupMeta.AutoLoadConfig~=false
local NotifyOn=true
local ThemeName="Mirrors Purple"
local UIScaleValue=1
local BackgroundTransparencyValue=0
local booting=true
local ConfigDirty=false
local SyncingControls=false
local Controls={}
local lastSafePosition=nil

local function saveStartupMeta()
    if not fs() then return end
    mk()
    pcall(function()
        writefile(STARTUP_FILE,Http:JSONEncode({ProfileName=ProfileName,AutoLoadConfig=AutoLoadConfig}))
    end)
end

-- Old mirrorskey-system endpoints were found to be unreliable during the audit.
-- They remain intentionally disabled instead of silently redirecting to an unverified replacement.
local ENABLE_LEGACY_EXTERNAL_APIS=false
local LEGACY_TELEMETRY_URL="https://mirrorskey-system.vercel.app/api/log-use"
local LEGACY_CHAT_URL="https://mirrorskey-system.vercel.app/api/chat"

local function GetExecutor()
    if type(identifyexecutor)=="function" then
        local ok,v=pcall(identifyexecutor)
        if ok and v then return tostring(v) end
    end
    if type(getexecutorname)=="function" then
        local ok,v=pcall(getexecutorname)
        if ok and v then return tostring(v) end
    end
    return "Unknown"
end

local function GetHWID()
    if type(gethwid)=="function" then
        local ok,v=pcall(gethwid)
        if ok and v then
            v=tostring(v)
            if #v>=8 and #v<=256 then return v end
        end
    end
    local ok,v=pcall(function()return RbxAnalyticsService:GetClientId()end)
    if ok and v then
        v=tostring(v)
        if #v>=8 and #v<=256 then return v end
    end
end

local KeyInfo={Status="Unknown",Provider="Unknown",ExpiresAt=nil}
local KEY_API_URL="https://mirrorshub-key.vercel.app/api/key/validate"
local KeyMessages={
    INVALID_KEY="Invalid key.",INVALID_HWID="Unable to identify this device.",HWID_MISMATCH="This key is linked to another device.",
    KEY_PAUSED="This key is paused.",KEY_INACTIVE="This key is inactive.",KEY_EXPIRED="This key has expired.",ACCESS_DENIED="Access denied.",USER_BANNED="Access denied.",VALIDATION_ERROR="Unable to validate key."
}

local function ValidateKey(key)
    key=tostring(key or ""):match("^%s*(.-)%s*$")
    if key=="" then return false end
    if not Request then
        KeyInfo.Status="REQUEST_UNSUPPORTED"
        warn("[MIRRORS] HTTP requests are not supported.")
        return false
    end
    local hwid=GetHWID()
    if not hwid then
        KeyInfo.Status="INVALID_HWID"
        warn("[MIRRORS] Unable to identify this device.")
        return false
    end
    local ok,res=pcall(function()
        return Request({
            Url=KEY_API_URL,Method="POST",Headers={["Content-Type"]="application/json",["Accept"]="application/json"},
            Body=Http:JSONEncode({key=key,hwid=hwid,robloxUserId=LP.UserId,robloxUsername=LP.Name,robloxDisplayName=LP.DisplayName,executor=GetExecutor(),placeId=game.PlaceId,jobId=game.JobId})
        })
    end)
    if not ok or type(res)~="table" then
        KeyInfo.Status="VALIDATION_ERROR"
        warn("[MIRRORS] Server connection failed.")
        return false
    end
    local raw=res.Body or res.body or res.ResponseBody or ""
    local decoded,data=pcall(function()return Http:JSONDecode(raw)end)
    if not decoded or type(data)~="table" then
        KeyInfo.Status="VALIDATION_ERROR"
        warn("[MIRRORS] Invalid server response.")
        return false
    end
    if data.valid==true then
        KeyInfo.Status="Active"
        KeyInfo.Provider=data.provider or "Unknown"
        KeyInfo.ExpiresAt=data.expiresAt
        print("[MIRRORS] Access granted.")
        return true
    end
    local code=tostring(data.code or "VALIDATION_ERROR")
    KeyInfo.Status=code
    warn("[MIRRORS] "..tostring(KeyMessages[code] or code))
    return false
end

local function FormatProvider(provider)
    local names={LOOTLABS="LootLabs",LINKVERTISE="Linkvertise",PROMO="Promo",ADMIN="Admin"}
    return names[provider] or provider or "Unknown"
end

local function RemainingTime(iso)
    if not iso then return "Unknown" end
    local ok,expires=pcall(DateTime.fromIsoDate,iso)
    if not ok or not expires then return "Unknown" end
    local seconds=math.floor((expires.UnixTimestampMillis-DateTime.now().UnixTimestampMillis)/1000)
    if seconds<=0 then return "Expired" end
    local days=math.floor(seconds/86400)
    local hours=math.floor((seconds%86400)/3600)
    local minutes=math.floor((seconds%3600)/60)
    if days>0 then return string.format("%dd %dh %dm",days,hours,minutes) end
    if hours>0 then return string.format("%dh %dm",hours,minutes) end
    return string.format("%dm",minutes)
end

if ENABLE_LEGACY_EXTERNAL_APIS and Request then
    Runtime:Spawn("Telemetry",function()
        local body=Http:JSONEncode({player=LP.Name,userId=tostring(LP.UserId),executor=GetExecutor(),placeId=tostring(game.PlaceId),jobId=tostring(game.JobId),version="1.6 Production"})
        pcall(function()Request({Url=LEGACY_TELEMETRY_URL,Method="POST",Headers={["Content-Type"]="application/json"},Body=body})end)
    end)
end

local WINDUI_URL="https://github.com/Footagesus/WindUI/releases/download/1.6.66/main.lua"
local okWind,windSource=pcall(function()return game:HttpGet(WINDUI_URL)end)
if not okWind then error("[MIRRORS] Failed to load pinned WindUI 1.6.66: "..tostring(windSource)) end
local WindUI=loadstring(windSource)()

WindUI:AddTheme({Name="Mirrors Purple",Accent=Color3.fromHex("#1C002E"),Background=Color3.fromHex("#101010"),Outline=Color3.fromHex("#8600D4"),Text=Color3.fromHex("#FFFFFF"),Placeholder=Color3.fromHex("#8a8a8a"),Button=Color3.fromHex("#2A0145"),Icon=Color3.fromHex("#C084FC")})
WindUI:AddTheme({Name="Midnight",Accent=Color3.fromHex("#111827"),Background=Color3.fromHex("#050505"),Outline=Color3.fromHex("#374151"),Text=Color3.fromHex("#FFFFFF"),Placeholder=Color3.fromHex("#9CA3AF"),Button=Color3.fromHex("#1F2937"),Icon=Color3.fromHex("#D1D5DB")})

local function notify(txt,icon,dur)
    if not Runtime.Alive or booting or not NotifyOn then return end
    pcall(function()WindUI:Notify({Title="Mirrors Hub",Content=txt,Duration=dur or 3,Icon=icon or "bell"})end)
end
local function bootNotify(txt)
    pcall(function()WindUI:Notify({Title="Mirrors Hub",Content=txt,Duration=4,Icon="check"})end)
end

local Window=WindUI:CreateWindow({
    Title=L("WindowTitle"),Icon="door-open",Author="by blackzw.mp3",Folder=CONFIG_FOLDER,
    Size=UDim2.fromOffset(590,470),MinSize=Vector2.new(560,350),ToggleKey=Enum.KeyCode.H,
    Transparent=true,Theme="Mirrors Purple",Resizable=false,SideBarWidth=200,HideSearchBar=false,ScrollBarEnabled=true,NewElements=true,
    KeySystem={Title="Access Required",Note="Get your key from the official Mirrors Hub website.",KeyValidator=ValidateKey,SaveKey=true,URL="https://mirrorshub-key.vercel.app/api/session",Thumbnail={Image="rbxassetid://132532585504638",Title="Mirrors Hub"}},
    User={Enabled=true,Anonymous=false}
})
Runtime.Window=Window

if Window.EditOpenButton then
    pcall(function()Window:EditOpenButton({Title=L("OpenButton"),Icon="monitor",CornerRadius=UDim.new(0,16),StrokeThickness=2,Color=ColorSequence.new(Color3.fromHex("8600D4"),Color3.fromHex("1C002E")),OnlyMobile=false,Enabled=true,Draggable=true})end)
end
if Window.OnDestroy then
    Window:OnDestroy(function()
        if not Runtime.Cleaning and not Runtime.Cleaned then Runtime:Cleanup() end
    end)
end

local ConfigManager=Window.ConfigManager
if ConfigManager and ConfigManager.Init then ConfigManager:Init(Window) end

local Tabs={
    Scripts=Window:Tab({Title=L("Scripts"),Icon="scroll-text"}),Aimbot=Window:Tab({Title=L("Aimbot"),Icon="crosshair"}),
    ESP=Window:Tab({Title=L("ESP"),Icon="eye"}),Misc=Window:Tab({Title=L("Misc"),Icon="circle-ellipsis"}),
    OP=Window:Tab({Title=L("OP"),Icon="flame",Locked=false}),Troll=Window:Tab({Title=L("Troll"),Icon="laugh"}),
    Config=Window:Tab({Title=L("Config"),Icon="cog"}),Status=Window:Tab({Title=L("Status"),Icon="activity"}),
    Info=Window:Tab({Title=L("Info"),Icon="info"}),AI=Window:Tab({Title=L("AskAI"),Icon="sparkles"})
}

local function char(p)return (p or LP).Character end
local function hum(p)local c=char(p);return c and c:FindFirstChildOfClass("Humanoid") end
local function root(p)local c=char(p);return c and c:FindFirstChild("HumanoidRootPart") end
local function destroyObject(o)
    if typeof(o)=="Instance" then pcall(function()o:Destroy()end)
    elseif o then pcall(function()if o.Remove then o:Remove() elseif o.Destroy then o:Destroy() end end) end
end

local function playerNames()
    local t={"None"}
    for _,p in ipairs(Players:GetPlayers()) do if p~=LP then t[#t+1]=p.Name end end
    table.sort(t,function(a,b)return a=="None" or (b~="None" and a<b) end)
    return t
end
local function getPlayerByName(name)
    if not name or name=="None" then return nil end
    return Players:FindFirstChild(name)
end
local function getOPSelected()return getPlayerByName(OPSelectedPlayer) end
local function getTrollSelected()return getPlayerByName(TrollSelectedPlayer) end

local Frame={Camera=Camera,Center=Vector2.zero,Now=0}
local function updateFrameContext()
    Camera=workspace.CurrentCamera or Camera
    Frame.Camera=Camera
    local size=Camera and Camera.ViewportSize or Vector2.zero
    Frame.Center=Vector2.new(size.X/2,size.Y/2)
    Frame.Now=os.clock()
end
updateFrameContext()

local HasDrawing=Drawing and Drawing.new
local FOVCircle,CrossA,CrossB
if HasDrawing then
    FOVCircle=Runtime:AddDrawing(Drawing.new("Circle"));FOVCircle.Thickness=1;FOVCircle.NumSides=64;FOVCircle.Radius=Aim.FOV;FOVCircle.Filled=false;FOVCircle.Visible=false;FOVCircle.Color=Aim.FOVColor
    CrossA=Runtime:AddDrawing(Drawing.new("Line"));CrossB=Runtime:AddDrawing(Drawing.new("Line"));CrossA.Thickness=1;CrossB.Thickness=1;CrossA.Visible=false;CrossB.Visible=false;CrossA.Color=Aim.FOVColor;CrossB.Color=Aim.FOVColor
end

local function updateCrosshair()
    if not CrossA or not CrossB then return end
    local c=Frame.Center;local n=Aim.CrosshairSize
    CrossA.From=Vector2.new(c.X-n,c.Y);CrossA.To=Vector2.new(c.X+n,c.Y)
    CrossB.From=Vector2.new(c.X,c.Y-n);CrossB.To=Vector2.new(c.X,c.Y+n)
    CrossA.Color=Aim.FOVColor;CrossB.Color=Aim.FOVColor
    CrossA.Visible=Aim.Crosshair;CrossB.Visible=Aim.Crosshair
end

local currentTarget,lastSwitch=nil,0
local AimRayParams=RaycastParams.new()
AimRayParams.FilterType=Enum.RaycastFilterType.Exclude
AimRayParams.IgnoreWater=true

local function aimVisible(part)
    if not Aim.VisibleCheck then return true end
    local c=part and part.Parent
    if not c or not Camera then return false end
    local filter={}
    if LP.Character then filter[#filter+1]=LP.Character end
    if Camera then filter[#filter+1]=Camera end
    AimRayParams.FilterDescendantsInstances=filter
    local result=workspace:Raycast(Camera.CFrame.Position,part.Position-Camera.CFrame.Position,AimRayParams)
    return result and result.Instance and result.Instance:IsDescendantOf(c) or false
end

local function targetData(part)
    if not part or not part.Parent or not Camera then return nil end
    local c=part.Parent
    local plr=Players:GetPlayerFromCharacter(c)
    local h=c:FindFirstChildOfClass("Humanoid")
    if not h or h.Health<=0 then return nil end
    if Aim.TeamCheck and plr and plr.Team==LP.Team then return nil end
    local pos,onScreen=Camera:WorldToViewportPoint(part.Position)
    if not onScreen then return nil end
    local screenDistance=(Vector2.new(pos.X,pos.Y)-Frame.Center).Magnitude
    if screenDistance>Aim.FOV then return nil end
    if not aimVisible(part) then return nil end
    return {Part=part,Distance=screenDistance}
end

local function closestTarget()
    local best,bestDistance=nil,Aim.FOV
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP then
            local c=p.Character
            local part=c and c:FindFirstChild(Aim.TargetPart)
            local data=part and targetData(part)
            if data and data.Distance<bestDistance then bestDistance=data.Distance;best=part end
        end
    end
    return best
end

local function updateAim()
    if not Aim.Enabled then currentTarget=nil;return end
    local data=currentTarget and targetData(currentTarget) or nil
    if not data and Frame.Now-lastSwitch>=Aim.TargetSwitchDelay then
        currentTarget=closestTarget();lastSwitch=Frame.Now
        data=currentTarget and targetData(currentTarget) or nil
    end
    if data and Camera then
        local desired=CFrame.new(Camera.CFrame.Position,data.Part.Position)
        local smooth=Camera.CFrame:Lerp(desired,math.clamp(Aim.Smoothness,0,1))
        Camera.CFrame=Camera.CFrame:Lerp(smooth,math.clamp(Aim.Strength,0,1))
    end
end

local TrackedPlayers={}
local ESPObjects={}
local function removeESP(p)
    local d=ESPObjects[p]
    if not d then return end
    for _,o in pairs(d) do destroyObject(o) end
    ESPObjects[p]=nil
end
local function espValid(p)
    if p==LP then return false end
    local c=p.Character;local h=c and c:FindFirstChildOfClass("Humanoid");local r=c and c:FindFirstChild("HumanoidRootPart")
    if not c or not h or not r or h.Health<=0 or not Camera then return false end
    if EspC.TeamCheck and p.Team==LP.Team then return false end
    return (Camera.CFrame.Position-r.Position).Magnitude<=EspC.MaxDistance
end
local function espColor(p,rainbowColor)
    if EspC.Rainbow then return rainbowColor end
    if EspC.TeamColor and p and p.TeamColor then return p.TeamColor.Color end
    return EspC.Color
end
local function ensureESPBase(p)
    if not EspC.Enabled or not espValid(p) then removeESP(p);return nil end
    local c=p.Character;local r=c and c:FindFirstChild("HumanoidRootPart")
    local d=ESPObjects[p]
    if d and d.Character~=c then removeESP(p);d=nil end
    if not d then
        local hi=Runtime:AddInstance(Instance.new("Highlight"));hi.Name="MirrorsESP_Highlight";hi.Adornee=c;hi.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop;hi.Parent=c
        d={Character=c,Highlight=hi,Billboard=nil,Text=nil,Line=nil}
        ESPObjects[p]=d
    end
    local needsText=EspC.ShowNames or EspC.ShowHealth or EspC.ShowDistance
    if needsText and not d.Billboard then
        local bg=Runtime:AddInstance(Instance.new("BillboardGui"));bg.Name="MirrorsESP_Info";bg.Adornee=r;bg.Size=UDim2.new(0,220,0,80);bg.StudsOffset=Vector3.new(0,3.5,0);bg.AlwaysOnTop=true;bg.Parent=r
        local tx=Runtime:AddInstance(Instance.new("TextLabel"));tx.Size=UDim2.new(1,0,1,0);tx.BackgroundTransparency=1;tx.TextStrokeTransparency=0;tx.Font=Enum.Font.GothamBold;tx.Parent=bg
        d.Billboard=bg;d.Text=tx
    elseif not needsText and d.Billboard then
        destroyObject(d.Billboard);d.Billboard=nil;d.Text=nil
    end
    if EspC.ShowLines and HasDrawing and not d.Line then
        d.Line=Runtime:AddDrawing(Drawing.new("Line"));d.Line.Visible=false;d.Line.Thickness=1.5
    elseif not EspC.ShowLines and d.Line then
        destroyObject(d.Line);d.Line=nil
    end
    return d
end
local function clearESP()for p in pairs(ESPObjects)do removeESP(p)end end
local function refreshESP()clearESP();if EspC.Enabled then for p in pairs(TrackedPlayers)do ensureESPBase(p)end end end
local function updateESP()
    if not EspC.Enabled then return end
    local rainbowColor=Color3.fromHSV((os.clock()%5)/5,1,1)
    for p in pairs(TrackedPlayers) do
        local d=ensureESPBase(p)
        if d then
            local c=p.Character;local h=c and c:FindFirstChildOfClass("Humanoid");local r=c and c:FindFirstChild("HumanoidRootPart")
            if h and r then
                local cc=espColor(p,rainbowColor)
                d.Highlight.FillColor=cc;d.Highlight.OutlineColor=cc;d.Highlight.FillTransparency=EspC.Fill and EspC.FillTransparency or 1;d.Highlight.OutlineTransparency=EspC.OutlineTransparency
                if d.Text then
                    d.Text.TextColor3=cc;d.Text.TextSize=EspC.TextSize
                    local a={};local dst=math.floor((Camera.CFrame.Position-r.Position).Magnitude)
                    if EspC.ShowNames then a[#a+1]=p.Name end
                    if EspC.ShowHealth then a[#a+1]="HP: "..math.floor(h.Health).."/"..math.floor(h.MaxHealth) end
                    if EspC.ShowDistance then a[#a+1]=dst.." studs" end
                    d.Text.Text=table.concat(a,"\n")
                end
                if d.Line then
                    local pos,on=Camera:WorldToViewportPoint(r.Position);d.Line.Visible=on
                    if on then
                        local y=Camera.ViewportSize.Y
                        if EspC.TracerOrigin=="Top" then y=0 elseif EspC.TracerOrigin=="Middle" then y=Camera.ViewportSize.Y/2 end
                        d.Line.From=Vector2.new(Camera.ViewportSize.X/2,y);d.Line.To=Vector2.new(pos.X,pos.Y);d.Line.Color=cc
                    end
                end
            end
        end
    end
end

local HitBackup=setmetatable({}, {__mode="k"})
local function resetHit()
    for part,data in pairs(HitBackup) do
        if part and part.Parent then
            pcall(function()part.Size=data.Size;part.Transparency=data.Transparency;part.Color=data.Color;part.Material=data.Material;part.CanCollide=data.CanCollide end)
        end
    end
    HitBackup=setmetatable({}, {__mode="k"})
end
local function validHit(p)
    if p==LP or not p.Character then return false end
    local h=hum(p);if not h or h.Health<=0 then return false end
    if HitC.TeamCheck and p.Team==LP.Team then return false end
    return true
end
local function applyHit(p)
    if not HitC.Enabled or not validHit(p) then return end
    local part=root(p);if not part or not part:IsA("BasePart") then return end
    if not HitBackup[part] then HitBackup[part]={Size=part.Size,Transparency=part.Transparency,Color=part.Color,Material=part.Material,CanCollide=part.CanCollide} end
    local s=math.clamp(tonumber(HitC.Size) or 10,2,HitC.MaxSize or 200)
    local targetSize=Vector3.new(s,s,s)
    if part.Size~=targetSize then part.Size=targetSize end
    if part.Transparency~=HitC.Transparency then part.Transparency=HitC.Transparency end
    if part.Color~=HitC.Color then part.Color=HitC.Color end
    if part.Material~=Enum.Material.Neon then part.Material=Enum.Material.Neon end
    if part.CanCollide then part.CanCollide=false end
end
local function updateHit()
    if not HitC.Enabled then resetHit();return end
    for p in pairs(TrackedPlayers) do if validHit(p) then applyHit(p) end end
end

local MovementSnapshot=nil
local function captureMovement()
    local h=hum();if not h then return nil end
    if not MovementSnapshot or MovementSnapshot.Humanoid~=h then
        MovementSnapshot={Humanoid=h,WalkSpeed=h.WalkSpeed,UseJumpPower=h.UseJumpPower,JumpPower=h.JumpPower,JumpHeight=h.JumpHeight}
    end
    return MovementSnapshot
end
local function applyMovement()
    local h=hum();if not h then return end
    local snap=captureMovement()
    if MiscC.SpeedEnabled and h.WalkSpeed~=MiscC.WalkSpeed then h.WalkSpeed=MiscC.WalkSpeed end
    if MiscC.JumpEnabled then
        if not h.UseJumpPower then h.UseJumpPower=true end
        if h.JumpPower~=MiscC.JumpPower then h.JumpPower=MiscC.JumpPower end
    end
end
local function setSpeedEnabled(on)
    MiscC.SpeedEnabled=on and true or false
    local h=hum();local snap=captureMovement()
    if MiscC.SpeedEnabled then applyMovement()
    elseif h and snap and snap.Humanoid==h then h.WalkSpeed=snap.WalkSpeed end
end
local function setJumpEnabled(on)
    MiscC.JumpEnabled=on and true or false
    local h=hum();local snap=captureMovement()
    if MiscC.JumpEnabled then applyMovement()
    elseif h and snap and snap.Humanoid==h then
        h.UseJumpPower=snap.UseJumpPower;h.JumpPower=snap.JumpPower;h.JumpHeight=snap.JumpHeight
    end
end
local function restoreMovement()
    local h=hum();local snap=MovementSnapshot
    if h and snap and snap.Humanoid==h then
        pcall(function()h.WalkSpeed=snap.WalkSpeed;h.UseJumpPower=snap.UseJumpPower;h.JumpPower=snap.JumpPower;h.JumpHeight=snap.JumpHeight end)
    end
    MovementSnapshot=nil
end

local NoclipBackup=setmetatable({}, {__mode="k"})
local function restoreNoclipParts()
    for part,value in pairs(NoclipBackup) do if part and part.Parent then pcall(function()part.CanCollide=value end) end end
    NoclipBackup=setmetatable({}, {__mode="k"})
end
local function applyNoclipPart(part)
    if not MiscC.Noclip or not part:IsA("BasePart") then return end
    if NoclipBackup[part]==nil then NoclipBackup[part]=part.CanCollide end
    if part.CanCollide then part.CanCollide=false end
end
local function attachNoclipCharacter()
    Runtime:SetConnection("NoclipDescendant",nil)
    restoreNoclipParts()
    if not MiscC.Noclip then return end
    local c=char();if not c then return end
    for _,v in ipairs(c:GetDescendants()) do if v:IsA("BasePart") then applyNoclipPart(v) end end
    Runtime:SetConnection("NoclipDescendant",c.DescendantAdded:Connect(function(v)if Runtime.Alive and MiscC.Noclip and v:IsA("BasePart") then applyNoclipPart(v) end end))
end
local function setNoclip(on)
    MiscC.Noclip=on and true or false
    if MiscC.Noclip then attachNoclipCharacter()
    else Runtime:SetConnection("NoclipDescendant",nil);restoreNoclipParts() end
end

local FullbrightSnapshot=nil
local FogSnapshot=nil
local worldApplying=false
local function applyWorldVisuals()
    if worldApplying then return end
    worldApplying=true
    if MiscC.Fullbright then
        Lighting.Ambient=Color3.new(1,1,1);Lighting.ColorShift_Bottom=Color3.new(1,1,1);Lighting.ColorShift_Top=Color3.new(1,1,1);Lighting.Brightness=4;Lighting.ClockTime=14;Lighting.GlobalShadows=false
    end
    if MiscC.NoFog then Lighting.FogEnd=100000;Lighting.FogStart=0 end
    worldApplying=false
end
local function setFullbright(on)
    on=on and true or false
    if on and not FullbrightSnapshot then
        FullbrightSnapshot={Ambient=Lighting.Ambient,ColorShift_Bottom=Lighting.ColorShift_Bottom,ColorShift_Top=Lighting.ColorShift_Top,Brightness=Lighting.Brightness,ClockTime=Lighting.ClockTime,GlobalShadows=Lighting.GlobalShadows}
    end
    MiscC.Fullbright=on
    if on then applyWorldVisuals()
    elseif FullbrightSnapshot then
        worldApplying=true
        for k,v in pairs(FullbrightSnapshot) do pcall(function()Lighting[k]=v end) end
        worldApplying=false;FullbrightSnapshot=nil
        if MiscC.NoFog then applyWorldVisuals() end
    end
end
local function setNoFog(on)
    on=on and true or false
    if on and not FogSnapshot then FogSnapshot={FogEnd=Lighting.FogEnd,FogStart=Lighting.FogStart} end
    MiscC.NoFog=on
    if on then applyWorldVisuals()
    elseif FogSnapshot then
        worldApplying=true;Lighting.FogEnd=FogSnapshot.FogEnd;Lighting.FogStart=FogSnapshot.FogStart;worldApplying=false;FogSnapshot=nil
        if MiscC.Fullbright then applyWorldVisuals() end
    end
end
Runtime:AddConnection(Lighting.Changed:Connect(function()
    if Runtime.Alive and not worldApplying and (MiscC.Fullbright or MiscC.NoFog) then task.defer(applyWorldVisuals) end
end))

local function antiVoidGuard()
    if not MiscC.AntiVoid then return end
    local r=root();local h=hum();if not r or not h then return end
    local threshold=workspace.FallenPartsDestroyHeight
    local danger=threshold+50
    if r.Position.Y>danger then
        if h.FloorMaterial~=Enum.Material.Air then lastSafePosition=r.CFrame end
    elseif r.Position.Y<=threshold+20 then
        r.AssemblyLinearVelocity=Vector3.zero
        if lastSafePosition then r.CFrame=lastSafePosition else r.CFrame=r.CFrame+Vector3.new(0,150,0) end
    end
end

local Frozen=setmetatable({}, {__mode="k"})
local SelectedFrozenPlayer=nil
local function ensureFreezeData(p)
    local r=root(p);local h=hum(p);local c=char(p)
    if not r or not h or not c then return nil end
    local data=Frozen[p]
    if not data or data.Character~=c then
        data={Character=c,Root=r,Humanoid=h,Anchored=r.Anchored,WalkSpeed=h.WalkSpeed,UseJumpPower=h.UseJumpPower,JumpPower=h.JumpPower,JumpHeight=h.JumpHeight,Reasons={}}
        Frozen[p]=data
    end
    return data
end
local function applyFrozenData(data)
    local r=data.Root;local h=data.Humanoid
    if r and r.Parent then r.Anchored=true;r.AssemblyLinearVelocity=Vector3.zero;r.AssemblyAngularVelocity=Vector3.zero end
    if h and h.Parent then h.WalkSpeed=0;h.UseJumpPower=true;h.JumpPower=0 end
end
local function freezePlayer(p,reason)
    if not p or p==LP then return end
    local data=ensureFreezeData(p);if not data then return end
    data.Reasons[reason or "Manual"]=true
    applyFrozenData(data)
end
local function unfreezeReason(p,reason)
    local data=Frozen[p];if not data then return end
    data.Reasons[reason]=nil
    if next(data.Reasons) then return end
    local r=data.Root;local h=data.Humanoid
    if r and r.Parent then r.Anchored=data.Anchored end
    if h and h.Parent then h.WalkSpeed=data.WalkSpeed;h.UseJumpPower=data.UseJumpPower;h.JumpPower=data.JumpPower;h.JumpHeight=data.JumpHeight end
    Frozen[p]=nil
end
local function unfreezePlayer(p)
    local data=Frozen[p];if not data then return end
    data.Reasons={}
    local r=data.Root;local h=data.Humanoid
    if r and r.Parent then r.Anchored=data.Anchored end
    if h and h.Parent then h.WalkSpeed=data.WalkSpeed;h.UseJumpPower=data.UseJumpPower;h.JumpPower=data.JumpPower;h.JumpHeight=data.JumpHeight end
    Frozen[p]=nil
end
local function unfreezeAll()for p in pairs(Frozen)do unfreezePlayer(p)end end
local function setFreezeSelected(on)
    on=on and true or false
    if not on and SelectedFrozenPlayer then unfreezeReason(SelectedFrozenPlayer,"Selected") end
    OpC.FreezeSelected=on
    SelectedFrozenPlayer=nil
    if on then
        local p=getOPSelected()
        if p then SelectedFrozenPlayer=p;freezePlayer(p,"Selected") else notify(L("NoPlayer"),"x",2) end
    end
end
local function setFreezeAll(on)
    on=on and true or false
    OpC.FreezeAll=on
    if on then for p in pairs(TrackedPlayers)do freezePlayer(p,"All")end
    else for p in pairs(Frozen)do unfreezeReason(p,"All")end end
end

local FakeDeathState={Active=false,Character=nil,Humanoid=nil,Root=nil,PlatformStand=nil,RootJoint=nil,RootJointC0=nil}
local function findRootJoint(c,r)
    local torso=c and (c:FindFirstChild("Torso") or c:FindFirstChild("UpperTorso"))
    return (r and r:FindFirstChild("RootJoint")) or (torso and torso:FindFirstChild("RootJoint"))
end
local function setFakeDeath(on)
    on=on and true or false
    if on then
        local h=hum();local r=root();local c=char();if not h or not r or not c then return end
        if not FakeDeathState.Active or FakeDeathState.Character~=c then
            local joint=findRootJoint(c,r)
            FakeDeathState={Active=true,Character=c,Humanoid=h,Root=r,PlatformStand=h.PlatformStand,RootJoint=joint,RootJointC0=joint and joint.C0 or nil}
        end
        TrollC.FakeDeath=true
        h.PlatformStand=true
        r.AssemblyLinearVelocity=Vector3.new(math.random(-25,25),55,math.random(-25,25));r.AssemblyAngularVelocity=Vector3.new(25,35,25)
        if FakeDeathState.RootJoint and FakeDeathState.RootJoint.Parent and FakeDeathState.RootJointC0 then FakeDeathState.RootJoint.C0=FakeDeathState.RootJointC0*CFrame.Angles(math.rad(90),0,0) end
    else
        TrollC.FakeDeath=false
        local state=FakeDeathState
        if state.Active then
            if state.Humanoid and state.Humanoid.Parent then
                state.Humanoid.PlatformStand=state.PlatformStand
                pcall(function()state.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp,true);state.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)end)
            end
            if state.RootJoint and state.RootJoint.Parent and state.RootJointC0 then state.RootJoint.C0=state.RootJointC0 end
            if state.Root and state.Root.Parent then state.Root.AssemblyLinearVelocity=Vector3.zero;state.Root.AssemblyAngularVelocity=Vector3.zero end
        end
        FakeDeathState={Active=false,Character=nil,Humanoid=nil,Root=nil,PlatformStand=nil,RootJoint=nil,RootJointC0=nil}
    end
end

local LagState={Timer=0,Holding=false,Character=nil,Root=nil,Anchored=nil}
local function releaseFakeLagHold()
    local s=LagState
    if s.Holding and s.Root and s.Root.Parent and s.Character==char() then s.Root.Anchored=s.Anchored end
    s.Holding=false;s.Character=nil;s.Root=nil;s.Anchored=nil
end
local function stopFakeLag()
    TrollC.FakeLag=false
    Runtime:NewToken("FakeLagHold")
    releaseFakeLagHold();LagState.Timer=0
end
local function fakeLag(dt)
    if not TrollC.FakeLag or LagState.Holding then return end
    LagState.Timer=LagState.Timer+dt
    if LagState.Timer<math.max(TrollC.FakeLagRate,.12) then return end
    LagState.Timer=0
    local c=char();local r=root();if not c or not r then return end
    LagState.Holding=true;LagState.Character=c;LagState.Root=r;LagState.Anchored=r.Anchored;r.Anchored=true
    Runtime:Delay("FakeLagHold",math.clamp(TrollC.FakeLagHold,.03,.14),function()
        if LagState.Character==char() then releaseFakeLagHold() else LagState.Holding=false end
    end)
end

local function stopHeadSit()
    local r=root();local h=hum()
    if h then h.Sit=false;h.PlatformStand=false;pcall(function()h:ChangeState(Enum.HumanoidStateType.GettingUp)end) end
    if r then r.AssemblyLinearVelocity=Vector3.zero;r.AssemblyAngularVelocity=Vector3.zero end
end
local function updateHeadSit()
    if not TrollC.HeadSit then return end
    local p=getTrollSelected();local r=root();local tr=p and root(p);local h=hum()
    if not r or not tr then return end
    r.AssemblyLinearVelocity=Vector3.zero;r.AssemblyAngularVelocity=Vector3.zero;r.CFrame=tr.CFrame*CFrame.new(0,3.15,0)
    if h then h.Sit=true end
end

local orbitA=0
local function updateSpin(dt)
    if not TrollC.Spin then return end
    local r=root();if r then r.CFrame=r.CFrame*CFrame.Angles(0,math.rad(TrollC.SpinSpeed)*dt*12,0) end
end
local function updateOrbit(dt)
    if not TrollC.Orbit then return end
    local p=getTrollSelected();local r=root();local tr=p and root(p);if not r or not tr then return end
    orbitA=orbitA+dt*TrollC.OrbitSpeed
    local rad,ht=TrollC.OrbitRadius,TrollC.OrbitHeight
    local off
    if TrollC.OrbitMode=="UpDown" then off=Vector3.new(math.cos(orbitA)*rad,ht+math.sin(orbitA*2)*rad,math.sin(orbitA)*rad)
    elseif TrollC.OrbitMode=="LeftRight" then off=Vector3.new(math.sin(orbitA)*rad,ht,0)
    elseif TrollC.OrbitMode=="Diagonal" then off=Vector3.new(math.cos(orbitA)*rad,ht+math.cos(orbitA)*rad,math.sin(orbitA)*rad)
    else off=Vector3.new(math.cos(orbitA)*rad,ht,math.sin(orbitA)*rad) end
    r.CFrame=CFrame.new(tr.Position+off,tr.Position)
end

local Ghosts={}
local MAX_GHOSTS=18
local function trimGhosts()
    while #Ghosts>MAX_GHOSTS do local old=table.remove(Ghosts,1);destroyObject(old) end
end
local function ghost()
    if not TrollC.Ghost then return end
    local r=root();if not r then return end
    local p=Runtime:AddInstance(Instance.new("Part"));p.Name="MirrorsGhost";p.Anchored=true;p.CanCollide=false;p.CanQuery=false;p.Transparency=.72;p.Size=Vector3.new(2,2.8,1);p.CFrame=r.CFrame;p.Material=Enum.Material.Neon;p.Parent=workspace
    Ghosts[#Ghosts+1]=p;trimGhosts()
    task.delay(.45,function()if Runtime.Alive and p and p.Parent then p:Destroy()end end)
end
local annoyT=0
local function updateAnnoy(dt)
    if not TrollC.Annoy then return end
    annoyT=annoyT+dt;if annoyT<TrollC.AnnoySpeed then return end;annoyT=0
    local p=getTrollSelected();local r=root();local tr=p and root(p);if not r or not tr then return end
    local off
    if TrollC.AnnoyMode=="Cross" then local a={Vector3.new(4,1.5,0),Vector3.new(-4,1.5,0),Vector3.new(0,1.5,4),Vector3.new(0,1.5,-4)};off=a[(math.floor(os.clock()*8)%4)+1]
    elseif TrollC.AnnoyMode=="Random" then off=Vector3.new(math.random(-5,5),math.random(1,5),math.random(-5,5))
    else off=Vector3.new(math.cos(os.clock()*12)*4,1.5,math.sin(os.clock()*12)*4) end
    r.CFrame=CFrame.new(tr.Position+off,tr.Position);ghost()
end

local GodState=nil
local GodSync=false
local function restoreGod()
    local s=GodState
    if s then
        local h=s.Humanoid
        if h and h.Parent then
            pcall(function()h.BreakJointsOnDeath=s.BreakJointsOnDeath;h.RequiresNeck=s.RequiresNeck;h.MaxHealth=s.MaxHealth;h.Health=math.min(s.Health,s.MaxHealth)end)
        end
        if s.ForceField and s.ForceField.Parent then s.ForceField:Destroy() end
    end
    GodState=nil
end
local function captureGod()
    local h=hum();local c=char();if not h or not c then return nil end
    if not GodState or GodState.Humanoid~=h then
        restoreGod()
        GodState={Humanoid=h,Character=c,BreakJointsOnDeath=h.BreakJointsOnDeath,RequiresNeck=h.RequiresNeck,MaxHealth=h.MaxHealth,Health=h.Health,ForceField=nil}
    end
    return GodState
end
local function applyGod()
    if not OpC.GodInf and not OpC.God100 then return end
    local s=captureGod();if not s then return end
    local h=s.Humanoid;local c=s.Character
    if OpC.GodInf then
        h.BreakJointsOnDeath=false;pcall(function()h.RequiresNeck=false end);h.MaxHealth=math.huge;h.Health=math.huge
        if not s.ForceField or not s.ForceField.Parent then local ff=Runtime:AddInstance(Instance.new("ForceField"));ff.Name="MirrorsFF";ff.Visible=false;ff.Parent=c;s.ForceField=ff end
    elseif OpC.God100 then
        if h.MaxHealth<100 then h.MaxHealth=100 end;if h.Health<100 then h.Health=100 end
    end
end
local function setControl(flag,value)
    local c=Controls[flag];if not c then return end
    SyncingControls=true
    pcall(function()if c.Set then c:Set(value) elseif c.Select then c:Select(value) end end)
    SyncingControls=false
end
local function setGodMode(mode)
    if mode=="INF" then OpC.GodInf=true;OpC.God100=false
    elseif mode=="100" then OpC.God100=true;OpC.GodInf=false
    else OpC.God100=false;OpC.GodInf=false end
    if not GodSync then
        GodSync=true;setControl("universal_op_god100",OpC.God100);setControl("universal_op_godinf",OpC.GodInf);GodSync=false
    end
    if OpC.God100 or OpC.GodInf then applyGod() else restoreGod() end
end

local AntiFlingBackup=setmetatable({}, {__mode="k"})
local function applyAntiFlingToPlayer(p)
    if not OpC.AntiFling or not p or p==LP then return end
    local r=root(p);if not r then return end
    if AntiFlingBackup[r]==nil then AntiFlingBackup[r]=r.CanCollide end
    if r.CanCollide then r.CanCollide=false end
end
local function restoreAntiFling()
    for part,value in pairs(AntiFlingBackup) do if part and part.Parent then pcall(function()part.CanCollide=value end) end end
    AntiFlingBackup=setmetatable({}, {__mode="k"})
end
local function setAntiFling(on)
    OpC.AntiFling=on and true or false
    if OpC.AntiFling then for p in pairs(TrackedPlayers)do applyAntiFlingToPlayer(p)end else restoreAntiFling() end
end

local flingRun=false
local function stopFling()
    flingRun=false;OpC.TouchFling=false;Runtime:NewToken("TouchFling")
    task.defer(function()
        local r=root();local h=hum()
        if r and r.Parent then r.AssemblyLinearVelocity=Vector3.zero;r.AssemblyAngularVelocity=Vector3.zero;r.Velocity=Vector3.zero;r.RotVelocity=Vector3.zero end
        if h then h.PlatformStand=false;h.Sit=false end
    end)
end
local function startFling()
    if flingRun then return end
    flingRun=true;OpC.TouchFling=true
    Runtime:Spawn("TouchFling",function(token)
        local movel=.1
        while flingRun and Runtime:IsTokenCurrent("TouchFling",token) do
            RunService.Heartbeat:Wait()
            if not flingRun or not Runtime:IsTokenCurrent("TouchFling",token) then break end
            local r=root();local h=hum()
            if r and h and h.Health>0 then
                local vel=r.Velocity;local jumpY=vel.Y
                r.Velocity=vel*OpC.FlingPower+Vector3.new(0,OpC.FlingPower,0)
                RunService.RenderStepped:Wait()
                if not flingRun or not Runtime:IsTokenCurrent("TouchFling",token) then break end
                if r and r.Parent then r.Velocity=Vector3.new(vel.X,jumpY,vel.Z) end
                RunService.Stepped:Wait()
                if r and r.Parent then r.Velocity=Vector3.new(vel.X,jumpY,vel.Z)+Vector3.new(0,movel+OpC.FlingPulse,0) end
                movel=-movel
            end
        end
    end)
end

local function tpToPlayer()
    local p=getOPSelected();local r=root();local tr=p and root(p)
    if not p or not r or not tr then notify(L("NoPlayer"),"x",3);return end
    LastTeleportCF=r.CFrame;r.CFrame=tr.CFrame*CFrame.new(0,0,3);notify(L("Teleported"),"map-pin",2)
end
local function bringPlayer()
    local p=getOPSelected();local r=root();local tr=p and root(p)
    if not p or not r or not tr then notify(L("NoPlayer"),"x",3);return end
    tr.CFrame=r.CFrame*CFrame.new(0,0,-4);tr.AssemblyLinearVelocity=Vector3.zero
end
local function spectatePlayer()
    local p=getOPSelected();local h=p and hum(p);if not h then notify(L("NoPlayer"),"x",3);return end
    Camera=workspace.CurrentCamera or Camera;if Camera then Camera.CameraSubject=h end
end
local function unspectate()
    Camera=workspace.CurrentCamera or Camera;local h=hum();if Camera and h then Camera.CameraSubject=h end
end
local function teleportBack()local r=root();if r and LastTeleportCF then r.CFrame=LastTeleportCF end end

local Performance={Enabled=false,Backup=setmetatable({}, {__mode="k"}),Terrain=nil}
local function protectedPerformanceObject(v)
    if not v or v==workspace.Terrain then return true end
    if Camera and (v==Camera or v:IsDescendantOf(Camera)) then return true end
    if v:FindFirstAncestorWhichIsA("Tool") then return true end
    local model=v:FindFirstAncestorOfClass("Model")
    if model and Players:GetPlayerFromCharacter(model) then return true end
    if LP:FindFirstChildOfClass("Backpack") and v:IsDescendantOf(LP.Backpack) then return true end
    return false
end
local function backupPerf(v,data)
    if not Performance.Backup[v] then Performance.Backup[v]=data end
end
local function applyPerformanceObject(v)
    if not Performance.Enabled or not v or not v.Parent or protectedPerformanceObject(v) then return end
    if v:IsA("BasePart") then
        backupPerf(v,{Kind="BasePart",Material=v.Material,Reflectance=v.Reflectance,CastShadow=v.CastShadow})
        v.Material=Enum.Material.Plastic;v.Reflectance=0;v.CastShadow=false
    elseif v:IsA("Decal") or v:IsA("Texture") then
        backupPerf(v,{Kind="Transparency",Transparency=v.Transparency});v.Transparency=1
    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
        backupPerf(v,{Kind="Enabled",Enabled=v.Enabled});v.Enabled=false
    elseif v:IsA("PointLight") or v:IsA("SpotLight") or v:IsA("SurfaceLight") then
        backupPerf(v,{Kind="Enabled",Enabled=v.Enabled});v.Enabled=false
    elseif v:IsA("Explosion") then
        backupPerf(v,{Kind="Explosion",Visible=v.Visible});v.Visible=false
    end
end
local function restorePerformance()
    Runtime:NewToken("PerformanceBatch")
    Runtime:SetConnection("PerformanceDescendant",nil)
    for v,data in pairs(Performance.Backup) do
        if v and v.Parent then
            pcall(function()
                if data.Kind=="BasePart" then v.Material=data.Material;v.Reflectance=data.Reflectance;v.CastShadow=data.CastShadow
                elseif data.Kind=="Transparency" then v.Transparency=data.Transparency
                elseif data.Kind=="Enabled" then v.Enabled=data.Enabled
                elseif data.Kind=="Explosion" then v.Visible=data.Visible end
            end)
        end
    end
    Performance.Backup=setmetatable({}, {__mode="k"})
    if Performance.Terrain then
        local t=workspace.Terrain;local d=Performance.Terrain
        pcall(function()t.WaterWaveSize=d.WaterWaveSize;t.WaterWaveSpeed=d.WaterWaveSpeed;t.WaterReflectance=d.WaterReflectance;t.WaterTransparency=d.WaterTransparency end)
        Performance.Terrain=nil
    end
end
local function setPerformanceMode(on)
    on=on and true or false
    if on==Performance.Enabled then return end
    Performance.Enabled=on;MiscC.Performance=on
    if on then
        local t=workspace.Terrain
        Performance.Terrain={WaterWaveSize=t.WaterWaveSize,WaterWaveSpeed=t.WaterWaveSpeed,WaterReflectance=t.WaterReflectance,WaterTransparency=t.WaterTransparency}
        pcall(function()t.WaterWaveSize=0;t.WaterWaveSpeed=0;t.WaterReflectance=0;t.WaterTransparency=1 end)
        Runtime:SetConnection("PerformanceDescendant",workspace.DescendantAdded:Connect(function(v)if Runtime.Alive and Performance.Enabled then applyPerformanceObject(v) end end))
        Runtime:Spawn("PerformanceBatch",function(token)
            local all=workspace:GetDescendants()
            for i,v in ipairs(all) do
                if not Runtime:IsTokenCurrent("PerformanceBatch",token) or not Performance.Enabled then return end
                applyPerformanceObject(v)
                if i%200==0 then task.wait() end
            end
        end)
        notify(L("PerformanceApplied"),"zap",3)
    else
        restorePerformance();notify(L("PerformanceRestored"),"rotate-ccw",3)
    end
end

local function getServer(small)
    local cursor,best,candidates=nil,nil,{}
    for _=1,10 do
        local url="https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100&excludeFullGames=true"..(cursor and "&cursor="..Http:UrlEncode(cursor) or "")
        local ok,data=pcall(function()return Http:JSONDecode(game:HttpGet(url))end)
        if not ok or not data or not data.data then break end
        for _,v in ipairs(data.data) do
            if v.id and v.id~=game.JobId and v.playing and v.maxPlayers and v.playing<v.maxPlayers then
                if small then if v.playing<5 and (not best or v.playing<best.playing) then best=v end else candidates[#candidates+1]=v end
            end
        end
        if small and best then break end
        cursor=data.nextPageCursor;if not cursor or (not small and #candidates>=60) then break end
    end
    if small then return best end
    if #candidates>0 then return candidates[math.random(1,#candidates)] end
end
local function hop()local s=getServer(false);if s then TP:TeleportToPlaceInstance(game.PlaceId,s.id,LP)else notify(L("NoServer"),"x",3)end end
local function smallServer()local s=getServer(true);if s then TP:TeleportToPlaceInstance(game.PlaceId,s.id,LP)else notify(L("NoServer"),"x",3)end end
local function joinJob()if JobInput and #JobInput>5 then TP:TeleportToPlaceInstance(game.PlaceId,JobInput,LP)end end
local function copyJob()if type(setclipboard)=="function" then setclipboard(game.JobId);notify(L("Copied"),"copy",2)else notify(game.JobId,"copy",5)end end

local function encodeValue(v,seen)
    seen=seen or {}
    local tv=typeof(v)
    if tv=="Color3" then return {__type="Color3",r=v.R,g=v.G,b=v.B}
    elseif tv=="Vector3" then return {__type="Vector3",x=v.X,y=v.Y,z=v.Z}
    elseif tv=="EnumItem" then return {__type="EnumItem",value=tostring(v)}
    elseif type(v)=="table" then
        if seen[v] then return nil end;seen[v]=true
        local out={};for k,val in pairs(v)do out[k]=encodeValue(val,seen)end;seen[v]=nil;return out
    end
    return v
end
local function decodeValue(v)
    if type(v)~="table" then return v end
    if v.__type=="Color3" then return Color3.new(tonumber(v.r) or 0,tonumber(v.g) or 0,tonumber(v.b) or 0) end
    if v.__type=="Vector3" then return Vector3.new(tonumber(v.x) or 0,tonumber(v.y) or 0,tonumber(v.z) or 0) end
    local out={};for k,val in pairs(v)do if k~="__type" then out[k]=decodeValue(val) end end;return out
end
local function currentConfig()
    return encodeValue({Aim=Aim,EspC=EspC,MiscC=MiscC,HitC=HitC,OpC=OpC,TrollC=TrollC,Lang=Lang,ProfileName=ProfileName,AutoSave=AutoSave,AutoLoadConfig=AutoLoadConfig,NotifyOn=NotifyOn,ThemeName=ThemeName,UIScaleValue=UIScaleValue,BackgroundTransparencyValue=BackgroundTransparencyValue})
end
local syncAllControls
local applyAllFeatureState
local function mergeTable(dst,src)if type(src)=="table" then for k,v in pairs(src)do dst[k]=v end end end
local function applyConfig(data)
    data=decodeValue(data);if type(data)~="table" then return false end
    mergeTable(Aim,data.Aim);mergeTable(EspC,data.EspC);mergeTable(MiscC,data.MiscC);mergeTable(HitC,data.HitC);mergeTable(OpC,data.OpC);mergeTable(TrollC,data.TrollC)
    if data.Lang and TXT[data.Lang] then saveLang(data.Lang) end
    if data.ProfileName then ProfileName=tostring(data.ProfileName) end
    if data.AutoSave~=nil then AutoSave=data.AutoSave and true or false end
    if data.AutoLoadConfig~=nil then AutoLoadConfig=data.AutoLoadConfig and true or false end
    if data.NotifyOn~=nil then NotifyOn=data.NotifyOn and true or false end
    ThemeName=tostring(data.ThemeName or ThemeName);UIScaleValue=tonumber(data.UIScaleValue) or UIScaleValue;BackgroundTransparencyValue=tonumber(data.BackgroundTransparencyValue) or BackgroundTransparencyValue
    if applyAllFeatureState then applyAllFeatureState() end
    if syncAllControls then syncAllControls() end
    saveStartupMeta()
    return true
end
local function exportConfig()
    local ok,raw=pcall(function()return Http:JSONEncode(currentConfig())end)
    if not ok then notify("Export failed: "..tostring(raw),"x",4);return end
    if type(setclipboard)=="function" then setclipboard(raw);notify(L("Copied"),"copy",2)else notify(raw,"copy",8)end
end
local function importConfig()
    if type(getclipboard)~="function" then notify(L("NotConfigured"),"x",3);return end
    local ok,data=pcall(function()return Http:JSONDecode(getclipboard())end)
    if ok and applyConfig(data) then notify(L("LoadedConfig"),"folder-open",2) else notify("Invalid config.","x",3) end
end

local function sanitizeProfileName(name)
    local n=tostring(name or "default"):gsub("[^%w_%-%s]",""):gsub("%s+","_")
    return n~="" and n or "default"
end
local function getConfigObject()
    if not ConfigManager or not ConfigManager.CreateConfig then return nil end
    return ConfigManager:CreateConfig(sanitizeProfileName(ProfileName))
end
local saveActiveConfig
saveActiveConfig=function(silent)
    local cfg=getConfigObject();if not cfg or not cfg.Save then if not silent then notify(L("ConfigNotFound"),"x",3)end;return false end
    local ok,err=pcall(function()cfg:Save()end)
    if ok then ConfigDirty=false;if not silent then notify(L("Saved"),"save",3)end;return true end
    if not silent then notify("Save failed: "..tostring(err),"x",4)end;return false
end
local function loadActiveConfig(silent)
    local cfg=getConfigObject();if not cfg or not cfg.Load then if not silent then notify(L("ConfigNotFound"),"x",3)end;return false end
    local ok,err=pcall(function()cfg:Load()end)
    if ok then
        task.defer(function()if Runtime.Alive then if applyAllFeatureState then applyAllFeatureState() end;if syncAllControls then syncAllControls() end end end)
        if not silent then notify(L("LoadedConfig"),"folder-open",3)end
        return true
    end
    if not silent then notify("Load failed: "..tostring(err),"x",4)end
    return false
end
local function markConfigDirty()
    if booting or SyncingControls then return end
    ConfigDirty=true
    if not AutoSave then return end
    Runtime:Delay("AutoSaveDebounce",1.5,function()if ConfigDirty and AutoSave then saveActiveConfig(true) end end)
end

local function registerControl(flag,control)if flag and control then Controls[flag]=control end;return control end
local function section(tab,key)tab:Section({Title=L(key),Box=false,TextSize=17}) end
local function para(tab,title,desc,color)return tab:Paragraph({Title=title,Desc=desc,Color=color or "Blue",Locked=false}) end
local function btn(tab,key,cb)return tab:Button({Title=L(key),Desc="",Locked=false,Callback=cb}) end
local function btnTitle(tab,title,cb)return tab:Button({Title=title,Desc="",Locked=false,Callback=cb}) end
local function tog(tab,key,flag,val,cb)
    local c=tab:Toggle({Title=L(key),Desc="",Flag=flag,Type="Checkbox",Value=val,Callback=function(v)if cb then cb(v)end;markConfigDirty()end})
    return registerControl(flag,c)
end
local function slid(tab,key,flag,min,max,def,step,cb)
    local c=tab:Slider({Title=L(key),Desc="",Flag=flag,Step=step or 1,Value={Min=min,Max=max,Default=def},Callback=function(v)if cb then cb(v)end;markConfigDirty()end})
    return registerControl(flag,c)
end
local function drop(tab,key,flag,vals,val,cb)
    local c=tab:Dropdown({Title=L(key),Desc="",Flag=flag,Values=vals,Value=val,Callback=function(v)if type(v)=="table" then v=v.Value or v.Title or v[1] end;if cb then cb(v)end;markConfigDirty()end})
    return registerControl(flag,c)
end
local function col(tab,key,flag,def,cb)
    local c=tab:Colorpicker({Title=L(key),Desc="",Flag=flag,Default=def,Transparency=0,Locked=false,Callback=function(v)if cb then cb(v)end;markConfigDirty()end})
    return registerControl(flag,c)
end
local function input(tab,key,flag,ph,cb)
    local c=tab:Input({Title=L(key),Placeholder=ph or "",Flag=flag,Callback=function(v)if cb then cb(v)end;markConfigDirty()end})
    return registerControl(flag,c)
end

local function getThemeNames()
    local names={"Mirrors Purple","Midnight","Dark"}
    if WindUI.GetThemes then
        local ok,t=pcall(function()return WindUI:GetThemes()end)
        if ok and type(t)=="table" then
            names={};for name in pairs(t)do names[#names+1]=name end
            if not table.find(names,"Mirrors Purple") then names[#names+1]="Mirrors Purple" end
            table.sort(names)
        end
    end
    return names
end

local function niceTime(sec)
    sec=math.max(0,math.floor(tonumber(sec) or 0));local d=math.floor(sec/86400);sec=sec%86400;local h=math.floor(sec/3600);sec=sec%3600;local m=math.floor(sec/60);local s=sec%60
    if d>0 then return string.format("%dd %02dh %02dm %02ds",d,h,m,s) end
    if h>0 then return string.format("%02dh %02dm %02ds",h,m,s) end
    return string.format("%02dm %02ds",m,s)
end
local function shortId(v)v=tostring(v or "");return #v>18 and (v:sub(1,8).."..."..v:sub(-6)) or v end
local function getPingText()
    local ok,p=pcall(function()local item=Stats.Network.ServerStatsItem["Data Ping"];return item and item:GetValueString() or "N/A" end)
    return ok and tostring(p) or "N/A"
end
local ServerStart=os.clock()
local function serverAge()return workspace.DistributedGameTime and workspace.DistributedGameTime>0 and workspace.DistributedGameTime or os.clock()-ServerStart end
local function playerPositionText()local r=root();return r and (math.floor(r.Position.X)..", "..math.floor(r.Position.Y)..", "..math.floor(r.Position.Z)) or "N/A" end
local CurrentFPS=0
local function serverInfoText()
    return table.concat({L("ServerPlayers")..": "..#Players:GetPlayers().."/"..Players.MaxPlayers,L("ServerTime")..": "..niceTime(serverAge()),"FPS: "..tostring(CurrentFPS),"Ping: "..getPingText(),"PlaceId: "..tostring(game.PlaceId),"JobId: "..shortId(game.JobId),"GameId: "..tostring(game.GameId),"Gravity: "..tostring(math.floor(workspace.Gravity)),"Executor: "..GetExecutor(),"Executor FS: "..(fs() and L("Yes") or L("No")),"Config: "..sanitizeProfileName(ProfileName),"Language: "..Lang,"Theme: "..ThemeName,"UI Scale: "..string.format("%.2f",UIScaleValue),"Key: "..tostring(KeyInfo.Status).." | "..FormatProvider(KeyInfo.Provider).." | "..RemainingTime(KeyInfo.ExpiresAt)},"\n")
end
local function playerInfoText()
    local h=hum();return table.concat({"Name: "..LP.Name,"UserId: "..tostring(LP.UserId),L("AccountAge")..": "..tostring(LP.AccountAge).." "..L("Days"),L("Team")..": "..(LP.Team and LP.Team.Name or L("None")),L("Health")..": "..(h and (math.floor(h.Health).."/"..math.floor(h.MaxHealth)) or "N/A"),L("Position")..": "..playerPositionText()},"\n")
end
local function copyServerInfo()
    local txt="Mirrors Hub - Status\n"..serverInfoText().."\n\n"..L("PlayerInfo").."\n"..playerInfoText()
    if type(setclipboard)=="function" then setclipboard(txt);notify(L("Copied"),"copy",2)else notify(txt,"info",8)end
end

local DISCORD_LINK="https://discord.gg/YZEg6FyRSF"
local function copyDiscord()if type(setclipboard)=="function" then setclipboard(DISCORD_LINK);notify(L("Copied"),"copy",2)else notify(DISCORD_LINK,"copy",8)end end
local function runExternal(src)
    notify("External script: EXTERNAL_SCRIPT_UNMANAGED","triangle-alert",3)
    local ok,err=pcall(function()loadstring(game:HttpGet(src,true))()end)
    if not ok then notify(tostring(err),"x",4)end
end


--==================================================
-- UI BUILD
--==================================================

section(Tabs.Info,"Info")
para(Tabs.Info,L("HomeTitle"),L("HomeDesc"),"Blue")
para(Tabs.Info,L("BetaTitle"),L("BetaDesc"),"Orange")
para(Tabs.Info,L("DiscordTitle"),L("DiscordDesc").."\n"..DISCORD_LINK,"Red")
para(Tabs.Info,L("StatusTitle"),"Build: 1.6 Production\nWindUI: 1.6.66 pinned","Green")
local KeyParagraph=para(Tabs.Info,L("KeyInformation"),"Loading...","Blue")
btn(Tabs.Info,"CopyDiscord",copyDiscord)

section(Tabs.Scripts,"Scripts")
btnTitle(Tabs.Scripts,"Infinite Yield FE",function()runExternal("https://raw.githubusercontent.com/DarkNetworks/Infinite-Yield/main/latest.lua")end)
btnTitle(Tabs.Scripts,"Fly V3",function()runExternal("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt")end)
btnTitle(Tabs.Scripts,"Noclip",function()runExternal("https://rawscripts.net/raw/Universal-Script-Noclip-Open-source-10442")end)
btnTitle(Tabs.Scripts,"Touch Fling",function()runExternal("https://pastebin.com/raw/LgZwZ7ZB")end)

section(Tabs.Aimbot,"Main")
tog(Tabs.Aimbot,"EnableAimbot","universal_aim_enabled",Aim.Enabled,function(v)Aim.Enabled=v;if not v then currentTarget=nil end end)
tog(Tabs.Aimbot,"TeamCheck","universal_aim_teamcheck",Aim.TeamCheck,function(v)Aim.TeamCheck=v;currentTarget=nil end)
tog(Tabs.Aimbot,"VisibleCheck","universal_aim_visiblecheck",Aim.VisibleCheck,function(v)Aim.VisibleCheck=v;currentTarget=nil end)
drop(Tabs.Aimbot,"TargetPart","universal_aim_targetpart",{"Head","HumanoidRootPart"},Aim.TargetPart,function(v)Aim.TargetPart=v or "Head";currentTarget=nil end)
section(Tabs.Aimbot,"FOV")
slid(Tabs.Aimbot,"AimbotFOV","universal_aim_fov",10,500,Aim.FOV,1,function(v)Aim.FOV=v end)
tog(Tabs.Aimbot,"ShowFOV","universal_aim_showfov",Aim.FOVVisible,function(v)Aim.FOVVisible=v end)
col(Tabs.Aimbot,"FOVColor","universal_aim_fovcolor",Aim.FOVColor,function(v)Aim.FOVColor=v end)
tog(Tabs.Aimbot,"Crosshair","universal_aim_crosshair",Aim.Crosshair,function(v)Aim.Crosshair=v end)
slid(Tabs.Aimbot,"CrosshairSize","universal_aim_crosshairsize",4,30,Aim.CrosshairSize,1,function(v)Aim.CrosshairSize=v end)
section(Tabs.Aimbot,"Tuning")
slid(Tabs.Aimbot,"Smoothness","universal_aim_smoothness",1,100,math.floor(Aim.Smoothness*388+.5),1,function(v)Aim.Smoothness=v/388 end)
slid(Tabs.Aimbot,"Strength","universal_aim_strength",1,100,math.floor(Aim.Strength*100+.5),1,function(v)Aim.Strength=v/100 end)
slid(Tabs.Aimbot,"SwitchDelay","universal_aim_switchdelay",0,2,Aim.TargetSwitchDelay,.05,function(v)Aim.TargetSwitchDelay=v end)

section(Tabs.ESP,"Main")
tog(Tabs.ESP,"EnableESP","universal_esp_enabled",EspC.Enabled,function(v)EspC.Enabled=v;if v then refreshESP()else clearESP()end end)
col(Tabs.ESP,"ESPColor","universal_esp_color",EspC.Color,function(v)EspC.Color=v end)
tog(Tabs.ESP,"TeamCheck","universal_esp_teamcheck",EspC.TeamCheck,function(v)EspC.TeamCheck=v;refreshESP()end)
tog(Tabs.ESP,"TeamColor","universal_esp_teamcolor",EspC.TeamColor,function(v)EspC.TeamColor=v end)
tog(Tabs.ESP,"RainbowESP","universal_esp_rainbow",EspC.Rainbow,function(v)EspC.Rainbow=v end)
section(Tabs.ESP,"Info")
tog(Tabs.ESP,"ShowNames","universal_esp_names",EspC.ShowNames,function(v)EspC.ShowNames=v end)
tog(Tabs.ESP,"ShowHealth","universal_esp_health",EspC.ShowHealth,function(v)EspC.ShowHealth=v end)
tog(Tabs.ESP,"ShowDistance","universal_esp_distance",EspC.ShowDistance,function(v)EspC.ShowDistance=v end)
tog(Tabs.ESP,"ShowLines","universal_esp_lines",EspC.ShowLines,function(v)EspC.ShowLines=v end)
drop(Tabs.ESP,"TracerOrigin","universal_esp_tracerorigin",{"Top","Middle","Bottom"},EspC.TracerOrigin,function(v)EspC.TracerOrigin=v or "Bottom" end)
section(Tabs.ESP,"Visual")
tog(Tabs.ESP,"FillBox","universal_esp_fill",EspC.Fill,function(v)EspC.Fill=v end)
slid(Tabs.ESP,"FillTransparency","universal_esp_filltransparency",0,100,math.floor(EspC.FillTransparency*100),1,function(v)EspC.FillTransparency=v/100 end)
slid(Tabs.ESP,"OutlineTransparency","universal_esp_outlinetransparency",0,100,math.floor(EspC.OutlineTransparency*100),1,function(v)EspC.OutlineTransparency=v/100 end)
slid(Tabs.ESP,"TextSize","universal_esp_textsize",8,30,EspC.TextSize,1,function(v)EspC.TextSize=v end)
slid(Tabs.ESP,"MaxDistance","universal_esp_maxdistance",100,10000,EspC.MaxDistance,50,function(v)EspC.MaxDistance=v end)
btn(Tabs.ESP,"RefreshESP",function()refreshESP();notify(L("ESPUpdated"),"refresh-cw",2)end)

section(Tabs.Misc,"Movement")
tog(Tabs.Misc,"SpeedEnabled","universal_misc_speed_enabled",MiscC.SpeedEnabled,function(v)setSpeedEnabled(v)end)
slid(Tabs.Misc,"WalkSpeed","universal_misc_walkspeed",16,200,MiscC.WalkSpeed,1,function(v)MiscC.WalkSpeed=v;if MiscC.SpeedEnabled then applyMovement()end end)
tog(Tabs.Misc,"JumpEnabled","universal_misc_jump_enabled",MiscC.JumpEnabled,function(v)setJumpEnabled(v)end)
slid(Tabs.Misc,"JumpPower","universal_misc_jumppower",50,300,MiscC.JumpPower,1,function(v)MiscC.JumpPower=v;if MiscC.JumpEnabled then applyMovement()end end)
tog(Tabs.Misc,"Noclip","universal_misc_noclip",MiscC.Noclip,function(v)setNoclip(v)end)
tog(Tabs.Misc,"InfiniteJump","universal_misc_infinitejump",MiscC.InfiniteJump,function(v)MiscC.InfiniteJump=v end)
section(Tabs.Misc,"Utility")
tog(Tabs.Misc,"AntiAFK","universal_misc_antiafk",MiscC.AntiAFK,function(v)MiscC.AntiAFK=v end)
btn(Tabs.Misc,"ResetCharacter",function()local h=hum();if h then h.Health=0 end end)
tog(Tabs.Misc,"AntiVoid","universal_misc_antivoid",MiscC.AntiVoid,function(v)MiscC.AntiVoid=v;if not v then lastSafePosition=nil end end)
tog(Tabs.Misc,"Fullbright","universal_misc_fullbright",MiscC.Fullbright,function(v)setFullbright(v)end)
tog(Tabs.Misc,"NoFog","universal_misc_nofog",MiscC.NoFog,function(v)setNoFog(v)end)
section(Tabs.Misc,"Hitbox")
tog(Tabs.Misc,"EnableHitbox","universal_hitbox_enabled",HitC.Enabled,function(v)HitC.Enabled=v;if v then updateHit()else resetHit()end end)
slid(Tabs.Misc,"HitboxSize","universal_hitbox_size",2,200,HitC.Size,1,function(v)HitC.Size=math.clamp(v,2,HitC.MaxSize);if HitC.Enabled then updateHit()end end)
slid(Tabs.Misc,"HitboxTransparency","universal_hitbox_transparency",0,100,math.floor(HitC.Transparency*100),1,function(v)HitC.Transparency=v/100;if HitC.Enabled then updateHit()end end)
col(Tabs.Misc,"HitboxColor","universal_hitbox_color",HitC.Color,function(v)HitC.Color=v;if HitC.Enabled then updateHit()end end)
tog(Tabs.Misc,"HitboxTeam","universal_hitbox_teamcheck",HitC.TeamCheck,function(v)HitC.TeamCheck=v;resetHit();if HitC.Enabled then updateHit()end end)
btn(Tabs.Misc,"ResetHitboxes",function()resetHit();notify(L("HitboxesReset"),"rotate-ccw",3)end)

section(Tabs.OP,"God")
tog(Tabs.OP,"God100","universal_op_god100",OpC.God100,function(v)if GodSync then OpC.God100=v;return end;if v then setGodMode("100")elseif OpC.God100 then setGodMode("OFF")end end)
tog(Tabs.OP,"GodInf","universal_op_godinf",OpC.GodInf,function(v)if GodSync then OpC.GodInf=v;return end;if v then setGodMode("INF")elseif OpC.GodInf then setGodMode("OFF")end end)
section(Tabs.OP,"Protection")
tog(Tabs.OP,"AntiFling","universal_op_antifling",OpC.AntiFling,function(v)setAntiFling(v)end)
section(Tabs.OP,"Fling")
tog(Tabs.OP,"TouchFling","universal_op_touchfling",OpC.TouchFling,function(v)if v then startFling()else stopFling()end end)
slid(Tabs.OP,"FlingPower","universal_op_flingpower",1000,10000,OpC.FlingPower,500,function(v)OpC.FlingPower=v end)
slid(Tabs.OP,"FlingPulse","universal_op_flingpulse",0,50,math.floor(OpC.FlingPulse*100),1,function(v)OpC.FlingPulse=v/100 end)
btn(Tabs.OP,"RefreshFling",function()if OpC.TouchFling then stopFling();task.wait(.05);startFling();setControl("universal_op_touchfling",true)end end)
section(Tabs.OP,"Utility")
local OPPlayerDrop=drop(Tabs.OP,"SelectPlayer","universal_op_selectedplayer",playerNames(),OPSelectedPlayer,function(v)
    local old=getOPSelected();OPSelectedPlayer=v or "None"
    if OpC.FreezeSelected then
        if old then unfreezeReason(old,"Selected") end
        SelectedFrozenPlayer=getOPSelected();if SelectedFrozenPlayer then freezePlayer(SelectedFrozenPlayer,"Selected") end
    end
end)
btn(Tabs.OP,"RefreshPlayers",function()local list=playerNames();if OPPlayerDrop and OPPlayerDrop.Refresh then OPPlayerDrop:Refresh(list)end;notify(L("PlayerListUpdated"),"refresh-cw",2)end)
btn(Tabs.OP,"TeleportPlayer",tpToPlayer);btn(Tabs.OP,"TeleportBack",teleportBack);btn(Tabs.OP,"BringPlayer",bringPlayer);btn(Tabs.OP,"SpectatePlayer",spectatePlayer);btn(Tabs.OP,"Unspectate",unspectate)
section(Tabs.OP,"Freeze")
tog(Tabs.OP,"FreezeSelected","universal_op_freeze_selected",OpC.FreezeSelected,function(v)setFreezeSelected(v)end)
tog(Tabs.OP,"FreezeAll","universal_op_freeze_all",OpC.FreezeAll,function(v)setFreezeAll(v)end)
btn(Tabs.OP,"UnfreezeAll",function()OpC.FreezeSelected=false;OpC.FreezeAll=false;SelectedFrozenPlayer=nil;unfreezeAll();setControl("universal_op_freeze_selected",false);setControl("universal_op_freeze_all",false)end)

section(Tabs.Troll,"Utility")
tog(Tabs.Troll,"FakeLag","universal_troll_fakelag",TrollC.FakeLag,function(v)TrollC.FakeLag=v;if not v then stopFakeLag()end end)
slid(Tabs.Troll,"FakeLagRate","universal_troll_fakelagrate",12,100,math.floor(TrollC.FakeLagRate*100),1,function(v)TrollC.FakeLagRate=math.max(v/100,.12) end)
slid(Tabs.Troll,"FakeLagHold","universal_troll_fakelaghold",1,40,math.floor(TrollC.FakeLagHold*100),1,function(v)TrollC.FakeLagHold=v/100 end)
btn(Tabs.Troll,"FakeDeath",function()setFakeDeath(true)end)
btn(Tabs.Troll,"FakeDeathCooldown",function()setFakeDeath(false)end)
section(Tabs.Troll,"Movement")
local TrollPlayerDrop=drop(Tabs.Troll,"SelectPlayer","universal_troll_selectedplayer",playerNames(),TrollSelectedPlayer,function(v)TrollSelectedPlayer=v or "None" end)
btn(Tabs.Troll,"RefreshPlayers",function()local list=playerNames();if TrollPlayerDrop and TrollPlayerDrop.Refresh then TrollPlayerDrop:Refresh(list)end;notify(L("PlayerListUpdated"),"refresh-cw",2)end)
tog(Tabs.Troll,"Orbit","universal_troll_orbit",TrollC.Orbit,function(v)TrollC.Orbit=v end)
drop(Tabs.Troll,"OrbitMode","universal_troll_orbitmode",{"Circle","UpDown","LeftRight","Diagonal"},TrollC.OrbitMode,function(v)TrollC.OrbitMode=v or "Circle" end)
slid(Tabs.Troll,"OrbitRadius","universal_troll_orbitradius",2,35,TrollC.OrbitRadius,1,function(v)TrollC.OrbitRadius=v end)
slid(Tabs.Troll,"OrbitSpeed","universal_troll_orbitspeed",1,40,TrollC.OrbitSpeed,1,function(v)TrollC.OrbitSpeed=v end)
slid(Tabs.Troll,"OrbitHeight","universal_troll_orbitheight",0,25,TrollC.OrbitHeight,1,function(v)TrollC.OrbitHeight=v end)
tog(Tabs.Troll,"SpinBot","universal_troll_spin",TrollC.Spin,function(v)TrollC.Spin=v end)
slid(Tabs.Troll,"SpinSpeed","universal_troll_spinspeed",1,150,TrollC.SpinSpeed,1,function(v)TrollC.SpinSpeed=v end)
tog(Tabs.Troll,"HeadSit","universal_troll_headsit",TrollC.HeadSit,function(v)TrollC.HeadSit=v;if not v then stopHeadSit()end end)
section(Tabs.Troll,"Fling")
tog(Tabs.Troll,"Annoy","universal_troll_annoy",TrollC.Annoy,function(v)TrollC.Annoy=v end)
drop(Tabs.Troll,"AnnoyMode","universal_troll_annoymode",{"Circle","Cross","Random"},TrollC.AnnoyMode,function(v)TrollC.AnnoyMode=v or "Circle" end)
slid(Tabs.Troll,"AnnoySpeed","universal_troll_annoyspeed",1,50,math.floor(TrollC.AnnoySpeed*100),1,function(v)TrollC.AnnoySpeed=math.max(v/100,.01)end)
tog(Tabs.Troll,"GhostTrail","universal_troll_ghost",TrollC.Ghost,function(v)TrollC.Ghost=v end)

local function configNames()
    local values={sanitizeProfileName(ProfileName)}
    if ConfigManager and ConfigManager.AllConfigs then
        local ok,list=pcall(function()return ConfigManager:AllConfigs()end)
        if ok and type(list)=="table" then
            for k,v in pairs(list) do
                local name=type(v)=="string" and v or (type(k)=="string" and k or nil)
                if name and not table.find(values,name) then values[#values+1]=name end
            end
        end
    end
    table.sort(values)
    return values
end

section(Tabs.Config,"ConfigFile")
para(Tabs.Config,L("Config"),L("ConfigPath"),"Blue")
local ConfigListDrop=drop(Tabs.Config,"ConfigList","universal_config_profile",configNames(),sanitizeProfileName(ProfileName),function(v)if v then ProfileName=tostring(v);saveStartupMeta()end end)
input(Tabs.Config,"ProfileName","universal_config_profile_name","default",function(v)ProfileName=tostring(v or "default");saveStartupMeta()end)
btn(Tabs.Config,"RefreshConfigs",function()if ConfigListDrop and ConfigListDrop.Refresh then ConfigListDrop:Refresh(configNames())end end)
btn(Tabs.Config,"SaveConfig",function()saveActiveConfig(false)end)
btn(Tabs.Config,"LoadConfig",function()loadActiveConfig(false)end)
btn(Tabs.Config,"DeleteConfig",function()
    local cfg=getConfigObject()
    if cfg and cfg.Delete then
        local ok=pcall(function()cfg:Delete()end)
        if ok then notify(L("ConfigDeleted"),"trash-2",3);if ConfigListDrop and ConfigListDrop.Refresh then ConfigListDrop:Refresh(configNames())end else notify(L("ConfigNotFound"),"x",3)end
    else notify(L("ConfigNotFound"),"x",3) end
end)
btn(Tabs.Config,"ExportConfig",exportConfig);btn(Tabs.Config,"ImportConfig",importConfig)
tog(Tabs.Config,"AutoLoadConfig","universal_config_autoload",AutoLoadConfig,function(v)AutoLoadConfig=v;saveStartupMeta()end)
tog(Tabs.Config,"AutoSave","universal_config_autosave",AutoSave,function(v)AutoSave=v;if v and ConfigDirty then markConfigDirty()end end)

local function resetSession()
    Aim.Enabled=false;Aim.FOVVisible=false;Aim.Crosshair=false;currentTarget=nil
    EspC.Enabled=false;clearESP()
    setSpeedEnabled(false);setJumpEnabled(false);setNoclip(false);MiscC.InfiniteJump=false
    setFullbright(false);setNoFog(false);HitC.Enabled=false;resetHit()
    setGodMode("OFF");setAntiFling(false);stopFling();setFreezeSelected(false);setFreezeAll(false);unfreezeAll()
    stopFakeLag();setFakeDeath(false);TrollC.Orbit=false;TrollC.Spin=false;TrollC.HeadSit=false;stopHeadSit();TrollC.Annoy=false
    setPerformanceMode(false);lastSafePosition=nil;unspectate()
    if FOVCircle then FOVCircle.Visible=false end;if CrossA then CrossA.Visible=false end;if CrossB then CrossB.Visible=false end
    if syncAllControls then syncAllControls()end
    notify(L("ResetDone"),"rotate-ccw",3)
end
btn(Tabs.Config,"ResetSession",resetSession)

section(Tabs.Config,"Server")
btn(Tabs.Config,"Rejoin",function()TP:Teleport(game.PlaceId,LP)end);btn(Tabs.Config,"ServerHop",hop);btn(Tabs.Config,"SmallServer",smallServer);btn(Tabs.Config,"CopyJobId",copyJob)
input(Tabs.Config,"JobIdInput","universal_config_jobid","xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",function(v)JobInput=tostring(v or "")end);btn(Tabs.Config,"JoinJobId",joinJob)

section(Tabs.Config,"Language")
drop(Tabs.Config,"LanguageDropdown","universal_config_language",{"English","Portuguese","Spanish"},Lang,function(v)if TXT[v] then saveLang(v);notify(L("LanguageReload"),"languages",4)end end)

section(Tabs.Config,"Interface")
tog(Tabs.Config,"PerformanceMode","universal_ui_performance",MiscC.Performance,function(v)setPerformanceMode(v)end)
tog(Tabs.Config,"Notifications","universal_ui_notifications",NotifyOn,function(v)NotifyOn=v end)
drop(Tabs.Config,"Theme","universal_ui_theme",getThemeNames(),ThemeName,function(v)
    if not v then return end;ThemeName=v
    if Window.SetTheme then Window:SetTheme(v) elseif WindUI.SetTheme then WindUI:SetTheme(v) end
end)
slid(Tabs.Config,"UIScale","universal_ui_scale",70,130,100,1,function(v)
    UIScaleValue=v/100;if Window.SetUIScale then Window:SetUIScale(UIScaleValue)end
end)
slid(Tabs.Config,"BackgroundTransparency","universal_ui_background_transparency",0,100,0,1,function(v)
    BackgroundTransparencyValue=v/100;if Window.SetBackgroundTransparency then Window:SetBackgroundTransparency(BackgroundTransparencyValue)end
end)
btn(Tabs.Config,"CenterWindow",function()if Window.SetToTheCenter then Window:SetToTheCenter()end end)
local KeybindControl=Tabs.Config:Keybind({Title=L("ToggleKey"),Desc="",Flag="universal_ui_togglekey",Value="H",Callback=function(v)if v and Enum.KeyCode[v] and Window.SetToggleKey then Window:SetToggleKey(Enum.KeyCode[v])end end})
registerControl("universal_ui_togglekey",KeybindControl)

section(Tabs.Config,"Danger")
btn(Tabs.Config,"UnloadScript",function()Runtime:Cleanup()end)

section(Tabs.Status,"Status")
local StatusParagraph=para(Tabs.Status,L("LiveStatus"),"Loading...","Green")
local PlayerStatusParagraph=para(Tabs.Status,L("PlayerInfo"),"Loading...","Blue")
btn(Tabs.Status,"RefreshStatus",function()
    if StatusParagraph and StatusParagraph.SetDesc then StatusParagraph:SetDesc(serverInfoText())end
    if PlayerStatusParagraph and PlayerStatusParagraph.SetDesc then PlayerStatusParagraph:SetDesc(playerInfoText())end
end)
btn(Tabs.Status,"CopyStatus",copyServerInfo)

-- AI is preserved, but the old unverified endpoint is disabled by default.
section(Tabs.AI,"AskAI")
local AIQuestion=""
local AICooldown=10
local AILastTime=0
input(Tabs.AI,"YourQuestion","universal_ai_question",L("QuestionPlaceholder"),function(v)AIQuestion=tostring(v or "")end)
local AIResponseParagraph=para(Tabs.AI,L("AIResponse"),L("AIAwaiting"),"Blue")
local AskButton
AskButton=Tabs.AI:Button({Title=L("SendButton"),Desc=L("SendDesc"),Callback=function()
    local now=os.clock()
    if now-AILastTime<AICooldown then if AIResponseParagraph.SetDesc then AIResponseParagraph:SetDesc(string.format(L("CooldownText"),math.ceil(AICooldown-(now-AILastTime))))end;return end
    if AIQuestion=="" or #AIQuestion<3 then if AIResponseParagraph.SetDesc then AIResponseParagraph:SetDesc(L("InvalidQuestion"))end;return end
    AILastTime=now
    if not ENABLE_LEGACY_EXTERNAL_APIS or not Request then if AIResponseParagraph.SetDesc then AIResponseParagraph:SetDesc(L("LegacyApiDisabled"))end;return end
    if AIResponseParagraph.SetDesc then AIResponseParagraph:SetDesc(L("Thinking"))end
    Runtime:Spawn("AICooldown",function(token)
        for i=AICooldown,1,-1 do
            if not Runtime:IsTokenCurrent("AICooldown",token) then return end
            if AskButton and AskButton.SetTitle then AskButton:SetTitle(L("SendButton").." ("..i.."s)")end
            task.wait(1)
        end
        if Runtime:IsTokenCurrent("AICooldown",token) and AskButton and AskButton.SetTitle then AskButton:SetTitle(L("SendButton"))end
    end)
    Runtime:Spawn("AIRequest",function(token)
        local ok,res=pcall(function()return Request({Url=LEGACY_CHAT_URL,Method="POST",Headers={["Content-Type"]="application/json",["Accept"]="application/json"},Body=Http:JSONEncode({prompt=AIQuestion,language=Lang})})end)
        if not Runtime:IsTokenCurrent("AIRequest",token) then return end
        local status=res and (res.StatusCode or res.Status) or 0
        if not ok or type(res)~="table" or status~=200 then if AIResponseParagraph.SetDesc then AIResponseParagraph:SetDesc("Request failed.")end;return end
        local raw=res.Body or res.body or ""
        local decoded,data=pcall(function()return Http:JSONDecode(raw)end)
        if AIResponseParagraph.SetDesc then AIResponseParagraph:SetDesc(decoded and type(data)=="table" and tostring(data.reply or "Invalid response.") or "Invalid response.")end
    end)
end})

syncAllControls=function()
    local values={
        universal_aim_enabled=Aim.Enabled,universal_aim_teamcheck=Aim.TeamCheck,universal_aim_visiblecheck=Aim.VisibleCheck,universal_aim_targetpart=Aim.TargetPart,
        universal_aim_fov=Aim.FOV,universal_aim_showfov=Aim.FOVVisible,universal_aim_fovcolor=Aim.FOVColor,universal_aim_crosshair=Aim.Crosshair,universal_aim_crosshairsize=Aim.CrosshairSize,
        universal_aim_smoothness=math.floor(Aim.Smoothness*388+.5),universal_aim_strength=math.floor(Aim.Strength*100+.5),universal_aim_switchdelay=Aim.TargetSwitchDelay,
        universal_esp_enabled=EspC.Enabled,universal_esp_color=EspC.Color,universal_esp_teamcheck=EspC.TeamCheck,universal_esp_teamcolor=EspC.TeamColor,universal_esp_rainbow=EspC.Rainbow,
        universal_esp_names=EspC.ShowNames,universal_esp_health=EspC.ShowHealth,universal_esp_distance=EspC.ShowDistance,universal_esp_lines=EspC.ShowLines,universal_esp_tracerorigin=EspC.TracerOrigin,
        universal_esp_fill=EspC.Fill,universal_esp_filltransparency=math.floor(EspC.FillTransparency*100),universal_esp_outlinetransparency=math.floor(EspC.OutlineTransparency*100),universal_esp_textsize=EspC.TextSize,universal_esp_maxdistance=EspC.MaxDistance,
        universal_misc_speed_enabled=MiscC.SpeedEnabled,universal_misc_walkspeed=MiscC.WalkSpeed,universal_misc_jump_enabled=MiscC.JumpEnabled,universal_misc_jumppower=MiscC.JumpPower,universal_misc_noclip=MiscC.Noclip,
        universal_misc_infinitejump=MiscC.InfiniteJump,universal_misc_antiafk=MiscC.AntiAFK,universal_misc_antivoid=MiscC.AntiVoid,universal_misc_fullbright=MiscC.Fullbright,universal_misc_nofog=MiscC.NoFog,
        universal_hitbox_enabled=HitC.Enabled,universal_hitbox_size=HitC.Size,universal_hitbox_transparency=math.floor(HitC.Transparency*100),universal_hitbox_color=HitC.Color,universal_hitbox_teamcheck=HitC.TeamCheck,
        universal_op_god100=OpC.God100,universal_op_godinf=OpC.GodInf,universal_op_antifling=OpC.AntiFling,universal_op_touchfling=OpC.TouchFling,universal_op_flingpower=OpC.FlingPower,universal_op_flingpulse=math.floor(OpC.FlingPulse*100),
        universal_op_freeze_selected=OpC.FreezeSelected,universal_op_freeze_all=OpC.FreezeAll,
        universal_troll_fakelag=TrollC.FakeLag,universal_troll_fakelagrate=math.floor(TrollC.FakeLagRate*100),universal_troll_fakelaghold=math.floor(TrollC.FakeLagHold*100),universal_troll_orbit=TrollC.Orbit,
        universal_troll_orbitmode=TrollC.OrbitMode,universal_troll_orbitradius=TrollC.OrbitRadius,universal_troll_orbitspeed=TrollC.OrbitSpeed,universal_troll_orbitheight=TrollC.OrbitHeight,universal_troll_spin=TrollC.Spin,universal_troll_spinspeed=TrollC.SpinSpeed,
        universal_troll_headsit=TrollC.HeadSit,universal_troll_annoy=TrollC.Annoy,universal_troll_annoymode=TrollC.AnnoyMode,universal_troll_annoyspeed=math.floor(TrollC.AnnoySpeed*100),universal_troll_ghost=TrollC.Ghost,
        universal_config_autoload=AutoLoadConfig,universal_config_autosave=AutoSave,universal_config_language=Lang,universal_ui_performance=MiscC.Performance,universal_ui_notifications=NotifyOn,universal_ui_theme=ThemeName,
        universal_ui_scale=math.floor(UIScaleValue*100),universal_ui_background_transparency=math.floor(BackgroundTransparencyValue*100)
    }
    SyncingControls=true
    for flag,value in pairs(values) do
        local c=Controls[flag]
        if c then pcall(function()if c.Set then c:Set(value) elseif c.Select then c:Select(value)end end)end
    end
    SyncingControls=false
end

applyAllFeatureState=function()
    setSpeedEnabled(MiscC.SpeedEnabled);setJumpEnabled(MiscC.JumpEnabled);setNoclip(MiscC.Noclip)
    setFullbright(MiscC.Fullbright);setNoFog(MiscC.NoFog)
    if HitC.Enabled then updateHit()else resetHit()end
    if EspC.Enabled then refreshESP()else clearESP()end
    if OpC.GodInf then setGodMode("INF")elseif OpC.God100 then setGodMode("100")else setGodMode("OFF")end
    setAntiFling(OpC.AntiFling)
    if OpC.TouchFling then startFling()else stopFling()end
    setFreezeSelected(OpC.FreezeSelected);setFreezeAll(OpC.FreezeAll)
    if TrollC.FakeLag then TrollC.FakeLag=true else stopFakeLag()end
    if TrollC.FakeDeath then setFakeDeath(true)else setFakeDeath(false)end
    if not TrollC.HeadSit then stopHeadSit()end
    setPerformanceMode(MiscC.Performance)
    if Window.SetTheme then pcall(function()Window:SetTheme(ThemeName)end)end
    if Window.SetUIScale then pcall(function()Window:SetUIScale(UIScaleValue)end)end
    if Window.SetBackgroundTransparency then pcall(function()Window:SetBackgroundTransparency(BackgroundTransparencyValue)end)end
end

local function updatePlayerDropdowns()
    local list=playerNames()
    if OPPlayerDrop and OPPlayerDrop.Refresh then pcall(function()OPPlayerDrop:Refresh(list)end)end
    if TrollPlayerDrop and TrollPlayerDrop.Refresh then pcall(function()TrollPlayerDrop:Refresh(list)end)end
end

local function onOtherCharacterAdded(p,c)
    task.defer(function()
        if not Runtime.Alive or p.Character~=c then return end
        if EspC.Enabled then ensureESPBase(p)end
        if HitC.Enabled then applyHit(p)end
        if OpC.AntiFling then applyAntiFlingToPlayer(p)end
        if OpC.FreezeAll then freezePlayer(p,"All")end
        if OpC.FreezeSelected and p==SelectedFrozenPlayer then freezePlayer(p,"Selected")end
    end)
end
local function trackPlayer(p)
    if not p or p==LP or TrackedPlayers[p] then return end
    TrackedPlayers[p]=true
    Runtime:AddConnection(p.CharacterAdded:Connect(function(c)onOtherCharacterAdded(p,c)end))
    if p.CharacterRemoving then Runtime:AddConnection(p.CharacterRemoving:Connect(function()removeESP(p)end))end
    if p.Character then onOtherCharacterAdded(p,p.Character)end
end
local function untrackPlayer(p)
    removeESP(p)
    if Frozen[p] then unfreezePlayer(p)end
    local r=root(p);if r and AntiFlingBackup[r]~=nil then pcall(function()r.CanCollide=AntiFlingBackup[r]end);AntiFlingBackup[r]=nil end
    TrackedPlayers[p]=nil
    if OPSelectedPlayer==p.Name then OPSelectedPlayer="None"end
    if TrollSelectedPlayer==p.Name then TrollSelectedPlayer="None"end
    if SelectedFrozenPlayer==p then SelectedFrozenPlayer=nil end
end
for _,p in ipairs(Players:GetPlayers())do trackPlayer(p)end

Runtime:AddConnection(Players.PlayerAdded:Connect(function(p)trackPlayer(p);updatePlayerDropdowns()end))
Runtime:AddConnection(Players.PlayerRemoving:Connect(function(p)untrackPlayer(p);task.defer(updatePlayerDropdowns)end))

local function onLocalCharacterAdded(c)
    lastSafePosition=nil
    MovementSnapshot=nil
    FakeDeathState={Active=false,Character=nil,Humanoid=nil,Root=nil,PlatformStand=nil,RootJoint=nil,RootJointC0=nil}
    GodState=nil
    Runtime:Delay("LocalCharacterInit",.25,function()
        if LP.Character~=c then return end
        if MiscC.SpeedEnabled or MiscC.JumpEnabled then applyMovement()end
        if MiscC.Noclip then attachNoclipCharacter()end
        if OpC.GodInf or OpC.God100 then applyGod()end
        if TrollC.FakeDeath then setFakeDeath(true)end
    end)
end
local function onLocalCharacterRemoving(c)
    if LP.Character~=c then return end
    lastSafePosition=nil
    Runtime:SetConnection("NoclipDescendant",nil)
    NoclipBackup=setmetatable({}, {__mode="k"})
    MovementSnapshot=nil
    GodState=nil
    FakeDeathState={Active=false,Character=nil,Humanoid=nil,Root=nil,PlatformStand=nil,RootJoint=nil,RootJointC0=nil}
    releaseFakeLagHold()
end
Runtime:AddConnection(LP.CharacterAdded:Connect(onLocalCharacterAdded))
if LP.CharacterRemoving then Runtime:AddConnection(LP.CharacterRemoving:Connect(onLocalCharacterRemoving))end
if LP.Character then onLocalCharacterAdded(LP.Character)end

Runtime:AddConnection(UIS.JumpRequest:Connect(function()
    if Runtime.Alive and MiscC.InfiniteJump then local h=hum();if h then h:ChangeState(Enum.HumanoidStateType.Jumping)end end
end))
Runtime:AddConnection(LP.Idled:Connect(function()
    if Runtime.Alive and MiscC.AntiAFK then
        local cf=Camera and Camera.CFrame or CFrame.new();VU:Button2Down(Vector2.new(),cf);task.wait(1);if Runtime.Alive then VU:Button2Up(Vector2.new(),cf)end
    end
end))

local frameCount,frameTime=0,0
Runtime:AddConnection(RunService.RenderStepped:Connect(function(dt)
    if not Runtime.Alive then return end
    updateFrameContext()
    frameCount=frameCount+1;frameTime=frameTime+dt
    if frameTime>=.5 then CurrentFPS=math.floor(frameCount/frameTime+.5);frameCount=0;frameTime=0 end
    if FOVCircle then FOVCircle.Position=Frame.Center;FOVCircle.Radius=Aim.FOV;FOVCircle.Color=Aim.FOVColor;FOVCircle.Visible=Aim.FOVVisible end
    updateCrosshair()
    if Aim.Enabled then updateAim()end
    if TrollC.Spin then updateSpin(dt)end
    if TrollC.Orbit then updateOrbit(dt)end
    if TrollC.Annoy then updateAnnoy(dt)end
    if TrollC.HeadSit then updateHeadSit()end
end))

local antiVoidAcc,espAcc,hitAcc,statusAcc,reconcileAcc=0,0,0,0,0
Runtime:AddConnection(RunService.Heartbeat:Connect(function(dt)
    if not Runtime.Alive then return end
    if TrollC.FakeLag then fakeLag(dt)end
    antiVoidAcc=antiVoidAcc+dt;espAcc=espAcc+dt;hitAcc=hitAcc+dt;statusAcc=statusAcc+dt;reconcileAcc=reconcileAcc+dt
    if antiVoidAcc>=.1 then antiVoidAcc=0;antiVoidGuard()end
    if espAcc>=.066 then espAcc=0;if EspC.Enabled then updateESP()end end
    if hitAcc>=.25 then hitAcc=0;if HitC.Enabled then updateHit()end end
    if reconcileAcc>=.25 then
        reconcileAcc=0
        if MiscC.SpeedEnabled or MiscC.JumpEnabled then applyMovement()end
        if OpC.GodInf or OpC.God100 then applyGod()end
    end
    if statusAcc>=1 then
        statusAcc=0
        if StatusParagraph and StatusParagraph.SetDesc then pcall(function()StatusParagraph:SetDesc(serverInfoText())end)end
        if PlayerStatusParagraph and PlayerStatusParagraph.SetDesc then pcall(function()PlayerStatusParagraph:SetDesc(playerInfoText())end)end
        if KeyParagraph and KeyParagraph.SetDesc then pcall(function()KeyParagraph:SetDesc(string.format("%s: %s\n%s: %s\n%s: %s",L("KeyStatus"),tostring(KeyInfo.Status),L("KeyProvider"),FormatProvider(KeyInfo.Provider),L("KeyExpires"),RemainingTime(KeyInfo.ExpiresAt)))end)end
    end
end))

Runtime:AddCleanup(function()
    -- Restore only state owned by this runtime.
    pcall(function()setFakeDeath(false)end)
    pcall(stopFakeLag)
    pcall(stopHeadSit)
    pcall(stopFling)
    pcall(function()setFreezeSelected(false);setFreezeAll(false);unfreezeAll()end)
    pcall(function()setAntiFling(false)end)
    pcall(function()setGodMode("OFF")end)
    pcall(function()HitC.Enabled=false;resetHit()end)
    pcall(clearESP)
    pcall(function()setNoclip(false)end)
    pcall(function()setSpeedEnabled(false);setJumpEnabled(false);restoreMovement()end)
    pcall(function()setFullbright(false);setNoFog(false)end)
    pcall(function()setPerformanceMode(false)end)
    pcall(unspectate)
    for _,g in ipairs(Ghosts)do destroyObject(g)end;Ghosts={}
end)

--==================================================
-- BOOT / AUTO LOAD
--==================================================
Runtime:Spawn("Boot",function(token)
    task.wait(.35)
    if not Runtime:IsTokenCurrent("Boot",token) then return end
    if AutoLoadConfig then loadActiveConfig(true) end
    task.wait(.2)
    if not Runtime:IsTokenCurrent("Boot",token) then return end
    applyAllFeatureState();syncAllControls();updatePlayerDropdowns()
    booting=false
    bootNotify(L("Loaded"))
end)

-- REQUIRES_RUNTIME_TEST:
-- Bring/Freeze replication, God behavior, AntiFling effectiveness, TouchFling, FakeLag,
-- executor Drawing/request/clipboard/filesystem APIs, WindUI ConfigManager behavior,
-- key validation end-to-end and all EXTERNAL_SCRIPT_UNMANAGED entries.
