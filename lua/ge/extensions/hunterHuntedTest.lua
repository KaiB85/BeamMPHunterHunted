-- Minimal Test Extension that definitely loads
local M = {}

-- Initialization
local function onExtensionLoaded()
    print("========================================")
    print("HUNTER HUNTED TEST EXTENSION LOADED!!!")
    print("========================================")
    log('I', 'hunterHuntedTest', 'Extension loaded successfully')
end

-- Simple test function
function M.test()
    print("Hunter Hunted test function works!")
    return "success"
end

-- Extension registration for BeamNG
M.onExtensionLoaded = onExtensionLoaded

-- Execute immediately
onExtensionLoaded()

return M