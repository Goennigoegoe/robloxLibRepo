function Alive(Player)
    if Player and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") ~= nil and Player.Character:FindFirstChild("Humanoid") ~= nil and Player.Character:FindFirstChild("Head") ~= nil then
        return true
    end
    return false
end

function checkFOV(part, camera, radius)
    local partOSP, onScreen = camera:worldToViewportPoint(part)
    local screenMiddle = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)

    if onScreen then
        local distance = (partOSP - screenMiddle).Magnitude

        if distance < radius then
            return true;
        end
    end
    return false;
end

function getClosest(localplayer, part)
    local closestPlayer = nil
    local closestDist = math.huge
    for i,v in pairs(game.Players:GetPlayers()) do
        if v ~= localplayer and Alive(v) and Alive(localplayer) then
            local Dist = (localplayer.Character.HumanoidRootPart.Position - v.Character[part].Position).magnitude
            if Dist < closestDist then
                closestDist = Dist
                closestPlayer = v
            end
        end
    end
    return closestPlayer
end

function getClosestFOV(localplayer, fov, part, camera)
    local closestPlayer = nil
    local closestDist = math.huge
    for i,v in pairs(game.Players:GetPlayers()) do
        if v ~= localplayer and Alive(v) and Alive(localplayer) and checkFOV(part, camera, fov) then
            local Dist = (localplayer.Character.HumanoidRootPart.Position - v.Character[part].Position).magnitude
            if Dist < closestDist then
                closestDist = Dist
                closestPlayer = v
            end
        end
    end
    return closestPlayer
end

function aimAtPart(camera, part)
    camera.CFrame = CFrame.new(camera.CFrame.Position, part.Position);
end
