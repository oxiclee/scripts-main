local Entity = {}

function Entity.new(asset, minTweenDuration, maxTweenDuration, canEntityKill, delay, backwards)
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

    local function calculateTweenDuration(startPosition, endPosition)
        local distance = (endPosition - startPosition).magnitude
        return math.clamp(distance / 10, minTweenDuration, maxTweenDuration)
    end

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
            local targetCFrame = node.CFrame + Vector3.new(0, 2, 0)
            local tweenDuration = calculateTweenDuration(part.Position, targetCFrame.p)
            local tweenInfo = TweenInfo.new(tweenDuration, Enum.EasingStyle.Linear)
            local properties = {
                CFrame = targetCFrame
            }
            local tween = ts:Create(part, tweenInfo, properties)

            table.insert(chain, tween)
        end

        for i, tween in ipairs(chain) do
            tween:Play()
            if i < #chain then
                tween.Completed:Wait()
            end
        end

        if (not backwards and nextroomindex > #rooms) or (backwards and nextroomindex < 1) then
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
