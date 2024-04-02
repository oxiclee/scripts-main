--config

local part = script.Parent
local speed = 60
local backwards = true
local _delay = 5
local rebounddata = {
	["Rebounds"] = true,
	["ReboundMax"] = 8,
	["ReboundMin"] = 2,
	["ReboundDelay"] = 2
}

local functions = {
	["SpawnFunction"] = function()
		return
	end,
	["DespawnFunction"] = function()
		return
	end,
}


local killradius = 100

local offset = 4

--setup
local ts = game:GetService("TweenService")
local trueoffset = Vector3.new(0, offset, 0)
local rooms = workspace.CurrentRooms:GetChildren()


local function kill()
	
	while true and task.wait(0.1) do
		
		local players = game:GetService("Players"):GetPlayers()
		
		for _, player in ipairs(players) do
			
			if player.Character and player.Character.HumanoidRootPart then
				
				local distance = (part.Position - player.Character.HumanoidRootPart.Position).Magnitude
				
				if distance <= killradius and player.Character:GetAttribute("Hiding") == false then
					
					player.Character.Humanoid.Health = 0
					
				end
				
			end
			
		end
		
	end
	
end

task.spawn(kill)





--tween

--pivot

if not backwards then
	part:PivotTo(rooms[1]:FindFirstChild("PathfindNodes")[1].CFrame + trueoffset)    
else
	local s = rooms[#rooms]
	local pf = s:FindFirstChild("PathfindNodes"):GetChildren()
	part:PivotTo(pf[#pf].CFrame + trueoffset)
end

--spawn, delay

task.spawn(functions["SpawnFunction"])
task.wait(_delay)

--LOGIC DONT TOUCH UNLESS BUILDING FROM GROUND UP

if not backwards then	
	
	if not rebounddata.Rebounds then
		
		for room = 1, #rooms do
			print("Entity entered room:"..tonumber(room + rooms[1].Name - 1))

			for node = 1, #rooms[room]:FindFirstChild("PathfindNodes"):GetChildren() do

				local h = game.TweenService:Create(part, TweenInfo.new((part.Position - rooms[room].PathfindNodes[node].Position).Magnitude / speed, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false), {CFrame = rooms[room].PathfindNodes[node].CFrame + trueoffset})

				h:Play()

				local playbackState = h.Completed:Wait()
				
			end
		end
	else
		
		local reboundnum = math.random(rebounddata.ReboundMin, rebounddata.ReboundMax)
		
		for i = 1, reboundnum do

			for room = 1, #rooms do
				print("Entity entered room:"..tonumber(room + rooms[1].Name - 1))

				for node = 1, #rooms[room]:FindFirstChild("PathfindNodes"):GetChildren() do

					local h = game.TweenService:Create(part, TweenInfo.new((part.Position - rooms[room].PathfindNodes[node].Position).Magnitude / speed, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false), {CFrame = rooms[room].PathfindNodes[node].CFrame + trueoffset})

					h:Play()

					local playbackState = h.Completed:Wait()

				end
			end
			
			task.wait(rebounddata.ReboundDelay)
			
			for room = #rooms, 1, -1 do
				print("Entity entered room:"..tonumber(room + rooms[1].Name - 1))

				for node = #rooms[room]:FindFirstChild("PathfindNodes"):GetChildren(), 1, -1 do

					local h = game.TweenService:Create(part, TweenInfo.new((part.Position - rooms[room].PathfindNodes[node].Position).Magnitude / speed, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false), {CFrame = rooms[room].PathfindNodes[node].CFrame + trueoffset})

					h:Play()

					local playbackState = h.Completed:Wait()

				end
			end
			
			task.wait(rebounddata.ReboundDelay)
			
		end
	end
	
	
	
else
	
	if not rebounddata.Rebounds then
		
		for room = #rooms, 1, -1 do
			print("Entity entered room:"..tonumber(room + rooms[1].Name - 1))

			for node = #rooms[room]:FindFirstChild("PathfindNodes"):GetChildren(), 1, -1 do

				local h = game.TweenService:Create(part, TweenInfo.new((part.Position - rooms[room].PathfindNodes[node].Position).Magnitude / speed, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false), {CFrame = rooms[room].PathfindNodes[node].CFrame + trueoffset})

				h:Play()

				local playbackState = h.Completed:Wait()

			end
		end
		
	else
		
		local reboundnum = math.random(rebounddata.ReboundMin, rebounddata.ReboundMax)

		for i = 1, reboundnum do

			for room = #rooms, 1, -1 do
				print("Entity entered room:"..tonumber(room + rooms[1].Name - 1))

				for node = #rooms[room]:FindFirstChild("PathfindNodes"):GetChildren(), 1, -1 do

					local h = game.TweenService:Create(part, TweenInfo.new((part.Position - rooms[room].PathfindNodes[node].Position).Magnitude / speed, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false), {CFrame = rooms[room].PathfindNodes[node].CFrame + trueoffset})

					h:Play()

					local playbackState = h.Completed:Wait()

				end
			end

			task.wait(rebounddata.ReboundDelay)

			for room = 1, #rooms do
				print("Entity entered room:"..tonumber(room + rooms[1].Name - 1))

				for node = 1, #rooms[room]:FindFirstChild("PathfindNodes"):GetChildren() do

					local h = game.TweenService:Create(part, TweenInfo.new((part.Position - rooms[room].PathfindNodes[node].Position).Magnitude / speed, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false), {CFrame = rooms[room].PathfindNodes[node].CFrame + trueoffset})

					h:Play()

					local playbackState = h.Completed:Wait()

				end
			end

			task.wait(rebounddata.ReboundDelay)
			
		end
		
	end
	
end


print("done!")

task.spawn(functions["DespawnFunction"])

part.CanCollide = false

part.Anchored = false

task.wait(2)

script.Parent:Destroy()
