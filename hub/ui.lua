local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Robox = {}
Robox.__index = Robox

local Theme = {
    Background = Color3.fromRGB(15, 15, 17),
    Secondary = Color3.fromRGB(20, 20, 23),
    Tertiary = Color3.fromRGB(25, 25, 28),
    Accent = Color3.fromRGB(99, 102, 241),
    AccentGlow = Color3.fromRGB(129, 132, 255),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(160, 160, 170),
    Border = Color3.fromRGB(35, 35, 40)
}

function Robox.new(config)
    local self = setmetatable({}, Robox)
    self.Theme = Theme
    self.Title = tostring(config.Title or "Interface")
    self.Subtitle = tostring(config.Subtitle or "Modern UI")
    self.Minimized = false
    self.Visible = true
    self.Tabs = {}
    self.Notifications = {}
    self:CreateScreenGui()
    self:CreateWindow()
    self:CreateToggleButton()
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

function Robox:CreateWindow()
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.new(0, 500, 0, 380)
    self.MainFrame.Position = UDim2.new(0.5, -250, 0.5, -190)
    self.MainFrame.BackgroundColor3 = self.Theme.Background
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.ClipsDescendants = false
    self.MainFrame.Parent = self.ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = self.MainFrame
    
    local BorderStroke = Instance.new("UIStroke")
    BorderStroke.Color = self.Theme.Border
    BorderStroke.Thickness = 1
    BorderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    BorderStroke.Parent = self.MainFrame
    
    self:CreateTopBar()
    self:CreateTabBar()
    self:CreateContentArea()
    self:MakeDraggable()
end

function Robox:CreateTopBar()
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 45)
    TopBar.BackgroundTransparency = 1
    TopBar.BorderSizePixel = 0
    TopBar.Parent = self.MainFrame
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0, 180, 0, 18)
    TitleLabel.Position = UDim2.new(0, 16, 0, 8)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = tostring(self.Title)
    TitleLabel.TextColor3 = self.Theme.Text
    TitleLabel.TextSize = 14
    TitleLabel.Font = Enum.Font.GothamMedium
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TopBar
    
    local SubtitleLabel = Instance.new("TextLabel")
    SubtitleLabel.Size = UDim2.new(0, 180, 0, 14)
    SubtitleLabel.Position = UDim2.new(0, 16, 0, 26)
    SubtitleLabel.BackgroundTransparency = 1
    SubtitleLabel.Text = tostring(self.Subtitle)
    SubtitleLabel.TextColor3 = self.Theme.TextSecondary
    SubtitleLabel.TextSize = 11
    SubtitleLabel.Font = Enum.Font.Gotham
    SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubtitleLabel.Parent = TopBar
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 28, 0, 28)
    CloseButton.Position = UDim2.new(1, -38, 0, 8)
    CloseButton.BackgroundColor3 = self.Theme.Tertiary
    CloseButton.BackgroundTransparency = 0
    CloseButton.BorderSizePixel = 0
    CloseButton.Text = "X"
    CloseButton.TextColor3 = self.Theme.Text
    CloseButton.TextSize = 14
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = TopBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseButton
    
    CloseButton.MouseEnter:Connect(function()
        TweenService:Create(CloseButton, TweenInfo.new(0.15), {
            BackgroundColor3 = Color3.fromRGB(239, 68, 68)
        }):Play()
    end)
    
    CloseButton.MouseLeave:Connect(function()
        TweenService:Create(CloseButton, TweenInfo.new(0.15), {
            BackgroundColor3 = self.Theme.Tertiary
        }):Play()
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        self.ScreenGui:Destroy()
    end)
    
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Size = UDim2.new(0, 28, 0, 28)
    MinimizeButton.Position = UDim2.new(1, -72, 0, 8)
    MinimizeButton.BackgroundColor3 = self.Theme.Tertiary
    MinimizeButton.BackgroundTransparency = 0
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.Text = "-"
    MinimizeButton.TextColor3 = self.Theme.Text
    MinimizeButton.TextSize = 18
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Parent = TopBar
    
    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 6)
    MinCorner.Parent = MinimizeButton
    
    MinimizeButton.MouseEnter:Connect(function()
        TweenService:Create(MinimizeButton, TweenInfo.new(0.15), {
            BackgroundColor3 = self.Theme.Secondary
        }):Play()
    end)
    
    MinimizeButton.MouseLeave:Connect(function()
        TweenService:Create(MinimizeButton, TweenInfo.new(0.15), {
            BackgroundColor3 = self.Theme.Tertiary
        }):Play()
    end)
    
    MinimizeButton.MouseButton1Click:Connect(function()
        self:ToggleMinimize()
    end)
    
    local Divider = Instance.new("Frame")
    Divider.Size = UDim2.new(1, -32, 0, 1)
    Divider.Position = UDim2.new(0, 16, 1, 0)
    Divider.BackgroundColor3 = self.Theme.Border
    Divider.BorderSizePixel = 0
    Divider.Parent = TopBar
end

function Robox:CreateTabBar()
    self.TabBar = Instance.new("Frame")
    self.TabBar.Name = "TabBar"
    self.TabBar.Size = UDim2.new(0, 120, 1, -60)
    self.TabBar.Position = UDim2.new(0, 16, 0, 52)
    self.TabBar.BackgroundTransparency = 1
    self.TabBar.Parent = self.MainFrame
    
    self.TabList = Instance.new("UIListLayout")
    self.TabList.SortOrder = Enum.SortOrder.LayoutOrder
    self.TabList.Padding = UDim.new(0, 3)
    self.TabList.Parent = self.TabBar
end

function Robox:CreateContentArea()
    self.ContentArea = Instance.new("ScrollingFrame")
    self.ContentArea.Name = "ContentArea"
    self.ContentArea.Size = UDim2.new(1, -152, 1, -68)
    self.ContentArea.Position = UDim2.new(0, 144, 0, 52)
    self.ContentArea.BackgroundTransparency = 1
    self.ContentArea.BorderSizePixel = 0
    self.ContentArea.ScrollBarThickness = 2
    self.ContentArea.ScrollBarImageColor3 = self.Theme.Accent
    self.ContentArea.ScrollBarImageTransparency = 0.5
    self.ContentArea.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.ContentArea.Parent = self.MainFrame
    
    local ContentList = Instance.new("UIListLayout")
    ContentList.SortOrder = Enum.SortOrder.LayoutOrder
    ContentList.Padding = UDim.new(0, 6)
    ContentList.Parent = self.ContentArea
    
    ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.ContentArea.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 8)
    end)
end

function Robox:CreateToggleButton()
    self.ToggleBtn = Instance.new("TextButton")
    self.ToggleBtn.Name = "ToggleButton"
    self.ToggleBtn.Size = UDim2.new(0, 70, 0, 32)
    self.ToggleBtn.Position = UDim2.new(1, -80, 0, 10)
    self.ToggleBtn.BackgroundColor3 = self.Theme.Accent
    self.ToggleBtn.BorderSizePixel = 0
    self.ToggleBtn.Text = "Hide"
    self.ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.ToggleBtn.TextSize = 13
    self.ToggleBtn.Font = Enum.Font.GothamMedium
    self.ToggleBtn.Parent = self.ScreenGui
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = self.ToggleBtn
    
    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Color = self.Theme.AccentGlow
    BtnStroke.Thickness = 1
    BtnStroke.Transparency = 0.5
    BtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    BtnStroke.Parent = self.ToggleBtn
    
    self.ToggleBtn.MouseButton1Click:Connect(function()
        self:ToggleVisibility()
    end)
    
    self.ToggleBtn.MouseEnter:Connect(function()
        TweenService:Create(self.ToggleBtn, TweenInfo.new(0.15), {
            BackgroundColor3 = self.Theme.AccentGlow
        }):Play()
    end)
    
    self.ToggleBtn.MouseLeave:Connect(function()
        TweenService:Create(self.ToggleBtn, TweenInfo.new(0.15), {
            BackgroundColor3 = self.Theme.Accent
        }):Play()
    end)
end

function Robox:AddTab(config)
    local tabName = tostring(config.Name or "Tab")
    
    local TabButton = Instance.new("TextButton")
    TabButton.Name = tabName
    TabButton.Size = UDim2.new(1, 0, 0, 32)
    TabButton.BackgroundColor3 = self.Theme.Tertiary
    TabButton.BackgroundTransparency = 0.5
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
    
    local TabLabel = Instance.new("TextLabel")
    TabLabel.Size = UDim2.new(1, -16, 1, 0)
    TabLabel.Position = UDim2.new(0, 10, 0, 0)
    TabLabel.BackgroundTransparency = 1
    TabLabel.Text = tabName
    TabLabel.TextColor3 = self.Theme.TextSecondary
    TabLabel.TextSize = 12
    TabLabel.Font = Enum.Font.GothamMedium
    TabLabel.TextXAlignment = Enum.TextXAlignment.Left
    TabLabel.Parent = TabButton
    
    local TabContent = Instance.new("Frame")
    TabContent.Name = tabName .. "Content"
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
        Name = tabName,
        Label = TabLabel,
        Indicator = TabIndicator
    })
    
    TabButton.MouseEnter:Connect(function()
        if not TabContent.Visible then
            TweenService:Create(TabButton, TweenInfo.new(0.15), {BackgroundTransparency = 0.2}):Play()
        end
    end)
    
    TabButton.MouseLeave:Connect(function()
        if not TabContent.Visible then
            TweenService:Create(TabButton, TweenInfo.new(0.15), {BackgroundTransparency = 0.5}):Play()
        end
    end)
    
    TabButton.MouseButton1Click:Connect(function()
        self:SelectTab(tabName)
    end)
    
    if #self.Tabs == 1 then
        self:SelectTab(tabName)
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
            TweenService:Create(tab.Button, TweenInfo.new(0.2), {
                BackgroundTransparency = 0.2
            }):Play()
            TweenService:Create(tab.Label, TweenInfo.new(0.2), {TextColor3 = self.Theme.Text}):Play()
            TweenService:Create(tab.Indicator, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                Size = UDim2.new(0, 3, 0, 20)
            }):Play()
        else
            tab.Content.Visible = false
            TweenService:Create(tab.Button, TweenInfo.new(0.2), {
                BackgroundTransparency = 0.5
            }):Play()
            TweenService:Create(tab.Label, TweenInfo.new(0.2), {TextColor3 = self.Theme.TextSecondary}):Play()
            TweenService:Create(tab.Indicator, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                Size = UDim2.new(0, 3, 0, 0)
            }):Play()
        end
    end
end

function Robox:AddSection(parent, config)
    local sectionName = tostring(config.Name or "Section")
    
    local Section = Instance.new("Frame")
    Section.Name = "Section"
    Section.Size = UDim2.new(1, -8, 0, 24)
    Section.BackgroundTransparency = 1
    Section.Parent = parent
    
    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Size = UDim2.new(1, 0, 1, 0)
    SectionTitle.BackgroundTransparency = 1
    SectionTitle.Text = sectionName
    SectionTitle.TextColor3 = self.Theme.Text
    SectionTitle.TextSize = 13
    SectionTitle.Font = Enum.Font.GothamMedium
    SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    SectionTitle.Parent = Section
    
    return Section
end

function Robox:AddToggle(parent, config)
    local toggleName = tostring(config.Name or "Toggle")
    
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = "Toggle"
    ToggleFrame.Size = UDim2.new(1, -8, 0, 36)
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
    ToggleLabel.Text = toggleName
    ToggleLabel.TextColor3 = self.Theme.Text
    ToggleLabel.TextSize = 12
    ToggleLabel.Font = Enum.Font.Gotham
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
            TweenService:Create(ToggleButton, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                BackgroundColor3 = self.Theme.Accent
            }):Play()
            TweenService:Create(ToggleSlider, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                Position = UDim2.new(1, -20, 0.5, -9)
            }):Play()
        else
            TweenService:Create(ToggleButton, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                BackgroundColor3 = self.Theme.Tertiary
            }):Play()
            TweenService:Create(ToggleSlider, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                Position = UDim2.new(0, 2, 0.5, -9)
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
    local buttonName = tostring(config.Name or "Button")
    
    local ButtonFrame = Instance.new("TextButton")
    ButtonFrame.Name = "Button"
    ButtonFrame.Size = UDim2.new(1, -8, 0, 36)
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
    ButtonLabel.Text = buttonName
    ButtonLabel.TextColor3 = self.Theme.Text
    ButtonLabel.TextSize = 12
    ButtonLabel.Font = Enum.Font.Gotham
    ButtonLabel.TextXAlignment = Enum.TextXAlignment.Left
    ButtonLabel.Parent = ButtonFrame
    
    ButtonFrame.MouseEnter:Connect(function()
        TweenService:Create(ButtonFrame, TweenInfo.new(0.15), {
            BackgroundColor3 = self.Theme.Tertiary
        }):Play()
    end)
    
    ButtonFrame.MouseLeave:Connect(function()
        TweenService:Create(ButtonFrame, TweenInfo.new(0.15), {
            BackgroundColor3 = self.Theme.Secondary
        }):Play()
    end)
    
    ButtonFrame.MouseButton1Click:Connect(function()
        TweenService:Create(ButtonFrame, TweenInfo.new(0.08), {
            BackgroundColor3 = self.Theme.Accent
        }):Play()
        task.wait(0.08)
        TweenService:Create(ButtonFrame, TweenInfo.new(0.08), {
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
    local dropdownName = tostring(config.Name or "Dropdown")
    local options = config.Options or {"Option 1"}
    local defaultValue = tostring(config.Default or options[1])
    
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Name = "Dropdown"
    DropdownFrame.Size = UDim2.new(1, -8, 0, 36)
    DropdownFrame.BackgroundColor3 = self.Theme.Secondary
    DropdownFrame.BorderSizePixel = 0
    DropdownFrame.ClipsDescendants = true
    DropdownFrame.Parent = parent
    
    local DropdownCorner = Instance.new("UICorner")
    DropdownCorner.CornerRadius = UDim.new(0, 8)
    DropdownCorner.Parent = DropdownFrame
    
    local DropdownLabel = Instance.new("TextLabel")
    DropdownLabel.Size = UDim2.new(0.5, 0, 0, 36)
    DropdownLabel.Position = UDim2.new(0, 12, 0, 0)
    DropdownLabel.BackgroundTransparency = 1
    DropdownLabel.Text = dropdownName
    DropdownLabel.TextColor3 = self.Theme.Text
    DropdownLabel.TextSize = 12
    DropdownLabel.Font = Enum.Font.Gotham
    DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
    DropdownLabel.Parent = DropdownFrame
    
    local DropdownValue = Instance.new("TextLabel")
    DropdownValue.Size = UDim2.new(0.5, -36, 0, 36)
    DropdownValue.Position = UDim2.new(0.5, 0, 0, 0)
    DropdownValue.BackgroundTransparency = 1
    DropdownValue.Text = defaultValue
    DropdownValue.TextColor3 = self.Theme.Accent
    DropdownValue.TextSize = 11
    DropdownValue.Font = Enum.Font.GothamMedium
    DropdownValue.TextXAlignment = Enum.TextXAlignment.Right
    DropdownValue.Parent = DropdownFrame
    
    local DropdownArrow = Instance.new("TextLabel")
    DropdownArrow.Size = UDim2.new(0, 20, 0, 36)
    DropdownArrow.Position = UDim2.new(1, -28, 0, 0)
    DropdownArrow.BackgroundTransparency = 1
    DropdownArrow.Text = "v"
    DropdownArrow.TextColor3 = self.Theme.TextSecondary
    DropdownArrow.TextSize = 10
    DropdownArrow.Font = Enum.Font.GothamMedium
    DropdownArrow.Parent = DropdownFrame
    
    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Size = UDim2.new(1, 0, 0, 36)
    DropdownButton.BackgroundTransparency = 1
    DropdownButton.Text = ""
    DropdownButton.Parent = DropdownFrame
    
    local DropdownList = Instance.new("Frame")
    DropdownList.Name = "DropdownList"
    DropdownList.Size = UDim2.new(1, 0, 0, 0)
    DropdownList.Position = UDim2.new(0, 0, 0, 40)
    DropdownList.BackgroundTransparency = 1
    DropdownList.Parent = DropdownFrame
    
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Padding = UDim.new(0, 2)
    ListLayout.Parent = DropdownList
    
    local opened = false
    local selectedValue = defaultValue
    
    for i, option in ipairs(options) do
        local optionStr = tostring(option)
        
        local OptionButton = Instance.new("TextButton")
        OptionButton.Size = UDim2.new(1, -8, 0, 30)
        OptionButton.Position = UDim2.new(0, 4, 0, 0)
        OptionButton.BackgroundColor3 = self.Theme.Tertiary
        OptionButton.BorderSizePixel = 0
        OptionButton.Text = ""
        OptionButton.Parent = DropdownList
        
        local OptionCorner = Instance.new("UICorner")
        OptionCorner.CornerRadius = UDim.new(0, 6)
        OptionCorner.Parent = OptionButton
        
        local OptionLabel = Instance.new("TextLabel")
        OptionLabel.Size = UDim2.new(1, -16, 1, 0)
        OptionLabel.Position = UDim2.new(0, 8, 0, 0)
        OptionLabel.BackgroundTransparency = 1
        OptionLabel.Text = optionStr
        OptionLabel.TextColor3 = self.Theme.Text
        OptionLabel.TextSize = 11
        OptionLabel.Font = Enum.Font.Gotham
        OptionLabel.TextXAlignment = Enum.TextXAlignment.Left
        OptionLabel.Parent = OptionButton
        
        OptionButton.MouseEnter:Connect(function()
            TweenService:Create(OptionButton, TweenInfo.new(0.15), {
                BackgroundColor3 = self.Theme.Accent
            }):Play()
            TweenService:Create(OptionLabel, TweenInfo.new(0.15), {
                TextColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
        end)
        
        OptionButton.MouseLeave:Connect(function()
            TweenService:Create(OptionButton, TweenInfo.new(0.15), {
                BackgroundColor3 = self.Theme.Tertiary
            }):Play()
            TweenService:Create(OptionLabel, TweenInfo.new(0.15), {
                TextColor3 = self.Theme.Text
            }):Play()
        end)
        
        OptionButton.MouseButton1Click:Connect(function()
            selectedValue = optionStr
            DropdownValue.Text = optionStr
            
            if config.Callback then
                pcall(function()
                    config.Callback(optionStr)
                end)
            end
            
            opened = false
            TweenService:Create(DropdownFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                Size = UDim2.new(1, -8, 0, 36)
            }):Play()
            TweenService:Create(DropdownArrow, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                Rotation = 0
            }):Play()
        end)
    end
    
    DropdownButton.MouseButton1Click:Connect(function()
        opened = not opened
        if opened then
            local contentHeight = ListLayout.AbsoluteContentSize.Y + 46
            TweenService:Create(DropdownFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                Size = UDim2.new(1, -8, 0, contentHeight)
            }):Play()
            TweenService:Create(DropdownArrow, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                Rotation = 180
            }):Play()
        else
            TweenService:Create(DropdownFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                Size = UDim2.new(1, -8, 0, 36)
            }):Play()
            TweenService:Create(DropdownArrow, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                Rotation = 0
            }):Play()
        end
    end)
    
    return {
        SetValue = function(value)
            local valueStr = tostring(value)
            selectedValue = valueStr
            DropdownValue.Text = valueStr
            
            if config.Callback then
                pcall(function()
                    config.Callback(valueStr)
                end)
            end
        end
    }
end

function Robox:AddSlider(parent, config)
    local sliderName = tostring(config.Name or "Slider")
    local minValue = tonumber(config.Min) or 0
    local maxValue = tonumber(config.Max) or 100
    local defaultValue = tonumber(config.Default) or minValue
    local increment = tonumber(config.Increment) or 1
    
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
    SliderLabel.Text = sliderName
    SliderLabel.TextColor3 = self.Theme.Text
    SliderLabel.TextSize = 12
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.Parent = SliderFrame
    
    local SliderValue = Instance.new("TextLabel")
    SliderValue.Size = UDim2.new(0.35, -12, 0, 18)
    SliderValue.Position = UDim2.new(0.65, 0, 0, 6)
    SliderValue.BackgroundTransparency = 1
    SliderValue.Text = tostring(defaultValue)
    SliderValue.TextColor3 = self.Theme.Accent
    SliderValue.TextSize = 12
    SliderValue.Font = Enum.Font.GothamMedium
    SliderValue.TextXAlignment = Enum.TextXAlignment.Right
    SliderValue.Parent = SliderFrame
    
    local SliderBar = Instance.new("Frame")
    SliderBar.Name = "SliderBar"
    SliderBar.Size = UDim2.new(1, -24, 0, 3)
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
    local currentValue = defaultValue
    
    local function UpdateSlider(input)
        local relativeX = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        currentValue = math.floor(minValue + (maxValue - minValue) * relativeX)
        
        if increment then
            currentValue = math.floor(currentValue / increment + 0.5) * increment
        end
        
        SliderValue.Text = tostring(currentValue)
        
        local fillSize = relativeX * SliderBar.AbsoluteSize.X
        TweenService:Create(SliderFill, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
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
    
    local initialPercentage = (currentValue - minValue) / (maxValue - minValue)
    local initialFillSize = initialPercentage * SliderBar.AbsoluteSize.X
    SliderFill.Size = UDim2.new(0, initialFillSize, 1, 0)
    
    return {
        SetValue = function(value)
            currentValue = math.clamp(tonumber(value) or minValue, minValue, maxValue)
            SliderValue.Text = tostring(currentValue)
            local percentage = (currentValue - minValue) / (maxValue - minValue)
            local fillSize = percentage * SliderBar.AbsoluteSize.X
            TweenService:Create(SliderFill, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
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
    local notifTitle = tostring(config.Title or "Notification")
    local notifText = tostring(config.Text or "")
    local notifDuration = tonumber(config.Duration) or 3
    
    local NotificationFrame = Instance.new("Frame")
    NotificationFrame.Name = "Notification"
    NotificationFrame.Size = UDim2.new(0, 280, 0, 0)
    NotificationFrame.Position = UDim2.new(1, -295, 1, -15)
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
    
    local NotifTitle = Instance.new("TextLabel")
    NotifTitle.Size = UDim2.new(1, -16, 0, 18)
    NotifTitle.Position = UDim2.new(0, 8, 0, 10)
    NotifTitle.BackgroundTransparency = 1
    NotifTitle.Text = notifTitle
    NotifTitle.TextColor3 = self.Theme.Text
    NotifTitle.TextSize = 12
    NotifTitle.Font = Enum.Font.GothamMedium
    NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
    NotifTitle.Parent = NotificationFrame
    
    local NotifText = Instance.new("TextLabel")
    NotifText.Size = UDim2.new(1, -16, 0, 0)
    NotifText.Position = UDim2.new(0, 8, 0, 32)
    NotifText.BackgroundTransparency = 1
    NotifText.Text = notifText
    NotifText.TextColor3 = self.Theme.TextSecondary
    NotifText.TextSize = 11
    NotifText.Font = Enum.Font.Gotham
    NotifText.TextXAlignment = Enum.TextXAlignment.Left
    NotifText.TextYAlignment = Enum.TextYAlignment.Top
    NotifText.TextWrapped = true
    NotifText.Parent = NotificationFrame
    
    local textBounds = game:GetService("TextService"):GetTextSize(
        notifText,
        11,
        Enum.Font.Gotham,
        Vector2.new(264, math.huge)
    )
    
    local totalHeight = 46 + textBounds.Y
    NotifText.Size = UDim2.new(1, -16, 0, textBounds.Y)
    
    local LoadingBar = Instance.new("Frame")
    LoadingBar.Name = "LoadingBar"
    LoadingBar.Size = UDim2.new(1, 0, 0, 2)
    LoadingBar.Position = UDim2.new(0, 0, 1, -2)
    LoadingBar.BackgroundColor3 = self.Theme.Accent
    LoadingBar.BorderSizePixel = 0
    LoadingBar.Parent = NotificationFrame
    
    TweenService:Create(NotificationFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0, 280, 0, totalHeight),
        Position = UDim2.new(1, -295, 1, -totalHeight - 15)
    }):Play()
    
    TweenService:Create(LoadingBar, TweenInfo.new(notifDuration, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 0, 0, 2)
    }):Play()
    
    task.wait(notifDuration)
    
    TweenService:Create(NotificationFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0, 280, 0, 0),
        Position = UDim2.new(1, -295, 1, -15)
    }):Play()
    
    task.wait(0.25)
    NotificationFrame:Destroy()
end

function Robox:ToggleMinimize()
    self.Minimized = not self.Minimized
    if self.Minimized then
        self.TabBar.Visible = false
        self.ContentArea.Visible = false
        TweenService:Create(self.MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 500, 0, 45)
        }):Play()
    else
        self.TabBar.Visible = true
        self.ContentArea.Visible = true
        TweenService:Create(self.MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 500, 0, 380)
        }):Play()
    end
end

function Robox:ToggleVisibility()
    self.Visible = not self.Visible
    if self.Visible then
        self.MainFrame.Visible = true
        TweenService:Create(self.MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Position = UDim2.new(0.5, -250, 0.5, -190)
        }):Play()
        self.ToggleBtn.Text = "Hide"
    else
        TweenService:Create(self.MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Position = UDim2.new(0.5, -250, 1.5, 0)
        }):Play()
        task.wait(0.2)
        self.MainFrame.Visible = false
        self.ToggleBtn.Text = "Open"
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
        self.Theme = Theme
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
