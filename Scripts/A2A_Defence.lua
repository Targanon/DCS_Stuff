--=============================================================================================================================================
--
--          A2A Dispatcher Defence system
--                        By
--                     Targs35
--         Adapted from Defence system By
--/////////////////////////////////////////////
--Name: Operation Snowfox A2A Defence System
--Author: Surrexen    ༼ つ ◕_◕ ༽つ    (づ｡◕‿◕｡)づ
--/////////////////////////////////////////////
-- He is DA Man!

--turns off trace
BASE:TraceOnOff( true )

--////RED AIR DEFENCE

REDDetectionSetGroup = SET_GROUP:New()
REDDetectionSetGroup:FilterPrefixes( { "DF RED EWR", "Red Carrier", "DF RED AWACS", "EWR Red" } ) -- , "DF RED AWACS"
REDDetectionSetGroup:FilterStart()
REDDetection = DETECTION_AREAS:New( REDDetectionSetGroup, 80000 )
REDA2ADispatcher = AI_A2A_DISPATCHER:New( REDDetection )
REDA2ADispatcher:SetTacticalDisplay( false )
RedBorderZone = ZONE_POLYGON:New( "RED Border", GROUP:FindByName( "RED Border" ) ) -- "RED International Waters Line"
REDA2ADispatcher:SetBorderZone( RedBorderZone )
REDA2ADispatcher:SetDefaultCapLimit( 1 )
REDA2ADispatcher:SetEngageRadius( 30000 )
REDA2ADispatcher:SetGciRadius( 35000 )
REDA2ADispatcher:SetDisengageRadius( 70000 )

--=============================================================================================================================================
--////RED SQUADRONS

--////function AI_A2A_DISPATCHER:SetSquadron( SquadronName, AirbaseName, TemplatePrefixes, ResourceCount )

-- ////Template Planes
-- SQ IRN F-4E
-- SQ IRN F-5E-3
-- SQ IRN MiG-29A
-- SQ IRN F-14A
-- SQ IRN JF-17

--////Airbases

-- * AIRBASE.PersianGulf.Abu_Dhabi_International_Airport
-- * AIRBASE.PersianGulf.Abu_Musa_Island_Airport
-- * AIRBASE.PersianGulf.Al-Bateen_Airport
-- * AIRBASE.PersianGulf.Al_Ain_International_Airport
-- * AIRBASE.PersianGulf.Al_Dhafra_AB
-- * AIRBASE.PersianGulf.Al_Maktoum_Intl
-- * AIRBASE.PersianGulf.Al_Minhad_AB
-- * AIRBASE.PersianGulf.Bandar_e_Jask_airfield
-- * AIRBASE.PersianGulf.Bandar_Abbas_Intl
-- * AIRBASE.PersianGulf.Bandar_Lengeh
-- * AIRBASE.PersianGulf.Dubai_Intl
-- * AIRBASE.PersianGulf.Fujairah_Intl
-- * AIRBASE.PersianGulf.Havadarya
-- * AIRBASE.PersianGulf.Jiroft_Airport
-- * AIRBASE.PersianGulf.Kerman_Airport
-- * AIRBASE.PersianGulf.Khasab
-- * AIRBASE.PersianGulf.Kish_International_Airport
-- * AIRBASE.PersianGulf.Lar_Airbase
-- * AIRBASE.PersianGulf.Lavan_Island_Airport
-- * AIRBASE.PersianGulf.Liwa_Airbase
-- * AIRBASE.PersianGulf.Qeshm_Island
-- * AIRBASE.PersianGulf.Ras_Al_Khaimah_International_Airport
-- * AIRBASE.PersianGulf.Sas_Al_Nakheel_Airport
-- * AIRBASE.PersianGulf.Sharjah_Intl
-- * AIRBASE.PersianGulf.Shiraz_International_Airport
-- * AIRBASE.PersianGulf.Sir_Abu_Nuayr
-- * AIRBASE.PersianGulf.Sirri_Island
-- * AIRBASE.PersianGulf.Tunb_Island_AFB
-- * AIRBASE.PersianGulf.Tunb_Kochak

-- Alpha   - Bandar Lengeh   - Sector 1	  -- Operating Iranian Planes
-- Beta    - Lar 			 - Sector 2	  -- Operating Iranian Planes
-- Gamma   - Havadarya	 	 - Sector 3	  -- Operating Iranian Planes
-- Delta   - Bandar Abbas	 - Sector 4	  -- Operating Iranian Planes
-- Epsilon - Bandar-e-Jask   - Sector 5   -- Operating Iranian Planes



--////CAP Squadrons
REDA2ADispatcher:SetSquadron( "Alpha", AIRBASE.PersianGulf.Bandar_Lengeh, { "SQ IRN F14 CAP", "SQ IRN MiG29A CAP" }, 10 )
REDA2ADispatcher:SetSquadron( "Beta", AIRBASE.PersianGulf.Lar_Airbase, { "SQ IRN J17 CAP", "SQ IRN MiG29A CAP" }, 10 )
REDA2ADispatcher:SetSquadron( "Gamma", AIRBASE.PersianGulf.Havadarya, { "SQ IRN F14 CAP", "SQ IRN MiG29A CAP" }, 10 )
REDA2ADispatcher:SetSquadron( "Delta", AIRBASE.PersianGulf.Bandar_Abbas_Intl, { "SQ IRN MiG29A CAP", "SQ IRN J17 CAP" }, 20 )
REDA2ADispatcher:SetSquadron( "Epsilon", AIRBASE.PersianGulf.Bandar_e_Jask_airfield, { "SQ IRN F14 CAP", "SQ IRN MiG29A CAP", "SQ IRN J17 CAP" }, 10 )
REDA2ADispatcher:SetSquadron( "Foxtrot", AIRBASE.PersianGulf.Qeshm_Island, { "SQ IRN F14 CAP", "SQ IRN MiG29A CAP" }, 10 )
--////GCI Squadrons
REDA2ADispatcher:SetSquadron( "Tau", AIRBASE.PersianGulf.Qeshm_Island, { "SQ RUS F5E CGI", "SQ RUS F4 CGI", "SQ IRN F_14 CGI" }, 30 )
REDA2ADispatcher:SetSquadron( "Uniform", AIRBASE.PersianGulf.Bandar_e_Jask_airfield, { "SQ RUS F5E CGI", "SQ RUS F4 CGI" }, 25 )
REDA2ADispatcher:SetSquadron( "Victor", AIRBASE.PersianGulf.Kish_International_Airport, { "SQ RUS F5E CGI", "SQ RUS F4 CGI", "SQ IRN F_14 CGI" }, 25 )

--=============================================================================================================================================
--////SQUADRON OVERHEAD (1.0-1.5)
--CAP
REDA2ADispatcher:SetSquadronOverhead( "Alpha", 1.0)
REDA2ADispatcher:SetSquadronOverhead( "Beta", 1.0)
REDA2ADispatcher:SetSquadronOverhead( "Gamma", 1.0)
REDA2ADispatcher:SetSquadronOverhead( "Delta", 1.0)
REDA2ADispatcher:SetSquadronOverhead( "Epsilon", 1.0)
REDA2ADispatcher:SetSquadronOverhead( "Foxtrot", 1.0)
--GCI
REDA2ADispatcher:SetSquadronOverhead( "Tau", 1.3)
REDA2ADispatcher:SetSquadronOverhead( "Uniform", 1.3)
REDA2ADispatcher:SetSquadronOverhead( "Victor", 1.0)


--=============================================================================================================================================
--////SQUADRON GROUPING (Number of planes to be launched)
--CAP
REDA2ADispatcher:SetSquadronGrouping( "Alpha", 1 )
REDA2ADispatcher:SetSquadronGrouping( "Beta", 1 )
REDA2ADispatcher:SetSquadronGrouping( "Gamma", 1 )
REDA2ADispatcher:SetSquadronGrouping( "Delta", 2 )
REDA2ADispatcher:SetSquadronGrouping( "Epsilon", 2 )
REDA2ADispatcher:SetSquadronGrouping( "Foxtrot", 1 )
--GCI
REDA2ADispatcher:SetSquadronGrouping( "Tau", 2 )
REDA2ADispatcher:SetSquadronGrouping( "Uniform", 1 )
REDA2ADispatcher:SetSquadronGrouping( "Victor", 1 )

--=============================================================================================================================================
--////SQUADRON TAKEOFF METHOD

--[[
REDA2ADispatcher:SetSquadronTakeoffFromParkingHot( "Alpha" )
REDA2ADispatcher:SetSquadronTakeoffFromParkingHot( "Beta" )
REDA2ADispatcher:SetSquadronTakeoffFromParkingHot( "Gamma" )
REDA2ADispatcher:SetSquadronTakeoffFromParkingHot( "Delta" )
REDA2ADispatcher:SetSquadronTakeoffFromParkingHot( "Epsilon" )
REDA2ADispatcher:SetSquadronTakeoffFromParkingHot( "Foxtrot" )
REDA2ADispatcher:SetSquadronTakeoffFromParkingHot( "Tau" )
]]--

--[[
REDA2ADispatcher:SetSquadronTakeoffFromRunway( "Alpha" )
REDA2ADispatcher:SetSquadronTakeoffFromRunway( "Beta" )
REDA2ADispatcher:SetSquadronTakeoffFromRunway( "Gamma" )
REDA2ADispatcher:SetSquadronTakeoffFromRunway( "Delta" )
REDA2ADispatcher:SetSquadronTakeoffFromRunway( "Epsilon" )
REDA2ADispatcher:SetSquadronTakeoffFromRunway( "Foxtrot" )
REDA2ADispatcher:SetSquadronTakeoffFromRunway( "Tau" )
]]--

--CAP
REDA2ADispatcher:SetSquadronTakeoffInAir( "Alpha", 200 )
REDA2ADispatcher:SetSquadronTakeoffInAir( "Beta", 200)
REDA2ADispatcher:SetSquadronTakeoffInAir( "Gamma", 200 )
REDA2ADispatcher:SetSquadronTakeoffInAir( "Delta", 200 )
REDA2ADispatcher:SetSquadronTakeoffInAir( "Epsilon", 200 )
REDA2ADispatcher:SetSquadronTakeoffInAir( "Foxtrot", 200 )
--GCI
REDA2ADispatcher:SetSquadronTakeoffInAir( "Tau", 200 )
REDA2ADispatcher:SetSquadronTakeoffInAir( "Uniform", 200 )
REDA2ADispatcher:SetSquadronTakeoffInAir( "Victor", 200 )

--////EXAMPLE CODE
--REDA2ADispatcher:SetSquadronTakeoffInAir( "Alpha" )
--REDA2ADispatcher:SetSquadronTakeoffFromParkingCold( "Alpha" )
--REDA2ADispatcher:SetSquadronTakeoffFromParkingHot( "Alpha" )
--REDA2ADispatcher:SetSquadronTakeoffFromRunway( "Alpha" )

--=============================================================================================================================================
--////SQUADRON LANDING METHOD
--cap
REDA2ADispatcher:SetSquadronLandingAtRunway( "Alpha" )
REDA2ADispatcher:SetSquadronLandingAtRunway( "Beta" )
REDA2ADispatcher:SetSquadronLandingAtRunway( "Gamma" )
REDA2ADispatcher:SetSquadronLandingAtRunway( "Delta" )
REDA2ADispatcher:SetSquadronLandingAtRunway( "Epsilon" )
REDA2ADispatcher:SetSquadronLandingAtRunway( "Foxtrot" )
--GCI
REDA2ADispatcher:SetSquadronLandingAtRunway( "Tau" )
REDA2ADispatcher:SetSquadronLandingAtRunway( "Uniform" )
REDA2ADispatcher:SetSquadronLandingAtRunway( "Victor" )

--=============================================================================================================================================
--////RED CAP SQUADRON EXECUTION

--function AI_A2A_DISPATCHER:SetSquadronCap( SquadronName, Zone, FloorAltitude, CeilingAltitude, PatrolMinSpeed, PatrolMaxSpeed, EngageMinSpeed, EngageMaxSpeed, AltType )
--function AI_A2A_DISPATCHER:SetSquadronCapInterval( SquadronName, CapLimit, LowInterval, HighInterval, Probability )

--////CAP Zones
CAPZoneRed1 = ZONE:New("CAP Zone RED 1")
CAPZoneRed2 = ZONE:New("CAP Zone RED 2")
CAPZoneRed3 = ZONE:New("CAP Zone RED 3")
CAPZoneRed4 = ZONE:New("CAP Zone RED 4")
CAPZoneRed5 = ZONE:New("CAP Zone RED 5")
CAPZoneRed6 = ZONE:New("CAP Zone RED 6")

--////Squadron Cap And Interval
REDA2ADispatcher:SetSquadronCap( "Alpha", CAPZoneRed1, 1000, 10000, 600, 800, 800, 1200, "BARO" )
REDA2ADispatcher:SetSquadronCapInterval( "Alpha", 1, 600, 1200, 1 )

REDA2ADispatcher:SetSquadronCap( "Beta", CAPZoneRed2, 1000, 10000, 600, 800, 800, 1200, "BARO" )
REDA2ADispatcher:SetSquadronCapInterval( "Beta", 1, 600, 1200, 1 )

REDA2ADispatcher:SetSquadronCap( "Gamma", CAPZoneRed3, 1000, 10000, 600, 800, 800, 1200, "BARO" )
REDA2ADispatcher:SetSquadronCapInterval( "Gamma", 1, 600, 1200, 1 )

REDA2ADispatcher:SetSquadronCap( "Delta", CAPZoneRed4, 1000, 10000, 600, 800, 800, 1200, "BARO" )
REDA2ADispatcher:SetSquadronCapInterval( "Delta", 1, 600, 1200, 1 )

REDA2ADispatcher:SetSquadronCap( "Epsilon", CAPZoneRed5, 1000, 10000, 600, 800, 800, 1200, "BARO" )
REDA2ADispatcher:SetSquadronCapInterval( "Epsilon", 1, 600, 1200, 1 )

REDA2ADispatcher:SetSquadronCap( "Foxtrot", CAPZoneRed6, 1000, 10000, 600, 800, 800, 1200, "BARO" )
REDA2ADispatcher:SetSquadronCapInterval( "Foxtrot", 1, 600, 1200, 1 )

--=============================================================================================================================================
--////RED GCI SQUADRON EXECUTION

--function AI_A2A_DISPATCHER:SetSquadronGci( SquadronName, EngageMinSpeed, EngageMaxSpeed )

--////GCI
REDA2ADispatcher:SetSquadronGci( "Tau", 300, 1200 )
REDA2ADispatcher:SetSquadronGci( "Uniform", 300, 1200 )
REDA2ADispatcher:SetSquadronGci( "Victor", 300, 1200 )
--A2ADispatcher:SetSquadronGci( "Kappa", 900, 1200 )

--=============================================================================================================================================
--////REFUELLING CAP

-- Setup the Refuelling for squadron "Rogue", at tanker (group) "Shell" when the fuel in the tank of the CAP defenders is less than 80%.
-- BLUEA2ADispatcher:SetSquadronFuelThreshold( "Rogue", 0.8 )
-- BLUEA2ADispatcher:SetSquadronTanker( "Rogue", "Texaco" )

-- Or standard refuel fuel threshold
--A2ADispatcher:SetSquadronRefuelThreshold( "Alpha", 0.30 ) -- Go RTB when only 30% of fuel remaining in the tank.
--A2ADispatcher:SetSquadronRefuelThreshold( "Beta", 0.30 )
--A2ADispatcher:SetSquadronRefuelThreshold( "Gamma", 0.30 )
--A2ADispatcher:SetSquadronRefuelThreshold( "Delta", 0.30 )
--A2ADispatcher:SetSquadronRefuelThreshold( "Epsilon", 0.30 )
--A2ADispatcher:SetSquadronRefuelThreshold( "Zeta", 0.30 )
--//Not sure about GCI fuel thresholds yet so not enabled
--A2ADispatcher:SetSquadronRefuelThreshold( "Tau", 0.50 )

--=============================================================================================================================================
--////CLEAN UP AIRBASES

--CLEANUP_AIRBASE:New( { AIRBASE.PersianGulf.Havadarya, AIRBASE.PersianGulf.Bandar_Lengeh, AIRBASE.PersianGulf.Lar_Airbase, AIRBASE.PersianGulf.Khasab, AIRBASE.PersianGulf.Bandar_Abbas_Intl, AIRBASE.PersianGulf.Sharjah_Intl } )

--=============================================================================================================================================