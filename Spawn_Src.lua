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

    local function createAndPlayTween()
        local nextRoomIndex = (backwards and currentRoomIndex > 1) and currentRoomIndex - 1 or (not backwards and currentRoomIndex % #rooms + 1) or #rooms

        local nextRoomCFrame = rooms[nextRoomIndex].PrimaryPart.CFrame

        local tween = ts:Create(part, tweenInfo, { CFrame = nextRoomCFrame })
        tween:Play()

        currentRoomIndex = nextRoomIndex

        local isLastRoom = (backwards and nextRoomIndex == #rooms) or (not backwards and nextRoomIndex == 1)

        if isLastRoom and rebound then
            backwards = not backwards
            createAndPlayTween()
        elseif isLastRoom then
            object:Destroy()
        else
            tween.Completed:Connect(createAndPlayTween)
        end
    end

    task.wait(delay)

    if backwards then
        ts:Create(part, tweenInfo, {CFrame = rooms[#rooms].PrimaryPart.CFrame}):Play():Connect(function()
                createAndPlayTween()
            end)
    else
        createAndPlayTween()
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
