--shell

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
---Tanker_Shell_Boom
---Escort_Shell
--/////////////////////////////////////////////////////////////////////////////////////////////
--///////////  Spawn Tanker and Escorts  ///////////////////////////////////////////////


  ---its from here things get new for me, code below is in BETA

 do    
    --Create Spawn Groups
   
    local Tanker_Shell = SPAWN:New("Tanker_Shell_Boom"):InitLimit( 1, 10 ):SpawnScheduled( 120, .0 ):InitCleanUp( 240 )
    local Escort_Shell_5 = SPAWN:New("Escort_shell_F16 #001"):InitLimit( 1, 20 ):SpawnScheduled( 120, .0 ):InitCleanUp( 240 )
    local Escort_Shell_6 = SPAWN:New("Escort_shell_F16 #002"):InitLimit( 1, 20 ):SpawnScheduled( 120, .0 ):InitCleanUp( 240 )
    -- Now to spawn the ojects  
    --Shell set Task
    --Spawn Groups into world
    local GroupTanker_Shell = Tanker_Shell:Spawn()
    local GroupEscort_Shell_5 = Escort_Shell_5:Spawn()
    local GroupEscort_Shell_6 = Escort_Shell_6:Spawn()


    local PointVec5 = POINT_VEC3:New( -100, 50, -100  ) -- This is a Vec3 class.
    local PointVec6 = POINT_VEC3:New( -100, 50, 100  ) -- This is a Vec3 class.
    local FollowDCSTask5 = GroupEscort_Shell_5:TaskFollow( GroupTanker_Shell, PointVec5:GetVec3() )
    local FollowDCSTask6 = GroupEscort_Shell_6:TaskFollow( GroupTanker_Shell, PointVec6:GetVec3() )
    GroupEscort_Shell_5:SetTask( FollowDCSTask5, 5 )
    GroupEscort_Shell_6:SetTask( FollowDCSTask6, 6 )

end

env.info("Tanker_Shell Loaded v.03.2")

--[[
--=============================================================================================================================================
--////CLEAN UP AIRBASE

CleanUpAirports = CLEANUP_AIRBASE:New( { AIRBASE.Caucasus.Anapa_Vityazevo } )

--=============================================================================================================================================

env.info("CLEAN UP AIRBASE from Tanker_Shell Loaded v.01.1")
]]