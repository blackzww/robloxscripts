local scripts={
	[12308344607]="https://raw.githubusercontent.com/blackzww/robloxscripts/refs/heads/main/Mirrors%20Hub%20-%20Doors%20(Lobby)/doorsl.lua",
	[6516141723]="https://raw.githubusercontent.com/blackzww/robloxscripts/refs/heads/main/Mirrors%20Hub%20-%20Doors%20(Lobby)/doorsl.lua",
	[6524124388]="https://raw.githubusercontent.com/blackzww/robloxscripts/refs/heads/main/Mirrors%20Hub%20-%20Doors%20(Lobby)/doorsl.lua",
	[136801880565837]="https://raw.githubusercontent.com/blackzww/robloxscripts/refs/heads/main/Mirrors%20Hub%20-%20%5BFPS%5D%20Flick/flick.lua",
	[142823291]="https://raw.githubusercontent.com/blackzww/robloxscripts/refs/heads/main/Mirrors%20Hub%20-%20MM2/mm2.lua"
}

local games={
	[2440500124]=false
}

local universal="https://raw.githubusercontent.com/blackzww/robloxscripts/refs/heads/main/Mirrors%20Hub%20-%20Universal/universal.lua"
local url=scripts[game.PlaceId]
local supported=url~=nil

if not url then url=universal end

pcall(function()
	game:GetService("StarterGui"):SetCore("SendNotification",{
		Title="Mirrors Hub",
		Text=supported and "Game Supported 🎮" or "Game not Supported ⚠️ | Loading Universal",
		Duration=5
	})
end)

pcall(function()
	local source=game:HttpGet(url)
	local fn=loadstring(source)
	if fn then fn() end
end)
