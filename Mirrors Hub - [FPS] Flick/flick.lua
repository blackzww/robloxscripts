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
local Camera=workspace.CurrentCamera

local VM=require(RS.ModuleScripts.cj)

local V={
	X=0,
	Y=0,
	Z=0,
	FOV=70
}

local function GetTool()
	local p=game:GetService("Players").LocalPlayer
	local c=p.Character
	return c and c:FindFirstChildOfClass("Tool")
end

local function UpdateView()
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
end

Misc:Slider({
	Title="ViewModel X",
	Desc="Left / Right",
	Step=.05,
	Value={
		Min=-5,
		Max=5,
		Default=0
	},
	Callback=function(v)
		V.X=v
		UpdateView()
	end
})

Misc:Slider({
	Title="ViewModel Y",
	Desc="Up / Down",
	Step=.05,
	Value={
		Min=-5,
		Max=5,
		Default=0
	},
	Callback=function(v)
		V.Y=v
		UpdateView()
	end
})

Misc:Slider({
	Title="ViewModel Z",
	Desc="Forward / Back",
	Step=.05,
	Value={
		Min=-10,
		Max=10,
		Default=0
	},
	Callback=function(v)
		V.Z=v
		UpdateView()
	end
})

Misc:Slider({
	Title="ViewModel FOV",
	Desc="Camera FOV",
	Step=1,
	Value={
		Min=40,
		Max=120,
		Default=70
	},
	Callback=function(v)
		V.FOV=v
		Camera.FieldOfView=v
	end
})

Misc:Button({
	Title="Reset ViewModel",
	Icon="rotate-ccw",
	Callback=function()
		V.X=0
		V.Y=0
		V.Z=0
		V.FOV=70

		Camera.FieldOfView=70
		UpdateView()
	end
})
