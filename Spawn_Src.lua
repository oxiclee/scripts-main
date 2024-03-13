local Entity = {}

function Entity.new(asset, tweenDuration, canEntityKill, delay, backwards, rebounds, reboundcount)
    local object = game:GetObjects(asset)[1]
    local part = object.PrimaryPart
    local roomfolder = workspace.CurrentRooms
    local rooms = roomfolder:GetChildren()
    local ts = game:GetService("TweenService")

    local currentreboundcount = 0
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
        local nextroomindex = nil

        if not backwards then
            nextroomindex = currentRoomIndex + 1
        else
            nextroomindex = currentRoomIndex - 1
        end
        
        local tween = ts:Create(part, tweenInfo, {CFrame = rooms[nextroomindex].PrimaryPart.CFrame})
        tween:Play()

        tween.Completed:Connect(function()
            if not backwards then
                if nextroomindex >= #rooms then
                    if rebounds then  -- Corrected variable name
                        backwards = not backwards
                        currentRoomIndex = #rooms
                        part.CFrame = rooms[#rooms].Door.PrimaryPart.CFrame
                        createAndPlayTween()
                    else
                         object:Destroy() 
                    end
                else
                    currentRoomIndex = nextroomindex
                    createAndPlayTween()
                end
            else
                if nextroomindex <= 1 then
                    if rebounds then  -- Corrected variable name
                        currentreboundcount = currentreboundcount+1
                        if currentreboundcount > reboundcount then
                            object:Destroy()  
                        else        
                            backwards = not backwards
                            createAndPlayTween()
                        end
                    end
                else
                    currentRoomIndex = nextroomindex
                    createAndPlayTween()
                end
            end
        end)
    end

    task.wait(delay)

    if not backwards then
        createAndPlayTween()
    else
        local backwardstween = ts:Create(part, tweenInfo, {CFrame = rooms[#rooms].PrimaryPart.CFrame})
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
