function Alive(Player)
    if Player and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") ~= nil and Player.Character:FindFirstChild("Humanoid") ~= nil and Player.Character:FindFirstChild("Head") ~= nil then
        return true
    end
    return false
end

local library = {};
library.__index = library;

library.specPlayer(cam, player, localplayer)
    if Alive(localplayer) and Alive(player) then
        local target = player.Character.Humanoid;

        cam.CameraSubject = target;
    end
end

library.stopSpec(cam, localplayer)
    if Alive(localplayer) then
        cam.CameraSubject = localplayer.Character.Humanoid;
    end
end

return setmetatable({}, library);
