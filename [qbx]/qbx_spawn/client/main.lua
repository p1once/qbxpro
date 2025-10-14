-- qbx_spawn - client/main.lua (auto-spawn)
-- Premier spawn fixe, puis respawn à la dernière position. Aucun menu.

local config = require 'config.client' -- gardé si tu as d'autres dépendances/locals dans la ressource

-- ======= RÉGLAGE : PREMIER SPAWN FIXE =======
local FirstSpawn = vec4(-877.71, -2179.13, 8.81, 131.13) -- change ici si besoin
-- ============================================

-- Utilitaires
local function toV4(p)
    if not p then return nil end
    if type(p) == 'vector4' then return p end
    if p.w then return vec4(p.x, p.y, p.z, p.w) end
    if p.h then return vec4(p.x, p.y, p.z, p.h) end
    if p.heading then return vec4(p.x, p.y, p.z, p.heading) end
    if p[1] then return vec4(p[1], p[2], p[3], p[4] or 0.0) end
    if p.x then return vec4(p.x, p.y, p.z, 0.0) end
    return nil
end

local function isZero(pos)
    if not pos then return true end
    local x = pos.x or pos[1] or 0.0
    local y = pos.y or pos[2] or 0.0
    local z = pos.z or pos[3] or 0.0
    return (math.abs(x) < 0.001 and math.abs(y) < 0.001 and math.abs(z) < 0.001)
end

local function fadeOut(ms) DoScreenFadeOut(ms or 500) while not IsScreenFadedOut() do Wait(0) end end
local function fadeIn(ms) DoScreenFadeIn(ms or 500) end

local function safeSpawn(coords)
    coords = coords or FirstSpawn

    fadeOut(500)

    local ped = PlayerPedId()
    FreezeEntityPosition(ped, true)
    DisplayRadar(false)

    SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false)
    SetEntityHeading(ped, coords.w or 0.0)

    ShutdownLoadingScreenNui()
    ShutdownLoadingScreen()

    Wait(150)
    FreezeEntityPosition(ped, false)
    DisplayRadar(true)
    fadeIn(500)
end

local function autoSpawn()
    -- Récupère (dernière position, éventuelle propriété courante) depuis le serveur
    local ok, lastPos = pcall(function()
        local pos = nil
        local p = lib.callback.await('qbx_spawn:server:getLastLocation', false)  -- retourne (pos, propertyId)
        if p ~= nil then
            -- lib.callback.await renvoie plusieurs valeurs; on n'en garde que la première via select()
            pos = select(1, p)
        end
        return pos
    end)

    local target = nil
    if ok then target = toV4(lastPos) end

    if target and not isZero(target) then
        -- Respawn à la dernière position
        safeSpawn(target)
    else
        -- Premier spawn fixe
        safeSpawn(FirstSpawn)
    end
end

-- Hook principal : au chargement du joueur, on spawn automatiquement
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    CreateThread(function()
        autoSpawn()
    end)
end)

-- Compat : si une autre ressource déclenche encore l'ancien flux de spawn,
-- on ignore l'UI et on applique notre autoSpawn.
RegisterNetEvent('qb-spawn:client:setupSpawns', function()
    autoSpawn()
end)

-- Compat : s'il existait un event pour ouvrir un menu de spawn, on le neutralise.
RegisterNetEvent('qbx_spawn:client:openMenu', function(...)
    autoSpawn()
end)
