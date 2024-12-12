RegisterNetEvent('logSpawnEvent')
AddEventHandler('logSpawnEvent', function(spawnType, model, spawnCode, networkId, playerName, serverId)
    local source = source
    local steamId = GetPlayerIdentifier(source, 0) or "N/A"
    local discordId = GetPlayerIdentifier(source, 1) or "N/A"

    local message = {
        {
            ["color"] = spawnType == "Vehicle" and 16711680 or 65280, -- Red for vehicles, green for props
            ["title"] = "Flux Entity Logs | " .. spawnType .. " Spawned",
            ["description"] = string.format(
                "Model: %s\nNetwork ID: %s\nPlayer Name: %s\nPlayer ID: %s\nSteam ID: %s\nDiscord ID: %s" ..
                (spawnType == "Vehicle" and "\nSpawn Code: " .. spawnCode or ""),
                model, networkId, playerName, serverId, steamId, discordId
            )
        }
    }

    PerformHttpRequest(Config.WebhookURL, function(err, text, headers) end, 'POST', json.encode({username = "Flux Entity Logs", embeds = message}), {['Content-Type'] = 'application/json'})
end)


print("[DEBUG] Entity Logs are now Logging")
print("[DEBUG] Webhook URL: " .. Config.WebhookURL)
print("[DEBUG] Log Vehicles: " .. tostring(Config.LogVehicles))
print("[DEBUG] Log Props: " .. tostring(Config.LogProps))

