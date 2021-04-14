RSCore = nil
TriggerEvent('RSCore:GetObject', function(obj) RSCore = obj end)

RSCore.Functions.CreateCallback("rs-gangs:server:FetchConfig", function(source, cb)
    cb(json.decode(LoadResourceFile(GetCurrentResourceName(), "config.json")))
end)

RSCore.Commands.Add("creategang", "Create a whitelisted gang job with a stash and car spawn", {{name = "gang", help = "Name of the gang"}, {name = "label", help = "Gang Label"}}, true, function(source, args)
    name = args[1]
    table.remove(args, 1)
    label = table.concat(args, " ")
    
    TriggerClientEvent("rs-gangs:client:BeginGangCreation", source, name, label)
end, "admin")

RegisterServerEvent("rs-gangs:server:creategang", function(newGang, gangName, gangLabel)
    local permission = RSCore.Functions.GetPermission(source)

    if permission == "admin" or permission == "god" then
        local gangConfig = json.decode(LoadResourceFile(GetCurrentResourceName(), "config.json"))
        gangConfig[gangName] = newGang

        local gangs = json.decode(LoadResourceFile(GetCurrentResourceName(), "gangs.json"))
        gangs[gangName] = {
            label = gangLabel
        }

        SaveResourceFile(GetCurrentResourceName(), "config.json", json.encode(gangConfig), -1)
        TriggerClientEvent("rs-gangs:client:UpdateGangs", -1, gangConfig)

        SaveResourceFile(GetCurrentResourceName(), "gangs.json", json.encode(gangs), -1)
        TriggerClientEvent("RSCore:Client:UpdateGangs", -1, gangs)
        TriggerEvent("RSCore:Server:UpdateGangs", gangs)

        TriggerClientEvent("RSCore:Notify", source, "Gang: "..gangName.." successfully Created", "success")
    else
        RSCore.Functions.Kick(source, "Attempting to place create a gang")
    end
end)

function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end


RSCore.Commands.Add("invitegang", "Invite a player into your gang", {{name = "ID", help = "Player ID"}}, true, function(source, args)
    local Player = RSCore.Functions.GetPlayer(source)
    local gang = Player.PlayerData.gang.name

    if gang == "none" then 
        TriggerClientEvent("RSCore:Notify", source, "You are not in a gang", "error")
        return 
    end
    if Config["GangLeaders"][gang] ~= nil and has_value(Config["GangLeaders"][gang], Player.PlayerData.citizenid) then
        local id = tonumber(args[1])
        if id == source then return end

        local OtherPlayer = RSCore.Functions.GetPlayer(id)
        if OtherPlayer ~= nil then
            OtherPlayer.Functions.SetGang(gang)
            TriggerClientEvent("RSCore:Notify", source, string.format("%s has been invited into your gang", GetPlayerName(id)))
            TriggerClientEvent("RSCore:Notify", id, string.format("%s has invited into you to %s", GetPlayerName(source), RSCore.Shared.Gangs[gang].label))
        else
            TriggerClientEvent("RSCore:Notify", source, "This player is not online", "error")
        end
    else
        TriggerClientEvent("RSCore:Notify", source, "You are not the leader of this gang", "error")
    end
end)

RSCore.Commands.Add("removegang", "Remove a player from your gang", {{name = "ID", help = "Player ID"}}, true, function(source, args)
    local Player = RSCore.Functions.GetPlayer(source)
    local gang = Player.PlayerData.gang.name

    if gang == "none" then 
        TriggerClientEvent("RSCore:Notify", source, "You are not in a gang", "error")
        return 
    end
    if Config["GangLeaders"][gang] ~= nil and has_value(Config["GangLeaders"][gang], Player.PlayerData.citizenid) then
        local id = tonumber(args[1])
        if id == source then return end

        local OtherPlayer = RSCore.Functions.GetPlayer(id)
        if OtherPlayer ~= nil then
            OtherPlayer.Functions.SetGang("none")
            TriggerClientEvent("RSCore:Notify", source, string.format("%s has been removed from your gang", GetPlayerName(id)))
            TriggerClientEvent("RSCore:Notify", id, string.format("%s has removed you from %s", GetPlayerName(source), RSCore.Shared.Gangs[gang].label))
        else
            TriggerClientEvent("RSCore:Notify", source, "This player is not online", "error")
        end
    else
        TriggerClientEvent("RSCore:Notify", source, "You are not the leader of this gang", "error")
    end
end)
