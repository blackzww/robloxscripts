local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local P = Players.LocalPlayer
local PG = P:WaitForChild("PlayerGui")

--==================================================
-- CONFIG
--==================================================

local W,H = 633,368
local LOAD_TIME = 15
local FADE_IN = 1.3
local FADE_OUT = 1

local PURPLE = Color3.fromRGB(145,70,255)
local LIGHT = Color3.fromRGB(215,110,255)
local STAR = utf8.char(0x2726) -- ✦

--==================================================
-- CLEAN
--==================================================

for _,o in ipairs({
	PG:FindFirstChild("MirrorsWelcome"),
	Lighting:FindFirstChild("MirrorsWelcomeBlur")
}) do
	if o then o:Destroy() end
end

--==================================================
-- HELPERS
--==================================================

local function New(c,p,parent)
	local o = Instance.new(c)

	for k,v in pairs(p or {}) do
		pcall(function()
			o[k] = v
		end)
	end

	o.Parent = parent
	return o
end

local function Round(o,r)
	return New("UICorner",{
		CornerRadius = r == true
			and UDim.new(1,0)
			or UDim.new(0,r)
	},o)
end

local function Tw(o,t,p,style,dir,repeatCount,reverses)
	local x = TweenService:Create(
		o,
		TweenInfo.new(
			t,
			style or Enum.EasingStyle.Quart,
			dir or Enum.EasingDirection.Out,
			repeatCount or 0,
			reverses or false
		),
		p
	)

	x:Play()
	return x
end

local function Grad(o,colors,rot)
	local k = {}

	for i,c in ipairs(colors) do
		k[i] = ColorSequenceKeypoint.new(
			(i-1)/(#colors-1),
			c
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
-- ROOT
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

local Container = New("Frame",{
	AnchorPoint = Vector2.new(.5,.5),
	Position = UDim2.fromScale(.5,.5),
	Size = UDim2.fromOffset(W,H),
	BackgroundTransparency = 1
},Overlay)

--==================================================
-- RESPONSIVE
--==================================================

local Scale = New("UIScale",{Scale=1},Container)
local Camera = workspace.CurrentCamera

local function Resize()
	if not Camera then return end

	local v = Camera.ViewportSize

	Scale.Scale = math.max(.4,math.min(
		(v.X-30)/W,
		(v.Y-30)/H,
		1
	))
end

Resize()

local RC = Camera:GetPropertyChangedSignal("ViewportSize"):Connect(Resize)

--==================================================
-- SHADOW
--==================================================

local Shadow = New("Frame",{
	AnchorPoint = Vector2.new(.5,.5),
	Position = UDim2.new(.5,0,.5,10),
	Size = UDim2.new(1,8,1,8),

	BackgroundColor3 = Color3.new(),
	BackgroundTransparency = .65,

	BorderSizePixel = 0,
	ZIndex = 1
},Container)

Round(Shadow,28)

--==================================================
-- GLOW EXTERNO
--==================================================

local Glow = New("Frame",{
	AnchorPoint = Vector2.new(.5,.5),
	Position = UDim2.fromScale(.5,.5),
	Size = UDim2.new(1,7,1,7),

	BackgroundTransparency = 1,
	ZIndex = 2
},Container)

Round(Glow,27)

local GlowStroke = New("UIStroke",{
	Thickness = 11,
	Color = PURPLE,
	Transparency = .82
},Glow)

-- PULSO CORRETO
Tw(
	GlowStroke,
	2.2,
	{Transparency=.94},
	Enum.EasingStyle.Sine,
	Enum.EasingDirection.InOut,
	-1,
	true
)

--==================================================
-- CARD
--==================================================

local Card = New("Frame",{
	Size = UDim2.fromScale(1,1),

	BackgroundColor3 = Color3.fromRGB(32,32,39),
	BackgroundTransparency = .07,

	BorderSizePixel = 0,
	ClipsDescendants = true,

	ZIndex = 3
},Container)

Round(Card,24)

Grad(Card,{
	Color3.fromRGB(56,56,65),
	Color3.fromRGB(40,40,47),
	Color3.fromRGB(27,27,33),
	Color3.fromRGB(17,17,22)
},135)

local Border = New("UIStroke",{
	Thickness = 4,
	Color = PURPLE,
	Transparency = .04
},Card)

Grad(Border,{
	Color3.fromRGB(100,50,255),
	LIGHT,
	Color3.fromRGB(110,55,255)
},35)

--==================================================
-- CÍRCULO DE BOLINHAS
--==================================================

local Ring = New("Frame",{
	AnchorPoint = Vector2.new(.5,.5),
	Position = UDim2.fromScale(.5,.5),

	Size = UDim2.fromOffset(30,30),

	BackgroundTransparency = 1,
	ZIndex = 4
},Card)

local Dots = {}

for i=1,40 do
	local a = math.rad((i-1)*9)

	local Dot = New("Frame",{
		AnchorPoint = Vector2.new(.5,.5),

		Position = UDim2.fromScale(
			.5 + math.cos(a)*.5,
			.5 + math.sin(a)*.5
		),

		Size = UDim2.fromOffset(4,4),

		BackgroundColor3 = Color3.new(1,1,1),
		BackgroundTransparency = .68,

		BorderSizePixel = 0,
		ZIndex = 4
	},Ring)

	Round(Dot,true)

	Dots[#Dots+1] = Dot
end

--==================================================
-- AVATAR GLOW
--==================================================

local AG = New("Frame",{
	AnchorPoint = Vector2.new(.5,.5),

	Position = UDim2.fromOffset(104,102),

	Size = UDim2.fromOffset(137,137),

	BackgroundTransparency = 1,

	ZIndex = 5
},Card)

Round(AG,true)

local AGStroke = New("UIStroke",{
	Thickness = 10,
	Color = PURPLE,
	Transparency = .78
},AG)

Tw(
	AGStroke,
	1.8,
	{Transparency=.92},
	Enum.EasingStyle.Sine,
	Enum.EasingDirection.InOut,
	-1,
	true
)

--==================================================
-- AVATAR
--==================================================

local AH = New("Frame",{
	Position = UDim2.fromOffset(43,41),
	Size = UDim2.fromOffset(122,122),

	BackgroundColor3 = Color3.fromRGB(20,20,25),
	BorderSizePixel = 0,

	ClipsDescendants = true,
	ZIndex = 7
},Card)

Round(AH,true)

local AS = New("UIStroke",{
	Thickness = 4,
	Color = PURPLE
},AH)

Grad(AS,{
	Color3.fromRGB(100,50,255),
	LIGHT,
	Color3.fromRGB(110,55,255)
},45)

local Fallback = New("TextLabel",{
	Size = UDim2.fromScale(1,1),
	BackgroundTransparency = 1,

	Text = P.Name:sub(1,1):upper(),

	TextColor3 = LIGHT,

	Font = Enum.Font.GothamBold,
	TextSize = 44,

	ZIndex = 7
},AH)

local Avatar = New("ImageLabel",{
	AnchorPoint = Vector2.new(.5,.5),
	Position = UDim2.fromScale(.5,.5),

	Size = UDim2.new(1,-12,1,-12),

	BackgroundTransparency = 1,

	Image = "",

	-- personagem inteiro
	ScaleType = Enum.ScaleType.Fit,

	ZIndex = 8
},AH)

-- personagem TODO dentro do aro
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

		task.wait(.25*i)
	end
end)

--==================================================
-- TEXT
--==================================================

local function Text(pos,size,value,font,textSize,color,align,parent)
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

		ZIndex = 7
	},parent or Card)
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

local Username = Text(
	UDim2.fromOffset(187,84),
	UDim2.fromOffset(400,36),

	P.Name.."!",

	Enum.Font.GothamBold,
	27,

	LIGHT,
	Enum.TextXAlignment.Left
)

Username.TextTruncate = Enum.TextTruncate.AtEnd

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
-- ESTRELAS ✦
--==================================================

local function Star(parent,pos,size)
	local s = New("TextLabel",{
		AnchorPoint = Vector2.new(.5,.5),
		Position = pos,
		Size = UDim2.fromOffset(size,size),

		BackgroundTransparency = 1,

		Text = STAR,

		TextColor3 = LIGHT,

		Font = Enum.Font.ArialBold,
		TextSize = size,

		ZIndex = 9
	},parent)

	Tw(
		s,
		10,
		{Rotation=360},
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.Out,
		-1
	)

	return s
end

Star(
	Card,
	UDim2.new(1,-31,0,28),
	17
)

--==================================================
-- DIVIDER
--==================================================

New("Frame",{
	Position = UDim2.fromOffset(31,180),
	Size = UDim2.new(1,-62,0,1),

	BackgroundColor3 = PURPLE,
	BackgroundTransparency = .6,

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

	LIGHT
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

	BackgroundColor3 = PURPLE,
	BorderSizePixel = 0,

	ClipsDescendants = true,
	ZIndex = 8
},Bar)

Round(Fill,true)

Grad(Fill,{
	Color3.fromRGB(90,40,255),
	Color3.fromRGB(150,65,255),
	Color3.fromRGB(230,110,255)
})

--==================================================
-- SHIMMER
--==================================================

local Shimmer = New("Frame",{
	AnchorPoint = Vector2.new(.5,.5),

	Position = UDim2.new(-.2,0,.5,0),
	Size = UDim2.fromOffset(45,50),

	BackgroundColor3 = Color3.new(1,1,1),
	BackgroundTransparency = .79,

	BorderSizePixel = 0,
	Rotation = 18,

	ZIndex = 9
},Fill)

Tw(
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

	LIGHT,
	Enum.TextXAlignment.Left
)

--==================================================
-- MESSAGE BOX
--==================================================

local Box = New("Frame",{
	Position = UDim2.fromOffset(74,294),
	Size = UDim2.fromOffset(485,43),

	BackgroundColor3 = Color3.fromRGB(27,27,33),
	BackgroundTransparency = .22,

	BorderSizePixel = 0,
	ZIndex = 7
},Card)

Round(Box,12)

Grad(Box,{
	Color3.fromRGB(49,49,57),
	Color3.fromRGB(31,31,38),
	Color3.fromRGB(21,21,26)
},115)

New("UIStroke",{
	Thickness = 1,
	Color = PURPLE,
	Transparency = .7
},Box)

Star(
	Box,
	UDim2.fromOffset(25,21),
	16
)

local Message = Text(
	UDim2.fromOffset(47,0),
	UDim2.new(1,-58,1,0),

	"Obrigado por utilizar o meu script!",

	Enum.Font.Gotham,
	16,

	Color3.fromRGB(215,215,223),
	Enum.TextXAlignment.Left,

	Box
)

local Messages = {
	"Obrigado por utilizar o meu script!",
	"Preparando a interface...",
	"Carregando recursos...",
	"Quase tudo pronto..."
}

--==================================================
-- FADE
--==================================================

local Fade = {}

local function Save(o,prop)
	local ok,v = pcall(function()
		return o[prop]
	end)

	if ok then
		Fade[#Fade+1] = {o,prop,v}
		o[prop] = 1
	end
end

Save(Card,"BackgroundTransparency")

for _,o in ipairs(Card:GetDescendants()) do

	if o:IsA("GuiObject") then
		Save(o,"BackgroundTransparency")
	end

	if o:IsA("TextLabel") then
		Save(o,"TextTransparency")
	elseif o:IsA("ImageLabel") then
		Save(o,"ImageTransparency")
	elseif o:IsA("UIStroke") then
		Save(o,"Transparency")
	end
end

local function FadeTo(original)
	for _,v in ipairs(Fade) do
		if v[1].Parent then

			Tw(
				v[1],
				original and FADE_IN or FADE_OUT,
				{
					[v[2]] =
						original
						and v[3]
						or 1
				},
				Enum.EasingStyle.Sine
			)

		end
	end
end

--==================================================
-- FADE IN
--==================================================

Tw(Overlay,FADE_IN,{
	BackgroundTransparency=.62
},Enum.EasingStyle.Sine)

Tw(Blur,FADE_IN,{
	Size=12
},Enum.EasingStyle.Sine)

FadeTo(true)

-- loading só começa DEPOIS
task.wait(FADE_IN+.05)

--==================================================
-- CÍRCULO DE BOLINHAS
--==================================================

Tw(
	Ring,
	6,
	{
		Size=UDim2.fromOffset(760,760),
		Rotation=50
	},
	Enum.EasingStyle.Sine
)

task.delay(4.8,function()

	for _,dot in ipairs(Dots) do
		if dot.Parent then

			Tw(
				dot,
				1.2,
				{BackgroundTransparency=1},
				Enum.EasingStyle.Sine
			)

		end
	end

end)

--==================================================
-- MENSAGENS
--==================================================

local Running = true

task.spawn(function()

	local index = 1

	while Running and Gui.Parent do

		Message.Text = Messages[index]
		Message.TextTransparency = 1

		Tw(Message,.45,{
			TextTransparency=0
		})

		task.wait(2.2)

		if not Running then break end

		Tw(Message,.4,{
			TextTransparency=1
		})

		task.wait(.45)

		index = index % #Messages + 1

	end

end)

--==================================================
-- LOADING 0 -> 100
--==================================================

Tw(
	Fill,
	LOAD_TIME,
	{Size=UDim2.fromScale(1,1)},
	Enum.EasingStyle.Linear
)

local Start = os.clock()
local Last = -1

while Gui.Parent do

	local progress = math.clamp(
		(os.clock()-Start)/LOAD_TIME,
		0,
		1
	)

	local value = math.floor(progress*100)

	if value ~= Last then
		Last = value
		Percent.Text = value.."%"
	end

	if progress >= 1 then
		break
	end

	task.wait(.1)
end

if not Gui.Parent then return end

Running = false

Fill.Size = UDim2.fromScale(1,1)
Percent.Text = "100%"
Loading.Text = "Carregado!"

Tw(Message,.25,{TextTransparency=1})
task.wait(.25)

Message.Text = "Tudo pronto. Aproveite!"

Tw(Message,.4,{TextTransparency=0})

task.wait(1)

--==================================================
-- FADE OUT
--==================================================

FadeTo(false)

Tw(Overlay,FADE_OUT,{
	BackgroundTransparency=1
},Enum.EasingStyle.Sine)

Tw(Blur,FADE_OUT,{
	Size=0
},Enum.EasingStyle.Sine)

task.wait(FADE_OUT+.1)

--==================================================
-- CLEANUP
--==================================================

RC:Disconnect()

if Blur.Parent then
	Blur:Destroy()
end

if Gui.Parent then
	Gui:Destroy()
end
