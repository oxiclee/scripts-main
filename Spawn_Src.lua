local Entity = {}

function Entity.new(asset, tweenDuration, canEntityKill, delay, backwards, rebound)
    local object = game:GetObjects(asset)[1]
    local part = object.PrimaryPart
    local rooms = workspace.CurrentRooms:GetChildren()
    local ts = game:GetService("TweenService")

    local currentRoomIndex = backwards and #rooms or 1

    object.Parent = workspace

    part.CFrame = (backwards and rooms[#rooms].Door.PrimaryPart or rooms[currentRoomIndex].PrimaryPart).CFrame

    local tweenInfo = TweenInfo.new(
        tweenDuration,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out,
        0,
        false,
        0
    )

    local function createAndPlayTween(nextRoomIndex, onRebound)
        local nextRoomCFrame = rooms[nextRoomIndex].PrimaryPart.CFrame

        local tween = ts:Create(part, tweenInfo, { CFrame = nextRoomCFrame })
        tween:Play()

        currentRoomIndex = nextRoomIndex

        local isLastRoom = (backwards and currentRoomIndex == 1) or (not backwards and currentRoomIndex == #rooms)

        if isLastRoom and rebound then
            onRebound()
        elseif isLastRoom then
            object:Destroy()
        else
            tween.Completed:Connect(function()
                local nextIndex = (backwards and currentRoomIndex > 1) and currentRoomIndex - 1 or (not backwards and currentRoomIndex % #rooms + 1) or #rooms
                createAndPlayTween(nextIndex, onRebound)
            end)
        end
    end

    task.wait(delay)

    local function reboundEntity()
        backwards = not backwards
        currentRoomIndex = backwards and #rooms or 1
        createAndPlayTween(currentRoomIndex, reboundEntity)
    end

    if backwards then
        local backwardstween = ts:Create(part, tweenInfo, {CFrame = rooms[#rooms].PrimaryPart.CFrame})
        backwardstween:Play()
        backwardstween.Completed:Connect(function()
            createAndPlayTween(currentRoomIndex, reboundEntity)
        end)
    else
        createAndPlayTween(currentRoomIndex, reboundEntity)
    end

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
