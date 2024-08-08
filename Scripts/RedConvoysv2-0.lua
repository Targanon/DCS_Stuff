-- Store all the spawners here so we can disable them when needed
Targs_GLOBAL_CONVOYSPAWNERS_ARRAY = {}
Targs_GLOBAL_SPAWNED_CONVOY_GROUPS = {}

-- To use:
-- Create a group, late activation and "name"
-- call Targs_ConvoySpawnerSetup("name", respawntime as int)


-- Pass in the group template name (string), Spawns the group, once dead they respawn, until disabled.
function Targs_ConvoySpawnerSetup(targsGroupName, targsRespawnTimer)
    local group    = GROUP:FindByName(targsGroupName)
    local size = group:CountAliveUnits()
    local spawner = SPAWN:New(targsGroupName)
        :InitLimit(size , 0)                       
        :SpawnScheduled(targsRespawnTimer, 600) 
        :OnSpawnGroup(function(spawnedGroup)
            -- Initial mark and message when the group spawns
            MarkGroupWithOrangeSmoke(spawnedGroup)
            SendMessageToBlueCoalition("The convoy " .. spawnedGroup:GetName() .. " has spawned and is marked with orange smoke.")
            -- Add the spawned group to the list of convoy groups
            Targs_GLOBAL_SPAWNED_CONVOY_GROUPS[spawnedGroup:GetName()] = {group = spawnedGroup, spotted = true}
            -- Start periodic updates for the spawned group
            StartPeriodicUpdates(spawnedGroup:GetName(), 600)  -- Update every 600 seconds (10 minutes)
            local leadUnit = spawnedGroup:GetUnit(1)
            if leadUnit then
                local unitPos = leadUnit:GetCoordinate()
                if unitPos then
                    StartMonitorUnitStrength(spawnedGroup:GetName(), 5, unitPos)
                end
            end
        end)
    Targs_GLOBAL_CONVOYSPAWNERS_ARRAY[targsGroupName] = spawner
    
end

-- Pass in the group template name (string), Stops the spawner from spawning more units
function Targs_ConvoySpawnerStop(targsGroupName)
    local spawner = Targs_GLOBAL_CONVOYSPAWNERS_ARRAY[targsGroupName]
    spawner:SpawnScheduleStop()
end


-- Mark a group with an orange smoke marker on the lead vehicle
function MarkGroupWithOrangeSmoke(group)
    if group then
        local leadUnit = group:GetUnit(1)
        if leadUnit then
            local unitPos = leadUnit:GetCoordinate()
            if unitPos then
                unitPos:SmokeOrange()
            else
                env.warning("Lead unit position is nil")
            end
        else
            env.warning("Lead unit is nil")
        end
    else
        env.warning("Group is nil")
    end
end

-- Send a message to the blue coalition
function SendMessageToBlueCoalition(message)
    trigger.action.outTextForCoalition(coalition.side.BLUE, message, 10)
end

-- Send periodic updates on convoy locations
function StartPeriodicUpdates(groupName, updateInterval)
    local function UpdateConvoyLocation()
        local convoyInfo = Targs_GLOBAL_SPAWNED_CONVOY_GROUPS[groupName]
        if convoyInfo and convoyInfo.group then
            local group = convoyInfo.group
            if group:IsAlive() then
                MarkGroupWithOrangeSmoke(group)
                SendMessageToBlueCoalition("Update: The convoy " .. group:GetName() .. " is currently at the marked location with orange smoke.")
                env.info("Update: The convoy " .. group:GetName() .. " is currently at the marked location with orange smoke.")
                -- Schedule the next update
                timer.scheduleFunction(UpdateConvoyLocation, {}, timer.getTime() + updateInterval)
            else
                -- The convoy has reached its final destination or is destroyed
                Targs_GLOBAL_SPAWNED_CONVOY_GROUPS[groupName] = nil
                SendMessageToBlueCoalition("The convoy " .. group:GetName() .. " has reached its final destination or is no longer active.")
                env.info("The convoy " .. group:GetName() .. " has reached its final destination or is no longer active.")
            end
        end
    end
    -- Start the first update
    timer.scheduleFunction(UpdateConvoyLocation, {}, timer.getTime() + updateInterval)
end

-- Function to monitor the unit strength of the convoy and order a retreat if necessary
function StartMonitorUnitStrength(groupName, updateInterval, retreatPos)
    local function MonitorUnitStrength()
        local convoyInfo = Targs_GLOBAL_SPAWNED_CONVOY_GROUPS[groupName]
        if convoyInfo and convoyInfo.group then
            local group = convoyInfo.group
            if group:CountAliveUnits() >= 7 then
                 -- Schedule the next update
                timer.scheduleFunction(MonitorUnitStrength, {}, timer.getTime() + updateInterval)
            else
                -- The convoy has not reached its final destination all or most of it is destroyed
                local retreatPos = COORDINATE:NewFromVec3(group:GetCoordinate():GetVec3()) -- Define the retreat position as needed
                group:OptionDisperseOnAttack(0)
                group:RouteGroundTo(retreatPos)  -- Move to the retreat position
                SendMessageToBlueCoalition("The convoy " .. group:GetName() .. " is retreating.")
                env.info("The convoy " .. group:GetName() .. " is retreating.")
            end
        end
    end
    timer.scheduleFunction(MonitorUnitStrength, {}, timer.getTime() + updateInterval)
end    




-- Example usage with convoys
local convoys = {
    {name = "REDSA2G3", respawnTime = 600},
    {name = "REDSA2G2", respawnTime = 1200},
    {name = "REDSA2G1", respawnTime = 60}
}

for _, convoy in ipairs(convoys) do
    Targs_ConvoySpawnerSetup(convoy.name, convoy.respawnTime)
end

-- Show in-game pop-up indicating script is running
timer.scheduleFunction(function()
    env.info("Heartbeat: " .. timer.getTime())
    return timer.getTime() + 60  -- Log heartbeat message every 60 seconds
end, {}, timer.getTime() + 60)
