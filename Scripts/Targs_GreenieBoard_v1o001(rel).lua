-- Ensure the 'package' global is available
if not package then
    package = {}
end

-- Custom logging functions
local function logInfo(message)
    env.info(message)
    local logFile = io.open(lfs.writedir() .. "Logs/TargsGreenieBoard.log", "a")
    if logFile then
        logFile:write("[INFO] " .. message .. "\n")
        logFile:close()
    else
        env.error("Failed to open TargsGreenieBoard.log")
    end
end

local function logError(message)
    env.error(message)
    local logFile = io.open(lfs.writedir() .. "Logs/TargsGreenieBoard.log", "a")
    if logFile then
        logFile:write("[ERROR] " .. message .. "\n")
        logFile:close()
    else
        env.error("Failed to open TargsGreenieBoard.log")
    end
end

-- Ensure MOOSE is loaded
if not _G.BASE then
    logError("MOOSE is not loaded. Ensure that Moose.lua is properly included in the mission.")
    return -- Exit the script if MOOSE is not loaded
end

logInfo("MOOSE is loaded successfully.")

-- Create AIRBOSS object
airbossLincoln = AIRBOSS:New("CVN_72_Abraham_Lincoln", "CVN_72_Abraham_Lincoln")

-- set the TACan frequency
airbossLincoln:SetTACAN(72, X, "ABL")

--- Set ICLS channel of carrier.
airbossLincoln:SetICLS(12, "ABL")

-- set rasdio for LSO
airbossLincoln:SetLSORadio(127400, "ÄM")

--Set Radio for Marshall
airbossLincoln:SetMarshalRadio(127400, "ÄM")

-- Set folder of airboss sound files within miz file.
airbossLincoln:SetSoundfilesFolder("Airboss Soundfiles/")

airbossLincoln:SetFunkManOn(10042, "127.0.0.1") -- Change this to your DCS ServerBot port

airbossLincoln:Start()

-- Function to handle LSO Grades
function airbossLincoln:OnAfterLSOGrade(From, Event, To, playerData, grade)
    local PlayerData = playerData
    local Grade = grade
    local score = tonumber(Grade.points)
    local name = tostring(PlayerData.name)

    -- Save the trap sheet
    self:_SaveTrapSheet(playerData, grade)

    -- Prepare the message to send to the Greenie Board
    local msg = {}
    msg.command = "onMissionEvent"
    msg.eventName = "S_EVENT_AIRBOSS"
    msg.initiator = {}
    msg.initiator.name = playerData.name
    msg.place = {}
    msg.place.name = Grade.carriername
    msg.points = Grade.points
    msg.grade = Grade.grade
    msg.details = Grade.details
    msg.case = Grade.case
    msg.wire = playerData.wire
    msg.trapsheet = "AIRBOSS-trapsheet-" .. playerData.name
    msg.time = timer.getTime()

    -- Send the message to the bot
    dcsbot.sendBotTable(msg)
    logInfo(string.format("Sent landing data for %s with score %.1f", name, score))
end

logInfo("-----------------------------------------------------------")
logInfo("AIRBOSS settings initialized for CVN 72 Abraham Lincoln.")
