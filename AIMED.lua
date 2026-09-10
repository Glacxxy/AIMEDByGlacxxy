-- AIMED
-- Authorized replica/test environment

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

local Config = {
    ESP = false,
    TriggerBot = false,
    SnapAim = false,

    TeamCheck = true,
    WallCheck = true,

    FOV = 120,
    Smoothness = 0.25,

    TargetPart = "Head"
}

local MIN_WIDTH = 240
local MIN_HEIGHT = 300
local DEFAULT_WIDTH = 280
local DEFAULT_HEIGHT = 360

local minimized = false
local oldHeight = DEFAULT_HEIGHT

local gui = Instance.new("ScreenGui")
gui.Name = "AIMED"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(DEFAULT_WIDTH, DEFAULT_HEIGHT)
main.Position = UDim2.new(0.5, -DEFAULT_WIDTH / 2, 0.5, -DEFAULT_HEIGHT / 2)
main.BackgroundColor3 = Color3.fromRGB(25, 18, 35)
main.BorderSizePixel = 0
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(170, 70, 255)
stroke.Thickness = 2
stroke.Parent = main

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 42)
header.BackgroundColor3 = Color3.fromRGB(35, 24, 48)
header.BorderSizePixel = 0
header.Parent = main

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 10)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -55, 1, 0)
title.Position = UDim2.fromOffset(15, 0)
title.BackgroundTransparency = 1
title.Text = "AIMED"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.fromOffset(36, 30)
minimize.Position = UDim2.new(1, -42, 0, 6)
minimize.BackgroundColor3 = Color3.fromRGB(55, 38, 70)
minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
minimize.Text = "-"
minimize.TextSize = 20
minimize.Font = Enum.Font.GothamBold
minimize.Parent = header

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 7)
minCorner.Parent = minimize

local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -20, 1, -52)
content.Position = UDim2.fromOffset(10, 47)
content.BackgroundTransparency = 1
content.Parent = main

local function makeButton(text, y)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 38)
    button.Position = UDim2.fromOffset(0, y)
    button.BackgroundColor3 = Color3.fromRGB(45, 31, 58)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = text
    button.TextSize = 15
    button.Font = Enum.Font.Gotham
    button.Parent = content

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 7)
    c.Parent = button

    return button
end

local espButton = makeButton("ESP: OFF", 0)
local triggerButton = makeButton("TriggerBot: OFF", 48)
local snapButton = makeButton("Snap Aim: OFF", 96)

local fovLabel = Instance.new("TextLabel")
fovLabel.Size = UDim2.new(1, 0, 0, 30)
fovLabel.Position = UDim2.fromOffset(0, 150)
fovLabel.BackgroundTransparency = 1
fovLabel.Text = "FOV: 120"
fovLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
fovLabel.TextSize = 14
fovLabel.Font = Enum.Font.Gotham
fovLabel.Parent = content

local fovBox = Instance.new("TextBox")
fovBox.Size = UDim2.new(1, 0, 0, 36)
fovBox.Position = UDim2.fromOffset(0, 182)
fovBox.BackgroundColor3 = Color3.fromRGB(45, 31, 58)
fovBox.TextColor3 = Color3.fromRGB(255, 255, 255)
fovBox.PlaceholderText = "FOV"
fovBox.Text = tostring(Config.FOV)
fovBox.TextSize = 14
fovBox.Font = Enum.Font.Gotham
fovBox.ClearTextOnFocus = false
fovBox.Parent = content

local fovCorner = Instance.new("UICorner")
fovCorner.CornerRadius = UDim.new(0, 7)
fovCorner.Parent = fovBox

local smoothLabel = Instance.new("TextLabel")
smoothLabel.Size = UDim2.new(1, 0, 0, 30)
smoothLabel.Position = UDim2.fromOffset(0, 226)
smoothLabel.BackgroundTransparency = 1
smoothLabel.Text = "Smoothness: 0.25"
smoothLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
smoothLabel.TextSize = 14
smoothLabel.Font = Enum.Font.Gotham
smoothLabel.Parent = content

local smoothBox = Instance.new("TextBox")
smoothBox.Size = UDim2.new(1, 0, 0, 36)
smoothBox.Position = UDim2.fromOffset(0, 258)
smoothBox.BackgroundColor3 = Color3.fromRGB(45, 31, 58)
smoothBox.TextColor3 = Color3.fromRGB(255, 255, 255)
smoothBox.PlaceholderText = "Smoothness"
smoothBox.Text = tostring(Config.Smoothness)
smoothBox.TextSize = 14
smoothBox.Font = Enum.Font.Gotham
smoothBox.ClearTextOnFocus = false
smoothBox.Parent = content

local smoothCorner = Instance.new("UICorner")
smoothCorner.CornerRadius = UDim.new(0, 7)
smoothCorner.Parent = smoothBox

local function isAlive(character)
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    return humanoid and humanoid.Health > 0
end

local function isEnemy(player)
    if player == LocalPlayer then
        return false
    end

    if not Config.TeamCheck then
        return true
    end

    return player.Team ~= LocalPlayer.Team
end

local function getTargetPart(character)
    if not character then
        return nil
    end

    return character:FindFirstChild("Head")
end

local function hasLineOfSight(part)
    local camera = workspace.CurrentCamera
    if not camera or not part then
        return false
    end

    local origin = camera.CFrame.Position
    local direction = part.Position - origin

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {
        LocalPlayer.Character
    }
    params.IgnoreWater = true

    local result = workspace:Raycast(origin, direction, params)

    if not result then
        return true
    end

    return result.Instance:IsDescendantOf(part.Parent)
end

local function getTarget()
    local camera = workspace.CurrentCamera
    if not camera then
        return nil
    end

    local viewport = camera.ViewportSize
    local crosshair = Vector2.new(viewport.X / 2, viewport.Y / 2)

    local closest = nil
    local closestDistance = Config.FOV

    for _, player in ipairs(Players:GetPlayers()) do
        if isEnemy(player) then
            local character = player.Character

            if character and isAlive(character) then
                local head = getTargetPart(character)

                if head then
                    local screenPosition, visible = camera:WorldToViewportPoint(head.Position)

                    if visible and screenPosition.Z > 0 then
                        local distance = (
                            Vector2.new(screenPosition.X, screenPosition.Y)
                            - crosshair
                        ).Magnitude

                        if distance <= closestDistance then
                            if not Config.WallCheck or hasLineOfSight(head) then
                                closestDistance = distance
                                closest = {
                                    Player = player,
                                    Character = character,
                                    Part = head
                                }
                            end
                        end
                    end
                end
            end
        end
    end

    return closest
end

local function triggerWeapon()
    local character = LocalPlayer.Character
    if not character then
        return
    end

    local tool = character:FindFirstChildOfClass("Tool")
    if not tool then
        return
    end

    pcall(function()
        tool:Activate()
    end)
end

local highlights = {}

local function removeESP(player)
    local highlight = highlights[player]

    if highlight then
        highlight:Destroy()
        highlights[player] = nil
    end
end

local function createESP(player)
    if player == LocalPlayer then
        return
    end

    if not isEnemy(player) then
        removeESP(player)
        return
    end

    local character = player.Character
    if not character then
        return
    end

    if not isAlive(character) then
        return
    end

    local existing = highlights[player]

    if existing then
        if existing.Adornee ~= character or existing.Parent ~= character then
            existing:Destroy()
            existing = nil
            highlights[player] = nil
        end
    end

    if not existing then
        existing = Instance.new("Highlight")
        existing.Name = "AIMED_ESP"
        existing.Adornee = character
        existing.Parent = character
        existing.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        existing.FillTransparency = 0.65
        existing.OutlineTransparency = 0
        existing.FillColor = Color3.fromRGB(170, 70, 255)
        existing.OutlineColor = Color3.fromRGB(255, 255, 255)

        highlights[player] = existing
    end
end

local function updateESP()
    if not Config.ESP then
        for player in pairs(highlights) do
            removeESP(player)
        end
        return
    end

    for _, player in ipairs(Players:GetPlayers()) do
        createESP(player)
    end
end

local function setupPlayer(player)
    if player == LocalPlayer then
        return
    end

    player.CharacterAdded:Connect(function(character)
        removeESP(player)

        if Config.ESP then
            character:WaitForChild("Humanoid", 5)
            createESP(player)
        end
    end)
end

for _, player in ipairs(Players:GetPlayers()) do
    setupPlayer(player)
end

Players.PlayerAdded:Connect(function(player)
    setupPlayer(player)

    if Config.ESP then
        task.wait(0.1)
        createESP(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

espButton.MouseButton1Click:Connect(function()
    Config.ESP = not Config.ESP
    espButton.Text = "ESP: " .. (Config.ESP and "ON" or "OFF")
    updateESP()
end)

triggerButton.MouseButton1Click:Connect(function()
    Config.TriggerBot = not Config.TriggerBot
    triggerButton.Text = "TriggerBot: " .. (Config.TriggerBot and "ON" or "OFF")
end)

snapButton.MouseButton1Click:Connect(function()
    Config.SnapAim = not Config.SnapAim
    snapButton.Text = "Snap Aim: " .. (Config.SnapAim and "ON" or "OFF")
end)

fovBox.FocusLost:Connect(function()
    local value = tonumber(fovBox.Text)

    if value then
        Config.FOV = math.max(1, value)
        fovLabel.Text = "FOV: " .. tostring(Config.FOV)
        fovBox.Text = tostring(Config.FOV)
    else
        fovBox.Text = tostring(Config.FOV)
    end
end)

smoothBox.FocusLost:Connect(function()
    local value = tonumber(smoothBox.Text)

    if value then
        Config.Smoothness = math.clamp(value, 0.01, 1)
        smoothLabel.Text = "Smoothness: " .. tostring(Config.Smoothness)
        smoothBox.Text = tostring(Config.Smoothness)
    else
        smoothBox.Text = tostring(Config.Smoothness)
    end
end)

minimize.MouseButton1Click:Connect(function()
    minimized = not minimized

    if minimized then
        oldHeight = main.AbsoluteSize.Y
        content.Visible = false
        minimize.Text = "+"

        TweenService:Create(
            main,
            TweenInfo.new(0.2),
            {Size = UDim2.fromOffset(main.AbsoluteSize.X, 42)}
        ):Play()
    else
        content.Visible = true
        minimize.Text = "-"

        TweenService:Create(
            main,
            TweenInfo.new(0.2),
            {Size = UDim2.fromOffset(main.AbsoluteSize.X, math.max(oldHeight, MIN_HEIGHT))}
        ):Play()
    end
end)

local dragging = false
local dragStart
local startPos

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPos = main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not dragging then
        return
    end

    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then

        local delta = input.Position - dragStart

        main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

local resizing = false
local resizeSide = nil
local resizeStart
local resizeStartSize
local resizeStartPos

local leftResize = Instance.new("TextButton")
leftResize.Name = "ResizeLeft"
leftResize.Size = UDim2.fromOffset(14, 14)
leftResize.Position = UDim2.new(0, 0, 1, -14)
leftResize.BackgroundTransparency = 1
leftResize.Text = ""
leftResize.Parent = main

local rightResize = Instance.new("TextButton")
rightResize.Name = "ResizeRight"
rightResize.Size = UDim2.fromOffset(14, 14)
rightResize.Position = UDim2.new(1, -14, 1, -14)
rightResize.BackgroundTransparency = 1
rightResize.Text = ""
rightResize.Parent = main

local function beginResize(side, input)
    resizing = true
    resizeSide = side
    resizeStart = input.Position
    resizeStartSize = main.AbsoluteSize
    resizeStartPos = main.AbsolutePosition

    input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
            resizing = false
            resizeSide = nil
        end
    end)
end

leftResize.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        beginResize("Left", input)
    end
end)

rightResize.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        beginResize("Right", input)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not resizing then
        return
    end

    if input.UserInputType ~= Enum.UserInputType.MouseMovement
        and input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end

    local delta = input.Position - resizeStart

    local width = resizeStartSize.X
    local height = math.max(MIN_HEIGHT, resizeStartSize.Y + delta.Y)

    if resizeSide == "Right" then
        width = math.max(MIN_WIDTH, resizeStartSize.X + delta.X)

        main.Size = UDim2.fromOffset(width, height)
    elseif resizeSide == "Left" then
        width = math.max(MIN_WIDTH, resizeStartSize.X - delta.X)

        local newX = resizeStartPos.X + (resizeStartSize.X - width)

        main.Size = UDim2.fromOffset(width, height)
        main.Position = UDim2.fromOffset(newX, resizeStartPos.Y)
    end
end)

RunService.RenderStepped:Connect(function()
    updateESP()

    if Config.SnapAim then
        local target = getTarget()

        if target and target.Part then
            local camera = workspace.CurrentCamera

            if camera then
                local desired = CFrame.lookAt(
                    camera.CFrame.Position,
                    target.Part.Position
                )

                camera.CFrame = camera.CFrame:Lerp(
                    desired,
                    Config.Smoothness
                )
            end
        end
    end

    if Config.TriggerBot then
        local target = getTarget()

        if target and target.Part and hasLineOfSight(target.Part) then
            triggerWeapon()
        end
    end
end)
