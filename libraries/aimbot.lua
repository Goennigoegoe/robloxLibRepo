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

--[[function createTracer(pos1, pos2, camera)
    local tracer = Drawing.new("Line");
    tracer.Transparency = 1;
    tracer.Color = Color3.new(255, 255, 255);
    tracer.Thickness = 1;
    tracer.From = Vector2.new(0, 0);
    tracer.To = Vector2.new(0, 0);
    tracer.Visible = false;
    
    local destroyed = false;

    function dotracer()
        game:GetService("RunService").RenderStepped:Connect(function()
            if not destroyed then
                local vector1, onScreen1 = camera:WorldToViewportPoint(pos1);
                local from = Vector2.new(vector1.X, vector1.Y);
                local vector2, onScreen2 = camera:WorldToViewportPoint(pos2);
                local to = Vector2.new(vector2.X, vector2.Y);
                if onScreen1 and onScreen2 then
                    tracer.From = from;
                    tracer.To = to;
                    tracer.Visible = true;
                else
                    tracer.Visible = false;
                end
            end
        end)
        task.wait(1)
        destroyed = true;
        tracer:Remove();
    end
    dotracer();
end]]--

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
    local pos, visible = camera:WorldToScreenPoint(part.Character.HumanoidRootPart.Position)
    if raycast then
        if raycast.Parent:FindFirstChild("Humanoid") == nil then
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

function library._getClosest(localplayer, part, teamCheck)
    local closestPlayer = nil
    local closestDist = math.huge
    for i,v in pairs(game.Players:GetPlayers()) do
        if teamCheck then
            if v ~= localplayer and v.Team ~= localplayer.Team and Alive(v) and library._checkWall(v, camera, localplayer) and Alive(localplayer) then
                local Dist = (localplayer.Character.HumanoidRootPart.Position - v.Character[part].Position).magnitude
                if Dist < closestDist then
                    closestDist = Dist
                    closestPlayer = v
                end
            end
        else
            if v ~= localplayer and Alive(v) and library._checkWall(v, camera, localplayer) and Alive(localplayer) then
                local Dist = (localplayer.Character.HumanoidRootPart.Position - v.Character[part].Position).magnitude
                if Dist < closestDist then
                    closestDist = Dist
                    closestPlayer = v
                end
            end
        end
    end
    return closestPlayer
end

function library._getClosestFOV(localplayer, fov, part, camera, teamCheck)
    local closestPlayer = nil
    local closestDist = math.huge
    for i,v in pairs(game.Players:GetPlayers()) do
        if teamCheck then
            if v ~= localplayer and v.Team ~= localplayer.Team and Alive(v) and Alive(localplayer) and library._checkWall(v, camera, localplayer) and library._checkFOV(v.Character[part], camera, fov) then
                local Dist = (localplayer.Character.HumanoidRootPart.Position - v.Character[part].Position).magnitude
                if Dist < closestDist then
                    closestDist = Dist
                    closestPlayer = v
                end
            end
        else
            if v ~= localplayer and Alive(v) and Alive(localplayer) and library._checkWall(v, camera, localplayer) and library._checkFOV(v.Character[part], camera, fov) then
                local Dist = (localplayer.Character.HumanoidRootPart.Position - v.Character[part].Position).magnitude
                if Dist < closestDist then
                    closestDist = Dist
                    closestPlayer = v
                end
            end
        end
    end
    return closestPlayer
end

function library._aimAtPart(camera, part)
    camera.CFrame = CFrame.new(camera.CFrame.Position, part.Position);
end

function library._silentAimAtPart(camera, part, usewait)--, tracer, localplayer)
    local savePos = camera.CFrame;

    camera.CFrame = CFrame.new(camera.CFrame.Position, part.Position);
    --[[if tracer then
        --(plr.Character:WaitForChild("Head").Position - cam.CFrame.Position).Unit * 1000
        local ray = Ray.new(camera.CFrame.Position, camera.CFrame.LookVector * 1000)--(part.Character.HumanoidRootPart.Position - camera.CFrame.Position).Unit * 300)
        local raycast, position = game:GetService("Workspace"):FindPartOnRayWithIgnoreList(ray, {camera, localplayer.Character, localplayer.Character.Head}, false, true)
        if raycast then
            createTracer(camera.CFrame.Position, Vector3.new(position.X, position.Y, position.Z), camera);
        end
    end]]--
    if usewait then
        task.wait();
    end
    camera.CFrame = savePos;
end

return setmetatable({}, library);
