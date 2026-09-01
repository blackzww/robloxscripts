local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer

if not Player then
	error("[MirrorsWelcome] LocalPlayer não encontrado.")
end

local PlayerGui = Player:WaitForChild("PlayerGui", 10)

if not PlayerGui then
	error("[MirrorsWelcome] PlayerGui não encontrado.")
end

--==================================================
-- CONFIG
--==================================================

local CONFIG = {
	LoadTime = 15,
	LoadedHoldTime = 1.15,
	ProgressUpdateRate = 0.05,

	BaseWidth = 700,
	BaseHeight = 370,
	ScreenMargin = 18,

	UseDisplayName = false,

	ThumbnailType = Enum.ThumbnailType.HeadShot,
	ThumbnailSize = Enum.ThumbnailSize.Size420x420,
	ThumbnailAttempts = 5,
	ThumbnailRetryDelay = 0.25,

	BlurEnabled = true,
	BlurSize = 12,

	OuterStroke = 4,
	AvatarStroke = 4,

	Purple = Color3.fromRGB(145, 70, 255),
	PurpleLight = Color3.fromRGB(210, 105, 255),

	GuiName = "MirrorsWelcome",
	BlurName = "MirrorsWelcomeBlur",
	RunAttribute = "MirrorsWelcomeRun"
}

--==================================================
-- CONTROLE DE EXECUÇÃO
--==================================================

local RunId = HttpService:GenerateGUID(false)

PlayerGui:SetAttribute(
	CONFIG.RunAttribute,
	RunId
)

local function IsCurrentRun()
	return PlayerGui:GetAttribute(
		CONFIG.RunAttribute
	) == RunId
end

--==================================================
-- REMOVER VERSÃO ANTERIOR
--==================================================

local OldGui = PlayerGui:FindFirstChild(
	CONFIG.GuiName
)

if OldGui then
	OldGui:Destroy()
end

local OldBlur = Lighting:FindFirstChild(
	CONFIG.BlurName
)

if OldBlur then
	OldBlur:Destroy()
end

--==================================================
-- VARIÁVEIS DE CLEANUP
--==================================================

local Gui
local Blur
local AvatarThread

local Connections = {}
local Tweens = {}

local Destroyed = false

local function TrackConnection(Connection)
	table.insert(
		Connections,
		Connection
	)

	return Connection
end

local function TrackTween(Tween)
	table.insert(
		Tweens,
		Tween
	)

	return Tween
end

local function Alive()

	return
		not Destroyed
		and IsCurrentRun()
		and Gui
		and Gui.Parent ~= nil

end

local function Cleanup()

	if Destroyed then
		return
	end

	Destroyed = true

	for _, Connection in ipairs(Connections) do

		pcall(function()
			Connection:Disconnect()
		end)

	end

	table.clear(Connections)

	for _, Tween in ipairs(Tweens) do

		pcall(function()
			Tween:Cancel()
		end)

	end

	table.clear(Tweens)

	if AvatarThread then

		pcall(function()
			task.cancel(AvatarThread)
		end)

		AvatarThread = nil

	end

	if Blur then

		pcall(function()
			Blur:Destroy()
		end)

		Blur = nil

	end

	if Gui then

		pcall(function()
			Gui:Destroy()
		end)

		Gui = nil

	end

	if IsCurrentRun() then

		PlayerGui:SetAttribute(
			CONFIG.RunAttribute,
			nil
		)

	end

end

--==================================================
-- HELPERS
--==================================================

local function New(
	ClassName,
	Properties,
	Parent
)

	local Object = Instance.new(
		ClassName
	)

	for Property, Value in pairs(Properties or {}) do

		local Success = pcall(function()
			Object[Property] = Value
		end)

		if not Success then
			warn(
				"[MirrorsWelcome] Propriedade ignorada:",
				ClassName,
				Property
			)
		end

	end

	if Parent then
		Object.Parent = Parent
	end

	return Object

end

local function CreateCorner(
	Parent,
	Radius
)

	return New(
		"UICorner",
		{
			CornerRadius = UDim.new(
				0,
				Radius
			)
		},
		Parent
	)

end

local function CreateRoundCorner(
	Parent
)

	return New(
		"UICorner",
		{
			CornerRadius = UDim.new(
				1,
				0
			)
		},
		Parent
	)

end

local function TryOuterStroke(Stroke)

	pcall(function()

		Stroke.BorderStrokePosition =
			Enum.BorderStrokePosition.Outer

	end)

end

--==================================================
-- HORÁRIO LOCAL
--==================================================

local function GetGreeting()

	local Success, LocalTime =
		pcall(function()

			return DateTime.now():ToLocalTime()

		end)

	if not Success or not LocalTime then
		return "Olá"
	end

	local Hour = LocalTime.Hour

	if Hour >= 5 and Hour < 12 then

		return "Bom Dia"

	elseif Hour >= 12 and Hour < 18 then

		return "Boa Tarde"

	else

		return "Boa Noite"

	end

end

local Greeting = GetGreeting()

local Username =
	CONFIG.UseDisplayName
	and Player.DisplayName
	or Player.Name

--==================================================
-- ACESSIBILIDADE
--==================================================

local ReducedMotion = false

pcall(function()

	ReducedMotion =
		GuiService.ReducedMotionEnabled

end)

--==================================================
-- MAIN
--==================================================

local Success, ErrorMessage = xpcall(
	function()

		if not IsCurrentRun() then
			return
		end

		--==================================================
		-- BLUR
		--==================================================

		if CONFIG.BlurEnabled then

			Blur = New(
				"BlurEffect",
				{
					Name = CONFIG.BlurName,
					Size = 0
				},
				Lighting
			)

		end

		--==================================================
		-- GUI
		--==================================================

		Gui = New(
			"ScreenGui",
			{
				Name = CONFIG.GuiName,

				ResetOnSpawn = false,

				DisplayOrder = 999999,

				ZIndexBehavior =
					Enum.ZIndexBehavior.Sibling,

				IgnoreGuiInset = false
			},
			PlayerGui
		)

		pcall(function()

			Gui.ScreenInsets =
				Enum.ScreenInsets.CoreUISafeInsets

			Gui.ClipToDeviceSafeArea = true

		end)

		TrackConnection(

			Gui.Destroying:Connect(function()

				Destroyed = true

			end)

		)

		--==================================================
		-- OVERLAY
		--==================================================

		local Overlay = New(
			"Frame",
			{
				Name = "Overlay",

				Size =
					UDim2.fromScale(1, 1),

				BackgroundColor3 =
					Color3.fromRGB(
						0,
						0,
						0
					),

				BackgroundTransparency = 1,

				BorderSizePixel = 0,

				ZIndex = 1
			},
			Gui
		)

		--==================================================
		-- CARD
		--==================================================

		local Card = New(
			"CanvasGroup",
			{
				Name = "Card",

				AnchorPoint =
					Vector2.new(
						0.5,
						0.5
					),

				Position =
					UDim2.fromScale(
						0.5,
						0.5
					),

				Size =
					UDim2.fromOffset(
						CONFIG.BaseWidth,
						CONFIG.BaseHeight
					),

				BackgroundColor3 =
					Color3.fromRGB(
						26,
						26,
						32
					),

				BorderSizePixel = 0,

				GroupTransparency = 0,

				ZIndex = 10
			},
			Overlay
		)

		CreateCorner(
			Card,
			25
		)

		--==================================================
		-- CARD GRADIENT
		--==================================================

		New(
			"UIGradient",
			{
				Rotation = 135,

				Color =
					ColorSequence.new({

						ColorSequenceKeypoint.new(
							0,
							Color3.fromRGB(
								52,
								52,
								60
							)
						),

						ColorSequenceKeypoint.new(
							0.30,
							Color3.fromRGB(
								39,
								39,
								46
							)
						),

						ColorSequenceKeypoint.new(
							0.63,
							Color3.fromRGB(
								26,
								26,
								32
							)
						),

						ColorSequenceKeypoint.new(
							1,
							Color3.fromRGB(
								14,
								14,
								18
							)
						)

					})
			},
			Card
		)

		--==================================================
		-- CARD STROKE
		--==================================================

		local CardStroke = New(
			"UIStroke",
			{
				ApplyStrokeMode =
					Enum.ApplyStrokeMode.Border,

				Thickness =
					CONFIG.OuterStroke,

				Transparency = 0.04,

				Color =
					CONFIG.Purple
			},
			Card
		)

		TryOuterStroke(
			CardStroke
		)

		New(
			"UIGradient",
			{
				Rotation = 30,

				Color =
					ColorSequence.new({

						ColorSequenceKeypoint.new(
							0,
							Color3.fromRGB(
								100,
								50,
								255
							)
						),

						ColorSequenceKeypoint.new(
							0.5,
							Color3.fromRGB(
								220,
								110,
								255
							)
						),

						ColorSequenceKeypoint.new(
							1,
							Color3.fromRGB(
								120,
								60,
								255
							)
						)

					})
			},
			CardStroke
		)

		--==================================================
		-- RESPONSIVIDADE
		--==================================================

		local Scale = New(
			"UIScale",
			{
				Scale = 1
			},
			Card
		)

		local function UpdateScale()

			if not Alive() then
				return
			end

			local Size =
				Overlay.AbsoluteSize

			if Size.X <= 0
				or Size.Y <= 0
			then
				return
			end

			local Margin =
				CONFIG.ScreenMargin * 2

			local Width =
				math.max(
					Size.X - Margin,
					1
				)

			local Height =
				math.max(
					Size.Y - Margin,
					1
				)

			local X =
				Width
				/ CONFIG.BaseWidth

			local Y =
				Height
				/ CONFIG.BaseHeight

			Scale.Scale =
				math.max(
					math.min(
						X,
						Y,
						1
					),
					0.1
				)

		end

		TrackConnection(

			Overlay:GetPropertyChangedSignal(
				"AbsoluteSize"
			):Connect(
				UpdateScale
			)

		)

		task.defer(
			UpdateScale
		)

		--==================================================
		-- AVATAR HOLDER
		--==================================================

		local AvatarHolder = New(
			"Frame",
			{
				Name = "AvatarHolder",

				Position =
					UDim2.fromOffset(
						48,
						38
					),

				Size =
					UDim2.fromOffset(
						145,
						145
					),

				BackgroundColor3 =
					Color3.fromRGB(
						17,
						17,
						22
					),

				BorderSizePixel = 0,

				ClipsDescendants = true,

				ZIndex = 15
			},
			Card
		)

		CreateRoundCorner(
			AvatarHolder
		)

		--==================================================
		-- FALLBACK
		--==================================================

		local FirstLetter =
			string.upper(
				string.sub(
					Player.Name,
					1,
					1
				)
			)

		local AvatarFallback = New(
			"TextLabel",
			{
				Name = "AvatarFallback",

				Size =
					UDim2.fromScale(
						1,
						1
					),

				BackgroundTransparency = 1,

				Text = FirstLetter,

				TextColor3 =
					CONFIG.PurpleLight,

				Font =
					Enum.Font.GothamBold,

				TextSize = 52,

				AutoLocalize = false,

				ZIndex = 16
			},
			AvatarHolder
		)

		--==================================================
		-- AVATAR OFICIAL
		--==================================================

		local AvatarImage = New(
			"ImageLabel",
			{
				Name = "Avatar",

				AnchorPoint =
					Vector2.new(
						0.5,
						0.5
					),

				Position =
					UDim2.fromScale(
						0.5,
						0.5
					),

				Size =
					UDim2.fromScale(
						1,
						1
					),

				BackgroundTransparency = 1,

				Image = "",

				ScaleType =
					Enum.ScaleType.Fit,

				ZIndex = 17
			},
			AvatarHolder
		)

		--==================================================
		-- AVATAR STROKE
		--==================================================

		local AvatarStroke = New(
			"UIStroke",
			{
				ApplyStrokeMode =
					Enum.ApplyStrokeMode.Border,

				Thickness =
					CONFIG.AvatarStroke,

				Transparency = 0,

				Color =
					CONFIG.Purple
			},
			AvatarHolder
		)

		TryOuterStroke(
			AvatarStroke
		)

		New(
			"UIGradient",
			{
				Rotation = 45,

				Color =
					ColorSequence.new({

						ColorSequenceKeypoint.new(
							0,
							Color3.fromRGB(
								95,
								50,
								255
							)
						),

						ColorSequenceKeypoint.new(
							0.5,
							Color3.fromRGB(
								220,
								110,
								255
							)
						),

						ColorSequenceKeypoint.new(
							1,
							Color3.fromRGB(
								115,
								60,
								255
							)
						)

					})
			},
			AvatarStroke
		)

		--==================================================
		-- TEXT HELPER
		--==================================================

		local function Text(
			Name,
			Position,
			Size,
			Value,
			Font,
			TextSize,
			Color,
			Alignment
		)

			return New(
				"TextLabel",
				{
					Name = Name,

					Position = Position,

					Size = Size,

					BackgroundTransparency = 1,

					Text = Value,

					TextColor3 = Color,

					TextXAlignment =
						Alignment,

					TextYAlignment =
						Enum.TextYAlignment.Center,

					Font = Font,

					TextSize = TextSize,

					AutoLocalize = false,

					ZIndex = 15
				},
				Card
			)

		end

		--==================================================
		-- GREETING
		--==================================================

		Text(
			"Greeting",

			UDim2.fromOffset(
				220,
				53
			),

			UDim2.fromOffset(
				430,
				48
			),

			Greeting .. ",",

			Enum.Font.GothamBold,

			32,

			Color3.fromRGB(
				245,
				245,
				250
			),

			Enum.TextXAlignment.Left
		)

		--==================================================
		-- USERNAME
		--==================================================

		local UsernameText = Text(
			"Username",

			UDim2.fromOffset(
				220,
				98
			),

			UDim2.fromOffset(
				430,
				40
			),

			Username .. "!",

			Enum.Font.GothamBold,

			29,

			CONFIG.PurpleLight,

			Enum.TextXAlignment.Left
		)

		UsernameText.TextTruncate =
			Enum.TextTruncate.AtEnd

		--==================================================
		-- WELCOME
		--==================================================

		Text(
			"Welcome",

			UDim2.fromOffset(
				220,
				141
			),

			UDim2.fromOffset(
				430,
				30
			),

			"Bem-vindo(a) ao meu script! 👋",

			Enum.Font.Gotham,

			18,

			Color3.fromRGB(
				192,
				192,
				202
			),

			Enum.TextXAlignment.Left
		)

		--==================================================
		-- DIVIDER
		--==================================================

		New(
			"Frame",
			{
				Name = "Divider",

				Position =
					UDim2.fromOffset(
						35,
						200
					),

				Size =
					UDim2.new(
						1,
						-70,
						0,
						1
					),

				BackgroundColor3 =
					CONFIG.Purple,

				BackgroundTransparency =
					0.63,

				BorderSizePixel = 0,

				ZIndex = 15
			},
			Card
		)

		--==================================================
		-- LOADING TEXT
		--==================================================

		local LoadingText = Text(
			"Loading",

			UDim2.fromOffset(
				0,
				215
			),

			UDim2.new(
				1,
				0,
				0,
				30
			),

			"Carregando...",

			Enum.Font.GothamMedium,

			18,

			CONFIG.PurpleLight,

			Enum.TextXAlignment.Center
		)

		--==================================================
		-- BAR
		--==================================================

		local Bar = New(
			"Frame",
			{
				Name = "ProgressBar",

				Position =
					UDim2.fromOffset(
						70,
						257
					),

				Size =
					UDim2.fromOffset(
						500,
						30
					),

				BackgroundColor3 =
					Color3.fromRGB(
						15,
						15,
						20
					),

				BorderSizePixel = 0,

				ClipsDescendants = true,

				ZIndex = 15
			},
			Card
		)

		CreateRoundCorner(
			Bar
		)

		New(
			"UIStroke",
			{
				Thickness = 1.5,

				Transparency =
					0.28,

				Color =
					Color3.fromRGB(
						125,
						75,
						185
					)
			},
			Bar
		)

		--==================================================
		-- FILL
		--==================================================

		local Fill = New(
			"Frame",
			{
				Name = "Fill",

				Size =
					UDim2.fromScale(
						0,
						1
					),

				BackgroundColor3 =
					CONFIG.Purple,

				BorderSizePixel = 0,

				ZIndex = 16
			},
			Bar
		)

		CreateRoundCorner(
			Fill
		)

		New(
			"UIGradient",
			{
				Color =
					ColorSequence.new({

						ColorSequenceKeypoint.new(
							0,
							Color3.fromRGB(
								95,
								45,
								255
							)
						),

						ColorSequenceKeypoint.new(
							0.5,
							Color3.fromRGB(
								150,
								65,
								255
							)
						),

						ColorSequenceKeypoint.new(
							1,
							Color3.fromRGB(
								225,
								105,
								255
							)
						)

					})
			},
			Fill
		)

		--==================================================
		-- %
		--==================================================

		local PercentText = Text(
			"Percent",

			UDim2.fromOffset(
				588,
				257
			),

			UDim2.fromOffset(
				75,
				30
			),

			"0%",

			Enum.Font.GothamMedium,

			19,

			CONFIG.PurpleLight,

			Enum.TextXAlignment.Left
		)

		--==================================================
		-- THANKS
		--==================================================

		Text(
			"Thanks",

			UDim2.fromOffset(
				20,
				315
			),

			UDim2.new(
				1,
				-40,
				0,
				30
			),

			"✦  Obrigado por utilizar o meu script!",

			Enum.Font.Gotham,

			18,

			Color3.fromRGB(
				208,
				208,
				216
			),

			Enum.TextXAlignment.Center
		)

		--==================================================
		-- AVATAR ASYNC
		--==================================================

		AvatarThread =
			task.spawn(function()

				for Attempt = 1,
					CONFIG.ThumbnailAttempts
				do

					if not Alive() then
						return
					end

					local ThumbnailSuccess,
						Content,
						Ready =
						pcall(function()

							return Players:GetUserThumbnailAsync(

								Player.UserId,

								CONFIG.ThumbnailType,

								CONFIG.ThumbnailSize

							)

						end)

					if
						ThumbnailSuccess
						and Ready == true
						and type(Content) == "string"
						and Content ~= ""
					then

						if not Alive() then
							return
						end

						if not AvatarImage.Parent then
							return
						end

						AvatarImage.Image =
							Content

						AvatarFallback.Visible =
							false

						return

					end

					if Attempt <
						CONFIG.ThumbnailAttempts
					then

						local Delay =
							CONFIG.ThumbnailRetryDelay
							* (
								2
								^ (Attempt - 1)
							)

						task.wait(
							Delay
						)

					end

				end

			end)

		--==================================================
		-- ENTRY
		--==================================================

		if ReducedMotion then

			Overlay.BackgroundTransparency =
				0.60

			Card.GroupTransparency = 0

			Card.Position =
				UDim2.fromScale(
					0.5,
					0.5
				)

			if Blur then
				Blur.Size =
					CONFIG.BlurSize
			end

		else

			Card.Position =
				UDim2.fromScale(
					0.5,
					0.545
				)

			Card.GroupTransparency = 1

			local OverlayTween =
				TrackTween(

					TweenService:Create(
						Overlay,

						TweenInfo.new(
							0.40,
							Enum.EasingStyle.Quart,
							Enum.EasingDirection.Out
						),

						{
							BackgroundTransparency =
								0.60
						}
					)

				)

			local CardTween =
				TrackTween(

					TweenService:Create(
						Card,

						TweenInfo.new(
							0.52,
							Enum.EasingStyle.Quart,
							Enum.EasingDirection.Out
						),

						{
							Position =
								UDim2.fromScale(
									0.5,
									0.5
								),

							GroupTransparency = 0
						}
					)

				)

			OverlayTween:Play()
			CardTween:Play()

			if Blur then

				local BlurTween =
					TrackTween(

						TweenService:Create(
							Blur,

							TweenInfo.new(
								0.45,
								Enum.EasingStyle.Quart,
								Enum.EasingDirection.Out
							),

							{
								Size =
									CONFIG.BlurSize
							}
						)

					)

				BlurTween:Play()

			end

		end

		--==================================================
		-- LOADING
		--==================================================

		local LoadTime =
			math.max(
				CONFIG.LoadTime,
				0
			)

		if LoadTime == 0 then

			Fill.Size =
				UDim2.fromScale(
					1,
					1
				)

			PercentText.Text =
				"100%"

		else

			local FillTween =
				TrackTween(

					TweenService:Create(
						Fill,

						TweenInfo.new(
							LoadTime,
							Enum.EasingStyle.Linear,
							Enum.EasingDirection.Out
						),

						{
							Size =
								UDim2.fromScale(
									1,
									1
								)
						}
					)

				)

			local StartedAt =
				os.clock()

			FillTween:Play()

			while Alive() do

				local Elapsed =
					os.clock()
					- StartedAt

				local Progress =
					math.clamp(
						Elapsed
							/ LoadTime,
						0,
						1
					)

				local Percent =
					math.floor(
						Progress
							* 100
					)

				PercentText.Text =
					tostring(
						Percent
					)
					.. "%"

				if Progress >= 1 then
					break
				end

				task.wait(
					CONFIG.ProgressUpdateRate
				)

			end

			if not Alive() then
				return
			end

			Fill.Size =
				UDim2.fromScale(
					1,
					1
				)

			PercentText.Text =
				"100%"

		end

		--==================================================
		-- LOADED
		--==================================================

		LoadingText.Text =
			"Carregado!"

		local HoldStarted =
			os.clock()

		while
			Alive()
			and (
				os.clock()
				- HoldStarted
			)
			<
			CONFIG.LoadedHoldTime
		do

			task.wait(0.05)

		end

		if not Alive() then
			return
		end

		--==================================================
		-- EXIT
		--==================================================

		if ReducedMotion then

			Card.GroupTransparency = 1

			Overlay.BackgroundTransparency =
				1

			if Blur then
				Blur.Size = 0
			end

		else

			local ExitTime = 0.42

			local CardExit =
				TrackTween(

					TweenService:Create(
						Card,

						TweenInfo.new(
							ExitTime,
							Enum.EasingStyle.Quart,
							Enum.EasingDirection.In
						),

						{
							Position =
								UDim2.fromScale(
									0.5,
									0.465
								),

							GroupTransparency = 1
						}
					)

				)

			local OverlayExit =
				TrackTween(

					TweenService:Create(
						Overlay,

						TweenInfo.new(
							ExitTime
						),

						{
							BackgroundTransparency =
								1
						}
					)

				)

			CardExit:Play()
			OverlayExit:Play()

			if Blur then

				local BlurExit =
					TrackTween(

						TweenService:Create(
							Blur,

							TweenInfo.new(
								ExitTime
							),

							{
								Size = 0
							}
						)

					)

				BlurExit:Play()

			end

			local ExitStarted =
				os.clock()

			while
				Alive()
				and (
					os.clock()
						- ExitStarted
				)
				<
				ExitTime + 0.05
			do

				task.wait(0.03)

			end

		end

	end,

	function(Error)

		local Trace = tostring(Error)

		pcall(function()

			Trace =
				debug.traceback(
					tostring(Error),
					2
				)

		end)

		return Trace

	end
)

--==================================================
-- CLEANUP GARANTIDO
--==================================================

Cleanup()

if not Success then

	warn(
		"[MirrorsWelcome]\n"
			.. tostring(
				ErrorMessage
			)
	)

end
