local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Robox = {}
Robox.__index = Robox

local Themes = {
    White = {
        Background = Color3.fromRGB(10, 10, 10),
        Secondary = Color3.fromRGB(15, 15, 15),
        Tertiary = Color3.fromRGB(20, 20, 20),
        Accent = Color3.fromRGB(255, 255, 255),
        AccentGlow = Color3.fromRGB(255, 255, 255),
        CloseIcon = "rbxassetid://119857977550721",
        MinimizeIcon = "rbxassetid://83728983492706",
        TitleIcon = "rbxassetid://108135968499852"
    },
    Grey = {
        Background = Color3.fromRGB(10, 10, 10),
        Secondary = Color3.fromRGB(15, 15, 15),
        Tertiary = Color3.fromRGB(20, 20, 20),
        Accent = Color3.fromRGB(150, 150, 150),
        AccentGlow = Color3.fromRGB(180, 180, 180),
        CloseIcon = "rbxassetid://118488476815314",
        MinimizeIcon = "rbxassetid://77736908524347",
        TitleIcon = "rbxassetid://86139502550336"
    },
    Cyan = {
        Background = Color3.fromRGB(10, 10, 10),
        Secondary = Color3.fromRGB(15, 15, 15),
        Tertiary = Color3.fromRGB(20, 20, 20),
        Accent = Color3.fromRGB(0, 255, 255),
        AccentGlow = Color3.fromRGB(0, 200, 255),
        CloseIcon = "rbxassetid://131578543366323",
        MinimizeIcon = "rbxassetid://103650153658551",
        TitleIcon = "rbxassetid://80628691584705"
    },
    Red = {
        Background = Color3.fromRGB(10, 10, 10),
        Secondary = Color3.fromRGB(15, 15, 15),
        Tertiary = Color3.fromRGB(20, 20, 20),
        Accent = Color3.fromRGB(255, 50, 80),
        AccentGlow = Color3.fromRGB(255, 80, 100),
        CloseIcon = "rbxassetid://127402339181958",
        MinimizeIcon = "rbxassetid://129940147514754",
        TitleIcon = "rbxassetid://77670841485007"
    },
    Yellow = {
        Background = Color3.fromRGB(10, 10, 10),
        Secondary = Color3.fromRGB(15, 15, 15),
        Tertiary = Color3.fromRGB(20, 20, 20),
        Accent = Color3.fromRGB(255, 220, 0),
        AccentGlow = Color3.fromRGB(255, 200, 0),
        CloseIcon = "rbxassetid://127236217049716",
        MinimizeIcon = "rbxassetid://86276743363769",
        TitleIcon = "rbxassetid://89005109714253"
    },
    Green = {
        Background = Color3.fromRGB(10, 10, 10),
        Secondary = Color3.fromRGB(15, 15, 15),
        Tertiary = Color3.fromRGB(20, 20, 20),
        Accent = Color3.fromRGB(0, 255, 150),
        AccentGlow = Color3.fromRGB(0, 230, 130),
        CloseIcon = "rbxassetid://120286788820616",
        MinimizeIcon = "rbxassetid://104718581334440",
        TitleIcon = "rbxassetid://136408220068657"
    },
    Pink = {
        Background = Color3.fromRGB(10, 10, 10),
        Secondary = Color3.fromRGB(15, 15, 15),
        Tertiary = Color3.fromRGB(20, 20, 20),
        Accent = Color3.fromRGB(255, 100, 200),
        AccentGlow = Color3.fromRGB(255, 120, 210),
        CloseIcon = "rbxassetid://82910073100769",
        MinimizeIcon = "rbxassetid://83860826595551",
        TitleIcon = "rbxassetid://135652338421844"
    }
}

function Robox.new(config)
    local self = setmetatable({}, Robox)
    self.Theme = Themes[config.Theme] or Themes.Cyan
    self.Title = config.Title or "Robox UI"
    self.Subtitle = config.Subtitle or "Interface"
    self.Minimized = false
    self.Visible = true
    self.Tabs = {}
    self.Notifications = {}
    self.ValidKey = config.Key or "DiamondHub2024"
    self:CreateScreenGui()
    spawn(function()
        self:ShowLoadingScreen()
    end)
    return self
end

function Robox:CreateScreenGui()
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "RoboxUI"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    local success = pcall(function()
        self.ScreenGui.Parent = game:GetService("CoreGui")
    end)
    if not success then
        self.ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end
end

function Robox:ShowLoadingScreen()
    local LoadingFrame = Instance.new("Frame")
    LoadingFrame.Name = "LoadingFrame"
    LoadingFrame.Size = UDim2.new(0, 400, 0, 250)
    LoadingFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
    LoadingFrame.BackgroundColor3 = self.Theme.Secondary
    LoadingFrame.BackgroundTransparency = 0.1
    LoadingFrame.BorderSizePixel = 0
    LoadingFrame.Parent = self.ScreenGui
    local LoadingCorner = Instance.new("UICorner")
    LoadingCorner.CornerRadius = UDim.new(0, 12)
    LoadingCorner.Parent = LoadingFrame
    local LoadingStroke = Instance.new("UIStroke")
    LoadingStroke.Color = self.Theme.Accent
    LoadingStroke.Thickness = 2
    LoadingStroke.Transparency = 0.5
    LoadingStroke.Parent = LoadingFrame
    local LoadingGlow = Instance.new("ImageLabel")
    LoadingGlow.Size = UDim2.new(1, 40, 1, 40)
    LoadingGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
    LoadingGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    LoadingGlow.BackgroundTransparency = 1
    LoadingGlow.Image = "rbxassetid://5028857084"
    LoadingGlow.ImageColor3 = self.Theme.Accent
    LoadingGlow.ImageTransparency = 0.7
    LoadingGlow.ScaleType = Enum.ScaleType.Slice
    LoadingGlow.SliceCenter = Rect.new(24, 24, 276, 276)
    LoadingGlow.ZIndex = 0
    LoadingGlow.Parent = LoadingFrame
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, 0, 0, 30)
    TitleLabel.Position = UDim2.new(0, 0, 0, 40)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "Diamond Hub"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 24
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Parent = LoadingFrame
    local LoadingIcon = Instance.new("ImageLabel")
    LoadingIcon.Size = UDim2.new(0, 60, 0, 60)
    LoadingIcon.Position = UDim2.new(0.5, -30, 0, 90)
    LoadingIcon.BackgroundTransparency = 1
    LoadingIcon.Image = self.Theme.TitleIcon
    LoadingIcon.ImageColor3 = self.Theme.Accent
    LoadingIcon.Parent = LoadingFrame
    local IconGlow = Instance.new("ImageLabel")
    IconGlow.Size = UDim2.new(1, 20, 1, 20)
    IconGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
    IconGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    IconGlow.BackgroundTransparency = 1
    IconGlow.Image = "rbxassetid://5028857084"
    IconGlow.ImageColor3 = self.Theme.Accent
    IconGlow.ImageTransparency = 0.4
    IconGlow.ScaleType = Enum.ScaleType.Slice
    IconGlow.SliceCenter = Rect.new(24, 24, 276, 276)
    IconGlow.ZIndex = 0
    IconGlow.Parent = LoadingIcon
    local LoadingBarBG = Instance.new("Frame")
    LoadingBarBG.Size = UDim2.new(0, 320, 0, 6)
    LoadingBarBG.Position = UDim2.new(0.5, -160, 1, -50)
    LoadingBarBG.BackgroundColor3 = self.Theme.Tertiary
    LoadingBarBG.BackgroundTransparency = 0.2
    LoadingBarBG.BorderSizePixel = 0
    LoadingBarBG.Parent = LoadingFrame
    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = LoadingBarBG
    local LoadingBarFill = Instance.new("Frame")
    LoadingBarFill.Size = UDim2.new(0, 0, 1, 0)
    LoadingBarFill.BackgroundColor3 = self.Theme.Accent
    LoadingBarFill.BackgroundTransparency = 0.1
    LoadingBarFill.BorderSizePixel = 0
    LoadingBarFill.Parent = LoadingBarBG
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = LoadingBarFill
    local FillGlow = Instance.new("ImageLabel")
    FillGlow.Size = UDim2.new(1, 30, 1, 30)
    FillGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
    FillGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    FillGlow.BackgroundTransparency = 1
    FillGlow.Image = "rbxassetid://5028857084"
    FillGlow.ImageColor3 = self.Theme.Accent
    FillGlow.ImageTransparency = 0.5
    FillGlow.ScaleType = Enum.ScaleType.Slice
    FillGlow.SliceCenter = Rect.new(24, 24, 276, 276)
    FillGlow.ZIndex = 0
    FillGlow.Parent = LoadingBarFill
    local fillTween = TweenService:Create(LoadingBarFill, TweenInfo.new(5, Enum.EasingStyle.Linear), {
        Size = UDim2.new(1, 0, 1, 0)
    })
    fillTween:Play()
    fillTween.Completed:Connect(function()
        task.wait(0.2)
        local closeTween = TweenService:Create(LoadingFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 400, 0, 0),
            Position = UDim2.new(0.5, -200, 0.5, 0)
        })
        closeTween:Play()
        closeTween.Completed:Connect(function()
            LoadingFrame:Destroy()
            self:ShowKeyScreen()
        end)
    end)
end

function Robox:ShowKeyScreen()
    local KeyFrame = Instance.new("Frame")
    KeyFrame.Name = "KeyFrame"
    KeyFrame.Size = UDim2.new(0, 0, 0, 0)
    KeyFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    KeyFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    KeyFrame.BackgroundColor3 = self.Theme.Secondary
    KeyFrame.BackgroundTransparency = 0.1
    KeyFrame.BorderSizePixel = 0
    KeyFrame.ClipsDescendants = true
    KeyFrame.Parent = self.ScreenGui
    local KeyCorner = Instance.new("UICorner")
    KeyCorner.CornerRadius = UDim.new(0, 12)
    KeyCorner.Parent = KeyFrame
    local KeyStroke = Instance.new("UIStroke")
    KeyStroke.Color = self.Theme.Accent
    KeyStroke.Thickness = 2
    KeyStroke.Transparency = 0.5
    KeyStroke.Parent = KeyFrame
    local KeyGlow = Instance.new("ImageLabel")
    KeyGlow.Size = UDim2.new(1, 40, 1, 40)
    KeyGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
    KeyGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    KeyGlow.BackgroundTransparency = 1
    KeyGlow.Image = "rbxassetid://5028857084"
    KeyGlow.ImageColor3 = self.Theme.Accent
    KeyGlow.ImageTransparency = 0.7
    KeyGlow.ScaleType = Enum.ScaleType.Slice
    KeyGlow.SliceCenter = Rect.new(24, 24, 276, 276)
    KeyGlow.ZIndex = 0
    KeyGlow.Parent = KeyFrame
    local KeyIcon = Instance.new("ImageLabel")
    KeyIcon.Size = UDim2.new(0, 40, 0, 40)
    KeyIcon.Position = UDim2.new(0, 30, 0, 30)
    KeyIcon.BackgroundTransparency = 1
    KeyIcon.Image = self.Theme.TitleIcon
    KeyIcon.ImageColor3 = self.Theme.Accent
    KeyIcon.Parent = KeyFrame
    local IconGlow2 = Instance.new("ImageLabel")
    IconGlow2.Size = UDim2.new(1, 16, 1, 16)
    IconGlow2.Position = UDim2.new(0.5, 0, 0.5, 0)
    IconGlow2.AnchorPoint = Vector2.new(0.5, 0.5)
    IconGlow2.BackgroundTransparency = 1
    IconGlow2.Image = "rbxassetid://5028857084"
    IconGlow2.ImageColor3 = self.Theme.Accent
    IconGlow2.ImageTransparency = 0.4
    IconGlow2.ScaleType = Enum.ScaleType.Slice
    IconGlow2.SliceCenter = Rect.new(24, 24, 276, 276)
    IconGlow2.ZIndex = 0
    IconGlow2.Parent = KeyIcon
    local KeyTitle = Instance.new("TextLabel")
    KeyTitle.Size = UDim2.new(1, -80, 0, 40)
    KeyTitle.Position = UDim2.new(0, 80, 0, 30)
    KeyTitle.BackgroundTransparency = 1
    KeyTitle.Text = "Diamond Key"
    KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyTitle.TextSize = 20
    KeyTitle.Font = Enum.Font.GothamBold
    KeyTitle.TextXAlignment = Enum.TextXAlignment.Left
    KeyTitle.Parent = KeyFrame
    local KeyBox = Instance.new("TextBox")
    KeyBox.Size = UDim2.new(1, -60, 0, 45)
    KeyBox.Position = UDim2.new(0, 30, 0, 100)
    KeyBox.BackgroundColor3 = self.Theme.Tertiary
    KeyBox.BackgroundTransparency = 0.3
    KeyBox.BorderSizePixel = 0
    KeyBox.Text = ""
    KeyBox.PlaceholderText = "Your Key"
    KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyBox.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
    KeyBox.TextTransparency = 0
    KeyBox.PlaceholderTransparency = 0.6
    KeyBox.TextSize = 14
    KeyBox.Font = Enum.Font.GothamMedium
    KeyBox.ClearTextOnFocus = false
    KeyBox.Parent = KeyFrame
    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 8)
    BoxCorner.Parent = KeyBox
    local BoxStroke = Instance.new("UIStroke")
    BoxStroke.Color = self.Theme.Accent
    BoxStroke.Thickness = 1
    BoxStroke.Transparency = 0.8
    BoxStroke.Parent = KeyBox
    local CheckButton = Instance.new("TextButton")
    CheckButton.Size = UDim2.new(0.48, -15, 0, 45)
    CheckButton.Position = UDim2.new(0, 30, 0, 165)
    CheckButton.BackgroundColor3 = self.Theme.Accent
    CheckButton.BackgroundTransparency = 0.2
    CheckButton.BorderSizePixel = 0
    CheckButton.Text = "Check Key"
    CheckButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CheckButton.TextSize = 14
    CheckButton.Font = Enum.Font.GothamBold
    CheckButton.Parent = KeyFrame
    local CheckCorner = Instance.new("UICorner")
    CheckCorner.CornerRadius = UDim.new(0, 8)
    CheckCorner.Parent = CheckButton
    local CheckStroke = Instance.new("UIStroke")
    CheckStroke.Color = self.Theme.Accent
    CheckStroke.Thickness = 1
    CheckStroke.Transparency = 0.5
    CheckStroke.Parent = CheckButton
    local GetButton = Instance.new("TextButton")
    GetButton.Size = UDim2.new(0.48, -15, 0, 45)
    GetButton.Position = UDim2.new(0.52, 0, 0, 165)
    GetButton.BackgroundColor3 = self.Theme.Secondary
    GetButton.BackgroundTransparency = 0.3
    GetButton.BorderSizePixel = 0
    GetButton.Text = "Get Key"
    GetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    GetButton.TextSize = 14
    GetButton.Font = Enum.Font.GothamBold
    GetButton.Parent = KeyFrame
    local GetCorner = Instance.new("UICorner")
    GetCorner.CornerRadius = UDim.new(0, 8)
    GetCorner.Parent = GetButton
    local GetStroke = Instance.new("UIStroke")
    GetStroke.Color = self.Theme.Accent
    GetStroke.Thickness = 1
    GetStroke.Transparency = 0.8
    GetStroke.Parent = GetButton
    TweenService:Create(KeyFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0, 450, 0, 240)
    }):Play()
    KeyBox.Focused:Connect(function()
        TweenService:Create(BoxStroke, TweenInfo.new(0.2), {Transparency = 0.4}):Play()
    end)
    KeyBox.FocusLost:Connect(function()
        TweenService:Create(BoxStroke, TweenInfo.new(0.2), {Transparency = 0.8}):Play()
    end)
    CheckButton.MouseEnter:Connect(function()
        TweenService:Create(CheckButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.1}):Play()
        TweenService:Create(CheckStroke, TweenInfo.new(0.2), {Transparency = 0.3}):Play()
    end)
    CheckButton.MouseLeave:Connect(function()
        TweenService:Create(CheckButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
        TweenService:Create(CheckStroke, TweenInfo.new(0.2), {Transparency = 0.5}):Play()
    end)
    GetButton.MouseEnter:Connect(function()
        TweenService:Create(GetButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.15}):Play()
        TweenService:Create(GetStroke, TweenInfo.new(0.2), {Transparency = 0.6}):Play()
    end)
    GetButton.MouseLeave:Connect(function()
        TweenService:Create(GetButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
        TweenService:Create(GetStroke, TweenInfo.new(0.2), {Transparency = 0.8}):Play()
    end)
    CheckButton.MouseButton1Click:Connect(function()
        if KeyBox.Text == self.ValidKey then
            local closeTween = TweenService:Create(KeyFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Size = UDim2.new(0, 0, 0, 0)
            })
            closeTween:Play()
            closeTween.Completed:Connect(function()
                KeyFrame:Destroy()
                self:CreateWindow()
                self:SetupToggleKey()
            end)
        else
            TweenService:Create(KeyFrame, TweenInfo.new(0.05), {
                Position = UDim2.new(0.5, -10, 0.5, 0)
            }):Play()
            task.wait(0.05)
            TweenService:Create(KeyFrame, TweenInfo.new(0.05), {
                Position = UDim2.new(0.5, 10, 0.5, 0)
            }):Play()
            task.wait(0.05)
            TweenService:Create(KeyFrame, TweenInfo.new(0.05), {
                Position = UDim2.new(0.5, 0, 0.5, 0)
            }):Play()
        end
    end)
    GetButton.MouseButton1Click:Connect(function()
        pcall(function()
            setclipboard(self.ValidKey)
        end)
    end)
end

function Robox:CreateWindow()
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.new(0, 650, 0, 450)
    self.MainFrame.Position = UDim2.new(0.5, -325, 0.5, -225)
    self.MainFrame.BackgroundColor3 = self.Theme.Background
    self.MainFrame.BackgroundTransparency = 0.05
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Parent = self.ScreenGui
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = self.MainFrame
    local OuterGlow = Instance.new("ImageLabel")
    OuterGlow.Name = "OuterGlow"
    OuterGlow.Size = UDim2.new(1, 40, 1, 40)
    OuterGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
    OuterGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    OuterGlow.BackgroundTransparency = 1
    OuterGlow.Image = "rbxassetid://5028857084"
    OuterGlow.ImageColor3 = self.Theme.Accent
    OuterGlow.ImageTransparency = 0.8
    OuterGlow.ScaleType = Enum.ScaleType.Slice
    OuterGlow.SliceCenter = Rect.new(24, 24, 276, 276)
    OuterGlow.ZIndex = 0
    OuterGlow.Parent = self.MainFrame
    local BorderStroke = Instance.new("UIStroke")
    BorderStroke.Color = self.Theme.Accent
    BorderStroke.Thickness = 1
    BorderStroke.Transparency = 0.7
    BorderStroke.Parent = self.MainFrame
    self:CreateTopBar()
    self:CreateTabBar()
    self:CreateContentArea()
    self:MakeDraggable()
end

function Robox:CreateTopBar()
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 50)
    TopBar.BackgroundColor3 = self.Theme.Secondary
    TopBar.BackgroundTransparency = 0.3
    TopBar.BorderSizePixel = 0
    TopBar.Parent = self.MainFrame
    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 12)
    TopCorner.Parent = TopBar
    local BottomCover = Instance.new("Frame")
    BottomCover.Size = UDim2.new(1, 0, 0, 12)
    BottomCover.Position = UDim2.new(0, 0, 1, -12)
    BottomCover.BackgroundColor3 = self.Theme.Secondary
    BottomCover.BackgroundTransparency = 0.3
    BottomCover.BorderSizePixel = 0
    BottomCover.Parent = TopBar
    local TopBarStroke = Instance.new("UIStroke")
    TopBarStroke.Color = self.Theme.Accent
    TopBarStroke.Thickness = 1
    TopBarStroke.Transparency = 0.85
    TopBarStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    TopBarStroke.Parent = TopBar
    local TitleIcon = Instance.new("ImageLabel")
    TitleIcon.Size = UDim2.new(0, 22, 0, 22)
    TitleIcon.Position = UDim2.new(0, 18, 0.5, -11)
    TitleIcon.BackgroundTransparency = 1
    TitleIcon.Image = self.Theme.TitleIcon
    TitleIcon.ImageColor3 = self.Theme.Accent
    TitleIcon.Parent = TopBar
    local IconGlow = Instance.new("ImageLabel")
    IconGlow.Size = UDim2.new(1, 10, 1, 10)
    IconGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
    IconGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    IconGlow.BackgroundTransparency = 1
    IconGlow.Image = "rbxassetid://5028857084"
    IconGlow.ImageColor3 = self.Theme.Accent
    IconGlow.ImageTransparency = 0.6
    IconGlow.ScaleType = Enum.ScaleType.Slice
    IconGlow.SliceCenter = Rect.new(24, 24, 276, 276)
    IconGlow.ZIndex = 0
    IconGlow.Parent = TitleIcon
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0, 250, 0, 20)
    TitleLabel.Position = UDim2.new(0, 48, 0, 9)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = self.Title
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 15
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TopBar
    local SubtitleLabel = Instance.new("TextLabel")
    SubtitleLabel.Size = UDim2.new(0, 250, 0, 16)
    SubtitleLabel.Position = UDim2.new(0, 48, 0, 27)
    SubtitleLabel.BackgroundTransparency = 1
    SubtitleLabel.Text = self.Subtitle
    SubtitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubtitleLabel.TextTransparency = 0.5
    SubtitleLabel.TextSize = 11
    SubtitleLabel.Font = Enum.Font.Gotham
    SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubtitleLabel.Parent = TopBar
    local CloseButton = Instance.new("ImageButton")
CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Position = UDim2.new(1, -35, 0.5, -10)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.BackgroundTransparency = 0.9
CloseButton.Image = self.Theme.CloseIcon
CloseButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Parent = TopBar
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseButton
CloseButton.MouseEnter:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
end)
CloseButton.MouseLeave:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.9}):Play()
end)
CloseButton.MouseButton1Click:Connect(function()
    self.ScreenGui:Destroy()
end)
local MinimizeButton = Instance.new("ImageButton")
MinimizeButton.Size = UDim2.new(0, 20, 0, 20)
MinimizeButton.Position = UDim2.new(1, -63, 0.5, -10)
MinimizeButton.BackgroundColor3 = self.Theme.Accent
MinimizeButton.BackgroundTransparency = 0.9
MinimizeButton.Image = self.Theme.MinimizeIcon
MinimizeButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Parent = TopBar
local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(1, 0)
MinCorner.Parent = MinimizeButton
MinimizeButton.MouseEnter:Connect(function()
    TweenService:Create(MinimizeButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play()
end)
MinimizeButton.MouseLeave:Connect(function()
    TweenService:Create(MinimizeButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.9}):Play()
end)
MinimizeButton.MouseButton1Click:Connect(function()
    self:ToggleMinimize()
end)
end

function Robox:CreateTabBar()
    self.TabBar = Instance.new("Frame")
    self.TabBar.Name = "TabBar"
    self.TabBar.Size = UDim2.new(0, 155, 1, -65)
    self.TabBar.Position = UDim2.new(0, 12, 0, 58)
    self.TabBar.BackgroundTransparency = 1
    self.TabBar.Parent = self.MainFrame
    self.TabList = Instance.new("UIListLayout")
    self.TabList.SortOrder = Enum.SortOrder.LayoutOrder
    self.TabList.Padding = UDim.new(0, 6)
    self.TabList.Parent = self.TabBar
    self.ActiveIndicator = Instance.new("Frame")
    self.ActiveIndicator.Name = "ActiveIndicator"
    self.ActiveIndicator.Size = UDim2.new(0, 3, 0, 38)
    self.ActiveIndicator.BackgroundColor3 = self.Theme.Accent
    self.ActiveIndicator.BorderSizePixel = 0
    self.ActiveIndicator.Parent = self.TabBar
    local IndicatorCorner = Instance.new("UICorner")
    IndicatorCorner.CornerRadius = UDim.new(1, 0)
    IndicatorCorner.Parent = self.ActiveIndicator
    local IndicatorGlow = Instance.new("ImageLabel")
    IndicatorGlow.Size = UDim2.new(1, 8, 1, 8)
    IndicatorGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
    IndicatorGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    IndicatorGlow.BackgroundTransparency = 1
    IndicatorGlow.Image = "rbxassetid://5028857084"
    IndicatorGlow.ImageColor3 = self.Theme.Accent
    IndicatorGlow.ImageTransparency = 0.5
    IndicatorGlow.ScaleType = Enum.ScaleType.Slice
    IndicatorGlow.SliceCenter = Rect.new(24, 24, 276, 276)
    IndicatorGlow.ZIndex = 0
    IndicatorGlow.Parent = self.ActiveIndicator
end

function Robox:CreateContentArea()
    self.ContentArea = Instance.new("ScrollingFrame")
    self.ContentArea.Name = "ContentArea"
    self.ContentArea.Size = UDim2.new(1, -185, 1, -73)
    self.ContentArea.Position = UDim2.new(0, 175, 0, 61)
    self.ContentArea.BackgroundTransparency = 1
    self.ContentArea.BorderSizePixel = 0
    self.ContentArea.ScrollBarThickness = 4
    self.ContentArea.ScrollBarImageColor3 = self.Theme.Accent
    self.ContentArea.ScrollBarImageTransparency = 0.5
    self.ContentArea.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.ContentArea.Parent = self.MainFrame
    local ContentList = Instance.new("UIListLayout")
    ContentList.SortOrder = Enum.SortOrder.LayoutOrder
    ContentList.Padding = UDim.new(0, 10)
    ContentList.Parent = self.ContentArea
    ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.ContentArea.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 12)
    end)
end

function Robox:AddTab(config)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = config.Name
    TabButton.Size = UDim2.new(1, 0, 0, 38)
    TabButton.BackgroundColor3 = self.Theme.Secondary
    TabButton.BackgroundTransparency = 0.4
    TabButton.BorderSizePixel = 0
    TabButton.Text = ""
    TabButton.Parent = self.TabBar
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 8)
    TabCorner.Parent = TabButton
    local TabStroke = Instance.new("UIStroke")
    TabStroke.Color = self.Theme.Accent
    TabStroke.Thickness = 1
    TabStroke.Transparency = 0.9
    TabStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    TabStroke.Parent = TabButton
    if config.Icon then
        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Size = UDim2.new(0, 18, 0, 18)
        TabIcon.Position = UDim2.new(0, 10, 0.5, -9)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = config.Icon
        TabIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        TabIcon.ImageTransparency = 0.3
        TabIcon.Parent = TabButton
    end
    local TabLabel = Instance.new("TextLabel")
    TabLabel.Size = UDim2.new(1, -40, 1, 0)
    TabLabel.Position = UDim2.new(0, 34, 0, 0)
    TabLabel.BackgroundTransparency = 1
    TabLabel.Text = config.Name
    TabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabLabel.TextTransparency = 0.3
    TabLabel.TextSize = 13
    TabLabel.Font = Enum.Font.GothamMedium
    TabLabel.TextXAlignment = Enum.TextXAlignment.Left
    TabLabel.Parent = TabButton
    local TabContent = Instance.new("Frame")
    TabContent.Name = config.Name .. "Content"
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.Visible = false
    TabContent.Parent = self.ContentArea
    local TabContentList = Instance.new("UIListLayout")
    TabContentList.SortOrder = Enum.SortOrder.LayoutOrder
    TabContentList.Padding = UDim.new(0, 10)
    TabContentList.Parent = TabContent
    table.insert(self.Tabs, {
        Button = TabButton,
        Content = TabContent,
        Name = config.Name,
        Icon = TabButton:FindFirstChild("ImageLabel"),
        Label = TabLabel,
        Stroke = TabStroke
    })
    TabButton.MouseEnter:Connect(function()
        if not TabContent.Visible then
            TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
            TweenService:Create(TabStroke, TweenInfo.new(0.2), {Transparency = 0.7}):Play()
        end
    end)
    TabButton.MouseLeave:Connect(function()
        if not TabContent.Visible then
            TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.4}):Play()
            TweenService:Create(TabStroke, TweenInfo.new(0.2), {Transparency = 0.9}):Play()
        end
    end)
    TabButton.MouseButton1Click:Connect(function()
        self:SelectTab(config.Name)
    end)
    if #self.Tabs == 1 then
        self:SelectTab(config.Name)
    end
    return {
        AddSection = function(sectionConfig)
            return self:AddSection(TabContent, sectionConfig)
        end,
        AddToggle = function(toggleConfig)
            return self:AddToggle(TabContent, toggleConfig)
        end,
        AddButton = function(buttonConfig)
            return self:AddButton(TabContent, buttonConfig)
        end,
        AddDropdown = function(dropdownConfig)
            return self:AddDropdown(TabContent, dropdownConfig)
        end,
        AddSlider = function(sliderConfig)
            return self:AddSlider(TabContent, sliderConfig)
        end
    }
end

function Robox:SelectTab(tabName)
    for _, tab in ipairs(self.Tabs) do
        if tab.Name == tabName then
            tab.Content.Visible = true
            TweenService:Create(tab.Button, TweenInfo.new(0.3), {BackgroundTransparency = 0.1}):Play()
            TweenService:Create(tab.Stroke, TweenInfo.new(0.3), {Transparency = 0.5}):Play()
            TweenService:Create(tab.Label, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
            if tab.Icon then
                TweenService:Create(tab.Icon, TweenInfo.new(0.3), {ImageTransparency = 0, ImageColor3 = self.Theme.Accent}):Play()
            end
            TweenService:Create(self.ActiveIndicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Position = UDim2.new(0, 0, 0, tab.Button.AbsolutePosition.Y - self.TabBar.AbsolutePosition.Y)
            }):Play()
        else
            tab.Content.Visible = false
            TweenService:Create(tab.Button, TweenInfo.new(0.3), {BackgroundTransparency = 0.4}):Play()
            TweenService:Create(tab.Stroke, TweenInfo.new(0.3), {Transparency = 0.9}):Play()
            TweenService:Create(tab.Label, TweenInfo.new(0.3), {TextTransparency = 0.3}):Play()
            if tab.Icon then
                TweenService:Create(tab.Icon, TweenInfo.new(0.3), {ImageTransparency = 0.3, ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
            end
        end
    end
end

function Robox:AddSection(parent, config)
    local Section = Instance.new("Frame")
    Section.Name = "Section"
    Section.Size = UDim2.new(1, -12, 0, 30)
    Section.BackgroundTransparency = 1
    Section.Parent = parent
    if config.Icon then
        local SectionIcon = Instance.new("ImageLabel")
        SectionIcon.Size = UDim2.new(0, 20, 0, 20)
        SectionIcon.Position = UDim2.new(0, 6, 0, 5)
        SectionIcon.BackgroundTransparency = 1
        SectionIcon.Image = config.Icon
        SectionIcon.ImageColor3 = self.Theme.Accent
        SectionIcon.Parent = Section
    end
    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Size = UDim2.new(1, -35, 1, 0)
    SectionTitle.Position = UDim2.new(0, config.Icon and 32 or 6, 0, 0)
    SectionTitle.BackgroundTransparency = 1
    SectionTitle.Text = config.Name
    SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    SectionTitle.TextTransparency = 0.3
    SectionTitle.TextSize = 15
    SectionTitle.Font = Enum.Font.GothamBold
    SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    SectionTitle.Parent = Section
    local Divider = Instance.new("Frame")
    Divider.Size = UDim2.new(1, -12, 0, 1)
    Divider.Position = UDim2.new(0, 6, 1, -2)
    Divider.BackgroundColor3 = self.Theme.Accent
    Divider.BackgroundTransparency = 0.85
    Divider.BorderSizePixel = 0
    Divider.Parent = Section
    return Section
end

function Robox:AddToggle(parent, config)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = "Toggle"
    ToggleFrame.Size = UDim2.new(1, -12, 0, 42)
    ToggleFrame.BackgroundColor3 = self.Theme.Secondary
    ToggleFrame.BackgroundTransparency = 0.3
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = parent
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 10)
    ToggleCorner.Parent = ToggleFrame
    local ToggleStroke = Instance.new("UIStroke")
    ToggleStroke.Color = self.Theme.Accent
    ToggleStroke.Thickness = 1
    ToggleStroke.Transparency = 0.9
    ToggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    ToggleStroke.Parent = ToggleFrame
    if config.Icon then
        local ToggleIcon = Instance.new("ImageLabel")
        ToggleIcon.Size = UDim2.new(0, 20, 0, 20)
        ToggleIcon.Position = UDim2.new(0, 12, 0.5, -10)
        ToggleIcon.BackgroundTransparency = 1
        ToggleIcon.Image = config.Icon
        ToggleIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        ToggleIcon.ImageTransparency = 0.3
        ToggleIcon.Parent = ToggleFrame
    end
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Size = UDim2.new(1, -100, 1, 0)
    ToggleLabel.Position = UDim2.new(0, config.Icon and 40 or 12, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = config.Name
    ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleLabel.TextSize = 13
    ToggleLabel.Font = Enum.Font.GothamMedium
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = ToggleFrame
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 46, 0, 22)
    ToggleButton.Position = UDim2.new(1, -58, 0.5, -11)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    ToggleButton.BackgroundTransparency = 0.2
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Text = ""
    ToggleButton.Parent = ToggleFrame
    local ToggleButtonCorner = Instance.new("UICorner")
    ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
    ToggleButtonCorner.Parent = ToggleButton
    local ToggleButtonStroke = Instance.new("UIStroke")
    ToggleButtonStroke.Color = self.Theme.Accent
    ToggleButtonStroke.Thickness = 1
    ToggleButtonStroke.Transparency = 0.8
    ToggleButtonStroke.Parent = ToggleButton
    local ToggleSlider = Instance.new("Frame")
    ToggleSlider.Size = UDim2.new(0, 18, 0, 18)
    ToggleSlider.Position = UDim2.new(0, 2, 0.5, -9)
    ToggleSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ToggleSlider.BackgroundTransparency = 0.1
    ToggleSlider.BorderSizePixel = 0
    ToggleSlider.Parent = ToggleButton
    local ToggleSliderCorner = Instance.new("UICorner")
    ToggleSliderCorner.CornerRadius = UDim.new(1, 0)
    ToggleSliderCorner.Parent = ToggleSlider
    local SliderGlow = Instance.new("ImageLabel")
    SliderGlow.Size = UDim2.new(1, 12, 1, 12)
    SliderGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
    SliderGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    SliderGlow.BackgroundTransparency = 1
    SliderGlow.Image = "rbxassetid://5028857084"
    SliderGlow.ImageColor3 = self.Theme.Accent
    SliderGlow.ImageTransparency = 1
    SliderGlow.ScaleType = Enum.ScaleType.Slice
    SliderGlow.SliceCenter = Rect.new(24, 24, 276, 276)
    SliderGlow.ZIndex = 0
    SliderGlow.Parent = ToggleSlider
    local toggled = config.Default or false
    local function UpdateToggle()
        if toggled then
            TweenService:Create(ToggleButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                BackgroundColor3 = self.Theme.Accent,
                BackgroundTransparency = 0.1
            }):Play()
            TweenService:Create(ToggleButtonStroke, TweenInfo.new(0.3), {Transparency = 0.3}):Play()
            TweenService:Create(ToggleSlider, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Position = UDim2.new(1, -20, 0.5, -9),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
            TweenService:Create(SliderGlow, TweenInfo.new(0.3), {ImageTransparency = 0.4}):Play()
            TweenService:Create(ToggleStroke, TweenInfo.new(0.3), {Transparency = 0.6}):Play()
        else
            TweenService:Create(ToggleButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(20, 20, 20),
                BackgroundTransparency = 0.2
            }):Play()
            TweenService:Create(ToggleButtonStroke, TweenInfo.new(0.3), {Transparency = 0.8}):Play()
            TweenService:Create(ToggleSlider, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Position = UDim2.new(0, 2, 0.5, -9),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
            TweenService:Create(SliderGlow, TweenInfo.new(0.3), {ImageTransparency = 1}):Play()
            TweenService:Create(ToggleStroke, TweenInfo.new(0.3), {Transparency = 0.9}):Play()
        end
        if config.Callback then
            pcall(function()
                config.Callback(toggled)
            end)
        end
    end
    UpdateToggle()
    ToggleFrame.MouseEnter:Connect(function()
        TweenService:Create(ToggleFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.15}):Play()
    end)
    ToggleFrame.MouseLeave:Connect(function()
        TweenService:Create(ToggleFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
    end)
    ToggleButton.MouseButton1Click:Connect(function()
        toggled = not toggled
        UpdateToggle()
    end)
    return {
        SetValue = function(value)
            toggled = value
            UpdateToggle()
        end
    }
end

function Robox:AddButton(parent, config)
    local ButtonFrame = Instance.new("TextButton")
    ButtonFrame.Name = "Button"
    ButtonFrame.Size = UDim2.new(1, -12, 0, 42)
    ButtonFrame.BackgroundColor3 = self.Theme.Secondary
    ButtonFrame.BackgroundTransparency = 0.3
    ButtonFrame.BorderSizePixel = 0
    ButtonFrame.Text = ""
    ButtonFrame.Parent = parent
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 10)
    ButtonCorner.Parent = ButtonFrame
    local ButtonStroke = Instance.new("UIStroke")
    ButtonStroke.Color = self.Theme.Accent
    ButtonStroke.Thickness = 1
    ButtonStroke.Transparency = 0.9
    ButtonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    ButtonStroke.Parent = ButtonFrame
    if config.Icon then
        local ButtonIcon = Instance.new("ImageLabel")
        ButtonIcon.Size = UDim2.new(0, 20, 0, 20)
        ButtonIcon.Position = UDim2.new(0, 12, 0.5, -10)
        ButtonIcon.BackgroundTransparency = 1
        ButtonIcon.Image = config.Icon
        ButtonIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        ButtonIcon.ImageTransparency = 0.3
        ButtonIcon.Parent = ButtonFrame
    end
    local ButtonLabel = Instance.new("TextLabel")
    ButtonLabel.Size = UDim2.new(1, -24, 1, 0)
    ButtonLabel.Position = UDim2.new(0, config.Icon and 40 or 12, 0, 0)
    ButtonLabel.BackgroundTransparency = 1
    ButtonLabel.Text = config.Name
    ButtonLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ButtonLabel.TextSize = 13
    ButtonLabel.Font = Enum.Font.GothamMedium
    ButtonLabel.TextXAlignment = Enum.TextXAlignment.Left
    ButtonLabel.Parent = ButtonFrame
    ButtonFrame.MouseEnter:Connect(function()
        TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.15}):Play()
        TweenService:Create(ButtonStroke, TweenInfo.new(0.2), {Transparency = 0.7}):Play()
    end)
    ButtonFrame.MouseLeave:Connect(function()
        TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
        TweenService:Create(ButtonStroke, TweenInfo.new(0.2), {Transparency = 0.9}):Play()
    end)
    ButtonFrame.MouseButton1Click:Connect(function()
        TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {BackgroundTransparency = 0.05}):Play()
        TweenService:Create(ButtonStroke, TweenInfo.new(0.1), {Transparency = 0.4}):Play()
        task.wait(0.1)
        TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {BackgroundTransparency = 0.3}):Play()
        TweenService:Create(ButtonStroke, TweenInfo.new(0.1), {Transparency = 0.9}):Play()
        if config.Callback then
            pcall(function()
                config.Callback()
            end)
        end
    end)
end

function Robox:AddDropdown(parent, config)
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Name = "Dropdown"
    DropdownFrame.Size = UDim2.new(1, -12, 0, 42)
    DropdownFrame.BackgroundColor3 = self.Theme.Secondary
    DropdownFrame.BackgroundTransparency = 0.3
    DropdownFrame.BorderSizePixel = 0
    DropdownFrame.ClipsDescendants = true
    DropdownFrame.Parent = parent
    local DropdownCorner = Instance.new("UICorner")
    DropdownCorner.CornerRadius = UDim.new(0, 10)
    DropdownCorner.Parent = DropdownFrame
    local DropdownStroke = Instance.new("UIStroke")
    DropdownStroke.Color = self.Theme.Accent
    DropdownStroke.Thickness = 1
    DropdownStroke.Transparency = 0.9
    DropdownStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    DropdownStroke.Parent = DropdownFrame
    local DropdownLabel = Instance.new("TextLabel")
    DropdownLabel.Size = UDim2.new(1, -60, 0, 42)
    DropdownLabel.Position = UDim2.new(0, 12, 0, 0)
    DropdownLabel.BackgroundTransparency = 1
    DropdownLabel.Text = config.Name
    DropdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    DropdownLabel.TextSize = 13
    DropdownLabel.Font = Enum.Font.GothamMedium
    DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
    DropdownLabel.Parent = DropdownFrame
    local DropdownValue = Instance.new("TextLabel")
    DropdownValue.Size = UDim2.new(0, 100, 0, 42)
    DropdownValue.Position = UDim2.new(1, -130, 0, 0)
    DropdownValue.BackgroundTransparency = 1
    DropdownValue.Text = config.Default or config.Options[1]
    DropdownValue.TextColor3 = self.Theme.Accent
    DropdownValue.TextSize = 12
    DropdownValue.Font = Enum.Font.GothamMedium
    DropdownValue.TextXAlignment = Enum.TextXAlignment.Right
    DropdownValue.Parent = DropdownFrame
    local DropdownIcon = Instance.new("ImageLabel")
    DropdownIcon.Size = UDim2.new(0, 16, 0, 16)
    DropdownIcon.Position = UDim2.new(1, -28, 0, 13)
    DropdownIcon.BackgroundTransparency = 1
    DropdownIcon.Image = "rbxassetid://3926305904"
    DropdownIcon.ImageRectOffset = Vector2.new(324, 364)
    DropdownIcon.ImageRectSize = Vector2.new(36, 36)
    DropdownIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    DropdownIcon.ImageTransparency = 0.4
    DropdownIcon.Rotation = 0
    DropdownIcon.Parent = DropdownFrame
    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Size = UDim2.new(1, 0, 0, 42)
    DropdownButton.BackgroundTransparency = 1
    DropdownButton.Text = ""
    DropdownButton.Parent = DropdownFrame
    local DropdownList = Instance.new("Frame")
    DropdownList.Name = "DropdownList"
    DropdownList.Size = UDim2.new(1, 0, 0, 0)
    DropdownList.Position = UDim2.new(0, 0, 0, 48)
    DropdownList.BackgroundTransparency = 1
    DropdownList.Parent = DropdownFrame
    local ListLayout = Instance.new("UIListLayout")
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 4)
ListLayout.Parent = DropdownList
local opened = false
local selectedValue = config.Default or config.Options[1]
for i, option in ipairs(config.Options) do
    local OptionButton = Instance.new("TextButton")
    OptionButton.Size = UDim2.new(1, -10, 0, 36)
    OptionButton.Position = UDim2.new(0, 5, 0, 0)
    OptionButton.BackgroundColor3 = self.Theme.Tertiary
    OptionButton.BackgroundTransparency = 0.2
    OptionButton.BorderSizePixel = 0
    OptionButton.Text = ""
    OptionButton.Parent = DropdownList
    local OptionCorner = Instance.new("UICorner")
    OptionCorner.CornerRadius = UDim.new(0, 8)
    OptionCorner.Parent = OptionButton
    local OptionStroke = Instance.new("UIStroke")
    OptionStroke.Color = self.Theme.Accent
    OptionStroke.Thickness = 1
    OptionStroke.Transparency = 0.95
    OptionStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    OptionStroke.Parent = OptionButton
    local OptionIndicator = Instance.new("Frame")
    OptionIndicator.Size = UDim2.new(0, 3, 1, -8)
    OptionIndicator.Position = UDim2.new(0, 4, 0, 4)
    OptionIndicator.BackgroundColor3 = self.Theme.Accent
    OptionIndicator.BorderSizePixel = 0
    OptionIndicator.Visible = option == selectedValue
    OptionIndicator.Parent = OptionButton
    local IndicatorCorner = Instance.new("UICorner")
    IndicatorCorner.CornerRadius = UDim.new(1, 0)
    IndicatorCorner.Parent = OptionIndicator
    local IndicatorGlow = Instance.new("ImageLabel")
    IndicatorGlow.Size = UDim2.new(1, 8, 1, 8)
    IndicatorGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
    IndicatorGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    IndicatorGlow.BackgroundTransparency = 1
    IndicatorGlow.Image = "rbxassetid://5028857084"
    IndicatorGlow.ImageColor3 = self.Theme.Accent
    IndicatorGlow.ImageTransparency = 0.5
    IndicatorGlow.ScaleType = Enum.ScaleType.Slice
    IndicatorGlow.SliceCenter = Rect.new(24, 24, 276, 276)
    IndicatorGlow.ZIndex = 0
    IndicatorGlow.Parent = OptionIndicator
    if config.OptionIcons and config.OptionIcons[i] then
        local OptionIcon = Instance.new("ImageLabel")
        OptionIcon.Size = UDim2.new(0, 18, 0, 18)
        OptionIcon.Position = UDim2.new(0, 12, 0.5, -9)
        OptionIcon.BackgroundTransparency = 1
        OptionIcon.Image = config.OptionIcons[i]
        OptionIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        OptionIcon.ImageTransparency = 0.3
        OptionIcon.Parent = OptionButton
    end
    local OptionLabel = Instance.new("TextLabel")
    OptionLabel.Size = UDim2.new(1, -24, 1, 0)
    OptionLabel.Position = UDim2.new(0, (config.OptionIcons and config.OptionIcons[i]) and 36 or 12, 0, 0)
    OptionLabel.BackgroundTransparency = 1
    OptionLabel.Text = option
    OptionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    OptionLabel.TextTransparency = 0.2
    OptionLabel.TextSize = 12
    OptionLabel.Font = Enum.Font.GothamMedium
    OptionLabel.TextXAlignment = Enum.TextXAlignment.Left
    OptionLabel.Parent = OptionButton
    OptionButton.MouseEnter:Connect(function()
        TweenService:Create(OptionButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.05}):Play()
        TweenService:Create(OptionStroke, TweenInfo.new(0.2), {Transparency = 0.8}):Play()
    end)
    OptionButton.MouseLeave:Connect(function()
        TweenService:Create(OptionButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
        TweenService:Create(OptionStroke, TweenInfo.new(0.2), {Transparency = 0.95}):Play()
    end)
    OptionButton.MouseButton1Click:Connect(function()
        selectedValue = option
        DropdownValue.Text = option
        for _, child in ipairs(DropdownList:GetChildren()) do
            if child:IsA("TextButton") then
                local indicator = child:FindFirstChild("Frame")
                if indicator then
                    indicator.Visible = false
                end
            end
        end
        OptionIndicator.Visible = true
        if config.Callback then
            pcall(function()
                config.Callback(option)
            end)
        end
        opened = false
        TweenService:Create(DropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(1, -12, 0, 42)
        }):Play()
        TweenService:Create(DropdownIcon, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Rotation = 0
        }):Play()
        TweenService:Create(DropdownStroke, TweenInfo.new(0.3), {Transparency = 0.9}):Play()
    end)
end
DropdownButton.MouseButton1Click:Connect(function()
    opened = not opened
    if opened then
        local contentHeight = ListLayout.AbsoluteContentSize.Y + 54
        TweenService:Create(DropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(1, -12, 0, contentHeight)
        }):Play()
        TweenService:Create(DropdownIcon, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Rotation = 180
        }):Play()
        TweenService:Create(DropdownStroke, TweenInfo.new(0.3), {Transparency = 0.6}):Play()
    else
        TweenService:Create(DropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(1, -12, 0, 42)
        }):Play()
        TweenService:Create(DropdownIcon, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Rotation = 0
        }):Play()
        TweenService:Create(DropdownStroke, TweenInfo.new(0.3), {Transparency = 0.9}):Play()
    end
end)
return {
    SetValue = function(value)
        selectedValue = value
        DropdownValue.Text = value
        for _, child in ipairs(DropdownList:GetChildren()) do
            if child:IsA("TextButton") then
                local indicator = child:FindFirstChild("Frame")
                local label = child:FindFirstChild("TextLabel")
                if indicator and label then
                    indicator.Visible = (label.Text == value)
                end
            end
        end
        if config.Callback then
            pcall(function()
                config.Callback(value)
            end)
        end
    end
}
end

function Robox:AddSlider(parent, config)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = "Slider"
    SliderFrame.Size = UDim2.new(1, -12, 0, 52)
    SliderFrame.BackgroundColor3 = self.Theme.Secondary
    SliderFrame.BackgroundTransparency = 0.3
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Parent = parent
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 10)
    SliderCorner.Parent = SliderFrame
    local SliderStroke = Instance.new("UIStroke")
    SliderStroke.Color = self.Theme.Accent
    SliderStroke.Thickness = 1
    SliderStroke.Transparency = 0.9
    SliderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    SliderStroke.Parent = SliderFrame
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Size = UDim2.new(1, -70, 0, 20)
    SliderLabel.Position = UDim2.new(0, 12, 0, 8)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Text = config.Name
    SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SliderLabel.TextSize = 13
    SliderLabel.Font = Enum.Font.GothamMedium
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.Parent = SliderFrame
    local SliderValue = Instance.new("TextLabel")
    SliderValue.Size = UDim2.new(0, 55, 0, 20)
    SliderValue.Position = UDim2.new(1, -67, 0, 8)
    SliderValue.BackgroundTransparency = 1
    SliderValue.Text = tostring(config.Default or config.Min)
    SliderValue.TextColor3 = self.Theme.Accent
    SliderValue.TextSize = 13
    SliderValue.Font = Enum.Font.GothamBold
    SliderValue.TextXAlignment = Enum.TextXAlignment.Right
    SliderValue.Parent = SliderFrame
    local SliderBar = Instance.new("Frame")
    SliderBar.Name = "SliderBar"
    SliderBar.Size = UDim2.new(1, -24, 0, 4)
    SliderBar.Position = UDim2.new(0, 12, 1, -16)
    SliderBar.BackgroundColor3 = self.Theme.Tertiary
    SliderBar.BackgroundTransparency = 0.2
    SliderBar.BorderSizePixel = 0
    SliderBar.Parent = SliderFrame
    local SliderBarCorner = Instance.new("UICorner")
    SliderBarCorner.CornerRadius = UDim.new(1, 0)
    SliderBarCorner.Parent = SliderBar
    local SliderFill = Instance.new("Frame")
    SliderFill.Name = "SliderFill"
    SliderFill.Size = UDim2.new(0, 0, 1, 0)
    SliderFill.BackgroundColor3 = self.Theme.Accent
    SliderFill.BackgroundTransparency = 0.1
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBar
    local SliderFillCorner = Instance.new("UICorner")
    SliderFillCorner.CornerRadius = UDim.new(1, 0)
    SliderFillCorner.Parent = SliderFill
    local SliderFillGlow = Instance.new("ImageLabel")
    SliderFillGlow.Size = UDim2.new(1, 20, 1, 20)
    SliderFillGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
    SliderFillGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    SliderFillGlow.BackgroundTransparency = 1
    SliderFillGlow.Image = "rbxassetid://5028857084"
    SliderFillGlow.ImageColor3 = self.Theme.Accent
    SliderFillGlow.ImageTransparency = 0.6
    SliderFillGlow.ScaleType = Enum.ScaleType.Slice
    SliderFillGlow.SliceCenter = Rect.new(24, 24, 276, 276)
    SliderFillGlow.ZIndex = 0
    SliderFillGlow.Parent = SliderFill
    local SliderButton = Instance.new("TextButton")
    SliderButton.Size = UDim2.new(1, 0, 1, 0)
    SliderButton.BackgroundTransparency = 1
    SliderButton.Text = ""
    SliderButton.Parent = SliderBar
    local dragging = false
    local currentValue = config.Default or config.Min
    local function UpdateSlider(input)
        local relativeX = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        currentValue = math.floor(config.Min + (config.Max - config.Min) * relativeX)
        if config.Increment then
            currentValue = math.floor(currentValue / config.Increment + 0.5) * config.Increment
        end
        SliderValue.Text = tostring(currentValue)
        TweenService:Create(SliderFill, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
            Size = UDim2.new(relativeX, 0, 1, 0)
        }):Play()
        if config.Callback then
            pcall(function()
                config.Callback(currentValue)
            end)
        end
    end
    SliderButton.MouseButton1Down:Connect(function()
        dragging = true
        TweenService:Create(SliderStroke, TweenInfo.new(0.2), {Transparency = 0.6}):Play()
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
            TweenService:Create(SliderStroke, TweenInfo.new(0.2), {Transparency = 0.9}):Play()
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            UpdateSlider(input)
        end
    end)
    SliderButton.MouseButton1Click:Connect(function(x, y)
        UpdateSlider({Position = Vector2.new(x, y)})
    end)
    local initialPercentage = (currentValue - config.Min) / (config.Max - config.Min)
    SliderFill.Size = UDim2.new(initialPercentage, 0, 1, 0)
    return {
        SetValue = function(value)
            currentValue = math.clamp(value, config.Min, config.Max)
            SliderValue.Text = tostring(currentValue)
            local percentage = (currentValue - config.Min) / (config.Max - config.Min)
            TweenService:Create(SliderFill, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                Size = UDim2.new(percentage, 0, 1, 0)
            }):Play()
            if config.Callback then
                pcall(function()
                    config.Callback(currentValue)
                end)
            end
        end
    }
end

function Robox:Notify(config)
    local NotificationFrame = Instance.new("Frame")
    NotificationFrame.Name = "Notification"
    NotificationFrame.Size = UDim2.new(0, 300, 0, 0)
    NotificationFrame.Position = UDim2.new(1, -320, 1, -20)
    NotificationFrame.BackgroundColor3 = self.Theme.Secondary
    NotificationFrame.BackgroundTransparency = 0.1
    NotificationFrame.BorderSizePixel = 0
    NotificationFrame.ClipsDescendants = true
    NotificationFrame.Parent = self.ScreenGui
    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 10)
    NotifCorner.Parent = NotificationFrame
    local NotifStroke = Instance.new("UIStroke")
    NotifStroke.Color = self.Theme.Accent
    NotifStroke.Thickness = 1
    NotifStroke.Transparency = 0.7
    NotifStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    NotifStroke.Parent = NotificationFrame
    local NotifGlow = Instance.new("ImageLabel")
    NotifGlow.Size = UDim2.new(1, 30, 1, 30)
    NotifGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
    NotifGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    NotifGlow.BackgroundTransparency = 1
    NotifGlow.Image = "rbxassetid://5028857084"
    NotifGlow.ImageColor3 = self.Theme.Accent
    NotifGlow.ImageTransparency = 0.7
    NotifGlow.ScaleType = Enum.ScaleType.Slice
    NotifGlow.SliceCenter = Rect.new(24, 24, 276, 276)
    NotifGlow.ZIndex = 0
    NotifGlow.Parent = NotificationFrame
    if config.Icon then
        local NotifIcon = Instance.new("ImageLabel")
        NotifIcon.Size = UDim2.new(0, 20, 0, 20)
        NotifIcon.Position = UDim2.new(0, 12, 0, 12)
        NotifIcon.BackgroundTransparency = 1
        NotifIcon.Image = config.Icon
        NotifIcon.ImageColor3 = self.Theme.Accent
        NotifIcon.Parent = NotificationFrame
        local IconGlow = Instance.new("ImageLabel")
        IconGlow.Size = UDim2.new(1, 12, 1, 12)
        IconGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
        IconGlow.AnchorPoint = Vector2.new(0.5, 0.5)
        IconGlow.BackgroundTransparency = 1
        IconGlow.Image = "rbxassetid://5028857084"
        IconGlow.ImageColor3 = self.Theme.Accent
        IconGlow.ImageTransparency = 0.5
        IconGlow.ScaleType = Enum.ScaleType.Slice
        IconGlow.SliceCenter = Rect.new(24, 24, 276, 276)
        IconGlow.ZIndex = 0
        IconGlow.Parent = NotifIcon
    end
    local NotifTitle = Instance.new("TextLabel")
    NotifTitle.Size = UDim2.new(1, -50, 0, 20)
    NotifTitle.Position = UDim2.new(0, config.Icon and 40 or 12, 0, 12)
    NotifTitle.BackgroundTransparency = 1
    NotifTitle.Text = config.Title or "Notification"
    NotifTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    NotifTitle.TextSize = 14
    NotifTitle.Font = Enum.Font.GothamBold
    NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
    NotifTitle.Parent = NotificationFrame
    local NotifText = Instance.new("TextLabel")
    NotifText.Size = UDim2.new(1, -24, 0, 0)
    NotifText.Position = UDim2.new(0, 12, 0, 36)
    NotifText.BackgroundTransparency = 1
    NotifText.Text = config.Text or ""
    NotifText.TextColor3 = Color3.fromRGB(255, 255, 255)
    NotifText.TextTransparency = 0.4
    NotifText.TextSize = 12
    NotifText.Font = Enum.Font.GothamMedium
    NotifText.TextXAlignment = Enum.TextXAlignment.Left
    NotifText.TextYAlignment = Enum.TextYAlignment.Top
    NotifText.TextWrapped = true
    NotifText.Parent = NotificationFrame
    local textBounds = game:GetService("TextService"):GetTextSize(
        config.Text or "",
        12,
        Enum.Font.GothamMedium,
        Vector2.new(276, math.huge)
    )
    local totalHeight = 52 + textBounds.Y
    NotifText.Size = UDim2.new(1, -24, 0, textBounds.Y)
    local LoadingBar = Instance.new("Frame")
    LoadingBar.Name = "LoadingBar"
    LoadingBar.Size = UDim2.new(1, 0, 0, 3)
    LoadingBar.Position = UDim2.new(0, 0, 1, -3)
    LoadingBar.BackgroundColor3 = self.Theme.Accent
    LoadingBar.BackgroundTransparency = 0.2
    LoadingBar.BorderSizePixel = 0
    LoadingBar.Parent = NotificationFrame
    local LoadingGlow = Instance.new("ImageLabel")
    LoadingGlow.Size = UDim2.new(1, 20, 1, 20)
    LoadingGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
    LoadingGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    LoadingGlow.BackgroundTransparency = 1
    LoadingGlow.Image = "rbxassetid://5028857084"
    LoadingGlow.ImageColor3 = self.Theme.Accent
    LoadingGlow.ImageTransparency = 0.4
    LoadingGlow.ScaleType = Enum.ScaleType.Slice
    LoadingGlow.SliceCenter = Rect.new(24, 24, 276, 276)
    LoadingGlow.ZIndex = 0
    LoadingGlow.Parent = LoadingBar
    TweenService:Create(NotificationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0, 300, 0, totalHeight),
        Position = UDim2.new(1, -320, 1, -totalHeight - 20)
    }):Play()
    local duration = config.Duration or 5
    TweenService:Create(LoadingBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 0, 0, 3)
    }):Play()
    task.wait(duration)
    TweenService:Create(NotificationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0, 300, 0, 0),
        Position = UDim2.new(1, -320, 1, -20)
    }):Play()
    task.wait(0.3)
    NotificationFrame:Destroy()
end

function Robox:ToggleMinimize()
    self.Minimized = not self.Minimized
    if self.Minimized then
        self.TabBar.Visible = false
        self.ContentArea.Visible = false
        TweenService:Create(self.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 650, 0, 50)
        }):Play()
    else
        self.TabBar.Visible = true
        self.ContentArea.Visible = true
        TweenService:Create(self.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 650, 0, 450)
        }):Play()
    end
end

function Robox:ToggleVisibility()
    self.Visible = not self.Visible
    if self.Visible then
        self.MainFrame.Visible = true
        TweenService:Create(self.MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 650, 0, 450)
        }):Play()
    else
        TweenService:Create(self.MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 650, 0, 0)
        }):Play()
        task.wait(0.25)
        self.MainFrame.Visible = false
    end
end

function Robox:SetupToggleKey()
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.LeftControl then
            self:ToggleVisibility()
        end
    end)
end

function Robox:MakeDraggable()
    local dragging = false
    local dragInput
    local dragStart
    local startPos
    local function update(input)
        local delta = input.Position - dragStart
        self.MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
    self.MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    self.MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

function Robox:SetTheme(themeName)
    if Themes[themeName] then
        self.Theme = Themes[themeName]
        if self.MainFrame then
            self.MainFrame.BackgroundColor3 = self.Theme.Background
            for _, tab in ipairs(self.Tabs) do
                if tab.Content.Visible then
                    self:SelectTab(tab.Name)
                    break
                end
            end
        end
    end
end

function Robox:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
    self.Tabs = {}
    self.Notifications = {}
end

return Robox
