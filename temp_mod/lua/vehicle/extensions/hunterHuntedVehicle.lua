-- Hunter Hunted Vehicle Extension
local M = {}

local function onInit()
    print("Hunter Hunted Vehicle Extension Loaded!")
    log('I', 'hunterHuntedVehicle', 'Vehicle extension initialized')
end

local function onReset()
    -- Vehicle reset logic
end

-- Public functions
function M.testVehicleFunction()
    print("Hunter Hunted vehicle test works!")
    return true
end

-- Callbacks
M.onInit = onInit
M.onReset = onReset

return M