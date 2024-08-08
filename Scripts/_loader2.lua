-- _loader2.lua
-- INSTRUCTIONS
-- In the DCS mission, do a single trigger, time more (1) that does a DO SCRIPT event
-- Paste this code into the DO SCRIPT:
-- assert(loadfile(SOURCEPATH .. "Mission_Loader.lua"))()

-- Ensure the 'package' global is available before loading Moose
if not package then
  package = {}
end

-- Moose
env.info("1 Moose_ Called")
assert(loadfile(SOURCEPATH .. "Moose_.lua"))()
env.info("1 Moose_ Loaded")

-- Greenie Board integration
--assert(loadfile(SOURCEPATH .. "Targs_GreenieBoard_v1o001(rel).lua"))()
--env.info("Targs Greenie Board integration NOT loaded")

-- Load Targs_RedAir_spawner
assert(loadfile(SOURCEPATH .. "Targs_RedAir_spawner.lua"))()
env.info("3 Targs_RedAir_spawner Loaded")

-- Load Targs_RedHelo_spawner
assert(loadfile(SOURCEPATH .. "Targs_RedHelo_spawner.lua"))()
env.info("4 Targs_RedHelo_spawner Loaded")

-- Load Targs_ConvoySpawnerSetupSite_V1a
env.info("5 Targs_SiteSetupConvoySpawner is next to be loaded")
assert(loadfile(SOURCEPATH .. "Targs_SiteSetupConvoySpawner_V1o00_180724.lua"))()
env.info("5 Targs_SiteSetupConvoySpawner was loaded")

-- Load tankers and awacs plus escorts to follow them
assert(loadfile(SOURCEPATH .. "Targs_Tanker_Shell V3.lua"))()
env.info("6.1 Shell Tanker was loaded")
assert(loadfile(SOURCEPATH .. "Targs_Tanker_Texaco V3.lua"))()
env.info("6.2 Texaco Tanker was loaded")
assert(loadfile(SOURCEPATH .. "Targs_AWACS_Darkstar V3.lua"))()
env.info("6.3 Darkstar E-7A was loaded")
assert(loadfile(SOURCEPATH .. "Targs_AWACS_Focus V3.lua"))()
env.info("6.4 Focus E-7A was loaded")

-- Farp Creator
--env.info("7 Farp Creator called")
--assert(loadfile(SOURCEPATH .. "Targs_FARPCREATOR CH-47F 010724.lua"))()
--env.info("7 Targs_FARPCREATOR CH-47F Loaded")

-- Restart Alarm
assert(loadfile(SOURCEPATH .. "Targs_RestartAlarm_Passed.lua"))()
env.info("11 RestartAlarm Loaded")

env.info("End of loaded Mission Files")

-- Holding area for code

-- Mist
-- assert(loadfile(SOURCEPATH .. "Mist.lua"))()
-- env.info("2 Mist Loaded")

-- FAC network
-- assert(loadfile(SOURCEPATH .. "FAC.lua"))()
-- env.info("4 FAC Loaded")

-- CTLD network
-- assert(loadfile(SOURCEPATH .. "CTLD.lua"))()
-- env.info("5 CTLD Loaded")

-- CSAR
-- assert(loadfile(SOURCEPATH .. "CSAR.lua"))()
-- env.info("CSAR Loaded")
