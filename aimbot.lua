--[[
    Enhanced Aimbot GUI v2
    Features:
    - Fixed toggle functionality
    - Proper FOV circle control
    - Smooth animations
    - Visual status feedback
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Local player
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Camera
local Cam = workspace.CurrentCamera

-- GUI Setup
local AimbotGUI = Instance.new("ScreenGui")
AimbotGUI.Name = "AimbotGUI"
AimbotGUI.ResetOnSpawn = false
AimbotGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
AimbotGUI.Parent = PlayerGui

-- Main Container
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BackgroundTransparency = 0.2
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -60)
MainFrame.Size = UDim2.new(0, 200, 0, 120)
MainFrame.Active = true
MainFrame.Draggable = true

-- Corner rounding
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = MainFrame

-- Drop shadow
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(60, 60, 60)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 6)
TitleCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = TitleBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Font = Enum.Font.GothamSemibold
Title.Text = "Aimbot Control"
Title.TextColor3 = Color3.fromRGB(220, 220, 220)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Toggle Button
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = MainFrame
ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60) -- Red when off
ToggleButton.Position = UDim2.new(0.5, -75, 0.5, -20)
ToggleButton.Size = UDim2.new(0, 150, 0, 40)
ToggleButton.Font = Enum.Font.GothamSemibold
ToggleButton.Text = "Enable Aimbot"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 14
ToggleButton.AutoButtonColor = false

-- Button corner rounding
local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 4)
ButtonCorner.Parent = ToggleButton

-- Status Indicator
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 10, 1, -25)
StatusLabel.Size = UDim2.new(1, -20, 0, 20)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Text = "Status: OFF"
StatusLabel.TextColor3 = Color3.fromRGB(200, 60, 60) -- Red when off
StatusLabel.TextSize = 12
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Credits
local CreditsLabel = Instance.new("TextLabel")
CreditsLabel.Name = "CreditsLabel"
CreditsLabel.Parent = MainFrame
CreditsLabel.BackgroundTransparency = 1
CreditsLabel.Position = UDim2.new(0, 10, 1, -25)
CreditsLabel.Size = UDim2.new(1, -20, 0, 20)
CreditsLabel.Font = Enum.Font.Gotham
CreditsLabel.Text = "by Bloodscript"
CreditsLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
CreditsLabel.TextSize = 12
CreditsLabel.TextXAlignment = Enum.TextXAlignment.Right

-- FOV Settings
local FOV = 100
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.fromRGB(0, 150, 255)
FOVCircle.Transparency = 0.7
FOVCircle.Filled = false
FOVCircle.Radius = FOV
FOVCircle.Position = Cam.ViewportSize / 2

-- Center Dot
local CenterDot = Drawing.new("Circle")
CenterDot.Visible = false
CenterDot.Thickness = 1
CenterDot.Color = Color3.fromRGB(255, 255, 255)
CenterDot.Filled = true
CenterDot.Radius = 2
CenterDot.Position = Cam.ViewportSize / 2

-- Aimbot State
local AimbotEnabled = false
local TargetPart = "Head"

-- Animation function
local function AnimateButton(newState)
    local tweenInfo = TweenInfo.new(
        0.2,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )
    
    if newState then
        -- Turn ON animations
        local colorTween = TweenService:Create(ToggleButton, tweenInfo, {
            BackgroundColor3 = Color3.fromRGB(60, 200, 60)
        })
        local textTween = TweenService:Create(ToggleButton, tweenInfo, {
            Text = "Disable Aimbot"
        })
        
        colorTween:Play()
        textTween:Play()
        
        StatusLabel.Text = "Status: ON"
        StatusLabel.TextColor3 = Color3.fromRGB(60, 200, 60)
        FOVCircle.Visible = true
        CenterDot.Visible = true
    else
        -- Turn OFF animations
        local colorTween = TweenService:Create(ToggleButton, tweenInfo, {
            BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        })
        local textTween = TweenService:Create(ToggleButton, tweenInfo, {
            Text = "Enable Aimbot"
        })
        
        colorTween:Play()
        textTween:Play()
        
        StatusLabel.Text = "Status: OFF"
        StatusLabel.TextColor3 = Color3.fromRGB(200, 60, 60)
        FOVCircle.Visible = false
        CenterDot.Visible = false
    end
end

-- Toggle function
local function ToggleAimbot()
    AimbotEnabled = not AimbotEnabled
    AnimateButton(AimbotEnabled)
end

-- Button click event
ToggleButton.MouseButton1Click:Connect(ToggleAimbot)

-- FOV Update function
local function UpdateFOV()
    FOVCircle.Position = Cam.ViewportSize / 2
    CenterDot.Position = Cam.ViewportSize / 2
end

-- Target finding function
local function GetClosestPlayer()
    if not AimbotEnabled then return nil end
    
    local closestPlayer = nil
    local shortestDistance = math.huge
    local localPlayer = Players.LocalPlayer
    local mousePos = Cam.ViewportSize / 2
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local character = player.Character
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            
            if humanoid and humanoid.Health > 0 then
                local part = character:FindFirstChild(TargetPart)
                if part then
                    local screenPos, onScreen = Cam:WorldToViewportPoint(part.Position)
                    if onScreen then
                        local pos = Vector2.new(screenPos.X, screenPos.Y)
                        local distance = (pos - mousePos).Magnitude
                        
                        if distance < shortestDistance and distance <= FOV then
                            shortestDistance = distance
                            closestPlayer = player
                        end
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

-- Main loop
RunService.RenderStepped:Connect(function()
    UpdateFOV()
    
    if AimbotEnabled then
        local targetPlayer = GetClosestPlayer()
        if targetPlayer and targetPlayer.Character then
            local targetPart = targetPlayer.Character:FindFirstChild(TargetPart)
            if targetPart then
                -- Smooth aiming
                local currentCF = Cam.CFrame
                local targetPos = targetPart.Position
                local newCF = CFrame.new(currentCF.Position, targetPos)
                Cam.CFrame = newCF:Lerp(currentCF, 0.7)
            end
        end
    end
end)

-- Keybinds
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.Delete then
            AimbotGUI:Destroy()
            FOVCircle:Remove()
            CenterDot:Remove()
        end
    end
end)

-- Initial setup
MainFrame.Parent = AimbotGUI