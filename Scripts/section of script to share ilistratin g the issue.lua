-- Ensure the 'package' global is available before loading Moose
if not package then
  package = {}
end

-- Load Moose
env.info("1 Moose_ Called")
assert(loadfile(SOURCEPATH .. "Moose_.lua"))()
env.info("1 Moose_ Loaded")

-- Custom logging functions
local function logInfo(message)
  env.info(message)
end

local function logError(message)
  env.error(message)
  local logFile = io.open(lfs.writedir() .. "Logs/airboss_error.log", "a")
  if logFile then
    logFile:write(message .. "\n")
    logFile:close()
  else
    env.error("Failed to open airboss_error.log")
  end
end

-- Function to safely execute code and log errors
local function safeExecute(func, ...)
  local status, err = pcall(func, ...)
  if not status then
    logError(err)
  end
end

-- Ensure MOOSE is loaded
if not _G.BASE then
  logError("MOOSE is not loaded. Ensure that Moose.lua is properly included in the mission.")
  return -- Exit the script if MOOSE is not loaded
end

logInfo("MOOSE is loaded successfully.")

-- Indicate the start of a new mission in the log file
logInfo("-------------------mission start-------------------")
local logFile = io.open(lfs.writedir() .. "Logs/airboss_error.log", "a")
if logFile then
  logFile:write("-------------------mission start-------------------\n")
  logFile:close()
else
  env.error("Failed to open airboss_error.log")
end

-- Display Current Wind
safeExecute(function()
  local function DisplayWind()
    if AirbossLincoln then
      local wpa, wpp, wtot = AirbossLincoln:GetWindOnDeck()
      local cspeed = AirbossLincoln.carrier:GetVelocityKNOTS()
      local text = string.format("Carrier Speed = %.1f knots, heading=%03d, turning=%s, state=%s.\n", cspeed, AirbossLincoln:GetHeading(), tostring(AirbossLincoln.turning), AirbossLincoln:GetState())
      text = text .. string.format("wind on deck || %.1f, -- %.1f , total %.1f knots.", UTILS.MpsToKnots(wpp), UTILS.MpsToKnots(wtot))
      UTILS.DisplayMissionTime(25)
      MESSAGE:New(text, 25):ToAll()
    else
      logError("AirbossLincoln is nil in DisplayWind")
    end
  end
  SCHEDULER:New(nil, DisplayWind, {}, 30, 30)
  logInfo("Scheduler for DisplayWind set up.")
end)
