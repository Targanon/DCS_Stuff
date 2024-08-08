----------------------------------------------------------------------
--SPA-124 - Air Ops - Scheduled Spawns with OnSpawnGroup() Escort Task
----------------------------------------------------------------------
 --//////////////////////////////////
 --////////////AWACSs and awacs v1
 --//////////////////////////////////
--////////// By Targs35 /////////////
--//////////////// from 62nd Air Wing, Brisbane server..
--///////////////////////////////////
 ------- With thanks to the guys at MOOSE and in particular Pikes, Nolove, Delta99 and Wingthor
 -- Funky Frank is the man..
-----////////////////////////////////
--///////////  Spawn AWACS and Escorts  ///

do
      
    local PointVec3 = POINT_VEC3:New( -200, 20, -600  ) -- This is a Vec3 class - defines the position of the escorts relative to the escorted group
    local PointVec4 = POINT_VEC3:New( -200, 20, 600  ) -- This is a Vec3 class - defines the position of the escorts relative to the escorted group
    
    --Create Spawn Groups, use the OnSpawnGroup() function to spawn two escorts and task them
       
    local AWACS_Overlord = SPAWN
      :New("Focus_E-7A Wedgetail-242-1")
      :InitLimit( 1, 2 ) -- spawn 1 *alive* units max
      :InitCleanUp( 240 )
      :OnSpawnGroup(function (AWACS) -- AWACS contains the GROUP object when the AWACS spawns
        local Escort_Overlord_3 = SPAWN
          :New("Escort_Focus_F16C-1")
          :InitLimit( 1, 2 )
          :InitCleanUp( 240 )
          :OnSpawnGroup(function (spawndgroup) -- spawndgrp contains the GROUP object when the escort spawns
            local FollowDCSTask3 = spawndgroup:TaskFollow( AWACS, PointVec3 ) -- create task
            spawndgroup:SetTask( FollowDCSTask3, 1 ) -- push task on the GROUP
          end
          )
          :SpawnScheduled( 120, 0.5 )
        
        local Escort_Overlord_4 = SPAWN
          :New("Escort_Focus_F16C-2")
          :InitLimit( 1, 2 )
          :InitCleanUp( 240 )
          :OnSpawnGroup(function (spawndgroup) -- spawndgrp contains the GROUP object when the escort spawns
            local FollowDCSTask4 = spawndgroup:TaskFollow( AWACS, PointVec4 )
            spawndgroup:SetTask( FollowDCSTask4, 1 )
          end
          )
          :SpawnScheduled( 180, 0.5 )     
      end
      )
      :SpawnScheduled( 60, 0.5 )

end
