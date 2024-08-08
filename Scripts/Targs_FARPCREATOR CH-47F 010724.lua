-- Targs_FARPCREATOR CH-47F 010724.lua
-- Updated to use CH-47F helicopter instead of a land-based convoy

FARPCREATOR = {
    Classname = "Targs FARP Creator",
    name = nil,
    client = {},
    clientmenus = {},
    scheduler = nil,
    schedulerid = nil,
    debug = false,
    OuterRadius = 20000,  -- Doubled the size
    InnerRadius = 1000,  -- Doubled the size
    maxconvoys = 3,
    TargetRadius = 100,  -- Doubled the size
    countryid = nil,
    convoytemplate = nil,
    servicetemplate = nil,
    convoys = {},
    farpcounter = 0,
    beattime = 10,
    menuadded = {},
    MenuF10 = {},
    MenuF10Root = nil,
    topmenu = nil,
    startpoints = {},
    usestartpoints = false,
    userandompoint = false,
    useclosestpoint = false,
    addfarps = false,
    radios = {127.5, 125.25, 129.25}
}

function FARPCREATOR:New(name, prefix, convoytemplate, servicetemplate, countryid)
    local self = BASE:Inherit(self, BASE:New())
    self.name = name
    self.clients = SET_CLIENT:New():FilterPrefixes(prefix):FilterActive(true):FilterStart()
    self.OuterRadius = 20000
    self.InnerRadius = 1000
    self.maxconvoys = 3
    self.TargetRadius = 100
    self.countryid = countryid
    self.convoytemplate = convoytemplate
    self.servicetemplate = servicetemplate
    self.FarpHDG = 3.1764992386297
    self.convoys = {}
    self.farpcounter = 0
    self.beattime = 10
    self.menuadded = {}
    self.MenuF10 = {}
    self.MenuF10Root = nil
    self.topmenu = nil
    self.startpoints = {}
    self.usestartpoints = false
    BASE:E({self.name, "Created FARP"})
    return self
end

function FARPCREATOR:SetConvoyRadius(inner, outer, targetradius)
    self.InnerRadius = inner
    self.OuterRadius = outer
    self.TargetRadius = targetradius
    return self
end

function FARPCREATOR:AddStartPoint(_coord)
    table.insert(self.startpoints, _coord)
    return self
end

function FARPCREATOR:SetConvoySpeed(_speed)
    self.convoyspeed = _speed 
    return self
end

function FARPCREATOR:RemoveStartPoint(_coord)
    local _Temp = {}
    for k, v in pairs(self.startpoints) do
        if v ~= _coord then
            table.insert(_Temp, v)
        end
    end
    self.startpoints = _Temp
    return self
end

function FARPCREATOR:UseStartPoints(_val)
    self.usestartpoints = _val or true
    if self.debug == true then
        self:E({"Setusestartpoints to:", self.usestartpoints, _val})
    end
    return self
end

function FARPCREATOR:UseClosestPoint(_val)
    self.useclosestpoint = _val or true
    if self.debug == true then
        self:E({"UseClosestPoint to:", self.useclosestpoint, _val})
    end
end

function FARPCREATOR:AddFarpsToPoints(_val)
    self.addfarps = _val or true
    if self.debug == true then
        self:E({"Addfarps to:", self.addfarps, _val})
    end
end

function FARPCREATOR:CreateMenu(targetgroup, _client)
    local group = _client:GetGroup()
    local gid = group:GetID()
    if group and gid then
        if not self.menuadded[gid] then
            self.menuadded[gid] = true
            local _rootPath = missionCommands.addSubMenuForGroup(gid, "" .. self.name .. " Farp Control")
            local _spawn = missionCommands.addCommandForGroup(gid, "Farp Convoy Request", _rootPath, self.SpawnConvoy, self, _client)
        end
    end
end

function FARPCREATOR:MenuCreator()
    BASE:E({"self.name", "Menu Creator"})
    self.clients:ForEachClient(function(MooseClient)
        if MooseClient:GetGroup() ~= nil then
            local _group = MooseClient:GetGroup()
            self:CreateMenu(_group, MooseClient, self.topmenu)
        end
    end)
end

function FARPCREATOR:Start()
    BASE:E(self.name, "Farp Heartbeat should be starting with a beat time of ", self.beattime)
    if self.scheduler == nil then
        self.scheduler, self.schedulerid = SCHEDULER:New(nil, function() self:heartbeat() end, {}, 0, self.beattime)
    else
        self.scheduler:Start()
    end
    return self
end

function FARPCREATOR:Stop()
    BASE:E(self.name, "Farp Heartbeat should be stopping")
    if self.scheduler ~= nil then
        self.scheduler:Stop()
    else
        BASE:E({self.name, "Unable to stop as we don't have a scheduler to stop! Are we started?"})
    end
    return self
end

function FARPCREATOR:heartbeat()
    if self.debug == true then
        self:E({self.name, "Heart Beat"})
    end
    self:MenuCreator()
    self:CheckConvoys()
    if self.debug == true then
        self:E({self.name, "Heart Beat Complete"})
    end
end

function FARPCREATOR:SpawnConvoy(_client)
    if self.debug == true then
        self:E({self.name, "Spawn Convoy", self.farpcounter, self.maxconvoys, _client})
    end
    if self.farpcounter < self.maxconvoys then
        local cid = _client.ObjectName
        self:E({self.name, "CID", cid})
        if self.convoys[cid] == nil then
            self:E({self.name, "self.convoy[cid] was nil"})
            self:spawn(_client)
        else
            local temptable = self.convoys[cid]
            if temptable.FarpServiceConvoy:IsAlive() ~= true then
                self:spawn(_client)
            else
                MESSAGE:New("Unable to request new Convoy, last one is still alive", 60):ToClient(_client)
            end
        end
    else
        MESSAGE:New("Unable to request new convoy as maximum FARP count has been reached", 60):ToClient(_client)
        BASE:E({self.name, "Spawn Convoy Unable FARP Count Reached", self.farpcounter, self.maxconvoys})
    end
end

function FARPCREATOR:spawn(_client)
    local temptable = {}
    temptable.client = _client -- store our client object for easier use.
    local cid = _client.ObjectName -- get our client id
    local FARPLocationVect = _client:GetPointVec2()
    local FARPCoordinate = _client:GetCoordinate()
    temptable.FARPCoordinate = FARPCoordinate
    temptable.FARPLocationVect = FARPLocationVect
    if self.debug == true then
      BASE:E({"got Vec2",temptable.FARPLocationVect})
    end
    temptable.ConvoyAX = temptable.FARPLocationVect:GetX()
    temptable.ConvoyAY = temptable.FARPLocationVect:GetY()
    if self.debug == true then
      BASE:E({"got x and y",temptable.ConvoyAX,temptable.ConvoyAY})
    end
    temptable.FarpAX = temptable.ConvoyAX
    temptable.FarpAY = temptable.ConvoyAY
    if self.debug == true then
      BASE:E({"attempting to get Farp location"})
    end
    if self.usestartpoints == false then
        if self.debug == true then
            self:E({"Attempting to get based on vector rather than existing point", self.usestartpoints})
        end
        temptable.ConvoySpawn = FARPCoordinate:GetRandomCoordinateInRadius(self.OuterRadius, self.InnerRadius)
        local breakout = 0
        local validcoord = true
        while temptable.ConvoySpawn:GetSurfaceType() == 3 and breakout < 20 do
            BASE:E({self.name, "Got Coordinate terrain type was", temptable.ConvoySpawn:GetSurfaceType()})
            validcoord = false
            breakout = breakout + 1
            temptable.ConvoySpawn = FARPCoordinate:GetRandomCoordinateInRadius(self.OuterRadius, self.InnerRadius)
        end
        if validcoord == false then
            MESSAGE:New("We were unable to find a valid spawn coordinate in 50 attempts, Please try your request again", 60):ToClient(_client)
            BASE:E({self.name, "No Valid Coordinate terrain type was", temptable.ConvoySpawn:GetSurfaceType()})
            return false
        end
    else
        if self.debug == true then
            self:E({"Attempting to get based on an existing point rather than existing point", self.usestartpoints})
        end
        local ttable = self.startpoints
        if #ttable == 0 then
            self:E({"startpoint 1"})
            MESSAGE:New("We are unable to locate a valid start coordinate for your convoy", 60):ToClient(_client)
            self:E({"startpoint 2"})
            return false
        end
        
        if self.debug == true then
            self:E({"Past line 285"})
        end
        if self.userandompoint then
            if self.debug then
                self:E({"in use random point"})
            end
            local _tc = self.startpoints[math.random(#ttable)]
            temptable.ConvoySpawn = _tc
            self:E({"end use random point"})
        end
        if self.useclosestpoint then
            if self.debug == true then
                self:E({"Past line 300"})
            end
            local _tc = nil
            local _md = 99999999999999999

            for k, v in pairs(self.startpoints) do
                if self.debug == true then
                    self:E({"Past line 308", k, v})
                end

                local _d = FARPCoordinate:Get2DDistance(v)
                self:E({"Past line 312", k, v})
                if _d < _md then
                    _tc = v
                    _md = _d
                end
            end
            temptable.ConvoySpawn = _tc
        end
    end
    if self.debug == true then
        temptable.ConvoySpawn:SmokeBlue()
        BASE:E({"Got Coordinate terrain type was", temptable.ConvoySpawn:GetSurfaceType()})
        BASE:E({"attempting to spawn"})
    end
    if self.debug == true then
        BASE:E({"Template is:", self.convoytemplate})
    end
    temptable.FarpServiceConvoy = SPAWN:NewWithAlias(self.convoytemplate, "" .. self.name .. "_convoy_" .. cid .. ""):SpawnFromCoordinate(temptable.ConvoySpawn)
    if self.debug == true then
        BASE:E({"Spawned."})
    end
    temptable.FarpServiceConvoy:SetAIOn()
    temptable.FarpServiceConvoy:RouteToVec2(temptable.FARPLocationVect, 160, 1, "LowAltitude", 300)
    self.convoys[cid] = temptable
    MESSAGE:New("New FARP Convoy is enroute to your location", 60):ToClient(_client)
end

function FARPCREATOR:CheckConvoys()
    if self.debug == true then
        BASE:E({self.name, "Check Convoys"})
    end
    for k, v in pairs(self.convoys) do
        if v ~= nil then
            BASE:E({self.name, "Check Convoy", k, v})
            local temptable = v
            if temptable.FarpServiceConvoy:IsAlive() then
                local ServiceConvoyVec2 = temptable.FarpServiceConvoy:GetPointVec2()
                local Convoyhasarrived = ServiceConvoyVec2:IsInRadius(temptable.FARPLocationVect, self.TargetRadius)
                if Convoyhasarrived == true then
                    MESSAGE:New("Your FARP Convoy has arrived at its destination and is now setting up", 30):ToClient(temptable.client)
                    self:SpawnFarp(temptable, k)
                    temptable.FarpServiceConvoy:Destroy()
                    self.convoys[k] = nil
                end
            else
                temptable.FarpServiceConvoy:Destroy()
                MESSAGE:New("Your FARP Convoy was destroyed prior to reaching its destination. Protect it better next time", 60):ToClient(temptable.client)
                self.convoys[k] = nil
            end
        else
            BASE:E({self.name, "Check Convoy Warning, V was Nil! this shouldn't happen"})
        end
    end
end

function FARPCREATOR:SpawnFarp(temptable, cid)
    if self.debug == true then
        self:E({self.name, "Spawning Farp", self.farpcounter, temptable, cid})
    end
    self.farpcounter = self.farpcounter + 1
    MESSAGE:New("A FARP Convoy has arrived at its destination and is setting up a new FARP", 30):ToBlue()
    local vehiclevect = temptable.FARPCoordinate:Translate(40, 0)
    local SpawnServiceVehicles = SPAWN:NewWithAlias(self.servicetemplate, "FarpServiceVehicles" .. self.farpcounter):SpawnFromCoordinate(vehiclevect)
    self:SpawnStatic("Farp1_ComandPost_" .. self.farpcounter, "kp_ug", "Fortifications", "FARP CP Blindage", 100, (temptable.FarpAX - -46.022111867), (temptable.FarpAY - -9.20689690), (self.FarpHDG - 1.6057029118348))
    self:SpawnStatic("Farp1_Generator1_" .. self.farpcounter, "GeneratorF", "Fortifications", "GeneratorF", 100, (temptable.FarpAX - -7.522753786), (temptable.FarpAY - -37.85968299), (self.FarpHDG - 1.5358897417550))
    self:SpawnStatic("Farp1_Tent1_" .. self.farpcounter, "PalatkaB", "Fortifications", "FARP Tent", 50, (temptable.FarpAX - -42.785309231), (temptable.FarpAY - -9.12264485), (self.FarpHDG - 1.6057029118348))
    self:SpawnStatic("Farp1_CoveredAmmo1_" .. self.farpcounter, "SetkaKP", "Fortifications", "FARP Ammo Dump Coating", 50, (temptable.FarpAX - 35.293756408), (temptable.FarpAY - 57.35770154), (self.FarpHDG - 3.1590459461098))
    self:SpawnStatic("Farp1_Tent2_" .. self.farpcounter, "PalatkaB", "Fortifications", "FARP Tent", 50, (temptable.FarpAX - -49.432834216), (temptable.FarpAY - -9.14503574), (self.FarpHDG - 1.6057029118348))
    self:SpawnStatic("Farp1_Wsock1_" .. self.farpcounter, "H-Windsock_RW", "Fortifications", "Windsock", 3, (temptable.FarpAX - 43.70051151), (temptable.FarpAY - 2.35458818), (self.FarpHDG))
    self:SpawnStatic("Farp1_Tyre1_" .. self.farpcounter, "H-tyre_B_WF", "Fortifications", "Black_Tyre_WF", 3, (temptable.FarpAX - -9.52339492), (temptable.FarpAY - 41.91442888), (self.FarpHDG))
    self:SpawnStatic("Farp1_Tyre2_" .. self.farpcounter, "H-tyre_B_WF", "Fortifications", "Black_Tyre_WF", 3, (temptable.FarpAX - 26.51502196), (temptable.FarpAY - 13.74232991), (self.FarpHDG))
    self:SpawnStatic("Farp1_Tyre3_" .. self.farpcounter, "H-tyre_B_WF", "Fortifications", "Black_Tyre_WF", 3, (temptable.FarpAX - 26.27681096), (temptable.FarpAY - -22.30693542), (self.FarpHDG))
    self:SpawnStatic("Farp1_Tyre4_" .. self.farpcounter, "H-tyre_B_WF", "Fortifications", "Black_Tyre_WF", 3, (temptable.FarpAX - 44.69212731), (temptable.FarpAY - 27.50978001), (self.FarpHDG))
    self:SpawnStatic("Farp1_Tyre5_" .. self.farpcounter, "H-tyre_B_WF", "Fortifications", "Black_Tyre_WF", 3, (temptable.FarpAX - -9.37543603), (temptable.FarpAY - -7.37904581), (self.FarpHDG))
    self:SpawnStatic("Farp1_Tyre6_" .. self.farpcounter, "H-tyre_B_WF", "Fortifications", "Black_Tyre_WF", 3, (temptable.FarpAX - 26.19740729), (temptable.FarpAY - 27.55856816), (self.FarpHDG))
    self:SpawnStatic("Farp1_Tyre7_" .. self.farpcounter, "H-tyre_B_WF", "Fortifications", "Black_Tyre_WF", 3, (temptable.FarpAX - 8.41098563), (temptable.FarpAY - -7.37904581), (self.FarpHDG))
    self:SpawnStatic("Farp1_Tyre8_" .. self.farpcounter, "H-tyre_B_WF", "Fortifications", "Black_Tyre_WF", 3, (temptable.FarpAX - 8.07919727), (temptable.FarpAY - 41.59167618), (self.FarpHDG))
    self:SpawnStatic("Farp1_Tyre9_" .. self.farpcounter, "H-tyre_B_WF", "Fortifications", "Black_Tyre_WF", 3, (temptable.FarpAX - -9.37543603), (temptable.FarpAY - 27.71737550), (self.FarpHDG))
    self:SpawnStatic("Farp1_Tyre10_" .. self.farpcounter, "H-tyre_B_WF", "Fortifications", "Black_Tyre_WF", 3, (temptable.FarpAX - -9.21662870), (temptable.FarpAY - 7.15182545), (self.FarpHDG))
    self:SpawnStatic("Farp1_Tyre11_" .. self.farpcounter, "H-tyre_B_WF", "Fortifications", "Black_Tyre_WF", 3, (temptable.FarpAX - 44.77786563), (temptable.FarpAY - -8.33188983), (self.FarpHDG))
    self:SpawnStatic("Farp1_Tyre12_" .. self.farpcounter, "H-tyre_B_WF", "Fortifications", "Black_Tyre_WF", 3, (temptable.FarpAX - 9.87567332), (temptable.FarpAY - 17.86661589), (self.FarpHDG))
    self:SpawnStatic("Farp1_Tyre13_" .. self.farpcounter, "H-tyre_B_WF", "Fortifications", "Black_Tyre_WF", 3, (temptable.FarpAX - 26.19740729), (temptable.FarpAY - -8.17308250), (self.FarpHDG))
    self:SpawnStatic("Farp1_Tyre14_" .. self.farpcounter, "H-tyre_B_WF", "Fortifications", "Black_Tyre_WF", 3, (temptable.FarpAX - 8.31389554), (temptable.FarpAY - 7.09103057), (self.FarpHDG))
    self:SpawnStatic("Farp1_Tyre15_" .. self.farpcounter, "H-tyre_B_WF", "Fortifications", "Black_Tyre_WF", 3, (temptable.FarpAX - 8.41098563), (temptable.FarpAY - 27.63797183), (self.FarpHDG))
    self:SpawnStatic("Farp1_Tyre16_" .. self.farpcounter, "H-tyre_B_WF", "Fortifications", "Black_Tyre_WF", 3, (temptable.FarpAX - 44.61905829), (temptable.FarpAY - 13.74232991), (self.FarpHDG))
    self:SpawnStatic("Farp1_Tyre17_" .. self.farpcounter, "H-tyre_B_WF", "Fortifications", "Black_Tyre_WF", 3, (temptable.FarpAX - 43.93118389), (temptable.FarpAY - -22.67033198), (self.FarpHDG))
    self:SpawnFarpBuilding("Farp_Heliport_" .. self.farpcounter, "invisiblefarp", "Heliports", "Invisible FARP", self.radios[self.farpcounter], 0, self.farpcounter, (temptable.FarpAX - 0.00000000), (temptable.FarpAY - 0.00000000), (self.FarpHDG))
    if self.addfarps == true then
        self:AddStartPoint(temptable.FARPCoordinate)
    end
    self:E({self.name, "Spawned Farp", self.farpcounter})
end

function FARPCREATOR:SpawnFarpBuilding(_name, _shape, _cat, _type, _radio, _modulation, _callsign, _x, _y, _heading)
    local staticObj = {
        ["name"] = _name,
        ["category"] = _cat,
        ["shape_name"] = _shape,
        ["type"] = _type,
        ["heliport_frequency"] = _radio,
        ["x"] = _x,
        ["y"] = _y,
        ["heliport_modulation"] = _modulation,
        ["heliport_callsign_id"] = _callsign,
        ["heading"] = _heading,
        ["groupId"] = 1,
        ["unitId"] = 1,
        ["dead"] = false,
    }
    coalition.addStaticObject(self.countryid, staticObj)
end

function FARPCREATOR:SpawnStatic(_name, _shape, _cat, _type, _rate, _x, _y, _heading)
    local staticObj = {
        ["name"] = _name,
        ["category"] = _cat,
        ["shape_name"] = _shape,
        ["type"] = _type,
        ["rate"] = _rate,
        ["x"] = _x,
        ["y"] = _y,
        ["heading"] = _heading,
        ["groupId"] = 1,
        ["unitId"] = 1,
        ["dead"] = false,
    }
    coalition.addStaticObject(self.countryid, staticObj)
end
