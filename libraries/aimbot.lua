print("0.1")

function Alive(Player)
    if Player and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") ~= nil and Player.Character:FindFirstChild("Humanoid") ~= nil and Player.Character:FindFirstChild("Head") ~= nil then
        return true
    end
    return false
end

function checkFOV(part, camera, radius)
    local worldToViewportPoint = camera.worldToViewportPoint;
    local vector, onScreen = camera:WorldToViewportPoint(part.Position)
    local screenMiddle = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)

    local position = Vector2.new(vector.X, vector.Y)

    if onScreen then
        local distance = (Vector2.new(vector.X, vector.Y) - Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)).Magnitude

        if distance < radius then
            return true;
        end
    end
    return false;
end

local library = {};

library.__index = library;

function library._checkFOV(part, camera, radius)
    local worldToViewportPoint = camera.worldToViewportPoint;
    local vector, onScreen = camera:WorldToViewportPoint(part.Position)
    local screenMiddle = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)

    local position = Vector2.new(vector.X, vector.Y)

    if onScreen then
        local distance = (Vector2.new(vector.X, vector.Y) - Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)).Magnitude

        if distance < radius then
            return true;
        end
    end
    return false;
end

function library._checkWall(part, camera, localplayer)
    local ray = Ray.new(camera.CFrame.Position, (part.Character.HumanoidRootPart.Position - camera.CFrame.Position).Unit * 300)
    local raycast, position = game:GetService("Workspace"):FindPartOnRayWithIgnoreList(ray, {camera, localplayer.Character, localplayer.Character.Head}, false, true)
    local pos, visible = camera:WorldToScreenPoint(part.HumanoidRootPart.Position)
    if raycast then
        if raycast.Parent.FindFirstChild("Humanoid") == nil then
            return false;
        elseif raycast.Parent == nil then
            return false;
        end
        if visible then
            return true;
        else
            return false;
        end
    end
    return false;
end

function library._getClosest(localplayer, part)
    local closestPlayer = nil
    local closestDist = math.huge
    for i,v in pairs(game.Players:GetPlayers()) do
        if v ~= localplayer and v.Team ~= localplayer.Team and Alive(v) and Alive(localplayer) then
            local Dist = (localplayer.Character.HumanoidRootPart.Position - v.Character[part].Position).magnitude
            if Dist < closestDist then
                closestDist = Dist
                closestPlayer = v
            end
        end
    end
    return closestPlayer
end

function library._getClosestFOV(localplayer, fov, part, camera)
    local closestPlayer = nil
    local closestDist = math.huge
    for i,v in pairs(game.Players:GetPlayers()) do
        if v ~= localplayer and v.Team ~= localplayer.Team and Alive(v) and Alive(localplayer) and library._checkFOV(v.Character[part], camera, fov) then
            local Dist = (localplayer.Character.HumanoidRootPart.Position - v.Character[part].Position).magnitude
            if Dist < closestDist then
                closestDist = Dist
                closestPlayer = v
            end
        end
    end
    return closestPlayer
end

function library._aimAtPart(camera, part)
    camera.CFrame = CFrame.new(camera.CFrame.Position, part.Position);
end

return setmetatable({}, library);
