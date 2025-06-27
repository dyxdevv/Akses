local AimbotGUI = Instance.new("ScreenGui")
local Background = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local Divider = Instance.new("Frame")
local EnableToggle = Instance.new("TextButton")
local UICorner_2 = Instance.new("UICorner")
local StatusLabel = Instance.new("TextLabel")
local Credits = Instance.new("TextLabel")

-- Properties:
AimbotGUI.Name = "AimbotGUI"
AimbotGUI.ResetOnSpawn = false
AimbotGUI.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

Background.Name = "Background"
Background.Parent = AimbotGUI
Background.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Background.Position = UDim2.new(0.5, -65, 0.5, -50)
Background.Size = UDim2.new(0, 130, 0, 100)
Background.Active = true
Background.Draggable = true

UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = Background

Title.Name = "Title"
Title.Parent = Background
Title.BackgroundTransparency = 1.000
Title.Position = UDim2.new(0, 0, 0, 5)
Title.Size = UDim2.new(1, 0, 0, 15)
Title.Font = Enum.Font.GothamBold
Title.Text = "ZenoVa | Aimbot v2"
Title.TextSize = 14.000

Divider.Name = "Divider"
Divider.Parent = Background
Divider.BorderSizePixel = 0
Divider.Position = UDim2.new(0, 0, 0, 20)
Divider.Size = UDim2.new(1, 0, 0, 1)

EnableToggle.Name = "EnableToggle"
EnableToggle.Parent = Background
EnableToggle.Position = UDim2.new(0.5, -40, 0.5, -15)
EnableToggle.Size = UDim2.new(0, 80, 0, 25)
EnableToggle.Font = Enum.Font.Gotham
EnableToggle.Text = "TOGGLE"
EnableToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
EnableToggle.TextSize = 11.000

UICorner_2.CornerRadius = UDim.new(0, 4)
UICorner_2.Parent = EnableToggle

StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = Background
StatusLabel.BackgroundTransparency = 1.000
StatusLabel.Position = UDim2.new(0.5, -40, 0.5, 10)
StatusLabel.Size = UDim2.new(0, 80, 0, 15)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Text = "STATUS: OFF"
StatusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
StatusLabel.TextSize = 11.000

Credits.Name = "Credits"
Credits.Parent = Background
Credits.BackgroundTransparency = 1.000
Credits.Position = UDim2.new(0, 0, 1, -15)
Credits.Size = UDim2.new(1, 0, 0, 15)
Credits.Font = Enum.Font.Gotham
Credits.Text = "by Zenoid | dyxdev"
Credits.TextColor3 = Color3.fromRGB(150, 150, 150)
Credits.TextSize = 9.000

-- Rainbow Effects
local RunService = game:GetService("RunService")
local rainbowSpeed = 0.5
local hue = 0

local function updateRainbowColors()
    hue = (hue + rainbowSpeed/360) % 1
    local rainbowColor = Color3.fromHSV(hue, 0.8, 0.9)
    
    -- Update GUI colors
    Title.TextColor3 = rainbowColor
    Divider.BackgroundColor3 = rainbowColor
    EnableToggle.BackgroundColor3 = Color3.fromRGB(
        math.floor(rainbowColor.R * 25),
        math.floor(rainbowColor.G * 25),
        math.floor(rainbowColor.B * 25)
    )
end

-- Rainbow FOV circle
local fov = 100
local Players = game:GetService("Players")
local Cam = game.Workspace.CurrentCamera

local FOVring = Drawing.new("Circle")
FOVring.Visible = false
FOVring.Thickness = 2
FOVring.Filled = false
FOVring.Radius = fov
FOVring.Position = Cam.ViewportSize / 2

local function updateDrawings()
    local camViewportSize = Cam.ViewportSize
    FOVring.Position = camViewportSize / 2
    FOVring.Color = Color3.fromHSV((hue + 0.3) % 1, 1, 1)
end

local aimbotEnabled = false

local function toggleAimbot()
    aimbotEnabled = not aimbotEnabled
    EnableToggle.Text = aimbotEnabled and "ON" or "OFF"
    StatusLabel.Text = aimbotEnabled and "STATUS: ON" or "STATUS: OFF"
    StatusLabel.TextColor3 = aimbotEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 50, 50)
    FOVring.Visible = aimbotEnabled
end

EnableToggle.MouseButton1Click:Connect(toggleAimbot)

-- Aimbot functionality
local function lookAt(target)
    local lookVector = (target - Cam.CFrame.Position).unit
    Cam.CFrame = CFrame.new(Cam.CFrame.Position, Cam.CFrame.Position + lookVector)
end

local function getClosestPlayerInFOV(trg_part)
    local nearest = nil
    local last = math.huge
    local playerMousePos = Cam.ViewportSize / 2
    local localPlayer = Players.LocalPlayer
    local localTeam = localPlayer.Team

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and (not player.Team or player.Team ~= localTeam) then
            local part = player.Character and player.Character:FindFirstChild(trg_part)
            if part then
                local ePos, isVisible = Cam:WorldToViewportPoint(part.Position)
                local distance = (Vector2.new(ePos.x, ePos.y) - playerMousePos).Magnitude

                if distance < last and isVisible and distance < fov then
                    last = distance
                    nearest = player
                end
            end
        end
    end
    return nearest
end

-- Main loop
RunService.RenderStepped:Connect(function()
    updateRainbowColors()
    updateDrawings()
    
    if aimbotEnabled then
        local closest = getClosestPlayerInFOV("Head")
        if closest and closest.Character:FindFirstChild("Head") then
            lookAt(closest.Character.Head.Position)
        end
    end
end)