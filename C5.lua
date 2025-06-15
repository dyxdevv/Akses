local speaker = game:GetService("Players").LocalPlayer
local speeds = 1
local nowe = false
local tpwalking = false
local prefix = {"/", ";", ".", "\\", "!", "?"} -- Allowed prefixes

-- Notification with command list
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "FLY SYSTEM V2",
    Text = "BY ZenoID / DyX\n\nCommands:\n/fly - Toggle fly\n/flyspeed [number] - Set fly speed\n/unfly - Disable fly",
    Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150",
    Duration = 10,
    Button1 = "OK"
})

-- Function to check if message starts with any prefix
local function isCommand(message)
    for _, p in ipairs(prefix) do
        if message:sub(1, #p) == p then
            return true, message:sub(#p + 1)
        end
    end
    return false, message
end

-- Fly function
local function enableFly()
    if nowe then return end
    
    nowe = true
    local chr = speaker.Character
    if not chr then return end
    
    local hum = chr:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    
    -- Disable animations and states
    hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.Landed, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.Running, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
    hum:ChangeState(Enum.HumanoidStateType.Swimming)
    
    if chr:FindFirstChild("Animate") then
        chr.Animate.Disabled = true
    end
    
    -- Set up movement
    for i = 1, speeds do
        spawn(function()
            local hb = game:GetService("RunService").Heartbeat
            tpwalking = true
            while tpwalking and hb:Wait() and chr and hum and hum.Parent do
                if hum.MoveDirection.Magnitude > 0 then
                    chr:TranslateBy(hum.MoveDirection)
                end
            end
        end)
    end
    
    -- Set up physics for flying
    local rootPart = chr:FindFirstChild("HumanoidRootPart") or chr:FindFirstChild("Torso") or chr:FindFirstChild("UpperTorso")
    if not rootPart then return end
    
    local bg = Instance.new("BodyGyro", rootPart)
    bg.P = 9e4
    bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.cframe = rootPart.CFrame
    
    local bv = Instance.new("BodyVelocity", rootPart)
    bv.velocity = Vector3.new(0, 0.1, 0)
    bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
    
    hum.PlatformStand = true
    
    local ctrl = {f = 0, b = 0, l = 0, r = 0}
    local lastctrl = {f = 0, b = 0, l = 0, r = 0}
    local maxspeed = 50
    local speed = 0
    
    game:GetService("RunService").RenderStepped:Connect(function()
        if not nowe or not chr or not hum or hum.Health <= 0 then return end
        
        if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
            speed = speed + 0.5 + (speed / maxspeed)
            if speed > maxspeed then
                speed = maxspeed
            end
        elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
            speed = speed - 1
            if speed < 0 then
                speed = 0
            end
        end
        
        if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
            bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f + ctrl.b)) + 
                          ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l + ctrl.r, (ctrl.f + ctrl.b) * 0.2, 0).p) - 
                          game.Workspace.CurrentCamera.CoordinateFrame.p)) * speed
            lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
        elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
            bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f + lastctrl.b)) + 
                          ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l + lastctrl.r, (lastctrl.f + lastctrl.b) * 0.2, 0).p) - 
                          game.Workspace.CurrentCamera.CoordinateFrame.p)) * speed
        else
            bv.velocity = Vector3.new(0, 0, 0)
        end
        
        bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f + ctrl.b) * 50 * speed / maxspeed), 0, 0)
    end)
    
    -- Key handling for movement
    local function handleKey(input, isDown)
        if input.KeyCode == Enum.KeyCode.W then
            ctrl.f = isDown and 1 or 0
        elseif input.KeyCode == Enum.KeyCode.S then
            ctrl.b = isDown and 1 or 0
        elseif input.KeyCode == Enum.KeyCode.A then
            ctrl.l = isDown and 1 or 0
        elseif input.KeyCode == Enum.KeyCode.D then
            ctrl.r = isDown and 1 or 0
        end
    end
    
    game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
        if not processed then
            handleKey(input, true)
        end
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input, processed)
        if not processed then
            handleKey(input, false)
        end
    end)
end

-- Disable fly function
local function disableFly()
    if not nowe then return end
    
    nowe = false
    tpwalking = false
    
    local chr = speaker.Character
    if not chr then return end
    
    local hum = chr:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    
    -- Re-enable all states
    for _, state in pairs(Enum.HumanoidStateType:GetEnumItems()) do
        hum:SetStateEnabled(state, true)
    end
    
    hum.PlatformStand = false
    
    if chr:FindFirstChild("Animate") then
        chr.Animate.Disabled = false
    end
    
    -- Remove physics objects
    local rootPart = chr:FindFirstChild("HumanoidRootPart") or chr:FindFirstChild("Torso") or chr:FindFirstChild("UpperTorso")
    if rootPart then
        for _, obj in ipairs(rootPart:GetChildren()) do
            if obj:IsA("BodyGyro") or obj:IsA("BodyVelocity") then
                obj:Destroy()
            end
        end
    end
    
    hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
end

-- Handle character added/respawn
speaker.CharacterAdded:Connect(function(char)
    wait(0.7)
    if char:FindFirstChildOfClass("Humanoid") then
        char:FindFirstChildOfClass("Humanoid").PlatformStand = false
    end
    if char:FindFirstChild("Animate") then
        char.Animate.Disabled = false
    end
    nowe = false
    tpwalking = false
end)

-- Chat command handler
game:GetService("Players").LocalPlayer.Chatted:Connect(function(message)
    local isCmd, cmd = isCommand(message)
    if not isCmd then return end
    
    cmd = cmd:lower():gsub("%s+", "):gsub("^%s+", ""):gsub("%s+$", "")
    
    if cmd == "fly" then
        if nowe then
            disableFly()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Fly System",
                Text = "Fly disabled",
                Duration = 2
            })
        else
            enableFly()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Fly System",
                Text = "Fly enabled (Speed: "..speeds..")",
                Duration = 2
            })
        end
    elseif cmd:sub(1, 9) == "flyspeed " then
        local newSpeed = tonumber(cmd:sub(10))
        if newSpeed and newSpeed >= 1 then
            speeds = newSpeed
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Fly System",
                Text = "Fly speed set to "..speeds,
                Duration = 2
            })
            
            if nowe then
                disableFly()
                enableFly()
            end
        else
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Fly System",
                Text = "Invalid speed. Must be number ≥ 1",
                Duration = 2
            })
        end
    elseif cmd == "unfly" then
        disableFly()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Fly System",
            Text = "Fly disabled",
            Duration = 2
        })
    end
end)