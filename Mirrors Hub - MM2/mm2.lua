local Players = game:GetService("Players")
local Stats = game:GetService("Stats")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local LP = Players.LocalPlayer

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Gameplay = Remotes:WaitForChild("Gameplay")
local Extras = Remotes:WaitForChild("Extras")

local GetCurrentPlayerData = Gameplay:WaitForChild("GetCurrentPlayerData")
local GetChance = Extras:WaitForChild("GetChance")

local Mirrors = {}

do
    local Env = getgenv and getgenv() or _G

    local PreviousRuntime = Env.MirrorsMM2Runtime
    if PreviousRuntime and PreviousRuntime.Cleanup then
        pcall(PreviousRuntime.Cleanup)
    end

    local Runtime = {
        Alive = true,
        Connections = {},
        Tweens = {},
        VisualTweens = {},
        Cleanups = {},
        Window = nil
    }

    Env.MirrorsMM2Runtime = Runtime
    Mirrors.Runtime = Runtime

    local function TrackConnection(Connection)
        if Connection then
            table.insert(Runtime.Connections, Connection)
        end
        return Connection
    end

    local function TrackTween(Tween, Visual)
        if Tween then
            table.insert(Visual and Runtime.VisualTweens or Runtime.Tweens, Tween)
        end
        return Tween
    end

    local function CancelVisualTweens()
        for _, Tween in ipairs(Runtime.VisualTweens) do
            pcall(function()
                Tween:Cancel()
            end)
        end
        table.clear(Runtime.VisualTweens)
    end

    local function AddCleanup(Callback)
        if typeof(Callback) == "function" then
            table.insert(Runtime.Cleanups, Callback)
        end
        return Callback
    end

    Mirrors.TrackConnection = TrackConnection
    Mirrors.TrackTween = TrackTween
    Mirrors.CancelVisualTweens = CancelVisualTweens
    Mirrors.AddCleanup = AddCleanup

    local State = {
        Language = "English",
        Theme = "Mirrors Purple",
        Notifications = true,
        ConfigApplying = false,
        Ready = false,
        SelectedTab = "Info"
    }

    Mirrors.State = State
    Mirrors.Controls = {}

    local PrefsPath = "WindUI/MirrorsHub/MM2/ui_settings.json"

    local function EnsureFolder(Path)
        if not makefolder or not isfolder then
            return
        end
        if not isfolder(Path) then
            pcall(makefolder, Path)
        end
    end

    local function EnsurePrefsFolder()
        EnsureFolder("WindUI")
        EnsureFolder("WindUI/MirrorsHub")
        EnsureFolder("WindUI/MirrorsHub/MM2")
    end

    local ThemeOptions = {
        "Mirrors Purple",
        "Dark",
        "Light",
        "Rose",
        "Plant",
        "Red",
        "Indigo",
        "Sky",
        "Violet",
        "Amber",
        "Emerald",
        "Midnight",
        "Crimson",
        "Monokai Pro",
        "Cotton Candy",
        "Mellowsi",
        "Rainbow"
    }

    local ThemeKeys = {}

    for _, Name in ipairs(ThemeOptions) do
        ThemeKeys[Name] = Name
    end

    local function IsThemeValid(Name)
        for _, ThemeName in ipairs(ThemeOptions) do
            if Name == ThemeName then
                return true
            end
        end
        return false
    end

    local function LoadPrefs()
        if not readfile or not isfile or not isfile(PrefsPath) then
            return
        end

        local Success, Data = pcall(function()
            return HttpService:JSONDecode(readfile(PrefsPath))
        end)

        if not Success or typeof(Data) ~= "table" then
            return
        end

        if Data.Language == "English" or Data.Language == "Português" or Data.Language == "Español" then
            State.Language = Data.Language
        end

        if IsThemeValid(Data.Theme) then
            State.Theme = Data.Theme
        end

        if typeof(Data.Notifications) == "boolean" then
            State.Notifications = Data.Notifications
        end
    end

    local function SavePrefs()
        if not writefile then
            return
        end

        EnsurePrefsFolder()

        pcall(function()
            writefile(PrefsPath, HttpService:JSONEncode({
                Language = State.Language,
                Theme = State.Theme,
                Notifications = State.Notifications
            }))
        end)
    end

    LoadPrefs()

    local WindUI = loadstring(game:HttpGet(
        "https://github.com/Footagesus/WindUI/releases/download/1.6.66/main.lua"
    ))()

    Mirrors.WindUI = WindUI

    local C = {
        White = Color3.fromHex("#FFFFFF"),
        SoftWhite = Color3.fromHex("#F8F5FB"),
        Text = Color3.fromHex("#FBF9FD"),
        Muted = Color3.fromHex("#ADA6B3"),
        PurpleLight = Color3.fromHex("#E4BCFF"),
        Purple = Color3.fromHex("#C463FF"),
        PurpleVivid = Color3.fromHex("#AD35FF"),
        PurpleDeep = Color3.fromHex("#7116C8"),
        PurpleDark = Color3.fromHex("#3C095E"),
        Pink = Color3.fromHex("#F04BFF"),
        Red = Color3.fromHex("#FF536B"),
        Blue = Color3.fromHex("#4D8DFF"),
        Cyan = Color3.fromHex("#28D8F3"),
        Green = Color3.fromHex("#43E39B"),
        Orange = Color3.fromHex("#FF9F32"),
        Yellow = Color3.fromHex("#FFC857"),
        Lavender = Color3.fromHex("#BFA4FF"),
        Graphite = Color3.fromHex("#29272D")
    }

    Mirrors.Colors = C

    WindUI:AddTheme({
        Name = "Mirrors Purple",
        Accent = WindUI:Gradient({
            ["0"] = { Color = Color3.fromHex("#FFFFFF"), Transparency = 0 },
            ["50"] = { Color = Color3.fromHex("#FAF7FC"), Transparency = 0 },
            ["100"] = { Color = Color3.fromHex("#E9D6F4"), Transparency = 0 }
        }, { Rotation = 90 }),
        Background = WindUI:Gradient({
            ["0"] = { Color = Color3.fromHex("#1B0F22"), Transparency = 0 },
            ["50"] = { Color = Color3.fromHex("#110B16"), Transparency = 0 },
            ["100"] = { Color = Color3.fromHex("#08060A"), Transparency = 0 }
        }, { Rotation = 120 }),
        Dialog = Color3.fromHex("#18101D"),
        Outline = Color3.fromHex("#EADCF4"),
        Text = C.Text,
        Placeholder = C.Muted,
        Button = Color3.fromHex("#24192A"),
        Icon = C.SoftWhite,
        Toggle = C.White,
        Slider = C.White,
        Checkbox = C.White,
        Primary = C.PurpleVivid,
        PanelBackground = Color3.fromHex("#FFFFFF"),
        PanelBackgroundTransparency = 0.94,
        ElementBackground = Color3.fromHex("#201625"),
        ElementBackgroundTransparency = 0.08,
        LabelBackground = Color3.fromHex("#000000"),
        LabelBackgroundTransparency = 0.72
    })

    local Translations = {
        ["Português"] = {
["Aim Assist"] = "Assistência de Mira",
["Aim FOV"] = "FOV da Mira",
["Aim Part"] = "Parte da Mira",
["Aim Smoothness"] = "Suavidade da Mira",
["Alive Players"] = "Jogadores Vivos",
["Anti-AFK"] = "Anti-AFK",
["Anti-AFK disabled."] = "Anti-AFK desativado.",
["Anti-AFK enabled."] = "Anti-AFK ativado.",
["Anti-Void"] = "Anti-Void",
["Anti Fling"] = "Anti Fling",
["Disables collisions between you and other players."] = "Desativa a colisão entre você e outros jogadores.",
["Auto Escape Murderer"] = "Fuga Automática do Assassino",
["Auto Gun"] = "Coleta Automática",
["Auto Load"] = "Carregamento Automático",
["Auto Load Config"] = "Carregamento Automático",
["Auto Shoot Murderer"] = "Ação Automática no Assassino",
["Auto Throw"] = "Arremesso Automático",
["Auto load disabled."] = "Carregamento automático desativado.",
["Auto load enabled for: "] = "Carregamento automático ativado para: ",
["Automatically aims at nearby players"] = "Mira automaticamente em jogadores próximos",
["Automatically collects nearby coins"] = "Coleta automaticamente moedas próximas",
["Automatically grabs the dropped gun and returns to your previous position"] = "Coleta automaticamente o item derrubado e retorna à posição anterior",
["Automatically kills players inside the selected range"] = "Ativa a ação automaticamente em jogadores dentro do alcance selecionado",
["Automatically load this config when Mirrors Hub starts."] = "Carrega automaticamente esta configuração ao iniciar o Mirrors Hub.",
["Automatically shoots the current Murderer"] = "Executa automaticamente a ação no Assassino atual",
["Automatically throws the knife at valid targets"] = "Executa automaticamente a ação em alvos válidos",
["Box"] = "Caixa",
["Box and tracer thickness"] = "Espessura da caixa e do traçador",
["Change the interface language."] = "Altere o idioma da interface.",
["Change your jump power."] = "Altera a força do pulo.",
["Change your movement speed."] = "Altera sua velocidade de movimento.",
["Character and movement utilities."] = "Utilitários de personagem e movimento.",
["Choose a WindUI theme."] = "Escolha um tema da WindUI.",
["Choose a player to kill"] = "Escolha um jogador",
["Choose the ESP rendering mode"] = "Escolha o modo de renderização do ESP",
["Choose where tracers start"] = "Escolha onde os traçadores começam",
["Choose which body part to target"] = "Escolha a parte do personagem para mirar",
["Clipboard Error"] = "Erro na Área de Transferência",
["Clipboard is not supported."] = "A área de transferência não é suportada.",
["Coin Farm"] = "Farm de Moedas",
["Config"] = "Configurações",
["Config Deleted"] = "Configuração Excluída",
["Config Error"] = "Erro de Configuração",
["Config Exported"] = "Configuração Exportada",
["Config Imported"] = "Configuração Importada",
["Config Loaded"] = "Configuração Carregada",
["Config Name"] = "Nome da Configuração",
["Config Reset"] = "Configuração Redefinida",
["Config Saved"] = "Configuração Salva",
["Config does not exist."] = "A configuração não existe.",
["Config does not exist: "] = "A configuração não existe: ",
["Config file was not found."] = "O arquivo de configuração não foi encontrado.",
["Config list refreshed."] = "Lista de configurações atualizada.",
["Configs"] = "Configurações",
["Configuration Manager"] = "Gerenciador de Configurações",
["Controls aim movement speed"] = "Controla a velocidade do movimento da mira",
["Controls highlight fill transparency"] = "Controla a transparência do preenchimento do highlight",
["Copy Job ID"] = "Copiar Job ID",
["Copy or restore configurations using JSON."] = "Copie ou restaure configurações usando JSON.",
["Copy the current configuration JSON to clipboard."] = "Copia o JSON da configuração atual para a área de transferência.",
["Could not"] = "Não foi possível",
["Could not copy the JSON."] = "Não foi possível copiar o JSON.",
["Could not create the config."] = "Não foi possível criar a configuração.",
["Could not delete the config."] = "Não foi possível excluir a configuração.",
["Could not load the config."] = "Não foi possível carregar a configuração.",
["Could not open the config."] = "Não foi possível abrir a configuração.",
["Could not prepare the config."] = "Não foi possível preparar a configuração.",
["Could not read the config."] = "Não foi possível ler a configuração.",
["Could not rejoin the server."] = "Não foi possível reconectar ao servidor.",
["Could not save the config."] = "Não foi possível salvar a configuração.",
["Could not teleport to the server."] = "Não foi possível entrar no servidor.",
["Could not write the config."] = "Não foi possível gravar a configuração.",
["Delete Config"] = "Excluir Configuração",
["Delete Failed"] = "Falha ao Excluir",
["Deleted: "] = "Excluída: ",
["Disabled"] = "Desativado",
["Distance"] = "Distância",
["Draw a box around players"] = "Desenha uma caixa ao redor dos jogadores",
["Draw a line to players"] = "Desenha uma linha até os jogadores",
["Drawing ESP text size"] = "Tamanho do texto do ESP Drawing",
["Drawing Thickness"] = "Espessura do Desenho",
["ESP Mode"] = "Modo do ESP",
["Enable ESP"] = "Ativar ESP",
["Enable custom JumpPower."] = "Ativa uma força de pulo personalizada.",
["Enable custom WalkSpeed."] = "Ativa uma velocidade personalizada.",
["Enable player ESP"] = "Ativa o ESP de jogadores",
["Enabled"] = "Ativado",
["Executor"] = "Executor",
["Export & Import"] = "Exportar e Importar",
["Export Config"] = "Exportar Configuração",
["Export Error"] = "Erro ao Exportar",
["FPS Boost"] = "Otimização de FPS",
["File configs are not supported."] = "Configurações em arquivo não são suportadas.",
["Find a server with fewer players."] = "Procura um servidor com menos jogadores.",
["Fling All"] = "Fling em Todos",
["Fling All Server"] = "Fling no Servidor Inteiro",
["Fling Murder"] = "Fling Assassino",
["Fling Murderer"] = "Fling no Assassino",
["Fling Player"] = "Fling no Jogador",
["Fling Sheriff"] = "Fling no Xerife",
["Fling every player in the server"] = "Aplica fling em todos os jogadores do servidor",
["Fling the current Murderer"] = "Aplica fling no Assassino atual",
["Fling the current Sheriff or Hero"] = "Aplica fling no Xerife ou Herói atual",
["Fling the selected player"] = "Aplica fling no jogador selecionado",
["Found a server with "] = "Servidor encontrado com ",
["Fullbright"] = "Iluminação Máxima",
["GENERAL"] = "GERAL",
["Game Information"] = "Informações do Jogo",
["Game Mode"] = "Modo de Jogo",
["Gun Drop"] = "Item no Chão",
["Gun Drop ESP"] = "ESP do Item no Chão",
["Hero"] = "Herói",
["Highlight Transparency"] = "Transparência do Highlight",
["Highlights the current Murderer"] = "Destaca o Assassino atual",
["Highlights the current Murderer through walls"] = "Destaca o Assassino atual através das paredes",
["Highlights the current Sheriff or Hero"] = "Destaca o Xerife ou Herói atual",
["Highlights the dropped gun"] = "Destaca o item derrubado",
["Highlights the dropped gun through walls"] = "Destaca o item derrubado através das paredes",
["Import Config"] = "Importar Configuração",
["Import Error"] = "Erro ao Importar",
["Import JSON"] = "Importar JSON",
["Imported as: "] = "Importada como: ",
["Info"] = "Informações",
["Innocent"] = "Inocente",
["Innocent ESP"] = "ESP dos Inocentes",
["Interface Settings"] = "Configurações da Interface",
["Invalid JSON."] = "JSON inválido.",
["JSON copied to clipboard."] = "JSON copiado para a área de transferência.",
["Job ID"] = "Job ID",
["Join another available server."] = "Entra em outro servidor disponível.",
["JumpPower"] = "Força do Pulo",
["JumpPower Value"] = "Valor do Pulo",
["Keeps the map bright and visible."] = "Mantém o mapa claro e visível.",
["Kill All"] = "Ação em Todos",
["Kill All Innocents"] = "Ação em Todos os Inocentes",
["Kill All Players"] = "Ação em Todos os Jogadores",
["Kill Failed"] = "Falha na Ação",
["Kill Selected Player"] = "Ação no Jogador Selecionado",
["Kill Sheriff"] = "Ação no Xerife",
["Kill every alive Innocent"] = "Executa a ação em todos os Inocentes vivos",
["Kill every alive player"] = "Executa a ação em todos os jogadores vivos",
["Kill the current Sheriff or Hero"] = "Executa a ação no Xerife ou Herói atual",
["Kill the selected player"] = "Executa a ação no jogador selecionado",
["Knife Aura"] = "Aura da Faca",
["Knife Aura Range"] = "Alcance da Aura",
["Knife Failed"] = "Falha na Ação",
["Language"] = "Idioma",
["Language changed"] = "Idioma alterado",
["Language, theme and notification preferences."] = "Idioma, tema e preferências de notificações.",
["Lighting and performance utilities."] = "Utilitários de iluminação e desempenho.",
["Load Config"] = "Carregar Configuração",
["Load Failed"] = "Falha ao Carregar",
["Load the selected configuration."] = "Carrega a configuração selecionada.",
["Loading..."] = "Carregando...",
["Lobby"] = "Lobby",
["MM2 Role ESP"] = "ESP de Funções do MM2",
["Main"] = "Principal",
["Manage the currently selected configuration."] = "Gerencie a configuração selecionada.",
["Map"] = "Mapa",
["Max Distance"] = "Distância Máxima",
["Maximum ESP render distance"] = "Distância máxima de renderização do ESP",
["Maximum Knife Aura distance"] = "Distância máxima da aura",
["Mirrors Purple"] = "Mirrors Purple",
["Misc"] = "Diversos",
["Missing Gun"] = "Item Ausente",
["Missing Knife"] = "Item Ausente",
["Murder"] = "Assassino",
["Murder Chance"] = "Chance de Assassino",
["Murderer"] = "Assassino",
["Murderer ESP"] = "ESP do Assassino",
["Murderer: Red\nSheriff / Hero: Blue\nInnocent: Green"] = "Assassino: Vermelho\nXerife / Herói: Azul\nInocente: Verde",
["Name"] = "Nome",
["Name used to save or create a configuration."] = "Nome usado para salvar ou criar uma configuração.",
["No Clip"] = "No Clip",
["No Murderer"] = "Sem Assassino",
["No Sheriff"] = "Sem Xerife",
["No Target"] = "Sem Alvo",
["No Targets"] = "Sem Alvos",
["No available server was found."] = "Nenhum servidor disponível foi encontrado.",
["Notifications"] = "Notificações",
["Notifications disabled."] = "Notificações desativadas.",
["Notifications enabled."] = "Notificações ativadas.",
["Paste a config JSON first."] = "Cole um JSON de configuração primeiro.",
["Paste an exported Mirrors Hub config."] = "Cole uma configuração exportada do Mirrors Hub.",
["Permanently delete the selected configuration."] = "Exclui permanentemente a configuração selecionada.",
["Ping"] = "Ping",
["Player"] = "Jogador",
["Players"] = "Jogadores",
["Prevents Roblox idle kick."] = "Evita a desconexão por inatividade.",
["ROLES"] = "FUNÇÕES",
["Redirects knife throws to Sheriff/Hero or the nearest player"] = "Redireciona o arremesso para o alvo válido configurado",
["Reduces effects, shadows and expensive materials."] = "Reduz efeitos, sombras e materiais pesados.",
["Refresh Config List"] = "Atualizar Lista",
["Refresh saved configuration files."] = "Atualiza os arquivos de configuração salvos.",
["Rejoin"] = "Reconectar",
["Rejoin Failed"] = "Falha ao Reconectar",
["Rejoin the current server."] = "Reconecta ao servidor atual.",
["Rejoining current server..."] = "Reconectando ao servidor atual...",
["Remove Fog"] = "Remover Neblina",
["Removes fog and atmosphere haze."] = "Remove neblina e efeitos de atmosfera.",
["Reset Config"] = "Redefinir Configuração",
["Restore all settings and shortcut positions to their defaults."] = "Restaura configurações e posições dos atalhos aos padrões.",
["Returns you to your last safe position when falling under the map."] = "Retorna à última posição segura ao cair do mapa.",
["Role"] = "Função",
["Round Time"] = "Tempo da Rodada",
["SYSTEM"] = "SISTEMA",
["Save & Load"] = "Salvar e Carregar",
["Save Config"] = "Salvar Configuração",
["Save Failed"] = "Falha ao Salvar",
["Save all registered settings and shortcut positions."] = "Salva todas as configurações registradas e posições dos atalhos.",
["Save the JSON above using the current Config Name."] = "Salva o JSON acima usando o nome de configuração atual.",
["Save, load and manage your Mirrors Hub MM2 settings."] = "Salve, carregue e gerencie as configurações do Mirrors Hub MM2.",
["Saved Configs"] = "Configurações Salvas",
["Saved as: "] = "Salva como: ",
["Searching for a small server..."] = "Procurando um servidor pequeno...",
["Searching for another server..."] = "Procurando outro servidor...",
["Select Player"] = "Selecionar Jogador",
["Select a player"] = "Selecione um jogador",
["Select an existing configuration."] = "Selecione uma configuração existente.",
["Server"] = "Servidor",
["Server Hop"] = "Trocar Servidor",
["Server Hop Failed"] = "Falha ao Trocar Servidor",
["Server Information"] = "Informações do Servidor",
["Server utilities and connection tools."] = "Utilitários de servidor e conexão.",
["Settings restored to defaults."] = "Configurações restauradas aos padrões.",
["Sheriff"] = "Xerife",
["Sheriff ESP"] = "ESP do Xerife",
["Shoot Failed"] = "Falha na Ação",
["Shoot Murder"] = "Ação no Assassino",
["Shoot Murderer"] = "Ação no Assassino",
["Shoot the Murderer directly, even without aiming at them"] = "Executa a ação diretamente no Assassino atual",
["Shortcuts"] = "Atalhos",
["Show Innocent players"] = "Mostra jogadores Inocentes",
["Show Murderer players"] = "Mostra jogadores Assassinos",
["Show Murderer, Sheriff, Hero or Innocent"] = "Mostra Assassino, Xerife, Herói ou Inocente",
["Show Sheriff and Hero players"] = "Mostra jogadores Xerife e Herói",
["Show distance in studs"] = "Mostra a distância em studs",
["Show hub notifications."] = "Exibe notificações do hub.",
["Show player names"] = "Mostra os nomes dos jogadores",
["Show the Fling All shortcut"] = "Mostra o atalho de Fling em Todos",
["Show the Fling Murder shortcut"] = "Mostra o atalho de Fling no Assassino",
["Show the Fling Sheriff shortcut"] = "Mostra o atalho de Fling no Xerife",
["Show the Kill All shortcut"] = "Mostra o atalho de ação em todos",
["Show the Kill Sheriff shortcut"] = "Mostra o atalho de ação no Xerife",
["Show the Shoot Murder shortcut"] = "Mostra o atalho de ação no Assassino",
["Show the TP Gun shortcut"] = "Mostra o atalho de TP do item",
["Show the TP Murder shortcut"] = "Mostra o atalho de TP do Assassino",
["Show the TP Sheriff shortcut"] = "Mostra o atalho de TP do Xerife",
["Show the Throw Knife shortcut"] = "Mostra o atalho de arremesso",
["Small Server"] = "Servidor Pequeno",
["Small Server Failed"] = "Falha ao Procurar Servidor",
["Stop Fling"] = "Parar Fling",
["Stop Fling All"] = "Parar Fling em Todos",
["Stop and return to your original position"] = "Para e retorna à sua posição original",
["TP Gun"] = "TP Item",
["TP Murder"] = "TP Assassino",
["TP Sheriff"] = "TP Xerife",
["Target acquisition radius"] = "Raio de aquisição de alvo",
["Teleport Gun Drop"] = "Teleportar para o Item",
["Teleport Sheriff"] = "Teleportar para o Xerife",
["Teleport directly to the dropped gun"] = "Teleporta diretamente para o item derrubado",
["Teleport to the current Sheriff or Hero"] = "Teleporta para o Xerife ou Herói atual",
["Teleports to a safer position when the Murderer gets within 5 studs"] = "Move para uma posição mais segura quando o Assassino chega a 5 studs",
["Text Size"] = "Tamanho do Texto",
["Theme"] = "Tema",
["Theme changed"] = "Tema alterado",
["This is not a Mirrors/WindUI config."] = "Esta não é uma configuração Mirrors/WindUI.",
["Throw Assist"] = "Assistência de Arremesso",
["Throw Failed"] = "Falha na Ação",
["Throw Knife"] = "Ação de Arremesso",
["Tracer"] = "Traçador",
["Tracer Origin"] = "Origem do Traçador",
["Unknown"] = "Desconhecido",
["Visual & Performance"] = "Visual e Desempenho",
["Walk through collidable objects."] = "Permite atravessar objetos com colisão.",
["WalkSpeed"] = "Velocidade",
["WalkSpeed Value"] = "Valor da Velocidade",
["Your Role"] = "Sua Função",
["Your executor does not support file configs."] = "Seu executor não suporta configurações em arquivo.",
        },
        ["Español"] = {
["Aim Assist"] = "Asistencia de Apuntado",
["Aim FOV"] = "FOV de Apuntado",
["Aim Part"] = "Parte de Apuntado",
["Aim Smoothness"] = "Suavidad de Apuntado",
["Alive Players"] = "Jugadores Vivos",
["Anti-AFK"] = "Anti-AFK",
["Anti-AFK disabled."] = "Anti-AFK desactivado.",
["Anti-AFK enabled."] = "Anti-AFK activado.",
["Anti-Void"] = "Anti-Void",
["Anti Fling"] = "Anti Fling",
["Disables collisions between you and other players."] = "Desactiva la colisión entre tú y otros jugadores.",
["Auto Escape Murderer"] = "Escape Automático del Asesino",
["Auto Gun"] = "Recogida Automática",
["Auto Load"] = "Carga Automática",
["Auto Load Config"] = "Carga Automática",
["Auto Shoot Murderer"] = "Acción Automática en Asesino",
["Auto Throw"] = "Lanzamiento Automático",
["Auto load disabled."] = "Carga automática desactivada.",
["Auto load enabled for: "] = "Carga automática activada para: ",
["Automatically aims at nearby players"] = "Apunta automáticamente a jugadores cercanos",
["Automatically collects nearby coins"] = "Recoge automáticamente monedas cercanas",
["Automatically grabs the dropped gun and returns to your previous position"] = "Recoge automáticamente el objeto caído y vuelve a la posición anterior",
["Automatically kills players inside the selected range"] = "Ejecuta automáticamente la acción en jugadores dentro del alcance seleccionado",
["Automatically load this config when Mirrors Hub starts."] = "Carga automáticamente esta configuración al iniciar Mirrors Hub.",
["Automatically shoots the current Murderer"] = "Ejecuta automáticamente la acción en el Asesino actual",
["Automatically throws the knife at valid targets"] = "Ejecuta automáticamente la acción en objetivos válidos",
["Box"] = "Caja",
["Box and tracer thickness"] = "Grosor de la caja y del trazador",
["Change the interface language."] = "Cambia el idioma de la interfaz.",
["Change your jump power."] = "Cambia la fuerza del salto.",
["Change your movement speed."] = "Cambia tu velocidad de movimiento.",
["Character and movement utilities."] = "Utilidades de personaje y movimiento.",
["Choose a WindUI theme."] = "Elige un tema de WindUI.",
["Choose a player to kill"] = "Elige un jugador",
["Choose the ESP rendering mode"] = "Elige el modo de renderizado del ESP",
["Choose where tracers start"] = "Elige dónde comienzan los trazadores",
["Choose which body part to target"] = "Elige la parte del personaje a la que apuntar",
["Clipboard Error"] = "Error del Portapapeles",
["Clipboard is not supported."] = "El portapapeles no es compatible.",
["Coin Farm"] = "Farm de Monedas",
["Config"] = "Configuración",
["Config Deleted"] = "Configuración Eliminada",
["Config Error"] = "Error de Configuración",
["Config Exported"] = "Configuración Exportada",
["Config Imported"] = "Configuración Importada",
["Config Loaded"] = "Configuración Cargada",
["Config Name"] = "Nombre de Configuración",
["Config Reset"] = "Configuración Restablecida",
["Config Saved"] = "Configuración Guardada",
["Config does not exist."] = "La configuración no existe.",
["Config does not exist: "] = "La configuración no existe: ",
["Config file was not found."] = "No se encontró el archivo de configuración.",
["Config list refreshed."] = "Lista de configuraciones actualizada.",
["Configs"] = "Configuraciones",
["Configuration Manager"] = "Gestor de Configuración",
["Controls aim movement speed"] = "Controla la velocidad del movimiento de apuntado",
["Controls highlight fill transparency"] = "Controla la transparencia del relleno del highlight",
["Copy Job ID"] = "Copiar Job ID",
["Copy or restore configurations using JSON."] = "Copia o restaura configuraciones usando JSON.",
["Copy the current configuration JSON to clipboard."] = "Copia el JSON de la configuración actual al portapapeles.",
["Could not"] = "No se pudo",
["Could not copy the JSON."] = "No se pudo copiar el JSON.",
["Could not create the config."] = "No se pudo crear la configuración.",
["Could not delete the config."] = "No se pudo eliminar la configuración.",
["Could not load the config."] = "No se pudo cargar la configuración.",
["Could not open the config."] = "No se pudo abrir la configuración.",
["Could not prepare the config."] = "No se pudo preparar la configuración.",
["Could not read the config."] = "No se pudo leer la configuración.",
["Could not rejoin the server."] = "No se pudo reconectar al servidor.",
["Could not save the config."] = "No se pudo guardar la configuración.",
["Could not teleport to the server."] = "No se pudo entrar al servidor.",
["Could not write the config."] = "No se pudo escribir la configuración.",
["Delete Config"] = "Eliminar Configuración",
["Delete Failed"] = "Error al Eliminar",
["Deleted: "] = "Eliminada: ",
["Disabled"] = "Desactivado",
["Distance"] = "Distancia",
["Draw a box around players"] = "Dibuja una caja alrededor de los jugadores",
["Draw a line to players"] = "Dibuja una línea hacia los jugadores",
["Drawing ESP text size"] = "Tamaño del texto del ESP Drawing",
["Drawing Thickness"] = "Grosor del Dibujo",
["ESP Mode"] = "Modo ESP",
["Enable ESP"] = "Activar ESP",
["Enable custom JumpPower."] = "Activa una fuerza de salto personalizada.",
["Enable custom WalkSpeed."] = "Activa una velocidad personalizada.",
["Enable player ESP"] = "Activa el ESP de jugadores",
["Enabled"] = "Activado",
["Executor"] = "Executor",
["Export & Import"] = "Exportar e Importar",
["Export Config"] = "Exportar Configuración",
["Export Error"] = "Error al Exportar",
["FPS Boost"] = "Optimización de FPS",
["File configs are not supported."] = "Las configuraciones en archivo no son compatibles.",
["Find a server with fewer players."] = "Busca un servidor con menos jugadores.",
["Fling All"] = "Fling a Todos",
["Fling All Server"] = "Fling a Todo el Servidor",
["Fling Murder"] = "Fling Asesino",
["Fling Murderer"] = "Fling al Asesino",
["Fling Player"] = "Fling al Jugador",
["Fling Sheriff"] = "Fling al Sheriff",
["Fling every player in the server"] = "Aplica fling a todos los jugadores del servidor",
["Fling the current Murderer"] = "Aplica fling al Asesino actual",
["Fling the current Sheriff or Hero"] = "Aplica fling al Sheriff o Héroe actual",
["Fling the selected player"] = "Aplica fling al jugador seleccionado",
["Found a server with "] = "Servidor encontrado con ",
["Fullbright"] = "Iluminación Máxima",
["GENERAL"] = "GENERAL",
["Game Information"] = "Información del Juego",
["Game Mode"] = "Modo de Juego",
["Gun Drop"] = "Objeto Caído",
["Gun Drop ESP"] = "ESP del Objeto Caído",
["Hero"] = "Héroe",
["Highlight Transparency"] = "Transparencia del Highlight",
["Highlights the current Murderer"] = "Resalta al Asesino actual",
["Highlights the current Murderer through walls"] = "Resalta al Asesino actual a través de paredes",
["Highlights the current Sheriff or Hero"] = "Resalta al Sheriff o Héroe actual",
["Highlights the dropped gun"] = "Resalta el objeto caído",
["Highlights the dropped gun through walls"] = "Resalta el objeto caído a través de paredes",
["Import Config"] = "Importar Configuración",
["Import Error"] = "Error al Importar",
["Import JSON"] = "Importar JSON",
["Imported as: "] = "Importada como: ",
["Info"] = "Información",
["Innocent"] = "Inocente",
["Innocent ESP"] = "ESP de Inocentes",
["Interface Settings"] = "Configuración de Interfaz",
["Invalid JSON."] = "JSON inválido.",
["JSON copied to clipboard."] = "JSON copiado al portapapeles.",
["Job ID"] = "Job ID",
["Join another available server."] = "Entra en otro servidor disponible.",
["JumpPower"] = "Fuerza de Salto",
["JumpPower Value"] = "Valor del Salto",
["Keeps the map bright and visible."] = "Mantiene el mapa claro y visible.",
["Kill All"] = "Acción en Todos",
["Kill All Innocents"] = "Acción en Todos los Inocentes",
["Kill All Players"] = "Acción en Todos los Jugadores",
["Kill Failed"] = "Error en la Acción",
["Kill Selected Player"] = "Acción en Jugador Seleccionado",
["Kill Sheriff"] = "Acción en Sheriff",
["Kill every alive Innocent"] = "Ejecuta la acción en todos los Inocentes vivos",
["Kill every alive player"] = "Ejecuta la acción en todos los jugadores vivos",
["Kill the current Sheriff or Hero"] = "Ejecuta la acción en el Sheriff o Héroe actual",
["Kill the selected player"] = "Ejecuta la acción en el jugador seleccionado",
["Knife Aura"] = "Aura",
["Knife Aura Range"] = "Alcance del Aura",
["Knife Failed"] = "Error en la Acción",
["Language"] = "Idioma",
["Language changed"] = "Idioma cambiado",
["Language, theme and notification preferences."] = "Idioma, tema y preferencias de notificaciones.",
["Lighting and performance utilities."] = "Utilidades de iluminación y rendimiento.",
["Load Config"] = "Cargar Configuración",
["Load Failed"] = "Error al Cargar",
["Load the selected configuration."] = "Carga la configuración seleccionada.",
["Loading..."] = "Cargando...",
["Lobby"] = "Lobby",
["MM2 Role ESP"] = "ESP de Roles de MM2",
["Main"] = "Principal",
["Manage the currently selected configuration."] = "Administra la configuración seleccionada.",
["Map"] = "Mapa",
["Max Distance"] = "Distancia Máxima",
["Maximum ESP render distance"] = "Distancia máxima de renderizado del ESP",
["Maximum Knife Aura distance"] = "Distancia máxima del aura",
["Mirrors Purple"] = "Mirrors Purple",
["Misc"] = "Varios",
["Missing Gun"] = "Objeto Ausente",
["Missing Knife"] = "Objeto Ausente",
["Murder"] = "Asesino",
["Murder Chance"] = "Probabilidad de Asesino",
["Murderer"] = "Asesino",
["Murderer ESP"] = "ESP del Asesino",
["Murderer: Red\nSheriff / Hero: Blue\nInnocent: Green"] = "Asesino: Rojo\nSheriff / Héroe: Azul\nInocente: Verde",
["Name"] = "Nombre",
["Name used to save or create a configuration."] = "Nombre usado para guardar o crear una configuración.",
["No Clip"] = "No Clip",
["No Murderer"] = "Sin Asesino",
["No Sheriff"] = "Sin Sheriff",
["No Target"] = "Sin Objetivo",
["No Targets"] = "Sin Objetivos",
["No available server was found."] = "No se encontró ningún servidor disponible.",
["Notifications"] = "Notificaciones",
["Notifications disabled."] = "Notificaciones desactivadas.",
["Notifications enabled."] = "Notificaciones activadas.",
["Paste a config JSON first."] = "Pega primero un JSON de configuración.",
["Paste an exported Mirrors Hub config."] = "Pega una configuración exportada de Mirrors Hub.",
["Permanently delete the selected configuration."] = "Elimina permanentemente la configuración seleccionada.",
["Ping"] = "Ping",
["Player"] = "Jugador",
["Players"] = "Jugadores",
["Prevents Roblox idle kick."] = "Evita la desconexión por inactividad.",
["ROLES"] = "ROLES",
["Redirects knife throws to Sheriff/Hero or the nearest player"] = "Redirige la acción al objetivo válido configurado",
["Reduces effects, shadows and expensive materials."] = "Reduce efectos, sombras y materiales pesados.",
["Refresh Config List"] = "Actualizar Lista",
["Refresh saved configuration files."] = "Actualiza los archivos de configuración guardados.",
["Rejoin"] = "Reconectar",
["Rejoin Failed"] = "Error al Reconectar",
["Rejoin the current server."] = "Reconecta al servidor actual.",
["Rejoining current server..."] = "Reconectando al servidor actual...",
["Remove Fog"] = "Quitar Niebla",
["Removes fog and atmosphere haze."] = "Quita niebla y efectos de atmósfera.",
["Reset Config"] = "Restablecer Configuración",
["Restore all settings and shortcut positions to their defaults."] = "Restaura configuraciones y posiciones de atajos a sus valores predeterminados.",
["Returns you to your last safe position when falling under the map."] = "Vuelve a la última posición segura al caer del mapa.",
["Role"] = "Rol",
["Round Time"] = "Tiempo de Ronda",
["SYSTEM"] = "SISTEMA",
["Save & Load"] = "Guardar y Cargar",
["Save Config"] = "Guardar Configuración",
["Save Failed"] = "Error al Guardar",
["Save all registered settings and shortcut positions."] = "Guarda todas las opciones registradas y posiciones de los atajos.",
["Save the JSON above using the current Config Name."] = "Guarda el JSON anterior usando el nombre de configuración actual.",
["Save, load and manage your Mirrors Hub MM2 settings."] = "Guarda, carga y administra la configuración de Mirrors Hub MM2.",
["Saved Configs"] = "Configuraciones Guardadas",
["Saved as: "] = "Guardada como: ",
["Searching for a small server..."] = "Buscando un servidor pequeño...",
["Searching for another server..."] = "Buscando otro servidor...",
["Select Player"] = "Seleccionar Jugador",
["Select a player"] = "Selecciona un jugador",
["Select an existing configuration."] = "Selecciona una configuración existente.",
["Server"] = "Servidor",
["Server Hop"] = "Cambiar Servidor",
["Server Hop Failed"] = "Error al Cambiar Servidor",
["Server Information"] = "Información del Servidor",
["Server utilities and connection tools."] = "Utilidades de servidor y conexión.",
["Settings restored to defaults."] = "Configuración restaurada a los valores predeterminados.",
["Sheriff"] = "Sheriff",
["Sheriff ESP"] = "ESP del Sheriff",
["Shoot Failed"] = "Error en la Acción",
["Shoot Murder"] = "Acción en Asesino",
["Shoot Murderer"] = "Acción en Asesino",
["Shoot the Murderer directly, even without aiming at them"] = "Ejecuta la acción directamente en el Asesino actual",
["Shortcuts"] = "Atajos",
["Show Innocent players"] = "Muestra jugadores Inocentes",
["Show Murderer players"] = "Muestra jugadores Asesino",
["Show Murderer, Sheriff, Hero or Innocent"] = "Muestra Asesino, Sheriff, Héroe o Inocente",
["Show Sheriff and Hero players"] = "Muestra jugadores Sheriff y Héroe",
["Show distance in studs"] = "Muestra la distancia en studs",
["Show hub notifications."] = "Muestra las notificaciones del hub.",
["Show player names"] = "Muestra los nombres de los jugadores",
["Show the Fling All shortcut"] = "Muestra el atajo de Fling a Todos",
["Show the Fling Murder shortcut"] = "Muestra el atajo de Fling al Asesino",
["Show the Fling Sheriff shortcut"] = "Muestra el atajo de Fling al Sheriff",
["Show the Kill All shortcut"] = "Muestra el atajo de acción en todos",
["Show the Kill Sheriff shortcut"] = "Muestra el atajo de acción en Sheriff",
["Show the Shoot Murder shortcut"] = "Muestra el atajo de acción en Asesino",
["Show the TP Gun shortcut"] = "Muestra el atajo de TP del objeto",
["Show the TP Murder shortcut"] = "Muestra el atajo de TP del Asesino",
["Show the TP Sheriff shortcut"] = "Muestra el atajo de TP del Sheriff",
["Show the Throw Knife shortcut"] = "Muestra el atajo de lanzamiento",
["Small Server"] = "Servidor Pequeño",
["Small Server Failed"] = "Error al Buscar Servidor",
["Stop Fling"] = "Detener Fling",
["Stop Fling All"] = "Detener Fling a Todos",
["Stop and return to your original position"] = "Detiene y vuelve a tu posición original",
["TP Gun"] = "TP Objeto",
["TP Murder"] = "TP Asesino",
["TP Sheriff"] = "TP Sheriff",
["Target acquisition radius"] = "Radio de adquisición de objetivo",
["Teleport Gun Drop"] = "Teleportar al Objeto",
["Teleport Sheriff"] = "Teleportar al Sheriff",
["Teleport directly to the dropped gun"] = "Teleporta directamente al objeto caído",
["Teleport to the current Sheriff or Hero"] = "Teleporta al Sheriff o Héroe actual",
["Teleports to a safer position when the Murderer gets within 5 studs"] = "Se mueve a una posición más segura cuando el Asesino está a 5 studs",
["Text Size"] = "Tamaño del Texto",
["Theme"] = "Tema",
["Theme changed"] = "Tema cambiado",
["This is not a Mirrors/WindUI config."] = "Esta no es una configuración Mirrors/WindUI.",
["Throw Assist"] = "Asistencia de Lanzamiento",
["Throw Failed"] = "Error en la Acción",
["Throw Knife"] = "Acción de Lanzamiento",
["Tracer"] = "Trazador",
["Tracer Origin"] = "Origen del Trazador",
["Unknown"] = "Desconocido",
["Visual & Performance"] = "Visual y Rendimiento",
["Walk through collidable objects."] = "Permite atravesar objetos con colisión.",
["WalkSpeed"] = "Velocidad",
["WalkSpeed Value"] = "Valor de Velocidad",
["Your Role"] = "Tu Rol",
["Your executor does not support file configs."] = "Tu executor no soporta configuraciones en archivo.",
        }
    }

    Mirrors.Translations = Translations

    local function Translate(Text, Language)
        if typeof(Text) ~= "string" then
            return Text
        end
        Language = Language or State.Language
        if Language == "English" then
            return Text
        end
        local Dict = Translations[Language]
        local Value = Dict and Dict[Text]
        if Value then
            return Value
        end

        if Language == "Português" then
            local Extra = {
                ["Role Tools"] = "Ferramentas da Função",
                ["Visual and movement utilities for the current round."] = "Utilitários visuais e de movimento para a rodada atual.",
                ["Control Sheriff and Hero visibility in the main ESP system."] = "Controla a visibilidade de Xerife e Herói no sistema principal de ESP.",
                ["Control Murderer visibility in the main ESP system."] = "Controla a visibilidade do Assassino no sistema principal de ESP.",
                ["Quick Actions"] = "Ações Rápidas",
                ["Fast movement shortcuts for the current round."] = "Atalhos rápidos de movimento para a rodada atual.",
                ["Teleport to the current Murderer"] = "Teleporta para o Assassino atual",
                ["No valid role target was found."] = "Nenhum alvo de função válido foi encontrado.",
                ["Overview"] = "Visão geral",
                ["Gameplay"] = "Jogabilidade",
                ["Visuals"] = "Visuais",
                ["Role tools"] = "Ferramentas da função",
                ["Defense"] = "Defesa",
                ["Survival"] = "Sobrevivência",
                ["Quick actions"] = "Ações rápidas",
                ["Utilities"] = "Utilitários",
                ["Settings"] = "Configurações",
                ["Center Window"] = "Centralizar Janela",
                ["Center the Mirrors Hub window."] = "Centraliza a janela do Mirrors Hub.",
                ["Reapply Visual"] = "Reaplicar Visual",
                ["Reapply Mirrors Purple glow and visual effects."] = "Reaplica o glow e os efeitos visuais do Mirrors Purple.",
                ["Window centered."] = "Janela centralizada.",
                ["Visual reapplied."] = "Visual reaplicado.",
                ["Mirrors Hub MM2 v1.6.1 loaded."] = "Mirrors Hub MM2 v1.6.1 carregado.",
                ["Session"] = "Sessão", ["Automation"] = "Automação", ["Targeting"] = "Mira", ["Player Actions"] = "Ações do Jogador",
                ["Role ESP"] = "ESP de Funções", ["Drawing"] = "Drawing", ["Role Filters"] = "Filtros de Função", ["Combat"] = "Combate",
                ["Target Actions"] = "Ações no Alvo", ["Gun"] = "Arma", ["Floating Shortcuts"] = "Atalhos Flutuantes",
                ["Player & Protection"] = "Jogador e Proteção", ["Interface"] = "Interface", ["Configuration"] = "Configuração"
            }
            return Extra[Text] or Text
        elseif Language == "Español" then
            local Extra = {
                ["Role Tools"] = "Herramientas del Rol",
                ["Visual and movement utilities for the current round."] = "Utilidades visuales y de movimiento para la ronda actual.",
                ["Control Sheriff and Hero visibility in the main ESP system."] = "Controla la visibilidad de Sheriff y Héroe en el sistema principal de ESP.",
                ["Control Murderer visibility in the main ESP system."] = "Controla la visibilidad del Asesino en el sistema principal de ESP.",
                ["Quick Actions"] = "Acciones Rápidas",
                ["Fast movement shortcuts for the current round."] = "Atajos rápidos de movimiento para la ronda actual.",
                ["Teleport to the current Murderer"] = "Teleporta al Asesino actual",
                ["No valid role target was found."] = "No se encontró un objetivo de rol válido.",
                ["Overview"] = "Resumen",
                ["Gameplay"] = "Jugabilidad",
                ["Visuals"] = "Visuales",
                ["Role tools"] = "Herramientas del rol",
                ["Defense"] = "Defensa",
                ["Survival"] = "Supervivencia",
                ["Quick actions"] = "Acciones rápidas",
                ["Utilities"] = "Utilidades",
                ["Settings"] = "Configuración",
                ["Center Window"] = "Centrar Ventana",
                ["Center the Mirrors Hub window."] = "Centra la ventana de Mirrors Hub.",
                ["Reapply Visual"] = "Reaplicar Visual",
                ["Reapply Mirrors Purple glow and visual effects."] = "Reaplica el glow y los efectos visuales de Mirrors Purple.",
                ["Window centered."] = "Ventana centrada.",
                ["Visual reapplied."] = "Visual reaplicado.",
                ["Mirrors Hub MM2 v1.6.1 loaded."] = "Mirrors Hub MM2 v1.6.1 cargado.",
                ["Session"] = "Sesión", ["Automation"] = "Automatización", ["Targeting"] = "Apuntado", ["Player Actions"] = "Acciones del Jugador",
                ["Role ESP"] = "ESP de Roles", ["Drawing"] = "Drawing", ["Role Filters"] = "Filtros de Rol", ["Combat"] = "Combate",
                ["Target Actions"] = "Acciones de Objetivo", ["Gun"] = "Arma", ["Floating Shortcuts"] = "Atajos Flotantes",
                ["Player & Protection"] = "Jugador y Protección", ["Interface"] = "Interfaz", ["Configuration"] = "Configuración"
            }
            return Extra[Text] or Text
        end

        return Text
    end

    local DynamicPrefixes = {
        "Saved as: ",
        "Deleted: ",
        "Imported as: ",
        "Config does not exist: ",
        "Auto load enabled for: ",
        "Found a server with "
    }

    local function TranslateDynamic(Text)
        if typeof(Text) ~= "string" then
            return Text
        end

        local Exact = Translate(Text)
        if Exact ~= Text then
            return Exact
        end

        for _, Prefix in ipairs(DynamicPrefixes) do
            if Text:sub(1, #Prefix) == Prefix then
                return Translate(Prefix) .. Text:sub(#Prefix + 1)
            end
        end

        return Text
    end

    Mirrors.Translate = Translate
    Mirrors.TranslateDynamic = TranslateDynamic

    local Window

    local function Notify(Title, Content, Icon, Duration, Force)
        if not Force and not State.Notifications then
            return
        end

        pcall(function()
            WindUI:Notify({
                Title = TranslateDynamic(tostring(Title or "Mirrors Hub")),
                Content = TranslateDynamic(tostring(Content or "")),
                Icon = Icon or "solar:info-square-bold",
                IconColor = C.PurpleVivid,
                Duration = Duration or 3,
                CanClose = true
            })
        end)
    end

    Mirrors.Notify = Notify

    function Mirrors.GetThemeOptions()
        return table.clone(ThemeOptions)
    end

    function Mirrors.GetUISettings()
        return {
            Language = State.Language,
            Theme = State.Theme,
            Notifications = State.Notifications
        }
    end

    local Registry = {}
    local FlagCounts = {}
    local StyledScroll = setmetatable({}, { __mode = "k" })
    local TabButtons = {}

    Mirrors.Registry = Registry

    local function Slug(Value)
        Value = tostring(Value or "Control")
        Value = Value:gsub("[^%w]+", "")
        if Value == "" then
            Value = "Control"
        end
        return Value
    end

    local NoFlag = {
        ["Config Name"] = true,
        ["Saved Configs"] = true,
        ["Auto Load Config"] = true,
        ["Import JSON"] = true,
        ["Select Player"] = true
    }

    local NoGenericNotify = {
        ["Auto Load Config"] = true,
        ["Aim Assist"] = true,
        ["Knife Aura"] = true,
        ["Throw Assist"] = true,
        ["Auto Throw"] = true,
        ["Auto Shoot Murderer"] = true,
        ["Auto Gun"] = true
    }

    local FlagTypes = {
        Toggle = true,
        Slider = true,
        Dropdown = true,
        Input = true,
        Keybind = true,
        Colorpicker = true
    }

    local function MakeFlag(TabKey, TypeName, Title)
        local Base = Slug(TabKey) .. "_" .. Slug(TypeName) .. "_" .. Slug(Title)
        local Count = (FlagCounts[Base] or 0) + 1
        FlagCounts[Base] = Count
        return Count == 1 and Base or (Base .. tostring(Count))
    end

    local function CopyOptions(Options)
        local New = {}
        for Key, Value in pairs(Options) do
            New[Key] = Value
        end
        return New
    end

    local function ButtonVisual(Title)
        local Lower = tostring(Title or ""):lower()
        if Lower:find("delete",1,true) or Lower:find("kill",1,true) then return C.Red end
        if Lower:find("shoot",1,true) or Lower:find("throw",1,true) then return C.Orange end
        if Lower:find("fling",1,true) then return C.Pink end
        if Lower:find("teleport",1,true) or Lower:find("tp ",1,true) then return C.Cyan end
        if Lower:find("server",1,true) or Lower:find("rejoin",1,true) then return C.Blue end
        if Lower:find("save",1,true) or Lower:find("export",1,true) then return C.Green end
        if Lower:find("load",1,true) or Lower:find("import",1,true) then return C.Blue end
        if Lower:find("refresh",1,true) or Lower:find("reapply",1,true) or Lower:find("center",1,true) or Lower:find("stop",1,true) then return C.Lavender end
        return C.Purple
    end

    local function RegisterElement(Element, TypeName, TabKey, RawTitle, RawDesc)
        if not Element then
            return Element
        end
        table.insert(Registry, {
            Element = Element,
            Type = TypeName,
            Tab = TabKey,
            Title = RawTitle,
            Desc = RawDesc
        })
        return Element
    end

    local function WrapTab(Tab, TabKey)
        for _, TypeName in ipairs({ "Paragraph", "Button", "Toggle", "Slider", "Dropdown", "Input", "Keybind", "Colorpicker", "Section" }) do
            local Original = Tab[TypeName]
            if typeof(Original) == "function" then
                Tab[TypeName] = function(Self, Options)
                    if typeof(Options) ~= "table" then
                        return Original(Self, Options)
                    end

                    local New = CopyOptions(Options)
                    local RawTitle = New.Title
                    local RawDesc = New.Desc

                    if typeof(RawTitle) == "string" then
                        New.Title = Translate(RawTitle)
                    end
                    if typeof(RawDesc) == "string" then
                        New.Desc = TranslateDynamic(RawDesc)
                    end
                    if typeof(New.Placeholder) == "string" then
                        New.Placeholder = Translate(New.Placeholder)
                    end

                    if typeof(New.Buttons) == "table" then
                        local Buttons = {}
                        for Index, Button in ipairs(New.Buttons) do
                            local B = CopyOptions(Button)
                            if typeof(B.Title) == "string" then
                                B.Title = Translate(B.Title)
                            end
                            if typeof(B.Desc) == "string" then
                                B.Desc = TranslateDynamic(B.Desc)
                            end
                            Buttons[Index] = B
                        end
                        New.Buttons = Buttons
                    end

                    if FlagTypes[TypeName] and not New.Flag and typeof(RawTitle) == "string" and not NoFlag[RawTitle] then
                        New.Flag = MakeFlag(TabKey, TypeName, RawTitle)
                    end

                    if TypeName == "Button" then
                        New.Desc = nil
                        New.Color = New.Color or ButtonVisual(RawTitle)
                        New.Justify = "Center"
                        if New.Icon then New.IconAlign = New.IconAlign or "Left" end
                    end

                    if TypeName == "Toggle" and typeof(New.Callback) == "function" and typeof(RawTitle) == "string" and not NoGenericNotify[RawTitle] then
                        local Callback = New.Callback
                        local LastValue = New.Value == true
                        New.Callback = function(Value)
                            Callback(Value)
                            if State.Ready and not State.ConfigApplying and Value ~= LastValue then
                                LastValue = Value
                                Notify(Translate(RawTitle), Translate(Value and "Enabled" or "Disabled"), "solar:check-square-bold", 2)
                            else
                                LastValue = Value
                            end
                        end
                    end

                    local Element = Original(Self, New)
                    RegisterElement(Element, TypeName, TabKey, RawTitle, RawDesc)
                    if TypeName == "Button" and typeof(Self.Space) == "function" then
                        pcall(function() Self:Space({ Columns = 1 }) end)
                    end


                    return Element
                end
            end
        end
    end

    local Background = "rbxassetid://127075963169326"

    local InitialTheme = ThemeKeys[State.Theme] or State.Theme
    pcall(function()
        WindUI:SetTheme(InitialTheme)
    end)

    Window = WindUI:CreateWindow({
        Title = "Mirrors Hub - MM2",
        Icon = "solar:home-2-bold",
        Author = "by blackzw.mp3",
        Folder = "MirrorsHub/MM2",
        Size = UDim2.fromOffset(620, 430),
        MinSize = Vector2.new(560, 380),
        MaxSize = Vector2.new(760, 520),
        ToggleKey = Enum.KeyCode.K,
        Transparent = true,
        Theme = InitialTheme,
        Resizable = true,
        SideBarWidth = 168,
        Background = Background,
        BackgroundImageTransparency = 0.80,
        HideSearchBar = true,
        ScrollBarEnabled = true,
        NewElements = true,
        Topbar = {
            Height = 44,
            ButtonsType = "Mac"
        },
        User = {
            Enabled = false,
            Anonymous = false
        }
    })

    Runtime.Window = Window
    Mirrors.Window = Window

    Window:EditOpenButton({
        Title = "Mirrors Hub",
        Icon = "gem",
        CornerRadius = UDim.new(0, 16),
        StrokeThickness = 1.5,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHex("#F5E7FF")),
            ColorSequenceKeypoint.new(0.25, Color3.fromHex("#D478FF")),
            ColorSequenceKeypoint.new(0.52, Color3.fromHex("#B93EFF")),
            ColorSequenceKeypoint.new(0.78, Color3.fromHex("#9D24EE")),
            ColorSequenceKeypoint.new(1, Color3.fromHex("#6814AF"))
        }),
        OnlyMobile = false,
        Enabled = true,
        Draggable = true
    })

    Window:Tag({
        Title = "v1.6.1",
        Icon = "solar:check-square-bold",
        Color = C.PurpleVivid,
        Border = true
    })

    pcall(function()
        Window:SetPanelBackground(true)
    end)

    local General = Window:Section({ Title = Translate("GENERAL"), Opened = true })
    local RolesSection = Window:Section({ Title = Translate("ROLES"), Opened = true })
    local System = Window:Section({ Title = Translate("SYSTEM"), Opened = true })

    local TabColors = {
        Info = C.PurpleLight,
        Main = C.Purple,
        ESP = C.Cyan,
        Murder = C.Red,
        Sheriff = C.Blue,
        Innocent = C.Green,
        Shortcuts = C.Orange,
        Misc = C.Lavender,
        Config = C.Pink
    }

    local function CreateTab(Section, Key, Desc, Icon)
        local Tab = Section:Tab({
            Title = Translate(Key),
            Desc = Translate(Desc),
            Icon = Icon,
            IconColor = TabColors[Key],
            IconShape = "Square",
            Border = true
        })
        RegisterElement(Tab, "Tab", Key, Key, Desc)
        return Tab
    end

    local Tabs = {
        Info = CreateTab(General, "Info", "Overview", "info"),
        Main = CreateTab(General, "Main", "Gameplay", "house"),
        ESP = CreateTab(General, "ESP", "Visuals", "eye"),
        Murder = CreateTab(RolesSection, "Murder", "Role tools", "skull"),
        Sheriff = CreateTab(RolesSection, "Sheriff", "Defense", "shield"),
        Innocent = CreateTab(RolesSection, "Innocent", "Survival", "user"),
        Shortcuts = CreateTab(System, "Shortcuts", "Quick actions", "zap"),
        Misc = CreateTab(System, "Misc", "Utilities", "wrench"),
        Config = CreateTab(System, "Config", "Settings", "settings")
    }

    Mirrors.Tabs = Tabs
    Mirrors.TabColors = TabColors

    for Key, Tab in pairs(Tabs) do
        WrapTab(Tab, Key)
    end

    local function SectionLine(Tab, Title)
        Tab:Section({ Title = Title, TextSize = 15, FontWeight = Enum.FontWeight.SemiBold, TextTransparency = 0.08 })
        Tab:Divider()
        Tab:Space({ Columns = 1 })
    end
    Mirrors.SectionLine = SectionLine

    local function GetGuiRoots()
        local Roots = { LP:WaitForChild("PlayerGui") }
        if typeof(gethui) == "function" then
            local Success, Root = pcall(gethui)
            if Success and typeof(Root) == "Instance" then
                table.insert(Roots, Root)
            end
        end
        return Roots
    end

    local function FindText(Text)
        for _, Root in ipairs(GetGuiRoots()) do
            for _, Object in ipairs(Root:GetDescendants()) do
                if (Object:IsA("TextLabel") or Object:IsA("TextButton")) and Object.Text == Text then
                    return Object
                end
            end
        end
    end

    local function FindButton(Text)
        local Object = FindText(Text)
        if not Object then
            return
        end
        if Object:IsA("GuiButton") then
            return Object
        end
        local Parent = Object.Parent
        for _ = 1, 8 do
            if not Parent then
                break
            end
            if Parent:IsA("GuiButton") then
                return Parent
            end
            Parent = Parent.Parent
        end
    end

    local function IsWindowFrame(Object)
        if not Object:IsA("Frame") then
            return false
        end
        local Size = Object.AbsoluteSize
        return Size.X >= 540 and Size.X <= 800 and Size.Y >= 350 and Size.Y <= 560
    end

    local function FindWindowFrame()
        local Title = FindText("Mirrors Hub - MM2")
        if Title then
            local Parent = Title.Parent
            for _ = 1, 14 do
                if not Parent then
                    break
                end
                if IsWindowFrame(Parent) then
                    return Parent
                end
                Parent = Parent.Parent
            end
        end
    end

    local function FindWindowRoot()
        local Frame = FindWindowFrame()
        if not Frame then
            return
        end
        local Parent = Frame
        while Parent and not Parent:IsA("ScreenGui") do
            Parent = Parent.Parent
        end
        return Parent
    end

    local function RemoveNamed(Parent, Name)
        local Object = Parent and Parent:FindFirstChild(Name)
        if Object then
            Object:Destroy()
        end
    end

    local function AddWhiteGlow(Parent, Name, Thickness, Transparency)
        if not Parent or Parent:FindFirstChild(Name) then
            return Parent and Parent:FindFirstChild(Name)
        end
        local Glow = Instance.new("UIStroke")
        Glow.Name = Name
        Glow.Thickness = Thickness
        Glow.Color = C.White
        Glow.Transparency = Transparency
        Glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        Glow.Parent = Parent
        return Glow
    end

    local function EnsureCorner(Object, Radius)
        if not Object or not Object:IsA("GuiObject") then
            return
        end
        local Corner = Object:FindFirstChildOfClass("UICorner")
        if not Corner then
            Corner = Instance.new("UICorner")
            Corner.Parent = Object
        end
        Corner.CornerRadius = UDim.new(0, Radius or 12)
        return Corner
    end

    local WindowClipState
    local function ApplyWindowVisual()
        local Frame = FindWindowFrame()
        if not Frame then
            return
        end

        CancelVisualTweens()
        for _, Name in ipairs({ "MirrorsBackground", "MirrorsTint", "MirrorsShade", "MirrorsBorder", "MirrorsGlow", "MirrorsAccent" }) do
            RemoveNamed(Frame, Name)
        end

        if WindowClipState == nil then WindowClipState = Frame.ClipsDescendants end
        if State.Theme ~= "Mirrors Purple" then
            Frame.ClipsDescendants = WindowClipState
            return
        end
        Frame.ClipsDescendants = false

        if State.Theme == "Mirrors Purple" then
            local Art = Instance.new("ImageLabel")
            Art.Name = "MirrorsBackground"
            Art.AnchorPoint = Vector2.new(0.5, 0.5)
            Art.Position = UDim2.fromScale(0.5, 0.5)
            Art.Size = UDim2.fromScale(1.045, 1.045)
            Art.BackgroundTransparency = 1
            Art.Image = Background
            Art.ScaleType = Enum.ScaleType.Crop
            Art.ImageTransparency = 0.80
            Art.ZIndex = 0
            Art.Active = false
            Art.Parent = Frame

            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 18)
            Corner.Parent = Art

            local Tint = Instance.new("Frame")
            Tint.Name = "MirrorsTint"
            Tint.Size = UDim2.fromScale(1, 1)
            Tint.BackgroundColor3 = C.PurpleVivid
            Tint.BackgroundTransparency = 0.94
            Tint.BorderSizePixel = 0
            Tint.ZIndex = 0
            Tint.Active = false
            Tint.Parent = Frame

            local TintCorner = Instance.new("UICorner")
            TintCorner.CornerRadius = UDim.new(0, 18)
            TintCorner.Parent = Tint

            local TintGradient = Instance.new("UIGradient")
            TintGradient.Rotation = 35
            TintGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, C.PurpleLight),
                ColorSequenceKeypoint.new(0.4, C.Purple),
                ColorSequenceKeypoint.new(0.75, C.PurpleVivid),
                ColorSequenceKeypoint.new(1, C.PurpleDark)
            })
            TintGradient.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.70),
                NumberSequenceKeypoint.new(0.5, 0.86),
                NumberSequenceKeypoint.new(1, 0.98)
            })
            TintGradient.Parent = Tint

            local Shade = Instance.new("Frame")
            Shade.Name = "MirrorsShade"
            Shade.Size = UDim2.fromScale(1, 1)
            Shade.BackgroundColor3 = Color3.fromHex("#080609")
            Shade.BackgroundTransparency = 0.63
            Shade.BorderSizePixel = 0
            Shade.ZIndex = 0
            Shade.Active = false
            Shade.Parent = Frame

            local ShadeCorner = Instance.new("UICorner")
            ShadeCorner.CornerRadius = UDim.new(0, 18)
            ShadeCorner.Parent = Shade

            local Move = TrackTween(TweenService:Create(Art, TweenInfo.new(12, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
                Position = UDim2.fromScale(0.505, 0.493),
                Size = UDim2.fromScale(1.07, 1.07)
            }), true)
            Move:Play()

            local Pulse = TrackTween(TweenService:Create(Tint, TweenInfo.new(5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
                BackgroundTransparency = 0.90
            }), true)
            Pulse:Play()
        end

        local Border = Instance.new("UIStroke")
        Border.Name = "MirrorsBorder"
        Border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        Border.Thickness = 1.8
        Border.Transparency = 0.06
        Border.Parent = Frame

        local BorderGradient = Instance.new("UIGradient")
        BorderGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, C.PurpleDeep),
            ColorSequenceKeypoint.new(0.20, C.PurpleVivid),
            ColorSequenceKeypoint.new(0.45, C.White),
            ColorSequenceKeypoint.new(0.56, C.PurpleLight),
            ColorSequenceKeypoint.new(0.82, C.PurpleVivid),
            ColorSequenceKeypoint.new(1, C.PurpleDeep)
        })
        BorderGradient.Parent = Border

        local EdgeGlow = Instance.new("UIStroke")
        EdgeGlow.Name = "MirrorsGlow"
        EdgeGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        EdgeGlow.Thickness = 6
        EdgeGlow.Color = C.White
        EdgeGlow.Transparency = 0.66
        EdgeGlow.Parent = Frame

        local BorderTween = TrackTween(TweenService:Create(BorderGradient, TweenInfo.new(9, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), { Rotation = 360 }), true)
        BorderTween:Play()

        local GlowPulse = TrackTween(TweenService:Create(EdgeGlow, TweenInfo.new(3.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), { Transparency = 0.78 }), true)
        GlowPulse:Play()

        local Accent = Instance.new("Frame")
        Accent.Name = "MirrorsAccent"
        Accent.AnchorPoint = Vector2.new(0.5, 1)
        Accent.Position = UDim2.new(0.5, 0, 1, -1)
        Accent.Size = UDim2.new(0.50, 0, 0, 2)
        Accent.BackgroundColor3 = C.White
        Accent.BorderSizePixel = 0
        Accent.ZIndex = 100
        Accent.Parent = Frame

        local AccentCorner = Instance.new("UICorner")
        AccentCorner.CornerRadius = UDim.new(1, 0)
        AccentCorner.Parent = Accent

        local AccentGradient = Instance.new("UIGradient")
        AccentGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, C.PurpleDark),
            ColorSequenceKeypoint.new(0.25, C.Purple),
            ColorSequenceKeypoint.new(0.5, C.White),
            ColorSequenceKeypoint.new(0.72, C.PurpleVivid),
            ColorSequenceKeypoint.new(1, C.PurpleDark)
        })
        AccentGradient.Parent = Accent

        AddWhiteGlow(Accent, "MirrorsAccentGlow", 6, 0.58)

        local Shine = Instance.new("Frame")
        Shine.Name = "Shine"
        Shine.AnchorPoint = Vector2.new(0.5, 0.5)
        Shine.Position = UDim2.fromScale(-0.18, 0.5)
        Shine.Size = UDim2.new(0.18, 0, 0, 2)
        Shine.BackgroundColor3 = C.White
        Shine.BorderSizePixel = 0
        Shine.ZIndex = 101
        Shine.Parent = Accent

        local ShineGradient = Instance.new("UIGradient")
        ShineGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 0),
            NumberSequenceKeypoint.new(1, 1)
        })
        ShineGradient.Parent = Shine

        local LineTween = TrackTween(TweenService:Create(Shine, TweenInfo.new(4.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1), {
            Position = UDim2.fromScale(1.18, 0.5)
        }), true)
        LineTween:Play()
    end

    Mirrors.ApplyWindowVisual = ApplyWindowVisual

    local function StyleOpenButton()
        local Button = FindButton("Mirrors Hub")
        if not Button then
            return
        end

        EnsureCorner(Button, 16)

        if not Button:FindFirstChild("MirrorsOpenScale") then
            local Scale = Instance.new("UIScale")
            Scale.Name = "MirrorsOpenScale"
            Scale.Scale = 1
            Scale.Parent = Button

            local Glow = AddWhiteGlow(Button, "MirrorsOpenGlow", 6, 0.52)

            local Dot = Instance.new("Frame")
            Dot.Name = "MirrorsOpenDot"
            Dot.AnchorPoint = Vector2.new(1, 0.5)
            Dot.Position = UDim2.new(1, -12, 0.5, 0)
            Dot.Size = UDim2.fromOffset(6, 6)
            Dot.BackgroundColor3 = C.White
            Dot.BorderSizePixel = 0
            Dot.Parent = Button

            local DotCorner = Instance.new("UICorner")
            DotCorner.CornerRadius = UDim.new(1, 0)
            DotCorner.Parent = Dot
            AddWhiteGlow(Dot, "MirrorsOpenDotGlow", 6, 0.48)

            local Breath = TrackTween(TweenService:Create(Glow, TweenInfo.new(2.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), { Transparency = 0.30 }), false)
            Breath:Play()

            local DotPulse = TrackTween(TweenService:Create(Dot, TweenInfo.new(1.7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
                BackgroundTransparency = 0.35,
                Size = UDim2.fromOffset(8, 8)
            }), false)
            DotPulse:Play()

            TrackConnection(Button.Activated:Connect(function()
                TweenService:Create(Scale, TweenInfo.new(0.16, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1.07 }):Play()
                TweenService:Create(Glow, TweenInfo.new(0.10), { Transparency = 0.12 }):Play()
                task.delay(0.15, function()
                    if Scale.Parent then
                        TweenService:Create(Scale, TweenInfo.new(0.20, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
                        TweenService:Create(Glow, TweenInfo.new(0.30), { Transparency = 0.50 }):Play()
                    end
                end)
            end))
        end
    end

    local function FindIconContainer(Button)
        local Best
        local BestArea = math.huge
        for _, Object in ipairs(Button:GetDescendants()) do
            if Object:IsA("ImageLabel") or Object:IsA("ImageButton") then
                local Parent = Object.Parent
                for _ = 1, 3 do
                    if not Parent then
                        break
                    end
                    if Parent:IsA("Frame") then
                        local Size = Parent.AbsoluteSize
                        local Delta = math.abs(Size.X - Size.Y)
                        if Size.X >= 20 and Size.X <= 48 and Size.Y >= 20 and Size.Y <= 48 and Delta <= 10 then
                            local Area = Size.X * Size.Y
                            if Area < BestArea then
                                Best = Parent
                                BestArea = Area
                            end
                        end
                    end
                    Parent = Parent.Parent
                end
            end
        end
        return Best
    end

    local function ClearSelectedGlow()
        for _, Button in pairs(TabButtons) do
            RemoveNamed(Button, "MirrorsSelectedEdge")
            RemoveNamed(Button, "MirrorsSelectedGlow")
            RemoveNamed(Button, "MirrorsTabAccent")
        end
    end

    local function ApplySelectedGlow(Key, Button)
        if State.SelectedTab ~= Key or not Button then
            return
        end

        EnsureCorner(Button, 12)

        local Edge = AddWhiteGlow(Button, "MirrorsSelectedEdge", 1.25, 0.20)
        local Glow = AddWhiteGlow(Button, "MirrorsSelectedGlow", 3.2, 0.72)
        if Edge then Edge.Color = C.White end
        if Glow then Glow.Color = C.White end

        if not Button:FindFirstChild("MirrorsTabAccent") then
            local Accent = Instance.new("Frame")
            Accent.Name = "MirrorsTabAccent"
            Accent.AnchorPoint = Vector2.new(0, 0.5)
            Accent.Position = UDim2.new(0, 2, 0.5, 0)
            Accent.Size = UDim2.new(0, 3, 0.54, 0)
            Accent.BackgroundColor3 = TabColors[Key] or C.Purple
            Accent.BorderSizePixel = 0
            Accent.ZIndex = Button.ZIndex + 2
            Accent.Parent = Button
            EnsureCorner(Accent, 3)
            AddWhiteGlow(Accent, "MirrorsTabAccentGlow", 2.2, 0.65)
        end
    end

    local function StyleTab(Key)
        local Title = Translate(Key)
        local Button = FindButton(Title) or FindButton(Key)
        if not Button then
            return
        end

        TabButtons[Key] = Button
        EnsureCorner(Button, 12)

        local Color = TabColors[Key] or C.Purple
        local IconContainer = FindIconContainer(Button)

        if IconContainer then
            for _, Child in ipairs(IconContainer:GetDescendants()) do
                if Child:IsA("ImageLabel") or Child:IsA("ImageButton") then
                    Child.ImageColor3 = Color
                end
            end
        end

        if not Button:FindFirstChild("MirrorsTabBound") then
            local Marker = Instance.new("BoolValue")
            Marker.Name = "MirrorsTabBound"
            Marker.Parent = Button
            TrackConnection(Button.Activated:Connect(function()
                State.SelectedTab = Key
                ClearSelectedGlow()
                ApplySelectedGlow(Key, Button)
            end))
        end

        ApplySelectedGlow(Key, Button)
    end

    local function StyleScrollbars()
        local Root = FindWindowRoot()
        if not Root then
            return
        end
        for _, Object in ipairs(Root:GetDescendants()) do
            if Object:IsA("ScrollingFrame") and not StyledScroll[Object] then
                StyledScroll[Object] = true
                Object.ScrollBarThickness = 2
                Object.ScrollBarImageColor3 = Color3.fromHex("#D9D7DC")
                Object.ScrollBarImageTransparency = 1
                local Token = 0
                TrackConnection(Object:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
                    Token += 1
                    local Current = Token
                    Object.ScrollBarImageTransparency = 0.20
                    task.delay(0.55, function()
                        if Object.Parent and Current == Token then
                            TweenService:Create(Object, TweenInfo.new(0.25), { ScrollBarImageTransparency = 1 }):Play()
                        end
                    end)
                end))
            end
        end
    end

    local function TranslateGuiText()
        local Root = FindWindowRoot()
        if not Root then
            return
        end

        local Reverse = {}
        for Language, Dict in pairs(Translations) do
            for English, Translated in pairs(Dict) do
                Reverse[Translated] = English
            end
        end

        for _, Object in ipairs(Root:GetDescendants()) do
            if Object:IsA("TextLabel") or Object:IsA("TextButton") then
                local English = Reverse[Object.Text] or Object.Text
                local New = Translate(English)
                if New ~= Object.Text then
                    Object.Text = New
                end
            end
        end
    end

    function Mirrors.RefreshLanguage()
        for _, Entry in ipairs(Registry) do
            local Element = Entry.Element
            if Element then
                if typeof(Entry.Title) == "string" and Element.SetTitle then
                    pcall(function()
                        Element:SetTitle(Translate(Entry.Title))
                    end)
                end
                if Entry.Type ~= "Button" and typeof(Entry.Desc) == "string" and Element.SetDesc then
                    pcall(function()
                        Element:SetDesc(TranslateDynamic(Entry.Desc))
                    end)
                end
            end
        end
        task.defer(TranslateGuiText)
        task.delay(0.08, function()
            if Mirrors.ApplyDetailedStyle then
                Mirrors.ApplyDetailedStyle()
            end
        end)
    end

    function Mirrors.SetLanguage(Language, Silent)
        if Language ~= "English" and Language ~= "Português" and Language ~= "Español" then
            return false
        end
        if State.Language == Language then
            return true
        end
        State.Language = Language
        SavePrefs()
        Mirrors.RefreshLanguage()
        if not Silent then
            Notify("Language changed", Language, "solar:info-square-bold", 2, true)
        end
        return true
    end

    function Mirrors.SetTheme(Name, Silent)
        if not IsThemeValid(Name) then
            return false
        end
        State.Theme = Name
        SavePrefs()
        pcall(function()
            WindUI:SetTheme(ThemeKeys[Name] or Name)
        end)
        task.delay(0.08, ApplyWindowVisual)
        task.delay(0.16, function()
            if Mirrors.ApplyDetailedStyle then
                Mirrors.ApplyDetailedStyle()
            end
        end)
        if not Silent then
            Notify("Theme changed", Name, "solar:check-square-bold", 2, true)
        end
        return true
    end

    function Mirrors.SetNotifications(Value, Silent)
        Value = Value == true
        if State.Notifications == Value then
            return
        end
        if not Value and not Silent then
            Notify("Notifications", "Notifications disabled.", "solar:info-square-bold", 2, true)
        end
        State.Notifications = Value
        SavePrefs()
        if Value and not Silent then
            Notify("Notifications", "Notifications enabled.", "solar:check-square-bold", 2, true)
        end
    end

    function Mirrors.ApplyUISettings(Data, Silent)
        if typeof(Data) ~= "table" then
            return
        end
        if Data.Language then Mirrors.SetLanguage(Data.Language, true) end
        if Data.Theme then Mirrors.SetTheme(Data.Theme, true) end
        if typeof(Data.Notifications) == "boolean" then Mirrors.SetNotifications(Data.Notifications, true) end
        if not Silent then
            Notify("Mirrors Hub", "Settings restored to defaults.", "solar:check-square-bold", 2)
        end
    end

    function Mirrors.ResetUISettings()
        State.ConfigApplying = true
        Mirrors.SetLanguage("English", true)
        Mirrors.SetTheme("Mirrors Purple", true)
        Mirrors.SetNotifications(true, true)
        local Controls = Mirrors.Controls
        if Controls.Language and Controls.Language.Select then pcall(function() Controls.Language:Select("English") end) end
        if Controls.Theme and Controls.Theme.Select then pcall(function() Controls.Theme:Select("Mirrors Purple") end) end
        if Controls.Notifications and Controls.Notifications.Set then pcall(function() Controls.Notifications:Set(true) end) end
        State.ConfigApplying = false
        SavePrefs()
    end

    function Mirrors.ApplyDetailedStyle()
        if not Runtime.Alive then
            return
        end
        ApplyWindowVisual()
        StyleOpenButton()
        for Key in pairs(Tabs) do
            StyleTab(Key)
        end
        StyleScrollbars()
    end

    Runtime.Cleanup = function()
        if not Runtime.Alive then
            return
        end
        Runtime.Alive = false
        CancelVisualTweens()
        for Index = #Runtime.Cleanups, 1, -1 do
            pcall(Runtime.Cleanups[Index])
        end
        table.clear(Runtime.Cleanups)
        for _, Tween in ipairs(Runtime.Tweens) do
            pcall(function() Tween:Cancel() end)
        end
        for _, Connection in ipairs(Runtime.Connections) do
            pcall(function() Connection:Disconnect() end)
        end
        table.clear(Runtime.Tweens)
        table.clear(Runtime.Connections)
        if Env.MirrorsMM2ShortcutsCleanup then pcall(Env.MirrorsMM2ShortcutsCleanup) end
        if Env.MirrorsMM2MiscCleanup then pcall(Env.MirrorsMM2MiscCleanup) end
        if Runtime.Window then
            pcall(function() Runtime.Window:Destroy() end)
        end
        if Env.MirrorsMM2Runtime == Runtime then
            Env.MirrorsMM2Runtime = nil
        end
    end

    if Window.OnDestroy then
        Window:OnDestroy(function()
            if Runtime.Alive then
                Runtime.Cleanup()
            end
        end)
    end

    task.delay(1, function()
        if Runtime.Alive then
            State.Ready = true
            Mirrors.ApplyDetailedStyle()
            Notify("Mirrors Hub - MM2", "Mirrors Hub MM2 v1.6.1 loaded.", "solar:check-square-bold", 3)
        end
    end)
end

local WindUI = Mirrors.WindUI
local Window = Mirrors.Window
local InfoTab = Mirrors.Tabs.Info
local MainTab = Mirrors.Tabs.Main
local EspTab = Mirrors.Tabs.ESP
local MurderTab = Mirrors.Tabs.Murder
local SheriffTab = Mirrors.Tabs.Sheriff
local InnocentTab = Mirrors.Tabs.Innocent
local ShortcutsTab = Mirrors.Tabs.Shortcuts
local MiscTab = Mirrors.Tabs.Misc
local ConfigTab = Mirrors.Tabs.Config
local SectionLine = Mirrors.SectionLine

local Roles = {}

local Executor = "Unknown"

local ServerInfo
local GameInfo

local FARM_SPEED = 25
local ARRIVE_DISTANCE = 1
local CLAIM_DISTANCE = 4
local CLAIM_TIMEOUT = 0.9
local BLOCK_TIME = 1.25

local Farming = false
local FarmID = 0
local CurrentTween

local CachedMap
local CachedContainer

local BlockedCoins = {}

local AimSettings = {
    Enabled = false,
    FOV = 250,
    Smoothness = 0.18,
    TargetPart = "Head"
}

local AimTarget

local SelectedPlayer
local PlayerDropdown

local FollowActive = false
local FollowConnection
local FollowSession = 0
local FollowOriginalCFrame

local TouchFlingEnabled = false
local TouchFlingThread
local TouchFlingSession = 0

local FlingAllActive = false
local FlingAllThread
local FlingAllSession = 0
local FlingAllOriginalCFrame

local MAX_TARGET_SPEED = 150
local TIME_PER_PLAYER = 2.5

local function GetExecutor()
    if typeof(identifyexecutor) == "function" then
        local Success, Name = pcall(identifyexecutor)

        if Success and Name then
            return tostring(Name)
        end
    end

    if typeof(getexecutorname) == "function" then
        local Success, Name = pcall(getexecutorname)

        if Success and Name then
            return tostring(Name)
        end
    end

    return "Unknown"
end

local function GetPing()
    local Success, Value = pcall(function()
        local Item =
            Stats.Network.ServerStatsItem:FindFirstChild("Data Ping")

        return Item
            and math.round(Item:GetValue())
            or 0
    end)

    return Success and Value or 0
end

local function GetMap()
    for _, Object in ipairs(Workspace:GetChildren()) do
        local MapID = Object:GetAttribute("MapID")

        if MapID ~= nil then
            return tostring(MapID)
        end
    end

    return "Lobby"
end

local function GetRoundTime()
    local Timer =
        Workspace:FindFirstChild("RoundTimerPart")

    local Time =
        Timer
        and Timer:GetAttribute("Time")

    if typeof(Time) == "number" then
        return math.max(
            0,
            math.floor(Time)
        )
    end

    return 0
end

local function GetAlivePlayers()
    local Count = 0

    for _, Player in ipairs(Players:GetPlayers()) do
        if Player:GetAttribute("Alive") == true then
            Count += 1
        end
    end

    return Count
end

local CachedMurderChance = "?"
local LastChanceUpdate = 0
local function GetMurderChance()
    local Now = os.clock()
    if Now - LastChanceUpdate < 3 then return CachedMurderChance end
    LastChanceUpdate = Now

    local Success, Result = pcall(function()
        return GetChance:InvokeServer()
    end)

    if Success and typeof(Result) == "number" then
        CachedMurderChance = math.round(Result)
    end
    return CachedMurderChance
end

local LastRolesUpdate = 0
local ROLE_UPDATE_INTERVAL = 0.5

local function UpdateRoles(Force)
    local Now = os.clock()
    if not Force and Now - LastRolesUpdate < ROLE_UPDATE_INTERVAL then
        return true
    end

    local Success, Data = pcall(function()
        return GetCurrentPlayerData:InvokeServer()
    end)

    if not Success or typeof(Data) ~= "table" then
        return false
    end

    LastRolesUpdate = Now
    table.clear(Roles)

    for Name, Info in pairs(Data) do
        if typeof(Info) == "table" then
            local Role = Info.Role or Info.role
            if Role then Roles[tostring(Name)] = tostring(Role) end
        end
    end
    return true
end

local function GetRole(Player)
    return Roles[Player.Name]
        or Roles[tostring(Player.UserId)]
        or "Unknown"
end

local function GetRoundRoles()
    local Murderer = "Unknown"
    local Sheriff = "Unknown"

    for _, Player in ipairs(
        Players:GetPlayers()
    ) do
        local Role =
            GetRole(Player)

        if Role == "Murderer" then
            Murderer =
                Player.Name

        elseif Role == "Sheriff"
        or Role == "Hero" then
            Sheriff =
                Player.Name
        end
    end

    return
        GetRole(LP),
        Murderer,
        Sheriff
end

local function UpdateInfo()
    if not ServerInfo
    or not GameInfo then
        return
    end

    UpdateRoles()

    ServerInfo:SetDesc(
        Mirrors.Translate("Players")
        .. ": "
        .. #Players:GetPlayers()
        .. "/"
        .. Players.MaxPlayers
        .. "\n"
        .. Mirrors.Translate("Job ID")
        .. ": "
        .. game.JobId
        .. "\n"
        .. Mirrors.Translate("Ping")
        .. ": "
        .. GetPing()
        .. " ms"
        .. "\n"
        .. Mirrors.Translate("Executor")
        .. ": "
        .. Executor
    )

    local Role,
    Murderer,
    Sheriff =
        GetRoundRoles()

    GameInfo:SetDesc(
        Mirrors.Translate("Map")
        .. ": "
        .. Mirrors.Translate(GetMap())
        .. "\n"
        .. Mirrors.Translate("Game Mode")
        .. ": "
        .. Mirrors.Translate(tostring(
            Workspace:GetAttribute("GameMode")
            or "Unknown"
        ))
        .. "\n"
        .. Mirrors.Translate("Round Time")
        .. ": "
        .. GetRoundTime()
        .. "s"
        .. "\n"
        .. Mirrors.Translate("Your Role")
        .. ": "
        .. Mirrors.Translate(Role)
        .. "\n"
        .. Mirrors.Translate("Murderer")
        .. ": "
        .. Murderer
        .. "\n"
        .. Mirrors.Translate("Sheriff")
        .. ": "
        .. Sheriff
        .. "\n"
        .. Mirrors.Translate("Alive Players")
        .. ": "
        .. GetAlivePlayers()
        .. "\n"
        .. Mirrors.Translate("Murder Chance")
        .. ": "
        .. GetMurderChance()
        .. "%"
    )
end

local function GetRoot()
    local Character =
        LP.Character

    if not Character then
        return
    end

    local Root =
        Character:FindFirstChild(
            "HumanoidRootPart"
        )

    local Humanoid =
        Character:FindFirstChildOfClass(
            "Humanoid"
        )

    if not Root
    or not Humanoid
    or Humanoid.Health <= 0 then
        return
    end

    return Root
end

local function ResetRootPhysics(Root)
    if not Root
    or not Root.Parent then
        return
    end

    Root.AssemblyLinearVelocity =
        Vector3.zero

    Root.AssemblyAngularVelocity =
        Vector3.zero
end

local function GetCoinContainer()
    if CachedMap
    and CachedMap.Parent
    and CachedContainer
    and CachedContainer.Parent then
        return CachedContainer
    end

    CachedMap = nil
    CachedContainer = nil

    table.clear(BlockedCoins)

    for _, Object in ipairs(
        Workspace:GetChildren()
    ) do
        local Container =
            Object:FindFirstChild(
                "CoinContainer"
            )

        if Object:GetAttribute("MapID") ~= nil
        and Container then

            CachedMap =
                Object

            CachedContainer =
                Container

            return Container
        end
    end
end

local function GetCoinVisual(Coin)
    if not Coin
    or not Coin.Parent
    or not Coin:IsA("BasePart") then
        return
    end

    local Visual =
        Coin:FindFirstChild(
            "CoinVisual"
        )

    if not Visual
    or Visual:GetAttribute("Collected") == true then
        return
    end

    return Visual
end

local function GetNearestCoin(
    Root,
    Container
)
    local Closest
    local ClosestVisual

    local ClosestDistance =
        math.huge

    local Now =
        os.clock()

    for _, Coin in ipairs(
        Container:GetChildren()
    ) do
        local BlockedUntil =
            BlockedCoins[Coin]

        if BlockedUntil
        and BlockedUntil <= Now then
            BlockedCoins[Coin] =
                nil

            BlockedUntil =
                nil
        end

        if not Coin.Parent then
            BlockedCoins[Coin] =
                nil

        elseif not BlockedUntil then
            local Visual =
                GetCoinVisual(Coin)

            if Visual then
                local Distance =
                    (
                        Root.Position
                        - Coin.Position
                    ).Magnitude

                if Distance < ClosestDistance then
                    Closest =
                        Coin

                    ClosestVisual =
                        Visual

                    ClosestDistance =
                        Distance
                end
            end
        end
    end

    return
        Closest,
        ClosestVisual
end

local function CancelCoinMovement()
    local Tween =
        CurrentTween

    CurrentTween =
        nil

    if Tween then
        pcall(function()
            Tween:Cancel()
        end)
    end
end

local function MoveToCoin(
    Root,
    Coin,
    Visual,
    ID
)
    if not Root.Parent
    or not Coin.Parent
    or not Visual.Parent
    or not Farming
    or ID ~= FarmID then
        return false, false
    end

    local Position =
        Coin.Position

    local Distance =
        (
            Root.Position
            - Position
        ).Magnitude

    if Distance <= ARRIVE_DISTANCE then
        return
            true,
            false,
            Position
    end

    local Duration =
        math.max(
            Distance / FARM_SPEED,
            0.03
        )

    local Tween =
        TweenService:Create(
            Root,

            TweenInfo.new(
                Duration,
                Enum.EasingStyle.Linear
            ),

            {
                CFrame =
                    CFrame.new(Position)
                    * Root.CFrame.Rotation
            }
        )

    CurrentTween =
        Tween

    local Finished =
        false

    local State

    local Connection =
        Tween.Completed:Connect(
            function(NewState)
                State =
                    NewState

                Finished =
                    true
            end
        )

    Tween:Play()

    local Deadline =
        os.clock()
        + Duration
        + 0.75

    while Farming
    and ID == FarmID
    and not Finished do

        if not Root.Parent
        or LP:GetAttribute("Alive") ~= true then
            break
        end

        if not Coin.Parent
        or not Visual.Parent
        or Visual:GetAttribute("Collected") == true then
            break
        end

        if os.clock() >= Deadline then
            break
        end

        task.wait(0.03)
    end

    if not Finished then
        pcall(function()
            Tween:Cancel()
        end)
    end

    Connection:Disconnect()

    if CurrentTween == Tween then
        CurrentTween =
            nil
    end

    if not Farming
    or ID ~= FarmID
    or not Root.Parent then
        return
            false,
            false,
            Position
    end

    local Near =
        (
            Root.Position
            - Position
        ).Magnitude
        <= CLAIM_DISTANCE

    local Collected =
        not Coin.Parent
        or not Visual.Parent
        or Visual:GetAttribute("Collected") == true

    if Collected then
        return
            Near,
            Near,
            Position
    end

    return
        (
            State == Enum.PlaybackState.Completed
            and Near
        ),
        false,
        Position
end

local function WaitForCoin(
    Coin,
    Visual,
    Root,
    Position,
    ID
)
    local Deadline =
        os.clock()
        + CLAIM_TIMEOUT

    while Farming
    and ID == FarmID do

        if not Root.Parent
        or LP:GetAttribute("Alive") ~= true then
            return false
        end

        local Near =
            (
                Root.Position
                - Position
            ).Magnitude
            <= CLAIM_DISTANCE

        if not Coin.Parent
        or not Visual.Parent
        or Visual:GetAttribute("Collected") == true then
            return Near
        end

        if not Near
        or os.clock() >= Deadline then
            return false
        end

        task.wait(0.03)
    end

    return false
end

local function StopCoinFarm()
    Farming =
        false

    FarmID += 1

    CancelCoinMovement()
end

local function StartCoinFarm()
    StopCoinFarm()

    Farming =
        true

    local ID =
        FarmID

    task.spawn(function()
        while Farming
        and ID == FarmID do

            local Success, Error =
                pcall(function()

                    if LP:GetAttribute("Alive") ~= true then
                        CancelCoinMovement()
                        task.wait(0.25)
                        return
                    end

                    local Root =
                        GetRoot()

                    if not Root then
                        CancelCoinMovement()
                        task.wait(0.2)
                        return
                    end

                    local Container =
                        GetCoinContainer()

                    if not Container then
                        CancelCoinMovement()
                        task.wait(0.35)
                        return
                    end

                    local Coin,
                    Visual =
                        GetNearestCoin(
                            Root,
                            Container
                        )

                    if not Coin
                    or not Visual then
                        task.wait(0.12)
                        return
                    end

                    local Reached,
                    Collected,
                    Position =
                        MoveToCoin(
                            Root,
                            Coin,
                            Visual,
                            ID
                        )

                    if Collected then
                        task.wait(0.03)
                        return
                    end

                    if Reached
                    and WaitForCoin(
                        Coin,
                        Visual,
                        Root,
                        Position,
                        ID
                    ) then
                        task.wait(0.03)
                        return
                    end

                    if Coin.Parent then
                        BlockedCoins[Coin] =
                            os.clock()
                            + BLOCK_TIME
                    end

                    task.wait(0.04)
                end)

            if not Success then
                CancelCoinMovement()

                warn(
                    "[Coin Farm] "
                    .. tostring(Error)
                )

                task.wait(0.35)
            end
        end
    end)
end

local function GetAimCamera()
    return Workspace.CurrentCamera
end

local function GetAimPart(Player)
    if not Player
    or Player == LP
    or not Player.Character then
        return
    end

    local Character =
        Player.Character

    local Humanoid =
        Character:FindFirstChildOfClass(
            "Humanoid"
        )

    if not Humanoid
    or Humanoid.Health <= 0 then
        return
    end

    return
        Character:FindFirstChild(
            AimSettings.TargetPart
        )
        or Character:FindFirstChild("Head")
        or Character:FindFirstChild(
            "HumanoidRootPart"
        )
end

local function GetScreenCenter()
    local Camera =
        GetAimCamera()

    if not Camera then
        return Vector2.zero
    end

    return
        Camera.ViewportSize
        * 0.5
end

local function IsAimTargetValid(Player)
    local Camera =
        GetAimCamera()

    local Part =
        GetAimPart(Player)

    if not Camera
    or not Part then
        return false
    end

    local Position,
    OnScreen =
        Camera:WorldToViewportPoint(
            Part.Position
        )

    if not OnScreen
    or Position.Z <= 0 then
        return false
    end

    local Distance =
        (
            Vector2.new(
                Position.X,
                Position.Y
            )
            - GetScreenCenter()
        ).Magnitude

    return
        Distance
        <= AimSettings.FOV
end

local function GetClosestAimTarget()
    local Camera =
        GetAimCamera()

    if not Camera then
        return
    end

    local Center =
        GetScreenCenter()

    local Closest

    local ClosestDistance =
        AimSettings.FOV

    for _, Player in ipairs(
        Players:GetPlayers()
    ) do
        if Player ~= LP then
            local Part =
                GetAimPart(Player)

            if Part then
                local Position,
                OnScreen =
                    Camera:WorldToViewportPoint(
                        Part.Position
                    )

                if OnScreen
                and Position.Z > 0 then

                    local Distance =
                        (
                            Vector2.new(
                                Position.X,
                                Position.Y
                            )
                            - Center
                        ).Magnitude

                    if Distance
                    < ClosestDistance then

                        ClosestDistance =
                            Distance

                        Closest =
                            Player
                    end
                end
            end
        end
    end

    return Closest
end

local function ClearAimTarget()
    AimTarget =
        nil
end

local function SetAimEnabled(Value)
    AimSettings.Enabled =
        Value

    if not Value then
        ClearAimTarget()
    end
end

local function GetPlayerNames()
    local List = {}

    for _, Player in ipairs(
        Players:GetPlayers()
    ) do
        if Player ~= LP then
            table.insert(
                List,
                Player.Name
            )
        end
    end

    table.sort(List)

    return List
end

local function GetPlayerFromName(Name)
    if not Name then
        return
    end

    return
        Players:FindFirstChild(Name)
end

local function RefreshPlayerDropdown()
    if not PlayerDropdown then
        return
    end

    PlayerDropdown:Refresh(
        GetPlayerNames()
    )

    if SelectedPlayer
    and not SelectedPlayer.Parent then
        SelectedPlayer =
            nil
    end
end

local function StopTouchFling()
    TouchFlingEnabled =
        false

    TouchFlingSession += 1
end

local function StartTouchFling()
    if TouchFlingEnabled then
        return
    end

    TouchFlingEnabled =
        true

    TouchFlingSession += 1

    local Session =
        TouchFlingSession

    TouchFlingThread =
        task.spawn(function()

            local Character
            local Root
            local Velocity
            local MoveL = 0.1

            while TouchFlingEnabled
            and Session == TouchFlingSession do

                RunService.Heartbeat:Wait()

                if not TouchFlingEnabled
                or Session ~= TouchFlingSession then
                    break
                end

                Character =
                    LP.Character

                Root =
                    Character
                    and Character:FindFirstChild(
                        "HumanoidRootPart"
                    )

                if Root then
                    Velocity =
                        Root.AssemblyLinearVelocity

                    Root.AssemblyLinearVelocity =
                        Velocity * 10000
                        + Vector3.new(
                            0,
                            10000,
                            0
                        )

                    RunService.RenderStepped:Wait()

                    if not TouchFlingEnabled
                    or Session ~= TouchFlingSession
                    or not Root.Parent then
                        break
                    end

                    Root.AssemblyLinearVelocity =
                        Velocity

                    RunService.Stepped:Wait()

                    if not TouchFlingEnabled
                    or Session ~= TouchFlingSession
                    or not Root.Parent then
                        break
                    end

                    Root.AssemblyLinearVelocity =
                        Velocity
                        + Vector3.new(
                            0,
                            MoveL,
                            0
                        )

                    MoveL =
                        -MoveL
                end
            end

            if Session == TouchFlingSession then
                TouchFlingThread =
                    nil
            end
        end)
end

local function StopFollowPlayer(TeleportBack)
    local WasActive =
        FollowActive
        or FollowConnection ~= nil

    FollowActive =
        false

    FollowSession += 1

    if FollowConnection then
        FollowConnection:Disconnect()
        FollowConnection =
            nil
    end

    if not WasActive then
        FollowOriginalCFrame =
            nil

        return
    end

    StopTouchFling()

    local Root =
        GetRoot()

    if Root then
        ResetRootPhysics(Root)

        if TeleportBack
        and FollowOriginalCFrame then
            Root.CFrame =
                FollowOriginalCFrame

            ResetRootPhysics(Root)
        end
    end

    FollowOriginalCFrame =
        nil
end

local function StopFlingAll(TeleportBack)
    local WasActive =
        FlingAllActive
        or FlingAllThread ~= nil

    FlingAllActive =
        false

    FlingAllSession += 1

    if not WasActive then
        FlingAllOriginalCFrame =
            nil

        return
    end

    StopTouchFling()

    local Root =
        GetRoot()

    if Root then
        ResetRootPhysics(Root)

        if TeleportBack
        and FlingAllOriginalCFrame then

            Root.CFrame =
                FlingAllOriginalCFrame

            ResetRootPhysics(Root)
        end
    end

    FlingAllOriginalCFrame =
        nil

    FlingAllThread =
        nil
end

local function FollowAndFlingPlayer(Player)
    if not Player
    or Player == LP
    or not Player.Parent then
        return
    end

    if FlingAllActive then
        StopFlingAll(true)
    end

    if FollowActive then
        StopFollowPlayer(true)
    end

    local Root =
        GetRoot()

    if not Root then
        return
    end

    FollowOriginalCFrame =
        Root.CFrame

    FollowActive =
        true

    FollowSession += 1

    local Session =
        FollowSession

    StartTouchFling()

    FollowConnection =
        RunService.Heartbeat:Connect(
            function()

                if not FollowActive
                or Session ~= FollowSession then
                    return
                end

                if not Player.Parent then
                    StopFollowPlayer(true)
                    return
                end

                local MyCharacter =
                    LP.Character

                local TargetCharacter =
                    Player.Character

                if not MyCharacter
                or not TargetCharacter then
                    StopFollowPlayer(true)
                    return
                end

                local MyRoot =
                    MyCharacter:FindFirstChild(
                        "HumanoidRootPart"
                    )

                local TargetRoot =
                    TargetCharacter:FindFirstChild(
                        "HumanoidRootPart"
                    )

                local TargetHumanoid =
                    TargetCharacter:FindFirstChildOfClass(
                        "Humanoid"
                    )

                if not MyRoot
                or not TargetRoot
                or not TargetHumanoid
                or TargetHumanoid.Health <= 0 then

                    StopFollowPlayer(true)
                    return
                end

                MyRoot.CFrame =
                    TargetRoot.CFrame
                    * CFrame.Angles(
                        math.rad(90),
                        0,
                        math.rad(180)
                    )

                if
                    TargetRoot
                        .AssemblyLinearVelocity
                        .Magnitude
                    >= MAX_TARGET_SPEED
                then
                    StopFollowPlayer(true)
                end
            end
        )
end

local function FlingAllPlayers()
    if FlingAllActive then
        StopFlingAll(true)
        return
    end

    if FollowActive then
        StopFollowPlayer(true)
    end

    local Root =
        GetRoot()

    if not Root then
        return
    end

    FlingAllOriginalCFrame =
        Root.CFrame

    FlingAllActive =
        true

    FlingAllSession += 1

    local Session =
        FlingAllSession

    StartTouchFling()

    FlingAllThread =
        task.spawn(function()

            local Targets = {}

            for _, Player in ipairs(
                Players:GetPlayers()
            ) do
                if Player ~= LP then
                    table.insert(
                        Targets,
                        Player
                    )
                end
            end

            for _, TargetPlayer in ipairs(Targets) do
                if not FlingAllActive
                or Session ~= FlingAllSession then
                    break
                end

                if TargetPlayer.Parent then
                    local StartTime =
                        os.clock()

                    while FlingAllActive
                    and Session == FlingAllSession
                    and TargetPlayer.Parent do

                        RunService.Heartbeat:Wait()

                        if not FlingAllActive
                        or Session ~= FlingAllSession then
                            break
                        end

                        local MyCharacter =
                            LP.Character

                        local TargetCharacter =
                            TargetPlayer.Character

                        if not MyCharacter
                        or not TargetCharacter then
                            break
                        end

                        local MyRoot =
                            MyCharacter:FindFirstChild(
                                "HumanoidRootPart"
                            )

                        local TargetRoot =
                            TargetCharacter:FindFirstChild(
                                "HumanoidRootPart"
                            )

                        local TargetHumanoid =
                            TargetCharacter:FindFirstChildOfClass(
                                "Humanoid"
                            )

                        if not MyRoot
                        or not TargetRoot
                        or not TargetHumanoid
                        or TargetHumanoid.Health <= 0 then
                            break
                        end

                        MyRoot.CFrame =
                            TargetRoot.CFrame
                            * CFrame.Angles(
                                math.rad(90),
                                0,
                                math.rad(180)
                            )

                        if
                            TargetRoot
                                .AssemblyLinearVelocity
                                .Magnitude
                            >= MAX_TARGET_SPEED
                        then
                            break
                        end

                        if
                            os.clock()
                            - StartTime
                            >= TIME_PER_PLAYER
                        then
                            break
                        end
                    end

                    if FlingAllActive
                    and Session == FlingAllSession then
                        task.wait(0.1)
                    end
                end
            end

            if FlingAllActive
            and Session == FlingAllSession then
                StopFlingAll(true)
            end
        end)
end

Mirrors.TrackConnection(RunService.RenderStepped:Connect(function()
    if not AimSettings.Enabled then
        return
    end

    local Camera =
        GetAimCamera()

    if not Camera then
        return
    end

    if not IsAimTargetValid(AimTarget) then
        AimTarget =
            GetClosestAimTarget()
    end

    local TargetPart =
        GetAimPart(AimTarget)

    if not TargetPart then
        return
    end

    local Current =
        Camera.CFrame

    local Direction =
        TargetPart.Position
        - Current.Position

    if Direction.Magnitude <= 0.001 then
        return
    end

    local Desired =
        CFrame.lookAt(
            Current.Position,
            TargetPart.Position
        )

    Camera.CFrame =
        Current:Lerp(
            Desired,

            math.clamp(
                AimSettings.Smoothness,
                0.01,
                1
            )
        )
end))

Mirrors.TrackConnection(Players.PlayerAdded:Connect(function()
    task.defer(
        RefreshPlayerDropdown
    )
end))

Mirrors.TrackConnection(Players.PlayerRemoving:Connect(function(Player)
    if Player == AimTarget then
        ClearAimTarget()
    end

    if Player == SelectedPlayer then
        SelectedPlayer =
            nil

        if FollowActive then
            StopFollowPlayer(true)
        end
    end

    task.defer(
        RefreshPlayerDropdown
    )
end))

Mirrors.TrackConnection(LP.CharacterRemoving:Connect(function()
    CancelCoinMovement()
    ClearAimTarget()
    StopFollowPlayer(false)
    StopFlingAll(false)
    StopTouchFling()
end))

Mirrors.TrackConnection(LP:GetAttributeChangedSignal(
    "Alive"
):Connect(function()

    if LP:GetAttribute("Alive") ~= true then
        CancelCoinMovement()
        ClearAimTarget()
        StopFollowPlayer(false)
        StopFlingAll(false)
        StopTouchFling()
    end
end))

Mirrors.AddCleanup(function()
    StopCoinFarm(); ClearAimTarget(); StopFollowPlayer(false); StopFlingAll(false); StopTouchFling()
end)

SectionLine(InfoTab, "Session")
ServerInfo = InfoTab:Paragraph({
    Title = "Server Information",
    Desc = "Loading...",

    Buttons = {
        {
            Icon = "copy",
            Title = "Copy Job ID",

            Callback = function()
                if typeof(setclipboard) == "function" then
                    setclipboard(
                        game.JobId
                    )
                end
            end,
        }
    }
})

GameInfo = InfoTab:Paragraph({
    Title = "Game Information",
    Desc = "Loading..."
})

SectionLine(MainTab, "Automation")
MainTab:Toggle({
    Title = "Coin Farm",
    Desc = "Automatically collects nearby coins",
    Value = false,

    Callback = function(Value)
        if Value then
            StartCoinFarm()
        else
            StopCoinFarm()
        end
    end
})

SectionLine(MainTab, "Targeting")
MainTab:Toggle({
    Title = "Aim Assist",
    Desc = "Automatically aims at nearby players",
    Value = false,

    Callback = function(Value)
        SetAimEnabled(Value)
    end
})

MainTab:Dropdown({
    Title = "Aim Part",
    Desc = "Choose which body part to target",

    Values = {
        "Head",
        "HumanoidRootPart",
        "UpperTorso",
        "LowerTorso",
        "Torso"
    },

    Value = "Head",

    Callback = function(Value)
        if type(Value) == "table" then
            Value =
                Value.Value
                or Value.Title
                or Value[1]
        end

        AimSettings.TargetPart =
            Value
            or "Head"

        ClearAimTarget()
    end
})

MainTab:Slider({
    Title = "Aim Smoothness",
    Desc = "Controls aim movement speed",

    Step = 1,

    Value = {
        Min = 1,
        Max = 100,
        Default = 18
    },

    Callback = function(Value)
        AimSettings.Smoothness =
            math.clamp(
                Value / 100,
                0.01,
                1
            )
    end
})

MainTab:Slider({
    Title = "Aim FOV",
    Desc = "Target acquisition radius",

    Step = 5,

    Value = {
        Min = 50,
        Max = 600,
        Default = 250
    },

    Callback = function(Value)
        AimSettings.FOV =
            Value

        ClearAimTarget()
    end
})

SectionLine(MainTab, "Player Actions")
PlayerDropdown = MainTab:Dropdown({
    Title = "Select Player",
    Desc = "Select a player",

    Values = GetPlayerNames(),

    AllowNone = true,
    SearchBarEnabled = true,

    Callback = function(Value)
        if type(Value) == "table" then
            Value =
                Value.Value
                or Value.Title
                or Value[1]
        end

        SelectedPlayer =
            GetPlayerFromName(Value)
    end
})

MainTab:Button({
    Title = "Fling Player",
    Desc = "Fling the selected player",
    Icon = "zap",

    Callback = function()
        FollowAndFlingPlayer(
            SelectedPlayer
        )
    end
})

MainTab:Button({
    Title = "Stop Fling",
    Desc = "Stop and return to your original position",
    Icon = "x",

    Callback = function()
        StopFollowPlayer(true)
    end
})

MainTab:Button({
    Title = "Fling All Server",
    Desc = "Fling every player in the server",
    Icon = "users",

    Callback = function()
        FlingAllPlayers()
    end
})

MainTab:Button({
    Title = "Stop Fling All",
    Desc = "Stop and return to your original position",
    Icon = "x",

    Callback = function()
        StopFlingAll(true)
    end
})

Executor =
    GetExecutor()

InfoTab:Select()

UpdateInfo()

task.spawn(function()
    while Mirrors.Runtime.Alive do
        task.wait(1)
        if not Mirrors.Runtime.Alive then break end
        pcall(UpdateInfo)
    end
end)

-- Main

local ESPColors = {
    Murderer = Color3.fromRGB(255, 70, 70),
    Sheriff = Color3.fromRGB(70, 150, 255),
    Hero = Color3.fromRGB(70, 150, 255),
    Innocent = Color3.fromRGB(80, 255, 120)
}

local ESPSettings = {
    Enabled = false,
    Mode = "Highlight",

    Box = true,
    Name = true,
    Role = true,
    Distance = true,
    Tracer = false,

    Murderer = true,
    Sheriff = true,
    Innocent = true,

    MaxDistance = 1000,

    TracerOrigin = "Bottom",

    HighlightFillTransparency = 0.72,
    HighlightOutlineTransparency = 0,

    DrawingThickness = 2,
    TextSize = 13
}

local ESPObjects = {}
local ESPAccumulator = 0
local ESP_UPDATE_RATE = 1 / 60

local function GetESPDropdownValue(Value)
    if type(Value) == "table" then
        return
            Value.Value
            or Value.Title
            or Value[1]
    end

    return Value
end

local function NormalizeESPRole(Role)
    if Role == "Murderer" then
        return "Murderer"
    end

    if Role == "Sheriff"
    or Role == "Hero" then
        return "Sheriff"
    end

    return "Innocent"
end

local function GetESPColor(Role)
    return
        ESPColors[Role]
        or ESPColors[
            NormalizeESPRole(Role)
        ]
        or ESPColors.Innocent
end

local function IsESPRoleEnabled(Role)
    local Normalized =
        NormalizeESPRole(Role)

    if Normalized == "Murderer" then
        return ESPSettings.Murderer
    end

    if Normalized == "Sheriff" then
        return ESPSettings.Sheriff
    end

    return ESPSettings.Innocent
end

local function HasDrawingSupport()
    local Success, Result = pcall(function()
        return Drawing ~= nil and typeof(Drawing.new) == "function"
    end)
    return Success and Result == true
end

local function NewDrawing(Type)
    if not HasDrawingSupport() then
        return
    end

    local Success, Object =
        pcall(function()
            return Drawing.new(Type)
        end)

    if Success then
        return Object
    end
end

local function RemoveDrawing(Object)
    if not Object then
        return
    end

    pcall(function()
        if Object.Remove then
            Object:Remove()
        elseif Object.Destroy then
            Object:Destroy()
        end
    end)
end

local function HideDrawings(Drawings)
    if not Drawings then
        return
    end

    for _, Object in pairs(Drawings) do
        if Object then
            pcall(function()
                Object.Visible = false
            end)
        end
    end
end

local function DestroyDrawings(Drawings)
    if not Drawings then
        return
    end

    for _, Object in pairs(Drawings) do
        RemoveDrawing(Object)
    end
end

local function GetESPData(Player)
    local Data =
        ESPObjects[Player]

    if Data then
        return Data
    end

    Data = {
        Highlight = nil,
        HighlightCharacter = nil,
        Drawings = nil
    }

    ESPObjects[Player] =
        Data

    return Data
end

local function EnsureDrawings(Player)
    local Data =
        GetESPData(Player)

    if Data.Drawings then
        return Data.Drawings
    end

    if not HasDrawingSupport() then
        return
    end

    local Box =
        NewDrawing("Square")

    local Name =
        NewDrawing("Text")

    local Role =
        NewDrawing("Text")

    local Distance =
        NewDrawing("Text")

    local Tracer =
        NewDrawing("Line")

    if not Box
    or not Name
    or not Role
    or not Distance
    or not Tracer then

        RemoveDrawing(Box)
        RemoveDrawing(Name)
        RemoveDrawing(Role)
        RemoveDrawing(Distance)
        RemoveDrawing(Tracer)

        return
    end

    pcall(function()
        Box.Visible = false
        Box.Filled = false
        Box.Transparency = 1
        Box.ZIndex = 2

        Name.Visible = false
        Name.Center = true
        Name.Outline = true
        Name.OutlineColor = Color3.fromRGB(8, 8, 10)
        Name.Transparency = 1
        Name.ZIndex = 3

        Role.Visible = false
        Role.Center = true
        Role.Outline = true
        Role.OutlineColor = Color3.fromRGB(8, 8, 10)
        Role.Transparency = 1
        Role.ZIndex = 3

        Distance.Visible = false
        Distance.Center = true
        Distance.Outline = true
        Distance.OutlineColor = Color3.fromRGB(8, 8, 10)
        Distance.Transparency = 1
        Distance.ZIndex = 3

        Tracer.Visible = false
        Tracer.Transparency = 0.90
        Tracer.ZIndex = 1
    end)

    Data.Drawings = {
        Box = Box,
        Name = Name,
        Role = Role,
        Distance = Distance,
        Tracer = Tracer
    }

    return Data.Drawings
end

local function DestroyHighlight(Data)
    if not Data then
        return
    end

    if Data.Highlight then
        pcall(function()
            Data.Highlight:Destroy()
        end)
    end

    Data.Highlight =
        nil

    Data.HighlightCharacter =
        nil
end

local function EnsureHighlight(
    Player,
    Character
)
    local Data =
        GetESPData(Player)

    if Data.Highlight
    and Data.Highlight.Parent
    and Data.HighlightCharacter == Character then
        return Data.Highlight
    end

    DestroyHighlight(Data)

    local Highlight =
        Instance.new("Highlight")

    Highlight.Name =
        "MirrorsHubESP"

    Highlight.Adornee =
        Character

    Highlight.DepthMode =
        Enum.HighlightDepthMode.AlwaysOnTop

    Highlight.FillTransparency =
        ESPSettings.HighlightFillTransparency

    Highlight.OutlineTransparency =
        ESPSettings.HighlightOutlineTransparency

    Highlight.Enabled =
        false

    Highlight.Parent =
        Character

    Data.Highlight =
        Highlight

    Data.HighlightCharacter =
        Character

    return Highlight
end

local function HideESPPlayer(Player)
    local Data =
        ESPObjects[Player]

    if not Data then
        return
    end

    if Data.Highlight then
        Data.Highlight.Enabled =
            false
    end

    HideDrawings(
        Data.Drawings
    )
end

local function DestroyESPPlayer(Player)
    local Data =
        ESPObjects[Player]

    if not Data then
        return
    end

    DestroyHighlight(Data)

    DestroyDrawings(
        Data.Drawings
    )

    ESPObjects[Player] =
        nil
end

local function DestroyAllESP()
    for Player in pairs(ESPObjects) do
        DestroyESPPlayer(Player)
    end
end

local function HideAllESP()
    for Player in pairs(ESPObjects) do
        HideESPPlayer(Player)
    end
end

local function GetESPCharacter(Player)
    if not Player
    or Player == LP then
        return
    end

    local Character =
        Player.Character

    if not Character then
        return
    end

    local Root =
        Character:FindFirstChild(
            "HumanoidRootPart"
        )

    local Humanoid =
        Character:FindFirstChildOfClass(
            "Humanoid"
        )

    if not Root
    or not Humanoid
    or Humanoid.Health <= 0 then
        return
    end

    return
        Character,
        Root,
        Humanoid
end

local function GetESPDistance(
    TargetRoot,
    Camera
)
    local MyRoot =
        LP.Character
        and LP.Character:FindFirstChild(
            "HumanoidRootPart"
        )

    if MyRoot then
        return
            (
                MyRoot.Position
                - TargetRoot.Position
            ).Magnitude
    end

    return
        (
            Camera.CFrame.Position
            - TargetRoot.Position
        ).Magnitude
end

local function GetCharacterScreenBounds(
    Character,
    Camera
)
    local Root =
        Character:FindFirstChild(
            "HumanoidRootPart"
        )

    if not Root then
        return
    end

    local RootScreen =
        Camera:WorldToViewportPoint(
            Root.Position
        )

    if RootScreen.Z <= 0.05 then
        return
    end

    local Success,
    BoundingCFrame,
    BoundingSize =
        pcall(function()
            local CF, Size =
                Character:GetBoundingBox()

            return CF, Size
        end)

    if not Success
    or not BoundingCFrame
    or not BoundingSize then
        return
    end

    local Center =
        BoundingCFrame.Position

    local HalfHeight =
        math.max(
            BoundingSize.Y * 0.5,
            2
        )

    local HalfWidth =
        math.max(
            BoundingSize.X,
            BoundingSize.Z
        ) * 0.52

    local CameraRight =
        Camera.CFrame.RightVector

    local Top =
        Camera:WorldToViewportPoint(
            Center
            + Vector3.new(
                0,
                HalfHeight + 0.12,
                0
            )
        )

    local Bottom =
        Camera:WorldToViewportPoint(
            Center
            - Vector3.new(
                0,
                HalfHeight + 0.05,
                0
            )
        )

    local Left =
        Camera:WorldToViewportPoint(
            Center
            - CameraRight * HalfWidth
        )

    local Right =
        Camera:WorldToViewportPoint(
            Center
            + CameraRight * HalfWidth
        )

    if Top.Z <= 0.05
    or Bottom.Z <= 0.05
    or Left.Z <= 0.05
    or Right.Z <= 0.05 then
        return
    end

    local MinX =
        math.min(
            Left.X,
            Right.X
        ) - 2

    local MaxX =
        math.max(
            Left.X,
            Right.X
        ) + 2

    local MinY =
        math.min(
            Top.Y,
            Bottom.Y
        ) - 2

    local MaxY =
        math.max(
            Top.Y,
            Bottom.Y
        ) + 2

    local Width =
        MaxX - MinX

    local Height =
        MaxY - MinY

    local Viewport =
        Camera.ViewportSize

    if Width < 4
    or Height < 8
    or Width > Viewport.X * 1.5
    or Height > Viewport.Y * 2.2 then
        return
    end

    local Margin = 90

    if MaxX < -Margin
    or MinX > Viewport.X + Margin
    or MaxY < -Margin
    or MinY > Viewport.Y + Margin then
        return
    end

    return
        MinX,
        MinY,
        MaxX,
        MaxY
end

local function GetTracerOrigin(Camera)
    local Viewport =
        Camera.ViewportSize

    if ESPSettings.TracerOrigin == "Center" then
        return Vector2.new(
            Viewport.X * 0.5,
            Viewport.Y * 0.5
        )
    end

    if ESPSettings.TracerOrigin == "Top" then
        return Vector2.new(
            Viewport.X * 0.5,
            0
        )
    end

    return Vector2.new(
        Viewport.X * 0.5,
        Viewport.Y
    )
end

local function GetESPDisplayName(Player)
    if Player.DisplayName
    and Player.DisplayName ~= "" then
        return Player.DisplayName
    end

    return Player.Name
end

local function UpdateHighlightESP(
    Player,
    Character,
    Role,
    Color
)
    local Data =
        GetESPData(Player)

    local UseHighlight =
        ESPSettings.Mode == "Highlight"
        or ESPSettings.Mode == "Both"

    if not UseHighlight then
        if Data.Highlight then
            Data.Highlight.Enabled =
                false
        end

        return
    end

    local Highlight =
        EnsureHighlight(
            Player,
            Character
        )

    if not Highlight then
        return
    end

    Highlight.FillColor =
        Color

    Highlight.OutlineColor =
        Color

    Highlight.FillTransparency =
        ESPSettings.HighlightFillTransparency

    Highlight.OutlineTransparency =
        ESPSettings.HighlightOutlineTransparency

    Highlight.Enabled =
        true
end

local function UpdateDrawingESP(
    Player,
    Character,
    Role,
    Color,
    Distance,
    Camera
)
    local Data =
        GetESPData(Player)

    local UseDrawing =
        ESPSettings.Mode == "Drawing"
        or ESPSettings.Mode == "Both"

    if not UseDrawing then
        HideDrawings(
            Data.Drawings
        )

        return
    end

    local Drawings =
        EnsureDrawings(Player)

    if not Drawings then
        return
    end

    local MinX,
    MinY,
    MaxX,
    MaxY =
        GetCharacterScreenBounds(
            Character,
            Camera
        )

    if not MinX then
        HideDrawings(Drawings)
        return
    end

    local Width =
        MaxX - MinX

    local Height =
        MaxY - MinY

    if Width <= 1
    or Height <= 1 then
        HideDrawings(Drawings)
        return
    end

    local CenterX =
        MinX + Width * 0.5

    local CenterY =
        MinY + Height * 0.5

    local TextSize =
        ESPSettings.TextSize

    local LineHeight =
        TextSize + 2

    Drawings.Box.Color =
        Color

    Drawings.Box.Thickness =
        ESPSettings.DrawingThickness

    Drawings.Box.Position =
        Vector2.new(
            MinX,
            MinY
        )

    Drawings.Box.Size =
        Vector2.new(
            Width,
            Height
        )

    Drawings.Box.Visible =
        ESPSettings.Box

    Drawings.Name.Color =
        Color3.fromRGB(
            248,
            248,
            252
        )

    Drawings.Name.Size =
        TextSize

    Drawings.Name.Text =
        GetESPDisplayName(
            Player
        )

    Drawings.Name.Position =
        Vector2.new(
            CenterX,
            MinY - LineHeight
        )

    Drawings.Name.Visible =
        ESPSettings.Name

    local BottomOffset =
        2

    Drawings.Role.Color =
        Color

    Drawings.Role.Size =
        TextSize

    Drawings.Role.Text =
        tostring(Role)

    Drawings.Role.Position =
        Vector2.new(
            CenterX,
            MaxY + BottomOffset
        )

    Drawings.Role.Visible =
        ESPSettings.Role

    if ESPSettings.Role then
        BottomOffset +=
            LineHeight
    end

    Drawings.Distance.Color =
        Color3.fromRGB(
            220,
            220,
            228
        )

    Drawings.Distance.Size =
        TextSize

    Drawings.Distance.Text =
        tostring(
            math.floor(
                Distance + 0.5
            )
        )
        .. " studs"

    Drawings.Distance.Position =
        Vector2.new(
            CenterX,
            MaxY + BottomOffset
        )

    Drawings.Distance.Visible =
        ESPSettings.Distance

    Drawings.Tracer.Color =
        Color

    Drawings.Tracer.Thickness =
        ESPSettings.DrawingThickness

    Drawings.Tracer.From =
        GetTracerOrigin(
            Camera
        )

    Drawings.Tracer.To =
        Vector2.new(
            CenterX,
            MaxY
        )

    Drawings.Tracer.Visible =
        ESPSettings.Tracer
end

local function UpdateESPPlayer(
    Player,
    Camera
)
    if Player == LP then
        return
    end

    local Character,
    Root =
        GetESPCharacter(Player)

    if not Character
    or not Root then
        HideESPPlayer(Player)
        return
    end

    local Role =
        GetRole(Player)

    if not IsESPRoleEnabled(Role) then
        HideESPPlayer(Player)
        return
    end

    local Distance =
        GetESPDistance(
            Root,
            Camera
        )

    if Distance
    > ESPSettings.MaxDistance then
        HideESPPlayer(Player)
        return
    end

    local Color =
        GetESPColor(Role)

    UpdateHighlightESP(
        Player,
        Character,
        Role,
        Color
    )

    UpdateDrawingESP(
        Player,
        Character,
        Role,
        Color,
        Distance,
        Camera
    )
end

local function UpdateESP()
    if not ESPSettings.Enabled then
        return
    end

    local Camera =
        Workspace.CurrentCamera

    if not Camera then
        return
    end

    for _, Player in ipairs(
        Players:GetPlayers()
    ) do
        if Player ~= LP then
            UpdateESPPlayer(
                Player,
                Camera
            )
        end
    end
end

local function RefreshESP()
    if not ESPSettings.Enabled then
        HideAllESP()
        return
    end

    UpdateESP()
end

local function SetESPEnabled(Value)
    ESPSettings.Enabled =
        Value

    if not Value then
        HideAllESP()
        return
    end

    RefreshESP()
end

Mirrors.TrackConnection(RunService.RenderStepped:Connect(function(DeltaTime)
    if not ESPSettings.Enabled then
        return
    end

    ESPAccumulator +=
        DeltaTime

    if ESPAccumulator
    < ESP_UPDATE_RATE then
        return
    end

    ESPAccumulator =
        ESPAccumulator % ESP_UPDATE_RATE

    UpdateESP()
end))

Mirrors.TrackConnection(Players.PlayerRemoving:Connect(function(Player)
    DestroyESPPlayer(Player)
end))

Mirrors.AddCleanup(function()
    ESPSettings.Enabled = false
    DestroyAllESP()
end)

SectionLine(EspTab, "Role ESP")
EspTab:Paragraph({
    Title = "MM2 Role ESP",
    Desc =
        "Murderer: Red"
        .. "\nSheriff / Hero: Blue"
        .. "\nInnocent: Green"
})

EspTab:Toggle({
    Title = "Enable ESP",
    Desc = "Enable player ESP",
    Value = false,

    Callback = function(Value)
        SetESPEnabled(Value)
    end
})

EspTab:Dropdown({
    Title = "ESP Mode",
    Desc = "Choose the ESP rendering mode",

    Values = {
        "Highlight",
        "Drawing",
        "Both"
    },

    Value = "Highlight",

    Callback = function(Value)
        Value =
            GetESPDropdownValue(
                Value
            )

        ESPSettings.Mode =
            Value
            or "Highlight"

        RefreshESP()
    end
})

SectionLine(EspTab, "Drawing")
EspTab:Toggle({
    Title = "Box",
    Desc = "Draw a box around players",
    Value = true,

    Callback = function(Value)
        ESPSettings.Box =
            Value

        RefreshESP()
    end
})

EspTab:Toggle({
    Title = "Name",
    Desc = "Show player names",
    Value = true,

    Callback = function(Value)
        ESPSettings.Name =
            Value

        RefreshESP()
    end
})

EspTab:Toggle({
    Title = "Role",
    Desc = "Show Murderer, Sheriff, Hero or Innocent",
    Value = true,

    Callback = function(Value)
        ESPSettings.Role =
            Value

        RefreshESP()
    end
})

EspTab:Toggle({
    Title = "Distance",
    Desc = "Show distance in studs",
    Value = true,

    Callback = function(Value)
        ESPSettings.Distance =
            Value

        RefreshESP()
    end
})

EspTab:Toggle({
    Title = "Tracer",
    Desc = "Draw a line to players",
    Value = false,

    Callback = function(Value)
        ESPSettings.Tracer =
            Value

        RefreshESP()
    end
})

EspTab:Dropdown({
    Title = "Tracer Origin",
    Desc = "Choose where tracers start",

    Values = {
        "Bottom",
        "Center",
        "Top"
    },

    Value = "Bottom",

    Callback = function(Value)
        Value =
            GetESPDropdownValue(
                Value
            )

        ESPSettings.TracerOrigin =
            Value
            or "Bottom"
    end
})

EspTab:Slider({
    Title = "Max Distance",
    Desc = "Maximum ESP render distance",

    Step = 50,

    Value = {
        Min = 50,
        Max = 2500,
        Default = 1000
    },

    Callback = function(Value)
        ESPSettings.MaxDistance =
            Value

        RefreshESP()
    end
})

EspTab:Slider({
    Title = "Drawing Thickness",
    Desc = "Box and tracer thickness",

    Step = 1,

    Value = {
        Min = 1,
        Max = 4,
        Default = 2
    },

    Callback = function(Value)
        ESPSettings.DrawingThickness =
            Value
    end
})

EspTab:Slider({
    Title = "Text Size",
    Desc = "Drawing ESP text size",

    Step = 1,

    Value = {
        Min = 10,
        Max = 20,
        Default = 13
    },

    Callback = function(Value)
        ESPSettings.TextSize =
            Value
    end
})

EspTab:Slider({
    Title = "Highlight Transparency",
    Desc = "Controls highlight fill transparency",

    Step = 5,

    Value = {
        Min = 0,
        Max = 100,
        Default = 70
    },

    Callback = function(Value)
        ESPSettings.HighlightFillTransparency =
            math.clamp(
                Value / 100,
                0,
                1
            )

        RefreshESP()
    end
})

SectionLine(EspTab, "Role Filters")
EspTab:Toggle({
    Title = "Murderer ESP",
    Desc = "Show Murderer players",
    Value = true,

    Callback = function(Value)
        ESPSettings.Murderer =
            Value

        RefreshESP()
    end
})

EspTab:Toggle({
    Title = "Sheriff ESP",
    Desc = "Show Sheriff and Hero players",
    Value = true,

    Callback = function(Value)
        ESPSettings.Sheriff =
            Value

        RefreshESP()
    end
})

EspTab:Toggle({
    Title = "Innocent ESP",
    Desc = "Show Innocent players",
    Value = true,

    Callback = function(Value)
        ESPSettings.Innocent =
            Value

        RefreshESP()
    end
})

--// ABA ESP TERMINADA \--

local MurderSettings = {
    KnifeAura = false,
    KnifeAuraRange = 15,

    ThrowAssist = false,

    AutoThrow = false,
    AutoThrowCooldown = 1.15,

    Prediction = 0.12,
    HitCooldown = 0.12
}

local function MurderConnect(Signal, Callback) return Mirrors.TrackConnection(Signal:Connect(Callback)) end

local MurderSelectedPlayer
local MurderPlayerDropdown

local MurderLastHit = {}
local MurderLastAutoThrow = 0
local MurderLastAssistThrow = 0

local MurderThrowButton
local MurderThrowConnection

local function GetMurderKnife()
    local Character = LP.Character
    if not Character then return end
    local Backpack = LP:FindFirstChild("Backpack")
    local Knife = Character:FindFirstChild("Knife") or (Backpack and Backpack:FindFirstChild("Knife"))
    if not Knife then
        for _, Container in ipairs({Character, Backpack}) do
            if Container then
                for _, Object in ipairs(Container:GetChildren()) do
                    if Object:IsA("Tool") and Object:GetAttribute("IsKnife") == true then Knife = Object; break end
                end
            end
            if Knife then break end
        end
    end
    if Knife and Knife:IsA("Tool") and Knife.Parent == Backpack then
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then pcall(function() Humanoid:EquipTool(Knife) end) end
    end
    if not Knife or not Knife:IsA("Tool") or Knife.Parent ~= Character then return end
    return Knife
end

local function GetMurderRemote(Name)
    local Knife = GetMurderKnife()

    if not Knife then
        return
    end

    local Events = Knife:FindFirstChild("Events")

    if not Events then
        return
    end

    local Remote = Events:FindFirstChild(Name)

    if Remote
    and Remote:IsA("RemoteEvent") then
        return Remote, Knife
    end
end

local function IsMurderPlayerAlive(Player)
    if not Player
    or Player == LP
    or not Player.Parent then
        return false
    end

    local Character = Player.Character

    if not Character then
        return false
    end

    local Humanoid =
        Character:FindFirstChildOfClass("Humanoid")

    if not Humanoid
    or Humanoid.Health <= 0 then
        return false
    end

    if Player:GetAttribute("Alive") == false then
        return false
    end

    return true
end

local function GetMurderTargetPart(Player)
    if not IsMurderPlayerAlive(Player) then
        return
    end

    local Character = Player.Character

    return
        Character:FindFirstChild("HumanoidRootPart")
        or Character:FindFirstChild("UpperTorso")
        or Character:FindFirstChild("Torso")
        or Character:FindFirstChild("Head")
end

local function RefreshMurderRoles()
    if typeof(UpdateRoles) == "function" then
        pcall(UpdateRoles, false)
    end
end

local function GetMurderSheriff()
    RefreshMurderRoles()

    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LP
        and IsMurderPlayerAlive(Player) then
            local Role = GetRole(Player)

            if Role == "Sheriff"
            or Role == "Hero" then
                return Player
            end
        end
    end
end

local function GetNearestMurderPlayer()
    local Character = LP.Character

    local Root =
        Character
        and Character:FindFirstChild("HumanoidRootPart")

    if not Root then
        return
    end

    local Best
    local BestDistance = math.huge

    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LP
        and IsMurderPlayerAlive(Player) then
            local Part =
                GetMurderTargetPart(Player)

            if Part then
                local Distance =
                    (
                        Root.Position
                        - Part.Position
                    ).Magnitude

                if Distance < BestDistance then
                    Best = Player
                    BestDistance = Distance
                end
            end
        end
    end

    return Best
end

local function GetMurderThrowTarget()
    local Sheriff = GetMurderSheriff()

    if Sheriff then
        return Sheriff
    end

    return GetNearestMurderPlayer()
end

local function MurderHitPlayer(Player, IgnoreCooldown)
    local Part =
        GetMurderTargetPart(Player)

    if not Part then
        return false
    end

    local Remote =
        GetMurderRemote("HandleTouched")

    if not Remote then
        return false
    end

    local Now = os.clock()

    if not IgnoreCooldown
    and MurderLastHit[Player]
    and Now - MurderLastHit[Player]
        < MurderSettings.HitCooldown then
        return false
    end

    MurderLastHit[Player] = Now

    local Success =
        pcall(function()
            Remote:FireServer(Part)
        end)

    return Success
end

local function MurderThrowPlayer(Player)
    local Part =
        GetMurderTargetPart(Player)

    if not Part then
        return false
    end

    local Remote, Knife =
        GetMurderRemote("KnifeThrown")

    if not Remote or not Knife then
        return false
    end

    local Handle =
        Knife:FindFirstChild("Handle")
        or Knife:FindFirstChildWhichIsA("BasePart")

    if not Handle then
        return false
    end

    local TargetPosition =
        Part.Position
        + Part.AssemblyLinearVelocity
        * MurderSettings.Prediction

    local Origin =
        Handle.Position

    local ThrowCFrame =
        CFrame.lookAt(
            Origin,
            TargetPosition
        )

    local Success =
        pcall(function()
            Remote:FireServer(
                ThrowCFrame,
                CFrame.new(TargetPosition)
            )
        end)

    return Success
end

local function MurderSilentThrow()
    local Target =
        GetMurderThrowTarget()

    if not Target then
        return false
    end

    return MurderThrowPlayer(Target)
end

local function KillSelectedMurderPlayer()
    if not MurderSelectedPlayer then
        return
    end

    MurderHitPlayer(
        MurderSelectedPlayer,
        true
    )
end

local function KillMurderSheriff()
    local Sheriff =
        GetMurderSheriff()

    if not Sheriff then
        return
    end

    MurderHitPlayer(
        Sheriff,
        true
    )
end

local function KillAllMurderInnocents()
    RefreshMurderRoles()

    task.spawn(function()
        for _, Player in ipairs(Players:GetPlayers()) do
            if not Mirrors.Runtime.Alive then break end
            if Player ~= LP
            and IsMurderPlayerAlive(Player)
            and GetRole(Player) == "Innocent" then
                MurderHitPlayer(
                    Player,
                    true
                )

                task.wait(0.05)
            end
        end
    end)
end

local function KillAllMurderPlayers()
    task.spawn(function()
        for _, Player in ipairs(Players:GetPlayers()) do
            if not Mirrors.Runtime.Alive then break end
            if Player ~= LP
            and IsMurderPlayerAlive(Player) then
                MurderHitPlayer(
                    Player,
                    true
                )

                task.wait(0.05)
            end
        end
    end)
end

local function FlingMurderSheriff()
    local Sheriff =
        GetMurderSheriff()

    if not Sheriff then
        return
    end

    FollowAndFlingPlayer(Sheriff)
end

local function GetMurderPlayerNames()
    local List = {}

    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LP then
            table.insert(
                List,
                Player.Name
            )
        end
    end

    table.sort(List)

    return List
end

local function GetMurderPlayerFromName(Name)
    if not Name then
        return
    end

    return Players:FindFirstChild(Name)
end

local function RefreshMurderPlayerDropdown()
    if not MurderPlayerDropdown then
        return
    end

    MurderPlayerDropdown:Refresh(
        GetMurderPlayerNames()
    )

    if MurderSelectedPlayer
    and not MurderSelectedPlayer.Parent then
        MurderSelectedPlayer = nil
    end
end

local function GetMurderThrowButton()
    local PlayerGui =
        LP:FindFirstChild("PlayerGui")

    if not PlayerGui then
        return
    end

    local Controls =
        PlayerGui:FindFirstChild(
            "GameplayControlsUI"
        )

    if not Controls then
        return
    end

    local Button =
        Controls:FindFirstChild(
            "Throw",
            true
        )

    if Button
    and Button:IsA("GuiButton") then
        return Button
    end
end

local function BindMurderThrowButton()
    local Button =
        GetMurderThrowButton()

    if Button == MurderThrowButton
    and MurderThrowConnection then
        return
    end

    if MurderThrowConnection then
        MurderThrowConnection:Disconnect()
        MurderThrowConnection = nil
    end

    MurderThrowButton = Button

    if not Button then
        return
    end

    MurderThrowConnection =
        MurderConnect(Button.MouseButton1Down, function()
            if not MurderSettings.ThrowAssist then
                return
            end

            local Now = os.clock()

            if Now - MurderLastAssistThrow < 0.15 then
                return
            end

            MurderLastAssistThrow = Now

            task.defer(
                MurderSilentThrow
            )
        end)
end

MurderConnect(RunService.Heartbeat, function()
    if MurderSettings.KnifeAura then
        local Character = LP.Character

        local Root =
            Character
            and Character:FindFirstChild(
                "HumanoidRootPart"
            )

        local Remote =
            GetMurderRemote(
                "HandleTouched"
            )

        if Root and Remote then
            for _, Player in ipairs(
                Players:GetPlayers()
            ) do
                if Player ~= LP
                and IsMurderPlayerAlive(Player) then
                    local Part =
                        GetMurderTargetPart(Player)

                    if Part then
                        local Distance =
                            (
                                Root.Position
                                - Part.Position
                            ).Magnitude

                        if Distance
                        <= MurderSettings.KnifeAuraRange then

                            local Now =
                                os.clock()

                            if not MurderLastHit[Player]
                            or Now
                                - MurderLastHit[Player]
                                >= MurderSettings.HitCooldown then

                                MurderLastHit[Player] =
                                    Now

                                pcall(function()
                                    Remote:FireServer(
                                        Part
                                    )
                                end)
                            end
                        end
                    end
                end
            end
        end
    end

    if MurderSettings.AutoThrow then
        local Now = os.clock()

        if Now - MurderLastAutoThrow
        >= MurderSettings.AutoThrowCooldown then

            if MurderSilentThrow() then
                MurderLastAutoThrow = Now
            end
        end
    end
end)

MurderConnect(Players.PlayerAdded, function()
    task.defer(
        RefreshMurderPlayerDropdown
    )
end)

MurderConnect(Players.PlayerRemoving, function(Player)
    MurderLastHit[Player] = nil

    if Player == MurderSelectedPlayer then
        MurderSelectedPlayer = nil
    end

    task.defer(
        RefreshMurderPlayerDropdown
    )
end)

MurderConnect(LP.CharacterAdded, function()
    table.clear(MurderLastHit)
    task.delay(1, function()
        if Mirrors.Runtime.Alive then BindMurderThrowButton() end
    end)
end)

MurderConnect(LP.CharacterRemoving, function()
    table.clear(MurderLastHit)

    MurderLastAutoThrow = 0
end)

local MurderPlayerGui =
    LP:WaitForChild("PlayerGui")

MurderConnect(MurderPlayerGui.DescendantAdded, function(Object)
    if Object.Name == "Throw"
    and Object:IsA("GuiButton") then
        task.defer(
            BindMurderThrowButton
        )
    end
end)

SectionLine(MurderTab, "Combat")
MurderTab:Toggle({
    Title = "Knife Aura",
    Desc = "Automatically kills players inside the selected range",
    Value = false,

    Callback = function(Value)
        MurderSettings.KnifeAura = Value

        if not Value then
            table.clear(MurderLastHit)
        end
    end
})

MurderTab:Slider({
    Title = "Knife Aura Range",
    Desc = "Maximum Knife Aura distance",
    Step = 1,

    Value = {
        Min = 2,
        Max = 50,
        Default = 15
    },

    Callback = function(Value)
        MurderSettings.KnifeAuraRange =
            math.clamp(
                Value,
                2,
                50
            )
    end
})

MurderTab:Toggle({
    Title = "Throw Assist",
    Desc = "Redirects knife throws to Sheriff/Hero or the nearest player",
    Value = false,

    Callback = function(Value)
        MurderSettings.ThrowAssist =
            Value

        if Value then
            BindMurderThrowButton()
        end
    end
})

MurderTab:Toggle({
    Title = "Auto Throw",
    Desc = "Automatically throws the knife at valid targets",
    Value = false,

    Callback = function(Value)
        MurderSettings.AutoThrow =
            Value

        MurderLastAutoThrow = 0
    end
})

SectionLine(MurderTab, "Target Actions")
MurderPlayerDropdown = MurderTab:Dropdown({
    Title = "Select Player",
    Desc = "Choose a player to kill",

    Values =
        GetMurderPlayerNames(),

    AllowNone = true,
    SearchBarEnabled = true,

    Callback = function(Value)
        if type(Value) == "table" then
            Value =
                Value.Value
                or Value.Title
                or Value[1]
        end

        MurderSelectedPlayer =
            GetMurderPlayerFromName(
                Value
            )
    end
})

MurderTab:Button({
    Title = "Kill Selected Player",
    Desc = "Kill the selected player",
    Icon = "skull",

    Callback = function()
        KillSelectedMurderPlayer()
    end
})

MurderTab:Button({
    Title = "Kill Sheriff",
    Desc = "Kill the current Sheriff or Hero",
    Icon = "crosshair",

    Callback = function()
        KillMurderSheriff()
    end
})

MurderTab:Button({
    Title = "Kill All Innocents",
    Desc = "Kill every alive Innocent",
    Icon = "users",

    Callback = function()
        KillAllMurderInnocents()
    end
})

MurderTab:Button({
    Title = "Kill All Players",
    Desc = "Kill every alive player",
    Icon = "skull",

    Callback = function()
        KillAllMurderPlayers()
    end
})

MurderTab:Button({
    Title = "Fling Sheriff",
    Desc = "Fling the current Sheriff or Hero",
    Icon = "zap",

    Callback = function()
        FlingMurderSheriff()
    end
})

BindMurderThrowButton()
Mirrors.AddCleanup(function()
    MurderSettings.KnifeAura=false; MurderSettings.ThrowAssist=false; MurderSettings.AutoThrow=false
    table.clear(MurderLastHit)
    if MurderThrowConnection then pcall(function() MurderThrowConnection:Disconnect() end); MurderThrowConnection=nil end
end)

local SheriffSettings = {
    AutoShoot = false,
    MurdererESP = false,
    GunDropESP = false,
    AutoEscape = false,

    AutoShootCooldown = 0.85,
    EscapeDistance = 5,
    EscapeCooldown = 1.2
}

local function SheriffConnect(Signal, Callback) return Mirrors.TrackConnection(Signal:Connect(Callback)) end

local SheriffMurderHighlight
local SheriffGunDropHighlight

local SheriffLastShot = 0
local SheriffLastEscape = 0
local SheriffLastRoleRefresh = 0
local SheriffLastSafeCFrame

local function GetSheriffGun()
    local Character = LP.Character
    local Backpack = LP:FindFirstChild("Backpack")
    local Gun = (Character and Character:FindFirstChild("Gun")) or (Backpack and Backpack:FindFirstChild("Gun"))
    if Gun and Gun:IsA("Tool") and Character and Gun.Parent == Backpack then
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then pcall(function() Humanoid:EquipTool(Gun) end) end
    end
    if not Gun or not Gun:IsA("Tool") or not Character or Gun.Parent ~= Character then return end
    return Gun
end

local function GetSheriffRoot()
    local Character = LP.Character

    if not Character then
        return
    end

    local Humanoid =
        Character:FindFirstChildOfClass("Humanoid")

    local Root =
        Character:FindFirstChild("HumanoidRootPart")

    if not Humanoid
    or not Root
    or Humanoid.Health <= 0 then
        return
    end

    return Root, Humanoid
end

local function IsSheriffPlayerAlive(Player)
    if not Player
    or Player == LP
    or not Player.Parent then
        return false
    end

    local Character = Player.Character

    if not Character then
        return false
    end

    local Humanoid =
        Character:FindFirstChildOfClass("Humanoid")

    if not Humanoid
    or Humanoid.Health <= 0 then
        return false
    end

    if Player:GetAttribute("Alive") == false then
        return false
    end

    return true
end

local function GetSheriffTargetPart(Player)
    if not IsSheriffPlayerAlive(Player) then
        return
    end

    local Character = Player.Character

    return
        Character:FindFirstChild("HumanoidRootPart")
        or Character:FindFirstChild("UpperTorso")
        or Character:FindFirstChild("Torso")
        or Character:FindFirstChild("Head")
end

local function RefreshSheriffRoles(Force)
    local Now = os.clock()

    if not Force
    and Now - SheriffLastRoleRefresh < 0.75 then
        return
    end

    SheriffLastRoleRefresh = Now

    pcall(UpdateRoles, Force == true)
end

local function GetSheriffMurderer()
    RefreshSheriffRoles(false)

    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LP
        and IsSheriffPlayerAlive(Player)
        and GetRole(Player) == "Murderer" then
            return Player
        end
    end
end

local function SheriffShootPlayer(Player)
    local Root =
        GetSheriffRoot()

    if not Root then
        return false
    end

    local Gun =
        GetSheriffGun()

    if not Gun then
        return false
    end

    local Shoot =
        Gun:FindFirstChild("Shoot")

    if not Shoot
    or not Shoot:IsA("RemoteEvent") then
        return false
    end

    local TargetPart =
        GetSheriffTargetPart(Player)

    if not TargetPart then
        return false
    end

    local Origin =
        Root.CFrame
        * CFrame.new(
            1.400390625,
            1.25,
            -3.4501953125
        )

    local Success =
        pcall(function()
            Shoot:FireServer(
                Origin,
                CFrame.new(
                    TargetPart.Position
                )
            )
        end)

    return Success
end

local function ShootSheriffMurderer()
    RefreshSheriffRoles(true)

    local Murderer =
        GetSheriffMurderer()

    if not Murderer then
        return false
    end

    return SheriffShootPlayer(
        Murderer
    )
end

local function UpdateSheriffMurdererESP()
    if not SheriffSettings.MurdererESP then
        if SheriffMurderHighlight then
            SheriffMurderHighlight:Destroy()
            SheriffMurderHighlight = nil
        end

        return
    end

    local Murderer =
        GetSheriffMurderer()

    local Character =
        Murderer
        and Murderer.Character

    if not Character then
        if SheriffMurderHighlight then
            SheriffMurderHighlight:Destroy()
            SheriffMurderHighlight = nil
        end

        return
    end

    if SheriffMurderHighlight
    and SheriffMurderHighlight.Adornee == Character
    and SheriffMurderHighlight.Parent then
        return
    end

    if SheriffMurderHighlight then
        SheriffMurderHighlight:Destroy()
        SheriffMurderHighlight = nil
    end

    local Highlight =
        Instance.new("Highlight")

    Highlight.Name =
        "MirrorsSheriffMurderESP"

    Highlight.Adornee =
        Character

    Highlight.DepthMode =
        Enum.HighlightDepthMode.AlwaysOnTop

    Highlight.FillColor =
        Color3.fromRGB(
            255,
            65,
            65
        )

    Highlight.OutlineColor =
        Color3.fromRGB(
            255,
            255,
            255
        )

    Highlight.FillTransparency =
        0.55

    Highlight.OutlineTransparency =
        0

    Highlight.Parent =
        Character

    SheriffMurderHighlight =
        Highlight
end

local function GetSheriffGunDrop()
    return Workspace:FindFirstChild(
        "GunDrop",
        true
    )
end

local function UpdateSheriffGunDropESP()
    if not SheriffSettings.GunDropESP then
        if SheriffGunDropHighlight then
            SheriffGunDropHighlight:Destroy()
            SheriffGunDropHighlight = nil
        end

        return
    end

    local GunDrop =
        GetSheriffGunDrop()

    if not GunDrop then
        if SheriffGunDropHighlight then
            SheriffGunDropHighlight:Destroy()
            SheriffGunDropHighlight = nil
        end

        return
    end

    if SheriffGunDropHighlight
    and SheriffGunDropHighlight.Adornee == GunDrop
    and SheriffGunDropHighlight.Parent then
        return
    end

    if SheriffGunDropHighlight then
        SheriffGunDropHighlight:Destroy()
        SheriffGunDropHighlight = nil
    end

    local Highlight =
        Instance.new("Highlight")

    Highlight.Name =
        "MirrorsSheriffGunDropESP"

    Highlight.Adornee =
        GunDrop

    Highlight.DepthMode =
        Enum.HighlightDepthMode.AlwaysOnTop

    Highlight.FillColor =
        Color3.fromRGB(
            255,
            210,
            60
        )

    Highlight.OutlineColor =
        Color3.fromRGB(
            255,
            255,
            255
        )

    Highlight.FillTransparency =
        0.35

    Highlight.OutlineTransparency =
        0

    Highlight.Parent =
        GunDrop

    SheriffGunDropHighlight =
        Highlight
end

local function UpdateSheriffSafePosition(
    Root,
    Humanoid,
    Murderer
)
    local MurderPart =
        GetSheriffTargetPart(Murderer)

    if not MurderPart then
        return
    end

    local Distance =
        (
            Root.Position
            - MurderPart.Position
        ).Magnitude

    if Distance < 18 then
        return
    end

    if Humanoid.FloorMaterial
    == Enum.Material.Air then
        return
    end

    SheriffLastSafeCFrame =
        Root.CFrame
end

local function FindSheriffEscapeCFrame(
    Root,
    Murderer
)
    local MurderPart =
        GetSheriffTargetPart(Murderer)

    if not MurderPart then
        return
    end

    if SheriffLastSafeCFrame then
        local SafeDistance =
            (
                SheriffLastSafeCFrame.Position
                - MurderPart.Position
            ).Magnitude

        if SafeDistance >= 15 then
            return SheriffLastSafeCFrame
        end
    end

    local Params =
        RaycastParams.new()

    Params.FilterType =
        Enum.RaycastFilterType.Exclude

    local Ignore = {}

    if LP.Character then
        table.insert(
            Ignore,
            LP.Character
        )
    end

    if Murderer.Character then
        table.insert(
            Ignore,
            Murderer.Character
        )
    end

    Params.FilterDescendantsInstances =
        Ignore

    local BestPosition
    local BestScore = -math.huge

    local Radii = {
        25,
        35,
        45
    }

    for _, Radius in ipairs(Radii) do
        for Index = 0, 15 do
            local Angle =
                math.rad(
                    Index * 22.5
                )

            local Offset =
                Vector3.new(
                    math.cos(Angle)
                    * Radius,
                    0,
                    math.sin(Angle)
                    * Radius
                )

            local Candidate =
                Root.Position
                + Offset

            local Result =
                Workspace:Raycast(
                    Candidate
                    + Vector3.new(
                        0,
                        25,
                        0
                    ),
                    Vector3.new(
                        0,
                        -60,
                        0
                    ),
                    Params
                )

            if Result
            and Result.Instance
            and Result.Instance.CanCollide then

                local Position =
                    Result.Position
                    + Vector3.new(
                        0,
                        3,
                        0
                    )

                local Score =
                    (
                        Position
                        - MurderPart.Position
                    ).Magnitude

                if Score > BestScore then
                    BestScore = Score
                    BestPosition = Position
                end
            end
        end
    end

    if BestPosition then
        return
            CFrame.new(
                BestPosition
            )
            * Root.CFrame.Rotation
    end
end

local function SheriffAutoEscape()
    if not SheriffSettings.AutoEscape then
        return
    end

    local Root, Humanoid =
        GetSheriffRoot()

    if not Root then
        return
    end

    local Murderer =
        GetSheriffMurderer()

    if not Murderer then
        return
    end

    local MurderPart =
        GetSheriffTargetPart(
            Murderer
        )

    if not MurderPart then
        return
    end

    UpdateSheriffSafePosition(
        Root,
        Humanoid,
        Murderer
    )

    local Distance =
        (
            Root.Position
            - MurderPart.Position
        ).Magnitude

    if Distance
    > SheriffSettings.EscapeDistance then
        return
    end

    local Now = os.clock()

    if Now - SheriffLastEscape
    < SheriffSettings.EscapeCooldown then
        return
    end

    local EscapeCFrame =
        FindSheriffEscapeCFrame(
            Root,
            Murderer
        )

    if not EscapeCFrame then
        return
    end

    SheriffLastEscape =
        Now

    Root.CFrame =
        EscapeCFrame

    ResetRootPhysics(
        Root
    )
end

local function FlingSheriffMurderer()
    RefreshSheriffRoles(true)

    local Murderer =
        GetSheriffMurderer()

    if not Murderer then
        return
    end

    FollowAndFlingPlayer(
        Murderer
    )
end

SheriffConnect(RunService.Heartbeat, function()
    local NeedsRoles = SheriffSettings.AutoShoot or SheriffSettings.MurdererESP or SheriffSettings.AutoEscape
    if NeedsRoles then RefreshSheriffRoles(false) end

    UpdateSheriffMurdererESP()
    UpdateSheriffGunDropESP()

    if SheriffSettings.AutoShoot then
        local Now =
            os.clock()

        if Now - SheriffLastShot
        >= SheriffSettings.AutoShootCooldown then

            local Murderer =
                GetSheriffMurderer()

            if Murderer
            and SheriffShootPlayer(
                Murderer
            ) then
                SheriffLastShot =
                    Now
            end
        end
    end

    SheriffAutoEscape()
end)

SheriffConnect(Players.PlayerRemoving, function(Player)
    if SheriffMurderHighlight
    and SheriffMurderHighlight.Adornee
    == Player.Character then

        SheriffMurderHighlight:Destroy()
        SheriffMurderHighlight = nil
    end
end)

SheriffConnect(LP.CharacterRemoving, function()
    SheriffLastSafeCFrame = nil
    SheriffLastShot = 0
    SheriffLastEscape = 0

    if SheriffMurderHighlight then
        SheriffMurderHighlight:Destroy()
        SheriffMurderHighlight = nil
    end
end)

SectionLine(SheriffTab, "Combat")
SheriffTab:Toggle({
    Title = "Auto Shoot Murderer",
    Desc = "Automatically shoots the current Murderer",
    Value = false,

    Callback = function(Value)
        SheriffSettings.AutoShoot =
            Value

        SheriffLastShot = 0
    end
})

SheriffTab:Button({
    Title = "Shoot Murderer",
    Desc = "Shoot the Murderer directly, even without aiming at them",
    Icon = "crosshair",

    Callback = function()
        ShootSheriffMurderer()
    end
})

SectionLine(SheriffTab, "Visuals")
SheriffTab:Toggle({
    Title = "Murderer ESP",
    Desc = "Highlights the current Murderer through walls",
    Value = false,

    Callback = function(Value)
        SheriffSettings.MurdererESP =
            Value

        if not Value
        and SheriffMurderHighlight then
            SheriffMurderHighlight:Destroy()
            SheriffMurderHighlight = nil
        end
    end
})

SheriffTab:Toggle({
    Title = "Gun Drop ESP",
    Desc = "Highlights the dropped gun",
    Value = false,

    Callback = function(Value)
        SheriffSettings.GunDropESP =
            Value

        if not Value
        and SheriffGunDropHighlight then
            SheriffGunDropHighlight:Destroy()
            SheriffGunDropHighlight = nil
        end
    end
})

SectionLine(SheriffTab, "Survival")
SheriffTab:Toggle({
    Title = "Auto Escape Murderer",
    Desc = "Teleports to a safer position when the Murderer gets within 5 studs",
    Value = false,

    Callback = function(Value)
        SheriffSettings.AutoEscape =
            Value

        SheriffLastEscape = 0

        if not Value then
            SheriffLastSafeCFrame =
                nil
        end
    end
})

SheriffTab:Button({
    Title = "Fling Murderer",
    Desc = "Fling the current Murderer",
    Icon = "zap",

    Callback = function()
        FlingSheriffMurderer()
    end
})

Mirrors.AddCleanup(function()
    SheriffSettings.AutoShoot=false; SheriffSettings.MurdererESP=false; SheriffSettings.GunDropESP=false; SheriffSettings.AutoEscape=false
    if SheriffMurderHighlight then pcall(function() SheriffMurderHighlight:Destroy() end); SheriffMurderHighlight=nil end
    if SheriffGunDropHighlight then pcall(function() SheriffGunDropHighlight:Destroy() end); SheriffGunDropHighlight=nil end
end)

local InnocentSettings = {
    AutoGun = false,
    GunDropESP = false,
    MurdererESP = false,
    SheriffESP = false,
    AutoEscape = false,

    EscapeDistance = 5,
    EscapeCooldown = 1.2,
    AutoGunCooldown = 1.5
}

local function InnocentConnect(Signal, Callback) return Mirrors.TrackConnection(Signal:Connect(Callback)) end

local InnocentGettingGun = false

local InnocentLastGunTry = 0
local InnocentLastEscape = 0
local InnocentLastRoleRefresh = 0

local InnocentLastSafeCFrame

local InnocentGunDropHighlight
local InnocentMurderHighlight
local InnocentSheriffHighlight

local function GetInnocentRoot()
    local Character = LP.Character

    if not Character then
        return
    end

    local Humanoid =
        Character:FindFirstChildOfClass("Humanoid")

    local Root =
        Character:FindFirstChild("HumanoidRootPart")

    if not Root
    or not Humanoid
    or Humanoid.Health <= 0 then
        return
    end

    return Root, Humanoid
end

local function HasInnocentGun()
    local Character = LP.Character
    local Backpack = LP:FindFirstChild("Backpack")

    return (
        Character
        and Character:FindFirstChild("Gun")
    ) ~= nil
    or (
        Backpack
        and Backpack:FindFirstChild("Gun")
    ) ~= nil
end

local function IsInnocentPlayerAlive(Player)
    if not Player
    or Player == LP
    or not Player.Parent then
        return false
    end

    local Character =
        Player.Character

    if not Character then
        return false
    end

    local Humanoid =
        Character:FindFirstChildOfClass("Humanoid")

    if not Humanoid
    or Humanoid.Health <= 0 then
        return false
    end

    if Player:GetAttribute("Alive") == false then
        return false
    end

    return true
end

local function GetInnocentTargetPart(Player)
    if not IsInnocentPlayerAlive(Player) then
        return
    end

    local Character =
        Player.Character

    return
        Character:FindFirstChild("HumanoidRootPart")
        or Character:FindFirstChild("UpperTorso")
        or Character:FindFirstChild("Torso")
        or Character:FindFirstChild("Head")
end

local function RefreshInnocentRoles(Force)
    local Now =
        os.clock()

    if not Force
    and Now - InnocentLastRoleRefresh < 0.75 then
        return
    end

    InnocentLastRoleRefresh =
        Now

    pcall(UpdateRoles, Force == true)
end

local function GetInnocentMurderer()
    RefreshInnocentRoles(false)

    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LP
        and IsInnocentPlayerAlive(Player)
        and GetRole(Player) == "Murderer" then
            return Player
        end
    end
end

local function GetInnocentSheriff()
    RefreshInnocentRoles(false)

    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LP
        and IsInnocentPlayerAlive(Player) then
            local Role =
                GetRole(Player)

            if Role == "Sheriff"
            or Role == "Hero" then
                return Player
            end
        end
    end
end

local function GetInnocentGunDrop()
    return Workspace:FindFirstChild(
        "GunDrop",
        true
    )
end

local function GetInnocentObjectCFrame(Object)
    if not Object
    or not Object.Parent then
        return
    end

    if Object:IsA("BasePart") then
        return Object.CFrame
    end

    if Object:IsA("Model") then
        return Object:GetPivot()
    end

    local Part =
        Object:FindFirstChildWhichIsA(
            "BasePart",
            true
        )

    return Part and Part.CFrame
end

local function TeleportInnocentGunDrop()
    local Root =
        GetInnocentRoot()

    local GunDrop =
        GetInnocentGunDrop()

    local GunCFrame =
        GetInnocentObjectCFrame(
            GunDrop
        )

    if not Root
    or not GunCFrame then
        return
    end

    Root.CFrame =
        CFrame.new(
            GunCFrame.Position
            + Vector3.new(
                0,
                2,
                0
            )
        )
        * Root.CFrame.Rotation

    ResetRootPhysics(
        Root
    )
end

local function GrabInnocentGun()
    if InnocentGettingGun
    or HasInnocentGun() then
        return
    end

    local Root =
        GetInnocentRoot()

    local GunDrop =
        GetInnocentGunDrop()

    local GunCFrame =
        GetInnocentObjectCFrame(
            GunDrop
        )

    if not Root
    or not GunCFrame then
        return
    end

    InnocentGettingGun =
        true

    local OriginalCFrame =
        Root.CFrame

    local Deadline =
        os.clock() + 1.6

    while Mirrors.Runtime.Alive
    and Root.Parent
    and not HasInnocentGun()
    and os.clock() < Deadline do
        local CurrentDrop =
            GetInnocentGunDrop()

        local CurrentCFrame =
            GetInnocentObjectCFrame(
                CurrentDrop
            )

        if not CurrentCFrame then
            break
        end

        Root.CFrame =
            CFrame.new(
                CurrentCFrame.Position
                + Vector3.new(
                    0,
                    1.5,
                    0
                )
            )
            * Root.CFrame.Rotation

        ResetRootPhysics(
            Root
        )

        task.wait(0.08)
    end

    task.wait(0.05)

    if Root.Parent then
        Root.CFrame =
            OriginalCFrame

        ResetRootPhysics(
            Root
        )
    end

    InnocentGettingGun =
        false
end

local function UpdateInnocentGunDropESP()
    if not InnocentSettings.GunDropESP then
        if InnocentGunDropHighlight then
            InnocentGunDropHighlight:Destroy()
            InnocentGunDropHighlight = nil
        end

        return
    end

    local GunDrop =
        GetInnocentGunDrop()

    if not GunDrop then
        if InnocentGunDropHighlight then
            InnocentGunDropHighlight:Destroy()
            InnocentGunDropHighlight = nil
        end

        return
    end

    if InnocentGunDropHighlight
    and InnocentGunDropHighlight.Parent
    and InnocentGunDropHighlight.Adornee == GunDrop then
        return
    end

    if InnocentGunDropHighlight then
        InnocentGunDropHighlight:Destroy()
    end

    local Highlight =
        Instance.new("Highlight")

    Highlight.Name =
        "MirrorsInnocentGunDropESP"

    Highlight.Adornee =
        GunDrop

    Highlight.DepthMode =
        Enum.HighlightDepthMode.AlwaysOnTop

    Highlight.FillColor =
        Color3.fromRGB(
            255,
            215,
            70
        )

    Highlight.OutlineColor =
        Color3.fromRGB(
            255,
            255,
            255
        )

    Highlight.FillTransparency =
        0.35

    Highlight.OutlineTransparency =
        0

    Highlight.Parent =
        GunDrop

    InnocentGunDropHighlight =
        Highlight
end

local function UpdateInnocentMurderESP()
    if not InnocentSettings.MurdererESP then
        if InnocentMurderHighlight then
            InnocentMurderHighlight:Destroy()
            InnocentMurderHighlight = nil
        end

        return
    end

    local Murderer =
        GetInnocentMurderer()

    local Character =
        Murderer
        and Murderer.Character

    if not Character then
        if InnocentMurderHighlight then
            InnocentMurderHighlight:Destroy()
            InnocentMurderHighlight = nil
        end

        return
    end

    if InnocentMurderHighlight
    and InnocentMurderHighlight.Parent
    and InnocentMurderHighlight.Adornee == Character then
        return
    end

    if InnocentMurderHighlight then
        InnocentMurderHighlight:Destroy()
    end

    local Highlight =
        Instance.new("Highlight")

    Highlight.Name =
        "MirrorsInnocentMurderESP"

    Highlight.Adornee =
        Character

    Highlight.DepthMode =
        Enum.HighlightDepthMode.AlwaysOnTop

    Highlight.FillColor =
        Color3.fromRGB(
            255,
            65,
            65
        )

    Highlight.OutlineColor =
        Color3.fromRGB(
            255,
            255,
            255
        )

    Highlight.FillTransparency =
        0.55

    Highlight.OutlineTransparency =
        0

    Highlight.Parent =
        Character

    InnocentMurderHighlight =
        Highlight
end

local function UpdateInnocentSheriffESP()
    if not InnocentSettings.SheriffESP then
        if InnocentSheriffHighlight then
            InnocentSheriffHighlight:Destroy()
            InnocentSheriffHighlight = nil
        end

        return
    end

    local Sheriff =
        GetInnocentSheriff()

    local Character =
        Sheriff
        and Sheriff.Character

    if not Character then
        if InnocentSheriffHighlight then
            InnocentSheriffHighlight:Destroy()
            InnocentSheriffHighlight = nil
        end

        return
    end

    if InnocentSheriffHighlight
    and InnocentSheriffHighlight.Parent
    and InnocentSheriffHighlight.Adornee == Character then
        return
    end

    if InnocentSheriffHighlight then
        InnocentSheriffHighlight:Destroy()
    end

    local Highlight =
        Instance.new("Highlight")

    Highlight.Name =
        "MirrorsInnocentSheriffESP"

    Highlight.Adornee =
        Character

    Highlight.DepthMode =
        Enum.HighlightDepthMode.AlwaysOnTop

    Highlight.FillColor =
        Color3.fromRGB(
            70,
            150,
            255
        )

    Highlight.OutlineColor =
        Color3.fromRGB(
            255,
            255,
            255
        )

    Highlight.FillTransparency =
        0.55

    Highlight.OutlineTransparency =
        0

    Highlight.Parent =
        Character

    InnocentSheriffHighlight =
        Highlight
end

local function UpdateInnocentSafePosition(
    Root,
    Humanoid,
    Murderer
)
    local MurderPart =
        GetInnocentTargetPart(
            Murderer
        )

    if not MurderPart then
        return
    end

    local Distance =
        (
            Root.Position
            - MurderPart.Position
        ).Magnitude

    if Distance < 18 then
        return
    end

    if Humanoid.FloorMaterial
    == Enum.Material.Air then
        return
    end

    InnocentLastSafeCFrame =
        Root.CFrame
end

local function FindInnocentEscapeCFrame(
    Root,
    Murderer
)
    local MurderPart =
        GetInnocentTargetPart(
            Murderer
        )

    if not MurderPart then
        return
    end

    if InnocentLastSafeCFrame then
        local Distance =
            (
                InnocentLastSafeCFrame.Position
                - MurderPart.Position
            ).Magnitude

        if Distance >= 15 then
            return InnocentLastSafeCFrame
        end
    end

    local Params =
        RaycastParams.new()

    Params.FilterType =
        Enum.RaycastFilterType.Exclude

    local Ignore = {}

    if LP.Character then
        table.insert(
            Ignore,
            LP.Character
        )
    end

    if Murderer.Character then
        table.insert(
            Ignore,
            Murderer.Character
        )
    end

    Params.FilterDescendantsInstances =
        Ignore

    local BestPosition
    local BestScore = -math.huge

    local Radii = {
        25,
        35,
        45
    }

    for _, Radius in ipairs(Radii) do
        for Index = 0, 15 do
            local Angle =
                math.rad(
                    Index * 22.5
                )

            local Candidate =
                Root.Position
                + Vector3.new(
                    math.cos(Angle)
                    * Radius,
                    0,
                    math.sin(Angle)
                    * Radius
                )

            local Result =
                Workspace:Raycast(
                    Candidate
                    + Vector3.new(
                        0,
                        25,
                        0
                    ),
                    Vector3.new(
                        0,
                        -60,
                        0
                    ),
                    Params
                )

            if Result
            and Result.Instance
            and Result.Instance.CanCollide then
                local Position =
                    Result.Position
                    + Vector3.new(
                        0,
                        3,
                        0
                    )

                local Score =
                    (
                        Position
                        - MurderPart.Position
                    ).Magnitude

                if Score > BestScore then
                    BestScore =
                        Score

                    BestPosition =
                        Position
                end
            end
        end
    end

    if BestPosition then
        return
            CFrame.new(
                BestPosition
            )
            * Root.CFrame.Rotation
    end
end

local function InnocentAutoEscape()
    if not InnocentSettings.AutoEscape
    or InnocentGettingGun then
        return
    end

    local Root, Humanoid =
        GetInnocentRoot()

    if not Root then
        return
    end

    local Murderer =
        GetInnocentMurderer()

    if not Murderer then
        return
    end

    local MurderPart =
        GetInnocentTargetPart(
            Murderer
        )

    if not MurderPart then
        return
    end

    UpdateInnocentSafePosition(
        Root,
        Humanoid,
        Murderer
    )

    local Distance =
        (
            Root.Position
            - MurderPart.Position
        ).Magnitude

    if Distance
    > InnocentSettings.EscapeDistance then
        return
    end

    local Now =
        os.clock()

    if Now - InnocentLastEscape
    < InnocentSettings.EscapeCooldown then
        return
    end

    local EscapeCFrame =
        FindInnocentEscapeCFrame(
            Root,
            Murderer
        )

    if not EscapeCFrame then
        return
    end

    InnocentLastEscape =
        Now

    Root.CFrame =
        EscapeCFrame

    ResetRootPhysics(
        Root
    )
end

local function TeleportInnocentSheriff()
    RefreshInnocentRoles(true)

    local Sheriff =
        GetInnocentSheriff()

    local TargetRoot =
        Sheriff
        and GetInnocentTargetPart(
            Sheriff
        )

    local Root =
        GetInnocentRoot()

    if not Sheriff
    or not TargetRoot
    or not Root then
        return
    end

    Root.CFrame =
        TargetRoot.CFrame
        * CFrame.new(
            0,
            0,
            3
        )

    ResetRootPhysics(
        Root
    )
end

local function FlingInnocentMurderer()
    RefreshInnocentRoles(true)

    local Murderer =
        GetInnocentMurderer()

    if not Murderer then
        return
    end

    FollowAndFlingPlayer(
        Murderer
    )
end

local function FlingInnocentSheriff()
    RefreshInnocentRoles(true)

    local Sheriff =
        GetInnocentSheriff()

    if not Sheriff then
        return
    end

    FollowAndFlingPlayer(
        Sheriff
    )
end

InnocentConnect(RunService.Heartbeat, function()
    UpdateInnocentGunDropESP()
    UpdateInnocentMurderESP()
    UpdateInnocentSheriffESP()

    if InnocentSettings.AutoGun
    and not InnocentGettingGun
    and not HasInnocentGun() then
        local GunDrop =
            GetInnocentGunDrop()

        local Now =
            os.clock()

        if GunDrop
        and Now - InnocentLastGunTry
        >= InnocentSettings.AutoGunCooldown then

            InnocentLastGunTry =
                Now

            task.spawn(
                GrabInnocentGun
            )
        end
    end

    InnocentAutoEscape()
end)

InnocentConnect(Players.PlayerRemoving, function(Player)
    if InnocentMurderHighlight
    and InnocentMurderHighlight.Adornee
    == Player.Character then
        InnocentMurderHighlight:Destroy()
        InnocentMurderHighlight = nil
    end

    if InnocentSheriffHighlight
    and InnocentSheriffHighlight.Adornee
    == Player.Character then
        InnocentSheriffHighlight:Destroy()
        InnocentSheriffHighlight = nil
    end
end)

InnocentConnect(LP.CharacterRemoving, function()
    InnocentGettingGun =
        false

    InnocentLastSafeCFrame =
        nil

    InnocentLastEscape =
        0

    InnocentLastGunTry =
        0

    if InnocentMurderHighlight then
        InnocentMurderHighlight:Destroy()
        InnocentMurderHighlight = nil
    end

    if InnocentSheriffHighlight then
        InnocentSheriffHighlight:Destroy()
        InnocentSheriffHighlight = nil
    end
end)

SectionLine(InnocentTab, "Gun")
InnocentTab:Toggle({
    Title = "Auto Gun",
    Desc = "Automatically grabs the dropped gun and returns to your previous position",
    Value = false,

    Callback = function(Value)
        InnocentSettings.AutoGun =
            Value

        InnocentLastGunTry =
            0
    end
})

InnocentTab:Button({
    Title = "Teleport Gun Drop",
    Desc = "Teleport directly to the dropped gun",
    Icon = "zap",

    Callback = function()
        TeleportInnocentGunDrop()
    end
})

SectionLine(InnocentTab, "Visuals")
InnocentTab:Toggle({
    Title = "Gun Drop ESP",
    Desc = "Highlights the dropped gun through walls",
    Value = false,

    Callback = function(Value)
        InnocentSettings.GunDropESP =
            Value

        if not Value
        and InnocentGunDropHighlight then
            InnocentGunDropHighlight:Destroy()
            InnocentGunDropHighlight = nil
        end
    end
})

InnocentTab:Toggle({
    Title = "Murderer ESP",
    Desc = "Highlights the current Murderer",
    Value = false,

    Callback = function(Value)
        InnocentSettings.MurdererESP =
            Value

        if not Value
        and InnocentMurderHighlight then
            InnocentMurderHighlight:Destroy()
            InnocentMurderHighlight = nil
        end
    end
})

InnocentTab:Toggle({
    Title = "Sheriff ESP",
    Desc = "Highlights the current Sheriff or Hero",
    Value = false,

    Callback = function(Value)
        InnocentSettings.SheriffESP =
            Value

        if not Value
        and InnocentSheriffHighlight then
            InnocentSheriffHighlight:Destroy()
            InnocentSheriffHighlight = nil
        end
    end
})

SectionLine(InnocentTab, "Survival")
InnocentTab:Toggle({
    Title = "Auto Escape Murderer",
    Desc = "Teleports to a safer position when the Murderer gets within 5 studs",
    Value = false,

    Callback = function(Value)
        InnocentSettings.AutoEscape =
            Value

        InnocentLastEscape =
            0

        if not Value then
            InnocentLastSafeCFrame =
                nil
        end
    end
})

InnocentTab:Button({
    Title = "Fling Murderer",
    Desc = "Fling the current Murderer",
    Icon = "zap",

    Callback = function()
        FlingInnocentMurderer()
    end
})

InnocentTab:Button({
    Title = "Teleport Sheriff",
    Desc = "Teleport to the current Sheriff or Hero",
    Icon = "map-pin",

    Callback = function()
        TeleportInnocentSheriff()
    end
})

InnocentTab:Button({
    Title = "Fling Sheriff",
    Desc = "Fling the current Sheriff or Hero",
    Icon = "zap",

    Callback = function()
        FlingInnocentSheriff()
    end
})

Mirrors.AddCleanup(function()
    InnocentSettings.AutoGun=false; InnocentSettings.GunDropESP=false; InnocentSettings.MurdererESP=false; InnocentSettings.SheriffESP=false; InnocentSettings.AutoEscape=false
    InnocentGettingGun=false
    for _, H in ipairs({InnocentGunDropHighlight, InnocentMurderHighlight, InnocentSheriffHighlight}) do if H then pcall(function() H:Destroy() end) end end
    InnocentGunDropHighlight, InnocentMurderHighlight, InnocentSheriffHighlight=nil,nil,nil
end)

task.spawn(function()

local UserInputService = game:GetService("UserInputService")

local GlobalEnv = getgenv and getgenv() or _G
        
if GlobalEnv.MirrorsMM2ShortcutsCleanup then
    pcall(GlobalEnv.MirrorsMM2ShortcutsCleanup)
end

local ShortcutConnections = {}
local ShortcutButtons = {}

local ShortcutDestroyed = false
local ShortcutRoleUpdate = 0

local ShortcutFlingMode = nil
local ShortcutFlingSession = 0

local ShortcutCooldown = {
    ShootMurder = false,
    ThrowKnife = false
}

local SHORTCUT_COOLDOWN = 3
local SHORTCUT_PREDICTION = 0.12

local function ShortcutConnect(Signal, Callback)
    local Connection = Signal:Connect(Callback)

    table.insert(
        ShortcutConnections,
        Connection
    )

    return Connection
end

local function ShortcutNotify(Title, Content)
    Mirrors.Notify(Title, Content, "solar:info-square-bold", 3)
end

local function ShortcutGetCharacter()
    local Character = LP.Character

    if not Character then
        return
    end

    local Humanoid =
        Character:FindFirstChildOfClass("Humanoid")

    local Root =
        Character:FindFirstChild("HumanoidRootPart")

    if not Humanoid
    or not Root
    or Humanoid.Health <= 0 then
        return
    end

    return Character, Humanoid, Root
end

local function ShortcutAlive(Player)
    if not Player
    or Player == LP
    or not Player.Parent then
        return false
    end

    local Character =
        Player.Character

    if not Character then
        return false
    end

    local Humanoid =
        Character:FindFirstChildOfClass("Humanoid")

    if not Humanoid
    or Humanoid.Health <= 0 then
        return false
    end

    if Player:GetAttribute("Alive") == false then
        return false
    end

    return true
end

local function ShortcutGetTargetPart(Player)
    if not ShortcutAlive(Player) then
        return
    end

    local Character =
        Player.Character

    return
        Character:FindFirstChild("HumanoidRootPart")
        or Character:FindFirstChild("UpperTorso")
        or Character:FindFirstChild("Torso")
        or Character:FindFirstChild("Head")
end

local function ShortcutRefreshRoles(Force)
    local Now =
        os.clock()

    if not Force
    and Now - ShortcutRoleUpdate < 0.7 then
        return
    end

    ShortcutRoleUpdate =
        Now

    pcall(UpdateRoles, Force == true)
end

local function ShortcutGetMurderer(Force)
    ShortcutRefreshRoles(
        Force == true
    )

    for _, Player in ipairs(
        Players:GetPlayers()
    ) do
        if Player ~= LP
        and ShortcutAlive(Player)
        and GetRole(Player) == "Murderer" then
            return Player
        end
    end
end

local function ShortcutGetSheriff(Force)
    ShortcutRefreshRoles(
        Force == true
    )

    for _, Player in ipairs(
        Players:GetPlayers()
    ) do
        if Player ~= LP
        and ShortcutAlive(Player) then

            local Role =
                GetRole(Player)

            if Role == "Sheriff"
            or Role == "Hero" then
                return Player
            end
        end
    end
end

local function ShortcutGetAlivePlayers()
    local Result = {}

    for _, Player in ipairs(
        Players:GetPlayers()
    ) do
        if Player ~= LP
        and ShortcutAlive(Player) then

            table.insert(
                Result,
                Player
            )
        end
    end

    return Result
end

local function ShortcutEquipTool(Name)
    local Character, Humanoid =
        ShortcutGetCharacter()

    if not Character
    or not Humanoid then
        return
    end

    local Equipped =
        Character:FindFirstChild(Name)

    if Equipped
    and Equipped:IsA("Tool") then
        return Equipped
    end

    local Backpack =
        LP:FindFirstChild("Backpack")

    local Tool =
        Backpack
        and Backpack:FindFirstChild(Name)

    if not Tool
    or not Tool:IsA("Tool") then
        return
    end

    pcall(function()
        Humanoid:EquipTool(
            Tool
        )
    end)

    local Deadline =
        os.clock() + 0.6

    repeat
        task.wait()

        Equipped =
            Character:FindFirstChild(Name)

    until Equipped
    or os.clock() >= Deadline

    return Equipped
end

local function ShortcutGetGun()
    local Gun =
        ShortcutEquipTool("Gun")

    if not Gun then
        ShortcutNotify(
            "Missing Gun",
            "You don't have the Gun."
        )

        return
    end

    return Gun
end

local function ShortcutGetKnife()
    local Knife =
        ShortcutEquipTool("Knife")

    if not Knife then
        ShortcutNotify(
            "Missing Knife",
            "You don't have the Knife."
        )

        return
    end

    return Knife
end

local function ShortcutGetGunDrop()
    return Workspace:FindFirstChild(
        "GunDrop",
        true
    )
end

local function ShortcutGetObjectCFrame(Object)
    if not Object
    or not Object.Parent then
        return
    end

    if Object:IsA("BasePart") then
        return Object.CFrame
    end

    if Object:IsA("Model") then
        return Object:GetPivot()
    end

    local Part =
        Object:FindFirstChildWhichIsA(
            "BasePart",
            true
        )

    return Part and Part.CFrame
end

local function ShortcutShootMurder()
    local Murderer =
        ShortcutGetMurderer(true)

    if not Murderer then
        ShortcutNotify(
            "No Murderer",
            "No Murderer was found."
        )

        return false
    end

    local Gun =
        ShortcutGetGun()

    if not Gun then
        return false
    end

    local Character, _, Root =
        ShortcutGetCharacter()

    local TargetPart =
        ShortcutGetTargetPart(
            Murderer
        )

    if not Character
    or not Root
    or not TargetPart then
        ShortcutNotify(
            "Shoot Failed",
            "The Murderer is not a valid target."
        )

        return false
    end

    local Shoot =
        Gun:FindFirstChild("Shoot")

    if not Shoot
    or not Shoot:IsA("RemoteEvent") then
        ShortcutNotify(
            "Shoot Failed",
            "Gun Shoot remote was not found."
        )

        return false
    end

    local Success =
        pcall(function()
            Shoot:FireServer(
                Root.CFrame
                * CFrame.new(
                    1.400390625,
                    1.25,
                    -3.4501953125
                ),
                CFrame.new(
                    TargetPart.Position
                )
            )
        end)

    if not Success then
        ShortcutNotify(
            "Shoot Failed",
            "Could not shoot the Murderer."
        )

        return false
    end

    return true
end

local function ShortcutTPGun()
    local _, _, Root =
        ShortcutGetCharacter()

    if not Root then
        return
    end

    local GunDrop =
        ShortcutGetGunDrop()

    local GunCFrame =
        ShortcutGetObjectCFrame(
            GunDrop
        )

    if not GunCFrame then
        ShortcutNotify(
            "Gun Drop",
            "No dropped Gun was found."
        )

        return
    end

    Root.CFrame =
        CFrame.new(
            GunCFrame.Position
            + Vector3.new(
                0,
                2,
                0
            )
        )
        * Root.CFrame.Rotation

    ResetRootPhysics(
        Root
    )
end

local function ShortcutTPMurder()
    local Murderer =
        ShortcutGetMurderer(true)

    if not Murderer then
        ShortcutNotify(
            "No Murderer",
            "No Murderer was found."
        )

        return
    end

    local TargetRoot =
        ShortcutGetTargetPart(
            Murderer
        )

    local _, _, Root =
        ShortcutGetCharacter()

    if not TargetRoot
    or not Root then
        return
    end

    Root.CFrame =
        TargetRoot.CFrame
        * CFrame.new(
            0,
            0,
            3
        )

    ResetRootPhysics(
        Root
    )
end

local function ShortcutTPSheriff()
    local Sheriff =
        ShortcutGetSheriff(true)

    if not Sheriff then
        ShortcutNotify(
            "No Sheriff",
            "No Sheriff or Hero was found."
        )

        return
    end

    local TargetRoot =
        ShortcutGetTargetPart(
            Sheriff
        )

    local _, _, Root =
        ShortcutGetCharacter()

    if not TargetRoot
    or not Root then
        return
    end

    Root.CFrame =
        TargetRoot.CFrame
        * CFrame.new(
            0,
            0,
            3
        )

    ResetRootPhysics(
        Root
    )
end

local function ShortcutThrowKnife()
    local Knife =
        ShortcutGetKnife()

    if not Knife then
        return false
    end

    local Events =
        Knife:FindFirstChild("Events")

    local Remote =
        Events
        and Events:FindFirstChild(
            "KnifeThrown"
        )

    if not Remote
    or not Remote:IsA("RemoteEvent") then
        ShortcutNotify(
            "Throw Failed",
            "KnifeThrown remote was not found."
        )

        return false
    end

    local Handle =
        Knife:FindFirstChild("Handle")
        or Knife:FindFirstChildWhichIsA(
            "BasePart"
        )

    if not Handle then
        ShortcutNotify(
            "Throw Failed",
            "Knife Handle was not found."
        )

        return false
    end

    ShortcutRefreshRoles(true)

    local Target =
        ShortcutGetSheriff(false)

    if not Target then
        local Character =
            LP.Character

        local Root =
            Character
            and Character:FindFirstChild(
                "HumanoidRootPart"
            )

        if Root then
            local BestDistance =
                math.huge

            for _, Player in ipairs(
                Players:GetPlayers()
            ) do
                if Player ~= LP
                and ShortcutAlive(Player) then

                    local Part =
                        ShortcutGetTargetPart(
                            Player
                        )

                    if Part then
                        local Distance =
                            (
                                Root.Position
                                - Part.Position
                            ).Magnitude

                        if Distance
                        < BestDistance then

                            BestDistance =
                                Distance

                            Target =
                                Player
                        end
                    end
                end
            end
        end
    end

    local TargetPart =
        Target
        and ShortcutGetTargetPart(
            Target
        )

    if not TargetPart then
        ShortcutNotify(
            "No Target",
            "No valid Knife target was found."
        )

        return false
    end

    local TargetPosition =
        TargetPart.Position
        + TargetPart.AssemblyLinearVelocity
        * SHORTCUT_PREDICTION

    local ThrowCFrame =
        CFrame.lookAt(
            Handle.Position,
            TargetPosition
        )

    local Success =
        pcall(function()
            Remote:FireServer(
                ThrowCFrame,
                CFrame.new(
                    TargetPosition
                )
            )
        end)

    if not Success then
        ShortcutNotify(
            "Throw Failed",
            "Could not throw the Knife."
        )

        return false
    end

    return true
end

local function ShortcutGetKnifeTouchRemote()
    local Knife =
        ShortcutGetKnife()

    if not Knife then
        return
    end

    local Events =
        Knife:FindFirstChild("Events")

    local Remote =
        Events
        and Events:FindFirstChild(
            "HandleTouched"
        )

    if not Remote
    or not Remote:IsA("RemoteEvent") then
        ShortcutNotify(
            "Knife Failed",
            "HandleTouched remote was not found."
        )

        return
    end

    return Remote
end

local function ShortcutKillSheriff()
    local Sheriff =
        ShortcutGetSheriff(true)

    if not Sheriff then
        ShortcutNotify(
            "No Sheriff",
            "No Sheriff or Hero was found."
        )

        return
    end

    local Remote =
        ShortcutGetKnifeTouchRemote()

    if not Remote then
        return
    end

    local TargetPart =
        ShortcutGetTargetPart(
            Sheriff
        )

    if not TargetPart then
        ShortcutNotify(
            "Kill Failed",
            "Sheriff is not a valid target."
        )

        return
    end

    pcall(function()
        Remote:FireServer(
            TargetPart
        )
    end)
end

local function ShortcutKillAll()
    local Targets =
        ShortcutGetAlivePlayers()

    if #Targets == 0 then
        ShortcutNotify(
            "No Targets",
            "No alive players were found."
        )

        return
    end

    local Remote =
        ShortcutGetKnifeTouchRemote()

    if not Remote then
        return
    end

    task.spawn(function()
        for _, Player in ipairs(Targets) do
            if ShortcutDestroyed then break end
            if ShortcutAlive(Player) then
                local Part =
                    ShortcutGetTargetPart(
                        Player
                    )

                if Part then
                    pcall(function()
                        Remote:FireServer(
                            Part
                        )
                    end)

                    task.wait(0.04)
                end
            end
        end
    end)
end

local function ShortcutStopFlingEngine()
    FollowActive = false
    FollowSession += 1

    if FollowConnection then
        FollowConnection:Disconnect()
        FollowConnection = nil
    end

    TouchFlingEnabled = false
    TouchFlingSession += 1

    FlingAllActive = false
    FlingAllSession += 1

    local Character =
        LP.Character

    local Root =
        Character
        and Character:FindFirstChild(
            "HumanoidRootPart"
        )

    if Root then
        ResetRootPhysics(
            Root
        )
    end
end

local function ShortcutUpdateFlingVisuals()
    local Map = {
        FlingMurder = "MURDER",
        FlingSheriff = "SHERIFF",
        FlingAll = "ALL"
    }

    for Name, Mode in pairs(Map) do
        local Object =
            ShortcutButtons[Name]

        if Object then
            if ShortcutFlingMode == Mode then
                Object:SetStatus(
                    "ON",
                    Color3.fromRGB(
                        220,
                        145,
                        255
                    )
                )
            else
                Object:SetStatus(
                    "OFF",
                    Color3.fromRGB(
                        165,
                        150,
                        175
                    )
                )
            end
        end
    end
end

local function ShortcutStopCurrentFling()
    ShortcutFlingSession += 1
    ShortcutFlingMode = nil

    ShortcutStopFlingEngine()
    ShortcutUpdateFlingVisuals()
end

local function ShortcutStartRoleFling(
    Mode,
    InitialTarget
)
    ShortcutFlingSession += 1

    local Session =
        ShortcutFlingSession

    ShortcutFlingMode =
        Mode

    ShortcutUpdateFlingVisuals()

    task.spawn(function()
        local CurrentTarget =
            nil

        while not ShortcutDestroyed
        and ShortcutFlingMode == Mode
        and ShortcutFlingSession == Session do

            ShortcutRefreshRoles(false)

            local Target

            if Mode == "MURDER" then
                Target =
                    ShortcutGetMurderer(false)
            else
                Target =
                    ShortcutGetSheriff(false)
            end

            if Target ~= CurrentTarget then
                ShortcutStopFlingEngine()

                CurrentTarget =
                    Target

                if Target then
                    FollowAndFlingPlayer(
                        Target
                    )
                end
            end

            task.wait(0.25)
        end

        if ShortcutFlingSession == Session then
            ShortcutStopFlingEngine()
        end
    end)
end

local function ShortcutStartFlingAll()
    ShortcutFlingSession += 1

    local Session =
        ShortcutFlingSession

    ShortcutFlingMode =
        "ALL"

    ShortcutUpdateFlingVisuals()

    task.spawn(function()
        while not ShortcutDestroyed
        and ShortcutFlingMode == "ALL"
        and ShortcutFlingSession == Session do

            local Targets =
                ShortcutGetAlivePlayers()

            if #Targets == 0 then
                task.wait(0.5)
                continue
            end

            for _, Player in ipairs(Targets) do
                if ShortcutDestroyed
                or ShortcutFlingMode ~= "ALL"
                or ShortcutFlingSession ~= Session then
                    break
                end

                if ShortcutAlive(Player) then
                    ShortcutStopFlingEngine()

                    FollowAndFlingPlayer(
                        Player
                    )

                    local Finish =
                        os.clock() + 1.35

                    repeat
                        task.wait(0.08)

                    until os.clock() >= Finish
                    or ShortcutDestroyed
                    or ShortcutFlingMode ~= "ALL"
                    or ShortcutFlingSession ~= Session
                    or not ShortcutAlive(Player)
                end
            end

            task.wait(0.1)
        end

        if ShortcutFlingSession == Session then
            ShortcutStopFlingEngine()
        end
    end)
end

local function ShortcutToggleFling(Mode)
    if ShortcutFlingMode == Mode then
        ShortcutStopCurrentFling()
        return
    end

    if Mode == "MURDER" then
        local Murderer =
            ShortcutGetMurderer(true)

        if not Murderer then
            ShortcutNotify(
                "No Murderer",
                "No Murderer was found."
            )

            return
        end

        ShortcutStopCurrentFling()

        ShortcutStartRoleFling(
            "MURDER",
            Murderer
        )

        return
    end

    if Mode == "SHERIFF" then
        local Sheriff =
            ShortcutGetSheriff(true)

        if not Sheriff then
            ShortcutNotify(
                "No Sheriff",
                "No Sheriff or Hero was found."
            )

            return
        end

        ShortcutStopCurrentFling()

        ShortcutStartRoleFling(
            "SHERIFF",
            Sheriff
        )

        return
    end

    if Mode == "ALL" then
        local Targets =
            ShortcutGetAlivePlayers()

        if #Targets == 0 then
            ShortcutNotify(
                "No Targets",
                "No alive players were found."
            )

            return
        end

        ShortcutStopCurrentFling()
        ShortcutStartFlingAll()
    end
end

local PlayerGui =
    LP:WaitForChild("PlayerGui")

local OldGui =
    PlayerGui:FindFirstChild(
        "MirrorsShortcutsGUI"
    )

if OldGui then
    OldGui:Destroy()
end

local ShortcutsGui =
    Instance.new("ScreenGui")

ShortcutsGui.Name =
    "MirrorsShortcutsGUI"

ShortcutsGui.ResetOnSpawn =
    false

ShortcutsGui.IgnoreGuiInset =
    true

ShortcutsGui.ZIndexBehavior =
    Enum.ZIndexBehavior.Sibling

ShortcutsGui.Parent =
    PlayerGui

local ShortcutPositions = {
    UDim2.fromOffset(60, 160),
    UDim2.fromOffset(152, 160),
    UDim2.fromOffset(244, 160),

    UDim2.fromOffset(60, 252),
    UDim2.fromOffset(152, 252),
    UDim2.fromOffset(244, 252),

    UDim2.fromOffset(60, 344),
    UDim2.fromOffset(152, 344),
    UDim2.fromOffset(244, 344),

    UDim2.fromOffset(60, 436)
}

local function CreateShortcut(
    Name,
    Text,
    Index,
    Callback
)
    local Button =
        Instance.new("TextButton")

    Button.Name =
        Name

    Button.AnchorPoint =
        Vector2.new(
            0.5,
            0.5
        )

    Button.Size =
        UDim2.fromOffset(
            84,
            84
        )

    Button.Position =
        ShortcutPositions[Index]

    Button.BackgroundColor3 =
        Color3.fromRGB(
            72,
            27,
            112
        )

    Button.BorderSizePixel =
        0

    Button.Text =
        ""

    Button.AutoButtonColor =
        false

    Button.Active =
        true

    Button.ClipsDescendants =
        true

    Button.Visible =
        false

    Button.ZIndex =
        20

    Button.Parent =
        ShortcutsGui

    local Corner =
        Instance.new("UICorner")

    Corner.CornerRadius =
        UDim.new(
            0,
            25
        )

    Corner.Parent =
        Button

    local Gradient =
        Instance.new("UIGradient")

    Gradient.Rotation =
        135

    Gradient.Color =
        ColorSequence.new({
            ColorSequenceKeypoint.new(
                0,
                Color3.fromRGB(
                    120,
                    47,
                    182
                )
            ),

            ColorSequenceKeypoint.new(
                0.42,
                Color3.fromRGB(
                    88,
                    32,
                    139
                )
            ),

            ColorSequenceKeypoint.new(
                0.72,
                Color3.fromRGB(
                    67,
                    24,
                    108
                )
            ),

            ColorSequenceKeypoint.new(
                1,
                Color3.fromRGB(
                    52,
                    19,
                    85
                )
            )
        })

    Gradient.Parent =
        Button

    local Stroke =
        Instance.new("UIStroke")

    Stroke.ApplyStrokeMode =
        Enum.ApplyStrokeMode.Border

    Stroke.Thickness =
        2

    Stroke.Transparency =
        0.06

    Stroke.Color =
        Color3.fromRGB(
            165,
            78,
            235
        )

    Stroke.Parent =
        Button

    local StrokeGradient =
        Instance.new("UIGradient")

    StrokeGradient.Rotation =
        135

    StrokeGradient.Color =
        ColorSequence.new({
            ColorSequenceKeypoint.new(
                0,
                Color3.fromRGB(
                    211,
                    133,
                    255
                )
            ),

            ColorSequenceKeypoint.new(
                0.45,
                Color3.fromRGB(
                    166,
                    82,
                    237
                )
            ),

            ColorSequenceKeypoint.new(
                1,
                Color3.fromRGB(
                    112,
                    46,
                    173
                )
            )
        })

    StrokeGradient.Parent =
        Stroke

    local InnerShade =
        Instance.new("Frame")

    InnerShade.Name =
        "InnerShade"

    InnerShade.AnchorPoint =
        Vector2.new(
            0.5,
            0.5
        )

    InnerShade.Position =
        UDim2.fromScale(
            0.5,
            0.5
        )

    InnerShade.Size =
        UDim2.new(
            1,
            -10,
            1,
            -10
        )

    InnerShade.BackgroundColor3 =
        Color3.fromRGB(
            255,
            255,
            255
        )

    InnerShade.BackgroundTransparency =
        0.972

    InnerShade.BorderSizePixel =
        0

    InnerShade.ZIndex =
        21

    InnerShade.Parent =
        Button

    local InnerCorner =
        Instance.new("UICorner")

    InnerCorner.CornerRadius =
        UDim.new(
            0,
            21
        )

    InnerCorner.Parent =
        InnerShade

    local Label =
        Instance.new("TextLabel")

    Label.Name =
        "Label"

    Label.AnchorPoint =
        Vector2.new(
            0.5,
            0.5
        )

    Label.Position =
        UDim2.new(
            0.5,
            0,
            0.42,
            0
        )

    Label.Size =
        UDim2.new(
            1,
            -14,
            0,
            43
        )

    Label.BackgroundTransparency =
        1

    Label.Text =
        Text

    Label.TextColor3 =
        Color3.fromRGB(
            245,
            240,
            250
        )

    Label.TextSize =
        12

    Label.TextWrapped =
        true

    Label.Font =
        Enum.Font.GothamBold

    Label.ZIndex =
        24

    Label.Parent =
        Button

    local Status =
        Instance.new("TextLabel")

    Status.Name =
        "Status"

    Status.AnchorPoint =
        Vector2.new(
            0.5,
            0.5
        )

    Status.Position =
        UDim2.new(
            0.5,
            0,
            0.69,
            0
        )

    Status.Size =
        UDim2.fromOffset(
            55,
            15
        )

    Status.BackgroundTransparency =
        1

    Status.Text =
        ""

    Status.TextColor3 =
        Color3.fromRGB(
            255,
            80,
            80
        )

    Status.TextSize =
        11

    Status.Font =
        Enum.Font.GothamBold

    Status.Visible =
        false

    Status.ZIndex =
        25

    Status.Parent =
        Button

    local BottomGlow =
        Instance.new("Frame")

    BottomGlow.Name =
        "BottomGlow"

    BottomGlow.AnchorPoint =
        Vector2.new(
            0.5,
            1
        )

    BottomGlow.Position =
        UDim2.new(
            0.5,
            0,
            1,
            -7
        )

    BottomGlow.Size =
        UDim2.fromOffset(
            44,
            9
        )

    BottomGlow.BackgroundColor3 =
        Color3.fromRGB(
            176,
            68,
            255
        )

    BottomGlow.BackgroundTransparency =
        0.79

    BottomGlow.BorderSizePixel =
        0

    BottomGlow.ZIndex =
        22

    BottomGlow.Parent =
        Button

    local BottomGlowCorner =
        Instance.new("UICorner")

    BottomGlowCorner.CornerRadius =
        UDim.new(
            1,
            0
        )

    BottomGlowCorner.Parent =
        BottomGlow

    local BottomGlowGradient =
        Instance.new("UIGradient")

    BottomGlowGradient.Transparency =
        NumberSequence.new({
            NumberSequenceKeypoint.new(
                0,
                1
            ),

            NumberSequenceKeypoint.new(
                0.16,
                0.62
            ),

            NumberSequenceKeypoint.new(
                0.5,
                0.1
            ),

            NumberSequenceKeypoint.new(
                0.84,
                0.62
            ),

            NumberSequenceKeypoint.new(
                1,
                1
            )
        })

    BottomGlowGradient.Parent =
        BottomGlow

    local BottomLine =
        Instance.new("Frame")

    BottomLine.Name =
        "BottomLine"

    BottomLine.AnchorPoint =
        Vector2.new(
            0.5,
            1
        )

    BottomLine.Position =
        UDim2.new(
            0.5,
            0,
            1,
            -10
        )

    BottomLine.Size =
        UDim2.fromOffset(
            35,
            3
        )

    BottomLine.BackgroundColor3 =
        Color3.fromRGB(
            210,
            126,
            255
        )

    BottomLine.BorderSizePixel =
        0

    BottomLine.ZIndex =
        23

    BottomLine.Parent =
        Button

    local BottomLineCorner =
        Instance.new("UICorner")

    BottomLineCorner.CornerRadius =
        UDim.new(
            1,
            0
        )

    BottomLineCorner.Parent =
        BottomLine

    local BottomLineGradient =
        Instance.new("UIGradient")

    BottomLineGradient.Color =
        ColorSequence.new({
            ColorSequenceKeypoint.new(
                0,
                Color3.fromRGB(
                    137,
                    50,
                    217
                )
            ),

            ColorSequenceKeypoint.new(
                0.5,
                Color3.fromRGB(
                    231,
                    166,
                    255
                )
            ),

            ColorSequenceKeypoint.new(
                1,
                Color3.fromRGB(
                    137,
                    50,
                    217
                )
            )
        })

    BottomLineGradient.Parent =
        BottomLine

    local Scale =
        Instance.new("UIScale")

    Scale.Scale =
        1

    Scale.Parent =
        Button

    local Object = {
        Button = Button,
        Label = Label,
        Status = Status,
        Scale = Scale,
        BottomLine = BottomLine,
        BottomGlow = BottomGlow,
        Cooling = false
    }

    function Object:SetStatus(
        Value,
        Color
    )
        if not Value
        or Value == "" then
            Status.Text = ""
            Status.Visible = false
            return
        end

        Status.Text =
            tostring(Value)

        Status.TextColor3 =
            Color
            or Color3.fromRGB(
                255,
                80,
                80
            )

        Status.Visible =
            true
    end

    local Dragging = false
    local DragInput
    local DragStart
    local StartPosition
    local WasDragged = false

    local function TweenScale(
        Value,
        Time
    )
        TweenService:Create(
            Scale,
            TweenInfo.new(
                Time,
                Enum.EasingStyle.Quint,
                Enum.EasingDirection.Out
            ),
            {
                Scale = Value
            }
        ):Play()
    end

    ShortcutConnect(
        Button.InputBegan,
        function(Input)
            if Input.UserInputType
            == Enum.UserInputType.MouseButton1
            or Input.UserInputType
            == Enum.UserInputType.Touch then

                Dragging = true
                WasDragged = false

                DragStart =
                    Input.Position

                StartPosition =
                    Button.Position

                TweenScale(
                    0.96,
                    0.08
                )

                local EndConnection
                EndConnection = Input.Changed:Connect(function()
                    if Input.UserInputState == Enum.UserInputState.End then
                        Dragging = false
                        TweenScale(1, 0.17)
                        if EndConnection then EndConnection:Disconnect(); EndConnection = nil end
                    end
                end)
            end
        end
    )

    ShortcutConnect(
        Button.InputChanged,
        function(Input)
            if Input.UserInputType
            == Enum.UserInputType.MouseMovement
            or Input.UserInputType
            == Enum.UserInputType.Touch then

                DragInput =
                    Input
            end
        end
    )

    ShortcutConnect(
        UserInputService.InputChanged,
        function(Input)
            if Dragging
            and Input == DragInput then

                local Delta =
                    Input.Position
                    - DragStart

                if Delta.Magnitude > 6 then
                    WasDragged = true
                end

                Button.Position =
                    UDim2.new(
                        StartPosition.X.Scale,
                        StartPosition.X.Offset
                        + Delta.X,
                        StartPosition.Y.Scale,
                        StartPosition.Y.Offset
                        + Delta.Y
                    )
            end
        end
    )

    ShortcutConnect(
        Button.Activated,
        function()
            if WasDragged
            or ShortcutDestroyed then
                return
            end

            TweenScale(
                0.92,
                0.065
            )

            TweenService:Create(
                BottomGlow,
                TweenInfo.new(
                    0.065
                ),
                {
                    BackgroundTransparency =
                        0.56,

                    Size =
                        UDim2.fromOffset(
                            52,
                            9
                        )
                }
            ):Play()

            TweenService:Create(
                BottomLine,
                TweenInfo.new(
                    0.065
                ),
                {
                    Size =
                        UDim2.fromOffset(
                            42,
                            3
                        )
                }
            ):Play()

            task.delay(
                0.075,
                function()
                    if ShortcutDestroyed
                    or not Button.Parent then
                        return
                    end

                    TweenScale(
                        1,
                        0.18
                    )

                    if not Object.Cooling then
                        TweenService:Create(
                            BottomGlow,
                            TweenInfo.new(
                                0.18
                            ),
                            {
                                BackgroundTransparency =
                                    0.79,

                                Size =
                                    UDim2.fromOffset(
                                        44,
                                        9
                                    )
                            }
                        ):Play()

                        TweenService:Create(
                            BottomLine,
                            TweenInfo.new(
                                0.18
                            ),
                            {
                                Size =
                                    UDim2.fromOffset(
                                        35,
                                        3
                                    )
                            }
                        ):Play()
                    end
                end
            )

            Callback(
                Object
            )
        end
    )

    ShortcutButtons[Name] =
        Object

    return Object
end

local function ShortcutRunCooldown(
    Object,
    Duration,
    Action
)
    if Object.Cooling then
        return
    end

    local Success =
        Action()

    if not Success then
        return
    end

    Object.Cooling =
        true

    task.spawn(function()
        local Started =
            os.clock()

        while not ShortcutDestroyed
        and Object.Button.Parent do

            local Elapsed =
                os.clock()
                - Started

            local Remaining =
                math.max(
                    0,
                    Duration
                    - Elapsed
                )

            local Ratio =
                math.clamp(
                    Remaining
                    / Duration,
                    0,
                    1
                )

            Object:SetStatus(
                string.format(
                    "%.1fs",
                    Remaining
                ),
                Color3.fromRGB(
                    255,
                    78,
                    78
                )
            )

            Object.BottomLine.Size =
                UDim2.fromOffset(
                    math.max(
                        2,
                        35 * Ratio
                    ),
                    3
                )

            if Remaining <= 0 then
                break
            end

            task.wait(0.035)
        end

        Object.Cooling =
            false

        Object:SetStatus()

        if Object.BottomLine.Parent then
            TweenService:Create(
                Object.BottomLine,
                TweenInfo.new(
                    0.16,
                    Enum.EasingStyle.Quint,
                    Enum.EasingDirection.Out
                ),
                {
                    Size =
                        UDim2.fromOffset(
                            35,
                            3
                        )
                }
            ):Play()
        end
    end)
end

CreateShortcut(
    "ShootMurder",
    "SHOOT MURDER",
    1,
    function(Object)
        ShortcutRunCooldown(
            Object,
            SHORTCUT_COOLDOWN,
            ShortcutShootMurder
        )
    end
)

CreateShortcut(
    "TPGun",
    "TP GUN",
    2,
    function()
        ShortcutTPGun()
    end
)

CreateShortcut(
    "TPMurder",
    "TP MURDER",
    3,
    function()
        ShortcutTPMurder()
    end
)

CreateShortcut(
    "TPSheriff",
    "TP SHERIFF",
    4,
    function()
        ShortcutTPSheriff()
    end
)

CreateShortcut(
    "FlingMurder",
    "FLING MURDER",
    5,
    function()
        ShortcutToggleFling(
            "MURDER"
        )
    end
)

CreateShortcut(
    "FlingSheriff",
    "FLING SHERIFF",
    6,
    function()
        ShortcutToggleFling(
            "SHERIFF"
        )
    end
)

CreateShortcut(
    "FlingAll",
    "FLING ALL",
    7,
    function()
        ShortcutToggleFling(
            "ALL"
        )
    end
)

CreateShortcut(
    "ThrowKnife",
    "THROW KNIFE",
    8,
    function(Object)
        ShortcutRunCooldown(
            Object,
            SHORTCUT_COOLDOWN,
            ShortcutThrowKnife
        )
    end
)

CreateShortcut(
    "KillSheriff",
    "KILL SHERIFF",
    9,
    function()
        ShortcutKillSheriff()
    end
)

CreateShortcut(
    "KillAll",
    "KILL ALL",
    10,
    function()
        ShortcutKillAll()
    end
)

ShortcutUpdateFlingVisuals()

local function SetShortcutVisible(
    Name,
    Value
)
    local Object =
        ShortcutButtons[Name]

    if not Object then
        return
    end

    Object.Button.Visible =
        Value

    if not Value then
        if Name == "FlingMurder"
        and ShortcutFlingMode == "MURDER" then
            ShortcutStopCurrentFling()

        elseif Name == "FlingSheriff"
        and ShortcutFlingMode == "SHERIFF" then
            ShortcutStopCurrentFling()

        elseif Name == "FlingAll"
        and ShortcutFlingMode == "ALL" then
            ShortcutStopCurrentFling()
        end
    end
end

SectionLine(ShortcutsTab, "Floating Shortcuts")
ShortcutsTab:Toggle({
    Title = "Shoot Murder",
    Desc = "Show the Shoot Murder shortcut",
    Value = false,

    Callback = function(Value)
        SetShortcutVisible(
            "ShootMurder",
            Value
        )
    end
})

ShortcutsTab:Toggle({
    Title = "TP Gun",
    Desc = "Show the TP Gun shortcut",
    Value = false,

    Callback = function(Value)
        SetShortcutVisible(
            "TPGun",
            Value
        )
    end
})

ShortcutsTab:Toggle({
    Title = "TP Murder",
    Desc = "Show the TP Murder shortcut",
    Value = false,

    Callback = function(Value)
        SetShortcutVisible(
            "TPMurder",
            Value
        )
    end
})

ShortcutsTab:Toggle({
    Title = "TP Sheriff",
    Desc = "Show the TP Sheriff shortcut",
    Value = false,

    Callback = function(Value)
        SetShortcutVisible(
            "TPSheriff",
            Value
        )
    end
})

ShortcutsTab:Toggle({
    Title = "Fling Murder",
    Desc = "Show the Fling Murder shortcut",
    Value = false,

    Callback = function(Value)
        SetShortcutVisible(
            "FlingMurder",
            Value
        )
    end
})

ShortcutsTab:Toggle({
    Title = "Fling Sheriff",
    Desc = "Show the Fling Sheriff shortcut",
    Value = false,

    Callback = function(Value)
        SetShortcutVisible(
            "FlingSheriff",
            Value
        )
    end
})

ShortcutsTab:Toggle({
    Title = "Fling All",
    Desc = "Show the Fling All shortcut",
    Value = false,

    Callback = function(Value)
        SetShortcutVisible(
            "FlingAll",
            Value
        )
    end
})

ShortcutsTab:Toggle({
    Title = "Throw Knife",
    Desc = "Show the Throw Knife shortcut",
    Value = false,

    Callback = function(Value)
        SetShortcutVisible(
            "ThrowKnife",
            Value
        )
    end
})

ShortcutsTab:Toggle({
    Title = "Kill Sheriff",
    Desc = "Show the Kill Sheriff shortcut",
    Value = false,

    Callback = function(Value)
        SetShortcutVisible(
            "KillSheriff",
            Value
        )
    end
})

ShortcutsTab:Toggle({
    Title = "Kill All",
    Desc = "Show the Kill All shortcut",
    Value = false,

    Callback = function(Value)
        SetShortcutVisible(
            "KillAll",
            Value
        )
    end
})

ShortcutConnect(
    LP.CharacterRemoving,
    function()
        ShortcutStopCurrentFling()
    end
)

GlobalEnv.MirrorsMM2ShortcutsCleanup =
    function()
        ShortcutDestroyed =
            true

        ShortcutStopCurrentFling()

        for _, Connection in ipairs(
            ShortcutConnections
        ) do
            pcall(function()
                Connection:Disconnect()
            end)
        end

        table.clear(
            ShortcutConnections
        )

        if ShortcutsGui
        and ShortcutsGui.Parent then
            ShortcutsGui:Destroy()
        end
    end
    end)

task.spawn(function()

local LocalPlayer = Players.LocalPlayer
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local PhysicsService = game:GetService("PhysicsService")

local Env = getgenv and getgenv() or _G

if Env.MirrorsMM2MiscCleanup then
    pcall(Env.MirrorsMM2MiscCleanup)
end

local MiscConnections = {}

local Settings = {
    AntiAFK = false,
    AntiVoid = false,
    AntiFling = false,
    FPSBoost = false,
    RemoveFog = false,
    Fullbright = false,
    Noclip = false,

    WalkSpeedEnabled = false,
    WalkSpeed = 32,

    JumpPowerEnabled = false,
    JumpPower = 75
}

local AntiAFKConnection
local NoclipConnection
local AntiVoidConnection
local AntiFlingConnection
local MovementConnection
local VisualConnection
local FPSDescendantConnection

local LastSafeCFrame
local LastSafeTime = 0

local CollisionStates = setmetatable({}, {
    __mode = "k"
})
local AntiFlingStates = setmetatable({}, { __mode = "k" })
local ANTI_FLING_LOCAL, ANTI_FLING_OTHERS = "MirrorsLocal", "MirrorsOthers"

local FPSStates = setmetatable({}, {
    __mode = "k"
})

local AtmosphereStates = setmetatable({}, {
    __mode = "k"
})

local EffectStates = setmetatable({}, {
    __mode = "k"
})

local OriginalLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    FogStart = Lighting.FogStart,
    FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    ExposureCompensation = Lighting.ExposureCompensation,
    EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
    EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale
}

local function CaptureLightingBaseline()
    OriginalLighting.Brightness = Lighting.Brightness
    OriginalLighting.ClockTime = Lighting.ClockTime
    OriginalLighting.FogStart = Lighting.FogStart
    OriginalLighting.FogEnd = Lighting.FogEnd
    OriginalLighting.GlobalShadows = Lighting.GlobalShadows
    OriginalLighting.Ambient = Lighting.Ambient
    OriginalLighting.OutdoorAmbient = Lighting.OutdoorAmbient
    OriginalLighting.ExposureCompensation = Lighting.ExposureCompensation
    OriginalLighting.EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale
    OriginalLighting.EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale
    table.clear(AtmosphereStates)
    table.clear(EffectStates)
end

local function Track(Connection)
    table.insert(
        MiscConnections,
        Connection
    )

    return Connection
end

local function Notify(Title, Content)
    Mirrors.Notify(Title, Content)
end

local function GetCharacter()
    local Character =
        LocalPlayer.Character

    if not Character then
        return
    end

    local Humanoid =
        Character:FindFirstChildOfClass(
            "Humanoid"
        )

    local Root =
        Character:FindFirstChild(
            "HumanoidRootPart"
        )

    if not Humanoid
    or not Root
    or Humanoid.Health <= 0 then
        return
    end

    return Character, Humanoid, Root
end

local function ResetVelocity(Root)
    if not Root then
        return
    end

    Root.AssemblyLinearVelocity =
        Vector3.zero

    Root.AssemblyAngularVelocity =
        Vector3.zero
end

local function EnableAntiAFK()
    if AntiAFKConnection then
        return
    end

    AntiAFKConnection =
        LocalPlayer.Idled:Connect(function()
            if not Settings.AntiAFK then
                return
            end

            pcall(function()
                VirtualUser:CaptureController()

                VirtualUser:ClickButton2(
                    Vector2.new(
                        0,
                        0
                    )
                )
            end)
        end)
end

local function DisableAntiAFK()
    if AntiAFKConnection then
        AntiAFKConnection:Disconnect()
        AntiAFKConnection = nil
    end
end

local function RejoinServer()
    Notify(
        "Rejoin",
        "Rejoining current server..."
    )

    task.spawn(function()
        local Success =
            pcall(function()
                if game.JobId ~= "" then
                    TeleportService:TeleportToPlaceInstance(
                        game.PlaceId,
                        game.JobId,
                        LocalPlayer
                    )
                else
                    TeleportService:Teleport(
                        game.PlaceId,
                        LocalPlayer
                    )
                end
            end)

        if not Success then
            Notify(
                "Rejoin Failed",
                "Could not rejoin the server."
            )
        end
    end)
end

local function FetchServers(MaxPages)
    local Servers = {}
    local Cursor = nil

    for _ = 1, MaxPages do
        local URL =
            "https://games.roblox.com/v1/games/"
            .. tostring(game.PlaceId)
            .. "/servers/Public?sortOrder=Asc&limit=100"

        if Cursor then
            URL =
                URL
                .. "&cursor="
                .. HttpService:UrlEncode(
                    Cursor
                )
        end

        local Success, Response =
            pcall(function()
                return game:HttpGet(URL)
            end)

        if not Success then
            break
        end

        local DecodeSuccess, Data =
            pcall(function()
                return HttpService:JSONDecode(
                    Response
                )
            end)

        if not DecodeSuccess
        or typeof(Data) ~= "table" then
            break
        end

        for _, Server in ipairs(
            Data.data or {}
        ) do
            if Server.id
            and Server.id ~= game.JobId
            and tonumber(Server.playing)
            and tonumber(Server.maxPlayers)
            and Server.playing < Server.maxPlayers then

                table.insert(
                    Servers,
                    Server
                )
            end
        end

        Cursor =
            Data.nextPageCursor

        if not Cursor then
            break
        end
    end

    return Servers
end

local function ServerHop()
    Notify(
        "Server Hop",
        "Searching for another server..."
    )

    task.spawn(function()
        local Servers =
            FetchServers(3)

        if #Servers == 0 then
            Notify(
                "Server Hop",
                "No available server was found."
            )

            return
        end

        local Server =
            Servers[
                math.random(
                    1,
                    #Servers
                )
            ]

        local Success =
            pcall(function()
                TeleportService:TeleportToPlaceInstance(
                    game.PlaceId,
                    Server.id,
                    LocalPlayer
                )
            end)

        if not Success then
            Notify(
                "Server Hop Failed",
                "Could not teleport to the server."
            )
        end
    end)
end

local function SmallServer()
    Notify(
        "Small Server",
        "Searching for a small server..."
    )

    task.spawn(function()
        local Servers =
            FetchServers(5)

        if #Servers == 0 then
            Notify(
                "Small Server",
                "No available server was found."
            )

            return
        end

        table.sort(
            Servers,
            function(A, B)
                return
                    (A.playing or math.huge)
                    <
                    (B.playing or math.huge)
            end
        )

        local Server =
            Servers[1]

        Notify(
            "Small Server",
            "Found a server with "
            .. tostring(Server.playing)
            .. " player(s)."
        )

        task.wait(0.3)

        local Success =
            pcall(function()
                TeleportService:TeleportToPlaceInstance(
                    game.PlaceId,
                    Server.id,
                    LocalPlayer
                )
            end)

        if not Success then
            Notify(
                "Small Server Failed",
                "Could not teleport to the server."
            )
        end
    end)
end

local function IsSafeGround(
    Character,
    Root
)
    local Params =
        RaycastParams.new()

    Params.FilterType =
        Enum.RaycastFilterType.Exclude

    Params.FilterDescendantsInstances = {
        Character
    }

    local Result =
        Workspace:Raycast(
            Root.Position,
            Vector3.new(
                0,
                -8,
                0
            ),
            Params
        )

    return Result ~= nil
end

local function EnableAntiVoid()
    if AntiVoidConnection then
        return
    end

    local Character, _, Root =
        GetCharacter()

    if Character
    and Root
    and IsSafeGround(
        Character,
        Root
    ) then
        LastSafeCFrame =
            Root.CFrame
    end

    AntiVoidConnection =
        RunService.Heartbeat:Connect(function()
            if not Settings.AntiVoid then
                return
            end

            local CurrentCharacter,
                Humanoid,
                CurrentRoot =
                GetCharacter()

            if not CurrentCharacter
            or not Humanoid
            or not CurrentRoot then
                return
            end

            local Grounded =
                IsSafeGround(
                    CurrentCharacter,
                    CurrentRoot
                )

            if Grounded
            and Humanoid.FloorMaterial
            ~= Enum.Material.Air then

                LastSafeCFrame =
                    CurrentRoot.CFrame

                LastSafeTime =
                    os.clock()

                return
            end

            if not LastSafeCFrame then
                return
            end

            local Drop =
                LastSafeCFrame.Position.Y
                - CurrentRoot.Position.Y

            local VoidLimit =
                Workspace.FallenPartsDestroyHeight
                + 20

            if Drop >= 24
            or CurrentRoot.Position.Y <= VoidLimit then

                CurrentRoot.CFrame =
                    LastSafeCFrame
                    + Vector3.new(
                        0,
                        3,
                        0
                    )

                ResetVelocity(
                    CurrentRoot
                )

                LastSafeTime =
                    os.clock()
            end
        end)
end

local function DisableAntiVoid()
    if AntiVoidConnection then
        AntiVoidConnection:Disconnect()
        AntiVoidConnection = nil
    end
end

local function EnsureAntiFlingGroups()
    pcall(function() PhysicsService:RegisterCollisionGroup(ANTI_FLING_LOCAL) end)
    pcall(function() PhysicsService:RegisterCollisionGroup(ANTI_FLING_OTHERS) end)
    return pcall(function() PhysicsService:CollisionGroupSetCollidable(ANTI_FLING_LOCAL, ANTI_FLING_OTHERS, false) end)
end

local function SetCharacterCollisionGroup(Character, Group)
    if not Character then return end
    for _, Part in ipairs(Character:GetDescendants()) do
        if Part:IsA("BasePart") then
            if AntiFlingStates[Part] == nil then AntiFlingStates[Part] = Part.CollisionGroup end
            if Part.CollisionGroup ~= Group then pcall(function() Part.CollisionGroup = Group end) end
        end
    end
end

local function ApplyAntiFling()
    if not Settings.AntiFling then return end
    SetCharacterCollisionGroup(LocalPlayer.Character, ANTI_FLING_LOCAL)
    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer then SetCharacterCollisionGroup(Player.Character, ANTI_FLING_OTHERS) end
    end
end

local function RestoreAntiFling()
    for Part, Group in pairs(AntiFlingStates) do
        if Part and Part.Parent then pcall(function() Part.CollisionGroup = Group end) end
    end
    table.clear(AntiFlingStates)
end

local function EnableAntiFling()
    if AntiFlingConnection then return end
    if not EnsureAntiFlingGroups() then return end
    ApplyAntiFling()
    local Last = 0
    AntiFlingConnection = RunService.Heartbeat:Connect(function()
        if not Settings.AntiFling then return end
        local Now=os.clock(); if Now-Last<0.2 then return end; Last=Now
        ApplyAntiFling()
    end)
end

local function DisableAntiFling()
    if AntiFlingConnection then AntiFlingConnection:Disconnect(); AntiFlingConnection=nil end
    RestoreAntiFling()
end

local function ApplyNoclip()
    local Character =
        LocalPlayer.Character

    if not Character then
        return
    end

    for _, Object in ipairs(
        Character:GetDescendants()
    ) do
        if Object:IsA("BasePart") then

            if CollisionStates[Object] == nil then
                CollisionStates[Object] =
                    Object.CanCollide
            end

            Object.CanCollide =
                false
        end
    end
end

local function RestoreCollisions()
    for Part, State in pairs(
        CollisionStates
    ) do
        if Part
        and Part.Parent then
            pcall(function()
                Part.CanCollide =
                    State
            end)
        end
    end

    table.clear(
        CollisionStates
    )
end

local function EnableNoclip()
    if NoclipConnection then
        return
    end

    NoclipConnection =
        RunService.Stepped:Connect(function()
            if Settings.Noclip then
                ApplyNoclip()
            end
        end)
end

local function DisableNoclip()
    if NoclipConnection then
        NoclipConnection:Disconnect()
        NoclipConnection = nil
    end

    RestoreCollisions()
end

local function ApplyMovement()
    local _, Humanoid =
        GetCharacter()

    if not Humanoid then
        return
    end

    if Settings.WalkSpeedEnabled then
        Humanoid.WalkSpeed =
            Settings.WalkSpeed
    end

    if Settings.JumpPowerEnabled then
        pcall(function()
            Humanoid.UseJumpPower =
                true
        end)

        Humanoid.JumpPower =
            Settings.JumpPower
    end
end

local function EnableMovementLoop()
    if MovementConnection then
        return
    end

    local LastUpdate = 0

    MovementConnection =
        RunService.Heartbeat:Connect(function()
            if not Settings.WalkSpeedEnabled
            and not Settings.JumpPowerEnabled then
                return
            end

            if os.clock()
            - LastUpdate < 0.12 then
                return
            end

            LastUpdate =
                os.clock()

            ApplyMovement()
        end)
end

local function DisableMovementLoopIfUnused()
    if Settings.WalkSpeedEnabled
    or Settings.JumpPowerEnabled then
        return
    end

    if MovementConnection then
        MovementConnection:Disconnect()
        MovementConnection = nil
    end
end

local function ApplyFPSObject(Object)
    if Object:IsA("BasePart") then

        if not FPSStates[Object] then
            FPSStates[Object] = {
                Type = "Part",
                Material = Object.Material,
                Reflectance = Object.Reflectance,
                CastShadow = Object.CastShadow
            }
        end

        Object.Material =
            Enum.Material.SmoothPlastic

        Object.Reflectance =
            0

        Object.CastShadow =
            false

    elseif Object:IsA("ParticleEmitter")
    or Object:IsA("Trail")
    or Object:IsA("Beam")
    or Object:IsA("Smoke")
    or Object:IsA("Fire")
    or Object:IsA("Sparkles") then

        if not FPSStates[Object] then
            FPSStates[Object] = {
                Type = "Enabled",
                Enabled = Object.Enabled
            }
        end

        Object.Enabled =
            false
    end
end

local function EnableFPSBoost()
    for _, Object in ipairs(
        Workspace:GetDescendants()
    ) do
        ApplyFPSObject(
            Object
        )
    end

    if not FPSDescendantConnection then
        FPSDescendantConnection =
            Workspace.DescendantAdded:Connect(function(Object)
                if not Settings.FPSBoost then
                    return
                end

                task.defer(function()
                    if Object
                    and Object.Parent then
                        ApplyFPSObject(
                            Object
                        )
                    end
                end)
            end)
    end
end

local function DisableFPSBoost()
    if FPSDescendantConnection then
        FPSDescendantConnection:Disconnect()
        FPSDescendantConnection = nil
    end

    for Object, State in pairs(
        FPSStates
    ) do
        if Object
        and Object.Parent then

            pcall(function()
                if State.Type == "Part" then
                    Object.Material =
                        State.Material

                    Object.Reflectance =
                        State.Reflectance

                    Object.CastShadow =
                        State.CastShadow

                elseif State.Type == "Enabled" then
                    Object.Enabled =
                        State.Enabled
                end
            end)
        end
    end

    table.clear(
        FPSStates
    )
end

local function SaveVisualObjects()
    for _, Object in ipairs(
        Lighting:GetChildren()
    ) do

        if Object:IsA("Atmosphere") then

            if not AtmosphereStates[Object] then
                AtmosphereStates[Object] = {
                    Density = Object.Density,
                    Haze = Object.Haze,
                    Glare = Object.Glare,
                    Offset = Object.Offset
                }
            end

        elseif Object:IsA("BloomEffect")
        or Object:IsA("BlurEffect")
        or Object:IsA("SunRaysEffect")
        or Object:IsA("ColorCorrectionEffect")
        or Object:IsA("DepthOfFieldEffect") then

            if not EffectStates[Object] then
                EffectStates[Object] = {
                    Enabled = Object.Enabled
                }
            end
        end
    end
end

local function RestoreVisualObjects()
    for Object, State in pairs(
        AtmosphereStates
    ) do
        if Object
        and Object.Parent then
            pcall(function()
                Object.Density =
                    State.Density

                Object.Haze =
                    State.Haze

                Object.Glare =
                    State.Glare

                Object.Offset =
                    State.Offset
            end)
        end
    end

    for Object, State in pairs(
        EffectStates
    ) do
        if Object
        and Object.Parent then
            pcall(function()
                Object.Enabled =
                    State.Enabled
            end)
        end
    end
end

local function ApplyVisualSettings()
    SaveVisualObjects()

    Lighting.Brightness =
        OriginalLighting.Brightness

    Lighting.ClockTime =
        OriginalLighting.ClockTime

    Lighting.FogStart =
        OriginalLighting.FogStart

    Lighting.FogEnd =
        OriginalLighting.FogEnd

    Lighting.GlobalShadows =
        OriginalLighting.GlobalShadows

    Lighting.Ambient =
        OriginalLighting.Ambient

    Lighting.OutdoorAmbient =
        OriginalLighting.OutdoorAmbient

    Lighting.ExposureCompensation =
        OriginalLighting.ExposureCompensation

    Lighting.EnvironmentDiffuseScale =
        OriginalLighting.EnvironmentDiffuseScale

    Lighting.EnvironmentSpecularScale =
        OriginalLighting.EnvironmentSpecularScale

    RestoreVisualObjects()

    if Settings.RemoveFog then
        Lighting.FogStart =
            0

        Lighting.FogEnd =
            1000000

        for Atmosphere in pairs(
            AtmosphereStates
        ) do
            if Atmosphere
            and Atmosphere.Parent then
                Atmosphere.Density =
                    0

                Atmosphere.Haze =
                    0

                Atmosphere.Glare =
                    0
            end
        end
    end

    if Settings.Fullbright then
        Lighting.Brightness =
            3

        Lighting.ClockTime =
            14

        Lighting.GlobalShadows =
            false

        Lighting.Ambient =
            Color3.fromRGB(
                255,
                255,
                255
            )

        Lighting.OutdoorAmbient =
            Color3.fromRGB(
                255,
                255,
                255
            )

        Lighting.ExposureCompensation =
            0
    end

    if Settings.FPSBoost then
        Lighting.GlobalShadows =
            false

        Lighting.EnvironmentDiffuseScale =
            0

        Lighting.EnvironmentSpecularScale =
            0

        for Effect in pairs(
            EffectStates
        ) do
            if Effect
            and Effect.Parent then
                Effect.Enabled =
                    false
            end
        end
    end
end

local function RestoreLighting()
    Lighting.Brightness =
        OriginalLighting.Brightness

    Lighting.ClockTime =
        OriginalLighting.ClockTime

    Lighting.FogStart =
        OriginalLighting.FogStart

    Lighting.FogEnd =
        OriginalLighting.FogEnd

    Lighting.GlobalShadows =
        OriginalLighting.GlobalShadows

    Lighting.Ambient =
        OriginalLighting.Ambient

    Lighting.OutdoorAmbient =
        OriginalLighting.OutdoorAmbient

    Lighting.ExposureCompensation =
        OriginalLighting.ExposureCompensation

    Lighting.EnvironmentDiffuseScale =
        OriginalLighting.EnvironmentDiffuseScale

    Lighting.EnvironmentSpecularScale =
        OriginalLighting.EnvironmentSpecularScale

    RestoreVisualObjects()
end

local function UpdateVisualLoop()
    local Enabled =
        Settings.RemoveFog
        or Settings.Fullbright
        or Settings.FPSBoost

    if Enabled then
        if not VisualConnection then
            CaptureLightingBaseline()
        end
        ApplyVisualSettings()

        if not VisualConnection then
            local LastUpdate = 0

            VisualConnection =
                RunService.Heartbeat:Connect(function()
                    if os.clock()
                    - LastUpdate < 0.4 then
                        return
                    end

                    LastUpdate =
                        os.clock()

                    if Settings.RemoveFog
                    or Settings.Fullbright
                    or Settings.FPSBoost then
                        ApplyVisualSettings()
                    end
                end)
        end
    else
        if VisualConnection then
            VisualConnection:Disconnect()
            VisualConnection = nil
        end

        RestoreLighting()
        table.clear(AtmosphereStates)
        table.clear(EffectStates)
    end
end

Track(
    LocalPlayer.CharacterAdded:Connect(function(Character)
        LastSafeCFrame =
            nil

        table.clear(
            CollisionStates
        )

        task.wait(0.6)

        local Humanoid =
            Character:FindFirstChildOfClass(
                "Humanoid"
            )

        local Root =
            Character:FindFirstChild(
                "HumanoidRootPart"
            )

        if Settings.AntiVoid
        and Humanoid
        and Root then
            LastSafeCFrame =
                Root.CFrame
        end

        if Settings.WalkSpeedEnabled
        or Settings.JumpPowerEnabled then
            ApplyMovement()
        end
    end)
)

SectionLine(MiscTab, "Server")

MiscTab:Toggle({
    Title = "Anti-AFK",
    Desc = "Prevents Roblox idle kick.",
    Value = false,

    Callback = function(Value)
        Settings.AntiAFK =
            Value

        if Value then
            EnableAntiAFK()

            Notify(
                "Anti-AFK",
                "Anti-AFK enabled."
            )
        else
            DisableAntiAFK()

            Notify(
                "Anti-AFK",
                "Anti-AFK disabled."
            )
        end
    end
})

MiscTab:Button({
    Title = "Rejoin",
    Desc = "Rejoin the current server.",

    Callback = function()
        RejoinServer()
    end
})

MiscTab:Button({
    Title = "Server Hop",
    Desc = "Join another available server.",

    Callback = function()
        ServerHop()
    end
})

MiscTab:Button({
    Title = "Small Server",
    Desc = "Find a server with fewer players.",

    Callback = function()
        SmallServer()
    end
})

SectionLine(MiscTab, "Player & Protection")

MiscTab:Toggle({
    Title = "Anti-Void",
    Desc = "Returns you to your last safe position when falling under the map.",
    Value = false,

    Callback = function(Value)
        Settings.AntiVoid =
            Value

        if Value then
            EnableAntiVoid()
        else
            DisableAntiVoid()
        end
    end
})

MiscTab:Toggle({
    Title = "Anti Fling",
    Desc = "Disables collisions between you and other players.",
    Value = false,
    Callback = function(Value)
        Settings.AntiFling = Value
        if Value then EnableAntiFling() else DisableAntiFling() end
    end
})

MiscTab:Toggle({
    Title = "No Clip",
    Desc = "Walk through collidable objects.",
    Value = false,

    Callback = function(Value)
        Settings.Noclip =
            Value

        if Value then
            EnableNoclip()
        else
            DisableNoclip()
        end
    end
})

MiscTab:Toggle({
    Title = "WalkSpeed",
    Desc = "Enable custom WalkSpeed.",
    Value = false,

    Callback = function(Value)
        Settings.WalkSpeedEnabled =
            Value

        if Value then
            EnableMovementLoop()
            ApplyMovement()
        else
            local _, Humanoid =
                GetCharacter()

            if Humanoid then
                Humanoid.WalkSpeed =
                    16
            end

            DisableMovementLoopIfUnused()
        end
    end
})

MiscTab:Slider({
    Title = "WalkSpeed Value",
    Desc = "Change your movement speed.",
    Step = 1,

    Value = {
        Min = 16,
        Max = 100,
        Default = 32
    },

    Callback = function(Value)
        Settings.WalkSpeed =
            Value

        if Settings.WalkSpeedEnabled then
            ApplyMovement()
        end
    end
})

MiscTab:Toggle({
    Title = "JumpPower",
    Desc = "Enable custom JumpPower.",
    Value = false,

    Callback = function(Value)
        Settings.JumpPowerEnabled =
            Value

        if Value then
            EnableMovementLoop()
            ApplyMovement()
        else
            local _, Humanoid =
                GetCharacter()

            if Humanoid then
                Humanoid.JumpPower =
                    50
            end

            DisableMovementLoopIfUnused()
        end
    end
})

MiscTab:Slider({
    Title = "JumpPower Value",
    Desc = "Change your jump power.",
    Step = 1,

    Value = {
        Min = 50,
        Max = 150,
        Default = 75
    },

    Callback = function(Value)
        Settings.JumpPower =
            Value

        if Settings.JumpPowerEnabled then
            ApplyMovement()
        end
    end
})

SectionLine(MiscTab, "Visual & Performance")

MiscTab:Toggle({
    Title = "FPS Boost",
    Desc = "Reduces effects, shadows and expensive materials.",
    Value = false,

    Callback = function(Value)
        Settings.FPSBoost =
            Value

        if Value then
            EnableFPSBoost()
        else
            DisableFPSBoost()
        end

        UpdateVisualLoop()
    end
})

MiscTab:Toggle({
    Title = "Remove Fog",
    Desc = "Removes fog and atmosphere haze.",
    Value = false,

    Callback = function(Value)
        Settings.RemoveFog =
            Value

        UpdateVisualLoop()
    end
})

MiscTab:Toggle({
    Title = "Fullbright",
    Desc = "Keeps the map bright and visible.",
    Value = false,

    Callback = function(Value)
        Settings.Fullbright =
            Value

        UpdateVisualLoop()
    end
})

Env.MirrorsMM2MiscCleanup =
    function()
        Settings.AntiAFK = false
        Settings.AntiVoid = false
        Settings.AntiFling = false
        Settings.Noclip = false
        Settings.WalkSpeedEnabled = false
        Settings.JumpPowerEnabled = false
        Settings.FPSBoost = false
        Settings.RemoveFog = false
        Settings.Fullbright = false

        DisableAntiAFK()
        DisableAntiVoid()
        DisableAntiFling()
        DisableNoclip()

        if MovementConnection then
            MovementConnection:Disconnect()
            MovementConnection = nil
        end

        if VisualConnection then
            VisualConnection:Disconnect()
            VisualConnection = nil
        end

        DisableFPSBoost()
        RestoreLighting()

        for _, Connection in ipairs(
            MiscConnections
        ) do
            pcall(function()
                Connection:Disconnect()
            end)
        end

        table.clear(
            MiscConnections
        )
    end

end)

task.spawn(function()

local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ConfigManager = Window.ConfigManager

local ConfigName = "default"
local ImportText = ""
local CurrentConfig = nil
local AutoLoadEnabled = false

local DefaultElements = {}
local DefaultShortcuts = {}

local ConfigPath
local AutoLoadPath

local function Notify(Title, Content)
    Mirrors.Notify(Title, Content)
end

local function SanitizeName(Name)
    Name = tostring(Name or "")
    Name = Name:gsub("^%s+", "")
    Name = Name:gsub("%s+$", "")
    Name = Name:gsub("[\\/:*?\"<>|]", "_")
    Name = Name:gsub("%.%.", "_")

    if Name == "" then
        Name = "default"
    end

    if #Name > 32 then
        Name = Name:sub(1, 32)
    end

    return Name
end

local function ConfigSupported()
    return
        ConfigManager
        and writefile
        and readfile
        and isfile
        and makefolder
        and isfolder
end

if ConfigManager then
    pcall(function()
        ConfigManager:Init(Window)
    end)

    ConfigPath = ConfigManager.Path

    if ConfigPath then
        AutoLoadPath =
            ConfigPath .. "autoload.txt"
    end
end

local function GetConfigPath(Name)
    if not ConfigPath then
        return
    end

    return
        ConfigPath
        .. SanitizeName(Name)
        .. ".json"
end

local function ReadAutoLoad()
    if not AutoLoadPath
    or not isfile
    or not readfile then
        return
    end

    if not isfile(AutoLoadPath) then
        return
    end

    local Success, Result =
        pcall(function()
            return readfile(
                AutoLoadPath
            )
        end)

    if Success
    and Result
    and Result ~= "" then
        return SanitizeName(Result)
    end
end

local function WriteAutoLoad(Name)
    if not AutoLoadPath
    or not writefile then
        return false
    end

    return pcall(function()
        writefile(
            AutoLoadPath,
            SanitizeName(Name)
        )
    end)
end

local function ClearAutoLoad()
    if not AutoLoadPath then
        return
    end

    if delfile
    and isfile
    and isfile(AutoLoadPath) then
        pcall(function()
            delfile(
                AutoLoadPath
            )
        end)
    elseif writefile then
        pcall(function()
            writefile(
                AutoLoadPath,
                ""
            )
        end)
    end
end

local function EncodeUDim2(Value)
    return {
        XS = Value.X.Scale,
        XO = Value.X.Offset,
        YS = Value.Y.Scale,
        YO = Value.Y.Offset
    }
end

local function DecodeUDim2(Data)
    if typeof(Data) ~= "table" then
        return
    end

    return UDim2.new(
        tonumber(Data.XS) or 0,
        tonumber(Data.XO) or 0,
        tonumber(Data.YS) or 0,
        tonumber(Data.YO) or 0
    )
end

local function GetShortcutGui()
    return PlayerGui:FindFirstChild(
        "MirrorsShortcutsGUI"
    )
end

local function CaptureShortcutLayout()
    local Data = {}

    local Gui =
        GetShortcutGui()

    if not Gui then
        return Data
    end

    for _, Object in ipairs(
        Gui:GetChildren()
    ) do
        if Object:IsA("GuiButton") then
            Data[Object.Name] = {
                Position =
                    EncodeUDim2(
                        Object.Position
                    ),

                Visible =
                    Object.Visible
            }
        end
    end

    return Data
end

local function ApplyShortcutLayout(Data)
    if typeof(Data) ~= "table" then
        return
    end

    local Gui =
        GetShortcutGui()

    if not Gui then
        return
    end

    for Name, State in pairs(
        Data
    ) do
        local Button =
            Gui:FindFirstChild(Name)

        if Button
        and Button:IsA("GuiButton")
        and typeof(State) == "table" then

            local Position =
                DecodeUDim2(
                    State.Position
                )

            if Position then
                Button.Position =
                    Position
            end

            if typeof(State.Visible)
            == "boolean" then
                Button.Visible =
                    State.Visible
            end
        end
    end
end

local function GetElementValue(Element)
    if not Element then
        return
    end

    local Type =
        Element.__type

    if Type == "Toggle" then
        return {
            Type = Type,
            Value = Element.Value
        }

    elseif Type == "Slider" then
        return {
            Type = Type,
            Value =
                Element.Value
                and Element.Value.Default
        }

    elseif Type == "Dropdown" then
        return {
            Type = Type,
            Value = Element.Value
        }

    elseif Type == "Input" then
        return {
            Type = Type,
            Value = Element.Value
        }

    elseif Type == "Keybind" then
        return {
            Type = Type,
            Value = Element.Value
        }

    elseif Type == "Colorpicker" then
        local Color =
            Element.Default

        return {
            Type = Type,

            Value =
                Color
                and Color:ToHex(),

            Transparency =
                Element.Transparency
        }
    end
end

local function ApplyElementValue(
    Element,
    Data
)
    if not Element
    or typeof(Data) ~= "table" then
        return
    end

    local Type =
        Data.Type

    pcall(function()
        if Type == "Toggle"
        and Element.Set then

            Element:Set(
                Data.Value == true
            )

        elseif Type == "Slider"
        and Element.Set then

            Element:Set(
                tonumber(Data.Value)
            )

        elseif Type == "Dropdown"
        and Element.Select then

            Element:Select(
                Data.Value
            )

        elseif Type == "Input"
        and Element.Set then

            Element:Set(
                Data.Value
            )

        elseif Type == "Keybind"
        and Element.Set then

            Element:Set(
                Data.Value
            )

        elseif Type == "Colorpicker"
        and Element.Update
        and Data.Value then

            Element:Update(
                Color3.fromHex(
                    Data.Value
                ),

                Data.Transparency
            )
        end
    end)
end

local function CaptureDefaults()
    table.clear(
        DefaultElements
    )

    if Window.PendingFlags then
        for Flag, Element in pairs(
            Window.PendingFlags
        ) do
            local Value =
                GetElementValue(
                    Element
                )

            if Value then
                DefaultElements[Flag] =
                    Value
            end
        end
    end

    DefaultShortcuts =
        CaptureShortcutLayout()
end

local function ResetLiveConfig()
    for Flag, Data in pairs(
        DefaultElements
    ) do
        local Element =
            Window.PendingFlags
            and Window.PendingFlags[Flag]

        if Element then
            ApplyElementValue(
                Element,
                Data
            )
        end
    end

    ApplyShortcutLayout(
        DefaultShortcuts
    )

    Mirrors.ResetUISettings()
end

local function GetConfigs()
    if not ConfigManager then
        return {}
    end

    local Success, Result =
        pcall(function()
            return
                ConfigManager:AllConfigs()
        end)

    if not Success
    or typeof(Result) ~= "table" then
        return {}
    end

    table.sort(Result)

    return Result
end

local ConfigInput
local ConfigDropdown
local AutoLoadToggle

local function RefreshConfigs()
    if not ConfigDropdown then
        return
    end

    local Configs =
        GetConfigs()

    if #Configs == 0 then
        Configs = {
            "default"
        }
    end

    pcall(function()
        ConfigDropdown:Refresh(
            Configs
        )
    end)
end

local function UpdateAutoLoadToggle()
    if not AutoLoadToggle then
        return
    end

    local AutoName =
        ReadAutoLoad()

    AutoLoadEnabled =
        AutoName ~= nil
        and AutoName == ConfigName

    pcall(function()
        AutoLoadToggle:Set(
            AutoLoadEnabled
        )
    end)
end

local function GetOrCreateConfig(Name)
    if not ConfigManager then
        return
    end

    Name =
        SanitizeName(Name)

    local Existing =
        ConfigManager:GetConfig(
            Name
        )

    if Existing
    and typeof(Existing) == "table"
    and Existing.Save then
        return Existing
    end

    local Success, Result =
        pcall(function()
            return
                ConfigManager:CreateConfig(
                    Name,
                    false
                )
        end)

    if Success then
        return Result
    end
end

local function SaveConfig(Silent)
    if not ConfigSupported() then
        if not Silent then
            Notify(
                "Config Error",
                "Your executor does not support file configs."
            )
        end

        return false
    end

    ConfigName =
        SanitizeName(
            ConfigName
        )

    local Config =
        GetOrCreateConfig(
            ConfigName
        )

    if not Config then
        if not Silent then
            Notify(
                "Save Failed",
                "Could not create the config."
            )
        end

        return false
    end

    Config:SetAutoLoad(false)

    Config:Set(
        "shortcutLayout",
        CaptureShortcutLayout()
    )

    Config:Set(
        "lastSave",
        os.date(
            "%Y-%m-%d %H:%M:%S"
        )
    )

    Config:Set(
        "version",
        "MM2"
    )

    Config:Set(
        "uiSettings",
        Mirrors.GetUISettings()
    )

    local Success =
        pcall(function()
            Config:Save()
        end)

    if not Success then
        if not Silent then
            Notify(
                "Save Failed",
                "Could not save the config."
            )
        end

        return false
    end

    CurrentConfig =
        Config

    if AutoLoadEnabled then
        WriteAutoLoad(
            ConfigName
        )
    end

    RefreshConfigs()

    if not Silent then
        Notify(
            "Config Saved",
            "Saved as: "
            .. ConfigName
        )
    end

    return true
end

local function LoadConfig(
    Name,
    Silent
)
    if not ConfigSupported() then
        if not Silent then
            Notify(
                "Config Error",
                "Your executor does not support file configs."
            )
        end

        return false
    end

    Name =
        SanitizeName(
            Name or ConfigName
        )

    local Path =
        GetConfigPath(
            Name
        )

    if not Path
    or not isfile(Path) then
        if not Silent then
            Notify(
                "Load Failed",
                "Config does not exist: "
                .. Name
            )
        end

        return false
    end

    local Config =
        GetOrCreateConfig(
            Name
        )

    if not Config then
        if not Silent then
            Notify(
                "Load Failed",
                "Could not open the config."
            )
        end

        return false
    end

    Mirrors.State.ConfigApplying = true

    local Success, CustomData =
        pcall(function()
            return Config:Load()
        end)

    Mirrors.State.ConfigApplying = false

    if not Success then
        if not Silent then
            Notify(
                "Load Failed",
                "Could not load the config."
            )
        end

        return false
    end

    CurrentConfig =
        Config

    if typeof(CustomData) == "table"
    and typeof(CustomData.uiSettings) == "table" then
        Mirrors.ApplyUISettings(
            CustomData.uiSettings,
            true
        )
    end

    ConfigName =
        Name

    if ConfigInput then
        pcall(function()
            ConfigInput:Set(
                ConfigName
            )
        end)
    end

    task.delay(
        0.15,
        function()
            if not Mirrors.Runtime.Alive then return end
            if typeof(CustomData) == "table" and CustomData.shortcutLayout then
                ApplyShortcutLayout(CustomData.shortcutLayout)
            end
        end
    )

    UpdateAutoLoadToggle()

    if not Silent then
        local LastSave =
            typeof(CustomData)
            == "table"
            and CustomData.lastSave
            or nil

        Notify(
            "Config Loaded",
            LastSave
            and (
                ConfigName
                .. "\nSaved: "
                .. tostring(
                    LastSave
                )
            )
            or ConfigName
        )
    end

    return true
end

local function DeleteConfig()
    if not ConfigSupported() then
        Notify(
            "Config Error",
            "Your executor does not support file configs."
        )

        return
    end

    ConfigName =
        SanitizeName(
            ConfigName
        )

    local Path =
        GetConfigPath(
            ConfigName
        )

    if not Path
    or not isfile(Path) then
        Notify(
            "Delete Failed",
            "Config does not exist."
        )

        return
    end

    local Success, Result =
        pcall(function()
            return
                ConfigManager:DeleteConfig(
                    ConfigName
                )
        end)

    if not Success
    or Result == false then

        if delfile then
            Success =
                pcall(function()
                    delfile(
                        Path
                    )
                end)
        end
    end

    if not Success then
        Notify(
            "Delete Failed",
            "Could not delete the config."
        )

        return
    end

    if ReadAutoLoad()
    == ConfigName then
        ClearAutoLoad()

        AutoLoadEnabled =
            false

        if AutoLoadToggle then
            pcall(function()
                AutoLoadToggle:Set(
                    false
                )
            end)
        end
    end

    CurrentConfig =
        nil

    RefreshConfigs()

    Notify(
        "Config Deleted",
        "Deleted: "
        .. ConfigName
    )
end

local function ExportConfig()
    if not ConfigSupported() then
        Notify(
            "Export Error",
            "File configs are not supported."
        )

        return
    end

    if not SaveConfig(true) then
        Notify(
            "Export Error",
            "Could not prepare the config."
        )

        return
    end

    local Path =
        GetConfigPath(
            ConfigName
        )

    if not Path
    or not isfile(Path) then
        Notify(
            "Export Error",
            "Config file was not found."
        )

        return
    end

    local Success, Data =
        pcall(function()
            return readfile(
                Path
            )
        end)

    if not Success
    or not Data then
        Notify(
            "Export Error",
            "Could not read the config."
        )

        return
    end

    local Clipboard =
        setclipboard
        or toclipboard

    if not Clipboard then
        Notify(
            "Clipboard Error",
            "Clipboard is not supported."
        )

        return
    end

    local Copied =
        pcall(function()
            Clipboard(
                Data
            )
        end)

    if Copied then
        Notify(
            "Config Exported",
            "JSON copied to clipboard."
        )
    else
        Notify(
            "Export Error",
            "Could not copy the JSON."
        )
    end
end

local function ImportConfig()
    if not ConfigSupported() then
        Notify(
            "Import Error",
            "File configs are not supported."
        )

        return
    end

    if ImportText == "" then
        Notify(
            "Import Error",
            "Paste a config JSON first."
        )

        return
    end

    local Success, Decoded =
        pcall(function()
            return HttpService:JSONDecode(
                ImportText
            )
        end)

    if not Success
    or typeof(Decoded) ~= "table" then
        Notify(
            "Import Error",
            "Invalid JSON."
        )

        return
    end

    if not Decoded.__elements
    and not Decoded.__custom then
        Notify(
            "Import Error",
            "This is not a Mirrors/WindUI config."
        )

        return
    end

    ConfigName =
        SanitizeName(
            ConfigName
        )

    local Path =
        GetConfigPath(
            ConfigName
        )

    local Normalized =
        HttpService:JSONEncode(
            Decoded
        )

    local Written =
        pcall(function()
            writefile(
                Path,
                Normalized
            )
        end)

    if not Written then
        Notify(
            "Import Error",
            "Could not write the config."
        )

        return
    end

    CurrentConfig =
        nil

    RefreshConfigs()

    Notify(
        "Config Imported",
        "Imported as: "
        .. ConfigName
    )
end

SectionLine(ConfigTab, "Interface")

Mirrors.Controls.Language = ConfigTab:Dropdown({
    Title = "Language",
    Desc = "Change the interface language.",
    Values = { "English", "Português", "Español" },
    Value = Mirrors.State.Language,
    AllowNone = false,
    Flag = "Config_Dropdown_Language",
    Callback = function(Value)
        if typeof(Value) == "table" then
            Value = Value.Value or Value.Title or Value[1]
        end
        Mirrors.SetLanguage(Value)
    end
})

Mirrors.Controls.Theme = ConfigTab:Dropdown({
    Title = "Theme",
    Desc = "Choose a WindUI theme.",
    Values = Mirrors.GetThemeOptions(),
    Value = Mirrors.State.Theme,
    AllowNone = false,
    Flag = "Config_Dropdown_Theme",
    Callback = function(Value)
        if typeof(Value) == "table" then
            Value = Value.Value or Value.Title or Value[1]
        end
        Mirrors.SetTheme(Value)
    end
})

Mirrors.Controls.Notifications = ConfigTab:Toggle({
    Title = "Notifications",
    Desc = "Show hub notifications.",
    Value = Mirrors.State.Notifications,
    Flag = "Config_Toggle_Notifications",
    Callback = function(Value)
        Mirrors.SetNotifications(Value)
    end
})

ConfigTab:Button({
    Title = "Center Window",
    Desc = "Center the Mirrors Hub window.",
    Icon = "solar:cursor-square-bold",
    Callback = function()
        pcall(function()
            Window:SetToTheCenter()
        end)
        Mirrors.Notify("Mirrors Hub", "Window centered.", "solar:check-square-bold", 2)
    end
})

ConfigTab:Button({
    Title = "Reapply Visual",
    Desc = "Reapply Mirrors Purple glow and visual effects.",
    Icon = "solar:check-square-bold",
    Callback = function()
        Mirrors.ApplyDetailedStyle()
        Mirrors.Notify("Mirrors Purple", "Visual reapplied.", "solar:check-square-bold", 2)
    end
})

SectionLine(ConfigTab, "Configuration")

ConfigInput =
    ConfigTab:Input({
        Title = "Config Name",
        Desc = "Name used to save or create a configuration.",
        Value = "default",
        Placeholder = "default",

        Callback = function(Value)
            ConfigName =
                SanitizeName(
                    Value
                )

            UpdateAutoLoadToggle()
        end
    })

ConfigDropdown =
    ConfigTab:Dropdown({
        Title = "Saved Configs",
        Desc = "Select an existing configuration.",
        Values = GetConfigs(),
        Value = nil,
        AllowNone = true,

        Callback = function(Value)
            if typeof(Value)
            == "table" then
                Value =
                    Value.Title
            end

            if not Value
            or Value == "" then
                return
            end

            ConfigName =
                SanitizeName(
                    Value
                )

            pcall(function()
                ConfigInput:Set(
                    ConfigName
                )
            end)

            UpdateAutoLoadToggle()
        end
    })

ConfigTab:Button({
    Title = "Refresh Config List",
    Desc = "Refresh saved configuration files.",

    Callback = function()
        RefreshConfigs()

        Notify(
            "Configs",
            "Config list refreshed."
        )
    end
})

SectionLine(ConfigTab, "Save & Load")

ConfigTab:Button({
    Title = "Save Config",
    Desc = "Save all registered settings and shortcut positions.",

    Callback = function()
        SaveConfig(false)
    end
})

ConfigTab:Button({
    Title = "Load Config",
    Desc = "Load the selected configuration.",

    Callback = function()
        LoadConfig(
            ConfigName,
            false
        )
    end
})

AutoLoadToggle =
    ConfigTab:Toggle({
        Title = "Auto Load Config",
        Desc = "Automatically load this config when Mirrors Hub starts.",
        Value = false,

        Callback = function(Value)
            AutoLoadEnabled =
                Value

            if Value then
                ConfigName =
                    SanitizeName(
                        ConfigName
                    )

                if not isfile
                or not GetConfigPath(
                    ConfigName
                )
                or not isfile(
                    GetConfigPath(
                        ConfigName
                    )
                ) then

                    if not SaveConfig(true) then
                        AutoLoadEnabled =
                            false

                        task.defer(function()
                            pcall(function()
                                AutoLoadToggle:Set(
                                    false
                                )
                            end)
                        end)

                        return
                    end
                end

                WriteAutoLoad(
                    ConfigName
                )

                Notify(
                    "Auto Load",
                    "Auto load enabled for: "
                    .. ConfigName
                )
            else
                if ReadAutoLoad()
                == ConfigName then
                    ClearAutoLoad()
                end

                Notify(
                    "Auto Load",
                    "Auto load disabled."
                )
            end
        end
    })

ConfigTab:Button({
    Title = "Reset Config",
    Desc = "Restore all settings and shortcut positions to their defaults.",

    Callback = function()
        ResetLiveConfig()

        Notify(
            "Config Reset",
            "Settings restored to defaults."
        )
    end
})

ConfigTab:Button({
    Title = "Delete Config",
    Desc = "Permanently delete the selected configuration.",

    Callback = function()
        DeleteConfig()
    end
})

SectionLine(ConfigTab, "Export & Import")

ConfigTab:Button({
    Title = "Export Config",
    Desc = "Copy the current configuration JSON to clipboard.",

    Callback = function()
        ExportConfig()
    end
})

ConfigTab:Input({
    Title = "Import JSON",
    Desc = "Paste an exported Mirrors Hub config.",
    Type = "Textarea",
    Placeholder = "{\"__version\":1.2,...}",

    Callback = function(Value)
        ImportText =
            tostring(
                Value or ""
            )
    end
})

ConfigTab:Button({
    Title = "Import Config",
    Desc = "Save the JSON above using the current Config Name.",

    Callback = function()
        ImportConfig()
    end
})

task.wait(0.15)

CaptureDefaults()
RefreshConfigs()

local SavedAutoLoad =
    ReadAutoLoad()

if SavedAutoLoad then
    ConfigName =
        SavedAutoLoad

    AutoLoadEnabled =
        true

    pcall(function()
        ConfigInput:Set(
            ConfigName
        )
    end)

    pcall(function()
        AutoLoadToggle:Set(
            true
        )
    end)

    task.delay(
        0.8,
        function()
            if Mirrors.Runtime.Alive then
                LoadConfig(SavedAutoLoad, true)
            end
        end
    )
end

end)
