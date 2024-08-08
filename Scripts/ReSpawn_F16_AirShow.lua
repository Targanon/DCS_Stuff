--------
---- respawn escorts
-------


-- local Air_Show_1 = SPAWN:New("F16_AirShow"):InitLimit( 1, 20 ):SpawnScheduled( 1620, .0 ):InitCleanUp( 60 )

-- local Air_Show_1_Grp = Air_Show_1:Spawn()


--_____________________________________________
--New Airshow Codes
-- Airshow F16's by Targs35 of 62AW--
--_____________________________________________

----------------------------------------------------------------------
--SPA-124 - Air Ops - Scheduled Spawns with OnSpawnGroup() Escort Task
----------------------------------------------------------------------
 --//////////////////////////////////
 --////////////F16_AirShows 
 --//////////////////////////////////
--////////// By Targs35 /////////////
--//////////////// from 62nd Air Wing, Brisbane server..
--///////////////////////////////////
 ------- With thanks to the guys at MOOSE and in particular Pikes, Nolove, Delta99 and Wingthor
 -- Funky Frank is the man..
-----////////////////////////////////
--///////////  Spawn Shell_Tanker and Escorts  ///

do
      
    local PointVec101 = POINT_VEC3:New( -20, 5, 20 ) -- This is a Vec3 class - defines the position of the escorts relative to the escorted group
    local PointVec102 = POINT_VEC3:New( -40, 10, 40 ) -- This is a Vec3 class - defines the position of the escorts relative to the escorted group
    local PointVec103 = POINT_VEC3:New( -60, 15, 60 ) -- This is a Vec3 class - defines the position of the escorts relative to the escorted group
    
    --Create Spawn Groups, use the OnSpawnGroup() function to spawn two escorts and task them
       
    local Tanker_Shell = SPAWN
      :New("F16_AirShow_1")
      :InitLimit( 1, 2 ) -- spawn 1 *alive* units max
      :InitCleanUp( 240 )
      :OnSpawnGroup(function (F16_AirShow) -- F16_AirShow contains the GROUP object when the F16_AirShow spawns
        local F16_AirShow_101 = SPAWN
          :New("F16_AirShow 101")
          :InitLimit( 1, 2 )
          :InitCleanUp( 240 )
          :OnSpawnGroup(function (spawndgroup) -- spawndgrp contains the GROUP object when the escort spawns
            local FollowDCSTask101 = spawndgroup:TaskFollow( F16_AirShow, PointVec101 ) -- create task
            spawndgroup:SetTask( FollowDCSTask101, 1 ) -- push task on the GROUP
          end
          )
          :SpawnScheduled( 60, 0.5 )
        
        local F16_AirShow_102 = SPAWN
          :New("F16_AirShow 102")
          :InitLimit( 1, 2 )
          :InitCleanUp( 240 )
          :OnSpawnGroup(function (spawndgroup) -- spawndgrp contains the GROUP object when the escort spawns
            local FollowDCSTask102 = spawndgroup:TaskFollow( F16_AirShow, PointVec102 )
            spawndgroup:SetTask( FollowDCSTask102, 1 )
          end
          )
          :SpawnScheduled( 60, 0.5 )     
      

        local F16_AirShow_103 = SPAWN
            :New("F16_AirShow 103")
            :InitLimit( 1, 2 )
            :InitCleanUp( 240 )
            :OnSpawnGroup(function (spawndgroup) -- spawndgrp contains the GROUP object when the escort spawns
                local FollowDCSTask103 = spawndgroup:TaskFollow( F16_AirShow, PointVec103 )
                spawndgroup:SetTask( FollowDCSTask103, 1 )
            end
            )
            :SpawnScheduled( 60, 0.5 )     
        end
        )
      :SpawnScheduled( 60, 0.5 )

end
