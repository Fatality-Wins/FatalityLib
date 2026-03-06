--[[
    ███████╗ █████╗ ████████╗ █████╗ ██╗     ██╗████████╗██╗   ██╗    ██╗    ██╗
    ██╔════╝██╔══██╗╚══██╔══╝██╔══██╗██║     ██║╚══██╔══╝╚██╗ ██╔╝    ██║    ██║
    █████╗  ███████║   ██║   ███████║██║     ██║   ██║    ╚████╔╝     ██║ █╗ ██║
    ██╔══╝  ██╔══██║   ██║   ██╔══██║██║     ██║   ██║     ╚██╔╝      ██║███╗██║
    ██║     ██║  ██║   ██║   ██║  ██║███████╗██║   ██║      ██║       ╚███╔███╔╝
    ╚═╝     ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝   ╚═╝      ╚═╝        ╚══╝╚══╝ 
    
    Fatality W - V1.0.0
]]

--// ═══════════════════════════════════════════════════════════════════════════════ \\--
--//                         LIBRARY (FIXED & EMBEDDED)                               \\--
--// ═══════════════════════════════════════════════════════════════════════════════ \\--

local FatalityLib = (function()
    -- Services
    local CoreGui = game:GetService("CoreGui")
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")

    -- Library Object
    local Library = {
        Categories = {},
        Toggles = {},
        Options = {},
        MenuOpen = true,
        ToggleKey = Enum.KeyCode.RightShift,
        GroupMode = false,
        Theme = {
            Header = Color3.fromRGB(15, 15, 15),
            Background = Color3.fromRGB(22, 22, 25),
            Hover = Color3.fromRGB(30, 30, 35),
            Accent = Color3.fromRGB(140, 90, 255),
            Text = Color3.fromRGB(240, 240, 240),
            TextDark = Color3.fromRGB(130, 130, 130),
            Border = Color3.fromRGB(35, 35, 40),
            Font = Enum.Font.GothamMedium,
        }
    }

    -- Helpers
    local function Create(class, properties)
        local inst = Instance.new(class)
        for i, v in pairs(properties) do
            if i ~= "Parent" then inst[i] = v end
        end
        if properties.Parent then inst.Parent = properties.Parent end
        return inst
    end

    local function Tween(inst, props, time)
        TweenService:Create(inst, TweenInfo.new(time or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
    end

    -- Init
    function Library:Init(options)
        options = options or {}
        self.ToggleKey = options.ToggleKey or Enum.KeyCode.RightShift
        self.GroupMode = options.GroupMode or false

        if self.ScreenGui then self.ScreenGui:Destroy() end

        self.ScreenGui = Create("ScreenGui", {
            Name = "FatalityUI",
            ZIndexBehavior = Enum.ZIndexBehavior.Global,
            ResetOnSpawn = false,
            Parent = CoreGui
        })

        self.MainContainer = Create("Frame", {
            Name = "Container",
            Parent = self.ScreenGui,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = self.MenuOpen
        })

        UserInputService.InputBegan:Connect(function(input, processed)
            if processed then return end
            if input.KeyCode == self.ToggleKey then
                self.MenuOpen = not self.MenuOpen
                self.MainContainer.Visible = self.MenuOpen
            end
        end)
    end

    function Library:SetGroupMode(state)
        self.GroupMode = state
    end

    function Library:Destroy()
        if self.ScreenGui then self.ScreenGui:Destroy() end
    end

    -- Category
    function Library:AddCategory(name)
        local Category = {Name = name, IsOpen = false, TotalHeight = 0}
        local index = #self.Categories
        
        local Column = Create("Frame", {
            Name = name .. "_Column",
            Parent = self.MainContainer,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 30 + (index * 170), 0, 30),
            Size = UDim2.new(0, 160, 0, 400),
        })
        Category.Column = Column

        local Header = Create("TextButton", {
            Parent = Column, BackgroundColor3 = self.Theme.Header, Size = UDim2.new(1, 0, 0, 32),
            Font = self.Theme.Font, Text = name, TextColor3 = self.Theme.Text, TextSize = 13,
            AutoButtonColor = false, ZIndex = 10
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = Header})
        Create("UIStroke", {Parent = Header, Color = self.Theme.Border, Thickness = 1})

        local Dropdown = Create("Frame", {
            Parent = Column, BackgroundColor3 = self.Theme.Background, Position = UDim2.new(0, 0, 0, 35),
            Size = UDim2.new(1, 0, 0, 0), ClipsDescendants = true, ZIndex = 5
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = Dropdown})
        Create("UIStroke", {Parent = Dropdown, Color = self.Theme.Border, Thickness = 1})

        local ContentLayout = Create("UIListLayout", {Parent = Dropdown, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2)})
        Create("UIPadding", {Parent = Dropdown, PaddingTop = UDim.new(0, 5), PaddingBottom = UDim.new(0, 5), PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5)})

        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Category.TotalHeight = ContentLayout.AbsoluteContentSize.Y + 10
            if Category.IsOpen then Dropdown.Size = UDim2.new(1, 0, 0, Category.TotalHeight) end
        end)

        -- Dragging Logic
        local dragging, dragStart, startPos
        Header.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true; dragStart = input.Position; startPos = Column.Position
                if Library.GroupMode then
                    for _, cat in pairs(Library.Categories) do cat.DragStartPos = cat.Column.Position end
                end
            elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                Category.IsOpen = not Category.IsOpen
                Tween(Dropdown, {Size = UDim2.new(1, 0, 0, Category.IsOpen and Category.TotalHeight or 0)}, 0.25)
                Tween(Header, {TextColor3 = Category.IsOpen and self.Theme.Accent or self.Theme.Text}, 0.2)
            end
        end)
        Header.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                if Library.GroupMode then
                    for _, cat in pairs(Library.Categories) do
                        if cat.DragStartPos then
                            cat.Column.Position = UDim2.new(cat.DragStartPos.X.Scale, cat.DragStartPos.X.Offset + delta.X, cat.DragStartPos.Y.Scale, cat.DragStartPos.Y.Offset + delta.Y)
                        end
                    end
                else
                    Column.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                end
            end
        end)

        --// Elements
        
        -- Label (Fixed)
        function Category:AddLabel(text)
            return Create("TextLabel", {
                Parent = Dropdown, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 20),
                Font = Library.Theme.Font, Text = text, TextColor3 = Library.Theme.Text,
                TextSize = 12, ZIndex = 6
            })
        end

        -- Button
        function Category:AddButton(options)
            local Button = Create("TextButton", {
                Parent = Dropdown, BackgroundColor3 = Library.Theme.Header, Size = UDim2.new(1, 0, 0, 24),
                Font = Library.Theme.Font, Text = options.Name or "Button", TextColor3 = Library.Theme.TextDark,
                TextSize = 12, AutoButtonColor = false, ZIndex = 6
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = Button})
            Button.MouseEnter:Connect(function() Tween(Button, {BackgroundColor3 = Library.Theme.Hover, TextColor3 = Library.Theme.Text}, 0.2) end)
            Button.MouseLeave:Connect(function() Tween(Button, {BackgroundColor3 = Library.Theme.Header, TextColor3 = Library.Theme.TextDark}, 0.2) end)
            Button.MouseButton1Click:Connect(function()
                Tween(Button, {TextColor3 = Library.Theme.Accent}, 0.1)
                task.delay(0.1, function() Tween(Button, {TextColor3 = Library.Theme.Text}, 0.2) end)
                if options.Callback then options.Callback() end
            end)
        end

        -- Toggle
        function Category:AddToggle(options)
            local flag = options.Flag or options.Name
            local default = options.Default or false
            local Toggle = Create("TextButton", {
                Parent = Dropdown, BackgroundColor3 = Library.Theme.Background, Size = UDim2.new(1, 0, 0, 22),
                Font = Library.Theme.Font, Text = "  " .. (options.Name or "Toggle"),
                TextColor3 = default and Library.Theme.Accent or Library.Theme.TextDark,
                TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false, ZIndex = 6
            })
            local Indicator = Create("Frame", {
                Parent = Toggle, BackgroundColor3 = Library.Theme.Accent, Position = UDim2.new(0, 2, 0.5, 0),
                Size = default and UDim2.new(0, 2, 0, 12) or UDim2.new(0, 0, 0, 0),
                AnchorPoint = Vector2.new(0, 0.5), ZIndex = 7
            })

            Library.Toggles[flag] = {Value = default}

            local function Fire(val)
                Tween(Toggle, {TextColor3 = val and Library.Theme.Accent or Library.Theme.TextDark}, 0.2)
                Tween(Indicator, {Size = val and UDim2.new(0, 2, 0, 12) or UDim2.new(0, 0, 0, 0)}, 0.2)
                if options.Callback then options.Callback(val) end
            end

            Toggle.MouseButton1Click:Connect(function()
                Library.Toggles[flag].Value = not Library.Toggles[flag].Value
                Fire(Library.Toggles[flag].Value)
            end)
            
            if default then Fire(default) end
        end

        -- Slider
        function Category:AddSlider(options)
            local flag = options.Flag or options.Name
            local min, max, default = options.Min or 0, options.Max or 100, options.Default or 0
            
            local SliderFrame = Create("Frame", {Parent = Dropdown, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 32), ZIndex = 6})
            Create("TextLabel", {Parent = SliderFrame, BackgroundTransparency = 1, Position = UDim2.new(0, 4, 0, 0), Size = UDim2.new(1, -8, 0, 14), Font = Library.Theme.Font, Text = options.Name, TextColor3 = Library.Theme.TextDark, TextSize = 11, TextXAlignment = 0, ZIndex = 7})
            local ValueLabel = Create("TextLabel", {Parent = SliderFrame, BackgroundTransparency = 1, Position = UDim2.new(0, 4, 0, 0), Size = UDim2.new(1, -8, 0, 14), Font = Library.Theme.Font, Text = tostring(default)..(options.Suffix or ""), TextColor3 = Library.Theme.Text, TextSize = 11, TextXAlignment = 1, ZIndex = 7})
            
            local BarBG = Create("TextButton", {Parent = SliderFrame, BackgroundColor3 = Library.Theme.Header, Position = UDim2.new(0, 4, 0, 18), Size = UDim2.new(1, -8, 0, 4), Text = "", AutoButtonColor = false, ZIndex = 7})
            Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = BarBG}); Create("UIStroke", {Parent = BarBG, Color = Library.Theme.Border, Thickness = 1})
            local BarFill = Create("Frame", {Parent = BarBG, BackgroundColor3 = Library.Theme.Accent, Size = UDim2.new((default-min)/(max-min), 0, 1, 0), ZIndex = 8})
            Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = BarFill})

            Library.Options[flag] = {Value = default}

            local function Update(input)
                local pct = math.clamp((input.Position.X - BarBG.AbsolutePosition.X) / BarBG.AbsoluteSize.X, 0, 1)
                local val = math.floor(min + (max - min) * pct)
                BarFill.Size = UDim2.new(pct, 0, 1, 0)
                ValueLabel.Text = tostring(val) .. (options.Suffix or "")
                Library.Options[flag].Value = val
                if options.Callback then options.Callback(val) end
            end
            
            local dragging = false
            BarBG.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; Update(i) end end)
            UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
            UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then Update(i) end end)
        end

        table.insert(self.Categories, Category)
        return Category
    end

    -- Export to global
    getgenv().FatalityLib = Library
    return Library
end)()

--// ═══════════════════════════════════════════════════════════════════════════════ \\--
--//                                  MAIN SCRIPT                                     \\--
--// ═══════════════════════════════════════════════════════════════════════════════ \\--

FatalityLib:Init({
    ToggleKey = Enum.KeyCode.RightShift,
    GroupMode = false 
})

-- Create 'Settings' Category
local Settings = FatalityLib:AddCategory("Settings")

-- 1. Unload Script
Settings:AddButton({
    Name = "Unload Script",
    Callback = function()
        FatalityLib:Destroy()
        print("Fatality W Unloaded!")
    end
})

Settings:AddLabel("UI Management")

-- 2. Move UI in Group
Settings:AddToggle({
    Name = "Move UI in Group",
    Flag = "GroupDrag",
    Default = false,
    Callback = function(Value)
        FatalityLib:SetGroupMode(Value)
    end
})

-- 3. Auto Load
Settings:AddToggle({
    Name = "Auto Load",
    Flag = "AutoLoad",
    Default = true,
    Callback = function(Value)
        if Value then
            print("Auto Load is Enabled")
            -- Add config loading logic here if needed
        end
    end
})

print("[Fatality W] Loaded Successfully")
