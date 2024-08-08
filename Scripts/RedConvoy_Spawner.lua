--Store all the spawners here so we can disable them when needed
TARGS_GLOBAL_GROUNDSPAWNERS_ARRAY = {}


--To use:
-- Create a group, late activation and "name"
-- call Targs_GroundSpawnerSetup("name",respawntime as int)
--

--Pass in the group template name (string), Spawns the group, once dead they respawn, until disabled.
function Targs_GroundSpawnerSetup(targsGroupName, targsRespawnTimer)
    local spawner = SPAWN:New(targsGroupName):InitLimit( GROUP:FindByName( targsGroupName ):GetInitialSize() , 20 ):SpawnScheduled( targsRespawnTimer, 0 )
    TARGS_GLOBAL_GROUNDSPAWNERS_ARRAY[targsGroupName] = spawner
end

--Pass in the group template name (string), Stops the spawner from spawning more units
function Targs_GroundSpawnerStop(targsGroupName)
    local spawner = LINK_GLOBAL_GROUNDSPAWNERS_ARRAY[targsGroupName]
    spawner:SpawnScheduleStop()
end


--Targs_GroundSpawnerSetup("BlueTank1", 300)
--Targs_GroundSpawnerSetup("BlueTank2", 60)
--Targs_GroundSpawnerSetup("BlueTank3", 60)
--Targs_GroundSpawnerSetup("BlueTank4", 60)
--Targs_GroundSpawnerSetup("BlueTank5", 60)

Targs_GroundSpawnerSetup("REDSA2G1", 60)
Targs_GroundSpawnerSetup("REDSA2G2", 60)
--Targs_GroundSpawnerSetup("RedTank3", 60)
--Targs_GroundSpawnerSetup("RedTank4", 600)
--Targs_GroundSpawnerSetup("RedTank5", 60)