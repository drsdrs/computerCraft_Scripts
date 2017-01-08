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
	if dir<4 then -- 0:fwd ||| 1: right ||| 2: back ||| 3:left
		rotate(dir)
		if check(1)==false then
			forward()
		else -- item in front
			if force then t.dig() t.attack() forward()
			else return false -- no can go
			end
		end
	elseif dir==4 then -- UP
		if check(0)~=false then
			if force then
				t.digUp()
				t.attackUp()
			else
				return false -- no can go
			end
		end
		t.up()
		position[2] = position[2]+1	
	
	elseif dir==5 then -- DOWN
		if check(2)~=false then
			if force then
				t.digDown()
				t.attackDown()
			else
				return false -- no can go
			end
		end
		t.down()
		position[2] = position[2]-1	
	end
	return true
	-- if item blocks and force==FALSE then return false

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
		while moveX()==true do getPos() end
		while moveY()==true do getPos() end
		while moveZ()==true do print(moveZ()) end
		if falseCnt>50 then return print("no can do!") end
		falseCnt = falseCnt+1
	end
	
	print(x~=position[0], " ",y~=position[1]," " , z~=position[2]) 
	return x.." - "..y.." - "..z
end

function moveFlat(dir)
	while move(3)~=false do end
end

-- setup --
setPos(0,0,0)


//print(goto(20,20,0, true))
//rotate(0)

moveFlat()

