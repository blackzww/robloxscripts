local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local P = Players.LocalPlayer
local PG = P:WaitForChild("PlayerGui")

--==================================================
-- CONFIG
--==================================================

local C = {
	W = 633,
	H = 368,

	LoadTime = 15,
	FadeIn = 1.35,
	FadeOut = 1.05,

	Purple = Color3.fromRGB(145,70,255),
	Light = Color3.fromRGB(215,110,255),

	Blur = 12
}

local STAR = utf8.char(0x2726) -- ✦

--==================================================
-- CLEAN
--==================================================

for _,v in ipairs({
	PG:FindFirstChild("MirrorsWelcome"),
	Lighting:FindFirstChild("MirrorsWelcomeBlur")
}) do
	if v then v:Destroy() end
end

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

local function Round(o,r)
	return New("UICorner",{
		CornerRadius = r == true and UDim.new(1,0) or UDim.new(0,r)
	},o)
end

local function Tween(o,t,p,style,dir,repeatCount)
	local x = TweenService:Create(o,TweenInfo.new(
		t,
		style or Enum.EasingStyle.Quart,
		dir or Enum.EasingDirection.Out,
		repeatCount or 0
	),p)

	x:Play()
	return x
end

local function Gradient(o,colors,rot)
	local k = {}

	for i,c in ipairs(colors) do
		k[i] = ColorSequenceKeypoint.new(
			(i-1)/(#colors-1),c
		)
	end

	return New("UIGradient",{
		Color = ColorSequence.new(k),
		Rotation = rot or 0
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
},PG)

local Overlay = New("Frame",{
	Size = UDim2.fromScale(1,1),
	BackgroundColor3 = Color3.new(),
	BackgroundTransparency = 1,
	BorderSizePixel = 0
},Gui)

--==================================================
-- CONTAINER
--==================================================

local Container = New("Frame",{
	AnchorPoint = Vector2.new(.5,.5),
	Position = UDim2.fromScale(.5,.5),
	Size = UDim2.fromOffset(C.W,C.H),
	BackgroundTransparency = 1
},Overlay)

local Scale = New("UIScale",{Scale=1},Container)

local Camera = workspace.CurrentCamera

local function Resize()
	if not Camera then return end

	local s = Camera.ViewportSize

	Scale.Scale = math.max(.45,math.min(
		(s.X-26)/C.W,
		(s.Y-26)/C.H,
		1
	))
end

Resize()

local RC = Camera:GetPropertyChangedSignal("ViewportSize"):Connect(Resize)

--==================================================
-- GLOW EXTERNO
--==================================================

local Glow = New("Frame",{
	AnchorPoint = Vector2.new(.5,.5),
	Position = UDim2.fromScale(.5,.5),
	Size = UDim2.new(1,10,1,10),

	BackgroundTransparency = 1,
	ZIndex = 1
},Container)

Round(Glow,27)

local GlowStroke = New("UIStroke",{
	Thickness = 12,
	Color = C.Purple,
	Transparency = .78
},Glow)

-- glow respirando
local GlowTween = Tween(
	GlowStroke,
	2.1,
	{Transparency=.91},
	Enum.EasingStyle.Sine,
	Enum.EasingDirection.InOut,
	-1
)

GlowTween.Reverses = true

--==================================================
-- SHADOW
--==================================================

local Shadow = New("Frame",{
	AnchorPoint = Vector2.new(.5,.5),
	Position = UDim2.new(.5,0,.5,10),
	Size = UDim2.new(1,6,1,6),

	BackgroundColor3 = Color3.new(),
	BackgroundTransparency = .62,

	BorderSizePixel = 0,
	ZIndex = 2
},Container)

Round(Shadow,27)

--==================================================
-- CARD
--==================================================

local Card = New("Frame",{
	Size = UDim2.fromScale(1,1),

	BackgroundColor3 = Color3.fromRGB(33,33,40),
	BackgroundTransparency = .08,

	BorderSizePixel = 0,
	ClipsDescendants = true,

	ZIndex = 3
},Container)

Round(Card,24)

Gradient(Card,{
	Color3.fromRGB(57,57,66),
	Color3.fromRGB(42,42,49),
	Color3.fromRGB(27,27,33),
	Color3.fromRGB(17,17,22)
},135)

local CardStroke = New("UIStroke",{
	Thickness = 4,
	Color = C.Purple,
	Transparency = .04
},Card)

Gradient(CardStroke,{
	Color3.fromRGB(100,50,255),
	C.Light,
	Color3.fromRGB(115,55,255)
},30)

--==================================================
-- CÍRCULO DE BOLINHAS
--==================================================

local Ring = New("Frame",{
	AnchorPoint = Vector2.new(.5,.5),
	Position = UDim2.fromScale(.5,.5),

	Size = UDim2.fromOffset(35,35),

	BackgroundTransparency = 1,
	Rotation = 0,

	ZIndex = 4
},Card)

local Dots = {}

for i=1,36 do
	local a = math.rad((i-1)*(360/36))

	local dot = New("Frame",{
		AnchorPoint = Vector2.new(.5,.5),

		Position = UDim2.fromScale(
			.5 + math.cos(a)*.5,
			.5 + math.sin(a)*.5
		),

		Size = UDim2.fromOffset(4,4),

		BackgroundColor3 = Color3.new(1,1,1),
		BackgroundTransparency = .67,

		BorderSizePixel = 0,

		ZIndex = 4
	},Ring)

	Round(dot,true)
	table.insert(Dots,dot)
end

--==================================================
-- AVATAR GLOW
--==================================================

local AvatarGlow = New("Frame",{
	AnchorPoint = Vector2.new(.5,.5),

	Position = UDim2.fromOffset(104,102),

	Size = UDim2.fromOffset(136,136),

	BackgroundTransparency = 1,

	ZIndex = 5
},Card)

Round(AvatarGlow,true)

local AGStroke = New("UIStroke",{
	Thickness = 11,
	Color = C.Purple,
	Transparency = .76
},AvatarGlow)

local AGTween = Tween(
	AGStroke,
	1.8,
	{Transparency=.9},
	Enum.EasingStyle.Sine,
	Enum.EasingDirection.InOut,
	-1
)

AGTween.Reverses = true

--==================================================
-- AVATAR
--==================================================

local AvatarHolder = New("Frame",{
	Position = UDim2.fromOffset(43,41),
	Size = UDim2.fromOffset(122,122),

	BackgroundColor3 = Color3.fromRGB(20,20,25),
	BorderSizePixel = 0,

	ClipsDescendants = true,

	ZIndex = 7
},Card)

Round(AvatarHolder,true)

local AvatarStroke = New("UIStroke",{
	Thickness = 4,
	Color = C.Purple,
	Transparency = 0
},AvatarHolder)

Gradient(AvatarStroke,{
	Color3.fromRGB(100,50,255),
	C.Light,
	Color3.fromRGB(110,55,255)
},45)

local Fallback = New("TextLabel",{
	Size = UDim2.fromScale(1,1),

	BackgroundTransparency = 1,

	Text = P.Name:sub(1,1):upper(),

	TextColor3 = C.Light,

	Font = Enum.Font.GothamBold,
	TextSize = 45,

	ZIndex = 7
},AvatarHolder)

local Avatar = New("ImageLabel",{
	AnchorPoint = Vector2.new(.5,.5),
	Position = UDim2.fromScale(.5,.5),

	-- padding garante personagem TODO dentro do aro
	Size = UDim2.new(1,-12,1,-12),

	BackgroundTransparency = 1,

	Image = "",
	ScaleType = Enum.ScaleType.Fit,

	ZIndex = 8
},AvatarHolder)

Round(Avatar,true)

-- AvatarThumbnail = personagem INTEIRO
task.spawn(function()
	for i=1,5 do
		if not Gui.Parent then return end

		local ok,img,ready = pcall(function()
			return Players:GetUserThumbnailAsync(
				P.UserId,
				Enum.ThumbnailType.AvatarThumbnail,
				Enum.ThumbnailSize.Size420x420
			)
		end)

		if ok and ready and img ~= "" then
			Avatar.Image = img
			Fallback.Visible = false
			return
		end

		task.wait(.3*i)
	end
end)

--==================================================
-- TEXTO
--==================================================

local function Text(pos,size,value,font,textSize,color,align,z)
	return New("TextLabel",{
		Position = pos,
		Size = size,

		BackgroundTransparency = 1,

		Text = value,
		TextColor3 = color,

		TextXAlignment = align or Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Center,

		Font = font,
		TextSize = textSize,

		ZIndex = z or 7
	},Card)
end

Text(
	UDim2.fromOffset(187,45),
	UDim2.fromOffset(400,40),

	Greeting..",",

	Enum.Font.GothamBold,
	29,

	Color3.fromRGB(245,245,250),
	Enum.TextXAlignment.Left
)

local User = Text(
	UDim2.fromOffset(187,84),
	UDim2.fromOffset(400,36),

	P.Name.."!",

	Enum.Font.GothamBold,
	27,

	C.Light,
	Enum.TextXAlignment.Left
)

User.TextTruncate = Enum.TextTruncate.AtEnd

Text(
	UDim2.fromOffset(187,122),
	UDim2.fromOffset(400,27),

	"Bem-vindo(a) ao meu script!",

	Enum.Font.Gotham,
	17,

	Color3.fromRGB(200,200,210),
	Enum.TextXAlignment.Left
)

--==================================================
-- SEGUNDA ESTRELA
--==================================================

local function Star(parent,pos,size,z)
	local s = New("TextLabel",{
		AnchorPoint = Vector2.new(.5,.5),
		Position = pos,
		Size = UDim2.fromOffset(size,size),

		BackgroundTransparency = 1,

		Text = STAR,

		TextColor3 = C.Light,

		Font = Enum.Font.ArialBold,
		TextSize = size,

		ZIndex = z or 8
	},parent)

	Tween(
		s,
		9,
		{Rotation=360},
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.Out,
		-1
	)

	return s
end

Star(
	Card,
	UDim2.new(1,-34,0,30),
	18,
	8
)

--==================================================
-- DIVIDER
--==================================================

New("Frame",{
	Position = UDim2.fromOffset(31,180),
	Size = UDim2.new(1,-62,0,1),

	BackgroundColor3 = C.Purple,
	BackgroundTransparency = .58,

	BorderSizePixel = 0,

	ZIndex = 7
},Card)

--==================================================
-- LOADING
--==================================================

local Loading = Text(
	UDim2.fromOffset(0,194),
	UDim2.new(1,0,0,28),

	"Carregando...",

	Enum.Font.GothamMedium,
	17,

	C.Light
)

local Bar = New("Frame",{
	Position = UDim2.fromOffset(53,233),
	Size = UDim2.fromOffset(455,29),

	BackgroundColor3 = Color3.fromRGB(15,15,20),
	BorderSizePixel = 0,

	ClipsDescendants = true,

	ZIndex = 7
},Card)

Round(Bar,true)

New("UIStroke",{
	Thickness = 1.5,
	Color = Color3.fromRGB(125,75,185),
	Transparency = .28
},Bar)

local Fill = New("Frame",{
	Size = UDim2.fromScale(0,1),

	BackgroundColor3 = C.Purple,
	BorderSizePixel = 0,

	ClipsDescendants = true,

	ZIndex = 8
},Bar)

Round(Fill,true)

Gradient(Fill,{
	Color3.fromRGB(90,40,255),
	Color3.fromRGB(150,65,255),
	Color3.fromRGB(230,110,255)
})

--==================================================
-- SHIMMER CLEAN
--==================================================

local Shimmer = New("Frame",{
	AnchorPoint = Vector2.new(.5,.5),

	Position = UDim2.new(-.2,0,.5,0),

	Size = UDim2.fromOffset(45,50),

	BackgroundColor3 = Color3.new(1,1,1),
	BackgroundTransparency = .78,

	BorderSizePixel = 0,
	Rotation = 18,

	ZIndex = 9
},Fill)

local ShimmerTween = Tween(
	Shimmer,
	1.7,
	{Position=UDim2.new(1.2,0,.5,0)},
	Enum.EasingStyle.Linear,
	Enum.EasingDirection.Out,
	-1
)

local Percent = Text(
	UDim2.fromOffset(523,233),
	UDim2.fromOffset(70,29),

	"0%",

	Enum.Font.GothamMedium,
	18,

	C.Light,
	Enum.TextXAlignment.Left
)

--==================================================
-- MESSAGE BOX
--==================================================

local MessageBox = New("Frame",{
	Position = UDim2.fromOffset(74,294),
	Size = UDim2.fromOffset(485,43),

	BackgroundColor3 = Color3.fromRGB(26,26,32),
	BackgroundTransparency = .23,

	BorderSizePixel = 0,

	ZIndex = 7
},Card)

Round(MessageBox,12)

Gradient(MessageBox,{
	Color3.fromRGB(52,52,60),
	Color3.fromRGB(31,31,38),
	Color3.fromRGB(20,20,25)
},115)

New("UIStroke",{
	Thickness = 1,
	Color = C.Purple,
	Transparency = .72
},MessageBox)

local MessageStar = Star(
	MessageBox,
	UDim2.fromOffset(27,21),
	17,
	9
)

local Message = New("TextLabel",{
	Position = UDim2.fromOffset(49,0),
	Size = UDim2.new(1,-60,1,0),

	BackgroundTransparency = 1,

	Text = "Obrigado por utilizar o meu script!",
	TextColor3 = Color3.fromRGB(215,215,223),

	TextXAlignment = Enum.TextXAlignment.Left,

	Font = Enum.Font.Gotham,
	TextSize = 16,

	ZIndex = 8
},MessageBox)

local Messages = {
	"Obrigado por utilizar o meu script!",
	"Preparando a interface...",
	"Carregando recursos...",
	"Finalizando tudo..."
}

--==================================================
-- FADE SYSTEM
--==================================================

local FadeItems = {}

local function AddFade(o,prop)
	local ok,v = pcall(function() return o[prop] end)

	if ok then
		table.insert(FadeItems,{o,prop,v})
		o[prop] = 1
	end
end

AddFade(Card,"BackgroundTransparency")

for _,o in ipairs(Card:GetDescendants()) do
	if o:IsA("GuiObject") then
		AddFade(o,"BackgroundTransparency")
	end

	if o:IsA("TextLabel") then
		AddFade(o,"TextTransparency")
	elseif o:IsA("ImageLabel") then
		AddFade(o,"ImageTransparency")
	elseif o:IsA("UIStroke") then
		AddFade(o,"Transparency")
	end
end

local function FadeIn()
	for _,v in ipairs(FadeItems) do
		if v[1].Parent then
			Tween(v[1],C.FadeIn,{[v[2]]=v[3]})
		end
	end
end

local function FadeOut()
	for _,v in ipairs(FadeItems) do
		if v[1].Parent then
			Tween(v[1],C.FadeOut,{[v[2]]=1})
		end
	end
end

--==================================================
-- ENTRADA
--==================================================

Tween(Overlay,C.FadeIn,{
	BackgroundTransparency=.62
})

Tween(Blur,C.FadeIn,{
	Size=C.Blur
})

FadeIn()

-- NÃO inicia loading antes do fade terminar
task.wait(C.FadeIn+.05)

--==================================================
-- CÍRCULO DE BOLINHAS — UMA VEZ
--==================================================

Tween(
	Ring,
	6.2,
	{
		Size = UDim2.fromOffset(760,760),
		Rotation = 65
	},
	Enum.EasingStyle.Sine,
	Enum.EasingDirection.Out
)

task.delay(5,function()
	for _,dot in ipairs(Dots) do
		if dot.Parent then
			Tween(dot,1.2,{
				BackgroundTransparency=1
			})
		end
	end
end)

--==================================================
-- MENSAGENS
--==================================================

local Running = true

task.spawn(function()
	local i = 1

	while Running and Gui.Parent do
		Message.Text = Messages[i]
		Message.TextTransparency = 1
		MessageBox.BackgroundTransparency = .42

		Tween(Message,.45,{
			TextTransparency=0
		})

		Tween(MessageBox,.45,{
			BackgroundTransparency=.23
		})

		task.wait(2.25)

		if not Running then break end

		Tween(Message,.4,{
			TextTransparency=1
		})

		Tween(MessageBox,.4,{
			BackgroundTransparency=.4
		})

		task.wait(.45)

		i = i % #Messages + 1
	end
end)

--==================================================
-- LOADING
--==================================================

Tween(
	Fill,
	C.LoadTime,
	{Size=UDim2.fromScale(1,1)},
	Enum.EasingStyle.Linear
)

local Started = os.clock()
local Last = -1

while Gui.Parent do
	local p = math.clamp(
		(os.clock()-Started)/C.LoadTime,
		0,
		1
	)

	local n = math.floor(p*100)

	if n ~= Last then
		Last = n
		Percent.Text = n.."%"
	end

	if p >= 1 then break end

	task.wait(.1)
end

if not Gui.Parent then return end

Running = false

Fill.Size = UDim2.fromScale(1,1)
Percent.Text = "100%"
Loading.Text = "Carregado!"

Tween(Message,.3,{TextTransparency=1})

task.wait(.3)

Message.Text = "Tudo pronto. Aproveite!"
Tween(Message,.4,{TextTransparency=0})

task.wait(1)

--==================================================
-- FADE OUT
--==================================================

GlowTween:Cancel()
AGTween:Cancel()
ShimmerTween:Cancel()

FadeOut()

Tween(Overlay,C.FadeOut,{
	BackgroundTransparency=1
})

Tween(Blur,C.FadeOut,{
	Size=0
})

task.wait(C.FadeOut+.08)

--==================================================
-- CLEANUP
--==================================================

RC:Disconnect()

if Blur.Parent then Blur:Destroy() end
if Gui.Parent then Gui:Destroy() end
