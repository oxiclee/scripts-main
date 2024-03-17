local Entity = {}

function Entity.new(obj, speedFactor, reverses)
    local object = game:GetObjects(obj)[1]
    object.Parent = workspace
    local p = object.PrimaryPart

    local nodes = {}

    for _, v in ipairs(workspace:GetDescendants()) do
        if v.Parent.Name == "PathfindNodes" and v.Parent:IsA("Folder") then
            table.insert(nodes, v.CFrame)
        end
    end

    local function distanceBetweenCFrames(cframe1, cframe2)
        return (cframe1 - cframe2).magnitude
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

    for i = startNodeIndex, endNodeIndex, step do
        local nodeStart = nodes[i]
        local nodeEnd = nodes[i + step]
        local distance = distanceBetweenCFrames(nodeStart, nodeEnd)
        local startTime = tick()

        while tick() - startTime < distance / speedFactor do
            local t = (tick() - startTime) / (distance / speedFactor)
            local lerpedCFrame = nodeStart:Lerp(nodeEnd, t)
            p.CFrame = lerpedCFrame
            wait()
        end
    end

    object:Destroy()
end

return Entity
