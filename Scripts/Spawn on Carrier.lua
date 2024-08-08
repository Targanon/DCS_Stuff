------------------------------------
-- Recovery Tanker Example Script --
------------------------------------


-- Declare SPAWN object
Spawn_F18 = SPAWN:New( "F18_Group" ):InitLimit( 1, 0 )

  -- Repeat on engine shutdown (when landed on the airport)
Spawn_F18:InitRepeatOnEngineShutDown()

-- Now SPAWN the group

Spawn_F18:SpawnAtAirbase( AIRBASE:FindByName( "the carrier Carl Vinson (CVN-70)" ), SPAWN.Takeoff.Cold )
