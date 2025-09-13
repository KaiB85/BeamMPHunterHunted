-- Simple Hunter Hunted Test Extension
local M = {}

-- Simple test function
local function onExtensionLoaded()
    log('I', 'hunterHuntedSimple', 'HUNTER HUNTED MOD LOADED SUCCESSFULLY!')
    print('HUNTER HUNTED MOD LOADED SUCCESSFULLY!')
end

-- Test function
function M.testFunction()
    print("Hunter Hunted test function works!")
    return "success"
end

-- Extension registration
M.onExtensionLoaded = onExtensionLoaded

-- Call initialization immediately
onExtensionLoaded()

return M