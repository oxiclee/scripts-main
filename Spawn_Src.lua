local Entity = {}

function Entity.new(asset, tweenDuration, canEntityKill, delay, backwards, rebounds, reboundcount)
    local object = game:GetObjects(asset)[1]
    local part = object.PrimaryPart
    local roomfolder = workspace.CurrentRooms
    local rooms = roomfolder:GetChildren()
    local ts = game:GetService("TweenService")

    local currentReboundCount = 0
    local currentRoomIndex = nil
    
    if backwards then
        currentRoomIndex = #rooms
        part.CFrame = rooms[#rooms].Door.PrimaryPart.CFrame
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
        rooms = roomfolder:GetChildren()
        local nextRoomIndex = nil

        if not backwards then
            nextRoomIndex = currentRoomIndex + 1
            if nextRoomIndex > #rooms then
                if rebounds then 
                    backwards = true
                    currentRoomIndex = #rooms - 1
                else
                    object:Destroy() 
                    return
                end
            end
        else
            nextRoomIndex = currentRoomIndex - 1
            if nextRoomIndex < 1 then
                if rebounds then 
                    currentReboundCount = currentReboundCount + 1
                    if currentReboundCount > reboundcount then
                        object:Destroy()  
                        return
                    else        
                        backwards = false
                        currentRoomIndex = 2
                    end
                else
                    object:Destroy() 
                    return
                end
            end
        end
        
        local tween = ts:Create(part, tweenInfo, {CFrame = rooms[nextRoomIndex].PrimaryPart.CFrame})
        tween:Play()

        tween.Completed:Connect(function()
            currentRoomIndex = nextRoomIndex
            createAndPlayTween()
        end)
    end

    task.wait(delay)

    createAndPlayTween()

    part.Touched:Connect(function(otherPart)
        if otherPart.Parent == game:GetService("Players").LocalPlayer.Character then
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
