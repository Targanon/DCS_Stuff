----------------------------------------------------------------------
--SPA-124 - Air Ops - Scheduled Spawns with OnSpawnGroup() Escort Task
----------------------------------------------------------------------
 --//////////////////////////////////
 --////////////Shell_Tankers and Shell_Tanker v1
 --//////////////////////////////////
--////////// By Targs35 /////////////
--//////////////// from 62nd Air Wing, Brisbane server..
--///////////////////////////////////
 ------- With thanks to the guys at MOOSE and in particular Pikes, Nolove, Delta99 and Wingthor
 -- Funky Frank is the man..
-----////////////////////////////////
--///////////  Spawn Shell_Tanker and Escorts  ///

do
      
    local PointVec5 = POINT_VEC3:New( -100, 10, 100  ) -- This is a Vec3 class - defines the position of the escorts relative to the escorted group
    local PointVec6 = POINT_VEC3:New( -120, 10, 150  ) -- This is a Vec3 class - defines the position of the escorts relative to the escorted group
    
    --Create Spawn Groups, use the OnSpawnGroup() function to spawn two escorts and task them
       
    local Tanker_Shell = SPAWN
      :New("Shell_KC-135_54Y_254-1")
      :InitLimit( 1, 2 ) -- spawn 1 *alive* units max
      :InitCleanUp( 240 )
      :OnSpawnGroup(function (Shell_Tanker) -- Shell_Tanker contains the GROUP object when the Shell_Tanker spawns
        local Escort_Shell_5 = SPAWN
          :New("Escort_shell_F15-1")
          :InitLimit( 1, 2 )
          :InitCleanUp( 240 )
          :OnSpawnGroup(function (spawndgroup) -- spawndgrp contains the GROUP object when the escort spawns
            local FollowDCSTask5 = spawndgroup:TaskFollow( Shell_Tanker, PointVec5 ) -- create task
            spawndgroup:SetTask( FollowDCSTask5, 1 ) -- push task on the GROUP
          end
          )
          :SpawnScheduled( 60, 0.5 )
        
        local Escort_Shell_6 = SPAWN
          :New("Escort_shell_F15-2")
          :InitLimit( 1, 2 )
          :InitCleanUp( 240 )
          :OnSpawnGroup(function (spawndgroup) -- spawndgrp contains the GROUP object when the escort spawns
            local FollowDCSTask6 = spawndgroup:TaskFollow( Shell_Tanker, PointVec6 )
            spawndgroup:SetTask( FollowDCSTask6, 1 )
          end
          )
          :SpawnScheduled( 60, 0.5 )     
      end
      )
      :SpawnScheduled( 60, 0.5 )

end
