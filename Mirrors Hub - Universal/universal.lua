local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local UserInputService=game:GetService("UserInputService")
local VirtualUser=game:GetService("VirtualUser")
local TeleportService=game:GetService("TeleportService")
local HttpService=game:GetService("HttpService")
local LP=Players.LocalPlayer
local Camera=workspace.CurrentCamera
local HUB_NAME,HUB_VERSION,HUB_FOLDER,LANG_FILE="Mirrors Hub","2.0 Supreme","MirrorsHub","MirrorsHub/language.json"
local booting=true
local function folder()
	if makefolder and not isfolder(HUB_FOLDER) then pcall(function()makefolder(HUB_FOLDER)end)end
end
folder()
local Lang="English"
local T={
English={
WindowTitle="Mirrors Hub - Universal",OpenButton="Open Mirrors Hub",
Scripts="Scripts",Aimbot="Aimbot",ESP="ESP",Misc="Misc",OP="OP",Troll="Troll",Config="Config",
Home="Home",Main="Main",FOV="FOV",Tuning="Tuning",Info="Info",Visual="Visual",Movement="Movement",Utility="Utility",Hitbox="Hitbox Expander",Server="Server",ConfigFile="Config File",Startup="Startup",Language="Language",Interface="Interface",Danger="Danger Zone",God="God Mode",Protection="Protection",Fling="Fling Tools",Soon="Coming Soon",
HomeTitle="Mirrors Hub",HomeDesc="Universal script hub.\nVersion: ",LoadScript="Load Script",LoadScriptDesc="Placeholder.",NoScript="No script configured yet.",
EnableAimbot="Enable Aimbot",EnableAimbotDesc="Enable or disable aim assist.",TeamCheck="Team Check",TeamCheckDesc="Ignore players from your team.",VisibleCheck="Visible Check",VisibleCheckDesc="Only target visible players.",TargetPart="Target Part",TargetPartDesc="Body part to target.",AimbotFOV="Aimbot FOV",AimbotFOVDesc="FOV radius size.",ShowFOV="Show FOV Circle",ShowFOVDesc="Display the FOV circle.",FOVColor="FOV Color",FOVColorDesc="FOV circle color.",Smoothness="Smoothness",SmoothnessDesc="Aim smoothing.",Strength="Aim Strength",StrengthDesc="Aim pull strength.",SwitchDelay="Target Switch Delay",SwitchDelayDesc="Delay before switching targets.",
EnableESP="Enable ESP",EnableESPDesc="Enable or disable ESP.",ESPColor="ESP Color",ESPColorDesc="Main ESP color.",ShowNames="Show Names",ShowNamesDesc="Show player names.",ShowHealth="Show Health",ShowHealthDesc="Show player health.",ShowDistance="Show Distance",ShowDistanceDesc="Show player distance.",ShowLines="Show Lines",ShowLinesDesc="Draw lines from screen bottom to players.",FillBox="Fill Box",FillBoxDesc="Fill character with transparent color.",FillTransparency="Fill Transparency",FillTransparencyDesc="Fill transparency.",OutlineTransparency="Outline Transparency",OutlineTransparencyDesc="Outline transparency.",TextSize="Text Size",TextSizeDesc="ESP text size.",MaxDistance="Max Distance",MaxDistanceDesc="Maximum ESP distance.",RefreshESP="Refresh ESP",RefreshESPDesc="Reload ESP objects.",ESPUpdated="ESP refreshed.",
WalkSpeed="WalkSpeed",WalkSpeedDesc="Movement speed.",JumpPower="JumpPower",JumpPowerDesc="Jump power.",Noclip="Noclip",NoclipDesc="Walk through collisions.",InfiniteJump="Infinite Jump",InfiniteJumpDesc="Jump infinitely.",AntiAFK="Anti AFK",AntiAFKDesc="Prevents idle kick.",ResetCharacter="Reset Character",ResetCharacterDesc="Reset your character.",
Rejoin="Rejoin Server",RejoinDesc="Reconnect to the same game.",ServerHop="Server Hop",ServerHopDesc="Move to another server.",SmallServer="Small Server",SmallServerDesc="Find a smaller server.",
EnableHitbox="Enable Hitbox Expander",EnableHitboxDesc="Expands selected character hitbox locally.",HitboxPart="Hitbox Target Part",HitboxPartDesc="Body part used as expanded hitbox.",HitboxSize="Hitbox Size",HitboxSizeDesc="Size applied to selected hitbox part.",HitboxTransparency="Hitbox Transparency",HitboxTransparencyDesc="Transparency of expanded hitbox.",HitboxColor="Hitbox Color",HitboxColorDesc="Color of expanded hitbox.",HitboxTeam="Hitbox Team Check",HitboxTeamDesc="Ignore players from your team.",ResetHitboxes="Reset Hitboxes",ResetHitboxesDesc="Restore modified hitboxes.",HitboxesReset="Hitboxes reset.",
God100="God Mode 1",God100Desc="Keeps your health always at 100.",GodInf="God Mode 2",GodInfDesc="Sets your health to infinite.",AntiFling="Anti Fling",AntiFlingDesc="Disables your collision and stabilizes physics.",TouchFling="Touch Fling",TouchFlingDesc="Touch players to fling them while you stay stable.",FlingPower="Touch Fling Power",FlingPowerDesc="Hidden fling force.",RefreshFling="Refresh Touch Fling",RefreshFlingDesc="Rebuilds touch fling on current character.",
ConfigPath="Folder: MirrorsHub\nFile: universal-config.json",SaveConfig="Save Config",SaveConfigDesc="Save universal-config.json.",LoadConfig="Load Config",LoadConfigDesc="Load universal-config.json.",ResetSession="Reset Session",ResetSessionDesc="Disable active session features.",AutoLoadConfig="Auto Load Config",AutoLoadConfigDesc="Save auto load preference.",AutoLoadScript="Auto Load Script",AutoLoadScriptDesc="Save auto execute preference.",LanguageDropdown="Interface Language",LanguageDropdownDesc="Changes hub language. Re-execute to fully refresh labels.",Notifications="Notifications",NotificationsDesc="Enable or disable notifications.",Theme="Theme",ThemeDesc="Change interface theme.",ToggleKey="Toggle UI Key",ToggleKeyDesc="Key to open/close the UI.",DestroyUI="Destroy UI",DestroyUIDesc="Completely removes the hub from screen.",
Saved="Config saved.",LoadedConfig="Config loaded.",ResetDone="Session reset.",KeyChanged="Toggle key changed to: ",LangSaved="Language saved. Re-execute to fully apply.",Loaded="Loaded 100%.",HopMsg="Trying to switch server...",SmallMsg="Searching for smaller server...",ServerErr="Failed to fetch servers.",NoServer="No smaller server found.",NotConfigured="Not configured yet.",FakeLag="Fake Lag",FakeLagDesc="Creates controlled character lag.",FakeDeath="Fake Death",FakeDeathDesc="Ragdolls your character with heavy physics.",Orbit="Orbit Player",OrbitDesc="Orbit selected player in chaotic 3D movement.",OrbitRadius="Orbit Radius",OrbitRadiusDesc="Orbit distance from target.",OrbitSpeed="Orbit Speed",OrbitSpeedDesc="Orbit movement speed.",OrbitHeight="Orbit Height",OrbitHeightDesc="Vertical orbit height.",SpinBot="Spin Bot",SpinBotDesc="Spin your character without blocking movement.",SpinSpeed="Spin Speed",SpinSpeedDesc="Character spin speed.",HeadSit="Head Sit Follow",HeadSitDesc="Sit/follow above selected player head.",Annoy="Annoy Teleport",AnnoyDesc="Teleport rapidly around selected player with ghost trail.",AnnoyMode="Annoy Mode",AnnoyModeDesc="Teleport pattern.",AnnoySpeed="Annoy Speed",AnnoySpeedDesc="Teleport refresh speed.",GhostTrail="Ghost Trail",GhostTrailDesc="Creates quick ghost clones while annoying.",SelectPlayer="Select Player",SelectPlayerDesc="Choose target player.",RefreshPlayers="Refresh Players",RefreshPlayersDesc="Refresh player list.",TeleportPlayer="Teleport To Player",TeleportPlayerDesc="Teleports you to selected player.",NoPlayer="No player selected.",PlayerListUpdated="Player list updated.",Teleported="Teleported.",AntiFlingOn="Anti Fling enabled.",AntiFlingOff="Anti Fling disabled.",FlingOn="Touch Fling enabled.",FlingOff="Touch Fling disabled.",FlingRefresh="Touch Fling refreshed."
},
Portuguese={
WindowTitle="Mirrors Hub - Universal",OpenButton="Abrir Mirrors Hub",
Scripts="Scripts",Aimbot="Aimbot",ESP="ESP",Misc="Misc",OP="OP",Troll="Troll",Config="Config",
Home="Início",Main="Principal",FOV="FOV",Tuning="Ajustes",Info="Informações",Visual="Visual",Movement="Movimento",Utility="Utilidades",Hitbox="Expansor de Hitbox",Server="Servidor",ConfigFile="Arquivo de Config",Startup="Inicialização",Language="Idioma",Interface="Interface",Danger="Zona de Perigo",God="God Mode",Protection="Proteção",Fling="Ferramentas de Fling",Soon="Em breve",
HomeTitle="Mirrors Hub",HomeDesc="Hub universal de scripts.\nVersão: ",LoadScript="Carregar Script",LoadScriptDesc="Placeholder.",NoScript="Nenhum script configurado ainda.",
EnableAimbot="Ativar Aimbot",EnableAimbotDesc="Liga ou desliga o assistente de mira.",TeamCheck="Verificar Time",TeamCheckDesc="Ignora jogadores do seu time.",VisibleCheck="Verificar Visibilidade",VisibleCheckDesc="Mira apenas em jogadores visíveis.",TargetPart="Parte do Alvo",TargetPartDesc="Parte do corpo para mirar.",AimbotFOV="FOV do Aimbot",AimbotFOVDesc="Tamanho do raio do FOV.",ShowFOV="Mostrar Círculo FOV",ShowFOVDesc="Mostra o círculo do FOV.",FOVColor="Cor do FOV",FOVColorDesc="Cor do círculo do FOV.",Smoothness="Suavidade",SmoothnessDesc="Suavidade da mira.",Strength="Força da Mira",StrengthDesc="Força da puxada da mira.",SwitchDelay="Delay de Troca de Alvo",SwitchDelayDesc="Tempo antes de trocar de alvo.",
EnableESP="Ativar ESP",EnableESPDesc="Liga ou desliga o ESP.",ESPColor="Cor do ESP",ESPColorDesc="Cor principal do ESP.",ShowNames="Mostrar Nomes",ShowNamesDesc="Mostra o nome dos jogadores.",ShowHealth="Mostrar Vida",ShowHealthDesc="Mostra a vida dos jogadores.",ShowDistance="Mostrar Distância",ShowDistanceDesc="Mostra a distância dos jogadores.",ShowLines="Mostrar Linhas",ShowLinesDesc="Desenha linhas do fundo da tela até os jogadores.",FillBox="Preencher Box",FillBoxDesc="Preenche o personagem com cor transparente.",FillTransparency="Transparência do Fill",FillTransparencyDesc="Transparência do preenchimento.",OutlineTransparency="Transparência da Borda",OutlineTransparencyDesc="Transparência da borda.",TextSize="Tamanho do Texto",TextSizeDesc="Tamanho do texto do ESP.",MaxDistance="Distância Máxima",MaxDistanceDesc="Distância máxima do ESP.",RefreshESP="Atualizar ESP",RefreshESPDesc="Recarrega os objetos do ESP.",ESPUpdated="ESP atualizado.",
WalkSpeed="Velocidade",WalkSpeedDesc="Velocidade de movimento.",JumpPower="Força do Pulo",JumpPowerDesc="Força do pulo.",Noclip="Noclip",NoclipDesc="Atravessar colisões.",InfiniteJump="Pulo Infinito",InfiniteJumpDesc="Permite pular infinitamente.",AntiAFK="Anti AFK",AntiAFKDesc="Evita ser removido por inatividade.",ResetCharacter="Resetar Personagem",ResetCharacterDesc="Reseta seu personagem.",
Rejoin="Reconectar Servidor",RejoinDesc="Reconecta no mesmo jogo.",ServerHop="Trocar Servidor",ServerHopDesc="Vai para outro servidor.",SmallServer="Servidor Menor",SmallServerDesc="Procura um servidor com menos jogadores.",
EnableHitbox="Ativar Expansor de Hitbox",EnableHitboxDesc="Expande localmente a hitbox selecionada dos personagens.",HitboxPart="Parte da Hitbox",HitboxPartDesc="Parte do corpo usada como hitbox expandida.",HitboxSize="Tamanho da Hitbox",HitboxSizeDesc="Tamanho aplicado na parte selecionada.",HitboxTransparency="Transparência da Hitbox",HitboxTransparencyDesc="Transparência da hitbox expandida.",HitboxColor="Cor da Hitbox",HitboxColorDesc="Cor da hitbox expandida.",HitboxTeam="Verificar Time da Hitbox",HitboxTeamDesc="Ignora jogadores do seu time.",ResetHitboxes="Resetar Hitboxes",ResetHitboxesDesc="Restaura todas as hitboxes modificadas.",HitboxesReset="Hitboxes resetadas.",
God100="God Mode 1",God100Desc="Mantém sua vida sempre em 100.",GodInf="God Mode 2",GodInfDesc="Deixa sua vida infinita.",AntiFling="Anti Fling",AntiFlingDesc="Remove sua colisão e estabiliza a física.",TouchFling="Touch Fling",TouchFlingDesc="Encoste nos jogadores para lançar eles enquanto você fica estável.",FlingPower="Força do Touch Fling",FlingPowerDesc="Força do hidden fling.",RefreshFling="Atualizar Touch Fling",RefreshFlingDesc="Recria o touch fling no personagem atual.",
ConfigPath="Pasta: MirrorsHub\nArquivo: universal-config.json",SaveConfig="Salvar Config",SaveConfigDesc="Salva universal-config.json.",LoadConfig="Carregar Config",LoadConfigDesc="Carrega universal-config.json.",ResetSession="Resetar Sessão",ResetSessionDesc="Desliga funções ativas da sessão.",AutoLoadConfig="Auto Carregar Config",AutoLoadConfigDesc="Salva preferência de auto load.",AutoLoadScript="Auto Carregar Script",AutoLoadScriptDesc="Salva preferência de auto execução.",LanguageDropdown="Idioma da Interface",LanguageDropdownDesc="Muda o idioma do hub. Reexecute para atualizar tudo.",Notifications="Notificações",NotificationsDesc="Liga ou desliga notificações.",Theme="Tema",ThemeDesc="Muda o tema da interface.",ToggleKey="Tecla da UI",ToggleKeyDesc="Tecla para abrir/fechar a interface.",DestroyUI="Destruir UI",DestroyUIDesc="Remove completamente o hub da tela.",
Saved="Config salva.",LoadedConfig="Config carregada.",ResetDone="Sessão resetada.",KeyChanged="Tecla da UI alterada para: ",LangSaved="Idioma salvo. Reexecute para aplicar tudo.",Loaded="Carregado 100%.",HopMsg="Tentando trocar de servidor...",SmallMsg="Procurando servidor menor...",ServerErr="Erro ao buscar servidores.",NoServer="Nenhum servidor menor encontrado.",NotConfigured="Ainda não configurado.",FakeLag="Fake Lag",FakeLagDesc="Cria lag controlado no personagem.",FakeDeath="Fake Death",FakeDeathDesc="Derruba seu personagem em ragdoll com física pesada.",Orbit="Orbitar Jogador",OrbitDesc="Orbita o jogador selecionado em movimento 3D caótico.",OrbitRadius="Raio da Órbita",OrbitRadiusDesc="Distância da órbita até o alvo.",OrbitSpeed="Velocidade da Órbita",OrbitSpeedDesc="Velocidade do movimento orbital.",OrbitHeight="Altura da Órbita",OrbitHeightDesc="Altura vertical da órbita.",SpinBot="Spin Bot",SpinBotDesc="Gira seu personagem sem impedir andar.",SpinSpeed="Velocidade do Spin",SpinSpeedDesc="Velocidade de rotação do personagem.",HeadSit="Sentar na Cabeça",HeadSitDesc="Senta/segue em cima da cabeça do jogador selecionado.",Annoy="Annoy Teleport",AnnoyDesc="Teleporta rapidamente ao redor do jogador com rastro fantasma.",AnnoyMode="Modo Annoy",AnnoyModeDesc="Padrão do teleporte.",AnnoySpeed="Velocidade Annoy",AnnoySpeedDesc="Velocidade de atualização do teleporte.",GhostTrail="Rastro Fantasma",GhostTrailDesc="Cria clones rápidos enquanto usa annoy.",SelectPlayer="Selecionar Jogador",SelectPlayerDesc="Escolha o jogador alvo.",RefreshPlayers="Atualizar Jogadores",RefreshPlayersDesc="Atualiza a lista de jogadores.",TeleportPlayer="Teleportar Para Jogador",TeleportPlayerDesc="Teleporta você até o jogador selecionado.",NoPlayer="Nenhum jogador selecionado.",PlayerListUpdated="Lista de jogadores atualizada.",Teleported="Teleportado.",AntiFlingOn="Anti Fling ativado.",AntiFlingOff="Anti Fling desativado.",FlingOn="Touch Fling ativado.",FlingOff="Touch Fling desativado.",FlingRefresh="Touch Fling atualizado."
},
Spanish={
WindowTitle="Mirrors Hub - Universal",OpenButton="Abrir Mirrors Hub",
Scripts="Scripts",Aimbot="Aimbot",ESP="ESP",Misc="Misc",OP="OP",Troll="Troll",Config="Config",
Home="Inicio",Main="Principal",FOV="FOV",Tuning="Ajustes",Info="Información",Visual="Visual",Movement="Movimiento",Utility="Utilidad",Hitbox="Expansor de Hitbox",Server="Servidor",ConfigFile="Archivo de Config",Startup="Inicio",Language="Idioma",Interface="Interfaz",Danger="Zona de Peligro",God="God Mode",Protection="Protección",Fling="Herramientas de Fling",Soon="Próximamente",
HomeTitle="Mirrors Hub",HomeDesc="Hub universal de scripts.\nVersión: ",LoadScript="Cargar Script",LoadScriptDesc="Placeholder.",NoScript="No hay script configurado todavía.",
EnableAimbot="Activar Aimbot",EnableAimbotDesc="Activa o desactiva la asistencia de mira.",TeamCheck="Verificar Equipo",TeamCheckDesc="Ignora jugadores de tu equipo.",VisibleCheck="Verificar Visibilidad",VisibleCheckDesc="Solo apunta a jugadores visibles.",TargetPart="Parte del Objetivo",TargetPartDesc="Parte del cuerpo para apuntar.",AimbotFOV="FOV del Aimbot",AimbotFOVDesc="Tamaño del radio del FOV.",ShowFOV="Mostrar Círculo FOV",ShowFOVDesc="Muestra el círculo del FOV.",FOVColor="Color del FOV",FOVColorDesc="Color del círculo FOV.",Smoothness="Suavidad",SmoothnessDesc="Suavidad de la mira.",Strength="Fuerza de Mira",StrengthDesc="Fuerza de arrastre de la mira.",SwitchDelay="Delay de Cambio de Objetivo",SwitchDelayDesc="Tiempo antes de cambiar objetivo.",
EnableESP="Activar ESP",EnableESPDesc="Activa o desactiva el ESP.",ESPColor="Color del ESP",ESPColorDesc="Color principal del ESP.",ShowNames="Mostrar Nombres",ShowNamesDesc="Muestra nombres de jugadores.",ShowHealth="Mostrar Vida",ShowHealthDesc="Muestra la vida de jugadores.",ShowDistance="Mostrar Distancia",ShowDistanceDesc="Muestra la distancia de jugadores.",ShowLines="Mostrar Líneas",ShowLinesDesc="Dibuja líneas desde abajo de la pantalla.",FillBox="Rellenar Box",FillBoxDesc="Rellena el personaje con color transparente.",FillTransparency="Transparencia del Relleno",FillTransparencyDesc="Transparencia del relleno.",OutlineTransparency="Transparencia del Borde",OutlineTransparencyDesc="Transparencia del borde.",TextSize="Tamaño del Texto",TextSizeDesc="Tamaño del texto del ESP.",MaxDistance="Distancia Máxima",MaxDistanceDesc="Distancia máxima del ESP.",RefreshESP="Actualizar ESP",RefreshESPDesc="Recarga objetos del ESP.",ESPUpdated="ESP actualizado.",
WalkSpeed="Velocidad",WalkSpeedDesc="Velocidad de movimiento.",JumpPower="Poder de Salto",JumpPowerDesc="Fuerza del salto.",Noclip="Noclip",NoclipDesc="Atravesar colisiones.",InfiniteJump="Salto Infinito",InfiniteJumpDesc="Permite saltar infinitamente.",AntiAFK="Anti AFK",AntiAFKDesc="Evita expulsión por inactividad.",ResetCharacter="Resetear Personaje",ResetCharacterDesc="Resetea tu personaje.",
Rejoin="Reconectar Servidor",RejoinDesc="Reconecta al mismo juego.",ServerHop="Cambiar Servidor",ServerHopDesc="Va a otro servidor.",SmallServer="Servidor Pequeño",SmallServerDesc="Busca un servidor con menos jugadores.",
EnableHitbox="Activar Expansor de Hitbox",EnableHitboxDesc="Expande localmente la hitbox seleccionada.",HitboxPart="Parte de Hitbox",HitboxPartDesc="Parte del cuerpo usada como hitbox expandida.",HitboxSize="Tamaño de Hitbox",HitboxSizeDesc="Tamaño aplicado a la parte seleccionada.",HitboxTransparency="Transparencia de Hitbox",HitboxTransparencyDesc="Transparencia de la hitbox expandida.",HitboxColor="Color de Hitbox",HitboxColorDesc="Color de la hitbox expandida.",HitboxTeam="Verificar Equipo de Hitbox",HitboxTeamDesc="Ignora jugadores de tu equipo.",ResetHitboxes="Resetear Hitboxes",ResetHitboxesDesc="Restaura todas las hitboxes modificadas.",HitboxesReset="Hitboxes reseteadas.",
God100="God Mode 1",God100Desc="Mantiene tu vida siempre en 100.",GodInf="God Mode 2",GodInfDesc="Deja tu vida infinita.",AntiFling="Anti Fling",AntiFlingDesc="Desactiva tu colisión y estabiliza la física.",TouchFling="Touch Fling",TouchFlingDesc="Toca jugadores para lanzarlos mientras tú quedas estable.",FlingPower="Fuerza del Touch Fling",FlingPowerDesc="Fuerza del hidden fling.",RefreshFling="Actualizar Touch Fling",RefreshFlingDesc="Reconstruye el touch fling en el personaje actual.",
ConfigPath="Carpeta: MirrorsHub\nArchivo: universal-config.json",SaveConfig="Guardar Config",SaveConfigDesc="Guarda universal-config.json.",LoadConfig="Cargar Config",LoadConfigDesc="Carga universal-config.json.",ResetSession="Resetear Sesión",ResetSessionDesc="Desactiva funciones activas de la sesión.",AutoLoadConfig="Auto Cargar Config",AutoLoadConfigDesc="Guarda preferencia de auto load.",AutoLoadScript="Auto Cargar Script",AutoLoadScriptDesc="Guarda preferencia de auto ejecución.",LanguageDropdown="Idioma de Interfaz",LanguageDropdownDesc="Cambia el idioma del hub. Reejecuta para actualizar todo.",Notifications="Notificaciones",NotificationsDesc="Activa o desactiva notificaciones.",Theme="Tema",ThemeDesc="Cambia el tema de la interfaz.",ToggleKey="Tecla de UI",ToggleKeyDesc="Tecla para abrir/cerrar la interfaz.",DestroyUI="Destruir UI",DestroyUIDesc="Elimina completamente el hub de la pantalla.",
Saved="Config guardada.",LoadedConfig="Config cargada.",ResetDone="Sesión reseteada.",KeyChanged="Tecla de UI cambiada a: ",LangSaved="Idioma guardado. Reejecuta para aplicar todo.",Loaded="Cargado 100%.",HopMsg="Intentando cambiar servidor...",SmallMsg="Buscando servidor pequeño...",ServerErr="Error al buscar servidores.",NoServer="No se encontró servidor menor.",NotConfigured="Todavía no configurado.",FakeLag="Fake Lag",FakeLagDesc="Crea lag controlado en el personaje.",FakeDeath="Fake Death",FakeDeathDesc="Ragdoll del personaje con física pesada.",Orbit="Orbitar Jugador",OrbitDesc="Orbita al jugador seleccionado en movimiento 3D caótico.",OrbitRadius="Radio de Órbita",OrbitRadiusDesc="Distancia de órbita al objetivo.",OrbitSpeed="Velocidad de Órbita",OrbitSpeedDesc="Velocidad del movimiento orbital.",OrbitHeight="Altura de Órbita",OrbitHeightDesc="Altura vertical de la órbita.",SpinBot="Spin Bot",SpinBotDesc="Gira tu personaje sin impedir caminar.",SpinSpeed="Velocidad de Spin",SpinSpeedDesc="Velocidad de rotación del personaje.",HeadSit="Sentarse en la Cabeza",HeadSitDesc="Se sienta/sigue encima de la cabeza del jugador seleccionado.",Annoy="Annoy Teleport",AnnoyDesc="Teletransporta rápido alrededor del jugador con rastro fantasma.",AnnoyMode="Modo Annoy",AnnoyModeDesc="Patrón del teletransporte.",AnnoySpeed="Velocidad Annoy",AnnoySpeedDesc="Velocidad de actualización del teletransporte.",GhostTrail="Rastro Fantasma",GhostTrailDesc="Crea clones rápidos mientras usa annoy.",SelectPlayer="Seleccionar Jugador",SelectPlayerDesc="Elige jugador objetivo.",RefreshPlayers="Actualizar Jugadores",RefreshPlayersDesc="Actualiza la lista de jugadores.",TeleportPlayer="Teleportar al Jugador",TeleportPlayerDesc="Te teleporta al jugador seleccionado.",NoPlayer="Ningún jugador seleccionado.",PlayerListUpdated="Lista de jugadores actualizada.",Teleported="Teleportado.",AntiFlingOn="Anti Fling activado.",AntiFlingOff="Anti Fling desactivado.",FlingOn="Touch Fling activado.",FlingOff="Touch Fling desactivado.",FlingRefresh="Touch Fling actualizado."
}
}
local function loadLang()
	if readfile and isfile and isfile(LANG_FILE) then
		local ok,d=pcall(function()return HttpService:JSONDecode(readfile(LANG_FILE))end)
		if ok and d and d.Language and T[d.Language] then Lang=d.Language end
	end
end
local function saveLang(v)
	if not T[v] then return end
	Lang=v;folder()
	if writefile then pcall(function()writefile(LANG_FILE,HttpService:JSONEncode({Language=v}))end)end
end
local function L(k)local s=T[Lang]or T.English;return s[k]or T.English[k]or k end
loadLang()
local Aim={Enabled=false,FOV=140,Smoothness=.09,Strength=1,TargetPart="Head",TargetSwitchDelay=.25,TeamCheck=false,VisibleCheck=false,FOVVisible=false,FOVColor=Color3.fromRGB(134,0,212)}
local EspC={Enabled=false,Color=Color3.fromRGB(0,255,255),ShowNames=false,ShowHealth=false,ShowDistance=false,ShowLines=false,TeamCheck=false,FillEnabled=false,FillTransparency=.75,OutlineTransparency=0,TextSize=13,MaxDistance=5000}
local MiscC={WalkSpeed=16,JumpPower=50,Noclip=false,InfiniteJump=false,AntiAFK=false}
local HitC={Enabled=false,Size=10,Transparency=.65,Color=Color3.fromRGB(134,0,212),TeamCheck=false,TargetPart="HumanoidRootPart"}
local OpC={God100=false,GodInf=false,AntiFling=false,TouchFling=false,FlingPower=10000}
local TrollC={FakeLag=false,FakeLagRate=.22,FakeDeath=false,Orbit=false,OrbitRadius=7,OrbitSpeed=8,OrbitHeight=4,Spin=false,SpinSpeed=35,HeadSit=false,Annoy=false,AnnoyMode="Circle",AnnoySpeed=.05,Ghost=true}
local SelectedPlayer=nil
local WindUI=loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
WindUI:AddTheme({Name="Mirrors Purple",Accent=Color3.fromHex("#1C002E"),Background=Color3.fromHex("#101010"),Outline=Color3.fromHex("#8600D4"),Text=Color3.fromHex("#FFFFFF"),Placeholder=Color3.fromHex("#8a8a8a"),Button=Color3.fromHex("#2A0145"),Icon=Color3.fromHex("#C084FC")})
WindUI:AddTheme({Name="Midnight",Accent=Color3.fromHex("#111827"),Background=Color3.fromHex("#050505"),Outline=Color3.fromHex("#374151"),Text=Color3.fromHex("#FFFFFF"),Placeholder=Color3.fromHex("#9CA3AF"),Button=Color3.fromHex("#1F2937"),Icon=Color3.fromHex("#D1D5DB")})
local NotifyOn=true
local function notify(txt,icon,dur)
	if booting or not NotifyOn then return end
	pcall(function()WindUI:Notify({Title=HUB_NAME,Content=txt,Duration=dur or 3,Icon=icon or "bell"})end)
end
local Window=WindUI:CreateWindow({Title=L("WindowTitle"),Icon="door-open",Author="by blackzw.mp3",Folder=HUB_FOLDER,Size=UDim2.fromOffset(580,460),MinSize=Vector2.new(560,350),MaxSize=Vector2.new(850,560),ToggleKey=Enum.KeyCode.H,Transparent=true,Theme="Mirrors Purple",Resizable=false,SideBarWidth=200,BackgroundImageTransparency=.42,HideSearchBar=false,ScrollBarEnabled=true,NewElements=true,User={Enabled=true,Anonymous=false}})
Window:EditOpenButton({Title=L("OpenButton"),Icon="monitor",CornerRadius=UDim.new(0,16),StrokeThickness=2,Color=ColorSequence.new(Color3.fromHex("8600D4"),Color3.fromHex("1C002E")),OnlyMobile=false,Enabled=true,Draggable=true})
local ConfigManager=Window.ConfigManager
local UConfig=ConfigManager:CreateConfig("universal-config")
local Tabs={Scripts=Window:Tab({Title=L("Scripts"),Icon="house"}),Aimbot=Window:Tab({Title=L("Aimbot"),Icon="crosshair"}),ESP=Window:Tab({Title=L("ESP"),Icon="eye"}),Misc=Window:Tab({Title=L("Misc"),Icon="circle-ellipsis"}),OP=Window:Tab({Title=L("OP"),Icon="flame",Locked=false}),Troll=Window:Tab({Title=L("Troll"),Icon="laugh"}),Config=Window:Tab({Title=L("Config"),Icon="cog"})}
local HasDrawing=Drawing and Drawing.new
local FOVCircle
if HasDrawing then FOVCircle=Drawing.new("Circle");FOVCircle.Thickness=1;FOVCircle.NumSides=64;FOVCircle.Radius=Aim.FOV;FOVCircle.Filled=false;FOVCircle.Visible=false;FOVCircle.Color=Aim.FOVColor end
local function char()return LP.Character end
local function hum()local c=char();return c and c:FindFirstChildOfClass("Humanoid")end
local function root(plr)local c=(plr or LP).Character;return c and c:FindFirstChild("HumanoidRootPart")end
local function center()Camera=workspace.CurrentCamera;return Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)end
local function destroy(o)if typeof(o)=="Instance"then o:Destroy()elseif o and o.Remove then pcall(function()o:Remove()end)end end
local currentTarget,lastSwitch=nil,0
local function visible(part)
	if not Aim.VisibleCheck then return true end
	if not part then return false end
	local c=part.Parent;if not c then return false end
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
	if not on then return false end
	return (Vector2.new(pos.X,pos.Y)-center()).Magnitude<=Aim.FOV
end
local function closestTarget()
	local best,dist=nil,Aim.FOV
	for _,p in ipairs(Players:GetPlayers())do
		if p~=LP then
			local c=p.Character;local h=c and c:FindFirstChildOfClass("Humanoid");local part=c and c:FindFirstChild(Aim.TargetPart)
			if h and h.Health>0 and part then
				if Aim.TeamCheck and p.Team==LP.Team then continue end
				if not visible(part)then continue end
				local pos,on=Camera:WorldToViewportPoint(part.Position)
				if on then local d=(Vector2.new(pos.X,pos.Y)-center()).Magnitude;if d<dist then dist=d;best=part end end
			end
		end
	end
	return best
end
local function updateAim()
	if not Aim.Enabled then currentTarget=nil;return end
	if not validTarget(currentTarget)then if tick()-lastSwitch>=Aim.TargetSwitchDelay then currentTarget=closestTarget();lastSwitch=tick()end end
	if currentTarget and validTarget(currentTarget)then
		local cf=CFrame.new(Camera.CFrame.Position,currentTarget.Position)
		Camera.CFrame=Camera.CFrame:Lerp(Camera.CFrame:Lerp(cf,Aim.Smoothness),Aim.Strength)
	end
end
local ESPObjects={}
local function removeESP(p)
	local d=ESPObjects[p];if not d then return end
	for _,o in pairs(d)do destroy(o)end
	ESPObjects[p]=nil
end
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
	local hi=Instance.new("Highlight");hi.Name="MirrorsESP_Highlight";hi.Adornee=c;hi.FillColor=EspC.Color;hi.OutlineColor=EspC.Color;hi.FillTransparency=EspC.FillEnabled and EspC.FillTransparency or 1;hi.OutlineTransparency=EspC.OutlineTransparency;hi.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop;hi.Parent=c
	local bg=Instance.new("BillboardGui");bg.Name="MirrorsESP_Info";bg.Adornee=r;bg.Size=UDim2.new(0,220,0,80);bg.StudsOffset=Vector3.new(0,3.5,0);bg.AlwaysOnTop=true;bg.Parent=r
	local tx=Instance.new("TextLabel");tx.Size=UDim2.new(1,0,1,0);tx.BackgroundTransparency=1;tx.TextColor3=EspC.Color;tx.TextStrokeTransparency=0;tx.TextStrokeColor3=Color3.new();tx.TextSize=EspC.TextSize;tx.Font=Enum.Font.GothamBold;tx.TextYAlignment=Enum.TextYAlignment.Center;tx.Parent=bg
	local line;if HasDrawing then line=Drawing.new("Line");line.Visible=false;line.Color=EspC.Color;line.Thickness=1.5;line.Transparency=1 end
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
					d.Highlight.FillColor=EspC.Color;d.Highlight.OutlineColor=EspC.Color;d.Highlight.FillTransparency=EspC.FillEnabled and EspC.FillTransparency or 1;d.Highlight.OutlineTransparency=EspC.OutlineTransparency
					d.Text.TextColor3=EspC.Color;d.Text.TextSize=EspC.TextSize
					local a={};local dst=math.floor((Camera.CFrame.Position-r.Position).Magnitude)
					if EspC.ShowNames then a[#a+1]=p.Name end
					if EspC.ShowHealth then a[#a+1]="HP: "..math.floor(h.Health).."/"..math.floor(h.MaxHealth)end
					if EspC.ShowDistance then a[#a+1]=dst.." studs"end
					d.Text.Text=table.concat(a,"\n");d.Billboard.Enabled=#a>0
					if d.Line then local pos,on=Camera:WorldToViewportPoint(r.Position);if EspC.ShowLines and on then d.Line.From=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y);d.Line.To=Vector2.new(pos.X,pos.Y);d.Line.Color=EspC.Color;d.Line.Visible=true else d.Line.Visible=false end end
				end
			else removeESP(p)end
		end
	end
end
local function applyMove()local h=hum();if h then h.WalkSpeed=MiscC.WalkSpeed;h.JumpPower=MiscC.JumpPower;h.UseJumpPower=true end end
local function applyNoclip()if not MiscC.Noclip then return end;local c=char();if c then for _,v in ipairs(c:GetDescendants())do if v:IsA("BasePart")then v.CanCollide=false end end end end
local function hop()notify(L("HopMsg"),"server",3);TeleportService:Teleport(game.PlaceId,LP)end
local function smallServer()
	notify(L("SmallMsg"),"search",3)
	local ok,s=pcall(function()return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))end)
	if not ok or not s or not s.data then notify(L("ServerErr"),"triangle-alert",3);return end
	local best
	for _,v in ipairs(s.data)do if v.id~=game.JobId and v.playing<v.maxPlayers then if not best or v.playing<best.playing then best=v end end end
	if best then TeleportService:TeleportToPlaceInstance(game.PlaceId,best.id,LP)else notify(L("NoServer"),"x",3)end
end
local originals={}
local function validHit(p)
	if p==LP or not p.Character then return false end
	local h=p.Character:FindFirstChildOfClass("Humanoid");if not h or h.Health<=0 then return false end
	if HitC.TeamCheck and p.Team==LP.Team then return false end
	return true
end
local function savePart(part)if part and not originals[part]then originals[part]={Size=part.Size,Transparency=part.Transparency,Color=part.Color,Material=part.Material,CanCollide=part.CanCollide}end end
local function resetPart(part)local o=originals[part];if o and part then pcall(function()part.Size=o.Size;part.Transparency=o.Transparency;part.Color=o.Color;part.Material=o.Material;part.CanCollide=o.CanCollide end);originals[part]=nil end end
local function resetHit()for p in pairs(originals)do resetPart(p)end end
local function applyHit(p)
	if not HitC.Enabled or not validHit(p)then return end
	local c=p.Character;local part=c and c:FindFirstChild(HitC.TargetPart);if not part or not part:IsA("BasePart")then return end
	savePart(part);part.Size=Vector3.new(HitC.Size,HitC.Size,HitC.Size);part.Transparency=HitC.Transparency;part.Color=HitC.Color;part.Material=Enum.Material.Neon;part.CanCollide=false
end
local function updateHit()if HitC.Enabled then for _,p in ipairs(Players:GetPlayers())do applyHit(p)end end end
local flingRun=false
local flingThread
local function god()
	local h=hum();if not h then return end
	if OpC.GodInf then h.MaxHealth=math.huge;h.Health=math.huge elseif OpC.God100 then h.MaxHealth=100;h.Health=100 end
end
local function antiFling()
	if not OpC.AntiFling and not OpC.TouchFling then return end
	local c=char();local r=root();if not c or not r then return end
	for _,v in ipairs(c:GetDescendants())do if v:IsA("BasePart")then v.CanCollide=false;v.AssemblyAngularVelocity=Vector3.zero end end
	r.AssemblyAngularVelocity=Vector3.zero
	if r.AssemblyLinearVelocity.Magnitude>140 then r.AssemblyLinearVelocity=Vector3.zero end
end
local function stopFling()flingRun=false end
local function startFling()
	if flingRun then return end
	flingRun=true
	flingThread=task.spawn(function()
		local mv=.1
		while flingRun do
			RunService.Heartbeat:Wait()
			local c=char();local r=root();local h=hum()
			if c and r and h and h.Health>0 then
				local cf=r.CFrame;local av=r.AssemblyAngularVelocity
				for _,p in ipairs(c:GetDescendants())do if p:IsA("BasePart")then p.CanCollide=false end end
				r.AssemblyLinearVelocity=r.AssemblyLinearVelocity*OpC.FlingPower+Vector3.new(0,OpC.FlingPower,0)
				r.AssemblyAngularVelocity=Vector3.new(OpC.FlingPower,OpC.FlingPower,OpC.FlingPower)
				RunService.RenderStepped:Wait()
				if r and r.Parent then r.CFrame=cf;r.AssemblyLinearVelocity=Vector3.zero;r.AssemblyAngularVelocity=Vector3.zero end
				RunService.Stepped:Wait()
				if r and r.Parent then r.CFrame=cf;r.AssemblyLinearVelocity=Vector3.new(0,mv,0);r.AssemblyAngularVelocity=av*0 end
				mv=-mv
			end
		end
	end)
end

local function playerNames()
	local t={}
	for _,p in ipairs(Players:GetPlayers())do if p~=LP then t[#t+1]=p.Name end end
	if #t==0 then t[1]="None" end
	return t
end
local function getSelected()
	if not SelectedPlayer or SelectedPlayer=="None"then return nil end
	local p=Players:FindFirstChild(SelectedPlayer)
	return p
end
local function tpToPlayer()
	local p=getSelected();local rr=p and root(p);local lr=root()
	if not p or not rr or not lr then notify(L("NoPlayer"),"x",3);return end
	lr.CFrame=rr.CFrame*CFrame.new(0,3,0)
	notify(L("Teleported"),"map-pin",2)
end
local function fakeLag()
	if not TrollC.FakeLag then return end
	local r=root()
	if r and math.random()<TrollC.FakeLagRate then
		local v=r.AssemblyLinearVelocity
		r.Anchored=true
		task.delay(math.random(4,10)/100,function()
			if r and r.Parent then r.Anchored=false;r.AssemblyLinearVelocity=v end
		end)
	end
end
local function fakeDeath()
	local c=char();local h=hum();local r=root()
	if not c or not h or not r then return end
	h.PlatformStand=true
	h:ChangeState(Enum.HumanoidStateType.Physics)
	for _,v in ipairs(c:GetDescendants())do
		if v:IsA("Motor6D")then v.Enabled=false end
		if v:IsA("BasePart")then
			v.CanCollide=true
			v.AssemblyLinearVelocity=Vector3.new(math.random(-60,60),math.random(20,90),math.random(-60,60))
			v.AssemblyAngularVelocity=Vector3.new(math.random(-80,80),math.random(-80,80),math.random(-80,80))
		end
	end
end
local function recoverDeath()
	local c=char();local h=hum()
	if not c or not h then return end
	for _,v in ipairs(c:GetDescendants())do if v:IsA("Motor6D")then v.Enabled=true end end
	h.PlatformStand=false
	h:ChangeState(Enum.HumanoidStateType.GettingUp)
end
local function ghost()
	if not TrollC.Ghost then return end
	local c=char();if not c then return end
	local clone=Instance.new("Model")
	clone.Name="MirrorsGhost"
	for _,v in ipairs(c:GetChildren())do
		if v:IsA("BasePart")then
			local p=Instance.new("Part")
			p.Size=v.Size;p.CFrame=v.CFrame;p.Anchored=true;p.CanCollide=false;p.Material=Enum.Material.ForceField;p.Color=Color3.fromRGB(134,0,212);p.Transparency=.65;p.Parent=clone
		end
	end
	clone.Parent=workspace
	task.delay(.18,function()if clone then clone:Destroy()end end)
end
local spinAngle=0
local function updateSpin(dt)
	if not TrollC.Spin then return end
	local r=root();if not r then return end
	spinAngle+=TrollC.SpinSpeed*dt
	r.CFrame=CFrame.new(r.Position)*CFrame.Angles(0,spinAngle,0)
end
local orbitT=0
local function updateOrbit(dt)
	local p=getSelected();local tr=p and root(p);local lr=root()
	if not tr or not lr then return end
	orbitT+=dt*TrollC.OrbitSpeed
	if TrollC.Orbit then
		local x=math.cos(orbitT)*TrollC.OrbitRadius
		local z=math.sin(orbitT*1.37)*TrollC.OrbitRadius
		local y=math.sin(orbitT*1.9)*TrollC.OrbitHeight+TrollC.OrbitHeight
		lr.CFrame=CFrame.new(tr.Position+Vector3.new(x,y,z),tr.Position)
	end
	if TrollC.HeadSit then
		lr.CFrame=tr.CFrame*CFrame.new(0,4.2,0)
		local h=hum();if h then h.Sit=true end
	end
end
local annoyClock=0
local function updateAnnoy(dt)
	if not TrollC.Annoy then return end
	annoyClock+=dt
	if annoyClock<TrollC.AnnoySpeed then return end
	annoyClock=0
	local p=getSelected();local tr=p and root(p);local lr=root()
	if not tr or not lr then return end
	local pos
	local m=TrollC.AnnoyMode
	if m=="Circle"then
		local a=tick()*30
		pos=tr.Position+Vector3.new(math.cos(a)*4,math.random(0,5),math.sin(a)*4)
	elseif m=="Cross"then
		local a=({Vector3.new(5,0,0),Vector3.new(-5,0,0),Vector3.new(0,0,5),Vector3.new(0,0,-5)})[math.random(1,4)]
		pos=tr.Position+a+Vector3.new(0,math.random(0,4),0)
	else
		pos=tr.Position+Vector3.new(math.random(-7,7),math.random(0,6),math.random(-7,7))
	end
	ghost()
	lr.CFrame=CFrame.new(pos,tr.Position)
end
local function safeStart()
	Aim.Enabled=false;Aim.FOVVisible=false;EspC.Enabled=false;currentTarget=nil
	if FOVCircle then FOVCircle.Visible=false end
	clearESP()
end
local function addSection(tab,key)tab:Section({Title=L(key),Box=false,TextSize=17})end
local function para(tab,title,desc,color)tab:Paragraph({Title=title,Desc=desc,Color=color or "Blue",Locked=false})end
local function btn(tab,t,d,cb)tab:Button({Title=L(t),Desc=L(d),Locked=false,Callback=cb})end
local function tog(tab,t,d,flag,val,cb)tab:Toggle({Title=L(t),Desc=L(d),Flag=flag,Type="Checkbox",Value=val,Callback=cb})end
local function slid(tab,t,d,flag,min,max,def,step,cb)tab:Slider({Title=L(t),Desc=L(d),Flag=flag,Step=step or 1,Value={Min=min,Max=max,Default=def},Callback=cb})end
local function drop(tab,t,d,flag,vals,val,cb)tab:Dropdown({Title=L(t),Desc=L(d),Flag=flag,Values=vals,Value=val,Callback=cb})end
local function col(tab,t,d,flag,def,cb)tab:Colorpicker({Title=L(t),Desc=L(d),Flag=flag,Default=def,Transparency=0,Locked=false,Callback=cb})end
addSection(Tabs.Scripts,"Home");para(Tabs.Scripts,L("HomeTitle"),L("HomeDesc")..HUB_VERSION,"Blue");btn(Tabs.Scripts,"LoadScript","LoadScriptDesc",function()notify(L("NoScript"),"info",3)end)
addSection(Tabs.Aimbot,"Main")
tog(Tabs.Aimbot,"EnableAimbot","EnableAimbotDesc","AimbotEnabled",false,function(v)Aim.Enabled=v;if not v then currentTarget=nil end end)
tog(Tabs.Aimbot,"TeamCheck","TeamCheckDesc","AimbotTeamCheck",false,function(v)Aim.TeamCheck=v;currentTarget=nil end)
tog(Tabs.Aimbot,"VisibleCheck","VisibleCheckDesc","AimbotVisibleCheck",false,function(v)Aim.VisibleCheck=v;currentTarget=nil end)
drop(Tabs.Aimbot,"TargetPart","TargetPartDesc","AimbotTargetPart",{"Head","HumanoidRootPart"},"Head",function(v)Aim.TargetPart=v;currentTarget=nil end)
addSection(Tabs.Aimbot,"FOV")
slid(Tabs.Aimbot,"AimbotFOV","AimbotFOVDesc","AimbotFOV",10,500,Aim.FOV,1,function(v)Aim.FOV=v;if FOVCircle then FOVCircle.Radius=v end end)
tog(Tabs.Aimbot,"ShowFOV","ShowFOVDesc","AimbotFOVVisible",false,function(v)Aim.FOVVisible=v;if FOVCircle then FOVCircle.Visible=v end end)
col(Tabs.Aimbot,"FOVColor","FOVColorDesc","AimbotFOVColor",Aim.FOVColor,function(v)Aim.FOVColor=v;if FOVCircle then FOVCircle.Color=v end end)
addSection(Tabs.Aimbot,"Tuning")
slid(Tabs.Aimbot,"Smoothness","SmoothnessDesc","AimbotSmoothness",1,100,35,1,function(v)Aim.Smoothness=v/388 end)
slid(Tabs.Aimbot,"Strength","StrengthDesc","AimbotStrength",1,100,100,1,function(v)Aim.Strength=v/100 end)
slid(Tabs.Aimbot,"SwitchDelay","SwitchDelayDesc","AimbotSwitchDelay",0,2,Aim.TargetSwitchDelay,.05,function(v)Aim.TargetSwitchDelay=v end)
addSection(Tabs.ESP,"Main")
tog(Tabs.ESP,"EnableESP","EnableESPDesc","ESPEnabled",false,function(v)EspC.Enabled=v;if v then refreshESP()else clearESP()end end)
col(Tabs.ESP,"ESPColor","ESPColorDesc","ESPColor",EspC.Color,function(v)EspC.Color=v end)
tog(Tabs.ESP,"TeamCheck","TeamCheckDesc","ESPTeamCheck",false,function(v)EspC.TeamCheck=v;refreshESP()end)
addSection(Tabs.ESP,"Info")
tog(Tabs.ESP,"ShowNames","ShowNamesDesc","ESPShowNames",false,function(v)EspC.ShowNames=v end)
tog(Tabs.ESP,"ShowHealth","ShowHealthDesc","ESPShowHealth",false,function(v)EspC.ShowHealth=v end)
tog(Tabs.ESP,"ShowDistance","ShowDistanceDesc","ESPShowDistance",false,function(v)EspC.ShowDistance=v end)
tog(Tabs.ESP,"ShowLines","ShowLinesDesc","ESPShowLines",false,function(v)EspC.ShowLines=v end)
addSection(Tabs.ESP,"Visual")
tog(Tabs.ESP,"FillBox","FillBoxDesc","ESPFill",false,function(v)EspC.FillEnabled=v end)
slid(Tabs.ESP,"FillTransparency","FillTransparencyDesc","ESPFillTransparency",0,100,75,1,function(v)EspC.FillTransparency=v/100 end)
slid(Tabs.ESP,"OutlineTransparency","OutlineTransparencyDesc","ESPOutlineTransparency",0,100,0,1,function(v)EspC.OutlineTransparency=v/100 end)
slid(Tabs.ESP,"TextSize","TextSizeDesc","ESPTextSize",8,30,EspC.TextSize,1,function(v)EspC.TextSize=v end)
slid(Tabs.ESP,"MaxDistance","MaxDistanceDesc","ESPMaxDistance",100,10000,EspC.MaxDistance,50,function(v)EspC.MaxDistance=v end)
btn(Tabs.ESP,"RefreshESP","RefreshESPDesc",function()refreshESP();notify(L("ESPUpdated"),"refresh-cw",2)end)
addSection(Tabs.Misc,"Movement")
slid(Tabs.Misc,"WalkSpeed","WalkSpeedDesc","MiscWalkSpeed",16,200,MiscC.WalkSpeed,1,function(v)MiscC.WalkSpeed=v;applyMove()end)
slid(Tabs.Misc,"JumpPower","JumpPowerDesc","MiscJumpPower",50,300,MiscC.JumpPower,1,function(v)MiscC.JumpPower=v;applyMove()end)
tog(Tabs.Misc,"Noclip","NoclipDesc","MiscNoclip",false,function(v)MiscC.Noclip=v end)
tog(Tabs.Misc,"InfiniteJump","InfiniteJumpDesc","MiscInfiniteJump",false,function(v)MiscC.InfiniteJump=v end)
addSection(Tabs.Misc,"Utility")
tog(Tabs.Misc,"AntiAFK","AntiAFKDesc","MiscAntiAFK",false,function(v)MiscC.AntiAFK=v end)
btn(Tabs.Misc,"ResetCharacter","ResetCharacterDesc",function()local h=hum();if h then h.Health=0 end end)
addSection(Tabs.Misc,"Hitbox")
tog(Tabs.Misc,"EnableHitbox","EnableHitboxDesc","HitboxEnabled",false,function(v)HitC.Enabled=v;if not v then resetHit()else updateHit()end end)
drop(Tabs.Misc,"HitboxPart","HitboxPartDesc","HitboxTargetPart",{"HumanoidRootPart","Head","UpperTorso","Torso"},"HumanoidRootPart",function(v)resetHit();HitC.TargetPart=v;updateHit()end)
slid(Tabs.Misc,"HitboxSize","HitboxSizeDesc","HitboxSize",2,50,HitC.Size,1,function(v)HitC.Size=v;updateHit()end)
slid(Tabs.Misc,"HitboxTransparency","HitboxTransparencyDesc","HitboxTransparency",0,100,math.floor(HitC.Transparency*100),1,function(v)HitC.Transparency=v/100;updateHit()end)
col(Tabs.Misc,"HitboxColor","HitboxColorDesc","HitboxColor",HitC.Color,function(v)HitC.Color=v;updateHit()end)
tog(Tabs.Misc,"HitboxTeam","HitboxTeamDesc","HitboxTeamCheck",false,function(v)HitC.TeamCheck=v;resetHit();updateHit()end)
btn(Tabs.Misc,"ResetHitboxes","ResetHitboxesDesc",function()resetHit();notify(L("HitboxesReset"),"rotate-ccw",3)end)
addSection(Tabs.OP,"God")
tog(Tabs.OP,"God100","God100Desc","OPGod100",false,function(v)OpC.God100=v;if v then OpC.GodInf=false end end)
tog(Tabs.OP,"GodInf","GodInfDesc","OPGodInf",false,function(v)OpC.GodInf=v;if v then OpC.God100=false end end)
addSection(Tabs.OP,"Protection")
tog(Tabs.OP,"AntiFling","AntiFlingDesc","OPAntiFling",false,function(v)OpC.AntiFling=v;notify(v and L("AntiFlingOn")or L("AntiFlingOff"),v and "shield"or"shield-off",3)end)
addSection(Tabs.OP,"Fling")
tog(Tabs.OP,"TouchFling","TouchFlingDesc","OPTouchFling",false,function(v)OpC.TouchFling=v;if v then startFling();notify(L("FlingOn"),"zap",3)else stopFling();notify(L("FlingOff"),"zap-off",3)end end)
slid(Tabs.OP,"FlingPower","FlingPowerDesc","OPFlingPower",1000,10000,OpC.FlingPower,1000,function(v)OpC.FlingPower=v end)
btn(Tabs.OP,"RefreshFling","RefreshFlingDesc",function()if OpC.TouchFling then stopFling();task.wait(.05);startFling()end;notify(L("FlingRefresh"),"refresh-cw",3)end)
addSection(Tabs.OP,"Utility")
drop(Tabs.OP,"SelectPlayer","SelectPlayerDesc","OPSelectedPlayer",playerNames(),"None",function(v)SelectedPlayer=v end)
btn(Tabs.OP,"RefreshPlayers","RefreshPlayersDesc",function()notify(L("PlayerListUpdated"),"refresh-cw",2)end)
btn(Tabs.OP,"TeleportPlayer","TeleportPlayerDesc",tpToPlayer)
addSection(Tabs.Troll,"Utility")
tog(Tabs.Troll,"FakeLag","FakeLagDesc","TrollFakeLag",false,function(v)TrollC.FakeLag=v end)
tog(Tabs.Troll,"FakeDeath","FakeDeathDesc","TrollFakeDeath",false,function(v)TrollC.FakeDeath=v;if v then fakeDeath()else recoverDeath()end end)
addSection(Tabs.Troll,"Movement")
drop(Tabs.Troll,"SelectPlayer","SelectPlayerDesc","TrollSelectedPlayer",playerNames(),"None",function(v)SelectedPlayer=v end)
btn(Tabs.Troll,"RefreshPlayers","RefreshPlayersDesc",function()notify(L("PlayerListUpdated"),"refresh-cw",2)end)
tog(Tabs.Troll,"Orbit","OrbitDesc","TrollOrbit",false,function(v)TrollC.Orbit=v end)
slid(Tabs.Troll,"OrbitRadius","OrbitRadiusDesc","TrollOrbitRadius",2,35,TrollC.OrbitRadius,1,function(v)TrollC.OrbitRadius=v end)
slid(Tabs.Troll,"OrbitSpeed","OrbitSpeedDesc","TrollOrbitSpeed",1,40,TrollC.OrbitSpeed,1,function(v)TrollC.OrbitSpeed=v end)
slid(Tabs.Troll,"OrbitHeight","OrbitHeightDesc","TrollOrbitHeight",0,25,TrollC.OrbitHeight,1,function(v)TrollC.OrbitHeight=v end)
tog(Tabs.Troll,"SpinBot","SpinBotDesc","TrollSpinBot",false,function(v)TrollC.Spin=v end)
slid(Tabs.Troll,"SpinSpeed","SpinSpeedDesc","TrollSpinSpeed",1,150,TrollC.SpinSpeed,1,function(v)TrollC.SpinSpeed=v end)
tog(Tabs.Troll,"HeadSit","HeadSitDesc","TrollHeadSit",false,function(v)TrollC.HeadSit=v end)
addSection(Tabs.Troll,"Fling")
tog(Tabs.Troll,"Annoy","AnnoyDesc","TrollAnnoy",false,function(v)TrollC.Annoy=v end)
drop(Tabs.Troll,"AnnoyMode","AnnoyModeDesc","TrollAnnoyMode",{"Circle","Cross","Random"},"Circle",function(v)TrollC.AnnoyMode=v end)
slid(Tabs.Troll,"AnnoySpeed","AnnoySpeedDesc","TrollAnnoySpeed",1,50,5,1,function(v)TrollC.AnnoySpeed=math.max(v/100,.01)end)
tog(Tabs.Troll,"GhostTrail","GhostTrailDesc","TrollGhost",true,function(v)TrollC.Ghost=v end)
addSection(Tabs.Config,"ConfigFile");para(Tabs.Config,L("Config"),L("ConfigPath"),"Blue")
btn(Tabs.Config,"SaveConfig","SaveConfigDesc",function()UConfig:Save();notify(L("Saved"),"save",3)end)
btn(Tabs.Config,"LoadConfig","LoadConfigDesc",function()UConfig:Load();safeStart();applyMove();updateHit();notify(L("LoadedConfig"),"folder-open",3)end)
btn(Tabs.Config,"ResetSession","ResetSessionDesc",function()Aim.Enabled=false;Aim.FOVVisible=false;EspC.Enabled=false;MiscC.Noclip=false;MiscC.InfiniteJump=false;HitC.Enabled=false;OpC.God100=false;OpC.GodInf=false;OpC.AntiFling=false;OpC.TouchFling=false;TrollC.FakeLag=false;TrollC.FakeDeath=false;TrollC.Orbit=false;TrollC.Spin=false;TrollC.HeadSit=false;TrollC.Annoy=false;stopFling();recoverDeath();currentTarget=nil;clearESP();resetHit();if FOVCircle then FOVCircle.Visible=false end;notify(L("ResetDone"),"rotate-ccw",3)end)
addSection(Tabs.Config,"Server")
btn(Tabs.Config,"Rejoin","RejoinDesc",function()TeleportService:Teleport(game.PlaceId,LP)end)
btn(Tabs.Config,"ServerHop","ServerHopDesc",hop)
btn(Tabs.Config,"SmallServer","SmallServerDesc",smallServer)
addSection(Tabs.Config,"Startup")
tog(Tabs.Config,"AutoLoadConfig","AutoLoadConfigDesc","ConfigAutoLoad",true,function()end)
tog(Tabs.Config,"AutoLoadScript","AutoLoadScriptDesc","ConfigAutoLoadScript",false,function()end)
addSection(Tabs.Config,"Language")
drop(Tabs.Config,"LanguageDropdown","LanguageDropdownDesc","ConfigLanguage",{"English","Portuguese","Spanish"},Lang,function(v)if T[v]then saveLang(v);notify(L("LangSaved"),"languages",4)end end)
addSection(Tabs.Config,"Interface")
tog(Tabs.Config,"Notifications","NotificationsDesc","ConfigNotifications",true,function(v)NotifyOn=v end)
drop(Tabs.Config,"Theme","ThemeDesc","ConfigTheme",{"Mirrors Purple","Midnight","Dark"},"Mirrors Purple",function(v)pcall(function()WindUI:SetTheme(v)end)end)
Tabs.Config:Keybind({Title=L("ToggleKey"),Desc=L("ToggleKeyDesc"),Flag="ConfigToggleKey",Value="H",Callback=function(v)if v and Enum.KeyCode[v]then Window:SetToggleKey(Enum.KeyCode[v]);notify(L("KeyChanged")..v,"keyboard",3)end end})
addSection(Tabs.Config,"Danger")
btn(Tabs.Config,"DestroyUI","DestroyUIDesc",function()clearESP();resetHit();stopFling();if FOVCircle then FOVCircle.Visible=false;pcall(function()FOVCircle:Remove()end)end;pcall(function()Window:Destroy()end)end)
UserInputService.JumpRequest:Connect(function()if MiscC.InfiniteJump then local h=hum();if h then h:ChangeState(Enum.HumanoidStateType.Jumping)end end end)
LP.Idled:Connect(function()if MiscC.AntiAFK then VirtualUser:Button2Down(Vector2.new(),Camera.CFrame);task.wait(1);VirtualUser:Button2Up(Vector2.new(),Camera.CFrame)end end)
LP.CharacterAdded:Connect(function()task.wait(.5);applyMove();if HitC.Enabled then updateHit()end;if TrollC.FakeDeath then fakeDeath()end end)
Players.PlayerAdded:Connect(function(p)p.CharacterAdded:Connect(function()task.wait(.7);if EspC.Enabled then createESP(p)end;if HitC.Enabled then applyHit(p)end end)end)
Players.PlayerRemoving:Connect(function(p)if p.Character then for _,v in ipairs(p.Character:GetDescendants())do if v:IsA("BasePart")then resetPart(v)end end end;removeESP(p)end)
for _,p in ipairs(Players:GetPlayers())do if p~=LP then p.CharacterAdded:Connect(function()task.wait(.7);if EspC.Enabled then createESP(p)end;if HitC.Enabled then applyHit(p)end end)end end
RunService.RenderStepped:Connect(function(dt)
	Camera=workspace.CurrentCamera
	if FOVCircle then FOVCircle.Position=center();FOVCircle.Radius=Aim.FOV;FOVCircle.Color=Aim.FOVColor;FOVCircle.Visible=Aim.FOVVisible end
	applyNoclip();antiFling();god();fakeLag();updateSpin(dt);updateOrbit(dt);updateAnnoy(dt);updateAim()
end)
task.spawn(function()while task.wait(.03)do if EspC.Enabled then updateESP()end end end)
task.spawn(function()while task.wait(.15)do if HitC.Enabled then updateHit()end end end)
task.defer(function()
	task.wait(.5)
	pcall(function()UConfig:Load()end)
	safeStart();applyMove();updateHit()
	task.wait(.25);booting=false
	notify(L("Loaded"),"check",3)
end)
