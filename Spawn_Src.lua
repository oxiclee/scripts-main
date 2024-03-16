function Entity.new(asset, tweenDuration, canEntityKill, delay, backwards)
    local object = game:GetObjects(asset)[1]
    local part = object.PrimaryPart
    local rooms = workspace.CurrentRooms:GetChildren()

    local currentRoomIndex = nil

    if backwards then
        currentRoomIndex = #rooms
        part.CFrame = rooms[currentRoomIndex].Door.PrimaryPart.CFrame
    else
        currentRoomIndex = 1
        part.CFrame = rooms[currentRoomIndex].PrimaryPart.CFrame
    end

    object.Parent = workspace

    local function createAndPlayTween()
        local nodes = rooms[currentRoomIndex].PathfindNodes:GetChildren()

        local nextroomindex = nil

        if not backwards then
            nextroomindex = currentRoomIndex + 1
        else
            nextroomindex = currentRoomIndex - 1
        end

        for i, node in ipairs(nodes) do
            local targetCFrame = node.CFrame + Vector3.new(0, 2, 0)
            local startTime = tick()
            local elapsedTime = 0

            while elapsedTime < tweenDuration do
                local alpha = math.min(1, elapsedTime / tweenDuration)
                part.CFrame = part.CFrame:lerp(targetCFrame, alpha)
                elapsedTime = tick() - startTime
                task.wait() 
            end
        end

        if (not backwards and nextroomindex > #rooms) or (backwards and nextroomindex < 1) then
            object:Destroy()
        else
            currentRoomIndex = nextroomindex
            createAndPlayTween()
        end
    end

    task.wait(delay)
    createAndPlayTween()

    part.Touched:Connect(function(otherpart)
        if otherpart.Parent == game:GetService("Players").LocalPlayer.Character then
            if canEntityKill then
                game:GetService("Players").LocalPlayer.Character.Humanoid.Health = 0
            else
                print("cannot kill")
            end
        end
    end)
end

return Entity
