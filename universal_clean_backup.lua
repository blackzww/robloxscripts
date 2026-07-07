local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local UIS=game:GetService("UserInputService")
local VU=game:GetService("VirtualUser")
local TP=game:GetService("TeleportService")
local Http=game:GetService("HttpService")
local RS=game:GetService("ReplicatedStorage")
local Lighting=game:GetService("Lighting")
local lastSafePosition = nil
local LocalizationService=game:GetService("LocalizationService")
local LP=Players.LocalPlayer
local Camera=workspace.CurrentCamera

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local LP = Players.LocalPlayer

task.spawn(function()
    local HttpService = game:GetService("HttpService")
    local Players = game:GetService("Players")
    local LP = Players.LocalPlayer

    local req = nil

    pcall(function()
        req = request or http_request or syn and syn.request
    end)

    if type(req) ~= "function" then
        return
    end

    local executor = "Unknown"

    pcall(function()
        if type(identifyexecutor) == "function" then
            executor = tostring(identifyexecutor())
        end
    end)

    local body = HttpService:JSONEncode({
        player = LP.Name,
        userId = tostring(LP.UserId),
        executor = executor,
        placeId = tostring(game.PlaceId),
        jobId = tostring(game.JobId),
        version = "Beta 1.4"
    })

    pcall(function()
        req({
            Url = "https://mirrorskey-system.vercel.app/api/log-use",
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = body
        })
    end)
end)

local HUB_FOLDER="MirrorsHub"
local CONFIG_FOLDER="MirrorsHub/config"
local LANG_FILE=CONFIG_FOLDER.."/language.json"
local booting=true




local function fs()
	return typeof(writefile)=="function" and typeof(readfile)=="function" and typeof(isfile)=="function" and typeof(makefolder)=="function"
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
HomeTitle="Mirrors Hub",HomeDesc="Universal script hub.\nVersion: 1.4\nCreated by blackzw.mp3",BetaTitle="Beta Notice",BetaDesc="This hub is still in beta and may contain bugs. Report issues on Discord.",DiscordTitle="Community",DiscordDesc="Found bugs or have suggestions? Send them on Discord.",StatusTitle="Status",StatusDesc="Build: 1.4 Beta.",
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
Saved="Config saved.",LoadedConfig="Config loaded.",ResetDone="Session reset.",Loaded="Script loaded successfully.",Copied="Copied.",ServerErr="Failed to fetch servers.",NoServer="No server with less than 5 players found.",NotConfigured="Not configured yet."
},
Portuguese={
WindowTitle="Mirrors Hub - Universal",OpenButton="Abrir Mirrors Hub",Scripts="Scripts",Aimbot="Aimbot",ESP="ESP",Misc="Misc",OP="OP",Troll="Troll",Config="Config",Status="Status",
Home="Início",Main="Principal",FOV="FOV",Tuning="Ajustes",Info="Informações",Visual="Visual",Movement="Movimento",Utility="Utilidades",Hitbox="Hitbox",Server="Servidor",ConfigFile="Arquivo de Config",Startup="Inicialização",Language="Idioma",Interface="Interface",Danger="Zona de Perigo",God="God Mode",Protection="Proteção",Fling="Ferramentas de Fling",Freeze="Ferramentas de Freeze",
HomeTitle="Mirrors Hub",HomeDesc="Hub universal de scripts.\nVersão: 1.4\nCriado por blackzw.mp3",BetaTitle="Aviso Beta",BetaDesc="Este hub ainda está em beta e pode conter bugs. Avise no Discord.",DiscordTitle="Comunidade",DiscordDesc="Achou bugs ou tem sugestões? Manda no Discord.",StatusTitle="Status",StatusDesc="Build: 1.4 Beta.",
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
Saved="Config salva.",LoadedConfig="Config carregada.",ResetDone="Sessão resetada.",Loaded="Script foi carregado com sucesso.",Copied="Copiado.",ServerErr="Erro ao buscar servidores.",NoServer="Nenhum servidor com menos de 5 pessoas encontrado.",NotConfigured="Ainda não configurado."
},
Spanish={
WindowTitle="Mirrors Hub - Universal",OpenButton="Abrir Mirrors Hub",Scripts="Scripts",Aimbot="Aimbot",ESP="ESP",Misc="Misc",OP="OP",Troll="Troll",Config="Config",Status="Status",
Home="Inicio",Main="Principal",FOV="FOV",Tuning="Ajustes",Info="Información",Visual="Visual",Movement="Movimiento",Utility="Utilidad",Hitbox="Hitbox",Server="Servidor",ConfigFile="Archivo de Config",Startup="Inicio",Language="Idioma",Interface="Interfaz",Danger="Zona de Peligro",God="God Mode",Protection="Protección",Fling="Herramientas de Fling",Freeze="Herramientas de Freeze",
HomeTitle="Mirrors Hub",HomeDesc="Hub universal de scripts.\nVersión: 1.4\nCreado por blackzw.mp3",BetaTitle="Aviso Beta",BetaDesc="Este hub todavía está en beta y puede tener bugs. Avísalo en Discord.",DiscordTitle="Comunidad",DiscordDesc="¿Bugs o sugerencias? Mándalos en Discord.",StatusTitle="Estado",StatusDesc="Build: 1.4 Beta.",
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
Saved="Config guardada.",LoadedConfig="Config cargada.",ResetDone="Sesión reseteada.",Loaded="Script cargado correctamente.",Copied="Copiado.",ServerErr="Error al buscar servidores.",NoServer="No se encontró servidor con menos de 5 personas.",NotConfigured="Todavía no configurado."
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

local Aim={Enabled=false,FOV=140,Smoothness=.09,Strength=1,TargetPart="Head",TargetSwitchDelay=.25,TeamCheck=false,VisibleCheck=false,FOVVisible=false,FOVColor=Color3.fromRGB(134,0,212),Crosshair=false,CrosshairSize=8}
local EspC={Enabled=false,Color=Color3.fromRGB(0,255,255),ShowNames=false,ShowHealth=false,ShowDistance=false,ShowLines=false,TeamCheck=false,Fill=false,FillTransparency=.75,OutlineTransparency=0,TextSize=13,MaxDistance=5000,TeamColor=false,Rainbow=false,TracerOrigin="Bottom"}
local MiscC={WalkSpeed=16,JumpPower=50,Noclip=false,InfiniteJump=false,AntiAFK=false,AntiVoid=true,Fullbright=false,NoFog=false}
local HitC={Enabled=false,Size=10,MaxSize=200,Transparency=.65,Color=Color3.fromRGB(134,0,212),TeamCheck=false}
local OpC={God100=false,GodInf=false,AntiFling=false,TouchFling=false,FlingPower=10000,FlingPulse=.1,FreezeSelected=false,FreezeAll=false}
local TrollC={FakeLag=false,FakeLagRate=.22,FakeLagHold=.08,FakeDeath=false,FakeDeathCooldown=1.2,Orbit=false,OrbitMode="Circle",OrbitRadius=7,OrbitSpeed=8,OrbitHeight=4,Spin=false,SpinSpeed=35,HeadSit=false,Annoy=false,AnnoyMode="Circle",AnnoySpeed=.05,Ghost=true}
local SelectedPlayer,JobInput,LastTeleportCF,ProfileName,AutoSave=nil,"",nil,"default",false

local WindUI=loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

WindUI.Services.mirrorskey = {
	Name = "Mirrors Key",
	Icon = "key",
	Args = { "BaseUrl" },
	New = function(BaseUrl)
		local function verify(key)
			if not key or key == "" then
				return false, "Key cannot be empty!"
			end
			local url = BaseUrl .. "/api/validate-key?key=" .. Http:UrlEncode(key)
			local success, response = pcall(function()
				return game:HttpGet(url)
			end)
			if not success then
				return false, "Failed to connect to the server."
			end
			local ok, data = pcall(function()
				return Http:JSONDecode(response)
			end)
			if not ok then
				return false, "Invalid server response."
			end
			if data.valid == true then
				return true, "Key verified successfully!"
			end
			return false, data.message or "Invalid key!"
		end
		local function copy()
			if setclipboard then
				setclipboard(BaseUrl)
			end
			return true
		end
		return { Verify = verify, Copy = copy }
	end
}
pcall(function()
	WindUI:AddTheme({Name="Mirrors Purple",Accent=Color3.fromHex("#1C002E"),Background=Color3.fromHex("#101010"),Outline=Color3.fromHex("#8600D4"),Text=Color3.fromHex("#FFFFFF"),Placeholder=Color3.fromHex("#8a8a8a"),Button=Color3.fromHex("#2A0145"),Icon=Color3.fromHex("#C084FC")})
	WindUI:AddTheme({Name="Midnight",Accent=Color3.fromHex("#111827"),Background=Color3.fromHex("#050505"),Outline=Color3.fromHex("#374151"),Text=Color3.fromHex("#FFFFFF"),Placeholder=Color3.fromHex("#9CA3AF"),Button=Color3.fromHex("#1F2937"),Icon=Color3.fromHex("#D1D5DB")})
end)
local NotifyOn=true
local function notify(txt,icon,dur)
	if booting or not NotifyOn then return end
	pcall(function()WindUI:Notify({Title="Mirrors Hub",Content=txt,Duration=dur or 3,Icon=icon or "bell"})end)
end
local function bootNotify(txt)
	pcall(function()WindUI:Notify({Title="Mirrors Hub",Content=txt,Duration=4,Icon="check"})end)
end

local Window=WindUI:CreateWindow({Title=L("WindowTitle"),Icon="door-open",Author="by blackzw.mp3",Folder=CONFIG_FOLDER,Size=UDim2.fromOffset(590,470),MinSize=Vector2.new(560,350),ToggleKey=Enum.KeyCode.H,Transparent=true,Theme="Mirrors Purple",Resizable=false,SideBarWidth=200,HideSearchBar=false,ScrollBarEnabled=true,NewElements=true,KeySystem={Note="Get your free key from the official website. Keys expire after 24 hours.",API={{Type="mirrorskey",BaseUrl="https://mirrorskey-system.vercel.app"}}},User={Enabled=true,Anonymous=false}})
pcall(function()Window:EditOpenButton({Title=L("OpenButton"),Icon="monitor",CornerRadius=UDim.new(0,16),StrokeThickness=2,Color=ColorSequence.new(Color3.fromHex("8600D4"),Color3.fromHex("1C002E")),OnlyMobile=false,Enabled=true,Draggable=true})end)
local ConfigManager=Window.ConfigManager
local UConfig=ConfigManager and ConfigManager:CreateConfig("universal-config")

local Tabs={Scripts=Window:Tab({Title=L("Scripts"),Icon="scroll-text"}),Aimbot=Window:Tab({Title=L("Aimbot"),Icon="crosshair"}),ESP=Window:Tab({Title=L("ESP"),Icon="eye"}),Misc=Window:Tab({Title=L("Misc"),Icon="circle-ellipsis"}),OP=Window:Tab({Title=L("OP"),Icon="flame",Locked=false}),Troll=Window:Tab({Title=L("Troll"),Icon="laugh"}),Config=Window:Tab({Title=L("Config"),Icon="cog"}),Status=Window:Tab({Title=L("Status"),Icon="activity"}),Info=Window:Tab({Title=L("Info"),Icon="info"})}

local function char(p)return (p or LP).Character end
local function hum(p)local c=char(p);return c and c:FindFirstChildOfClass("Humanoid")end
local function root(p)local c=char(p);return c and c:FindFirstChild("HumanoidRootPart")end
local function center()Camera=workspace.CurrentCamera;return Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)end
local function destroy(o)if typeof(o)=="Instance"then o:Destroy()elseif o and o.Remove then pcall(function()o:Remove()end)end end
local function playerNames()
	local t={"None"}
	for _,p in ipairs(Players:GetPlayers())do if p~=LP then t[#t+1]=p.Name end end
	table.sort(t,function(a,b)return a=="None" or (b~="None" and a<b)end)
	return t
end
local function getSelected()
	if not SelectedPlayer or SelectedPlayer=="None" then return nil end
	return Players:FindFirstChild(SelectedPlayer)
end
local function tpToPlayer()
	local p=getSelected();local r=root();local tr=p and root(p)
	if not p or not r or not tr then notify(L("NoPlayer"),"x",3)return end
	LastTeleportCF=r.CFrame
	r.CFrame=tr.CFrame*CFrame.new(0,0,3)
	notify(L("Teleported"),"map-pin",2)
end
local function bringPlayer()
	local p=getSelected();local r=root();local tr=p and root(p)
	if not p or not r or not tr then notify(L("NoPlayer"),"x",3)return end
	tr.CFrame=r.CFrame*CFrame.new(0,0,-4)
	tr.AssemblyLinearVelocity=Vector3.zero
end
local function spectatePlayer()
	local p=getSelected();local h=p and hum(p)
	if not h then notify(L("NoPlayer"),"x",3)return end
	Camera.CameraSubject=h
end
local function unspectate()
	local h=hum();if h then Camera.CameraSubject=h end
end
local function teleportBack()
	local r=root();if r and LastTeleportCF then r.CFrame=LastTeleportCF end
end

local HasDrawing=Drawing and Drawing.new
local FOVCircle
if HasDrawing then FOVCircle=Drawing.new("Circle");FOVCircle.Thickness=1;FOVCircle.NumSides=64;FOVCircle.Radius=Aim.FOV;FOVCircle.Filled=false;FOVCircle.Visible=false;FOVCircle.Color=Aim.FOVColor end
local CrossA,CrossB
if HasDrawing then CrossA=Drawing.new("Line");CrossB=Drawing.new("Line");CrossA.Thickness=1;CrossB.Thickness=1;CrossA.Visible=false;CrossB.Visible=false;CrossA.Color=Aim.FOVColor;CrossB.Color=Aim.FOVColor end
local function updateCrosshair()
	if not CrossA or not CrossB then return end
	local c=center();local n=Aim.CrosshairSize
	CrossA.From=Vector2.new(c.X-n,c.Y);CrossA.To=Vector2.new(c.X+n,c.Y)
	CrossB.From=Vector2.new(c.X,c.Y-n);CrossB.To=Vector2.new(c.X,c.Y+n)
	CrossA.Color=Aim.FOVColor;CrossB.Color=Aim.FOVColor;CrossA.Visible=Aim.Crosshair;CrossB.Visible=Aim.Crosshair
end
local function espColor(p)
	if EspC.Rainbow then return Color3.fromHSV((tick()%5)/5,1,1)end
	if EspC.TeamColor and p and p.TeamColor then return p.TeamColor.Color end
	return EspC.Color
end

local currentTarget,lastSwitch=nil,0
local function visible(part)
	if not Aim.VisibleCheck then return true end
	local c=part and part.Parent;if not c then return false end
	local p=RaycastParams.new();p.FilterType=Enum.RaycastFilterType.Exclude;p.FilterDescendantsInstances={LP.Character,Camera};p.IgnoreWater=true
	local r=workspace:Raycast(Camera.CFrame.Position,part.Position-Camera.CFrame.Position,p)
	return r and r.Instance and r.Instance:IsDescendantOf(c)
end
local function validTarget(part)
	if not part or not part.Parent then return false end
	local c=part.Parent;local plr=Players:GetPlayerFromCharacter(c);local h=c:FindFirstChildOfClass("Humanoid")
	if not h or h.Health<=0 then return false end
	if Aim.TeamCheck and plr and plr.Team==LP.Team then return false end
	if not visible(part)then return false end
	local pos,on=Camera:WorldToViewportPoint(part.Position)
	return on and (Vector2.new(pos.X,pos.Y)-center()).Magnitude<=Aim.FOV
end
local function closestTarget()
	local best,dist=nil,Aim.FOV
	for _,p in ipairs(Players:GetPlayers())do
		if p~=LP then
			local c=p.Character;local h=c and c:FindFirstChildOfClass("Humanoid");local part=c and c:FindFirstChild(Aim.TargetPart)
			if h and h.Health>0 and part and (not Aim.TeamCheck or p.Team~=LP.Team) and visible(part) then
				local pos,on=Camera:WorldToViewportPoint(part.Position)
				if on then local d=(Vector2.new(pos.X,pos.Y)-center()).Magnitude;if d<dist then dist=d;best=part end end
			end
		end
	end
	return best
end
local function updateAim()
	if not Aim.Enabled then currentTarget=nil;return end
	if not validTarget(currentTarget) and tick()-lastSwitch>=Aim.TargetSwitchDelay then currentTarget=closestTarget();lastSwitch=tick()end
	if currentTarget and validTarget(currentTarget)then
		local cf=CFrame.new(Camera.CFrame.Position,currentTarget.Position)
		Camera.CFrame=Camera.CFrame:Lerp(Camera.CFrame:Lerp(cf,Aim.Smoothness),Aim.Strength)
	end
end

local ESPObjects={}
local function removeESP(p)local d=ESPObjects[p];if not d then return end;for _,o in pairs(d)do destroy(o)end;ESPObjects[p]=nil end
local function espValid(p)
	if p==LP then return false end
	local c=p.Character;local h=c and c:FindFirstChildOfClass("Humanoid");local r=c and c:FindFirstChild("HumanoidRootPart")
	if not c or not h or not r or h.Health<=0 then return false end
	if EspC.TeamCheck and p.Team==LP.Team then return false end
	return (Camera.CFrame.Position-r.Position).Magnitude<=EspC.MaxDistance
end
local function createESP(p)
	removeESP(p)
	if not EspC.Enabled or not espValid(p)then return end
	local c=p.Character;local r=c and c:FindFirstChild("HumanoidRootPart");if not c or not r then return end
	local hi=Instance.new("Highlight");hi.Name="MirrorsESP_Highlight";hi.Adornee=c;hi.FillColor=EspC.Color;hi.OutlineColor=EspC.Color;hi.FillTransparency=EspC.Fill and EspC.FillTransparency or 1;hi.OutlineTransparency=EspC.OutlineTransparency;hi.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop;hi.Parent=c
	local bg=Instance.new("BillboardGui");bg.Name="MirrorsESP_Info";bg.Adornee=r;bg.Size=UDim2.new(0,220,0,80);bg.StudsOffset=Vector3.new(0,3.5,0);bg.AlwaysOnTop=true;bg.Parent=r
	local tx=Instance.new("TextLabel");tx.Size=UDim2.new(1,0,1,0);tx.BackgroundTransparency=1;tx.TextColor3=EspC.Color;tx.TextStrokeTransparency=0;tx.TextSize=EspC.TextSize;tx.Font=Enum.Font.GothamBold;tx.Parent=bg
	local line;if HasDrawing then line=Drawing.new("Line");line.Visible=false;line.Color=EspC.Color;line.Thickness=1.5 end
	ESPObjects[p]={Highlight=hi,Billboard=bg,Text=tx,Line=line}
end
local function clearESP()for p in pairs(ESPObjects)do removeESP(p)end end
local function refreshESP()for _,p in ipairs(Players:GetPlayers())do if p~=LP then createESP(p)end end end
local function updateESP()
	if not EspC.Enabled then return end
	for _,p in ipairs(Players:GetPlayers())do
		if p~=LP then
			if espValid(p)then
				if not ESPObjects[p]then createESP(p)end
				local d=ESPObjects[p];local c=p.Character;local h=c and c:FindFirstChildOfClass("Humanoid");local r=c and c:FindFirstChild("HumanoidRootPart")
				if d and h and r then
					local cc=espColor(p)
					d.Highlight.FillColor=cc;d.Highlight.OutlineColor=cc;d.Highlight.FillTransparency=EspC.Fill and EspC.FillTransparency or 1;d.Highlight.OutlineTransparency=EspC.OutlineTransparency
					d.Text.TextColor3=cc;d.Text.TextSize=EspC.TextSize
					local a={};local dst=math.floor((Camera.CFrame.Position-r.Position).Magnitude)
					if EspC.ShowNames then a[#a+1]=p.Name end
					if EspC.ShowHealth then a[#a+1]="HP: "..math.floor(h.Health).."/"..math.floor(h.MaxHealth)end
					if EspC.ShowDistance then a[#a+1]=dst.." studs"end
					d.Text.Text=table.concat(a,"\n");d.Billboard.Enabled=#a>0
					if d.Line then local pos,on=Camera:WorldToViewportPoint(r.Position);d.Line.Visible=EspC.ShowLines and on;if d.Line.Visible then local y=Camera.ViewportSize.Y;if EspC.TracerOrigin=="Top"then y=0 elseif EspC.TracerOrigin=="Middle"then y=Camera.ViewportSize.Y/2 end;d.Line.From=Vector2.new(Camera.ViewportSize.X/2,y);d.Line.To=Vector2.new(pos.X,pos.Y);d.Line.Color=cc end end
				end
			else removeESP(p)end
		end
	end
end

-- TABELA TOTALMENTE EXCLUSIVA PARA O HITBOX (Evita conflito com o Freeze)
local backupPropriedadesHitbox = {}

local function resetHit()
	for part, dados in pairs(backupPropriedadesHitbox) do
		if part and part.Parent then
			pcall(function()
				part.Size = dados.Size
				part.Transparency = dados.Transparency
				part.Color = dados.Color
				part.Material = dados.Material
				part.CanCollide = dados.CanCollide
			end)
		end
	end
	backupPropriedadesHitbox = {}
end

local function validHit(p)
	if p == LP or not p.Character then return false end
	local h = hum(p);if not h or h.Health <= 0 then return false end
	if HitC.TeamCheck and p.Team == LP.Team then return false end
	return true
end

local function applyHit(p)
	if not HitC.Enabled or not validHit(p) then return end
	local part = root(p)
	if not part or not part:IsA("BasePart") then return end
	
	local s = math.clamp(tonumber(HitC.Size) or 10, 2, HitC.MaxSize or 200)
	local tamanhoAlvo = Vector3.new(s, s, s)
	
	-- Se ja estiver no tamanho certo, ignora (Evita conflito de re-aplicação com o Freeze)
	if part.Size == tamanhoAlvo then return end
	
	-- Salva na tabela exclusiva do Hitbox
	if not backupPropriedadesHitbox[part] then
		backupPropriedadesHitbox[part] = {
			Size = part.Size,
			Transparency = part.Transparency,
			Color = part.Color,
			Material = part.Material,
			CanCollide = part.CanCollide
		}
	end
	
	-- Aplica exatamente as configuracoes do teste que funcionou!
	part.Size = tamanhoAlvo
	part.Transparency = HitC.Transparency or 0.6
	part.Color = HitC.Color or Color3.fromRGB(255, 0, 0)
	part.Material = Enum.Material.Neon
	part.CanCollide = false
end

local function updateHit()
	if HitC.Enabled then 
		for _, p in ipairs(Players:GetPlayers()) do 
			if validHit(p) then
				applyHit(p) 
			end
		end 
	else
		resetHit()
	end
end

local frozen={}
local function freezePlayer(p)
	if not p or p==LP or not p.Character then return end
	local r=root(p);local h=hum(p)
	if r then
		frozen[p]=frozen[p] or {Anchored=r.Anchored,WalkSpeed=h and h.WalkSpeed,JumpPower=h and h.JumpPower}
		r.Anchored=true
		r.AssemblyLinearVelocity=Vector3.zero
		r.AssemblyAngularVelocity=Vector3.zero
	end
	if h then h.WalkSpeed=0;h.JumpPower=0;pcall(function()h.UseJumpPower=true end)end
end
local function unfreezePlayer(p)
	local data=frozen[p]
	local r=root(p);local h=hum(p)
	if r then r.Anchored=data and data.Anchored or false end
	if h then h.WalkSpeed=(data and data.WalkSpeed) or 16;h.JumpPower=(data and data.JumpPower) or 50 end
	frozen[p]=nil
end
local function freezeSelected()
	local p=getSelected()
	if not p then notify(L("NoPlayer"),"x",2)return end
	freezePlayer(p)
end
local function freezeAll()
	for _,p in ipairs(Players:GetPlayers())do if p~=LP then freezePlayer(p)end end
end
local function unfreezeAll()
	for p in pairs(frozen)do unfreezePlayer(p)end
end
local function applyMove()
	local h = hum()
	if h then 
		h.WalkSpeed = MiscC.WalkSpeed
		h.UseJumpPower = true 
		h.JumpPower = MiscC.JumpPower
		
		-- Correção para o pulo não travar quando estiver muito alto
		if MiscC.JumpPower > 150 then
			local r = root()
			if r and h.Jump then
				r.AssemblyLinearVelocity = Vector3.new(r.AssemblyLinearVelocity.X, MiscC.JumpPower, r.AssemblyLinearVelocity.Z)
			end
		end
	end
end


local noclipConn = nil
local function setNoclip(on)
	MiscC.Noclip = on and true or false
	if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
	
	if MiscC.Noclip then
		noclipConn = RunService.Stepped:Connect(function()
			if not MiscC.Noclip then return end
			local c = player.Character
			if not c then return end
			
			for _, v in pairs(c:GetDescendants()) do
				if v:IsA("BasePart") and v.CanCollide then
					v.CanCollide = false
				end
			end
		end)
	end
end
-- Salva os valores originais do Lighting de forma segura
local originalLighting = {
	Ambient = Lighting.Ambient,
	ColorShift_Bottom = Lighting.ColorShift_Bottom,
	ColorShift_Top = Lighting.ColorShift_Top,
	Brightness = Lighting.Brightness,
	ClockTime = Lighting.ClockTime,
	GlobalShadows = Lighting.GlobalShadows,
	FogEnd = Lighting.FogEnd,
	FogStart = Lighting.FogStart
}

local function updateWorldVisuals()
	-- --- NO FOG ---
	if MiscC.NoFog then 
		Lighting.FogEnd = 100000
		Lighting.FogStart = 0
	else 
		Lighting.FogEnd = originalLighting.FogEnd
		Lighting.FogStart = originalLighting.FogStart
	end

	-- --- FULLBRIGHT ---
	if MiscC.Fullbright then
		Lighting.Ambient = Color3.new(1, 1, 1)
		Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
		Lighting.ColorShift_Top = Color3.new(1, 1, 1)
		Lighting.Brightness = 4
		Lighting.ClockTime = 14
		Lighting.GlobalShadows = false
	else
		Lighting.Ambient = originalLighting.Ambient
		Lighting.ColorShift_Bottom = originalLighting.ColorShift_Bottom
		Lighting.ColorShift_Top = originalLighting.ColorShift_Top
		Lighting.Brightness = originalLighting.Brightness
		Lighting.ClockTime = originalLighting.ClockTime
		Lighting.GlobalShadows = originalLighting.GlobalShadows
	end
end

-- Em vez de usar LightingChanged, usamos um loop leve em segundo plano para forçar os valores
task.spawn(function()
	while true do
		task.wait(0.1) -- Roda 10 vezes por segundo, leve e não gera lag
		if MiscC.Fullbright or MiscC.NoFog then
			updateWorldVisuals()
		end
	end
end)
local function antiVoidGuard()
	if not MiscC.AntiVoid then return end
	
	local c = char()
	local r = root()
	local h = hum()
	
	if c and r and h then
		-- Limite onde o Roblox destrói o boneco (geralmente -500)
		local voidThreshold = workspace.FallenPartsDestroyHeight
		
		-- Define uma "zona de perigo" um pouco acima do limite do void (ex: 50 studs acima do void)
		local dangerZone = voidThreshold + 50 
		
		-- Só atualiza a posição se você estiver BEM acima da zona de perigo do void
		if r.Position.Y > dangerZone then
			-- Garante que você está pisando firme no chão e não voando ou caindo
			if h.FloorMaterial ~= Enum.Material.Air then
				lastSafePosition = r.CFrame
			end
		elseif r.Position.Y <= voidThreshold + 20 then
			-- Se você invadir a linha de salvamento (perto do fundo do void), teleporta de volta
			if lastSafePosition then
				r.AssemblyLinearVelocity = Vector3.zero -- Zera o impulso para não bugar a física
				r.CFrame = lastSafePosition
			else
				-- Safe-guard caso comece o jogo já caindo: joga para cima
				r.AssemblyLinearVelocity = Vector3.zero
				r.CFrame = r.CFrame + Vector3.new(0, 150, 0)
			end
		end
	end
end
local function fakeDeath()
	local h = hum(); local r = root()
	if not h or not r then return end
	
	h.PlatformStand = true
	-- Joga o boneco longe e gira (Efeito forte)
	r.AssemblyLinearVelocity = Vector3.new(math.random(-25,25), 55, math.random(-25,25))
	r.AssemblyAngularVelocity = Vector3.new(25, 35, 25)
	
	-- Força o corpo a ficar horizontal em relação ao chão
	local torso = r.Parent:FindFirstChild("Torso") or r.Parent:FindFirstChild("UpperTorso")
	if torso then
		local rootJoint = r:FindFirstChild("RootJoint") or torso:FindFirstChild("RootJoint")
		if rootJoint then
			rootJoint.C0 = rootJoint.C0 * CFrame.Angles(math.rad(90), 0, 0)
		end
	end
end

local function standUp()
	local h = hum(); local r = root()
	if not h or not r then return end
	
	h.PlatformStand = false
	h:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
	h:ChangeState(Enum.HumanoidStateType.GettingUp)
	
	-- Reseta a rotação do corpo ao normal
	local torso = r.Parent:FindFirstChild("Torso") or r.Parent:FindFirstChild("UpperTorso")
	if torso then
		local rootJoint = r:FindFirstChild("RootJoint") or torso:FindFirstChild("RootJoint")
		if rootJoint then
			rootJoint.C0 = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(-90), math.rad(180), 0) -- Padrão do Roblox
		end
	end
	
	r.AssemblyLinearVelocity = Vector3.zero
	r.AssemblyAngularVelocity = Vector3.zero
end

local lagT,lagHold,lagToken=0,false,0
local function stopFakeLag()
	lagToken+=1
	lagT=0
	lagHold=false
	local r=root();local h=hum()
	if r then
		r.Anchored=false
		r.AssemblyLinearVelocity=Vector3.zero
		r.AssemblyAngularVelocity=Vector3.zero
	end
	if h then
		h.PlatformStand=false
		h.Sit=false
		pcall(function()h:ChangeState(Enum.HumanoidStateType.Running)end)
	end
end
local function fakeLag(dt)
	if not TrollC.FakeLag then return end
	if lagHold then return end
	lagT+=dt
	if lagT>=math.max(TrollC.FakeLagRate,.12) then
		lagT=0
		local r=root()
		if r then
			lagHold=true
			lagToken+=1
			local token=lagToken
			r.Anchored=true
			task.delay(math.clamp(TrollC.FakeLagHold,.03,.14),function()
				if token==lagToken then
					local rr=root()
					if rr then rr.Anchored=false end
					lagHold=false
				end
			end)
		end
	end
end

local function stopHeadSit()
	local r=root();local h=hum()
	if h then
		h.Sit=false
		h.PlatformStand=false
		pcall(function()h:ChangeState(Enum.HumanoidStateType.GettingUp)end)
		task.delay(.15,function()local hh=hum();if hh then pcall(function()hh:ChangeState(Enum.HumanoidStateType.Running)end)end end)
	end
	if r then
		r.AssemblyLinearVelocity=Vector3.zero
		r.AssemblyAngularVelocity=Vector3.zero
	end
end
local function updateHeadSit()
	if not TrollC.HeadSit then return end
	local p=getSelected();local r=root();local tr=p and root(p);local h=hum()
	if not r or not tr then return end
	r.AssemblyLinearVelocity=Vector3.zero
	r.AssemblyAngularVelocity=Vector3.zero
	r.CFrame=tr.CFrame*CFrame.new(0,3.15,0)
	if h then h.Sit=true end
end

local orbitA=0
local function updateSpin(dt)
	local r=root()
	if TrollC.Spin and r then r.CFrame=r.CFrame*CFrame.Angles(0,math.rad(TrollC.SpinSpeed)*dt*12,0)end
end
local function updateOrbit(dt)
	if not TrollC.Orbit then return end
	local p=getSelected();local r=root();local tr=p and root(p)
	if not r or not tr then return end
	orbitA+=dt*TrollC.OrbitSpeed
	local rad,ht=TrollC.OrbitRadius,TrollC.OrbitHeight
	local off
	if TrollC.OrbitMode=="UpDown" then off=Vector3.new(math.cos(orbitA)*rad,ht+math.sin(orbitA*2)*rad,math.sin(orbitA)*rad)
	elseif TrollC.OrbitMode=="LeftRight" then off=Vector3.new(math.sin(orbitA)*rad,ht,0)
	elseif TrollC.OrbitMode=="Diagonal" then off=Vector3.new(math.cos(orbitA)*rad,ht+math.cos(orbitA)*rad,math.sin(orbitA)*rad)
	else off=Vector3.new(math.cos(orbitA)*rad,ht,math.sin(orbitA)*rad)end
	r.CFrame=CFrame.new(tr.Position+off,tr.Position)
end
local annoyT=0
local function ghost()
	if not TrollC.Ghost then return end
	local r=root();if not r then return end
	local p=Instance.new("Part");p.Name="MirrorsGhost";p.Anchored=true;p.CanCollide=false;p.CanQuery=false;p.Transparency=.72;p.Size=Vector3.new(2,2.8,1);p.CFrame=r.CFrame;p.Material=Enum.Material.Neon;p.Parent=workspace
	task.delay(.45,function()if p then p:Destroy()end end)
end
local function updateAnnoy(dt)
	if not TrollC.Annoy then return end
	annoyT+=dt
	if annoyT<TrollC.AnnoySpeed then return end
	annoyT=0
	local p=getSelected();local r=root();local tr=p and root(p)
	if not r or not tr then return end
	local off
	if TrollC.AnnoyMode=="Cross" then
		local a={Vector3.new(4,1.5,0),Vector3.new(-4,1.5,0),Vector3.new(0,1.5,4),Vector3.new(0,1.5,-4)}
		off=a[(math.floor(tick()*8)%4)+1]
	elseif TrollC.AnnoyMode=="Random" then off=Vector3.new(math.random(-5,5),math.random(1,5),math.random(-5,5))
	else off=Vector3.new(math.cos(tick()*12)*4,1.5,math.sin(tick()*12)*4)end
	r.CFrame=CFrame.new(tr.Position+off,tr.Position)
	ghost()
end

local function god()
	local h=hum();local c=char()
	if not h then return end
	if OpC.GodInf then
		h.BreakJointsOnDeath=false;pcall(function()h.RequiresNeck=false end)
		h.MaxHealth=math.huge;h.Health=math.huge
		if c and not c:FindFirstChild("MirrorsFF")then local ff=Instance.new("ForceField");ff.Name="MirrorsFF";ff.Visible=false;ff.Parent=c end
	elseif OpC.God100 then
		h.MaxHealth=math.max(h.MaxHealth,100);if h.Health<100 then h.Health=100 end
	else
		local ff=c and c:FindFirstChild("MirrorsFF");if ff then ff:Destroy()end
	end
end
local function antiFling()
	-- Verifica se o botão do menu está ligado
	if not OpC.AntiFling then return end
	
	-- O código exato que você mandou, usando as variáveis do seu script (LP e Players)
	for _, CoPlayer in pairs(Players:GetChildren()) do
		if CoPlayer ~= LP and CoPlayer.Character then
			for _, Part in pairs(CoPlayer.Character:GetChildren()) do
				if Part.Name == "HumanoidRootPart" then
					Part.CanCollide = false
				end
			end
		end
	end
 
	for _, Accessory in pairs(workspace:GetChildren()) do
		if Accessory:IsA("Accessory") and Accessory:FindFirstChildWhichIsA("Part") then
			Accessory:FindFirstChildWhichIsA("Part"):Destroy()
		end
	end
end

local flingRun=false
pcall(function()
	if not RS:FindFirstChild("juisdfj0i32i0eidsuf0iok")then
		local detection=Instance.new("Decal")
		detection.Name="juisdfj0i32i0eidsuf0iok"
		detection.Parent=RS
	end
end)
local function stopFling()
	flingRun=false
	task.defer(function()
		local r=root()
		if r and r.Parent then
			r.AssemblyLinearVelocity=Vector3.zero
			r.AssemblyAngularVelocity=Vector3.zero
			r.Velocity=Vector3.zero
			r.RotVelocity=Vector3.zero
		end
		local h=hum()
		if h then h.PlatformStand=false;h.Sit=false end
	end)
end
local function startFling()
	if flingRun then return end
	flingRun=true
	task.spawn(function()
		local movel=.1
		while flingRun do
			RunService.Heartbeat:Wait()
			local r=root();local h=hum()
			if r and h and h.Health>0 then
				local vel=r.Velocity
				local jumpY=vel.Y
				r.Velocity=vel*OpC.FlingPower+Vector3.new(0,OpC.FlingPower,0)
				RunService.RenderStepped:Wait()
				if not flingRun then break end
				if r and r.Parent then r.Velocity=Vector3.new(vel.X,jumpY,vel.Z)end
				RunService.Stepped:Wait()
				if r and r.Parent then r.Velocity=Vector3.new(vel.X,jumpY,vel.Z)+Vector3.new(0,movel+OpC.FlingPulse,0)end
				movel=-movel
			end
		end
	end)
end

local function getServer(small)
	local cursor,best,candidates=nil,nil,{}
	for _=1,10 do
		local url="https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100&excludeFullGames=true"..(cursor and "&cursor="..cursor or "")
		local ok,s=pcall(function()return Http:JSONDecode(game:HttpGet(url))end)
		if not ok or not s or not s.data then break end
		for _,v in ipairs(s.data)do
			if v.id and v.id~=game.JobId and v.playing and v.maxPlayers and v.playing<v.maxPlayers then
				if small then
					if v.playing<5 and (not best or v.playing<best.playing)then best=v end
				else
					candidates[#candidates+1]=v
				end
			end
		end
		if small and best then break end
		cursor=s.nextPageCursor
		if not cursor or (not small and #candidates>=60) then break end
	end
	if small then return best end
	if #candidates>0 then return candidates[math.random(1,#candidates)]end
end
local function hop()
	local s=getServer(false)
	if s then TP:TeleportToPlaceInstance(game.PlaceId,s.id,LP)else notify(L("NoServer"),"x",3)end
end
local function smallServer()
	local s=getServer(true)
	if s then TP:TeleportToPlaceInstance(game.PlaceId,s.id,LP)else notify(L("NoServer"),"x",3)end
end
local function joinJob()
	if JobInput and #JobInput>5 then TP:TeleportToPlaceInstance(game.PlaceId,JobInput,LP)end
end
local function copyJob()
	if typeof(setclipboard)=="function" then setclipboard(game.JobId);notify(L("Copied"),"copy",2)else notify(game.JobId,"copy",5)end
end

local function currentConfig()
	return {Aim=Aim,EspC=EspC,MiscC=MiscC,HitC=HitC,OpC=OpC,TrollC=TrollC,Lang=Lang,ProfileName=ProfileName}
end
local function applyConfig(d)
	if type(d)~="table"then return end
	for k,v in pairs(d.Aim or {})do Aim[k]=v end
	for k,v in pairs(d.EspC or {})do EspC[k]=v end
	for k,v in pairs(d.MiscC or {})do MiscC[k]=v end
	for k,v in pairs(d.HitC or {})do HitC[k]=v end
	for k,v in pairs(d.OpC or {})do OpC[k]=v end
	for k,v in pairs(d.TrollC or {})do TrollC[k]=v end
	if d.Lang and TXT[d.Lang]then saveLang(d.Lang)end
end
local function profilePath()
	mk();local n=tostring(ProfileName or "default"):gsub("[^%w_%-%s]",""):gsub("%s+","_");if n==""then n="default"end
	return CONFIG_FOLDER.."/"..n..".json"
end
local function exportConfig()
	local raw=Http:JSONEncode(currentConfig())
	if typeof(setclipboard)=="function"then setclipboard(raw);notify(L("Copied"),"copy",2)else notify(raw,"copy",8)end
end
local function importConfig()
	if typeof(getclipboard)~="function"then notify(L("NotConfigured"),"x",3)return end
	local ok,d=pcall(function()return Http:JSONDecode(getclipboard())end)
	if ok then applyConfig(d);applyMove();setNoclip(MiscC.Noclip);updateWorldVisuals();updateHit();refreshESP();notify(L("LoadedConfig"),"folder-open",2)end
end
local function saveProfile()
	if fs()then writefile(profilePath(),Http:JSONEncode(currentConfig()))end
end
local function loadProfile()
	if fs()and isfile(profilePath())then local ok,d=pcall(function()return Http:JSONDecode(readfile(profilePath()))end);if ok then applyConfig(d);applyMove();setNoclip(MiscC.Noclip);updateWorldVisuals();updateHit();refreshESP()end end
end
local function safeStart()
	Aim.Enabled=false;Aim.FOVVisible=false;EspC.Enabled=false;currentTarget=nil;if FOVCircle then FOVCircle.Visible=false end;clearESP()
end
local function section(tab,key)pcall(function()tab:Section({Title=L(key),Box=false,TextSize=17})end)end

local ServerStart=os.clock()
local function niceTime(sec)
	sec=math.max(0,math.floor(tonumber(sec) or 0))
	local d=math.floor(sec/86400);sec=sec%86400
	local h=math.floor(sec/3600);sec=sec%3600
	local m=math.floor(sec/60);local ss=sec%60
	if d>0 then return string.format("%dd %02dh %02dm %02ds",d,h,m,ss)end
	if h>0 then return string.format("%02dh %02dm %02ds",h,m,ss)end
	return string.format("%02dm %02ds",m,ss)
end
local function shortId(v)
	v=tostring(v or "")
	if #v>18 then return v:sub(1,8).."..."..v:sub(-6)end
	return v
end
local function getPingText()
	local ok,p=pcall(function()
		local stats=game:GetService("Stats")
		local item=stats.Network.ServerStatsItem["Data Ping"]
		return item and item:GetValueString() or "N/A"
	end)
	return ok and tostring(p) or "N/A"
end
local function serverAge()
	return workspace.DistributedGameTime and workspace.DistributedGameTime>0 and workspace.DistributedGameTime or os.clock()-ServerStart
end
local function playerPositionText()
	local r=root()
	return r and (math.floor(r.Position.X)..", "..math.floor(r.Position.Y)..", "..math.floor(r.Position.Z)) or "N/A"
end
local function serverInfoText()
	local pls=Players:GetPlayers()
	local lines={
		L("ServerPlayers")..": "..#pls.."/"..Players.MaxPlayers,
		L("ServerTime")..": "..niceTime(serverAge()),
		"Ping: "..getPingText(),
		"PlaceId: "..tostring(game.PlaceId),
		"JobId: "..shortId(game.JobId),
		"GameId: "..tostring(game.GameId),
		"Gravity: "..tostring(math.floor(workspace.Gravity)),
		"Executor FS: "..(fs() and L("Yes") or L("No"))
	}
	return table.concat(lines,"\n")
end
local function playerInfoText()
	local h=hum()
	return table.concat({
		"Name: "..LP.Name,
		"UserId: "..tostring(LP.UserId),
		L("AccountAge")..": "..tostring(LP.AccountAge).." "..L("Days"),
		L("Team")..": "..(LP.Team and LP.Team.Name or L("None")),
		L("Health")..": "..(h and (math.floor(h.Health).."/"..math.floor(h.MaxHealth)) or "N/A"),
		L("Position")..": "..playerPositionText()
	},"\n")
end
local function copyServerInfo()
	local txt="Mirrors Hub - Status\n"..serverInfoText().."\n\n"..L("PlayerInfo").."\n"..playerInfoText()
	if typeof(setclipboard)=="function" then setclipboard(txt);notify(L("Copied"),"copy",2)else notify(txt,"info",8)end
end

local function para(tab,title,desc,color)pcall(function()tab:Paragraph({Title=title,Desc=desc,Color=color or "Blue",Locked=false})end)end
local function btn(tab,t,cb)pcall(function()tab:Button({Title=L(t),Desc="",Locked=false,Callback=cb})end)end
local function btnTitle(tab,t,cb)pcall(function()tab:Button({Title=t,Desc="",Locked=false,Callback=cb})end)end
local function tog(tab,t,flag,val,cb)pcall(function()tab:Toggle({Title=L(t),Desc="",Flag=flag,Type="Checkbox",Value=val,Callback=cb})end)end
local function slid(tab,t,flag,min,max,def,step,cb)pcall(function()tab:Slider({Title=L(t),Desc="",Flag=flag,Step=step or 1,Value={Min=min,Max=max,Default=def},Callback=cb})end)end
local function drop(tab,t,flag,vals,val,cb) local d; pcall(function() d=tab:Dropdown({Title=L(t),Desc="",Flag=flag,Values=vals,Value=val,Callback=cb}) end); return d end
local function col(tab,t,flag,def,cb)pcall(function()tab:Colorpicker({Title=L(t),Desc="",Flag=flag,Default=def,Transparency=0,Locked=false,Callback=cb})end)end
local function input(tab,t,ph,cb)
	pcall(function()
		if tab.Input then tab:Input({Title=L(t),Placeholder=ph or "",Callback=cb})
		elseif tab.Textbox then tab:Textbox({Title=L(t),Placeholder=ph or "",Callback=cb})end
	end)
end

local DISCORD_LINK="https://discord.gg/YZEg6FyRSF"
local function copyDiscord()
	if typeof(setclipboard)=="function"then setclipboard(DISCORD_LINK);notify(L("Copied"),"copy",2)else notify(DISCORD_LINK,"copy",8)end
end
local function runExternal(src)
	local ok,err=pcall(function()loadstring(game:HttpGet(src,true))()end)
	if not ok then notify(tostring(err),"x",4)end
end
local function boostFPS()
	pcall(function()if typeof(setfpscap)=="function"then setfpscap(120)end end)
	pcall(function()settings().Rendering.QualityLevel=Enum.QualityLevel.Level01 end)
	pcall(function()UserSettings():GetService("UserGameSettings").SavedQualityLevel=Enum.SavedQualitySetting.QualityLevel1 end)
	pcall(function()Lighting.GlobalShadows=false;Lighting.FogEnd=100000;Lighting.Brightness=1;Lighting.ClockTime=14 end)
	pcall(function()workspace.Terrain.WaterWaveSize=0;workspace.Terrain.WaterWaveSpeed=0;workspace.Terrain.WaterReflectance=0;workspace.Terrain.WaterTransparency=1 end)
	for _,v in ipairs(game:GetDescendants())do
		pcall(function()
			if v:IsA("BasePart")then v.Material=Enum.Material.Plastic;v.Reflectance=0
			elseif v:IsA("Decal")or v:IsA("Texture")then v.Transparency=1
			elseif v:IsA("ParticleEmitter")or v:IsA("Trail")or v:IsA("Beam")then v.Enabled=false
			elseif v:IsA("PointLight")or v:IsA("SpotLight")or v:IsA("SurfaceLight")then v.Enabled=false
			elseif v:IsA("Explosion")then v.Visible=false
			end
		end)
	end
	notify(L("BoostApplied"),"zap",4)
end
section(Tabs.Scripts,"Scripts")
btnTitle(Tabs.Scripts,"Infinite Yield FE",function()runExternal("https://raw.githubusercontent.com/DarkNetworks/Infinite-Yield/main/latest.lua")end)
btnTitle(Tabs.Scripts,"Fly V3",function()runExternal("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt")end)
btnTitle(Tabs.Scripts,"Noclip",function()runExternal("https://rawscripts.net/raw/Universal-Script-Noclip-Open-source-10442")end)
btnTitle(Tabs.Scripts,"Touch Fling",function()runExternal("https://pastebin.com/raw/LgZwZ7ZB")end)
section(Tabs.Info,"Info");para(Tabs.Info,L("HomeTitle"),L("HomeDesc"),"Blue");para(Tabs.Info,L("BetaTitle"),L("BetaDesc"),"Orange");para(Tabs.Info,L("DiscordTitle"),L("DiscordDesc").."\n"..DISCORD_LINK,"Red");para(Tabs.Info,L("StatusTitle"),L("StatusDesc"),"Green");btn(Tabs.Info,"CopyDiscord",copyDiscord)
section(Tabs.Status,"Server");btn(Tabs.Status,"ShowPlayers",function()notify(L("ServerPlayers")..": "..#Players:GetPlayers().."/"..Players.MaxPlayers,"users",4)end);btn(Tabs.Status,"ShowServerTime",function()notify(L("ServerTime")..": "..niceTime(serverAge()),"clock",4)end);btn(Tabs.Status,"ShowPing",function()notify("Ping: "..getPingText(),"wifi",4)end);btn(Tabs.Status,"ShowPlaceId",function()notify("PlaceId: "..tostring(game.PlaceId),"map",4)end);btn(Tabs.Status,"ShowJobId",function()notify("JobId: "..tostring(game.JobId),"server",6)end);btn(Tabs.Status,"ShowGameId",function()notify("GameId: "..tostring(game.GameId),"database",4)end);btn(Tabs.Status,"ShowGravity",function()notify("Gravity: "..tostring(math.floor(workspace.Gravity)),"activity",4)end);btn(Tabs.Status,"ShowExecutor",function()notify("Executor FS: "..(fs() and L("Yes") or L("No")),"folder",4)end);btn(Tabs.Status,"ShowAccountAge",function()notify(L("AccountAge")..": "..tostring(LP.AccountAge).." "..L("Days"),"user",4)end);btn(Tabs.Status,"ShowPosition",function()notify(L("Position")..": "..playerPositionText(),"map-pin",4)end);btn(Tabs.Status,"CopyStatus",copyServerInfo);btn(Tabs.Status,"CopyJobId",copyJob);btn(Tabs.Status,"RefreshStatus",function()notify(serverInfoText().."\n\n"..playerInfoText(),"activity",7)end)
section(Tabs.Aimbot,"Main");tog(Tabs.Aimbot,"EnableAimbot","AimbotEnabled",false,function(v)Aim.Enabled=v;if not v then currentTarget=nil end end);tog(Tabs.Aimbot,"TeamCheck","AimbotTeamCheck",false,function(v)Aim.TeamCheck=v;currentTarget=nil end);tog(Tabs.Aimbot,"VisibleCheck","AimbotVisibleCheck",false,function(v)Aim.VisibleCheck=v;currentTarget=nil end);drop(Tabs.Aimbot,"TargetPart","AimbotTargetPart",{"Head","HumanoidRootPart"},"Head",function(v)Aim.TargetPart=v;currentTarget=nil end)
section(Tabs.Aimbot,"FOV");slid(Tabs.Aimbot,"AimbotFOV","AimbotFOV",10,500,Aim.FOV,1,function(v)Aim.FOV=v;if FOVCircle then FOVCircle.Radius=v end end);tog(Tabs.Aimbot,"ShowFOV","AimbotFOVVisible",false,function(v)Aim.FOVVisible=v;if FOVCircle then FOVCircle.Visible=v end end);col(Tabs.Aimbot,"FOVColor","AimbotFOVColor",Aim.FOVColor,function(v)Aim.FOVColor=v;if FOVCircle then FOVCircle.Color=v end end);tog(Tabs.Aimbot,"Crosshair","AimbotCrosshair",false,function(v)Aim.Crosshair=v end);slid(Tabs.Aimbot,"CrosshairSize","AimbotCrosshairSize",4,30,Aim.CrosshairSize,1,function(v)Aim.CrosshairSize=v end)
section(Tabs.Aimbot,"Tuning");slid(Tabs.Aimbot,"Smoothness","AimbotSmoothness",1,100,35,1,function(v)Aim.Smoothness=v/388 end);slid(Tabs.Aimbot,"Strength","AimbotStrength",1,100,100,1,function(v)Aim.Strength=v/100 end);slid(Tabs.Aimbot,"SwitchDelay","AimbotSwitchDelay",0,2,Aim.TargetSwitchDelay,.05,function(v)Aim.TargetSwitchDelay=v end)
section(Tabs.ESP,"Main");tog(Tabs.ESP,"EnableESP","ESPEnabled",false,function(v)EspC.Enabled=v;if v then refreshESP()else clearESP()end end);col(Tabs.ESP,"ESPColor","ESPColor",EspC.Color,function(v)EspC.Color=v end);tog(Tabs.ESP,"TeamCheck","ESPTeamCheck",false,function(v)EspC.TeamCheck=v;refreshESP()end);tog(Tabs.ESP,"TeamColor","ESPTeamColor",false,function(v)EspC.TeamColor=v end);tog(Tabs.ESP,"RainbowESP","ESPRainbow",false,function(v)EspC.Rainbow=v end)
section(Tabs.ESP,"Info");tog(Tabs.ESP,"ShowNames","ESPShowNames",false,function(v)EspC.ShowNames=v end);tog(Tabs.ESP,"ShowHealth","ESPShowHealth",false,function(v)EspC.ShowHealth=v end);tog(Tabs.ESP,"ShowDistance","ESPShowDistance",false,function(v)EspC.ShowDistance=v end);tog(Tabs.ESP,"ShowLines","ESPShowLines",false,function(v)EspC.ShowLines=v end);drop(Tabs.ESP,"TracerOrigin","ESPTracerOrigin",{"Top","Middle","Bottom"},"Bottom",function(v)EspC.TracerOrigin=v end)
section(Tabs.ESP,"Visual");tog(Tabs.ESP,"FillBox","ESPFill",false,function(v)EspC.Fill=v end);slid(Tabs.ESP,"FillTransparency","ESPFillTransparency",0,100,75,1,function(v)EspC.FillTransparency=v/100 end);slid(Tabs.ESP,"OutlineTransparency","ESPOutlineTransparency",0,100,0,1,function(v)EspC.OutlineTransparency=v/100 end);slid(Tabs.ESP,"TextSize","ESPTextSize",8,30,EspC.TextSize,1,function(v)EspC.TextSize=v end);slid(Tabs.ESP,"MaxDistance","ESPMaxDistance",100,10000,EspC.MaxDistance,50,function(v)EspC.MaxDistance=v end);btn(Tabs.ESP,"RefreshESP",function()refreshESP();notify(L("ESPUpdated"),"refresh-cw",2)end)
section(Tabs.Misc,"Movement");slid(Tabs.Misc,"WalkSpeed","MiscWalkSpeed",16,200,MiscC.WalkSpeed,1,function(v)MiscC.WalkSpeed=v;applyMove()end);slid(Tabs.Misc,"JumpPower","MiscJumpPower",50,300,MiscC.JumpPower,1,function(v)MiscC.JumpPower=v;applyMove()end);tog(Tabs.Misc,"Noclip","MiscNoclip",false,function(v)setNoclip(v)end);tog(Tabs.Misc,"InfiniteJump","MiscInfiniteJump",false,function(v)MiscC.InfiniteJump=v end)
section(Tabs.Misc,"Utility");tog(Tabs.Misc,"AntiAFK","MiscAntiAFK",false,function(v)MiscC.AntiAFK=v end);btn(Tabs.Misc,"ResetCharacter",function()local h=hum();if h then h.Health=0 end end);tog(Tabs.Misc,"AntiVoid","MiscAntiVoid",true,function(v)MiscC.AntiVoid=v end);tog(Tabs.Misc,"Fullbright","MiscFullbright",false,function(v)MiscC.Fullbright=v;updateWorldVisuals()end);tog(Tabs.Misc,"NoFog","MiscNoFog",false,function(v)MiscC.NoFog=v;updateWorldVisuals()end)
section(Tabs.Misc,"Hitbox");tog(Tabs.Misc,"EnableHitbox","HitboxEnabled",false,function(v)HitC.Enabled=v;if not v then resetHit()else updateHit()end end);slid(Tabs.Misc,"HitboxSize","HitboxSize",2,200,HitC.Size,1,function(v)HitC.Size=math.clamp(v,2,HitC.MaxSize);updateHit()end);slid(Tabs.Misc,"HitboxTransparency","HitboxTransparency",0,100,math.floor(HitC.Transparency*100),1,function(v)HitC.Transparency=v/100;updateHit()end);col(Tabs.Misc,"HitboxColor","HitboxColor",HitC.Color,function(v)HitC.Color=v;updateHit()end);tog(Tabs.Misc,"HitboxTeam","HitboxTeamCheck",false,function(v)HitC.TeamCheck=v;resetHit();updateHit()end);btn(Tabs.Misc,"ResetHitboxes",function()resetHit();notify(L("HitboxesReset"),"rotate-ccw",3)end)
section(Tabs.OP,"God");tog(Tabs.OP,"God100","OPGod100",false,function(v)OpC.God100=v;if v then OpC.GodInf=false end end);tog(Tabs.OP,"GodInf","OPGodInf",false,function(v)OpC.GodInf=v;if v then OpC.God100=false end end);
section(Tabs.OP,"Protection");tog(Tabs.OP,"AntiFling","OPAntiFling",false,function(v)OpC.AntiFling=v end)
section(Tabs.OP,"Fling");tog(Tabs.OP,"TouchFling","OPTouchFling",false,function(v)OpC.TouchFling=v;if v then startFling()else stopFling()end end);slid(Tabs.OP,"FlingPower","OPFlingPower",1000,10000,OpC.FlingPower,500,function(v)OpC.FlingPower=v end);slid(Tabs.OP,"FlingPulse","OPFlingPulse",0,50,10,1,function(v)OpC.FlingPulse=v/100 end);btn(Tabs.OP,"RefreshFling",function()if OpC.TouchFling then stopFling();task.wait(.05);startFling()end end)
section(Tabs.OP,"Utility");local OPPlayerDrop=drop(Tabs.OP,"SelectPlayer","OPSelectedPlayer",playerNames(),"None",function(v)SelectedPlayer=v end);btn(Tabs.OP,"RefreshPlayers",function()local novaLista=playerNames();if OPPlayerDrop and OPPlayerDrop.Refresh then pcall(function()OPPlayerDrop:Refresh(novaLista)end)end;notify(L("PlayerListUpdated"),"refresh-cw",2)end);btn(Tabs.OP,"TeleportPlayer",tpToPlayer);btn(Tabs.OP,"TeleportBack",teleportBack);btn(Tabs.OP,"BringPlayer",bringPlayer);btn(Tabs.OP,"SpectatePlayer",spectatePlayer);btn(Tabs.OP,"Unspectate",unspectate)
section(Tabs.Troll,"Utility");tog(Tabs.Troll,"FakeLag","TrollFakeLag",false,function(v)TrollC.FakeLag=v;if not v then stopFakeLag()end end);slid(Tabs.Troll,"FakeLagRate","TrollFakeLagRate",12,100,22,1,function(v)TrollC.FakeLagRate=math.max(v/100,.12) end);slid(Tabs.Troll,"FakeLagHold","TrollFakeLagHold",1,40,8,1,function(v)TrollC.FakeLagHold=v/100 end);btn(Tabs.Troll,L("FakeDeath"),function() fakeDeath() end);btn(Tabs.Troll,L("FakeDeathCooldown"),function() standUp() end)
section(Tabs.Troll,"Movement");local TrollPlayerDrop=drop(Tabs.Troll,"SelectPlayer","TrollSelectedPlayer",playerNames(),"None",function(v)SelectedPlayer=v end);btn(Tabs.Troll,"RefreshPlayers",function()local novaLista=playerNames();if TrollPlayerDrop and TrollPlayerDrop.Refresh then pcall(function()TrollPlayerDrop:Refresh(novaLista)end)end;notify(L("PlayerListUpdated"),"refresh-cw",2)end);tog(Tabs.Troll,"Orbit","TrollOrbit",false,function(v)TrollC.Orbit=v end);drop(Tabs.Troll,"OrbitMode","TrollOrbitMode",{"Circle","UpDown","LeftRight","Diagonal"},"Circle",function(v)TrollC.OrbitMode=v end);slid(Tabs.Troll,"OrbitRadius","TrollOrbitRadius",2,35,TrollC.OrbitRadius,1,function(v)TrollC.OrbitRadius=v end);slid(Tabs.Troll,"OrbitSpeed","TrollOrbitSpeed",1,40,TrollC.OrbitSpeed,1,function(v)TrollC.OrbitSpeed=v end);slid(Tabs.Troll,"OrbitHeight","TrollOrbitHeight",0,25,TrollC.OrbitHeight,1,function(v)TrollC.OrbitHeight=v end);tog(Tabs.Troll,"SpinBot","TrollSpinBot",false,function(v)TrollC.Spin=v end);slid(Tabs.Troll,"SpinSpeed","TrollSpinSpeed",1,150,TrollC.SpinSpeed,1,function(v)TrollC.SpinSpeed=v end);tog(Tabs.Troll,"HeadSit","TrollHeadSit",false,function(v)TrollC.HeadSit=v;if not v then stopHeadSit()end end)
section(Tabs.Troll,"Fling");tog(Tabs.Troll,"Annoy","TrollAnnoy",false,function(v)TrollC.Annoy=v end);drop(Tabs.Troll,"AnnoyMode","TrollAnnoyMode",{"Circle","Cross","Random"},"Circle",function(v)TrollC.AnnoyMode=v end);slid(Tabs.Troll,"AnnoySpeed","TrollAnnoySpeed",1,50,5,1,function(v)TrollC.AnnoySpeed=math.max(v/100,.01)end);tog(Tabs.Troll,"GhostTrail","TrollGhost",true,function(v)TrollC.Ghost=v end)
section(Tabs.Config,"ConfigFile");para(Tabs.Config,L("Config"),L("ConfigPath"),"Blue");btn(Tabs.Config,"SaveConfig",function()if UConfig then UConfig:Save()end;notify(L("Saved"),"save",3)end);btn(Tabs.Config,"LoadConfig",function()if UConfig then UConfig:Load()end;loadProfile();safeStart();applyMove();setNoclip(MiscC.Noclip);updateWorldVisuals();updateHit();notify(L("LoadedConfig"),"folder-open",3)end);btn(Tabs.Config,"ExportConfig",exportConfig);btn(Tabs.Config,"ImportConfig",importConfig);input(Tabs.Config,"ProfileName","default",function(v)ProfileName=tostring(v or "default")end);tog(Tabs.Config,"AutoSave","ConfigAutoSave",false,function(v)AutoSave=v end);btn(Tabs.Config,"ResetSession",function()Aim.Enabled=false;Aim.FOVVisible=false;EspC.Enabled=false;MiscC.Noclip=false;MiscC.InfiniteJump=false;MiscC.Fullbright=false;MiscC.NoFog=false;HitC.Enabled=false;OpC.God100=false;OpC.GodInf=false;OpC.AntiFling=false;OpC.TouchFling=false;TrollC.FakeLag=false;TrollC.FakeDeath=false;TrollC.Orbit=false;TrollC.Spin=false;TrollC.HeadSit=false;TrollC.Annoy=false;setNoclip(false);stopFling();stopFakeLag();stopHeadSit();fakeDeath(false);unfreezeAll();clearESP();resetHit();updateWorldVisuals();if FOVCircle then FOVCircle.Visible=false end;notify(L("ResetDone"),"rotate-ccw",3)end)
section(Tabs.Config,"Server");btn(Tabs.Config,"Rejoin",function()TP:Teleport(game.PlaceId,LP)end);btn(Tabs.Config,"ServerHop",hop);btn(Tabs.Config,"SmallServer",smallServer);btn(Tabs.Config,"CopyJobId",copyJob);input(Tabs.Config,"JobIdInput","xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",function(v)JobInput=tostring(v or "")end);btn(Tabs.Config,"JoinJobId",joinJob)
section(Tabs.Config,"Language");drop(Tabs.Config,"LanguageDropdown","ConfigLanguage",{"English","Portuguese","Spanish"},Lang,function(v)if TXT[v]then saveLang(v);notify(L("LoadedConfig"),"languages",2)end end)
section(Tabs.Config,"Interface");btn(Tabs.Config,"BoostFPS",boostFPS);tog(Tabs.Config,"Notifications","ConfigNotifications",true,function(v)NotifyOn=v end);drop(Tabs.Config,"Theme","ConfigTheme",{"Mirrors Purple","Midnight","Dark"},"Mirrors Purple",function(v)pcall(function()WindUI:SetTheme(v)end)end);pcall(function()Tabs.Config:Keybind({Title=L("ToggleKey"),Desc="",Flag="ConfigToggleKey",Value="H",Callback=function(v)if v and Enum.KeyCode[v]then Window:SetToggleKey(Enum.KeyCode[v])end end})end)
section(Tabs.Config,"Danger");btn(Tabs.Config,"DestroyUI",function()clearESP();resetHit();setNoclip(false);stopFling();stopFakeLag();stopHeadSit();unfreezeAll();MiscC.Fullbright=false;MiscC.NoFog=false;updateWorldVisuals();if FOVCircle then FOVCircle.Visible=false;pcall(function()FOVCircle:Remove()end)end;if CrossA then pcall(function()CrossA:Remove()end)end;if CrossB then pcall(function()CrossB:Remove()end)end;pcall(function()Window:Destroy()end)end)

UIS.JumpRequest:Connect(function()
	if MiscC.InfiniteJump then local h=hum();if h then h:ChangeState(Enum.HumanoidStateType.Jumping)end end
end)
LP.Idled:Connect(function()if MiscC.AntiAFK then VU:Button2Down(Vector2.new(),Camera.CFrame);task.wait(1);VU:Button2Up(Vector2.new(),Camera.CFrame)end end)
LP.CharacterAdded:Connect(function()task.wait(.5);applyMove();setNoclip(MiscC.Noclip);god();if HitC.Enabled then updateHit()end;if TrollC.FakeDeath then fakeDeath(true)end end)
Players.PlayerAdded:Connect(function(p)p.CharacterAdded:Connect(function()task.wait(.7);if EspC.Enabled then createESP(p)end;if HitC.Enabled then applyHit(p)end;if OpC.FreezeAll then freezePlayer(p)end end)end)
Players.PlayerRemoving:Connect(function(p)removeESP(p);frozen[p]=nil end)
for _,p in ipairs(Players:GetPlayers())do if p~=LP then p.CharacterAdded:Connect(function()task.wait(.7);if EspC.Enabled then createESP(p)end;if HitC.Enabled then applyHit(p)end;if OpC.FreezeAll then freezePlayer(p)end end)end end

RunService.RenderStepped:Connect(function(dt)
	Camera=workspace.CurrentCamera
	if FOVCircle then FOVCircle.Position=center();FOVCircle.Radius=Aim.FOV;FOVCircle.Color=Aim.FOVColor;FOVCircle.Visible=Aim.FOVVisible end;updateCrosshair()
	antiVoidGuard();antiFling();god();fakeLag(dt);updateSpin(dt);updateOrbit(dt);updateAnnoy(dt);updateHeadSit();updateAim()
	if OpC.FreezeSelected then freezeSelected()end
	if OpC.FreezeAll then freezeAll()end
end)
task.spawn(function()while task.wait(.75)do applyMove();updateWorldVisuals()end end)
task.spawn(function()while task.wait(.05)do if EspC.Enabled then updateESP()end end end)
task.spawn(function()while task.wait(.2)do if HitC.Enabled then updateHit()end end end)
task.spawn(function()while task.wait(8)do if AutoSave then pcall(saveProfile)end end end)
task.defer(function()
	task.wait(.5)
	pcall(function()if UConfig then UConfig:Load()end end)
	safeStart();applyMove();setNoclip(MiscC.Noclip);updateWorldVisuals();updateHit()
	task.wait(.25);booting=false
	bootNotify(L("Loaded"))
end)
