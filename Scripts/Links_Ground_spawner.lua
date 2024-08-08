--Store all the spawners here so we can disable them when needed
LINK_GLOBAL_GROUNDSPAWNERS_ARRAY = {}


--To use:
-- Create a group, late activation and "name"
-- call Link_GroundSpawnerSetup("name",respawntime as int)
--

--Pass in the group template name (string), Spawns the group, once dead they respawn, until disabled.
function Link_GroundSpawnerSetup(linkGroupName, linkRespawnTimer)
    local spawner = SPAWN:New(linkGroupName):InitLimit( GROUP:FindByName( linkGroupName ):GetInitialSize() , 20 ):SpawnScheduled( linkRespawnTimer, 0 )
    LINK_GLOBAL_GROUNDSPAWNERS_ARRAY[linkGroupName] = spawner
end

--Pass in the group template name (string), Stops the spawner from spawning more units
function Link_GroundSpawnerStop(linkGroupName)
    local spawner = LINK_GLOBAL_GROUNDSPAWNERS_ARRAY[linkGroupName]
    spawner:SpawnScheduleStop()
end


--Link_GroundSpawnerSetup("BlueTank1", 300)
--Link_GroundSpawnerSetup("BlueTank2", 60)
--Link_GroundSpawnerSetup("BlueTank3", 60)
--Link_GroundSpawnerSetup("BlueTank4", 60)
--Link_GroundSpawnerSetup("BlueTank5", 60)

Link_GroundSpawnerSetup("REDSA2G1", 60)
Link_GroundSpawnerSetup("REDSA2G2", 60)
--Link_GroundSpawnerSetup("RedTank3", 60)
--Link_GroundSpawnerSetup("RedTank4", 600)
--Link_GroundSpawnerSetup("RedTank5", 60)