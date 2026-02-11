local menuOpen = false
local hasPermission = false

local function setNui(open)
    menuOpen = open
    SetNuiFocus(open, open)
    SendNUIMessage({
        action = 'setVisible',
        visible = open
    })
end

local function notify(msg)
    BeginTextCommandThefeedPost('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandThefeedPostTicker(false, true)
end

RegisterNetEvent('luxuadmin:setPermission', function(isAllowed)
    hasPermission = isAllowed == true
end)

RegisterCommand(Config.OpenCommand, function()
    if not hasPermission then
        notify('~r~Du hast keine Rechte für LuxuAdmin.')
        return
    end

    setNui(not menuOpen)
end, false)

RegisterKeyMapping(Config.OpenCommand, 'LuxuAdmin Menü öffnen/schließen', 'keyboard', 'F10')

RegisterNUICallback('close', function(_, cb)
    setNui(false)
    cb({ ok = true })
end)

RegisterNUICallback('kickPlayer', function(data, cb)
    TriggerServerEvent('luxuadmin:kickPlayer', tonumber(data.id), tostring(data.reason or 'Kein Grund angegeben'))
    cb({ ok = true })
end)

RegisterNUICallback('announce', function(data, cb)
    TriggerServerEvent('luxuadmin:announce', tostring(data.message or ''))
    cb({ ok = true })
end)

RegisterNUICallback('setWeather', function(data, cb)
    TriggerServerEvent('luxuadmin:setWeather', tostring(data.weather or 'CLEAR'))
    cb({ ok = true })
end)

RegisterNUICallback('setTime', function(data, cb)
    TriggerServerEvent('luxuadmin:setTime', tonumber(data.hour), tonumber(data.minute))
    cb({ ok = true })
end)

RegisterNUICallback('healSelf', function(_, cb)
    local ped = PlayerPedId()
    SetEntityHealth(ped, GetEntityMaxHealth(ped))
    ClearPedBloodDamage(ped)
    notify('~g~Du wurdest geheilt.')
    cb({ ok = true })
end)

RegisterNUICallback('reviveSelf', function(_, cb)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, GetEntityHeading(ped), true, false)
    SetEntityHealth(ped, GetEntityMaxHealth(ped))
    ClearPedTasksImmediately(ped)
    ClearPedBloodDamage(ped)
    notify('~g~Du wurdest wiederbelebt.')
    cb({ ok = true })
end)

RegisterNUICallback('tpToWaypoint', function(_, cb)
    local waypoint = GetFirstBlipInfoId(8)
    if not DoesBlipExist(waypoint) then
        notify('~r~Setze zuerst einen Wegpunkt auf der Karte.')
        cb({ ok = false })
        return
    end

    local ped = PlayerPedId()
    local coords = GetBlipInfoIdCoord(waypoint)
    local foundGround, groundZ = GetGroundZFor_3dCoord(coords.x, coords.y, 1000.0, false)

    if foundGround then
        SetEntityCoordsNoOffset(ped, coords.x, coords.y, groundZ + 1.0, false, false, false)
    else
        SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z + 1.0, false, false, false)
    end

    notify('~g~Zum Wegpunkt teleportiert.')
    cb({ ok = true })
end)


RegisterNetEvent('luxuadmin:syncWeather', function(weatherType)
    ClearOverrideWeather()
    ClearWeatherTypePersist()
    SetWeatherTypePersist(weatherType)
    SetWeatherTypeNow(weatherType)
    SetWeatherTypeNowPersist(weatherType)
end)

RegisterNetEvent('luxuadmin:syncTime', function(hour, minute)
    NetworkOverrideClockTime(hour, minute, 0)
end)

CreateThread(function()
    Wait(1500)
    TriggerServerEvent('luxuadmin:requestPermission')
end)
