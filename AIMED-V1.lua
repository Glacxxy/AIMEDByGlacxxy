--==================================================
-- AIMED
--==================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

--==================================================
-- CONFIG
--==================================================

local Config = {
    ESP = false,
    TriggerBot = false,
    SnapAim = false,

    TeamCheck = true,
    WallCheck = true,

    FOV = 120,
    Smoothness = 0.25,

    -- AIM ASSIST IS HEAD ONLY
    TargetPart = "Head"
}

--==================================================
-- GUI SETTINGS
--==================================================

local MIN_WIDTH = 240
local MIN_HEIGHT = 300

local DEFAULT_WIDTH = 280
local DEFAULT_HEIGHT = 360

local minimized = false
local oldHeight = DEFAULT_HEIGHT

--==================================================
-- CLEAN OLD GUI
--==================================================

local old = CoreGui:FindFirstChild("AIMED")

if old then
    old:Destroy()
end

--==================================================
-- GUI
--==================================================

local gui = Instance.new("ScreenGui")
gui.Name = "AIMED"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Name = "AIMED_Main"

frame.Size = UDim2.fromOffset(
    DEFAULT_WIDTH,
    DEFAULT_HEIGHT
)

frame.Position = UDim2.new(
    0.5,
    -DEFAULT_WIDTH / 2,
    0.5,
    -DEFAULT_HEIGHT / 2
)

frame.BackgroundColor3 =
    Color3.fromRGB(18, 12, 25)

frame.BorderSizePixel = 0
frame.Active = true
frame.ClipsDescendants = true
frame.Parent = gui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 12)
frameCorner.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(140, 60, 255)
stroke.Thickness = 2
stroke.Parent = frame

--==================================================
-- HEADER
--==================================================

local handle = Instance.new("TextButton")

handle.Name = "AIMED_DragHandle"

handle.Size =
    UDim2.new(1, -45, 0, 42)

handle.Position =
    UDim2.fromOffset(0, 0)

handle.BackgroundTransparency = 1

handle.Text = "AIMED"

handle.TextColor3 =
    Color3.fromRGB(190, 120, 255)

handle.TextSize = 20
handle.Font = Enum.Font.GothamBold
handle.AutoButtonColor = false

handle.Parent = frame

--==================================================
-- MINIMIZE
--==================================================

local minimize = Instance.new("TextButton")

minimize.Name = "AIMED_Minimize"

minimize.Size =
    UDim2.fromOffset(42, 42)

minimize.Position =
    UDim2.new(1, -42, 0, 0)

minimize.BackgroundTransparency = 1

minimize.Text = "-"
minimize.TextColor3 =
    Color3.fromRGB(190, 120, 255)

minimize.TextSize = 25
minimize.Font = Enum.Font.GothamBold
minimize.AutoButtonColor = false

minimize.Parent = frame

minimize.Activated:Connect(function()

    minimized = not minimized

    if minimized then

        oldHeight =
            frame.AbsoluteSize.Y

        frame:TweenSize(
            UDim2.fromOffset(
                frame.AbsoluteSize.X,
                42
            ),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quad,
            0.15,
            true
        )

        minimize.Text = "+"

    else

        frame:TweenSize(
            UDim2.fromOffset(
                frame.AbsoluteSize.X,
                oldHeight
            ),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Quad,
            0.15,
            true
        )

        minimize.Text = "-"
    end
end)

--==================================================
-- CONTENT
--==================================================

local content = Instance.new("Frame")

content.Name = "AIMED_Content"

content.Size =
    UDim2.new(1, 0, 1, -42)

content.Position =
    UDim2.fromOffset(0, 42)

content.BackgroundTransparency = 1

content.Parent = frame

--==================================================
-- TOGGLE CREATOR
--==================================================

local function createToggle(text, y)

    local button =
        Instance.new("TextButton")

    button.Size =
        UDim2.new(1, -30, 0, 38)

    button.Position =
        UDim2.fromOffset(15, y)

    button.BackgroundColor3 =
        Color3.fromRGB(28, 20, 38)

    button.BorderSizePixel = 0

    button.TextColor3 =
        Color3.new(1, 1, 1)

    button.TextSize = 14

    button.Font =
        Enum.Font.GothamBold

    button.Parent = content

    local corner =
        Instance.new("UICorner")

    corner.CornerRadius =
        UDim.new(0, 8)

    corner.Parent = button

    return button
end

local function updateToggle(
    button,
    name,
    value
)

    button.Text =
        name ..
        ": " ..
        (value and "ON" or "OFF")

    if value then

        button.BackgroundColor3 =
            Color3.fromRGB(
                105,
                45,
                190
            )

    else

        button.BackgroundColor3 =
            Color3.fromRGB(
                28,
                20,
                38
            )
    end
end

--==================================================
-- ESP BUTTON
--==================================================

local espButton =
    createToggle(
        "ESP",
        8
    )

updateToggle(
    espButton,
    "ESP",
    Config.ESP
)

espButton.Activated:Connect(function()

    Config.ESP =
        not Config.ESP

    updateToggle(
        espButton,
        "ESP",
        Config.ESP
    )
end)

--==================================================
-- TRIGGERBOT BUTTON
--==================================================

local triggerButton =
    createToggle(
        "TRIGGERBOT",
        52
    )

updateToggle(
    triggerButton,
    "TRIGGERBOT",
    Config.TriggerBot
)

triggerButton.Activated:Connect(function()

    Config.TriggerBot =
        not Config.TriggerBot

    updateToggle(
        triggerButton,
        "TRIGGERBOT",
        Config.TriggerBot
    )
end)

--==================================================
-- SNAP AIM BUTTON
--==================================================

local aimButton =
    createToggle(
        "SNAP AIM",
        96
    )

updateToggle(
    aimButton,
    "SNAP AIM",
    Config.SnapAim
)

aimButton.Activated:Connect(function()

    Config.SnapAim =
        not Config.SnapAim

    updateToggle(
        aimButton,
        "SNAP AIM",
        Config.SnapAim
    )
end)

--==================================================
-- FOV
--==================================================

local fovInput =
    Instance.new("TextBox")

fovInput.Size =
    UDim2.new(1, -30, 0, 36)

fovInput.Position =
    UDim2.fromOffset(15, 140)

fovInput.BackgroundColor3 =
    Color3.fromRGB(28, 20, 38)

fovInput.BorderSizePixel = 0

fovInput.Text =
    tostring(Config.FOV)

fovInput.PlaceholderText =
    "FOV"

fovInput.TextColor3 =
    Color3.new(1, 1, 1)

fovInput.TextSize = 14
fovInput.Font = Enum.Font.Gotham

fovInput.ClearTextOnFocus = false

fovInput.Parent = content

local fovCorner =
    Instance.new("UICorner")

fovCorner.CornerRadius =
    UDim.new(0, 8)

fovCorner.Parent = fovInput

fovInput.FocusLost:Connect(function()

    local value =
        tonumber(fovInput.Text)

    if value then

        Config.FOV =
            math.clamp(
                value,
                10,
                1000
            )

        fovInput.Text =
            tostring(Config.FOV)

    else

        fovInput.Text =
            tostring(Config.FOV)
    end
end)

--==================================================
-- SMOOTHNESS
--==================================================

local smoothInput =
    Instance.new("TextBox")

smoothInput.Size =
    UDim2.new(1, -30, 0, 36)

smoothInput.Position =
    UDim2.fromOffset(15, 184)

smoothInput.BackgroundColor3 =
    Color3.fromRGB(28, 20, 38)

smoothInput.BorderSizePixel = 0

smoothInput.Text =
    tostring(Config.Smoothness)

smoothInput.PlaceholderText =
    "Smoothness"

smoothInput.TextColor3 =
    Color3.new(1, 1, 1)

smoothInput.TextSize = 14
smoothInput.Font = Enum.Font.Gotham

smoothInput.ClearTextOnFocus = false

smoothInput.Parent = content

local smoothCorner =
    Instance.new("UICorner")

smoothCorner.CornerRadius =
    UDim.new(0, 8)

smoothCorner.Parent = smoothInput

smoothInput.FocusLost:Connect(function()

    local value =
        tonumber(smoothInput.Text)

    if value then

        Config.Smoothness =
            math.clamp(
                value,
                0.01,
                1
            )

        smoothInput.Text =
            tostring(
                Config.Smoothness
            )

    else

        smoothInput.Text =
            tostring(
                Config.Smoothness
            )
    end
end)

--==================================================
-- TEAM CHECK
--==================================================

local teamButton =
    createToggle(
        "TEAM CHECK",
        228
    )

updateToggle(
    teamButton,
    "TEAM CHECK",
    Config.TeamCheck
)

teamButton.Activated:Connect(function()

    Config.TeamCheck =
        not Config.TeamCheck

    updateToggle(
        teamButton,
        "TEAM CHECK",
        Config.TeamCheck
    )
end)

--==================================================
-- DESTROY
--==================================================

local destroy =
    Instance.new("TextButton")

destroy.Size =
    UDim2.new(1, -30, 0, 35)

destroy.Position =
    UDim2.fromOffset(15, 272)

destroy.BackgroundColor3 =
    Color3.fromRGB(55, 25, 65)

destroy.BorderSizePixel = 0

destroy.Text = "DESTROY"

destroy.TextColor3 =
    Color3.fromRGB(
        220,
        180,
        255
    )

destroy.TextSize = 14
destroy.Font = Enum.Font.GothamBold

destroy.Parent = content

local destroyCorner =
    Instance.new("UICorner")

destroyCorner.CornerRadius =
    UDim.new(0, 8)

destroyCorner.Parent = destroy

--==================================================
-- RESIZE HANDLES
--==================================================

local resizeLeft =
    Instance.new("TextButton")

resizeLeft.Name =
    "AIMED_ResizeLeft"

resizeLeft.Size =
    UDim2.fromOffset(28, 28)

resizeLeft.Position =
    UDim2.new(
        0,
        0,
        1,
        -28
    )

resizeLeft.BackgroundTransparency = 1
resizeLeft.Text = ""
resizeLeft.AutoButtonColor = false
resizeLeft.ZIndex = 20

resizeLeft.Parent = frame

local resizeRight =
    Instance.new("TextButton")

resizeRight.Name =
    "AIMED_ResizeRight"

resizeRight.Size =
    UDim2.fromOffset(28, 28)

resizeRight.Position =
    UDim2.new(
        1,
        -28,
        1,
        -28
    )

resizeRight.BackgroundTransparency = 1
resizeRight.Text = ""
resizeRight.AutoButtonColor = false
resizeRight.ZIndex = 20

resizeRight.Parent = frame

--==================================================
-- RESIZE LOGIC
--==================================================

local resizingLeft = false
local resizingRight = false

local resizeStart
local startWidth
local startHeight
local startX
local startY

resizeLeft.InputBegan:Connect(function(input)

    if minimized then
        return
    end

    if input.UserInputType ==
        Enum.UserInputType.MouseButton1
        or input.UserInputType ==
        Enum.UserInputType.Touch then

        resizingLeft = true

        resizeStart =
            input.Position

        startWidth =
            frame.AbsoluteSize.X

        startHeight =
            frame.AbsoluteSize.Y

        startX =
            frame.AbsolutePosition.X

        startY =
            frame.AbsolutePosition.Y
    end
end)

resizeRight.InputBegan:Connect(function(input)

    if minimized then
        return
    end

    if input.UserInputType ==
        Enum.UserInputType.MouseButton1
        or input.UserInputType ==
        Enum.UserInputType.Touch then

        resizingRight = true

        resizeStart =
            input.Position

        startWidth =
            frame.AbsoluteSize.X

        startHeight =
            frame.AbsoluteSize.Y

        startX =
            frame.AbsolutePosition.X

        startY =
            frame.AbsolutePosition.Y
    end
end)

UserInputService.InputEnded:Connect(function(input)

    if input.UserInputType ==
        Enum.UserInputType.MouseButton1
        or input.UserInputType ==
        Enum.UserInputType.Touch then

        resizingLeft = false
        resizingRight = false

        resizeStart = nil
    end
end)

UserInputService.InputChanged:Connect(function(input)

    if minimized then
        return
    end

    if not resizeStart then
        return
    end

    if input.UserInputType ~=
        Enum.UserInputType.MouseMovement
        and input.UserInputType ~=
        Enum.UserInputType.Touch then

        return
    end

    local delta =
        input.Position -
        resizeStart

    -- RIGHT CORNER
    if resizingRight then

        local newWidth =
            math.max(
                MIN_WIDTH,
                startWidth + delta.X
            )

        local newHeight =
            math.max(
                MIN_HEIGHT,
                startHeight + delta.Y
            )

        frame.Size =
            UDim2.fromOffset(
                newWidth,
                newHeight
            )
    end

    -- LEFT CORNER
    if resizingLeft then

        local newWidth =
            math.max(
                MIN_WIDTH,
                startWidth - delta.X
            )

        local newHeight =
            math.max(
                MIN_HEIGHT,
                startHeight + delta.Y
            )

        local rightEdge =
            startX + startWidth

        local newX =
            rightEdge - newWidth

        frame.Position =
            UDim2.fromOffset(
                newX,
                startY
            )

        frame.Size =
            UDim2.fromOffset(
                newWidth,
                newHeight
            )
    end
end)

--==================================================
-- DRAGGING
--==================================================

local dragging = false
local dragStart
local startPosition

handle.InputBegan:Connect(function(input)

    if input.UserInputType ==
        Enum.UserInputType.MouseButton1
        or input.UserInputType ==
        Enum.UserInputType.Touch then

        dragging = true

        dragStart =
            input.Position

        startPosition =
            frame.Position
    end
end)

handle.InputEnded:Connect(function(input)

    if input.UserInputType ==
        Enum.UserInputType.MouseButton1
        or input.UserInputType ==
        Enum.UserInputType.Touch then

        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)

    if not dragging then
        return
    end

    if input.UserInputType ==
        Enum.UserInputType.MouseMovement
        or input.UserInputType ==
        Enum.UserInputType.Touch then

        local delta =
            input.Position -
            dragStart

        frame.Position =
            UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,

                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
    end
end)

--==================================================
-- CHARACTER HELPERS
--==================================================

local function getCharacter(player)

    return player and player.Character
end

local function getTargetPart(character)

    if not character then
        return nil
    end

    -- HEAD ONLY
    return character:FindFirstChild("Head")
end

local function isAlive(character)

    local humanoid =
        character and
        character:FindFirstChildOfClass(
            "Humanoid"
        )

    return humanoid ~= nil
        and humanoid.Health > 0
end

local function isEnemy(player)

    if player == LocalPlayer then
        return false
    end

    if Config.TeamCheck then

        if LocalPlayer.Team ~= nil
            and player.Team ~= nil
            and LocalPlayer.Team ==
                player.Team then

            return false
        end
    end

    return true
end

--==================================================
-- LINE OF SIGHT
--==================================================

local function hasLineOfSight(part)

    local camera =
        workspace.CurrentCamera

    if not camera or not part then
        return false
    end

    local origin =
        camera.CFrame.Position

    local direction =
        part.Position - origin

    local params =
        RaycastParams.new()

    params.FilterType =
        Enum.RaycastFilterType.Exclude

    params.FilterDescendantsInstances = {
        LocalPlayer.Character
    }

    params.IgnoreWater = true

    local result =
        workspace:Raycast(
            origin,
            direction,
            params
        )

    if not result then
        return true
    end

    return result.Instance:IsDescendantOf(
        part.Parent
    )
end

--==================================================
-- CROSSHAIR TARGET
--==================================================

local function getCrosshairTarget()

    local camera =
        workspace.CurrentCamera

    if not camera then
        return nil
    end

    local viewport =
        camera.ViewportSize

    local crosshair =
        Vector2.new(
            viewport.X / 2,
            viewport.Y / 2
        )

    local closest = nil

    local closestDistance =
        Config.FOV

    for _, player in ipairs(
        Players:GetPlayers()
    ) do

        if isEnemy(player) then

            local character =
                getCharacter(player)

            if character
                and isAlive(character) then

                -- HEAD ONLY
                local head =
                    getTargetPart(character)

                if head then

                    local screenPosition,
                        visible =
                        camera:WorldToViewportPoint(
                            head.Position
                        )

                    if visible
                        and screenPosition.Z > 0 then

                        local position =
                            Vector2.new(
                                screenPosition.X,
                                screenPosition.Y
                            )

                        local distance =
                            (
                                position -
                                crosshair
                            ).Magnitude

                        if distance <=
                            closestDistance then

                            if not Config.WallCheck
                                or hasLineOfSight(
                                    head
                                ) then

                                closestDistance =
                                    distance

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

--==================================================
-- ESP
--==================================================

local highlights = {}

local function removeESP(player)

    local highlight =
        highlights[player]

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

    local character =
        player.Character

    if not character then
        return
    end

    if not isAlive(character) then
        return
    end

    local existing =
        highlights[player]

    -- Make sure the highlight is attached
    -- to the CURRENT character.
    if existing then

        if existing.Adornee ~= character
            or existing.Parent ~= character then

            existing:Destroy()
            existing = nil
            highlights[player] = nil
        end
    end

    if not existing then

        existing =
            Instance.new("Highlight")

        existing.Name =
            "AIMED_ESP"

        existing.Adornee =
            character

        existing.Parent =
            character

        -- Important for ESP through walls.
        existing.DepthMode =
            Enum.HighlightDepthMode.AlwaysOnTop

        existing.FillTransparency =
            0.65

        existing.OutlineTransparency =
            0

        existing.FillColor =
            Color3.fromRGB(
                170,
                70,
                255
            )

        existing.OutlineColor =
            Color3.fromRGB(
                255,
                255,
                255
            )

        highlights[player] =
            existing
    end
end

local function updateESP()

    if not Config.ESP then

        for player in pairs(highlights) do
            removeESP(player)
        end

        return
    end

    for _, player in ipairs(
        Players:GetPlayers()
    ) do

        createESP(player)
    end
end

--==================================================
-- RESPAWN ESP
--==================================================

local function setupPlayer(player)

    if player == LocalPlayer then
        return
    end

    player.CharacterAdded:Connect(
        function(character)

            removeESP(player)

            if Config.ESP then

                -- Wait for the character's
                -- parts to exist.
                character:WaitForChild(
                    "Humanoid",
                    5
                )

                createESP(player)
            end
        end
    )
end

for _, player in ipairs(
    Players:GetPlayers()
) do

    setupPlayer(player)
end

Players.PlayerAdded:Connect(
    function(player)

        setupPlayer(player)

        if Config.ESP then
            task.wait(0.1)
            createESP(player)
        end
    end
)

Players.PlayerRemoving:Connect(
    function(player)

        removeESP(player)
    end
)

--==================================================
-- SNAP AIM
--==================================================

local function snapAim(target)

    local camera =
        workspace.CurrentCamera

    if not camera or not target then
        return
    end

    -- HEAD ONLY
    local head =
        target.Character
        and target.Character:FindFirstChild(
            "Head"
        )

    if not head then
        return
    end

    if Config.WallCheck
        and not hasLineOfSight(head) then

        return
    end

    local desired =
        CFrame.lookAt(
            camera.CFrame.Position,
            head.Position
        )

    camera.CFrame =
        camera.CFrame:Lerp(
            desired,
            Config.Smoothness
        )
end

--==================================================
-- TRIGGERBOT
--==================================================

local function triggerWeapon()

    local character =
        LocalPlayer.Character

    if not character then
        return
    end

    local tool =
        character:FindFirstChildOfClass(
            "Tool"
        )

    if not tool then
        return
    end

    pcall(function()

        tool:Activate()
    end)
end

--==================================================
-- MAIN LOOP
--==================================================

local connection

connection =
    RunService.RenderStepped:Connect(
        function()

        if not gui.Parent then

            if connection then
                connection:Disconnect()
            end

            return
        end

        updateESP()

        local target =
            getCrosshairTarget()

        if not target then
            return
        end

        -- AIM ASSIST -> HEAD
        if Config.SnapAim then

            snapAim(target)
        end

        -- TRIGGERBOT
        if Config.TriggerBot then

            -- Final LOS check immediately
            -- before firing.
            if not Config.WallCheck
                or hasLineOfSight(
                    target.Part
                ) then

                triggerWeapon()
            end
        end
    end)

--==================================================
-- DESTROY EVERYTHING
--==================================================

destroy.Activated:Connect(function()

    if connection then
        connection:Disconnect()
    end

    for player, highlight in pairs(
        highlights
    ) do

        if highlight then
            highlight:Destroy()
        end
    end

    table.clear(highlights)

    gui:Destroy()
end)