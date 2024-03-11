local Entity = {}

function Entity.new(asset, tweenDuration, canEntityKill, delay, backwards)
    local object = game:GetObjects(asset)[1]
    local part = object.PrimaryPart
    local rooms = workspace.CurrentRooms:GetChildren()
    local ts = game:GetService("TweenService")

    local currentRoomIndex = backwards and #rooms or 1

    object.Parent = workspace
    if not backwards then
        part.CFrame = rooms[currentRoomIndex].PrimaryPart.CFrame
    else
        part.CFrame = rooms[#rooms].Door.PrimaryPart.CFrame
    end

    local tweenInfo = TweenInfo.new(
        tweenDuration,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out,
        0,
        false,
        0
    )

    local function createAndPlayTween()
        local nextRoomIndex

        if backwards then
            if currentRoomIndex == #rooms then
                nextRoomIndex = #rooms
            else
                nextRoomIndex = currentRoomIndex > 1 and currentRoomIndex - 1 or #rooms
            end
        else
            nextRoomIndex = currentRoomIndex % #rooms + 1
        end

        local nextRoomCFrame

        if backwards and currentRoomIndex == #rooms then
            nextRoomCFrame = rooms[currentRoomIndex].PrimaryPart.CFrame
        else
            nextRoomCFrame = rooms[nextRoomIndex].PrimaryPart.CFrame
        end

        local tween = ts:Create(part, tweenInfo, { CFrame = nextRoomCFrame })
        tween:Play()

        currentRoomIndex = nextRoomIndex

        if backwards and nextRoomIndex == 1 then
            object:Destroy()
        else
            tween.Completed:Connect(createAndPlayTween)
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
                return
            end
        end
    end)
end

return Entity
