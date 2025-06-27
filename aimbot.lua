--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
-- Instances:
local AimbotGUI = Instance.new("ScreenGui")
local Background = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local Divider = Instance.new("Frame")
local EnableToggle = Instance.new("TextButton")
local UICorner_2 = Instance.new("UICorner")
local AimbotLabel = Instance.new("TextLabel")
local Credits = Instance.new("TextLabel")

-- Properties:
AimbotGUI.Name = "AimbotGUI"
AimbotGUI.ResetOnSpawn = false
AimbotGUI.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

Background.Name = "Background"
Background.Parent = AimbotGUI
Background.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Background.Position = UDim2.new(0.5, -75, 0.5, -60)
Background.Size = UDim2.new(0, 150, 0, 120) -- Smaller size
Background.Active = true
Background.Draggable = true

UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = Background

Title.Name = "Title"
Title.Parent = Background
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1.000
Title.Position = UDim2.new(0, 0, 0, 5)
Title.Size = UDim2.new(1, 0, 0, 20)
Title.Font = Enum.Font.GothamSemibold
Title.Text = "AIMBOT"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.TextSize = 16.000

Divider.Name = "Divider"
Divider.Parent = Background
Divider.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
Divider.BorderSizePixel = 0
Divider.Position = UDim2.new(0, 0, 0, 25)
Divider.Size = UDim2.new(1, 0, 0, 1)

EnableToggle.Name = "EnableToggle"
EnableToggle.Parent = Background
EnableToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
EnableToggle.Position = UDim2.new(0.5, -50, 0.5, -20)
EnableToggle.Size = UDim2.new(0, 100, 0, 30) -- Smaller button
EnableToggle.Font = Enum.Font.Gotham
EnableToggle.Text = "ENABLE"
EnableToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
EnableToggle.TextSize = 12.000

UICorner_2.CornerRadius = UDim.new(0, 4)
UICorner_2.Parent = EnableToggle

AimbotLabel.Name = "AimbotLabel"
AimbotLabel.Parent = Background
AimbotLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
AimbotLabel.BackgroundTransparency = 1.000
AimbotLabel.Position = UDim2.new(0.5, -50, 0.5, 15)
AimbotLabel.Size = UDim2.new(0, 100, 0, 20)
AimbotLabel.Font = Enum.Font.Gotham
AimbotLabel.Text = "STATUS: OFF"
AimbotLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
AimbotLabel.TextSize = 12.000

Credits.Name = "Credits"
Credits.Parent = Background
Credits.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Credits.BackgroundTransparency = 1.000
Credits.Position = UDim2.new(0, 0, 1, -20)
Credits.Size = UDim2.new(1, 0, 0, 20)
Credits.Font = Enum.Font.Gotham
Credits.Text = "by Bloodscript"
Credits.TextColor3 = Color3.fromRGB(150, 150, 150)
Credits.TextSize = 10.000

-- Drawing FOV circle
local fov = 100
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Cam = game.Workspace.CurrentCamera

local FOVring = Drawing.new("Circle")
FOVring.Visible = false -- Comenzamos con el FOV invisible
FOVring.Thickness = 2
FOVring.Color = Color3.fromRGB(0, 255, 255) -- Cyan color to match theme
FOVring.Filled = false
FOVring.Radius = fov
FOVring.Position = Cam.ViewportSize / 2

local function updateDrawings()
    local camViewportSize = Cam.ViewportSize
    FOVring.Position = camViewportSize / 2
end

local function onKeyDown(input)
    if input.KeyCode == Enum.KeyCode.Delete then
        RunService:UnbindFromRenderStep("FOVUpdate")
        FOVring:Remove()
    end
end

UserInputService.InputBegan:Connect(onKeyDown)

local aimbotEnabled = false -- Variable para controlar el estado del aimbot

local function lookAt(target)
    local lookVector = (target - Cam.CFrame.Position).unit
    local newCFrame = CFrame.new(Cam.CFrame.Position, Cam.CFrame.Position + lookVector)
    Cam.CFrame = newCFrame
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

local function toggleAimbot()
    aimbotEnabled = not aimbotEnabled

    if aimbotEnabled then
        EnableToggle.Text = "DISABLE"
        EnableToggle.BackgroundColor3 = Color3.fromRGB(50, 30, 30)
        AimbotLabel.Text = "STATUS: ON"
        AimbotLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
        FOVring.Visible = true
    else
        EnableToggle.Text = "ENABLE"
        EnableToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        AimbotLabel.Text = "STATUS: OFF"
        AimbotLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        FOVring.Visible = false
    end
end

EnableToggle.MouseButton1Click:Connect(toggleAimbot)

RunService.RenderStepped:Connect(function()
    updateDrawings()
    if aimbotEnabled then
        local closest = getClosestPlayerInFOV("Head")
        if closest and closest.Character:FindFirstChild("Head") then
            lookAt(closest.Character.Head.Position)
        end
    end
end)

-- Función para actualizar el dibujo del campo de visión cada frame
game:GetService("RunService").RenderStepped:Connect(updateDrawings)