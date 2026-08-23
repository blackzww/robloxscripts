local scripts={
	[12308344607]="URL_DO_DOORS",
	[6516141723]="URL_DO_DOORS",
	[6524124388]="URL_DO_DOORS",

	
}

local universal="https://raw.githubusercontent.com/blackzww/robloxscripts/refs/heads/main/Mirrors%20Hub%20-%20Universal/universal.lua"

local supported=scripts[game.PlaceId]
local url=supported or universal

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
