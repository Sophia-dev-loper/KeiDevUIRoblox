-- KeiDev UI Library v1.0
local KeiDev = {}
KeiDev.__index = KeiDev

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

function KeiDev:init(title, toggle, key, drag)
    local self = setmetatable({}, KeiDev)

    local gui = Instance.new("ScreenGui")
    gui.Name = "KeiDevUI"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = CoreGui

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 500, 0, 400)
    main.Position = UDim2.new(0.5, -250, 0.5, -200)
    main.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    main.BorderSizePixel = 0
    main.Parent = gui
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 18)

    -- Topbar
    local topbar = Instance.new("Frame")
    topbar.Size = UDim2.new(1, 0, 0, 45)
    topbar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    topbar.BorderSizePixel = 0
    topbar.Parent = main
    Instance.new("UICorner", topbar).CornerRadius = UDim.new(0, 18)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = title or "KeiDev"
    titleLabel.Size = UDim2.new(1, -15, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = Color3.fromRGB(73, 166, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 18
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = topbar

    -- Drag
    if drag then
        local dragging, dragStart, startPos
        topbar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = main.Position
                input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
                local delta = input.Position - dragStart
                main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end

    -- Toggle Key
    if toggle then
        UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == key then
                gui.Enabled = not gui.Enabled
            end
        end)
    end

    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, -10, 1, -55)
    content.Position = UDim2.new(0, 5, 0, 50)
    content.BackgroundTransparency = 1
    content.ScrollBarThickness = 3
    content.Parent = main
    Instance.new("UIListLayout", content).Padding = UDim.new(0, 8)

    self.Main = main
    self.Content = content
    self.Gui = gui

    return self
end

function KeiDev:Divider(text)
    local label = Instance.new("TextLabel")
    label.Text = "─── "..text.." ───"
    label.Size = UDim2.new(1, 0, 0, 25)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(120, 120, 120)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.Parent = self.Content
end

function KeiDev:Section(name)
    local section = {}
    section.Parent = self.Content

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 30)
    frame.BackgroundTransparency = 1
    frame.Parent = self.Content

    local label = Instance.new("TextLabel")
    label.Text = name
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(73, 166, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    function section:Divider(text) self.Parent:Divider(text) end
    function section:Button(text, callback)
        local btn = Instance.new("TextButton")
        btn.Text = text
        btn.Size = UDim2.new(1, 0, 0, 40)
        btn.BackgroundColor3 = Color3.fromRGB(123, 44, 255)
        btn.TextColor3 = Color3.white
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 14
        btn.Parent = self.Parent
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
        btn.MouseButton1Click:Connect(callback)
    end
    function section:Label(text)
        local lbl = Instance.new("TextLabel")
        lbl.Text = text
        lbl.Size = UDim2.new(1, 0, 0, 25)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 14
        lbl.Parent = self.Parent
    end
    function section:Switch(text, default, callback)
        local state = default
        local btn = Instance.new("TextButton")
        btn.Text = text..": "..(state and "ON" or "OFF")
        btn.Size = UDim2.new(1, 0, 0, 40)
        btn.BackgroundColor3 = state and Color3.fromRGB(57, 255, 141) or Color3.fromRGB(30, 30, 30)
        btn.TextColor3 = Color3.white
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        btn.Parent = self.Parent
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.Text = text..": "..(state and "ON" or "OFF")
            btn.BackgroundColor3 = state and Color3.fromRGB(57, 255, 141) or Color3.fromRGB(30, 30, 30)
            callback(state)
        end)
    end
    function section:TextField(placeholder, default, callback)
        local box = Instance.new("TextBox")
        box.PlaceholderText = placeholder
        box.Text = default
        box.Size = UDim2.new(1, 0, 0, 40)
        box.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        box.TextColor3 = Color3.white
        box.Font = Enum.Font.Gotham
        box.TextSize = 14
        box.Parent = self.Parent
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 12)
        box.FocusLost:Connect(function() callback(box.Text) end)
    end
    function section:Select() end -- placeholder

    return section
end

function KeiDev:TempNotify(title, text, icon)
    game.StarterGui:SetCore("SendNotification", {Title=title; Text=text; Duration=3; Icon=icon})
end

function KeiDev:Notify(title, text, btnText, icon, callback)
    self:TempNotify(title, text.." ["..btnText.."]", icon)
    callback()
end

function KeiDev:Notify2(title, text, btn1, btn2, icon, cb1, cb2)
    self:TempNotify(title, text.." ["..btn1.."/"..btn2.."]", icon)
    cb1()
end

function KeiDev:GreenButton(callback)
    local btn = Instance.new("TextButton")
    btn.Text = "KeiDev Green Button"
    btn.Size = UDim2.new(1, -10, 0, 45)
    btn.Position = UDim2.new(0, 5, 1, -50)
    btn.BackgroundColor3 = Color3.fromRGB(57, 255, 141)
    btn.TextColor3 = Color3.black
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.Parent = self.Main
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
    btn.MouseButton1Click:Connect(callback)
end

return KeiDev
