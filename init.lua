-- Hunter Hunted Mod Initialization
print("Hunter Hunted Mod Loading...")

-- Load the main extension
local path = debug.getinfo(1, "S").source:match("@(.+)/init.lua")
if path then
    package.path = package.path .. ";" .. path .. "/?.lua"
    
    -- Try to load our extension
    local success, extension = pcall(require, "lua.ge.extensions.hunterHuntedSimple")
    if success then
        print("Hunter Hunted Simple Extension Loaded!")
        _G.hunterHuntedMod = extension
    else
        print("Failed to load Hunter Hunted extension: " .. tostring(extension))
    end
end