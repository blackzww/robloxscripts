--==================================================
-- MIRRORS HUB - MURDER MYSTERY 2
-- by blackzw
--==================================================

--// SERVICES
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Workspace = game:GetService("Workspace")

local LP = Players.LocalPlayer

--// MM2
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Gameplay = Remotes:WaitForChild("Gameplay")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local ClientServices = ReplicatedStorage:WaitForChild("ClientServices")

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

--==================================================
-- KEY SYSTEM
--==================================================

local API = "https://mirrorshub-key.vercel.app/api/key/validate"

-- guarda as infos da key
local KeyInfo = {
	Status = "Unknown",
	Provider = "Unknown",
	ExpiresAt = nil
}

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
	local fn = identifyexecutor or getexecutorname

	if fn then
		local ok, name = pcall(fn)

		if ok and name then
			return tostring(name)
		end
	end

	return "Unknown"
end

-- pega o hwid
local function GetHWID()
	if gethwid then
		local ok, hwid = pcall(gethwid)

		if ok and hwid then
			hwid = tostring(hwid)

			if #hwid >= 8 and #hwid <= 256 then
				return hwid
			end
		end
	end

	-- fallback
	local ok, hwid = pcall(function()
		return game:GetService("RbxAnalyticsService"):GetClientId()
	end)

	if ok and hwid then
		hwid = tostring(hwid)

		if #hwid >= 8 and #hwid <= 256 then
			return hwid
		end
	end

	return nil
end

-- valida a key
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

	local decoded, data = pcall(
		HttpService.JSONDecode,
		HttpService,
		raw
	)

	if not decoded or type(data) ~= "table" then
		warn("[MIRRORS] Invalid server response.")
		return false
	end

	if data.valid == true then
		KeyInfo.Status = "Active"
		KeyInfo.Provider = data.provider or "Unknown"
		KeyInfo.ExpiresAt = data.expiresAt

		return true
	end

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

-- deixa o provider bonito
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

-- tempo da key
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

	local d = math.floor(seconds / 86400)
	local h = math.floor(seconds % 86400 / 3600)
	local m = math.floor(seconds % 3600 / 60)

	if d > 0 then
		return string.format("%dd %dh %dm", d, h, m)
	elseif h > 0 then
		return string.format("%dh %dm", h, m)
	end

	return string.format("%dm", m)
end

--==================================================
-- RUNTIME
--==================================================

local Env = getgenv()

-- limpa a execução antiga
if Env.MirrorsMM2Runtime
	and Env.MirrorsMM2Runtime.Cleanup
then
	pcall(
		Env.MirrorsMM2Runtime.Cleanup
	)
end

local Runtime = {
	Alive = true,
	Connections = {},
	Cleanups = {},
	Window = nil,
	Notifications = true
}

Env.MirrorsMM2Runtime = Runtime

-- salva connection
local function AddConnection(connection)
	if connection then
		table.insert(
			Runtime.Connections,
			connection
		)
	end

	return connection
end

-- salva cleanup
local function AddCleanup(callback)
	if type(callback) == "function" then
		table.insert(
			Runtime.Cleanups,
			callback
		)
	end
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
			"Clipboard is not supported.",
			"x"
		)

		return
	end

	if pcall(copy, tostring(text)) then
		Notify(
			"Mirrors Hub",
			"Copied to clipboard.",
			"copy",
			2
		)
	end
end

--==================================================
-- MM2 MODULES
--==================================================

-- require protegido pra n quebrar o script todo
local function SafeRequire(object)
	if not object then
		return nil
	end

	local ok, result =
		pcall(require, object)

	if ok then
		return result
	end

	return nil
end

-- módulos q achamos no dump
local CurrentRound = SafeRequire(
	Modules:FindFirstChild("CurrentRoundClient")
)

local LevelModule = SafeRequire(
	Modules:FindFirstChild("LevelModule")
)

local PerkService = SafeRequire(
	ClientServices:FindFirstChild("PerkService")
)

--==================================================
-- ROUND DATA
--==================================================

local RoundData = {}

local RoundInfo = {
	Status = "Lobby",
	Mode = "Unknown",

	Winner = "Unknown",
	Reason = "Unknown",

	LocalRole = "Unknown"
}

-- pega info do player
local function GetPlayerRoundData(player)
	return RoundData[player.Name]
end

-- pega role
local function GetRole(player)
	local info =
		GetPlayerRoundData(player)

	return info
		and info.Role
		or "Unknown"
end

-- vê se morreu
local function IsDead(player)
	local info =
		GetPlayerRoundData(player)

	if info and (
		info.Dead == true
		or info.Killed == true
	) then
		return true
	end

	return player:GetAttribute("Alive") == false
end

-- atualiza os dados da rodada
local function SetRoundData(data)
	if type(data) ~= "table" then
		return
	end

	table.clear(RoundData)

	for name, info in pairs(data) do
		if type(name) == "string"
			and type(info) == "table"
		then
			RoundData[name] = info
		end
	end
end

-- tenta pegar a tabela inicial
if CurrentRound then
	local data

	if type(CurrentRound.GetLatestPlayerData) == "function" then
		local ok, result =
			pcall(
				CurrentRound.GetLatestPlayerData
			)

		if ok then
			data = result
		end
	end

	data =
		data
		or CurrentRound.PlayerData

	if type(data) == "table" then
		SetRoundData(data)
	end
end

--==================================================
-- ROUND HELPERS
--==================================================

-- pega murderer e sheriff
local function GetRolePlayers()
	local murderer = "Unknown"
	local sheriff = "Unknown"

	for name, info in pairs(RoundData) do
		if info.Role == "Murderer" then
			murderer = name

		elseif info.Role == "Sheriff" then
			sheriff = name
		end
	end

	return murderer, sheriff
end

-- vivos da rodada
local function GetAlive()
	local alive = 0
	local total = 0

	for name, info in pairs(RoundData) do
		local player =
			Players:FindFirstChild(name)

		if player then
			total += 1

			if info.Dead ~= true
				and info.Killed ~= true
				and player:GetAttribute("Alive") ~= false
			then
				alive += 1
			end
		end
	end

	return alive, total
end

-- pega o timer q o próprio mapa mostra
local function GetRoundTimer()
	local part =
		Workspace:FindFirstChild(
			"RoundTimerPart"
		)

	if not part then
		return "--:--"
	end

	local gui =
		part:FindFirstChild(
			"SurfaceGui"
		)

	local timer =
		gui
		and gui:FindFirstChild(
			"Timer"
		)

	if timer
		and timer:IsA("TextLabel")
		and timer.Text ~= ""
	then
		return timer.Text
	end

	return "--:--"
end

-- conta coins q tão aparecendo
local function GetVisibleCoins()
	local ok, coins = pcall(
		CollectionService.GetTagged,
		CollectionService,
		"CoinVisual"
	)

	if ok and type(coins) == "table" then
		return #coins
	end

	return 0
end

-- pega quem estamos spectando
local function GetSpectating()
	local camera =
		Workspace.CurrentCamera

	local subject =
		camera
		and camera.CameraSubject

	if not subject then
		return "None"
	end

	local character =
		subject:IsA("Humanoid")
		and subject.Parent
		or subject:FindFirstAncestorOfClass("Model")

	local player =
		character
		and Players:GetPlayerFromCharacter(
			character
		)

	if player and player ~= LP then
		return player.Name
	end

	return "None"
end

-- perk equipado
local function GetPerk()
	if PerkService
		and type(
			PerkService.GetEquippedPerk
		) == "function"
	then
		local ok, perk = pcall(
			PerkService.GetEquippedPerk,
			PerkService
		)

		if ok and perk then
			return tostring(perk)
		end
	end

	return tostring(
		LP:GetAttribute("EquippedPerk")
		or "Unknown"
	)
end

-- perk do murderer
local function GetMurdererPerk()
	if CurrentRound
		and type(
			CurrentRound.GetMurdererPerk
		) == "function"
	then
		local ok, perk = pcall(
			CurrentRound.GetMurdererPerk
		)

		if ok and perk then
			return tostring(perk)
		end
	end

	for _, info in pairs(RoundData) do
		if info.Role == "Murderer" then
			return tostring(
				info.Perk
				or "Unknown"
			)
		end
	end

	return "Unknown"
end

--==================================================
-- LEVEL / XP
--==================================================

local function GetLevelData()
	local xp =
		tonumber(
			LP:GetAttribute("XP")
		)
		or 0

	local level =
		tonumber(
			LP:GetAttribute("Level")
		)

	-- fallback usando o módulo do jogo
	if not level
		and LevelModule
		and type(LevelModule.GetLevel) == "function"
	then
		local ok, result =
			pcall(
				LevelModule.GetLevel,
				xp
			)

		if ok then
			level =
				tonumber(result)
		end
	end

	level = level or 1

	local progress = nil

	-- calcula usando a tabela real do jogo
	if LevelModule
		and type(LevelModule.GetXP) == "function"
		and level < 100
	then
		local ok1, currentXP =
			pcall(
				LevelModule.GetXP,
				level
			)

		local ok2, nextXP =
			pcall(
				LevelModule.GetXP,
				level + 1
			)

		currentXP =
			ok1
			and tonumber(currentXP)

		nextXP =
			ok2
			and tonumber(nextXP)

		if currentXP
			and nextXP
			and nextXP > currentXP
		then
			progress = math.clamp(
				(
					xp - currentXP
				)
				/
				(
					nextXP - currentXP
				)
				* 100,
				0,
				100
			)
		end
	end

	return level, xp, progress
end

--==================================================
-- WINDOW
--==================================================

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

	KeySystem = {
		Title = "Access Required",

		Note =
			"Get your key from the official Mirrors Hub website.",

		KeyValidator = ValidateKey,

		SaveKey = true,

		URL =
			"https://mirrorshub-key.vercel.app/api/session",

		Thumbnail = {
			Image =
				"rbxassetid://132532585504638",

			Title =
				"Mirrors Hub"
		}
	},

	User = {
		Enabled = true,
		Anonymous = false,

		Callback = function()
			print("eu eu eu (yo yo yo)")
		end
	}
})

Runtime.Window = Window

-- botão pra abrir
Window:EditOpenButton({
	Title = "Open Mirrors Hub - MM2",
	Icon = "monitor",

	CornerRadius =
		UDim.new(0, 16),

	StrokeThickness = 2,

	Color = ColorSequence.new(
		Color3.fromHex("8B00FF"),
		Color3.fromHex("430078")
	),

	OnlyMobile = false,
	Enabled = true,
	Draggable = true
})

--==================================================
-- TABS
--==================================================

local InfoTab =
	Window:Tab({
		Title = "Info",
		Icon = "info"
	})

local MainTab =
	Window:Tab({
		Title = "Main",
		Icon = "house"
	})

local VisualsTab =
	Window:Tab({
		Title = "Visuals",
		Icon = "eye"
	})

local CombatTab =
	Window:Tab({
		Title = "Combat",
		Icon = "crosshair"
	})

local PlayerTab =
	Window:Tab({
		Title = "Player",
		Icon = "user"
	})

local SettingsTab =
	Window:Tab({
		Title = "Settings",
		Icon = "settings"
	})

--==================================================
-- INFO
--==================================================

local Purple =
	Color3.fromRGB(
		134,
		0,
		217
	)

-- geral
local function GetInformationText()
	return
		"Script: Mirrors Hub | Murder Mystery 2\n" ..
		"Version: Beta 1.6.1\n" ..
		"Developer: blackzw\n" ..
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

-- key
local function GetKeyText()
	return
		"Status: "
		.. tostring(KeyInfo.Status)
		.. "\n" ..

		"Provider: "
		.. FormatProvider(
			KeyInfo.Provider
		)
		.. "\n" ..

		"Expires In: "
		.. RemainingTime(
			KeyInfo.ExpiresAt
		)
end

-- rodada
local function GetRoundText()
	local murderer, sheriff =
		GetRolePlayers()

	local alive, total =
		GetAlive()

	local own =
		GetRole(LP)

	if own == "Unknown" then
		own =
			RoundInfo.LocalRole
	end

	local text =
		"Status: "
		.. RoundInfo.Status
		.. "\n" ..

		"Mode: "
		.. RoundInfo.Mode
		.. "\n" ..

		"Time Left: "
		.. GetRoundTimer()
		.. "\n\n" ..

		"Murderer: "
		.. murderer
		.. "\n" ..

		"Sheriff: "
		.. sheriff
		.. "\n" ..

		"Your Role: "
		.. own
		.. "\n" ..

		"Murderer Perk: "
		.. GetMurdererPerk()
		.. "\n" ..

		"Alive: "
		.. alive
		.. " / "
		.. total
		.. "\n" ..

		"Coins Visible: "
		.. GetVisibleCoins()

	if RoundInfo.Status == "Finished" then
		text ..=
			"\n\nWinner: "
			.. RoundInfo.Winner
			.. "\nReason: "
			.. RoundInfo.Reason
	end

	return text
end

-- conta
local function GetAccountText()
	local level, xp, progress =
		GetLevelData()

	local progressText =
		progress
		and string.format(
			"%.1f%%",
			progress
		)
		or "Max / Unknown"

	return
		"Username: "
		.. LP.Name
		.. "\n" ..

		"Display Name: "
		.. LP.DisplayName
		.. "\n" ..

		"User ID: "
		.. LP.UserId
		.. "\n\n" ..

		"Level: "
		.. level
		.. "\n" ..

		"Prestige: "
		.. tostring(
			LP:GetAttribute("Prestige")
			or 0
		)
		.. "\n" ..

		"XP: "
		.. tostring(xp)
		.. "\n" ..

		"Next Level: "
		.. progressText
		.. "\n\n" ..

		"Perk: "
		.. GetPerk()
		.. "\n" ..

		"Spectating: "
		.. GetSpectating()
end

local InformationParagraph =
	InfoTab:Paragraph({
		Title = "Information",
		Color = Purple,
		Desc = GetInformationText()
	})

local KeyParagraph =
	InfoTab:Paragraph({
		Title = "Key Information",
		Color = Purple,
		Desc = GetKeyText()
	})

local RoundParagraph =
	InfoTab:Paragraph({
		Title = "Round Information",
		Color = Purple,
		Desc = GetRoundText()
	})

local AccountParagraph =
	InfoTab:Paragraph({
		Title = "Account Information",
		Color = Purple,
		Desc = GetAccountText()
	})

InfoTab:Space()

InfoTab:Button({
	Title = "Copy Job ID",
	Icon = "copy",
	IconAlign = "Right",

	Color = Purple,
	Justify = "Between",

	Callback = function()
		CopyText(game.JobId)
	end
})

-- atualiza os cards
task.spawn(function()
	while Runtime.Alive do
		pcall(function()
			InformationParagraph:SetDesc(
				GetInformationText()
			)

			KeyParagraph:SetDesc(
				GetKeyText()
			)

			RoundParagraph:SetDesc(
				GetRoundText()
			)

			AccountParagraph:SetDesc(
				GetAccountText()
			)
		end)

		task.wait(0.75)
	end
end)

--==================================================
-- ESP
--==================================================

local ESP = {
	Enabled = false,

	Filter = "All",

	ShowDistance = true,
	ShowDead = true,

	Objects = {}
}

-- cores dos roles
local RoleColors = {
	Murderer = Color3.fromRGB(134, 0, 217),
	Sheriff = Color3.fromRGB(35, 145, 255),
	Innocent = Color3.fromRGB(55, 225, 105),

	Survivor = Color3.fromRGB(35, 145, 255),
	Zombie = Color3.fromRGB(45, 160, 70),

	Freezer = Color3.fromRGB(150, 220, 250),
	Runner = Color3.fromRGB(0, 200, 100),

	Red = Color3.fromRGB(255, 75, 75),
	Blue = Color3.fromRGB(75, 145, 255),

	Dead = Color3.fromRGB(105, 105, 115),
	Unknown = Color3.fromRGB(155, 155, 165)
}

-- estado do player
local function GetESPState(player)
	if IsDead(player) then
		return "Dead"
	end

	return GetRole(player)
end

-- filtro
local function ShouldShowESP(player)
	if player == LP
		or not ESP.Enabled
	then
		return false
	end

	local state =
		GetESPState(player)

	if state == "Dead"
		and not ESP.ShowDead
	then
		return false
	end

	if ESP.Filter == "All" then
		return true
	end

	if ESP.Filter == "Alive" then
		return state ~= "Dead"
	end

	return state == ESP.Filter
end

-- remove um
local function RemoveESP(player)
	local data =
		ESP.Objects[player]

	if not data then
		return
	end

	pcall(function()
		data.Highlight:Destroy()
	end)

	pcall(function()
		data.Gui:Destroy()
	end)

	ESP.Objects[player] = nil
end

-- limpa tudo
local function RemoveAllESP()
	for _, data in pairs(
		ESP.Objects
	) do
		pcall(function()
			data.Highlight:Destroy()
		end)

		pcall(function()
			data.Gui:Destroy()
		end)
	end

	table.clear(
		ESP.Objects
	)
end

-- cria
local function CreateESP(player)
	local char =
		player.Character

	local head =
		char
		and char:FindFirstChild(
			"Head"
		)

	if not char or not head then
		return
	end

	RemoveESP(player)

	-- highlight
	local highlight =
		Instance.new("Highlight")

	highlight.Name =
		"MirrorsESP"

	highlight.Adornee =
		char

	highlight.DepthMode =
		Enum.HighlightDepthMode.AlwaysOnTop

	highlight.FillTransparency =
		0.9

	highlight.OutlineTransparency =
		0

	highlight.Parent =
		char

	-- texto
	local gui =
		Instance.new("BillboardGui")

	gui.Name =
		"MirrorsESPInfo"

	gui.Adornee =
		head

	gui.Size =
		UDim2.fromOffset(
			210,
			35
		)

	gui.StudsOffset =
		Vector3.new(
			0,
			2.8,
			0
		)

	gui.AlwaysOnTop =
		true

	gui.MaxDistance =
		600

	gui.Parent =
		head

	local text =
		Instance.new("TextLabel")

	text.Size =
		UDim2.fromScale(1, 1)

	text.BackgroundTransparency =
		1

	text.Font =
		Enum.Font.GothamBold

	text.TextSize =
		13

	text.TextStrokeTransparency =
		0.3

	text.Parent =
		gui

	ESP.Objects[player] = {
		Highlight = highlight,
		Gui = gui,
		Text = text
	}
end

-- atualiza um
local function UpdateESP(player)
	if not ShouldShowESP(player) then
		RemoveESP(player)
		return
	end

	local char =
		player.Character

	local root =
		char
		and char:FindFirstChild(
			"HumanoidRootPart"
		)

	local head =
		char
		and char:FindFirstChild(
			"Head"
		)

	if not char
		or not root
		or not head
	then
		RemoveESP(player)
		return
	end

	if not ESP.Objects[player] then
		CreateESP(player)
	end

	local data =
		ESP.Objects[player]

	if not data then
		return
	end

	local state =
		GetESPState(player)

	local color =
		RoleColors[state]
		or RoleColors.Unknown

	data.Highlight.Adornee =
		char

	data.Gui.Adornee =
		head

	data.Highlight.FillColor =
		color

	data.Highlight.OutlineColor =
		color

	data.Text.TextColor3 =
		color

	-- distância
	local distanceText = ""

	if ESP.ShowDistance then
		local myRoot =
			LP.Character
			and LP.Character:FindFirstChild(
				"HumanoidRootPart"
			)

		if myRoot then
			local distance =
				math.floor(
					(
						root.Position
						- myRoot.Position
					).Magnitude
				)

			distanceText =
				" • "
				.. distance
				.. " studs"
		end
	end

	-- lobby fica mais clean
	if state == "Unknown" then
		data.Text.Text =
			player.DisplayName
			.. distanceText
	else
		data.Text.Text =
			player.DisplayName
			.. " ["
			.. state
			.. "]"
			.. distanceText
	end

	-- morto fica apagado
	if state == "Dead" then
		data.Highlight.FillTransparency =
			0.96

		data.Highlight.OutlineTransparency =
			0.45

		data.Text.TextTransparency =
			0.4
	else
		data.Highlight.FillTransparency =
			0.9

		data.Highlight.OutlineTransparency =
			0

		data.Text.TextTransparency =
			0
	end
end

-- atualiza todos
local function UpdateAllESP()
	if not ESP.Enabled then
		return
	end

	for _, player in ipairs(
		Players:GetPlayers()
	) do
		UpdateESP(player)
	end
end

--==================================================
-- ESP UI
--==================================================

VisualsTab:Paragraph({
	Title = "Role ESP",

	Desc =
		"Real-time MM2 role information.",

	Color = Purple
})

VisualsTab:Toggle({
	Title = "Enable ESP",

	Desc =
		"Shows players through walls",

	Value = false,

	Callback = function(value)
		ESP.Enabled = value

		if value then
			UpdateAllESP()
		else
			RemoveAllESP()
		end
	end
})

-- um filtro só, sem 2 toggle brigando
VisualsTab:Dropdown({
	Title = "Role Filter",

	Desc =
		"Choose which players appear",

	Values = {
		"All",
		"Alive",
		"Murderer",
		"Sheriff",
		"Innocent"
	},

	Value = "All",

	Callback = function(value)
		ESP.Filter =
			value or "All"

		if ESP.Enabled then
			UpdateAllESP()
		end
	end
})

VisualsTab:Toggle({
	Title = "Show Distance",

	Value = true,

	Callback = function(value)
		ESP.ShowDistance =
			value == true

		if ESP.Enabled then
			UpdateAllESP()
		end
	end
})

VisualsTab:Toggle({
	Title = "Show Dead Players",

	Value = true,

	Callback = function(value)
		ESP.ShowDead =
			value == true

		if ESP.Enabled then
			UpdateAllESP()
		end
	end
})

-- distância precisa atualizar enquanto o player anda
task.spawn(function()
	while Runtime.Alive do
		if ESP.Enabled then
			UpdateAllESP()
		end

		task.wait(0.25)
	end
end)

--==================================================
-- ROUND EVENTS
--==================================================

-- fonte principal do jogo
if CurrentRound
	and CurrentRound.PlayerDataChanged
	and CurrentRound.PlayerDataChanged:IsA(
		"BindableEvent"
	)
then
	AddConnection(
		CurrentRound.PlayerDataChanged.Event:Connect(
			function()
				SetRoundData(
					CurrentRound.PlayerData
				)

				if next(RoundData) then
					RoundInfo.Status =
						"Playing"
				end

				UpdateAllESP()
			end
		)
	)
else
	-- fallback caso o módulo mude
	AddConnection(
		Gameplay.PlayerDataChanged.OnClientEvent:Connect(
			function(data)
				SetRoundData(data)

				if next(RoundData) then
					RoundInfo.Status =
						"Playing"
				end

				UpdateAllESP()
			end
		)
	)
end

-- loading
AddConnection(
	Gameplay.LoadingMap.OnClientEvent:Connect(
		function(mode)
			RoundInfo.Status =
				"Loading"

			RoundInfo.Mode =
				tostring(
					mode
					or "Unknown"
				)

			RoundInfo.Winner =
				"Unknown"

			RoundInfo.Reason =
				"Unknown"

			RoundInfo.LocalRole =
				"Unknown"

			table.clear(
				RoundData
			)

			UpdateAllESP()
		end
	)
)

-- round começou
AddConnection(
	Gameplay.RoundStart.OnClientEvent:Connect(
		function()
			RoundInfo.Status =
				"Playing"
		end
	)
)

-- pega nosso role + mode
AddConnection(
	Gameplay.RoleSelect.OnClientEvent:Connect(
		function(role, _, _, _, mode)
			RoundInfo.LocalRole =
				tostring(
					role
					or "Unknown"
				)

			if mode then
				RoundInfo.Mode =
					tostring(mode)
			end
		end
	)
)

-- fallback do começo da rodada
AddConnection(
	Gameplay.Fade.OnClientEvent:Connect(
		function(data)
			if type(data) == "table"
				and not next(RoundData)
			then
				SetRoundData(data)
				UpdateAllESP()
			end
		end
	)
)

-- fim da rodada
AddConnection(
	Gameplay.VictoryScreen.OnClientEvent:Connect(
		function(_, winner, reason)
			RoundInfo.Status =
				"Finished"

			RoundInfo.Winner =
				tostring(
					winner
					or "Unknown"
				)

			RoundInfo.Reason =
				tostring(
					reason
					or "Unknown"
				)

			UpdateAllESP()
		end
	)
)

-- terminou o fade final
AddConnection(
	Gameplay.RoundEndFade.OnClientEvent:Connect(
		function()
			task.delay(2.5, function()
				if not Runtime.Alive
					or RoundInfo.Status ~= "Finished"
				then
					return
				end

				RoundInfo.Status =
					"Lobby"

				RoundInfo.Winner =
					"Unknown"

				RoundInfo.Reason =
					"Unknown"

				RoundInfo.LocalRole =
					"Unknown"

				table.clear(
					RoundData
				)

				UpdateAllESP()
			end)
		end
	)
)

--==================================================
-- PLAYER EVENTS
--==================================================

local function SetupPlayer(player)
	if player == LP then
		return
	end

	-- morreu/reviveu
	AddConnection(
		player:GetAttributeChangedSignal(
			"Alive"
		):Connect(function()
			UpdateESP(player)
		end)
	)

	-- respawn
	AddConnection(
		player.CharacterAdded:Connect(
			function()
				RemoveESP(player)

				task.wait(0.2)

				UpdateESP(player)
			end
		)
	)
end

for _, player in ipairs(
	Players:GetPlayers()
) do
	SetupPlayer(player)
end

AddConnection(
	Players.PlayerAdded:Connect(
		function(player)
			SetupPlayer(player)
		end
	)
)

AddConnection(
	Players.PlayerRemoving:Connect(
		function(player)
			RoundData[player.Name] =
				nil

			RemoveESP(player)
		end
	)
)

--==================================================
-- SETTINGS
--==================================================

SettingsTab:Toggle({
	Title = "Notifications",

	Desc =
		"Enable Mirrors Hub notifications",

	Value = true,

	Callback = function(value)
		Runtime.Notifications =
			value == true
	end
})

SettingsTab:Button({
	Title = "Copy Job ID",
	Icon = "copy",

	Callback = function()
		CopyText(game.JobId)
	end
})

--==================================================
-- CLEANUP
--==================================================

AddCleanup(function()
	RemoveAllESP()

	table.clear(
		RoundData
	)
end)

Runtime.Cleanup = function()
	if not Runtime.Alive then
		return
	end

	Runtime.Alive = false

	-- cleanup
	for i = #Runtime.Cleanups, 1, -1 do
		pcall(
			Runtime.Cleanups[i]
		)
	end

	-- connections
	for _, connection in ipairs(
		Runtime.Connections
	) do
		pcall(function()
			connection:Disconnect()
		end)
	end

	table.clear(
		Runtime.Connections
	)

	table.clear(
		Runtime.Cleanups
	)

	-- ui
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

--// MIRRORS HUB MM2 CARREGADO
