local Entity = {}

function Entity.new(asset, lerpDuration, canEntityKill, delay, backwards)
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

    local function createAndPlayLerp()
        local nodes = rooms[currentRoomIndex].PathfindNodes:GetChildren()

        local nextroomindex = nil

        if not backwards then
            nextroomindex = currentRoomIndex + 1
        else
            nextroomindex = currentRoomIndex - 1
        end

        local nextNodeIndex = 1

        local function lerpToNextNode()
            local targetCF = nodes[nextNodeIndex].CFrame + Vector3.new(0, 2, 0)
            local startTime = tick()
            local endTime = startTime + lerpDuration

            while tick() < endTime do
                local alpha = (tick() - startTime) / lerpDuration
                part.CFrame = CFrame.new(part.Position:Lerp(targetCF.Position, alpha), targetCF.LookVector)
                task.wait()
            end

            nextNodeIndex = nextNodeIndex + 1
        end

        while nextNodeIndex <= #nodes do
            lerpToNextNode()
        end

        if (not backwards and nextroomindex > #rooms) or (backwards and nextroomindex < 1) then
            object:Destroy()
        else
            currentRoomIndex = nextroomindex
            createAndPlayLerp()
        end
    end

    task.wait(delay)

    createAndPlayLerp()

    part.Touched:Connect(function(otherpart)
        if otherpart.Parent == game:GetService("Players").LocalPlayer.Character then
            if canEntityKill then
                game:GetService("Players").LocalPlayer.Character.Humanoid.Health = 0
            else
                print("cannot kill")
                return
            end
        end
    end)
end

return Entity
