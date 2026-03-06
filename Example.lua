--[[
    Fatality W - Starter Settings
]]

-- Load the Library (Paste the library code above into a ModuleScript named "Library" or load via string)
-- For this example to work directly, ensure Library.lua is in the same folder or use a loadstring pointing to it
local FatalityLib = require(script.Parent.Library) -- CHANGE THIS PATH IF NEEDED

--// Initialize the UI
FatalityLib:Init({
    ToggleKey = Enum.KeyCode.RightShift,
    GroupMode = false 
})

--// ═══════════════════════════════════════════════════════════════════════════════ \\--
--//                                 SETTINGS COLUMN                                  \\--
--// ═══════════════════════════════════════════════════════════════════════════════ \\--
local Settings = FatalityLib:AddCategory("Settings")

Settings:AddLabel("UI Management")

-- 1. Unload Script
Settings:AddButton({
    Name = "Unload Script",
    Callback = function()
        FatalityLib:Destroy()
        print("Fatality W Unloaded!")
    end
})

-- 2. Move UI in Group
Settings:AddToggle({
    Name = "Move UI in Group",
    Flag = "GroupDrag",
    Default = false,
    Callback = function(Value)
        -- Toggles whether dragging moves all columns together or individually
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
            print("Auto Load Enabled - Place Config Load Logic Here")
        end
    end
})

print("[Fatality W] UI Loaded! Press Right Shift to hide/show.")
