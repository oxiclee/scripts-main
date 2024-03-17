local module = {}

function module.new(obj, speedFactor, reverses, delay, flickerlength)
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

    local start, finish, step
    if reverses then
        start, finish, step = #nodes, 1, -1
    else
        start, finish, step = 1, #nodes, 1
    end

    ModuleEvents = require(game:GetService("ReplicatedStorage").ClientModules.Module_Events)
    ModuleEvents.flicker(workspace.CurrentRooms[game:GetService("ReplicatedStorage").GameData.LatestRoom.Value],flickerlength)
    
    task.wait(delay)

    for i = start, finish, step do
        local nodeStart = nodes[i].CFrame
        local nodeEnd = nodes[i + step].CFrame
        local distance = distanceBetweenCFrames(nodeStart, nodeEnd)
        local startTime = tick()

        while tick() - startTime < distance / speedFactor do
            local t = (tick() - startTime) / (distance / speedFactor)
            local lerpedCFrame = nodeStart:Lerp(nodeEnd, t)
            p.CFrame = lerpedCFrame
            wait()
        end
    end

    p.CFrame = nodes[finish].CFrame
    obj2:Destroy()
end

return module
