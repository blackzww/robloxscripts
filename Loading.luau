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
local LIGHT = Color3.fromRGB(215,110,255)

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
		pcall(function() o[k] = v end)
	end
	o.Parent = parent
	return o
end

local function Corner(o,r)
	return New("UICorner",{
		CornerRadius = r == true and UDim.new(1,0) or UDim.new(0,r)
	},o)
end

local function Tween(o,t,p,style,dir)
	local x = TweenService:Create(o,TweenInfo.new(
		t,
		style or Enum.EasingStyle.Quart,
		dir or Enum.EasingDirection.Out
	),p)
	x:Play()
	return x
end

local function Gradient(o,colors,rotation)
	local k = {}
	for i,c in ipairs(colors) do
		k[i] = ColorSequenceKeypoint.new((i-1)/(#colors-1),c)
	end

	return New("UIGradient",{
		Color = ColorSequence.new(k),
		Rotation = rotation or 0
	},o)
end

local function Stroke(o,size,trans)
	local s = New("UIStroke",{
		Thickness = size,
		Transparency = trans or .05,
		Color = PURPLE,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	},o)

	Gradient(s,{
		Color3.fromRGB(95,45,255),
		LIGHT,
		Color3.fromRGB(110,55,255)
	},35)

	return s
end

local function Spark(parent,pos,size,z)
	local h = New("Frame",{
		AnchorPoint = Vector2.new(.5,.5),
		Position = pos,
		Size = UDim2.fromOffset(size,2),
		BackgroundColor3 = LIGHT,
		BorderSizePixel = 0,
		ZIndex = z
	},parent)

	local v = New("Frame",{
		AnchorPoint = Vector2.new(.5,.5),
		Position = pos,
		Size = UDim2.fromOffset(2,size),
		BackgroundColor3 = LIGHT,
		BorderSizePixel = 0,
		ZIndex = z
	},parent)

	Corner(h,true)
	Corner(v,true)

	task.spawn(function()
		while parent.Parent do
			Tween(h,.7,{
				Size = UDim2.fromOffset(size*1.45,2),
				BackgroundTransparency = .15
			},Enum.EasingStyle.Sine)

			Tween(v,.7,{
				Size = UDim2.fromOffset(2,size*1.45),
				BackgroundTransparency = .15
			},Enum.EasingStyle.Sine)

			task.wait(.7)

			Tween(h,.7,{
				Size = UDim2.fromOffset(size,2),
				BackgroundTransparency = .55
			},Enum.EasingStyle.Sine)

			Tween(v,.7,{
				Size = UDim2.fromOffset(2,size),
				BackgroundTransparency = .55
			},Enum.EasingStyle.Sine)

			task.wait(.7)
		end
	end)

	return h,v
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
-- GLOWS DE FUNDO
--==================================================

local function GlowCircle(pos,size)
	local g = New("Frame",{
		AnchorPoint = Vector2.new(.5,.5),
		Position = pos,
		Size = UDim2.fromOffset(size,size),

		BackgroundColor3 = PURPLE,
		BackgroundTransparency = .94,

		BorderSizePixel = 0,
		ZIndex = 1
	},Overlay)

	Corner(g,true)

	local s = New("UIStroke",{
		Thickness = 2,
		Color = PURPLE,
		Transparency = .78
	},g)

	task.spawn(function()
		while g.Parent do
			Tween(g,2.2,{
				Size = UDim2.fromOffset(size*1.18,size*1.18)
			},Enum.EasingStyle.Sine)

			Tween(s,2.2,{
				Transparency = .92
			},Enum.EasingStyle.Sine)

			task.wait(2.2)

			Tween(g,2.2,{
				Size = UDim2.fromOffset(size,size)
			},Enum.EasingStyle.Sine)

			Tween(s,2.2,{
				Transparency = .78
			},Enum.EasingStyle.Sine)

			task.wait(2.2)
		end
	end)

	return g
end

GlowCircle(UDim2.fromScale(.24,.30),220)
GlowCircle(UDim2.fromScale(.78,.70),270)
GlowCircle(UDim2.fromScale(.83,.23),120)

--==================================================
-- SHADOW
--==================================================

local Shadow = New("Frame",{
	AnchorPoint = Vector2.new(.5,.5),
	Position = UDim2.new(.5,0,.5,12),
	Size = UDim2.fromOffset(718,388),

	BackgroundColor3 = Color3.new(),
	BackgroundTransparency = .52,

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

	BackgroundColor3 = Color3.fromRGB(35,35,42),
	BorderSizePixel = 0,

	ZIndex = 3
},Overlay)

Corner(Card,25)

Gradient(Card,{
	Color3.fromRGB(58,58,67),
	Color3.fromRGB(42,42,50),
	Color3.fromRGB(29,29,35),
	Color3.fromRGB(18,18,23)
},135)

local CardStroke = Stroke(Card,4,.02)

-- pulso da borda
task.spawn(function()
	while Card.Parent do
		Tween(CardStroke,1.5,{
			Transparency = .18
		},Enum.EasingStyle.Sine)

		task.wait(1.5)

		Tween(CardStroke,1.5,{
			Transparency = .02
		},Enum.EasingStyle.Sine)

		task.wait(1.5)
	end
end)

--==================================================
-- RESPONSIVE
--==================================================

local Scale = New("UIScale",{Scale = 1},Card)
local ShadowScale = New("UIScale",{Scale = 1},Shadow)

local function Resize()
	local cam = workspace.CurrentCamera
	if not cam then return end

	local s = cam.ViewportSize

	local value = math.max(.45,math.min(
		(s.X-30)/700,
		(s.Y-30)/370,
		1
	))

	Scale.Scale = value
	ShadowScale.Scale = value
end

Resize()

local Cam = workspace.CurrentCamera
local ResizeConnection = Cam:GetPropertyChangedSignal("ViewportSize"):Connect(Resize)

--==================================================
-- AVATAR
--==================================================

local AvatarHolder = New("Frame",{
	Position = UDim2.fromOffset(48,37),
	Size = UDim2.fromOffset(145,145),

	BackgroundColor3 = Color3.fromRGB(22,22,28),
	BorderSizePixel = 0,

	ClipsDescendants = true,
	ZIndex = 7
},Card)

Corner(AvatarHolder,true)

local Avatar = New("ImageLabel",{
	Position = UDim2.fromScale(0,0),
	Size = UDim2.fromScale(1,1),

	BackgroundTransparency = 1,

	Image = "",
	ScaleType = Enum.ScaleType.Crop,

	ClipsDescendants = true,
	ZIndex = 8
},AvatarHolder)

-- IMPORTANTE:
-- também arredonda o próprio ImageLabel
-- isso impede o avatar de vazar
Corner(Avatar,true)

local Fallback = New("TextLabel",{
	Size = UDim2.fromScale(1,1),
	BackgroundTransparency = 1,

	Text = Player.Name:sub(1,1):upper(),

	TextColor3 = LIGHT,
	Font = Enum.Font.GothamBold,
	TextSize = 50,

	ZIndex = 7
},AvatarHolder)

local AvatarRing = Stroke(AvatarHolder,4,0)

--==================================================
-- RAIOS ATRÁS DO AVATAR
--==================================================

local Rays = New("Frame",{
	AnchorPoint = Vector2.new(.5,.5),
	Position = UDim2.fromOffset(120,109),
	Size = UDim2.fromOffset(180,180),

	BackgroundTransparency = 1,
	ZIndex = 5
},Card)

for i = 1,12 do
	local angle = (i-1)*30

	local ray = New("Frame",{
		AnchorPoint = Vector2.new(.5,1),
		Position = UDim2.fromScale(.5,.5),
		Size = UDim2.fromOffset(2,87),

		BackgroundColor3 = PURPLE,
		BackgroundTransparency = .78,

		BorderSizePixel = 0,
		Rotation = angle,

		ZIndex = 5
	},Rays)

	Corner(ray,true)
end

task.spawn(function()
	while Rays.Parent do
		Tween(Rays,8,{
			Rotation = Rays.Rotation + 360
		},Enum.EasingStyle.Linear)

		task.wait(8)
	end
end)

-- avatar pulse
task.spawn(function()
	while AvatarHolder.Parent do
		Tween(AvatarRing,1.3,{
			Transparency = .25
		},Enum.EasingStyle.Sine)

		task.wait(1.3)

		Tween(AvatarRing,1.3,{
			Transparency = 0
		},Enum.EasingStyle.Sine)

		task.wait(1.3)
	end
end)

--==================================================
-- AVATAR ROBLOX
--==================================================

task.spawn(function()

	for attempt = 1,5 do

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

		task.wait(.3*attempt)
	end
end)

--==================================================
-- TEXT HELPER
--==================================================

local function Text(pos,size,text,font,textSize,color,align)
	return New("TextLabel",{
		Position = pos,
		Size = size,

		BackgroundTransparency = 1,

		Text = text,
		TextColor3 = color,

		TextXAlignment = align or Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Center,

		Font = font,
		TextSize = textSize,

		ZIndex = 7
	},Card)
end

--==================================================
-- HEADER
--==================================================

Text(
	UDim2.fromOffset(220,52),
	UDim2.fromOffset(430,48),

	Greeting..",",

	Enum.Font.GothamBold,
	32,

	Color3.fromRGB(245,245,250),
	Enum.TextXAlignment.Left
)

local Username = Text(
	UDim2.fromOffset(220,96),
	UDim2.fromOffset(430,40),

	Player.Name.."!",

	Enum.Font.GothamBold,
	29,

	LIGHT,
	Enum.TextXAlignment.Left
)

Username.TextTruncate = Enum.TextTruncate.AtEnd

Text(
	UDim2.fromOffset(220,140),
	UDim2.fromOffset(430,30),

	"Bem-vindo(a) ao meu script!",

	Enum.Font.Gotham,
	18,

	Color3.fromRGB(205,205,215),
	Enum.TextXAlignment.Left
)

--==================================================
-- DIVIDER
--==================================================

local Divider = New("Frame",{
	Position = UDim2.fromOffset(35,200),
	Size = UDim2.new(1,-70,0,1),

	BackgroundColor3 = PURPLE,
	BackgroundTransparency = .55,

	BorderSizePixel = 0,
	ZIndex = 7
},Card)

-- brilho viajando no divisor
local DividerGlow = New("Frame",{
	AnchorPoint = Vector2.new(.5,.5),
	Position = UDim2.fromScale(0,.5),

	Size = UDim2.fromOffset(55,3),

	BackgroundColor3 = LIGHT,
	BackgroundTransparency = .15,

	BorderSizePixel = 0,
	ZIndex = 8
},Divider)

Corner(DividerGlow,true)

task.spawn(function()
	while Divider.Parent do
		DividerGlow.Position = UDim2.fromScale(0,.5)

		Tween(DividerGlow,2.3,{
			Position = UDim2.fromScale(1,.5)
		},Enum.EasingStyle.Linear)

		task.wait(2.5)
	end
end)

--==================================================
-- SPARKLES
--==================================================

Spark(Card,UDim2.fromOffset(638,48),16,8)
Spark(Card,UDim2.fromOffset(664,182),10,8)
Spark(Card,UDim2.fromOffset(43,242),9,8)
Spark(Card,UDim2.fromOffset(650,320),12,8)

--==================================================
-- LOADING
--==================================================

local Loading = Text(
	UDim2.fromOffset(0,215),
	UDim2.new(1,0,0,30),

	"Carregando...",

	Enum.Font.GothamMedium,
	18,
	LIGHT
)

local Bar = New("Frame",{
	Position = UDim2.fromOffset(70,257),
	Size = UDim2.fromOffset(500,30),

	BackgroundColor3 = Color3.fromRGB(17,17,22),
	BorderSizePixel = 0,

	ClipsDescendants = true,
	ZIndex = 7
},Card)

Corner(Bar,true)

New("UIStroke",{
	Thickness = 1.5,
	Transparency = .25,
	Color = Color3.fromRGB(125,75,185)
},Bar)

local Fill = New("Frame",{
	Size = UDim2.fromScale(0,1),

	BackgroundColor3 = PURPLE,
	BorderSizePixel = 0,

	ZIndex = 8
},Bar)

Corner(Fill,true)

local FillGradient = Gradient(Fill,{
	Color3.fromRGB(90,40,255),
	Color3.fromRGB(150,65,255),
	Color3.fromRGB(235,115,255)
})

-- shimmer da barra
task.spawn(function()
	while Fill.Parent do
		FillGradient.Offset = Vector2.new(-1,0)

		Tween(FillGradient,1.4,{
			Offset = Vector2.new(1,0)
		},Enum.EasingStyle.Linear)

		task.wait(1.5)
	end
end)

local Percent = Text(
	UDim2.fromOffset(588,257),
	UDim2.fromOffset(75,30),

	"0%",

	Enum.Font.GothamMedium,
	19,

	LIGHT,
	Enum.TextXAlignment.Left
)

--==================================================
-- THANKS SEM ÍCONE BUGADO
--==================================================

Spark(
	Card,
	UDim2.fromOffset(211,330),
	13,
	8
)

Text(
	UDim2.fromOffset(225,315),
	UDim2.fromOffset(330,30),

	"Obrigado por utilizar o meu script!",

	Enum.Font.Gotham,
	18,

	Color3.fromRGB(215,215,222),
	Enum.TextXAlignment.Left
)

--==================================================
-- ENTRADA
--==================================================

Card.Position = UDim2.fromScale(.5,.56)
Shadow.Position = UDim2.new(.5,0,.56,12)

Tween(Overlay,.45,{
	BackgroundTransparency = .62
})

Tween(Blur,.45,{
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
	{Size = UDim2.fromScale(1,1)},
	Enum.EasingStyle.Linear
)

local Start = os.clock()
local Last = -1

while Gui.Parent do

	local Progress = math.clamp(
		(os.clock()-Start)/LOAD_TIME,
		0,
		1
	)

	local Value = math.floor(Progress*100)

	if Value ~= Last then
		Last = Value
		Percent.Text = Value.."%"
	end

	if Progress >= 1 then
		break
	end

	task.wait(.08)
end

if not Gui.Parent then return end

Fill.Size = UDim2.fromScale(1,1)
Percent.Text = "100%"
Loading.Text = "Carregado!"

Tween(CardStroke,.25,{
	Transparency = 0
})

task.wait(1.1)

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
