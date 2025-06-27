--[[
    Aimbot GUI v2.1
    Ultra Compact UI
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Main GUI
local AimbotGUI = Instance.new("ScreenGui")
AimbotGUI.Name = "AimbotGUI"
AimbotGUI.ResetOnSpawn = false
AimbotGUI.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame (Smaller size)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = AimbotGUI
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BackgroundTransparency = 0.2
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.8, 0, 0.5, -50)
MainFrame.Size = UDim2.new(0, 120, 0, 100) -- Smaller size
MainFrame.Active = true
MainFrame.Draggable = true

-- Corner Radius
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 20) -- Smaller title bar

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 6)
TitleCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = TitleBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 8, 0, 0)
Title.Size = UDim2.new(1, -8, 1, 0)
Title.Font = Enum.Font.GothamSemibold
Title.Text = "AIMBOT"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 12 -- Smaller text
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Toggle Button
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = MainFrame
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50) -- Red when off
ToggleButton.Position = UDim2.new(0.1, 0, 0.25, 0)
ToggleButton.Size = UDim2.new(0.8, 0, 0, 25) -- Smaller button
ToggleButton.Font = Enum.Font.GothamSemibold
ToggleButton.Text = "OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 12
ToggleButton.AutoButtonColor = false

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 4)
ButtonCorner.Parent = ToggleButton

-- Status Indicator (Removed separate indicator since button shows status)

-- Footer
local Footer = Instance.new("Frame")
Footer.Name = "Footer"
Footer.Parent = MainFrame
Footer.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Footer.BorderSizePixel = 0
Footer.Position = UDim2.new(0, 0, 1, -15)
Footer.Size = UDim2.new(1, 0, 0, 15)

local FooterCorner = Instance.new("UICorner")
FooterCorner.CornerRadius = UDim.new(0, 6)
FooterCorner.Parent = Footer

local FooterText = Instance.new("TextLabel")
FooterText.Name = "FooterText"
FooterText.Parent = Footer
FooterText.BackgroundTransparency = 1
FooterText.Size = UDim2.new(1, 0, 1, 0)
FooterText.Font = Enum.Font.Gotham
FooterText.Text = "by Bloodscript"
FooterText.TextColor3 = Color3.fromRGB(200, 200, 200)
FooterText.TextSize = 10

-- FOV Circle (Smaller radius with dot in center)
local fov = 60 -- Smaller FOV circle
local Cam = game.Workspace.CurrentCamera
local FOVring = Drawing.new("Circle")
FOVring.Visible = false
FOVring.Thickness = 1
FOVring.Color = Color3.fromRGB(0, 255, 255)
FOVring.Filled = false
FOVring.Transparency = 0.7
FOVring.Radius = fov
FOVring.Position = Cam.ViewportSize / 2

-- Center dot
local CenterDot = Drawing.new("Circle")
CenterDot.Visible = false
CenterDot.Thickness = 1
CenterDot.Color = Color3.fromRGB(255, 255, 255)
CenterDot.Filled = true
CenterDot.Transparency = 1
CenterDot.Radius = 2
CenterDot.Position = Cam.ViewportSize / 2

-- Aimbot Logic
local aimbotEnabled = false

local function updateDrawings()
    local center = Cam.ViewportSize / 2
    FOVring.Position = center
    CenterDot.Position = center
end

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

-- Toggle Function with Animation
local function toggleAimbot()
    aimbotEnabled = not aimbotEnabled
    
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    
    if aimbotEnabled then
        -- Animate to ON state
        local tween = TweenService:Create(ToggleButton, tweenInfo, {
            BackgroundColor3 = Color3.fromRGB(50, 255, 50), -- Green when on
            Text = "ON"
        })
        tween:Play()
        
        FOVring.Visible = true
        CenterDot.Visible = true
    else
        -- Animate to OFF state
        local tween = TweenService:Create(ToggleButton, tweenInfo, {
            BackgroundColor3 = Color3.fromRGB(255, 50, 50), -- Red when off
            Text = "OFF"
        })
        tween:Play()
        
        FOVring.Visible = false
        CenterDot.Visible = false
    end
end

-- Button Effects
ToggleButton.MouseEnter:Connect(function()
    local targetColor = aimbotEnabled and Color3.fromRGB(40, 220, 40) or Color3.fromRGB(220, 40, 40)
    TweenService:Create(ToggleButton, TweenInfo.new(0.1), {
        BackgroundColor3 = targetColor
    }):Play()
end)

ToggleButton.MouseLeave:Connect(function()
    local targetColor = aimbotEnabled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
    TweenService:Create(ToggleButton, TweenInfo.new(0.1), {
        BackgroundColor3 = targetColor
    }):Play()
end)

ToggleButton.MouseButton1Click:Connect(toggleAimbot)

-- Close on Delete
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Delete then
        AimbotGUI:Destroy()
        FOVring:Remove()
        CenterDot:Remove()
    end
end)

-- Main Loop
RunService.RenderStepped:Connect(function()
    updateDrawings()
    if aimbotEnabled then
        local closest = getClosestPlayerInFOV("Head")
        if closest and closest.Character:FindFirstChild("Head") then
            lookAt(closest.Character.Head.Position)
        end
    end
end)