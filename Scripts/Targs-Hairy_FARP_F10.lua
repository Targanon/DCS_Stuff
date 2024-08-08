--- 

-- Test adding a static to an airbase...
local wh =  WAREHOUSE:New(STATIC:FindByName("FARP1"), "FARP1")
wh:AddAsset('t_UH-1H', 5)
wh:AddAsset('UH-1H', 7)



-- Define the function to create a static FARP at a given position




function createFARP(position)
    local farp = {
        ["category"] = "Heliports",
        ["shape_name"] = "FARPS", -- Full FARP shape name
        ["type"] = "FARP",
        ["unitId"] = mist.getNextUnitId(), -- Ensure this function is available in your environment
        ["x"] = position.x,
        ["y"] = position.z, -- Note: 'y' in DCS is actually the z-axis for world coordinates
        ["name"] = "DYNFARP",
        ["heading"] = 0,
        ["dead"] = false,
        ["dynamicSpawn"] = true,
    }

    coalition.addStaticObject(country.id.USA, farp)


    local wh = {
        ["category"] = "Warehouses",
        ["shape_name"] = "sklad",
        ["type"] = "Warehouse",
        ["unitId"] = 268,
        ["rate"] = 100,
        ["x"] = position.x,
        ["y"] = position.z, -- Note: 'y' in DCS is actually the z-axis for world coordinates
        ["name"] = "DYNWAREHOUSE",
        ["heading"] = 0,
    }, 
    coalition.addStaticObject(country.id.USA, wh)

    wh1 = WAREHOUSE:New(STATIC:FindByName("WAREHOUSE1"), "WAREHOUSE1")
    wh1:AddAsset('t_UH-1H', 5)




    mist.scheduleFunction(function()
        local staticObject = STATIC:FindByName("DYNFARP")
        if staticObject then
            local warehouse = WAREHOUSE:New(staticObject, "DYNFARP")
            warehouse:AddAsset('t_UH-1H', 5)
        else
            env.info("Static object 'DYNFARP' not found.")
        end
    end, {}, timer.getTime() + 1) -- Adjust the delay as needed (1 second in this example)
end

-- Define the function to get player coordinates, display them with an offset, and create a FARP
function getPlayerCoordinates(unit)
    if unit then
        local unitPosition = unit:getPosition().p
        local unitOrientation = unit:getPosition().x

        -- Normalize the forward vector
        local forwardVector = {
            x = unitOrientation.x,
            y = unitOrientation.y,
            z = unitOrientation.z
        }
        local length = math.sqrt(forwardVector.x^2 + forwardVector.y^2 + forwardVector.z^2)
        forwardVector.x = forwardVector.x / length
        forwardVector.y = forwardVector.y / length
        forwardVector.z = forwardVector.z / length

        -- Apply the 100m offset
        local offsetPosition = {
            x = unitPosition.x + forwardVector.x * 100,
            y = unitPosition.y + forwardVector.y * 100,
            z = unitPosition.z + forwardVector.z * 100
        }

        -- Display the offset coordinates
        local lat, lon, alt = coord.LOtoLL(offsetPosition)
        trigger.action.outTextForUnit(unit:getID(), string.format("Your offset coordinates:\nLatitude: %.6f\nLongitude: %.6f\nAltitude: %.1f meters", lat, lon, alt), 10)

        -- Create the FARP at the offset position
        createFARP(offsetPosition)
    else
        trigger.action.outText("Unit not found.", 10)
    end
end

-- Add the F10 menu for a group
function addF10MenuForGroup(group)
    if group then
        for i = 1, #group:getUnits() do
            local unit = group:getUnit(i)
            if unit then
                missionCommands.addCommandForGroup(group:getID(), "Get Offset Coordinates and Create FARP", nil, getPlayerCoordinates, unit)
            end
        end
    end
end

-- Iterate over all groups and add the F10 menu
function addF10MenuForAllPlayers()
    local coalitionGroups
    -- Process helicopter groups for both sides
    coalitionGroups = coalition.getGroups(coalition.side.BLUE, Group.Category.HELICOPTER)
    for i = 1, #coalitionGroups do
        addF10MenuForGroup(coalitionGroups[i])
    end
    
end

-- Schedule the menu addition
do

    wh1 = WAREHOUSE:New(STATIC:FindByName("WAREHOUSE1"), "WAREHOUSE1")
    wh1:AddAsset('t_UH-1H', 5)

    addF10MenuForAllPlayers()
end
