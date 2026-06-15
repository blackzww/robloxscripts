local scripts = {
    [142823291] = "https://raw.githubusercontent.com/blackzww/robloxscripts/refs/heads/main/Mirrors%20Hub%20-%20MM2/mm2.lua", -- MM2
}

local universal = "https://raw.githubusercontent.com/blackzww/robloxscripts/refs/heads/main/Mirrors%20Hub%20-%20Universal/universal.lua"

local supported = scripts[game.PlaceId]
local url = supported or universal

if supported then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Mirrors Hub",
        Text = "Game Supported 🎮",
        Duration = 5
    })
else
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Mirrors Hub",
        Text = "Game not Supported ⚠️ | Loading Universal",
        Duration = 5
    })
end

loadstring(game:HttpGet(url))()
