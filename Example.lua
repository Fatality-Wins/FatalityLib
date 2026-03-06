--[[
    ███████╗ █████╗ ████████╗ █████╗ ██╗     ██╗████████╗██╗   ██╗    ██╗    ██╗
    ██╔════╝██╔══██╗╚══██╔══╝██╔══██╗██║     ██║╚══██╔══╝╚██╗ ██╔╝    ██║    ██║
    █████╗  ███████║   ██║   ███████║██║     ██║   ██║    ╚████╔╝     ██║ █╗ ██║
    ██╔══╝  ██╔══██║   ██║   ██╔══██║██║     ██║   ██║     ╚██╔╝      ██║███╗██║
    ██║     ██║  ██║   ██║   ██║  ██║███████╗██║   ██║      ██║       ╚███╔███╔╝
    ╚═╝     ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝   ╚═╝      ╚═╝        ╚══╝╚══╝ 
    
    Fatality W Library - Complete Example
    Repository: https://github.com/Fatality-Wins/FatalityLib
    
    This example demonstrates ALL features of the library including:
    - Toggles, Sliders, Dropdowns, Textboxes
    - Color Pickers, Keybinds
    - Buttons, Labels, Dividers
    - Theme Manager, Save Manager
    - Notifications, Watermarks
    - And much more!
]]

--// ═══════════════════════════════════════════════════════════════════════════════ \\--
--//                                   LOAD LIBRARY                                   \\--
--// ═══════════════════════════════════════════════════════════════════════════════ \\--

local repo = 'https://raw.githubusercontent.com/Fatality-Wins/FatalityLib/main/'

print('[Fatality W] Loading library from:', repo)

local FatalityLib = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

print('[Fatality W] Library loaded successfully!')

--// ═══════════════════════════════════════════════════════════════════════════════ \\--
--//                                 CREATE WINDOW                                    \\--
--// ═══════════════════════════════════════════════════════════════════════════════ \\--

local Window = FatalityLib:CreateWindow({
    Title = 'Fatality W Library',
    Subtitle = 'v1.0.0 - Full Example',
    Size = UDim2.fromOffset(600, 450),
    ToggleKey = Enum.KeyCode.RightShift
})

--// ═══════════════════════════════════════════════════════════════════════════════ \\--
--//                                   CREATE TABS                                    \\--
--// ═══════════════════════════════════════════════════════════════════════════════ \\--

local Tabs = {
    Main = Window:AddTab({ Name = '🏠 Main' }),
    Combat = Window:AddTab({ Name = '⚔️ Combat' }),
    Visuals = Window:AddTab({ Name = '👁️ Visuals' }),
    Misc = Window:AddTab({ Name = '🔧 Misc' }),
    Settings = Window:AddTab({ Name = '⚙️ Settings' })
}

--// ═══════════════════════════════════════════════════════════════════════════════ \\--
--//                                    MAIN TAB                                      \\--
--// ═══════════════════════════════════════════════════════════════════════════════ \\--

local PlayerSection = Tabs.Main:AddSection({ Name = 'Player Movement' })

-- Walk Speed Toggle
PlayerSection:AddToggle({
    Name = 'Walk Speed Hack',
    Flag = 'WalkSpeedEnabled',
    Default = false,
    Callback = function(value)
        print('[Fatality W] Walk Speed:', value)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild('Humanoid') then
            if value then
                char.Humanoid.WalkSpeed = Options.WalkSpeedValue.Value
            else
                char.Humanoid.WalkSpeed = 16
            end
        end
    end
})

-- Walk Speed Slider
PlayerSection:AddSlider({
    Name = 'Walk Speed Value',
    Flag = 'WalkSpeedValue',
    Min = 16,
    Max = 500,
    Default = 16,
    Increment = 1,
    Suffix = ' studs/s',
    Callback = function(value)
        if Toggles.WalkSpeedEnabled and Toggles.WalkSpeedEnabled.Value then
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild('Humanoid') then
                char.Humanoid.WalkSpeed = value
            end
        end
    end
})

-- Jump Power Toggle
PlayerSection:AddToggle({
    Name = 'Jump Power Hack',
    Flag = 'JumpPowerEnabled',
    Default = false,
    Callback = function(value)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild('Humanoid') then
            if value then
                char.Humanoid.JumpPower = Options.JumpPowerValue.Value
            else
                char.Humanoid.JumpPower = 50
            end
        end
    end
})

-- Jump Power Slider
PlayerSection:AddSlider({
    Name = 'Jump Power Value',
    Flag = 'JumpPowerValue',
    Min = 50,
    Max = 500,
    Default = 50,
    Increment = 1,
})

-- Gravity Toggle
PlayerSection:AddToggle({
    Name = 'Low Gravity',
    Flag = 'LowGravity',
    Default = false,
    Callback = function(value)
        workspace.Gravity = value and Options.GravityValue.Value or 196.2
    end
})

-- Gravity Slider
PlayerSection:AddSlider({
    Name = 'Gravity Value',
    Flag = 'GravityValue',
    Min = 0,
    Max = 196.2,
    Default = 196.2,
    Increment = 0.1,
    Callback = function(value)
        if Toggles.LowGravity and Toggles.LowGravity.Value then
            workspace.Gravity = value
        end
    end
})

-- Divider
PlayerSection:AddLabel('Character Actions')

-- Reset Button
PlayerSection:AddButton({
    Name = 'Reset Character',
    Callback = function()
        game.Players.LocalPlayer.Character:BreakJoints()
        FatalityLib:Notify({
            Title = 'Character',
            Content = 'Character reset!',
            Duration = 2,
            Type = 'Info'
        })
    end
})

-- Respawn Button
PlayerSection:AddButton({
    Name = 'Respawn (Teleport to Spawn)',
    Callback = function()
        local spawn = workspace:FindFirstChild('SpawnLocation')
        if spawn then
            local char = game.Players.LocalPlayer.Character
            if char then
                char:SetPrimaryPartCFrame(spawn.CFrame + Vector3.new(0, 5, 0))
                FatalityLib:Notify({
                    Title = 'Teleport',
                    Content = 'Teleported to spawn!',
                    Duration = 2,
                    Type = 'Success'
                })
            end
        else
            FatalityLib:Notify({
                Title = 'Error',
                Content = 'No spawn location found!',
                Duration = 2,
                Type = 'Error'
            })
        end
    end
})

-- Teleport Section
local TeleportSection = Tabs.Main:AddSection({ Name = 'Teleportation' })

-- Player Name Textbox
TeleportSection:AddTextbox({
    Name = 'Player Name',
    Flag = 'TeleportPlayerName',
    Default = '',
    Placeholder = 'Enter player name...',
    Callback = function(value, enterPressed)
        if enterPressed and value ~= '' then
            print('[Fatality W] Searching for player:', value)
        end
    end
})

-- Player Dropdown
TeleportSection:AddDropdown({
    Name = 'Select Player',
    Flag = 'PlayerDropdown',
    Items = (function()
        local players = {}
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                table.insert(players, player.Name)
            end
        end
        table.sort(players)
        return players
    end)(),
    Default = nil,
    Callback = function(value)
        print('[Fatality W] Selected player:', value)
    end
})

-- Refresh Players Button
TeleportSection:AddButton({
    Name = 'Refresh Player List',
    Callback = function()
        local players = {}
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                table.insert(players, player.Name)
            end
        end
        table.sort(players)
        
        if Options.PlayerDropdown and Options.PlayerDropdown.Refresh then
            Options.PlayerDropdown:Refresh(players)
        end
        
        FatalityLib:Notify({
            Title = 'Players',
            Content = 'Player list refreshed!',
            Duration = 2,
            Type = 'Info'
        })
    end
})

-- Teleport to Player Button
TeleportSection:AddButton({
    Name = 'Teleport to Selected Player',
    Callback = function()
        local targetName = Options.PlayerDropdown and Options.PlayerDropdown.Value
        if not targetName or targetName == '' then
            FatalityLib:Notify({
                Title = 'Error',
                Content = 'Please select a player first!',
                Duration = 2,
                Type = 'Error'
            })
            return
        end
        
        local target = game.Players:FindFirstChild(targetName)
        if target and target.Character and target.Character:FindFirstChild('HumanoidRootPart') then
            local localChar = game.Players.LocalPlayer.Character
            if localChar and localChar:FindFirstChild('HumanoidRootPart') then
                localChar.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
                FatalityLib:Notify({
                    Title = 'Teleport',
                    Content = 'Teleported to ' .. targetName .. '!',
                    Duration = 2,
                    Type = 'Success'
                })
            end
        else
            FatalityLib:Notify({
                Title = 'Error',
                Content = 'Player not found or has no character!',
                Duration = 2,
                Type = 'Error'
            })
        end
    end
})

--// ═══════════════════════════════════════════════════════════════════════════════ \\--
--//                                  COMBAT TAB                                      \\--
--// ═══════════════════════════════════════════════════════════════════════════════ \\--

local AimbotSection = Tabs.Combat:AddSection({ Name = 'Aimbot Settings' })

AimbotSection:AddToggle({
    Name = 'Enable Aimbot',
    Flag = 'AimbotEnabled',
    Default = false,
    Risky = true,
    Callback = function(value)
        print('[Fatality W] Aimbot:', value)
    end
})

AimbotSection:AddDropdown({
    Name = 'Target Part',
    Flag = 'AimbotTargetPart',
    Items = { 'Head', 'Torso', 'HumanoidRootPart', 'Left Arm', 'Right Arm' },
    Default = 'Head',
    Callback = function(value)
        print('[Fatality W] Aimbot targeting:', value)
    end
})

AimbotSection:AddSlider({
    Name = 'FOV Circle Size',
    Flag = 'AimbotFOV',
    Min = 50,
    Max = 500,
    Default = 100,
    Increment = 1,
    Suffix = ' pixels',
})

AimbotSection:AddSlider({
    Name = 'Smoothness',
    Flag = 'AimbotSmooth',
    Min = 0,
    Max = 1,
    Default = 0.5,
    Increment = 0.01,
})

AimbotSection:AddToggle({
    Name = 'Show FOV Circle',
    Flag = 'ShowFOVCircle',
    Default = true,
})

AimbotSection:AddToggle({
    Name = 'Team Check',
    Flag = 'AimbotTeamCheck',
    Default = true,
})

AimbotSection:AddToggle({
    Name = 'Visible Check',
    Flag = 'AimbotVisibleCheck',
    Default = true,
})

-- Aimbot Keybind
AimbotSection:AddKeybind({
    Name = 'Aimbot Key',
    Flag = 'AimbotKey',
    Default = Enum.KeyCode.E,
    Callback = function(key)
        print('[Fatality W] Aimbot key:', key)
    end
})

-- Triggerbot Section
local TriggerbotSection = Tabs.Combat:AddSection({ Name = 'Triggerbot' })

TriggerbotSection:AddToggle({
    Name = 'Enable Triggerbot',
    Flag = 'TriggerbotEnabled',
    Default = false,
    Risky = true,
})

TriggerbotSection:AddSlider({
    Name = 'Trigger Delay',
    Flag = 'TriggerbotDelay',
    Min = 0,
    Max = 1,
    Default = 0.1,
    Increment = 0.01,
    Suffix = 's',
})

TriggerbotSection:AddToggle({
    Name = 'Team Check',
    Flag = 'TriggerbotTeamCheck',
    Default = true,
})

-- Silent Aim Section
local SilentAimSection = Tabs.Combat:AddSection({ Name = 'Silent Aim' })

SilentAimSection:AddToggle({
    Name = 'Enable Silent Aim',
    Flag = 'SilentAimEnabled',
    Default = false,
    Risky = true,
})

SilentAimSection:AddSlider({
    Name = 'Hit Chance',
    Flag = 'SilentAimHitChance',
    Min = 0,
    Max = 100,
    Default = 100,
    Increment = 1,
    Suffix = '%',
})

--// ═══════════════════════════════════════════════════════════════════════════════ \\--
--//                                  VISUALS TAB                                     \\--
--// ═══════════════════════════════════════════════════════════════════════════════ \\--

local ESPSection = Tabs.Visuals:AddSection({ Name = 'ESP Settings' })

ESPSection:AddToggle({
    Name = 'Enable ESP',
    Flag = 'ESPEnabled',
    Default = false,
    Callback = function(value)
        print('[Fatality W] ESP:', value)
    end
})

ESPSection:AddToggle({
    Name = 'Box ESP',
    Flag = 'ESPBox',
    Default = true,
})

ESPSection:AddToggle({
    Name = 'Name ESP',
    Flag = 'ESPName',
    Default = true,
})

ESPSection:AddToggle({
    Name = 'Health Bar',
    Flag = 'ESPHealth',
    Default = true,
})

ESPSection:AddToggle({
    Name = 'Distance ESP',
    Flag = 'ESPDistance',
    Default = false,
})

ESPSection:AddToggle({
    Name = 'Tracers',
    Flag = 'ESPTracers',
    Default = false,
})

ESPSection:AddToggle({
    Name = 'Team Check',
    Flag = 'ESPTeamCheck',
    Default = true,
})

ESPSection:AddSlider({
    Name = 'Max Distance',
    Flag = 'ESPMaxDistance',
    Min = 100,
    Max = 5000,
    Default = 1000,
    Increment = 50,
    Suffix = ' studs',
})

-- ESP Colors
ESPSection:AddLabel('ESP Colors')

ESPSection:AddColorPicker({
    Name = 'Enemy Color',
    Flag = 'ESPEnemyColor',
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(color)
        print('[Fatality W] Enemy ESP color:', color)
    end
})

ESPSection:AddColorPicker({
    Name = 'Team Color',
    Flag = 'ESPTeamColor',
    Default = Color3.fromRGB(0, 255, 0),
})

ESPSection:AddColorPicker({
    Name = 'Tracer Color',
    Flag = 'ESPTracerColor',
    Default = Color3.fromRGB(255, 255, 255),
})

-- World Visuals Section
local WorldSection = Tabs.Visuals:AddSection({ Name = 'World Visuals' })

WorldSection:AddToggle({
    Name = 'Fullbright',
    Flag = 'Fullbright',
    Default = false,
    Callback = function(value)
        local lighting = game:GetService('Lighting')
        if value then
            lighting.Brightness = 2
            lighting.ClockTime = 14
            lighting.FogEnd = 100000
            lighting.GlobalShadows = false
            lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        else
            lighting.Brightness = 1
            lighting.ClockTime = 14
            lighting.FogEnd = 100000
            lighting.GlobalShadows = true
            lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
        end
    end
})

WorldSection:AddToggle({
    Name = 'No Fog',
    Flag = 'NoFog',
    Default = false,
    Callback = function(value)
        local lighting = game:GetService('Lighting')
        if value then
            lighting.FogEnd = 100000
        else
            lighting.FogEnd = 100000
        end
    end
})

WorldSection:AddSlider({
    Name = 'Field of View',
    Flag = 'FOV',
    Min = 30,
    Max = 120,
    Default = 70,
    Increment = 1,
    Callback = function(value)
        workspace.CurrentCamera.FieldOfView = value
    end
})

WorldSection:AddToggle({
    Name = 'Remove Shadows',
    Flag = 'NoShadows',
    Default = false,
    Callback = function(value)
        game:GetService('Lighting').GlobalShadows = not value
    end
})

-- Crosshair Section
local CrosshairSection = Tabs.Visuals:AddSection({ Name = 'Crosshair' })

CrosshairSection:AddToggle({
    Name = 'Custom Crosshair',
    Flag = 'CustomCrosshair',
    Default = false,
})

CrosshairSection:AddSlider({
    Name = 'Crosshair Size',
    Flag = 'CrosshairSize',
    Min = 5,
    Max = 50,
    Default = 10,
    Increment = 1,
})

CrosshairSection:AddSlider({
    Name = 'Crosshair Thickness',
    Flag = 'CrosshairThickness',
    Min = 1,
    Max = 5,
    Default = 2,
    Increment = 1,
})

CrosshairSection:AddColorPicker({
    Name = 'Crosshair Color',
    Flag = 'CrosshairColor',
    Default = Color3.fromRGB(0, 255, 0),
})

--// ═══════════════════════════════════════════════════════════════════════════════ \\--
--//                                   MISC TAB                                       \\--
--// ═══════════════════════════════════════════════════════════════════════════════ \\--

local MovementSection = Tabs.Misc:AddSection({ Name = 'Movement' })

MovementSection:AddToggle({
    Name = 'Infinite Jump',
    Flag = 'InfiniteJump',
    Default = false,
})

MovementSection:AddToggle({
    Name = 'NoClip',
    Flag = 'NoClip',
    Default = false,
    Risky = true,
})

MovementSection:AddToggle({
    Name = 'Fly',
    Flag = 'Fly',
    Default = false,
    Risky = true,
})

MovementSection:AddSlider({
    Name = 'Fly Speed',
    Flag = 'FlySpeed',
    Min = 10,
    Max = 500,
    Default = 50,
    Increment = 1,
})

MovementSection:AddKeybind({
    Name = 'Fly Keybind',
    Flag = 'FlyKeybind',
    Default = Enum.KeyCode.F,
})

-- Automation Section
local AutoSection = Tabs.Misc:AddSection({ Name = 'Automation' })

AutoSection:AddToggle({
    Name = 'Auto Sprint',
    Flag = 'AutoSprint',
    Default = false,
})

AutoSection:AddToggle({
    Name = 'Auto Collect Items',
    Flag = 'AutoCollect',
    Default = false,
})

AutoSection:AddSlider({
    Name = 'Collection Range',
    Flag = 'CollectionRange',
    Min = 10,
    Max = 100,
    Default = 30,
    Increment = 1,
    Suffix = ' studs',
})

-- Game Section
local GameSection = Tabs.Misc:AddSection({ Name = 'Game' })

GameSection:AddButton({
    Name = 'Rejoin Server',
    Callback = function()
        game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
    end
})

GameSection:AddButton({
    Name = 'Server Hop',
    Callback = function()
        local TeleportService = game:GetService('TeleportService')
        local HttpService = game:GetService('HttpService')
        
        local servers = HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=100'))
        
        if servers and servers.data then
            for _, server in pairs(servers.data) do
                if server.id ~= game.JobId then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, game.Players.LocalPlayer)
                    break
                end
            end
        end
    end
})

GameSection:AddTextbox({
    Name = 'Join Game by ID',
    Flag = 'GameID',
    Default = '',
    Placeholder = 'Enter Game ID...',
})

GameSection:AddButton({
    Name = 'Join Game',
    Callback = function()
        local gameId = Options.GameID and Options.GameID.Value
        if gameId and gameId ~= '' then
            local id = tonumber(gameId)
            if id then
                game:GetService('TeleportService'):Teleport(id, game.Players.LocalPlayer)
            else
                FatalityLib:Notify({
                    Title = 'Error',
                    Content = 'Invalid Game ID!',
                    Duration = 2,
                    Type = 'Error'
                })
            end
        end
    end
})

-- Info Section
local InfoSection = Tabs.Misc:AddSection({ Name = 'Information' })

InfoSection:AddLabel('Fatality W Library v1.0.0')
InfoSection:AddLabel('GitHub: Fatality-Wins/FatalityLib')
InfoSection:AddLabel('Press RightShift to toggle menu')
InfoSection:AddLabel(' ')
InfoSection:AddLabel('Example script with all features')
InfoSection:AddLabel('Created for demonstration purposes')

--// ═══════════════════════════════════════════════════════════════════════════════ \\--
--//                                SETTINGS TAB                                      \\--
--// ═══════════════════════════════════════════════════════════════════════════════ \\--

local MenuSection = Tabs.Settings:AddSection({ Name = 'Menu Settings' })

MenuSection:AddButton({
    Name = 'Unload UI',
    Callback = function()
        FatalityLib:Notify({
            Title = 'Unloading',
            Content = 'Unloading UI in 2 seconds...',
            Duration = 2,
            Type = 'Warning'
        })
        
        task.wait(2)
        FatalityLib:Destroy()
    end
})

MenuSection:AddKeybind({
    Name = 'Menu Toggle Key',
    Flag = 'MenuKeybind',
    Default = Enum.KeyCode.RightShift,
    Callback = function(key)
        print('[Fatality W] Menu toggle key:', key)
    end
})

MenuSection:AddToggle({
    Name = 'Enable Notifications',
    Flag = 'NotificationsEnabled',
    Default = true,
    Callback = function(value)
        print('[Fatality W] Notifications:', value)
    end
})

MenuSection:AddToggle({
    Name = 'Show Watermark',
    Flag = 'ShowWatermark',
    Default = false,
    Callback = function(value)
        -- If watermark feature is implemented
        -- FatalityLib:SetWatermarkVisibility(value)
    end
})

MenuSection:AddToggle({
    Name = 'Notify on Error',
    Flag = 'NotifyOnError',
    Default = true,
    Callback = function(value)
        FatalityLib.NotifyOnError = value
    end
})

-- Performance Section
local PerformanceSection = Tabs.Settings:AddSection({ Name = 'Performance' })

PerformanceSection:AddToggle({
    Name = 'Reduce Motion',
    Flag = 'ReduceMotion',
    Default = false,
})

PerformanceSection:AddSlider({
    Name = 'UI Render Distance',
    Flag = 'UIRenderDistance',
    Min = 100,
    Max = 1000,
    Default = 500,
    Increment = 50,
})

--// ═══════════════════════════════════════════════════════════════════════════════ \\--
--//                            THEME & SAVE MANAGER SETUP                            \\--
--// ═══════════════════════════════════════════════════════════════════════════════ \\--

-- Setup Theme Manager
ThemeManager:SetLibrary(FatalityLib)
ThemeManager:SetFolder('FatalityW')

-- Setup Save Manager
SaveManager:SetLibrary(FatalityLib)
SaveManager:SetFolder('FatalityW')
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({
    'MenuKeybind',
    'GameID',
    'TeleportPlayerName'
})

-- Build UI sections
ThemeManager:BuildThemeSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- Load saved settings
task.spawn(function()
    task.wait(1)
    ThemeManager:LoadDefaultTheme()
    SaveManager:LoadAutoloadConfig()
end)

--// ═══════════════════════════════════════════════════════════════════════════════ \\--
--//                              WATERMARK & FPS COUNTER                             \\--
--// ═══════════════════════════════════════════════════════════════════════════════ \\--

local FrameTime = tick()
local FrameCount = 0
local FPS = 60

local function UpdateFPS()
    FrameCount = FrameCount + 1
    
    if (tick() - FrameTime) >= 1 then
        FPS = FrameCount
        FrameTime = tick()
        FrameCount = 0
    end
end

game:GetService('RunService').RenderStepped:Connect(UpdateFPS)

--// ═══════════════════════════════════════════════════════════════════════════════ \\--
--//                              EXAMPLE FUNCTIONALITY                               \\--
--// ═══════════════════════════════════════════════════════════════════════════════ \\--

-- Infinite Jump Implementation
local InfiniteJumpConnection
if Toggles.InfiniteJump then
    Toggles.InfiniteJump:OnChanged(function()
        if Toggles.InfiniteJump.Value then
            InfiniteJumpConnection = game:GetService('UserInputService').JumpRequest:Connect(function()
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChild('Humanoid') then
                    char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
            
            FatalityLib:Notify({
                Title = 'Infinite Jump',
                Content = 'Infinite Jump enabled!',
                Duration = 2,
                Type = 'Success'
            })
        else
            if InfiniteJumpConnection then
                InfiniteJumpConnection:Disconnect()
            end
            
            FatalityLib:Notify({
                Title = 'Infinite Jump',
                Content = 'Infinite Jump disabled!',
                Duration = 2,
                Type = 'Info'
            })
        end
    end)
end

-- NoClip Implementation
local NoClipConnection
if Toggles.NoClip then
    Toggles.NoClip:OnChanged(function()
        if Toggles.NoClip.Value then
            NoClipConnection = game:GetService('RunService').Stepped:Connect(function()
                local char = game.Players.LocalPlayer.Character
                if char then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA('BasePart') and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end)
            
            FatalityLib:Notify({
                Title = 'NoClip',
                Content = 'NoClip enabled!',
                Duration = 2,
                Type = 'Success'
            })
        else
            if NoClipConnection then
                NoClipConnection:Disconnect()
            end
            
            local char = game.Players.LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA('BasePart') then
                        part.CanCollide = true
                    end
                end
            end
            
            FatalityLib:Notify({
                Title = 'NoClip',
                Content = 'NoClip disabled!',
                Duration = 2,
                Type = 'Info'
            })
        end
    end)
end

-- Fly Implementation
local FlyConnection
local FlySpeed = 50
local Flying = false

local function StartFlying()
    local char = game.Players.LocalPlayer.Character
    if not char or not char:FindFirstChild('HumanoidRootPart') then return end
    
    local root = char.HumanoidRootPart
    local camera = workspace.CurrentCamera
    
    local BodyVelocity = Instance.new('BodyVelocity')
    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    BodyVelocity.Parent = root
    
    local BodyGyro = Instance.new('BodyGyro')
    BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    BodyGyro.P = 9e4
    BodyGyro.Parent = root
    
    FlyConnection = game:GetService('RunService').Heartbeat:Connect(function()
        if not Flying or not Toggles.Fly.Value then
            BodyVelocity:Destroy()
            BodyGyro:Destroy()
            if FlyConnection then
                FlyConnection:Disconnect()
            end
            return
        end
        
        local moveDirection = Vector3.new(0, 0, 0)
        FlySpeed = Options.FlySpeed.Value
        
        if InputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + camera.CFrame.LookVector
        end
        if InputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - camera.CFrame.LookVector
        end
        if InputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - camera.CFrame.RightVector
        end
        if InputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + camera.CFrame.RightVector
        end
        if InputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, 1, 0)
        end
        if InputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDirection = moveDirection - Vector3.new(0, 1, 0)
        end
        
        BodyVelocity.Velocity = moveDirection.Unit * FlySpeed
        BodyGyro.CFrame = camera.CFrame
    end)
end

if Toggles.Fly then
    Toggles.Fly:OnChanged(function()
        Flying = Toggles.Fly.Value
        
        if Flying then
            StartFlying()
            FatalityLib:Notify({
                Title = 'Fly',
                Content = 'Fly enabled! Use WASD + Space/Shift',
                Duration = 3,
                Type = 'Success'
            })
        else
            if FlyConnection then
                FlyConnection:Disconnect()
            end
            
            FatalityLib:Notify({
                Title = 'Fly',
                Content = 'Fly disabled!',
                Duration = 2,
                Type = 'Info'
            })
        end
    end)
end

if Options.FlyKeybind then
    Options.FlyKeybind:OnChanged(function()
        print('[Fatality W] Fly keybind changed to:', Options.FlyKeybind.Value)
    end)
end

--// ═══════════════════════════════════════════════════════════════════════════════ \\--
--//                                 NOTIFICATIONS                                    \\--
--// ═══════════════════════════════════════════════════════════════════════════════ \\--

-- Welcome notification
FatalityLib:Notify({
    Title = 'Fatality W Library',
    Content = 'Successfully loaded!\nPress RightShift to toggle menu.\nGitHub: Fatality-Wins/FatalityLib',
    Duration = 5,
    Type = 'Success'
})

-- Example notifications after delay
task.spawn(function()
    task.wait(3)
    
    FatalityLib:Notify({
        Title = 'Example',
        Content = 'This is an info notification!',
        Duration = 3,
        Type = 'Info'
    })
    
    task.wait(2)
    
    FatalityLib:Notify({
        Title = 'Warning',
        Content = 'This is a warning notification!',
        Duration = 3,
        Type = 'Warning'
    })
    
    task.wait(2)
    
    FatalityLib:Notify({
        Title = 'Tip',
        Content = 'Use the Settings tab to save your configs!',
        Duration = 4,
        Type = 'Info'
    })
end)

--// ═══════════════════════════════════════════════════════════════════════════════ \\--
--//                                 AUTO UPDATES                                     \\--
--// ═══════════════════════════════════════════════════════════════════════════════ \\--

-- Auto-refresh player list every 30 seconds
task.spawn(function()
    while true do
        task.wait(30)
        
        if Options.PlayerDropdown then
            local players = {}
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer then
                    table.insert(players, player.Name)
                end
            end
            table.sort(players)
            
            if Options.PlayerDropdown.Refresh then
                Options.PlayerDropdown:Refresh(players)
            end
        end
    end
end)

--// ═══════════════════════════════════════════════════════════════════════════════ \\--
--//                                   FINISH                                         \\--
--// ═══════════════════════════════════════════════════════════════════════════════ \\--

print('═══════════════════════════════════════════════════════════════')
print('           FATALITY W LIBRARY - EXAMPLE LOADED')
print('═══════════════════════════════════════════════════════════════')
print('[Fatality W] All features loaded successfully!')
print('[Fatality W] Press RightShift to toggle the menu')
print('[Fatality W] Repository: https://github.com/Fatality-Wins/FatalityLib')
print('[Fatality W] Example script version 1.0.0')
print('═══════════════════════════════════════════════════════════════')
