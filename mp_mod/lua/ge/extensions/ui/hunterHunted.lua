-- Hunter Hunted Multiplayer UI Extension
local M = {}

-- Game state that syncs across multiplayer
local gameState = {
    isActive = false,
    players = {},
    hunterPoints = 1000,
    currentRole = "neutral"
}

-- UI state
local uiVisible = false

-- Core functions
function M.toggleUI()
    uiVisible = not uiVisible
    print("Hunter Hunted UI toggled: " .. tostring(uiVisible))
end

function M.setRole(role)
    gameState.currentRole = role or "neutral"
    print("Hunter Hunted: Role set to " .. gameState.currentRole)
    
    -- Send to multiplayer if available
    if core_multiplayerGameplay then
        core_multiplayerGameplay.sendCustomData("hunterHunted", {
            action = "roleChange",
            role = role,
            playerId = core_multiplayerGameplay.getOwnPlayerId()
        })
    end
end

function M.startGame()
    gameState.isActive = true
    print("Hunter Hunted: Game started!")
    
    if core_multiplayerGameplay then
        core_multiplayerGameplay.sendCustomData("hunterHunted", {
            action = "gameStart"
        })
    end
end

function M.stopGame()
    gameState.isActive = false
    print("Hunter Hunted: Game stopped!")
    
    if core_multiplayerGameplay then
        core_multiplayerGameplay.sendCustomData("hunterHunted", {
            action = "gameStop"
        })
    end
end

-- Multiplayer data handler
function M.onCustomDataReceived(data)
    if data.action == "roleChange" then
        print("Player " .. tostring(data.playerId) .. " changed role to " .. data.role)
    elseif data.action == "gameStart" then
        gameState.isActive = true
        print("Game started by remote player")
    elseif data.action == "gameStop" then
        gameState.isActive = false
        print("Game stopped by remote player")
    end
end

-- Register multiplayer handler
if core_multiplayerGameplay then
    core_multiplayerGameplay.registerCustomDataHandler("hunterHunted", M.onCustomDataReceived)
end

-- Simple test function
function M.test()
    print("Hunter Hunted Multiplayer Extension Working!")
    print("Current role: " .. gameState.currentRole)
    print("Game active: " .. tostring(gameState.isActive))
    return gameState
end

print("Hunter Hunted Multiplayer UI Extension Loaded!")

return M