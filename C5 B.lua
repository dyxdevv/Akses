local prefix = {";", ".", "/", "#", ":", "?"}
local speeds = 1
local nowe = false
local tpwalking = false
local speaker = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Function to check if message starts with any prefix
local function isCommand(message)
    for _, p in ipairs(prefix) do
        if message:sub(1, #p) == p then
            return true, message:sub(#p + 1)
        end
    end
    return false, message
end

-- Table to track controls state
local ctrl = {f = 0, b = 0, l = 0, r = 0}

-- Update control states on input began
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    local key = input.KeyCode
    if key == Enum.KeyCode.W then ctrl.f = 1
    elseif key == Enum.KeyCode.S then ctrl.b = -1
    elseif key == Enum.KeyCode.A then ctrl.l = -1
    elseif key == Enum.KeyCode.D then ctrl.r = 1
    end
end)

-- Update control states on input ended
UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    local key = input.KeyCode
    if key == Enum.KeyCode.W then ctrl.f = 0
    elseif key == Enum.KeyCode.S then ctrl.b = 0
    elseif key == Enum.KeyCode.A then ctrl.l = 0
    elseif key == Enum.KeyCode.D then ctrl.r = 0
    end
end)

-- Fly function
local function toggleFly()
    if nowe == true then
        nowe = false
        tpwalking = false
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
        game.Players.LocalPlayer.Character.Animate.Disabled = false
    else 
        nowe = true
        tpwalking = true
        game.Players.LocalPlayer.Character.Animate.Disabled = true
        local Char = game.Players.LocalPlayer.Character
        local Hum = Char:FindFirstChildOfClass("Humanoid") or Char:FindFirstChildOfClass("AnimationController")
        for _, v in next, Hum:GetPlayingAnimationTracks() do
            v:AdjustSpeed(0)
        end
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
        
        -- Movement control variables
        local lastctrl = {f = 0, b = 0, l = 0, r = 0}
        local maxspeed = speeds * 10
        local speed = 0
        
        -- Setup BodyGyro and BodyVelocity
        local plr = game.Players.LocalPlayer
        local rigType = plr.Character.Humanoid.RigType
        local rootPart = nil
        if rigType == Enum.HumanoidRigType.R6 then
            rootPart = plr.Character:FindFirstChild("Torso") or plr.Character:FindFirstChild("UpperTorso") or plr.Character.PrimaryPart
        else
            rootPart = plr.Character:FindFirstChild("UpperTorso") or plr.Character.PrimaryPart
        end
        
        if not rootPart then
            -- Safety return if no root part found
            nowe = false
            tpwalking = false
            game.Players.LocalPlayer.Character.Animate.Disabled = false
            return
        end
        
        local bg = Instance.new("BodyGyro", rootPart)
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = rootPart.CFrame
        local bv = Instance.new("BodyVelocity", rootPart)
        bv.velocity = Vector3.new(0,0.1,0)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        
        if nowe == true then
            plr.Character.Humanoid.PlatformStand = true
        end
        
        -- Main flying loop, runs every RenderStepped frame for smoothness
        while nowe == true and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 and rootPart.Parent do
            RunService.RenderStepped:Wait()
            
            -- Update speed with smoothing
            if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
                speed = speed + 0.5 + (speed / maxspeed)
                if speed > maxspeed then speed = maxspeed end
            else
                speed = speed - 1
                if speed < 0 then speed = 0 end
            end
            
            -- Calculate movement direction based on inputs and camera lookVector
            local cam = workspace.CurrentCamera
            local moveDirection = Vector3.new(ctrl.l + ctrl.r, 0, ctrl.f + ctrl.b)
            local cameraLook = cam.CFrame.LookVector
            local cameraRight = cam.CFrame.RightVector
            
            -- Movement vector relative to camera orientation
            local moveVector = (cameraLook * moveDirection.Z + cameraRight * moveDirection.X).Unit
            if moveDirection.Magnitude == 0 then
                -- When no movement keys pressed keep velocity at zero or last known direction with decelerated speed
                bv.velocity = Vector3.new(0, 0, 0)
            else
                bv.velocity = moveVector * speed
            end
            
            -- Update BodyGyro cfame to fully match camera orientation (including pitch and roll)
            bg.cframe = cam.CFrame
            
            -- Store last control values
            lastctrl.f = ctrl.f
            lastctrl.b = ctrl.b
            lastctrl.l = ctrl.l
            lastctrl.r = ctrl.r
        end
        
        -- Cleanup after flying ends
        bg:Destroy()
        bv:Destroy()
        plr.Character.Humanoid.PlatformStand = false
        game.Players.LocalPlayer.Character.Animate.Disabled = false
        tpwalking = false
        nowe = false
    end
end

-- Character added event
game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(char)
    wait(0.7)
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
        game.Players.LocalPlayer.Character.Animate.Disabled = false
    end
    nowe = false
    tpwalking = false
end)

-- Improved chat handler with fixed flyspeed command, immediate detection
game:GetService("Players").LocalPlayer.Chatted:Connect(function(message)
    -- Fast command detect with no blocking
    local isCmd, cmd = isCommand(message)
    if isCmd then
        -- Parse command parts immediately
        local parts = {}
        for part in cmd:gmatch("%S+") do
            table.insert(parts, part:lower())
        end
        if #parts == 0 then return end
        
        if parts[1] == "fly" then
            toggleFly()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Fly System",
                Text = "Fly " .. (nowe and "enabled" or "disabled"),
                Duration = 2
            })
        elseif parts[1] == "unfly" then
            if nowe then
                toggleFly()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Fly System",
                    Text = "Fly disabled",
                    Duration = 2
                })
            end
        elseif parts[1] == "flyspeed" and #parts >= 2 then
            local newSpeed = tonumber(parts[2])
            if newSpeed and newSpeed >= 1 and newSpeed <= 10000 then
                speeds = newSpeed
                if nowe and not tpwalking then
                    -- spawn the tpwalking thread once if not already running
                    tpwalking = true
                    spawn(function()
                        local hb = game:GetService("RunService").Heartbeat
                        local chr = game.Players.LocalPlayer.Character
                        local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
                        while tpwalking and hb:Wait() and chr and hum and hum.Parent do
                            if hum.MoveDirection.Magnitude > 0 then
                                chr:TranslateBy(hum.MoveDirection * (speeds / 10))
                            end
                        end
                    end)
                end
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
        elseif parts[1] == "flycmds" or parts[1] == "flyhelp" then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Fly Commands",
                Text = "fly - Toggle flight\nflyspeed [1-10000] - Set speed\nunfly - Disable flight",
                Duration = 5
            })
        end
    end
end)

-- Initial notification with commands
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Fly System Loaded",
    Text = "Commands: fly, flyspeed [1-10000], unfly\nPrefixes: ; . / # : ?",
    Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150",
    Duration = 5
})
