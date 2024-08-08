--Store all the spawners here so we can disable them when needed
LINK_GLOBAL_REDAIRSPAWNERS_ARRAY = {}


--To use:
-- Create a group, late activation and "name"
-- call Link_RedAirSpawnerSetup("name",respawntime as int)
--

--Pass in the group template name (string), Spawns the group, once dead they respawn, until disabled.
function Link_RedAirSpawnerSetup(linkGroupName, linkRespawnTimer)
    local spawner = SPAWN:New(linkGroupName):InitLimit( GROUP:FindByName( linkGroupName ):GetInitialSize() , 20 ):SpawnScheduled( linkRespawnTimer, 0 )
    LINK_GLOBAL_REDAIRSPAWNERS_ARRAY[linkGroupName] = spawner
end

--Pass in the group template name (string), Stops the spawner from spawning more units
function Link_RedAirSpawnerStop(linkGroupName)
    local spawner = LINK_GLOBAL_REDAIRSPAWNERS_ARRAY[linkGroupName]
    spawner:SpawnScheduleStop()
end


--Link_RedAirSpawnerSetup("RedAirSu27_G1", 300)
Link_RedAirSpawnerSetup("RedAirSu27_G2", 220)
--Link_RedAirSpawnerSetup("RedAirSu27_G3", 60)
Link_RedAirSpawnerSetup("RedAirSu27_G4", 160)
--Link_RedAirSpawnerSetup("RedAirSu27_G5", 60)

--Link_RedAirSpawnerSetup("RedAirF16_G1", 60)
--Link_RedAirSpawnerSetup("RedAirF16_G2", 60)
Link_RedAirSpawnerSetup("RedAirF16_G3", 360)
--Link_RedAirSpawnerSetup("RedAirF16_G4", 600)
Link_RedAirSpawnerSetup("RedAirF16_G5", 460)