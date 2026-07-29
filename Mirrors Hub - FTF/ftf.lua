print("<b><font color='rgb(0, 255, 0)'>[Mirrors Hub] Script executed successfully!</font></b>")

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
	Placeholder = Color3.fromHex("#FFFFFF"),
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
	DialogContent = Color3.fromHex("#FFFFFF"),
	DialogIcon = Color3.fromHex("#a78bfa"),

	WindowTopbarButtonIcon = Color3.fromHex("c4b5fd"),
	WindowTopbarTitle = Color3.fromHex("FFFFFF"),
	WindowTopbarAuthor = Color3.fromHex("FFFFFF"),
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
	ElementDesc = Color3.fromHex("#FFFFFF"),
	ElementIcon = Color3.fromHex("#c4b5fd"),

	PopupBackground = WindUI:Gradient({
		["0"] = { Color = Color3.fromHex("#1e1033"), Transparency = 0 },
		["100"] = { Color = Color3.fromHex("#050208"), Transparency = 0 },
	}, {
		Rotation = 90,
	}),
	PopupBackgroundTransparency = 0.05,
	PopupTitle = Color3.fromHex("#FFFFFF"),
	PopupContent = Color3.fromHex("#FFFFFF"),
	PopupIcon = Color3.fromHex("#a78bfa"),

	Toggle = Color3.fromHex("#52525b"),
	ToggleBar = Color3.fromHex("#FFFFFF"),

	Checkbox = Color3.fromHex("#4c1d95"),
	CheckboxIcon = Color3.fromHex("#a78bfa"),

	Slider = Color3.fromHex("#4c1d95"),
	SliderThumb = Color3.fromHex("#a78bfa"),
})

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

local Info = Window:Tab({ Title = "Info", Icon = "info" })
local Esp = Window:Tab({ Title = "ESP", Icon = "eye" })
local Beast = Window:Tab({ Title = "Beast", Icon = "skull" })
local Hider = Window:Tab({ Title = "Hider", Icon = "user" })
local Misc = Window:Tab({ Title = "Misc", Icon = "layers" })
local Config = Window:Tab({ Title = "Config", Icon = "cog" })

Info:Paragraph({
    Title = "Mirrors Hub - Flee The Facility",
    Desc = "Made by blackzw.mp3. Join our Discord server to stay up to date with the latest updates, get support, and report bugs!",
    Buttons = {
        {
            Title = "Join Discord",
            Icon = "message-circle",
            Callback = function()
                setclipboard("https://discord.gg/YZEg6FyRSF")

                WindUI:Notify({
                    Title = "Discord",
                    Content = "Invite copied! Paste it into your browser to join.",
                    Duration = 3
                })
            end
        }
    }
})

local GameStatusPara = Info:Paragraph({
    Title = "Match Status",
    Desc = "Loading match data..."
})

task.spawn(function()
    while true do
        task.wait(1)

        local beastName = "None (Waiting)"
        local beastPower = "Unknown"
        local survivors = 0
        local downed = 0
        local totalComps = 0
        local hackedComps = 0

        -- 1. Verifica o Poder do Beast
        local CurrentPowerObj = game.ReplicatedStorage:FindFirstChild("CurrentPower")
        if CurrentPowerObj and CurrentPowerObj.Value ~= nil and CurrentPowerObj.Value ~= "" then
            beastPower = tostring(CurrentPowerObj.Value)
        end

        -- 2. Varre os Jogadores (Beast, Sobreviventes e Caídos)
        for _, v in pairs(game.Players:GetPlayers()) do
            if v:FindFirstChild("TempPlayerStatsModule") then
                local isBeast = v.TempPlayerStatsModule:FindFirstChild("IsBeast")
                
                if isBeast and isBeast.Value == true then
                    beastName = v.Name
                else
                    -- Se não é o Beast e tem o StatsModule, é um sobrevivente
                    survivors = survivors + 1
                    
                    local ragdoll = v.TempPlayerStatsModule:FindFirstChild("Ragdoll")
                    if ragdoll and ragdoll.Value == true then
                        downed = downed + 1
                    end
                end
            end
        end

        -- 3. Varre o Mapa procurando os Computadores
        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name == "ComputerTable" and v:FindFirstChild("Screen") then
                totalComps = totalComps + 1
                
                -- Se a tela for verde escura, o computador já foi hackeado
                if v.Screen.BrickColor == BrickColor.new("Dark green") then
                    hackedComps = hackedComps + 1
                end
            end
        end

        local compsLeft = totalComps - hackedComps

        -- 4. Monta o texto bonitão (usando quebras de linha \n)
        local newText = string.format(
            "Beast: %s\nPower: %s\n\nSurvivors: %d (%d Downed)\nComputers Left: %d / %d", 
            beastName, 
            beastPower, 
            survivors, 
            downed, 
            compsLeft, 
            totalComps
        )

        -- 5. Atualiza a interface usando o método correto da WindUI
        pcall(function()
            GameStatusPara:Set({
                Desc = newText
            })
        end)
    end
end)

-- ============================================================================
-- ESP: DOOR STATUS
-- Scans single and double doors, creates missing highlights, and maps each door
-- trigger state to the same colors used by the original implementation.
-- ============================================================================

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

local ToggleDoor = Esp:Toggle({
	Title = "Door ESP",
	Desc = "Highlights doors and updates their color to reflect the current door status",
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

-- ============================================================================
-- ESP: PLAYER LOCATIONS AND ROLES
-- Creates one managed ESP folder per remote character, displays distance, and
-- uses distinct colors and labels to identify the current Beast.
-- ============================================================================

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

local TogglePlayer = Esp:Toggle({
	Title = "Player ESP",
	Desc = "Displays player locations, distances, and a distinct highlight for the current Beast",
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

-- ============================================================================
-- BEAST: SYNCHRONIZED CRAWLING
-- Plays the crawl animation locally, synchronizes crawl input with the server,
-- and adjusts animation speed according to the character movement direction.
-- ============================================================================

local currentAnimTrack = nil
local connection = nil
local noclipConnection = nil -- Conexão para o Noclip
local player = game.Players.LocalPlayer
local remote = game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvent")
local animStorage = game:GetService("ReplicatedStorage"):FindFirstChild("Animations")
local animPath = animStorage and animStorage:FindFirstChild("AnimCrawl")
local runService = game:GetService("RunService")

local Toggle = Beast:Toggle({
	Title = "Crawl Button",
	Desc = "Enables synchronized crawling visible to everyone with Noclip",
	Type = "Toggle",
	Value = false,
	Callback = function(state)
		local char = player.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		local animator = hum and hum:FindFirstChildOfClass("Animator")

		if state then
			-- Ativa o Noclip
			if char then
				noclipConnection = runService.Stepped:Connect(function()
					if player.Character and player.Character == char then
						for _, part in ipairs(player.Character:GetDescendants()) do
							if part:IsA("BasePart") and part.CanCollide then
								part.CanCollide = false
							end
						end
					end
				end)
			end

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
			-- Desativa o Noclip
			if noclipConnection then
				noclipConnection:Disconnect()
				noclipConnection = nil
			end

			if connection then
				connection:Disconnect()
				connection = nil
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

-- ============================================================================
-- ESP: COMPUTER STATUS
-- Highlights map computers and refreshes each highlight color from the current
-- screen state while the feature remains enabled.
-- ============================================================================

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

local ToggleComputer = Esp:Toggle({
	Title = "Computer ESP",
	Desc = "Highlights map computers and updates each color from its current screen state",
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

-- ============================================================================
-- ESP: FREEZE POD LOCATIONS
-- Maintains a persistent highlight on every Freeze Pod while the feature is
-- enabled and removes only the highlights created under matching pod objects.
-- ============================================================================

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

local ToggleFreeze = Esp:Toggle({
	Title = "Freeze Pod ESP",
	Desc = "Highlights every Freeze Pod so its location remains visible across the map",
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

-- ============================================================================
-- HIDER: PERFECT AUTO HACK
-- Continuously reports successful minigame results while enabled. The original
-- polling interval and remote call are intentionally preserved.
-- ============================================================================

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

-- ============================================================================
-- HIDER: SERVER-SYNCHRONIZED INVISIBILITY
-- Maintains separate real and cloned characters, swaps the active character on
-- the configured key, and restores the original character when stopped or dead.
-- ============================================================================

getgenv().FE_Invisible_Active = false

local ToggleInvisible = Hider:Toggle({
	Title = "Invisibility (F Key)",
	Desc = "Makes you invisible on the server. Requires Anti-Cheat to be disabled!",
	Locked = true,
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

-- ============================================================================
-- HIDER: REMOVE LOCAL PLAYER ROPE
-- Detects rope constraints attached to the local character and invokes the
-- existing hammer release action without changing the original polling rate.
-- ============================================================================

local removeRopeEnabled = false

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

local ToggleRemoveRope = Hider:Toggle({
	Title = "Remove Rope (You)",
	Desc = "Automatically releases rope constraints when the Beast pulls or carries your character",
	Type = "Toggle",
	Value = false,
	Callback = function(state)
		removeRopeEnabled = state
	end,
})

-- ============================================================================
-- HIDER: BEAST RELEASE AND SLOWDOWN ACTIONS
-- Shares one player scan for two independent actions: releasing carried players
-- and forcing the Beast jump event. Either toggle may operate on its own.
-- ============================================================================

local removeRopeAllEnabled = false
local slowBeastEnabled = false

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

local ToggleRemoveRopeAll = Hider:Toggle({
	Title = "Remove Rope (All)",
	Desc = "Forces the Beast to release any player it attempts to carry or capture",
	Type = "Toggle",
	Value = false,
	Callback = function(state)
		removeRopeAllEnabled = state
	end,
})

local ToggleSlowBeast = Hider:Toggle({
	Title = "Slow Down Beast",
	Desc = "Repeatedly invokes the Beast jump event to slow or lock its movement",
	Type = "Toggle",
	Value = false,
	Callback = function(state)
		slowBeastEnabled = state
	end,
})

-- ============================================================================
-- HIDER: BEAST POWER INFORMATION
-- Reads the replicated power value and reports either the current selection or
-- the existing fallback state through a WindUI notification.
-- ============================================================================

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

-- ============================================================================
-- BEAST: CHARACTER MODIFIERS
-- Provides one-shot controls for the existing slowdown script, crawl restriction,
-- hammer audio, and gemstone light. Each action keeps its original role check.
-- ============================================================================

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

-- ============================================================================
-- BEAST: DOWNED PLAYER PROGRESS
-- Tracks downed players, creates one billboard per valid target, updates its
-- action progress, and removes stale billboards when targets recover or leave.
-- ============================================================================

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

local ToggleRagdollTime = Beast:Toggle({
	Title = "Show Player Ragdoll Time",
	Desc = "Displays each downed player and their current recovery progress above the character",
	Type = "Toggle",
	Value = false,
	Callback = function(state)
		ragdollEspEnabled = state

		if not state then
			clearAllBillboards()
		end
	end,
})

-- ============================================================================
-- MISC: CAMERA RECOVERY
-- Restores the standard camera subject, camera mode, zoom limits, and head state
-- using the same protected operation as the original button callback.
-- ============================================================================

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

-- ============================================================================
-- MISC: NOCLIP
-- Disables collision on current character parts during each Stepped update and
-- disconnects only the connection owned by this feature when toggled off.
-- ============================================================================

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

-- ============================================================================
-- MISC: INFINITE JUMP
-- Connects to JumpRequest only while enabled and forwards each request to the
-- current Humanoid without retaining stale character references.
-- ============================================================================

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

-- ============================================================================
-- MISC: CAMERA-RELATIVE FLIGHT
-- Owns the flight movers and runtime connections, derives movement from the
-- camera orientation, and restores Humanoid state whenever flight stops.
-- ============================================================================

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

-- ============================================================================
-- MISC: DETECTION AREA
-- Maintains a configurable visual area, scans nearby parts at a fixed interval,
-- resolves unique ancestor models, and publishes results through BindableEvent.
-- ============================================================================

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
	Title = "Hitbox Expander (Beta)",
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

-- ============================================================================
-- MISC: CHARACTER STRUCTURE BYPASS
-- Performs the original protected character hierarchy replacement. This remains
-- a manual action because it intentionally changes core character instances.
-- ============================================================================

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
