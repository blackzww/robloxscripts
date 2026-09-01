local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--==================================================
-- CONFIG
--==================================================

local LOAD_TIME = 15

local PURPLE = Color3.fromRGB(145,70,255)
local PURPLE2 = Color3.fromRGB(205,100,255)
local WHITE = Color3.fromRGB(245,245,250)

--==================================================
-- CLEAN
--==================================================

local old = PlayerGui:FindFirstChild("MirrorsWelcome")
if old then old:Destroy() end

local oldBlur = Lighting:FindFirstChild("MirrorsWelcomeBlur")
if oldBlur then oldBlur:Destroy() end

--==================================================
-- HELPERS
--==================================================

local function New(class,p,parent)
	local o = Instance.new(class)

	for k,v in pairs(p or {}) do
		pcall(function()
			o[k] = v
		end)
	end

	o.Parent = parent
	return o
end

local function Corner(o,r)
	return New("UICorner",{
		CornerRadius = r == true and UDim.new(1,0) or UDim.new(0,r)
	},o)
end

local function Tween(o,time,props,style,dir)
	local t = TweenService:Create(
		o,
		TweenInfo.new(
			time,
			style or Enum.EasingStyle.Quart,
			dir or Enum.EasingDirection.Out
		),
		props
	)

	t:Play()
	return t
end

local function Gradient(o,colors,rotation)
	local points = {}

	for i,c in ipairs(colors) do
		points[i] = ColorSequenceKeypoint.new(
			(i-1)/(#colors-1),
			c
		)
	end

	return New("UIGradient",{
		Color = ColorSequence.new(points),
		Rotation = rotation or 0
	},o)
end

--==================================================
-- HORÁRIO
--==================================================

local Greeting = "Olá"

pcall(function()
	local h = DateTime.now():ToLocalTime().Hour

	Greeting =
		(h >= 5 and h < 12 and "Bom Dia")
		or (h >= 12 and h < 18 and "Boa Tarde")
		or "Boa Noite"
end)

--==================================================
-- GUI
--==================================================

local Blur = New("BlurEffect",{
	Name = "MirrorsWelcomeBlur",
	Size = 0
},Lighting)

local Gui = New("ScreenGui",{
	Name = "MirrorsWelcome",
	IgnoreGuiInset = true,
	ResetOnSpawn = false,
	DisplayOrder = 999999,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling
},PlayerGui)

local Overlay = New("Frame",{
	Size = UDim2.fromScale(1,1),
	BackgroundColor3 = Color3.new(),
	BackgroundTransparency = 1,
	BorderSizePixel = 0
},Gui)

--==================================================
-- SHADOW
--==================================================

local Shadow = New("Frame",{
	AnchorPoint = Vector2.new(.5,.5),
	Position = UDim2.new(.5,0,.5,12),

	Size = UDim2.fromOffset(720,390),

	BackgroundColor3 = Color3.new(),
	BackgroundTransparency = .55,

	BorderSizePixel = 0,
	ZIndex = 2
},Overlay)

Corner(Shadow,30)

--==================================================
-- CARD
--==================================================

local Card = New("Frame",{
	AnchorPoint = Vector2.new(.5,.5),
	Position = UDim2.fromScale(.5,.5),

	Size = UDim2.fromOffset(700,370),

	BackgroundColor3 = Color3.fromRGB(32,32,39),
	BorderSizePixel = 0,

	ClipsDescendants = true,
	ZIndex = 3
},Overlay)

Corner(Card,25)

Gradient(Card,{
	Color3.fromRGB(55,55,64),
	Color3.fromRGB(38,38,45),
	Color3.fromRGB(25,25,31),
	Color3.fromRGB(17,17,22)
},135)

--==================================================
-- BORDA + GLOW
--==================================================

local Stroke = New("UIStroke",{
	Thickness = 4,
	Color = PURPLE,
	Transparency = .05,
	ApplyStrokeMode = Enum.ApplyStrokeMode.Border
},Card)

Gradient(Stroke,{
	Color3.fromRGB(100,50,255),
	PURPLE2,
	Color3.fromRGB(115,55,255)
},35)

-- respiração da borda
task.spawn(function()

	while Card.Parent do

		Tween(Stroke,1.5,{
			Transparency = .28,
			Thickness = 3
		},Enum.EasingStyle.Sine)

		task.wait(1.5)

		Tween(Stroke,1.5,{
			Transparency = .03,
			Thickness = 4
		},Enum.EasingStyle.Sine)

		task.wait(1.5)

	end

end)

--==================================================
-- EFEITO CIRCULAR PASSANDO PELO CARD
--==================================================

local Circle = New("Frame",{
	AnchorPoint = Vector2.new(.5,.5),

	Position = UDim2.fromOffset(-130,310),

	Size = UDim2.fromOffset(300,300),

	BackgroundTransparency = 1,

	ZIndex = 4
},Card)

Corner(Circle,true)

local CircleGlow = New("UIStroke",{
	Thickness = 22,
	Color = PURPLE,
	Transparency = .94
},Circle)

local CircleLine = New("UIStroke",{
	Thickness = 2,
	Color = PURPLE2,
	Transparency = .68
},Circle)

Gradient(CircleLine,{
	Color3.fromRGB(100,40,255),
	PURPLE2,
	Color3.fromRGB(110,50,255)
},45)

-- círculo atravessa a UI inteira
task.spawn(function()

	while Card.Parent do

		Circle.Position =
			UDim2.fromOffset(-160,330)

		Circle.Size =
			UDim2.fromOffset(260,260)

		CircleLine.Transparency = .85
		CircleGlow.Transparency = .97

		Tween(Circle,4.2,{
			Position = UDim2.fromOffset(850,30),
			Size = UDim2.fromOffset(480,480),
			Rotation = 180
		},Enum.EasingStyle.Sine)

		Tween(CircleLine,1,{
			Transparency = .55
		},Enum.EasingStyle.Sine)

		Tween(CircleGlow,1,{
			Transparency = .91
		},Enum.EasingStyle.Sine)

		task.wait(3)

		Tween(CircleLine,1.2,{
			Transparency = 1
		})

		Tween(CircleGlow,1.2,{
			Transparency = 1
		})

		task.wait(1.4)

	end

end)

--==================================================
-- RESPONSIVE
--==================================================

local Scale = New("UIScale",{Scale = 1},Card)
local ShadowScale = New("UIScale",{Scale = 1},Shadow)

local Camera = workspace.CurrentCamera

local function Resize()

	if not Camera then return end

	local s = Camera.ViewportSize

	local scale = math.max(.45,math.min(
		(s.X-30)/700,
		(s.Y-30)/370,
		1
	))

	Scale.Scale = scale
	ShadowScale.Scale = scale

end

Resize()

local ResizeConnection =
	Camera:GetPropertyChangedSignal("ViewportSize"):Connect(Resize)

--==================================================
-- AVATAR
--==================================================

local AvatarGlow = New("Frame",{
	AnchorPoint = Vector2.new(.5,.5),

	Position = UDim2.fromOffset(120,109),

	Size = UDim2.fromOffset(160,160),

	BackgroundColor3 = PURPLE,
	BackgroundTransparency = .93,

	BorderSizePixel = 0,

	ZIndex = 5
},Card)

Corner(AvatarGlow,true)

local AvatarHolder = New("Frame",{
	Position = UDim2.fromOffset(48,37),

	Size = UDim2.fromOffset(145,145),

	BackgroundColor3 = Color3.fromRGB(20,20,25),
	BorderSizePixel = 0,

	ClipsDescendants = true,

	ZIndex = 7
},Card)

Corner(AvatarHolder,true)

local AvatarStroke = New("UIStroke",{
	Thickness = 4,
	Color = PURPLE,
	Transparency = 0
},AvatarHolder)

Gradient(AvatarStroke,{
	Color3.fromRGB(100,50,255),
	PURPLE2,
	Color3.fromRGB(110,55,255)
},45)

--==================================================
-- AVATAR REAL
--==================================================

local Fallback = New("TextLabel",{
	Size = UDim2.fromScale(1,1),

	BackgroundTransparency = 1,

	Text = Player.Name:sub(1,1):upper(),

	TextColor3 = PURPLE2,

	Font = Enum.Font.GothamBold,
	TextSize = 50,

	ZIndex = 8
},AvatarHolder)

local Avatar = New("ImageLabel",{
	AnchorPoint = Vector2.new(.5,.5),

	Position = UDim2.fromScale(.5,.5),

	-- padding interno impede tocar no aro
	Size = UDim2.new(1,-10,1,-10),

	BackgroundTransparency = 1,

	Image = "",

	ScaleType = Enum.ScaleType.Fit,

	ZIndex = 9
},AvatarHolder)

Corner(Avatar,true)

-- halo do avatar
task.spawn(function()

	while AvatarHolder.Parent do

		Tween(AvatarGlow,1.6,{
			Size = UDim2.fromOffset(175,175),
			BackgroundTransparency = .97
		},Enum.EasingStyle.Sine)

		Tween(AvatarStroke,1.6,{
			Transparency = .25
		},Enum.EasingStyle.Sine)

		task.wait(1.6)

		Tween(AvatarGlow,1.6,{
			Size = UDim2.fromOffset(160,160),
			BackgroundTransparency = .92
		},Enum.EasingStyle.Sine)

		Tween(AvatarStroke,1.6,{
			Transparency = 0
		},Enum.EasingStyle.Sine)

		task.wait(1.6)

	end

end)

--==================================================
-- THUMBNAIL
--==================================================

task.spawn(function()

	for i = 1,5 do

		if not Gui.Parent then return end

		local ok,image,ready = pcall(function()

			return Players:GetUserThumbnailAsync(
				Player.UserId,
				Enum.ThumbnailType.HeadShot,
				Enum.ThumbnailSize.Size420x420
			)

		end)

		if ok and ready and image and image ~= "" then

			Avatar.Image = image
			Fallback.Visible = false

			return

		end

		task.wait(.25*i)

	end

end)

--==================================================
-- TEXT
--==================================================

local function Text(pos,size,value,font,textSize,color,align)

	local t = New("TextLabel",{
		Position = pos,
		Size = size,

		BackgroundTransparency = 1,

		Text = value,
		TextColor3 = color,

		TextTransparency = 0,

		TextXAlignment =
			align or Enum.TextXAlignment.Center,

		TextYAlignment =
			Enum.TextYAlignment.Center,

		Font = font,
		TextSize = textSize,

		ZIndex = 7
	},Card)

	return t

end

local GreetingText = Text(
	UDim2.fromOffset(220,52),
	UDim2.fromOffset(430,48),

	Greeting..",",

	Enum.Font.GothamBold,
	32,

	WHITE,

	Enum.TextXAlignment.Left
)

local Username = Text(
	UDim2.fromOffset(220,96),
	UDim2.fromOffset(430,40),

	Player.Name.."!",

	Enum.Font.GothamBold,
	29,

	PURPLE2,

	Enum.TextXAlignment.Left
)

Username.TextTruncate =
	Enum.TextTruncate.AtEnd

local Welcome = Text(
	UDim2.fromOffset(220,140),
	UDim2.fromOffset(430,30),

	"Bem-vindo(a) ao meu script!",

	Enum.Font.Gotham,
	18,

	Color3.fromRGB(200,200,210),

	Enum.TextXAlignment.Left
)

--==================================================
-- ENTRADA DOS TEXTOS
--==================================================

for i,t in ipairs({
	GreetingText,
	Username,
	Welcome
}) do

	local final = t.Position

	t.Position =
		final + UDim2.fromOffset(20,0)

	t.TextTransparency = 1

	task.delay(.12*i,function()

		if not t.Parent then return end

		Tween(t,.55,{
			Position = final,
			TextTransparency = 0
		})

	end)

end

--==================================================
-- DIVIDER
--==================================================

local Divider = New("Frame",{
	Position = UDim2.fromOffset(35,200),

	Size = UDim2.new(1,-70,0,1),

	BackgroundColor3 = PURPLE,

	BackgroundTransparency = .62,

	BorderSizePixel = 0,

	ZIndex = 7
},Card)

--==================================================
-- LOADING
--==================================================

local Loading = Text(
	UDim2.fromOffset(0,215),
	UDim2.new(1,0,0,30),

	"Carregando...",

	Enum.Font.GothamMedium,
	18,

	PURPLE2
)

local Bar = New("Frame",{
	Position = UDim2.fromOffset(70,257),

	Size = UDim2.fromOffset(500,30),

	BackgroundColor3 =
		Color3.fromRGB(16,16,21),

	BorderSizePixel = 0,

	ClipsDescendants = true,

	ZIndex = 7
},Card)

Corner(Bar,true)

New("UIStroke",{
	Thickness = 1.5,

	Color = Color3.fromRGB(125,75,185),

	Transparency = .3
},Bar)

local Fill = New("Frame",{
	Size = UDim2.fromScale(0,1),

	BackgroundColor3 = PURPLE,

	BorderSizePixel = 0,

	ClipsDescendants = true,

	ZIndex = 8
},Bar)

Corner(Fill,true)

Gradient(Fill,{
	Color3.fromRGB(90,40,255),
	Color3.fromRGB(145,60,255),
	Color3.fromRGB(230,110,255)
})

--==================================================
-- SHIMMER
--==================================================

local Shimmer = New("Frame",{
	AnchorPoint = Vector2.new(.5,.5),

	Position = UDim2.new(-.2,0,.5,0),

	Size = UDim2.fromOffset(80,60),

	BackgroundColor3 = Color3.new(1,1,1),

	BackgroundTransparency = .72,

	BorderSizePixel = 0,

	Rotation = 20,

	ZIndex = 9
},Fill)

Gradient(Shimmer,{
	Color3.new(1,1,1),
	Color3.fromRGB(255,190,255),
	Color3.new(1,1,1)
})

task.spawn(function()

	while Fill.Parent do

		Shimmer.Position =
			UDim2.new(-.2,0,.5,0)

		Tween(
			Shimmer,
			1.6,
			{
				Position =
					UDim2.new(1.2,0,.5,0)
			},
			Enum.EasingStyle.Linear
		)

		task.wait(2)

	end

end)

local Percent = Text(
	UDim2.fromOffset(588,257),
	UDim2.fromOffset(75,30),

	"0%",

	Enum.Font.GothamMedium,
	19,

	PURPLE2,

	Enum.TextXAlignment.Left
)

--==================================================
-- ESTRELA CLEAN QUE APARECE
--==================================================

local Star = New("Frame",{
	AnchorPoint = Vector2.new(.5,.5),

	Position = UDim2.fromOffset(218,330),

	Size = UDim2.fromOffset(0,0),

	BackgroundTransparency = 1,

	ZIndex = 9
},Card)

local StarCenter = New("Frame",{
	AnchorPoint = Vector2.new(.5,.5),

	Position = UDim2.fromScale(.5,.5),

	Size = UDim2.fromOffset(8,8),

	BackgroundColor3 = PURPLE2,

	BackgroundTransparency = 1,

	Rotation = 45,

	BorderSizePixel = 0,

	ZIndex = 9
},Star)

Corner(StarCenter,2)

local StarVertical = New("Frame",{
	AnchorPoint = Vector2.new(.5,.5),

	Position = UDim2.fromScale(.5,.5),

	Size = UDim2.fromOffset(3,0),

	BackgroundColor3 = PURPLE2,

	BackgroundTransparency = 1,

	BorderSizePixel = 0,

	ZIndex = 9
},Star)

Corner(StarVertical,true)

local StarHorizontal = New("Frame",{
	AnchorPoint = Vector2.new(.5,.5),

	Position = UDim2.fromScale(.5,.5),

	Size = UDim2.fromOffset(0,3),

	BackgroundColor3 = PURPLE2,

	BackgroundTransparency = 1,

	BorderSizePixel = 0,

	ZIndex = 9
},Star)

Corner(StarHorizontal,true)

-- estrela surge e some
task.spawn(function()

	while Star.Parent do

		Star.Size = UDim2.fromOffset(24,24)

		StarCenter.BackgroundTransparency = 1
		StarVertical.BackgroundTransparency = 1
		StarHorizontal.BackgroundTransparency = 1

		StarVertical.Size =
			UDim2.fromOffset(3,0)

		StarHorizontal.Size =
			UDim2.fromOffset(0,3)

		task.wait(1.1)

		Tween(StarCenter,.25,{
			BackgroundTransparency = .05,
			Size = UDim2.fromOffset(9,9)
		})

		Tween(StarVertical,.3,{
			Size = UDim2.fromOffset(3,22),
			BackgroundTransparency = .05
		})

		Tween(StarHorizontal,.3,{
			Size = UDim2.fromOffset(22,3),
			BackgroundTransparency = .05
		})

		task.wait(.45)

		Tween(StarCenter,.45,{
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(3,3)
		})

		Tween(StarVertical,.45,{
			Size = UDim2.fromOffset(2,5),
			BackgroundTransparency = 1
		})

		Tween(StarHorizontal,.45,{
			Size = UDim2.fromOffset(5,2),
			BackgroundTransparency = 1
		})

		task.wait(1.5)

	end

end)

--==================================================
-- THANKS
--==================================================

Text(
	UDim2.fromOffset(235,315),
	UDim2.fromOffset(340,30),

	"Obrigado por utilizar o meu script!",

	Enum.Font.Gotham,
	18,

	Color3.fromRGB(215,215,222),

	Enum.TextXAlignment.Left
)

--==================================================
-- ENTRADA PRINCIPAL
--==================================================

Card.Position =
	UDim2.fromScale(.5,.56)

Shadow.Position =
	UDim2.new(.5,0,.56,12)

Tween(Overlay,.45,{
	BackgroundTransparency = .63
})

Tween(Blur,.5,{
	Size = 12
})

Tween(Card,.65,{
	Position = UDim2.fromScale(.5,.5)
},Enum.EasingStyle.Back)

Tween(Shadow,.65,{
	Position = UDim2.new(.5,0,.5,12)
},Enum.EasingStyle.Back)

--==================================================
-- LOADING
--==================================================

Tween(
	Fill,
	LOAD_TIME,
	{
		Size = UDim2.fromScale(1,1)
	},
	Enum.EasingStyle.Linear
)

local Started = os.clock()
local Last = -1

while Gui.Parent do

	local progress = math.clamp(
		(os.clock()-Started)/LOAD_TIME,
		0,
		1
	)

	local value =
		math.floor(progress*100)

	if value ~= Last then
		Last = value
		Percent.Text = value.."%"
	end

	if progress >= 1 then
		break
	end

	task.wait(.08)

end

if not Gui.Parent then return end

Fill.Size =
	UDim2.fromScale(1,1)

Percent.Text = "100%"
Loading.Text = "Carregado!"

-- pequeno impacto final
Tween(Stroke,.25,{
	Thickness = 6,
	Transparency = 0
})

task.wait(.25)

Tween(Stroke,.4,{
	Thickness = 4,
	Transparency = .04
})

task.wait(1)

--==================================================
-- SAÍDA
--==================================================

Tween(Card,.5,{
	Position = UDim2.fromScale(.5,.44)
},Enum.EasingStyle.Quart,Enum.EasingDirection.In)

Tween(Shadow,.5,{
	Position = UDim2.new(.5,0,.44,12),
	BackgroundTransparency = 1
})

Tween(Overlay,.5,{
	BackgroundTransparency = 1
})

Tween(Blur,.5,{
	Size = 0
})

task.wait(.52)

ResizeConnection:Disconnect()

if Blur.Parent then
	Blur:Destroy()
end

if Gui.Parent then
	Gui:Destroy()
end
