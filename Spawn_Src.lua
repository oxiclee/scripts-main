local Entity = {}

function Entity.new(assetId, tweenDuration, canEntityKill)
    local object = game:GetObjects("rbxassetid://" .. assetId)[1]
    local part = object.PrimaryPart
    local rooms = workspace.CurrentRooms:GetChildren()
    local ts = game:GetService("TweenService")

    local currentRoomIndex = 1

    object.Parent = workspace
    part.CFrame = rooms[currentRoomIndex].PrimaryPart.CFrame

    local tweenInfo = TweenInfo.new(
        tweenDuration/100,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out,
        0,
        false,
        0
    )

    local function createAndPlayTween()
        local nextRoomIndex = currentRoomIndex % #rooms + 1
        local nextRoomCFrame = rooms[nextRoomIndex].PrimaryPart.CFrame

        local tween = ts:Create(part, tweenInfo, { CFrame = nextRoomCFrame })
        tween:Play()

        currentRoomIndex = nextRoomIndex

        if nextRoomIndex == 1 then
            object:Destroy()  -- Destroy the object when the final room's tween is completed
        else
            tween.Completed:Connect(createAndPlayTween)  -- Recursively create and play tween for the next room
        end
    end

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
