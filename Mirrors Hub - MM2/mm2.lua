--// SERVICES
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local Analytics = game:GetService("RbxAnalyticsService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LP = Players.LocalPlayer

local Gameplay = ReplicatedStorage
	:WaitForChild("Remotes")
	:WaitForChild("Gameplay")

--// WINDUI
local WindUI = loadstring(game:HttpGet(
	"https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

--// REQUEST
local Request =
	(syn and syn.request)
	or http_request
	or request

if not Request then
	error("[MIRRORS] HTTP requests are not supported.")
end

--// KEY SYSTEM
local API = "https://mirrorshub-key.vercel.app/api/key/validate"

-- guarda as infos da key pra usar dps
local KeyInfo = {
	Status = "Unknown",
	Provider = "Unknown",
	ExpiresAt = nil
}

-- mensagens de erro da key
local KeyMessages = {
	INVALID_KEY = "Invalid key.",
	INVALID_HWID = "Unable to identify this device.",
	HWID_MISMATCH = "This key is linked to another device.",
	KEY_PAUSED = "This key is paused.",
	KEY_INACTIVE = "This key is inactive.",
	KEY_EXPIRED = "This key has expired.",
	ACCESS_DENIED = "Access denied.",
	USER_BANNED = "Access denied.",
	VALIDATION_ERROR = "Unable to validate key."
}

-- pega o executor
local function GetExecutor()
	if identifyexecutor then
		local ok, name = pcall(identifyexecutor)

		if ok and name then
			return tostring(name)
		end
	end

	if getexecutorname then
		local ok, name = pcall(getexecutorname)

		if ok and name then
			return tostring(name)
		end
	end

	return "Unknown"
end

-- pega o hwid
local function GetHWID()
	if gethwid then
		local ok, value = pcall(gethwid)

		if ok and value then
			value = tostring(value)

			if #value >= 8 and #value <= 256 then
				return value
			end
		end
	end

	-- fallback caso o executor n tenha gethwid
	local ok, value = pcall(function()
		return Analytics:GetClientId()
	end)

	if ok and value then
		value = tostring(value)

		if #value >= 8 and #value <= 256 then
			return value
		end
	end

	return nil
end

-- valida a key na api
local function ValidateKey(key)
	key = tostring(key or ""):match("^%s*(.-)%s*$")

	if key == "" then
		return false
	end

	local hwid = GetHWID()

	if not hwid then
		warn("[MIRRORS] Unable to identify this device.")
		return false
	end

	-- manda tudo pro servidor validar
	local ok, res = pcall(function()
		return Request({
			Url = API,
			Method = "POST",

			Headers = {
				["Content-Type"] = "application/json",
				["Accept"] = "application/json"
			},

			Body = HttpService:JSONEncode({
				key = key,
				hwid = hwid,

				robloxUserId = LP.UserId,
				robloxUsername = LP.Name,
				robloxDisplayName = LP.DisplayName,

				executor = GetExecutor(),

				placeId = game.PlaceId,
				jobId = game.JobId
			})
		})
	end)

	if not ok or type(res) ~= "table" then
		warn("[MIRRORS] Server connection failed.")
		return false
	end

	local raw =
		res.Body
		or res.body
		or res.ResponseBody
		or ""

	-- tenta ler a resposta da api
	local decoded, data = pcall(
		HttpService.JSONDecode,
		HttpService,
		raw
	)

	if not decoded or type(data) ~= "table" then
		warn("[MIRRORS] Invalid server response.")
		return false
	end

	-- key valida
	if data.valid == true then
		KeyInfo.Status = "Active"
		KeyInfo.Provider = data.provider or "Unknown"
		KeyInfo.ExpiresAt = data.expiresAt

		return true
	end

	-- key invalida
	local code = tostring(
		data.code or "VALIDATION_ERROR"
	)

	KeyInfo.Status = code

	warn(
		"[MIRRORS] "
		.. tostring(
			KeyMessages[code] or code
		)
	)

	return false
end

-- deixa o nome do provider bonitinho
local function FormatProvider(provider)
	local names = {
		LOOTLABS = "LootLabs",
		LINKVERTISE = "Linkvertise",
		PROMO = "Promo",
		ADMIN = "Admin",

		lootlabs = "LootLabs",
		linkvertise = "Linkvertise",
		promo = "Promo",
		admin = "Admin"
	}

	return names[provider]
		or provider
		or "Unknown"
end

-- calcula quanto tempo falta pra key acabar
local function RemainingTime(iso)
	if not iso then
		return "Unknown"
	end

	local ok, expires = pcall(
		DateTime.fromIsoDate,
		iso
	)

	if not ok or not expires then
		return "Unknown"
	end

	local seconds = math.floor(
		(
			expires.UnixTimestampMillis
			- DateTime.now().UnixTimestampMillis
		) / 1000
	)

	if seconds <= 0 then
		return "Expired"
	end

	local days = math.floor(seconds / 86400)
	local hours = math.floor((seconds % 86400) / 3600)
	local minutes = math.floor((seconds % 3600) / 60)

	if days > 0 then
		return string.format(
			"%dd %dh %dm",
			days,
			hours,
			minutes
		)
	end

	if hours > 0 then
		return string.format(
			"%dh %dm",
			hours,
			minutes
		)
	end

	return string.format(
		"%dm",
		minutes
	)
end

--// LIMPA O SCRIPT ANTIGO
local Env = getgenv()

if Env.MirrorsMM2Runtime
	and Env.MirrorsMM2Runtime.Cleanup
then
	pcall(
		Env.MirrorsMM2Runtime.Cleanup
	)
end

-- runtime do script
local Runtime = {
	Alive = true,
	Connections = {},
	Cleanups = {},
	Window = nil,

	CurrentConfig = nil,
	CurrentConfigName = "default",

	Notifications = true,
	FPSCap = 0
}

Env.MirrorsMM2Runtime = Runtime

-- salva connections pra limpar dps
local function AddConnection(c)
	if c then
		table.insert(
			Runtime.Connections,
			c
		)
	end

	return c
end

-- salva funções de cleanup
local function AddCleanup(fn)
	if type(fn) == "function" then
		table.insert(
			Runtime.Cleanups,
			fn
		)
	end

	return fn
end

-- notificação
local function Notify(title, content, icon, duration)
	if not Runtime.Notifications then
		return
	end

	pcall(function()
		WindUI:Notify({
			Title = title or "Mirrors Hub",
			Content = content or "",
			Icon = icon,
			Duration = duration or 3
		})
	end)
end

-- copia texto
local function CopyText(text)
	local copy =
		setclipboard
		or toclipboard

	if not copy then
		Notify(
			"Clipboard",
			"Clipboard is not supported by this executor.",
			"x",
			3
		)

		return false
	end

	local ok = pcall(
		copy,
		tostring(text)
	)

	if ok then
		Notify(
			"Mirrors Hub",
			"Copied to clipboard.",
			"copy",
			2
		)
	end

	return ok
end

-- limpa tudo quando executar o script dnv
Runtime.Cleanup = function()
	if not Runtime.Alive then
		return
	end

	Runtime.Alive = false

	for i = #Runtime.Cleanups, 1, -1 do
		pcall(
			Runtime.Cleanups[i]
		)
	end

	for _, c in ipairs(Runtime.Connections) do
		pcall(function()
			c:Disconnect()
		end)
	end

	table.clear(Runtime.Connections)
	table.clear(Runtime.Cleanups)

	pcall(function()
		if Runtime.Window
			and Runtime.Window.Destroy
		then
			Runtime.Window:Destroy()
		end
	end)

	if Env.MirrorsMM2Runtime == Runtime then
		Env.MirrorsMM2Runtime = nil
	end
end

--// WINDOW
local Window = WindUI:CreateWindow({
	Title = "Mirrors Hub - Murder Mystery 2",
	Icon = "door-open",
	Author = "by blackzw.mp3",
	Folder = "MirrorsHub/MM2",

	Size = UDim2.fromOffset(580, 460),
	MinSize = Vector2.new(560, 350),
	MaxSize = Vector2.new(850, 560),

	Transparent = true,
	Theme = "Dark",

	Resizable = true,
	SideBarWidth = 200,

	HideSearchBar = false,
	ScrollBarEnabled = false,

	-- key system da windui
	KeySystem = {
		Title = "Access Required",

		Note = "Get your key from the official Mirrors Hub website.",

		KeyValidator = ValidateKey,

		SaveKey = true,

		URL = "https://mirrorshub-key.vercel.app/api/session",

		Thumbnail = {
			Image = "rbxassetid://132532585504638",
			Title = "Mirrors Hub"
		}
	},

	-- user ali no canto
	User = {
		Enabled = true,
		Anonymous = false,

		Callback = function()
			print("eu eu eu (yo yo yo)")
		end
	}
})

Runtime.Window = Window

-- botão mobile/abrir ui
Window:EditOpenButton({
	Title = "Open Mirrors Hub - MM2",

	Icon = "monitor",

	CornerRadius = UDim.new(
		0,
		16
	),

	StrokeThickness = 2,

	Color = ColorSequence.new(
		Color3.fromHex("8B00FF"),
		Color3.fromHex("430078")
	),

	OnlyMobile = false,

	Enabled = true,
	Draggable = true
})

--// TABS
local InfoTab = Window:Tab({
	Title = "Info",
	Icon = "info"
})

local MainTab = Window:Tab({
	Title = "Main",
	Icon = "house"
})

local VisualsTab = Window:Tab({
	Title = "Visuals",
	Icon = "eye"
})

local CombatTab = Window:Tab({
	Title = "Combat",
	Icon = "crosshair"
})

local PlayerTab = Window:Tab({
	Title = "Player",
	Icon = "user"
})

local SettingsTab = Window:Tab({
	Title = "Settings",
	Icon = "settings"
})

--==================================================
-- INFO
--==================================================

-- infos da rodada
local RoundInfo = {
	Status = "Lobby",
	Mode = "Unknown",

	Murderer = "Unknown",
	Sheriff = "Unknown",
	YourRole = "Unknown",

	Alive = 0,
	Total = 0
}

-- dados reais da rodada q vem do jogo
local RoundData = {}

-- atualiza quantos players tão vivos
local function UpdateRoundPlayers()
	local alive = 0
	local total = 0

	for _, player in ipairs(
		Players:GetPlayers()
	) do
		total += 1

		if player:GetAttribute("Alive") == true then
			alive += 1
		end
	end

	RoundInfo.Alive = alive
	RoundInfo.Total = total
end

-- texto das informações do script
local function GetInformationText()
	return
		"Script: Mirrors Hub | Murder Mystery 2\n" ..
		"Version: Beta 1.6.1\n" ..
		"Developer: blackzw\n" ..
		"Game: Murder Mystery 2\n" ..
		"Status: Operational\n\n" ..

		"Players: "
		.. #Players:GetPlayers()
		.. " / "
		.. Players.MaxPlayers
		.. "\n" ..

		"PlaceId: "
		.. game.PlaceId
		.. "\n" ..

		"JobId: "
		.. game.JobId
end

-- texto das informações da key
local function GetKeyInformationText()
	return
		"Status: "
		.. tostring(KeyInfo.Status)
		.. "\n" ..

		"Provider: "
		.. FormatProvider(KeyInfo.Provider)
		.. "\n" ..

		"Expires In: "
		.. RemainingTime(KeyInfo.ExpiresAt)
		.. "\n" ..

		"Username: "
		.. LP.Name
		.. "\n" ..

		"Display Name: "
		.. LP.DisplayName
		.. "\n" ..

		"User ID: "
		.. LP.UserId
end

-- texto da rodada
local function GetRoundText()
	return
		"Status: "
		.. RoundInfo.Status
		.. "\n" ..

		"Mode: "
		.. RoundInfo.Mode
		.. "\n" ..

		"Murderer: "
		.. RoundInfo.Murderer
		.. "\n" ..

		"Sheriff: "
		.. RoundInfo.Sheriff
		.. "\n" ..

		"Your Role: "
		.. RoundInfo.YourRole
		.. "\n" ..

		"Alive: "
		.. RoundInfo.Alive
		.. " / "
		.. RoundInfo.Total
end

-- infos da conta
local function GetAccountText()
	return
		"Username: "
		.. LP.Name
		.. "\n" ..

		"Display Name: "
		.. LP.DisplayName
		.. "\n" ..

		"Level: "
		.. tostring(
			LP:GetAttribute("Level")
			or "Unknown"
		)
		.. "\n" ..

		"Prestige: "
		.. tostring(
			LP:GetAttribute("Prestige")
			or 0
		)
		.. "\n" ..

		"XP: "
		.. tostring(
			LP:GetAttribute("XP")
			or "Unknown"
		)
end

-- informações gerais
local InformationParagraph = InfoTab:Paragraph({
	Title = "Information",

	Color = Color3.fromRGB(
		134,
		0,
		217
	),

	Desc = GetInformationText()
})

-- informações da key
local KeyInformationParagraph = InfoTab:Paragraph({
	Title = "Key Information",

	Color = Color3.fromRGB(
		134,
		0,
		217
	),

	Desc = GetKeyInformationText()
})

-- informações da rodada
local RoundParagraph = InfoTab:Paragraph({
	Title = "Round Information",

	Color = Color3.fromRGB(
		134,
		0,
		217
	),

	Desc = GetRoundText()
})

-- informações da conta
local AccountParagraph = InfoTab:Paragraph({
	Title = "Account Information",

	Color = Color3.fromRGB(
		134,
		0,
		217
	),

	Desc = GetAccountText()
})

InfoTab:Space()

-- copia o job id
local CopyJobIdButton = InfoTab:Button({
	Title = "Copy Job ID",

	Icon = "copy",
	IconAlign = "Right",

	Color = Color3.fromRGB(
		134,
		0,
		217
	),

	Justify = "Between",

	Callback = function()
		CopyText(game.JobId)
	end
})

-- atualiza os cards
task.spawn(function()
	while Runtime.Alive do
		pcall(function()
			UpdateRoundPlayers()

			InformationParagraph:SetDesc(
				GetInformationText()
			)

			KeyInformationParagraph:SetDesc(
				GetKeyInformationText()
			)

			RoundParagraph:SetDesc(
				GetRoundText()
			)

			AccountParagraph:SetDesc(
				GetAccountText()
			)
		end)

		task.wait(1)
	end
end)

--// TAB INFO TERMINADA

--==================================================
-- ESP
--==================================================

local ESPEnabled = false

local ShowOnlyMurderer = false
local ShowOnlySheriff = false

local ESPObjects = {}

local RoleColors = {
	Murderer = Color3.fromRGB(
		134,
		0,
		217
	), -- roxo mirrors 💜

	Sheriff = Color3.fromRGB(
		0,
		140,
		255
	),

	Innocent = Color3.fromRGB(
		60,
		255,
		100
	),

	Unknown = Color3.fromRGB(
		150,
		150,
		150
	),

	Dead = Color3.fromRGB(
		100,
		100,
		100
	)
}

-- pega o estado atual
local function GetPlayerState(player)
	if player:GetAttribute("Alive") == false then
		return "Dead"
	end

	local info = RoundData[player.Name]

	if not info then
		return "Unknown"
	end

	return info.Role or "Unknown"
end

-- decide se o player aparece
local function ShouldShowPlayer(player)
	if player == LP then
		return false
	end

	if not ESPEnabled then
		return false
	end

	local state = GetPlayerState(player)

	if ShowOnlyMurderer then
		return state == "Murderer"
	end

	if ShowOnlySheriff then
		return state == "Sheriff"
	end

	return true
end

-- remove o esp
local function RemoveESP(player)
	local data = ESPObjects[player]

	if not data then
		return
	end

	if data.Highlight then
		pcall(function()
			data.Highlight:Destroy()
		end)
	end

	if data.Billboard then
		pcall(function()
			data.Billboard:Destroy()
		end)
	end

	ESPObjects[player] = nil
end

-- cria o esp
local function CreateESP(player)
	if player == LP then
		return
	end

	local character = player.Character

	if not character then
		return
	end

	local head =
		character:FindFirstChild("Head")

	if not head then
		return
	end

	RemoveESP(player)

	-- highlight
	local highlight =
		Instance.new("Highlight")

	highlight.Name = "MirrorsESP"

	highlight.Adornee = character

	highlight.DepthMode =
		Enum.HighlightDepthMode.AlwaysOnTop

	highlight.FillTransparency = 0.72
	highlight.OutlineTransparency = 0

	highlight.Parent = character

	-- nome + role
	local billboard =
		Instance.new("BillboardGui")

	billboard.Name = "MirrorsESPInfo"

	billboard.Adornee = head

	billboard.AlwaysOnTop = true

	billboard.Size =
		UDim2.fromOffset(
			180,
			45
		)

	billboard.StudsOffset =
		Vector3.new(
			0,
			2.8,
			0
		)

	billboard.Parent = head

	local text =
		Instance.new("TextLabel")

	text.Name = "Info"

	text.Size =
		UDim2.fromScale(
			1,
			1
		)

	text.BackgroundTransparency = 1

	text.Font =
		Enum.Font.GothamBold

	text.TextSize = 14

	text.TextStrokeTransparency = 0.4
	text.TextWrapped = true

	text.Parent = billboard

	ESPObjects[player] = {
		Highlight = highlight,
		Billboard = billboard,
		Text = text
	}
end

-- atualiza um player
local function UpdateESP(player)
	if not ShouldShowPlayer(player) then
		RemoveESP(player)
		return
	end

	local character = player.Character

	if not character then
		RemoveESP(player)
		return
	end

	local head =
		character:FindFirstChild("Head")

	if not head then
		return
	end

	local data =
		ESPObjects[player]

	if not data then
		CreateESP(player)

		data =
			ESPObjects[player]
	end

	if not data then
		return
	end

	local state =
		GetPlayerState(player)

	local color =
		RoleColors[state]
		or RoleColors.Unknown

	-- atualiza caso respawne
	data.Highlight.Adornee =
		character

	data.Billboard.Adornee =
		head

	data.Highlight.FillColor =
		color

	data.Highlight.OutlineColor =
		color

	data.Text.TextColor3 =
		color

	-- texto
	if state == "Unknown" then
		data.Text.Text =
			player.DisplayName

	elseif state == "Dead" then
		data.Text.Text =
			player.DisplayName
			.. "\n[Dead]"

	else
		data.Text.Text =
			player.DisplayName
			.. "\n["
			.. state
			.. "]"
	end

	-- morto fica mais apagado
	if state == "Dead" then
		data.Highlight.FillTransparency =
			0.9

		data.Highlight.OutlineTransparency =
			0.45

		data.Text.TextTransparency =
			0.45

	else
		data.Highlight.FillTransparency =
			0.72

		data.Highlight.OutlineTransparency =
			0

		data.Text.TextTransparency =
			0
	end
end

-- atualiza geral
local function UpdateAllESP()
	for _, player in ipairs(
		Players:GetPlayers()
	) do
		UpdateESP(player)
	end
end

--// ESP TOGGLES

-- liga/desliga tudo
local ESPToggle = VisualsTab:Toggle({
	Title = "Role ESP",

	Desc = "Shows player roles through walls",

	Default = false,

	Callback = function(value)
		ESPEnabled = value

		if value then
			UpdateAllESP()
		else
			local playersToRemove = {}

			for player in pairs(
				ESPObjects
			) do
				table.insert(
					playersToRemove,
					player
				)
			end

			for _, player in ipairs(
				playersToRemove
			) do
				RemoveESP(player)
			end
		end
	end
})

-- mostra só murderer
local MurdererOnlyToggle =
	VisualsTab:Toggle({
		Title = "Murderer Only",

		Desc = "Shows only the Murderer",

		Default = false,

		Callback = function(value)
			ShowOnlyMurderer = value

			if value then
				ShowOnlySheriff = false
			end

			if ESPEnabled then
				UpdateAllESP()
			end
		end
	})

-- mostra só sheriff
local SheriffOnlyToggle =
	VisualsTab:Toggle({
		Title = "Sheriff Only",

		Desc = "Shows only the Sheriff",

		Default = false,

		Callback = function(value)
			ShowOnlySheriff = value

			if value then
				ShowOnlyMurderer = false
			end

			if ESPEnabled then
				UpdateAllESP()
			end
		end
	})

--==================================================
-- ROUND EVENTS
--==================================================

-- começou a carregar o mapa
AddConnection(
	Gameplay.LoadingMap.OnClientEvent:Connect(
		function(mode)
			RoundInfo.Status = "Loading"

			RoundInfo.Mode =
				tostring(
					mode
					or "Unknown"
				)

			RoundInfo.Murderer = "Unknown"
			RoundInfo.Sheriff = "Unknown"
			RoundInfo.YourRole = "Unknown"

			table.clear(RoundData)

			UpdateRoundPlayers()

			if ESPEnabled then
				UpdateAllESP()
			end
		end
	)
)

-- recebe os roles reais
AddConnection(
	Gameplay.Fade.OnClientEvent:Connect(
		function(data)
			if type(data) ~= "table" then
				return
			end

			table.clear(RoundData)

			RoundInfo.Status = "Playing"

			RoundInfo.Murderer =
				"Unknown"

			RoundInfo.Sheriff =
				"Unknown"

			for playerName, info in pairs(data) do
				if type(info) == "table" then
					RoundData[playerName] = {
						Role =
							info.Role
							or "Unknown",

						Dead =
							info.Dead
							== true,

						Killed =
							info.Killed
							== true,

						UserId =
							info.UserId
					}

					if info.Role == "Murderer" then
						RoundInfo.Murderer =
							playerName

					elseif info.Role == "Sheriff" then
						RoundInfo.Sheriff =
							playerName
					end

					if playerName == LP.Name then
						RoundInfo.YourRole =
							info.Role
							or "Unknown"
					end
				end
			end

			UpdateRoundPlayers()

			if ESPEnabled then
				UpdateAllESP()
			end
		end
	)
)

-- pega seu role pelo roleselect tbm
AddConnection(
	Gameplay.RoleSelect.OnClientEvent:Connect(
		function(role)
			RoundInfo.YourRole =
				tostring(
					role
					or "Unknown"
				)
		end
	)
)

-- fim da rodada
AddConnection(
	Gameplay.VictoryScreen.OnClientEvent:Connect(
		function()
			RoundInfo.Status =
				"Finished"

			table.clear(RoundData)

			if ESPEnabled then
				UpdateAllESP()
			end

			-- volta pro estado de lobby dps
			task.delay(3, function()
				if not Runtime.Alive then
					return
				end

				RoundInfo.Status =
					"Lobby"

				RoundInfo.Mode =
					"Unknown"

				RoundInfo.Murderer =
					"Unknown"

				RoundInfo.Sheriff =
					"Unknown"

				RoundInfo.YourRole =
					"Unknown"

				UpdateRoundPlayers()

				if ESPEnabled then
					UpdateAllESP()
				end
			end)
		end
	)
)

--==================================================
-- PLAYER EVENTS
--==================================================


-- configura cada player
local function SetupPlayer(player)
	-- atualiza quando morre/revive
	AddConnection(
		player:GetAttributeChangedSignal(
			"Alive"
		):Connect(function()
			UpdateRoundPlayers()

			if ESPEnabled then
				UpdateESP(player)
			end
		end)
	)

	-- atualiza quando respawna
	AddConnection(
		player.CharacterAdded:Connect(
			function()
				task.wait(0.25)

				RemoveESP(player)

				if ESPEnabled then
					UpdateESP(player)
				end
			end
		)
	)
end

-- players q já tão no server
for _, player in ipairs(
	Players:GetPlayers()
) do
	SetupPlayer(player)
end

-- player entrou
AddConnection(
	Players.PlayerAdded:Connect(
		function(player)
			SetupPlayer(player)

			UpdateRoundPlayers()

			task.wait(0.25)

			if ESPEnabled then
				UpdateESP(player)
			end
		end
	)
)

-- player saiu
AddConnection(
	Players.PlayerRemoving:Connect(
		function(player)
			RoundData[player.Name] = nil

			RemoveESP(player)

			task.defer(
				UpdateRoundPlayers
			)
		end
	)
)

--==================================================
-- CLEANUP DO ESP
--==================================================

AddCleanup(function()
	local playersToRemove = {}

	for player in pairs(
		ESPObjects
	) do
		table.insert(
			playersToRemove,
			player
		)
	end

	for _, player in ipairs(
		playersToRemove
	) do
		RemoveESP(player)
	end

	table.clear(RoundData)
end)
