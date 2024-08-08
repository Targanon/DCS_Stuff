-- Targs_SiteSetupConvoySpawner_WIP_180724.lua

-- Script Information and Recognitions
-- This script was developed to handle convoy spawning, routing, and destination management in DCS.
-- Auther : Targs35 aka Aussie_Targs of Aussie_Flight_Brisabne Servers..

-- DO NOT DISTRIBUTE--
-- DO NOT DISTRIBUTE--
-- DO NOT DISTRIBUTE--
-- DO NOT DISTRIBUTE--
-- DO NOT DISTRIBUTE--


-- Contributors:  Link_Jedi_Knight and various community posts and MOOSE developers.

-- Toggle for detailed logging
local enableDetailedLogging = false

local function logInfo(message)
    if enableDetailedLogging then
        env.info(message)
    end
end

local function logWarning(message)
    if enableDetailedLogging then
        env.warning(message)
    end
end

env.info("3 Targs_ConvoySpawnerSetupSite_V1a start loading")

-- set default speed for spawned units
local convoySpeed = 60  -- speed in KPH

-- Define convoy templates with their respawn times
local convoyTemplates = {
    {name = "REDSA2G5", respawnTime = 1600, variation = 0.1},
    {name = "REDSA2G4", respawnTime = 1600, variation = 0.1},
    {name = "REDSA2G3", respawnTime = 600, variation = 0.1},
    {name = "REDSA2G2", respawnTime = 1200, variation = 0.1},
    {name = "REDSA2G1", respawnTime = 1800, variation = 0.1}
}

-- Define the Destination Zones
local Targ_Global_Destination_Array = {
    "Destination_1",
    "Destination_2",
    "Destination_3",
    "Destination_4",
    "Destination_5"
}

-- Define the Deployment Zones
local Targ_Global_Deployment_Array = {
    "Deployment_1",
    "Deployment_2",
    "Deployment_3",
    "Deployment_4",
    "Deployment_5"
}

-- Define the Deployed Infantry Groups
local Targ_Global_DeployedInfantry_Array = {
    "Infantry-1",
    "Infantry-2",
    "Infantry-3",
    "Infantry-4",
    "Infantry-5"
}

-- Define the Deployed Armor Groups
local Targ_Global_DeployedArmour_Array = {
    "Armour1",
    "Armour2",
    "Armour3",
    "Armour4",
    "Armour5"
}

-- Store all the spawners here so we can disable them when needed
Targs_GLOBAL_CONVOYSPAWNERS_ARRAY = {}
Targs_GLOBAL_SPAWNED_CONVOY_GROUPS = {}
Targs_GLOBAL_DEPLOYED_GROUPS = {}
local assignedDestinations = {}

-- Function to set up and spawn a convoy with random respawn time and initial start delay using DCS's timer
function Targs_ConvoySpawnerSetup(convoyTemplate)
    local randomRespawnVariation = convoyTemplate.variation * convoyTemplate.respawnTime
    local randomRespawnTime = math.random(convoyTemplate.respawnTime - randomRespawnVariation, convoyTemplate.respawnTime + randomRespawnVariation)

    -- This function encapsulates the spawning logic
    local function spawnConvoy()
        local spawner = SPAWN:New(convoyTemplate.name)
            :InitLimit(20, 20)
            :OnSpawnGroup(function(spawnedGroup)
                local groupName = spawnedGroup:GetName()
                if not Targs_GLOBAL_SPAWNED_CONVOY_GROUPS[groupName] or not Targs_GLOBAL_SPAWNED_CONVOY_GROUPS[groupName].group:IsAlive() then
                    -- Assign a random unused destination
                    local destinationZone = nil
                    for _, zoneName in ipairs(Targ_Global_Destination_Array) do
                        if not assignedDestinations[zoneName] then
                            destinationZone = zoneName
                            assignedDestinations[zoneName] = true
                            break
                        end
                    end

                    if destinationZone then
                        local zone = ZONE:FindByName(destinationZone)
                        if not zone then
                            logWarning("Destination zone not found: " .. destinationZone)
                            return
                        end

                        -- Convert the destination zone center to a point
                        local destinationPoint = zone:GetCoordinate()
                        local startCoord = spawnedGroup:GetUnit(1):GetCoordinate()

                        -- Route the convoy on the road
                        spawnedGroup:OptionDisperseOnAttack(0)
                        spawnedGroup:RouteGroundOnRoad(destinationPoint, convoySpeed, 1, "OnRoad")

                        -- Initial mark and message when the group spawns
                        MarkGroupWithOrangeSmoke(spawnedGroup)
                        SendMessageToBlueCoalition("An Armoured Convoy " .. groupName .. " has been spotted near a Lookout station. Its Location has been marked with Smoke, Also a Marker can be found on the F10 map.")
                        logInfo("An Armoured Convoy " .. groupName .. " has been spotted near a Lookout station. Its Location has been marked with Smoke, Also a Marker can be found on the F10 map.")
                        
                        -- Add the spawned group to the list of convoy groups
                        Targs_GLOBAL_SPAWNED_CONVOY_GROUPS[groupName] = {
                            group = spawnedGroup,
                            spawnPos = spawnedGroup:GetCoordinate(),
                            spotted = true,
                            spawnTime = timer.getTime(),
                            destinationZoneName = destinationZone  -- Store the destination zone name for monitoring
                        }

                        -- Start periodic updates for the spawned group
                        StartPeriodicUpdates(groupName, 600)  -- Update every 600 seconds (10 minutes)
                        -- Start monitoring the unit strength
                        MonitorUnitStrength(groupName, 60)
                        -- Monitor convoy arrival at the destination
                        MonitorConvoyArrival(groupName, destinationZone, 60)
                    else
                        logWarning("No available destination zones for convoy.")
                    end
                else
                    logInfo("Convoy " .. groupName .. " is still alive. Skipping respawn.")
                end
            end)

        Targs_GLOBAL_CONVOYSPAWNERS_ARRAY[convoyTemplate.name] = spawner
        spawner:Spawn()
    end

    -- Generate a random start delay up to 40 minutes (2400 seconds)
    local randomStartDelay = math.random(0, 2400)
    timer.scheduleFunction(spawnConvoy, nil, timer.getTime() + randomStartDelay)
end

-- Table to store marker IDs for each group
local groupMarkers = {}

-- Mark a group with an orange smoke marker on the lead vehicle and place a marker on the F10 map
function MarkGroupWithOrangeSmoke(group)
    if group then
        local groupName = group:GetName()
        local leadUnit = group:GetUnit(1)
        if leadUnit then
            local unitPos = leadUnit:GetCoordinate()
            if unitPos then
                unitPos:SmokeOrange()

                -- Clear the existing marker if it exists
                if groupMarkers[groupName] then
                    trigger.action.removeMark(groupMarkers[groupName])
                    groupMarkers[groupName] = nil  -- Clear the marker ID from the table
                end

                -- Add a new marker on the F10 map
                local markerId = unitPos:MarkToCoalition(
                    "Convoy Location: " .. groupName,
                    coalition.side.BLUE,
                    true  -- Changed to true to make it read-only
                )
                groupMarkers[groupName] = markerId  -- Store the new marker ID

                -- Send message about the orange smoke
                SendMessageToBlueCoalition("An Armoured Convoy " .. groupName .. " has been marked with Orange Smoke and a Marker on the F10 map.")
            else
                logWarning("Lead unit position not found for group: " .. groupName)
            end
        else
            logWarning("Lead unit not found for group: " .. groupName)
        end
    else
        logWarning("Group not found for marking.")
    end
end

-- Monitor convoy's unit strength and send a message to the Blue coalition when strength drops below 50%
function MonitorUnitStrength(groupName, checkInterval)
    local function checkStrength()
        local groupData = Targs_GLOBAL_SPAWNED_CONVOY_GROUPS[groupName]

        if groupData == nil then
            logInfo("MonitorUnitStrength: groupData is nil for group " .. groupName)
            return
        end

        if groupData.group == nil then
            logInfo("MonitorUnitStrength: groupData.group is nil for group " .. groupName)
            return
        end

        if not groupData.group:IsAlive() then
            logInfo("MonitorUnitStrength: group is not alive for group " .. groupName)
            return
        end

        local initialSize = groupData.group:GetInitialSize()
        if initialSize == nil then
            logInfo("MonitorUnitStrength: InitialSize is nil for group " .. groupName)
            return
        end

        local currentSize = groupData.group:GetSize()
        if currentSize == nil then
            logInfo("MonitorUnitStrength: GetSize is nil for group " .. groupName)
            return
        end

        if currentSize <= initialSize * 0.5 then
            SendMessageToBlueCoalition("An Armoured Convoy " .. groupName .. " is at less than 50% strength.")
            logInfo("An Armoured Convoy " .. groupName .. " is at less than 50% strength.")
            return  -- Stop checking after sending the message
        end

        -- Continue checking at the specified interval
        timer.scheduleFunction(checkStrength, nil, timer.getTime() + checkInterval)
    end

    checkStrength()
end

-- Monitor convoy's arrival at the destination
function MonitorConvoyArrival(groupName, destinationZoneName, checkInterval)
    local function checkArrival()
        local groupData = Targs_GLOBAL_SPAWNED_CONVOY_GROUPS[groupName]

        if groupData == nil or not groupData.group or not groupData.group:IsAlive() then
            logInfo("MonitorConvoyArrival: Group " .. groupName .. " is not valid or not alive.")
            return
        end

        local destinationZone = ZONE:FindByName(destinationZoneName)
        if not destinationZone then
            logInfo("MonitorConvoyArrival: Destination zone " .. destinationZoneName .. " not found.")
            return
        else
            logInfo("MonitorConvoyArrival: Found destination zone " .. destinationZoneName .. ".")
        end

        local groupUnits = groupData.group:GetUnits()
        if not groupUnits then
            logInfo("MonitorConvoyArrival: No units found in group " .. groupName .. ".")
            return
        end

        local destinationPoint = destinationZone:GetCoordinate()
        local destinationRadius = destinationZone:GetRadius()

        for _, unit in ipairs(groupUnits) do
            local unitPoint = unit:GetCoordinate()
            logInfo("MonitorConvoyArrival: Checking unit at point (" .. unitPoint.x .. ", " .. unitPoint.z .. ") for group " .. groupName .. ".")

            local dx = unitPoint.x - destinationPoint.x
            local dz = unitPoint.z - destinationPoint.z
            local distance = math.sqrt(dx * dx + dz * dz)

            if distance <= destinationRadius then
                logInfo("Convoy group " .. groupName .. " has arrived at destination " .. destinationZoneName .. ".")
                DeployNewGroupInDestination(destinationZoneName, groupName)
                Targs_GLOBAL_SPAWNED_CONVOY_GROUPS[groupName].group:Destroy()  -- Despawn the convoy group
                Targs_GLOBAL_SPAWNED_CONVOY_GROUPS[groupName] = nil
                assignedDestinations[destinationZoneName] = nil
                return
            end
        end

        timer.scheduleFunction(checkArrival, nil, timer.getTime() + checkInterval)
    end

    checkArrival()
end

-- Deploy a new group in the specified destination zone
function DeployNewGroupInDestination(destinationZoneName, groupName)
    local destinationZone = ZONE:FindByName(destinationZoneName)
    if not destinationZone then
        logWarning("Destination zone not found for " .. destinationZoneName .. ".")
        return
    end

    -- Select the corresponding deployment zone
    local deploymentZoneName = nil
    for i, destinationName in ipairs(Targ_Global_Destination_Array) do
        if destinationName == destinationZoneName then
            deploymentZoneName = Targ_Global_Deployment_Array[i]
            break
        end
    end

    if not deploymentZoneName then
        logWarning("No corresponding deployment zone found for destination " .. destinationZoneName .. ".")
        return
    end

    local deploymentZone = ZONE:FindByName(deploymentZoneName)
    if not deploymentZone then
        logWarning("Deployment zone not found for " .. deploymentZoneName .. ".")
        return
    end

    -- Function to spawn a group from an array
    local function spawnGroupFromArray(groupArray, fallbackGroupName)
        for _, groupName in ipairs(groupArray) do
            local group = SPAWN:New(groupName)
            if group then
                return group:SpawnInZone(deploymentZone)
            else
                logWarning("Group not found: " .. groupName)
            end
        end
        logWarning("All groups in array not found, spawning fallback group: " .. fallbackGroupName)
        return SPAWN:New(fallbackGroupName):SpawnInZone(deploymentZone)
    end

    -- Spawn infantry and armor groups
    local infantryGroup = spawnGroupFromArray(Targ_Global_DeployedInfantry_Array, "Default01")
    local armorGroup = spawnGroupFromArray(Targ_Global_DeployedArmour_Array, "Default01")

    if infantryGroup and armorGroup then
        local infantryGroupID = infantryGroup:GetName()
        local armorGroupID = armorGroup:GetName()

        -- Mark the deployed groups with red smoke
        local leadUnit = armorGroup:GetUnit(1)
        if leadUnit then
            local unitPos = leadUnit:GetCoordinate()
            if unitPos then
                unitPos:SmokeRed()
                SendMessageToBlueCoalition("A new enemy base has been set up and marked with Red Smoke.")
            end
        end

        logInfo("A convoy has made it past all of your efforts to stop it. Now an enemy base will be set up. Deploying " .. infantryGroup:GetName() .. " and " .. armorGroup:GetName() .. ".")
        Targs_GLOBAL_DEPLOYED_GROUPS[infantryGroupID] = {group = infantryGroup, deploymentZone = deploymentZoneName, lastUpdateTime = timer.getTime()}
        Targs_GLOBAL_DEPLOYED_GROUPS[armorGroupID] = {group = armorGroup, deploymentZone = deploymentZoneName, lastUpdateTime = timer.getTime()}
        
        -- Start periodic updates for the deployed groups
        StartDeployedGroupUpdates(infantryGroupID, armorGroupID, 1800)  -- Update every 1800 seconds (30 minutes)
    else
        logWarning("Failed to spawn one or both groups.")
    end
end

-- Start periodic updates for deployed groups
function StartDeployedGroupUpdates(infantryGroupID, armorGroupID, updateInterval)
    local function deployedGroupUpdate()
        local infantryGroupData = Targs_GLOBAL_DEPLOYED_GROUPS[infantryGroupID]
        local armorGroupData = Targs_GLOBAL_DEPLOYED_GROUPS[armorGroupID]

        if infantryGroupData and infantryGroupData.group and infantryGroupData.group:IsAlive() then
            MarkGroupWithRedSmoke(infantryGroupData.group)
        end

        if armorGroupData and armorGroupData.group and armorGroupData.group:IsAlive() then
            MarkGroupWithRedSmoke(armorGroupData.group)
        end

        -- Continue periodic updates
        timer.scheduleFunction(deployedGroupUpdate, nil, timer.getTime() + updateInterval)
    end

    deployedGroupUpdate()
end

-- Mark a group with red smoke marker
function MarkGroupWithRedSmoke(group)
    if group then
        local leadUnit = group:GetUnit(1)
        if leadUnit then
            local unitPos = leadUnit:GetCoordinate()
            if unitPos then
                unitPos:SmokeRed()
                SendMessageToBlueCoalition("A new enemy base has been marked with Red Smoke.")
            else
                logWarning("Lead unit position not found for marking.")
            end
        else
            logWarning("Lead unit not found for marking.")
        end
    else
        logWarning("Group not found for marking.")
    end
end

-- Start periodic updates for a given group
function StartPeriodicUpdates(groupName, updateInterval)
    local function periodicUpdate()
        local groupData = Targs_GLOBAL_SPAWNED_CONVOY_GROUPS[groupName]

        if groupData == nil then
            logInfo("StartPeriodicUpdates: groupData is nil for group " .. groupName)
            return
        end

        if groupData.group == nil then
            logInfo("StartPeriodicUpdates: groupData.group is nil for group " .. groupName)
            return
        end

        if not groupData.group:IsAlive() then
            logInfo("StartPeriodicUpdates: group is not alive for group " .. groupName)
            return
        end

        -- Mark the group with smoke and update F10 marker
        MarkGroupWithOrangeSmoke(groupData.group)

        -- Continue periodic updates
        timer.scheduleFunction(periodicUpdate, nil, timer.getTime() + updateInterval)
    end

    periodicUpdate()
end

-- Send a message to the Blue coalition
function SendMessageToBlueCoalition(message)
    trigger.action.outTextForCoalition(coalition.side.BLUE, message, 10)
end

-- Set up convoys for all templates
for _, convoyTemplate in ipairs(convoyTemplates) do
    Targs_ConvoySpawnerSetup(convoyTemplate)
end

env.info("3 Targs_ConvoySpawnerSetupSite complete")
