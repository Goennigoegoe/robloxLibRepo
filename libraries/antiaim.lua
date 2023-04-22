function Alive(Player)
    if Player and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") ~= nil and Player.Character:FindFirstChild("Humanoid") ~= nil and Player.Character:FindFirstChild("Head") ~= nil then
        return true
    end
    return false
end

local library = {};
library.__index = library;

function library.Spin(Speed, player)
    if Alive(player) then
        player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(Speed), 0)
    end
end

function library.Jitter(Speed, Angle, player)
    if Alive(player) then
        local Jit = Speed
        player.Character.HumanoidRootPart.CFrame = CFrame.new(player.Character.HumanoidRootPart.CFrame.Position) * CFrame.Angles(0, math.rad(Angle) + math.rad((math.random(1, 2) == 1 and Jit or -Jit)), 0)
    end
end

function library.Angle(Angle, player, cam)
    if Alive(player) then
        local camLv = cam.CFrame.lookVector
        local camRotation = math.atan2(-camLv.X, -camLv.Z)

        player.Character.HumanoidRootPart.CFrame = CFrame.new(player.Character.HumanoidRootPart.CFrame.Position) * CFrame.Angles(0, camRotation, 0);
    end
end

function library.AngleJit(speed, offset, player, cam)
    if Alive(player) then
        local camLv = cam.CFrame.lookVector
        local camRotation = math.atan2(-camLv.X, -camLv.Z)

        player.Character.HumanoidRootPart.CFrame = CFrame.new(player.Character.HumanoidRootPart.CFrame.Position) * CFrame.Angles(0, (camRotation + math.rad(offset)) + math.rad((math.random(1, 2) == 1 and Jit or -Jit)), 0);
    end
end

return setmetatable({}, library);
