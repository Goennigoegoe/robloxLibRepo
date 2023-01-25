local utility = {}

function utility.table(tbl, usemt)
    tbl = tbl or {}

    local oldtbl = table.clone(tbl)
    table.clear(tbl)

    for i, v in next, oldtbl do
        if type(i) == "string" then
            tbl[i:lower()] = v
        else
            tbl[i] = v
        end
    end

    if usemt == true then
        setmetatable(tbl, {
            __index = function(t, k)
                return rawget(t, k:lower()) or rawget(t, k)
            end,

            __newindex = function(t, k, v)
                if type(k) == "string" then
                    rawset(t, k:lower(), v)
                else
                    rawset(t, k, v)
                end
            end
        })
    end

    return tbl
end

function utility.getLength(tbl)
    local length = 0;
    for i,v in pairs(tbl) do
        length = length + 1;
    end
    return length;
end

function utility.wrapAround(current, maxamount)
    if current > maxamount then
        return 1;
    elseif current < 1 then
        return maxamount;
    end
    return current;
end

function utility.setColor(selected, tbl)
    for i,v in pairs(tbl) do
        if i ~= selected then
            tbl[i].Color = Color3.new(255, 255, 255);
        else
            tbl[i].Color = Color3.new(0, 0, 255);
            --print("selected");
        end
    end
end

function utility.toOnOff(bool)
    if bool then
        return "On";
    end
    return "Off";
end

local drawings = {};
--[[local elements = {};
local toggles = {};
local sliders = {};
local buttons = {};]]--
local interactables = {};
local callbacks = {};
local objtypes = {};
local flagnames = {};
local stepSize = {};
local selectedItem = 1;

local Camera = workspace.CurrentCamera;
local viewportX = Camera.ViewportSize.X;
local viewportY = Camera.ViewportSize.Y;
local viewportSize = Camera.ViewportSize;

local library = utility.table({Name = "No Name Specified", Offset = Vector2.new(50, 100), flags = {}, Loaded = false, Watermark = false, Padding = 20, Unloaded = false, TextSize = 25, open = true}, true);

function library:Load(Name, Offset, Watermark, Padding, TextSize)
    self.Loaded = true;

    self.Name = Name;
    self.Offset = Offset;
    self.Watermark = Watermark;
    self.TextSize = TextSize;
    self.Open = true;
    library.Padding = Padding;

    local watermark = Drawing.new("Text");
    watermark.Visible = self.Watermark;
    watermark.Transparency = 1;
    watermark.Color = Color3.new(255, 255, 255);
    watermark.Text = self.Name;
    watermark.Center = false;
    watermark.Size = self.TextSize;
    watermark.Outline = true;
    watermark.Font = 0;
    watermark.Position = Vector2.new(0, 0) + self.Offset;
    watermark.ZIndex = 1;

    local background = Drawing.new("Square");
    background.Visible = true;
    background.Transparency = 1;
    background.Color = Color3.fromRGB(30, 30, 36);
    background.ZIndex = 0;
    background.Thickness = 1;
    background.Position = self.Offset - Vector2.new(2, 2);
    background.Filled = true;
    background.Size = Vector2.new(50, 20)

    self.Background = background;
    
    table.insert(drawings, watermark);
    background.Size = drawings[utility.getLength(drawings)].Position + Vector2.new(50, 2);
end

function library:CreateLabel(text)
    local label = Drawing.new("Text");
    label.Visible = true;
    label.Transparency = 1;
    label.Text = text;
    label.Color = Color3.new(255, 255, 255);
    label.Center = false;
    label.Size = self.TextSize;
    label.Outline = true;
    label.Font = 0;
    label.Position = drawings[utility.getLength(drawings)].Position + Vector2.new(0, self.Padding);
    label.ZIndex = 1;

    table.insert(drawings, label);

    self.Background.Size = drawings[utility.getLength(drawings)].Position + Vector2.new(50, 2);

    return lable;
end

function library:CreateButton(text, callback, flag)
    local button = Drawing.new("Text");
    button.Visible = true;
    button.Transparency = 1;
    button.Text = text;
    button.Color = Color3.new(255, 255, 255);
    button.Center = false;
    button.Size = self.TextSize;
    button.Outline = true;
    button.Font = 0;
    button.Position = drawings[utility.getLength(drawings)].Position + Vector2.new(0, self.Padding);
    button.ZIndex = 1;

    self.flags[flag] = "Button";

    table.insert(drawings, button);
    table.insert(interactables, button);
    table.insert(callbacks, callback);
    table.insert(objtypes, 0);
    table.insert(flagnames, flag);
    table.insert(stepSize, 0);

    self.Background.Size = drawings[utility.getLength(drawings)].Position + Vector2.new(50, 2);

    return button;
end

function library:CreateToggle(text, default, callback, flag)
    local toggle = Drawing.new("Text");
    toggle.Visible = true;
    toggle.Transparency = 1;
    toggle.Text = text .. ": " .. utility.toOnOff(default);
    toggle.Color = Color3.new(255, 255, 255);
    toggle.Center = false;
    toggle.Size = self.TextSize;
    toggle.Outline = true;
    toggle.Font = 0;
    toggle.Position = drawings[utility.getLength(drawings)].Position + Vector2.new(0, self.Padding);
    toggle.ZIndex = 1;

    self.flags[flag] = default;

    table.insert(drawings, toggle);
    table.insert(interactables, toggle);
    table.insert(callbacks, callback);
    table.insert(objtypes, 1);
    table.insert(flagnames, flag);
    table.insert(stepSize, 0);

    game:GetService("RunService").Heartbeat:Connect(function()
        if not self.Unloaded then
            toggle.Text = text .. ": " .. utility.toOnOff(self.flags[flag]);
        end
    end)

    self.Background.Size = drawings[utility.getLength(drawings)].Position + Vector2.new(50, 2);

    return toggle;
end

function library:CreateSlider(text, default, min, max, step, callback, flag)
    local slider = Drawing.new("Text");
    slider.Visible = true;
    slider.Transparency = 1;
    slider.Text = text .. " " .. tostring(default);
    slider.Color = Color3.new(255, 255, 255);
    slider.Center = false;
    slider.Size = self.TextSize;
    slider.Outline = true;
    slider.Font = 0;
    slider.Position = drawings[utility.getLength(drawings)].Position + Vector2.new(0, self.Padding);
    slider.ZIndex = 1;

    self.flags[flag] = default;

    table.insert(drawings, slider);
    table.insert(interactables, slider);
    table.insert(callbacks, callback);
    table.insert(objtypes, 2);
    table.insert(flagnames, flag);
    table.insert(stepSize, step);

    game:GetService("RunService").Heartbeat:Connect(function()
        if self.flags[flag] > max then
            self.flags[flag] = max;
        elseif self.flags[flag] < min then
            self.flags[flag] = min;
        end
        if not self.Unloaded then
            slider.Text = text .. " " .. tostring(self.flags[flag]);
        end
    end)

    self.Background.Size = drawings[utility.getLength(drawings)].Position + Vector2.new(50, 2);

    return slider;
end

function library:Unload()
    for i,v in pairs(drawings) do
        v.Visible = false;
        v:Remove();
    end

    for i,v in pairs(flagnames) do
        if type(library.flags[v]) == "boolean" then
            library.flags[v] = false;
        end
    end

    self.Background:Remove();

    self.Unloaded = true;
end

function library:Close()
    self.open = not self.open

    for i,v in pairs(drawings) do
        v.Visible = self.open;
    end
    self.Background.Visible = self.open;
end

game:GetService("UserInputService").InputBegan:Connect(function(key)
    if not library.Unloaded then
        if key.KeyCode == Enum.KeyCode.KeypadTwo then
            selectedItem = selectedItem + 1;
            selectedItem = utility.wrapAround(selectedItem, utility.getLength(interactables));
            utility.setColor(selectedItem, interactables);
        elseif key.KeyCode == Enum.KeyCode.KeypadEight then
            selectedItem = selectedItem - 1;
            selectedItem = utility.wrapAround(selectedItem, utility.getLength(interactables));
            utility.setColor(selectedItem, interactables);
        elseif key.KeyCode == Enum.KeyCode.KeypadFive then
            if objtypes[selectedItem] == 0 then
                callbacks[selectedItem]();
            elseif objtypes[selectedItem] == 1 then
                library.flags[flagnames[selectedItem]] = not library.flags[flagnames[selectedItem]];
                local toggled = library.flags[flagnames[selectedItem]];
                callbacks[selectedItem](toggled);
            end
        elseif key.KeyCode == Enum.KeyCode.KeypadFour then
            if objtypes[selectedItem] == 2 then
                library.flags[flagnames[selectedItem]] = library.flags[flagnames[selectedItem]] - stepSize[selectedItem];
                callbacks[selectedItem](library.flags[flagnames[selectedItem]]);
            end
        elseif key.KeyCode == Enum.KeyCode.KeypadSix then
            if objtypes[selectedItem] == 2 then
                library.flags[flagnames[selectedItem]] = library.flags[flagnames[selectedItem]] + stepSize[selectedItem];
                callbacks[selectedItem](library.flags[flagnames[selectedItem]]);
            end
        elseif key.KeyCode == Enum.KeyCode.RightShift then
            library:Close();
        end
    end
end)

return library;
