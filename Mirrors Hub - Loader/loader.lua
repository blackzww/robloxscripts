
local scripts = {
    [142823291] = "https://raw.githubusercontent.com/SEUUSER/SEUREPO/main/mm2.lua", -- MM2
}

local universal = "https://raw.githubusercontent.com/blackzww/robloxscripts/refs/heads/main/Mirrors%20Hub%20-%20Universal/universal.lua"

local url = scripts[game.PlaceId] or universal

loadstring(game:HttpGet(url))()
