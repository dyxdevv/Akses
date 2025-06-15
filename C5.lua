local prefix = {";", ".", "/", "#", ":", "?"}
local speeds = 1
local nowe = false
local tpwalking = false
local speaker = game:GetService("Players").LocalPlayer

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
local function toggleFly()
    if nowe == true then
        nowe = false
        if speaker.Character and speaker.Character:FindFirstChildOfClass("Humanoid") then
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, true)
            speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)
            speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
        end
    else 
        nowe = true
        for i = 1, speeds do
            spawn(function()
                local hb = game:GetService("RunService").Heartbeat
                tpwalking = true
                local chr = speaker.Character
                local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
                while tpwalking and hb:Wait() and chr and hum and hum.Parent do
                    if hum.MoveDirection.Magnitude > 0 then
                        chr:TranslateBy(hum.MoveDirection * (speeds / 10))
                    end
                end
            end)
        end
        
        if speaker.Character then
            if speaker.Character:FindFirstChild("Animate") then
                speaker.Character.Animate.Disabled = true
            end
            
            local Hum = speaker.Character:FindFirstChildOfClass("Humanoid") or speaker.Character:FindFirstChildOfClass("AnimationController")
            if Hum then
                for i,v in next, Hum:GetPlayingAnimationTracks() do
                    v:AdjustSpeed(0)
                end
            end
            
            if speaker.Character:FindFirstChildOfClass("Humanoid") then
                speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
                speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
                speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
                speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
                speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
                speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed, false)
                speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
                speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
                speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, false)
                speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, false)
                speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
                speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, false)
                speaker.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
                speaker.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
            end
        end
    end

    if speaker.Character and speaker.Character:FindFirstChildOfClass("Humanoid") then
        if speaker.Character:FindFirstChildOfClass("Humanoid").RigType == Enum.HumanoidRigType.R6 then
            local torso = speaker.Character:FindFirstChild("Torso")
            if torso then
                local bg = torso:FindFirstChild("BodyGyro") or Instance.new("BodyGyro", torso)
                bg.P = 9e4
                bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
                bg.cframe = torso.CFrame
                
                local bv = torso:FindFirstChild("BodyVelocity") or Instance.new("BodyVelocity", torso)
                bv.velocity = Vector3.new(0,0.1,0)
                bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
                
                if nowe == true then
                    speaker.Character.Humanoid.PlatformStand = true
                else
                    bg:Destroy()
                    bv:Destroy()
                    speaker.Character.Humanoid.PlatformStand = false
                    if speaker.Character:FindFirstChild("Animate") then
                        speaker.Character.Animate.Disabled = false
                    end
                    tpwalking = false
                end
            end
        else
            local upperTorso = speaker.Character:FindFirstChild("UpperTorso")
            if upperTorso then
                local bg = upperTorso:FindFirstChild("BodyGyro") or Instance.new("BodyGyro", upperTorso)
                bg.P = 9e4
                bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
                bg.cframe = upperTorso.CFrame
                
                local bv = upperTorso:FindFirstChild("BodyVelocity") or Instance.new("BodyVelocity", upperTorso)
                bv.velocity = Vector3.new(0,0.1,0)
                bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
                
                if nowe == true then
                    speaker.Character.Humanoid.PlatformStand = true
                else
                    bg:Destroy()
                    bv:Destroy()
                    speaker.Character.Humanoid.PlatformStand = false
                    if speaker.Character:FindFirstChild("Animate") then
                        speaker.Character.Animate.Disabled = false
                    end
                    tpwalking = false
                end
            end
        end
    end
end

-- Character added event
speaker.CharacterAdded:Connect(function(char)
    wait(0.7)
    if char:FindFirstChildOfClass("Humanoid") then
        char.Humanoid.PlatformStand = false
    end
    if char:FindFirstChild("Animate") then
        char.Animate.Disabled = false
    end
    nowe = false
    tpwalking = false
end)

-- Key controls for movement
local ctrl = {f = 0, b = 0, l = 0, r = 0}
local lastctrl = {f = 0, b = 0, l = 0, r = 0}

local function updateFlyVelocity()
    while true do
        if nowe and speaker.Character then
            local rootPart = speaker.Character:FindFirstChild("HumanoidRootPart") or 
                           speaker.Character:FindFirstChild("Torso") or 
                           speaker.Character:FindFirstChild("UpperTorso")
            
            if rootPart then
                local bv = rootPart:FindFirstChild("BodyVelocity")
                if bv then
                    local maxspeed = speeds * 10
                    local speed = 0
                    
                    if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
                        speed = speed + 0.5 + (speed/maxspeed)
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
                                     game.Workspace.CurrentCamera.CoordinateFrame.p) * speed
                        lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
                    elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
                        bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f + lastctrl.b)) + 
                                     ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l + lastctrl.r, (lastctrl.f + lastctrl.b) * 0.2, 0).p) - 
                                     game.Workspace.CurrentCamera.CoordinateFrame.p) * speed
                    else
                        bv.velocity = Vector3.new(0, 0, 0)
                    end
                end
            end
        end
        wait()
    end
end

spawn(updateFlyVelocity)

-- Input handling
local UserInputService = game:GetService("UserInputService")

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

UserInputService.InputBegan:Connect(function(input, processed)
    if not processed then
        handleKey(input, true)
    end
end)

UserInputService.InputEnded:Connect(function(input, processed)
    if not processed then
        handleKey(input, false)
    end
end)

-- Chat command handler
speaker.Chatted:Connect(function(message)
    local isCmd, cmd = isCommand(message)
    if isCmd then
        cmd = cmd:lower():gsub("%s+", "):gsub("^%s+", ""):gsub("%s+$", "")
        
        if cmd == "fly" then
            toggleFly()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Fly System",
                Text = "Fly " .. (nowe and "enabled" or "disabled"),
                Duration = 2
            })
        elseif cmd:sub(1, 9) == "flyspeed " then
            local newSpeed = tonumber(cmd:sub(10))
            if newSpeed and newSpeed >= 1 and newSpeed <= 10000 then
                speeds = newSpeed
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Fly System",
                    Text = "Speed set to " .. speeds,
                    Duration = 2
                })
            else
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Fly System",
                    Text = "Invalid speed (1-10000)",
                    Duration = 2
                })
            end
        elseif cmd == "unfly" then
            if nowe then
                toggleFly()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Fly System",
                    Text = "Fly disabled",
                    Duration = 2
                })
            end
        elseif cmd == "flycmds" or cmd == "flyhelp" then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Fly Commands",
                Text = "fly - Toggle flight\nflyspeed [1-10000] - Set speed\nunfly - Disable flight",
                Duration = 5
            })
        end
    end
end)

-- Initial notification
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Fly System Loaded",
    Text = "Commands: fly, flyspeed [1-10000], unfly\nPrefixes: ; . / # : ?",
    Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150",
    Duration = 5
})