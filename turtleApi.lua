local t = turtle

local facing = 0
local position = {}

function setFace(face) facing = face end

function getPos()
	print("X:"..position[0].." Y:"..position[1].." Z:"..position[2])
end

function setPos(x,y,z)
	position[0] = x 
	position[1] = y 
	position[2] = z 
end

function rotate(face)
	while face ~= facing do
		if face == ((facing-1)%4) then
			t.turnLeft()
			facing = ((facing-1)%4)
		else
			t.turnRight()
			facing = ((facing+1)%4)
		end
	end
	facing = face
end

function forward()
	t.forward()
	if facing==0 then position[1] = position[1]+1
	elseif facing==1 then position[0] = position[0]+1
	elseif facing==2 then position[1] = position[1]-1
	elseif facing==3 then position[0] = position[0]-1
	end
end

function move(dir, force) -- force: if TRUE remove whats blocking
	if dir>5 then return print("No such direction") end
	if dir<4 then -- 0:fwd ||| 1: right ||| 2: back ||| 3:left
		rotate(dir)
		if check(1)==false then
			forward()
		else -- item in front
			if force then
				t.dig()
				t.attack()
				move(dir, force)
			else
				return false -- no can go
			end
		end
	elseif dir==4 then -- UP
		if check(0)~=false then -- item in front
			if force then
				t.digUp()
				t.attackUp()
				move(dir, force)
			else
				return false -- no can go
			end
		else
			t.up()
			position[2] = position[2]+1	
		end
	elseif dir==5 then -- DOWN
		if check(2)~=false then -- item in front
			if force then
				t.digDown()
				t.attackDown()
				move(dir, force)
			else
				return false -- no can go
			end
		else
			t.down()
			position[2] = position[2]-1	
		end
	end
	return true

end

function check(actionDir) -- 0=up 1=front 2=down
	local success, data = false, false
	if actionDir==0 then success, data = t.inspectUp()
	elseif actionDir==1 then success, data =  t.inspect()
	elseif actionDir==2 then success, data =  t.inspectDown()
	end
	if success==false then data = false end
	return data
end

function goto(x, y, z, force)

	local function moveX()
		if x==position[0] then return false
		elseif x>position[0] then
			return move(1, force)
		else
			return move(3, force)
		end
	end
	
	local function moveY()
		if y==position[1] then return false
		elseif y>position[1] then
			return move(0, force)
		else
			return move(2, force)
		end
	end
	
	local function moveZ()
		if z==position[2] then return false
		elseif z>position[2] then
			return move(4, force)
		else
			return move(5, force)
		end
	end
	
	local falseCnt = 0
	while (x~=position[0] or y~=position[1] or z~=position[2]) do
		while moveX()==true do end
		while moveY()==true do end
		while moveZ()==true do end
		while moveY()==true do end
		while moveZ()==true do end
		while moveX()==true do end

		if falseCnt>15 then return print("no can do!") end
		falseCnt = falseCnt+1
	end
end

function moveFlat(dir)
	while move(5)~=false do t.attack() end
	while move(dir)==false do
		t.attack()
		move(4)
	end
	t.attack()
end


function spiralOut(size, force)
	if size%2==0 then
		print("size must be non-divideable by 2\n Increase size by one.")
		size = size + 1
	end
	goto(0, math.floor(size/2), position[2], true)
	local sideLen = 0
	local sideSwitch = 0
	
	
	while sideLen<size-1 do -- circle from inner to outer
		for len=0, sideLen do
			move(0+sideSwitch*2, true)
		end
		for len=0, sideLen do
			move(1+sideSwitch*2, true)
		end
		sideSwitch = 1-sideSwitch
		sideLen = sideLen + 1
	end
	
	for len=0, sideLen-1 do
		move(0+sideSwitch*2, true)
	end
	for len=0, sideLen-1 do
		move(1+sideSwitch*2, true)
	end

end
-- setup --
setPos(0,0,0)


function digForward() -- dig 3x3 in front of robot
	for y=0, 1 do
		move(0, true)	move(4, true)	move(3, true)	move(5, true)
		move(5, true)	move(1, true)	move(1, true)	move(4, true)
		move(4, true)	move(3, true)	move(5, true)
	end
end

function digDown(size, depth)
	for d=0, depth-1 do
		move(5, true)
		spiralOut(size, true)
	end
end

-- TODO item & equip functions

digDown(5, 2)

goto(0,0,0, false)
rotate(0)
