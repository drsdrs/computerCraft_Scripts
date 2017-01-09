print("Load turtleApi: ", os.loadAPI("turtleApi"))

local menuItems = {
	"bla", "bleee",
	"2bla", "3bleee",
	"2bla", "3bleee"
}

local menuLength = 6

local width,height = term.getSize()

function showPosRot()
	term.setTextColor(colors.yellow)
	term.setCursorPos(width-5, 1)
	term.write("X:"..turtleApi.position[0].."  ")
	term.setCursorPos(width-5, 2)
	term.write("Y:"..turtleApi.position[1].."  ")
	term.setCursorPos(width-5, 3)
	term.write("Z:"..turtleApi.position[2].."  ")
end



for x=1, width do
	for y=1, height do
		paintutils.drawPixel(x,y,colors.green)
	end
end

term.setBackgroundColor(colors.green)
term.setTextColor(colors.black)


for row=0, menuLength do
	term.setCursorPos(1,row)
	term.write(row..": "..tostring(menuItems[row]))
end

showPosRot()

while true do
  local evt, key = os.pullEvent("key")
	term.setCursorPos(1,height-1)
	term.write(": "..(key-1).."   ")
end
