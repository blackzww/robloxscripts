--==================================================
-- MIRRORS HUB - [FPS] FLICK
-- v1.4.1 FULL RESTORED
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
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")
local Camera = Workspace.CurrentCamera

local Players=game:GetService("Players")
local HttpService=game:GetService("HttpService")
local Analytics=game:GetService("RbxAnalyticsService")

local LP=Players.LocalPlayer

local Request=
	(syn and syn.request)
	or http_request
	or request

if not Request then
	error("[MIRRORS] HTTP requests are not supported.")
end

local API="https://mirrorshub-key.vercel.app/api/validate-key"

local KeyInfo={
	Status="Unknown",
	Provider="Unknown",
	ExpiresAt=nil
}

local KeyMessages={
	INVALID_KEY="Invalid key.",
	INVALID_HWID="Unable to identify this device.",
	HWID_MISMATCH="This key is linked to another device.",
	KEY_PAUSED="This key is paused.",
	KEY_INACTIVE="This key is inactive.",
	KEY_EXPIRED="This key has expired.",
	ACCESS_DENIED="Access denied.",
	USER_BANNED="Access denied.",
	VALIDATION_ERROR="Unable to validate key."
}

local function GetExecutor()
	if identifyexecutor then
		local ok,name=pcall(identifyexecutor)
		if ok and name then return tostring(name) end
	end

	if getexecutorname then
		local ok,name=pcall(getexecutorname)
		if ok and name then return tostring(name) end
	end

	return "Unknown"
end

local function GetHWID()
	if gethwid then
		local ok,value=pcall(gethwid)

		if ok and value then
			value=tostring(value)

			if #value>=8 and #value<=256 then
				return value
			end
		end
	end

	local ok,value=pcall(function()
		return Analytics:GetClientId()
	end)

	if ok and value then
		value=tostring(value)

		if #value>=8 and #value<=256 then
			return value
		end
	end
end

local function ValidateKey(key)
	key=tostring(key or ""):match("^%s*(.-)%s*$")

	if key=="" then
		return false
	end

	local hwid=GetHWID()

	if not hwid then
		warn("[MIRRORS] Unable to identify this device.")
		return false
	end

	local ok,res=pcall(function()
		return Request({
			Url=API,
			Method="POST",
			Headers={
				["Content-Type"]="application/json",
				["Accept"]="application/json"
			},
			Body=HttpService:JSONEncode({
				key=key,
				hwid=hwid,
				robloxUserId=LP.UserId,
				robloxUsername=LP.Name,
				robloxDisplayName=LP.DisplayName,
				executor=GetExecutor(),
				placeId=game.PlaceId,
				jobId=game.JobId
			})
		})
	end)

	if not ok or type(res)~="table" then
		warn("[MIRRORS] Server connection failed.")
		return false
	end

	local raw=res.Body or res.body or res.ResponseBody or ""
	local decoded,data=pcall(
		HttpService.JSONDecode,
		HttpService,
		raw
	)

	if not decoded or type(data)~="table" then
		warn("[MIRRORS] Invalid server response.")
		return false
	end

	if data.valid==true then
		KeyInfo.Status="Active"
		KeyInfo.Provider=data.provider or "Unknown"
		KeyInfo.ExpiresAt=data.expiresAt

		return true
	end

	local code=tostring(
		data.code or "VALIDATION_ERROR"
	)

	KeyInfo.Status=code

	warn(
		"[MIRRORS] "
		..tostring(
			KeyMessages[code] or code
		)
	)

	return false
end

local function FormatProvider(provider)
	local names={
		LOOTLABS="LootLabs",
		LINKVERTISE="Linkvertise",
		PROMO="Promo",
		ADMIN="Admin"
	}

	return names[provider]
		or provider
		or "Unknown"
end

local function RemainingTime(iso)
	if not iso then
		return "Unknown"
	end

	local ok,expires=pcall(
		DateTime.fromIsoDate,
		iso
	)

	if not ok or not expires then
		return "Unknown"
	end

	local seconds=math.floor(
		(
			expires.UnixTimestampMillis
			-DateTime.now().UnixTimestampMillis
		)/1000
	)

	if seconds<=0 then
		return "Expired"
	end

	local days=math.floor(seconds/86400)
	local hours=math.floor(seconds%86400/3600)
	local minutes=math.floor(seconds%3600/60)

	if days>0 then
		return string.format(
			"%dd %dh %dm",
			days,
			hours,
			minutes
		)
	end

	if hours>0 then
		return string.format(
			"%dh %dm",
			hours,
			minutes
		)
	end

	return string.format("%dm",minutes)
end

--==================================================
-- CLEAN OLD EXECUTION
--==================================================
local Env = getgenv()
if Env.MirrorsFlickRuntime and Env.MirrorsFlickRuntime.Cleanup then
	pcall(Env.MirrorsFlickRuntime.Cleanup)
end
local Runtime={Alive=true,Connections={},Cleanups={},Window=nil,CurrentConfig=nil,CurrentConfigName="default",Notifications=true,FPSCap=0}
Env.MirrorsFlickRuntime=Runtime
local function AddConnection(c)
	if c then table.insert(Runtime.Connections,c) end
	return c
end
local function AddCleanup(fn)
	if type(fn)=="function" then table.insert(Runtime.Cleanups,fn) end
	return fn
end
local function Notify(title,content,icon,duration)
	if not Runtime.Notifications then return end
	pcall(function() WindUI:Notify({Title=title or "Mirrors Hub",Content=content or "",Icon=icon,Duration=duration or 3}) end)
end
local function CopyText(text)
	local copy=setclipboard or toclipboard
	if not copy then Notify("Clipboard","Clipboard is not supported by this executor.","x",3) return false end
	local ok=pcall(copy,tostring(text))
	if ok then Notify("Mirrors Hub","Copied to clipboard.","copy",2) end
	return ok
end
Runtime.Cleanup=function()
	if not Runtime.Alive then return end
	Runtime.Alive=false
	for i=#Runtime.Cleanups,1,-1 do pcall(Runtime.Cleanups[i]) end
	for _,c in ipairs(Runtime.Connections) do pcall(function() c:Disconnect() end) end
	table.clear(Runtime.Connections)
	table.clear(Runtime.Cleanups)
	pcall(function()
		if Runtime.Window and Runtime.Window.Destroy then Runtime.Window:Destroy() end
	end)
	if Env.MirrorsFlickRuntime==Runtime then Env.MirrorsFlickRuntime=nil end
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
	KeySystem={
		Title="Access Required",
		Note="Get your key from the official Mirrors Hub website.",
		KeyValidator=ValidateKey,
		SaveKey=true,
		URL="https://mirrorshub-key.vercel.app/api/session",
		Thumbnail={
			Image="rbxassetid://132532585504638",
			Title="Mirrors Hub"
		}
	},
		
	User = {
		Enabled = true,
		Anonymous = false
	}
})
Runtime.Window = Window
Window:Tag({
	Title = "v1.4.1",
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
local Visuals = Window:Tab({
	Title = "Visuals",
	Icon = "palette"
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
		"Version 1.4.1\n" ..
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
if not DrawingSupported then Settings.ESPMode="Highlight" end
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
AddCleanup(function()
	if BulletHandler.Fire==HookedFire then BulletHandler.Fire=OriginalFire end
end)
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
		if type(value)=="table" then value=value.Value or value.Title or value[1] end
		Settings.TargetMode=value or "Crosshair Priority"
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
	Value = DrawingSupported and "Box" or "Highlight",
	Callback = function(value)
		if type(value)=="table" then value=value.Value or value.Title or value[1] end
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
-- MOVEMENT
--==================================================
local Movement={SpeedEnabled=false,Speed=32,JumpEnabled=false,JumpPower=75,InfiniteJump=false}
local HumanoidDefaults=setmetatable({},{__mode="k"})
local function GetHumanoid()
	local c=LP.Character
	return c and c:FindFirstChildOfClass("Humanoid")
end
local function SaveHumanoid(h)
	if not h or HumanoidDefaults[h] then return end
	HumanoidDefaults[h]={WalkSpeed=h.WalkSpeed,JumpPower=h.JumpPower,JumpHeight=h.JumpHeight,UseJumpPower=h.UseJumpPower}
end
local function RestoreMovement(h,restoreSpeed,restoreJump)
	local d=h and HumanoidDefaults[h]
	if not d then return end
	pcall(function()
		if restoreSpeed then h.WalkSpeed=d.WalkSpeed end
		if restoreJump then
			h.UseJumpPower=d.UseJumpPower
			h.JumpPower=d.JumpPower
			h.JumpHeight=d.JumpHeight
		end
	end)
end
local function ApplyMovement()
	local h=GetHumanoid()
	if not h then return end
	SaveHumanoid(h)
	if Movement.SpeedEnabled then pcall(function() h.WalkSpeed=Movement.Speed end) end
	if Movement.JumpEnabled then
		pcall(function()
			h.UseJumpPower=true
			h.JumpPower=Movement.JumpPower
		end)
	end
end
AddConnection(RunService.Heartbeat:Connect(function()
	if Runtime.Alive and (Movement.SpeedEnabled or Movement.JumpEnabled) then ApplyMovement() end
end))
AddConnection(UserInputService.JumpRequest:Connect(function()
	if not Runtime.Alive or not Movement.InfiniteJump then return end
	local h=GetHumanoid()
	if h then pcall(function() h:ChangeState(Enum.HumanoidStateType.Jumping) end) end
end))
AddCleanup(function()
	Movement.SpeedEnabled=false
	Movement.JumpEnabled=false
	Movement.InfiniteJump=false
	for h in pairs(HumanoidDefaults) do RestoreMovement(h,true,true) end
end)
Main:Paragraph({Title="Movement",Desc="Speed • Jump • Infinite Jump",Image="move"})
Main:Toggle({Title="Speed Boost",Desc="Keep a custom WalkSpeed.",Value=false,Flag="flick_speed_boost",Callback=function(v)
	Movement.SpeedEnabled=v
	local h=GetHumanoid()
	if h then SaveHumanoid(h) if v then ApplyMovement() else RestoreMovement(h,true,false) end end
end})
Main:Slider({Title="Speed",Desc="WalkSpeed while Speed Boost is enabled.",Step=1,Value={Min=16,Max=100,Default=32},Flag="flick_speed",Callback=function(v)
	Movement.Speed=tonumber(v) or 32
	if Movement.SpeedEnabled then ApplyMovement() end
end})
Main:Toggle({Title="Jump Boost",Desc="Keep a custom jump power.",Value=false,Flag="flick_jump_boost",Callback=function(v)
	Movement.JumpEnabled=v
	local h=GetHumanoid()
	if h then SaveHumanoid(h) if v then ApplyMovement() else RestoreMovement(h,false,true) end end
end})
Main:Slider({Title="Jump Power",Desc="Jump strength while Jump Boost is enabled.",Step=1,Value={Min=50,Max=150,Default=75},Flag="flick_jump_power",Callback=function(v)
	Movement.JumpPower=tonumber(v) or 75
	if Movement.JumpEnabled then ApplyMovement() end
end})
Main:Toggle({Title="Infinite Jump",Desc="Jump again while airborne.",Value=false,Flag="flick_infinite_jump",Callback=function(v) Movement.InfiniteJump=v end})
--==================================================
-- VIEWMODEL
--==================================================
local VM
pcall(function() VM=require(ReplicatedStorage:WaitForChild("ModuleScripts"):WaitForChild("cj")) end)
local OriginalFOV=(Workspace.CurrentCamera and Workspace.CurrentCamera.FieldOfView) or 70
local View={X=0,Y=0,Z=0,RX=0,RY=0,RZ=0,FOV=OriginalFOV,Locked=false}
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
		if v:IsA("Motor6D") and v.Name=="ToolGrip" and v.Part1 and v.Part1:IsDescendantOf(tool) then return v end
	end
end
local function LockView() View.Locked=true end
local function UpdateRotation()
	if not View.Locked then return end
	local tool=GetTool()
	local grip=tool and GetGrip(tool)
	if not grip then return end
	if not GripBases[grip] then GripBases[grip]=grip.C0 end
	grip.C0=GripBases[grip]*CFrame.Angles(math.rad(View.RX),math.rad(View.RY),math.rad(View.RZ))
end
local function UpdateView()
	if not View.Locked or not VM then return end
	local tool=GetTool()
	if not tool then return end
	local base=tool:GetAttribute("ViewModelOffset")
	if typeof(base)~="Vector3" then base=Vector3.zero end
	pcall(function() VM:onViewModelOffsetChanged(base+Vector3.new(View.X,View.Y,View.Z),.08,Enum.EasingStyle.Quad) end)
	UpdateRotation()
end
local function SetupTool(tool)
	if ToolConnection then ToolConnection:Disconnect() ToolConnection=nil end
	task.delay(.1,UpdateView)
	if tool then ToolConnection=tool.Activated:Connect(function() task.delay(.45,UpdateView) end) end
end
local function SetupCharacter(c)
	local tool=c:FindFirstChildOfClass("Tool")
	if tool then SetupTool(tool) end
	AddConnection(c.ChildAdded:Connect(function(v) if v:IsA("Tool") then SetupTool(v) end end))
end
if LP.Character then SetupCharacter(LP.Character) end
AddConnection(LP.CharacterAdded:Connect(SetupCharacter))
AddConnection(RunService.RenderStepped:Connect(function()
	if not Runtime.Alive or not View.Locked then return end
	local cam=Workspace.CurrentCamera
	if cam and math.abs(cam.FieldOfView-View.FOV)>.01 then cam.FieldOfView=View.FOV end
	UpdateRotation()
end))
local function ResetViewModel()
	View.Locked=false
	View.X,View.Y,View.Z=0,0,0
	View.RX,View.RY,View.RZ=0,0,0
	View.FOV=OriginalFOV
	for grip,base in pairs(GripBases) do if grip and grip.Parent then pcall(function() grip.C0=base end) end end
	table.clear(GripBases)
	local cam=Workspace.CurrentCamera
	if cam then cam.FieldOfView=OriginalFOV end
	local tool=GetTool()
	if VM and tool then
		local base=tool:GetAttribute("ViewModelOffset")
		if typeof(base)~="Vector3" then base=Vector3.zero end
		pcall(function() VM:onViewModelOffsetChanged(base,.12,Enum.EasingStyle.Quad) end)
	end
end
AddCleanup(function()
	if ToolConnection then ToolConnection:Disconnect() ToolConnection=nil end
	ResetViewModel()
end)
Visuals:Paragraph({Title="ViewModel",Desc="Position • Rotation • locked FOV",Image="scan"})
for _,d in ipairs({
	{"ViewModel X","Left / Right","X",-5,5,.05},
	{"ViewModel Y","Up / Down","Y",-5,5,.05},
	{"ViewModel Z","Forward / Back","Z",-10,10,.05},
	{"Rotation X","Pitch","RX",-180,180,1},
	{"Rotation Y","Yaw","RY",-180,180,1},
	{"Rotation Z","Roll","RZ",-180,180,1}
}) do
	Visuals:Slider({Title=d[1],Desc=d[2],Step=d[6],Value={Min=d[4],Max=d[5],Default=0},Callback=function(v)
		View[d[3]]=tonumber(v) or 0 LockView() UpdateView()
	end})
end
Visuals:Slider({Title="ViewModel FOV",Desc="Locked camera FOV",Step=1,Value={Min=40,Max=200,Default=math.clamp(OriginalFOV,40,200)},Callback=function(v)
	View.FOV=tonumber(v) or OriginalFOV LockView()
	local cam=Workspace.CurrentCamera if cam then cam.FieldOfView=View.FOV end
end})
Visuals:Button({Title="Reset ViewModel",Icon="rotate-ccw",Callback=ResetViewModel})
--==================================================
-- RGB WEAPON LASER
--==================================================
local Laser={Enabled=false,Distance=5000,Speed=.12,Muzzle=nil,Objects={}}
local function LaserClear()
	for _,o in ipairs(Laser.Objects) do pcall(function() o:Destroy() end) end
	table.clear(Laser.Objects)
	Laser.Muzzle=nil
end
local function GetMuzzle()
	local t=GetTool()
	local m=t and t:FindFirstChild("Muz",true)
	return m and m:IsA("BasePart") and m or nil
end
local function NewBeam(a,b,w,tr)
	local x=Instance.new("Beam")
	x.Attachment0=a x.Attachment1=b x.Width0=w x.Width1=w x.FaceCamera=true x.LightEmission=1 x.LightInfluence=0 x.Transparency=NumberSequence.new(tr) x.Parent=a.Parent
	return x
end
local function LaserCreate(m)
	LaserClear()
	if not m then return end
	Laser.Muzzle=m
	local a0=Instance.new("Attachment") a0.Name="MirrorsLaser" a0.Parent=m
	local loc=m:FindFirstChild("LOC") if loc and loc:IsA("Attachment") then a0.CFrame=loc.CFrame end
	local ep=Instance.new("Part") ep.Name="MirrorsLaserEnd" ep.Size=Vector3.one*.01 ep.Transparency=1 ep.Anchored=true ep.CanCollide=false ep.CanTouch=false ep.CanQuery=false ep.Parent=Workspace
	local a1=Instance.new("Attachment",ep)
	local glow=NewBeam(a0,a1,.09,.65)
	local mid=NewBeam(a0,a1,.045,.18)
	local core=NewBeam(a0,a1,.02,0)
	local dot=Instance.new("Part") dot.Name="MirrorsLaserDot" dot.Shape=Enum.PartType.Ball dot.Size=Vector3.one*.14 dot.Material=Enum.Material.Neon dot.Anchored=true dot.CanCollide=false dot.CanTouch=false dot.CanQuery=false dot.Parent=Workspace
	local halo=dot:Clone() halo.Name="MirrorsLaserHalo" halo.Size=Vector3.one*.28 halo.Transparency=.6 halo.Parent=Workspace
	local light=Instance.new("PointLight",dot) light.Brightness=3 light.Range=6
	Laser.Objects={a0,ep,glow,mid,core,dot,halo}
end
AddConnection(RunService.RenderStepped:Connect(function()
	if not Runtime.Alive or not Laser.Enabled then return end
	local m=GetMuzzle()
	if m~=Laser.Muzzle then LaserCreate(m) end
	if not m or #Laser.Objects<7 then return end
	local a0,ep,glow,mid,core,dot,halo=table.unpack(Laser.Objects)
	local cam=Workspace.CurrentCamera
	if not cam or not a0.Parent or not ep.Parent then return end
	local rgb=Color3.fromHSV((os.clock()*Laser.Speed)%1,1,1)
	local white=rgb:Lerp(Color3.new(1,1,1),.7)
	glow.Color=ColorSequence.new(rgb) mid.Color=ColorSequence.new(rgb) core.Color=ColorSequence.new(white)
	dot.Color=white halo.Color=rgb
	local light=dot:FindFirstChildOfClass("PointLight") if light then light.Color=rgb end
	local s=cam.ViewportSize
	local ray=cam:ViewportPointToRay(s.X/2,s.Y/2)
	local rp=RaycastParams.new() rp.FilterType=Enum.RaycastFilterType.Exclude rp.FilterDescendantsInstances={LP.Character,ep,dot,halo}
	local hit=Workspace:Raycast(ray.Origin,ray.Direction*Laser.Distance,rp)
	local pos=hit and hit.Position+hit.Normal*.02 or ray.Origin+ray.Direction*Laser.Distance
	ep.Position=pos dot.Position=pos halo.Position=pos
	dot.Transparency=hit and 0 or 1 halo.Transparency=hit and .6 or 1 if light then light.Enabled=hit~=nil end
	local pulse=1+math.sin(os.clock()*8)*.05
	core.Width0=.02*pulse core.Width1=core.Width0 mid.Width0=.045*pulse mid.Width1=mid.Width0 glow.Width0=.09*pulse glow.Width1=glow.Width0
end))
AddCleanup(function() Laser.Enabled=false LaserClear() end)
Visuals:Toggle({Title="RGB Weapon Laser",Desc="3D RGB laser pointer",Value=false,Flag="flick_rgb_laser",Callback=function(v) Laser.Enabled=v if not v then LaserClear() end end})
--==================================================
-- CUSTOM CROSSHAIR
--==================================================
local Crosshair={ON=false,S="Cross",Size=10,Gap=5,T=2,Speed=1,Color=Color3.new(1,1,1),RGB=false}
local CrosshairStyles={"Cross","Cross + Dot","Dot","X","Rhombus","Circle","Dynamic Cross","Pulse","Spin","Orbit","RGB Ring","Sharingan","Manji","Tech","Corners","Nova","Halo","Flower","Radar","Helix"}
local CrossObjects,CrossMap={},{}
local CrossGUI
local function OriginalCrosshair(v)
	local g=PG:FindFirstChild("GunOverlay")
	local s=g and g:FindFirstChild("ScreenSize")
	local x=s and s:FindFirstChild("Cross")
	if x then x.Visible=v end
end
local function ClearCrosshair()
	for _,x in ipairs(CrossObjects) do pcall(function() x:Destroy() end) end
	table.clear(CrossObjects) table.clear(CrossMap)
end
local function CF(round,parent)
	local x=Instance.new("Frame") x.AnchorPoint=Vector2.new(.5,.5) x.BorderSizePixel=0 x.BackgroundColor3=Crosshair.Color x.ZIndex=999 x.Parent=parent or CrossGUI
	if round then local u=Instance.new("UICorner",x) u.CornerRadius=UDim.new(1,0) end
	table.insert(CrossObjects,x) return x
end
local function CL(h,p,n)
	local x=CF(false,p) x.Size=h and UDim2.fromOffset(n or Crosshair.Size,Crosshair.T) or UDim2.fromOffset(Crosshair.T,n or Crosshair.Size) return x
end
local function CD(sz,p)
	local x=CF(true,p) sz=sz or Crosshair.T+3 x.Size=UDim2.fromOffset(sz,sz) x.Position=UDim2.fromScale(.5,.5) return x
end
local function CRing(sz,t,p)
	local x=CF(true,p) x.Size=UDim2.fromOffset(sz,sz) x.Position=UDim2.fromScale(.5,.5) x.BackgroundTransparency=1
	local st=Instance.new("UIStroke",x) st.Thickness=t or Crosshair.T st.Color=Crosshair.Color return x,st
end
local function CrossPaint(col)
	for _,x in ipairs(CrossObjects) do
		if x:IsA("Frame") then
			if x.BackgroundTransparency<1 then x.BackgroundColor3=col end
			local st=x:FindFirstChildOfClass("UIStroke") if st then st.Color=col end
		end
	end
end
local function CrossLines()
	local s,g=Crosshair.Size,Crosshair.Gap
	local a={CL(true),CL(true),CL(false),CL(false)}
	a[1].Position=UDim2.new(.5,-g-s/2,.5,0) a[2].Position=UDim2.new(.5,g+s/2,.5,0) a[3].Position=UDim2.new(.5,0,.5,-g-s/2) a[4].Position=UDim2.new(.5,0,.5,g+s/2)
	return a
end
local function CrossOrbit(n,rad,len)
	local a={}
	for i=1,n do
		local h=CF(false) h.Size=UDim2.fromOffset(1,1) h.BackgroundTransparency=1 h.Position=UDim2.fromScale(.5,.5)
		local x=CL(true,h,len) x.Position=UDim2.fromOffset(rad,0) a[i]=h
	end
	return a
end
local function BuildCrosshair()
	ClearCrosshair()
	if not Crosshair.ON then return end
	local S,s,g=Crosshair.S,Crosshair.Size,Crosshair.Gap
	if S=="Cross" or S=="Cross + Dot" then CrossMap.L=CrossLines() if S=="Cross + Dot" then CD() end
	elseif S=="Dot" then CD(Crosshair.T+4)
	elseif S=="X" then CrossMap.X={CL(true,nil,s*2),CL(true,nil,s*2)} for i,x in ipairs(CrossMap.X) do x.Position=UDim2.fromScale(.5,.5) x.Rotation=i==1 and 45 or -45 end
	elseif S=="Rhombus" then
		local d=(s+g)*.72 CrossMap.X={}
		for i=1,4 do local x=CL(true,nil,s) x.Position=UDim2.new(.5,({-d,d,0,0})[i],.5,({0,0,-d,d})[i]) x.Rotation=({45,-135,-45,135})[i] CrossMap.X[i]=x end
	elseif S=="Circle" then CRing((s+g)*2)
	elseif S=="Dynamic Cross" then CrossMap.L=CrossLines() CrossMap.Center=CD()
	elseif S=="Pulse" then CrossMap.R1=CRing((s+g)*2) CrossMap.R2=CRing((s+g)*2) CrossMap.Center=CD()
	elseif S=="Spin" then CrossMap.A=CrossOrbit(4,g+s+3,s) CrossMap.Center=CD()
	elseif S=="Orbit" then CrossMap.R=CRing((s+g)*2) CrossMap.D={} for i=1,3 do CrossMap.D[i]=CD(Crosshair.T+4) end CrossMap.Center=CD(Crosshair.T+2)
	elseif S=="RGB Ring" then CrossMap.R1=CRing((s+g)*2) CrossMap.R2=CRing((s+g)*2.55,1) CrossMap.D={} for i=1,3 do CrossMap.D[i]=CD(Crosshair.T+4) end
	elseif S=="Sharingan" then
		local d=(s+g)*2.7 CrossMap.I=CF(true) CrossMap.I.Size=UDim2.fromOffset(d,d) CrossMap.I.Position=UDim2.fromScale(.5,.5) CrossMap.I.BackgroundTransparency=.55
		local st=Instance.new("UIStroke",CrossMap.I) st.Thickness=2 st.Color=Crosshair.Color CrossMap.R=CRing(d*.62,1.5) CrossMap.P=CD(math.max(5,Crosshair.T+4)) CrossMap.T={}
		for i=1,3 do local h=CF(false) h.Size=UDim2.fromOffset(1,1) h.BackgroundTransparency=1 CD(6,h) local tail=CF(true,h) tail.Size=UDim2.fromOffset(3,8) tail.Position=UDim2.fromOffset(4,3) tail.Rotation=40 CrossMap.T[i]=h end
	elseif S=="Manji" then
		CrossMap.A={}
		for i=1,4 do local h=CF(false) h.Size=UDim2.fromOffset(1,1) h.Position=UDim2.fromScale(.5,.5) h.BackgroundTransparency=1 local a=CL(true,h,s+g) a.AnchorPoint=Vector2.new(0,.5) local b=CL(false,h,s*.75) b.Position=UDim2.fromOffset(s+g,s*.32) h.Rotation=(i-1)*90 CrossMap.A[i]=h end
	elseif S=="Tech" then CrossMap.R=CRing((s+g)*1.35,1) CrossMap.A=CrossOrbit(4,g+s+4,s) CrossMap.Center=CD()
	elseif S=="Corners" then CrossMap.C={} for i=1,8 do CrossMap.C[i]=CF(false) end
	elseif S=="Nova" then CrossMap.A=CrossOrbit(8,g+s+2,s*.75) CrossMap.R=CRing((s+g)*1.1,1) CrossMap.Center=CD()
	elseif S=="Halo" then CrossMap.R1=CRing((s+g)*2) CrossMap.R2=CRing((s+g)*3,1) CrossMap.R3=CRing((s+g)*4,.75) CrossMap.Center=CD()
	elseif S=="Flower" then CrossMap.D={} for i=1,6 do CrossMap.D[i]=CD(math.max(4,Crosshair.T+3)) end CrossMap.Center=CD(Crosshair.T+3)
	elseif S=="Radar" then CrossMap.R1=CRing((s+g)*2,1) CrossMap.R2=CRing((s+g)*3,1) CrossMap.A=CrossOrbit(1,0,(s+g)*3)
	elseif S=="Helix" then CrossMap.D={} for i=1,8 do CrossMap.D[i]=CD(math.max(3,Crosshair.T+2)) end end
	CrossPaint(Crosshair.Color)
end
local oldCross=PG:FindFirstChild("MirrorsCustomCrosshair") if oldCross then oldCross:Destroy() end
CrossGUI=Instance.new("ScreenGui") CrossGUI.Name="MirrorsCustomCrosshair" CrossGUI.IgnoreGuiInset=true CrossGUI.ResetOnSpawn=false CrossGUI.DisplayOrder=999 CrossGUI.Parent=PG
AddConnection(RunService.RenderStepped:Connect(function()
	if not Runtime.Alive or not Crosshair.ON then return end
	OriginalCrosshair(false)
	local t=os.clock()*Crosshair.Speed local S,s,g=Crosshair.S,Crosshair.Size,Crosshair.Gap local col=Crosshair.RGB and Color3.fromHSV((t*.16)%1,1,1) or Crosshair.Color CrossPaint(col)
	if S=="Dynamic Cross" and CrossMap.L then
		local d=g+4+(math.sin(t*5)*.5+.5)*12 CrossMap.L[1].Position=UDim2.new(.5,-d-s/2,.5,0) CrossMap.L[2].Position=UDim2.new(.5,d+s/2,.5,0) CrossMap.L[3].Position=UDim2.new(.5,0,.5,-d-s/2) CrossMap.L[4].Position=UDim2.new(.5,0,.5,d+s/2)
	elseif S=="Pulse" and CrossMap.R1 then
		local p=(s+g)*2 local q=1+math.sin(t*5)*.2 CrossMap.R1.Size=UDim2.fromOffset(p*q,p*q) CrossMap.R2.Size=UDim2.fromOffset(p*(1.4-q*.2),p*(1.4-q*.2))
	elseif (S=="Spin" or S=="Tech" or S=="Nova" or S=="Manji") and CrossMap.A then
		local speed=S=="Nova" and 75 or S=="Spin" and 110 or 55 for i,x in ipairs(CrossMap.A) do x.Rotation=t*speed+(i-1)*(360/#CrossMap.A) end if CrossMap.R then CrossMap.R.Rotation=-t*speed*.5 end
	elseif (S=="Orbit" or S=="RGB Ring") and CrossMap.D then
		local rad=g+s+5 for i,x in ipairs(CrossMap.D) do local a=math.rad(t*120+(i-1)*120) x.Position=UDim2.new(.5,math.cos(a)*rad,.5,math.sin(a)*rad) end
	elseif S=="Sharingan" and CrossMap.T then
		local d=(s+g)*2.7 local rad=d*.31 for i,x in ipairs(CrossMap.T) do local a=t*42+(i-1)*120 local q=math.rad(a) x.Position=UDim2.new(.5,math.cos(q)*rad,.5,math.sin(q)*rad) x.Rotation=a+55 end CrossMap.R.Rotation=-t*18
	elseif S=="Corners" and CrossMap.C then
		local d=g+s+math.sin(t*4)*3 local q={{-d,-d,s,Crosshair.T},{-d,-d,Crosshair.T,s},{d,-d,s,Crosshair.T},{d,-d,Crosshair.T,s},{-d,d,s,Crosshair.T},{-d,d,Crosshair.T,s},{d,d,s,Crosshair.T},{d,d,Crosshair.T,s}}
		for i,x in ipairs(CrossMap.C) do x.Size=UDim2.fromOffset(q[i][3],q[i][4]) x.Position=UDim2.new(.5,q[i][1],.5,q[i][2]) end
	elseif S=="Halo" and CrossMap.R1 then
		local a=math.sin(t*3) CrossMap.R1.Rotation=t*50 CrossMap.R2.Rotation=-t*35 CrossMap.R3.Rotation=t*20 CrossMap.R1.Size=UDim2.fromOffset((s+g)*2*(1+a*.08),(s+g)*2*(1+a*.08))
	elseif S=="Flower" and CrossMap.D then
		local rad=g+s for i,x in ipairs(CrossMap.D) do local a=math.rad(t*65+(i-1)*60) local q=rad+math.sin(t*4+i)*2 x.Position=UDim2.new(.5,math.cos(a)*q,.5,math.sin(a)*q) end
	elseif S=="Radar" and CrossMap.A then CrossMap.A[1].Rotation=t*130
	elseif S=="Helix" and CrossMap.D then
		for i,x in ipairs(CrossMap.D) do local a=t*3+(i-1)*.7 local rad=g+s+math.sin(a)*6 local q=a*55 x.Position=UDim2.new(.5,math.cos(math.rad(q))*rad,.5,math.sin(math.rad(q))*rad) end
	end
end))
AddCleanup(function()
	Crosshair.ON=false OriginalCrosshair(true) ClearCrosshair()
	if CrossGUI then CrossGUI:Destroy() CrossGUI=nil end
end)
Visuals:Paragraph({Title="Crosshair",Desc="20 custom styles • animated • RGB",Image="crosshair"})
Visuals:Toggle({Title="Custom Crosshair",Desc="Replace Flick crosshair",Value=false,Flag="flick_custom_crosshair",Callback=function(v) Crosshair.ON=v OriginalCrosshair(not v) BuildCrosshair() end})
Visuals:Dropdown({Title="Crosshair Style",Values=CrosshairStyles,Value="Cross",Callback=function(v) if type(v)=="table" then v=v.Value or v.Title or v[1] end if v then Crosshair.S=v BuildCrosshair() end end})
Visuals:Colorpicker({Title="Crosshair Color",Desc="Crosshair base color",Default=Color3.fromRGB(255,255,255),Locked=false,Flag="flick_crosshair_color",Callback=function(v) Crosshair.Color=v if not Crosshair.RGB then CrossPaint(v) end end})
Visuals:Toggle({Title="Rainbow Crosshair",Desc="Animated RGB color",Value=false,Flag="flick_crosshair_rgb",Callback=function(v) Crosshair.RGB=v if not v then CrossPaint(Crosshair.Color) end end})
Visuals:Slider({Title="Crosshair Size",Step=1,Value={Min=3,Max=35,Default=10},Callback=function(v) Crosshair.Size=v BuildCrosshair() end})
Visuals:Slider({Title="Crosshair Gap",Step=1,Value={Min=0,Max=25,Default=5},Callback=function(v) Crosshair.Gap=v BuildCrosshair() end})
Visuals:Slider({Title="Crosshair Thickness",Step=1,Value={Min=1,Max=7,Default=2},Callback=function(v) Crosshair.T=v BuildCrosshair() end})
Visuals:Slider({Title="Animation Speed",Step=.1,Value={Min=.1,Max=4,Default=1},Callback=function(v) Crosshair.Speed=v end})
--==================================================
-- PERFORMANCE MODE
--==================================================
local Performance={Enabled=false,Saved={},Removed={},Connection=nil,Token=0}
local function PerformanceProtected(o)
	local p=o
	while p and p~=Workspace do
		if p:IsA("Tool") or p.Name=="_MirrorsVisual" or p==Workspace:FindFirstChild("ViewModel") or p.Name=="MirrorsLaserEnd" or p.Name=="MirrorsLaserDot" or p.Name=="MirrorsLaserHalo" then return true end
		if p:IsA("Model") and Players:GetPlayerFromCharacter(p) then return true end
		p=p.Parent
	end
	return false
end
local function PerformanceSet(o,k,v)
	Performance.Saved[o]=Performance.Saved[o] or {}
	if Performance.Saved[o][k]==nil then pcall(function() Performance.Saved[o][k]=o[k] end) end
	pcall(function() o[k]=v end)
end
local function PerformanceFlat(o)
	if not Performance.Enabled or PerformanceProtected(o) then return end
	if o:IsA("BasePart") then
		PerformanceSet(o,"Material",Enum.Material.SmoothPlastic) PerformanceSet(o,"MaterialVariant","") PerformanceSet(o,"Reflectance",0)
		if o:IsA("MeshPart") then PerformanceSet(o,"TextureID","") end
	elseif o:IsA("SpecialMesh") then PerformanceSet(o,"TextureId","")
	elseif o:IsA("Decal") or o:IsA("Texture") then PerformanceSet(o,"Transparency",1)
	elseif o:IsA("SurfaceAppearance") then if not Performance.Removed[o] then Performance.Removed[o]=o.Parent o.Parent=nil end
	elseif o:IsA("ParticleEmitter") or o:IsA("Trail") or o:IsA("Beam") or o:IsA("Smoke") or o:IsA("Fire") or o:IsA("Sparkles") then PerformanceSet(o,"Enabled",false) end
end
local function PerformanceDisable()
	Performance.Token=Performance.Token+1
	Performance.Enabled=false
	if Performance.Connection then Performance.Connection:Disconnect() Performance.Connection=nil end
	for o,parent in pairs(Performance.Removed) do if o and parent and parent.Parent then pcall(function() o.Parent=parent end) end end
	for o,t in pairs(Performance.Saved) do if o and o.Parent then for k,v in pairs(t) do pcall(function() o[k]=v end) end end end
	table.clear(Performance.Removed) table.clear(Performance.Saved)
end
local function PerformanceEnable()
	PerformanceDisable()
	Performance.Token=Performance.Token+1
	local token=Performance.Token
	Performance.Enabled=true
	for i,o in ipairs(Workspace:GetDescendants()) do
		if not Performance.Enabled or token~=Performance.Token then break end
		PerformanceFlat(o)
		if i%700==0 then task.wait() end
	end
	if Performance.Enabled and token==Performance.Token then
		Performance.Connection=Workspace.DescendantAdded:Connect(function(o) if token==Performance.Token then task.defer(PerformanceFlat,o) end end)
	end
end
AddCleanup(PerformanceDisable)
Visuals:Paragraph({Title="Performance",Desc="Flatten map textures/effects without touching players, weapons or Lighting.",Image="gauge"})
Visuals:Toggle({Title="Performance Mode",Desc="Smooth map • remove textures/effects",Value=false,Flag="flick_performance",Callback=function(v) if v then task.spawn(PerformanceEnable) else PerformanceDisable() end end})
--==================================================
-- MISC / CONFIG
--==================================================
local AntiAFKConnection
Misc:Section({Title="Server",TextSize=18})
Misc:Button({Title="Rejoin Server",Icon="refresh-cw",Callback=function() pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId,game.JobId,LP) end) end})
Misc:Button({Title="Copy Job ID",Icon="clipboard-copy",Callback=function() CopyText(game.JobId) end})
Misc:Button({Title="Copy Place ID",Icon="copy",Callback=function() CopyText(game.PlaceId) end})
Misc:Button({Title="Copy Join URI",Icon="link",Callback=function() CopyText(string.format("roblox://placeId=%s&gameInstanceId=%s",game.PlaceId,game.JobId)) end})
Misc:Space()
Misc:Section({Title="Runtime",TextSize=18})
Misc:Toggle({Title="Anti AFK",Desc="Prevents idle disconnects when supported.",Value=false,Flag="script_anti_afk",Callback=function(v)
	if AntiAFKConnection then AntiAFKConnection:Disconnect() AntiAFKConnection=nil end
	if v then AntiAFKConnection=LP.Idled:Connect(function() pcall(function() VirtualUser:CaptureController() VirtualUser:ClickButton2(Vector2.zero) end) end) end
end})
Misc:Dropdown({Title="FPS Cap",Desc="Executor FPS cap.",Values={"30","60","90","120","144","240","Unlimited"},Value="60",Flag="script_fps_cap",Callback=function(v)
	if type(v)=="table" then v=v.Value or v.Title or v[1] end
	local cap=v=="Unlimited" and 0 or tonumber(v) Runtime.FPSCap=cap or 60
	if setfpscap then pcall(setfpscap,Runtime.FPSCap) end
end})
Misc:Toggle({Title="Notifications",Desc="Show Mirrors Hub notifications.",Value=true,Flag="script_notifications",Callback=function(v) Runtime.Notifications=v end})
Misc:Button({Title="Unload Script",Icon="power",Color=Color3.fromHex("EF4444"),Callback=function() Runtime.Cleanup() end})
AddCleanup(function() if AntiAFKConnection then AntiAFKConnection:Disconnect() AntiAFKConnection=nil end end)

Config:Section({Title="Interface",TextSize=18})
local Themes={}
local okThemes,themeTable=pcall(function() return WindUI:GetThemes() end)
if okThemes and type(themeTable)=="table" then for name in pairs(themeTable) do table.insert(Themes,name) end end
if #Themes==0 then Themes={"Violet","Dark","Light"} end
table.sort(Themes)
Config:Dropdown({Title="Theme",Values=Themes,SearchBarEnabled=true,Value=table.find(Themes,"Violet") and "Violet" or Themes[1],Flag="gui_theme",Callback=function(v)
	if type(v)=="table" then v=v.Value or v.Title or v[1] end
	if v then pcall(function() WindUI:SetTheme(v) end) end
end})
Config:Slider({Title="UI Scale",Step=.05,Value={Min=.65,Max=1.25,Default=1},Flag="gui_scale",Callback=function(v) pcall(function() Window:SetUIScale(tonumber(v) or 1) end) end})
Config:Slider({Title="Background Transparency",Step=.05,Value={Min=0,Max=1,Default=.42},Flag="gui_transparency",Callback=function(v)
	v=tonumber(v) or .42 pcall(function() Window:SetBackgroundTransparency(v) end) pcall(function() Window:SetBackgroundImageTransparency(v) end)
end})
Config:Toggle({Title="Resizable Window",Value=true,Flag="gui_resizable",Callback=function(v) pcall(function() Window:IsResizable(v) end) end})
Config:Toggle({Title="Panel Background",Desc="Show panel background when supported.",Value=true,Flag="gui_panel_background",Callback=function(v) pcall(function() Window:SetPanelBackground(v) end) end})
Config:Keybind({Title="UI Toggle Key",Desc="Key used to open and close the hub.",Value="K",Flag="gui_toggle_key",Callback=function(v)
	local key=v if typeof(v)~="EnumItem" then key=Enum.KeyCode[tostring(v):gsub("Enum.KeyCode%.","")] end
	if key then pcall(function() Window:SetToggleKey(key) end) end
end})
Config:Button({Title="Center Window",Icon="move",Callback=function() pcall(function() Window:SetToTheCenter() end) end})
Config:Space()
Config:Section({Title="Configuration Manager",TextSize=18})
local ConfigManager=Window.ConfigManager
local ConfigAvailable=ConfigManager~=nil
local ConfigName="default"
local ConfigFile
local AutoSaveOnClose=true
local AutoLoadSelected=false
local ConfigInput,ConfigDropdown,ConfigStatus
local function NormalizeConfigName(v)
	v=tostring(v or ""):gsub("[^%w%-%_ ]",""):gsub("^%s+",""):gsub("%s+$","")
	if v=="" then v="default" end
	return v:sub(1,40)
end
local function GetConfigList()
	if not ConfigAvailable then return {} end
	local ok,res=pcall(function() return ConfigManager:AllConfigs() end)
	if not ok or type(res)~="table" then return {} end
	table.sort(res) return res
end
local function RefreshConfigDropdown(selectName)
	if not ConfigDropdown then return end
	local list=GetConfigList() pcall(function() ConfigDropdown:Refresh(list) end)
	if selectName and table.find(list,selectName) then pcall(function() ConfigDropdown:Select(selectName) end) end
end
local function UpdateConfigStatus(message)
	if not ConfigStatus then return end
	local list=GetConfigList()
	pcall(function() ConfigStatus:SetDesc(string.format("Selected   %s\nSaved      %d\nAuto Save  %s\nAuto Load  %s%s",ConfigName,#list,AutoSaveOnClose and "ON" or "OFF",AutoLoadSelected and "ON" or "OFF",message and ("\n"..message) or "")) end)
end
ConfigStatus=Config:Paragraph({Title="Config Status",Desc="Loading...",Image="save"})
if ConfigAvailable then
	pcall(function() ConfigManager:Init(Window) end)
	ConfigInput=Config:Input({Title="Config Name",Value=ConfigName,Placeholder="default",Callback=function(v) ConfigName=NormalizeConfigName(v) Runtime.CurrentConfigName=ConfigName end})
	ConfigDropdown=Config:Dropdown({Title="Saved Configs",Values=GetConfigList(),AllowNone=true,SearchBarEnabled=true,Callback=function(v)
		if type(v)=="table" then v=v.Value or v.Title or v[1] end
		if v then ConfigName=NormalizeConfigName(v) Runtime.CurrentConfigName=ConfigName if ConfigInput then pcall(function() ConfigInput:Set(ConfigName) end) end UpdateConfigStatus() end
	end})
	Config:Toggle({Title="Auto Save on UI Close",Value=true,Callback=function(v) AutoSaveOnClose=v UpdateConfigStatus() end})
	Config:Toggle({Title="Auto Load Selected",Value=false,Callback=function(v) AutoLoadSelected=v UpdateConfigStatus() end})
	Config:Button({Title="Save Config",Icon="save",Color=Color3.fromHex("315DFF"),Callback=function()
		ConfigName=NormalizeConfigName(ConfigName) ConfigFile=ConfigManager:CreateConfig(ConfigName)
		if not ConfigFile then UpdateConfigStatus("Save failed") Notify("Config","Could not create config.","x",3) return end
		pcall(function() ConfigFile:SetAutoLoad(AutoLoadSelected) end)
		pcall(function() ConfigFile:Set("lastSave",os.date("%Y-%m-%d %H:%M:%S")) end)
		pcall(function() ConfigFile:Set("scriptVersion","1.4.1") end)
		local ok=pcall(function() ConfigFile:Save() end)
		if ok then Runtime.CurrentConfig=ConfigFile Runtime.CurrentConfigName=ConfigName RefreshConfigDropdown(ConfigName) UpdateConfigStatus("Saved now") Notify("Config","Saved: "..ConfigName,"check",3) else UpdateConfigStatus("Save failed") Notify("Config","Failed to save config.","x",3) end
	end})
	Config:Button({Title="Load Config",Icon="folder-open",Callback=function()
		ConfigName=NormalizeConfigName(ConfigName) ConfigFile=ConfigManager:CreateConfig(ConfigName)
		local ok,data=pcall(function() return ConfigFile:Load() end)
		if ok and data~=false then Runtime.CurrentConfig=ConfigFile Runtime.CurrentConfigName=ConfigName AutoLoadSelected=ConfigFile.AutoLoad==true UpdateConfigStatus("Loaded now") Notify("Config","Loaded: "..ConfigName,"refresh-cw",3) else UpdateConfigStatus("Load failed") Notify("Config","Config not found or invalid.","x",3) end
	end})
	Config:Button({Title="Delete Config",Icon="trash-2",Color=Color3.fromHex("EF4444"),Callback=function()
		ConfigName=NormalizeConfigName(ConfigName) local ok,success,message=pcall(function() return ConfigManager:DeleteConfig(ConfigName) end)
		if ok and success then if Runtime.CurrentConfigName==ConfigName then Runtime.CurrentConfig=nil Runtime.CurrentConfigName="default" ConfigName="default" if ConfigInput then pcall(function() ConfigInput:Set(ConfigName) end) end end RefreshConfigDropdown() UpdateConfigStatus("Deleted") Notify("Config",message or "Config deleted.","trash-2",3) else UpdateConfigStatus("Delete failed") Notify("Config",tostring(message or "Delete failed."),"x",3) end
	end})
	Config:Button({Title="Refresh Config List",Icon="refresh-cw",Callback=function() RefreshConfigDropdown(ConfigName) UpdateConfigStatus("List refreshed") end})
	task.defer(function()
		local list=GetConfigList()
		for _,name in ipairs(list) do local cfg=ConfigManager:CreateConfig(name) if cfg and cfg.AutoLoad then ConfigName=name ConfigFile=cfg Runtime.CurrentConfig=cfg Runtime.CurrentConfigName=name AutoLoadSelected=true if ConfigInput then pcall(function() ConfigInput:Set(name) end) end if ConfigDropdown then pcall(function() ConfigDropdown:Select(name) end) end break end end
		RefreshConfigDropdown(ConfigName) UpdateConfigStatus()
	end)
else ConfigStatus:SetDesc("ConfigManager unavailable. This executor may not support file APIs.") end
pcall(function() Window:OnClose(function()
	if not Runtime.Alive or not AutoSaveOnClose or not ConfigAvailable then return end
	if Runtime.CurrentConfig then pcall(function() Runtime.CurrentConfig:Set("lastSave",os.date("%Y-%m-%d %H:%M:%S")) Runtime.CurrentConfig:Save() end) end
end) end)
--==================================================
-- FINAL CLEANUP REGISTRATIONS
--==================================================
AddCleanup(function()
	Settings.AimbotEnabled=false
	Settings.TriggerActive=false
	Settings.ESPEnabled=false
	HideAllESP()
	ClearESP()
	pcall(function() SignalManager.Fire("FireWeapon",Enum.UserInputState.End) end)
end)


pcall(function() Window:OnDestroy(function() if Runtime.Alive then Runtime.Cleanup() end end) end)
