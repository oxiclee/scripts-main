local module = {}

module.Generate = function(vmodel, vspeed, vbackwards, vkillradius, vdelay, vdata, vspawnfunction, voffset)
	--config

	local part = vmodel.PrimaryPart
	local speed = vspeed
	local backwards = vbackwards
	local _delay = vdelay
	local rebounddata = vdata
	
	local spawnfunction = vspawnfunction 

	local offset = voffset

	--setup
	local ts = game:GetService("TweenService")
	local trueoffset = Vector3.new(0, offset, 0)
	local nodes = workspace.NODES:GetChildren()
	local startindex

	if not backwards then
		startindex = 1
	else
		startindex = #nodes
	end
	
	local function kill()
		while true and task.wait(0.1) do
			local players = game:GetService("Players"):GetPlayers()
			for _, player in ipairs(players) do
				if player.Character and player.Character.HumanoidRootPart then
					local distance = (part.Position - player.Character.HumanoidRootPart.Position).Magnitude
					if distance <= vkillradius then
						player.Character.Humanoid.Health = 0
					end
				end
			end
		end
	end
	
	task.spawn(kill)





	--tween
	part:PivotTo(nodes[startindex].CFrame + trueoffset)    
	spawnfunction()
	task.wait(_delay)

	if not backwards then	

		if not rebounddata.Rebounds then

			for nextindex = startindex, #nodes do

				local node = nodes[nextindex]

				local h = game.TweenService:Create(part, TweenInfo.new((part.Position - node.Position).Magnitude / speed, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false), {CFrame = node.CFrame + trueoffset})

				h:Play()

				local playbackState = h.Completed:Wait()

			end

		else

			local reboundnum = math.random(rebounddata.ReboundMin, rebounddata.ReboundMax)

			for i = 1, reboundnum do

				for nextindex = startindex, #nodes do

					local node = nodes[nextindex]

					local h = game.TweenService:Create(part, TweenInfo.new((part.Position - node.Position).Magnitude / speed, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false), {CFrame = node.CFrame + trueoffset})

					h:Play()

					local playbackState = h.Completed:Wait()

				end

				task.wait(rebounddata.ReboundDelay)

				for nextindex = #nodes, 1, -1 do
					local node = nodes[nextindex]

					local h = game.TweenService:Create(part, TweenInfo.new((part.Position - node.Position).Magnitude / speed, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false), {CFrame = node.CFrame + trueoffset})

					h:Play()

					local playbackState = h.Completed:Wait()

				end

				task.wait(rebounddata.ReboundDelay)

			end
		end



	else

		if not rebounddata.Rebounds then

			for nextindex = #nodes, 1, -1 do
				local node = nodes[nextindex]

				local h = game.TweenService:Create(part, TweenInfo.new((part.Position - node.Position).Magnitude / speed, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false), {CFrame = node.CFrame + trueoffset})

				h:Play()

				local playbackState = h.Completed:Wait()

			end

		else

			local reboundnum = math.random(rebounddata.ReboundMin, rebounddata.ReboundMax)

			for i = 1, reboundnum do

				for nextindex = #nodes, 1, -1 do

					local node = nodes[nextindex]

					local h = game.TweenService:Create(part, TweenInfo.new((part.Position - node.Position).Magnitude / speed, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false), {CFrame = node.CFrame + trueoffset})

					h:Play()

					local playbackState = h.Completed:Wait()

				end

				task.wait(rebounddata.ReboundDelay)

				for nextindex = 1, #nodes do

					local node = nodes[nextindex]

					local h = game.TweenService:Create(part, TweenInfo.new((part.Position - node.Position).Magnitude / speed, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false), {CFrame = node.CFrame + trueoffset})

					h:Play()

					local playbackState = h.Completed:Wait()

				end

				task.wait(rebounddata.ReboundDelay)

			end

		end

	end


	print("done!")
	part.CanCollide = false
	part.Anchored = false
	task.wait(2)
	vmodel:Destroy()
end

return module
