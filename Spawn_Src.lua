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
        else
            nextRoomIndex = currentRoomIndex - 1
        end
        
        local tween = ts:Create(part, tweenInfo, {CFrame = rooms[nextRoomIndex].PrimaryPart.CFrame})
        tween:Play()

        tween.Completed:Connect(function()
            if not backwards then
                if nextRoomIndex >= #rooms then
                    if rebounds then 
                            
                        backwards = not backwards
                            
                        if not backwards then
                            currentRoomIndex = 1
                        else
                            currentRoomIndex = #rooms
                        end
                            
                        createAndPlayTween()
                    else
                        object:Destroy() 
                    end
                else
                    currentRoomIndex = nextRoomIndex
                    createAndPlayTween()
                end
            else
                if nextRoomIndex <= 1 then
                    if rebounds then 
                        currentReboundCount = currentReboundCount + 1
                        if currentReboundCount > reboundcount then
                            object:Destroy()  
                        else        
                            backwards = not backwards
                            createAndPlayTween()
                        end
                    end
                else
                    currentRoomIndex = nextRoomIndex
                    createAndPlayTween()
                end
            end
        end)
    end

    task.wait(delay)

    if not backwards then
        createAndPlayTween()
    else
        local backwardsTween = ts:Create(part, tweenInfo, {CFrame = rooms[#rooms].PrimaryPart.CFrame})
        backwardsTween:Play()
        backwardsTween.Completed:Connect(function()
            createAndPlayTween()
        end)
    end

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
