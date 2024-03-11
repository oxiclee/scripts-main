local Entity = {}

function Entity.new(assetId, tweenDuration, killRadius, canEntityKill)
    local object = game:GetObjects("rbxassetid://" .. assetId)[1]
    local part = object.PrimaryPart
    local rooms = workspace.CurrentRooms:GetChildren()
    local ts = game:GetService("TweenService")

    local currentRoomIndex = 1

    object.Parent = workspace
    part.CFrame = rooms[currentRoomIndex].PrimaryPart.CFrame

    local tweenInfo = TweenInfo.new(
        tweenDuration,
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

    game:GetService("RunService").Stepped:Connect(function()
        for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (part.Position - player.Character.HumanoidRootPart.Position).magnitude
                if distance <= killRadius then
                    if canEntityKill then
                        player.Character.Humanoid.Health = 0
                    else
                        print("Entity cannot kill.")
                    end
                end
            end
        end
    end)
end

return Entity
