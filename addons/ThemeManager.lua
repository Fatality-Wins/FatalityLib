--[[
    ███████╗ █████╗ ████████╗ █████╗ ██╗     ██╗████████╗██╗   ██╗    ██╗    ██╗
    ██╔════╝██╔══██╗╚══██╔══╝██╔══██╗██║     ██║╚══██╔══╝╚██╗ ██╔╝    ██║    ██║
    █████╗  ███████║   ██║   ███████║██║     ██║   ██║    ╚████╔╝     ██║ █╗ ██║
    ██╔══╝  ██╔══██║   ██║   ██╔══██║██║     ██║   ██║     ╚██╔╝      ██║███╗██║
    ██║     ██║  ██║   ██║   ██║  ██║███████╗██║   ██║      ██║       ╚███╔███╔╝
    ╚═╝     ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝   ╚═╝      ╚═╝        ╚══╝╚══╝ 
    
    Fatality W Library - Theme Manager
    Theme System Addon
]]

local HttpService = game:GetService('HttpService')

local ThemeManager = {}

do
    ThemeManager.Folder = 'FatalityWLib'
    ThemeManager.Library = nil
    ThemeManager.DefaultTheme = 'Fatality W'
    
    --// ═══════════════════════════════════════════════════════════════════════════════ \\--
    --//                                BUILT-IN THEMES                                   \\--
    --// ═══════════════════════════════════════════════════════════════════════════════ \\--
    
    ThemeManager.BuiltInThemes = {
        ['Fatality W'] = {
            Order = 1,
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
            }
        },
        ['Midnight Purple'] = {
            Order = 2,
            Theme = {
                Primary = Color3.fromRGB(18, 12, 28),
                Secondary = Color3.fromRGB(25, 18, 38),
                Tertiary = Color3.fromRGB(32, 24, 48),
                Accent = Color3.fromRGB(155, 89, 182),
                AccentDark = Color3.fromRGB(125, 69, 152),
                Text = Color3.fromRGB(255, 255, 255),
                TextDark = Color3.fromRGB(180, 180, 180),
                Border = Color3.fromRGB(50, 40, 65),
                Risk = Color3.fromRGB(255, 75, 75),
                Success = Color3.fromRGB(75, 255, 130),
            }
        },
        ['Ocean Blue'] = {
            Order = 3,
            Theme = {
                Primary = Color3.fromRGB(12, 18, 28),
                Secondary = Color3.fromRGB(18, 26, 38),
                Tertiary = Color3.fromRGB(24, 34, 48),
                Accent = Color3.fromRGB(52, 152, 219),
                AccentDark = Color3.fromRGB(41, 128, 185),
                Text = Color3.fromRGB(255, 255, 255),
                TextDark = Color3.fromRGB(180, 180, 180),
                Border = Color3.fromRGB(35, 50, 70),
                Risk = Color3.fromRGB(255, 75, 75),
                Success = Color3.fromRGB(75, 255, 130),
            }
        },
        ['Crimson Red'] = {
            Order = 4,
            Theme = {
                Primary = Color3.fromRGB(20, 12, 15),
                Secondary = Color3.fromRGB(28, 18, 22),
                Tertiary = Color3.fromRGB(38, 24, 30),
                Accent = Color3.fromRGB(231, 76, 60),
                AccentDark = Color3.fromRGB(192, 57, 43),
                Text = Color3.fromRGB(255, 255, 255),
                TextDark = Color3.fromRGB(180, 180, 180),
                Border = Color3.fromRGB(55, 35, 40),
                Risk = Color3.fromRGB(255, 100, 100),
                Success = Color3.fromRGB(75, 255, 130),
            }
        },
        ['Emerald Green'] = {
            Order = 5,
            Theme = {
                Primary = Color3.fromRGB(12, 20, 15),
                Secondary = Color3.fromRGB(18, 28, 22),
                Tertiary = Color3.fromRGB(24, 38, 30),
                Accent = Color3.fromRGB(46, 204, 113),
                AccentDark = Color3.fromRGB(39, 174, 96),
                Text = Color3.fromRGB(255, 255, 255),
                TextDark = Color3.fromRGB(180, 180, 180),
                Border = Color3.fromRGB(35, 55, 42),
                Risk = Color3.fromRGB(255, 75, 75),
                Success = Color3.fromRGB(100, 255, 150),
            }
        },
        ['Sunset Orange'] = {
            Order = 6,
            Theme = {
                Primary = Color3.fromRGB(22, 15, 12),
                Secondary = Color3.fromRGB(30, 22, 18),
                Tertiary = Color3.fromRGB(40, 30, 24),
                Accent = Color3.fromRGB(243, 156, 18),
                AccentDark = Color3.fromRGB(211, 84, 0),
                Text = Color3.fromRGB(255, 255, 255),
                TextDark = Color3.fromRGB(180, 180, 180),
                Border = Color3.fromRGB(60, 45, 35),
                Risk = Color3.fromRGB(255, 75, 75),
                Success = Color3.fromRGB(75, 255, 130),
            }
        },
        ['Cyber Pink'] = {
            Order = 7,
            Theme = {
                Primary = Color3.fromRGB(20, 12, 20),
                Secondary = Color3.fromRGB(28, 18, 28),
                Tertiary = Color3.fromRGB(38, 24, 38),
                Accent = Color3.fromRGB(255, 64, 129),
                AccentDark = Color3.fromRGB(233, 30, 99),
                Text = Color3.fromRGB(255, 255, 255),
                TextDark = Color3.fromRGB(180, 180, 180),
                Border = Color3.fromRGB(55, 35, 55),
                Risk = Color3.fromRGB(255, 100, 100),
                Success = Color3.fromRGB(75, 255, 130),
            }
        },
        ['Aqua Cyan'] = {
            Order = 8,
            Theme = {
                Primary = Color3.fromRGB(12, 20, 22),
                Secondary = Color3.fromRGB(18, 28, 30),
                Tertiary = Color3.fromRGB(24, 38, 42),
                Accent = Color3.fromRGB(0, 188, 212),
                AccentDark = Color3.fromRGB(0, 151, 167),
                Text = Color3.fromRGB(255, 255, 255),
                TextDark = Color3.fromRGB(180, 180, 180),
                Border = Color3.fromRGB(30, 55, 60),
                Risk = Color3.fromRGB(255, 75, 75),
                Success = Color3.fromRGB(75, 255, 130),
            }
        },
        ['Neon'] = {
            Order = 9,
            Theme = {
                Primary = Color3.fromRGB(8, 8, 12),
                Secondary = Color3.fromRGB(12, 12, 18),
                Tertiary = Color3.fromRGB(18, 18, 25),
                Accent = Color3.fromRGB(0, 255, 128),
                AccentDark = Color3.fromRGB(0, 200, 100),
                Text = Color3.fromRGB(255, 255, 255),
                TextDark = Color3.fromRGB(150, 255, 200),
                Border = Color3.fromRGB(0, 80, 50),
                Risk = Color3.fromRGB(255, 50, 50),
                Success = Color3.fromRGB(0, 255, 128),
            }
        },
        ['Dark Mode'] = {
            Order = 10,
            Theme = {
                Primary = Color3.fromRGB(18, 18, 18),
                Secondary = Color3.fromRGB(25, 25, 25),
                Tertiary = Color3.fromRGB(35, 35, 35),
                Accent = Color3.fromRGB(100, 100, 100),
                AccentDark = Color3.fromRGB(80, 80, 80),
                Text = Color3.fromRGB(255, 255, 255),
                TextDark = Color3.fromRGB(150, 150, 150),
                Border = Color3.fromRGB(50, 50, 50),
                Risk = Color3.fromRGB(255, 75, 75),
                Success = Color3.fromRGB(75, 255, 130),
            }
        },
        ['Light Mode'] = {
            Order = 11,
            Theme = {
                Primary = Color3.fromRGB(240, 240, 245),
                Secondary = Color3.fromRGB(230, 230, 235),
                Tertiary = Color3.fromRGB(220, 220, 225),
                Accent = Color3.fromRGB(100, 65, 200),
                AccentDark = Color3.fromRGB(80, 50, 170),
                Text = Color3.fromRGB(30, 30, 35),
                TextDark = Color3.fromRGB(80, 80, 90),
                Border = Color3.fromRGB(180, 180, 190),
                Risk = Color3.fromRGB(220, 50, 50),
                Success = Color3.fromRGB(50, 180, 100),
            }
        },
        ['Discord'] = {
            Order = 12,
            Theme = {
                Primary = Color3.fromRGB(32, 34, 37),
                Secondary = Color3.fromRGB(47, 49, 54),
                Tertiary = Color3.fromRGB(54, 57, 63),
                Accent = Color3.fromRGB(88, 101, 242),
                AccentDark = Color3.fromRGB(71, 82, 196),
                Text = Color3.fromRGB(255, 255, 255),
                TextDark = Color3.fromRGB(185, 187, 190),
                Border = Color3.fromRGB(66, 70, 77),
                Risk = Color3.fromRGB(237, 66, 69),
                Success = Color3.fromRGB(87, 242, 135),
            }
        },
        ['Spotify'] = {
            Order = 13,
            Theme = {
                Primary = Color3.fromRGB(18, 18, 18),
                Secondary = Color3.fromRGB(24, 24, 24),
                Tertiary = Color3.fromRGB(40, 40, 40),
                Accent = Color3.fromRGB(30, 215, 96),
                AccentDark = Color3.fromRGB(25, 185, 84),
                Text = Color3.fromRGB(255, 255, 255),
                TextDark = Color3.fromRGB(179, 179, 179),
                Border = Color3.fromRGB(50, 50, 50),
                Risk = Color3.fromRGB(255, 75, 75),
                Success = Color3.fromRGB(30, 215, 96),
            }
        },
        ['GitHub'] = {
            Order = 14,
            Theme = {
                Primary = Color3.fromRGB(13, 17, 23),
                Secondary = Color3.fromRGB(22, 27, 34),
                Tertiary = Color3.fromRGB(33, 38, 45),
                Accent = Color3.fromRGB(88, 166, 255),
                AccentDark = Color3.fromRGB(56, 139, 253),
                Text = Color3.fromRGB(201, 209, 217),
                TextDark = Color3.fromRGB(139, 148, 158),
                Border = Color3.fromRGB(48, 54, 61),
                Risk = Color3.fromRGB(248, 81, 73),
                Success = Color3.fromRGB(63, 185, 80),
            }
        },
    }
    
    --// ═══════════════════════════════════════════════════════════════════════════════ \\--
    --//                                  CORE METHODS                                    \\--
    --// ═══════════════════════════════════════════════════════════════════════════════ \\--
    
    function ThemeManager:SetLibrary(library)
        self.Library = library
    end
    
    function ThemeManager:SetFolder(folder)
        self.Folder = folder
        self:BuildFolderTree()
    end
    
    function ThemeManager:BuildFolderTree()
        local paths = {
            self.Folder,
            self.Folder .. '/themes'
        }
        
        for i = 1, #paths do
            local path = paths[i]
            if not isfolder(path) then
                makefolder(path)
            end
        end
    end
    
    --// ═══════════════════════════════════════════════════════════════════════════════ \\--
    --//                                THEME APPLICATION                                 \\--
    --// ═══════════════════════════════════════════════════════════════════════════════ \\--
    
    function ThemeManager:ApplyTheme(themeName)
        if not self.Library then
            warn('[ThemeManager] Library not set!')
            return false
        end
        
        local themeData = nil
        
        -- Check built-in themes first
        if self.BuiltInThemes[themeName] then
            themeData = self.BuiltInThemes[themeName].Theme
        else
            -- Check custom themes
            themeData = self:GetCustomTheme(themeName)
        end
        
        if not themeData then
            warn('[ThemeManager] Theme not found: ' .. themeName)
            return false
        end
        
        -- Apply theme to library
        for key, color in pairs(themeData) do
            if self.Library.Theme then
                self.Library.Theme[key] = color
            end
        end
        
        -- Update color pickers if they exist
        self:UpdateColorPickers(themeData)
        
        -- Refresh UI
        self:RefreshUI()
        
        return true
    end
    
    function ThemeManager:UpdateColorPickers(themeData)
        local colorFields = {
            'Primary', 'Secondary', 'Tertiary', 'Accent', 'AccentDark',
            'Text', 'TextDark', 'Border', 'Risk', 'Success'
        }
        
        for _, field in pairs(colorFields) do
            local flagName = 'ThemeManager_' .. field
            if Options[flagName] and themeData[field] then
                if Options[flagName].Set then
                    Options[flagName]:Set(themeData[field])
                end
            end
        end
    end
    
    function ThemeManager:RefreshUI()
        if not self.Library then return end
        
        -- If the library has a refresh method, call it
        if self.Library.RefreshTheme then
            self.Library:RefreshTheme()
        end
        
        -- Destroy and rebuild UI if needed
        -- This is a simple approach; you may want something more sophisticated
    end
    
    function ThemeManager:GetCurrentTheme()
        if not self.Library or not self.Library.Theme then
            return nil
        end
        
        local theme = {}
        for key, color in pairs(self.Library.Theme) do
            theme[key] = color
        end
        return theme
    end
    
    --// ═══════════════════════════════════════════════════════════════════════════════ \\--
    --//                               CUSTOM THEMES                                      \\--
    --// ═══════════════════════════════════════════════════════════════════════════════ \\--
    
    function ThemeManager:SaveCustomTheme(name)
        if not name or name:gsub('%s', '') == '' then
            if self.Library and self.Library.Notify then
                self.Library:Notify({
                    Title = 'Theme Error',
                    Content = 'Please enter a theme name',
                    Duration = 3,
                    Type = 'Error'
                })
            end
            return false
        end
        
        local theme = self:GetCurrentTheme()
        if not theme then
            return false
        end
        
        -- Convert colors to hex for storage
        local themeData = {}
        for key, color in pairs(theme) do
            if typeof(color) == 'Color3' then
                themeData[key] = {
                    R = math.floor(color.R * 255),
                    G = math.floor(color.G * 255),
                    B = math.floor(color.B * 255)
                }
            end
        end
        
        local success, encoded = pcall(HttpService.JSONEncode, HttpService, themeData)
        if not success then
            return false
        end
        
        local path = self.Folder .. '/themes/' .. name .. '.json'
        
        local writeSuccess = pcall(function()
            writefile(path, encoded)
        end)
        
        return writeSuccess
    end
    
    function ThemeManager:GetCustomTheme(name)
        local path = self.Folder .. '/themes/' .. name
        
        -- Try with .json extension
        if not isfile(path) and not path:match('%.json$') then
            path = path .. '.json'
        end
        
        if not isfile(path) then
            return nil
        end
        
        local content
        local readSuccess = pcall(function()
            content = readfile(path)
        end)
        
        if not readSuccess then
            return nil
        end
        
        local success, decoded = pcall(HttpService.JSONDecode, HttpService, content)
        if not success then
            return nil
        end
        
        -- Convert stored format back to Color3
        local theme = {}
        for key, value in pairs(decoded) do
            if type(value) == 'table' and value.R and value.G and value.B then
                theme[key] = Color3.fromRGB(value.R, value.G, value.B)
            elseif type(value) == 'string' then
                -- Support hex format
                local success, color = pcall(Color3.fromHex, value)
                if success then
                    theme[key] = color
                end
            end
        end
        
        return theme
    end
    
    function ThemeManager:DeleteCustomTheme(name)
        local path = self.Folder .. '/themes/' .. name
        
        if not path:match('%.json$') then
            path = path .. '.json'
        end
        
        if isfile(path) then
            local success = pcall(function()
                delfile(path)
            end)
            return success
        end
        
        return false
    end
    
    function ThemeManager:GetCustomThemes()
        local themes = {}
        
        if not isfolder(self.Folder .. '/themes') then
            self:BuildFolderTree()
            return themes
        end
        
        local files = listfiles(self.Folder .. '/themes')
        
        for i = 1, #files do
            local file = files[i]
            if file:sub(-5) == '.json' then
                local name = file:match("([^/\\]+)%.json$")
                if name and name ~= 'default' then
                    table.insert(themes, name)
                end
            end
        end
        
        table.sort(themes)
        return themes
    end
    
    --// ═══════════════════════════════════════════════════════════════════════════════ \\--
    --//                               DEFAULT THEME                                      \\--
    --// ═══════════════════════════════════════════════════════════════════════════════ \\--
    
    function ThemeManager:SaveDefaultTheme(name)
        local path = self.Folder .. '/themes/default.txt'
        
        pcall(function()
            writefile(path, name)
        end)
    end
    
    function ThemeManager:GetDefaultTheme()
        local path = self.Folder .. '/themes/default.txt'
        
        if isfile(path) then
            return readfile(path)
        end
        
        return self.DefaultTheme
    end
    
    function ThemeManager:LoadDefaultTheme()
        local themeName = self:GetDefaultTheme()
        
        if themeName then
            local success = self:ApplyTheme(themeName)
            
            if success and self.Library and self.Library.Notify then
                self.Library:Notify({
                    Title = 'Theme',
                    Content = 'Loaded theme: ' .. themeName,
                    Duration = 2,
                    Type = 'Info'
                })
            end
            
            return success
        end
        
        return false
    end
    
    --// ═══════════════════════════════════════════════════════════════════════════════ \\--
    --//                             GET THEME NAMES                                      \\--
    --// ═══════════════════════════════════════════════════════════════════════════════ \\--
    
    function ThemeManager:GetBuiltInThemeNames()
        local names = {}
        
        for name, data in pairs(self.BuiltInThemes) do
            table.insert(names, {name = name, order = data.Order})
        end
        
        table.sort(names, function(a, b)
            return a.order < b.order
        end)
        
        local result = {}
        for _, item in ipairs(names) do
            table.insert(result, item.name)
        end
        
        return result
    end
    
    function ThemeManager:GetAllThemeNames()
        local themes = self:GetBuiltInThemeNames()
        local custom = self:GetCustomThemes()
        
        for _, name in ipairs(custom) do
            table.insert(themes, '[Custom] ' .. name)
        end
        
        return themes
    end
    
    --// ═══════════════════════════════════════════════════════════════════════════════ \\--
    --//                            BUILD THEME SECTION                                   \\--
    --// ═══════════════════════════════════════════════════════════════════════════════ \\--
    
    function ThemeManager:BuildThemeSection(tab)
        assert(self.Library, 'ThemeManager: Library not set! Use ThemeManager:SetLibrary(library) first.')
        
        local section = tab:AddSection({ Name = 'Themes' })
        
        -- Theme Dropdown
        section:AddDropdown({
            Name = 'Select Theme',
            Flag = 'ThemeManager_ThemeList',
            Items = self:GetBuiltInThemeNames(),
            Default = self:GetDefaultTheme(),
            Callback = function(value)
                self:ApplyTheme(value)
            end
        })
        
        -- Apply Theme Button
        section:AddButton({
            Name = 'Apply Theme',
            Callback = function()
                local themeName = Options.ThemeManager_ThemeList and Options.ThemeManager_ThemeList.Value
                if themeName then
                    local success = self:ApplyTheme(themeName)
                    if success then
                        self.Library:Notify({
                            Title = 'Theme',
                            Content = 'Applied theme: ' .. themeName,
                            Duration = 2,
                            Type = 'Success'
                        })
                    end
                end
            end
        })
        
        -- Set Default Button
        section:AddButton({
            Name = 'Set as Default',
            Callback = function()
                local themeName = Options.ThemeManager_ThemeList and Options.ThemeManager_ThemeList.Value
                if themeName then
                    self:SaveDefaultTheme(themeName)
                    self.Library:Notify({
                        Title = 'Theme',
                        Content = 'Set default: ' .. themeName,
                        Duration = 2,
                        Type = 'Success'
                    })
                end
            end
        })
        
        -- Color Customization Section
        local colorSection = tab:AddSection({ Name = 'Color Customization' })
        
        -- Primary Color
        colorSection:AddColorPicker({
            Name = 'Primary',
            Flag = 'ThemeManager_Primary',
            Default = self.Library.Theme.Primary,
            Callback = function(color)
                if self.Library.Theme then
                    self.Library.Theme.Primary = color
                end
            end
        })
        
        -- Secondary Color
        colorSection:AddColorPicker({
            Name = 'Secondary',
            Flag = 'ThemeManager_Secondary',
            Default = self.Library.Theme.Secondary,
            Callback = function(color)
                if self.Library.Theme then
                    self.Library.Theme.Secondary = color
                end
            end
        })
        
        -- Tertiary Color
        colorSection:AddColorPicker({
            Name = 'Tertiary',
            Flag = 'ThemeManager_Tertiary',
            Default = self.Library.Theme.Tertiary,
            Callback = function(color)
                if self.Library.Theme then
                    self.Library.Theme.Tertiary = color
                end
            end
        })
        
        -- Accent Color
        colorSection:AddColorPicker({
            Name = 'Accent',
            Flag = 'ThemeManager_Accent',
            Default = self.Library.Theme.Accent,
            Callback = function(color)
                if self.Library.Theme then
                    self.Library.Theme.Accent = color
                    self.Library.Theme.AccentDark = Color3.fromRGB(
                        math.floor(color.R * 255 * 0.8),
                        math.floor(color.G * 255 * 0.8),
                        math.floor(color.B * 255 * 0.8)
                    )
                end
            end
        })
        
        -- Text Color
        colorSection:AddColorPicker({
            Name = 'Text',
            Flag = 'ThemeManager_Text',
            Default = self.Library.Theme.Text,
            Callback = function(color)
                if self.Library.Theme then
                    self.Library.Theme.Text = color
                end
            end
        })
        
        -- Border Color
        colorSection:AddColorPicker({
            Name = 'Border',
            Flag = 'ThemeManager_Border',
            Default = self.Library.Theme.Border,
            Callback = function(color)
                if self.Library.Theme then
                    self.Library.Theme.Border = color
                end
            end
        })
        
        -- Custom Theme Section
        local customSection = tab:AddSection({ Name = 'Custom Themes' })
        
        -- Theme Name Input
        customSection:AddTextbox({
            Name = 'Theme Name',
            Flag = 'ThemeManager_CustomName',
            Default = '',
            Placeholder = 'Enter theme name...',
            Callback = function() end
        })
        
        -- Save Theme Button
        customSection:AddButton({
            Name = 'Save Current Theme',
            Callback = function()
                local name = Options.ThemeManager_CustomName and Options.ThemeManager_CustomName.Value
                
                if not name or name:gsub('%s', '') == '' then
                    self.Library:Notify({
                        Title = 'Theme Error',
                        Content = 'Please enter a theme name',
                        Duration = 3,
                        Type = 'Error'
                    })
                    return
                end
                
                local success = self:SaveCustomTheme(name)
                
                if success then
                    self.Library:Notify({
                        Title = 'Theme',
                        Content = 'Saved theme: ' .. name,
                        Duration = 2,
                        Type = 'Success'
                    })
                    
                    -- Refresh custom themes dropdown
                    if Options.ThemeManager_CustomList and Options.ThemeManager_CustomList.Refresh then
                        Options.ThemeManager_CustomList:Refresh(self:GetCustomThemes())
                    end
                else
                    self.Library:Notify({
                        Title = 'Theme Error',
                        Content = 'Failed to save theme',
                        Duration = 3,
                        Type = 'Error'
                    })
                end
            end
        })
        
        -- Custom Themes Dropdown
        customSection:AddDropdown({
            Name = 'Custom Themes',
            Flag = 'ThemeManager_CustomList',
            Items = self:GetCustomThemes(),
            Default = nil,
            Callback = function() end
        })
        
        -- Load Custom Theme Button
        customSection:AddButton({
            Name = 'Load Custom Theme',
            Callback = function()
                local name = Options.ThemeManager_CustomList and Options.ThemeManager_CustomList.Value
                
                if not name or name == '' then
                    self.Library:Notify({
                        Title = 'Theme Error',
                        Content = 'Please select a custom theme',
                        Duration = 3,
                        Type = 'Error'
                    })
                    return
                end
                
                local success = self:ApplyTheme(name)
                
                if success then
                    self.Library:Notify({
                        Title = 'Theme',
                        Content = 'Loaded theme: ' .. name,
                        Duration = 2,
                        Type = 'Success'
                    })
                else
                    self.Library:Notify({
                        Title = 'Theme Error',
                        Content = 'Failed to load theme',
                        Duration = 3,
                        Type = 'Error'
                    })
                end
            end
        })
        
        -- Delete Custom Theme Button
        customSection:AddButton({
            Name = 'Delete Custom Theme',
            Callback = function()
                local name = Options.ThemeManager_CustomList and Options.ThemeManager_CustomList.Value
                
                if not name or name == '' then
                    self.Library:Notify({
                        Title = 'Theme Error',
                        Content = 'Please select a custom theme',
                        Duration = 3,
                        Type = 'Error'
                    })
                    return
                end
                
                local success = self:DeleteCustomTheme(name)
                
                if success then
                    self.Library:Notify({
                        Title = 'Theme',
                        Content = 'Deleted theme: ' .. name,
                        Duration = 2,
                        Type = 'Success'
                    })
                    
                    -- Refresh dropdown
                    if Options.ThemeManager_CustomList and Options.ThemeManager_CustomList.Refresh then
                        Options.ThemeManager_CustomList:Refresh(self:GetCustomThemes())
                    end
                else
                    self.Library:Notify({
                        Title = 'Theme Error',
                        Content = 'Failed to delete theme',
                        Duration = 3,
                        Type = 'Error'
                    })
                end
            end
        })
        
        -- Refresh Custom Themes Button
        customSection:AddButton({
            Name = 'Refresh Custom Themes',
            Callback = function()
                if Options.ThemeManager_CustomList and Options.ThemeManager_CustomList.Refresh then
                    Options.ThemeManager_CustomList:Refresh(self:GetCustomThemes())
                end
                
                self.Library:Notify({
                    Title = 'Theme',
                    Content = 'Refreshed custom themes',
                    Duration = 2,
                    Type = 'Info'
                })
            end
        })
        
        -- Load default theme on build
        self:LoadDefaultTheme()
        
        return section
    end
    
    --// ═══════════════════════════════════════════════════════════════════════════════ \\--
    --//                              QUICK METHODS                                       \\--
    --// ═══════════════════════════════════════════════════════════════════════════════ \\--
    
    function ThemeManager:ApplyToTab(tab)
        return self:BuildThemeSection(tab)
    end
    
    function ThemeManager:ApplyToSection(section)
        -- Simplified version for adding to existing section
        section:AddDropdown({
            Name = 'Theme',
            Flag = 'ThemeManager_Quick',
            Items = self:GetBuiltInThemeNames(),
            Default = self:GetDefaultTheme(),
            Callback = function(value)
                self:ApplyTheme(value)
            end
        })
    end
    
    --// ═══════════════════════════════════════════════════════════════════════════════ \\--
    --//                                EXPORT/IMPORT                                     \\--
    --// ═══════════════════════════════════════════════════════════════════════════════ \\--
    
    function ThemeManager:ExportTheme()
        local theme = self:GetCurrentTheme()
        if not theme then return nil end
        
        local themeData = {}
        for key, color in pairs(theme) do
            if typeof(color) == 'Color3' then
                themeData[key] = {
                    R = math.floor(color.R * 255),
                    G = math.floor(color.G * 255),
                    B = math.floor(color.B * 255)
                }
            end
        end
        
        local success, encoded = pcall(HttpService.JSONEncode, HttpService, themeData)
        if success then
            if setclipboard then
                setclipboard(encoded)
                return true
            end
        end
        
        return false
    end
    
    function ThemeManager:ImportTheme(jsonString)
        local success, decoded = pcall(HttpService.JSONDecode, HttpService, jsonString)
        if not success then
            return false
        end
        
        local theme = {}
        for key, value in pairs(decoded) do
            if type(value) == 'table' and value.R and value.G and value.B then
                theme[key] = Color3.fromRGB(value.R, value.G, value.B)
            end
        end
        
        -- Apply imported theme
        if self.Library and self.Library.Theme then
            for key, color in pairs(theme) do
                self.Library.Theme[key] = color
            end
            
            self:UpdateColorPickers(theme)
            self:RefreshUI()
            
            return true
        end
        
        return false
    end
    
    --// ═══════════════════════════════════════════════════════════════════════════════ \\--
    --//                                 INITIALIZE                                       \\--
    --// ═══════════════════════════════════════════════════════════════════════════════ \\--
    
    ThemeManager:BuildFolderTree()
end

return ThemeManager
