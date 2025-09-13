local M = {}

-- Game State
local gameState = {
    isActive = false,
    players = {},
    targetPoint = nil,
    targetTimer = 0,
    hunterPoints = 1000, -- Gemeinsame Punkte der Gejagten
    targetRadius = 5, -- Radius in Metern für Zielerreichung
    captureTime = 180, -- 3 Minuten in Sekunden
    speedThreshold = 2.0 -- km/h unter dem Punkte abgezogen werden
}

-- Player Roles
local ROLES = {
    NEUTRAL = "neutral",
    HUNTER = "hunter", 
    HUNTED = "hunted"
}

-- Initialize the extension
local function onExtensionLoaded()
    log('I', 'hunterHunted', 'Hunter Hunted mod loaded')
    
    -- Initialize local player
    local playerId = be:getPlayerName() or "Player1"
    gameState.players[playerId] = {
        role = ROLES.NEUTRAL,
        position = {x = 0, y = 0, z = 0},
        velocity = 0,
        lastUpdate = 0
    }
    
    log('I', 'hunterHunted', 'Local player initialized as: ' .. playerId)
end

-- Player Management
function M.onPlayerJoin(playerId)
    gameState.players[playerId] = {
        role = ROLES.NEUTRAL,
        position = {x = 0, y = 0, z = 0},
        velocity = 0,
        lastUpdate = 0
    }
    
    log('I', 'hunterHunted', 'Player ' .. playerId .. ' joined as neutral')
    M.sendGameStateToPlayer(playerId)
end

function M.onPlayerLeave(playerId)
    if gameState.players[playerId] then
        gameState.players[playerId] = nil
        log('I', 'hunterHunted', 'Player ' .. playerId .. ' left the game')
    end
end

-- Role Management
function M.setPlayerRole(playerId, role)
    if not gameState.players[playerId] then return end
    if not ROLES[string.upper(role)] then return end
    
    gameState.players[playerId].role = role
    log('I', 'hunterHunted', 'Player ' .. playerId .. ' changed role to ' .. role)
    
    -- Send update to all players
    M.broadcastGameState()
    
    -- If player becomes hunted and no target exists, create one
    if role == ROLES.HUNTED and not gameState.targetPoint then
        M.generateNewTarget()
    end
end

-- Target Point System
function M.generateNewTarget()
    -- Generate random point on map (simplified - in real implementation use map bounds)
    local mapSize = 2000 -- Adjust based on actual map
    gameState.targetPoint = {
        x = math.random(-mapSize, mapSize),
        y = math.random(-mapSize, mapSize),
        z = 0 -- Will be adjusted to ground level
    }
    
    gameState.targetTimer = 0
    
    log('I', 'hunterHunted', 'New target generated at: ' .. 
        gameState.targetPoint.x .. ', ' .. gameState.targetPoint.y)
    
    M.broadcastGameState()
end

-- Game Logic Update
function M.onUpdate(dt)
    if not gameState.isActive then return end
    
    -- Update player positions and check conditions
    for playerId, player in pairs(gameState.players) do
        M.updatePlayerData(playerId)
        
        if player.role == ROLES.HUNTED then
            M.checkHuntedPlayer(playerId, player, dt)
        end
    end
    
    -- Check target point conditions
    if gameState.targetPoint then
        M.checkTargetPoint(dt)
    end
end

function M.updatePlayerData(playerId)
    -- Get vehicle data (simplified - in real implementation get from BeamNG vehicle)
    local vehicle = be:getPlayerVehicle(playerId)
    if not vehicle then return end
    
    local player = gameState.players[playerId]
    -- Update position and velocity
    -- player.position = vehicle:getPosition()
    -- player.velocity = vehicle:getVelocity()
end

function M.checkHuntedPlayer(playerId, player, dt)
    -- Check if hunted player is moving slowly
    if player.velocity < gameState.speedThreshold then
        -- Check if any hunter is nearby
        local hunterNearby = false
        for otherPlayerId, otherPlayer in pairs(gameState.players) do
            if otherPlayer.role == ROLES.HUNTER then
                local distance = M.getDistance(player.position, otherPlayer.position)
                if distance < 10 then -- 10 meter radius for point deduction
                    hunterNearby = true
                    break
                end
            end
        end
        
        if hunterNearby then
            gameState.hunterPoints = math.max(0, gameState.hunterPoints - (10 * dt)) -- 10 points per second
            log('I', 'hunterHunted', 'Hunted player caught! Points: ' .. gameState.hunterPoints)
        end
    end
end

function M.checkTargetPoint(dt)
    local huntedAtTarget = {}
    local huntersAtTarget = {}
    
    -- Check which players are at target
    for playerId, player in pairs(gameState.players) do
        local distance = M.getDistance(player.position, gameState.targetPoint)
        
        if player.role == ROLES.HUNTED and distance < gameState.targetRadius then
            table.insert(huntedAtTarget, playerId)
        elseif player.role == ROLES.HUNTER and distance < gameState.targetRadius then
            table.insert(huntersAtTarget, playerId)
        end
    end
    
    -- If hunted players are at target and no hunters
    if #huntedAtTarget > 0 and #huntersAtTarget == 0 then
        gameState.targetTimer = gameState.targetTimer + dt
        
        -- Check if they've been there long enough
        if gameState.targetTimer >= gameState.captureTime then
            M.huntedWin()
        end
    else
        -- Reset timer if hunters arrive or hunted leave
        if #huntersAtTarget > 0 then
            M.generateNewTarget() -- Hunters reached target, generate new one
        else
            gameState.targetTimer = 0
        end
    end
end

-- Win Conditions
function M.huntedWin()
    log('I', 'hunterHunted', 'Hunted players win!')
    M.endGame("Hunted players reached the target!")
end

function M.huntersWin()
    log('I', 'hunterHunted', 'Hunters win!')
    M.endGame("Hunters caught all hunted players!")
end

function M.endGame(message)
    gameState.isActive = false
    -- Send win message to all players
    M.broadcastMessage(message)
end

-- Game Control
function M.startGame()
    gameState.isActive = true
    gameState.hunterPoints = 1000
    gameState.targetTimer = 0
    
    -- Generate first target if there are hunted players
    local hasHunted = false
    for _, player in pairs(gameState.players) do
        if player.role == ROLES.HUNTED then
            hasHunted = true
            break
        end
    end
    
    if hasHunted then
        M.generateNewTarget()
    end
    
    log('I', 'hunterHunted', 'Game started!')
    M.broadcastGameState()
end

function M.stopGame()
    gameState.isActive = false
    gameState.targetPoint = nil
    gameState.targetTimer = 0
    
    log('I', 'hunterHunted', 'Game stopped!')
    M.broadcastGameState()
end

-- Utility Functions
function M.getDistance(pos1, pos2)
    local dx = pos1.x - pos2.x
    local dy = pos1.y - pos2.y
    local dz = pos1.z - pos2.z
    return math.sqrt(dx*dx + dy*dy + dz*dz)
end

-- Network Functions
function M.sendGameStateToPlayer(playerId)
    -- Send current game state to specific player
    -- Implementation depends on BeamNG's networking system
end

function M.broadcastGameState()
    -- Send game state to all players
    for playerId, _ in pairs(gameState.players) do
        M.sendGameStateToPlayer(playerId)
    end
end

function M.broadcastMessage(message)
    -- Send message to all players
    log('I', 'hunterHunted', 'Broadcast: ' .. message)
end

-- UI Functions
function M.initUI()
    -- Simple console-based UI
    log('I', 'hunterHunted', 'UI initialized - Use console commands:')
    log('I', 'hunterHunted', 'extensions.hunterHunted.setPlayerRole("ROLE") - NEUTRAL/HUNTER/HUNTED')
    log('I', 'hunterHunted', 'extensions.hunterHunted.startGame() - Start game')
    log('I', 'hunterHunted', 'extensions.hunterHunted.stopGame() - Stop game')
end

-- Console Commands for testing
function M.setRole(role)
    local playerId = be:getPlayerName() or "Player1"
    M.setPlayerRole(playerId, string.lower(role))
end

-- Public API
M.setPlayerRole = M.setPlayerRole
M.startGame = M.startGame
M.stopGame = M.stopGame
M.getGameState = function() return gameState end

-- Extension lifecycle
M.onExtensionLoaded = onExtensionLoaded
M.onExtensionUnloaded = function()
    log('I', 'hunterHunted', 'Hunter Hunted mod unloaded')
end

-- Add console commands
M.setRole = M.setRole

-- Auto-initialize
onExtensionLoaded()

return M