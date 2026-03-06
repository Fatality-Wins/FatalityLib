local Down = false 
local KickMessage = "Fatality W is currently down for maintenance."

if Down then
    game:GetService("Players").LocalPlayer:Kick(KickMessage)
    return nil
end

--// Services
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local ProtectGui = protectgui or (syn and syn.protect_gui) or function() end

--// Library Setup
local FatalityLib = {
    Categories = {},
    Toggles = {},
    Options = {},
    MenuOpen = true,
    ToggleKey = Enum.KeyCode.RightShift,
    GroupMode = false, -- If true, dragging one column drags all of them
    
    Theme = {
        Header = Color3.fromRGB(15, 15, 15),
        Background = Color3.fromRGB(22, 22, 25),
        Hover = Color3.fromRGB(30, 30, 35),
        Accent = Color3.fromRGB(140, 90, 255), -- Purple accent
        Text = Color3.fromRGB(240, 240, 240),
        TextDark = Color3.fromRGB(130, 130, 130),
        Border = Color3.fromRGB(35, 35, 40),
        Font = Enum.Font.GothamMedium,
    }
}

getgenv().FatalityLib = FatalityLib
getgenv().Toggles = FatalityLib.Toggles
getgenv().Options = FatalityLib.Options

--// Utility Functions
local function Create(class, properties)
    local inst = Instance.new(class)
    for i, v in pairs(properties) do
        if i ~= "Parent" then
            inst[i] = v
        end
    end
    if properties.Parent then
        inst.Parent = properties.Parent
    end
    return inst
end

local function Tween(instance, properties, duration)
    local tweenInfo = TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

--// Initialization
function FatalityLib:Init(options)
    options = options or {}
    self.ToggleKey = options.ToggleKey or Enum.KeyCode.RightShift
    self.GroupMode = options.GroupMode or false

    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end

    local ScreenGui = Create("ScreenGui", {
        Name = "FatalityUI",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        ResetOnSpawn = false,
    })
    ProtectGui(ScreenGui)
    ScreenGui.Parent = CoreGui
    self.ScreenGui = ScreenGui

    local MainContainer = Create("Frame", {
        Name = "Container",
        Parent = ScreenGui,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
    })
    self.MainContainer = MainContainer

    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == self.ToggleKey then
            self.MenuOpen = not self.MenuOpen
            MainContainer.Visible = self.MenuOpen
        end
    end)
end

function FatalityLib:SetGroupMode(state)
    self.GroupMode = state
end

--// Create Category (Column)
function FatalityLib:AddCategory(name)
    local Category = {
        Name = name,
        IsOpen = false,
        Elements = {},
        TotalHeight = 0
    }

    local index = #self.Categories
    local xOffset = 30 + (index * 170) -- Auto space horizontally

    local Column = Create("Frame", {
        Name = name .. "_Column",
        Parent = self.MainContainer,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, xOffset, 0, 30),
        Size = UDim2.new(0, 160, 0, 400),
    })
    Category.Column = Column

    -- Header (Draggable, Right-click to open)
    local Header = Create("TextButton", {
        Name = "Header",
        Parent = Column,
        BackgroundColor3 = self.Theme.Header,
        Size = UDim2.new(1, 0, 0, 32),
        Font = self.Theme.Font,
        Text = name,
        TextColor3 = self.Theme.Text,
        TextSize = 13,
        AutoButtonColor = false,
        ZIndex = 10,
    })
    
    Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = Header })
    Create("UIStroke", { Parent = Header, Color = self.Theme.Border, Thickness = 1 })

    -- Dropdown Container
    local Dropdown = Create("Frame", {
        Name = "Dropdown",
        Parent = Column,
        BackgroundColor3 = self.Theme.Background,
        Position = UDim2.new(0, 0, 0, 35),
        Size = UDim2.new(1, 0, 0, 0),
        ClipsDescendants = true,
        ZIndex = 5,
    })
    
    Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = Dropdown })
    Create("UIStroke", { Parent = Dropdown, Color = self.Theme.Border, Thickness = 1 })

    local ContentLayout = Create("UIListLayout", {
        Parent = Dropdown,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2),
    })
    
    Create("UIPadding", {
        Parent = Dropdown,
        PaddingTop = UDim.new(0, 5),
        PaddingBottom = UDim.new(0, 5),
        PaddingLeft = UDim.new(0, 5),
        PaddingRight = UDim.new(0, 5),
    })

    local function UpdateHeight()
        local height = ContentLayout.AbsoluteContentSize.Y + 10
        Category.TotalHeight = height
        if Category.IsOpen then
            Dropdown.Size = UDim2.new(1, 0, 0, height)
        end
    end
    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateHeight)

    --// Dragging & Opening Logic
    local dragging, dragStart, startPos

    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            -- Left Click: Drag
            dragging = true
            dragStart = input.Position
            startPos = Column.Position

            -- If GroupMode is on, capture start positions of all categories
            if FatalityLib.GroupMode then
                for _, cat in pairs(FatalityLib.Categories) do
                    cat.DragStartPos = cat.Column.Position
                end
            end

        elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
            -- Right Click: Toggle Dropdown
            Category.IsOpen = not Category.IsOpen
            if Category.IsOpen then
                Tween(Dropdown, {Size = UDim2.new(1, 0, 0, Category.TotalHeight)}, 0.25)
                Tween(Header, {TextColor3 = self.Theme.Accent}, 0.2)
            else
                Tween(Dropdown, {Size = UDim2.new(1, 0, 0, 0)}, 0.25)
                Tween(Header, {TextColor3 = self.Theme.Text}, 0.2)
            end
        end
    end)

    Header.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            
            if FatalityLib.GroupMode then
                -- Move all columns
                for _, cat in pairs(FatalityLib.Categories) do
                    if cat.DragStartPos then
                        cat.Column.Position = UDim2.new(
                            cat.DragStartPos.X.Scale,
                            cat.DragStartPos.X.Offset + delta.X,
                            cat.DragStartPos.Y.Scale,
                            cat.DragStartPos.Y.Offset + delta.Y
                        )
                    end
                end
            else
                -- Move single column
                Column.Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end
    end)

    --// Elements

    -- LABEL (FIXED: Added this function)
    function Category:AddLabel(text)
        local Label = Create("TextLabel", {
            Name = "Label",
            Parent = Dropdown,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 20),
            Font = FatalityLib.Theme.Font,
            Text = text,
            TextColor3 = FatalityLib.Theme.Text,
            TextSize = 12,
            ZIndex = 6,
        })
        return Label
    end

    -- BUTTON
    function Category:AddButton(options)
        local btnName = options.Name or "Button"
        local callback = options.Callback or function() end

        local Button = Create("TextButton", {
            Name = btnName,
            Parent = Dropdown,
            BackgroundColor3 = FatalityLib.Theme.Header,
            Size = UDim2.new(1, 0, 0, 24),
            Font = FatalityLib.Theme.Font,
            Text = btnName,
            TextColor3 = FatalityLib.Theme.TextDark,
            TextSize = 12,
            AutoButtonColor = false,
            ZIndex = 6,
        })
        Create("UICorner", { CornerRadius = UDim.new(0, 3), Parent = Button })

        Button.MouseEnter:Connect(function()
            Tween(Button, {BackgroundColor3 = FatalityLib.Theme.Hover, TextColor3 = FatalityLib.Theme.Text}, 0.2)
        end)
        Button.MouseLeave:Connect(function()
            Tween(Button, {BackgroundColor3 = FatalityLib.Theme.Header, TextColor3 = FatalityLib.Theme.TextDark}, 0.2)
        end)
        
        -- Left Click to interact
        Button.MouseButton1Click:Connect(function()
            Tween(Button, {TextColor3 = FatalityLib.Theme.Accent}, 0.1)
            task.delay(0.1, function() Tween(Button, {TextColor3 = FatalityLib.Theme.Text}, 0.2) end)
            callback()
        end)
    end

    -- TOGGLE
    function Category:AddToggle(options)
        local tglName = options.Name or "Toggle"
        local flag = options.Flag or tglName
        local default = options.Default or false
        local callback = options.Callback or function() end

        local Toggle = Create("TextButton", {
            Name = tglName,
            Parent = Dropdown,
            BackgroundColor3 = FatalityLib.Theme.Background,
            Size = UDim2.new(1, 0, 0, 22),
            Font = FatalityLib.Theme.Font,
            Text = "  " .. tglName,
            TextColor3 = default and FatalityLib.Theme.Accent or FatalityLib.Theme.TextDark,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false,
            ZIndex = 6,
        })

        local Indicator = Create("Frame", {
            Name = "Indicator",
            Parent = Toggle,
            BackgroundColor3 = FatalityLib.Theme.Accent,
            Position = UDim2.new(0, 2, 0.5, 0),
            Size = default and UDim2.new(0, 2, 0, 12) or UDim2.new(0, 0, 0, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BorderSizePixel = 0,
            ZIndex = 7,
        })

        FatalityLib.Toggles[flag] = { Value = default }

        local function Fire()
            local state = FatalityLib.Toggles[flag].Value
            if state then
                Tween(Toggle, {TextColor3 = FatalityLib.Theme.Accent}, 0.2)
                Tween(Indicator, {Size = UDim2.new(0, 2, 0, 12)}, 0.2)
            else
                Tween(Toggle, {TextColor3 = FatalityLib.Theme.TextDark}, 0.2)
                Tween(Indicator, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
            end
            callback(state)
        end

        -- Left Click to turn on/off
        Toggle.MouseButton1Click:Connect(function()
            FatalityLib.Toggles[flag].Value = not FatalityLib.Toggles[flag].Value
            Fire()
        end)

        local Obj = {}
        function Obj:Set(value)
            FatalityLib.Toggles[flag].Value = value
            Fire()
        end
        FatalityLib.Toggles[flag].Set = Obj.Set

        if default then callback(default) end
        return Obj
    end

    -- SLIDER
    function Category:AddSlider(options)
        local sldName = options.Name or "Slider"
        local flag = options.Flag or sldName
        local min = options.Min or 0
        local max = options.Max or 100
        local default = options.Default or min
        local suffix = options.Suffix or ""
        local callback = options.Callback or function() end

        local SliderFrame = Create("Frame", {
            Name = sldName,
            Parent = Dropdown,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 32),
            ZIndex = 6,
        })

        local Label = Create("TextLabel", {
            Name = "Title",
            Parent = SliderFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 4, 0, 0),
            Size = UDim2.new(1, -8, 0, 14),
            Font = FatalityLib.Theme.Font,
            Text = sldName,
            TextColor3 = FatalityLib.Theme.TextDark,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 7,
        })

        local ValueLabel = Create("TextLabel", {
            Name = "Value",
            Parent = SliderFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 4, 0, 0),
            Size = UDim2.new(1, -8, 0, 14),
            Font = FatalityLib.Theme.Font,
            Text = tostring(default) .. suffix,
            TextColor3 = FatalityLib.Theme.Text,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Right,
            ZIndex = 7,
        })

        local BarBG = Create("TextButton", {
            Name = "BarBG",
            Parent = SliderFrame,
            BackgroundColor3 = FatalityLib.Theme.Header,
            Position = UDim2.new(0, 4, 0, 18),
            Size = UDim2.new(1, -8, 0, 4),
            Text = "",
            AutoButtonColor = false,
            ZIndex = 7,
        })
        Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = BarBG })
        Create("UIStroke", { Parent = BarBG, Color = FatalityLib.Theme.Border, Thickness = 1 })

        local BarFill = Create("Frame", {
            Name = "Fill",
            Parent = BarBG,
            BackgroundColor3 = FatalityLib.Theme.Accent,
            Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
            ZIndex = 8,
        })
        Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = BarFill })

        FatalityLib.Options[flag] = { Value = default }

        local Dragging = false
        local function Update(input)
            local percent = math.clamp((input.Position.X - BarBG.AbsolutePosition.X) / BarBG.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + (max - min) * percent)
            
            BarFill.Size = UDim2.new(percent, 0, 1, 0)
            ValueLabel.Text = tostring(value) .. suffix
            FatalityLib.Options[flag].Value = value
            callback(value)
        end

        -- Left Click to drag
        BarBG.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                Dragging = true
                Tween(Label, {TextColor3 = FatalityLib.Theme.Text}, 0.2)
                Update(input)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                Dragging = false
                Tween(Label, {TextColor3 = FatalityLib.Theme.TextDark}, 0.2)
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                Update(input)
            end
        end)

        local Obj = {}
        function Obj:Set(val)
            local value = math.clamp(val, min, max)
            local percent = (value - min) / (max - min)
            BarFill.Size = UDim2.new(percent, 0, 1, 0)
            ValueLabel.Text = tostring(value) .. suffix
            FatalityLib.Options[flag].Value = value
            callback(value)
        end
        FatalityLib.Options[flag].Set = Obj.Set

        return Obj
    end

    table.insert(self.Categories, Category)
    return Category
end

function FatalityLib:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

return FatalityLib
