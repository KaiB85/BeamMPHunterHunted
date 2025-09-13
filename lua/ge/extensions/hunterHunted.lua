-- Hunter Hunted Extension for BeamNG.drive
local M = {}

-- Extension metadata
M.dependencies = {}

-- Game state
local gameState = {
    isActive = false,
    players = {},
    hunterPoints = 1000,
    myRole = "neutral",
    targetPoint = nil,
    targetTimer = 0
}

-- Player roles
local ROLES = {
    NEUTRAL = "neutral",
    HUNTER = "hunter", 
    HUNTED = "hunted"
}

-- Extension lifecycle functions
local function onExtensionLoaded()
    log('I', 'hunterHunted', 'Hunter Hunted extension loaded')
    print("HUNTER HUNTED: Extension loaded successfully!")
end

local function onExtensionUnloaded()
    log('I', 'hunterHunted', 'Hunter Hunted extension unloaded')
end

-- Core game functions
function M.test()
    print("=== HUNTER HUNTED STATUS ===")
    print("Extension: WORKING")
    print("Current role: " .. gameState.myRole)
    print("Game active: " .. tostring(gameState.isActive))
    print("Points: " .. gameState.hunterPoints)
    return gameState
end

function M.setRole(role)
    if not role or not ROLES[string.upper(role)] then
        print("Invalid role. Use: HUNTER, HUNTED, or NEUTRAL")
        return false
    end
    
    gameState.myRole = string.lower(role)
    print("HUNTER HUNTED: Role changed to " .. gameState.myRole)
    log('I', 'hunterHunted', 'Player role changed to: ' .. gameState.myRole)
    return true
end

function M.startGame()
    gameState.isActive = true
    print("HUNTER HUNTED: Game started!")
    log('I', 'hunterHunted', 'Game started')
    return true
end

function M.stopGame()
    gameState.isActive = false
    print("HUNTER HUNTED: Game stopped!")
    log('I', 'hunterHunted', 'Game stopped')
    return true
end

function M.getGameState()
    return gameState
end

function M.help()
    print("=== HUNTER HUNTED COMMANDS ===")
    print("extensions.hunterHunted.test() - Show status")
    print("extensions.hunterHunted.setRole('HUNTER'|'HUNTED'|'NEUTRAL') - Change role")
    print("extensions.hunterHunted.startGame() - Start game")
    print("extensions.hunterHunted.stopGame() - Stop game")
    print("extensions.hunterHunted.help() - Show this help")
end

-- Register lifecycle functions
M.onExtensionLoaded = onExtensionLoaded
M.onExtensionUnloaded = onExtensionUnloaded

return M