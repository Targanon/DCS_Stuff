--Overlord

 --//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 --////////////Tankers and awacs v1
 --//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////////// By Targs35 /////////////////////////
--//////////////// from 62nd Air Wing, Brisbane server..
--///////////////////////////////////////////////////////////////////////////////////////////////
 ------- With thanks to the guys at MOOSE and in particular Pikes, Nolove, Delta99 and Wingthor
 -- Funky Frank is the man..
-----/////////////////////////////////////////////////////////////////////////////////////////////
----/////////////////  Object names in ME  //////////////////////////
--- Names are used for both Group and UnitName --
---AWACS_Overlord
---Escort_Overlord
--/////////////////////////////////////////////////////////////////////////////////////////////
--///////////  Spawn Tankers, AWACS and Escorts  ///////////////////////////////////////////////


  ---its from here things get new for me, code below is in BETA

  do    
    --Create Spawn Groups
   
    local AWACS_Overlord = SPAWN:New("AWACS_Overlord_E_3A"):InitLimit( 1, 10 ):SpawnScheduled( 60, .0 ):InitCleanUp( 240 )
    local Escort_Overlord_3 = SPAWN:New("Escort_Overlord_F15 #001"):InitLimit( 1, 20 ):SpawnScheduled( 120, .0 ):InitCleanUp( 240 )
    local Escort_Overlord_4 = SPAWN:New("Escort_Overlord_F15 #002"):InitLimit( 1, 20 ):SpawnScheduled( 120, .0 ):InitCleanUp( 240 )
    -- Now to spawn the ojects  
    -- Overloard set Task
    -- Spawn Groups into world
    local GroupAWACS_Overlord = AWACS_Overlord:Spawn()
    local GroupEscort_Overlord_3 = Escort_Overlord_3:Spawn()
    local GroupEscort_Overlord_4 = Escort_Overlord_4:Spawn()


    local PointVec3 = POINT_VEC3:New( -100, 50, -100 ) -- This is a Vec3 class.
    local PointVec4 = POINT_VEC3:New( -100, 50, 100 ) -- This is a Vec3 class.
    local FollowDCSTask3 = GroupEscort_Overlord_3:TaskFollow( GroupAWACS_Overlord, PointVec3:GetVec3() )
    local FollowDCSTask4 = GroupEscort_Overlord_4:TaskFollow( GroupAWACS_Overlord, PointVec4:GetVec3() )
    GroupEscort_Overlord_3:SetTask( FollowDCSTask3, 3 )
    GroupEscort_Overlord_4:SetTask( FollowDCSTask4, 4 )

end

env.info("AWACS_ Overlord Loaded v.02.2")

--[[
--=============================================================================================================================================
--////CLEAN UP AIRBASE

CleanUpAirports = CLEANUP_AIRBASE:New( { AIRBASE.Caucasus.Anapa_Vityazevo } )

--=============================================================================================================================================

env.info("CLEAN UP AIRBASE from AWACS_ Overlord Loaded v.01.1")
]]