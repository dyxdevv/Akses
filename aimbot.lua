--[[
  🔥 AIMBOT MINI v3.0 🔥
  - Super Compact GUI (100x70)
  - ON/OFF Toggle (Red/Green)
  - Small FOV Circle + Center Dot
  - Precise Head Lock
  - Delete to Close
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- GUI Setup
local AimbotGUI = Instance.new("ScreenGui")
AimbotGUI.Name = "MiniAimbot"
AimbotGUI.ResetOnSpawn = false
AimbotGUI.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame (Tiny!)
local MainFrame = Instance.new("Frame")
MainFrame.Parent = AimbotGUI
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BackgroundTransparency = 0.3
MainFrame.Position = UDim2.new(0.85, 0, 0.5, -35)
MainFrame.Size = UDim2.new(0, 100, 0, 70)
MainFrame.Active = true
MainFrame.Draggable = true

-- Rounded Corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 5)
UICorner.Parent = MainFrame

-- Toggle Button
local ToggleButton = Instance.new("TextButton")
ToggleButton.Parent = MainFrame
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50) -- Red when off
ToggleButton.Position = UDim2.new(0.1, 0, 0.2, 0)
ToggleButton.Size = UDim2.new(0.8, 0, 0, 25)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "OFF"
ToggleButton.TextColor3 = Color3.white
ToggleButton.TextSize = 12
ToggleButton.AutoButtonColor = false

-- Button Corner
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 4)

-- Title Label
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = MainFrame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0.1, 0, 0.6, 0)
TitleLabel.Size = UDim2.new(0.8, 0, 0, 15)
TitleLabel.Font = Enum.Font.Gotham
TitleLabel.Text = "LOCK ON"
TitleLabel.TextColor3 = Color3.white
TitleLabel.TextSize = 11

-- FOV Drawing
local Cam = game.Workspace.CurrentCamera
local FOV = 60 -- Small FOV
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.fromRGB(0, 200, 255)
FOVCircle.Transparency = 0.7
FOVCircle.Radius = FOV
FOVCircle.Position = Cam.ViewportSize/2

-- Center Dot
local CenterDot = Drawing.new("Circle")
CenterDot.Visible = false
CenterDot.Filled = true
CenterDot.Radius = 2
CenterDot.Color = Color3.white
CenterDot.Position = Cam.ViewportSize/2

-- Aimbot Logic
local Enabled = false

local function UpdateDrawings()
    FOVCircle.Position = Cam.ViewportSize/2
    CenterDot.Position = Cam.ViewportSize/2
end

local function GetClosestPlayer()
    local closest = nil
    local minDist = math.huge
    local localPlayer = Players.LocalPlayer
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local head = player.Character:FindFirstChild("Head")
            if head then
                local pos, onScreen = Cam:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - FOVCircle.Position).Magnitude
                    if dist < minDist and dist < FOV then
                        minDist = dist
                        closest = player
                    end
                end
            end
        end
    end
    
    return closest
end

-- Toggle Function
local function ToggleAimbot()
    Enabled = not Enabled
    
    if Enabled then
        -- Change to GREEN
        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(50, 255, 50),
            Text = "ON"
        }):Play()
        FOVCircle.Visible = true
        CenterDot.Visible = true
    else
        -- Change to RED
        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(255, 50, 50),
            Text = "OFF"
        }):Play()
        FOVCircle.Visible = false
        CenterDot.Visible = false
    end
end

-- Button Click
ToggleButton.MouseButton1Click:Connect(ToggleAimbot)

-- Delete to Close
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Delete then
        AimbotGUI:Destroy()
        FOVCircle:Remove()
        CenterDot:Remove()
    end
end)

-- Main Loop
RunService.RenderStepped:Connect(function()
    UpdateDrawings()
    
    if Enabled then
        local target = GetClosestPlayer()
        if target and target.Character then
            local head = target.Character:FindFirstChild("Head")
            if head then
                Cam.CFrame = CFrame.new(Cam.CFrame.Position, head.Position)
            end
        end
    end
end)