local Entity = {}

function Entity.setup(params)
    Entity.model = params.Model
    Entity.speed = params.Speed
    Entity.moveDelay = params.MoveDelay
    Entity.heightOffset = params.HeightOffset
    Entity.canKill = params.CanKill
    Entity.killRange = params.KillRange
end

function Entity.create()
    local object = game:GetObjects(Entity.model)[1]
    local part = object.PrimaryPart
    local ts = game:GetService("TweenService")

    local tween = ts:Create(part, TweenInfo.new(1), { CFrame = CFrame.new(10, 0, 0) })
    tween:Play()

    game:GetService("RunService").Stepped:Connect(function()
        for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
            local distance = (part.Position - player.Character.HumanoidRootPart.Position).magnitude
            if distance <= Entity.killRange then
                if Entity.canKill then
                    player.Character.Humanoid.Health = 0
                end
            end
        end
    end)
end

return Entity
