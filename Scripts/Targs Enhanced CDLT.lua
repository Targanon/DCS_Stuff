-- Enhanced CDLT Script for DCS using MOOSE with Vehicle Selection and Assembly

-- 1. Check for MOOSE Library
if not _G.MOOSE then
    error("MOOSE library not loaded. Please ensure MOOSE is included in the mission.")
end

-- 2. Setup and Initialization
local CTLD = {}

function CTLD.Init()
    -- Initialization code here
    env.info("CTLD initialized.")
    CTLD.CreateF10Menu()
    CTLD.SetupZones()
end

-- 3. Cargo Definitions

CTLD.CargoList = {
    -- Vehicles
    { Type = "Hummer", CratesNeeded = 1, Weight = 1000, Template = "Hummer" },
    { Type = "Scout", CratesNeeded = 1, Weight = 1000, Template = "Scout" },
    { Type = "Patriot System", CratesNeeded = 4, Weight = 5000, Template = "PatriotSystem" },
    { Type = "Refueling Truck", CratesNeeded = 2, Weight = 3000, Template = "RefuelingTruck" },
    { Type = "Ammo Truck", CratesNeeded = 2, Weight = 3000, Template = "AmmoTruck" },
    { Type = "Bradley", CratesNeeded = 3, Weight = 4000, Template = "Bradley" },
    
    -- Ammo
    { Type = "Ammo Air-to-Air", CratesNeeded = 1, Weight = 500, Template = "AmmoAirToAir" },
    { Type = "Ammo Air-to-Ground", CratesNeeded = 1, Weight = 500, Template = "AmmoAirToGround" },
    { Type = "Gun Ammo", CratesNeeded = 1, Weight = 300, Template = "GunAmmo" },
    
    -- Fuel
    { Type = "Diesel", CratesNeeded = 1, Weight = 2000, Template = "DieselFuel" },
    { Type = "Aviation Gas", CratesNeeded = 1, Weight = 2000, Template = "AviationGas" },
    { Type = "Gasoline", CratesNeeded = 1, Weight = 2000, Template = "Gasoline" },
    { Type = "Other Fuel", CratesNeeded = 1, Weight = 2000, Template = "OtherFuel" },

    -- Troops
    { Type = "Troops 10", CratesNeeded = 1, Weight = 1000, Template = "Troops10" },
    { Type = "Troops 20", CratesNeeded = 2, Weight = 2000, Template = "Troops20" },
    { Type = "Troops 30", CratesNeeded = 3, Weight = 3000, Template = "Troops30" },
    { Type = "Troops 40", CratesNeeded = 4, Weight = 4000, Template = "Troops40" }
}

-- 4. Pickup and Delivery Zones
CTLD.PickupZones = {}
CTLD.DeliveryZones = {}

function CTLD.SetupZones()
    for i = 1, 6 do
        table.insert(CTLD.PickupZones, { Name = "PickupZone" .. i, Zone = ZONE:New("PickupZone" .. i) })
        table.insert(CTLD.DeliveryZones, { Name = "DeliveryZone" .. i, Zone = ZONE:New("DeliveryZone" .. i) })
    end
end

-- 5. Transport Options

CTLD.Transporters = {
    Air = {
        "C135",
        "Hercules",
        "CH47F",
        "Mi8",
        "Huey"
    },
    Ground = {
        "UralTruck",
        "TransportTruck"
    }
}

-- 6. Task Creation and Handling

function CTLD.CreateTask(cargoType, pickupZone, deliveryZone)
    env.info(string.format("Task created: Transport %s from %s to %s", cargoType, pickupZone.Name, deliveryZone.Name))
    -- Additional task creation logic
end

-- 7. AI Handling

function CTLD.AITransport(cargoType, transporter)
    env.info(string.format("AI transporting %s using %s", cargoType, transporter))
    -- Logic for AI to handle transport
end

-- 8. Vehicle Assembly
function CTLD.AssembleVehicle(playerUnit, vehicleType)
    local playerPos = playerUnit:GetPoint()
    local cratesNearby = {} -- List of crates within 20m

    -- Find crates within 20m of each other and within 50m of the player
    for _, crate in ipairs(CTLD.CargoList) do
        if crate.Type == vehicleType then
            -- Placeholder for actual crate location check
            local cratePos = {} -- This should be replaced with actual position fetching logic
            local distance = CTLD.GetDistance(playerPos, cratePos)
            if distance <= 50 then
                table.insert(cratesNearby, crate)
            end
        end
    end

    -- Check if enough crates are nearby to assemble the vehicle
    if #cratesNearby >= CTLD.CargoList[vehicleType].CratesNeeded then
        -- Assemble vehicle
        env.info(string.format("Assembling %s at player's location", vehicleType))
        -- Placeholder for vehicle assembly logic
    else
        env.info(string.format("Not enough crates to assemble %s", vehicleType))
    end
end

-- Function to get distance between two points
function CTLD.GetDistance(point1, point2)
    local dx = point2.x - point1.x
    local dy = point2.y - point1.y
    local dz = point2.z - point1.z
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

-- 9. Set Initial Travel Direction
function CTLD.SetInitialDirection(vehicle, direction)
    -- Placeholder for setting the initial direction of the assembled vehicle
    env.info(string.format("Setting initial direction %s for vehicle %s", direction, vehicle:GetName()))
end

-- 10. F10 Menu System
function CTLD.CreateF10Menu()
    -- Root menu
    local menuRoot = MENU_COALITION:New(coalition.side.BLUE, "Logistics Requests")

    -- Submenus for each category
    local menuVehicles = MENU_COALITION:New(coalition.side.BLUE, "Request Vehicles", menuRoot)
    local menuAmmo = MENU_COALITION:New(coalition.side.BLUE, "Request Ammo", menuRoot)
    local menuFuel = MENU_COALITION:New(coalition.side.BLUE, "Request Fuel", menuRoot)
    local menuTroops = MENU_COALITION:New(coalition.side.BLUE, "Request Troops", menuRoot)

    -- Ammo Submenus
    local menuAmmoAirToAir = MENU_COALITION:New(coalition.side.BLUE, "Air-to-Air Ammo", menuAmmo)
    local menuAmmoAirToGround = MENU_COALITION:New(coalition.side.BLUE, "Air-to-Ground Ammo", menuAmmo)
    local menuAmmoGun = MENU_COALITION:New(coalition.side.BLUE, "Gun Ammo", menuAmmo)

    -- Fuel Submenus
    local menuFuelDiesel = MENU_COALITION:New(coalition.side.BLUE, "Diesel", menuFuel)
    local menuFuelAviationGas = MENU_COALITION:New(coalition.side.BLUE, "Aviation Gas", menuFuel)
    local menuFuelGasoline = MENU_COALITION:New(coalition.side.BLUE, "Gasoline", menuFuel)
    local menuFuelOther = MENU_COALITION:New(coalition.side.BLUE, "Other Fuel", menuFuel)

    -- Vehicle Assembly Menu
    local menuVehicleAssembly = MENU_COALITION:New(coalition.side.BLUE, "Assemble Vehicles", menuRoot)

    -- Add items to each submenu
    for _, cargo in ipairs(CTLD.CargoList) do
        if cargo.Type:match("Vehicle") then
            MENU_COALITION_COMMAND:New(coalition.side.BLUE, cargo.Type, menuVehicles, CTLD.RequestCargo, cargo.Type)
            MENU_COALITION_COMMAND:New(coalition.side.BLUE, string.format("Assemble %s", cargo.Type), menuVehicleAssembly, CTLD.AssembleVehicle, cargo.Type)
        elseif cargo.Type == "Ammo Air-to-Air" then
            MENU_COALITION_COMMAND:New(coalition.side.BLUE, cargo.Type, menuAmmoAirToAir, CTLD.RequestCargo, cargo.Type)
        elseif cargo.Type == "Ammo Air-to-Ground" then
            MENU_COALITION_COMMAND:New(coalition.side.BLUE, cargo.Type, menuAmmoAirToGround, CTLD.RequestCargo, cargo.Type)
        elseif cargo.Type == "Gun Ammo" then
            MENU_COALITION_COMMAND:New(coalition.side.BLUE, cargo.Type, menuAmmoGun, CTLD.RequestCargo, cargo.Type)
        elseif cargo.Type == "Diesel" then
            MENU_COALITION_COMMAND:New(coalition.side.BLUE, cargo.Type, menuFuelDiesel, CTLD.RequestCargo, cargo.Type)
        elseif cargo.Type == "Aviation Gas" then
            MENU_COALITION_COMMAND:New(coalition.side.BLUE, cargo.Type, menuFuelAviationGas, CTLD.RequestCargo, cargo.Type)
        elseif cargo.Type == "Gasoline" then
            MENU_COALITION_COMMAND:New(coalition.side.BLUE, cargo.Type, menuFuelGasoline, CTLD.RequestCargo, cargo.Type)
        elseif cargo.Type == "Other Fuel" then
            MENU_COALITION_COMMAND:New(coalition.side.BLUE, cargo.Type, menuFuelOther, CTLD.RequestCargo, cargo.Type)
        elseif cargo.Type:match("Troops") then
            MENU_COALITION_COMMAND:New(coalition.side.BLUE, cargo.Type, menuTroops, CTLD.RequestCargo, cargo.Type)
        end
    end
end

-- 11. Player Request Handling
function CTLD.RequestCargo(cargoType)
    env.info(string.format("Player requested %s", cargoType))
    -- Logic to handle the player's request, e.g., spawning the cargo at a pickup zone
end

-- 12. Initialization Call
CTLD.Init()

-- Example of creating a task
CTLD.CreateTask("Ammo Air-to-Air", CTLD.PickupZones[1], CTLD.DeliveryZones[1])

-- AI handling example
CTLD.AITransport("Ammo Air-to-Air", CTLD.Transporters.Air[2])

