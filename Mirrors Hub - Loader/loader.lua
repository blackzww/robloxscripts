local scripts={
	[12308344607]="https://raw.githubusercontent.com/blackzww/robloxscripts/refs/heads/main/Mirrors%20Hub%20-%20Doors%20(Lobby)/doorsl.lua",
	[6516141723]="https://raw.githubusercontent.com/blackzww/robloxscripts/refs/heads/main/Mirrors%20Hub%20-%20Doors%20(Lobby)/doorsl.lua",
	[6524124388]="https://raw.githubusercontent.com/blackzww/robloxscripts/refs/heads/main/Mirrors%20Hub%20-%20Doors%20(Lobby)/doorsl.lua",
	[136801880565837]="https://raw.githubusercontent.com/blackzww/robloxscripts/refs/heads/main/Mirrors%20Hub%20-%20%5BFPS%5D%20Flick/flick.lua"
}

local games={
	[2440500124]="SEM SCRIPTS ATUALMENTE"
}

local universal="https://raw.githubusercontent.com/blackzww/robloxscripts/refs/heads/main/Mirrors%20Hub%20-%20Universal/universal.lua"

local url=scripts[game.PlaceId] or games[game.GameId] or universal
local supported=scripts[game.PlaceId]~=nil or games[game.GameId]~=nil

pcall(function()
	game:GetService("StarterGui"):SetCore("SendNotification",{
		Title="Mirrors Hub",
		Text=supported and "Game Supported 🎮" or "Game not Supported ⚠️ | Loading Universal",
		Duration=5
	})
end)

local ok,source=pcall(game.HttpGet,game,url)

if not ok or type(source)~="string" or source=="" then
	warn("[MIRRORS] Failed to load script.")
	return
end

local fn,err=loadstring(source)

if not fn then
	warn("[MIRRORS] Compile error: "..tostring(err))
	return
end

fn()
