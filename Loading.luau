local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--==================================================
-- CONFIG
--==================================================

local LOAD_TIME = 15
local HOLD_TIME = 1
local PURPLE = Color3.fromRGB(145,70,255)
local LIGHT_PURPLE = Color3.fromRGB(210,105,255)

--==================================================
-- CLEAN OLD
--==================================================

local old = PlayerGui:FindFirstChild("MirrorsWelcome")
if old then old:Destroy() end

local oldBlur = Lighting:FindFirstChild("MirrorsWelcomeBlur")
if oldBlur then oldBlur:Destroy() end

--==================================================
-- HELPERS
--==================================================

local function New(class,props,parent)
	local o = Instance.new(class)
	for k,v in pairs(props) do
		pcall(function() o[k] = v end)
	end
	o.Parent = parent
	return o
end

local function Corner(parent,r)
	return New("UICorner",{
		CornerRadius = r == true and UDim.new(1,0) or UDim.new(0,r)
	},parent)
end

local function Tween(o,t,p,style,dir)
	local tw = TweenService:Create(
		o,
		TweenInfo.new(
			t,
			style or Enum.EasingStyle.Quart,
			dir or Enum.EasingDirection.Out
		),
		p
	)
	tw:Play()
	return tw
end

local function Gradient(parent,colors,rotation)
	local points = {}
	for i,color in ipairs(colors) do
		points[i] = ColorSequenceKeypoint.new((i-1)/(#colors-1),color)
	end

	return New("UIGradient",{
		Color = ColorSequence.new(points),
		Rotation = rotation or 0
	},parent)
end

local function Stroke(parent,size)
	local s = New("UIStroke",{
		Thickness = size,
		Transparency = .03,
		Color = PURPLE,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	},parent)

	Gradient(s,{
		Color3.fromRGB(100,50,255),
		Color3.fromRGB(215,105,255),
		Color3.fromRGB(115,60,255)
	},35)

	return s
end

--==================================================
-- GREETING
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
	BackgroundColor3 = Color3.new(0,0,0),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ZIndex = 1
},Gui)

--==================================================
-- SHADOW
--==================================================

local Shadow = New("Frame",{
	AnchorPoint = Vector2.new(.5,.5),
	Position = UDim2.new(.5,0,.5,10),
	Size = UDim2.fromOffset(716,386),
	BackgroundColor3 = Color3.new(0,0,0),
	BackgroundTransparency = .55,
	BorderSizePixel = 0,
	ZIndex = 2
},Overlay)

Corner(Shadow,28)

--==================================================
-- CARD
--==================================================

local Card = New("Frame",{
	AnchorPoint = Vector2.new(.5,.5),
	Position = UDim2.fromScale(.5,.5),
	Size = UDim2.fromOffset(700,370),

	BackgroundColor3 = Color3.fromRGB(35,35,42),
	BackgroundTransparency = 0,

	BorderSizePixel = 0,
	ZIndex = 3
},Overlay)

Corner(Card,25)
Stroke(Card,4)

Gradient(Card,{
	Color3.fromRGB(58,58,67),
	Color3.fromRGB(43,43,50),
	Color3.fromRGB(31,31,37),
	Color3.fromRGB(21,21,26)
},135)

--==================================================
-- RESPONSIVE
--==================================================

local Scale = New("UIScale",{Scale = 1},Card)
local ShadowScale = New("UIScale",{Scale = 1},Shadow)

local function Resize()
	local s = workspace.CurrentCamera.ViewportSize

	local scale = math.min(
		(s.X-30)/700,
		(s.Y-30)/370,
		1
	)

	scale = math.max(scale,.45)

	Scale.Scale = scale
	ShadowScale.Scale = scale
end

Resize()

local resizeConnection =
	workspace.CurrentCamera
	:GetPropertyChangedSignal("ViewportSize")
	:Connect(Resize)

--==================================================
-- AVATAR
--==================================================

local AvatarHolder = New("Frame",{
	Position = UDim2.fromOffset(48,37),
	Size = UDim2.fromOffset(145,145),

	BackgroundColor3 = Color3.fromRGB(24,24,30),
	BorderSizePixel = 0,

	ClipsDescendants = true,
	ZIndex = 5
},Card)

Corner(AvatarHolder,true)
Stroke(AvatarHolder,4)

local Fallback = New("TextLabel",{
	Size = UDim2.fromScale(1,1),
	BackgroundTransparency = 1,

	Text = Player.Name:sub(1,1):upper(),

	TextColor3 = LIGHT_PURPLE,
	Font = Enum.Font.GothamBold,
	TextSize = 48,

	ZIndex = 6
},AvatarHolder)

local Avatar = New("ImageLabel",{
	AnchorPoint = Vector2.new(.5,.5),

	-- centralizado exatamente
	Position = UDim2.fromScale(.5,.5),

	-- leve zoom só para eliminar borda vazia do thumbnail
	Size = UDim2.fromScale(1.06,1.06),

	BackgroundTransparency = 1,
	Image = "",

	ScaleType = Enum.ScaleType.Crop,

	ZIndex = 7
},AvatarHolder)

-- avatar oficial Roblox
task.spawn(function()
	for i = 1,4 do

		if not Gui.Parent then return end

		local ok,image,ready = pcall(function()
			return Players:GetUserThumbnailAsync(
				Player.UserId,
				Enum.ThumbnailType.HeadShot,
				Enum.ThumbnailSize.Size420x420
			)
		end)

		if ok and ready and image ~= "" then
			Avatar.Image = image
			Fallback.Visible = false
			return
		end

		task.wait(.25*i)
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

		ZIndex = 5
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

	LIGHT_PURPLE,
	Enum.TextXAlignment.Left
)

Username.TextTruncate = Enum.TextTruncate.AtEnd

Text(
	UDim2.fromOffset(220,140),
	UDim2.fromOffset(430,30),

	"Bem-vindo(a) ao meu script! 👋",

	Enum.Font.Gotham,
	18,

	Color3.fromRGB(205,205,215),
	Enum.TextXAlignment.Left
)

--==================================================
-- DIVIDER
--==================================================

New("Frame",{
	Position = UDim2.fromOffset(35,200),
	Size = UDim2.new(1,-70,0,1),

	BackgroundColor3 = PURPLE,
	BackgroundTransparency = .55,

	BorderSizePixel = 0,
	ZIndex = 5
},Card)

--==================================================
-- LOADING TEXT
--==================================================

local Loading = Text(
	UDim2.fromOffset(0,215),
	UDim2.new(1,0,0,30),

	"Carregando...",

	Enum.Font.GothamMedium,
	18,

	LIGHT_PURPLE
)

--==================================================
-- BAR
--==================================================

local Bar = New("Frame",{
	Position = UDim2.fromOffset(70,257),
	Size = UDim2.fromOffset(500,30),

	BackgroundColor3 = Color3.fromRGB(17,17,22),
	BorderSizePixel = 0,

	ClipsDescendants = true,
	ZIndex = 5
},Card)

Corner(Bar,true)

New("UIStroke",{
	Thickness = 1.5,
	Transparency = .28,
	Color = Color3.fromRGB(125,75,185)
},Bar)

local Fill = New("Frame",{
	Size = UDim2.fromScale(0,1),

	BackgroundColor3 = PURPLE,
	BorderSizePixel = 0,

	ZIndex = 6
},Bar)

Corner(Fill,true)

Gradient(Fill,{
	Color3.fromRGB(95,45,255),
	Color3.fromRGB(150,65,255),
	Color3.fromRGB(225,105,255)
})

local Percent = Text(
	UDim2.fromOffset(588,257),
	UDim2.fromOffset(75,30),

	"0%",

	Enum.Font.GothamMedium,
	19,

	LIGHT_PURPLE,
	Enum.TextXAlignment.Left
)

--==================================================
-- THANKS
--==================================================

Text(
	UDim2.fromOffset(20,315),
	UDim2.new(1,-40,0,30),

	"✦  Obrigado por utilizar o meu script!",

	Enum.Font.Gotham,
	18,

	Color3.fromRGB(215,215,222)
)

--==================================================
-- ENTRADA
--==================================================

Card.Position = UDim2.fromScale(.5,.54)
Shadow.Position = UDim2.new(.5,0,.54,10)

Tween(Overlay,.4,{
	BackgroundTransparency = .62
})

Tween(Blur,.4,{
	Size = 10
})

Tween(Card,.5,{
	Position = UDim2.fromScale(.5,.5)
})

Tween(Shadow,.5,{
	Position = UDim2.new(.5,0,.5,10)
})

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
local LastPercent = -1

while Gui.Parent do

	local progress = math.clamp(
		(os.clock()-Start)/LOAD_TIME,
		0,
		1
	)

	local value = math.floor(progress*100)

	if value ~= LastPercent then
		LastPercent = value
		Percent.Text = value.."%"
	end

	if progress >= 1 then
		break
	end

	task.wait(.08)
end

if not Gui.Parent then
	return
end

Fill.Size = UDim2.fromScale(1,1)
Percent.Text = "100%"
Loading.Text = "Carregado!"

task.wait(HOLD_TIME)

--==================================================
-- SAÍDA
--==================================================

Tween(Card,.42,{
	Position = UDim2.fromScale(.5,.46)
},Enum.EasingStyle.Quart,Enum.EasingDirection.In)

Tween(Shadow,.42,{
	Position = UDim2.new(.5,0,.46,10),
	BackgroundTransparency = 1
})

Tween(Overlay,.42,{
	BackgroundTransparency = 1
})

Tween(Blur,.42,{
	Size = 0
})

task.wait(.45)

--==================================================
-- CLEANUP
--==================================================

resizeConnection:Disconnect()

if Blur.Parent then
	Blur:Destroy()
end

if Gui.Parent then
	Gui:Destroy()
end
