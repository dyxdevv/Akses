local gui = Instance.new("ScreenGui")
local main = Instance.new("Frame")
local label = Instance.new("TextLabel")
local description = Instance.new("TextLabel")
local button = Instance.new("TextButton")
local UICorner_main = Instance.new("UICorner")
local UICorner_button = Instance.new("UICorner")
local UICorner_label = Instance.new("UICorner")
local UICorner_desc = Instance.new("UICorner")
local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
local UITextSizeConstraint_2 = Instance.new("UITextSizeConstraint")
local UITextSizeConstraint_3 = Instance.new("UITextSizeConstraint")

gui.Name = "ZeroGravityGUI"
gui.Parent = gethui()
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

main.Name = "main"
main.Parent = gui
main.BackgroundColor3 = Color3.fromRGB(10, 30, 50) -- Deep ocean blue
main.BorderColor3 = Color3.fromRGB(0, 80, 120) -- Ocean surface blue
main.BorderSizePixel = 0
main.Position = UDim2.new(0.196095973, 0, 0.556803584, 0)
main.Size = UDim2.new(0.178187668, 0, 0.19960205, 0)
main.Active = true
main.Draggable = true

UICorner_main.CornerRadius = UDim.new(0.05, 0)
UICorner_main.Parent = main

label.Name = "label"
label.Parent = main
label.BackgroundColor3 = Color3.fromRGB(0, 150, 255) -- Bright ocean blue
label.BorderColor3 = Color3.fromRGB(0, 0, 0)
label.BorderSizePixel = 0
label.Size = UDim2.new(1, 0, 0.25, 0)
label.Font = Enum.Font.GothamBold
label.Text = "ZenoVA | Zero Gravity"
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextScaled = true
label.TextSize = 29.000
label.TextWrapped = true

UICorner_label.CornerRadius = UDim.new(0.2, 0)
UICorner_label.Parent = label

UITextSizeConstraint.Parent = label
UITextSizeConstraint.MaxTextSize = 29

description.Name = "description"
description.Parent = main
description.BackgroundColor3 = Color3.fromRGB(20, 50, 70) -- Medium ocean blue
description.BorderColor3 = Color3.fromRGB(0, 0, 0)
description.BorderSizePixel = 0
description.Position = UDim2.new(0, 0, 0.25, 0)
description.Size = UDim2.new(1, 0, 0.2, 0)
description.Font = Enum.Font.Gotham
description.Text = "Created By ZenoVa / Zenoid Scripts"
description.TextColor3 = Color3.fromRGB(255, 255, 255)
description.TextScaled = true
description.TextSize = 16.000
description.TextWrapped = true

UICorner_desc.CornerRadius = UDim.new(0.2, 0)
UICorner_desc.Parent = description

UITextSizeConstraint_3.Parent = description
UITextSizeConstraint_3.MaxTextSize = 16

button.Name = "button"
button.Parent = main
button.BackgroundColor3 = Color3.fromRGB(0, 180, 220) -- Turquoise button
button.BorderColor3 = Color3.fromRGB(0, 0, 0)
button.BorderSizePixel = 0
button.Position = UDim2.new(0.075, 0, 0.55, 0)
button.Size = UDim2.new(0.85, 0, 0.35, 0)
button.Font = Enum.Font.GothamBold
button.Text = "Toggle Zero Gravity"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextSize = 24.000
button.TextScaled = true
button.TextWrapped = true

UICorner_button.CornerRadius = UDim.new(0.2, 0) -- Rounded button
UICorner_button.Parent = button

UITextSizeConstraint_2.Parent = button
UITextSizeConstraint_2.MaxTextSize = 24

-- Scripts:

local plr = game:GetService("Players").LocalPlayer
local normalGravity = workspace.Gravity
local zeroGravityEnabled = false

local function ZenoVa_fake_script() -- button.script 
 local script = Instance.new('LocalScript', button)
 
 -- Create a smooth transition effect
 local function updateButtonColor(isEnabled)
  if isEnabled then
   script.Parent.BackgroundColor3 = Color3.fromRGB(255, 140, 0) -- Darker orange when activated
   script.Parent.Text = "Gravity: OFF"
  else
   script.Parent.BackgroundColor3 = Color3.fromRGB(255, 215, 0) -- Yellow when deactivated
   script.Parent.Text = "Gravity: ON"
  end
 end

 script.Parent.MouseButton1Click:Connect(function()
  zeroGravityEnabled = not zeroGravityEnabled
  
  if zeroGravityEnabled then
   workspace.Gravity = 0
   
   local humanoid = plr.Character:FindFirstChildWhichIsA("Humanoid")
   if humanoid then
    humanoid.Sit = true
    task.wait(0.1)
    humanoid.RootPart.CFrame = humanoid.RootPart.CFrame * CFrame.Angles(math.pi * 0.5, 0, 0)
    for _, v in ipairs(humanoid:GetPlayingAnimationTracks()) do
     v:Stop()
    end
   end
  else
   workspace.Gravity = normalGravity
  end
  
  updateButtonColor(zeroGravityEnabled)
 end)
 
 game:GetService("UserInputService").JumpRequest:Connect(function()
  if zeroGravityEnabled then
   workspace.Gravity = normalGravity
   zeroGravityEnabled = false
   updateButtonColor(zeroGravityEnabled)
  end
 end)
 
 -- Initialize button text
 updateButtonColor(zeroGravityEnabled)
end
coroutine.wrap(ZenoVa_fake_script)()