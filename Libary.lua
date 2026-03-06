--[[
    ███████╗ █████╗ ████████╗ █████╗ ██╗     ██╗████████╗██╗   ██╗    ██╗    ██╗
    ██╔════╝██╔══██╗╚══██╔══╝██╔══██╗██║     ██║╚══██╔══╝╚██╗ ██╔╝    ██║    ██║
    █████╗  ███████║   ██║   ███████║██║     ██║   ██║    ╚████╔╝     ██║ █╗ ██║
    ██╔══╝  ██╔══██║   ██║   ██╔══██║██║     ██║   ██║     ╚██╔╝      ██║███╗██║
    ██║     ██║  ██║   ██║   ██║  ██║███████╗██║   ██║      ██║       ╚███╔███╔╝
    ╚═╝     ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝   ╚═╝      ╚═╝        ╚══╝╚══╝ 
    
    Fatality W Library v1.0.0
    Custom UI Library
]]

--// ═══════════════════════════════════════════════════════════════════════════════ \\--
--//                                 DOWN SYSTEM                                      \\--
--// ═══════════════════════════════════════════════════════════════════════════════ \\--

local Down = false -- SET TO true TO DISABLE SCRIPT
local KickMessage = "Fatality W Library is currently down for maintenance. Please try again later."

if Down then
    game:GetService("Players").LocalPlayer:Kick(KickMessage)
    return nil
end

--// ═══════════════════════════════════════════════════════════════════════════════ \\--
--//                                   SERVICES                                       \\--
--// ═══════════════════════════════════════════════════════════════════════════════ \\--

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TextService = game:GetService("TextService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

--// ═══════════════════════════════════════════════════════════════════════════════ \\--
--//                                  VARIABLES                                       \\--
--// ═══════════════════════════════════════════════════════════════════════════════ \\--

local ProtectGui = protectgui or (syn and syn.protect_gui) or function() end

local Toggles = {}
local Options = {}

getgenv().Toggles = Toggles
getgenv().Options = Options

--// ═══════════════════════════════════════════════════════════════════════════════ \\--
--//                                   LIBRARY                                        \\--
--// ═══════════════════════════════════════════════════════════════════════════════ \\--

local FatalityLib = {
    Name = "Fatality W Library",
    Version = "1.0.0",
    
    -- Theme
    Theme = {
        Primary = Color3.fromRGB(15, 15, 20),
        Secondary = Color3.fromRGB(20, 20, 28),
        Tertiary = Color3.fromRGB(25, 25, 35),
        Accent = Color3.fromRGB(130, 80, 245),
        AccentDark = Color3.fromRGB(100, 60, 200),
        Text = Color3.fromRGB(255, 255, 255),
        TextDark = Color3.fromRGB(180, 180, 180),
        Border = Color3.fromRGB(40, 40, 55),
        Risk = Color3.fromRGB(255, 75, 75),
        Success = Color3.fromRGB(75, 255, 130),
    },
    
    Flags = {},
    Connections = {},
    ScreenGui = nil,
    Toggled = false,
    
    Down = Down,
    KickMessage = KickMessage,
}

--// Utility Functions
local function Create(instanceType, properties)
    local instance = Instance.new(instanceType)
    for prop, value in pairs(properties) do
        if prop ~= "Parent" then
            instance[prop] = value
        end
    end
    if properties.Parent then
        instance.Parent = properties.Parent
    end
    return instance
end

local function Tween(instance, properties, duration, style, direction)
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(duration or 0.2, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out),
        properties
    )
    tween:Play()
    return tween
end

local function GetTextSize(text, size, font, bounds)
    return TextService:GetTextSize(text, size, font, bounds or Vector2.new(math.huge, math.huge))
end

local function Ripple(button)
    spawn(function()
        local ripple = Create("Frame", {
            Name = "Ripple",
            Parent = button,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.8,
            BorderSizePixel = 0,
            Position = UDim2.new(0, Mouse.X - button.AbsolutePosition.X, 0, Mouse.Y - button.AbsolutePosition.Y),
            Size = UDim2.new(0, 0, 0, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            ZIndex = button.ZIndex + 1,
        })
        
        Create("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = ripple,
        })
        
        local size = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
        Tween(ripple, {Size = UDim2.new(0, size, 0, size), BackgroundTransparency = 1}, 0.5)
        
        wait(0.5)
        ripple:Destroy()
    end)
end

--// ═══════════════════════════════════════════════════════════════════════════════ \\--
--//                              DOWN SYSTEM METHODS                                 \\--
--// ═══════════════════════════════════════════════════════════════════════════════ \\--

function FatalityLib:SetDown(isDown, message)
    Down = isDown
    self.Down = isDown
    if message then
        KickMessage = message
        self.KickMessage = message
    end
    if isDown then
        LocalPlayer:Kick(KickMessage)
    end
end

function FatalityLib:IsDown()
    return Down
end

--// ═══════════════════════════════════════════════════════════════════════════════ \\--
--//                               NOTIFICATION SYSTEM                                \\--
--// ═══════════════════════════════════════════════════════════════════════════════ \\--

function FatalityLib:Notify(options)
    options = options or {}
    local title = options.Title or "Notification"
    local content = options.Content or ""
    local duration = options.Duration or 3
    local type_ = options.Type or "Info"
    
    local typeColors = {
        Info = self.Theme.Accent,
        Success = self.Theme.Success,
        Warning = Color3.fromRGB(255, 200, 50),
        Error = self.Theme.Risk,
    }
    
    local notifHolder = self.ScreenGui:FindFirstChild("NotificationHolder")
    if not notifHolder then
        notifHolder = Create("Frame", {
            Name = "NotificationHolder",
            Parent = self.ScreenGui,
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -20, 0, 20),
            Size = UDim2.new(0, 300, 1, -40),
            AnchorPoint = Vector2.new(1, 0),
        })
        
        Create("UIListLayout", {
            Parent = notifHolder,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10),
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            VerticalAlignment = Enum.VerticalAlignment.Top,
        })
    end
    
    local notif = Create("Frame", {
        Name = "Notification",
        Parent = notifHolder,
        BackgroundColor3 = self.Theme.Secondary,
        Size = UDim2.new(1, 0, 0, 0),
        ClipsDescendants = true,
        BackgroundTransparency = 1,
    })
    
    Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = notif,
    })
    
    Create("UIStroke", {
        Parent = notif,
        Color = self.Theme.Border,
        Thickness = 1,
    })
    
    local accent = Create("Frame", {
        Name = "Accent",
        Parent = notif,
        BackgroundColor3 = typeColors[type_] or self.Theme.Accent,
        Size = UDim2.new(0, 3, 1, 0),
        BorderSizePixel = 0,
    })
    
    Create("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = accent,
    })
    
    local titleLabel = Create("TextLabel", {
        Name = "Title",
        Parent = notif,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 10),
        Size = UDim2.new(1, -25, 0, 20),
        Font = Enum.Font.GothamBold,
        Text = title,
        TextColor3 = self.Theme.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    local contentLabel = Create("TextLabel", {
        Name = "Content",
        Parent = notif,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 32),
        Size = UDim2.new(1, -25, 0, 0),
        Font = Enum.Font.Gotham,
        Text = content,
        TextColor3 = self.Theme.TextDark,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
    })
    
    local textSize = GetTextSize(content, 13, Enum.Font.Gotham, Vector2.new(260, math.huge))
    contentLabel.Size = UDim2.new(1, -25, 0, textSize.Y)
    
    local totalHeight = 50 + textSize.Y
    
    -- Animate in
    Tween(notif, {Size = UDim2.new(1, 0, 0, totalHeight), BackgroundTransparency = 0}, 0.3)
    
    -- Auto remove
    spawn(function()
        wait(duration)
        Tween(notif, {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1}, 0.3)
        wait(0.3)
        notif:Destroy()
    end)
    
    return notif
end

--// ═══════════════════════════════════════════════════════════════════════════════ \\--
--//                                 CREATE WINDOW                                    \\--
--// ═══════════════════════════════════════════════════════════════════════════════ \\--

function FatalityLib:CreateWindow(options)
    options = options or {}
    local title = options.Title or "Fatality W Library"
    local subtitle = options.Subtitle or "v1.0.0"
    local size = options.Size or UDim2.new(0, 600, 0, 450)
    local toggleKey = options.ToggleKey or Enum.KeyCode.RightShift
    
    -- Create ScreenGui
    local screenGui = Create("ScreenGui", {
        Name = "FatalityWLibrary",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })
    
    ProtectGui(screenGui)
    screenGui.Parent = CoreGui
    self.ScreenGui = screenGui
    
    -- Main Window
    local main = Create("Frame", {
        Name = "Main",
        Parent = screenGui,
        BackgroundColor3 = self.Theme.Primary,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = size,
        AnchorPoint = Vector2.new(0.5, 0.5),
        ClipsDescendants = true,
    })
    
    Create("UICorner", {
        CornerRadius = UDim.new(0, 10),
        Parent = main,
    })
    
    Create("UIStroke", {
        Parent = main,
        Color = self.Theme.Border,
        Thickness = 1,
    })
    
    -- Shadow
    local shadow = Create("ImageLabel", {
        Name = "Shadow",
        Parent = main,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, 50, 1, 50),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = "rbxassetid://5554236805",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        ZIndex = -1,
    })
    
    -- Top Bar
    local topBar = Create("Frame", {
        Name = "TopBar",
        Parent = main,
        BackgroundColor3 = self.Theme.Secondary,
        Size = UDim2.new(1, 0, 0, 50),
        BorderSizePixel = 0,
    })
    
    Create("UICorner", {
        CornerRadius = UDim.new(0, 10),
        Parent = topBar,
    })
    
    -- Fix corner
    local topBarFix = Create("Frame", {
        Name = "Fix",
        Parent = topBar,
        BackgroundColor3 = self.Theme.Secondary,
        Position = UDim2.new(0, 0, 1, -10),
        Size = UDim2.new(1, 0, 0, 10),
        BorderSizePixel = 0,
    })
    
    -- Accent Line
    local accentLine = Create("Frame", {
        Name = "AccentLine",
        Parent = topBar,
        BackgroundColor3 = self.Theme.Accent,
        Position = UDim2.new(0, 0, 1, 0),
        Size = UDim2.new(1, 0, 0, 2),
        BorderSizePixel = 0,
    })
    
    -- Title
    local titleLabel = Create("TextLabel", {
        Name = "Title",
        Parent = topBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(0.5, 0, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = title,
        TextColor3 = self.Theme.Text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    -- Subtitle
    local subtitleLabel = Create("TextLabel", {
        Name = "Subtitle",
        Parent = topBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -15, 0, 0),
        Size = UDim2.new(0.3, 0, 1, 0),
        Font = Enum.Font.Gotham,
        Text = subtitle,
        TextColor3 = self.Theme.Accent,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Right,
    })
    
    -- Tab Container
    local tabContainer = Create("Frame", {
        Name = "TabContainer",
        Parent = main,
        BackgroundColor3 = self.Theme.Secondary,
        Position = UDim2.new(0, 0, 0, 52),
        Size = UDim2.new(0, 150, 1, -52),
        BorderSizePixel = 0,
    })
    
    local tabList = Create("ScrollingFrame", {
        Name = "TabList",
        Parent = tabContainer,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 10),
        Size = UDim2.new(1, -20, 1, -20),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = self.Theme.Accent,
        BorderSizePixel = 0,
    })
    
    Create("UIListLayout", {
        Parent = tabList,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5),
    })
    
    -- Content Container
    local contentContainer = Create("Frame", {
        Name = "ContentContainer",
        Parent = main,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 150, 0, 52),
        Size = UDim2.new(1, -150, 1, -52),
        BorderSizePixel = 0,
    })
    
    -- Dragging
    local dragging, dragStart, startPos
    
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
        end
    end)
    
    topBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Toggle Visibility
    self.Toggled = true
    
    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == toggleKey then
            self.Toggled = not self.Toggled
            main.Visible = self.Toggled
        end
    end)
    
    -- Window Object
    local Window = {
        Main = main,
        TabContainer = tabContainer,
        TabList = tabList,
        ContentContainer = contentContainer,
        Tabs = {},
    }
    
    --// ═══════════════════════════════════════════════════════════════════════════════ \\--
    --//                                   ADD TAB                                        \\--
    --// ═══════════════════════════════════════════════════════════════════════════════ \\--
    
    function Window:AddTab(options)
        options = options or {}
        local name = options.Name or "Tab"
        local icon = options.Icon or ""
        
        local tabButton = Create("TextButton", {
            Name = name,
            Parent = tabList,
            BackgroundColor3 = FatalityLib.Theme.Tertiary,
            Size = UDim2.new(1, 0, 0, 35),
            Font = Enum.Font.Gotham,
            Text = "  " .. name,
            TextColor3 = FatalityLib.Theme.TextDark,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false,
            BorderSizePixel = 0,
        })
        
        Create("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = tabButton,
        })
        
        Create("UIPadding", {
            Parent = tabButton,
            PaddingLeft = UDim.new(0, 10),
        })
        
        local tabContent = Create("ScrollingFrame", {
            Name = name .. "Content",
            Parent = contentContainer,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 10),
            Size = UDim2.new(1, -20, 1, -20),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = FatalityLib.Theme.Accent,
            Visible = false,
            BorderSizePixel = 0,
        })
        
        Create("UIListLayout", {
            Parent = tabContent,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10),
        })
        
        -- Update canvas size
        tabContent.ChildAdded:Connect(function()
            wait()
            local layout = tabContent:FindFirstChild("UIListLayout")
            if layout then
                tabContent.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
            end
        end)
        
        -- First tab is selected
        if #self.Tabs == 0 then
            tabContent.Visible = true
            tabButton.BackgroundColor3 = FatalityLib.Theme.Accent
            tabButton.TextColor3 = FatalityLib.Theme.Text
        end
        
        tabButton.MouseButton1Click:Connect(function()
            Ripple(tabButton)
            
            for _, tab in pairs(self.Tabs) do
                tab.Content.Visible = false
                Tween(tab.Button, {BackgroundColor3 = FatalityLib.Theme.Tertiary, TextColor3 = FatalityLib.Theme.TextDark}, 0.2)
            end
            
            tabContent.Visible = true
            Tween(tabButton, {BackgroundColor3 = FatalityLib.Theme.Accent, TextColor3 = FatalityLib.Theme.Text}, 0.2)
        end)
        
        tabButton.MouseEnter:Connect(function()
            if not tabContent.Visible then
                Tween(tabButton, {BackgroundColor3 = FatalityLib.Theme.Border}, 0.2)
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if not tabContent.Visible then
                Tween(tabButton, {BackgroundColor3 = FatalityLib.Theme.Tertiary}, 0.2)
            end
        end)
        
        -- Tab Object
        local Tab = {
            Button = tabButton,
            Content = tabContent,
            Sections = {},
        }
        
        table.insert(self.Tabs, Tab)
        
        --// ═══════════════════════════════════════════════════════════════════════════════ \\--
        --//                                  ADD SECTION                                     \\--
        --// ═══════════════════════════════════════════════════════════════════════════════ \\--
        
        function Tab:AddSection(options)
            options = options or {}
            local name = options.Name or "Section"
            
            local section = Create("Frame", {
                Name = name,
                Parent = tabContent,
                BackgroundColor3 = FatalityLib.Theme.Secondary,
                Size = UDim2.new(1, 0, 0, 40),
                BorderSizePixel = 0,
                ClipsDescendants = true,
            })
            
            Create("UICorner", {
                CornerRadius = UDim.new(0, 8),
                Parent = section,
            })
            
            Create("UIStroke", {
                Parent = section,
                Color = FatalityLib.Theme.Border,
                Thickness = 1,
            })
            
            local sectionTitle = Create("TextLabel", {
                Name = "Title",
                Parent = section,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(1, -24, 0, 35),
                Font = Enum.Font.GothamBold,
                Text = name,
                TextColor3 = FatalityLib.Theme.Text,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
            })
            
            local sectionContent = Create("Frame", {
                Name = "Content",
                Parent = section,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 35),
                Size = UDim2.new(1, -24, 0, 0),
            })
            
            Create("UIListLayout", {
                Parent = sectionContent,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 8),
            })
            
            local function updateSectionSize()
                wait()
                local layout = sectionContent:FindFirstChild("UIListLayout")
                if layout then
                    local contentHeight = layout.AbsoluteContentSize.Y
                    sectionContent.Size = UDim2.new(1, -24, 0, contentHeight)
                    section.Size = UDim2.new(1, 0, 0, 45 + contentHeight)
                end
            end
            
            sectionContent.ChildAdded:Connect(updateSectionSize)
            sectionContent.ChildRemoved:Connect(updateSectionSize)
            
            local Section = {
                Frame = section,
                Content = sectionContent,
            }
            
            table.insert(self.Sections, Section)
            
            --// ═══════════════════════════════════════════════════════════════════════════════ \\--
            --//                                   ADD TOGGLE                                     \\--
            --// ═══════════════════════════════════════════════════════════════════════════════ \\--
            
            function Section:AddToggle(options)
                options = options or {}
                local name = options.Name or "Toggle"
                local flag = options.Flag or name
                local default = options.Default or false
                local callback = options.Callback or function() end
                local risky = options.Risky or false
                
                local toggle = Create("Frame", {
                    Name = name,
                    Parent = sectionContent,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 30),
                })
                
                local toggleLabel = Create("TextLabel", {
                    Name = "Label",
                    Parent = toggle,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 0),
                    Size = UDim2.new(1, -50, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = name,
                    TextColor3 = risky and FatalityLib.Theme.Risk or FatalityLib.Theme.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
                
                local toggleButton = Create("Frame", {
                    Name = "Button",
                    Parent = toggle,
                    BackgroundColor3 = FatalityLib.Theme.Tertiary,
                    Position = UDim2.new(1, -40, 0.5, 0),
                    Size = UDim2.new(0, 40, 0, 20),
                    AnchorPoint = Vector2.new(0, 0.5),
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = toggleButton,
                })
                
                local toggleCircle = Create("Frame", {
                    Name = "Circle",
                    Parent = toggleButton,
                    BackgroundColor3 = FatalityLib.Theme.TextDark,
                    Position = UDim2.new(0, 3, 0.5, 0),
                    Size = UDim2.new(0, 14, 0, 14),
                    AnchorPoint = Vector2.new(0, 0.5),
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = toggleCircle,
                })
                
                local toggled = default
                Toggles[flag] = {Value = toggled}
                
                local function updateToggle()
                    if toggled then
                        Tween(toggleButton, {BackgroundColor3 = FatalityLib.Theme.Accent}, 0.2)
                        Tween(toggleCircle, {Position = UDim2.new(1, -17, 0.5, 0), BackgroundColor3 = FatalityLib.Theme.Text}, 0.2)
                    else
                        Tween(toggleButton, {BackgroundColor3 = FatalityLib.Theme.Tertiary}, 0.2)
                        Tween(toggleCircle, {Position = UDim2.new(0, 3, 0.5, 0), BackgroundColor3 = FatalityLib.Theme.TextDark}, 0.2)
                    end
                    Toggles[flag].Value = toggled
                    callback(toggled)
                end
                
                if default then updateToggle() end
                
                local clickRegion = Create("TextButton", {
                    Name = "ClickRegion",
                    Parent = toggle,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Text = "",
                })
                
                clickRegion.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    updateToggle()
                end)
                
                local ToggleObj = {}
                
                function ToggleObj:Set(value)
                    toggled = value
                    updateToggle()
                end
                
                function ToggleObj:Get()
                    return toggled
                end
                
                Toggles[flag] = ToggleObj
                Toggles[flag].Value = toggled
                
                return ToggleObj
            end
            
            --// ═══════════════════════════════════════════════════════════════════════════════ \\--
            --//                                   ADD SLIDER                                     \\--
            --// ═══════════════════════════════════════════════════════════════════════════════ \\--
            
            function Section:AddSlider(options)
                options = options or {}
                local name = options.Name or "Slider"
                local flag = options.Flag or name
                local min = options.Min or 0
                local max = options.Max or 100
                local default = options.Default or min
                local increment = options.Increment or 1
                local suffix = options.Suffix or ""
                local callback = options.Callback or function() end
                
                local slider = Create("Frame", {
                    Name = name,
                    Parent = sectionContent,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 45),
                })
                
                local sliderLabel = Create("TextLabel", {
                    Name = "Label",
                    Parent = slider,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 0),
                    Size = UDim2.new(0.5, 0, 0, 20),
                    Font = Enum.Font.Gotham,
                    Text = name,
                    TextColor3 = FatalityLib.Theme.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
                
                local sliderValue = Create("TextLabel", {
                    Name = "Value",
                    Parent = slider,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0.5, 0, 0, 0),
                    Size = UDim2.new(0.5, 0, 0, 20),
                    Font = Enum.Font.GothamBold,
                    Text = tostring(default) .. suffix,
                    TextColor3 = FatalityLib.Theme.Accent,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Right,
                })
                
                local sliderBar = Create("Frame", {
                    Name = "Bar",
                    Parent = slider,
                    BackgroundColor3 = FatalityLib.Theme.Tertiary,
                    Position = UDim2.new(0, 0, 0, 28),
                    Size = UDim2.new(1, 0, 0, 8),
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = sliderBar,
                })
                
                local sliderFill = Create("Frame", {
                    Name = "Fill",
                    Parent = sliderBar,
                    BackgroundColor3 = FatalityLib.Theme.Accent,
                    Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = sliderFill,
                })
                
                local sliderCircle = Create("Frame", {
                    Name = "Circle",
                    Parent = sliderFill,
                    BackgroundColor3 = FatalityLib.Theme.Text,
                    Position = UDim2.new(1, 0, 0.5, 0),
                    Size = UDim2.new(0, 14, 0, 14),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = sliderCircle,
                })
                
                local value = default
                Options[flag] = {Value = value}
                
                local dragging = false
                
                local function updateSlider(input)
                    local pos = UDim2.new(math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1), 0, 1, 0)
                    sliderFill.Size = pos
                    
                    local rawValue = min + ((max - min) * pos.X.Scale)
                    value = math.floor(rawValue / increment + 0.5) * increment
                    value = math.clamp(value, min, max)
                    
                    sliderValue.Text = tostring(value) .. suffix
                    Options[flag].Value = value
                    callback(value)
                end
                
                sliderBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        updateSlider(input)
                    end
                end)
                
                sliderBar.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        updateSlider(input)
                    end
                end)
                
                local SliderObj = {}
                
                function SliderObj:Set(val)
                    value = math.clamp(val, min, max)
                    local pos = (value - min) / (max - min)
                    sliderFill.Size = UDim2.new(pos, 0, 1, 0)
                    sliderValue.Text = tostring(value) .. suffix
                    Options[flag].Value = value
                    callback(value)
                end
                
                function SliderObj:Get()
                    return value
                end
                
                Options[flag] = SliderObj
                Options[flag].Value = value
                
                return SliderObj
            end
            
            --// ═══════════════════════════════════════════════════════════════════════════════ \\--
            --//                                   ADD BUTTON                                     \\--
            --// ═══════════════════════════════════════════════════════════════════════════════ \\--
            
            function Section:AddButton(options)
                options = options or {}
                local name = options.Name or "Button"
                local callback = options.Callback or function() end
                
                local button = Create("TextButton", {
                    Name = name,
                    Parent = sectionContent,
                    BackgroundColor3 = FatalityLib.Theme.Tertiary,
                    Size = UDim2.new(1, 0, 0, 32),
                    Font = Enum.Font.GothamBold,
                    Text = name,
                    TextColor3 = FatalityLib.Theme.Text,
                    TextSize = 13,
                    AutoButtonColor = false,
                    ClipsDescendants = true,
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = button,
                })
                
                button.MouseEnter:Connect(function()
                    Tween(button, {BackgroundColor3 = FatalityLib.Theme.Accent}, 0.2)
                end)
                
                button.MouseLeave:Connect(function()
                    Tween(button, {BackgroundColor3 = FatalityLib.Theme.Tertiary}, 0.2)
                end)
                
                button.MouseButton1Click:Connect(function()
                    Ripple(button)
                    callback()
                end)
                
                return button
            end
            
            --// ═══════════════════════════════════════════════════════════════════════════════ \\--
            --//                                  ADD DROPDOWN                                    \\--
            --// ═══════════════════════════════════════════════════════════════════════════════ \\--
            
            function Section:AddDropdown(options)
                options = options or {}
                local name = options.Name or "Dropdown"
                local flag = options.Flag or name
                local items = options.Items or {}
                local default = options.Default or items[1] or ""
                local callback = options.Callback or function() end
                
                local dropdown = Create("Frame", {
                    Name = name,
                    Parent = sectionContent,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 55),
                    ClipsDescendants = false,
                })
                
                local dropdownLabel = Create("TextLabel", {
                    Name = "Label",
                    Parent = dropdown,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 0),
                    Size = UDim2.new(1, 0, 0, 20),
                    Font = Enum.Font.Gotham,
                    Text = name,
                    TextColor3 = FatalityLib.Theme.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
                
                local dropdownButton = Create("TextButton", {
                    Name = "Button",
                    Parent = dropdown,
                    BackgroundColor3 = FatalityLib.Theme.Tertiary,
                    Position = UDim2.new(0, 0, 0, 25),
                    Size = UDim2.new(1, 0, 0, 30),
                    Font = Enum.Font.Gotham,
                    Text = "  " .. tostring(default),
                    TextColor3 = FatalityLib.Theme.Text,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    AutoButtonColor = false,
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = dropdownButton,
                })
                
                local dropdownArrow = Create("TextLabel", {
                    Name = "Arrow",
                    Parent = dropdownButton,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -25, 0, 0),
                    Size = UDim2.new(0, 20, 1, 0),
                    Font = Enum.Font.GothamBold,
                    Text = "▼",
                    TextColor3 = FatalityLib.Theme.TextDark,
                    TextSize = 10,
                })
                
                local dropdownList = Create("Frame", {
                    Name = "List",
                    Parent = dropdown,
                    BackgroundColor3 = FatalityLib.Theme.Tertiary,
                    Position = UDim2.new(0, 0, 0, 57),
                    Size = UDim2.new(1, 0, 0, 0),
                    ClipsDescendants = true,
                    ZIndex = 10,
                    Visible = false,
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = dropdownList,
                })
                
                Create("UIListLayout", {
                    Parent = dropdownList,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 2),
                })
                
                Create("UIPadding", {
                    Parent = dropdownList,
                    PaddingTop = UDim.new(0, 5),
                    PaddingBottom = UDim.new(0, 5),
                    PaddingLeft = UDim.new(0, 5),
                    PaddingRight = UDim.new(0, 5),
                })
                
                local selected = default
                local opened = false
                Options[flag] = {Value = selected}
                
                local function toggleDropdown()
                    opened = not opened
                    
                    if opened then
                        dropdownList.Visible = true
                        local targetHeight = math.min(#items * 28 + 10, 150)
                        Tween(dropdownList, {Size = UDim2.new(1, 0, 0, targetHeight)}, 0.2)
                        Tween(dropdownArrow, {Rotation = 180}, 0.2)
                        dropdown.Size = UDim2.new(1, 0, 0, 55 + targetHeight + 5)
                    else
                        Tween(dropdownList, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                        Tween(dropdownArrow, {Rotation = 0}, 0.2)
                        wait(0.2)
                        dropdownList.Visible = false
                        dropdown.Size = UDim2.new(1, 0, 0, 55)
                    end
                end
                
                dropdownButton.MouseButton1Click:Connect(toggleDropdown)
                
                for _, item in pairs(items) do
                    local itemButton = Create("TextButton", {
                        Name = item,
                        Parent = dropdownList,
                        BackgroundColor3 = FatalityLib.Theme.Secondary,
                        Size = UDim2.new(1, 0, 0, 25),
                        Font = Enum.Font.Gotham,
                        Text = item,
                        TextColor3 = FatalityLib.Theme.Text,
                        TextSize = 12,
                        AutoButtonColor = false,
                        ZIndex = 11,
                    })
                    
                    Create("UICorner", {
                        CornerRadius = UDim.new(0, 4),
                        Parent = itemButton,
                    })
                    
                    itemButton.MouseEnter:Connect(function()
                        Tween(itemButton, {BackgroundColor3 = FatalityLib.Theme.Accent}, 0.2)
                    end)
                    
                    itemButton.MouseLeave:Connect(function()
                        Tween(itemButton, {BackgroundColor3 = FatalityLib.Theme.Secondary}, 0.2)
                    end)
                    
                    itemButton.MouseButton1Click:Connect(function()
                        selected = item
                        dropdownButton.Text = "  " .. item
                        Options[flag].Value = selected
                        callback(selected)
                        toggleDropdown()
                    end)
                end
                
                local DropdownObj = {}
                
                function DropdownObj:Set(val)
                    selected = val
                    dropdownButton.Text = "  " .. val
                    Options[flag].Value = selected
                    callback(selected)
                end
                
                function DropdownObj:Get()
                    return selected
                end
                
                function DropdownObj:Refresh(newItems)
                    for _, child in pairs(dropdownList:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                    
                    items = newItems
                    
                    for _, item in pairs(items) do
                        local itemButton = Create("TextButton", {
                            Name = item,
                            Parent = dropdownList,
                            BackgroundColor3 = FatalityLib.Theme.Secondary,
                            Size = UDim2.new(1, 0, 0, 25),
                            Font = Enum.Font.Gotham,
                            Text = item,
                            TextColor3 = FatalityLib.Theme.Text,
                            TextSize = 12,
                            AutoButtonColor = false,
                            ZIndex = 11,
                        })
                        
                        Create("UICorner", {
                            CornerRadius = UDim.new(0, 4),
                            Parent = itemButton,
                        })
                        
                        itemButton.MouseEnter:Connect(function()
                            Tween(itemButton, {BackgroundColor3 = FatalityLib.Theme.Accent}, 0.2)
                        end)
                        
                        itemButton.MouseLeave:Connect(function()
                            Tween(itemButton, {BackgroundColor3 = FatalityLib.Theme.Secondary}, 0.2)
                        end)
                        
                        itemButton.MouseButton1Click:Connect(function()
                            selected = item
                            dropdownButton.Text = "  " .. item
                            Options[flag].Value = selected
                            callback(selected)
                            toggleDropdown()
                        end)
                    end
                end
                
                Options[flag] = DropdownObj
                Options[flag].Value = selected
                
                return DropdownObj
            end
            
            --// ═══════════════════════════════════════════════════════════════════════════════ \\--
            --//                                  ADD TEXTBOX                                     \\--
            --// ═══════════════════════════════════════════════════════════════════════════════ \\--
            
            function Section:AddTextbox(options)
                options = options or {}
                local name = options.Name or "Textbox"
                local flag = options.Flag or name
                local default = options.Default or ""
                local placeholder = options.Placeholder or "Enter text..."
                local callback = options.Callback or function() end
                
                local textbox = Create("Frame", {
                    Name = name,
                    Parent = sectionContent,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 55),
                })
                
                local textboxLabel = Create("TextLabel", {
                    Name = "Label",
                    Parent = textbox,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 0),
                    Size = UDim2.new(1, 0, 0, 20),
                    Font = Enum.Font.Gotham,
                    Text = name,
                    TextColor3 = FatalityLib.Theme.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
                
                local textboxInput = Create("TextBox", {
                    Name = "Input",
                    Parent = textbox,
                    BackgroundColor3 = FatalityLib.Theme.Tertiary,
                    Position = UDim2.new(0, 0, 0, 25),
                    Size = UDim2.new(1, 0, 0, 30),
                    Font = Enum.Font.Gotham,
                    Text = default,
                    PlaceholderText = placeholder,
                    PlaceholderColor3 = FatalityLib.Theme.TextDark,
                    TextColor3 = FatalityLib.Theme.Text,
                    TextSize = 12,
                    ClearTextOnFocus = false,
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = textboxInput,
                })
                
                Create("UIPadding", {
                    Parent = textboxInput,
                    PaddingLeft = UDim.new(0, 10),
                    PaddingRight = UDim.new(0, 10),
                })
                
                Options[flag] = {Value = default}
                
                textboxInput.FocusLost:Connect(function(enterPressed)
                    Options[flag].Value = textboxInput.Text
                    callback(textboxInput.Text, enterPressed)
                end)
                
                local TextboxObj = {}
                
                function TextboxObj:Set(val)
                    textboxInput.Text = val
                    Options[flag].Value = val
                end
                
                function TextboxObj:Get()
                    return textboxInput.Text
                end
                
                Options[flag] = TextboxObj
                Options[flag].Value = default
                
                return TextboxObj
            end
            
            --// ═══════════════════════════════════════════════════════════════════════════════ \\--
            --//                                   ADD LABEL                                      \\--
            --// ═══════════════════════════════════════════════════════════════════════════════ \\--
            
            function Section:AddLabel(text)
                local label = Create("TextLabel", {
                    Name = "Label",
                    Parent = sectionContent,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 20),
                    Font = Enum.Font.Gotham,
                    Text = text,
                    TextColor3 = FatalityLib.Theme.TextDark,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextWrapped = true,
                })
                
                local LabelObj = {}
                
                function LabelObj:Set(newText)
                    label.Text = newText
                end
                
                return LabelObj
            end
            
            --// ═══════════════════════════════════════════════════════════════════════════════ \\--
            --//                                 ADD KEYBIND                                      \\--
            --// ═══════════════════════════════════════════════════════════════════════════════ \\--
            
            function Section:AddKeybind(options)
                options = options or {}
                local name = options.Name or "Keybind"
                local flag = options.Flag or name
                local default = options.Default or Enum.KeyCode.None
                local callback = options.Callback or function() end
                
                local keybind = Create("Frame", {
                    Name = name,
                    Parent = sectionContent,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 30),
                })
                
                local keybindLabel = Create("TextLabel", {
                    Name = "Label",
                    Parent = keybind,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 0),
                    Size = UDim2.new(1, -80, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = name,
                    TextColor3 = FatalityLib.Theme.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
                
                local keybindButton = Create("TextButton", {
                    Name = "Button",
                    Parent = keybind,
                    BackgroundColor3 = FatalityLib.Theme.Tertiary,
                    Position = UDim2.new(1, -75, 0.5, 0),
                    Size = UDim2.new(0, 75, 0, 25),
                    AnchorPoint = Vector2.new(0, 0.5),
                    Font = Enum.Font.GothamBold,
                    Text = default.Name or "None",
                    TextColor3 = FatalityLib.Theme.Accent,
                    TextSize = 11,
                    AutoButtonColor = false,
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = keybindButton,
                })
                
                local currentKey = default
                local listening = false
                Options[flag] = {Value = currentKey}
                
                keybindButton.MouseButton1Click:Connect(function()
                    listening = true
                    keybindButton.Text = "..."
                end)
                
                UserInputService.InputBegan:Connect(function(input, processed)
                    if processed then return end
                    
                    if listening then
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            currentKey = input.KeyCode
                            keybindButton.Text = currentKey.Name
                            Options[flag].Value = currentKey
                            listening = false
                        end
                    else
                        if input.KeyCode == currentKey then
                            callback(currentKey)
                        end
                    end
                end)
                
                local KeybindObj = {}
                
                function KeybindObj:Set(key)
                    currentKey = key
                    keybindButton.Text = key.Name
                    Options[flag].Value = key
                end
                
                function KeybindObj:Get()
                    return currentKey
                end
                
                Options[flag] = KeybindObj
                Options[flag].Value = currentKey
                
                return KeybindObj
            end
            
            --// ═══════════════════════════════════════════════════════════════════════════════ \\--
            --//                               ADD COLORPICKER                                    \\--
            --// ═══════════════════════════════════════════════════════════════════════════════ \\--
            
            function Section:AddColorPicker(options)
                options = options or {}
                local name = options.Name or "Color"
                local flag = options.Flag or name
                local default = options.Default or Color3.fromRGB(255, 255, 255)
                local callback = options.Callback or function() end
                
                local colorpicker = Create("Frame", {
                    Name = name,
                    Parent = sectionContent,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 30),
                })
                
                local colorLabel = Create("TextLabel", {
                    Name = "Label",
                    Parent = colorpicker,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 0),
                    Size = UDim2.new(1, -50, 1, 0),
                    Font = Enum.Font.Gotham,
                    Text = name,
                    TextColor3 = FatalityLib.Theme.Text,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
                
                local colorDisplay = Create("TextButton", {
                    Name = "Display",
                    Parent = colorpicker,
                    BackgroundColor3 = default,
                    Position = UDim2.new(1, -40, 0.5, 0),
                    Size = UDim2.new(0, 40, 0, 20),
                    AnchorPoint = Vector2.new(0, 0.5),
                    Text = "",
                    AutoButtonColor = false,
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = colorDisplay,
                })
                
                Create("UIStroke", {
                    Parent = colorDisplay,
                    Color = FatalityLib.Theme.Border,
                    Thickness = 1,
                })
                
                local selectedColor = default
                Options[flag] = {Value = selectedColor}
                
                -- Color picker popup
                local pickerOpen = false
                local pickerFrame = Create("Frame", {
                    Name = "Picker",
                    Parent = colorpicker,
                    BackgroundColor3 = FatalityLib.Theme.Secondary,
                    Position = UDim2.new(0, 0, 1, 5),
                    Size = UDim2.new(1, 0, 0, 0),
                    ClipsDescendants = true,
                    ZIndex = 20,
                    Visible = false,
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(0, 8),
                    Parent = pickerFrame,
                })
                
                Create("UIStroke", {
                    Parent = pickerFrame,
                    Color = FatalityLib.Theme.Border,
                    Thickness = 1,
                })
                
                -- Hue slider
                local hueSlider = Create("Frame", {
                    Name = "HueSlider",
                    Parent = pickerFrame,
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    Position = UDim2.new(0, 10, 0, 10),
                    Size = UDim2.new(1, -20, 0, 15),
                    ZIndex = 21,
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = hueSlider,
                })
                
                Create("UIGradient", {
                    Parent = hueSlider,
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                        ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                        ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                        ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
                    }),
                })
                
                -- Saturation/Value box
                local svBox = Create("Frame", {
                    Name = "SVBox",
                    Parent = pickerFrame,
                    BackgroundColor3 = Color3.fromHSV(0, 1, 1),
                    Position = UDim2.new(0, 10, 0, 35),
                    Size = UDim2.new(1, -20, 0, 100),
                    ZIndex = 21,
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = svBox,
                })
                
                local satGradient = Create("Frame", {
                    Name = "SatGradient",
                    Parent = svBox,
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    Size = UDim2.new(1, 0, 1, 0),
                    ZIndex = 22,
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = satGradient,
                })
                
                Create("UIGradient", {
                    Parent = satGradient,
                    Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.new(1, 1, 1)),
                    Transparency = NumberSequence.new(0, 1),
                })
                
                local valGradient = Create("Frame", {
                    Name = "ValGradient",
                    Parent = svBox,
                    BackgroundColor3 = Color3.new(0, 0, 0),
                    Size = UDim2.new(1, 0, 1, 0),
                    ZIndex = 23,
                })
                
                Create("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = valGradient,
                })
                
                Create("UIGradient", {
                    Parent = valGradient,
                    Color = ColorSequence.new(Color3.new(0, 0, 0), Color3.new(0, 0, 0)),
                    Transparency = NumberSequence.new(1, 0),
                    Rotation = 90,
                })
                
                local h, s, v = Color3.toHSV(default)
                
                local function updateColor()
                    selectedColor = Color3.fromHSV(h, s, v)
                    colorDisplay.BackgroundColor3 = selectedColor
                    svBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                    Options[flag].Value = selectedColor
                    callback(selectedColor)
                end
                
                colorDisplay.MouseButton1Click:Connect(function()
                    pickerOpen = not pickerOpen
                    
                    if pickerOpen then
                        pickerFrame.Visible = true
                        Tween(pickerFrame, {Size = UDim2.new(1, 0, 0, 150)}, 0.2)
                        colorpicker.Size = UDim2.new(1, 0, 0, 185)
                    else
                        Tween(pickerFrame, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                        wait(0.2)
                        pickerFrame.Visible = false
                        colorpicker.Size = UDim2.new(1, 0, 0, 30)
                    end
                end)
                
                local draggingHue = false
                local draggingSV = false
                
                hueSlider.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        draggingHue = true
                    end
                end)
                
                hueSlider.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        draggingHue = false
                    end
                end)
                
                svBox.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        draggingSV = true
                    end
                end)
                
                svBox.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        draggingSV = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        if draggingHue then
                            h = math.clamp((input.Position.X - hueSlider.AbsolutePosition.X) / hueSlider.AbsoluteSize.X, 0, 1)
                            updateColor()
                        elseif draggingSV then
                            s = math.clamp((input.Position.X - svBox.AbsolutePosition.X) / svBox.AbsoluteSize.X, 0, 1)
                            v = 1 - math.clamp((input.Position.Y - svBox.AbsolutePosition.Y) / svBox.AbsoluteSize.Y, 0, 1)
                            updateColor()
                        end
                    end
                end)
                
                local ColorObj = {}
                
                function ColorObj:Set(color)
                    h, s, v = Color3.toHSV(color)
                    updateColor()
                end
                
                function ColorObj:Get()
                    return selectedColor
                end
                
                Options[flag] = ColorObj
                Options[flag].Value = selectedColor
                
                return ColorObj
            end
            
            return Section
        end
        
        return Tab
    end
    
    return Window
end

--// ═══════════════════════════════════════════════════════════════════════════════ \\--
--//                                   CLEANUP                                        \\--
--// ═══════════════════════════════════════════════════════════════════════════════ \\--

function FatalityLib:Destroy()
    for _, connection in pairs(self.Connections) do
        connection:Disconnect()
    end
    
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

--// ═══════════════════════════════════════════════════════════════════════════════ \\--
--//                                   RETURN                                         \\--
--// ═══════════════════════════════════════════════════════════════════════════════ \\--

getgenv().FatalityLib = FatalityLib
return FatalityLib
