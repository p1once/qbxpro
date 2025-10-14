Config = {}

Config.Settings = {
    Debug = true,
    ServerName = "Ft Script's Rp",
    Notify = 'qb-core', -- ft_notification, qb-core or ox_lib
    inventory = 'ox_inventory',  -- qb-inventory, ox_inventory
    Images = 'nui://qb-inventory/html/images/',
}

Config.Commands = {
    EnableReport = true,
    report = 'report',
    adminmenu = 'adminmenu',
}

Config.Admins = {
    -- Add license or discord id like below example
    -- license '0000000000000000000000000000000000000000',
    -- discord '0000000000000000', 

    -- Add here 

    'b912cfa0fb53c0ff99758e7047f4d0ac440c6d2c',
}

Config.MenuJobs = {
    { Job = "police",    JobLabel = "Police" },
    { Job = "medic",     JobLabel = "Medic" },
    { Job = "mechanic",  JobLabel = "Mechanic" },
    { Job = "ambulance", JobLabel = "ambulance" },
    { Job = "cardealer", JobLabel = "cardealer" },
    { Job = "taco",      JobLabel = "taco" }
}

Config.DutyTag = true

Config.DutyCloth = {
    male = {
        torso  = { slot = 148, drawable = 11, texture = 7 },
        tshirt = { slot = 15,  drawable = 8,  texture = 0 },
        arms   = { slot = 4,   drawable = 3,  texture = 0 },
        pants  = { slot = 67,  drawable = 4,  texture = 7 },
        shoes  = { slot = 46,  drawable = 6,  texture = 0 },
        vest   = { slot = 0,   drawable = 9,  texture = 0 },
        chain  = { slot = 51,  drawable = 7,  texture = 0 },
        bag    = { slot = 82,  drawable = 5,  texture = 17 },
    },
    female = {
        torso  = { slot = 148, drawable = 11, texture = 7 },
        tshirt = { slot = 15,  drawable = 8,  texture = 0 },
        arms   = { slot = 4,   drawable = 3,  texture = 0 },
        pants  = { slot = 67,  drawable = 4,  texture = 7 },
        shoes  = { slot = 46,  drawable = 6,  texture = 0 },
        vest   = { slot = 0,   drawable = 9,  texture = 0 },
        chain  = { slot = 51,  drawable = 7,  texture = 0 },
        bag    = { slot = 82,  drawable = 5,  texture = 17 },
    }
}
