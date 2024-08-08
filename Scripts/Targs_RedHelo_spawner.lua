-- thisis an adaption of Links Ground Spawner.
-- I needed a way to spawnm aircraft repeatedly and I used this
-- with some mods to the Names of variables.. etc. and I added the
-- reapeat tag as well.
--Store all the spawners here so we can disable them when needed
Targs_GLOBAL_RedHeloSPAWNERS_ARRAY = {}


--To use:
-- Create a group, late activation and "name"
-- call Targs_RedHeloSpawnerSetup("name",respawntime as int)
--

--Pass in the group template name (string), Spawns the group, once dead they respawn, until disabled.
function Targs_RedHeloSpawnerSetup(TargsGroupName, TargsRespawnTimer)
    local spawner = SPAWN:New(TargsGroupName)
                         :InitLimit( GROUP
                         :FindByName( TargsGroupName )
                         :GetInitialSize() , 20 )
                         :SpawnScheduled( TargsRespawnTimer, 0 )
                         :InitRepeatOnLanding() -- <<<<<<<<is this the extra you siad about???
    Targs_GLOBAL_RedHeloSPAWNERS_ARRAY[TargsGroupName] = spawner
end

--Pass in the group template name (string), Stops the spawner from spawning more units
function Targs_RedHeloSpawnerStop(TargsGroupName)
    local spawner = Targs_GLOBAL_RedHeloSPAWNERS_ARRAY[TargsGroupName]
    spawner:SpawnScheduleStop()
end


Targs_RedHeloSpawnerSetup("RedHelo11_R1", 30)
--Targs_RedHeloSpawnerSetup("RedHelo11_A2", 60)
--Targs_RedHeloSpawnerSetup("RedHelo11_A3", 60)
--Targs_RedHeloSpawnerSetup("RedHelo11_A4", 30)
--Targs_RedHeloSpawnerSetup("RedHelo11_A5", 60)
--Targs_RedHeloSpawnerSetup("RedHelo11_A6", 30)

--Targs_RedHeloSpawnerSetup("RedHelo21_B1", 30)
--Targs_RedHeloSpawnerSetup("RedHelo21_B2", 60)
--args_RedHeloSpawnerSetup("RedHelo21_B3", 30)
--Targs_RedHeloSpawnerSetup("RedHelo21_B4", 90)
--Targs_RedHeloSpawnerSetup("RedHelo21_B5", 60)
--Targs_RedHeloSpawnerSetup("RedHelo21_B6", 30)