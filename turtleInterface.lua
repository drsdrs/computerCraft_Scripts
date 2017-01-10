print("Load turtleApi: ", os.loadAPI("turtleApi"))
local T = turtleApi

local menuItems = {
	"setPos: x,y,z        	   |     ",
	"setRotation: rotation	   |     ",
	"goto: x,y,z,force    	   |     ",
	"digFwd3x3: length        |     ",
	"digDwn: size,depth       |     ",
}

local menuLength = 5

local width,height = term.getSize()

function showPosRot()
	term.setCursorPos(width-5, 1)
	term.write("X:"..T.position[0].."   ")
	term.setCursorPos(width-5, 2)
	term.write("Y:"..T.position[1].."   ")
	term.setCursorPos(width-5, 3)
	term.write("Z:"..T.position[2].."   ")
	term.setCursorPos(width-5, 4)
	term.write("R:"..T.getRotation().."   ")
end

function showMenuItems()
	for row=0, menuLength do
		term.setCursorPos(1,row)
		term.write(row.."="..tostring(menuItems[row]))
	end
	term.setCursorPos(1,menuLength+1)
	term.write("---------------------------------------------")

end

function waitForCommand()
	local command = read()
	local splited = split(command, " ")
	if tablelength(splited)<2 then return print("Input error") end
	local args = split(splited[2], ",")
	if tablelength(args)<1 then return print("Input error") end
	local funct = tonumber(splited[1])
	if args[4]=="true" then args[4]=true else args[4]=false end
	excecuteCommand(funct,tonumber(args[1]),tonumber(args[2]),tonumber(args[3]),args[4])
end

function show(text)
	term.setCursorPos(1, height)
	term.write(text)
end

function excecuteCommand(cmd, arg0, arg1, arg2, arg3)
	if cmd==1 then T.setPos(arg0, arg1, arg2)
	elseif cmd==2 then T.setRotation(arg0)
	elseif cmd==3 then T.goto(arg0, arg1, arg2, arg3)
	elseif cmd==4 then T.dig3x3(arg0)
	elseif cmd==5 then T.digDown(arg0, arg1)
	end
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function split(str, pat)
   local t = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
	 table.insert(t,cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return t
end

term.clear()

while true do
	showMenuItems()
	showPosRot()
	term.setCursorPos(1,height)
	waitForCommand()

end
