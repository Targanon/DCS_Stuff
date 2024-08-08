--_starter2.lua
-- Syria Mission Files Location skynet-iads-compiled.lua


local PATH = debug.getinfo(1).source
SOURCEPATH = "C:\\test\\"
local startPath = "C:\\Users\\"
if(string.sub(PATH,1,string.len(startPath)) == startPath) then 
	local windowsname = string.sub(PATH,string.len(startPath)+1,string.len(PATH))
	local i , j = string.find(windowsname,"\\")
	windowsname = string.sub(windowsname,1, i)
	local scriptPath = startPath .. windowsname .. "Saved Games\\Missions\\Targs_Missions\\Syria_Devistation\\Scripts\\"; -- Saved Games\\Missions\\Syria_Early_Strike\\Scripts\\
		SOURCEPATH = string.gsub(scriptPath,"\\","/")

end;
trigger.action.outText(string.format("Execute PATH: %s", PATH), 5); 
trigger.action.outText(string.format("SOURCE SCRIPT PATH set to: %s", SOURCEPATH), 5);


assert(loadfile(SOURCEPATH .. "_loader.lua"))()