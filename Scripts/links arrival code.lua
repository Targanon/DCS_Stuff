local function checkArrival()
        local groupData = Targs_GLOBAL_SPAWNED_CONVOY_GROUPS[groupName]

        if not groupData or not groupData.group or not groupData.group:IsAlive() then
            env.info("MonitorConvoyArrival: Group " .. groupName .. " is not valid or not alive.")
            return
        end

        local destinationZone = ZONE:FindByName(destinationZoneName)
        if not destinationZone then
            env.info("MonitorConvoyArrival: Destination zone " .. destinationZoneName .. " not found.")
            return
        else
            env.info("MonitorConvoyArrival: Found destination zone " .. destinationZoneName)
        end

        local groupUnits = groupData.group:GetUnits()
        if not groupUnits then
            env.info("MonitorConvoyArrival: No units found in group " .. groupName)
            return
        end

        for i, unit in ipairs(groupUnits) do
            local unitPoint = unit:GetPointVec2()
            env.info("MonitorConvoyArrival: Checking unit " .. unit:GetName() .. " at point " .. unitPoint:ToString())
            if destinationZone:IsPointInZone(unitPoint) then
                env.info("Convoy group " .. groupName .. " has arrived at destination " .. destinationZoneName)
                DeployNewGroupInDestination(destinationZoneName, groupName)
                Targs_GLOBAL_SPAWNED_CONVOY_GROUPS[groupName] = nil
                assignedDestinations[destinationZoneName] = nil
                return
            end
        end

        timer.scheduleFunction(checkArrival, nil, timer.getTime() + checkInterval)
    end