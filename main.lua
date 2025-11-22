local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Robox = {}
Robox.__index = Robox

local Themes = {
    White = {
        Background = Color3.fromRGB(45, 45, 45),
        Accent = Color3.fromRGB(255, 255, 255),
        CloseIcon = "rbxassetid://119857977550721",
        MinimizeIcon = "rbxassetid://83728983492706",
        TitleIcon = "rbxassetid://108135968499852"
    },
    Grey = {
        Background = Color3.fromRGB(45, 45, 45),
        Accent = Color3.fromRGB(150, 150, 150),
        CloseIcon = "rbxassetid://118488476815314",
        MinimizeIcon = "rbxassetid://77736908524347",
        TitleIcon = "rbxassetid://86139502550336"
    },
    Cyan = {
        Background = Color3.fromRGB(45, 45, 45),
        Accent = Color3.fromRGB(0, 255, 255),
        CloseIcon = "rbxassetid://131578543366323",
        MinimizeIcon = "rbxassetid://103650153658551",
        TitleIcon = "rbxassetid://80628691584705"
    },
    Red = {
        Background = Color3.fromRGB(45, 45, 45),
        Accent = Color3.fromRGB(255, 50, 50),
        CloseIcon = "rbxassetid://127402339181958",
        MinimizeIcon = "rbxassetid://129940147514754",
        TitleIcon = "rbxassetid://77670841485007"
    },
    Yellow = {
        Background = Color3.fromRGB(45, 45, 45),
        Accent = Color3.fromRGB(255, 255, 0),
        CloseIcon = "rbxassetid://127236217049716",
        MinimizeIcon = "rbxassetid://86276743363769",
        TitleIcon = "rbxassetid://89005109714253"
    },
    Green = {
        Background = Color3.fromRGB(45, 45, 45),
        Accent = Color3.fromRGB(0, 255, 100),
        CloseIcon = "rbxassetid://120286788820616",
        MinimizeIcon = "rbxassetid://104718581334440",
        TitleIcon = "rbxassetid://136408220068657"
    },
    Pink = {
        Background = Color3.fromRGB(45, 45, 45),
        Accent = Color3.fromRGB(255, 100, 200),
        CloseIcon = "rbxassetid://82910073100769",
        MinimizeIcon = "rbxassetid://83860826595551",
        TitleIcon = "rbxassetid://135652338421844"
    }
}

function Robox.new(config)
    local self = setmetatable({}, Robox)
    
    self.Theme = Themes[config.Theme] or Themes.White
    self.Title = config.Title or "Robox UI"
    self.Subtitle = config.Subtitle or "Interface"
    self.Minimized = false
    self.Tabs = {}
    self.Notifications = {}
    
    self:CreateWindow()
    
    return self
end

function Robox:CreateWindow()
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "RoboxUI"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    if syn and syn.protect_gui then
        syn.protect_gui(self.ScreenGui)
    elseif gethui then
        self.ScreenGui.Parent = gethui()
    else
        self.ScreenGui.Parent = game:GetService("CoreGui")
    end
    
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.new(0, 600, 0, 400)
    self.MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    self.MainFrame.BackgroundColor3 = self.Theme.Background
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Parent = self.ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = self.MainFrame
    
    self:CreateTopBar()
    self:CreateTabBar()
    self:CreateContentArea()
    self:MakeDraggable()
end

function Robox:CreateTopBar()
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 50)
    TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = self.MainFrame
    
    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 8)
    TopCorner.Parent = TopBar
    
    local BottomCover = Instance.new("Frame")
    BottomCover.Size = UDim2.new(1, 0, 0, 8)
    BottomCover.Position = UDim2.new(0, 0, 1, -8)
    BottomCover.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    BottomCover.BorderSizePixel = 0
    BottomCover.Parent = TopBar
    
    local TitleIcon = Instance.new("ImageLabel")
    TitleIcon.Size = UDim2.new(0, 24, 0, 24)
    TitleIcon.Position = UDim2.new(0, 15, 0.5, -12)
    TitleIcon.BackgroundTransparency = 1
    TitleIcon.Image = self.Theme.TitleIcon
    TitleIcon.ImageColor3 = self.Theme.Accent
    TitleIcon.Parent = TopBar
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0, 200, 0, 20)
    TitleLabel.Position = UDim2.new(0, 45, 0, 10)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = self.Title
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 16
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TopBar
    
    local SubtitleLabel = Instance.new("TextLabel")
    SubtitleLabel.Size = UDim2.new(0, 200, 0, 15)
    SubtitleLabel.Position = UDim2.new(0, 45, 0, 30)
    SubtitleLabel.BackgroundTransparency = 1
    SubtitleLabel.Text = self.Subtitle
    SubtitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubtitleLabel.TextTransparency = 0.5
    SubtitleLabel.TextSize = 12
    SubtitleLabel.Font = Enum.Font.Gotham
    SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubtitleLabel.Parent = TopBar
    
    local CloseButton = Instance.new("ImageButton")
    CloseButton.Size = UDim2.new(0, 20, 0, 20)
    CloseButton.Position = UDim2.new(1, -35, 0.5, -10)
    CloseButton.BackgroundTransparency = 1
    CloseButton.Image = self.Theme.CloseIcon
    CloseButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Parent = TopBar
    CloseButton.MouseButton1Click:Connect(function()
        self.ScreenGui:Destroy()
    end)
    
    local MinimizeButton = Instance.new("ImageButton")
    MinimizeButton.Size = UDim2.new(0, 20, 0, 20)
    MinimizeButton.Position = UDim2.new(1, -65, 0.5, -10)
    MinimizeButton.BackgroundTransparency = 1
    MinimizeButton.Image = self.Theme.MinimizeIcon
    MinimizeButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.Parent = TopBar
    MinimizeButton.MouseButton1Click:Connect(function()
        self:ToggleMinimize()
    end)
end

function Robox:CreateTabBar()
    self.TabBar = Instance.new("Frame")
    self.TabBar.Name = "TabBar"
    self.TabBar.Size = UDim2.new(0, 150, 1, -60)
    self.TabBar.Position = UDim2.new(0, 10, 0, 55)
    self.TabBar.BackgroundTransparency = 1
    self.TabBar.Parent = self.MainFrame
    
    self.TabList = Instance.new("UIListLayout")
    self.TabList.SortOrder = Enum.SortOrder.LayoutOrder
    self.TabList.Padding = UDim.new(0, 5)
    self.TabList.Parent = self.TabBar
    
    self.ActiveIndicator = Instance.new("Frame")
    self.ActiveIndicator.Name = "ActiveIndicator"
    self.ActiveIndicator.Size = UDim2.new(0, 3, 0, 35)
    self.ActiveIndicator.BackgroundColor3 = self.Theme.Accent
    self.ActiveIndicator.BorderSizePixel = 0
    self.ActiveIndicator.Parent = self.TabBar
    
    local IndicatorCorner = Instance.new("UICorner")
    IndicatorCorner.CornerRadius = UDim.new(1, 0)
    IndicatorCorner.Parent = self.ActiveIndicator
end

function Robox:CreateContentArea()
    self.ContentArea = Instance.new("ScrollingFrame")
    self.ContentArea.Name = "ContentArea"
    self.ContentArea.Size = UDim2.new(1, -180, 1, -70)
    self.ContentArea.Position = UDim2.new(0, 170, 0, 60)
    self.ContentArea.BackgroundTransparency = 1
    self.ContentArea.BorderSizePixel = 0
    self.ContentArea.ScrollBarThickness = 4
    self.ContentArea.ScrollBarImageColor3 = self.Theme.Accent
    self.ContentArea.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.ContentArea.Parent = self.MainFrame
    
    local ContentList = Instance.new("UIListLayout")
    ContentList.SortOrder = Enum.SortOrder.LayoutOrder
    ContentList.Padding = UDim.new(0, 10)
    ContentList.Parent = self.ContentArea
    
    ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.ContentArea.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 10)
    end)
end

function Robox:AddTab(config)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = config.Name
    TabButton.Size = UDim2.new(1, 0, 0, 35)
    TabButton.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    TabButton.BorderSizePixel = 0
    TabButton.Text = "  " .. config.Name
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.TextSize = 14
    TabButton.Font = Enum.Font.Gotham
    TabButton.TextXAlignment = Enum.TextXAlignment.Left
    TabButton.Parent = self.TabBar
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 6)
    TabCorner.Parent = TabButton
    
    if config.Icon then
        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Size = UDim2.new(0, 18, 0, 18)
        TabIcon.Position = UDim2.new(0, 10, 0.5, -9)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = config.Icon
        TabIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        TabIcon.Parent = TabButton
        
        TabButton.Text = "      " .. config.Name
    end
    
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
        Name = config.Name
    })
    
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
            tab.Button.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
            
            TweenService:Create(self.ActiveIndicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Position = UDim2.new(0, 0, 0, tab.Button.AbsolutePosition.Y - self.TabBar.AbsolutePosition.Y)
            }):Play()
        else
            tab.Content.Visible = false
            tab.Button.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
        end
    end
end

function Robox:AddSection(parent, config)
    local Section = Instance.new("Frame")
    Section.Name = "Section"
    Section.Size = UDim2.new(1, -10, 0, 30)
    Section.BackgroundTransparency = 1
    Section.Parent = parent
    
    if config.Icon then
        local SectionIcon = Instance.new("ImageLabel")
        SectionIcon.Size = UDim2.new(0, 20, 0, 20)
        SectionIcon.Position = UDim2.new(0, 5, 0, 5)
        SectionIcon.BackgroundTransparency = 1
        SectionIcon.Image = config.Icon
        SectionIcon.ImageColor3 = self.Theme.Accent
        SectionIcon.Parent = Section
    end
    
    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Size = UDim2.new(1, -35, 1, 0)
    SectionTitle.Position = UDim2.new(0, config.Icon and 30 or 5, 0, 0)
    SectionTitle.BackgroundTransparency = 1
    SectionTitle.Text = config.Name
    SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    SectionTitle.TextTransparency = 0.3
    SectionTitle.TextSize = 16
    SectionTitle.Font = Enum.Font.GothamBold
    SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    SectionTitle.Parent = Section
    
    return Section
end

function Robox:AddToggle(parent, config)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = "Toggle"
    ToggleFrame.Size = UDim2.new(1, -10, 0, 40)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = parent
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 6)
    ToggleCorner.Parent = ToggleFrame
    
    if config.Icon then
        local ToggleIcon = Instance.new("ImageLabel")
        ToggleIcon.Size = UDim2.new(0, 20, 0, 20)
        ToggleIcon.Position = UDim2.new(0, 10, 0.5, -10)
        ToggleIcon.BackgroundTransparency = 1
        ToggleIcon.Image = config.Icon
        ToggleIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        ToggleIcon.Parent = ToggleFrame
    end
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Size = UDim2.new(1, -100, 1, 0)
    ToggleLabel.Position = UDim2.new(0, config.Icon and 40 or 10, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = config.Name
    ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleLabel.TextSize = 14
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = ToggleFrame
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 45, 0, 22)
    ToggleButton.Position = UDim2.new(1, -55, 0.5, -11)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Text = ""
    ToggleButton.Parent = ToggleFrame
    
    local ToggleButtonCorner = Instance.new("UICorner")
    ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
    ToggleButtonCorner.Parent = ToggleButton
    
    local ToggleSlider = Instance.new("Frame")
    ToggleSlider.Size = UDim2.new(0, 18, 0, 18)
    ToggleSlider.Position = UDim2.new(0, 2, 0.5, -9)
    ToggleSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ToggleSlider.BorderSizePixel = 0
    ToggleSlider.Parent = ToggleButton
    
    local ToggleSliderCorner = Instance.new("UICorner")
    ToggleSliderCorner.CornerRadius = UDim.new(1, 0)
    ToggleSliderCorner.Parent = ToggleSlider
    
    local toggled = config.Default or false
    
    local function UpdateToggle()
        if toggled then
            TweenService:Create(ToggleButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                BackgroundColor3 = self.Theme.Accent
            }):Play()
            TweenService:Create(ToggleSlider, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                Position = UDim2.new(1, -20, 0.5, -9)
            }):Play()
        else
            TweenService:Create(ToggleButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            }):Play()
            TweenService:Create(ToggleSlider, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                Position = UDim2.new(0, 2, 0.5, -9)
            }):Play()
        end
        
        if config.Callback then
            config.Callback(toggled)
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
    ButtonFrame.Size = UDim2.new(1, -10, 0, 40)
    ButtonFrame.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    ButtonFrame.BorderSizePixel = 0
    ButtonFrame.Text = ""
    ButtonFrame.Parent = parent
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = ButtonFrame
    
    if config.Icon then
        local ButtonIcon = Instance.new("ImageLabel")
        ButtonIcon.Size = UDim2.new(0, 20, 0, 20)
        ButtonIcon.Position = UDim2.new(0, 10, 0.5, -10)
        ButtonIcon.BackgroundTransparency = 1
        ButtonIcon.Image = config.Icon
        ButtonIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        ButtonIcon.Parent = ButtonFrame
    end
    
    local ButtonLabel = Instance.new("TextLabel")
    ButtonLabel.Size = UDim2.new(1, -20, 1, 0)
    ButtonLabel.Position = UDim2.new(0, config.Icon and 40 or 10, 0, 0)
    ButtonLabel.BackgroundTransparency = 1
    ButtonLabel.Text = config.Name
    ButtonLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ButtonLabel.TextSize = 14
    ButtonLabel.Font = Enum.Font.Gotham
    ButtonLabel.TextXAlignment = Enum.TextXAlignment.Left
    ButtonLabel.Parent = ButtonFrame
    
    ButtonFrame.MouseButton1Click:Connect(function()
        TweenService:Create(ButtonFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        }):Play()
        
        wait(0.1)
        
        TweenService:Create(ButtonFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.fromRGB(55, 55, 55)
        }):Play()
        
        if config.Callback then
            config.Callback()
        end
    end)
end

function Robox:AddDropdown(parent, config)
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Name = "Dropdown"
    DropdownFrame.Size = UDim2.new(1, -10, 0, 40)
    DropdownFrame.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    DropdownFrame.BorderSizePixel = 0
    DropdownFrame.ClipsDescendants = true
    DropdownFrame.Parent = parent
    
    local DropdownCorner = Instance.new("UICorner")
    DropdownCorner.CornerRadius = UDim.new(0, 6)
    DropdownCorner.Parent = DropdownFrame
    
    local DropdownLabel = Instance.new("TextLabel")
    DropdownLabel.Size = UDim2.new(1, -60, 0, 40)
    DropdownLabel.Position = UDim2.new(0, 10, 0, 0)
    DropdownLabel.BackgroundTransparency = 1
    DropdownLabel.Text = config.Name
    DropdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    DropdownLabel.TextSize = 14
    DropdownLabel.Font = Enum.Font.Gotham
    DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
    DropdownLabel.Parent = DropdownFrame
    
    local DropdownValue = Instance.new("TextLabel")
    DropdownValue.Size = UDim2.new(0, 100, 0, 40)
    DropdownValue.Position = UDim2.new(1, -140, 0, 0)
    DropdownValue.BackgroundTransparency = 1
    DropdownValue.Text = config.Default or config.Options[1]
    DropdownValue.TextColor3 = self.Theme.Accent
    DropdownValue.TextSize = 13
    DropdownValue.Font = Enum.Font.Gotham
    DropdownValue.TextXAlignment = Enum.TextXAlignment.Right
    DropdownValue.Parent = DropdownFrame
    
    local DropdownIcon = Instance.new("ImageLabel")
    DropdownIcon.Size = UDim2.new(0, 16, 0, 16)
    DropdownIcon.Position = UDim2.new(1, -30, 0, 12)
    DropdownIcon.BackgroundTransparency = 1
    DropdownIcon.Image = "rbxassetid://3926305904"
    DropdownIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    DropdownIcon.Rotation = 0
    DropdownIcon.Parent = DropdownFrame
    
    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Size = UDim2.new(1, 0, 0, 40)
    DropdownButton.BackgroundTransparency = 1
    DropdownButton.Text = ""
    DropdownButton.Parent = DropdownFrame
    
    local DropdownList = Instance.new("Frame")
    DropdownList.Name = "DropdownList"
    DropdownList.Size = UDim2.new(1, 0, 0, 0)
    DropdownList.Position = UDim2.new(0, 0, 0, 45)
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
        OptionButton.Size = UDim2.new(1, -10, 0, 35)
        OptionButton.Position = UDim2.new(0, 5, 0, 0)
        OptionButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        OptionButton.BorderSizePixel = 0
        OptionButton.Text = ""
        OptionButton.Parent = DropdownList
        
        local OptionCorner = Instance.new("UICorner")
        OptionCorner.CornerRadius = UDim.new(0, 4)
        OptionCorner.Parent = OptionButton
        
        local OptionIndicator = Instance.new("Frame")
        OptionIndicator.Size = UDim2.new(0, 3, 1, -6)
        OptionIndicator.Position = UDim2.new(0, 3, 0, 3)
        OptionIndicator.BackgroundColor3 = self.Theme.Accent
        OptionIndicator.BorderSizePixel = 0
        OptionIndicator.Visible = option == selectedValue
        OptionIndicator.Parent = OptionButton
        
        local IndicatorCorner = Instance.new("UICorner")
        IndicatorCorner.CornerRadius = UDim.new(1, 0)
        IndicatorCorner.Parent = OptionIndicator
        
        OptionIcon.Parent = OptionButton
        end
        
        local OptionLabel = Instance.new("TextLabel")
        OptionLabel.Size = UDim2.new(1, -20, 1, 0)
        OptionLabel.Position = UDim2.new(0, (config.OptionIcons and config.OptionIcons[i]) and 35 or 12, 0, 0)
        OptionLabel.BackgroundTransparency = 1
        OptionLabel.Text = option
        OptionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        OptionLabel.TextSize = 13
        OptionLabel.Font = Enum.Font.Gotham
        OptionLabel.TextXAlignment = Enum.TextXAlignment.Left
        OptionLabel.Parent = OptionButton
        
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
                config.Callback(option)
            end
            
            opened = false
            TweenService:Create(DropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Size = UDim2.new(1, -10, 0, 40)
            }):Play()
            TweenService:Create(DropdownIcon, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Rotation = 0
            }):Play()
        end)
    end
    
    DropdownButton.MouseButton1Click:Connect(function()
        opened = not opened
        
        if opened then
            local contentHeight = ListLayout.AbsoluteContentSize.Y + 50
            TweenService:Create(DropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Size = UDim2.new(1, -10, 0, contentHeight)
            }):Play()
            TweenService:Create(DropdownIcon, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Rotation = 180
            }):Play()
        else
            TweenService:Create(DropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Size = UDim2.new(1, -10, 0, 40)
            }):Play()
            TweenService:Create(DropdownIcon, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
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
                    local indicator = child:FindFirstChild("Frame")
                    local label = child:FindFirstChild("TextLabel")
                    if indicator and label then
                        indicator.Visible = (label.Text == value)
                    end
                end
            end
            
            if config.Callback then
                config.Callback(value)
            end
        end
    }
end

function Robox:AddSlider(parent, config)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = "Slider"
    SliderFrame.Size = UDim2.new(1, -10, 0, 50)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Parent = parent
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 6)
    SliderCorner.Parent = SliderFrame
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Size = UDim2.new(1, -70, 0, 20)
    SliderLabel.Position = UDim2.new(0, 10, 0, 8)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Text = config.Name
    SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SliderLabel.TextSize = 14
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.Parent = SliderFrame
    
    local SliderValue = Instance.new("TextLabel")
    SliderValue.Size = UDim2.new(0, 50, 0, 20)
    SliderValue.Position = UDim2.new(1, -60, 0, 8)
    SliderValue.BackgroundTransparency = 1
    SliderValue.Text = tostring(config.Default or config.Min)
    SliderValue.TextColor3 = self.Theme.Accent
    SliderValue.TextSize = 13
    SliderValue.Font = Enum.Font.GothamBold
    SliderValue.TextXAlignment = Enum.TextXAlignment.Right
    SliderValue.Parent = SliderFrame
    
    local SliderBar = Instance.new("Frame")
    SliderBar.Name = "SliderBar"
    SliderBar.Size = UDim2.new(1, -20, 0, 4)
    SliderBar.Position = UDim2.new(0, 10, 1, -15)
    SliderBar.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
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
            currentValue = math.floor(currentValue / config.Increment) * config.Increment
        end
        
        SliderValue.Text = tostring(currentValue)
        
        TweenService:Create(SliderFill, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
            Size = UDim2.new(relativeX, 0, 1, 0)
        }):Play()
        
        if config.Callback then
            config.Callback(currentValue)
        end
    end
    
    SliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            UpdateSlider(input)
        end
    end)
    
    SliderButton.MouseButton1Click:Connect(function(input)
        UpdateSlider(input)
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
                config.Callback(currentValue)
            end
        end
    }
end

function Robox:Notify(config)
    local NotificationFrame = Instance.new("Frame")
    NotificationFrame.Name = "Notification"
    NotificationFrame.Size = UDim2.new(0, 300, 0, 0)
    NotificationFrame.Position = UDim2.new(1, -320, 1, -20)
    NotificationFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    NotificationFrame.BorderSizePixel = 0
    NotificationFrame.ClipsDescendants = true
    NotificationFrame.Parent = self.ScreenGui
    
    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 8)
    NotifCorner.Parent = NotificationFrame
    
    if config.Icon then
        local NotifIcon = Instance.new("ImageLabel")
        NotifIcon.Size = UDim2.new(0, 20, 0, 20)
        NotifIcon.Position = UDim2.new(0, 10, 0, 10)
        NotifIcon.BackgroundTransparency = 1
        NotifIcon.Image = config.Icon
        NotifIcon.ImageColor3 = self.Theme.Accent
        NotifIcon.Parent = NotificationFrame
    end
    
    local NotifTitle = Instance.new("TextLabel")
    NotifTitle.Size = UDim2.new(1, -50, 0, 20)
    NotifTitle.Position = UDim2.new(0, config.Icon and 40 or 10, 0, 10)
    NotifTitle.BackgroundTransparency = 1
    NotifTitle.Text = config.Title or "Notification"
    NotifTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    NotifTitle.TextSize = 14
    NotifTitle.Font = Enum.Font.GothamBold
    NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
    NotifTitle.Parent = NotificationFrame
    
    local NotifText = Instance.new("TextLabel")
    NotifText.Size = UDim2.new(1, -20, 0, 0)
    NotifText.Position = UDim2.new(0, 10, 0, 35)
    NotifText.BackgroundTransparency = 1
    NotifText.Text = config.Text or ""
    NotifText.TextColor3 = Color3.fromRGB(255, 255, 255)
    NotifText.TextTransparency = 0.3
    NotifText.TextSize = 12
    NotifText.Font = Enum.Font.Gotham
    NotifText.TextXAlignment = Enum.TextXAlignment.Left
    NotifText.TextYAlignment = Enum.TextYAlignment.Top
    NotifText.TextWrapped = true
    NotifText.Parent = NotificationFrame
    
    local textBounds = game:GetService("TextService"):GetTextSize(
        config.Text or "",
        12,
        Enum.Font.Gotham,
        Vector2.new(280, math.huge)
    )
    
    local totalHeight = 50 + textBounds.Y
    NotifText.Size = UDim2.new(1, -20, 0, textBounds.Y)
    
    local LoadingBar = Instance.new("Frame")
    LoadingBar.Name = "LoadingBar"
    LoadingBar.Size = UDim2.new(1, 0, 0, 3)
    LoadingBar.Position = UDim2.new(0, 0, 1, -3)
    LoadingBar.BackgroundColor3 = self.Theme.Accent
    LoadingBar.BorderSizePixel = 0
    LoadingBar.Parent = NotificationFrame
    
    TweenService:Create(NotificationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0, 300, 0, totalHeight)
    }):Play()
    
    local duration = config.Duration or 5
    
    TweenService:Create(LoadingBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 0, 0, 3)
    }):Play()
    
    wait(duration)
    
    TweenService:Create(NotificationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0, 300, 0, 0)
    }):Play()
    
    wait(0.3)
    NotificationFrame:Destroy()
end

function Robox:ToggleMinimize()
    self.Minimized = not self.Minimized
    
    if self.Minimized then
        TweenService:Create(self.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 600, 0, 50)
        }):Play()
    else
        TweenService:Create(self.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 600, 0, 400)
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
    end
end

return Robox
