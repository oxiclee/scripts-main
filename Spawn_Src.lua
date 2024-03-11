local Entity = {}

function Entity.new(asset, tweenDuration, canEntityKill, delay, backwards)
    local object = game:GetObjects(asset)[1]
    local part = object.PrimaryPart
    local rooms = workspace.CurrentRooms:GetChildren()
    local ts = game:GetService("TweenService")

    local currentRoomIndex = backwards and #rooms or 1

    object.Parent = workspace

    local tweenInfo = TweenInfo.new(
        tweenDuration,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out,
        0,
        false,
        0
    )

    local function createAndPlayTween(targetIndex)
        local nextRoomIndex = targetIndex or currentRoomIndex

        local nextRoomCFrame = rooms[nextRoomIndex].PrimaryPart.CFrame

        local tween = ts:Create(part, tweenInfo, { CFrame = nextRoomCFrame })
        tween:Play()

        currentRoomIndex = nextRoomIndex

        if (backwards and nextRoomIndex == #rooms) or (not backwards and nextRoomIndex == 1) then
            object:Destroy()
        else
            tween.Completed:Connect(function()
                if backwards and nextRoomIndex == #rooms then
                    createAndPlayTween(1)
                else
                    createAndPlayTween((nextRoomIndex % #rooms) + 1)
                end
            end)
        end
    end

    if backwards then
        local lastRoomIndex = #rooms
        local lastRoomCFrame = rooms[lastRoomIndex].PrimaryPart.CFrame
        local tweenToLastRoom = ts:Create(part, tweenInfo, { CFrame = lastRoomCFrame })
        tweenToLastRoom:Play()
        tweenToLastRoom.Completed:Connect(function()
            createAndPlayTween(lastRoomIndex)
        end)
    else
        part.CFrame = rooms[currentRoomIndex].PrimaryPart.CFrame
        task.wait(delay)
        createAndPlayTween()
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
