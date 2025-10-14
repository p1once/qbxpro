local QBCore = exports['qb-core']:GetCoreObject()

function Notify(player, message, type, duration)
    if duration == nil then
        duration = 3000
    end

    if Config.Settings.Notify == 'ft_notification' then
        TriggerClientEvent('ft_notification:ShowNotify', player, message, type, duration)
    elseif Config.Settings.Notify == 'qb-core' then
        TriggerClientEvent('QBCore:Notify', player, message, type, duration)
    elseif Config.Settings.Notify == 'ox_lib' then
        lib.notify(player, { title = L('notify.title'),  description = message, position = 'top', type, showDuration = duration })
    end
end


function IsPlayerAdmin(source, cb)
    local playerIdentifiers = GetPlayerIdentifiers(source)
    local discordId, licenseId = nil, nil

    for _, identifier in ipairs(playerIdentifiers) do
        if string.find(identifier, "discord:") then
            discordId = identifier:gsub("discord:", "")
        elseif string.find(identifier, "license:") then
            licenseId = identifier:gsub("license:", "")
        end
    end

    for _, adminId in ipairs(Config.Admins or {}) do
        if adminId == licenseId or adminId == discordId then
            local perms = {
                superadmin = true
            }
            cb(true, perms)
            return
        end
    end

    if not licenseId then
        cb(false, nil)
        return
    end

    local result = Query('SELECT permissions FROM ft_qb_admins WHERE license = ? LIMIT 1', { licenseId })

    if result and result[1] and result[1].permissions then
        local ok, perms = pcall(function()
            return json.decode(result[1].permissions)
        end)

        if ok and perms then
            cb(true, perms)
            return
        else
            cb(false, nil)
            return
        end
    else
        cb(false, nil)
    end
end
