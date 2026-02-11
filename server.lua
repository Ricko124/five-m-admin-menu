local function isAllowed(source)
    return IsPlayerAceAllowed(source, Config.RequiredAce)
end

local function deny(source)
    TriggerClientEvent('chat:addMessage', source, {
        color = {255, 80, 80},
        multiline = false,
        args = {'LuxuAdmin', 'Keine Berechtigung.'}
    })
end

RegisterNetEvent('luxuadmin:requestPermission', function()
    local src = source
    TriggerClientEvent('luxuadmin:setPermission', src, isAllowed(src))
end)

RegisterNetEvent('luxuadmin:kickPlayer', function(targetId, reason)
    local src = source
    if not isAllowed(src) then
        deny(src)
        return
    end

    local target = tonumber(targetId)
    if not target or not GetPlayerName(target) then
        TriggerClientEvent('chat:addMessage', src, {
            color = {255, 200, 80},
            args = {'LuxuAdmin', 'Ungültige Spieler-ID.'}
        })
        return
    end

    DropPlayer(target, ('Du wurdest von einem Admin gekickt. Grund: %s'):format(reason or 'Kein Grund'))
end)

RegisterNetEvent('luxuadmin:announce', function(message)
    local src = source
    if not isAllowed(src) then
        deny(src)
        return
    end

    local text = tostring(message or '')
    if text == '' then
        return
    end

    TriggerClientEvent('chat:addMessage', -1, {
        color = {255, 120, 120},
        multiline = true,
        args = {'LuxuAdmin', Config.AnnouncePrefix .. text}
    })
end)

RegisterNetEvent('luxuadmin:setWeather', function(weatherType)
    local src = source
    if not isAllowed(src) then
        deny(src)
        return
    end

    local weather = string.upper(tostring(weatherType or 'CLEAR'))
    TriggerClientEvent('luxuadmin:syncWeather', -1, weather)
end)

RegisterNetEvent('luxuadmin:setTime', function(hour, minute)
    local src = source
    if not isAllowed(src) then
        deny(src)
        return
    end

    local h = math.max(0, math.min(23, tonumber(hour) or 12))
    local m = math.max(0, math.min(59, tonumber(minute) or 0))

    TriggerClientEvent('luxuadmin:syncTime', -1, h, m)
end)
