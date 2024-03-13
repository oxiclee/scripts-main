local Entity = {}

function Entity.new(asset, tweenDuration, canEntityKill, delay, backwards)
    local object = game:GetObjects(asset)[1]
    local part = object.PrimaryPart
    local rooms = workspace.CurrentRooms:GetChildren()
    local ts = game:GetService("TweenService")

    local currentRoomIndex = nil

    if backwards then
        currentRoomIndex = #rooms
        part.CFrame = rooms[#rooms].Door.PrimaryPart.CFrame
    else
        currentRoomIndex = 1
        part.CFrame = rooms[currentRoomIndex].Door.PrimaryPart.CFrame
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
        local nextroomindex = nil

        if not backwards then
            nextroomindex = currentRoomIndex + 1
        else
            nextroomindex = currentRoomIndex - 1
        end
        
        local tween = ts:Create(part, tweenInfo, {CFrame = rooms[nextroomindex].Door.PrimaryPart.CFrame})
        tween:Play()

        tween.Completed:Connect(function()
            if not backwards then
                if nextroomindex >= #rooms then
                    object:Destroy()
                else
                    nextroomindex = currentRoomIndex + 1
                end
            else
                if nextroomindex <= 1 then
                    object:Destroy()
                else
                    nextroomindex = currentRoomIndex - 1
                end
            end
            createAndPlayTween()
        end)
    end

    task.wait(delay)

    if not backwards then
        createAndPlayTween()
    else
        local backwardstween = ts:Create(part, tweenInfo, {CFrame = rooms[#rooms].Door.PrimaryPart.CFrame})
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
