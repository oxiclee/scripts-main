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
        local nodes = rooms[currentRoomIndex].PathfindNodes:GetChildren()
        local chain = {}

        local nextroomindex = nil

        if not backwards then
            nextroomindex = currentRoomIndex + 1
        else
            nextroomindex = currentRoomIndex - 1
        end

        for i, node in ipairs(nodes) do
            local cf = node.CFrame + Vector3.new(0, 1.4, 0)
            local tween = ts:Create(part, tweenInfo, {CFrame = cf})

            table.insert(chain, tween)
            
        end

        for i, tween in ipairs(chain) do
            tween:Play()
            if i < #chain then
                tween.Completed:Wait()
            end
        end


        if not backwards and nextroomindex > #rooms - 1 then
            object:Destroy()
        else
            currentRoomIndex = nextroomindex
            createAndPlayTween()
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
