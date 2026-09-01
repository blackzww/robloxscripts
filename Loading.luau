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
	FadeIn = 1.25,
	FadeOut = 1.0,

	Purple = Color3.fromRGB(145, 70, 255),
	Purple2 = Color3.fromRGB(210, 100, 255),

	Text = Color3.fromRGB(246, 246, 250),
	SubText = Color3.fromRGB(205, 205, 215),

	Blur = 10
}

--==================================================
-- CLEAN
--==================================================

local Old = PG:FindFirstChild("MirrorsWelcome")
if Old then Old:Destroy() end

local OldBlur = Lighting:FindFirstChild("MirrorsWelcomeBlur")
if OldBlur then OldBlur:Destroy() end

--==================================================
-- HELPERS
--==================================================

local function New(class, props, parent)
	local o = Instance.new(class)

	for k, v in pairs(props or {}) do
		pcall(function()
			o[k] = v
		end)
	end

	o.Parent = parent
	return o
end

local function Round(o, radius)
	return New("UICorner", {
		CornerRadius = radius == true
			and UDim.new(1, 0)
			or UDim.new(0, radius)
	}, o)
end

local function Tw(o, time, props, style, dir, count, reverse)
	local t = TweenService:Create(
		o,
		TweenInfo.new(
			time,
			style or Enum.EasingStyle.Quart,
			dir or Enum.EasingDirection.Out,
			count or 0,
			reverse or false
		),
		props
	)

	t:Play()
	return t
end

local function Grad(o, colors, rotation)
	local points = {}

	for i, color in ipairs(colors) do
		points[i] = ColorSequenceKeypoint.new(
			(i - 1) / (#colors - 1),
			color
		)
	end

	return New("UIGradient", {
		Color = ColorSequence.new(points),
		Rotation = rotation or 0
	}, o)
end

local function Text(parent, pos, size, value, font, textSize, color, align, z)
	return New("TextLabel", {
		Position = pos,
		Size = size,

		BackgroundTransparency = 1,

		Text = value,
		TextColor3 = color,

		TextXAlignment = align or Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Center,

		Font = font,
		TextSize = textSize,

		AutoLocalize = false,

		ZIndex = z or 10
	}, parent)
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

local Blur = New("BlurEffect", {
	Name = "MirrorsWelcomeBlur",
	Size = 0
}, Lighting)

local Gui = New("ScreenGui", {
	Name = "MirrorsWelcome",

	IgnoreGuiInset = true,
	ResetOnSpawn = false,

	DisplayOrder = 999999,

	ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, PG)

local Overlay = New("Frame", {
	Size = UDim2.fromScale(1, 1),

	BackgroundColor3 = Color3.new(),
	BackgroundTransparency = 1,

	BorderSizePixel = 0
}, Gui)

local Root = New("Frame", {
	AnchorPoint = Vector2.new(.5, .5),
	Position = UDim2.fromScale(.5, .5),

	Size = UDim2.fromOffset(C.W, C.H),

	BackgroundTransparency = 1
}, Overlay)

--==================================================
-- RESPONSIVE
--==================================================

local Scale = New("UIScale", {
	Scale = 1
}, Root)

local Camera = workspace.CurrentCamera

local function Resize()
	if not Camera then return end

	local v = Camera.ViewportSize

	Scale.Scale = math.max(
		.42,
		math.min(
			(v.X - 28) / C.W,
			(v.Y - 28) / C.H,
			1
		)
	)
end

Resize()

local ResizeConnection =
	Camera:GetPropertyChangedSignal("ViewportSize"):Connect(Resize)

--==================================================
-- SHADOW
--==================================================

local Shadow = New("Frame", {
	AnchorPoint = Vector2.new(.5, .5),

	Position = UDim2.new(.5, 0, .5, 9),

	Size = UDim2.new(1, 8, 1, 8),

	BackgroundColor3 = Color3.fromRGB(8, 8, 12),
	BackgroundTransparency = 1,

	BorderSizePixel = 0,

	ZIndex = 1
}, Root)

Round(Shadow, 28)

--==================================================
-- GLOW EXTERNO
--==================================================

local Glow = New("Frame", {
	AnchorPoint = Vector2.new(.5, .5),

	Position = UDim2.fromScale(.5, .5),

	Size = UDim2.new(1, 5, 1, 5),

	BackgroundTransparency = 1,

	ZIndex = 2
}, Root)

Round(Glow, 27)

local GlowStroke = New("UIStroke", {
	Thickness = 8,

	Color = C.Purple,

	Transparency = 1
}, Glow)

--==================================================
-- CARD
--==================================================

local Card = New("Frame", {
	Size = UDim2.fromScale(1, 1),

	BackgroundColor3 = Color3.fromRGB(55, 55, 64),
	BackgroundTransparency = 1,

	BorderSizePixel = 0,

	ClipsDescendants = true,

	ZIndex = 3
}, Root)

Round(Card, 24)

-- GRADIENTE CINZA ESCURO VISÍVEL
local CardGradient = Grad(Card, {
	Color3.fromRGB(68, 68, 78),
	Color3.fromRGB(55, 55, 65),
	Color3.fromRGB(44, 44, 53),
	Color3.fromRGB(34, 34, 42),
	Color3.fromRGB(25, 25, 32)
}, 135)

CardGradient.Offset = Vector2.new(-.04, 0)

--==================================================
-- BORDA
--==================================================

local Border = New("UIStroke", {
	Thickness = 3,

	Color = C.Purple,

	Transparency = 1,

	ApplyStrokeMode = Enum.ApplyStrokeMode.Border
}, Card)

pcall(function()
	Border.BorderStrokePosition =
		Enum.BorderStrokePosition.Outer
end)

Grad(Border, {
	Color3.fromRGB(105, 55, 255),
	Color3.fromRGB(145, 65, 255),
	C.Purple2,
	Color3.fromRGB(120, 55, 255)
}, 25)

--==================================================
-- CÍRCULO DUPLO DE BOLINHAS
--==================================================

local function CreateRing(transparency, z, rotation)
	local Ring = New("Frame", {
		AnchorPoint = Vector2.new(.5, .5),

		Position = UDim2.fromScale(.5, .5),

		Size = UDim2.fromOffset(22, 22),

		BackgroundTransparency = 1,

		Rotation = rotation or 0,

		ZIndex = z
	}, Card)

	local Dots = {}

	for i = 1, 48 do
		local a = math.rad((i - 1) * 7.5)

		local Dot = New("Frame", {
			AnchorPoint = Vector2.new(.5, .5),

			Position = UDim2.fromScale(
				.5 + math.cos(a) * .5,
				.5 + math.sin(a) * .5
			),

			Size = UDim2.fromOffset(3, 3),

			BackgroundColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 1,

			BorderSizePixel = 0,

			ZIndex = z
		}, Ring)

		Round(Dot, true)

		Dots[#Dots + 1] = {
			Object = Dot,
			Transparency = transparency
		}
	end

	return Ring, Dots
end

-- camada traseira
local Ring1, Dots1 = CreateRing(.80, 4, 0)

-- camada dianteira
local Ring2, Dots2 = CreateRing(.57, 5, 3.75)

Ring2.Size = UDim2.fromOffset(16, 16)

--==================================================
-- AVATAR GLOW
--==================================================

local AvatarGlow = New("Frame", {
	AnchorPoint = Vector2.new(.5, .5),

	Position = UDim2.fromOffset(104, 102),

	Size = UDim2.fromOffset(139, 139),

	BackgroundTransparency = 1,

	ZIndex = 6
}, Card)

Round(AvatarGlow, true)

local AvatarGlowStroke = New("UIStroke", {
	Thickness = 9,

	Color = C.Purple,

	Transparency = 1
}, AvatarGlow)

--==================================================
-- AVATAR CLIP
--==================================================

local AvatarClip = New("Frame", {
	Position = UDim2.fromOffset(49, 47),

	Size = UDim2.fromOffset(110, 110),

	BackgroundColor3 = Color3.fromRGB(38, 38, 46),
	BackgroundTransparency = .10,

	BorderSizePixel = 0,

	ClipsDescendants = true,

	ZIndex = 7
}, Card)

Round(AvatarClip, true)

Grad(AvatarClip, {
	Color3.fromRGB(51, 51, 60),
	Color3.fromRGB(34, 34, 42),
	Color3.fromRGB(24, 24, 30)
}, 135)

--==================================================
-- AVATAR IMAGE
--==================================================

local Avatar = New("ImageLabel", {
	Size = UDim2.fromScale(1, 1),

	BackgroundTransparency = 1,

	-- avatar oficial inteiro
	Image = (
		"rbxthumb://type=Avatar&id=%d&w=420&h=420"
	):format(P.UserId),

	ImageTransparency = 1,

	ScaleType = Enum.ScaleType.Fit,

	ZIndex = 8
}, AvatarClip)

--==================================================
-- ARO SEPARADO DO AVATAR
--==================================================

local AvatarRing = New("Frame", {
	Position = UDim2.fromOffset(43, 41),

	Size = UDim2.fromOffset(122, 122),

	BackgroundTransparency = 1,

	ZIndex = 10
}, Card)

Round(AvatarRing, true)

local AvatarStroke = New("UIStroke", {
	Thickness = 3,

	Color = C.Purple,

	Transparency = 1
}, AvatarRing)

Grad(AvatarStroke, {
	Color3.fromRGB(105, 55, 255),
	C.Purple2,
	Color3.fromRGB(115, 55, 255)
}, 45)

--==================================================
-- HEADER
--==================================================

local Greet = Text(
	Card,

	UDim2.fromOffset(188, 46),
	UDim2.fromOffset(390, 38),

	Greeting .. ",",

	Enum.Font.GothamBold,
	29,

	C.Text,

	Enum.TextXAlignment.Left
)

local Username = Text(
	Card,

	UDim2.fromOffset(188, 84),
	UDim2.fromOffset(390, 36),

	P.Name .. "!",

	Enum.Font.GothamBold,
	27,

	C.Purple2,

	Enum.TextXAlignment.Left
)

Username.TextTruncate =
	Enum.TextTruncate.AtEnd

local Welcome = Text(
	Card,

	UDim2.fromOffset(188, 121),
	UDim2.fromOffset(390, 28),

	"Bem-vindo(a) ao meu script!",

	Enum.Font.Gotham,
	17,

	C.SubText,

	Enum.TextXAlignment.Left
)

Greet.TextTransparency = 1
Username.TextTransparency = 1
Welcome.TextTransparency = 1

--==================================================
-- LUCIDE SPARKLES
--==================================================

local function EmptySparkle(parent, pos, size, z)
	return New("ImageLabel", {
		AnchorPoint = Vector2.new(.5, .5),

		Position = pos,
		Size = UDim2.fromOffset(size, size),

		BackgroundTransparency = 1,

		Image = "",
		ImageColor3 = C.Purple2,
		ImageTransparency = 1,

		ScaleType = Enum.ScaleType.Fit,

		ZIndex = z or 12
	}, parent)
end

local TopSparkle = EmptySparkle(
	Card,
	UDim2.new(1, -28, 0, 27),
	20,
	12
)

--==================================================
-- DIVIDER
--==================================================

local Divider = New("Frame", {
	Position = UDim2.fromOffset(31, 180),

	Size = UDim2.new(1, -62, 0, 1),

	BackgroundColor3 = C.Purple,
	BackgroundTransparency = 1,

	BorderSizePixel = 0,

	ZIndex = 8
}, Card)

--==================================================
-- LOADING
--==================================================

local Loading = Text(
	Card,

	UDim2.fromOffset(0, 194),
	UDim2.new(1, 0, 0, 28),

	"Carregando...",

	Enum.Font.GothamMedium,
	17,

	C.Purple2
)

Loading.TextTransparency = 1

local Bar = New("Frame", {
	Position = UDim2.fromOffset(53, 233),

	Size = UDim2.fromOffset(455, 29),

	BackgroundColor3 = Color3.fromRGB(38, 38, 47),
	BackgroundTransparency = 1,

	BorderSizePixel = 0,

	ClipsDescendants = true,

	ZIndex = 8
}, Card)

Round(Bar, true)

local BarStroke = New("UIStroke", {
	Thickness = 1.3,

	Color = Color3.fromRGB(145, 90, 200),

	Transparency = 1
}, Bar)

local Fill = New("Frame", {
	Size = UDim2.fromScale(0, 1),

	BackgroundColor3 = C.Purple,

	BorderSizePixel = 0,

	ZIndex = 9
}, Bar)

Round(Fill, true)

local FillGradient = Grad(Fill, {
	Color3.fromRGB(85, 38, 235),
	Color3.fromRGB(120, 50, 255),
	Color3.fromRGB(205, 95, 255),
	Color3.fromRGB(145, 60, 255),
	Color3.fromRGB(90, 40, 240)
}, 0)

FillGradient.Offset =
	Vector2.new(-.55, 0)

local Percent = Text(
	Card,

	UDim2.fromOffset(523, 233),
	UDim2.fromOffset(70, 29),

	"0%",

	Enum.Font.GothamMedium,
	18,

	C.Purple2,

	Enum.TextXAlignment.Left
)

Percent.TextTransparency = 1

--==================================================
-- MESSAGE BOX
--==================================================

local Box = New("Frame", {
	Position = UDim2.fromOffset(75, 293),

	Size = UDim2.fromOffset(483, 44),

	BackgroundColor3 = Color3.fromRGB(52, 52, 62),
	BackgroundTransparency = 1,

	BorderSizePixel = 0,

	ZIndex = 8
}, Card)

Round(Box, 12)

Grad(Box, {
	Color3.fromRGB(66, 66, 77),
	Color3.fromRGB(51, 51, 61),
	Color3.fromRGB(38, 38, 47),
	Color3.fromRGB(30, 30, 38)
}, 115)

local BoxStroke = New("UIStroke", {
	Thickness = 1,

	Color = C.Purple,

	Transparency = 1
}, Box)

local BottomSparkle = EmptySparkle(
	Box,
	UDim2.fromOffset(24, 22),
	18,
	12
)

local Message = Text(
	Box,

	UDim2.fromOffset(48, 0),
	UDim2.new(1, -58, 1, 0),

	"Obrigado por utilizar o meu script!",

	Enum.Font.Gotham,
	16,

	Color3.fromRGB(225, 225, 230),

	Enum.TextXAlignment.Left,
	10
)

Message.TextTransparency = 1

local Messages = {
	"Obrigado por utilizar o meu script!",
	"Preparando a interface...",
	"Carregando recursos...",
	"Quase tudo pronto..."
}

--==================================================
-- CARREGA LUCIDE UMA ÚNICA VEZ
--==================================================

local Entered = false

task.spawn(function()
	local ok, Lucide = pcall(function()

		return loadstring(game:HttpGet(
			"https://raw.githubusercontent.com/xxpwnxxx420lord/Lucide.Lua/refs/heads/main/lucide.lua"
		))()

	end)

	if not ok or not Lucide or not Gui.Parent then
		return
	end

	local success, asset = pcall(function()

		return Lucide:geticon("sparkles", {
			size = 64,
			color = "#D76EFF",
			stroke_width = 2
		})

	end)

	if not success or not asset then
		return
	end

	TopSparkle.Image = asset
	BottomSparkle.Image = asset

	while Gui.Parent and not Entered do
		task.wait(.05)
	end

	if not Gui.Parent then
		return
	end

	Tw(
		TopSparkle,
		.45,
		{ImageTransparency = .08},
		Enum.EasingStyle.Sine
	)

	Tw(
		BottomSparkle,
		.45,
		{ImageTransparency = .12},
		Enum.EasingStyle.Sine
	)

	-- horário
	Tw(
		TopSparkle,
		14,
		{Rotation = 360},
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.Out,
		-1
	)

	Tw(
		BottomSparkle,
		17,
		{Rotation = 360},
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.Out,
		-1
	)
end)

--==================================================
-- FADE IN
--==================================================

Tw(
	Overlay,
	C.FadeIn,
	{BackgroundTransparency = .74},
	Enum.EasingStyle.Sine
)

Tw(
	Blur,
	C.FadeIn,
	{Size = C.Blur},
	Enum.EasingStyle.Sine
)

Tw(
	Shadow,
	C.FadeIn,
	{BackgroundTransparency = .82},
	Enum.EasingStyle.Sine
)

Tw(
	Card,
	C.FadeIn,
	{BackgroundTransparency = .08},
	Enum.EasingStyle.Sine
)

Tw(
	Border,
	C.FadeIn,
	{Transparency = .05},
	Enum.EasingStyle.Sine
)

Tw(
	GlowStroke,
	C.FadeIn,
	{Transparency = .82},
	Enum.EasingStyle.Sine
)

Tw(
	AvatarGlowStroke,
	C.FadeIn,
	{Transparency = .80},
	Enum.EasingStyle.Sine
)

Tw(
	AvatarStroke,
	C.FadeIn,
	{Transparency = 0},
	Enum.EasingStyle.Sine
)

Tw(
	Avatar,
	C.FadeIn,
	{ImageTransparency = 0},
	Enum.EasingStyle.Sine
)

Tw(
	Greet,
	C.FadeIn,
	{TextTransparency = 0},
	Enum.EasingStyle.Sine
)

Tw(
	Username,
	C.FadeIn,
	{TextTransparency = 0},
	Enum.EasingStyle.Sine
)

Tw(
	Welcome,
	C.FadeIn,
	{TextTransparency = .05},
	Enum.EasingStyle.Sine
)

Tw(
	Divider,
	C.FadeIn,
	{BackgroundTransparency = .62},
	Enum.EasingStyle.Sine
)

Tw(
	Loading,
	C.FadeIn,
	{TextTransparency = 0},
	Enum.EasingStyle.Sine
)

Tw(
	Bar,
	C.FadeIn,
	{BackgroundTransparency = .10},
	Enum.EasingStyle.Sine
)

Tw(
	BarStroke,
	C.FadeIn,
	{Transparency = .28},
	Enum.EasingStyle.Sine
)

Tw(
	Percent,
	C.FadeIn,
	{TextTransparency = 0},
	Enum.EasingStyle.Sine
)

Tw(
	Box,
	C.FadeIn,
	{BackgroundTransparency = .20},
	Enum.EasingStyle.Sine
)

Tw(
	BoxStroke,
	C.FadeIn,
	{Transparency = .70},
	Enum.EasingStyle.Sine
)

Tw(
	Message,
	C.FadeIn,
	{TextTransparency = 0},
	Enum.EasingStyle.Sine
)

-- nada carrega antes disso
task.wait(C.FadeIn + .05)

Entered = true

--==================================================
-- ANIMAÇÕES CONTÍNUAS
--==================================================

-- gradiente do card se move quase imperceptivelmente
Tw(
	CardGradient,
	7,
	{Offset = Vector2.new(.04, 0)},
	Enum.EasingStyle.Sine,
	Enum.EasingDirection.InOut,
	-1,
	true
)

-- glow respira sem mudar thickness
Tw(
	GlowStroke,
	2.2,
	{Transparency = .93},
	Enum.EasingStyle.Sine,
	Enum.EasingDirection.InOut,
	-1,
	true
)

Tw(
	AvatarGlowStroke,
	1.9,
	{Transparency = .92},
	Enum.EasingStyle.Sine,
	Enum.EasingDirection.InOut,
	-1,
	true
)

-- borda só muda transparência
Tw(
	Border,
	2,
	{Transparency = .15},
	Enum.EasingStyle.Sine,
	Enum.EasingDirection.InOut,
	-1,
	true
)

-- shimmer sem frame branco
Tw(
	FillGradient,
	1.8,
	{Offset = Vector2.new(.55, 0)},
	Enum.EasingStyle.Sine,
	Enum.EasingDirection.InOut,
	-1,
	true
)

--==================================================
-- MOSTRA AS 2 CAMADAS DE BOLINHAS
--==================================================

for _, data in ipairs(Dots1) do
	data.Object.BackgroundTransparency =
		data.Transparency
end

for _, data in ipairs(Dots2) do
	data.Object.BackgroundTransparency =
		data.Transparency
end

-- expansão UMA vez
Tw(
	Ring1,
	6.2,
	{
		Size = UDim2.fromOffset(315, 315),
		Rotation = 32
	},
	Enum.EasingStyle.Sine,
	Enum.EasingDirection.Out
)

Tw(
	Ring2,
	6.2,
	{
		Size = UDim2.fromOffset(315, 315),
		Rotation = -24
	},
	Enum.EasingStyle.Sine,
	Enum.EasingDirection.Out
)

-- fade leve das bolinhas sem criar 96 tweens
task.spawn(function()

	task.wait(5.15)

	for step = 1, 8 do

		if not Gui.Parent then
			return
		end

		local a = step / 8

		for _, data in ipairs(Dots1) do
			data.Object.BackgroundTransparency =
				data.Transparency
				+ (1 - data.Transparency) * a
		end

		for _, data in ipairs(Dots2) do
			data.Object.BackgroundTransparency =
				data.Transparency
				+ (1 - data.Transparency) * a
		end

		task.wait(.1)
	end

	if Ring1.Parent then Ring1:Destroy() end
	if Ring2.Parent then Ring2:Destroy() end

end)

--==================================================
-- MENSAGENS
--==================================================

local Running = true

task.spawn(function()

	local i = 1

	while Running and Gui.Parent do

		task.wait(2.1)

		if not Running or not Gui.Parent then
			break
		end

		Tw(
			Message,
			.35,
			{TextTransparency = 1},
			Enum.EasingStyle.Sine
		)

		task.wait(.38)

		if not Running or not Gui.Parent then
			break
		end

		i = i % #Messages + 1

		Message.Text =
			Messages[i]

		Tw(
			Message,
			.42,
			{TextTransparency = 0},
			Enum.EasingStyle.Sine
		)

	end

end)

--==================================================
-- LOADING
--==================================================

Tw(
	Fill,
	C.LoadTime,
	{Size = UDim2.fromScale(1, 1)},
	Enum.EasingStyle.Linear
)

local Started = os.clock()
local Last = -1

while Gui.Parent do

	local progress = math.clamp(
		(os.clock() - Started) / C.LoadTime,
		0,
		1
	)

	local value =
		math.floor(progress * 100)

	if value ~= Last then
		Last = value
		Percent.Text = value .. "%"
	end

	if progress >= 1 then
		break
	end

	-- apenas 10 updates/s
	task.wait(.1)
end

if not Gui.Parent then
	return
end

Running = false

Fill.Size = UDim2.fromScale(1, 1)

Percent.Text = "100%"
Loading.Text = "Carregado!"

--==================================================
-- FINAL
--==================================================

Tw(
	Message,
	.25,
	{TextTransparency = 1},
	Enum.EasingStyle.Sine
)

task.wait(.28)

Message.Text =
	"Tudo pronto. Aproveite!"

Tw(
	Message,
	.42,
	{TextTransparency = 0},
	Enum.EasingStyle.Sine
)

-- flash somente pela transparência da borda
Tw(
	Border,
	.22,
	{Transparency = 0},
	Enum.EasingStyle.Sine
)

Tw(
	GlowStroke,
	.22,
	{Transparency = .70},
	Enum.EasingStyle.Sine
)

task.wait(.28)

Tw(
	Border,
	.45,
	{Transparency = .06},
	Enum.EasingStyle.Sine
)

Tw(
	GlowStroke,
	.45,
	{Transparency = .84},
	Enum.EasingStyle.Sine
)

task.wait(.8)

--==================================================
-- FADE OUT
--==================================================

local function FadeText(t)
	if t.Parent then
		Tw(
			t,
			C.FadeOut,
			{TextTransparency = 1},
			Enum.EasingStyle.Sine
		)
	end
end

FadeText(Greet)
FadeText(Username)
FadeText(Welcome)
FadeText(Loading)
FadeText(Percent)
FadeText(Message)

Tw(
	Avatar,
	C.FadeOut,
	{ImageTransparency = 1},
	Enum.EasingStyle.Sine
)

Tw(
	TopSparkle,
	C.FadeOut,
	{ImageTransparency = 1},
	Enum.EasingStyle.Sine
)

Tw(
	BottomSparkle,
	C.FadeOut,
	{ImageTransparency = 1},
	Enum.EasingStyle.Sine
)

Tw(
	AvatarStroke,
	C.FadeOut,
	{Transparency = 1},
	Enum.EasingStyle.Sine
)

Tw(
	AvatarGlowStroke,
	C.FadeOut,
	{Transparency = 1},
	Enum.EasingStyle.Sine
)

Tw(
	Divider,
	C.FadeOut,
	{BackgroundTransparency = 1},
	Enum.EasingStyle.Sine
)

Tw(
	Bar,
	C.FadeOut,
	{BackgroundTransparency = 1},
	Enum.EasingStyle.Sine
)

Tw(
	BarStroke,
	C.FadeOut,
	{Transparency = 1},
	Enum.EasingStyle.Sine
)

Tw(
	Box,
	C.FadeOut,
	{BackgroundTransparency = 1},
	Enum.EasingStyle.Sine
)

Tw(
	BoxStroke,
	C.FadeOut,
	{Transparency = 1},
	Enum.EasingStyle.Sine
)

Tw(
	Card,
	C.FadeOut,
	{BackgroundTransparency = 1},
	Enum.EasingStyle.Sine
)

Tw(
	Border,
	C.FadeOut,
	{Transparency = 1},
	Enum.EasingStyle.Sine
)

Tw(
	GlowStroke,
	C.FadeOut,
	{Transparency = 1},
	Enum.EasingStyle.Sine
)

Tw(
	Shadow,
	C.FadeOut,
	{BackgroundTransparency = 1},
	Enum.EasingStyle.Sine
)

Tw(
	Overlay,
	C.FadeOut,
	{BackgroundTransparency = 1},
	Enum.EasingStyle.Sine
)

Tw(
	Blur,
	C.FadeOut,
	{Size = 0},
	Enum.EasingStyle.Sine
)

task.wait(C.FadeOut + .08)

--==================================================
-- CLEANUP
--==================================================

ResizeConnection:Disconnect()

if Blur.Parent then
	Blur:Destroy()
end

if Gui.Parent then
	Gui:Destroy()
end
