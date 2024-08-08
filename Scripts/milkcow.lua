function HEVENT:handleMilkCow(text,coord,_group,_playername,_coalition)
  local _playerame = _playername or "Unknown"
  local _coord = coord
  local _col = _coalition
  local _mgrs = _coord:ToStringMGRS()
  local _agent = BLUEFIRESUPPORTNAME
  self:E({_playername,_coord,_agent,_mgrs})
  local msg = string.format("%s, this is %s requesting a FARP at %s.",_agent,_playername,_mgrs)
  self:Msg(msg,nil,_col,10)
  -- get our nearest airbase.
  local nearestab = coord:GetClosestAirbase(nil,_coalition)
  if self.milkcowtemplate == nil then
    msg = string.format("%s, %s unable at this time no assets avalible",_playername,_agent)
    self:Msg(msg,nil,_col,10)
    return false
  end
  if self.milkcowspawns == self.milkcowuses then
    msg = string.format("%s, %s unable to at this time, all the cows are currently deployed you'll have to wait until tomorrow buddy.",_playername,_agent)
    self:Msg(msg,nil,_col,10)
    return false
  end
  local _nook = SPAWN:NewWithAlias(self.milkcowtemplate,"MilkCow"):SpawnAtAirbase(nearestab,SPAWN.Takeoff.Runway,00)
  if _nook == nil then
    msg = string.format("%s, %s inform command we have had a FOBAR error, milkcows are down there are no moos happening today",_playername,_agent)
    self:Msg(msg,nil,_col,10)
    return false
  end

  self.milkcowspawns = self.milkcowspawns + 1
  -- ok we have spawned the milkcow now we need to route it from its current location to the new location.
 
  local Route = {}
  local FromCoord = nearestab:GetCoordinate()
  local fromheading = FromCoord:HeadingTo(coord)
  local distance = FromCoord:Get2DDistance(coord)
  local midpoint = FromCoord:Translate((distance/2),fromheading)
  local mvec3 = midpoint:GetVec2()
  midpoint = COORDINATE:NewFromVec2(mvec3,150)
  local ToCoord = coord
  local speed = UTILS.KnotsToKmph(120)
  Route[#Route+1] = FromCoord:WaypointAirTakeOffRunway(COORDINATE.WaypointAltType.BARO,speed)
  Route[#Route+1] = midpoint:WaypointAirFlyOverPoint(COORDINATE.WaypointAltType.RADIO,speed)
  Route[#Route+1] = ToCoord:WaypointAirFlyOverPoint(COORDINATE.WaypointAltType.RADIO,speed)
  local Tasks = {}
  Tasks[#Tasks+1] = _nook:TaskLandAtVec2(ToCoord:GetVec2(),150)
  Tasks[#Tasks+1] = _nook:TaskFunction("MilkCowFarpSpawn",coord,_group,_playername,_coalition)
  local combotask = _nook:TaskCombo(Tasks)
  _nook:SetTaskWaypoint(Route[#Route],combotask)
  Route[#Route+1] = FromCoord:WaypointAirLanding(speed)
  _nook:Route(Route,1)
  self:Log({"Should have pushed all data to the milkcow and it should be going were we want it to be going."})

  msg = string.format("%s, Milkcow request recieved unit is taking off from this time for coordinates %s",_playername,_mgrs)
  self:Msg(msg,nil,_col,10)
end
function MilkCowArrived()
  HEVENT:Msg("Milk Cow is landing at target Coordinates Base should take 150 seconds to create",nil,2,10)
end