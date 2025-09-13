local M = {}

local imgui = ui_imgui
local hunterHunted = extensions.hunterHunted

-- UI State
local uiState = {
    showMainWindow = true,
    showRoleSelection = false,
    selectedRole = "neutral"
}

-- Main UI Window
local function drawMainWindow()
    if not uiState.showMainWindow then return end
    
    if imgui.Begin("Hunter Hunted", imgui.BoolPtr(uiState.showMainWindow)) then
        local gameState = hunterHunted.getGameState()
        
        -- Game Status
        imgui.Text("Game Status: " .. (gameState.isActive and "ACTIVE" or "INACTIVE"))
        imgui.Text("Hunted Points: " .. gameState.hunterPoints)
        
        -- Target Information (only for hunted players)
        local localPlayer = gameState.players[be:getPlayerName()]
        if localPlayer and localPlayer.role == "hunted" and gameState.targetPoint then
            imgui.Separator()
            imgui.Text("TARGET LOCATION:")
            imgui.Text(string.format("X: %.1f, Y: %.1f", 
                gameState.targetPoint.x, gameState.targetPoint.y))
            
            if gameState.targetTimer > 0 then
                local remaining = 180 - gameState.targetTimer
                imgui.Text(string.format("Capture Time: %.1fs", remaining))
            end
        end
        
        imgui.Separator()
        
        -- Role Selection
        if imgui.CollapsingHeader("Role Selection") then
            if imgui.RadioButton("Neutral", uiState.selectedRole == "neutral") then
                uiState.selectedRole = "neutral"
            end
            if imgui.RadioButton("Hunter", uiState.selectedRole == "hunter") then
                uiState.selectedRole = "hunter"
            end
            if imgui.RadioButton("Hunted", uiState.selectedRole == "hunted") then
                uiState.selectedRole = "hunted"
            end
            
            if imgui.Button("Change Role") then
                hunterHunted.setPlayerRole(be:getPlayerName(), uiState.selectedRole)
            end
        end
        
        -- Game Controls (for admin/host)
        imgui.Separator()
        if imgui.CollapsingHeader("Game Controls") then
            if imgui.Button("Start Game") then
                hunterHunted.startGame()
            end
            imgui.SameLine()
            if imgui.Button("Stop Game") then
                hunterHunted.stopGame()
            end
        end
        
        -- Player List
        if imgui.CollapsingHeader("Players") then
            for playerId, player in pairs(gameState.players) do
                local roleColor = {1, 1, 1, 1} -- white default
                if player.role == "hunter" then
                    roleColor = {1, 0.2, 0.2, 1} -- red
                elseif player.role == "hunted" then
                    roleColor = {0.2, 0.8, 0.2, 1} -- green
                end
                
                imgui.TextColored(imgui.ImVec4(roleColor[1], roleColor[2], roleColor[3], roleColor[4]),
                    playerId .. " (" .. player.role .. ")")
            end
        end
    end
    imgui.End()
end

-- Navigation UI for hunted players
local function drawNavigationUI()
    local gameState = hunterHunted.getGameState()
    local localPlayer = gameState.players[be:getPlayerName()]
    
    if not localPlayer or localPlayer.role ~= "hunted" or not gameState.targetPoint then
        return
    end
    
    -- Simple navigation indicator
    imgui.SetNextWindowPos(imgui.ImVec2(50, 50))
    imgui.SetNextWindowSize(imgui.ImVec2(200, 100))
    
    if imgui.Begin("Navigation", nil, imgui.WindowFlags_NoResize + imgui.WindowFlags_NoCollapse) then
        imgui.Text("TARGET LOCATION")
        imgui.Text(string.format("X: %.0f", gameState.targetPoint.x))
        imgui.Text(string.format("Y: %.0f", gameState.targetPoint.y))
        
        -- Simple distance calculation (would need actual player position)
        imgui.Text("Distance: Calculating...")
        
        -- Capture progress
        if gameState.targetTimer > 0 then
            local progress = gameState.targetTimer / 180
            imgui.ProgressBar(progress, imgui.ImVec2(180, 0))
        end
    end
    imgui.End()
end

-- Update function called by BeamNG
function M.onUpdate()
    drawMainWindow()
    drawNavigationUI()
end

-- Toggle UI visibility
function M.toggleUI()
    uiState.showMainWindow = not uiState.showMainWindow
end

-- Extension lifecycle
function M.onExtensionLoaded()
    log('I', 'hunterHuntedUI', 'Hunter Hunted UI loaded')
end

-- Register UI update
extensions.hook("onUpdate", M.onUpdate)

return M