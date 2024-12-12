FiveM Entity Logs

Vehicle Logging:

Logs vehicle spawns when a player enters a vehicle.
Captures the vehicle’s model, spawn code, network ID, and the player responsible for spawning it.
Provides a clear trace of who spawned which vehicle and when.


Prop Logging:

Tracks the spawning of props like traffic cones, barriers, and other in-game objects.
Only logs a prop when it is spawned by a player, ensuring minimal log spam.
Logs the model name, network ID, player name, and server ID for each spawned prop.


Real-time Logging to Discord:

The script sends detailed information to a Discord webhook about the spawned entities, making it easy for server administrators to review in-game activities.
Each log entry includes the type of entity (vehicle or prop), player information (name, ID, steam, discord), and entity-specific data (model, spawn code, network ID).


Efficient Tracking:

Reduces unnecessary checks by logging entities at specific spawn points (only when a vehicle or prop is spawned).
Minimizes performance impact by logging once per entity spawn and caching previously logged entities.


Webhook Configuration:

Easily configurable Discord webhook URL in the config.lua  file, allowing staff to direct the logs to any Discord channel.



Debugging:

If you have changed any part of the code and are seeing bugs you can always import the following code below into your `server.lua`. I would suggest not touching if you are unsure what to do.


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
