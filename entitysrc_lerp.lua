local Entity = {}

function Entity.new(obj, speedFactor, delay, reverses, flickerduration)
    local object = game:GetObjects(obj)[1]
    object.Parent = workspace
    local p = object.PrimaryPart

    if not reverses then
        p.CFrame = workspace.CurrentRooms:GetChildren()[1].PrimaryPart.CFrame
    else
        local BAKrooms = workspace.CurrentRooms:GetChildren()
        p.CFrame = BAKrooms[#BAKrooms].Door.PrimaryPart.CFrame
    end
    
    local nodes = {}

    for _, v in ipairs(workspace:GetDescendants()) do
        if v.Parent.Name == "PathfindNodes" and v.Parent:IsA("Folder") then
            table.insert(nodes, v.CFrame)
        end
    end

    local function distanceBetweenCFrames(cframe1, cframe2)
        if cframe1 and cframe2 then
            return (cframe1.Position - cframe2.Position).magnitude
        else
            return 0
        end
    end

    local startNodeIndex, endNodeIndex, step
    if reverses then
        startNodeIndex = #nodes
        endNodeIndex = 1
        step = -1
    else
        startNodeIndex = 1
        endNodeIndex = #nodes
        step = 1
    end

    ModuleEvents = require(game:GetService("ReplicatedStorage").ClientModules.Module_Events)
    ModuleEvents.flicker(workspace.CurrentRooms[game:GetService("ReplicatedStorage").GameData.LatestRoom.Value],flickerduration)

    task.wait(delay)
    
    for i = startNodeIndex, endNodeIndex, step do
        local nodeStart = nodes[i]
        local nodeEnd = nodes[i + step]
        local distance = distanceBetweenCFrames(nodeStart, nodeEnd)
        local startTime = tick()

        while tick() - startTime < distance / speedFactor do
            local t = (tick() - startTime) / (distance / speedFactor)
            local lerpedCFrame = nodeStart:Lerp(nodeEnd, t)
            lerpedCFrame = lerpedCFrame + Vector3.new(0, 2, 0)
            p.CFrame = lerpedCFrame
            wait()
        end
    end

    object:Destroy()
end

return Entity
