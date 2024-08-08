--RestartAlarm_Passed.lua
-- By [62AW] Targs35



  local function MESSAGE()
    trigger.action.outText(string.format("This Server will restart every 5 hours!" ), 10);
  end

  -- Set a trigger action in ME test if Flag 5000 is true
  local mytimer=TIMER:New(MESSAGE,3)
  mytimer:Start(nil, 1800)     -- Will call right now and then every 1800 sec until all eternity.


  local function RESTART()
        trigger.action.outText(string.format("This Server will restart .... NOW.......!" ), 10); -- message restarting now
        trigger.action.setUserFlag(5000, true ) -- set the Flag
  end

  local mytimer=TIMER:New(RESTART,3)
  mytimer:Start(18000)            -- Will call the function once after 14400 seconds.