lib.versionCheck('Qbox-project/qbx_spawn')

-- ====== CONFIG LOCALE ======
-- Coupe l'onglet "Propriété/Maison" dans le menu de spawn
local DISABLE_PROPERTY_SPAWN = true
-- ===========================

-- Renvoie la dernière position (ou nil si joueur tout neuf)
lib.callback.register('qbx_spawn:server:getLastLocation', function(source)
    local player = exports.qbx_core:GetPlayer(source)
    if not player then
        return nil, nil
    end

    local result = MySQL.single.await(
        'SELECT position FROM players WHERE citizenid = ?',
        { player.PlayerData.citizenid }
    )

    local position = nil
    if result and result.position and result.position ~= '' then
        local ok, decoded = pcall(json.decode, result.position)
        if ok then position = decoded end
    end

    local currentPropertyId = nil
    if player.PlayerData and player.PlayerData.metadata then
        currentPropertyId = player.PlayerData.metadata.currentPropertyId
    end

    return position, currentPropertyId
end)

-- Désactive l'affichage des propriétés dans le menu de spawn
lib.callback.register('qbx_spawn:server:getProperties', function(source)
    if DISABLE_PROPERTY_SPAWN then
        return {}
    end

    -- (Code d'origine en secours si jamais vous réactivez le flag)
    if not GetResourceState('qbx_properties'):find('start') then
        return {}
    end

    local player = exports.qbx_core:GetPlayer(source)
    if not player then
        return {}
    end

    local houseData = {}
    local properties = MySQL.query.await(
        'SELECT id, property_name, coords FROM properties WHERE owner = ?',
        { player.PlayerData.citizenid }
    ) or {}

    for i = 1, #properties do
        local property = properties[i]
        local coords = nil
        local ok, decoded = pcall(json.decode, property.coords)
        if ok then coords = decoded end

        houseData[#houseData + 1] = {
            label = property.property_name,
            coords = coords,
            propertyId = property.id,
        }
    end

    return houseData
end)
