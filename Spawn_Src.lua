local Entity = {}

function Entity.new(asset, tweenDuration, canEntityKill, delay, backwards)
    local object = game:GetObjects(asset)[1]
    local part = object.PrimaryPart
    local rooms = workspace.CurrentRooms:GetChildren()
    local ts = game:GetService("TweenService")

    local currentRoomIndex = nil

    if backwards then
        currentroomindex = #rooms
        part.CFrame = rooms[#rooms].Door.PrimaryPart.CFrame
    else
        currentroomindex = 1
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
        local nextroomindex = nil

        if not backwards then
            nextroomindex = currentroomindex + 1
        else
            nextroomindex = currentroomindex - 1
        end
        
        local tween = ts:Create(part, tweenInfo, {CFrame = rooms[nextroomindex].PrimaryPart.CFrame})
        tween:Play()

        tween.Completed:Connect(function()
            if not backwards then
                if nextroomindex >= #rooms then
                        object:Destroy()
                else
                    nextroomindex = currentroomindex + 1
                end
            else
                if nextroomindex <= 1 then
                    object:Destroy()
                else
                    nextroomindex = currentroomindex - 1
                end
            end
            createAndPlayTween()
        end)
        
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
