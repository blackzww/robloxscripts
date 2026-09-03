task.spawn(function()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Stats = game:GetService("Stats")

local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

local Env = getgenv()

if Env.MirrorsV5Runtime and Env.MirrorsV5Runtime.Cleanup then
    pcall(Env.MirrorsV5Runtime.Cleanup)
end

local Runtime = {
    Alive = true,
    Connections = {},
    Instances = {},
    Tweens = {},
    Window = nil,
    Notifications = true
}

Env.MirrorsV5Runtime = Runtime

local function AddConnection(Connection)
    if Connection then
        table.insert(Runtime.Connections, Connection)
    end

    return Connection
end

local function AddInstance(Object)
    if Object then
        table.insert(Runtime.Instances, Object)
    end

    return Object
end

local function AddTween(Tween)
    if Tween then
        table.insert(Runtime.Tweens, Tween)
    end

    return Tween
end

Runtime.Cleanup = function()
    if not Runtime.Alive then
        return
    end

    Runtime.Alive = false

    for _, Tween in ipairs(Runtime.Tweens) do
        pcall(function()
            Tween:Cancel()
        end)
    end

    for _, Connection in ipairs(Runtime.Connections) do
        pcall(function()
            Connection:Disconnect()
        end)
    end

    for i = #Runtime.Instances, 1, -1 do
        pcall(function()
            Runtime.Instances[i]:Destroy()
        end)
    end

    if Runtime.Window then
        pcall(function()
            Runtime.Window:Destroy()
        end)
    end

    table.clear(Runtime.Connections)
    table.clear(Runtime.Instances)
    table.clear(Runtime.Tweens)

    if Env.MirrorsV5Runtime == Runtime then
        Env.MirrorsV5Runtime = nil
    end
end

local WindUI = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/download/1.6.66/main.lua"
))()

local BACKGROUND = "rbxassetid://127075963169326"

local C = {
    White = Color3.fromHex("#FFFFFF"),
    SoftWhite = Color3.fromHex("#F8F5FB"),
    Text = Color3.fromHex("#FBF9FD"),
    Muted = Color3.fromHex("#ADA6B3"),

    PurpleLight = Color3.fromHex("#E4BCFF"),
    Purple = Color3.fromHex("#C463FF"),
    PurpleVivid = Color3.fromHex("#AD35FF"),
    PurpleDeep = Color3.fromHex("#7116C8"),
    PurpleDark = Color3.fromHex("#3C095E"),

    Pink = Color3.fromHex("#F04BFF"),
    Red = Color3.fromHex("#FF536B"),
    Blue = Color3.fromHex("#4D8DFF"),
    Cyan = Color3.fromHex("#28D8F3"),
    Green = Color3.fromHex("#43E39B"),
    Orange = Color3.fromHex("#FF9F32"),
    Yellow = Color3.fromHex("#FFC857"),
    Lavender = Color3.fromHex("#BFA4FF"),

    Background = Color3.fromHex("#0D0911"),
    Panel = Color3.fromHex("#151019"),
    Card = Color3.fromHex("#201625"),
    Graphite = Color3.fromHex("#29272D"),
    Graphite2 = Color3.fromHex("#343138")
}

local TAB_COLORS = {
    Info = C.PurpleLight,
    Main = C.Purple,
    ESP = C.Cyan,
    Murder = C.Red,
    Sheriff = C.Blue,
    Innocent = C.Green,
    Shortcuts = C.Orange,
    Misc = C.Lavender,
    Config = C.Pink
}

WindUI:AddTheme({
    Name = "Mirrors Purple",

    Accent = WindUI:Gradient({
        ["0"] = {
            Color = Color3.fromHex("#FFFFFF"),
            Transparency = 0
        },

        ["50"] = {
            Color = Color3.fromHex("#FAF7FC"),
            Transparency = 0
        },

        ["100"] = {
            Color = Color3.fromHex("#E9D6F4"),
            Transparency = 0
        }
    }, {
        Rotation = 90
    }),

    Background = WindUI:Gradient({
        ["0"] = {
            Color = Color3.fromHex("#1B0F22"),
            Transparency = 0
        },

        ["50"] = {
            Color = Color3.fromHex("#110B16"),
            Transparency = 0
        },

        ["100"] = {
            Color = Color3.fromHex("#08060A"),
            Transparency = 0
        }
    }, {
        Rotation = 120
    }),

    Dialog = Color3.fromHex("#18101D"),

    Outline = WindUI:Gradient({
        ["0"] = {
            Color = C.PurpleLight,
            Transparency = 0.12
        },

        ["45"] = {
            Color = C.PurpleVivid,
            Transparency = 0.18
        },

        ["100"] = {
            Color = C.PurpleDark,
            Transparency = 0.28
        }
    }, {
        Rotation = 35
    }),

    Text = C.Text,
    Placeholder = C.Muted,

    Button = WindUI:Gradient({
        ["0"] = {
            Color = Color3.fromHex("#2B2030"),
            Transparency = 0
        },

        ["50"] = {
            Color = Color3.fromHex("#201724"),
            Transparency = 0
        },

        ["100"] = {
            Color = Color3.fromHex("#151018"),
            Transparency = 0
        }
    }, {
        Rotation = 110
    }),

    Icon = C.SoftWhite
})

WindUI:SetTheme("Mirrors Purple")

pcall(function()
    WindUI:SetNotificationLower(true)
end)

local Window = WindUI:CreateWindow({
    Title = "Mirrors Hub - MM2",
    Icon = "solar:home-2-bold",
    Author = "by blackzw.mp3",
    Folder = "MirrorsHub/MM2/V5",

    Size = UDim2.fromOffset(620, 430),
    MinSize = Vector2.new(560, 380),
    MaxSize = Vector2.new(760, 520),

    ToggleKey = Enum.KeyCode.K,

    Transparent = true,
    Theme = "Mirrors Purple",
    Resizable = true,

    SideBarWidth = 168,

    Background = BACKGROUND,
    BackgroundImageTransparency = 0.79,

    HideSearchBar = true,
    ScrollBarEnabled = true,

    NewElements = true,

    Topbar = {
        Height = 44,
        ButtonsType = "Mac"
    },

    User = {
        Enabled = false,
        Anonymous = false
    }
})

Runtime.Window = Window

Window:SetToggleKey(Enum.KeyCode.K)

Window:EditOpenButton({
    Title = "Open Mirrors Hub - MM2",

    Icon = "solar:home-2-bold",

    CornerRadius = UDim.new(0, 16),

    StrokeThickness = 2,

    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(
            0,
            Color3.fromHex("#EBCBFF")
        ),

        ColorSequenceKeypoint.new(
            0.25,
            Color3.fromHex("#D478FF")
        ),

        ColorSequenceKeypoint.new(
            0.52,
            Color3.fromHex("#B93EFF")
        ),

        ColorSequenceKeypoint.new(
            0.78,
            Color3.fromHex("#9D24EE")
        ),

        ColorSequenceKeypoint.new(
            1,
            Color3.fromHex("#6814AF")
        )
    }),

    OnlyMobile = false,
    Enabled = true,
    Draggable = true
})

Window:Tag({
    Title = "v1.6.1",
    Icon = "solar:stars-bold",
    Color = C.PurpleVivid,
    Border = true,
    Radius = 11
})

Window:Tag({
    Title = "BETA",
    Icon = "solar:flame-bold",
    Color = C.Pink,
    Border = true,
    Radius = 11
})

pcall(function()
    Window:SetPanelBackground(true)
end)

pcall(function()
    Window:SetBackgroundImageTransparency(0.79)
end)

local function Notify(Title, Content, Icon, Duration)
    if not Runtime.Notifications then
        return
    end

    WindUI:Notify({
        Title = Title or "Mirrors Hub",

        Content = Content or "",

        Icon =
            Icon
            or "solar:info-square-bold",

        Duration = Duration or 3,

        CanClose = true
    })
end

local Visual = {
    BackgroundVisibility = 20,
    Glow = 78,
    Vibrance = 74,
    Glass = 50
}

local Custom = {
    Frame = nil,
    Background = nil,
    Tint = nil,
    Shade = nil
}

local function GetGuiRoots()
    local Roots = {
        PlayerGui
    }

    if type(gethui) == "function" then
        local Success, Root =
            pcall(gethui)

        if Success and typeof(Root) == "Instance" then
            table.insert(Roots, Root)
        end
    end

    return Roots
end

local function FindGuiText(Text)
    for _, Root in ipairs(GetGuiRoots()) do
        for _, Object in ipairs(Root:GetDescendants()) do
            if (
                Object:IsA("TextLabel")
                or Object:IsA("TextButton")
            )
            and Object.Text == Text then
                return Object
            end
        end
    end
end

local function FindGuiButton(Text)
    local Object =
        FindGuiText(Text)

    if not Object then
        return
    end

    if Object:IsA("GuiButton") then
        return Object
    end

    local Parent =
        Object.Parent

    for _ = 1, 8 do
        if not Parent then
            break
        end

        if Parent:IsA("GuiButton") then
            return Parent
        end

        Parent =
            Parent.Parent
    end
end

local function IsWindowFrame(Object)
    if not Object:IsA("Frame") then
        return false
    end

    local Size =
        Object.AbsoluteSize

    return
        Size.X >= 540
        and Size.X <= 800
        and Size.Y >= 350
        and Size.Y <= 560
end

local function FindWindowFrame()
    local Title =
        FindGuiText(
            "Mirrors Hub - MM2"
        )

    if Title then
        local Parent =
            Title.Parent

        for _ = 1, 14 do
            if not Parent then
                break
            end

            if IsWindowFrame(Parent) then
                return Parent
            end

            Parent =
                Parent.Parent
        end
    end

    local Best
    local BestScore =
        math.huge

    for _, Root in ipairs(GetGuiRoots()) do
        for _, Object in ipairs(Root:GetDescendants()) do
            if IsWindowFrame(Object) then
                local Size =
                    Object.AbsoluteSize

                local Score =
                    math.abs(
                        Size.X - 620
                    )
                    +
                    math.abs(
                        Size.Y - 430
                    )

                if Score < BestScore then
                    Best =
                        Object

                    BestScore =
                        Score
                end
            end
        end
    end

    return Best
end

local function RemoveIfExists(Parent, Name)
    if not Parent then
        return
    end

    local Object =
        Parent:
            FindFirstChild(Name)

    if Object then
        Object:Destroy()
    end
end

local function ApplyWindowVisual()
    local Frame =
        Custom.Frame

    if not Frame
    or not Frame.Parent then
        Frame =
            FindWindowFrame()

        Custom.Frame =
            Frame
    end

    if not Frame then
        return
    end

    for _, Name in ipairs({
        "MirrorsV5Background",
        "MirrorsV5Tint",
        "MirrorsV5Shade",
        "MirrorsV5Border",
        "MirrorsV5Glow",
        "MirrorsV5Accent",
        "MirrorsV5AccentGlow"
    }) do
        RemoveIfExists(
            Frame,
            Name
        )
    end

    Frame.ClipsDescendants =
        false

    local Background =
        Instance.new(
            "ImageLabel"
        )

    Background.Name =
        "MirrorsV5Background"

    Background.AnchorPoint =
        Vector2.new(
            0.5,
            0.5
        )

    Background.Position =
        UDim2.fromScale(
            0.5,
            0.5
        )

    Background.Size =
        UDim2.fromScale(
            1.04,
            1.04
        )

    Background.BackgroundTransparency =
        1

    Background.Image =
        BACKGROUND

    Background.ScaleType =
        Enum.ScaleType.Crop

    Background.ImageTransparency =
        math.clamp(
            0.92 -
            (
                Visual.BackgroundVisibility
                / 100
            ) * 0.65,
            0.48,
            0.92
        )

    Background.ZIndex = 0
    Background.Active = false

    Background.Parent =
        Frame

    local Corner =
        Instance.new(
            "UICorner"
        )

    Corner.CornerRadius =
        UDim.new(
            0,
            18
        )

    Corner.Parent =
        Background

    local Tint =
        Instance.new(
            "Frame"
        )

    Tint.Name =
        "MirrorsV5Tint"

    Tint.Size =
        UDim2.fromScale(
            1,
            1
        )

    Tint.BackgroundColor3 =
        C.PurpleVivid

    Tint.BackgroundTransparency =
        0.93

    Tint.BorderSizePixel =
        0

    Tint.ZIndex = 0
    Tint.Active = false

    Tint.Parent =
        Frame

    local TintCorner =
        Instance.new(
            "UICorner"
        )

    TintCorner.CornerRadius =
        UDim.new(
            0,
            18
        )

    TintCorner.Parent =
        Tint

    local TintGradient =
        Instance.new(
            "UIGradient"
        )

    TintGradient.Rotation =
        35

    TintGradient.Color =
        ColorSequence.new({
            ColorSequenceKeypoint.new(
                0,
                C.PurpleLight
            ),

            ColorSequenceKeypoint.new(
                0.35,
                C.Purple
            ),

            ColorSequenceKeypoint.new(
                0.7,
                C.PurpleVivid
            ),

            ColorSequenceKeypoint.new(
                1,
                C.PurpleDark
            )
        })

    TintGradient.Transparency =
        NumberSequence.new({
            NumberSequenceKeypoint.new(
                0,
                0.67
            ),

            NumberSequenceKeypoint.new(
                0.42,
                0.84
            ),

            NumberSequenceKeypoint.new(
                1,
                0.97
            )
        })

    TintGradient.Parent =
        Tint

    local Shade =
        Instance.new(
            "Frame"
        )

    Shade.Name =
        "MirrorsV5Shade"

    Shade.Size =
        UDim2.fromScale(
            1,
            1
        )

    Shade.BackgroundColor3 =
        Color3.fromRGB(
            6,
            4,
            8
        )

    Shade.BackgroundTransparency =
        math.clamp(
            0.54
            +
            (
                Visual.Glass
                / 100
            ) * 0.12,
            0.54,
            0.68
        )

    Shade.BorderSizePixel =
        0

    Shade.ZIndex =
        0

    Shade.Active =
        false

    Shade.Parent =
        Frame

    local ShadeCorner =
        Instance.new(
            "UICorner"
        )

    ShadeCorner.CornerRadius =
        UDim.new(
            0,
            18
        )

    ShadeCorner.Parent =
        Shade

    local ShadeGradient =
        Instance.new(
            "UIGradient"
        )

    ShadeGradient.Rotation =
        105

    ShadeGradient.Color =
        ColorSequence.new({
            ColorSequenceKeypoint.new(
                0,
                Color3.fromHex("#09060B")
            ),

            ColorSequenceKeypoint.new(
                0.5,
                Color3.fromHex("#17101C")
            ),

            ColorSequenceKeypoint.new(
                1,
                Color3.fromHex("#09060C")
            )
        })

    ShadeGradient.Parent =
        Shade

    local Border =
        Instance.new(
            "UIStroke"
        )

    Border.Name =
        "MirrorsV5Border"

    Border.ApplyStrokeMode =
        Enum.ApplyStrokeMode.Border

    Border.Thickness =
        1.7

    Border.Transparency =
        0.07

    Border.Parent =
        Frame

    local BorderGradient =
        Instance.new(
            "UIGradient"
        )

    BorderGradient.Rotation =
        0

    BorderGradient.Color =
        ColorSequence.new({
            ColorSequenceKeypoint.new(
                0,
                C.PurpleDeep
            ),

            ColorSequenceKeypoint.new(
                0.22,
                C.Purple
            ),

            ColorSequenceKeypoint.new(
                0.48,
                C.White
            ),

            ColorSequenceKeypoint.new(
                0.58,
                C.PurpleLight
            ),

            ColorSequenceKeypoint.new(
                0.82,
                C.PurpleVivid
            ),

            ColorSequenceKeypoint.new(
                1,
                C.PurpleDeep
            )
        })

    BorderGradient.Parent =
        Border

    local Glow =
        Instance.new(
            "UIStroke"
        )

    Glow.Name =
        "MirrorsV5Glow"

    Glow.ApplyStrokeMode =
        Enum.ApplyStrokeMode.Border

    Glow.Thickness =
        5.5

    Glow.Color =
        C.White

    Glow.Transparency =
        math.clamp(
            0.93
            -
            (
                Visual.Glow
                / 100
            ) * 0.23,
            0.68,
            0.93
        )

    Glow.Parent =
        Frame

    local Accent =
        Instance.new(
            "Frame"
        )

    Accent.Name =
        "MirrorsV5Accent"

    Accent.AnchorPoint =
        Vector2.new(
            0.5,
            1
        )

    Accent.Position =
        UDim2.new(
            0.5,
            0,
            1,
            -1
        )

    Accent.Size =
        UDim2.new(
            0.48,
            0,
            0,
            2
        )

    Accent.BackgroundColor3 =
        C.White

    Accent.BorderSizePixel =
        0

    Accent.ZIndex =
        100

    Accent.Parent =
        Frame

    local AccentCorner =
        Instance.new(
            "UICorner"
        )

    AccentCorner.CornerRadius =
        UDim.new(
            1,
            0
        )

    AccentCorner.Parent =
        Accent

    local AccentGradient =
        Instance.new(
            "UIGradient"
        )

    AccentGradient.Color =
        ColorSequence.new({
            ColorSequenceKeypoint.new(
                0,
                C.PurpleDark
            ),

            ColorSequenceKeypoint.new(
                0.25,
                C.Purple
            ),

            ColorSequenceKeypoint.new(
                0.5,
                C.White
            ),

            ColorSequenceKeypoint.new(
                0.72,
                C.PurpleVivid
            ),

            ColorSequenceKeypoint.new(
                1,
                C.PurpleDark
            )
        })

    AccentGradient.Parent =
        Accent

    local AccentGlow =
        Instance.new(
            "UIStroke"
        )

    AccentGlow.Name =
        "MirrorsV5AccentGlow"

    AccentGlow.Thickness =
        5

    AccentGlow.Color =
        C.White

    AccentGlow.Transparency =
        0.72

    AccentGlow.Parent =
        Accent

    local Shine =
        Instance.new(
            "Frame"
        )

    Shine.Name =
        "MirrorsV5AccentShine"

    Shine.AnchorPoint =
        Vector2.new(
            0.5,
            0.5
        )

    Shine.Position =
        UDim2.fromScale(
            -0.2,
            0.5
        )

    Shine.Size =
        UDim2.new(
            0.16,
            0,
            0,
            2
        )

    Shine.BackgroundColor3 =
        C.White

    Shine.BorderSizePixel =
        0

    Shine.ZIndex =
        101

    Shine.Parent =
        Accent

    local ShineGradient =
        Instance.new(
            "UIGradient"
        )

    ShineGradient.Transparency =
        NumberSequence.new({
            NumberSequenceKeypoint.new(
                0,
                1
            ),

            NumberSequenceKeypoint.new(
                0.5,
                0
            ),

            NumberSequenceKeypoint.new(
                1,
                1
            )
        })

    ShineGradient.Parent =
        Shine

    Custom.Background =
        Background

    Custom.Tint =
        Tint

    Custom.Shade =
        Shade

    local BackgroundMove =
        AddTween(
            TweenService:Create(
                Background,

                TweenInfo.new(
                    12,
                    Enum.EasingStyle.Sine,
                    Enum.EasingDirection.InOut,
                    -1,
                    true
                ),

                {
                    Position =
                        UDim2.fromScale(
                            0.505,
                            0.493
                        ),

                    Size =
                        UDim2.fromScale(
                            1.07,
                            1.07
                        )
                }
            )
        )

    BackgroundMove:Play()

    local TintPulse =
        AddTween(
            TweenService:Create(
                Tint,

                TweenInfo.new(
                    5,
                    Enum.EasingStyle.Sine,
                    Enum.EasingDirection.InOut,
                    -1,
                    true
                ),

                {
                    BackgroundTransparency =
                        0.9
                }
            )
        )

    TintPulse:Play()

    local BorderShine =
        AddTween(
            TweenService:Create(
                BorderGradient,

                TweenInfo.new(
                    8,
                    Enum.EasingStyle.Linear,
                    Enum.EasingDirection.InOut,
                    -1
                ),

                {
                    Rotation =
                        360
                }
            )
        )

    BorderShine:Play()

    local LineShine =
        AddTween(
            TweenService:Create(
                Shine,

                TweenInfo.new(
                    3.8,
                    Enum.EasingStyle.Sine,
                    Enum.EasingDirection.InOut,
                    -1
                ),

                {
                    Position =
                        UDim2.fromScale(
                            1.2,
                            0.5
                        )
                }
            )
        )

    LineShine:Play()
end

local function StyleOpenButton()
    local Button =
        FindGuiButton(
            "Open Mirrors Hub - MM2"
        )

    if not Button then
        return
    end

    if Button:FindFirstChild(
        "MirrorsV5Scale"
    ) then
        return
    end

    local Scale =
        Instance.new(
            "UIScale"
        )

    Scale.Name =
        "MirrorsV5Scale"

    Scale.Scale =
        1

    Scale.Parent =
        Button

    local Glow =
        Instance.new(
            "UIStroke"
        )

    Glow.Name =
        "MirrorsV5Glow"

    Glow.Thickness =
        4

    Glow.Color =
        C.White

    Glow.Transparency =
        0.68

    Glow.Parent =
        Button

    local Dot =
        Instance.new(
            "Frame"
        )

    Dot.Name =
        "MirrorsV5Dot"

    Dot.AnchorPoint =
        Vector2.new(
            1,
            0.5
        )

    Dot.Position =
        UDim2.new(
            1,
            -12,
            0.5,
            0
        )

    Dot.Size =
        UDim2.fromOffset(
            6,
            6
        )

    Dot.BackgroundColor3 =
        C.White

    Dot.BorderSizePixel =
        0

    Dot.Parent =
        Button

    local DotCorner =
        Instance.new(
            "UICorner"
        )

    DotCorner.CornerRadius =
        UDim.new(
            1,
            0
        )

    DotCorner.Parent =
        Dot

    local DotGlow =
        Instance.new(
            "UIStroke"
        )

    DotGlow.Thickness =
        5

    DotGlow.Color =
        C.White

    DotGlow.Transparency =
        0.63

    DotGlow.Parent =
        Dot

    local GlowTween =
        AddTween(
            TweenService:Create(
                Glow,

                TweenInfo.new(
                    2.5,
                    Enum.EasingStyle.Sine,
                    Enum.EasingDirection.InOut,
                    -1,
                    true
                ),

                {
                    Transparency =
                        0.35
                }
            )
        )

    GlowTween:Play()

    local DotTween =
        AddTween(
            TweenService:Create(
                Dot,

                TweenInfo.new(
                    1.6,
                    Enum.EasingStyle.Sine,
                    Enum.EasingDirection.InOut,
                    -1,
                    true
                ),

                {
                    BackgroundTransparency =
                        0.35,

                    Size =
                        UDim2.fromOffset(
                            8,
                            8
                        )
                }
            )
        )

    DotTween:Play()

    AddConnection(
        Button.Activated:Connect(
            function()
                TweenService:Create(
                    Scale,

                    TweenInfo.new(
                        0.18,
                        Enum.EasingStyle.Back,
                        Enum.EasingDirection.Out
                    ),

                    {
                        Scale = 1.07
                    }
                ):Play()

                TweenService:Create(
                    Glow,

                    TweenInfo.new(
                        0.12
                    ),

                    {
                        Transparency =
                            0.1
                    }
                ):Play()

                task.delay(
                    0.16,
                    function()
                        if not Scale.Parent then
                            return
                        end

                        TweenService:Create(
                            Scale,

                            TweenInfo.new(
                                0.2,
                                Enum.EasingStyle.Back,
                                Enum.EasingDirection.Out
                            ),

                            {
                                Scale = 1
                            }
                        ):Play()

                        TweenService:Create(
                            Glow,

                            TweenInfo.new(
                                0.35
                            ),

                            {
                                Transparency =
                                    0.55
                            }
                        ):Play()
                    end
                )
            end
        )
    )
end

local General =
    Window:Section({
        Title = "GENERAL",
        Opened = true
    })

local Roles =
    Window:Section({
        Title = "ROLES",
        Opened = true
    })

local System =
    Window:Section({
        Title = "SYSTEM",
        Opened = true
    })

local Tabs = {}

Tabs.Info =
    General:Tab({
        Title = "Info",
        Desc = "Overview",

        Icon =
            "solar:info-square-bold",

        IconColor =
            TAB_COLORS.Info,

        IconShape =
            "Square",

        Border = true
    })

Tabs.Main =
    General:Tab({
        Title = "Main",
        Desc = "Gameplay",

        Icon =
            "solar:home-2-bold",

        IconColor =
            TAB_COLORS.Main,

        IconShape =
            "Square",

        Border = true
    })

Tabs.ESP =
    General:Tab({
        Title = "ESP",
        Desc = "Visuals",

        Icon =
            "solar:eye-bold",

        IconColor =
            TAB_COLORS.ESP,

        IconShape =
            "Square",

        Border = true
    })

Tabs.Murder =
    Roles:Tab({
        Title = "Murder",
        Desc = "Role tools",

        Icon =
            "solar:target-bold",

        IconColor =
            TAB_COLORS.Murder,

        IconShape =
            "Square",

        Border = true
    })

Tabs.Sheriff =
    Roles:Tab({
        Title = "Sheriff",
        Desc = "Defense",

        Icon =
            "solar:shield-check-bold",

        IconColor =
            TAB_COLORS.Sheriff,

        IconShape =
            "Square",

        Border = true
    })

Tabs.Innocent =
    Roles:Tab({
        Title = "Innocent",
        Desc = "Survival",

        Icon =
            "solar:user-bold",

        IconColor =
            TAB_COLORS.Innocent,

        IconShape =
            "Square",

        Border = true
    })

Tabs.Shortcuts =
    System:Tab({
        Title = "Shortcuts",
        Desc = "Quick actions",

        Icon =
            "solar:cursor-square-bold",

        IconColor =
            TAB_COLORS.Shortcuts,

        IconShape =
            "Square",

        Border = true
    })

Tabs.Misc =
    System:Tab({
        Title = "Misc",
        Desc = "Utilities",

        Icon =
            "solar:widget-5-bold",

        IconColor =
            TAB_COLORS.Misc,

        IconShape =
            "Square",

        Border = true
    })

Tabs.Config =
    System:Tab({
        Title = "Config",
        Desc = "Settings",

        Icon =
            "solar:settings-bold",

        IconColor =
            TAB_COLORS.Config,

        IconShape =
            "Square",

        Border = true
    })

local function Header(Tab, Title)
    Tab:Section({
        Title = Title,

        TextSize = 18,

        FontWeight =
            Enum.FontWeight.SemiBold
    })

    Tab:Space()
end

local function Box(
    Tab,
    Title,
    Desc
)
    return Tab:Section({
        Title = Title,
        Desc = Desc,

        Box = true,
        BoxBorder = true,
        Opened = true
    })
end

local function Action(
    Parent,
    Title,
    Icon,
    Color,
    Callback
)
    return Parent:Button({
        Title = Title,

        Icon = Icon,

        IconAlign = "Left",

        Justify = "Center",

        Color = Color,

        Callback = Callback
    })
end

local function Preview(Name)
    Notify(
        "Mirrors Hub",
        Name .. " • visual test",
        "solar:stars-bold",
        2
    )
end

local Avatar = ""

pcall(function()
    Avatar =
        Players:GetUserThumbnailAsync(
            LP.UserId,

            Enum.ThumbnailType.HeadShot,

            Enum.ThumbnailSize.Size100x100
        )
end)

local function GetPing()
    local Success, Value =
        pcall(function()
            return Stats
                .Network
                .ServerStatsItem[
                    "Data Ping"
                ]
                :GetValue()
        end)

    if Success then
        return math.floor(Value)
    end

    return 0
end

Header(
    Tabs.Info,
    "Information"
)

local PlayerBox =
    Box(
        Tabs.Info,
        "Player",
        "Current session"
    )

PlayerBox:Paragraph({
    Title =
        LP.DisplayName,

    Desc =
        "@"
        .. LP.Name
        .. "\nUser ID: "
        .. tostring(LP.UserId),

    Image =
        Avatar,

    ImageSize =
        42
})

Tabs.Info:Space()

local StatusBox =
    Box(
        Tabs.Info,
        "Live Status",
        "Mirrors Hub"
    )

local StatusParagraph =
    StatusBox:Paragraph({
        Title =
            "Mirrors Hub - MM2",

        Desc =
            "Loading...",

        Image =
            "solar:stars-bold",

        ImageSize =
            21
    })

task.spawn(function()
    while Runtime.Alive do
        StatusParagraph:SetDesc(
            "Version: v1.6.1 • BETA"
            .. "\nPlayers: "
            .. #Players:GetPlayers()
            .. "/"
            .. tostring(
                Players.MaxPlayers
            )
            .. "\nPing: "
            .. GetPing()
            .. " ms"
            .. "\nPlace ID: "
            .. tostring(
                game.PlaceId
            )
        )

        task.wait(1)
    end
end)

Header(
    Tabs.Main,
    "Main"
)

local MainCore =
    Box(
        Tabs.Main,
        "Gameplay",
        "Core features"
    )

MainCore:Toggle({
    Title = "Coin Farm",

    Desc =
        "Automatically collect available coins.",

    Value = false,

    Flag =
        "V5_Main_CoinFarm",

    Callback =
        function()
        end
})

MainCore:Space()

MainCore:Toggle({
    Title = "Aim Assist",

    Desc =
        "Enable targeting assistance.",

    Value = false,

    Flag =
        "V5_Main_AimAssist",

    Callback =
        function()
        end
})

Tabs.Main:Space()

local PlayerActions =
    Tabs.Main:Group({})

Action(
    PlayerActions,

    "Player Fling",

    "solar:square-transfer-horizontal-bold",

    C.Purple,

    function()
        Preview(
            "Player Fling"
        )
    end
)

PlayerActions:Space()

Action(
    PlayerActions,

    "Fling All",

    "solar:bolt-bold",

    C.Pink,

    function()
        Preview(
            "Fling All"
        )
    end
)

Header(
    Tabs.ESP,
    "ESP"
)

local EspMain =
    Box(
        Tabs.ESP,
        "Players",
        "Player rendering"
    )

EspMain:Toggle({
    Title = "Enable ESP",

    Desc =
        "Display selected player information.",

    Value = false,

    Flag =
        "V5_ESP_Enabled",

    Callback =
        function()
        end
})

EspMain:Space()

EspMain:Dropdown({
    Title = "ESP Style",

    Desc =
        "Choose rendering style.",

    Values = {
        "Highlight",
        "Drawing",
        "Both"
    },

    Value =
        "Highlight",

    Flag =
        "V5_ESP_Style",

    Callback =
        function()
        end
})

Tabs.ESP:Space()

local EspDetails =
    Box(
        Tabs.ESP,
        "Details",
        "Visible information"
    )

for _, Data in ipairs({
    {"Box", true},
    {"Name", true},
    {"Role", true},
    {"Distance", false},
    {"Tracer", false}
}) do
    EspDetails:Toggle({
        Title =
            Data[1],

        Value =
            Data[2],

        Flag =
            "V5_ESP_"
            .. Data[1],

        Callback =
            function()
            end
    })

    EspDetails:Space()
end

Tabs.ESP:Space()

local EspRange =
    Box(
        Tabs.ESP,
        "Range",
        "Maximum render distance"
    )

EspRange:Slider({
    Title =
        "ESP Distance",

    Desc =
        "Maximum visible distance.",

    Step = 5,
    Width = 190,

    IsTooltip = true,
    IsTextbox = false,

    Value = {
        Min = 25,
        Max = 500,
        Default = 250
    },

    Flag =
        "V5_ESP_Range",

    Callback =
        function()
        end
})

Header(
    Tabs.Murder,
    "Murder"
)

local MurderCombat =
    Box(
        Tabs.Murder,
        "Combat",
        "Knife features"
    )

MurderCombat:Toggle({
    Title =
        "Knife Aura",

    Desc =
        "Automatically interact with nearby targets.",

    Value = false,

    Flag =
        "V5_Murder_KnifeAura",

    Callback =
        function()
        end
})

MurderCombat:Space()

MurderCombat:Slider({
    Title =
        "Aura Radius",

    Desc =
        "Maximum nearby range.",

    Step = 1,
    Width = 190,

    IsTooltip = true,
    IsTextbox = false,

    Value = {
        Min = 2,
        Max = 50,
        Default = 15
    },

    Flag =
        "V5_Murder_AuraRadius",

    Callback =
        function()
        end
})

MurderCombat:Space()

MurderCombat:Toggle({
    Title =
        "Throw Assist",

    Desc =
        "Assist knife throw targeting.",

    Value = false,

    Flag =
        "V5_Murder_ThrowAssist",

    Callback =
        function()
        end
})

MurderCombat:Space()

MurderCombat:Toggle({
    Title =
        "Auto Throw",

    Desc =
        "Automatically trigger assisted throws.",

    Value = false,

    Flag =
        "V5_Murder_AutoThrow",

    Callback =
        function()
        end
})

Tabs.Murder:Space()

local MurderActions =
    Tabs.Murder:Group({})

Action(
    MurderActions,

    "Kill Sheriff",

    "solar:target-bold",

    C.Red,

    function()
        Preview(
            "Kill Sheriff"
        )
    end
)

MurderActions:Space()

Action(
    MurderActions,

    "Fling Sheriff",

    "solar:square-transfer-horizontal-bold",

    C.Purple,

    function()
        Preview(
            "Fling Sheriff"
        )
    end
)

Tabs.Murder:Space()

local MurderActions2 =
    Tabs.Murder:Group({})

Action(
    MurderActions2,

    "Kill Innocents",

    "solar:users-group-rounded-bold",

    C.Orange,

    function()
        Preview(
            "Kill Innocents"
        )
    end
)

MurderActions2:Space()

Action(
    MurderActions2,

    "Kill All",

    "solar:danger-triangle-bold",

    C.Red,

    function()
        Preview(
            "Kill All"
        )
    end
)

Header(
    Tabs.Sheriff,
    "Sheriff"
)

local SheriffCombat =
    Box(
        Tabs.Sheriff,
        "Defense",
        "Sheriff utilities"
    )

SheriffCombat:Toggle({
    Title =
        "Auto Shoot Murderer",

    Desc =
        "Automatically react to the current Murderer.",

    Value = false,

    Flag =
        "V5_Sheriff_AutoShoot",

    Callback =
        function()
        end
})

SheriffCombat:Space()

SheriffCombat:Toggle({
    Title =
        "Murderer ESP",

    Desc =
        "Highlight the current Murderer.",

    Value = false,

    Flag =
        "V5_Sheriff_MurderESP",

    Callback =
        function()
        end
})

SheriffCombat:Space()

SheriffCombat:Toggle({
    Title =
        "Gun Drop ESP",

    Desc =
        "Highlight the dropped gun.",

    Value = false,

    Flag =
        "V5_Sheriff_GunDrop",

    Callback =
        function()
        end
})

SheriffCombat:Space()

SheriffCombat:Toggle({
    Title =
        "Auto Escape Murderer",

    Desc =
        "Create distance when danger gets close.",

    Value = false,

    Flag =
        "V5_Sheriff_AutoEscape",

    Callback =
        function()
        end
})

Tabs.Sheriff:Space()

local SheriffActions =
    Tabs.Sheriff:Group({})

Action(
    SheriffActions,

    "Shoot Murder",

    "solar:target-bold",

    C.Blue,

    function()
        Preview(
            "Shoot Murder"
        )
    end
)

SheriffActions:Space()

Action(
    SheriffActions,

    "Fling Murder",

    "solar:square-transfer-horizontal-bold",

    C.Purple,

    function()
        Preview(
            "Fling Murder"
        )
    end
)

Header(
    Tabs.Innocent,
    "Innocent"
)

local InnocentFeatures =
    Box(
        Tabs.Innocent,
        "Survival",
        "Role utilities"
    )

InnocentFeatures:Toggle({
    Title =
        "Auto Gun",

    Desc =
        "Automatically interact with the dropped gun.",

    Value = false,

    Flag =
        "V5_Innocent_AutoGun",

    Callback =
        function()
        end
})

InnocentFeatures:Space()

InnocentFeatures:Toggle({
    Title =
        "Gun Drop ESP",

    Desc =
        "Highlight the dropped gun.",

    Value = false,

    Flag =
        "V5_Innocent_GunESP",

    Callback =
        function()
        end
})

InnocentFeatures:Space()

InnocentFeatures:Toggle({
    Title =
        "Murderer ESP",

    Desc =
        "Highlight the current Murderer.",

    Value = false,

    Flag =
        "V5_Innocent_MurderESP",

    Callback =
        function()
        end
})

InnocentFeatures:Space()

InnocentFeatures:Toggle({
    Title =
        "Sheriff ESP",

    Desc =
        "Highlight Sheriff or Hero.",

    Value = false,

    Flag =
        "V5_Innocent_SheriffESP",

    Callback =
        function()
        end
})

InnocentFeatures:Space()

InnocentFeatures:Toggle({
    Title =
        "Auto Escape Murderer",

    Desc =
        "Automatically create distance.",

    Value = false,

    Flag =
        "V5_Innocent_Escape",

    Callback =
        function()
        end
})

Tabs.Innocent:Space()

local InnocentActions =
    Tabs.Innocent:Group({})

Action(
    InnocentActions,

    "Teleport Gun",

    "solar:map-arrow-right-bold",

    C.Cyan,

    function()
        Preview(
            "Teleport Gun"
        )
    end
)

InnocentActions:Space()

Action(
    InnocentActions,

    "Teleport Sheriff",

    "solar:map-arrow-right-bold",

    C.Blue,

    function()
        Preview(
            "Teleport Sheriff"
        )
    end
)

Tabs.Innocent:Space()

local InnocentActions2 =
    Tabs.Innocent:Group({})

Action(
    InnocentActions2,

    "Fling Murder",

    "solar:square-transfer-horizontal-bold",

    C.Red,

    function()
        Preview(
            "Fling Murder"
        )
    end
)

InnocentActions2:Space()

Action(
    InnocentActions2,

    "Fling Sheriff",

    "solar:square-transfer-horizontal-bold",

    C.Purple,

    function()
        Preview(
            "Fling Sheriff"
        )
    end
)

Header(
    Tabs.Shortcuts,
    "Shortcuts"
)

local ShortcutBox =
    Box(
        Tabs.Shortcuts,
        "Floating Buttons",
        "Choose visible shortcuts"
    )

for _, Name in ipairs({
    "Shoot Murder",
    "TP Gun",
    "TP Murder",
    "TP Sheriff",
    "Fling Murder",
    "Fling Sheriff",
    "Fling All",
    "Throw Knife",
    "Kill Sheriff",
    "Kill All"
}) do
    ShortcutBox:Toggle({
        Title = Name,

        Desc =
            "Show this floating shortcut.",

        Value = false,

        Flag =
            "V5_Shortcut_"
            ..
            Name:gsub(
                "%W",
                ""
            ),

        Callback =
            function()
            end
    })

    ShortcutBox:Space()
end

Header(
    Tabs.Misc,
    "Misc"
)

local MiscUtility =
    Box(
        Tabs.Misc,
        "Utility",
        "General options"
    )

for _, Data in ipairs({
    {
        "Anti-AFK",
        "Prevent idle disconnect."
    },
    {
        "Anti-Void",
        "Recover from unsafe falls."
    },
    {
        "No Clip",
        "Disable character collision."
    }
}) do
    MiscUtility:Toggle({
        Title =
            Data[1],

        Desc =
            Data[2],

        Value = false,

        Flag =
            "V5_Misc_"
            ..
            Data[1]:gsub(
                "%W",
                ""
            ),

        Callback =
            function()
            end
    })

    MiscUtility:Space()
end

Tabs.Misc:Space()

local MiscVisual =
    Box(
        Tabs.Misc,
        "Visual",
        "Lighting and performance"
    )

for _, Data in ipairs({
    {
        "FPS Boost",
        "Reduce unnecessary visual effects."
    },
    {
        "Remove Fog",
        "Reduce atmospheric fog."
    },
    {
        "Fullbright",
        "Increase scene visibility."
    }
}) do
    MiscVisual:Toggle({
        Title =
            Data[1],

        Desc =
            Data[2],

        Value = false,

        Flag =
            "V5_Misc_"
            ..
            Data[1]:gsub(
                "%W",
                ""
            ),

        Callback =
            function()
            end
    })

    MiscVisual:Space()
end

Tabs.Misc:Space()

local Movement =
    Box(
        Tabs.Misc,
        "Movement",
        "Character values"
    )

Movement:Toggle({
    Title =
        "WalkSpeed",

    Desc =
        "Enable custom movement speed.",

    Value = false,

    Flag =
        "V5_Misc_WalkSpeedEnabled",

    Callback =
        function()
        end
})

Movement:Space()

Movement:Slider({
    Title =
        "Speed",

    Desc =
        "Movement speed.",

    Step = 1,
    Width = 190,

    IsTooltip = true,
    IsTextbox = false,

    Value = {
        Min = 16,
        Max = 100,
        Default = 32
    },

    Flag =
        "V5_Misc_WalkSpeed",

    Callback =
        function()
        end
})

Movement:Space()

Movement:Toggle({
    Title =
        "JumpPower",

    Desc =
        "Enable custom jump strength.",

    Value = false,

    Flag =
        "V5_Misc_JumpEnabled",

    Callback =
        function()
        end
})

Movement:Space()

Movement:Slider({
    Title =
        "Jump Strength",

    Desc =
        "Jump power value.",

    Step = 1,
    Width = 190,

    IsTooltip = true,
    IsTextbox = false,

    Value = {
        Min = 50,
        Max = 150,
        Default = 75
    },

    Flag =
        "V5_Misc_JumpPower",

    Callback =
        function()
        end
})

Tabs.Misc:Space()

local ServerActions =
    Tabs.Misc:Group({})

Action(
    ServerActions,

    "Rejoin",

    "solar:restart-bold",

    C.Purple,

    function()
        Preview(
            "Rejoin"
        )
    end
)

ServerActions:Space()

Action(
    ServerActions,

    "Server Hop",

    "solar:global-bold",

    C.Blue,

    function()
        Preview(
            "Server Hop"
        )
    end
)

Tabs.Misc:Space()

Action(
    Tabs.Misc,

    "Small Server",

    "solar:users-group-rounded-bold",

    C.Cyan,

    function()
        Preview(
            "Small Server"
        )
    end
)

Header(
    Tabs.Config,
    "Configuration"
)

local Appearance =
    Box(
        Tabs.Config,
        "Appearance",
        "Mirrors Purple"
    )

Appearance:Slider({
    Title =
        "Background Visibility",

    Desc =
        "Control background artwork.",

    Step = 1,
    Width = 190,

    IsTooltip = true,
    IsTextbox = false,

    Value = {
        Min = 0,
        Max = 60,
        Default = 20
    },

    Flag =
        "V5_UI_Background",

    Callback =
        function(Value)
            Visual.BackgroundVisibility =
                Value

            ApplyWindowVisual()
        end
})

Appearance:Space()

Appearance:Slider({
    Title =
        "Glow Strength",

    Desc =
        "White glow intensity.",

    Step = 1,
    Width = 190,

    IsTooltip = true,
    IsTextbox = false,

    Value = {
        Min = 0,
        Max = 100,
        Default = 78
    },

    Flag =
        "V5_UI_Glow",

    Callback =
        function(Value)
            Visual.Glow =
                Value

            ApplyWindowVisual()
        end
})

Appearance:Space()

Appearance:Slider({
    Title =
        "Purple Vibrance",

    Desc =
        "Purple color intensity.",

    Step = 1,
    Width = 190,

    IsTooltip = true,
    IsTextbox = false,

    Value = {
        Min = 20,
        Max = 100,
        Default = 74
    },

    Flag =
        "V5_UI_Vibrance",

    Callback =
        function(Value)
            Visual.Vibrance =
                Value
        end
})

Appearance:Space()

Appearance:Slider({
    Title =
        "Glass",

    Desc =
        "Dark glass strength.",

    Step = 1,
    Width = 190,

    IsTooltip = true,
    IsTextbox = false,

    Value = {
        Min = 0,
        Max = 100,
        Default = 50
    },

    Flag =
        "V5_UI_Glass",

    Callback =
        function(Value)
            Visual.Glass =
                Value

            ApplyWindowVisual()
        end
})

Tabs.Config:Space()

local Interface =
    Box(
        Tabs.Config,
        "Interface",
        "Behavior and scale"
    )

Interface:Slider({
    Title =
        "UI Scale",

    Desc =
        "Interface scale.",

    Step = 0.05,
    Width = 190,

    IsTooltip = true,
    IsTextbox = false,

    Value = {
        Min = 0.75,
        Max = 1.15,
        Default = 1
    },

    Flag =
        "V5_UI_Scale",

    Callback =
        function(Value)
            pcall(function()
                Window:SetUIScale(
                    Value
                )
            end)
        end
})

Interface:Space()

Interface:Toggle({
    Title =
        "Notifications",

    Desc =
        "Show Mirrors Hub notifications.",

    Value = true,

    Flag =
        "V5_UI_Notifications",

    Callback =
        function(Value)
            Runtime.Notifications =
                Value
        end
})

Interface:Space()

Interface:Keybind({
    Title =
        "Toggle UI Key",

    Desc =
        "Keyboard shortcut.",

    Value =
        "K",

    Flag =
        "V5_UI_ToggleKey",

    Callback =
        function(Value)

            local Name =
                tostring(Value):
                    gsub(
                        "Enum.KeyCode%.",
                        ""
                    )

            local Key =
                Enum.KeyCode[Name]

            if Key then
                Window:SetToggleKey(
                    Key
                )
            end
        end
})

Tabs.Config:Space()

local InterfaceActions =
    Tabs.Config:Group({})

Action(
    InterfaceActions,

    "Center Window",

    "solar:align-horizontal-center-bold",

    C.Purple,

    function()
        pcall(function()
            Window:
                SetToTheCenter()
        end)
    end
)

InterfaceActions:Space()

Action(
    InterfaceActions,

    "Reapply Visual",

    "solar:palette-bold",

    C.Pink,

    function()
        ApplyWindowVisual()

        Notify(
            "Mirrors Purple",
            "Visual reapplied.",
            "solar:palette-bold",
            2
        )
    end
)

Tabs.Config:Space()

local ConfigManager =
    Window.ConfigManager

if ConfigManager
and ConfigManager.Init then
    ConfigManager:Init(
        Window
    )
end

local ConfigName =
    "default"

local ConfigBox =
    Box(
        Tabs.Config,
        "Config Manager",
        "Profiles"
    )

ConfigBox:Input({
    Title =
        "Config Name",

    Desc =
        "Configuration profile name.",

    Value =
        ConfigName,

    Placeholder =
        "default",

    Callback =
        function(Value)

            Value =
                tostring(
                    Value or ""
                )
                :gsub(
                    "[^%w_%-]",
                    ""
                )

            if Value == "" then
                Value =
                    "default"
            end

            ConfigName =
                Value:sub(
                    1,
                    32
                )
        end
})

Tabs.Config:Space()

local ConfigActions =
    Tabs.Config:Group({})

Action(
    ConfigActions,

    "Save",

    "solar:diskette-bold",

    C.Purple,

    function()
        if not ConfigManager then
            Notify(
                "Config",
                "ConfigManager unavailable."
            )

            return
        end

        local Config =
            ConfigManager:
                CreateConfig(
                    ConfigName
                )

        Config:Save()

        Notify(
            "Config",
            ConfigName
            .. " saved.",

            "solar:diskette-bold",
            2
        )
    end
)

ConfigActions:Space()

Action(
    ConfigActions,

    "Load",

    "solar:folder-with-files-bold",

    C.Blue,

    function()
        if not ConfigManager then
            return
        end

        local Config =
            ConfigManager:
                CreateConfig(
                    ConfigName
                )

        Config:Load()

        task.delay(
            0.2,
            ApplyWindowVisual
        )

        Notify(
            "Config",
            ConfigName
            .. " loaded.",

            "solar:folder-with-files-bold",
            2
        )
    end
)

Tabs.Config:Space()

local ConfigActions2 =
    Tabs.Config:Group({})

Action(
    ConfigActions2,

    "Delete",

    "solar:trash-bin-trash-bold",

    C.Red,

    function()
        if not ConfigManager then
            return
        end

        local Config =
            ConfigManager:
                CreateConfig(
                    ConfigName
                )

        Config:Delete()

        Notify(
            "Config",
            ConfigName
            .. " deleted.",

            "solar:trash-bin-trash-bold",
            2
        )
    end
)

ConfigActions2:Space()

Action(
    ConfigActions2,

    "Reset Visual",

    "solar:restart-bold",

    C.Orange,

    function()

        Visual.BackgroundVisibility =
            20

        Visual.Glow =
            78

        Visual.Vibrance =
            74

        Visual.Glass =
            50

        pcall(function()
            Window:SetUIScale(
                1
            )
        end)

        ApplyWindowVisual()

        Notify(
            "Mirrors Purple",
            "Visual reset.",
            "solar:restart-bold",
            2
        )
    end
)

Tabs.Config:Space()

Action(
    Tabs.Config,

    "Unload Visual Test",

    "solar:power-bold",

    C.Red,

    function()
        Runtime.Cleanup()
    end
)

local TAB_TITLES = {
    "Info",
    "Main",
    "ESP",
    "Murder",
    "Sheriff",
    "Innocent",
    "Shortcuts",
    "Misc",
    "Config"
}

local SelectedTab =
    "Info"

local function FindIconContainer(Button)
    local Best
    local BestArea =
        math.huge

    for _, Object in ipairs(
        Button:GetDescendants()
    ) do
        if Object:IsA("ImageLabel")
        or Object:IsA("ImageButton") then

            local Parent =
                Object.Parent

            for _ = 1, 3 do
                if not Parent then
                    break
                end

                if Parent:IsA("Frame") then
                    local Size =
                        Parent.AbsoluteSize

                    local Delta =
                        math.abs(
                            Size.X -
                            Size.Y
                        )

                    if
                        Size.X >= 22
                        and Size.X <= 46
                        and Size.Y >= 22
                        and Size.Y <= 46
                        and Delta <= 8
                    then
                        local Area =
                            Size.X *
                            Size.Y

                        if Area < BestArea then
                            Best =
                                Parent

                            BestArea =
                                Area
                        end
                    end
                end

                Parent =
                    Parent.Parent
            end
        end
    end

    return Best
end

local function StyleTab(
    Name,
    Color
)
    local Button =
        FindGuiButton(Name)

    if not Button then
        return
    end

    local IconContainer =
        FindIconContainer(
            Button
        )

    if IconContainer then
        IconContainer.BackgroundColor3 =
            Color

        IconContainer.BackgroundTransparency =
            0.68

        local Corner =
            IconContainer:
                FindFirstChildOfClass(
                    "UICorner"
                )

        if Corner then
            Corner.CornerRadius =
                UDim.new(
                    0,
                    9
                )
        end

        if not IconContainer:FindFirstChild(
            "MirrorsV5IconEdge"
        ) then
            local Edge =
                Instance.new(
                    "UIStroke"
                )

            Edge.Name =
                "MirrorsV5IconEdge"

            Edge.Thickness =
                1

            Edge.Color =
                Color

            Edge.Transparency =
                0.15

            Edge.Parent =
                IconContainer
        end

        if not IconContainer:FindFirstChild(
            "MirrorsV5IconGlow"
        ) then
            local Glow =
                Instance.new(
                    "UIStroke"
                )

            Glow.Name =
                "MirrorsV5IconGlow"

            Glow.Thickness =
                4

            Glow.Color =
                C.White

            Glow.Transparency =
                0.8

            Glow.Parent =
                IconContainer
        end

        for _, Child in ipairs(
            IconContainer:GetDescendants()
        ) do
            if Child:IsA("ImageLabel")
            or Child:IsA("ImageButton") then
                Child.ImageColor3 =
                    C.White
            end
        end
    end

    local function ApplySelected()
        RemoveIfExists(
            Button,
            "MirrorsV5SelectedEdge"
        )

        RemoveIfExists(
            Button,
            "MirrorsV5SelectedGlow"
        )

        if SelectedTab ~= Name then
            return
        end

        local Edge =
            Instance.new(
                "UIStroke"
            )

        Edge.Name =
            "MirrorsV5SelectedEdge"

        Edge.Thickness =
            1.2

        Edge.Color =
            C.White

        Edge.Transparency =
            0.15

        Edge.Parent =
            Button

        local Glow =
            Instance.new(
                "UIStroke"
            )

        Glow.Name =
            "MirrorsV5SelectedGlow"

        Glow.Thickness =
            4.5

        Glow.Color =
            C.White

        Glow.Transparency =
            0.72

        Glow.Parent =
            Button
    end

    ApplySelected()

    AddConnection(
        Button.Activated:Connect(
            function()
                SelectedTab =
                    Name

                for _, OtherName in ipairs(
                    TAB_TITLES
                ) do
                    local Other =
                        FindGuiButton(
                            OtherName
                        )

                    if Other then
                        RemoveIfExists(
                            Other,
                            "MirrorsV5SelectedEdge"
                        )

                        RemoveIfExists(
                            Other,
                            "MirrorsV5SelectedGlow"
                        )
                    end
                end

                ApplySelected()
            end
        )
    )
end

local function StyleSidebarSections()
    for _, Name in ipairs({
        "GENERAL",
        "ROLES",
        "SYSTEM"
    }) do
        local Label =
            FindGuiText(Name)

        if Label then
            Label.TextColor3 =
                C.White

            Label.TextTransparency =
                0.18

            local Parent =
                Label.Parent

            if Parent
            and Parent:IsA("GuiObject")
            and not Parent:FindFirstChild(
                "MirrorsV5SectionLine"
            ) then

                local Line =
                    Instance.new(
                        "Frame"
                    )

                Line.Name =
                    "MirrorsV5SectionLine"

                Line.AnchorPoint =
                    Vector2.new(
                        0.5,
                        1
                    )

                Line.Position =
                    UDim2.new(
                        0.5,
                        0,
                        1,
                        -1
                    )

                Line.Size =
                    UDim2.new(
                        0.82,
                        0,
                        0,
                        1
                    )

                Line.BackgroundColor3 =
                    C.Purple

                Line.BackgroundTransparency =
                    0.3

                Line.BorderSizePixel =
                    0

                Line.Parent =
                    Parent
            end
        end
    end
end

local ACTION_TITLES = {
    "Player Fling",
    "Fling All",
    "Kill Sheriff",
    "Fling Sheriff",
    "Kill Innocents",
    "Kill All",
    "Shoot Murder",
    "Fling Murder",
    "Teleport Gun",
    "Teleport Sheriff",
    "Rejoin",
    "Server Hop",
    "Small Server",
    "Center Window",
    "Reapply Visual",
    "Save",
    "Load",
    "Delete",
    "Reset Visual",
    "Unload Visual Test"
}

local function StyleActionButton(Title)
    local Button =
        FindGuiButton(
            Title
        )

    if not Button then
        return
    end

    if Button:FindFirstChild(
        "MirrorsV5ButtonScale"
    ) then
        return
    end

    local Scale =
        Instance.new(
            "UIScale"
        )

    Scale.Name =
        "MirrorsV5ButtonScale"

    Scale.Scale =
        1

    Scale.Parent =
        Button

    local Glow =
        Instance.new(
            "UIStroke"
        )

    Glow.Name =
        "MirrorsV5ButtonGlow"

    Glow.Thickness =
        4

    Glow.Color =
        C.White

    Glow.Transparency =
        0.88

    Glow.Parent =
        Button

    AddConnection(
        Button.MouseEnter:Connect(
            function()
                TweenService:Create(
                    Glow,

                    TweenInfo.new(
                        0.18
                    ),

                    {
                        Transparency =
                            0.62
                    }
                ):Play()
            end
        )
    )

    AddConnection(
        Button.MouseLeave:Connect(
            function()
                TweenService:Create(
                    Glow,

                    TweenInfo.new(
                        0.2
                    ),

                    {
                        Transparency =
                            0.88
                    }
                ):Play()
            end
        )
    )

    AddConnection(
        Button.Activated:Connect(
            function()
                TweenService:Create(
                    Scale,

                    TweenInfo.new(
                        0.17,
                        Enum.EasingStyle.Back,
                        Enum.EasingDirection.Out
                    ),

                    {
                        Scale = 1.055
                    }
                ):Play()

                TweenService:Create(
                    Glow,

                    TweenInfo.new(
                        0.1
                    ),

                    {
                        Transparency =
                            0.3
                    }
                ):Play()

                task.delay(
                    0.15,
                    function()
                        if not Scale.Parent then
                            return
                        end

                        TweenService:Create(
                            Scale,

                            TweenInfo.new(
                                0.2,
                                Enum.EasingStyle.Back,
                                Enum.EasingDirection.Out
                            ),

                            {
                                Scale = 1
                            }
                        ):Play()

                        TweenService:Create(
                            Glow,

                            TweenInfo.new(
                                0.28
                            ),

                            {
                                Transparency =
                                    0.82
                            }
                        ):Play()
                    end
                )
            end
        )
    )
end

local SECTION_TITLES = {
    "Player",
    "Live Status",
    "Gameplay",
    "Players",
    "Details",
    "Range",
    "Combat",
    "Defense",
    "Survival",
    "Floating Buttons",
    "Utility",
    "Visual",
    "Movement",
    "Appearance",
    "Interface",
    "Config Manager"
}

local function StyleCard(Title)
    local Label =
        FindGuiText(
            Title
        )

    if not Label then
        return
    end

    local Parent =
        Label.Parent

    for _ = 1, 6 do
        if not Parent then
            return
        end

        if Parent:IsA("Frame") then
            local Size =
                Parent.AbsoluteSize

            if
                Size.X >= 250
                and Size.Y >= 45
            then
                if not Parent:FindFirstChild(
                    "MirrorsV5CardGlow"
                ) then

                    local Glow =
                        Instance.new(
                            "UIStroke"
                        )

                    Glow.Name =
                        "MirrorsV5CardGlow"

                    Glow.Thickness =
                        3

                    Glow.Color =
                        C.White

                    Glow.Transparency =
                        0.9

                    Glow.Parent =
                        Parent

                    AddConnection(
                        Parent.MouseEnter:Connect(
                            function()
                                TweenService:Create(
                                    Glow,

                                    TweenInfo.new(
                                        0.2
                                    ),

                                    {
                                        Transparency =
                                            0.73
                                    }
                                ):Play()
                            end
                        )
                    )

                    AddConnection(
                        Parent.MouseLeave:Connect(
                            function()
                                TweenService:Create(
                                    Glow,

                                    TweenInfo.new(
                                        0.2
                                    ),

                                    {
                                        Transparency =
                                            0.9
                                    }
                                ):Play()
                            end
                        )
                    )
                end

                return
            end
        end

        Parent =
            Parent.Parent
    end
end

local function StyleScrollbars()
    for _, Root in ipairs(GetGuiRoots()) do
        for _, Object in ipairs(
            Root:GetDescendants()
        ) do
            if Object:IsA(
                "ScrollingFrame"
            ) then

                Object.ScrollBarThickness =
                    2

                Object.ScrollBarImageColor3 =
                    Color3.fromHex(
                        "#858189"
                    )

                Object.ScrollBarImageTransparency =
                    1

                local Token = 0

                AddConnection(
                    Object:
                        GetPropertyChangedSignal(
                            "CanvasPosition"
                        )
                        :Connect(
                            function()
                                Token += 1

                                local Current =
                                    Token

                                Object.ScrollBarImageTransparency =
                                    0.28

                                task.delay(
                                    0.6,
                                    function()
                                        if
                                            not Object.Parent
                                            or Current ~= Token
                                        then
                                            return
                                        end

                                        TweenService:Create(
                                            Object,

                                            TweenInfo.new(
                                                0.25
                                            ),

                                            {
                                                ScrollBarImageTransparency =
                                                    1
                                            }
                                        ):Play()
                                    end
                                )
                            end
                        )
                )
            end
        end
    end
end

local function ApplyDetailedStyle()
    ApplyWindowVisual()

    StyleOpenButton()

    StyleSidebarSections()

    for Name, Color in pairs(
        TAB_COLORS
    ) do
        StyleTab(
            Name,
            Color
        )
    end

    for _, Title in ipairs(
        ACTION_TITLES
    ) do
        StyleActionButton(
            Title
        )
    end

    for _, Title in ipairs(
        SECTION_TITLES
    ) do
        StyleCard(
            Title
        )
    end

    StyleScrollbars()
end

Tabs.Info:Select()

task.delay(
    1,
    function()
        if not Runtime.Alive then
            return
        end

        ApplyDetailedStyle()

        Notify(
            "Mirrors Hub - MM2",
            "Mirrors Purple V5 loaded.",
            "solar:stars-bold",
            3
        )
    end
)

if Window.OnDestroy then
    Window:OnDestroy(
        function()
            if Runtime.Alive then
                Runtime.Cleanup()
            end
        end
    )
end

end)
