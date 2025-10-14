local QBCore = exports['qb-core']:GetCoreObject()

function Notify(message, type, duration)
    if duration == nil then
        duration = 3000
    end

    if Config.Settings.Notify == 'ft_notification' then
        exports.ft_notification:ShowNotify(message, type, duration)
    elseif Config.Settings.Notify == 'qb-core' then
        QBCore.Functions.Notify(message, type, duration)
    elseif Config.Settings.Notify == 'ox_lib' then
        lib.notify({ title = L('notify.title'), description = message, position = 'top', type = type, showDuration = duration })
    end
end
