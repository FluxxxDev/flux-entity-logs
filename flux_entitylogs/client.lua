local loggedVehicles = {}
local loggedProps = {} 

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if Config.LogVehicles then
            local ped = PlayerPedId()
            if IsPedInAnyVehicle(ped, false) then
                local vehicle = GetVehiclePedIsIn(ped, false)
                local model = GetEntityModel(vehicle)
                local spawnCode = GetDisplayNameFromVehicleModel(model)
                local networkId = NetworkGetNetworkIdFromEntity(vehicle)

                if not loggedVehicles[networkId] then
                    loggedVehicles[networkId] = true
                    print(string.format("[DEBUG] Logging Vehicle Spawn - Model: %s, SpawnCode: %s, Network ID: %s", model, spawnCode, networkId))
                    TriggerServerEvent('logSpawnEvent', "Vehicle", model, spawnCode, networkId, GetPlayerName(PlayerId()), GetPlayerServerId(PlayerId()))
                end
            end
        end

        if Config.LogProps then
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)

            local props = GetAllProps()
            for _, prop in ipairs(props) do
                local model = GetEntityModel(prop)
                local networkId = NetworkGetNetworkIdFromEntity(prop)

                if not loggedProps[networkId] then
                    loggedProps[networkId] = true
                    print(string.format("[DEBUG] Logging Prop Spawn - Model: %s, Network ID: %s", model, networkId))
                    TriggerServerEvent('logSpawnEvent', "Prop", model, nil, networkId, GetPlayerName(PlayerId()), GetPlayerServerId(PlayerId()))
                end
            end
        end
    end
end)

function GetAllProps()
    local props = {}
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local radius = 0.9
    
    local handle, object = FindFirstObject()
    local success
    repeat
        local entityCoords = GetEntityCoords(object)
        if #(coords - entityCoords) < radius then
            if not IsEntityAVehicle(object) and not IsPedInAnyVehicle(ped, false) then
                table.insert(props, object)
            end
        end
        success, object = FindNextObject(handle)
    until not success
    EndFindObject(handle)

    return props
end
