-- INSTRUCTIONS
-- In the DCS mission do a single trigger, time more (1) that does a DO SCRIPT event
-- Paste this code into the DO SCRIPT:
-- assert(loadfile(SOURCEPATH .. "Mission_Loader.lua"))()
-- that the old system is way diiferent..

--Moose
assert(loadfile(SOURCEPATH .. "Moose.lua"))()
env.info("1 Moose_ Loaded")

--Mist
--assert(loadfile(SOURCEPATH .. "Mist.lua"))()
--env.info("2 Mist Loaded")

--load Targs_RedAir_spawner\
assert(loadfile(SOURCEPATH .. "Targs_RedAir_spawner.lua"))()
env.info("2 Targs_RedAir_spawner Loaded")

--load Targs_RedHelo_spawner\
assert(loadfile(SOURCEPATH .. "Targs_RedHelo_spawner.lua"))()
env.info("3 Targs_RedHelo_spawner Loaded")

--Load Targs_ConvoySpawnerSetupSite_V1a
env.info("3 Targs_ConvoySpawnerSetupSite_V1a is next to be loaded")
assert(loadfile(SOURCEPATH .. "Targs_ConvoySpawnerSetupSite_V_1a.lua"))()
env.info("3 Targs_ConvoySpawnerSetupSite_V_1a was loaded")

--load Links_Ground_spawner\
--assert(loadfile(SOURCEPATH .. "Targs_RedConvoysv2-0.lua"))()
--env.info("4 Targs_RedConvoy_Spawner_Tracker_timebased Loaded")


env.info("5 Farp Creator called")
--Farp Creator
--assert(loadfile(SOURCEPATH .. "FarpCreator_Chinook.lua"))()
--env.info("6 FarpCreator_Chinook Loaded")
assert(loadfile(SOURCEPATH .. "Targs_FARP_Creator_Final.lua"))()
env.info("7 FTargs_FARP_Creator_Final Loaded")


--Restart Alarm
assert(loadfile(SOURCEPATH .. "RestartAlarm_Passed.lua"))()
env.info("11 RestartAlarm Loaded")


env.info("End of loaded Mission Files")

--Holding area for code


--Mist
--assert(loadfile(SOURCEPATH .. "Mist.lua"))()
--env.info("2 Mist Loaded")

--A2A defence red network
--  assert(loadfile(SOURCEPATH .. "Syria_v1.1.lua"))()
--  env.info("3 A2A Defence Loaded")

--FAC network
--  assert(loadfile(SOURCEPATH .. "FAC.lua"))()
--  env.info("4 FAC Loaded")

--CTLD network
  --assert(loadfile(SOURCEPATH .. "CTLD.lua"))()
  --env.info("5 CTLD Loaded")


--CSAR
  --assert(loadfile(SOURCEPATH .. "CSAR.lua"))()
  --env.info("CSAR Loaded")

--airboss
--  assert(loadfile(SOURCEPATH .. "Airboss_Recovery_lite.lua"))()
--  env.info("12 Airboss Loaded")

--RAT network
--  assert(loadfile(SOURCEPATH .. "Syria_RAT_v1_2.lua"))()
--  env.info("13 RAT Network Loaded")



--load CTLD (helicopter Supply missions)
  --assert(loadfile(SOURCEPATH .. "CTLD - UH60mod.lua"))()
  --env.info("13 CTLD - UH60mod Loaded")

--load CSAR (helicopter Rescue missions)
  --assert(loadfile(SOURCEPATH .. "CSAR UH60.lua"))()
  --env.info("14 CSAR UH60 Loaded")

--load Profiler (Profiler.lua)
--  assert(loadfile(SOURCEPATH .. "Profiler.lua"))()
--  env.info("15 Profiler Loaded")



--Utility Aircraft network
--  assert(loadfile(SOURCEPATH .. "UtilityAircraft_v1.lua"))()
--  env.info("6 UtilityAircraft Loaded")

--load tankers and awacs plus escorts to follow them
--assert(loadfile(SOURCEPATH .. "Tanker_Shell V3.lua"))()
--assert(loadfile(SOURCEPATH .. "Tanker_Texaco V3.lua"))()
--assert(loadfile(SOURCEPATH .. "AWACS_Overlord V3.lua"))()
--env.info("7 8 9 Awacs n Tankers Loaded")

--Links_Ground_spawner
--  assert(loadfile(SOURCEPATH .. "Links_Ground_spawner.lua"))()
--  env.info("14 Links_Ground_spawner Loaded")

--RescueHelo
  --assert(loadfile(SOURCEPATH .. "RescueHelo.lua"))()
  --env.info("8 RescueHelo Loaded")

--Skynet iads Compiled
--  assert(loadfile(SOURCEPATH .. "skynet-iads-compiled.lua"))()
--  env.info("9 skynet-iads-compiled Loaded")

--Syria_v3.1-Skynet-DEV_OFF
--  assert(loadfile(SOURCEPATH .. "Syria_v3.1-Skynet-DEV_OFF.lua"))()
--  env.info("10 Syria_v3.1-Skynet-DEV_OFF Loaded")
