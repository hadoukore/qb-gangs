# rs-gangs
Gangs for RS-Core with Gang Support instead of Jobs, supports infinately scaling gangs. Super optimised down to 0.01ms with a gang, 0.00ms as a civilian.

# Features:

Each gang has a stash and a list of vehicles they can get out from their garage. Config is fully customisable for each gang.

### New Version 2.3 In-Game Gang Configurator

To begin creating a gang use `/creategang [name] [description]` to start the process, use `/placestash` to place the gang stash and `/placegarage` to place the gang garage using the In-Game configurator to chose the gang colours and vehicle list, when you have placed both you can use `/finishgang` to complete it or use `/cancelgang` at any time to abort the process.

![Preview](https://i.imgur.com/vVr0n0W.jpg)

# Installation
Add Gangs into rs-core/shared.lua like this:
```lua
RSShared.Gangs = json.decode(LoadResourceFile("rs-gangs", "gangs.json"))

```
Add event to rs-core/server/events.lua
```lua
RegisterServerEvent("RSCore:Server:UpdateGangs")
AddEventHandler("RSCore:Server:UpdateGangs", function(gangs)
	QBShared.Gangs = gangs
	RSCore.Shared.Gangs = gangs
end)
```
Add event to rs-core/client/events.lua
```lua
RegisterNetEvent("RSCore:Server:UpdateGangs")
AddEventHandler("RSCore:Server:UpdateGangs", function(gangs)
	QBShared.Gangs = gangs
	RSCore.Shared.Gangs = gangs
end)
```

To enable lockable doors for gangs, you need to modify rs-doorlocks/client/main.lua line 217 like this:
```lua
function IsAuthorized(doorID)
	local PlayerData = RSCore.Functions.GetPlayerData()

	for _,job in pairs(doorID.authorizedJobs) do
		if job == PlayerData.job.name then
			return true
		end
	end

	for _,gang in pairs(doorID.authorizedJobs) do
		if gang == PlayerData.gang.name then
			return true
		end
	end
	
	return false
end
```
Add Citizenids for gang leaders for each gang into server/config.lua like this:
```lua
Config = {
	["GangLeaders"] = {
		["ballas"] = {
			"ORJ52463",
			"ABC12345"
		},
		["marabunta"] = {

		},
		["vagos"] = {

		},
		["families"] = {
			
		},
		["lost"] = {

		}
	}
}
```

# Interiors used:

- Ballas Interior - https://github.com/TRANEdAK1nG/Ballas-Interior
- TheFamily Interior - https://github.com/TRANEdAK1nG/Famillies-Interior
- Vagos Interior - https://github.com/TRANEdAK1nG/Vagos-Interior
- Marabunta Interior - https://github.com/TRANEdAK1nG/Marabunta-Interior
