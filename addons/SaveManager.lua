--[[
    ███████╗ █████╗ ████████╗ █████╗ ██╗     ██╗████████╗██╗   ██╗    ██╗    ██╗
    ██╔════╝██╔══██╗╚══██╔══╝██╔══██╗██║     ██║╚══██╔══╝╚██╗ ██╔╝    ██║    ██║
    █████╗  ███████║   ██║   ███████║██║     ██║   ██║    ╚████╔╝     ██║ █╗ ██║
    ██╔══╝  ██╔══██║   ██║   ██╔══██║██║     ██║   ██║     ╚██╔╝      ██║███╗██║
    ██║     ██║  ██║   ██║   ██║  ██║███████╗██║   ██║      ██║       ╚███╔███╔╝
    ╚═╝     ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝   ╚═╝      ╚═╝        ╚══╝╚══╝ 
    
    Fatality W Library - Save Manager
    Configuration System Addon
]]

local HttpService = game:GetService('HttpService')

local SaveManager = {}

do
    SaveManager.Folder = 'FatalityWLib'
    SaveManager.Ignore = {}
    SaveManager.Library = nil
    SaveManager.AutoloadLabel = nil
    
    --// ═══════════════════════════════════════════════════════════════════════════════ \\--
    --//                                    PARSERS                                       \\--
    --// ═══════════════════════════════════════════════════════════════════════════════ \\--
    
    SaveManager.Parser = {
        Toggle = {
            Save = function(idx, object)
                return {
                    type = 'Toggle',
                    idx = idx,
                    value = object.Value
                }
            end,
            Load = function(idx, data)
                if Toggles[idx] then
                    if Toggles[idx].Set then
                        Toggles[idx]:Set(data.value)
                    elseif Toggles[idx].SetValue then
                        Toggles[idx]:SetValue(data.value)
                    else
                        Toggles[idx].Value = data.value
                    end
                end
            end,
        },
        
        Slider = {
            Save = function(idx, object)
                return {
                    type = 'Slider',
                    idx = idx,
                    value = tostring(object.Value)
                }
            end,
            Load = function(idx, data)
                if Options[idx] then
                    if Options[idx].Set then
                        Options[idx]:Set(tonumber(data.value))
                    elseif Options[idx].SetValue then
                        Options[idx]:SetValue(tonumber(data.value))
                    else
                        Options[idx].Value = tonumber(data.value)
                    end
                end
            end,
        },
        
        Dropdown = {
            Save = function(idx, object)
                return {
                    type = 'Dropdown',
                    idx = idx,
                    value = object.Value,
                    multi = object.Multi or false
                }
            end,
            Load = function(idx, data)
                if Options[idx] then
                    if Options[idx].Set then
                        Options[idx]:Set(data.value)
                    elseif Options[idx].SetValue then
                        Options[idx]:SetValue(data.value)
                    else
                        Options[idx].Value = data.value
                    end
                end
            end,
        },
        
        ColorPicker = {
            Save = function(idx, object)
                local color = object.Value
                return {
                    type = 'ColorPicker',
                    idx = idx,
                    value = {
                        R = math.floor(color.R * 255),
                        G = math.floor(color.G * 255),
                        B = math.floor(color.B * 255)
                    },
                    transparency = object.Transparency or 0
                }
            end,
            Load = function(idx, data)
                if Options[idx] then
                    local color = Color3.fromRGB(data.value.R, data.value.G, data.value.B)
                    if Options[idx].Set then
                        Options[idx]:Set(color)
                    elseif Options[idx].SetValueRGB then
                        Options[idx]:SetValueRGB(color, data.transparency)
                    elseif Options[idx].SetValue then
                        Options[idx]:SetValue(color)
                    else
                        Options[idx].Value = color
                    end
                end
            end,
        },
        
        Keybind = {
            Save = function(idx, object)
                local keyValue = object.Value
                local keyName = "None"
                
                if typeof(keyValue) == "EnumItem" then
                    keyName = keyValue.Name
                elseif type(keyValue) == "string" then
                    keyName = keyValue
                end
                
                return {
                    type = 'Keybind',
                    idx = idx,
                    key = keyName,
                    mode = object.Mode or 'Toggle'
                }
            end,
            Load = function(idx, data)
                if Options[idx] then
                    local key = Enum.KeyCode[data.key] or Enum.KeyCode.None
                    if Options[idx].Set then
                        Options[idx]:Set(key)
                    elseif Options[idx].SetValue then
                        Options[idx]:SetValue({data.key, data.mode})
                    else
                        Options[idx].Value = key
                    end
                end
            end,
        },
        
        KeyPicker = {
            Save = function(idx, object)
                return {
                    type = 'KeyPicker',
                    idx = idx,
                    key = object.Value,
                    mode = object.Mode or 'Toggle'
                }
            end,
            Load = function(idx, data)
                if Options[idx] then
                    if Options[idx].Set then
                        Options[idx]:Set({data.key, data.mode})
                    elseif Options[idx].SetValue then
                        Options[idx]:SetValue({data.key, data.mode})
                    end
                end
            end,
        },
        
        Textbox = {
            Save = function(idx, object)
                return {
                    type = 'Textbox',
                    idx = idx,
                    value = object.Value
                }
            end,
            Load = function(idx, data)
                if Options[idx] and type(data.value) == 'string' then
                    if Options[idx].Set then
                        Options[idx]:Set(data.value)
                    elseif Options[idx].SetValue then
                        Options[idx]:SetValue(data.value)
                    else
                        Options[idx].Value = data.value
                    end
                end
            end,
        },
        
        Input = {
            Save = function(idx, object)
                return {
                    type = 'Input',
                    idx = idx,
                    value = object.Value
                }
            end,
            Load = function(idx, data)
                if Options[idx] and type(data.value) == 'string' then
                    if Options[idx].Set then
                        Options[idx]:Set(data.value)
                    elseif Options[idx].SetValue then
                        Options[idx]:SetValue(data.value)
                    else
                        Options[idx].Value = data.value
                    end
                end
            end,
        },
    }
    
    --// ═══════════════════════════════════════════════════════════════════════════════ \\--
    --//                                  CORE METHODS                                    \\--
    --// ═══════════════════════════════════════════════════════════════════════════════ \\--
    
    function SaveManager:SetLibrary(library)
        self.Library = library
    end
    
    function SaveManager:SetFolder(folder)
        self.Folder = folder
        self:BuildFolderTree()
    end
    
    function SaveManager:SetIgnoreIndexes(list)
        for _, key in next, list do
            self.Ignore[key] = true
        end
    end
    
    function SaveManager:IgnoreThemeSettings()
        self:SetIgnoreIndexes({
            -- Theme settings
            "BackgroundColor", 
            "MainColor", 
            "AccentColor", 
            "OutlineColor", 
            "FontColor",
            "Primary",
            "Secondary",
            "Tertiary",
            "Border",
            "Text",
            "TextDark",
            -- Theme manager
            "ThemeManager_ThemeList",
            "ThemeManager_CustomThemeList",
            "ThemeManager_CustomThemeName",
        })
    end
    
    --// ═══════════════════════════════════════════════════════════════════════════════ \\--
    --//                               FOLDER MANAGEMENT                                  \\--
    --// ═══════════════════════════════════════════════════════════════════════════════ \\--
    
    function SaveManager:BuildFolderTree()
        local paths = {
            self.Folder,
            self.Folder .. '/themes',
            self.Folder .. '/configs'
        }
        
        for i = 1, #paths do
            local path = paths[i]
            if not isfolder(path) then
                makefolder(path)
            end
        end
    end
    
    function SaveManager:RefreshConfigList()
        local configs = {}
        
        if not isfolder(self.Folder .. '/configs') then
            self:BuildFolderTree()
            return configs
        end
        
        local files = listfiles(self.Folder .. '/configs')
        
        for i = 1, #files do
            local file = files[i]
            if file:sub(-5) == '.json' then
                local name = file:match("([^/\\]+)%.json$")
                if name then
                    table.insert(configs, name)
                end
            end
        end
        
        table.sort(configs)
        return configs
    end
    
    --// ═══════════════════════════════════════════════════════════════════════════════ \\--
    --//                                 SAVE / LOAD                                      \\--
    --// ═══════════════════════════════════════════════════════════════════════════════ \\--
    
    function SaveManager:Save(name)
        if not name or name:gsub('%s', '') == '' then
            return false, 'Invalid config name'
        end
        
        local fullPath = self.Folder .. '/configs/' .. name .. '.json'
        
        local data = {
            version = 1,
            timestamp = os.time(),
            objects = {}
        }
        
        -- Save Toggles
        for idx, toggle in next, Toggles do
            if self.Ignore[idx] then continue end
            
            local toggleType = toggle.Type or 'Toggle'
            if self.Parser[toggleType] then
                local success, result = pcall(function()
                    return self.Parser[toggleType].Save(idx, toggle)
                end)
                
                if success and result then
                    table.insert(data.objects, result)
                end
            end
        end
        
        -- Save Options
        for idx, option in next, Options do
            if self.Ignore[idx] then continue end
            
            local optionType = option.Type
            if not optionType then
                -- Try to detect type
                if option.Value ~= nil then
                    if typeof(option.Value) == "Color3" then
                        optionType = 'ColorPicker'
                    elseif typeof(option.Value) == "EnumItem" then
                        optionType = 'Keybind'
                    elseif type(option.Value) == "number" then
                        optionType = 'Slider'
                    elseif type(option.Value) == "string" then
                        optionType = 'Textbox'
                    elseif type(option.Value) == "table" then
                        optionType = 'Dropdown'
                    end
                end
            end
            
            if optionType and self.Parser[optionType] then
                local success, result = pcall(function()
                    return self.Parser[optionType].Save(idx, option)
                end)
                
                if success and result then
                    table.insert(data.objects, result)
                end
            end
        end
        
        local success, encoded = pcall(HttpService.JSONEncode, HttpService, data)
        if not success then
            return false, 'Failed to encode config data'
        end
        
        local writeSuccess, writeError = pcall(function()
            writefile(fullPath, encoded)
        end)
        
        if not writeSuccess then
            return false, 'Failed to write config file: ' .. tostring(writeError)
        end
        
        return true
    end
    
    function SaveManager:Load(name)
        if not name or name:gsub('%s', '') == '' then
            return false, 'Invalid config name'
        end
        
        local fullPath = self.Folder .. '/configs/' .. name .. '.json'
        
        if not isfile(fullPath) then
            return false, 'Config file not found'
        end
        
        local content
        local readSuccess, readError = pcall(function()
            content = readfile(fullPath)
        end)
        
        if not readSuccess then
            return false, 'Failed to read config file: ' .. tostring(readError)
        end
        
        local success, data = pcall(HttpService.JSONDecode, HttpService, content)
        if not success then
            return false, 'Failed to decode config data'
        end
        
        if not data.objects then
            return false, 'Invalid config format'
        end
        
        for _, object in next, data.objects do
            if object.type and self.Parser[object.type] then
                task.spawn(function()
                    local loadSuccess, loadError = pcall(function()
                        self.Parser[object.type].Load(object.idx, object)
                    end)
                    
                    if not loadSuccess then
                        warn('[SaveManager] Failed to load ' .. object.idx .. ': ' .. tostring(loadError))
                    end
                end)
            end
        end
        
        return true
    end
    
    function SaveManager:Delete(name)
        if not name or name:gsub('%s', '') == '' then
            return false, 'Invalid config name'
        end
        
        local fullPath = self.Folder .. '/configs/' .. name .. '.json'
        
        if not isfile(fullPath) then
            return false, 'Config file not found'
        end
        
        local success, error = pcall(function()
            delfile(fullPath)
        end)
        
        if not success then
            return false, 'Failed to delete config: ' .. tostring(error)
        end
        
        return true
    end
    
    --// ═══════════════════════════════════════════════════════════════════════════════ \\--
    --//                                  AUTOLOAD                                        \\--
    --// ═══════════════════════════════════════════════════════════════════════════════ \\--
    
    function SaveManager:GetAutoloadConfig()
        local autoloadPath = self.Folder .. '/configs/autoload.txt'
        
        if isfile(autoloadPath) then
            return readfile(autoloadPath)
        end
        
        return nil
    end
    
    function SaveManager:SetAutoloadConfig(name)
        local autoloadPath = self.Folder .. '/configs/autoload.txt'
        
        if name then
            writefile(autoloadPath, name)
        elseif isfile(autoloadPath) then
            delfile(autoloadPath)
        end
    end
    
    function SaveManager:LoadAutoloadConfig()
        local autoloadName = self:GetAutoloadConfig()
        
        if autoloadName then
            local success, error = self:Load(autoloadName)
            
            if success then
                if self.Library and self.Library.Notify then
                    self.Library:Notify({
                        Title = 'Config',
                        Content = 'Auto-loaded config: ' .. autoloadName,
                        Duration = 3,
                        Type = 'Success'
                    })
                end
            else
                if self.Library and self.Library.Notify then
                    self.Library:Notify({
                        Title = 'Config Error',
                        Content = 'Failed to auto-load: ' .. tostring(error),
                        Duration = 3,
                        Type = 'Error'
                    })
                end
            end
            
            return success, error
        end
        
        return false, 'No autoload config set'
    end
    
    --// ═══════════════════════════════════════════════════════════════════════════════ \\--
    --//                              BUILD CONFIG SECTION                                \\--
    --// ═══════════════════════════════════════════════════════════════════════════════ \\--
    
    function SaveManager:BuildConfigSection(tab)
        assert(self.Library, 'SaveManager: Library not set! Use SaveManager:SetLibrary(library) first.')
        
        local section = tab:AddSection({ Name = 'Configuration' })
        
        -- Config Name Input
        section:AddTextbox({
            Name = 'Config Name',
            Flag = 'SaveManager_ConfigName',
            Default = '',
            Placeholder = 'Enter config name...',
            Callback = function() end
        })
        
        -- Config List Dropdown
        section:AddDropdown({
            Name = 'Config List',
            Flag = 'SaveManager_ConfigList',
            Items = self:RefreshConfigList(),
            Default = nil,
            Callback = function() end
        })
        
        -- Create Config Button
        section:AddButton({
            Name = 'Create Config',
            Callback = function()
                local name = Options.SaveManager_ConfigName and Options.SaveManager_ConfigName.Value
                
                if not name or name:gsub('%s', '') == '' then
                    self.Library:Notify({
                        Title = 'Config Error',
                        Content = 'Please enter a config name',
                        Duration = 3,
                        Type = 'Error'
                    })
                    return
                end
                
                local success, error = self:Save(name)
                
                if success then
                    self.Library:Notify({
                        Title = 'Config',
                        Content = 'Created config: ' .. name,
                        Duration = 3,
                        Type = 'Success'
                    })
                    
                    -- Refresh dropdown
                    if Options.SaveManager_ConfigList and Options.SaveManager_ConfigList.Refresh then
                        Options.SaveManager_ConfigList:Refresh(self:RefreshConfigList())
                    end
                else
                    self.Library:Notify({
                        Title = 'Config Error',
                        Content = 'Failed to create: ' .. tostring(error),
                        Duration = 3,
                        Type = 'Error'
                    })
                end
            end
        })
        
        -- Load Config Button
        section:AddButton({
            Name = 'Load Config',
            Callback = function()
                local name = Options.SaveManager_ConfigList and Options.SaveManager_ConfigList.Value
                
                if not name or name == '' then
                    self.Library:Notify({
                        Title = 'Config Error',
                        Content = 'Please select a config to load',
                        Duration = 3,
                        Type = 'Error'
                    })
                    return
                end
                
                local success, error = self:Load(name)
                
                if success then
                    self.Library:Notify({
                        Title = 'Config',
                        Content = 'Loaded config: ' .. name,
                        Duration = 3,
                        Type = 'Success'
                    })
                else
                    self.Library:Notify({
                        Title = 'Config Error',
                        Content = 'Failed to load: ' .. tostring(error),
                        Duration = 3,
                        Type = 'Error'
                    })
                end
            end
        })
        
        -- Overwrite Config Button
        section:AddButton({
            Name = 'Overwrite Config',
            Callback = function()
                local name = Options.SaveManager_ConfigList and Options.SaveManager_ConfigList.Value
                
                if not name or name == '' then
                    self.Library:Notify({
                        Title = 'Config Error',
                        Content = 'Please select a config to overwrite',
                        Duration = 3,
                        Type = 'Error'
                    })
                    return
                end
                
                local success, error = self:Save(name)
                
                if success then
                    self.Library:Notify({
                        Title = 'Config',
                        Content = 'Overwrote config: ' .. name,
                        Duration = 3,
                        Type = 'Success'
                    })
                else
                    self.Library:Notify({
                        Title = 'Config Error',
                        Content = 'Failed to overwrite: ' .. tostring(error),
                        Duration = 3,
                        Type = 'Error'
                    })
                end
            end
        })
        
        -- Delete Config Button
        section:AddButton({
            Name = 'Delete Config',
            Callback = function()
                local name = Options.SaveManager_ConfigList and Options.SaveManager_ConfigList.Value
                
                if not name or name == '' then
                    self.Library:Notify({
                        Title = 'Config Error',
                        Content = 'Please select a config to delete',
                        Duration = 3,
                        Type = 'Error'
                    })
                    return
                end
                
                local success, error = self:Delete(name)
                
                if success then
                    self.Library:Notify({
                        Title = 'Config',
                        Content = 'Deleted config: ' .. name,
                        Duration = 3,
                        Type = 'Success'
                    })
                    
                    -- Refresh dropdown
                    if Options.SaveManager_ConfigList and Options.SaveManager_ConfigList.Refresh then
                        Options.SaveManager_ConfigList:Refresh(self:RefreshConfigList())
                    end
                else
                    self.Library:Notify({
                        Title = 'Config Error',
                        Content = 'Failed to delete: ' .. tostring(error),
                        Duration = 3,
                        Type = 'Error'
                    })
                end
            end
        })
        
        -- Refresh List Button
        section:AddButton({
            Name = 'Refresh List',
            Callback = function()
                if Options.SaveManager_ConfigList and Options.SaveManager_ConfigList.Refresh then
                    Options.SaveManager_ConfigList:Refresh(self:RefreshConfigList())
                end
                
                self.Library:Notify({
                    Title = 'Config',
                    Content = 'Refreshed config list',
                    Duration = 2,
                    Type = 'Info'
                })
            end
        })
        
        -- Set Autoload Button
        section:AddButton({
            Name = 'Set as Autoload',
            Callback = function()
                local name = Options.SaveManager_ConfigList and Options.SaveManager_ConfigList.Value
                
                if not name or name == '' then
                    self.Library:Notify({
                        Title = 'Config Error',
                        Content = 'Please select a config for autoload',
                        Duration = 3,
                        Type = 'Error'
                    })
                    return
                end
                
                self:SetAutoloadConfig(name)
                
                if self.AutoloadLabel then
                    self.AutoloadLabel:Set('Autoload: ' .. name)
                end
                
                self.Library:Notify({
                    Title = 'Config',
                    Content = 'Set autoload: ' .. name,
                    Duration = 3,
                    Type = 'Success'
                })
            end
        })
        
        -- Clear Autoload Button
        section:AddButton({
            Name = 'Clear Autoload',
            Callback = function()
                self:SetAutoloadConfig(nil)
                
                if self.AutoloadLabel then
                    self.AutoloadLabel:Set('Autoload: None')
                end
                
                self.Library:Notify({
                    Title = 'Config',
                    Content = 'Cleared autoload config',
                    Duration = 3,
                    Type = 'Info'
                })
            end
        })
        
        -- Autoload Label
        local autoloadName = self:GetAutoloadConfig() or 'None'
        self.AutoloadLabel = section:AddLabel('Autoload: ' .. autoloadName)
        
        -- Ignore SaveManager's own options
        self:SetIgnoreIndexes({
            'SaveManager_ConfigName',
            'SaveManager_ConfigList'
        })
        
        return section
    end
    
    --// ═══════════════════════════════════════════════════════════════════════════════ \\--
    --//                             SIMPLIFIED METHODS                                   \\--
    --// ═══════════════════════════════════════════════════════════════════════════════ \\--
    
    -- Quick save to default config
    function SaveManager:QuickSave()
        return self:Save('default')
    end
    
    -- Quick load default config
    function SaveManager:QuickLoad()
        return self:Load('default')
    end
    
    -- Export config to clipboard
    function SaveManager:ExportToClipboard(name)
        if not name then
            return false, 'No config name provided'
        end
        
        local fullPath = self.Folder .. '/configs/' .. name .. '.json'
        
        if not isfile(fullPath) then
            return false, 'Config not found'
        end
        
        local content = readfile(fullPath)
        
        if setclipboard then
            setclipboard(content)
            return true
        else
            return false, 'Clipboard not supported'
        end
    end
    
    -- Import config from clipboard
    function SaveManager:ImportFromClipboard(name)
        -- This would require a way to get clipboard content
        -- Most exploits don't support this, so leaving as placeholder
        return false, 'Import from clipboard not supported'
    end
    
    --// ═══════════════════════════════════════════════════════════════════════════════ \\--
    --//                                 INITIALIZE                                       \\--
    --// ═══════════════════════════════════════════════════════════════════════════════ \\--
    
    SaveManager:BuildFolderTree()
end

return SaveManager
