local module = {}

function module.new(obj, speedFactor)
    local obj2 = game:GetObjects(obj)[1]
    obj2.Parent = workspace
    local p = obj2.PrimaryPart

    local nodes = {}

    for _, v in ipairs(workspace:GetDescendants()) do
        if v.Parent.Name == "PathfindNodes" and v.Parent:IsA("Folder") then
            table.insert(nodes, v)
        end
    end

    local function distanceBetweenCFrames(cframe1, cframe2)
        if cframe1 and cframe2 then
            return (cframe1.Position - cframe2.Position).magnitude
        else
            return 0
        end
    end


    for i = 1, #nodes - 1 do
        local nodeStart = nodes[i].CFrame
        local nodeEnd = nodes[i + 1].CFrame
        local distance = distanceBetweenCFrames(nodeStart, nodeEnd)
        local startTime = tick()

        while tick() - startTime < distance / speedFactor do
            local t = (tick() - startTime) / (distance / speedFactor)
            local lerpedCFrame = nodeStart:Lerp(nodeEnd, t)
            p.CFrame = lerpedCFrame
            wait()
        end
    end

    p.CFrame = nodes[#nodes].CFrame
    obj2:Destroy()
end

return module
