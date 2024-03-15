local Entity = {}

function Entity.new(asset, tweenDuration, canEntityKill, delay, backwards)
    local object = game:GetObjects(asset)[1]
    local part = object.PrimaryPart
    local rooms = workspace.CurrentRooms:GetChildren()
    local ts = game:GetService("TweenService")

    local currentRoomIndex = nil

    if backwards then
        currentRoomIndex = #rooms
        part.CFrame = rooms[currentRoomIndex].Door.PrimaryPart.CFrame
    else
        currentRoomIndex = 1
        part.CFrame = rooms[currentRoomIndex].PrimaryPart.CFrame
    end

    object.Parent = workspace

    local tweenInfo = TweenInfo.new(
        tweenDuration,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out,
        0,
        false,
        0
    )

    local function createAndPlayTween()
        local pathfindNodes = rooms[currentRoomIndex].PathfindNodes:GetChildren()
        local tweenChain = {}

        for i, node in ipairs(pathfindNodes) do
            -- Adjusting the Y component of the node's CFrame
            local nodeCFrame = node.CFrame + Vector3.new(0, 2, 0)
            
            local nodeTween = ts:Create(part, tweenInfo, {CFrame = nodeCFrame})
            table.insert(tweenChain, nodeTween)
        end

        local primaryPartTween = ts:Create(part, tweenInfo, {CFrame = rooms[currentRoomIndex].PrimaryPart.CFrame})
        table.insert(tweenChain, primaryPartTween)

        for i, tween in ipairs(tweenChain) do
            tween:Play()
            if i < #tweenChain then
                tween.Completed:Wait()
            end
        end

        local nextroomindex = backwards and currentRoomIndex - 1 or currentRoomIndex + 1

        if (not backwards and nextroomindex >= #rooms) or (backwards and nextroomindex <= 0) then
            object:Destroy()
        else
            currentRoomIndex = nextroomindex
            createAndPlayTween()
        end
    end

    task.wait(delay)

    if not backwards then
        createAndPlayTween()
    else
        local backwardstween = ts:Create(part, tweenInfo, {CFrame = rooms[#rooms].PrimaryPart.CFrame})
        backwardstween:Play()
        backwardstween.Completed:Connect(function()
            createAndPlayTween()
        end)
    end

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
