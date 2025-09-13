-- Working Hunter Hunted Extension
print("HUNTER HUNTED: Loading extension...")

local M = {}

-- Game state
local gameState = {
    isActive = false,
    players = {},
    hunterPoints = 1000
}

-- Simple functions
function M.test()
    print("HUNTER HUNTED: Test function works!")
    return "Extension is working!"
end

function M.setRole(role)
    print("HUNTER HUNTED: Setting role to " .. tostring(role))
    -- Add your role logic here
    return true
end

function M.startGame()
    gameState.isActive = true
    print("HUNTER HUNTED: Game started!")
    return true
end

function M.stopGame()
    gameState.isActive = false
    print("HUNTER HUNTED: Game stopped!")
    return true
end

function M.getGameState()
    return gameState
end

print("HUNTER HUNTED: Extension loaded successfully!")

return M