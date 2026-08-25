--==================================================
-- MIRRORS HUB - [FPS] FLICK
-- CLEANED / REWORKED VERSION
--==================================================

local WindUI = loadstring(game:HttpGet(
	"https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

--==================================================
-- SERVICES
--==================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

--==================================================
-- RUNTIME / RE-EXECUTION PROTECTION
--==================================================

local Environment = getgenv()

if Environment.MirrorsFlickRuntime
	and Environment.MirrorsFlickRuntime.Cleanup then

	pcall(Environment.MirrorsFlickRuntime.Cleanup)
end

local Runtime = {
	Alive = true,
	Connections = {},
	Window = nil
}

Environment.MirrorsFlickRuntime = Runtime

local function AddConnection(connection)
	table.insert(Runtime.Connections, connection)
	return connection
end

--==================================================
-- WINDOW
--==================================================

local Window = WindUI:CreateWindow({
	Title = "Mirrors Hub - [FPS] Flick",
	Icon = "door-open",
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
		Anonymous = false
	}
})

Runtime.Window = Window

Window:Tag({
	Title = "v1.1.0",
	Color = Color3.fromHex("00FF66"),
	Radius = 13
})

Window:SetToggleKey(Enum.KeyCode.K)

Window:EditOpenButton({
	Title = "Open Mirrors Hub - [FPS] Flick",

	Icon = "monitor",

	CornerRadius = UDim.new(0, 16),
	StrokeThickness = 2,

	Color = ColorSequence.new(
		Color3.fromHex("7B00FF"),
		Color3.fromHex("3C007D")
	),

	OnlyMobile = false,
	Enabled = true,
	Draggable = true
})

--==================================================
-- TABS
--==================================================

local Info = Window:Tab({
	Title = "Info",
	Icon = "info"
})

local Main = Window:Tab({
	Title = "Main",
	Icon = "house"
})

local Esp = Window:Tab({
	Title = "Esp",
	Icon = "eye"
})

local Misc = Window:Tab({
	Title = "Misc",
	Icon = "layers"
})

local Config = Window:Tab({
	Title = "Config",
	Icon = "cog"
})

Info:Select()

--==================================================
-- INFO
--==================================================

Info:Paragraph({
	Title = "Mirrors Hub - [FPS] Flick",

	Desc =
		"Script feito por blackzw.mp3\n" ..
		"Entre no Discord para atualizações, suporte e bugs!",

	Image = "info",
	ImageSize = 24,

	Thumbnail = "rbxassetid://91587269886962",
	ThumbnailSize = 70,

	Buttons = {
		{
			Title = "Entrar no Discord",
			Icon = "message-circle",

			Callback = function()
				local Copy = setclipboard or toclipboard

				if Copy then
					Copy("https://discord.gg/YZEg6FyRSF")

					WindUI:Notify({
						Title = "Discord",
						Content = "Convite copiado!",
						Duration = 3
					})
				end
			end
		}
	}
})

--==================================================
-- SERVER INFO
--==================================================

local JoinTime = os.time()
local ServerInfo

local function FormatTime(seconds)
	local hours = math.floor(seconds / 3600)
	local minutes = math.floor((seconds % 3600) / 60)
	local secs = seconds % 60

	return string.format(
		"%02d:%02d:%02d",
		hours,
		minutes,
		secs
	)
end

local function GetPing()
	local success, result = pcall(function()
		return Stats.Network.ServerStatsItem[
			"Data Ping"
		]:GetValue()
	end)

	if success then
		return math.floor(result)
	end

	return 0
end

local function UpdateStatus()
	if not Runtime.Alive or not ServerInfo then
		return
	end

	ServerInfo:SetDesc(string.format(
		"👥 Jogadores: %d / %d\n" ..
		"📶 Ping: %d ms\n" ..
		"⏱️ Tempo no servidor: %s\n" ..
		"🧑 Nome: %s (@%s)\n" ..
		"🎂 Conta criada há: %d dias\n" ..
		"🖥️ PlaceId: %s\n" ..
		"🔑 JobId: %s",

		#Players:GetPlayers(),
		Players.MaxPlayers,

		GetPing(),

		FormatTime(
			os.time() - JoinTime
		),

		LocalPlayer.DisplayName,
		LocalPlayer.Name,
		LocalPlayer.AccountAge,

		tostring(game.PlaceId),
		tostring(game.JobId)
	))
end

ServerInfo = Info:Paragraph({
	Title = "Informações do Servidor",
	Desc = "Carregando..."
})

UpdateStatus()

task.spawn(function()
	while Runtime.Alive do
		task.wait(5)

		if Runtime.Alive then
			pcall(UpdateStatus)
		end
	end
end)

Info:Space()

Info:Button({
	Title = "Copiar Job ID",

	Color = Color3.fromHex("#a2ff30"),

	Justify = "Center",

	IconAlign = "Left",
	Icon = "clipboard-copy",

	Callback = function()
		local Copy = setclipboard or toclipboard

		if not Copy then
			WindUI:Notify({
				Title = "Erro",
				Content = "Clipboard não suportado.",
				Duration = 3
			})

			return
		end

		Copy(game.JobId)

		WindUI:Notify({
			Title = "Copiado!",
			Content = "Job ID copiado.",
			Duration = 3
		})
	end
})

--==================================================
-- MODULES
--==================================================

local GunModules =
	ReplicatedStorage
		:WaitForChild("ModuleScripts")
		:WaitForChild("GunModules")

local BulletHandler =
	require(
		GunModules:WaitForChild("BulletHandler")
	)

local SignalManager =
	require(
		ReplicatedStorage
			:WaitForChild("SignalManager")
	)

--==================================================
-- SETTINGS
--==================================================

local Settings = {
	AimbotEnabled = false,

	TriggerActive = false,

	TargetMode = "Crosshair Priority",

	TeamCheck = false,

	ESPEnabled = true,

	AutoFireDelay = 0.10
}

--==================================================
-- CHARACTER
--==================================================

local function GetCharacter()
	return LocalPlayer.Character
end

local function GetRoot()
	local character = GetCharacter()

	return character
		and character:FindFirstChild(
			"HumanoidRootPart"
		)
end

--==================================================
-- WEAPON RANGE
--==================================================

local function GetWeaponRange()
	local success, range = pcall(function()

		local value =
			BulletHandler.Range
			or BulletHandler.MaxDistance
			or BulletHandler.BulletRange

		value = tonumber(value)

		if value and value > 0 then
			return value
		end

		return 300
	end)

	if success then
		return range
	end

	return 300
end

--==================================================
-- TARGET VALIDATION
--==================================================

local function IsValidEnemy(player)
	if player == LocalPlayer then
		return false
	end

	if Settings.TeamCheck
		and LocalPlayer.Team
		and player.Team
		and LocalPlayer.Team == player.Team then

		return false
	end

	local character = player.Character

	if not character then
		return false
	end

	local humanoid =
		character:FindFirstChildOfClass(
			"Humanoid"
		)

	local head =
		character:FindFirstChild("Head")

	if not humanoid
		or humanoid.Health <= 0
		or not head then

		return false
	end

	return true
end

--==================================================
-- LINE OF SIGHT
--==================================================

local function HasLineOfSight(targetPart)
	if not targetPart then
		return false
	end

	Camera = Workspace.CurrentCamera

	if not Camera then
		return false
	end

	local origin =
		Camera.CFrame.Position

	local direction =
		targetPart.Position - origin

	local parameters =
		RaycastParams.new()

	parameters.FilterType =
		Enum.RaycastFilterType.Exclude

	parameters.IgnoreWater = true

	local character =
		LocalPlayer.Character

	parameters.FilterDescendantsInstances =
		character and {character} or {}

	local result =
		Workspace:Raycast(
			origin,
			direction,
			parameters
		)

	if not result then
		return true
	end

	local targetCharacter =
		targetPart.Parent

	return result.Instance
		and targetCharacter
		and result.Instance:IsDescendantOf(
			targetCharacter
		)
end

--==================================================
-- TARGET SYSTEM
--==================================================

local function GetTarget(requireVisibility)
	local root = GetRoot()

	if not root then
		return nil
	end

	Camera = Workspace.CurrentCamera

	if not Camera then
		return nil
	end

	local weaponRange =
		GetWeaponRange()

	local bestTarget = nil

	--==============================================
	-- PROXIMITY
	--==============================================

	if Settings.TargetMode
		== "Proximity Priority" then

		local shortest =
			math.huge

		for _, player in ipairs(
			Players:GetPlayers()
		) do

			if not IsValidEnemy(player) then
				continue
			end

			local head =
				player.Character.Head

			local distance =
				(
					head.Position
					- root.Position
				).Magnitude

			if distance > weaponRange then
				continue
			end

			if requireVisibility
				and not HasLineOfSight(head) then

				continue
			end

			if distance < shortest then
				shortest = distance
				bestTarget = head
			end
		end

	--==============================================
	-- CROSSHAIR
	--==============================================

	else

		local closestScreenDistance =
			math.huge

		local center =
			Camera.ViewportSize / 2

		for _, player in ipairs(
			Players:GetPlayers()
		) do

			if not IsValidEnemy(player) then
				continue
			end

			local head =
				player.Character.Head

			local worldDistance =
				(
					head.Position
					- root.Position
				).Magnitude

			if worldDistance > weaponRange then
				continue
			end

			local screenPosition,
				onScreen =
				Camera:WorldToViewportPoint(
					head.Position
				)

			if not onScreen then
				continue
			end

			if requireVisibility
				and not HasLineOfSight(head) then

				continue
			end

			local screenDistance =
				(
					Vector2.new(
						screenPosition.X,
						screenPosition.Y
					)
					- center
				).Magnitude

			if screenDistance
				< closestScreenDistance then

				closestScreenDistance =
					screenDistance

				bestTarget = head
			end
		end
	end

	return bestTarget
end

--==================================================
-- ESP SETTINGS
--==================================================

Settings.ESPEnabled = true
Settings.ESPMode = "Box"
Settings.ESPLines = false
Settings.ESPNames = false

local ESP_COLOR = Color3.fromRGB(168, 85, 247)
local TARGET_COLOR = Color3.fromRGB(216, 180, 254)

local BoxCache = {}

--==================================================
-- CREATE ESP
--==================================================

local function CreateESP(player)
	if BoxCache[player] then
		return
	end

	local data = {}

	--==================================================
	-- BOX
	--==================================================

	local sizePart = Instance.new("Part")

	sizePart.Name = "MirrorsESP_" .. player.Name
	sizePart.Size = Vector3.new(4.5, 6, 2.5)

	sizePart.Transparency = 1
	sizePart.Anchored = true

	sizePart.CanCollide = false
	sizePart.CanTouch = false
	sizePart.CanQuery = false

	sizePart.CastShadow = false
	sizePart.Parent = Workspace

	local box = Instance.new("SelectionBox")

	box.Name = "MirrorsBox"
	box.Adornee = sizePart

	box.Color3 = ESP_COLOR
	box.SurfaceColor3 = ESP_COLOR

box.SurfaceTransparency = 1
	box.Transparency = 0

	box.LineThickness = 0.035

	pcall(function()
		box.Parent = CoreGui
	end)

	if not box.Parent then
		box.Parent = sizePart
	end

	--==================================================
	-- HIGHLIGHT
	--==================================================

	local highlight = Instance.new("Highlight")

	highlight.Name = "MirrorsHighlight"

	highlight.FillColor = ESP_COLOR
	highlight.OutlineColor = ESP_COLOR

	highlight.FillTransparency = 0.75
	highlight.OutlineTransparency = 0

	highlight.DepthMode =
		Enum.HighlightDepthMode.AlwaysOnTop

	highlight.Enabled = false

	pcall(function()
		highlight.Parent = CoreGui
	end)

	if not highlight.Parent then
		highlight.Parent = Workspace
	end

	--==================================================
	-- NAME ESP
	--==================================================

	local billboard = Instance.new("BillboardGui")

	billboard.Name = "MirrorsNameESP"

	billboard.Size =
		UDim2.fromOffset(160, 30)

	billboard.StudsOffset =
		Vector3.new(0, 3.8, 0)

	billboard.AlwaysOnTop = true
	billboard.Enabled = false

	local label = Instance.new("TextLabel")

	label.Size =
		UDim2.fromScale(1, 1)

	label.BackgroundTransparency = 1

	label.TextColor3 = ESP_COLOR
	label.TextStrokeTransparency = 0.3

	label.Font = Enum.Font.GothamBold
	label.TextSize = 14

	label.Parent = billboard

	pcall(function()
		billboard.Parent = CoreGui
	end)

	if not billboard.Parent then
		billboard.Parent = Workspace
	end

	--==================================================
	-- LINE ESP
	--==================================================

	local line = Drawing and Drawing.new("Line")

	if line then
		line.Color = ESP_COLOR
		line.Thickness = 1.5
		line.Transparency = 1
		line.Visible = false
	end

	data.Part = sizePart
	data.Box = box
	data.Highlight = highlight

	data.Billboard = billboard
	data.Label = label

	data.Line = line

	BoxCache[player] = data
end

--==================================================
-- REMOVE ESP
--==================================================

local function RemoveESP(player)
	local data = BoxCache[player]

	if not data then
		return
	end

	for _, object in ipairs({
		data.Box,
		data.Part,
		data.Highlight,
		data.Billboard
	}) do
		if object then
			pcall(function()
				object:Destroy()
			end)
		end
	end

	if data.Line then
		pcall(function()
			data.Line:Remove()
		end)
	end

	BoxCache[player] = nil
end

local function HideESP()
	for _, data in pairs(BoxCache) do

		if data.Box then
			data.Box.Adornee = nil
		end

		if data.Highlight then
			data.Highlight.Enabled = false
		end

		if data.Billboard then
			data.Billboard.Enabled = false
		end

		if data.Line then
			data.Line.Visible = false
		end
	end
end

local function ClearESP()
	for player in pairs(BoxCache) do
		RemoveESP(player)
	end
end

Players.PlayerRemoving:Connect(RemoveESP)

--==================================================
-- ESP UPDATE
--==================================================

AddConnection(
	RunService.RenderStepped:Connect(function()

		if not Settings.ESPEnabled then
			HideESP()
			return
		end

		local root = GetRoot()

		if not root then
			HideESP()
			return
		end

		Camera = Workspace.CurrentCamera

		if not Camera then
			return
		end

		local range = GetWeaponRange()
		local currentTarget = GetTarget(false)

		for _, player in ipairs(
			Players:GetPlayers()
		) do

			if not IsValidEnemy(player) then
				continue
			end

			local character = player.Character

			local targetRoot =
				character
				and character:FindFirstChild(
					"HumanoidRootPart"
				)

			local head =
				character
				and character:FindFirstChild(
					"Head"
				)

			if not targetRoot or not head then
				continue
			end

			local distance =
				(
					targetRoot.Position
					- root.Position
				).Magnitude

			CreateESP(player)

			local data = BoxCache[player]

			if not data then
				continue
			end

			if distance > range then

				data.Box.Adornee = nil
				data.Highlight.Enabled = false
				data.Billboard.Enabled = false

				if data.Line then
					data.Line.Visible = false
				end

				continue
			end

			--==================================================
			-- COLOR
			--==================================================

			local color =
				head == currentTarget
				and TARGET_COLOR
				or ESP_COLOR

			--==================================================
			-- BOX MODE
			--==================================================

			if Settings.ESPMode == "Box" then

				data.Part.CFrame =
					targetRoot.CFrame

				data.Box.Adornee =
					data.Part

				data.Box.Color3 = color
				data.Box.SurfaceColor3 = color

				data.Highlight.Enabled = false

			--==================================================
			-- HIGHLIGHT MODE
			--==================================================

			elseif Settings.ESPMode == "Highlight" then

				data.Box.Adornee = nil

				data.Highlight.Adornee =
					character

				data.Highlight.FillColor =
					color

				data.Highlight.OutlineColor =
					color

				data.Highlight.Enabled = true
			end

			--==================================================
			-- NAME ESP
			--==================================================

			if Settings.ESPNames then

				data.Billboard.Adornee =
					head

				data.Billboard.Enabled =
					true

				data.Label.TextColor3 =
					color

				data.Label.Text =
					string.format(
						"%s\n%d studs",
						player.Name,
						math.floor(distance)
					)

			else

				data.Billboard.Enabled =
					false
			end

			--==================================================
			-- LINE ESP
			--==================================================

			if Settings.ESPLines
				and data.Line then

				local screenPos,
					onScreen =
					Camera:WorldToViewportPoint(
						targetRoot.Position
					)

				if onScreen then

					local viewport =
						Camera.ViewportSize

					data.Line.From =
						Vector2.new(
							viewport.X / 2,
							viewport.Y
						)

					data.Line.To =
						Vector2.new(
							screenPos.X,
							screenPos.Y
						)

					data.Line.Color =
						color

					data.Line.Visible =
						true

				else

					data.Line.Visible =
						false
				end

			elseif data.Line then

				data.Line.Visible =
					false
			end
		end
	end)
)

--==================================================
-- BULLET HOOK
--==================================================

pcall(function()
	if make_writeable then
		make_writeable(
			BulletHandler
		)
	end
end)

local OriginalFire =
	BulletHandler.Fire

local HookedFire

HookedFire = function(data)

	local enabled =
		Settings.AimbotEnabled
		or Settings.TriggerActive

	if enabled
		and type(data) == "table"
		and data.Misc then

		local requireVisibility =
			Settings.TriggerActive

		local target =
			GetTarget(
				requireVisibility
			)

		if target then

			local origin =
				data.Origin

			if typeof(origin)
				== "Vector3" then

				local difference =
					target.Position
					- origin

				if difference.Magnitude > 0 then

					data.Direction =
						difference.Unit
				end
			end

			if typeof(
				data.Misc.CamCFrame
			) == "CFrame" then

				data.Misc.CamCFrame =
					CFrame.new(
						data.Misc.CamCFrame.Position,
						target.Position
					)
			end
		end
	end

	return OriginalFire(data)
end

BulletHandler.Fire =
	HookedFire

--==================================================
-- AUTO FIRE
--==================================================

task.spawn(function()

	while Runtime.Alive do

		task.wait(
			Settings.AutoFireDelay
		)

		if not Runtime.Alive then
			break
		end

		if not Settings.TriggerActive then
			continue
		end

		local target =
			GetTarget(true)

		if not target then
			continue
		end

		pcall(function()

			SignalManager.Fire(
				"FireWeapon",
				Enum.UserInputState.Begin
			)

			task.wait(0.03)

			SignalManager.Fire(
				"FireWeapon",
				Enum.UserInputState.End
			)
		end)
	end
end)

--==================================================
-- MAIN UI
--==================================================

Main:Toggle({
	Title = "Silent Aim + ESP",

	Desc =
		"Redirects shots to a valid target inside the weapon range.",

	Value = false,

	Type = "Toggle",

	Flag = "silent_aim",

	Callback = function(state)
		Settings.AimbotEnabled =
			state

		if not state then
			HideESP()
		end
	end
})

Main:Dropdown({
	Title = "Target Priority Mode",

	Desc =
		"Choose how targets are selected.",

	Values = {
		"Crosshair Priority",
		"Proximity Priority"
	},

	Callback = function(selected)

		if selected
			== "Proximity Priority" then

			Settings.TargetMode =
				"Proximity Priority"

		else

			Settings.TargetMode =
				"Crosshair Priority"
		end
	end
})

Main:Toggle({
	Title = "Auto Fire",

	Desc =
		"Automatically fires when a visible target is available.",

	Value = false,

	Type = "Toggle",

	Flag = "auto_fire",

	Callback = function(state)
		Settings.TriggerActive =
			state
	end
})

Main:Toggle({
	Title = "Team Check",

	Desc =
		"Ignore players on your team.",

	Value = false,

	Type = "Toggle",

	Flag = "team_check",

	Callback = function(state)
		Settings.TeamCheck =
			state
	end
})

--==================================================
-- ESP UI
--==================================================

Esp:Toggle({
	Title = "Player Boxes",

	Desc =
		"Show 30-stud boxes around targets inside weapon range.",

	Value = true,

	Type = "Toggle",

	Flag = "player_boxes",

	Callback = function(state)
		Settings.ESPEnabled =
			state

		if not state then
			HideESP()
		end
	end
})

--==================================================
-- CONFIG
--==================================================

Config:Paragraph({
	Title = "Target System",

	Desc =
		"Silent Aim and Auto Fire now share the same target system.\n" ..
		"Auto Fire additionally requires direct line of sight.",

	Image = "crosshair"
})

--==================================================
-- CLEANUP
--==================================================

Runtime.Cleanup = function()

	if not Runtime.Alive then
		return
	end

	Runtime.Alive = false

	Settings.AimbotEnabled =
		false

	Settings.TriggerActive =
		false

	if BulletHandler.Fire
		== HookedFire then

		BulletHandler.Fire =
			OriginalFire
	end

	for _, connection in ipairs(
		Runtime.Connections
	) do

		pcall(function()
			connection:Disconnect()
		end)
	end

	ClearESP()

	pcall(function()
		SignalManager.Fire(
			"FireWeapon",
			Enum.UserInputState.End
		)
	end)

	pcall(function()
		if Runtime.Window
			and Runtime.Window.Destroy then

			Runtime.Window:Destroy()
		end
	end)
end