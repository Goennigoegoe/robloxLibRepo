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

local drawings = {};
--[[local elements = {};
local toggles = {};
local sliders = {};
local buttons = {};]]--
local interactables = {};
local callbacks = {};
local objtypes = {};
local flagnames = {};
local selectedItem = 1;

local Camera = workspace.CurrentCamera;
local viewportX = Camera.ViewportSize.X;
local viewportY = Camera.ViewportSize.Y;
local viewportSize = Camera.ViewportSize;

local library = utility.table({Name = "No Name Specified", Offset = Vector2.new(50, 100), flags = {}, Loaded = false, Watermark = false, Padding = 20, Unloaded = false}, true);

function library:Load(Name, Offset, Watermark, Padding)
    self.Loaded = true;

    self.Name = Name;
    self.Offset = Offset;
    self.Watermark = Watermark;
    library.Padding = Padding;

    local watermark = Drawing.new("Text");
    watermark.Visible = self.Watermark;
    watermark.Transparency = 1;
    watermark.Color = Color3.new(255, 255, 255);
    watermark.Text = self.Name;
    watermark.Center = false;
    watermark.Size = 25;
    watermark.Outline = true;
    watermark.Font = 0;
    watermark.Position = Vector2.new(0, 0) + self.Offset;
    
    table.insert(drawings, watermark);
end

function library:CreateLabel(text)
    local label = Drawing.new("Text");
    label.Visible = true;
    label.Transparency = 1;
    label.Text = text;
    label.Color = Color3.new(255, 255, 255);
    label.Center = false;
    label.Size = 25;
    label.Outline = true;
    label.Font = 0;
    label.Position = drawings[utility.getLength(drawings)].Position + Vector2.new(0, self.Padding);

    table.insert(drawings, label);
    return lable;
end

function library:CreateButton(text, callback, flag)
    local button = Drawing.new("Text");
    button.Visible = true;
    button.Transparency = 1;
    button.Text = text;
    button.Color = Color3.new(255, 255, 255);
    button.Center = false;
    button.Size = 25;
    button.Outline = true;
    button.Font = 0;
    button.Position = drawings[utility.getLength(drawings)].Position + Vector2.new(0, self.Padding);

    self.flags[flag] = "Button";

    table.insert(drawings, button);
    table.insert(interactables, button);
    table.insert(callbacks, callback);
    table.insert(objtypes, 0);
    table.insert(flagnames, flag);

    return button;
end

function library:CreateToggle(text, default, callback, flag)
    local toggle = Drawing.new("Text");
    toggle.Visible = true;
    toggle.Transparency = 1;
    toggle.Text = text;
    toggle.Color = Color3.new(255, 255, 255);
    toggle.Center = false;
    toggle.Size = 25;
    toggle.Outline = true;
    toggle.Font = 0;
    toggle.Position = drawings[utility.getLength(drawings)].Position + Vector2.new(0, self.Padding);

    self.flags[flag] = default;

    table.insert(drawings, toggle);
    table.insert(interactables, toggle);
    table.insert(callbacks, callback);
    table.insert(objtypes, 1);
    table.insert(flagnames, flag);

    return toggle;
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

    self.Unloaded = true;
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
                toggled = library.flags[flagnames[selectedItem]];
                --callbacks[selectedItem](library.flags[flagnames[selectedItem]]);
                type(toggled);
                --callbacks[selectedItem](toggled);
            end
        end
    end
end)

return library;
