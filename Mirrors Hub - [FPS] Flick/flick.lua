--==================================================
-- MIRRORS HUB - [FPS] FLICK
-- v1.2.0
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

local LP = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

--==================================================
-- CLEAN OLD EXECUTION
--==================================================

local Env = getgenv()

if Env.MirrorsFlickRuntime
	and Env.MirrorsFlickRuntime.Cleanup then

	pcall(Env.MirrorsFlickRuntime.Cleanup)
end

local Runtime = {
	Alive = true,
	Connections = {},
	Window = nil
}

Env.MirrorsFlickRuntime = Runtime

local function AddConnection(connection)
	table.insert(Runtime.Connections, connection)
	return connection
end

--==================================================
-- WINDOW
--==================================================

local Window = WindUI:CreateWindow({
	Title = "Mirrors Hub - [FPS] Flick",
	Icon = "crosshair",
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
	Title = "v1.2.0",
	Color = Color3.fromHex("A855F7"),
	Radius = 13
})

Window:SetToggleKey(Enum.KeyCode.K)

Window:EditOpenButton({
	Title = "Open Mirrors Hub - [FPS] Flick",

	Icon = "crosshair",

	CornerRadius = UDim.new(0, 16),
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

local Info = Window:Tab({
	Title = "Info",
	Icon = "info"
})

local Main = Window:Tab({
	Title = "Main",
	Icon = "crosshair"
})

local Esp = Window:Tab({
	Title = "ESP",
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
	Title = "Mirrors Hub",

	Desc =
		"[FPS] Flick\n" ..
		"Version 1.2.0\n" ..
		"Created by blackzw.mp3",

	Image = "crosshair",
	ImageSize = 24,

	Thumbnail = "rbxassetid://91587269886962",
	ThumbnailSize = 70
})

Info:Paragraph({
	Title = "Community",

	Desc =
		"Updates • Support • Bugs • Suggestions",

	Image = "message-circle",
	ImageSize = 22,

	Buttons = {
		{
			Title = "Copy Discord",
			Icon = "copy",

			Callback = function()

				local Copy =
					setclipboard
					or toclipboard

				if not Copy then
					return
				end

				Copy(
					"https://discord.gg/YZEg6FyRSF"
				)

				WindUI:Notify({
					Title = "Mirrors Hub",
					Content = "Discord link copied.",
					Duration = 3
				})
			end
		}
	}
})

--==================================================
-- SERVER STATUS
--==================================================

local JoinTime = os.time()

local ServerInfo =
	Info:Paragraph({
		Title = "Server",
		Desc = "Loading...",
		Image = "server"
	})

local RuntimeInfo =
	Info:Paragraph({
		Title = "Engine",
		Desc = "Loading...",
		Image = "cpu"
	})

local function FormatTime(seconds)

	local hours =
		math.floor(seconds / 3600)

	local minutes =
		math.floor(
			(seconds % 3600) / 60
		)

	local secs =
		seconds % 60

	return string.format(
		"%02d:%02d:%02d",
		hours,
		minutes,
		secs
	)
end

local function GetPing()

	local success, value =
		pcall(function()

			return Stats.Network
				.ServerStatsItem[
					"Data Ping"
				]
				:GetValue()
		end)

	if success then
		return math.floor(value)
	end

	return 0
end

--==================================================
-- MODULES
--==================================================

local GunModules =
	ReplicatedStorage
		:WaitForChild("ModuleScripts")
		:WaitForChild("GunModules")

local BulletHandler =
	require(
		GunModules
			:WaitForChild(
				"BulletHandler"
			)
	)

local SignalManager =
	require(
		ReplicatedStorage
			:WaitForChild(
				"SignalManager"
			)
	)

--==================================================
-- SETTINGS
--==================================================

local Settings = {

	-- AIM

	AimbotEnabled = false,

	TargetMode =
		"Crosshair Priority",

	TeamCheck = false,

	WallCheck = false,

	AimFOV = 250,

	-- AUTO FIRE

	TriggerActive = false,

	AutoFireDelay = 0.10,

	-- ESP

	ESPEnabled = false,

	ESPMode = "Box",

	ESPLines = false,

	ESPNames = false,

	ESPDistance = true,

	ESPMaxDistance = 2000
}

--==================================================
-- COLORS
--==================================================

local PURPLE =
	Color3.fromRGB(
		168,
		85,
		247
	)

local TARGET_PURPLE =
	Color3.fromRGB(
		216,
		180,
		254
	)

--==================================================
-- CHARACTER
--==================================================

local function GetCharacter()

	return LP.Character

end

local function GetRoot()

	local character =
		GetCharacter()

	if not character then
		return nil
	end

	return character:FindFirstChild(
		"HumanoidRootPart"
	)

end

--==================================================
-- WEAPON RANGE
--==================================================

local function GetWeaponRange()

	local success, result =
		pcall(function()

			local range =
				BulletHandler.Range
				or BulletHandler.MaxDistance
				or BulletHandler.BulletRange

			range =
				tonumber(range)

			if range
				and range > 0 then

				return range
			end

			return 300
		end)

	if success then
		return result
	end

	return 300
end

--==================================================
-- VALID PLAYER
--==================================================

local function GetPlayerParts(player)

	if player == LP then
		return
	end

	local character =
		player.Character

	if not character then
		return
	end

	local humanoid =
		character
			:FindFirstChildOfClass(
				"Humanoid"
			)

	local root =
		character
			:FindFirstChild(
				"HumanoidRootPart"
			)

	local head =
		character
			:FindFirstChild(
				"Head"
			)

	if not humanoid
		or humanoid.Health <= 0
		or not root
		or not head then

		return
	end

	return character,
		humanoid,
		root,
		head
end

local function IsTargetAllowed(player)

	if player == LP then
		return false
	end

	if Settings.TeamCheck
		and LP.Team
		and player.Team
		and LP.Team == player.Team then

		return false
	end

	return true
end

--==================================================
-- WALL CHECK
--==================================================

local function HasLineOfSight(part)

	if not part then
		return false
	end

	Camera =
		Workspace.CurrentCamera

	if not Camera then
		return false
	end

	local origin =
		Camera.CFrame.Position

	local direction =
		part.Position - origin

	local params =
		RaycastParams.new()

	params.FilterType =
		Enum.RaycastFilterType.Exclude

	params.IgnoreWater = true

	local character =
		LP.Character

	params.FilterDescendantsInstances =
		character
			and {character}
			or {}

	local result =
		Workspace:Raycast(
			origin,
			direction,
			params
		)

	if not result then
		return true
	end

	return result.Instance
		and part.Parent
		and result.Instance
			:IsDescendantOf(
				part.Parent
			)
end

--==================================================
-- TARGET SYSTEM
--==================================================

local function GetTarget(
	requireVisibility
)

	local localRoot =
		GetRoot()

	if not localRoot then
		return nil
	end

	Camera =
		Workspace.CurrentCamera

	if not Camera then
		return nil
	end

	local weaponRange =
		GetWeaponRange()

	local bestTarget = nil

	--==============================================
	-- PROXIMITY
	--==============================================

	if Settings.TargetMode ==
		"Proximity Priority" then

		local shortest =
			math.huge

		for _, player in ipairs(
			Players:GetPlayers()
		) do

			if not IsTargetAllowed(
				player
			) then
				continue
			end

			local character,
				humanoid,
				root,
				head =
				GetPlayerParts(
					player
				)

			if not head then
				continue
			end

			local distance =
				(
					head.Position
					- localRoot.Position
				).Magnitude

			if distance >
				weaponRange then

				continue
			end

			if requireVisibility
				and not HasLineOfSight(
					head
				) then

				continue
			end

			if distance <
				shortest then

				shortest =
					distance

				bestTarget =
					head
			end
		end

		return bestTarget
	end

	--==============================================
	-- CROSSHAIR
	--==============================================

	local center =
		Camera.ViewportSize / 2

	local closest =
		Settings.AimFOV

	for _, player in ipairs(
		Players:GetPlayers()
	) do

		if not IsTargetAllowed(
			player
		) then

			continue
		end

		local character,
			humanoid,
			root,
			head =
			GetPlayerParts(
				player
			)

		if not head then
			continue
		end

		local distance =
			(
				head.Position
				- localRoot.Position
			).Magnitude

		if distance >
			weaponRange then

			continue
		end

		local screen,
			onScreen =
			Camera
				:WorldToViewportPoint(
					head.Position
				)

		if not onScreen
			or screen.Z <= 0 then

			continue
		end

		if requireVisibility
			and not HasLineOfSight(
				head
			) then

			continue
		end

		local screenDistance =
			(
				Vector2.new(
					screen.X,
					screen.Y
				)
				- center
			).Magnitude

		if screenDistance <
			closest then

			closest =
				screenDistance

			bestTarget =
				head
		end
	end

	return bestTarget
end

--==================================================
-- DRAWING SUPPORT
--==================================================

local DrawingSupported =
	Drawing
	and Drawing.new

local function NewDrawing(class)

	if not DrawingSupported then
		return nil
	end

	local success, object =
		pcall(function()

			return Drawing.new(class)

		end)

	if success then
		return object
	end

	return nil
end

--==================================================
-- ESP CACHE
--==================================================

local ESPCache = {}

local function HideESPData(data)

	if not data then
		return
	end

	if data.Box then
		data.Box.Visible = false
	end

	if data.Line then
		data.Line.Visible = false
	end

	if data.Name then
		data.Name.Visible = false
	end

	if data.Highlight then
		data.Highlight.Enabled =
			false

		data.Highlight.Adornee =
			nil
	end
end

local function CreateESP(player)

	if ESPCache[player] then
		return ESPCache[player]
	end

	local data = {}

	--==============================================
	-- 2D BOX
	--==============================================

	data.Box =
		NewDrawing("Square")

	if data.Box then

		data.Box.Visible =
			false

		data.Box.Filled =
			false

		data.Box.Thickness =
			1.5

		data.Box.Transparency =
			1

		data.Box.Color =
			PURPLE
	end

	--==============================================
	-- LINE
	--==============================================

	data.Line =
		NewDrawing("Line")

	if data.Line then

		data.Line.Visible =
			false

		data.Line.Thickness =
			1.3

		data.Line.Transparency =
			1

		data.Line.Color =
			PURPLE
	end

	--==============================================
	-- NAME
	--==============================================

	data.Name =
		NewDrawing("Text")

	if data.Name then

		data.Name.Visible =
			false

		data.Name.Center =
			true

		data.Name.Outline =
			true

		data.Name.Size =
			14

		data.Name.Transparency =
			1

		data.Name.Color =
			PURPLE
	end

	--==============================================
	-- HIGHLIGHT
	--==============================================

	local highlight =
		Instance.new("Highlight")

	highlight.Name =
		"MirrorsHighlight_"
		.. player.Name

	highlight.Enabled =
		false

	highlight.DepthMode =
		Enum.HighlightDepthMode
			.AlwaysOnTop

	highlight.FillColor =
		PURPLE

	highlight.OutlineColor =
		PURPLE

	highlight.FillTransparency =
		0.78

	highlight.OutlineTransparency =
		0

	local success =
		pcall(function()

			highlight.Parent =
				CoreGui

		end)

	if not success
		or not highlight.Parent then

		highlight.Parent =
			Workspace
	end

	data.Highlight =
		highlight

	ESPCache[player] =
		data

	return data
end

local function RemoveESP(player)

	local data =
		ESPCache[player]

	if not data then
		return
	end

	if data.Box then

		pcall(function()
			data.Box:Remove()
		end)
	end

	if data.Line then

		pcall(function()
			data.Line:Remove()
		end)
	end

	if data.Name then

		pcall(function()
			data.Name:Remove()
		end)
	end

	if data.Highlight then

		pcall(function()
			data.Highlight:Destroy()
		end)
	end

	ESPCache[player] =
		nil
end

local function HideAllESP()

	for _, data in pairs(
		ESPCache
	) do

		HideESPData(data)
	end
end

local function ClearESP()

	local list = {}

	for player in pairs(
		ESPCache
	) do

		table.insert(
			list,
			player
		)
	end

	for _, player in ipairs(
		list
	) do

		RemoveESP(player)
	end
end

--==================================================
-- GET CHARACTER 2D BOX
--==================================================

local function Get2DBounds(
	character
)

	Camera =
		Workspace.CurrentCamera

	if not Camera then
		return nil
	end

	local success,
		boundsCF,
		boundsSize =
		pcall(function()

			local cf, size =
				character
					:GetBoundingBox()

			return cf, size
		end)

	if not success
		or not boundsCF
		or not boundsSize then

		return nil
	end

	local half =
		boundsSize / 2

	local minX =
		math.huge

	local minY =
		math.huge

	local maxX =
		-math.huge

	local maxY =
		-math.huge

	local visiblePoints =
		0

	for x = -1, 1, 2 do
		for y = -1, 1, 2 do
			for z = -1, 1, 2 do

				local worldPosition =
					(
						boundsCF
						* CFrame.new(
							half.X * x,
							half.Y * y,
							half.Z * z
						)
					).Position

				local viewport =
					Camera
						:WorldToViewportPoint(
							worldPosition
						)

				if viewport.Z > 0 then

					visiblePoints += 1

					minX =
						math.min(
							minX,
							viewport.X
						)

					minY =
						math.min(
							minY,
							viewport.Y
						)

					maxX =
						math.max(
							maxX,
							viewport.X
						)

					maxY =
						math.max(
							maxY,
							viewport.Y
						)
				end
			end
		end
	end

	if visiblePoints == 0 then
		return nil
	end

	local viewport =
		Camera.ViewportSize

	if maxX < 0
		or minX > viewport.X
		or maxY < 0
		or minY > viewport.Y then

		return nil
	end

	local width =
		maxX - minX

	local height =
		maxY - minY

	if width <= 1
		or height <= 1 then

		return nil
	end

	return Vector2.new(
		minX,
		minY
	),
	Vector2.new(
		width,
		height
	)
end

--==================================================
-- PLAYER REMOVING
--==================================================

AddConnection(
	Players.PlayerRemoving
		:Connect(function(player)

			RemoveESP(player)

		end)
)

--==================================================
-- ESP RENDER
--==================================================

AddConnection(
	RunService.RenderStepped
		:Connect(function()

			if not Runtime.Alive then
				return
			end

			if not Settings.ESPEnabled then

				HideAllESP()
				return
			end

			local localRoot =
				GetRoot()

			if not localRoot then

				HideAllESP()
				return
			end

			Camera =
				Workspace.CurrentCamera

			if not Camera then
				return
			end

			local currentTarget = nil

			if Settings.AimbotEnabled
				or Settings.TriggerActive then

				currentTarget =
					GetTarget(false)
			end

			for _, player in ipairs(
				Players:GetPlayers()
			) do

				if player == LP then
					continue
				end

				local data =
					CreateESP(player)

				local character,
					humanoid,
					root,
					head =
					GetPlayerParts(
						player
					)

				--==============================
				-- DEAD / RESPAWNING / INVALID
				--==============================

				if not character
					or not humanoid
					or humanoid.Health <= 0
					or not root
					or not head then

					HideESPData(data)
					continue
				end

				--==============================
				-- TEAM CHECK
				--==============================

				if Settings.TeamCheck
					and LP.Team
					and player.Team
					and LP.Team ==
						player.Team then

					HideESPData(data)
					continue
				end

				--==============================
				-- DISTANCE
				--==============================

				local distance =
					(
						root.Position
						- localRoot.Position
					).Magnitude

				if distance >
					Settings.ESPMaxDistance then

					HideESPData(data)
					continue
				end

				--==============================
				-- SCREEN BOUNDS
				--==============================

				local position,
					size =
					Get2DBounds(
						character
					)

				local targetColor =
					currentTarget == head
					and TARGET_PURPLE
					or PURPLE

				--==============================
				-- BOX
				--==============================

				if Settings.ESPMode ==
					"Box" then

					data.Highlight.Enabled =
						false

					data.Highlight.Adornee =
						nil

					if data.Box
						and position
						and size then

						data.Box.Position =
							position

						data.Box.Size =
							size

						data.Box.Color =
							targetColor

						data.Box.Visible =
							true

					elseif data.Box then

						data.Box.Visible =
							false
					end

				--==============================
				-- HIGHLIGHT
				--==============================

				elseif Settings.ESPMode ==
					"Highlight" then

					if data.Box then
						data.Box.Visible =
							false
					end

					data.Highlight.Adornee =
						character

					data.Highlight.FillColor =
						targetColor

					data.Highlight.OutlineColor =
						targetColor

					data.Highlight.Enabled =
						true
				end

				--==============================
				-- NAME ESP
				--==============================

				if Settings.ESPNames
					and data.Name
					and position
					and size then

					local text =
						player.DisplayName

					if Settings.ESPDistance then

						text ..=
							string.format(
								"  [%dm]",
								math.floor(
									distance
								)
							)
					end

					data.Name.Text =
						text

					data.Name.Color =
						targetColor

					data.Name.Position =
						Vector2.new(
							position.X
								+ size.X / 2,

							position.Y
								- 18
						)

					data.Name.Visible =
						true

				elseif data.Name then

					data.Name.Visible =
						false
				end

				--==============================
				-- LINES
				--==============================

				if Settings.ESPLines
					and data.Line
					and position
					and size then

					local viewport =
						Camera.ViewportSize

					data.Line.From =
						Vector2.new(
							viewport.X / 2,
							viewport.Y - 2
						)

					data.Line.To =
						Vector2.new(
							position.X
								+ size.X / 2,

							position.Y
								+ size.Y
						)

					data.Line.Color =
						targetColor

					data.Line.Visible =
						true

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

local function GetOriginPosition(
	data
)

	if not data then
		return nil
	end

	if typeof(data.Origin) ==
		"Vector3" then

		return data.Origin
	end

	if typeof(data.Origin) ==
		"CFrame" then

		return data.Origin.Position
	end

	return nil
end

HookedFire =
	function(data)

		if (
			Settings.AimbotEnabled
			or Settings.TriggerActive
		)
			and type(data) ==
				"table" then

			local visibility =
				Settings.TriggerActive
				or Settings.WallCheck

			local target =
				GetTarget(
					visibility
				)

			if target then

				local origin =
					GetOriginPosition(
						data
					)

				if origin then

					local difference =
						target.Position
						- origin

					if difference.Magnitude >
						0 then

						data.Direction =
							difference.Unit
					end
				end

				if data.Misc
					and typeof(
						data.Misc.CamCFrame
					) == "CFrame" then

					data.Misc.CamCFrame =
						CFrame.new(
							data.Misc
								.CamCFrame
								.Position,

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

			task.wait(0.025)

			SignalManager.Fire(
				"FireWeapon",
				Enum.UserInputState.End
			)

		end)
	end
end)

--==================================================
-- UPDATE INFO
--==================================================

local function UpdateInfo()

	if not Runtime.Alive then
		return
	end

	pcall(function()

		ServerInfo:SetDesc(
			string.format(
				"Players  %d/%d\n" ..
				"Ping     %d ms\n" ..
				"Session  %s\n" ..
				"Place    %s\n" ..
				"Job      %s",

				#Players:GetPlayers(),
				Players.MaxPlayers,

				GetPing(),

				FormatTime(
					os.time()
					- JoinTime
				),

				tostring(
					game.PlaceId
				),

				tostring(
					game.JobId
				)
			)
		)

	end)

	pcall(function()

		RuntimeInfo:SetDesc(
			string.format(
				"Weapon Range  %d studs\n" ..
				"Target Mode   %s\n" ..
				"ESP Engine    %s\n" ..
				"ESP Range     %d studs",

				math.floor(
					GetWeaponRange()
				),

				Settings.TargetMode,

				DrawingSupported
					and "Drawing 2D"
					or "Highlight only",

				Settings.ESPMaxDistance
			)
		)

	end)
end

UpdateInfo()

task.spawn(function()

	while Runtime.Alive do

		task.wait(3)

		if Runtime.Alive then
			UpdateInfo()
		end
	end
end)

--==================================================
-- INFO BUTTONS
--==================================================

Info:Space()

Info:Button({
	Title = "Copy Job ID",
	Desc = "Copy current server identifier",

	Icon = "clipboard-copy",

	Callback = function()

		local Copy =
			setclipboard
				or toclipboard

		if not Copy then

			WindUI:Notify({
				Title = "Clipboard",
				Content = "Not supported.",
				Duration = 3
			})

			return
		end

		Copy(game.JobId)

		WindUI:Notify({
			Title = "Mirrors Hub",
			Content = "Job ID copied.",
			Duration = 3
		})
	end
})

--==================================================
-- MAIN UI
--==================================================

Main:Paragraph({
	Title = "Targeting",
	Desc =
		"Silent Aim • Auto Fire • Crosshair / Proximity\n" ..
		"Uses the weapon's detected range.",
	Image = "crosshair"
})

Main:Toggle({
	Title = "Silent Aim",

	Desc =
		"Redirect shots toward the selected target.",

	Value = false,
	Type = "Toggle",

	Flag = "flick_silent_aim",

	Callback = function(state)

		Settings.AimbotEnabled =
			state

	end
})

Main:Toggle({
	Title = "Auto Fire",

	Desc =
		"Automatically fires at visible targets.",

	Value = false,
	Type = "Toggle",

	Flag = "flick_auto_fire",

	Callback = function(state)

		Settings.TriggerActive =
			state

	end
})

Main:Dropdown({
	Title = "Target Priority",

	Desc =
		"Choose how targets are selected.",

	Values = {
		"Crosshair Priority",
		"Proximity Priority"
	},

	Callback = function(value)

		Settings.TargetMode =
			value
				or "Crosshair Priority"

	end
})

Main:Toggle({
	Title = "Wall Check",

	Desc =
		"Require line of sight for Silent Aim.",

	Value = false,
	Type = "Toggle",

	Flag = "flick_wall_check",

	Callback = function(state)

		Settings.WallCheck =
			state

	end
})

Main:Toggle({
	Title = "Team Check",

	Desc =
		"Ignore players on your team.",

	Value = false,
	Type = "Toggle",

	Flag = "flick_team_check",

	Callback = function(state)

		Settings.TeamCheck =
			state

	end
})

Main:Slider({
	Title = "Crosshair FOV",

	Desc =
		"Maximum target distance from the center of the screen.",

	Value = {
		Min = 50,
		Max = 600,
		Default = 250
	},

	Step = 10,

	Flag = "flick_fov",

	Callback = function(value)

		Settings.AimFOV =
			tonumber(value)
				or 250

	end
})

--==================================================
-- ESP UI
--==================================================

Esp:Paragraph({
	Title = "Player ESP",

	Desc =
		"Purple visual tracking system.\n" ..
		"Box mode is rendered in 2D and stays visible through walls.",

	Image = "eye"
})

Esp:Toggle({
	Title = "Enable ESP",

	Desc =
		"Master switch for all ESP visuals.",

	Value = false,
	Type = "Toggle",

	Flag = "flick_esp",

	Callback = function(state)

		Settings.ESPEnabled =
			state

		if not state then
			HideAllESP()
		end
	end
})

Esp:Dropdown({
	Title = "ESP Style",

	Desc =
		"Choose the main player visual.",

	Values = {
		"Box",
		"Highlight"
	},

	Callback = function(value)

		if value == "Box"
			and not DrawingSupported then

			Settings.ESPMode =
				"Highlight"

			WindUI:Notify({
				Title = "ESP",
				Content =
					"Drawing API unavailable. Using Highlight.",
				Duration = 4
			})

			return
		end

		Settings.ESPMode =
			value or "Box"

	end
})

Esp:Toggle({
	Title = "Name ESP",

	Desc =
		"Show the player's display name.",

	Value = false,
	Type = "Toggle",

	Flag = "flick_esp_names",

	Callback = function(state)

		Settings.ESPNames =
			state

	end
})

Esp:Toggle({
	Title = "Distance",

	Desc =
		"Show distance beside the player's name.",

	Value = true,
	Type = "Toggle",

	Flag = "flick_esp_distance",

	Callback = function(state)

		Settings.ESPDistance =
			state

	end
})

Esp:Toggle({
	Title = "Snaplines",

	Desc =
		"Draw a line from the bottom of the screen to players.",

	Value = false,
	Type = "Toggle",

	Flag = "flick_esp_lines",

	Callback = function(state)

		Settings.ESPLines =
			state

	end
})

Esp:Slider({
	Title = "ESP Distance",

	Desc =
		"Maximum visual ESP range.",

	Value = {
		Min = 100,
		Max = 5000,
		Default = 2000
	},

	Step = 100,

	Flag = "flick_esp_range",

	Callback = function(value)

		Settings.ESPMaxDistance =
			tonumber(value)
				or 2000

	end
})

Esp:Button({
	Title = "Clear ESP Cache",

	Desc =
		"Destroy and rebuild every cached ESP object.",

	Icon = "refresh-cw",

	Callback = function()

		ClearESP()

		WindUI:Notify({
			Title = "ESP",
			Content = "ESP cache cleared.",
			Duration = 2
		})
	end
})

--==================================================
-- MISC
--==================================================

Misc:Paragraph({
	Title = "Runtime",

	Desc =
		"Re-execution safe.\n" ..
		"Old connections, ESP objects and hooks are cleaned automatically.",

	Image = "activity"
})

Misc:Paragraph({
	Title = "Rendering",

	Desc =
		"Box • Drawing 2D\n" ..
		"Highlight • AlwaysOnTop\n" ..
		"Names • Screen-space\n" ..
		"Lines • Screen-space",

	Image = "scan"
})

--==================================================
-- CONFIG
--==================================================

Config:Paragraph({
	Title = "Controls",

	Desc =
		"Open / Close: K\n" ..
		"UI: WindUI\n" ..
		"Theme: Violet",

	Image = "cog"
})

Config:Paragraph({
	Title = "Mirrors Engine",

	Desc =
		"One target resolver.\n" ..
		"One BulletHandler hook.\n" ..
		"One ESP render loop.",

	Image = "cpu"
})

--==================================================
-- CLEANUP
--==================================================

Runtime.Cleanup = function()

	if not Runtime.Alive then
		return
	end

	Runtime.Alive =
		false

	Settings.AimbotEnabled =
		false

	Settings.TriggerActive =
		false

	Settings.ESPEnabled =
		false

	HideAllESP()

	if BulletHandler.Fire ==
		HookedFire then

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

local RS=game:GetService("ReplicatedStorage")
local RunService=game:GetService("RunService")

local VM=require(RS.ModuleScripts.cj)

local ORIGINAL_FOV=Camera.FieldOfView

local V={
	X=0,
	Y=0,
	Z=0,

	RX=0,
	RY=0,
	RZ=0,

	FOV=70
}

local Locked=true
local GripBases=setmetatable({},{__mode="k"})
local ToolConnection

local function GetTool()
	local c=LP.Character
	return c and c:FindFirstChildOfClass("Tool")
end

local function GetGrip(tool)
	local c=LP.Character
	if not c or not tool then return end

	for _,v in ipairs(c:GetDescendants()) do
		if v:IsA("Motor6D")
		and v.Name=="ToolGrip"
		and v.Part1
		and v.Part1:IsDescendantOf(tool) then
			return v
		end
	end
end

local function UpdateRotation()
	if not Locked then return end

	local tool=GetTool()
	if not tool then return end

	local grip=GetGrip(tool)
	if not grip then return end

	if not GripBases[grip] then
		GripBases[grip]=grip.C0
	end

	grip.C0=
		GripBases[grip]
		*CFrame.Angles(
			math.rad(V.RX),
			math.rad(V.RY),
			math.rad(V.RZ)
		)
end

local function UpdateView()
	if not Locked then return end

	local tool=GetTool()
	if not tool then return end

	local base=tool:GetAttribute("ViewModelOffset")

	if typeof(base)~="Vector3" then
		base=Vector3.zero
	end

	VM:onViewModelOffsetChanged(
		base+Vector3.new(V.X,V.Y,V.Z),
		.08,
		Enum.EasingStyle.Quad
	)

	UpdateRotation()
end

local function SetupTool(tool)
	if ToolConnection then
		ToolConnection:Disconnect()
		ToolConnection=nil
	end

	task.delay(.1,UpdateView)

	if tool then
		ToolConnection=tool.Activated:Connect(function()
			-- deixa a animação acontecer e restaura nossa config
			task.delay(.45,UpdateView)
		end)
	end
end

--==================================================
-- LOCK
--==================================================

RunService.RenderStepped:Connect(function()
	if not Locked then return end

	-- FOV fica realmente travado
	if Camera.FieldOfView~=V.FOV then
		Camera.FieldOfView=V.FOV
	end

	-- rotação também fica travada
	UpdateRotation()
end)

local function SetupCharacter(c)
	local tool=c:FindFirstChildOfClass("Tool")
	if tool then SetupTool(tool) end

	c.ChildAdded:Connect(function(v)
		if v:IsA("Tool") then
			SetupTool(v)
		end
	end)
end

if LP.Character then
	SetupCharacter(LP.Character)
end

LP.CharacterAdded:Connect(SetupCharacter)

--==================================================
-- POSITION
--==================================================

Misc:Slider({
	Title="ViewModel X",
	Desc="Left / Right",
	Step=.05,
	Value={Min=-5,Max=5,Default=0},

	Callback=function(v)
		V.X=v
		UpdateView()
	end
})

Misc:Slider({
	Title="ViewModel Y",
	Desc="Up / Down",
	Step=.05,
	Value={Min=-5,Max=5,Default=0},

	Callback=function(v)
		V.Y=v
		UpdateView()
	end
})

Misc:Slider({
	Title="ViewModel Z",
	Desc="Forward / Back",
	Step=.05,
	Value={Min=-10,Max=10,Default=0},

	Callback=function(v)
		V.Z=v
		UpdateView()
	end
})

--==================================================
-- ROTATION
--==================================================

Misc:Slider({
	Title="Rotation X",
	Desc="Pitch",
	Step=1,
	Value={Min=-180,Max=180,Default=0},

	Callback=function(v)
		V.RX=v
		UpdateRotation()
	end
})

Misc:Slider({
	Title="Rotation Y",
	Desc="Yaw",
	Step=1,
	Value={Min=-180,Max=180,Default=0},

	Callback=function(v)
		V.RY=v
		UpdateRotation()
	end
})

Misc:Slider({
	Title="Rotation Z",
	Desc="Roll",
	Step=1,
	Value={Min=-180,Max=180,Default=0},

	Callback=function(v)
		V.RZ=v
		UpdateRotation()
	end
})

--==================================================
-- FOV
--==================================================

Misc:Slider({
	Title="ViewModel FOV",
	Desc="Locked Camera FOV",
	Step=1,

	Value={
		Min=40,
		Max=200,
		Default=70
	},

	Callback=function(v)
		V.FOV=v
		Camera.FieldOfView=v
	end
})

--==================================================
-- RESET
--==================================================

Misc:Button({
	Title="Reset ViewModel",
	Icon="rotate-ccw",

	Callback=function()
		Locked=false

		V.X,V.Y,V.Z=0,0,0
		V.RX,V.RY,V.RZ=0,0,0
		V.FOV=ORIGINAL_FOV

		for grip,base in pairs(GripBases) do
			if grip and grip.Parent then
				grip.C0=base
			end
		end

		Camera.FieldOfView=ORIGINAL_FOV

		local tool=GetTool()

		if tool then
			local base=tool:GetAttribute("ViewModelOffset")

			if typeof(base)~="Vector3" then
				base=Vector3.zero
			end

			VM:onViewModelOffsetChanged(
				base,
				.12,
				Enum.EasingStyle.Quad
			)
		end
	end
})


local P=game:GetService("Players")
local R=game:GetService("RunService")
local LP=P.LocalPlayer
local Cam=workspace.CurrentCamera

local ON=false
local DIST=5000
local SPEED=.12

local objs={}
local con

local function clear()
	if con then con:Disconnect() con=nil end
	for _,v in pairs(objs) do
		pcall(function()v:Destroy()end)
	end
	table.clear(objs)
end

local function muzzle()
	local c=LP.Character
	local t=c and c:FindFirstChildOfClass("Tool")
	local m=t and t:FindFirstChild("Muz",true)
	return m and m:IsA("BasePart") and m
end

local function beam(a,b,w,tr)
	local x=Instance.new("Beam")
	x.Attachment0=a
	x.Attachment1=b
	x.Width0=w
	x.Width1=w
	x.FaceCamera=true
	x.LightEmission=1
	x.LightInfluence=0
	x.Transparency=NumberSequence.new(tr)
	x.Parent=a.Parent
	return x
end

local function start()
	clear()
	if not ON then return end

	local m=muzzle()
	if not m then return end

	local a0=Instance.new("Attachment",m)
	a0.Name="MirrorsLaser"

	local loc=m:FindFirstChild("LOC")
	if loc and loc:IsA("Attachment") then
		a0.CFrame=loc.CFrame
	end

	local ep=Instance.new("Part",workspace)
	ep.Size=Vector3.one*.01
	ep.Transparency=1
	ep.Anchored=true
	ep.CanCollide=false
	ep.CanTouch=false
	ep.CanQuery=false

	local a1=Instance.new("Attachment",ep)

	local glow=beam(a0,a1,.09,.65)
	local mid=beam(a0,a1,.045,.18)
	local core=beam(a0,a1,.02,0)

	local dot=Instance.new("Part",workspace)
	dot.Shape=Enum.PartType.Ball
	dot.Size=Vector3.one*.14
	dot.Material=Enum.Material.Neon
	dot.Anchored=true
	dot.CanCollide=false
	dot.CanTouch=false
	dot.CanQuery=false

	local halo=dot:Clone()
	halo.Size=Vector3.one*.28
	halo.Transparency=.6
	halo.Parent=workspace

	local light=Instance.new("PointLight",dot)
	light.Brightness=3
	light.Range=6

	objs={a0,ep,dot,halo}
	local lastM=m

	con=R.RenderStepped:Connect(function()
		if not ON then return clear() end

		local nm=muzzle()
		if nm~=lastM then return start() end

		local rgb=Color3.fromHSV((os.clock()*SPEED)%1,1,1)
		local white=rgb:Lerp(Color3.new(1,1,1),.7)

		glow.Color=ColorSequence.new(rgb)
		mid.Color=ColorSequence.new(rgb)
		core.Color=ColorSequence.new(white)

		dot.Color=white
		halo.Color=rgb
		light.Color=rgb

		local s=Cam.ViewportSize
		local ray=Cam:ViewportPointToRay(s.X/2,s.Y/2)

		local rp=RaycastParams.new()
		rp.FilterType=Enum.RaycastFilterType.Exclude
		rp.FilterDescendantsInstances={LP.Character,ep,dot,halo}

		local hit=workspace:Raycast(ray.Origin,ray.Direction*DIST,rp)

		local pos=hit
			and hit.Position+hit.Normal*.02
			or ray.Origin+ray.Direction*DIST

		ep.Position=pos
		dot.Position=pos
		halo.Position=pos

		dot.Transparency=hit and 0 or 1
		halo.Transparency=hit and .6 or 1
		light.Enabled=hit~=nil

		local pulse=1+math.sin(os.clock()*8)*.05
		core.Width0=.02*pulse core.Width1=core.Width0
		mid.Width0=.045*pulse mid.Width1=mid.Width0
		glow.Width0=.09*pulse glow.Width1=glow.Width0
	end)
end

Misc:Toggle({
	Title="RGB Weapon Laser",
	Desc="3D laser pointer",
	Value=false,
	Callback=function(v)
		ON=v
		if v then start() else clear() end
	end
})

LP.CharacterAdded:Connect(function()
	if ON then
		task.wait(1)
		start()
	end
end)


local R=game:GetService("RunService")
local LP=P.LocalPlayer
local PG=LP:WaitForChild("PlayerGui")

local C={ON=false,S="Cross",Size=10,Gap=5,T=2,Speed=1,Color=Color3.new(1,1,1),RGB=false}
local Styles={"Cross","Cross + Dot","Dot","X","Rhombus","Circle","Dynamic Cross","Pulse","Spin","Orbit","RGB Ring","Sharingan","Manji","Tech","Corners","Nova","Halo","Flower","Radar","Helix"}
local O,M={},{}
local V

local function original(v)
	local g=PG:FindFirstChild("GunOverlay")
	local s=g and g:FindFirstChild("ScreenSize")
	local x=s and s:FindFirstChild("Cross")
	if x then x.Visible=v end
end

local function clear()
	for _,x in ipairs(O) do pcall(function()x:Destroy()end) end
	table.clear(O)table.clear(M)
end

local function F(round,parent)
	local x=Instance.new("Frame")
	x.AnchorPoint=Vector2.new(.5,.5)
	x.BorderSizePixel=0
	x.BackgroundColor3=C.Color
	x.ZIndex=999
	x.Parent=parent or V
	if round then
		local u=Instance.new("UICorner",x)
		u.CornerRadius=UDim.new(1,0)
	end
	O[#O+1]=x
	return x
end

local function L(h,p,n)
	local x=F(false,p)
	x.Size=h and UDim2.fromOffset(n or C.Size,C.T) or UDim2.fromOffset(C.T,n or C.Size)
	return x
end

local function D(sz,p)
	local x=F(true,p)
	sz=sz or C.T+3
	x.Size=UDim2.fromOffset(sz,sz)
	x.Position=UDim2.fromScale(.5,.5)
	return x
end

local function Ring(sz,t,p)
	local x=F(true,p)
	x.Size=UDim2.fromOffset(sz,sz)
	x.Position=UDim2.fromScale(.5,.5)
	x.BackgroundTransparency=1
	local st=Instance.new("UIStroke",x)
	st.Thickness=t or C.T
	st.Color=C.Color
	return x,st
end

local function paint(col)
	for _,x in ipairs(O) do
		if x:IsA("Frame") then
			if x.BackgroundTransparency<1 then x.BackgroundColor3=col end
			local s=x:FindFirstChildOfClass("UIStroke")
			if s then s.Color=col end
		end
	end
end

local function Cross()
	local s,g=C.Size,C.Gap
	local a={L(1),L(1),L(),L()}
	a[1].Position=UDim2.new(.5,-g-s/2,.5,0)
	a[2].Position=UDim2.new(.5,g+s/2,.5,0)
	a[3].Position=UDim2.new(.5,0,.5,-g-s/2)
	a[4].Position=UDim2.new(.5,0,.5,g+s/2)
	return a
end

local function orbit(n,rad,len)
	local a={}
	for i=1,n do
		local h=F(false)
		h.Size=UDim2.fromOffset(1,1)
		h.BackgroundTransparency=1
		h.Position=UDim2.fromScale(.5,.5)
		local x=L(true,h,len)
		x.Position=UDim2.fromOffset(rad,0)
		a[i]=h
	end
	return a
end

local function build()
	clear()
	if not C.ON then return end
	local S,s,g=C.S,C.Size,C.Gap

	if S=="Cross" or S=="Cross + Dot" then
		M.L=Cross()
		if S=="Cross + Dot" then D() end
	elseif S=="Dot" then D(C.T+4)
	elseif S=="X" then
		M.X={L(1,nil,s*2),L(1,nil,s*2)}
		for i,x in ipairs(M.X) do x.Position=UDim2.fromScale(.5,.5)x.Rotation=i==1 and 45 or -45 end
	elseif S=="Rhombus" then
		local d=(s+g)*.72
		M.X={}
		for i=1,4 do
			local x=L(1,nil,s)
			x.Position=UDim2.new(.5,({-d,d,0,0})[i],.5,({0,0,-d,d})[i])
			x.Rotation=({45,-135,-45,135})[i]
			M.X[i]=x
		end
	elseif S=="Circle" then Ring((s+g)*2)
	elseif S=="Dynamic Cross" then M.L=Cross() M.Center=D()
	elseif S=="Pulse" then M.R1=Ring((s+g)*2) M.R2=Ring((s+g)*2) M.Center=D()
	elseif S=="Spin" then M.A=orbit(4,g+s+3,s) M.Center=D()
	elseif S=="Orbit" then
		M.R=Ring((s+g)*2)
		M.D={}
		for i=1,3 do M.D[i]=D(C.T+4) end
		M.Center=D(C.T+2)
	elseif S=="RGB Ring" then
		M.R1=Ring((s+g)*2)
		M.R2=Ring((s+g)*2.55,1)
		M.D={}
		for i=1,3 do M.D[i]=D(C.T+4) end
	elseif S=="Sharingan" then
		local d=(s+g)*2.7
		M.I=F(true) M.I.Size=UDim2.fromOffset(d,d) M.I.Position=UDim2.fromScale(.5,.5) M.I.BackgroundTransparency=.55
		local st=Instance.new("UIStroke",M.I) st.Thickness=2 st.Color=C.Color
		M.R=Ring(d*.62,1.5)
		M.P=D(math.max(5,C.T+4))
		M.T={}
		for i=1,3 do
			local h=F(false) h.Size=UDim2.fromOffset(1,1) h.BackgroundTransparency=1
			local q=D(6,h)
			local tail=F(true,h) tail.Size=UDim2.fromOffset(3,8) tail.Position=UDim2.fromOffset(4,3) tail.Rotation=40
			M.T[i]=h
		end
	elseif S=="Manji" then
		M.A={}
		for i=1,4 do
			local h=F(false) h.Size=UDim2.fromOffset(1,1) h.Position=UDim2.fromScale(.5,.5) h.BackgroundTransparency=1
			local a=L(1,h,s+g) a.AnchorPoint=Vector2.new(0,.5)
			local b=L(false,h,s*.75) b.Position=UDim2.fromOffset(s+g,s*.32)
			h.Rotation=(i-1)*90
			M.A[i]=h
		end
	elseif S=="Tech" then M.R=Ring((s+g)*1.35,1) M.A=orbit(4,g+s+4,s) M.Center=D()
	elseif S=="Corners" then
		M.C={}
		for i=1,8 do M.C[i]=F(false) end
	elseif S=="Nova" then
		M.A=orbit(8,g+s+2,s*.75)
		M.R=Ring((s+g)*1.1,1)
		M.Center=D()
	elseif S=="Halo" then
		M.R1=Ring((s+g)*2)
		M.R2=Ring((s+g)*3,1)
		M.R3=Ring((s+g)*4,.75)
		M.Center=D()
	elseif S=="Flower" then
		M.D={}
		for i=1,6 do M.D[i]=D(math.max(4,C.T+3)) end
		M.Center=D(C.T+3)
	elseif S=="Radar" then
		M.R1=Ring((s+g)*2,1)
		M.R2=Ring((s+g)*3,1)
		M.A=orbit(1,0,(s+g)*3)
	elseif S=="Helix" then
		M.D={}
		for i=1,8 do M.D[i]=D(math.max(3,C.T+2)) end
	end
	paint(C.Color)
end

local old=PG:FindFirstChild("MirrorsCustomCrosshair")
if old then old:Destroy() end

V=Instance.new("ScreenGui")
V.Name="MirrorsCustomCrosshair"
V.IgnoreGuiInset=true
V.ResetOnSpawn=false
V.DisplayOrder=999
V.Parent=PG

R.RenderStepped:Connect(function()
	if not C.ON then return end
	local t=os.clock()*C.Speed
	local S,s,g=C.S,C.Size,C.Gap
	local col=C.RGB and Color3.fromHSV((t*.16)%1,1,1) or C.Color
	paint(col)

	if S=="Dynamic Cross" and M.L then
		local d=g+4+(math.sin(t*5)*.5+.5)*12
		M.L[1].Position=UDim2.new(.5,-d-s/2,.5,0) M.L[2].Position=UDim2.new(.5,d+s/2,.5,0)
		M.L[3].Position=UDim2.new(.5,0,.5,-d-s/2) M.L[4].Position=UDim2.new(.5,0,.5,d+s/2)

	elseif S=="Pulse" and M.R1 then
		local p=(s+g)*2 local q=1+math.sin(t*5)*.2
		M.R1.Size=UDim2.fromOffset(p*q,p*q)
		M.R2.Size=UDim2.fromOffset(p*(1.4-q*.2),p*(1.4-q*.2))

	elseif (S=="Spin" or S=="Tech" or S=="Nova" or S=="Manji") and M.A then
		local speed=S=="Nova" and 75 or S=="Spin" and 110 or 55
		for i,x in ipairs(M.A) do x.Rotation=t*speed+(i-1)*(360/#M.A) end
		if M.R then M.R.Rotation=-t*speed*.5 end

	elseif (S=="Orbit" or S=="RGB Ring") and M.D then
		local rad=g+s+5
		for i,x in ipairs(M.D) do
			local a=math.rad(t*120+(i-1)*120)
			x.Position=UDim2.new(.5,math.cos(a)*rad,.5,math.sin(a)*rad)
		end

	elseif S=="Sharingan" and M.T then
		local d=(s+g)*2.7 local rad=d*.31
		for i,x in ipairs(M.T) do
			local a=t*42+(i-1)*120 local q=math.rad(a)
			x.Position=UDim2.new(.5,math.cos(q)*rad,.5,math.sin(q)*rad)
			x.Rotation=a+55
		end
		M.R.Rotation=-t*18

	elseif S=="Corners" and M.C then
		local d=g+s+math.sin(t*4)*3
		local q={{-d,-d,s,C.T},{-d,-d,C.T,s},{d,-d,s,C.T},{d,-d,C.T,s},{-d,d,s,C.T},{-d,d,C.T,s},{d,d,s,C.T},{d,d,C.T,s}}
		for i,x in ipairs(M.C) do x.Size=UDim2.fromOffset(q[i][3],q[i][4]) x.Position=UDim2.new(.5,q[i][1],.5,q[i][2]) end

	elseif S=="Halo" and M.R1 then
		local a=math.sin(t*3)
		M.R1.Rotation=t*50
		M.R2.Rotation=-t*35
		M.R3.Rotation=t*20
		M.R1.Size=UDim2.fromOffset((s+g)*2*(1+a*.08),(s+g)*2*(1+a*.08))

	elseif S=="Flower" and M.D then
		local rad=g+s
		for i,x in ipairs(M.D) do
			local a=math.rad(t*65+(i-1)*60)
			local q=rad+math.sin(t*4+i)*2
			x.Position=UDim2.new(.5,math.cos(a)*q,.5,math.sin(a)*q)
		end

	elseif S=="Radar" and M.A then
		M.A[1].Rotation=t*130

	elseif S=="Helix" and M.D then
		for i,x in ipairs(M.D) do
			local a=t*3+(i-1)*.7
			local rad=g+s+math.sin(a)*6
			local q=a*55
			x.Position=UDim2.new(.5,math.cos(math.rad(q))*rad,.5,math.sin(math.rad(q))*rad)
		end
	end
end)

Misc:Toggle({
	Title="Custom Crosshair",
	Desc="Replace Flick crosshair",
	Value=false,
	Callback=function(v)
		C.ON=v
		original(not v)
		build()
	end
})

Misc:Dropdown({
	Title="Crosshair Style",
	Values=Styles,
	Value="Cross",
	Callback=function(v)
		if type(v)=="table" then v=v.Title or v.Value end
		if v then C.S=v build() end
	end
})

Misc:Colorpicker({
	Title="Crosshair Color",
	Desc="Crosshair base color",
	Default=Color3.fromRGB(255,255,255),
	Locked=false,
	Flag="flick_crosshair_color",
	Callback=function(v)
		C.Color=v
		if not C.RGB then paint(v) end
	end
})

Misc:Toggle({
	Title="Rainbow Crosshair",
	Desc="Animated RGB color",
	Value=false,
	Callback=function(v)
		C.RGB=v
		if not v then paint(C.Color) end
	end
})

Misc:Slider({
	Title="Crosshair Size",
	Step=1,
	Value={Min=3,Max=35,Default=10},
	Callback=function(v) C.Size=v build() end
})

Misc:Slider({
	Title="Crosshair Gap",
	Step=1,
	Value={Min=0,Max=25,Default=5},
	Callback=function(v) C.Gap=v build() end
})

Misc:Slider({
	Title="Crosshair Thickness",
	Step=1,
	Value={Min=1,Max=7,Default=2},
	Callback=function(v) C.T=v build() end
})

Misc:Slider({
	Title="Animation Speed",
	Step=.1,
	Value={Min=.1,Max=4,Default=1},
	Callback=function(v) C.Speed=v end
})

PG.ChildAdded:Connect(function(x)
	if x.Name=="GunOverlay" and C.ON then
		task.delay(.1,function()original(false)end)
	end
end)

local P,W=game:GetService("Players"),workspace
local Saved,Removed,Con={},{}

local function char(o)
	for _,p in ipairs(P:GetPlayers()) do
		if p.Character and o:IsDescendantOf(p.Character) then return true end
	end
end

local function protected(o)
	if char(o) then return true end
	local p=o
	while p do
		if p:IsA("Tool") or p.Name=="_MirrorsVisual" or p==W:FindFirstChild("ViewModel") then return true end
		p=p.Parent
	end
end

local function set(o,k,v)
	Saved[o]=Saved[o] or {}
	if Saved[o][k]==nil then pcall(function() Saved[o][k]=o[k] end) end
	pcall(function() o[k]=v end)
end

local function flat(o)
	if protected(o) then return end
	if o:IsA("BasePart") then
		set(o,"Material",Enum.Material.SmoothPlastic)
		set(o,"MaterialVariant","")
		set(o,"Reflectance",0)
		set(o,"CastShadow",false)
		if o:IsA("MeshPart") then set(o,"TextureID","") end
	elseif o:IsA("SpecialMesh") then
		set(o,"TextureId","")
	elseif o:IsA("Decal") or o:IsA("Texture") then
		set(o,"Transparency",1)
	elseif o:IsA("SurfaceAppearance") then
		if not Removed[o] then Removed[o]=o.Parent o.Parent=nil end
	elseif o:IsA("ParticleEmitter") or o:IsA("Trail") or o:IsA("Beam")
	or o:IsA("Smoke") or o:IsA("Fire") or o:IsA("Sparkles") then
		set(o,"Enabled",false)
	end
end

local function enable()
	for i,o in ipairs(W:GetDescendants()) do
		flat(o)
		if i%700==0 then task.wait() end
	end
	Con=W.DescendantAdded:Connect(function(o) task.defer(flat,o) end)
end

local function disable()
	if Con then Con:Disconnect() Con=nil end
	for o,parent in pairs(Removed) do
		if o and parent and parent.Parent then pcall(function() o.Parent=parent end) end
	end
	for o,t in pairs(Saved) do
		if o and o.Parent then
			for k,v in pairs(t) do pcall(function() o[k]=v end) end
		end
	end
	table.clear(Removed)
	table.clear(Saved)
end

Misc:Toggle({
	Title="Performance Mode",
	Desc="Removes map textures and effects",
	Value=false,
	Callback=function(v)
		if v then enable() else disable() end
	end
})
