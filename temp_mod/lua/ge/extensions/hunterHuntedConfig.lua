local M = {}

-- Spielkonfiguration
M.config = {
    -- Punktesystem
    startingPoints = 1000,
    pointsLossRate = 10, -- Punkte pro Sekunde wenn gefangen
    
    -- Geschwindigkeit und Distanzen
    speedThreshold = 2.0, -- km/h unter dem Punkte verloren gehen
    hunterCatchRadius = 10, -- Meter - Distanz für Punkteverlust
    targetCaptureRadius = 5, -- Meter - Distanz zum Zielpunkt
    
    -- Zeiten
    targetCaptureTime = 180, -- 3 Minuten in Sekunden
    
    -- Map Settings (anpassbar je nach Map)
    mapBounds = {
        minX = -2000,
        maxX = 2000,
        minY = -2000,
        maxY = 2000,
        minZ = -100,
        maxZ = 500
    },
    
    -- UI Settings
    showNavigationForHunted = true,
    showPointsForAll = true,
    
    -- Debug
    debugMode = true,
    logLevel = "INFO"
}

-- Vordefinierte Zielpunkte für verschiedene Maps (optional)
M.predefinedTargets = {
    -- GridMap
    gridmap = {
        {x = 500, y = 500, z = 0},
        {x = -500, y = 500, z = 0},
        {x = 500, y = -500, z = 0},
        {x = -500, y = -500, z = 0},
        {x = 0, y = 0, z = 0}
    },
    
    -- West Coast USA
    west_coast_usa = {
        {x = 1200, y = 800, z = 50},
        {x = -800, y = 1000, z = 30},
        {x = 600, y = -1200, z = 80},
        {x = -1000, y = -600, z = 20}
    }
}

-- Lade Konfiguration aus Datei (falls vorhanden)
function M.loadConfig()
    local configPath = "settings/hunterHunted_config.json"
    
    -- Versuche Konfiguration zu laden
    if FS.fileExists(configPath) then
        local content = readFile(configPath)
        if content then
            local success, data = pcall(jsonDecode, content)
            if success and data then
                -- Merge mit Standard-Konfiguration
                for key, value in pairs(data) do
                    if M.config[key] ~= nil then
                        M.config[key] = value
                    end
                end
                log('I', 'hunterHuntedConfig', 'Configuration loaded from file')
            end
        end
    else
        log('I', 'hunterHuntedConfig', 'Using default configuration')
    end
end

-- Speichere Konfiguration
function M.saveConfig()
    local configPath = "settings/hunterHunted_config.json"
    local content = jsonEncode(M.config)
    
    if content then
        writeFile(configPath, content)
        log('I', 'hunterHuntedConfig', 'Configuration saved to file')
    end
end

-- Getter für Konfigurationswerte
function M.get(key)
    return M.config[key]
end

-- Setter für Konfigurationswerte
function M.set(key, value)
    if M.config[key] ~= nil then
        M.config[key] = value
        return true
    end
    return false
end

-- Generiere zufälligen Zielpunkt basierend auf aktueller Map
function M.generateRandomTarget()
    local mapName = getMapName() or "unknown"
    local targets = M.predefinedTargets[mapName]
    
    if targets and #targets > 0 then
        -- Wähle zufälligen vordefinierten Punkt
        return targets[math.random(1, #targets)]
    else
        -- Generiere zufälligen Punkt innerhalb der Map-Grenzen
        return {
            x = math.random(M.config.mapBounds.minX, M.config.mapBounds.maxX),
            y = math.random(M.config.mapBounds.minY, M.config.mapBounds.maxY),
            z = 0 -- Wird später an Bodenhöhe angepasst
        }
    end
end

-- Validiere Zielpunkt (prüfe ob befahrbar)
function M.validateTarget(target)
    -- Hier könnte man prüfen ob der Punkt auf einer Straße liegt,
    -- nicht im Wasser ist, etc.
    -- Für jetzt einfache Validierung
    
    if not target then return false end
    
    local bounds = M.config.mapBounds
    return target.x >= bounds.minX and target.x <= bounds.maxX and
           target.y >= bounds.minY and target.y <= bounds.maxY
end

-- Extension lifecycle
function M.onExtensionLoaded()
    M.loadConfig()
    log('I', 'hunterHuntedConfig', 'Hunter Hunted Config loaded')
end

function M.onExtensionUnloaded()
    M.saveConfig()
end

return M