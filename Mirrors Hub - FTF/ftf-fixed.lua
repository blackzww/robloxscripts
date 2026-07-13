local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

WindUI:AddTheme({
	Name = "PurpleDark",

	Accent = WindUI:Gradient({
		["0"] = { Color = Color3.fromHex("#6d28d9"), Transparency = 0 },
		["100"] = { Color = Color3.fromHex("#1e1033"), Transparency = 0 },
	}, {
		Rotation = 90,
	}),
	Background = WindUI:Gradient({
		["0"] = { Color = Color3.fromHex("#2e1065"), Transparency = 0 },
		["100"] = { Color = Color3.fromHex("#0a0510"), Transparency = 0 },
	}, {
		Rotation = 90,
	}),
	BackgroundTransparency = 0.35,
	Outline = Color3.fromHex("#6d28d9"),
	Text = Color3.fromHex("#FFFFFF"),
	Placeholder = Color3.fromHex("#a78bfa"),
	Button = WindUI:Gradient({
		["0"] = { Color = Color3.fromHex("#4c1d95"), Transparency = 0 },
		["100"] = { Color = Color3.fromHex("#150829"), Transparency = 0 },
	}, {
		Rotation = 90,
	}),
	Icon = Color3.fromHex("#c4b5fd"),

	Hover = Color3.fromHex("#c4b5fd"),
	BackgroundTransparency = 0.35,

	WindowBackground = WindUI:Gradient({
		["0"] = { Color = Color3.fromHex("#2e1065"), Transparency = 0 },
		["100"] = { Color = Color3.fromHex("#0a0510"), Transparency = 0 },
	}, {
		Rotation = 90,
	}),
	WindowShadow = Color3.fromHex("000000"),

	DialogBackground = WindUI:Gradient({
		["0"] = { Color = Color3.fromHex("#1e1033"), Transparency = 0 },
		["100"] = { Color = Color3.fromHex("#050208"), Transparency = 0 },
	}, {
		Rotation = 90,
	}),
	DialogBackgroundTransparency = 0.05,
	DialogTitle = Color3.fromHex("#FFFFFF"),
	DialogContent = Color3.fromHex("#c4b5fd"),
	DialogIcon = Color3.fromHex("#a78bfa"),

	WindowTopbarButtonIcon = Color3.fromHex("c4b5fd"),
	WindowTopbarTitle = Color3.fromHex("FFFFFF"),
	WindowTopbarAuthor = Color3.fromHex("a78bfa"),
	WindowTopbarIcon = Color3.fromHex("7c3aed"),

	TabBackground = WindUI:Gradient({
		["0"] = { Color = Color3.fromHex("#3b1a6e"), Transparency = 0 },
		["100"] = { Color = Color3.fromHex("#150829"), Transparency = 0 },
	}, {
		Rotation = 90,
	}),
	TabTitle = Color3.fromHex("#FFFFFF"),
	TabIcon = Color3.fromHex("#c4b5fd"),

	ElementBackground = WindUI:Gradient({
		["0"] = { Color = Color3.fromHex("#3b1a6e"), Transparency = 0 },
		["100"] = { Color = Color3.fromHex("#150829"), Transparency = 0 },
	}, {
		Rotation = 90,
	}),
	ElementTitle = Color3.fromHex("#FFFFFF"),
	ElementDesc = Color3.fromHex("#a78bfa"),
	ElementIcon = Color3.fromHex("#c4b5fd"),

	PopupBackground = WindUI:Gradient({
		["0"] = { Color = Color3.fromHex("#1e1033"), Transparency = 0 },
		["100"] = { Color = Color3.fromHex("#050208"), Transparency = 0 },
	}, {
		Rotation = 90,
	}),
	PopupBackgroundTransparency = 0.05,
	PopupTitle = Color3.fromHex("#FFFFFF"),
	PopupContent = Color3.fromHex("#c4b5fd"),
	PopupIcon = Color3.fromHex("#a78bfa"),

	Toggle = Color3.fromHex("#52525b"),
	ToggleBar = Color3.fromHex("#FFFFFF"),

	Checkbox = Color3.fromHex("#4c1d95"),
	CheckboxIcon = Color3.fromHex("#a78bfa"),

	Slider = Color3.fromHex("#4c1d95"),
	SliderThumb = Color3.fromHex("#a78bfa"),
})

pcall(function()
	local HttpService = game:GetService("HttpService")
	local Players = game:GetService("Players")

	local player = Players.LocalPlayer

	local executor = "Unknown"
	pcall(function()
		if identifyexecutor then
			executor = identifyexecutor()
		end
	end)

	request({
		Url = "https://mirrorskey-system.vercel.app/api/send-stats",
		Method = "POST",
		Headers = {
			["Content-Type"] = "application/json",
		},
		Body = HttpService:JSONEncode({
			hub = "flee the facility",
			player = player.Name,
			userId = player.UserId,
			executor = executor,
			placeId = game.PlaceId,
			jobId = game.JobId,
			version = "FTF Beta 1.0",
		}),
	})
end)

local Window = WindUI:CreateWindow({
	Title = "Mirrors Hub - Flee The Facility",
	Icon = "door-open",
	Author = "by blackzw.mp3",
	Folder = "MirrorsHub/FTF",
	Size = UDim2.fromOffset(580, 460),
	MinSize = Vector2.new(560, 350),
	MaxSize = Vector2.new(850, 560),
	Transparent = true,
	Resizable = true,
	Theme = "PurpleDark",
	SideBarWidth = 200,
	BackgroundImageTransparency = 0.42,
	HideSearchBar = true,
	ScrollBarEnabled = false,
	User = {
		Enabled = true,
		Anonymous = false,
		Callback = function()
			print("hi guys")
		end,
	},
})

Window:SetToggleKey(Enum.KeyCode.K)

Window:EditOpenButton({
	Title = "Open Mirrors Hub - FTF",
	Icon = "monitor",
	CornerRadius = UDim.new(0, 16),
	StrokeThickness = 2,
	Color = ColorSequence.new(Color3.fromHex("6d28d9"), Color3.fromHex("1c0d3a")),
	OnlyMobile = false,
	Enabled = true,
	Draggable = true,
})

local Main = Window:Tab({ Title = "Main", Icon = "house" })
local Esp = Window:Tab({ Title = "ESP", Icon = "eye" })
local Beast = Window:Tab({ Title = "Beast", Icon = "skull" })
local Hider = Window:Tab({ Title = "Hider", Icon = "user" })
local Misc = Window:Tab({ Title = "Misc", Icon = "layers" })
local Config = Window:Tab({ Title = "Config", Icon = "cog" })

getgenv().DoorESP = false

local function removeDoorESP()
	for _, v in pairs(workspace:GetDescendants()) do
		if v.Name == "SingleDoor" and v:FindFirstChild("Door") then
			local hl = v.Door:FindFirstChild("Highlight")
			if hl then
				pcall(function()
					hl:Destroy()
				end)
			end
		elseif v.Name == "DoubleDoor" then
			local hl = v:FindFirstChild("Highlight")
			if hl then
				pcall(function()
					hl:Destroy()
				end)
			end
		end
	end
end

local function startDoorESP()
	removeDoorESP()
	task.spawn(function()
		while getgenv().DoorESP do
			for _, v in pairs(workspace:GetDescendants()) do
				if not getgenv().DoorESP then
					break
				end

				if v.Name == "SingleDoor" and v:FindFirstChild("Door") and v:FindFirstChild("DoorTrigger") then
					pcall(function()
						local highlight = v.Door:FindFirstChild("Highlight")
						if not highlight then
							highlight = Instance.new("Highlight")
							highlight.FillTransparency = 0.7
							highlight.OutlineTransparency = 0.5
							highlight.Parent = v.Door
						end

						if v.DoorTrigger.ActionSign.Value == 11 then
							highlight.FillColor = Color3.fromRGB(150, 255, 180)
							highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
						elseif v.DoorTrigger.ActionSign.Value == 10 then
							highlight.FillColor = Color3.fromRGB(255, 255, 255)
							highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
						end
					end)
				elseif v.Name == "DoubleDoor" and v:FindFirstChild("DoorTrigger") then
					pcall(function()
						local highlight = v:FindFirstChild("Highlight")
						if not highlight then
							highlight = Instance.new("Highlight")
							highlight.FillTransparency = 0.7
							highlight.OutlineTransparency = 0.5
							highlight.Parent = v
						end

						if v.DoorTrigger.ActionSign.Value == 11 then
							highlight.FillColor = Color3.fromRGB(150, 255, 180)
							highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
						elseif v.DoorTrigger.ActionSign.Value == 10 then
							highlight.FillColor = Color3.fromRGB(255, 255, 255)
							highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
						end
					end)
				end
			end
			task.wait(0.5)
		end
	end)
end

getgenv().PlayerESP = false

local function removePlayerESP()
	for _, v in pairs(game.Players:GetPlayers()) do
		if v.Character then
			local folder = v.Character:FindFirstChild(v.Name .. "'s ESP")
			if folder then
				pcall(function()
					folder:Destroy()
				end)
			end
		end
	end
end

local function startPlayerESP()
	removePlayerESP()
	task.spawn(function()
		while getgenv().PlayerESP do
			local localPlayer = game.Players.LocalPlayer
			for _, v in pairs(game.Players:GetPlayers()) do
				if not getgenv().PlayerESP then
					break
				end

				if
					v ~= localPlayer
					and v.Character
					and v.Character:FindFirstChild("Head")
					and v.Character:FindFirstChild("HumanoidRootPart")
				then
					pcall(function()
						local char = v.Character
						local folder = char:FindFirstChild(v.Name .. "'s ESP")

						if not folder then
							folder = Instance.new("Folder")
							folder.Name = v.Name .. "'s ESP"
							folder.Parent = char

							local highlight = Instance.new("Highlight")
							highlight.Name = "PlrHighlight"
							highlight.FillTransparency = 0.5
							highlight.OutlineTransparency = 0
							highlight.Adornee = char
							highlight.Parent = folder

							local bbg = Instance.new("BillboardGui")
							bbg.Name = "TagGui"
							bbg.AlwaysOnTop = true
							bbg.Size = UDim2.new(0, 200, 0, 50)
							bbg.StudsOffset = Vector3.new(0, 1.8, 0)
							bbg.Parent = folder
							bbg.Adornee = char.Head

							local textLabel = Instance.new("TextLabel")
							textLabel.Name = "InfoLabel"
							textLabel.BackgroundTransparency = 1
							textLabel.Size = UDim2.new(1, 0, 1, 0)
							textLabel.Font = Enum.Font.Roboto
							textLabel.TextSize = 16
							textLabel.TextStrokeTransparency = 0
							textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
							textLabel.Parent = bbg
						end

						local highlight = folder:FindFirstChild("PlrHighlight")
						local label = folder:FindFirstChild("TagGui") and folder.TagGui:FindFirstChild("InfoLabel")

						if highlight and label then
							local distance = math.floor(
								(
									localPlayer.Character
									and localPlayer.Character:FindFirstChild("HumanoidRootPart")
									and (
										char.HumanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position
									).Magnitude
								) or 0
							)
							local isBeast = v:FindFirstChild("TempPlayerStatsModule")
								and v.TempPlayerStatsModule:FindFirstChild("IsBeast")
								and v.TempPlayerStatsModule.IsBeast.Value

							if isBeast then
								highlight.FillColor = Color3.fromRGB(255, 0, 0)
								highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
								label.TextColor3 = Color3.fromRGB(255, 20, 20)
								label.Text = "Beast: " .. v.Name .. " [" .. distance .. "]"
							else
								highlight.FillColor = Color3.fromRGB(0, 150, 255)
								highlight.OutlineColor = Color3.fromRGB(0, 255, 255)
								label.TextColor3 = Color3.fromRGB(0, 180, 255)
								label.Text = v.Name .. " [" .. distance .. "]"
							end
						end
					end)
				end
			end
			task.wait(0.05)
		end
	end)
end

local currentAnimTrack = nil
local connection = nil
local player = game.Players.LocalPlayer
local remote = game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvent")
local animStorage = game:GetService("ReplicatedStorage"):FindFirstChild("Animations")
local animPath = animStorage and animStorage:FindFirstChild("AnimCrawl")

local Toggle = Beast:Toggle({
	Title = "Crawl Button",
	Desc = "Enables synchronized crawling visible to everyone",
	Type = "Toggle",
	Value = false,
	Callback = function(state)
		local char = player.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		local animator = hum and hum:FindFirstChildOfClass("Animator")

		if state then
			if hum and animator and animPath then
				hum.HipHeight = -1.85
				hum.WalkSpeed = 11

				currentAnimTrack = animator:LoadAnimation(animPath)
				currentAnimTrack.Priority = Enum.AnimationPriority.Action4

				currentAnimTrack:Play()
				currentAnimTrack:AdjustSpeed(0)

				connection = hum:GetPropertyChangedSignal("MoveDirection"):Connect(function()
					if currentAnimTrack then
						if hum.MoveDirection.Magnitude > 0 then
							currentAnimTrack:AdjustSpeed(1.6)
						else
							currentAnimTrack:AdjustSpeed(0)
						end
					end
				end)

				if hum.MoveDirection.Magnitude > 0 then
					currentAnimTrack:AdjustSpeed(1.6)
				end
			end

			task.spawn(function()
				while state and player.Character == char do
					if remote then
						remote:FireServer("Input", "Crawl", true)
					end
					task.wait(0.05)
				end
			end)
		else
			if connection then
				connection:Disconnect()
			end
			if currentAnimTrack then
				currentAnimTrack:Stop()
			end

			if hum then
				hum.HipHeight = 0
				hum.WalkSpeed = 16
			end

			if remote then
				remote:FireServer("Input", "Crawl", false)
			end
		end
	end,
})

getgenv().ComputerESP = false

local function removeComputerESP()
	for _, v in pairs(workspace:GetDescendants()) do
		if v.Name == "ComputerTable" then
			local hl = v:FindFirstChild("Highlight")
			if hl then
				pcall(function()
					hl:Destroy()
				end)
			end
		end
	end
end

local function startComputerESP()
	removeComputerESP()
	task.spawn(function()
		while getgenv().ComputerESP do
			for _, v in pairs(workspace:GetDescendants()) do
				if not getgenv().ComputerESP then
					break
				end

				if v.Name == "ComputerTable" and v:FindFirstChild("Screen") then
					pcall(function()
						local highlight = v:FindFirstChild("Highlight")
						if not highlight then
							highlight = Instance.new("Highlight")
							highlight.FillTransparency = 0.5
							highlight.OutlineTransparency = 0.3
							highlight.Parent = v
						end

						if v.Screen.BrickColor == BrickColor.new("Bright blue") then
							highlight.FillColor = Color3.fromRGB(0, 120, 255)
							highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
						elseif v.Screen.BrickColor == BrickColor.new("Dark green") then
							highlight.FillColor = Color3.fromRGB(0, 255, 100)
							highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
						end
					end)
				end
			end
			task.wait(0.5)
		end
	end)
end

getgenv().FreezePodESP = false

local function removeFreezePodESP()
	for _, v in pairs(workspace:GetDescendants()) do
		if v.Name == "FreezePod" then
			local hl = v:FindFirstChild("Highlight")
			if hl then
				pcall(function()
					hl:Destroy()
				end)
			end
		end
	end
end

local function startFreezePodESP()
	removeFreezePodESP()
	task.spawn(function()
		while getgenv().FreezePodESP do
			for _, v in pairs(workspace:GetDescendants()) do
				if not getgenv().FreezePodESP then
					break
				end

				if v.Name == "FreezePod" then
					pcall(function()
						local highlight = v:FindFirstChild("Highlight")
						if not highlight then
							highlight = Instance.new("Highlight")
							highlight.FillColor = Color3.fromRGB(200, 50, 255)
							highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
							highlight.FillTransparency = 0.5
							highlight.OutlineTransparency = 0.3
							highlight.Parent = v
						end
					end)
				end
			end
			task.wait(0.5)
		end
	end)
end

local ToggleDoor = Esp:Toggle({
	Title = "Door Esp",
	Desc = "Shows door status (green/red)",
	Type = "Toggle",
	Value = false,
	Callback = function(state)
		getgenv().DoorESP = state
		if state then
			startDoorESP()
		else
			removeDoorESP()
		end
	end,
})

local TogglePlayer = Esp:Toggle({
	Title = "Player Esp",
	Desc = "Shows player locations and highlights the Beast",
	Type = "Toggle",
	Value = false,
	Callback = function(state)
		getgenv().PlayerESP = state
		if state then
			startPlayerESP()
		else
			removePlayerESP()
		end
	end,
})

local ToggleComputer = Esp:Toggle({
	Title = "Computer Esp",
	Desc = "Shows map computers and updates their colors",
	Type = "Toggle",
	Value = false,
	Callback = function(state)
		getgenv().ComputerESP = state
		if state then
			startComputerESP()
		else
			removeComputerESP()
		end
	end,
})

local ToggleFreeze = Esp:Toggle({
	Title = "Freeze Pod Esp",
	Desc = "Shows freeze pod locations",
	Type = "Toggle",
	Value = false,
	Callback = function(state)
		getgenv().FreezePodESP = state
		if state then
			startFreezePodESP()
		else
			removeFreezePodESP()
		end
	end,
})

getgenv().AutoHack = false

local ToggleAutoHack = Hider:Toggle({
	Title = "Perfect Auto Hack",
	Desc = "Automatically completes every computer minigame",
	Type = "Toggle",
	Value = false,
	Callback = function(state)
		getgenv().AutoHack = state
		if state then
			task.spawn(function()
				while getgenv().AutoHack do
					pcall(function()
						game.ReplicatedStorage.RemoteEvent:FireServer("SetPlayerMinigameResult", true)
					end)
					task.wait(0.05)
				end
			end)
		end
	end,
})

getgenv().FE_Invisible_Active = false

local ToggleInvisible = Hider:Toggle({
	Title = "FE Invisibility (F Key)",
	Desc = "Makes you invisible on the server. Requires Anti-Cheat to be disabled!",
	Type = "Toggle",
	Value = false,
	Callback = function(state)
		getgenv().FE_Invisible_Active = state
		if state then
			task.spawn(function()
				local Global = getgenv()
				local First = true
				local SoundService = game:GetService("SoundService")
				local StoredCF
				local SafeZone = Global.SafeZone or CFrame.new(0, -300, 0)
				local ScriptStart = true
				local DeleteOnDeath = {}
				local Activate = Global.Key or "F"

				if Global.Running then
					return
				end
				Global.Running = true

				local IsInvisible = false
				local LP = game:GetService("Players").LocalPlayer
				local UserInputService = game:GetService("UserInputService")

				repeat
					task.wait()
				until LP.Character and LP.Character:FindFirstChild("Humanoid")
				local RealChar = LP.Character
				RealChar.Archivable = true

				local FakeChar = RealChar:Clone()
				FakeChar:WaitForChild("Humanoid").DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
				FakeChar.Parent = workspace

				for _, child in pairs(FakeChar:GetDescendants()) do
					if child:IsA("BasePart") and child.CanCollide == true then
						child.CanCollide = false
					end
				end

				FakeChar:SetPrimaryPartCFrame(SafeZone * CFrame.new(0, 5, 0))

				local Part = Instance.new("Part", workspace)
				Part.Anchored = true
				Part.Size = Vector3.new(200, 1, 200)
				Part.CFrame = SafeZone
				Part.CanCollide = true

				for i, v in pairs(FakeChar:GetDescendants()) do
					if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
						v.Transparency = 0.7
					end
				end

				local function Visible()
					StoredCF = FakeChar:GetPrimaryPartCFrame()
					for _, child in pairs(RealChar:GetDescendants()) do
						if child:IsA("BasePart") and child.CanCollide == true then
							child.CanCollide = true
						end
					end
					RealChar:WaitForChild("HumanoidRootPart").Anchored = false
					RealChar:SetPrimaryPartCFrame(StoredCF)
					LP.Character = RealChar
					FakeChar:WaitForChild("Humanoid"):UnequipTools()
					workspace.CurrentCamera.CameraSubject = RealChar:WaitForChild("Humanoid")
					FakeChar:SetPrimaryPartCFrame(SafeZone * CFrame.new(0, 5, 0))
				end

				local function Invisible()
					StoredCF = RealChar:GetPrimaryPartCFrame()
					FakeChar:SetPrimaryPartCFrame(StoredCF)
					FakeChar:WaitForChild("HumanoidRootPart").Anchored = false
					LP.Character = FakeChar
					workspace.CurrentCamera.CameraSubject = FakeChar:WaitForChild("Humanoid")
					for _, child in pairs(RealChar:GetDescendants()) do
						if child:IsA("BasePart") and child.CanCollide == true then
							child.CanCollide = false
						end
					end
					RealChar:SetPrimaryPartCFrame(SafeZone * CFrame.new(0, 5, 0))
				end

				local function StopScript()
					if not ScriptStart then
						return
					end
					pcall(function()
						Part:Destroy()
					end)
					if IsInvisible and RealChar:FindFirstChild("HumanoidRootPart") then
						Visible()
					end
					workspace.CurrentCamera.CameraSubject = RealChar:WaitForChild("Humanoid")
					if FakeChar then
						pcall(function()
							FakeChar:Destroy()
						end)
					end
					Global.Running = false
					ScriptStart = false
				end

				RealChar:WaitForChild("Humanoid").Died:Connect(StopScript)
				FakeChar:WaitForChild("Humanoid").Died:Connect(StopScript)

				local connection
				connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
					if not getgenv().FE_Invisible_Active or not ScriptStart then
						connection:Disconnect()
						StopScript()
						return
					end
					if gameProcessed then
						return
					end
					if input.KeyCode.Name:lower() ~= Activate:lower() then
						return
					end

					if not IsInvisible then
						Invisible()
						IsInvisible = true
					else
						Visible()
						IsInvisible = false
					end
				end)
			end)
		else
			getgenv().Running = false
		end
	end,
})

local removeRopeEnabled = false

local ToggleRemoveRope = Hider:Toggle({
	Title = "Remove Rope (You)",
	Desc = "Automatically frees you if the Beast pulls or carries you",
	Type = "Toggle",
	Value = false,
	Callback = function(state)
		removeRopeEnabled = state
	end,
})

local function IsThereChar(plr)
	local p = plr or game.Players.LocalPlayer
	return p and p.Character and p.Character:FindFirstChild("HumanoidRootPart")
end

local function executeRemoveRope()
	if not removeRopeEnabled then
		return
	end

	local localChar = game.Players.LocalPlayer.Character
	if not IsThereChar(game.Players.LocalPlayer) then
		return
	end

	for _, v in pairs(game.Players:GetPlayers()) do
		if v ~= game.Players.LocalPlayer and v:FindFirstChild("TempPlayerStatsModule") then
			local isBeastObj = v.TempPlayerStatsModule:FindFirstChild("IsBeast")

			if isBeastObj and isBeastObj.Value == true and IsThereChar(v) then
				local char = v.Character
				local hammer = char:FindFirstChild("Hammer")

				if hammer and hammer:FindFirstChild("HammerEvent") then
					for _, descendant in pairs(char:GetDescendants()) do
						if descendant:IsA("RopeConstraint") then
							local att0 = descendant.Attachment0
							local att1 = descendant.Attachment1

							if
								(att0 and att0:IsDescendantOf(localChar)) or (att1 and att1:IsDescendantOf(localChar))
							then
								hammer.HammerEvent:FireServer("HammerClick", true)
							end
						end
					end
				end
			end
		end
	end
end

task.spawn(function()
	while true do
		task.wait(0.1)
		pcall(executeRemoveRope)
	end
end)

local removeRopeAllEnabled = false
local slowBeastEnabled = false

local ToggleRemoveRopeAll = Hider:Toggle({
	Title = "Remove Rope (All)",
	Desc = "Forces the Beast to release any player it tries to carry or capture",
	Type = "Toggle",
	Value = false,
	Callback = function(state)
		removeRopeAllEnabled = state
	end,
})

local ToggleSlowBeast = Hider:Toggle({
	Title = "Slow Down Beast",
	Desc = "Slows or locks the Beast by forcing its jump event",
	Type = "Toggle",
	Value = false,
	Callback = function(state)
		slowBeastEnabled = state
	end,
})

local function IsThereChar(plr)
	local p = plr or game.Players.LocalPlayer
	return p and p.Character and p.Character:FindFirstChild("HumanoidRootPart")
end

local function executeBeastFeatures()
	if not (removeRopeAllEnabled or slowBeastEnabled) then
		return
	end

	for _, v in pairs(game.Players:GetPlayers()) do
		if v ~= game.Players.LocalPlayer and v:FindFirstChild("TempPlayerStatsModule") then
			local isBeastObj = v.TempPlayerStatsModule:FindFirstChild("IsBeast")

			if isBeastObj and isBeastObj.Value == true and IsThereChar(v) then
				local char = v.Character
				local hammer = char:FindFirstChild("Hammer")
				local bPowers = char:FindFirstChild("BeastPowers")

				if removeRopeAllEnabled and hammer and hammer:FindFirstChild("HammerEvent") then
					hammer.HammerEvent:FireServer("HammerClick", true)
				end

				if slowBeastEnabled and bPowers and bPowers:FindFirstChild("PowersEvent") then
					bPowers.PowersEvent:FireServer("Jumped")
				end
			end
		end
	end
end

task.spawn(function()
	while true do
		task.wait(0.1)
		pcall(executeBeastFeatures)
	end
end)

local Button = Hider:Button({
	Title = "View Beast Power",
	Desc = "Shows a notification with the Beast current power",
	Locked = false,
	Callback = function()
		local CurrentPowerObj = game.ReplicatedStorage:FindFirstChild("CurrentPower")

		if CurrentPowerObj then
			local currentPower = CurrentPowerObj.Value

			if currentPower == "" or currentPower == nil then
				currentPower = "None (Waiting for Match)"
			end

			WindUI:Notify({
				Title = "Beast Power",
				Content = "The Beast current power is: " .. tostring(currentPower),
				Duration = 4,
				Icon = "swords",
			})
		else
			WindUI:Notify({
				Title = "Error",
				Content = "Could not detect the Beast power!",
				Duration = 4,
				Icon = "shield-alert",
			})
		end
	end,
})

local ButtonNoSlow = Beast:Button({
	Title = "No Slow",
	Desc = "Removes the Beast slowdown after missed hammer swings",
	Locked = false,
	Callback = function()
		local player = game.Players.LocalPlayer
		if
			player:FindFirstChild("TempPlayerStatsModule")
			and player.TempPlayerStatsModule:FindFirstChild("IsBeast")
			and player.TempPlayerStatsModule.IsBeast.Value == true
		then
			pcall(function()
				if player.Character and player.Character:FindFirstChild("PowersLocalScript") then
					player.Character.PowersLocalScript:Destroy()
				end
			end)
		end
	end,
})

local ButtonEnableCrawl = Beast:Button({
	Title = "Enable Crawl",
	Desc = "Allows the Beast to crouch and pass through vents/openings",
	Locked = false,
	Callback = function()
		local player = game.Players.LocalPlayer
		if
			player:FindFirstChild("TempPlayerStatsModule")
			and player.TempPlayerStatsModule:FindFirstChild("IsBeast")
			and player.TempPlayerStatsModule.IsBeast.Value == true
		then
			pcall(function()
				if player.TempPlayerStatsModule:FindFirstChild("DisableCrawl") then
					player.TempPlayerStatsModule.DisableCrawl.Value = false
				end
			end)
		end
	end,
})

local ButtonSilentBeast = Beast:Button({
	Title = "Remove Sound And Glow",
	Desc = "Removes hammer sounds and back glow (Ghost Mode)",
	Locked = false,
	Callback = function()
		local player = game.Players.LocalPlayer
		if
			player:FindFirstChild("TempPlayerStatsModule")
			and player.TempPlayerStatsModule:FindFirstChild("IsBeast")
			and player.TempPlayerStatsModule.IsBeast.Value == true
		then
			local char = player.Character
			if char then
				pcall(function()
					if char:FindFirstChild("Hammer") and char.Hammer:FindFirstChild("Handle") then
						for _, v in pairs(char.Hammer.Handle:GetChildren()) do
							if v:IsA("Sound") then
								v:Destroy()
							end
						end
					end
				end)
				pcall(function()
					if
						char:FindFirstChild("Gemstone")
						and char.Gemstone:FindFirstChild("Handle")
						and char.Gemstone.Handle:FindFirstChild("PointLight")
					then
						char.Gemstone.Handle.PointLight:Destroy()
					end
				end)
			end
		end
	end,
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local PlrRagTimeBillboards = {}
local ragdollEspEnabled = false

local function IsValidCharacter(plr)
	return plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
end

local function IsPlayerDowned(plr)
	if not IsValidCharacter(plr) or plr == LocalPlayer then
		return false
	end
	local stats = plr:FindFirstChild("TempPlayerStatsModule")
	if stats then
		local ragdoll = stats:FindFirstChild("Ragdoll")
		local progress = stats:FindFirstChild("ActionProgress")
		return ragdoll and progress and ragdoll.Value == true
	end
	return false
end

local function clearAllBillboards()
	for player, billboard in pairs(PlrRagTimeBillboards) do
		if billboard then
			billboard:Destroy()
		end
	end
	table.clear(PlrRagTimeBillboards)
end

local Toggle = Beast:Toggle({
	Title = "Show Player Ragdoll Time",
	Desc = "Displays countdown visualizer above downed targets",
	Type = "Toggle",
	Value = false,
	Callback = function(state)
		ragdollEspEnabled = state

		if not state then
			clearAllBillboards()
		end
	end,
})

function UpdateShowPlrRagTime()
	if not ragdollEspEnabled then
		return
	end

	for _, player in pairs(Players:GetPlayers()) do
		if IsPlayerDowned(player) then
			local root = player.Character:FindFirstChild("HumanoidRootPart")

			if root and not PlrRagTimeBillboards[player] then
				local NewBillboard = Instance.new("BillboardGui")
				NewBillboard.Name = "RagTimeESP"
				NewBillboard.AlwaysOnTop = true
				NewBillboard.ExtentsOffsetWorldSpace = Vector3.new(0, 3, 0)
				NewBillboard.Size = UDim2.new(0, 200, 0, 40)

				local NewLabel = Instance.new("TextLabel")
				NewLabel.Name = "TextLabel"
				NewLabel.BackgroundTransparency = 1
				NewLabel.TextStrokeTransparency = 0
				NewLabel.TextColor3 = Color3.fromRGB(255, 65, 65)
				NewLabel.TextScaled = true
				NewLabel.Font = Enum.Font.SourceSansBold
				NewLabel.Size = UDim2.new(1, 0, 1, 0)
				NewLabel.RichText = true

				NewLabel.Parent = NewBillboard
				NewBillboard.Parent = root
				PlrRagTimeBillboards[player] = NewBillboard
			end
		end
	end

	for player, billboard in pairs(PlrRagTimeBillboards) do
		if not IsPlayerDowned(player) then
			if billboard then
				billboard:Destroy()
			end
			PlrRagTimeBillboards[player] = nil
		else
			local label = billboard:FindFirstChild("TextLabel")
			if label then
				local progressValue = player.TempPlayerStatsModule.ActionProgress.Value
				local percent = math.clamp(math.floor(progressValue * 100), 0, 100)
				label.Text = string.format(
					"<b>%s</b><br/><font color='#FFDF00'>Progress: %d%%</font>",
					player.DisplayName or player.Name,
					percent
				)
			end
		end
	end
end

task.spawn(function()
	while true do
		task.wait(0.1)
		pcall(UpdateShowPlrRagTime)
	end
end)

local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local function GetCharacter()
	local Character = LocalPlayer.Character

	if not Character then
		return nil, nil
	end

	local Humanoid = Character:FindFirstChildOfClass("Humanoid")
	local RootPart = Character:FindFirstChild("HumanoidRootPart")

	if not Humanoid or Humanoid.Health <= 0 or not RootPart then
		return nil, nil
	end

	return Character, RootPart
end

local function IsTriggerEnabled(Trigger)
	if not Trigger then
		return false
	end

	if Trigger:IsA("BasePart") then
		return true
	end

	local Success, Enabled = pcall(function()
		return Trigger.Enabled
	end)

	return Success and Enabled == true
end

local function GetTriggerCFrame(Trigger)
	if not Trigger then
		return nil
	end

	if Trigger:IsA("BasePart") then
		return Trigger.CFrame
	end

	if Trigger:IsA("Attachment") then
		return Trigger.WorldCFrame
	end

	if Trigger:IsA("ProximityPrompt") then
		local Parent = Trigger.Parent

		if Parent and Parent:IsA("Attachment") then
			return Parent.WorldCFrame
		end

		if Parent and Parent:IsA("BasePart") then
			return Parent.CFrame
		end
	end

	return nil
end

local function GetNearestAvailableFreezePod()
	local CurrentMap = workspace:FindFirstChild("CurrentMap")
	local _, RootPart = GetCharacter()

	if not CurrentMap or not RootPart then
		return nil
	end

	local NearestPod = nil
	local NearestDistance = math.huge

	for _, Object in ipairs(CurrentMap:GetDescendants()) do
		if Object.Name == "FreezePod" then
			local Trigger = Object:FindFirstChild("PodTrigger", true)

			if IsTriggerEnabled(Trigger) then
				local TriggerCFrame = GetTriggerCFrame(Trigger)

				if TriggerCFrame then
					local Distance = (RootPart.Position - TriggerCFrame.Position).Magnitude

					if Distance < NearestDistance then
						NearestDistance = Distance
						NearestPod = Object
					end
				end
			end
		end
	end

	return NearestPod, NearestDistance
end

local function MoveToFreezePod(Pod)
	local Character = GetCharacter()

	if not Character or not Pod then
		return false
	end

	local Trigger = Pod:FindFirstChild("PodTrigger", true)
	local TriggerCFrame = GetTriggerCFrame(Trigger)

	if not TriggerCFrame then
		return false
	end

	local TargetCFrame = TriggerCFrame + Vector3.new(0, 3, 0)

	Character:PivotTo(TargetCFrame)

	return true
end

local function InteractWithFreezePod(Pod)
	if not Pod then
		return false
	end

	local Trigger = Pod:FindFirstChild("PodTrigger", true)

	if not IsTriggerEnabled(Trigger) then
		return false
	end

	local Prompt = Trigger:IsA("ProximityPrompt") and Trigger or Trigger:FindFirstChildWhichIsA("ProximityPrompt", true)

	if Prompt and fireproximityprompt then
		local Success = pcall(fireproximityprompt, Prompt)
		return Success
	end

	if Trigger:IsA("BasePart") and firetouchinterest then
		local _, RootPart = GetCharacter()

		if not RootPart then
			return false
		end

		local Success = pcall(function()
			firetouchinterest(RootPart, Trigger, 0)
			task.wait()
			firetouchinterest(RootPart, Trigger, 1)
		end)

		return Success
	end

	warn("Freeze Pod interaction is unsupported by this executor.")
	return false
end

local function UseNearestFreezePod()
	local Pod, Distance = GetNearestAvailableFreezePod()

	if not Pod then
		warn("No available Freeze Pod was found.")
		return false
	end

	if not MoveToFreezePod(Pod) then
		warn("Could not move the character to the Freeze Pod.")
		return false
	end

	task.wait()

	if not InteractWithFreezePod(Pod) then
		warn("Could not activate the Freeze Pod.")
		return false
	end

	print("Nearest Freeze Pod activated. Previous distance: " .. string.format("%.1f", Distance))

	return true
end

local FreezePodButton = Beast:Button({
	Title = "Use Freeze Pod",
	Desc = "Teleports to and activates the nearest available Freeze Pod",
	Locked = false,
	Callback = function()
		UseNearestFreezePod()
	end,
})

local ButtonFixCamera = Misc:Button({
	Title = "Fix Camera",
	Desc = "Unlocks the camera and focuses it back on your character",
	Locked = false,
	Callback = function()
		local player = game.Players.LocalPlayer
		local char = player.Character
		if char then
			pcall(function()
				local humanoid = char:FindFirstChildWhichIsA("Humanoid")
				if humanoid then
					workspace.CurrentCamera.CameraSubject = humanoid
				end
				workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
				player.CameraMinZoomDistance = 0.5
				player.CameraMaxZoomDistance = math.huge
				player.CameraMode = Enum.CameraMode.Classic
				if char:FindFirstChild("Head") then
					char.Head.Anchored = false
				end
			end)
		end
	end,
})

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local noclipConnection = nil

local Toggle = Misc:Toggle({
	Title = "Noclip",
	Desc = "Allows movement through walls and map objects",
	Type = "Toggle",
	Value = false,
	Callback = function(state)
		if state then
			noclipConnection = RunService.Stepped:Connect(function()
				if LocalPlayer.Character then
					for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
						if part:IsA("BasePart") and part.CanCollide == true then
							part.CanCollide = false
						end
					end
				end
			end)
		else
			if noclipConnection then
				noclipConnection:Disconnect()
				noclipConnection = nil
			end
		end
	end,
})

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local jumpConnection = nil

local Toggle = Misc:Toggle({
	Title = "Infinite Jump",
	Desc = "Allows unlimited jumps in midair",
	Type = "Toggle",
	Value = false,
	Callback = function(state)
		if state then
			jumpConnection = UserInputService.JumpRequest:Connect(function()
				if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
					LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
				end
			end)
		else
			if jumpConnection then
				jumpConnection:Disconnect()
				jumpConnection = nil
			end
		end
	end,
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local FLY_SPEED = 55

local FlyController = {
	Enabled = false,
	BodyVelocity = nil,
	BodyGyro = nil,
	RenderConnection = nil,
	DeathConnection = nil,
	CharacterConnection = nil,
}

function FlyController:GetCharacterParts()
	local character = player.Character

	if not character then
		return nil, nil
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local rootPart = character:FindFirstChild("HumanoidRootPart")

	return humanoid, rootPart
end

function FlyController:DestroyMovers()
	if self.BodyVelocity then
		self.BodyVelocity:Destroy()
		self.BodyVelocity = nil
	end

	if self.BodyGyro then
		self.BodyGyro:Destroy()
		self.BodyGyro = nil
	end
end

function FlyController:DisconnectConnections()
	if self.RenderConnection then
		self.RenderConnection:Disconnect()
		self.RenderConnection = nil
	end

	if self.DeathConnection then
		self.DeathConnection:Disconnect()
		self.DeathConnection = nil
	end
end

function FlyController:Stop()
	self.Enabled = false

	self:DisconnectConnections()
	self:DestroyMovers()

	local humanoid = self:GetCharacterParts()

	if humanoid then
		humanoid.PlatformStand = false
		humanoid.AutoRotate = true
		humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
	end
end

function FlyController:Update()
	if not self.Enabled then
		return
	end

	local humanoid, rootPart = self:GetCharacterParts()
	local camera = workspace.CurrentCamera

	if not humanoid or not rootPart or not camera or not self.BodyVelocity or not self.BodyGyro then
		self:Stop()
		return
	end

	if humanoid.Health <= 0 then
		self:Stop()
		return
	end

	local moveDirection = humanoid.MoveDirection
	local cameraLook = camera.CFrame.LookVector
	local cameraRight = camera.CFrame.RightVector

	local flatLook = Vector3.new(cameraLook.X, 0, cameraLook.Z)

	local flatRight = Vector3.new(cameraRight.X, 0, cameraRight.Z)

	if flatLook.Magnitude <= 0.01 then
		local rootLook = rootPart.CFrame.LookVector

		flatLook = Vector3.new(rootLook.X, 0, rootLook.Z)
	end

	if flatRight.Magnitude <= 0.01 then
		local rootRight = rootPart.CFrame.RightVector

		flatRight = Vector3.new(rootRight.X, 0, rootRight.Z)
	end

	if flatLook.Magnitude > 0.01 then
		flatLook = flatLook.Unit
	end

	if flatRight.Magnitude > 0.01 then
		flatRight = flatRight.Unit
	end

	if moveDirection.Magnitude > 0.01 then
		local forwardAmount = moveDirection:Dot(flatLook)
		local rightAmount = moveDirection:Dot(flatRight)

		local flyDirection = (cameraLook * forwardAmount) + (flatRight * rightAmount)

		if flyDirection.Magnitude > 0.01 then
			self.BodyVelocity.Velocity = flyDirection.Unit * FLY_SPEED
		else
			self.BodyVelocity.Velocity = Vector3.zero
		end
	else
		self.BodyVelocity.Velocity = Vector3.zero
	end

	self.BodyGyro.CFrame = CFrame.lookAt(rootPart.Position, rootPart.Position + cameraLook, camera.CFrame.UpVector)
end

function FlyController:Start()
	if self.Enabled then
		return true
	end

	local humanoid, rootPart = self:GetCharacterParts()

	if not humanoid or not rootPart or humanoid.Health <= 0 then
		return false
	end

	self:DisconnectConnections()
	self:DestroyMovers()

	self.Enabled = true

	humanoid.PlatformStand = true
	humanoid.AutoRotate = false

	self.BodyVelocity = Instance.new("BodyVelocity")
	self.BodyVelocity.Name = "Robox2FlyVelocity"
	self.BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	self.BodyVelocity.P = 25000
	self.BodyVelocity.Velocity = Vector3.zero
	self.BodyVelocity.Parent = rootPart

	self.BodyGyro = Instance.new("BodyGyro")
	self.BodyGyro.Name = "Robox2FlyGyro"
	self.BodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
	self.BodyGyro.P = 25000
	self.BodyGyro.D = 500
	self.BodyGyro.CFrame = rootPart.CFrame
	self.BodyGyro.Parent = rootPart

	self.DeathConnection = humanoid.Died:Connect(function()
		self:Stop()
	end)

	self.RenderConnection = RunService.RenderStepped:Connect(function()
		self:Update()
	end)

	return true
end

function FlyController:SetEnabled(state)
	if state then
		return self:Start()
	end

	self:Stop()
	return true
end

FlyController.CharacterConnection = player.CharacterAdded:Connect(function()
	FlyController:Stop()
end)

local FlyToggle = Misc:Toggle({
	Title = "Toggle Fly",
	Desc = "Fly in the camera direction",
	Type = "Toggle",
	Value = false,

	Callback = function(state)
		local started = FlyController:SetEnabled(state)

		if state and not started then
			warn("Could not enable Fly: character unavailable.")
		end
	end,
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local DEFAULT_RANGE = 70
local DETECTION_HEIGHT = 12
local DETECTION_INTERVAL = 0.1

local VISUALIZER_NAME = "Robox2DetectionArea"

local HitboxController = {
	Enabled = false,
	Range = DEFAULT_RANGE,

	Visualizer = nil,
	UpdateConnection = nil,
	CharacterConnection = nil,

	ElapsedTime = 0,
	DetectedParts = {},
	DetectedModels = {},
}

HitboxController.Detected = Instance.new("BindableEvent")

function HitboxController:GetCharacterParts()
	local character = player.Character

	if not character then
		return nil, nil, nil
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local rootPart = character:FindFirstChild("HumanoidRootPart")

	return character, humanoid, rootPart
end

function HitboxController:GetFeetPosition()
	local character, humanoid, rootPart = self:GetCharacterParts()

	if not character or not humanoid or not rootPart then
		return nil
	end

	local verticalOffset = (rootPart.Size.Y * 0.5) + humanoid.HipHeight

	return rootPart.Position - Vector3.new(0, verticalOffset, 0)
end

function HitboxController:CreateVisualizer()
	self:DestroyVisualizer()

	local character = player.Character

	if not character then
		return
	end

	local visualizer = Instance.new("Part")
	visualizer.Name = VISUALIZER_NAME

	visualizer.Anchored = true
	visualizer.CanCollide = false
	visualizer.CanTouch = false
	visualizer.CanQuery = false
	visualizer.CastShadow = false

	visualizer.Massless = true
	visualizer.Locked = true

	visualizer.Material = Enum.Material.Neon
	visualizer.Color = Color3.fromRGB(34, 197, 94)
	visualizer.Transparency = 0.7

	visualizer.Size = Vector3.new(self.Range, 0.15, self.Range)

	visualizer.Parent = workspace

	self.Visualizer = visualizer
	self:UpdateVisualizer()
end

function HitboxController:DestroyVisualizer()
	if self.Visualizer then
		self.Visualizer:Destroy()
		self.Visualizer = nil
	end
end

function HitboxController:UpdateVisualizer()
	if not self.Visualizer then
		return
	end

	local feetPosition = self:GetFeetPosition()

	if not feetPosition then
		return
	end

	self.Visualizer.Size = Vector3.new(self.Range, 0.15, self.Range)

	self.Visualizer.CFrame = CFrame.new(feetPosition - Vector3.new(0, 0.1, 0))
end

function HitboxController:CreateOverlapParams()
	local character = player.Character
	local exclusions = {}

	if character then
		table.insert(exclusions, character)
	end

	if self.Visualizer then
		table.insert(exclusions, self.Visualizer)
	end

	local overlapParams = OverlapParams.new()
	overlapParams.FilterType = Enum.RaycastFilterType.Exclude
	overlapParams.FilterDescendantsInstances = exclusions

	overlapParams.MaxParts = 0
	overlapParams.RespectCanCollide = false

	return overlapParams
end

function HitboxController:GetDetectionCFrame()
	local character, humanoid, rootPart = self:GetCharacterParts()

	if not character or not humanoid or not rootPart then
		return nil
	end

	return CFrame.new(rootPart.Position)
end

function HitboxController:Scan()
	if not self.Enabled then
		return {}, {}
	end

	local character, humanoid, rootPart = self:GetCharacterParts()

	if not character or not humanoid or not rootPart or humanoid.Health <= 0 then
		return {}, {}
	end

	local detectionCFrame = self:GetDetectionCFrame()

	if not detectionCFrame then
		return {}, {}
	end

	local detectionSize = Vector3.new(self.Range, DETECTION_HEIGHT, self.Range)

	local overlapParams = self:CreateOverlapParams()

	local parts = workspace:GetPartBoundsInBox(detectionCFrame, detectionSize, overlapParams)

	local detectedModels = {}
	local modelLookup = {}

	for _, part in ipairs(parts) do
		local model = part:FindFirstAncestorOfClass("Model")

		if model and model ~= character and not modelLookup[model] then
			modelLookup[model] = true
			table.insert(detectedModels, model)
		end
	end

	self.DetectedParts = parts
	self.DetectedModels = detectedModels

	self.Detected:Fire(parts, detectedModels)

	return parts, detectedModels
end

function HitboxController:Update(deltaTime)
	if not self.Enabled then
		return
	end

	self:UpdateVisualizer()

	self.ElapsedTime += deltaTime

	if self.ElapsedTime < DETECTION_INTERVAL then
		return
	end

	self.ElapsedTime = 0
	self:Scan()
end

function HitboxController:Start()
	if self.Enabled then
		return true
	end

	local character, humanoid, rootPart = self:GetCharacterParts()

	if not character or not humanoid or not rootPart or humanoid.Health <= 0 then
		return false
	end

	self.Enabled = true
	self.ElapsedTime = DETECTION_INTERVAL

	self:CreateVisualizer()

	if not self.UpdateConnection then
		self.UpdateConnection = RunService.Heartbeat:Connect(function(deltaTime)
			self:Update(deltaTime)
		end)
	end

	return true
end

function HitboxController:Stop()
	self.Enabled = false
	self.ElapsedTime = 0

	if self.UpdateConnection then
		self.UpdateConnection:Disconnect()
		self.UpdateConnection = nil
	end

	self:DestroyVisualizer()

	table.clear(self.DetectedParts)
	table.clear(self.DetectedModels)
end

function HitboxController:SetEnabled(state)
	if state then
		return self:Start()
	end

	self:Stop()
	return true
end

function HitboxController:SetRange(value)
	if typeof(value) ~= "number" then
		return
	end

	self.Range = math.clamp(value, 20, 120)

	if self.Visualizer then
		self:UpdateVisualizer()
	end

	if self.Enabled then
		self.ElapsedTime = DETECTION_INTERVAL
	end
end

function HitboxController:GetDetectedParts()
	return table.clone(self.DetectedParts)
end

function HitboxController:GetDetectedModels()
	return table.clone(self.DetectedModels)
end

HitboxController.CharacterConnection = player.CharacterAdded:Connect(function(character)
	if not HitboxController.Enabled then
		return
	end

	HitboxController:DestroyVisualizer()

	character:WaitForChild("Humanoid")
	character:WaitForChild("HumanoidRootPart")

	HitboxController:CreateVisualizer()
	HitboxController.ElapsedTime = DETECTION_INTERVAL
end)

local HitboxToggle = Misc:Toggle({
	Title = "Detection Area",
	Desc = "Enables the additional interaction area",
	Type = "Toggle",
	Locked = true,
	Value = false,
	Callback = function(state)
		local success = HitboxController:SetEnabled(state)

		if state == true and success == false then
			warn("Could not enable the area: character unavailable.")
		end
	end,
})

local RangeSlider = Misc:Slider({
	Title = "Range Size",
	Desc = "Sets the detection area width",
	Locked = true,
	Step = 1,
	Value = {
		Min = 20,
		Max = 120,
		Default = DEFAULT_RANGE,
	},
	Callback = function(value)
		HitboxController:SetRange(value)
	end,
})

local ButtonBypass = Misc:Button({
	Title = "Bypass Anticheat",
	Desc = "Modifies the character structure. Do not use while playing as the Beast!",
	Locked = false,
	Callback = function()
		local player = game.Players.LocalPlayer
		local character = player.Character
		if character then
			pcall(function()
				local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
				local root = character:FindFirstChild("HumanoidRootPart")
				if torso and root then
					character.Parent = nil
					root.Parent = nil
					task.wait(0.5)
					local fake = torso:Clone()
					fake.Parent = character
					torso.Name = "HumanoidRootPart"
					torso.Transparency = 1
					getgenv().Torsoo = torso
					character.Parent = workspace
				end
			end)
		end
	end,
})
