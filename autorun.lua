-- Auto-run script for Hunter Hunted mod
print("Hunter Hunted autorun.lua executing...")

-- Load extension immediately
local path = "lua/ge/extensions/hunterHuntedTest.lua"
local success, result = pcall(dofile, path)

if success then
    print("Hunter Hunted extension loaded via autorun!")
else
    print("Failed to load Hunter Hunted extension: " .. tostring(result))
end