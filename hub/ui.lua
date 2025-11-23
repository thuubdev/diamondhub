local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Robox = {}
Robox.__index = Robox

local FreeTheme = {
    Background = Color3.fromRGB(8, 8, 12),
    Secondary = Color3.fromRGB(12, 12, 16),
    Tertiary = Color3.fromRGB(16, 16, 20),
    Accent = Color3.fromRGB(59, 130, 246),
    AccentGlow = Color3.fromRGB(96, 165, 250),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(148, 163, 184),
    Border = Color3.fromRGB(30, 41, 59),
    DiamondIcon = "rbxassetid://89292430794864",
    CloseIcon = "rbxassetid://115996516910269",
    MinimizeIcon = "rbxassetid://134196154818547",
    ChevronIcon = "rbxassetid://85396524006943",
    CheckIcon = "rbxassetid://99485429958746"
}

local PremiumTheme = {
    Background = Color3.fromRGB(8, 8, 12),
    Secondary = Color3.fromRGB(12, 12, 16),
    Tertiary = Color3.fromRGB(16, 16, 20),
    Accent = Color3.fromRGB(239, 68, 68),
    AccentGlow = Color3.fromRGB(248, 113, 113),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(148, 163, 184),
    Border = Color3.fromRGB(30, 41, 59),
    DiamondIcon = "rbxassetid://98711955142021",
    CloseIcon = "rbxassetid://74363073011356",
    MinimizeIcon = "rbxassetid://111824884348013",
    ChevronIcon = "rbxassetid://71029386769543",
    CheckIcon = "rbxassetid://86852073527497",
    CartIcon = "rbxassetid://96608425643956"
}

function Robox.new(config)
    local self = setmetatable({}, Robox)
    self.IsPremium = config.Premium or false
    self.Theme = self.IsPremium and PremiumTheme or FreeTheme
    self.Title = config.Title or "Diamond Hub"
    self.Subtitle = config.Subtitle or "Blox Fruits"
    self.Minimized = false
    self.Visible = true
    self.Tabs = {}
    self.Notifications = {}
    self.NotificationQueue = {}
    
    self:CreateScreenGui()
    
    if self.IsPremium then
        spawn(function()
            self:ShowKeySystem()
        end)
    else
        spawn(function()
            self:ShowLoadingScreen()
        end)
    end
    
    return self
end

function Robox:CreateScreenGui()
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "RoboxUI"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.IgnoreGuiInset = true
    
    local success = pcall(function()
        self.ScreenGui.Parent = game:GetService("CoreGui")
    end)
    
    if not success then
        self.ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end
end

function Robox:ShowKeySystem()
    local KeyFrame = Instance.new("Frame")
    KeyFrame.Name = "KeyFrame"
    KeyFrame.Size = UDim2.new(0, 340, 0, 200)
    KeyFrame.Position = UDim2.new(0.5, -170, 0.5, -100)
    KeyFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    KeyFrame.BorderSizePixel = 0
    KeyFrame.Parent = self.ScreenGui
    
    local KeyCorner = Instance.new("UICorner")
    KeyCorner.CornerRadius = UDim.new(0, 16)
    KeyCorner.Parent = KeyFrame
    
    local KeyStroke = Instance.new("UIStroke")
    KeyStroke.Color = self.Theme.Border
    KeyStroke.Thickness = 1
    KeyStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    KeyStroke.Parent = KeyFrame
    
    local DiamondIcon = Instance.new("ImageLabel")
    DiamondIcon.Size = UDim2.new(0, 48, 0, 48)
    DiamondIcon.Position = UDim2.new(0, 20, 0, 20)
    DiamondIcon.BackgroundTransparency = 1
    DiamondIcon.Image = self.Theme.DiamondIcon
    DiamondIcon.Parent = KeyFrame
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -80, 0, 24)
    TitleLabel.Position = UDim2.new(0, 76, 0, 26)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "Diamond"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 18
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = KeyFrame
    
    local SubtitleLabel = Instance.new("TextLabel")
    SubtitleLabel.Size = UDim2.new(1, -80, 0, 18)
    SubtitleLabel.Position = UDim2.new(0, 76, 0, 46)
    SubtitleLabel.BackgroundTransparency = 1
    SubtitleLabel.Text = "PREMIUM"
    SubtitleLabel.TextColor3 = self.Theme.Accent
    SubtitleLabel.TextSize = 14
    SubtitleLabel.Font = Enum.Font.GothamBold
    SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubtitleLabel.Parent = KeyFrame
    
    local CloseBtn = Instance.new("ImageButton")
    CloseBtn.Size = UDim2.new(0, 24, 0, 24)
    CloseBtn.Position = UDim2.new(1, -44, 0, 20)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Image = self.Theme.CloseIcon
    CloseBtn.ImageColor3 = self.Theme.Accent
    CloseBtn.Parent = KeyFrame
    
    CloseBtn.MouseButton1Click:Connect(function()
        self.ScreenGui:Destroy()
    end)
    
    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(1, -40, 0, 42)
    KeyInput.Position = UDim2.new(0, 20, 0, 90)
    KeyInput.BackgroundColor3 = self.Theme.Secondary
    KeyInput.BorderSizePixel = 0
    KeyInput.Text = ""
    KeyInput.PlaceholderText = "Input Key"
    KeyInput.PlaceholderColor3 = self.Theme.TextSecondary
    KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyInput.TextSize = 14
    KeyInput.Font = Enum.Font.Gotham
    KeyInput.ClearTextOnFocus = false
    KeyInput.Parent = KeyFrame
    
    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 10)
    InputCorner.Parent = KeyInput
    
    local InputPadding = Instance.new("UIPadding")
    InputPadding.PaddingLeft = UDim.new(0, 14)
    InputPadding.PaddingRight = UDim.new(0, 14)
    InputPadding.Parent = KeyInput
    
    local CheckButton = Instance.new("TextButton")
    CheckButton.Size = UDim2.new(0, 130, 0, 42)
    CheckButton.Position = UDim2.new(0, 20, 0, 145)
    CheckButton.BackgroundColor3 = self.Theme.Tertiary
    CheckButton.BorderSizePixel = 0
    CheckButton.Text = ""
    CheckButton.Parent = KeyFrame
    
    local CheckCorner = Instance.new("UICorner")
    CheckCorner.CornerRadius = UDim.new(0, 10)
    CheckCorner.Parent = CheckButton
    
    local CheckIcon = Instance.new("ImageLabel")
    CheckIcon.Size = UDim2.new(0, 20, 0, 20)
    CheckIcon.Position = UDim2.new(0, 16, 0.5, -10)
    CheckIcon.BackgroundTransparency = 1
    CheckIcon.Image = self.Theme.CheckIcon
    CheckIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    CheckIcon.Parent = CheckButton
    
    local CheckLabel = Instance.new("TextLabel")
    CheckLabel.Size = UDim2.new(1, -45, 1, 0)
    CheckLabel.Position = UDim2.new(0, 42, 0, 0)
    CheckLabel.BackgroundTransparency = 1
    CheckLabel.Text = "Verify"
    CheckLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    CheckLabel.TextSize = 13
    CheckLabel.Font = Enum.Font.GothamMedium
    CheckLabel.TextXAlignment = Enum.TextXAlignment.Left
    CheckLabel.Parent = CheckButton
    
    local CartButton = Instance.new("TextButton")
    CartButton.Size = UDim2.new(0, 150, 0, 42)
    CartButton.Position = UDim2.new(1, -170, 0, 145)
    CartButton.BackgroundColor3 = self.Theme.Tertiary
    CartButton.BorderSizePixel = 0
    CartButton.Text = ""
    CartButton.Parent = KeyFrame
    
    local CartCorner = Instance.new("UICorner")
    CartCorner.CornerRadius = UDim.new(0, 10)
    CartCorner.Parent = CartButton
    
    local CartIcon = Instance.new("ImageLabel")
    CartIcon.Size = UDim2.new(0, 20, 0, 20)
    CartIcon.Position = UDim2.new(0, 16, 0.5, -10)
    CartIcon.BackgroundTransparency = 1
    CartIcon.Image = self.Theme.CartIcon
    CartIcon.Parent = CartButton
    
    local CartLabel = Instance.new("TextLabel")
    CartLabel.Size = UDim2.new(1, -45, 1, 0)
    CartLabel.Position = UDim2.new(0, 42, 0, 0)
    CartLabel.BackgroundTransparency = 1
    CartLabel.Text = "Buy Key"
    CartLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    CartLabel.TextSize = 13
    CartLabel.Font = Enum.Font.GothamMedium
    CartLabel.TextXAlignment = Enum.TextXAlignment.Left
    CartLabel.Parent = CartButton
    
    CheckButton.MouseEnter:Connect(function()
        TweenService:Create(CheckButton, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.Secondary}):Play()
    end)
    
    CheckButton.MouseLeave:Connect(function()
        TweenService:Create(CheckButton, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.Tertiary}):Play()
    end)
    
    CartButton.MouseEnter:Connect(function()
        TweenService:Create(CartButton, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.Secondary}):Play()
    end)
    
    CartButton.MouseLeave:Connect(function()
        TweenService:Create(CartButton, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.Tertiary}):Play()
    end)
    
    CheckButton.MouseButton1Click:Connect(function()
        if KeyInput.Text == "adm123" then
            TweenService:Create(KeyFrame, TweenInfo.new(0.3), {
                Position = UDim2.new(0.5, -170, -0.5, 0)
            }):Play()
            task.wait(0.3)
            KeyFrame:Destroy()
            self:ShowLoadingScreen()
        else
            TweenService:Create(KeyFrame, TweenInfo.new(0.1), {
                Position = UDim2.new(0.5, -180, 0.5, -100)
            }):Play()
            task.wait(0.1)
            TweenService:Create(KeyFrame, TweenInfo.new(0.1), {
                Position = UDim2.new(0.5, -160, 0.5, -100)
            }):Play()
            task.wait(0.1)
            TweenService:Create(KeyFrame, TweenInfo.new(0.1), {
                Position = UDim2.new(0.5, -170, 0.5, -100)
            }):Play()
        end
    end)
end

function Robox:ShowLoadingScreen()
    local LoadingFrame = Instance.new("Frame")
    LoadingFrame.Name = "LoadingFrame"
    LoadingFrame.Size = UDim2.new(0, 0, 0, 0)
    LoadingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    LoadingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    LoadingFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    LoadingFrame.BorderSizePixel = 0
    LoadingFrame.Parent = self.ScreenGui
    
    local LoadingCorner = Instance.new("UICorner")
    LoadingCorner.CornerRadius = UDim.new(0, 16)
    LoadingCorner.Parent = LoadingFrame
    
    TweenService:Create(LoadingFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 600, 0, 300)
    }):Play()
    
    task.wait(0.5)
    
    local DiamondIcon = Instance.new("ImageLabel")
    DiamondIcon.Size = UDim2.new(0, 80, 0, 80)
    DiamondIcon.Position = UDim2.new(0.5, -40, 0.5, -80)
    DiamondIcon.BackgroundTransparency = 1
    DiamondIcon.Image = self.Theme.DiamondIcon
    DiamondIcon.ImageTransparency = 1
    DiamondIcon.Parent = LoadingFrame
    
    TweenService:Create(DiamondIcon, TweenInfo.new(0.6), {ImageTransparency = 0}):Play()
    
    task.wait(0.3)
    
    local LoadingBarBG = Instance.new("Frame")
    LoadingBarBG.Size = UDim2.new(0, 500, 0, 4)
    LoadingBarBG.Position = UDim2.new(0.5, -250, 1, -40)
    LoadingBarBG.BackgroundColor3 = self.Theme.Secondary
    LoadingBarBG.BorderSizePixel = 0
    LoadingBarBG.Parent = LoadingFrame
    
    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = LoadingBarBG
    
    local LoadingBarFill = Instance.new("Frame")
    LoadingBarFill.Size = UDim2.new(0, 0, 1, 0)
    LoadingBarFill.BackgroundColor3 = self.Theme.Accent
    LoadingBarFill.BorderSizePixel = 0
    LoadingBarFill.Parent = LoadingBarBG
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = LoadingBarFill
    
    local fillTween = TweenService:Create(LoadingBarFill, TweenInfo.new(3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
        Size = UDim2.new(1, 0, 1, 0)
    })
    fillTween:Play()
    
    fillTween.Completed:Connect(function()
        task.wait(0.3)
        TweenService:Create(LoadingFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()
        task.wait(0.5)
        LoadingFrame:Destroy()
        self:CreateWindow()
        self:CreateFloatingButton()
    end)
end

function Robox:CreateWindow()
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.new(0, 0, 0, 0)
    self.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.MainFrame.BackgroundColor3 = self.Theme.Background
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.ClipsDescendants = true
    self.MainFrame.Parent = self.ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 16)
    UICorner.Parent = self.MainFrame
    
    local BorderStroke = Instance.new("UIStroke")
    BorderStroke.Color = self.Theme.Border
    BorderStroke.Thickness = 1
    BorderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    BorderStroke.Parent = self.MainFrame
    
    TweenService:Create(self.MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 550, 0, 380)
    }):Play()
    
    task.wait(0.5)
    
    self:CreateTopBar()
    self:CreateTabBar()
    self:CreateContentArea()
    self:MakeDraggable()
end

function Robox:CreateFloatingButton()
    local FloatBtn = Instance.new("TextButton")
    FloatBtn.Name = "FloatingButton"
    FloatBtn.Size = UDim2.new(0, 56, 0, 56)
    FloatBtn.Position = UDim2.new(1, -76, 0, 20)
    FloatBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    FloatBtn.BorderSizePixel = 0
    FloatBtn.Text = ""
    FloatBtn.Parent = self.ScreenGui
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(1, 0)
    BtnCorner.Parent = FloatBtn
    
    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Color = self.Theme.Accent
    BtnStroke.Thickness = 2
    BtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    BtnStroke.Parent = FloatBtn
    
    local BtnIcon = Instance.new("ImageLabel")
    BtnIcon.Size = UDim2.new(0, 32, 0, 32)
    BtnIcon.Position = UDim2.new(0.5, -16, 0.5, -16)
    BtnIcon.BackgroundTransparency = 1
    BtnIcon.Image = self.Theme.DiamondIcon
    BtnIcon.Parent = FloatBtn
    
    local dragging = false
    local dragInput
    local dragStart
    local startPos
    
    FloatBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = FloatBtn.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    FloatBtn.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            FloatBtn.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    FloatBtn.MouseButton1Click:Connect(function()
        if not dragging then
            self:ToggleVisibility()
        end
    end)
    
    FloatBtn.MouseEnter:Connect(function()
        TweenService:Create(FloatBtn, TweenInfo.new(0.2), {
            Size = UDim2.new(0, 64, 0, 64)
        }):Play()
        TweenService:Create(BtnIcon, TweenInfo.new(0.2), {
            Size = UDim2.new(0, 38, 0, 38),
            Position = UDim2.new(0.5, -19, 0.5, -19)
        }):Play()
    end)
    
    FloatBtn.MouseLeave:Connect(function()
        TweenService:Create(FloatBtn, TweenInfo.new(0.2), {
            Size = UDim2.new(0, 56, 0, 56)
        }):Play()
        TweenService:Create(BtnIcon, TweenInfo.new(0.2), {
            Size = UDim2.new(0, 32, 0, 32),
            Position = UDim2.new(0.5, -16, 0.5, -16)
        }):Play()
    end)
end

function Robox:CreateTopBar()
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 50)
    TopBar.BackgroundTransparency = 1
    TopBar.BorderSizePixel = 0
    TopBar.Parent = self.MainFrame
    
    local TitleIcon = Instance.new("ImageLabel")
    TitleIcon.Size = UDim2.new(0, 28, 0, 28)
    TitleIcon.Position = UDim2.new(0, 16, 0, 11)
    TitleIcon.BackgroundTransparency = 1
    TitleIcon.Image = self.Theme.DiamondIcon
    TitleIcon.Parent = TopBar
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0, 200, 0, 18)
    TitleLabel.Position = UDim2.new(0, 52, 0, 11)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = self.Title
    TitleLabel.TextColor3 = self.Theme.Text
    TitleLabel.TextSize = 14
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TopBar
    
    local SubtitleLabel = Instance.new("TextLabel")
    SubtitleLabel.Size = UDim2.new(0, 200, 0, 14)
    SubtitleLabel.Position = UDim2.new(0, 52, 0, 27)
    SubtitleLabel.BackgroundTransparency = 1
    SubtitleLabel.Text = self.Subtitle
    SubtitleLabel.TextColor3 = self.Theme.TextSecondary
    SubtitleLabel.TextSize = 11
    SubtitleLabel.Font = Enum.Font.Gotham
    SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubtitleLabel.Parent = TopBar
    
    local CloseButton = Instance.new("ImageButton")
    CloseButton.Size = UDim2.new(0, 28, 0, 28)
    CloseButton.Position = UDim2.new(1, -44, 0, 11)
    CloseButton.BackgroundColor3 = self.Theme.Tertiary
    CloseButton.BorderSizePixel = 0
    CloseButton.Image = self.Theme.CloseIcon
    CloseButton.ImageColor3 = self.Theme.Text
    CloseButton.Parent = TopBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseButton
    
    CloseButton.MouseEnter:Connect(function()
        TweenService:Create(CloseButton, TweenInfo.new(0.2), {
            BackgroundColor3 = self.Theme.Accent
        }):Play()
    end)
    
    CloseButton.MouseLeave:Connect(function()
        TweenService:Create(CloseButton, TweenInfo.new(0.2), {
            BackgroundColor3 = self.Theme.Tertiary
        }):Play()
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        TweenService:Create(self.MainFrame, TweenInfo.new(0.3), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()
    end)
    
    local MinimizeButton = Instance.new("ImageButton")
    MinimizeButton.Size = UDim2.new(0, 28, 0, 28)
    MinimizeButton.Position = UDim2.new(1, -78, 0, 11)
    MinimizeButton.BackgroundColor3 = self.Theme.Tertiary
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.Image = self.Theme.MinimizeIcon
    MinimizeButton.ImageColor3 = self.Theme.Text
    MinimizeButton.Parent = TopBar
    
    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 8)
    MinCorner.Parent = MinimizeButton
    
    MinimizeButton.MouseEnter:Connect(function()
        TweenService:Create(MinimizeButton, TweenInfo.new(0.2), {
            BackgroundColor3 = self.Theme.Secondary
        }):Play()
    end)
    
    MinimizeButton.MouseLeave:Connect(function()
        TweenService:Create(MinimizeButton, TweenInfo.new(0.2), {
            BackgroundColor3 = self.Theme.Tertiary
        }):Play()
    end)
    
    MinimizeButton.MouseButton1Click:Connect(function()
        self:ToggleMinimize()
    end)
    
    local Divider = Instance.new("Frame")
    Divider.Size = UDim2.new(1, -32, 0, 1)
    Divider.Position = UDim2.new(0, 16, 1, -1)
    Divider.BackgroundColor3 = self.Theme.Border
    Divider.BorderSizePixel = 0
    Divider.Parent = TopBar
end

function Robox:CreateTabBar()
    self.TabBar = Instance.new("Frame")
    self.TabBar.Name = "TabBar"
    self.TabBar.Size = UDim2.new(0, 110, 1, -62)
    self.TabBar.Position = UDim2.new(0, 16, 0, 56)
    self.TabBar.BackgroundTransparency = 1
    self.TabBar.Parent = self.MainFrame
    
    self.TabList = Instance.new("UIListLayout")
    self.TabList.SortOrder = Enum.SortOrder.LayoutOrder
    self.TabList.Padding = UDim.new(0, 4)
    self.TabList.Parent = self.TabBar
end

function Robox:CreateContentArea()
    self.ContentArea = Instance.new("ScrollingFrame")
    self.ContentArea.Name = "ContentArea"
    self.ContentArea.Size = UDim2.new(1, -146, 1, -68)
    self.ContentArea.Position = UDim2.new(0, 134, 0, 56)
    self.ContentArea.BackgroundTransparency = 1
    self.ContentArea.BorderSizePixel = 0
    self.ContentArea.ScrollBarThickness = 3
    self.ContentArea.ScrollBarImageColor3 = self.Theme.Accent
    self.ContentArea.ScrollBarImageTransparency = 0.3
    self.ContentArea.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.ContentArea.Parent = self.MainFrame
    
    local ContentList = Instance.new("UIListLayout")
    ContentList.SortOrder = Enum.SortOrder.LayoutOrder
    ContentList.Padding = UDim.new(0, 6)
    ContentList.Parent = self.ContentArea
    
    ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.ContentArea.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 10)
    end)
end

function Robox:AddTab(config)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = config.Name
    TabButton.Size = UDim2.new(1, 0, 0, 36)
    TabButton.BackgroundColor3 = self.Theme.Tertiary
    TabButton.BackgroundTransparency = 0.6
    TabButton.BorderSizePixel = 0
    TabButton.Text = ""
    TabButton.Parent = self.TabBar
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 8)
    TabCorner.Parent = TabButton

    local TabIndicator = Instance.new("Frame")
    TabIndicator.Name = "TabIndicator"
    TabIndicator.Size = UDim2.new(0, 3, 0, 0)
    TabIndicator.Position = UDim2.new(0, 0, 0.5, 0)
    TabIndicator.AnchorPoint = Vector2.new(0, 0.5)
    TabIndicator.BackgroundColor3 = self.Theme.Accent
    TabIndicator.BorderSizePixel = 0
    TabIndicator.Parent = TabButton

    local IndicatorCorner = Instance.new("UICorner")
    IndicatorCorner.CornerRadius = UDim.new(0, 2)
    IndicatorCorner.Parent = TabIndicator

    local TabIcon = Instance.new("ImageLabel")
    TabIcon.Size = UDim2.new(0, 16, 0, 16)
    TabIcon.Position = UDim2.new(0, 10, 0.5, -8)
    TabIcon.BackgroundTransparency = 1
    TabIcon.Image = self.Theme.ChevronIcon
    TabIcon.ImageColor3 = self.Theme.TextSecondary
    TabIcon.Parent = TabButton

    local TabLabel = Instance.new("TextLabel")
    TabLabel.Size = UDim2.new(1, -36, 1, 0)
    TabLabel.Position = UDim2.new(0, 30, 0, 0)
    TabLabel.BackgroundTransparency = 1
    TabLabel.Text = config.Name
    TabLabel.TextColor3 = self.Theme.TextSecondary
    TabLabel.TextSize = 12
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
    TabContentList.Padding = UDim.new(0, 6)
    TabContentList.Parent = TabContent

    table.insert(self.Tabs, {
        Button = TabButton,
        Content = TabContent,
        Name = config.Name,
        Label = TabLabel,
        Icon = TabIcon,
        Indicator = TabIndicator
    })

    TabButton.MouseEnter:Connect(function()
        if not TabContent.Visible then
            TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
        end
    end)

    TabButton.MouseLeave:Connect(function()
        if not TabContent.Visible then
            TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.6}):Play()
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
            TweenService:Create(tab.Button, TweenInfo.new(0.25), {BackgroundTransparency = 0.2}):Play()
            TweenService:Create(tab.Label, TweenInfo.new(0.25), {TextColor3 = self.Theme.Text}):Play()
            TweenService:Create(tab.Icon, TweenInfo.new(0.25), {ImageColor3 = self.Theme.Accent}):Play()
            TweenService:Create(tab.Indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Size = UDim2.new(0, 3, 0, 20)
            }):Play()
        else
            tab.Content.Visible = false
            TweenService:Create(tab.Button, TweenInfo.new(0.25), {BackgroundTransparency = 0.6}):Play()
            TweenService:Create(tab.Label, TweenInfo.new(0.25), {TextColor3 = self.Theme.TextSecondary}):Play()
            TweenService:Create(tab.Icon, TweenInfo.new(0.25), {ImageColor3 = self.Theme.TextSecondary}):Play()
            TweenService:Create(tab.Indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Size = UDim2.new(0, 3, 0, 0)
            }):Play()
        end
    end
end

function Robox:AddSection(parent, config)
    local Section = Instance.new("Frame")
    Section.Name = "Section"
    Section.Size = UDim2.new(1, -8, 0, 24)
    Section.BackgroundTransparency = 1
    Section.Parent = parent
    
    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Size = UDim2.new(1, 0, 1, 0)
    SectionTitle.BackgroundTransparency = 1
    SectionTitle.Text = config.Name
    SectionTitle.TextColor3 = self.Theme.Text
    SectionTitle.TextSize = 13
    SectionTitle.Font = Enum.Font.GothamBold
    SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    SectionTitle.Parent = Section

    return Section
end

function Robox:AddToggle(parent, config)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = "Toggle"
    ToggleFrame.Size = UDim2.new(1, -8, 0, 38)
    ToggleFrame.BackgroundColor3 = self.Theme.Secondary
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = parent
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = ToggleFrame

    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 12, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = config.Name
    ToggleLabel.TextColor3 = self.Theme.Text
    ToggleLabel.TextSize = 12
    ToggleLabel.Font = Enum.Font.GothamMedium
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = ToggleFrame

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 40, 0, 22)
    ToggleButton.Position = UDim2.new(1, -48, 0.5, -11)
    ToggleButton.BackgroundColor3 = self.Theme.Tertiary
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Text = ""
    ToggleButton.Parent = ToggleFrame

    local ToggleButtonCorner = Instance.new("UICorner")
    ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
    ToggleButtonCorner.Parent = ToggleButton

    local ToggleSlider = Instance.new("Frame")
    ToggleSlider.Size = UDim2.new(0, 16, 0, 16)
    ToggleSlider.Position = UDim2.new(0, 3, 0.5, -8)
    ToggleSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ToggleSlider.BorderSizePixel = 0
    ToggleSlider.Parent = ToggleButton

    local ToggleSliderCorner = Instance.new("UICorner")
    ToggleSliderCorner.CornerRadius = UDim.new(1, 0)
    ToggleSliderCorner.Parent = ToggleSlider

    local toggled = config.Default or false

    local function UpdateToggle()
        if toggled then
            TweenService:Create(ToggleButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                BackgroundColor3 = self.Theme.Accent
            }):Play()
            TweenService:Create(ToggleSlider, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Position = UDim2.new(1, -19, 0.5, -8)
            }):Play()
        else
            TweenService:Create(ToggleButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                BackgroundColor3 = self.Theme.Tertiary
            }):Play()
            TweenService:Create(ToggleSlider, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Position = UDim2.new(0, 3, 0.5, -8)
            }):Play()
        end
        
        if config.Callback then
            pcall(function()
                config.Callback(toggled)
            end)
        end
    end

    UpdateToggle()

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
    ButtonFrame.Size = UDim2.new(1, -8, 0, 38)
    ButtonFrame.BackgroundColor3 = self.Theme.Secondary
    ButtonFrame.BorderSizePixel = 0
    ButtonFrame.Text = ""
    ButtonFrame.Parent = parent
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = ButtonFrame

    local ButtonLabel = Instance.new("TextLabel")
    ButtonLabel.Size = UDim2.new(1, -24, 1, 0)
    ButtonLabel.Position = UDim2.new(0, 12, 0, 0)
    ButtonLabel.BackgroundTransparency = 1
    ButtonLabel.Text = config.Name
    ButtonLabel.TextColor3 = self.Theme.Text
    ButtonLabel.TextSize = 12
    ButtonLabel.Font = Enum.Font.GothamMedium
    ButtonLabel.TextXAlignment = Enum.TextXAlignment.Left
    ButtonLabel.Parent = ButtonFrame

    ButtonFrame.MouseEnter:Connect(function()
        TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {
            BackgroundColor3 = self.Theme.Tertiary
        }):Play()
    end)

    ButtonFrame.MouseLeave:Connect(function()
        TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {
            BackgroundColor3 = self.Theme.Secondary
        }):Play()
    end)

    ButtonFrame.MouseButton1Click:Connect(function()
        TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {
            BackgroundColor3 = self.Theme.Accent
        }):Play()
        task.wait(0.1)
        TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {
            BackgroundColor3 = self.Theme.Secondary
        }):Play()
        
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
    DropdownFrame.Size = UDim2.new(1, -8, 0, 38)
    DropdownFrame.BackgroundColor3 = self.Theme.Secondary
    DropdownFrame.BorderSizePixel = 0
    DropdownFrame.ClipsDescendants = true
    DropdownFrame.Parent = parent
    
    local DropdownCorner = Instance.new("UICorner")
    DropdownCorner.CornerRadius = UDim.new(0, 8)
    DropdownCorner.Parent = DropdownFrame

    local DropdownLabel = Instance.new("TextLabel")
    DropdownLabel.Size = UDim2.new(0.5, -16, 0, 38)
    DropdownLabel.Position = UDim2.new(0, 12, 0, 0)
    DropdownLabel.BackgroundTransparency = 1
    DropdownLabel.Text = config.Name
    DropdownLabel.TextColor3 = self.Theme.Text
    DropdownLabel.TextSize = 12
    DropdownLabel.Font = Enum.Font.GothamMedium
    DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
    DropdownLabel.Parent = DropdownFrame

    local DropdownValue = Instance.new("TextLabel")
    DropdownValue.Size = UDim2.new(0.5, -40, 0, 38)
    DropdownValue.Position = UDim2.new(0.5, 0, 0, 0)
    DropdownValue.BackgroundTransparency = 1
    DropdownValue.Text = config.Default or config.Options[1]
    DropdownValue.TextColor3 = self.Theme.Accent
    DropdownValue.TextSize = 11
    DropdownValue.Font = Enum.Font.GothamMedium
    DropdownValue.TextXAlignment = Enum.TextXAlignment.Right
    DropdownValue.Parent = DropdownFrame

    local DropdownArrow = Instance.new("ImageLabel")
    DropdownArrow.Size = UDim2.new(0, 14, 0, 14)
    DropdownArrow.Position = UDim2.new(1, -26, 0, 12)
    DropdownArrow.BackgroundTransparency = 1
    DropdownArrow.Image = self.Theme.ChevronIcon
    DropdownArrow.ImageColor3 = self.Theme.TextSecondary
    DropdownArrow.Parent = DropdownFrame

    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Size = UDim2.new(1, 0, 0, 38)
    DropdownButton.BackgroundTransparency = 1
    DropdownButton.Text = ""
    DropdownButton.Parent = DropdownFrame

    local DropdownList = Instance.new("Frame")
    DropdownList.Name = "DropdownList"
    DropdownList.Size = UDim2.new(1, 0, 0, 0)
    DropdownList.Position = UDim2.new(0, 0, 0, 42)
    DropdownList.BackgroundTransparency = 1
    DropdownList.Parent = DropdownFrame

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Padding = UDim.new(0, 2)
    ListLayout.Parent = DropdownList

    local opened = false
    local selectedValue = config.Default or config.Options[1]

    for i, option in ipairs(config.Options) do
        local OptionButton = Instance.new("TextButton")
        OptionButton.Size = UDim2.new(1, -10, 0, 30)
        OptionButton.Position = UDim2.new(0, 5, 0, 0)
        OptionButton.BackgroundColor3 = self.Theme.Tertiary
        OptionButton.BorderSizePixel = 0
        OptionButton.Text = ""
        OptionButton.Parent = DropdownList
        
        local OptionCorner = Instance.new("UICorner")
        OptionCorner.CornerRadius = UDim.new(0, 6)
        OptionCorner.Parent = OptionButton
        
        local OptionIndicator = Instance.new("Frame")
        OptionIndicator.Name = "OptionIndicator"
        OptionIndicator.Size = UDim2.new(0, 3, 0, option == selectedValue and 16 or 0)
        OptionIndicator.Position = UDim2.new(0, 0, 0.5, 0)
        OptionIndicator.AnchorPoint = Vector2.new(0, 0.5)
        OptionIndicator.BackgroundColor3 = self.Theme.Accent
        OptionIndicator.BorderSizePixel = 0
        OptionIndicator.Parent = OptionButton
        
        local OptionIndicatorCorner = Instance.new("UICorner")
        OptionIndicatorCorner.CornerRadius = UDim.new(0, 2)
        OptionIndicatorCorner.Parent = OptionIndicator
        
        local OptionIcon = Instance.new("ImageLabel")
        OptionIcon.Size = UDim2.new(0, 14, 0, 14)
        OptionIcon.Position = UDim2.new(0, 10, 0.5, -7)
        OptionIcon.BackgroundTransparency = 1
        OptionIcon.Image = self.Theme.ChevronIcon
        OptionIcon.ImageColor3 = self.Theme.TextSecondary
        OptionIcon.Parent = OptionButton
        
        local OptionLabel = Instance.new("TextLabel")
        OptionLabel.Size = UDim2.new(1, -32, 1, 0)
        OptionLabel.Position = UDim2.new(0, 28, 0, 0)
        OptionLabel.BackgroundTransparency = 1
        OptionLabel.Text = option
        OptionLabel.TextColor3 = self.Theme.Text
        OptionLabel.TextSize = 11
        OptionLabel.Font = Enum.Font.Gotham
        OptionLabel.TextXAlignment = Enum.TextXAlignment.Left
        OptionLabel.Parent = OptionButton
        
        OptionButton.MouseEnter:Connect(function()
            TweenService:Create(OptionButton, TweenInfo.new(0.2), {
                BackgroundColor3 = self.Theme.Accent
            }):Play()
            TweenService:Create(OptionLabel, TweenInfo.new(0.2), {
                TextColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
            TweenService:Create(OptionIcon, TweenInfo.new(0.2), {
                ImageColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
        end)
        
        OptionButton.MouseLeave:Connect(function()
            TweenService:Create(OptionButton, TweenInfo.new(0.2), {
                BackgroundColor3 = self.Theme.Tertiary
            }):Play()
            TweenService:Create(OptionLabel, TweenInfo.new(0.2), {
                TextColor3 = self.Theme.Text
            }):Play()
            TweenService:Create(OptionIcon, TweenInfo.new(0.2), {
                ImageColor3 = self.Theme.TextSecondary
            }):Play()
        end)
        
        OptionButton.MouseButton1Click:Connect(function()
            selectedValue = option
            DropdownValue.Text = option
            
            for _, child in ipairs(DropdownList:GetChildren()) do
                if child:IsA("TextButton") then
                    local indicator = child:FindFirstChild("OptionIndicator")
                    if indicator then
                        TweenService:Create(indicator, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                            Size = UDim2.new(0, 3, 0, 0)
                        }):Play()
                    end
                end
            end
            
            TweenService:Create(OptionIndicator, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                Size = UDim2.new(0, 3, 0, 16)
            }):Play()
            
            if config.Callback then
                pcall(function()
                    config.Callback(option)
                end)
            end
            
            opened = false
            TweenService:Create(DropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Size = UDim2.new(1, -8, 0, 38)
            }):Play()
            TweenService:Create(DropdownArrow, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Rotation = 0
            }):Play()
        end)
    end

    DropdownButton.MouseButton1Click:Connect(function()
        opened = not opened
        if opened then
            local contentHeight = ListLayout.AbsoluteContentSize.Y + 46
            TweenService:Create(DropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Size = UDim2.new(1, -8, 0, contentHeight)
            }):Play()
            TweenService:Create(DropdownArrow, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Rotation = 180
            }):Play()
        else
            TweenService:Create(DropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Size = UDim2.new(1, -8, 0, 38)
            }):Play()
            TweenService:Create(DropdownArrow, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Rotation = 0
            }):Play()
        end
    end)

    return {
        SetValue = function(value)
            selectedValue = value
            DropdownValue.Text = value
            
            for _, child in ipairs(DropdownList:GetChildren()) do
                if child:IsA("TextButton") then
                    local indicator = child:FindFirstChild("OptionIndicator")
                    local label = child:FindFirstChildOfClass("TextLabel")
                    if indicator and label and label.Text == value then
                        TweenService:Create(indicator, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                            Size = UDim2.new(0, 3, 0, 16)
                        }):Play()
                    elseif indicator then
                        TweenService:Create(indicator, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                            Size = UDim2.new(0, 3, 0, 0)
                        }):Play()
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
    SliderFrame.Size = UDim2.new(1, -8, 0, 44)
    SliderFrame.BackgroundColor3 = self.Theme.Secondary
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Parent = parent
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 8)
    SliderCorner.Parent = SliderFrame

    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Size = UDim2.new(0.65, 0, 0, 18)
    SliderLabel.Position = UDim2.new(0, 12, 0, 6)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Text = config.Name
    SliderLabel.TextColor3 = self.Theme.Text
    SliderLabel.TextSize = 12
    SliderLabel.Font = Enum.Font.GothamMedium
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.Parent = SliderFrame

    local SliderValue = Instance.new("TextLabel")
    SliderValue.Size = UDim2.new(0.35, -12, 0, 18)
    SliderValue.Position = UDim2.new(0.65, 0, 0, 6)
    SliderValue.BackgroundTransparency = 1
    SliderValue.Text = tostring(config.Default or config.Min)
    SliderValue.TextColor3 = self.Theme.Accent
    SliderValue.TextSize = 12
    SliderValue.Font = Enum.Font.GothamBold
    SliderValue.TextXAlignment = Enum.TextXAlignment.Right
    SliderValue.Parent = SliderFrame

    local SliderBar = Instance.new("Frame")
    SliderBar.Name = "SliderBar"
    SliderBar.Size = UDim2.new(1, -24, 0, 4)
    SliderBar.Position = UDim2.new(0, 12, 1, -14)
    SliderBar.BackgroundColor3 = self.Theme.Tertiary
    SliderBar.BorderSizePixel = 0
    SliderBar.Parent = SliderFrame

    local SliderBarCorner = Instance.new("UICorner")
    SliderBarCorner.CornerRadius = UDim.new(1, 0)
    SliderBarCorner.Parent = SliderBar

    local SliderFill = Instance.new("Frame")
    SliderFill.Name = "SliderFill"
    SliderFill.Size = UDim2.new(0, 0, 1, 0)
    SliderFill.BackgroundColor3 = self.Theme.Accent
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBar

    local SliderFillCorner = Instance.new("UICorner")
    SliderFillCorner.CornerRadius = UDim.new(1, 0)
    SliderFillCorner.Parent = SliderFill

    local SliderDot = Instance.new("Frame")
    SliderDot.Size = UDim2.new(0, 12, 0, 12)
    SliderDot.Position = UDim2.new(1, -6, 0.5, -6)
    SliderDot.AnchorPoint = Vector2.new(0.5, 0.5)
    SliderDot.BackgroundColor3 = self.Theme.Accent
    SliderDot.BorderSizePixel = 0
    SliderDot.Parent = SliderFill

    local DotCorner = Instance.new("UICorner")
    DotCorner.CornerRadius = UDim.new(1, 0)
    DotCorner.Parent = SliderDot

    local dragging = false
    local currentValue = config.Default or config.Min

    local function UpdateSlider(input)
        local relativeX = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        currentValue = math.floor(config.Min + (config.Max - config.Min) * relativeX)
        
        if config.Increment then
            currentValue = math.floor(currentValue / config.Increment + 0.5) * config.Increment
        end
        
        SliderValue.Text = tostring(currentValue)
        
        local fillSize = relativeX * SliderBar.AbsoluteSize.X
        TweenService:Create(SliderFill, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, fillSize, 1, 0)
        }):Play()
        
        if config.Callback then
            pcall(function()
                config.Callback(currentValue)
            end)
        end
    end

    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            UpdateSlider(input)
        end
    end)

    SliderBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSlider(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    local initialPercentage = (currentValue - config.Min) / (config.Max - config.Min)
    local initialFillSize = initialPercentage * SliderBar.AbsoluteSize.X
    SliderFill.Size = UDim2.new(0, initialFillSize, 1, 0)

    return {
        SetValue = function(value)
            currentValue = math.clamp(value, config.Min, config.Max)
            SliderValue.Text = tostring(currentValue)
            local percentage = (currentValue - config.Min) / (config.Max - config.Min)
            local fillSize = percentage * SliderBar.AbsoluteSize.X
            TweenService:Create(SliderFill, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                Size = UDim2.new(0, fillSize, 1, 0)
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
    table.insert(self.NotificationQueue, config)
    if #self.NotificationQueue == 1 then
        self:ShowNextNotification()
    end
end

function Robox:ShowNextNotification()
    if #self.NotificationQueue == 0 then
        return
    end
    
    local config = self.NotificationQueue[1]

    local existingNotifs = 0
    for _, child in ipairs(self.ScreenGui:GetChildren()) do
        if child.Name == "Notification" then
            existingNotifs = existingNotifs + 1
        end
    end

    local NotificationFrame = Instance.new("Frame")
    NotificationFrame.Name = "Notification"
    NotificationFrame.Size = UDim2.new(0, 280, 0, 0)
    NotificationFrame.Position = UDim2.new(1, -300, 1, -20 - (existingNotifs * 90))
    NotificationFrame.BackgroundColor3 = self.Theme.Background
    NotificationFrame.BorderSizePixel = 0
    NotificationFrame.ClipsDescendants = true
    NotificationFrame.Parent = self.ScreenGui

    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 10)
    NotifCorner.Parent = NotificationFrame

    local NotifStroke = Instance.new("UIStroke")
    NotifStroke.Color = self.Theme.Border
    NotifStroke.Thickness = 1
    NotifStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    NotifStroke.Parent = NotificationFrame

    local NotifIcon = Instance.new("ImageLabel")
    NotifIcon.Size = UDim2.new(0, 20, 0, 20)
    NotifIcon.Position = UDim2.new(0, 12, 0, 12)
    NotifIcon.BackgroundTransparency = 1
    NotifIcon.Image = config.Icon or self.Theme.CheckIcon
    NotifIcon.ImageColor3 = self.Theme.Accent
    NotifIcon.Parent = NotificationFrame

    local NotifTitle = Instance.new("TextLabel")
    NotifTitle.Size = UDim2.new(1, -44, 0, 16)
    NotifTitle.Position = UDim2.new(0, 38, 0, 12)
    NotifTitle.BackgroundTransparency = 1
    NotifTitle.Text = config.Title or "Notification"
    NotifTitle.TextColor3 = self.Theme.Text
    NotifTitle.TextSize = 12
    NotifTitle.Font = Enum.Font.GothamBold
    NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
    NotifTitle.Parent = NotificationFrame

    local NotifText = Instance.new("TextLabel")
    NotifText.Size = UDim2.new(1, -24, 0, 0)
    NotifText.Position = UDim2.new(0, 12, 0, 34)
    NotifText.BackgroundTransparency = 1
    NotifText.Text = config.Text or ""
    NotifText.TextColor3 = self.Theme.TextSecondary
    NotifText.TextSize = 11
    NotifText.Font = Enum.Font.Gotham
    NotifText.TextXAlignment = Enum.TextXAlignment.Left
    NotifText.TextYAlignment = Enum.TextYAlignment.Top
    NotifText.TextWrapped = true
    NotifText.Parent = NotificationFrame

    local textBounds = game:GetService("TextService"):GetTextSize(
        config.Text or "",
        11,
        Enum.Font.Gotham,
        Vector2.new(256, math.huge)
    )

    local totalHeight = 48 + textBounds.Y
    NotifText.Size = UDim2.new(1, -24, 0, textBounds.Y)

    local LoadingBar = Instance.new("Frame")
    LoadingBar.Name = "LoadingBar"
    LoadingBar.Size = UDim2.new(1, 0, 0, 2)
    LoadingBar.Position = UDim2.new(0, 0, 1, -2)
    LoadingBar.BackgroundColor3 = self.Theme.Accent
    LoadingBar.BorderSizePixel = 0
    LoadingBar.Parent = NotificationFrame

    TweenService:Create(NotificationFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 280, 0, totalHeight)
    }):Play()

    local duration = config.Duration or 3
    TweenService:Create(LoadingBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 0, 0, 2)
    }):Play()

    task.wait(duration)

    TweenService:Create(NotificationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = UDim2.new(1, 20, NotificationFrame.Position.Y.Scale, NotificationFrame.Position.Y.Offset)
    }):Play()

    task.wait(0.3)
    NotificationFrame:Destroy()

    table.remove(self.NotificationQueue, 1)

    for i, child in ipairs(self.ScreenGui:GetChildren()) do
        if child.Name == "Notification" then
            local targetY = 1
            local targetOffset = -20 - ((i - 1) * 90)
            TweenService:Create(child, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Position = UDim2.new(1, -300, targetY, targetOffset)
            }):Play()
        end
    end

    if #self.NotificationQueue > 0 then
        task.wait(0.2)
        self:ShowNextNotification()
    end
end

function Robox:ToggleMinimize()
    self.Minimized = not self.Minimized
    if self.Minimized then
        self.TabBar.Visible = false
        self.ContentArea.Visible = false
        TweenService:Create(self.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 550, 0, 50)
        }):Play()
    else
        self.TabBar.Visible = true
        self.ContentArea.Visible = true
        TweenService:Create(self.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 550, 0, 380)
        }):Play()
    end
end

function Robox:ToggleVisibility()
    self.Visible = not self.Visible
    if self.Visible then
        TweenService:Create(self.MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = self.Minimized and UDim2.new(0, 550, 0, 50) or UDim2.new(0, 550, 0, 380)
        }):Play()
    else
        TweenService:Create(self.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()
    end
end

function Robox:MakeDraggable()
    local dragging = false
    local dragInput
    local dragStart
    local startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        TweenService:Create(self.MainFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
            Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        }):Play()
    end

    self.MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
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
    if themeName == "Dark" then
        self.Theme = self.IsPremium and PremiumTheme or FreeTheme
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
    self.NotificationQueue = {}
end

return Robox
