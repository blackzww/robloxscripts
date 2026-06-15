
local scripts = {
    [142823291] = "https://raw.githubusercontent.com/SEUUSER/SEUREPO/main/mm2.lua", -- MM2
}

local universal = "https://raw.githubusercontent.com/SEUUSER/SEUREPO/main/universal.lua"

local url = scripts[game.PlaceId] or universal

loadstring(game:HttpGet(url))()
